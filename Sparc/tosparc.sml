(* WARNING: Use Rat or Rat2 only if sure that no spills (or at most one if one of Rat/Rat2 is used)
              will cause usage of Rat/Rat2 during the live range of Rat/Rat2.
*)

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
   val inProc = ref false

   local
     (* stack slot position of next variable to be made stack-resident *)

     val count = ref 0
     val stack_res = ref (Regmap.empty) : stacklocation Regmap.map ref

   in
     fun init_stack_res () = (count := 0; stack_res := Regmap.empty)
     fun get_stack_res () = !stack_res
     fun add_stack x =
	 (case Regmap.find(!stack_res,x) of
	     SOME i => i
	   | NONE =>
		 let val r = SPILLED_INT(!count)
		 in stack_res := Regmap.insert(!stack_res,x,r);
		    count := !count + 1;
		    r
		 end)
   end


   fun var2ireg v = R (Name.var2int v)

   fun translateRep rep =
       let fun translateVar v =
	   ((case (Regmap.find(!tracemap, var2ireg v)) of
		 NONE => if (!inProc)
			     then (print "Warning: Missing binding for type variable "; print (msReg (var2ireg v));
				   error "ERROR: Missing binding for type variable ")
			 else ()
	       | SOME _ => ());
	    R(Name.var2int v))
       in  case rep of
	   Rtl.TRACE => (NONE, Tracetable.TRACE_YES)
	 | Rtl.LOCATIVE => (NONE, Tracetable.TRACE_IMPOSSIBLE)
	 | Rtl.COMPUTE path =>
	       (case path of
		    Rtl.Projvar_p (Rtl.REGI(v,_),[]) =>
			let val v = translateVar v
			in  (SOME v, Tracetable.TRACE_STACK(add_stack v))
			end
	       | Rtl.Projvar_p (Rtl.REGI(v,_),i) =>
			let val v = translateVar v
			in  (SOME v, Tracetable.TRACE_STACK_REC(add_stack v, i))
			end
	       | Rtl.Projvar_p (Rtl.SREGI _, i) => error "SREG should not contain type"
	       | Rtl.Projlabel_p (l,[]) => (NONE,Tracetable.TRACE_LABEL l)
	       | Rtl.Projlabel_p (l,i) => (NONE,Tracetable.TRACE_LABEL_REC (l,i))
	       | Rtl.Projglobal_p (l,[]) => (NONE,Tracetable.TRACE_GLOBAL l)
	       | Rtl.Projglobal_p (l,i) => (NONE,Tracetable.TRACE_GLOBAL_REC (l,i))
	       | Rtl.Notneeded_p => (NONE,Tracetable.TRACE_IMPOSSIBLE))
	| Rtl.UNSET => (NONE,Tracetable.TRACE_UNSET)
	| Rtl.NOTRACE_INT => (NONE,Tracetable.TRACE_NO)
	| Rtl.NOTRACE_REAL => (NONE,Tracetable.TRACE_NO)
	| Rtl.NOTRACE_CODE => (NONE,Tracetable.TRACE_NO)
	| Rtl.NOTRACE_LABEL => (NONE,Tracetable.TRACE_NO)
       end

   fun internal_translateRep v Rtl.UNSET = (add_stack (R (Name.var2int v));
					    translateRep Rtl.UNSET)
     | internal_translateRep _ rep = translateRep rep

   fun translateSReg Rtl.HEAPALLOC = Rheap
     | translateSReg Rtl.HEAPLIMIT = Rhlimit
     | translateSReg Rtl.STACK = Rsp
     | translateSReg Rtl.THREADPTR = Rth
     | translateSReg Rtl.EXNSTACK = Rexnptr
     | translateSReg Rtl.EXNARG = Rexnarg
     | translateSReg Rtl.HANDLER = Rhandler

   fun translateIReg (Rtl.REGI (v, rep)) =
       let val vv = R (Name.var2int v)
	   val _ = tracemap := Regmap.insert(!tracemap, vv, internal_translateRep v rep)
       in  vv
       end
     | translateIReg (Rtl.SREGI s) = translateSReg s

   fun translateFReg (Rtl.REGF (v, _)) = F (2 * (Name.var2int v))


   fun translateReg (Rtl.I ir) = translateIReg ir
     | translateReg (Rtl.F fr) = translateFReg fr

   (* Translate an RTL register option into a SPARC register option *)
   fun translateIRegOpt NONE = NONE
     | translateIRegOpt (SOME Reg) = SOME (translateIReg Reg)

   (* Translate the register-or-immediate value found as the second
      source operand in many instructions *)
   fun translateOp (Rtl.REG rtl_reg) =
         REGop (translateIReg rtl_reg)
     | translateOp (Rtl.IMM src2) =
	 if (in_imm_range src2) then
	   IMMop (INT src2)
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
      here so that we can add them to Core RETURN assembly op *)
   val current_res    = ref []              : Rtl.reg list ref

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
       let fun branch_case (fallthrough, succ_labels) =
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
	   end
       in  (current_instrs := (NO_ANN instr) :: (! current_instrs);
	    case (Sparc.Machine.cFlow instr) of
		NOBRANCH => ()
	      | BRANCH info => branch_case info
	      | DELAY_BRANCH info => (current_instrs := (NO_ANN (SPECIFIC NOP)) :: (! current_instrs);
				      branch_case info))
       end


   (* Translate an RTL instruction into one or more Sparc instructions *)
   val load_imm = (app emit) o load_imm'

   fun translate_icmp Rtl.EQ = BE
     | translate_icmp Rtl.NE = BNE
     | translate_icmp Rtl.GT = BG
     | translate_icmp Rtl.GE = BGE
     | translate_icmp Rtl.LT = BL
     | translate_icmp Rtl.LE = BLE

   fun translate_uicmp Rtl.EQ = BE
     | translate_uicmp Rtl.NE = BNE
     | translate_uicmp Rtl.GT = BGU
     | translate_uicmp Rtl.GE = BCC
     | translate_uicmp Rtl.LT = BCS
     | translate_uicmp Rtl.LE = BLEU

   fun negate_icmp BE  = BNE
     | negate_icmp BNE = BE
     | negate_icmp BG  = BLE
     | negate_icmp BGE = BL
     | negate_icmp BL  = BGE
     | negate_icmp BLE = BG
     | negate_icmp BLEU = BGU
     | negate_icmp BGU = BLEU
     | negate_icmp BCC = BCS
     | negate_icmp BCS = BCC
     | negate_icmp BVC = BVS
     | negate_icmp BVS = BVC

   fun translate_fcmp Rtl.EQ = FBE
     | translate_fcmp Rtl.NE = FBNE
     | translate_fcmp Rtl.GT = FBG
     | translate_fcmp Rtl.GE = FBGE
     | translate_fcmp Rtl.LT = FBL
     | translate_fcmp Rtl.LE = FBLE

   fun loadEA' destOpt ea =
       (case ea of
	    Rtl.REA(rtlBase, disp) => (translateIReg rtlBase, INT disp)
	  | Rtl.LEA(label, disp) => let val base = freshIreg()
				    in  emit(SPECIFIC(SETHI(HIGHLABEL (label,i2w disp), base)));
					(base, LOWLABEL (label,i2w disp))
				    end
	  | Rtl.RREA(r1, r2) => let val Rsrc1 = translateIReg r1
				    val Rsrc2 = translateIReg r2
				    val dest = (case destOpt of
						    NONE => translateIReg
							(Rtl.REGI(Name.fresh_var(),Rtl.LOCATIVE))
						  | SOME d => d)
				    val _ = emit (SPECIFIC(INTOP (ADD, Rsrc1, REGop Rsrc2, dest)))
				in  (dest, INT 0)
				end)

   val loadEA = loadEA' NONE
   fun translate_local_label ll =
       (* Begin new basic block *)
       (saveBlock ();
	resetBlock ll true true)

   (* Overflow checks occur after the operation. *)
   fun trap_overflow trapi = emit (SPECIFIC (TRAP (trapi, ST_INT_OVERFLOW)))
