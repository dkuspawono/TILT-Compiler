(*$import PPRTL Sparc MACHINEUTILS TRACETABLE BBLOCK TOASM Util *)

(* Translation from Rtl to Sparc pseudoregister-assembly. 
   Assumptions:
     (1) The thread pointer points to a structure where the first 32 longs
           store the saved general purpose registers.  In particular, when
	   making C calls, the allocation pointer and allocation limit are 
	   saved at offset given by the 8 times the register's number.

*)
         
functor Tosparc(structure Machineutils : MACHINEUTILS 
	        structure ArgTracetable : TRACETABLE 
                structure Bblock : BBLOCK
		    where type Machine.specific_instruction = Sparc.specific_instruction
		    where type Machine.instruction = Sparc.Machine.instruction
		sharing ArgTracetable = Bblock.Tracetable)
  :> TOASM where Machine = Sparc.Machine
	   where Bblock = Bblock
	   where Tracetable = ArgTracetable
= 
struct

   structure Bblock = Bblock
   structure Sparc = Sparc
   structure Machineutils = Machineutils
   structure Tracetable = ArgTracetable
   structure W = TilWord32
   val i2w = W.fromInt
   val w2i = W.toInt
       
   open Machineutils Bblock
   open Sparc
   open Machine
   open Core

   fun error s = Util.error "tosparc.sml" s

   (* Translate the two RTL register types into the single
      SPARC register type.  *)

   val tracemap = ref (Regmap.empty) : (register option * Tracetable.trace) Regmap.map ref

   local
     (* stack slot position of next variable to be made stack-resident *)

     val count = ref 0
     val stack_res = ref (Regmap.empty) : stacklocation Regmap.map ref

   in
     fun init_stack_res () = (count := 0; stack_res := Regmap.empty)
     fun get_stack_res () = !stack_res
     fun add_stack x =
	 (case Regmap.find(!stack_res,x)
	  of SOME i => i
	   | NONE => 
		 let val a = !count
		 in stack_res := Regmap.insert(!stack_res,x,SPILLED_INT(!count));
		    count := !count + 1;
		    SPILLED_INT a
		 end)
   end



   fun translateRep rep =
       case rep of
	  Rtl.TRACE => (NONE, Tracetable.TRACE_YES)
        | Rtl.LOCATIVE => (NONE, Tracetable.TRACE_IMPOSSIBLE)
        | Rtl.COMPUTE path =>
	      (case path of
	         Rtl.Projvar_p (Rtl.REGI(v,_),[]) => 
		     ((case (Regmap.find(!tracemap,R (Name.var2int v))) of
			   NONE => NONE
			 | SOME (ropt,_) => ropt),
			   Tracetable.TRACE_STACK(add_stack (R (Name.var2int v))))
	       | Rtl.Projvar_p (Rtl.REGI(v,_),i) => 
		     ((case (Regmap.find(!tracemap,R (Name.var2int v))) of
			   NONE => NONE
			 | SOME (ropt,_) => ropt),
		       Tracetable.TRACE_STACK_REC(add_stack(R (Name.var2int v)),i))
	       | Rtl.Projvar_p (Rtl.SREGI _, i) => error "SREG should not contain type"
	       | Rtl.Projlabel_p (l,[]) => (NONE,Tracetable.TRACE_GLOBAL l)
	       | Rtl.Projlabel_p (l,i) => (NONE,Tracetable.TRACE_GLOBAL_REC (l,i))
	       | Rtl.Notneeded_p => (NONE,Tracetable.TRACE_IMPOSSIBLE))
	| Rtl.UNSET => (NONE,Tracetable.TRACE_UNSET)
	| Rtl.NOTRACE_INT => (NONE,Tracetable.TRACE_NO)
	| Rtl.NOTRACE_REAL => (NONE,Tracetable.TRACE_NO)
	| Rtl.NOTRACE_CODE => (NONE,Tracetable.TRACE_NO)
	| Rtl.NOTRACE_LABEL => (NONE,Tracetable.TRACE_NO)

   fun internal_translateRep v Rtl.UNSET = (add_stack (R (Name.var2int v)); 
					    translateRep Rtl.UNSET)
     | internal_translateRep _ rep = translateRep rep	

   fun translateSReg Rtl.HEAPPTR = Rheap
     | translateSReg Rtl.HEAPLIMIT = Rhlimit
     | translateSReg Rtl.STACKPTR = Rsp
     | translateSReg Rtl.THREADPTR = Rth
     | translateSReg Rtl.EXNPTR = Rexnptr
     | translateSReg Rtl.EXNARG = Rexnarg
     
   fun translateIReg (Rtl.REGI (v, rep)) = 	
       (tracemap := Regmap.insert(!tracemap,R (Name.var2int v),internal_translateRep v rep);
	R (Name.var2int v))
     | translateIReg (Rtl.SREGI s) = translateSReg s
     
   fun translateFReg (Rtl.REGF (v, _)) = F (Name.var2int v)

   fun translateReg (Rtl.I ir) = translateIReg ir
     | translateReg (Rtl.F fr) = translateFReg fr

   (* Translate an RTL register option into a DECALPHA register option *)
   fun translateIRegOpt NONE = NONE
     | translateIRegOpt (SOME Reg) = SOME (translateIReg Reg)

   (* Translate the register-or-immediate value found as the second 
      source operand in many alpha instructions *)
   fun translateOp (Rtl.REG rtl_reg) = 
         REGop (translateIReg rtl_reg)
     | translateOp (Rtl.IMM src2) =
	 if (in_imm_range src2) then 
	   IMMop src2
	 else
	   error ("immediate out of range: " ^ (Int.toString src2))





   (*****************************************
    * MAIN TRANSLATION STARTS HERE ROUTINES *
    *****************************************)

   (* Translation data structures. *)

   (* All the basic blocks genenerated are stored in this
      label-to-basic-block mapping *)
   val block_map = ref (Labelmap.empty) : bblock Labelmap.map ref

   (* As the translator steps through a basic block, the current_...
      values are updated; at the end of the basic block they're
      packaged up into a BBLOCK and stored in the block_map. *)

   (* Name of the procedure being allocated *)
   val current_proc   = ref (freshCodeLabel ()) : label ref

   (* The current procedure's formal return variables; accessible
      here so that we can add them to DecAlpha's RETURN assembly op *)
   val current_res    = ref []              : register list ref

   (* Name/Label of the block currently being allocated *)
   val current_label  = ref (freshCodeLabel ()) : label ref

   (* List of instructions in this basic block.
      !!!instrs are kept in REVERSE order in this list!!! *)
   val current_instrs = ref [] : instruction annotated list ref

   (* Blocks to which control may flow following this block *)
   val current_succs  = ref []              : label list ref

   (* True iff this block's label is ever referenced.  If not,
      we don't have to print this label in the final assembly code *)
   val current_truelabel = ref false        : bool ref

   (* list of all the labels of blocks in the procedure,
      in reverse order from the order in which the blocks appeared
      in the RTL code.  That is, as blocks are translated their
      label is prepended to this list.  Note that the hd of this list
      is the label of the last block saved in the block_map. *)
   val current_blocklabels = ref [] : label list ref

   (* Flag:  True if the last block stored ended with a unconditional
             branch, or otherwise control does not flow through to the
	     current block. *)
   val no_fallthrough = ref true

   (* Translation functions *)

   (* Find a block by it's name in the block_map *)
   fun getBlock block_label = 
       (case (Labelmap.find(! block_map, block_label)) of
	    SOME bl => bl | NONE => error "getBlock")

   (* Remove all occurrences of a given label from a list *)
   fun removeAllLabel [] _ = []
     | removeAllLabel (lab :: rest) lab' = 
       if (eqLabs lab lab') then
	 removeAllLabel rest lab'
       else
	 lab :: (removeAllLabel rest lab')

   (* Package up the current_??? values into a basic block,
      and store it in the block_map if the label must occur
      in the output program or the list of instructions is nonempty. *)
   fun saveBlock () =
     if (! current_truelabel orelse 
	 length (! current_instrs) > 0) then
       (block_map := Labelmap.insert (! block_map, ! current_label,
				      BLOCK{instrs  = ref (! current_instrs),
					    def     = Regset.empty,
					    use     = Regset.empty,
					    in_live  = ref (Regset.empty),
					    out_live = ref (Regset.empty),
					    truelabel= ! current_truelabel,
					    succs  = ref (! current_succs)});
       current_blocklabels := (! current_label) :: (! current_blocklabels))
     else
       (* We have a useless, empty basic block here.  Delete all
          references to this block as the successor of somebody. *)
       Labelmap.app 
          (fn (BLOCK{succs,...}) => 
	   succs := (removeAllLabel (! succs) (! current_label)))
	  (! block_map)
	

   (* Reset the current_??? values.  If a add_to_predecessor is
      true, and we weren't told the previous block does not
      fall through, then the last block stored in the block_map
      will have the newly reset block added as a successor. *)
   fun resetBlock new_label truelabel add_to_predecessor =
     (current_label  := new_label;
      current_instrs := [];
      current_succs  := [];
      current_truelabel := truelabel;

      if add_to_predecessor andalso (not (! no_fallthrough)) then
	let val (BLOCK{succs,...}) = getBlock (hd (! current_blocklabels))
	in 
	  succs := new_label :: (! succs) 
	end
      else
	();
	
      no_fallthrough := false)

   (* Adds an instruction to the current basic block, updating the other
      relevant current_??? values.  If this is a control-flow instruction,
      saves the current basic block and sets up a new, empty block. *)
   fun emit (instr : instruction) =
       (current_instrs := (NO_ANN instr) :: (! current_instrs);

	case (Sparc.Machine.cFlow instr) of 
	  NONE => ()
	| SOME (fallthrough, succ_labels) =>
	    let 
	      val nextlabel = freshCodeLabel ()
	    in
	      current_succs := succ_labels @ (! current_succs);
	      if fallthrough then 
		 current_succs := nextlabel :: (! current_succs)
	      else
		 ();
	      saveBlock ();
	      resetBlock nextlabel false false;
	      no_fallthrough := not fallthrough
	    end)


   (* Translate an RTL instruction into one or more Alpha instructions *)
   fun load_imm (immed, Rdest) =
          let  
            val lowmask = 0w8191  (* 13 bit mask *)
	    val low     = w2i(W.andb(immed, lowmask))
	    val high    = w2i(W.rshifta(immed, 13))
	  in
	      if (high = 0 orelse high = ~1)
		 then emit(SPECIFIC(INTOP(OR,Rzero,IMMop (w2i immed),Rdest)))
	      else (emit(SPECIFIC(SETHI(high,Rdest)));
		    if (low = 0)
			 then ()
	 	     else (emit(SPECIFIC(INTOP(OR,Rdest,IMMop low, Rdest)))))
	  end

   fun translate_icmp Rtl.EQ = BE
     | translate_icmp Rtl.NE = BNE
     | translate_icmp Rtl.GT = BG
     | translate_icmp Rtl.GE = BGE
     | translate_icmp Rtl.LT = BL
     | translate_icmp Rtl.LE = BLE


   fun translate_fcmp Rtl.EQ = FBE
     | translate_fcmp Rtl.NE = FBNE
     | translate_fcmp Rtl.GT = FBG
     | translate_fcmp Rtl.GE = FBGE
     | translate_fcmp Rtl.LT = FBL
     | translate_fcmp Rtl.LE = FBLE

   fun translate (Rtl.LI (immed, rtl_Rdest)) = load_imm(immed,translateIReg rtl_Rdest)
     | translate (Rtl.LADDR (label, offset, rtl_Rdest)) =
          let
	    val Rdest = translateIReg rtl_Rdest
	  in
	    emit (BASE(LADDR (Rdest, label)));
	    if (offset <> 0) then 
	      emit (SPECIFIC(INTOP (ADD, Rdest, IMMop offset, Rdest)))
	    else 
	      ()
	  end

     | translate (Rtl.LEA (Rtl.EA (rtl_Raddr, offset), rtl_Rdest)) =
          emit (SPECIFIC(INTOP (ADD, translateIReg rtl_Rdest, IMMop offset, 
		       translateIReg rtl_Raddr)))

     | translate (Rtl.MV (rtl_Rsrc, rtl_Rdest)) =
          emit (BASE(MOVI (translateIReg rtl_Rsrc, translateIReg rtl_Rdest)))

     | translate (Rtl.CMV (cmp, rtl_Rsrc1, op2, rtl_Rdest)) =
       let 
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val Rop2 = translateOp op2
	 val Rdest = translateIReg rtl_Rdest
         val label = Rtl.fresh_code_label "cmv"
         val br = (case cmp of
		   Rtl.EQ =>  BE
		 | Rtl.NE =>  BNE
		 | Rtl.GT =>  BG
		 | Rtl.GE =>  BGE
		 | Rtl.LT =>  BL
		 | Rtl.LE =>  BLE)
       in emit(SPECIFIC(CMP (Rsrc1, IMMop 0)));
	  emit(SPECIFIC(CBRANCHI(br,label)));
	  emit(SPECIFIC NOP);
	  emit(SPECIFIC(INTOP(OR, Rzero, Rop2, Rdest)));
          translate(Rtl.ILABEL label)
       end

     | translate (Rtl.FMV (rtl_Fsrc, rtl_Fdest)) =
       let
	 val Fsrc = translateFReg rtl_Fsrc
	 val Fdest = translateFReg rtl_Fdest
       in
	 emit (BASE (MOVF (Fsrc,Fdest)))
       end

     | translate (Rtl.ADD (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (ADD, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.SUB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SUB, Rsrc1, src2, Rdest)))
       end
     | translate (Rtl.MUL (rtl_Rsrc1, op2 as (Rtl.IMM denom), rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val Rdest = translateIReg rtl_Rdest
	 val src2  = translateOp op2
       in emit (SPECIFIC(INTOP (SMUL, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.MUL (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SMUL, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.DIV (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val src2 = translateOp op2
	 val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SDIV, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.MOD (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val rtl_Rsrc2 = 
		(case op2 of
			Rtl.REG r => r
		      | Rtl.IMM n => 
			let val temp = Rtl.REGI(Name.fresh_var(), Rtl.NOTRACE_INT)
			    val _ = translate(Rtl.LI(i2w n,temp))
			in  temp
			end)
       in
	 translate(Rtl.CALL{call_type = Rtl.C_NORMAL,
				func = Rtl.LABEL' (Rtl.C_EXTERN_LABEL ".rem"),
				args = [Rtl.I rtl_Rsrc1, Rtl.I rtl_Rsrc2],
				results = [Rtl.I rtl_Rdest],
				save = []})
       end

     | translate (Rtl.S4ADD (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SLL, Rsrc1, IMMop 2, Rdest)));
	 emit (SPECIFIC(INTOP (ADD, Rdest, src2, Rdest)))
       end

     | translate (Rtl.S8ADD (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SLL, Rsrc1, IMMop 3, Rdest)));
	 emit (SPECIFIC(INTOP (ADD, Rdest, src2, Rdest)))
       end

     | translate (Rtl.S4SUB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SLL, Rsrc1, IMMop 2, Rdest)));
	 emit (SPECIFIC(INTOP (SUB, Rdest, src2, Rdest)))
       end

     | translate (Rtl.S8SUB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SLL, Rsrc1, IMMop 3, Rdest)));
	 emit (SPECIFIC(INTOP (SUB, Rdest, src2, Rdest)))
       end

     | translate (Rtl.ADDT (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (ADDCC, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.SUBT (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SUBCC, Rsrc1, src2, Rdest)))
       end


     | translate (Rtl.MULT (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SMULCC, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.DIVT args) = translate (Rtl.DIV args)

     | translate (Rtl.MODT args) = translate (Rtl.MOD args)

     | translate (Rtl.CMPSI (cmp, rtl_Rsrc1, rtl_op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val op2 = translateOp rtl_op2
	 val Rdest = translateIReg rtl_Rdest
         val br = (case cmp of
		   Rtl.EQ =>  BE
		 | Rtl.NE =>  BNE
		 | Rtl.GT =>  BG
		 | Rtl.GE =>  BGE
		 | Rtl.LT =>  BL
		 | Rtl.LE =>  BLE)
         val label = Rtl.fresh_code_label "cmpsi"
       in emit(SPECIFIC(CMP(Rsrc1, op2)));
	  load_imm(0w1, Rdest);
	  emit(SPECIFIC(CBRANCHI(br,label)));
	  emit(SPECIFIC NOP);
	  load_imm(0w0, Rdest);
          translate(Rtl.ILABEL label)
       end

     | translate (Rtl.CMPUI (cmp, rtl_Rsrc1, rtl_op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val op2 = translateOp rtl_op2
	 val Rdest = translateIReg rtl_Rdest
         val br = (case cmp of
		   Rtl.EQ =>  BE
		 | Rtl.NE =>  BNE
		 | Rtl.GT =>  BGU
		 | Rtl.GE =>  BCC
		 | Rtl.LT =>  BCS
		 | Rtl.LE =>  BLEU)
         val label = Rtl.fresh_code_label "cmpui"
       in emit(SPECIFIC(CMP(Rsrc1, op2)));
	  load_imm(0w1, Rdest);
	  emit(SPECIFIC(CBRANCHI(br,label)));
	  emit(SPECIFIC NOP);
	  load_imm(0w0, Rdest);
          translate(Rtl.ILABEL label)
       end

     | translate (Rtl.NOTB (rtl_Rsrc, rtl_Rdest)) =
       let
	 val Rsrc = translateIReg rtl_Rsrc
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (ORCC, Rzero, REGop Rsrc, Rdest)))
       end

     | translate (Rtl.ANDB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (AND, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.ORB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (OR, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.XORB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (XOR, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.SLL (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 (* Need to sign-extend shifted result to regain
            canonical 32-bit form in register (See Assembly
            manual, page B-3 *)
	 emit (SPECIFIC (INTOP (SLL, Rsrc1, src2, Rdest)));
	 emit (SPECIFIC (INTOP (ADD, Rdest, REGop Rzero, Rdest)))
       end

     | translate (Rtl.SRL (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (SRL, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.SRA (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (SRA, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.FADDD (rtl_Fsrc1, rtl_Fsrc2, rtl_Fdest)) =
       let
	 val Fsrc1 = translateFReg rtl_Fsrc1
         val Fsrc2 = translateFReg rtl_Fsrc2
         val Fdest = translateFReg rtl_Fdest
       in
          emit (SPECIFIC (FPOP (FADDD, Fsrc1, Fsrc2, Fdest)))
       end

     | translate (Rtl.FSUBD (rtl_Fsrc1, rtl_Fsrc2, rtl_Fdest)) =
       let
	 val Fsrc1 = translateFReg rtl_Fsrc1
         val Fsrc2 = translateFReg rtl_Fsrc2
         val Fdest = translateFReg rtl_Fdest
       in
          emit (SPECIFIC (FPOP (FSUBD, Fsrc1, Fsrc2, Fdest)))
       end

     | translate (Rtl.FMULD (rtl_Fsrc1, rtl_Fsrc2, rtl_Fdest)) =
       let
	 val Fsrc1 = translateFReg rtl_Fsrc1
         val Fsrc2 = translateFReg rtl_Fsrc2
         val Fdest = translateFReg rtl_Fdest
       in
          emit (SPECIFIC (FPOP (FMULD, Fsrc1, Fsrc2, Fdest)))
       end

     | translate (Rtl.FDIVD (rtl_Fsrc1, rtl_Fsrc2, rtl_Fdest)) =
       let
	 val Fsrc1 = translateFReg rtl_Fsrc1
         val Fsrc2 = translateFReg rtl_Fsrc2
         val Fdest = translateFReg rtl_Fdest
       in
          emit (SPECIFIC (FPOP (FDIVD, Fsrc1, Fsrc2, Fdest)))
       end

     | translate (Rtl.FABSD (rtl_Fsrc, rtl_Fdest)) =
       let
	 val Fsrc  = translateFReg rtl_Fsrc
         val Fdest = translateFReg rtl_Fdest
       in
	 emit (SPECIFIC (FPMOVE (FABSD, Fsrc, Fdest)))
       end

     | translate (Rtl.FNEGD (rtl_Fsrc, rtl_Fdest)) =
       let
	 val Fsrc  = translateFReg rtl_Fsrc
         val Fdest = translateFReg rtl_Fdest
       in
	 emit (SPECIFIC (FPMOVE (FNEGD, Fsrc, Fdest)))
       end


     | translate (Rtl.CVT_REAL2INT (rtl_Fsrc, rtl_Rdest)) =
       let
	 val Fsrc  = translateFReg rtl_Fsrc
         val Rdest = translateIReg rtl_Rdest
       in
	   emit (SPECIFIC(FPCONV(FDTOI, Fsrc, Rdest)))
       end

     | translate (Rtl.CVT_INT2REAL (rtl_Rsrc, rtl_Fdest)) =
       let
	 val Rsrc  = translateIReg rtl_Rsrc
         val Fdest = translateFReg rtl_Fdest
       in
	   emit (SPECIFIC (FPCONV (FITOD, Fdest, Fdest)))
       end

 
     | translate (Rtl.CMPF (cmp, rtl_Fsrc1, rtl_Fsrc2, rtl_Rdest)) =
       let
	 val Fsrc1 = translateFReg rtl_Fsrc1
         val Fsrc2 = translateFReg rtl_Fsrc2
         val Rdest = translateIReg rtl_Rdest
	 val label = Rtl.fresh_code_label "cmpf"
         val br = (case cmp of
		   Rtl.EQ =>  FBE
		 | Rtl.NE =>  FBNE
		 | Rtl.GT =>  FBG
		 | Rtl.GE =>  FBGE
		 | Rtl.LT =>  FBL
		 | Rtl.LE =>  FBLE)
       in emit(SPECIFIC(FCMPD(Fsrc1, Fsrc2)));
	  load_imm(0w1, Rdest);
	  emit(SPECIFIC(CBRANCHF(br,label)));
	  emit(SPECIFIC NOP);
	  load_imm(0w0, Rdest);
          translate(Rtl.ILABEL label)
       end

     | translate (Rtl.BR ll) =  emit (BASE (BR ll))

     | translate (Rtl.BCNDI (comparison, rtl_Rsrc1, rtl_op2, loc_label, pre)) =
       let val Rsrc1 = translateIReg rtl_Rsrc1
	   val op2 = translateOp rtl_op2
	   val cmp = translate_icmp comparison
       in 
	   emit(SPECIFIC(CMP(Rsrc1,op2)));
	   emit(SPECIFIC(CBRANCHI(cmp, loc_label)));
	   emit(SPECIFIC NOP)
       end

     | translate (Rtl.BCNDF (cmp, rtl_Fsrc1, rtl_Fsrc2, loc_label, pre)) =
       let 
	 val Fsrc1 = translateFReg rtl_Fsrc1
         val Fsrc2 = translateFReg rtl_Fsrc2
         val cmp = translate_fcmp cmp
       in 
	 emit (SPECIFIC (FCMPD(Fsrc1, Fsrc2)));
	 emit (SPECIFIC (CBRANCHF(cmp, loc_label)));
	 emit(SPECIFIC NOP)
       end


     | translate (Rtl.JMP (rtl_Raddr, rtllabels)) =
       let
	 val Raddr = translateIReg rtl_Raddr
       in
	   emit (BASE (RTL (JMP (Raddr, rtllabels))))
       end

     | translate (Rtl.CALL {call_type, func, args, results, ...}) =
       let
	   val func = (case func of
			   Rtl.REG' rtl_Raddr => INDIRECT(translateIReg rtl_Raddr)
			 | Rtl.LABEL' l => DIRECT(l, NONE))
       in
	   (case call_type of
		Rtl.C_NORMAL =>
		    (emit(SPECIFIC(INTOP(SUB, Rsp, IMMop 256, Rsp)));
		    emit(BASE(RTL (CALL{calltype = Rtl.C_NORMAL,
					func = DIRECT(Rtl.C_EXTERN_LABEL "save_iregs", NONE),
					args = [],
					results = [],
					argregs = NONE,
					resregs = NONE,
					destroys = NONE}))))
	      | _ => ());

	  emit (BASE(RTL (CALL{calltype = call_type,
			       func     = func,
			       args     = map translateReg args,
			       results  = map translateReg results,
			       argregs  = NONE,
			       resregs  = NONE,
			       destroys = NONE})));

	   (case call_type of
		Rtl.C_NORMAL =>
		    (emit(BASE(RTL (CALL{calltype = Rtl.C_NORMAL,
					func = DIRECT(Rtl.C_EXTERN_LABEL "load_iregs", NONE),
					args = [],
					results = [],
					argregs = NONE,
					resregs = NONE,
					destroys = NONE})));
		     emit(SPECIFIC(INTOP(ADD,Rsp, IMMop 256, Rsp))))
	      | _ => ());

	   (* Have a return for tailcalls in case we cannot do tailcalls from overflowing arguments *)
	   (case call_type of
		Rtl.ML_TAIL _ => emit (BASE (RTL (RETURN {results = !current_res})))
	      | _ => ())
       end


     | translate (Rtl.RETURN rtl_Raddr) =
          emit (BASE (RTL (RETURN {results = ! current_res})))

     | translate (Rtl.SAVE_CS l) = emit (BASE (RTL (SAVE_CS l)))

     | translate (Rtl.END_SAVE) = ()
     | translate (Rtl.RESTORE_CS) = ()
     | translate (Rtl.LOAD32I (Rtl.EA (rtl_Raddr, disp), rtl_Rdest)) =
       let
	 val Raddr = translateIReg rtl_Raddr
	 val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (LOADI (LD, Rdest, disp, Raddr)))
       end

     | translate (Rtl.STORE32I (Rtl.EA (rtl_Raddr, disp), rtl_Rdest)) =
       let
	 val Raddr = translateIReg rtl_Raddr
	 val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (STOREI (ST, Rdest, disp, Raddr)))
       end


     | translate (Rtl.LOADQF (Rtl.EA (rtl_Raddr, disp), rtl_Fdest)) =
       let
	 val Raddr = translateIReg rtl_Raddr
	 val Fdest = translateFReg rtl_Fdest
       in
	 emit (SPECIFIC (LOADF (LDDF, Fdest, disp, Raddr)))
       end

     | translate (Rtl.STOREQF (Rtl.EA (rtl_Raddr, disp), rtl_Fsrc)) =
       let
	 val Raddr = translateIReg rtl_Raddr
	 val Fsrc  = translateFReg rtl_Fsrc
       in
	 emit (SPECIFIC (STOREF (STDF, Fsrc, disp, Raddr)))
       end

     | translate (Rtl.ICOMMENT str) = emit (BASE(ICOMMENT str))

     | translate (Rtl.MUTATE (Rtl.EA(base,disp),newval,isptr_opt)) =
	 let 
	     fun logwrite() = 
		 let val writelist_cursor = Rtl.ML_EXTERN_LABEL "writelist_cursor"
		     val cursor_addr = Rtl.REGI(Name.fresh_var(),Rtl.NOTRACE_LABEL)
		     val cursor_val = Rtl.REGI(Name.fresh_var(),Rtl.LOCATIVE)
		     val store_loc = Rtl.REGI(Name.fresh_var(),Rtl.LOCATIVE)
		 in  emit (SPECIFIC (INTOP (SUB, Rhlimit, IMMop 8, Rhlimit)));
		     app translate [Rtl.LADDR(writelist_cursor,0,cursor_addr),
				    Rtl.LOAD32I(Rtl.EA(cursor_addr,0),cursor_val),
				    Rtl.ADD(base, Rtl.IMM disp,store_loc),
				    Rtl.STORE32I(Rtl.EA(cursor_val,0),store_loc),
				    Rtl.ADD(cursor_val, Rtl.IMM 4, cursor_val),
				    Rtl.STORE32I(Rtl.EA(cursor_addr,0),cursor_val)]
		 end
	 in
	   translate (Rtl.STORE32I(Rtl.EA(base,disp),newval));
	   (case isptr_opt of
		NONE => logwrite()
	      | SOME isptr =>
		    let val after = Rtl.fresh_code_label "dynmutate_after"
		    in  translate (Rtl.BCNDI(Rtl.EQ,isptr,Rtl.IMM 0,after,false));
			logwrite();
			translate (Rtl.ILABEL after)
		    end)
	 end

     | translate (Rtl.INIT (Rtl.EA (rtl_Raddr, disp), rtl_Rdest, unused)) =
       let
	 val Raddr = translateIReg rtl_Raddr
	 val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (STOREI (ST, Rdest, disp, Raddr)))
       end

     | translate (Rtl.NEEDGC (Rtl.REG rtl_Rsize)) =
       let
	 val Rsize = translateIReg rtl_Rsize
	 val rtl_loclabel = Rtl.fresh_code_label "needgc"
       in
	 emit (SPECIFIC (INTOP   (SLL, Rsize, IMMop 2, Rat)));
	 emit (SPECIFIC (INTOP   (ADD, Rat, REGop Rheap, Rat)));
	 emit (SPECIFIC (CMP     (Rat, REGop Rhlimit)));
	 emit (SPECIFIC (CBRANCHI(BL, rtl_loclabel)));
	  emit(SPECIFIC NOP);
	 emit (SPECIFIC (INTOP   (SLL, Rsize, IMMop 2, Rhlimit)));
	 emit (BASE (GC_CALLSITE rtl_loclabel));
	 emit (BASE (BSR (Rtl.ML_EXTERN_LABEL ("gc_raw"), NONE,
			     {regs_modified=[Rat], regs_destroyed=[Rat],
			      args=[Rat]})));
	 translate (Rtl.ILABEL rtl_loclabel)
       end

     | translate (Rtl.NEEDGC (Rtl.IMM 0)) = ()
     | translate (Rtl.NEEDGC (Rtl.IMM words)) =
       let
	 val rtl_Itemp = Rtl.REGI(Name.fresh_var(),Rtl.NOTRACE_INT)
	 val Itemp = translateIReg rtl_Itemp
	 val rtl_loclabel = Rtl.fresh_code_label "needgc"
	 val size = 4 * words
       in
	 if (in_ea_disp_range size) then
	   emit (SPECIFIC (INTOP (ADD, Rheap, IMMop size, Rat)))
	 else
	   (load_imm(i2w size, Rat);
	    emit (SPECIFIC (INTOP (ADD, Rheap, REGop Rat, Rat))));
	 emit (SPECIFIC (CMP   (Rat, REGop Rhlimit)));
	 emit (SPECIFIC (CBRANCHI(BL, rtl_loclabel)));
	  emit(SPECIFIC NOP);
	 load_imm(i2w size, Rhlimit);
	 emit (BASE (GC_CALLSITE rtl_loclabel));
	 emit (BASE (BSR (Rtl.ML_EXTERN_LABEL ("gc_raw"), NONE,
			  {regs_modified=[Rat], regs_destroyed=[Rat],
			   args=[Rat]})));
	 translate (Rtl.ILABEL rtl_loclabel)
       end

     | translate (Rtl.SOFT_VBARRIER _) = ()
     | translate (Rtl.SOFT_ZBARRIER _) = ()
     | translate (Rtl.HARD_VBARRIER _) = ()
     | translate (Rtl.HARD_ZBARRIER _) = ()

     | translate (Rtl.IALIGN x) = ()
(*
          emit(IALIGN (case x
		  of Rtl.OCTA => OCTA
		   | Rtl.QUAD => QUAD
		   | Rtl.LONG => LONG
		   | _ => error "unexpected alignment in instruction stream"))
*)
     | translate (Rtl.ILABEL ll) = 
          (* Begin new basic block *)
          (saveBlock ();
	   resetBlock ll true true)

	  
     | translate Rtl.HALT = 
       (* HALT is a no-op from the translator's point of view *)
          ()


       (* HANDLER_ENTRY: the start of handler. *)

     | translate Rtl.HANDLER_ENTRY =  

	 emit (BASE (RTL HANDLER_ENTRY))

	  

   (* Translates an entire Rtl procedure *)
   fun translateProc (Rtl.PROC {name, args, code, known, results, return, 
				save = _, vars = _}) =
     let
       val args   = map translateReg args
       val res    = map translateReg results
       val return = translateIReg return
     in
       (* initialization *)
       tracemap := Regmap.empty;
       block_map := Labelmap.empty;
       current_blocklabels := [];
       current_proc := name;
       current_res := res;
       init_stack_res();
       
       (* Create (empty) preamble block with same name as the procedure *)
       resetBlock name true false;
       saveBlock ();

       (* Start a new block *)
       resetBlock (freshCodeLabel()) true true;

       (* Translate instructions *)
       (Array.app 
	(fn arg => ((translate arg)
		    handle e => (print "exn raised during translation of Rtl instruction:\n  ";
				 Pprtl.pp_Instr arg;
				 raise e)))
	code);
       
       (* Flush last block *)
       saveBlock ();

       (* Return blocklabels with blocks in the SAME order as in
          the Rtl code, and the associated block_map *)
       (rev (! current_blocklabels), ! block_map, ! tracemap, get_stack_res())
     end

   (* For reasons of simplicity, the datatype for Rtl data is
      the same as the datatype for Decalpha data.  Hence the
      translation of the data is really easy---remove it from
      the array. *)
   fun array2list a = 
       let val len = Array.length a
	   fun loop n = if (n >= len) then []
			else (Array.sub(a,n))::(loop (n+1))
       in  loop 0
       end
(*   fun translateData data_array = array2list data_array *)


end (* struct *)