(*
   fun test_overflow trapi =
       let val cc = (case trapi
		       of TVS => BVC
			| TNE => BE)
	   val afterLabel = Rtl.fresh_code_label "afterOverflowCheck"
       in  emit (SPECIFIC (CBRANCHI (cc, afterLabel, true)));
	   emit (BASE (BSR (Rtl.xML_EXTERN_LABEL ("OverflowFromML"), NONE,
			    {regs_modified=[], regs_destroyed=[], args=[]})));
	   translate_local_label afterLabel
       end
*)
   fun test_overflow trapi =
       let val branch = (case trapi
			   of TVS => BVS
			    | TNE => BNE)
       in  emit (SPECIFIC (CBRANCHI (branch, Rtl.C_EXTERN_LABEL "localOverflowFromML", false)))
       end
   fun hard_vbarrier (trapi : trap_instruction) = if (!branchingTraps) then test_overflow trapi
						  else trap_overflow trapi
(*
   (* Division by check occurs before the operation.  The trap always occurs.  *)
   fun test_zero' (IMMop (INT 0)) = emit (BASE (BSR (Rtl.xML_EXTERN_LABEL ("DivFromML"), NONE,
						     {regs_modified=[], regs_destroyed=[], args=[]})))
     | test_zero' (IMMop (INT _)) = ()
     | test_zero' opDivisor =
       let val afterLabel = Rtl.fresh_code_label "afterZeroCheck"
	   val _ = (case opDivisor
		      of REGop rDivisor => emit (SPECIFIC (CBRANCHR (BRNZ, rDivisor, afterLabel, true)))
		       | _ => (emit (SPECIFIC (CMP (Rzero, opDivisor)));
			       emit (SPECIFIC (CBRANCHI (BNE, afterLabel, true)))))
	   val _ = emit (BASE (BSR (Rtl.xML_EXTERN_LABEL ("DivFromML"), NONE,
				    {regs_modified=[], regs_destroyed=[], args=[]})))
	   val _ = translate_local_label afterLabel
       in  ()
       end
*)
   local
       val divLbl = Rtl.C_EXTERN_LABEL "localDivFromML"
   in
       (* Division by zero check occurs before the operation.  The trap always occurs.  *)
       fun test_zero' (IMMop (INT 0)) = emit (BASE (BR divLbl))
	 | test_zero' (IMMop (INT _)) = ()
	 | test_zero' (REGop rDivisor) = emit (SPECIFIC (CBRANCHR (BRZ, rDivisor, divLbl, false)))
	 | test_zero' opDivisor = (emit (SPECIFIC (CMP (Rzero, opDivisor)));
				   emit (SPECIFIC (CBRANCHI (BE, divLbl, false))))
   end
   fun test_zero opDivisor = if (!branchingTraps) then test_zero' opDivisor
			     else ()

   fun translate (Rtl.LI (immed, rtl_Rdest)) = load_imm(immed,translateIReg rtl_Rdest)
     | translate (Rtl.LADDR (ea, rtl_Rdest)) =
          let val Rdest = translateIReg rtl_Rdest
	      val (Rbase,disp) = loadEA' (SOME Rdest) ea
	      val dispZero = (case disp of
				  LOWINT 0w0 => true
				| INT 0 => true
				| _ => false)
	  in  if dispZero
		  then (if eqRegs'(Rbase,Rdest)
			    then ()
			else emit (BASE(MOVE (Rbase, Rdest))))
	      else emit (SPECIFIC(INTOP (OR, Rbase, IMMop disp, Rdest)))
	  end

     | translate (Rtl.MV (rtl_Rsrc, rtl_Rdest)) =
          emit (BASE(MOVE (translateIReg rtl_Rsrc, translateIReg rtl_Rdest)))

     | translate (Rtl.CMV (rtl_cmp, rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val Rop2 = translateOp op2
	 val Rdest = translateIReg rtl_Rdest
         val label = Rtl.fresh_code_label "cmv"
         val cmp = translate_icmp rtl_cmp
       in emit(SPECIFIC(CMP (Rsrc1, IMMop (INT 0))));
	  emit(SPECIFIC(CBRANCHI(negate_icmp cmp,label,true)));
	  emit(SPECIFIC(INTOP(OR, Rzero, Rop2, Rdest)));
          translate(Rtl.ILABEL label)
       end

     | translate (Rtl.FMV (rtl_Fsrc, rtl_Fdest)) =
       let
	 val Fsrc = translateFReg rtl_Fsrc
	 val Fdest = translateFReg rtl_Fdest
       in
	 emit (BASE (MOVE (Fsrc,Fdest)))
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

     | translate (Rtl.UDIV (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val src2 = translateOp op2
	 val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(WRY  Rzero));
	 emit (SPECIFIC(INTOP (UDIV, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.UMOD (rtl_Rsrc1, op2, rtl_Rdest)) =
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
			    func = Rtl.LABEL' (Rtl.C_EXTERN_LABEL ".urem"),
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
	 emit (SPECIFIC(INTOP (SLL, Rsrc1, IMMop (INT 2), Rat)));
	 emit (SPECIFIC(INTOP (ADD, Rat, src2, Rdest)))
       end

     | translate (Rtl.S8ADD (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SLL, Rsrc1, IMMop (INT 3), Rat)));
	 emit (SPECIFIC(INTOP (ADD, Rat, src2, Rdest)))
       end

     | translate (Rtl.S4SUB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SLL, Rsrc1, IMMop (INT 2), Rat)));
	 emit (SPECIFIC(INTOP (SUB, Rat, src2, Rdest)))
       end

     | translate (Rtl.S8SUB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SLL, Rsrc1, IMMop (INT 3), Rat)));
	 emit (SPECIFIC(INTOP (SUB, Rat, src2, Rdest)))
       end

     | translate (Rtl.ADDT (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (ADDCC, Rsrc1, src2, Rdest)));
	 hard_vbarrier TVS
       end

     | translate (Rtl.SUBT (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC(INTOP (SUBCC, Rsrc1, src2, Rdest)));
	 hard_vbarrier TVS
       end


     | translate (Rtl.MULT (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
	 val Ry = translateIReg(Rtl.REGI(Name.fresh_var(),Rtl.NOTRACE_INT))
	 val Rmsb = translateIReg(Rtl.REGI(Name.fresh_var(),Rtl.NOTRACE_INT))
       in
         (* SMULCC is useless for detecting overflow *)
	 emit (SPECIFIC(INTOP (SMUL, Rsrc1, src2, Rdest)));
	 emit (SPECIFIC(RDY   Ry));
	 emit (SPECIFIC(INTOP (SRA, Rdest, IMMop (INT 31), Rmsb)));
	 emit (SPECIFIC(CMP   (Ry, REGop Rmsb)));
	 hard_vbarrier TNE
       end

     | translate (Rtl.DIVT (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val src2 = translateOp op2
	 val Rdest = translateIReg rtl_Rdest
       in
	 test_zero src2;
	 emit (SPECIFIC(INTOP (SRA, Rsrc1, IMMop (INT 31), Rat)));
	 emit (SPECIFIC(WRY   Rat));
	 emit (SPECIFIC(INTOP (SDIVCC, Rsrc1, src2, Rdest)));
	 (* hard division by zero trap is free *)
	 hard_vbarrier TVS
       end

     | translate (Rtl.MODT (rtl_Rsrc1, op2, rtl_Rdest)) =
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
	 test_zero (translateOp op2);
	 translate(Rtl.CALL{call_type = Rtl.C_NORMAL, (* XXX should use our own asm routine so this can ML_NORMAL *)
			    func = Rtl.LABEL' (Rtl.C_EXTERN_LABEL ".rem"),
			    args = [Rtl.I rtl_Rsrc1, Rtl.I rtl_Rsrc2],
			    results = [Rtl.I rtl_Rdest],
			    save = []})
	 (* hard division by zero trap is free *)
       end

     | translate (Rtl.CMPSI (cmp, rtl_Rsrc1, rtl_op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val op2 = translateOp rtl_op2
	 val Rdest = translateIReg rtl_Rdest
         val br = translate_icmp cmp
         val label = Rtl.fresh_code_label "cmpsi"
       in emit(SPECIFIC(CMP(Rsrc1, op2)));
	  load_imm(0w1, Rdest);
	  emit(SPECIFIC(CBRANCHI(br,label,true)));
	  load_imm(0w0, Rdest);
          translate(Rtl.ILABEL label)
       end

     | translate (Rtl.CMPUI (cmp, rtl_Rsrc1, rtl_op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
	 val op2 = translateOp rtl_op2
	 val Rdest = translateIReg rtl_Rdest
         val br = translate_uicmp cmp
         val label = Rtl.fresh_code_label "cmpui"
       in emit(SPECIFIC(CMP(Rsrc1, op2)));
	  load_imm(0w1, Rdest);
	  emit(SPECIFIC(CBRANCHI(br,label,true)));
	  load_imm(0w0, Rdest);
          translate(Rtl.ILABEL label)
       end

     | translate (Rtl.NOTB (rtl_Rsrc, rtl_Rdest)) =
       let
	 val Rsrc = translateIReg rtl_Rsrc
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (ORNOT, Rzero, REGop Rsrc, Rdest)))
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

     | translate (Rtl.ANDNOTB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (ANDNOT, Rsrc1, src2, Rdest)))
       end

     | translate (Rtl.ORNOTB (rtl_Rsrc1, op2, rtl_Rdest)) =
       let
	 val Rsrc1 = translateIReg rtl_Rsrc1
         val src2  = translateOp op2
         val Rdest = translateIReg rtl_Rdest
       in
	 emit (SPECIFIC (INTOP (ORNOT, Rsrc1, src2, Rdest)))
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
	 val scratch = INT threadScratch_disp
       in
	   emit (SPECIFIC (FPMOVE(FDTOI, Fsrc, Fat)));
	   emit (SPECIFIC (STOREF (STF, Fat, scratch, Rth)));
	   emit (SPECIFIC (LOADI (LD, Rdest, scratch, Rth)))
       end

     | translate (Rtl.CVT_INT2REAL (rtl_Rsrc, rtl_Fdest)) =
       let
	 val Rsrc  = translateIReg rtl_Rsrc
         val Fdest = translateFReg rtl_Fdest
	 val scratch = INT threadScratch_disp
       in
	   emit (SPECIFIC (STOREI (ST, Rsrc, scratch, Rth)));
	   emit (SPECIFIC (LOADF  (LDF, Fat, scratch, Rth)));
	   emit (SPECIFIC (FPMOVE (FITOD, Fat, Fdest)))
       end


     | translate (Rtl.CMPF (cmp, rtl_Fsrc1, rtl_Fsrc2, rtl_Rdest)) =
       let
	 val Fsrc1 = translateFReg rtl_Fsrc1
         val Fsrc2 = translateFReg rtl_Fsrc2
         val Rdest = translateIReg rtl_Rdest
	 val label = Rtl.fresh_code_label "cmpf"
         val br = translate_fcmp cmp
       in emit(SPECIFIC(FCMPD(Fsrc1, Fsrc2)));
	  load_imm(0w1, Rdest);
	  emit(SPECIFIC(CBRANCHF(br,label)));
	  load_imm(0w0, Rdest);
          translate(Rtl.ILABEL label)
       end

     | translate (Rtl.BR ll) =  emit (BASE (BR ll))

     | translate (Rtl.BCNDSI (comparison, rtl_Rsrc1, rtl_op2, loc_label, pre)) =
       let val Rsrc1 = translateIReg rtl_Rsrc1
	   val op2 = translateOp rtl_op2
	   val cmp = translate_icmp comparison
       in
	   emit(SPECIFIC(CMP(Rsrc1,op2)));
	   emit(SPECIFIC(CBRANCHI(cmp, loc_label, pre)))
       end

     | translate (Rtl.BCNDUI (comparison, rtl_Rsrc1, rtl_op2, loc_label, pre)) =
       let val Rsrc1 = translateIReg rtl_Rsrc1
	   val op2 = translateOp rtl_op2
	   val cmp = translate_uicmp comparison
       in
	   emit(SPECIFIC(CMP(Rsrc1,op2)));
	   emit(SPECIFIC(CBRANCHI(cmp, loc_label, pre)))
       end

     | translate (Rtl.BCNDF (cmp, rtl_Fsrc1, rtl_Fsrc2, loc_label, pre)) =
       let
	 val Fsrc1 = translateFReg rtl_Fsrc1
         val Fsrc2 = translateFReg rtl_Fsrc2
         val cmp = translate_fcmp cmp
       in
	 emit (SPECIFIC (FCMPD(Fsrc1, Fsrc2)));
	 emit (SPECIFIC (CBRANCHF(cmp, loc_label)))
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

	   (case (call_type, length args <= length indirect_int_args) of
		(Rtl.ML_TAIL _, false) =>
		    (emit (BASE(RTL (CALL{calltype = Rtl.ML_NORMAL,
					  func     = func,
					  args     = map translateReg args,
					  results  = map translateReg results,
					  argregs  = NONE,
					  resregs  = NONE,
					  destroys = NONE})));
		     emit (BASE (RTL (RETURN {results = map translateReg (!current_res)}))))
	      | _ =>
		    emit (BASE(RTL (CALL{calltype = call_type,
					 func     = func,
					 args     = map translateReg args,
					 results  = map translateReg results,
					 argregs  = NONE,
					 resregs  = NONE,
					 destroys = NONE}))))
       end


     | translate (Rtl.RETURN rtl_Raddr) =
          emit (BASE (RTL (RETURN {results = map translateReg (!current_res)})))

     | translate (Rtl.PUSH_EXN) = ()
     | translate (Rtl.POP_EXN) = ()
     | translate (Rtl.THROW_EXN) = ()
     | translate (Rtl.CATCH_EXN) = emit (BASE (RTL HANDLER_ENTRY)) (* indicator to restore callee-save *)

     | translate (Rtl.LOAD8I (ea, rtl_Rdest)) =
       let val (Raddr, disp) = loadEA ea
	   val Rdest = translateIReg rtl_Rdest
       in  emit (SPECIFIC (LOADI (LDUB, Rdest, disp, Raddr)))
       end

     | translate (Rtl.STORE8I (ea, rtl_Rdest)) =
       let val (Raddr, disp) = loadEA ea
	   val Rdest = translateIReg rtl_Rdest
       in  emit (SPECIFIC (STOREI (STUB, Rdest, disp, Raddr)))
       end

     | translate (Rtl.LOAD32I (ea, rtl_Rdest)) =
       let val (Raddr, disp) = loadEA ea
	   val Rdest = translateIReg rtl_Rdest
       in  emit (SPECIFIC (LOADI (LD, Rdest, disp, Raddr)))
       end

     | translate (Rtl.STORE32I (ea, rtl_Rdest)) =
       let val (Raddr, disp) = loadEA ea
	   val Rdest = translateIReg rtl_Rdest
       in  emit (SPECIFIC (STOREI (ST, Rdest, disp, Raddr)))
       end

     | translate (Rtl.LOAD64F (ea, rtl_Fdest)) =
       let val (Raddr, disp) = loadEA ea
	   val Fdest = translateFReg rtl_Fdest
       in emit (SPECIFIC (LOADF (LDDF, Fdest, disp, Raddr)))
       end

     | translate (Rtl.STORE64F (ea, rtl_Fsrc)) =
       let val (Raddr, disp) = loadEA ea
	   val Fsrc = translateFReg rtl_Fsrc
       in  emit (SPECIFIC (STOREF (STDF, Fsrc, disp, Raddr)))
       end

     | translate (Rtl.MIRROR_GLOBAL_OFFSET rtl_Rdest) =
       let val Rdest = translateIReg rtl_Rdest
       in  emit (SPECIFIC (LOADI (LD, Rdest, INT globalOffset_disp, Rth)))
       end

     | translate (Rtl.MIRROR_PTR_ARRAY_OFFSET rtl_Rdest) =
       let val Rdest = translateIReg rtl_Rdest
       in  emit (SPECIFIC (LOADI (LD, Rdest, INT arrayOffset_disp, Rth)))
       end

     | translate (Rtl.LOADSP Rdest) =
       let val stackletOffset = Rtl.REGI(Name.fresh_var(),Rtl.NOTRACE_INT)
	   val Rth = Rtl.SREGI Rtl.THREADPTR
	   val Rsp = Rtl.SREGI Rtl.STACK
       in  app translate [Rtl.LOAD32I (Rtl.REA (Rth, stackletOffset_disp), stackletOffset),
			  Rtl.SUB (Rsp, Rtl.REG stackletOffset, Rdest)]
       end

     (* RESTORESP must preserve Rhandler = Rat2 = %r17, Rexnarg = Rra
        = %r15, and Rexnptr = %r1.  Fresh temporaries (which may be
        spilled) can not be used because we are switching stack
        frames.  Since there can be no spills, we may use Rat and Rat2
        without interfering with register allocation.  We use Rat both
        as a temporary and to save Rexnarg around the call to
        RestoreStackFromML.  *)

     | translate (Rtl.RESTORESP) =
       let val afterLabel = Rtl.fresh_code_label "after_sp"
       in  app emit [SPECIFIC(LOADI(LD, Rat, INT stackletOffset_disp, Rth)),
		     SPECIFIC(INTOP(ADD, Rsp, REGop Rat, Rsp)),
		     SPECIFIC(LOADI(LD, Rat, INT stackTop_disp, Rth)),
		     SPECIFIC(CMP(Rsp, REGop Rat)),
		     SPECIFIC(CBRANCHI(BLEU, afterLabel, true)),
		     BASE(MOVE(Rexnarg, Rat)), (* Rexnarg = Rra trashed by BSR *)
		     BASE(BSR (Rtl.C_EXTERN_LABEL ("RestoreStackFromML"), NONE,
			       {regs_modified=[], regs_destroyed=[], args=[]})),
		     BASE(MOVE(Rat, Rexnarg))];
	   translate (Rtl.ILABEL afterLabel)
       end

     | translate (Rtl.ICOMMENT str) = emit (BASE(ICOMMENT str))

     | translate (Rtl.STOREMUTATE (ea, mutateType)) =
	   let val writeAlloc = Rtl.REGI(Name.fresh_var(),Rtl.LOCATIVE)
	       val writeAllocTemp = Rtl.REGI(Name.fresh_var(),Rtl.LOCATIVE)
	       val store_obj = Rtl.REGI(Name.fresh_var(),Rtl.TRACE)
	       val store_disp = Rtl.REGI(Name.fresh_var(),Rtl.NOTRACE_INT)
	       val sentinel = Rtl.REGI(Name.fresh_var(),Rtl.NOTRACE_INT)
	       val wordsForEachMutate = 3
	       val bytesForEachMutate = 4 * wordsForEachMutate
	   in  emit (SPECIFIC(LOADI (LD, translateIReg writeAlloc, INT writelistAlloc_disp, Rth)));
	       app translate
	       ((case ea of
		     Rtl.REA (r, i) => [Rtl.MV (r, store_obj), Rtl.LI(TilWord32.fromInt i, store_disp)]
		   | Rtl.LEA (l, i) => [Rtl.LADDR (Rtl.LEA(l, 0), store_obj), Rtl.LI(TilWord32.fromInt i, store_disp)]
		   | Rtl.RREA (r1, r2) => [Rtl.MV (r1, store_obj), Rtl.MV (r2, store_disp)]) @
		     [Rtl.STORE32I(Rtl.REA(writeAlloc,0),store_obj),
		      Rtl.STORE32I(Rtl.REA(writeAlloc,4),store_disp)]
		     @ (case mutateType of
			    Rtl.PTR_MUTATE => (* The STOREMUTATE precedes the STORE32I *)
				let val prevVal = Rtl.REGI(Name.fresh_var(), Rtl.TRACE)
				in [Rtl.LOAD32I(ea,prevVal),
				    Rtl.STORE32I(Rtl.REA(writeAlloc,8),prevVal)]
				end
			  | _ => [])
		     @ [Rtl.ADD(writeAlloc, Rtl.IMM bytesForEachMutate, writeAllocTemp)]);
	       emit (SPECIFIC(STOREI (ST, translateIReg writeAllocTemp,INT writelistAlloc_disp, Rth)))
	   end

     | translate (Rtl.NEEDMUTATE n) =
       let val wordsForEachMutate = 3
	   val bytesForEachMutate = 4 * wordsForEachMutate
	   val bytesNeeded = bytesForEachMutate * n
	   val useImm = in_imm_range bytesNeeded
	   val writeAlloc = Rtl.REGI(Name.fresh_var(),Rtl.LOCATIVE)
	   val writeLimit = Rtl.REGI(Name.fresh_var(),Rtl.LOCATIVE)
	   val writeAllocTemp = Rtl.REGI(Name.fresh_var(),Rtl.LOCATIVE)
	   val afterLabel = Rtl.fresh_code_label "afterMutateCheck"
       in  emit (SPECIFIC(LOADI (LD, translateIReg writeAlloc, INT writelistAlloc_disp, Rth)));
	   emit (SPECIFIC(LOADI (LD, translateIReg writeLimit, INT writelistLimit_disp, Rth)));
	   app translate
	   (if useImm then [Rtl.ADD(writeAlloc, Rtl.IMM bytesNeeded, writeAllocTemp)]
	    else [Rtl.LI(i2w bytesNeeded, writeAllocTemp),
		  Rtl.ADD(writeAlloc, Rtl.REG writeAllocTemp, writeAllocTemp)]);
	   translate (Rtl.BCNDUI(Rtl.LE, writeAllocTemp, Rtl.REG writeLimit, afterLabel, true));
	   if useImm then emit (SPECIFIC (INTOP(SUB, Rheap, IMMop(INT(bytesForEachMutate * n)), Rat)))
	   else (load_imm (i2w bytesNeeded, Rat);
		 emit (SPECIFIC (INTOP(SUB, Rheap, REGop Rat, Rat))));
	   emit (BASE (GC_CALLSITE afterLabel));
	   emit (BASE (BSR (Rtl.C_EXTERN_LABEL ("GCFromML"), NONE,
			    {regs_modified=[Rat], regs_destroyed=[Rat],
			     args=[Rat]})));
	   translate (Rtl.ILABEL afterLabel)
       end

     | translate (Rtl.NEEDALLOC (Rtl.IMM 0)) = ()
     | translate (Rtl.NEEDALLOC rtl_operand) =
       let
	   val rtl_loclabel = Rtl.fresh_code_label "needgc"
       in
	   (case rtl_operand of
		Rtl.REG rtl_Rsize =>
		    let val Rsize = translateIReg rtl_Rsize
		    in  emit (SPECIFIC (INTOP   (SLL, Rsize, IMMop (INT 2), Rat)));
			emit (SPECIFIC (INTOP   (ADD, Rat, REGop Rheap, Rat)))
		    end
	      | Rtl.IMM words =>
		    let val size = 4 * words
		    in  if (in_ea_disp_range size)
			    then emit (SPECIFIC (INTOP (ADD, Rheap, IMMop (INT size), Rat)))
			else
			    (load_imm(i2w size, Rat);
			     emit (SPECIFIC (INTOP (ADD, Rheap, REGop Rat, Rat))))
		    end);
	  emit (SPECIFIC (LOADI (LD, Rhlimit, INT heapLimit_disp, Rth)));
	  emit (SPECIFIC (CMP     (Rat, REGop Rhlimit)));
	  emit (SPECIFIC (CBRANCHI(BLEU, rtl_loclabel,true)));
	  emit (BASE (GC_CALLSITE rtl_loclabel));
	  emit (BASE (BSR (Rtl.C_EXTERN_LABEL ("GCFromML"), NONE,
			   {regs_modified=[Rat], regs_destroyed=[Rat],
			    args=[Rat]})));
	  translate (Rtl.ILABEL rtl_loclabel)
       end

     (*
	The RTL instructions SOFT_ZBARRIER and HARD_ZBARRIER handle
	any pending divide by zero exceptions.  These are always
	emitted in pairs so you need to generate code for at most one
	of them.  I say "at most one" because the runtime and OS may
	conspire to deliver a signal when division by zero occurs,
	making explicit barriers unnecessary.  A "hard" barrier is
	precise: Previous arithmetic instructions are completed, and
	any necessary div exceptions are raised, before subsequent
	instructions are issued.  A "soft" barrier provides no such
	gaurantees (ug).

	SOFT_VBARRIER and HARD_VBARRIER are similar for overflow.

	You also need to generate barriers when translating the
	following RTL instructions: ADDT, SUBT, MULT, DIVT, and MODT.
      *)

     | translate (Rtl.SOFT_VBARRIER _) = ()
     | translate (Rtl.SOFT_ZBARRIER _) = ()
     | translate (Rtl.HARD_VBARRIER _) = hard_vbarrier TVS
     | translate (Rtl.HARD_ZBARRIER _) = () (* free *)

     | translate (Rtl.ILABEL ll) = translate_local_label ll

     | translate Rtl.HALT =
       (* HALT is a no-op from the translator's point of view *)
          ()

   fun translateCode code =
       let fun translate1 arg = ((translate arg)
				 handle e => (print "exn raised during translation of Rtl instruction:\n  ";
				 Pprtl.pp_Instr arg;
				 raise e))
       in  Array.app translate1 code
       end

   (* Translates an entire Rtl procedure *)
   fun translateProc (Rtl.PROC {name, args, code, results, return,
				save = _, vars = _}) =
     let
       (* initialization *)
       val _ = inProc := true
       val _ = tracemap := Regmap.empty;
       val _ = block_map := Labelmap.empty
       val _ = current_blocklabels := []
       val _ = current_proc := name
       val _ = init_stack_res()

       val _ = map translateReg args     (* Args are defined on entry so we need to define them *)
       val _ = translateIReg return
       val _ = current_res := results    (* Args are defined on entry so we need to define them *)

       (* Create (empty) preamble block with same name as the procedure *)
       val _ = resetBlock name true false
       val _ = saveBlock ()

       (* Start a new block *)
       val _ = resetBlock (freshCodeLabel()) true true

       (* Translate instructions *)
       val _ = translateCode code

       (* Flush last block *)
       val _ = saveBlock ()

       (* Return blocklabels with blocks in the SAME order as in
          the Rtl code, and the associated block_map *)
       val res = (rev (! current_blocklabels), ! block_map, ! tracemap, get_stack_res())
       val _ = inProc := false
     in  res
     end

end (* struct *)
