(*$import TORTLARRAY Rtl Pprtl TortlBase TortlRecord Rtltags Nil NilUtil Ppnil Stats *)


structure TortlArray :> TORTL_ARRAY =

struct

    structure TortlBase = TortlBase
    open Name
    open Rtl
    open Nil
    open TortlBase TortlRecord
    open Rtltags

    val maxByteRequest = 8192
    val w2i = TilWord32.toInt
    val i2w = TilWord32.fromInt
    val do_writelist = ref true
    fun error s = Util.error "tortl-array" s

  (* ----------  Subscript operations ----------------- *)
  fun xsub_float (state, fs) (vl1 : term, vl2 : term, tr) =
      let
	  val a' = load_ireg_term(vl1,NONE)
	  val destf = alloc_regf()
	  val _ =  (case (in_ea_range 8 vl2) of
			SOME i => add_instr(LOADQF(REA(a',i),destf))
		      | NONE =>
			    let val b' = load_ireg_term(vl2,NONE)
				val addr = alloc_regi (LOCATIVE)
			    in  add_instr(S8ADD(b',REG a',addr));
				add_instr(LOADQF(REA(addr,0),destf))
			    end)
      in  (LOCATION(REGISTER(false, F destf)), state)
      end

  fun xsub_help (state : state, is, c)  (vl1 : term, vl2 : term, rep) =
      let val a' = load_ireg_term(vl1,NONE)
	  val desti = alloc_regi rep
      in  (case is of
	       Prim.W32 => (add_instr(ICOMMENT "int sub start");
			    (case (in_ea_range 4 vl2) of
				SOME i => add_instr(LOAD32I(REA(a',i),desti))
			      | NONE => let val b' = load_ireg_term(vl2,NONE)
					    val addr = alloc_regi (LOCATIVE)
					in  add_instr(S4ADD(b',REG a',addr));
					    add_instr(LOAD32I(REA(addr,0),desti))
					end);
				 add_instr(ICOMMENT "int sub end"))
	     | Prim.W8 => let val b' = load_ireg_term(vl2,NONE)
			      val addr = alloc_regi (LOCATIVE)
			  in  add_instr(ICOMMENT "character sub start\n");
			      add_instr(ADD(b',REG a',addr));
			      add_instr(LOAD8I(REA(addr,0),desti));
			      add_instr(ICOMMENT "character sub end\n")
			  end
	     | _ => error "xintptrsub not done on all int sizes");
	  (LOCATION(REGISTER(false,I desti)), state)
      end

  fun xsub_int (state : state, is)  (vl1 : term, vl2 : term, tr) =
      let val c = Prim_c(Int_c is, [])
      in  xsub_help (state,is,c) (vl1,vl2,niltrace2rep state tr)
      end

  fun xsub_known(state : state, c) (vl1 : term, vl2 : term, tr) =
      xsub_help(state, Prim.W32,c) (vl1,vl2,niltrace2rep state tr)


  fun xsub_dynamic(state,c, con_ir) (vl1 : term, vl2 : term, tr) : term * state =
      let
	  val _ = Stats.counter("Rtlxsub_dyn")()
	  fun floatcase s = let val (LOCATION(REGISTER(_,F fr)),s) = xsub_float(state,Prim.F64) 
								(vl1,vl2,Nil.TraceKnown TraceInfo.Notrace_Real)
				val (ir,s) = boxFloat(s,fr)
			    in  (I ir, s)
			    end
	  fun nonfloatcase (s,is) = let val (LOCATION(REGISTER(_, reg)),s) = xsub_int(s,is) (vl1,vl2,tr)
				    in  (reg,s)
				    end
				
	  val r = con_ir
	  val tmp = alloc_regi NOTRACE_INT
	  val desti = alloc_regi(niltrace2rep state tr)
	  val afterl = fresh_code_label "sub_after"
	  val floatl = fresh_code_label "sub_float"
	  val charl = fresh_code_label "sub_char"
	  val nonfloatl = fresh_code_label "sub_nonfloat"
	  val _ = (add_instr(BCNDI(EQ, r, IMM 11, floatl, false));
		   add_instr(BCNDI(EQ, r, IMM 0, charl, false)))
	  val _ = add_instr(ILABEL nonfloatl)
	  val (I desti,w32_state) = nonfloatcase(state, Prim.W32)
	  val _ = add_instr(BR afterl)

	  val _ = add_instr(ILABEL charl)
	  val (I desti8,w8_state) = nonfloatcase(state, Prim.W8)
	  val _ = add_instr(MV(desti8,desti))
	  val _ = add_instr(BR afterl)

	  val _ = add_instr(ILABEL floatl)
	  val (I boxi,float_state) = floatcase state

	  val _ = (add_instr(MV(boxi,desti));
		   add_instr(ILABEL afterl))
	  val state = join_states[w8_state,w32_state,float_state]
      in (LOCATION(REGISTER(false, I desti)), state)
      end
 
  (* ----------  Update operations ----------------- *)

  fun xupdate_float(state : state, fs) (vl1 : term, vl2 : term, vl3 : term) : term * state =
      let val a' = load_ireg_term(vl1,NONE)
	  val argf = load_freg_term(vl3,NONE)
      in (case (in_ea_range 8 vl2) of
	      SOME i => add_instr(STOREQF(REA(a',i),argf))
	    | NONE => let val b' = load_ireg_term(vl2,NONE)
			  val addr = alloc_regi (LOCATIVE)
		      in  add_instr(S8ADD(b',REG a',addr));
			  add_instr(STOREQF(REA(addr,0),argf))
		      end);
	  (empty_record, state)
      end

  fun xupdate_int(state : state, is) (vl1 : term, vl2 : term, vl3 : term) : term * state =
      let
	  val a' = load_ireg_term(vl1,NONE)
	  val argi = load_ireg_term(vl3,NONE)
      in  (case is of
	       Prim.W32 => (case (in_ea_range 4 vl2) of
				SOME i => add_instr(STORE32I(REA(a',i),argi))
			      | NONE => let val b' = load_ireg_term(vl2,NONE)
					    val addr = alloc_regi (LOCATIVE)
					in  add_instr(S4ADD(b',REG a',addr));
					    add_instr(STORE32I(REA(addr,0),argi))
					end)
	     | Prim.W8 => let val b' = load_ireg_term(vl2,NONE)
			      val addr = alloc_regi (LOCATIVE)
			  in  add_instr(ICOMMENT "character update start");
			      add_instr(ADD(b',REG a',addr));
			      add_instr(STORE8I(REA(addr,0),argi));
			      add_instr(ICOMMENT "character update end")
			  end
	     | _ => error "xintupdate not implemented on this size");
	  (empty_record, state)
      end

  fun xptrupdate(state, c) (vl1 : term, vl2 : term, vl3 : term) : term * state =
      let
	  val base = load_ireg_term(vl1,NONE)
	  val newval = load_ireg_term(vl3,NONE)
	  val ea = (case (in_imm_range_vl vl2) of
	       SOME offset => REA(base,4 * offset)
	     | NONE => let val offset = load_ireg_term(vl2,NONE)
			   val byteOffset = alloc_regi NOTRACE_INT
		       in  add_instr(SLL(offset,IMM 2, byteOffset));
			   RREA(base, byteOffset)
		       end)
      in  add_instr(MUTATE(ea, newval,NONE));
	  (empty_record, state)
      end

  fun xupdate_known(state, c) vlist : term * state =
      let
	  val is_ptr = (case #2(simplify_type state c) of
			    Prim_c(Sum_c{totalcount,tagcount,...},_) => totalcount <> tagcount
			  | _ => true)
      in  if (!do_writelist andalso is_ptr)
	      then xptrupdate(state, c) vlist
	  else xupdate_int(state,Prim.W32) vlist
      end

  fun xupdate_dynamic(state : state,c, con_ir) 
                     (vl1 : term, vl2 : term, vl3 : term) 
      : term * state =
      let
	  val _ = Stats.counter("Rtlxupdate_dyn")()
	   val r = con_ir
	   val tmp = alloc_regi NOTRACE_INT
	   val afterl = fresh_code_label "update_after"
	   val floatl = fresh_code_label "update_float"
	   val intl = fresh_code_label "update_int"
	   val charl = fresh_code_label "update_char"
	   val _ = (add_instr(BCNDI(EQ, r, IMM 11, floatl, false));
		    add_instr(BCNDI(EQ, r, IMM 2, intl, false));
		    add_instr(BCNDI(EQ, r, IMM 0, charl, false)))
	   val _ = xptrupdate(state,c) (vl1,vl2,vl3)
	   val _ = add_instr(BR afterl)
	   val _ = add_instr(ILABEL intl)
	   val _ = xupdate_int(state,Prim.W32) (vl1,vl2,vl3)
	   val _ = add_instr(BR afterl)
	   val _ = add_instr(ILABEL charl)
	   val _ = xupdate_int(state,Prim.W8) (vl1,vl2,vl3)
	   val _ = add_instr(BR afterl)
	   val _ = add_instr(ILABEL floatl)
	   val fr = unboxFloat(load_ireg_term(vl3,NONE))
	   val _ = xupdate_float(state,Prim.F64) (vl1,vl2,LOCATION(REGISTER (false,F fr)))
	   val _ = add_instr(ILABEL afterl)
      in  (empty_record, state)
      end



  (* -------------------- Length operations ------------------ *)
  fun xlen_float (state,fs) (vl : term) : term * state =
      let val dest = alloc_regi NOTRACE_INT
	  val src = load_ireg_term(vl,NONE)
	  val _ = add_instr(LOAD32I(REA(src,~4),dest))
	  val _ = add_instr(SRL(dest,IMM real_len_offset,dest))
      in  (LOCATION (REGISTER (false,I dest)), state)
      end

  fun xlen_int (state,is) (vl : term) : term * state =
      let val dest = alloc_regi NOTRACE_INT
	  val src = load_ireg_term(vl,NONE)
	  val _ = add_instr(LOAD32I(REA(src,~4),dest))
	  val offset = int_len_offset + (case is of
					     Prim.W8 => 0
					   | Prim.W16 => 1
					   | Prim.W32 => 2)
	  val _ = add_instr(SRL(dest,IMM offset,dest))
      in  (LOCATION (REGISTER (false,I dest)), state)
      end

  fun xlen_known (state,c) (vl : term) : term * state =
      let val dest = alloc_regi NOTRACE_INT
	  val src = load_ireg_term(vl,NONE)
	  val _ = add_instr(LOAD32I(REA(src,~4),dest))
	  val _ = add_instr(SRL(dest,IMM (2 + int_len_offset),dest))
      in  (LOCATION (REGISTER (false,I dest)), state)
      end

  fun xlen_dynamic (state,c, con_ir) (vl : term) : term * state =
      let 
	  val _ = Stats.counter("Rtlxlen_dyn")()
	  val dest = alloc_regi NOTRACE_INT
	  val src = load_ireg_term(vl,NONE)
	  val _ = add_instr(LOAD32I(REA(src,~4),dest))
	  val r = con_ir
	  val tmp = alloc_regi NOTRACE_INT
	  val afterl = fresh_code_label "length_after"
	  val floatl = fresh_code_label "length_float"
	  val charl = fresh_code_label "length_char"
	  val _ = (add_instr(BCNDI(EQ, r, IMM 11, floatl, false));
		   add_instr(BCNDI(EQ, r, IMM 0, charl, false));
		   add_instr(SRL(dest,IMM (2+int_len_offset),dest));
		   add_instr(BR afterl);
		   add_instr(ILABEL floatl);
		   add_instr(SRL(dest,IMM real_len_offset,dest));
		   add_instr(BR afterl);
		   add_instr(ILABEL charl);
		   add_instr(SRL(dest,IMM (int_len_offset),dest));
		   add_instr(ILABEL afterl))
      in  (LOCATION (REGISTER (false,I dest)), state)
      end

    (* -----------------  allocation code ---------------------- *)
  fun make_ptag_opt () = 
      if (!HeapProfile) 
	  then let val temp = alloc_regi(NOTRACE_INT)
		   val _ = add_instr(LI(MakeProfileTag(), temp))
	       in  SOME temp
	       end
      else NONE

    fun xarray_float (state, Prim.F32) (_, _) : term * state = error "no 32-bit floats"
      | xarray_float (state, Prim.F64) (vl1, vl2) = (* logical length, float value *)
	let 
	    val len = load_ireg_term(vl1,NONE)
	    val fr = load_freg_term(vl2,NONE)
	    val dest = alloc_regi TRACE
	    val ptag_opt = make_ptag_opt()
	    val skiptag = alloc_regi NOTRACE_INT
	    val tag = alloc_regi(NOTRACE_INT)
	    val i = alloc_regi(NOTRACE_INT)
	    val tmp = alloc_regi(NOTRACE_INT)
	    val gctemp  = alloc_regi(NOTRACE_INT)
	    val fsmall_alloc = fresh_code_label "array_float_smallalloc"
	    val fafter       = fresh_code_label "array_float_after" 
	    val fbottom      = fresh_code_label "array_float_bottom"
	    val ftop         = fresh_code_label "array_float_top"
	    (* store object tag and profile tag with alignment so that
	     raw data is octaligned;  then loop through and initialize *)

	    
	in  (* gctemp is # words needed *)
	    add_instr(ADD(len,REG len, gctemp));
	    (case ptag_opt of
		 NONE => add_instr(ADD(gctemp, IMM 3, gctemp))
	       | SOME _ => add_instr(ADD(gctemp, IMM 4, gctemp)));  
	    (* if array is too large, call runtime to allocate *)
	    let	val tmp' = alloc_regi(NOTRACE_INT)
	    in	add_instr(LI(TilWord32.fromInt (maxByteRequest div 4),tmp'));  (* gctemp in words *)
		add_instr(BCNDI(LE, gctemp, REG tmp', fsmall_alloc, true))
	    end;
	    (* call the runtime to allocate large array *)
	    add_instr(CALL{call_type = C_NORMAL,
			   func = LABEL' (ML_EXTERN_LABEL "alloc_bigfloatarray"),
			   args = (case ptag_opt of 
					NONE => [I len,F fr]
				      | SOME ptag => [I len,I ptag,F fr]),
			   results = [I dest],
			   save = getLocals()});
	    add_instr(BR fafter);
	     
	    (* inline allocation code - start by doing the tag stuff*)
	    add_instr(ILABEL fsmall_alloc);
	    (case ptag_opt of
		 NONE =>
		    (needgc(state,REG gctemp);
		     align_odd_word();
		     mk_realarraytag(len,tag);
		     add_instr(STORE32I(REA(heapptr,0),tag)); (* store tag *)
		     add_instr(ADD(heapptr,IMM 4,dest)))
	       | SOME ptag =>
		    (needgc(state,REG gctemp);
		     align_even_word();
		     add_instr(STORE32I(REA(heapptr,0), ptag));                (* store profile tag *)
		     mk_realarraytag(len,tag);               
		     add_instr(STORE32I(REA(heapptr,4),tag)); (* store tag *)
		     add_instr(ADD(heapptr,IMM 8,dest))));
		
	    (* now use a loop to initialize the data portion *)
	    add_instr(S8ADD(len,REG dest,heapptr));
	    add_instr(LI(Rtltags.skip, skiptag));
	    add_instr(STORE32I(REA(heapptr,0),skiptag));
	    add_instr(ADD(heapptr,IMM 4,heapptr));
	    add_instr(SUB(len,IMM 1,i));       (* init val *)
	    add_instr(BR fbottom);             (* enter loop from bottom *)
	    do_code_align();
	    add_instr(ILABEL ftop);            (* loop start *)
	    add_instr(S8ADD(i,REG dest,tmp));
	    add_instr(STOREQF(REA(tmp,0),fr));  (* initialize value *)
	    add_instr(SUB(i,IMM 1,i));
	    add_instr(ILABEL fbottom);
	    add_instr(BCNDI(GE,i,IMM 0,ftop,true));
	    add_instr(ILABEL fafter);
	    (LOCATION(REGISTER(false, I dest)),
	     new_gcstate state)   (* after all this allocation, we cannot merge *)
	end (* end of floatcase *)


  fun general_init_case(ptag_opt : regi option, (* optional profile tag *)
			tag  : regi,         (* tag *)
			dest : regi,         (* destination register *)
			gctemp : term, (* number of words to increment heapptr by *)
			len : regi,          (* number of words to write *)
			v : regi,            (* write v (len) times *)
			gafter,              (* label to jump to when done *)
			isptr
			) = 
      let 
	  val skiptag      = alloc_regi NOTRACE_INT
	  val tmp          = alloc_regi NOTRACE_INT
	  val i            = alloc_regi NOTRACE_INT
	  val gbottom      = fresh_code_label "array_init_bottom"
	  val gtop         = fresh_code_label "array_init_top"
      in 
	  (case ptag_opt of
	       NONE => (add_instr(ICOMMENT "storing tag");
			add_instr(STORE32I(REA(heapptr,0),tag)); (* allocation *)
			add_instr(ADD(heapptr,IMM 4,dest)))
	     | SOME ptag => (add_instr(STORE32I(REA(heapptr,0), ptag));
			     add_instr(STORE32I(REA(heapptr,4),tag)); (* allocation *)
			     add_instr(ADD(heapptr,IMM 8,dest))));
	       
	   (* gctemp's contents reflects the profile tag already *)
	   (case gctemp of
		   (VALUE (INT n)) => add_instr(ADD(heapptr, IMM (4*(w2i n)), heapptr))
		  | _ => let val gctemp = load_ireg_term(gctemp,NONE)
			 in  add_instr(S4ADD(gctemp,REG heapptr,heapptr))
			 end);

	    add_instr(LI(Rtltags.skip, skiptag));
	    add_instr(STORE32I(REA(heapptr,0),skiptag));
	    add_instr(SUB(len,IMM 1,i));  (* init val and enter loop from bot *)
	    add_instr(BR gbottom);
	    do_code_align();
	    add_instr(ILABEL gtop);        (* top of loop *)
	    add_instr(S4ADD(i,REG dest,tmp));
	    if isptr
		then add_instr(MUTATE(REA(tmp,0),v,NONE))
	    else add_instr(STORE32I(REA(tmp,0),v)); (* allocation *)
	    add_instr(SUB(i,IMM 1,i));
	    add_instr(ILABEL gbottom);
	    add_instr(BCNDI(GE,i,IMM 0,gtop,true));
	    add_instr(ILABEL gafter)
      end

    fun xarray_int (state,is) (vl1,vl2) : term * state = 
	    let val dest  = alloc_regi TRACE
		val gctemp  = alloc_regi(NOTRACE_INT)
		val i       = alloc_regi(NOTRACE_INT)
		val field = load_ireg_term(vl2,NONE)
		val loglen = load_ireg_term(vl1,NONE)
		val ptag_opt = make_ptag_opt()

		val _ = add_instr(ICOMMENT "initializing int/ptr array start")
		(* bytelen - the logical length of the array in bytes which is used by alloca_bigintarray
		   wordlen - the physical length of the array in words - note padding
		   value - word value with wihch the array needs to be filled *)
		val (bytelen,wordlen,word) = 
		    (case is of
		         (* Byte arrays and vectors have the same format.  Since they are word aligned,
			    there can 1 to 3 extra bytes left over.  These should not be used by
			    the mutator and cannot be relied on by the mutator to contain anything.
			    Specifically, they are not necessarily zero.  Consequentaly, ML strings
			    which are byte vectors are not the same as C strings. To make ML strings
			    compatiable with C strings, we would not only have to null-terminate but also
			    to introduce an extra word when the logical string length is a multiple of 4. *)
			 Prim.W8 => 
			     let val word = alloc_regi NOTRACE_INT
				 val wordlen = alloc_regi NOTRACE_INT
				 val tmp     = alloc_regi NOTRACE_INT
				 val tmp2    = alloc_regi NOTRACE_INT
				 val _ = (add_instr(ADD(loglen,IMM 3,tmp));      (* tmp = loglen + 3 *)  
					  add_instr(SRL(tmp,IMM 2,wordlen));     (* wordlen = (loglen + 3)/4 *)
					  add_instr(SLL(field,IMM 8,tmp2));      (* tmp2 = 00b0 where b is the byte *)
					  add_instr(ORB(tmp2,REG field,tmp2));   (* tmp2 = 00bb *)
					  add_instr(SLL(tmp2,IMM 16, word));     (* word = bb00 *)
					  add_instr(ORB(word,REG tmp2,word)))    (* word = bbbb *)
			     in  (loglen,wordlen,word)
			     end
		       | Prim.W16 => error "Prim.W16 is not implemented"
		       | Prim.W32 => (let val bytelen = alloc_regi NOTRACE_INT
				      in  add_instr(SLL(loglen,IMM 2, bytelen)); (* bytelen = loglen * 4  *)
					  (bytelen,loglen,field)
				      end)
		       | Prim.W64 => error "Prim.W64 not implemented")
		val gafter = fresh_code_label "array_int_after"
		val ismall_alloc = fresh_code_label "array_int_small"
		val _ = add_instr(CMPUI(EQ,loglen,IMM 0, gctemp))
		val _ = add_instr(ADD(gctemp,IMM 1, gctemp))
		val _ =  add_instr(ADD(gctemp,REG wordlen, gctemp))
		val _ = if (!HeapProfile)
			    then add_instr(ADD(gctemp, IMM 1, gctemp))
			else ()
		val _ = let val tmp = alloc_regi(NOTRACE_INT)
			in  add_instr(LI(TilWord32.fromInt (maxByteRequest div 4),tmp));
			    add_instr(BCNDI(LE, gctemp, REG tmp, ismall_alloc, true))
			end
		val _ = add_instr(CALL{call_type = C_NORMAL,
				    func = LABEL' (ML_EXTERN_LABEL "alloc_bigintarray"),
				    args = (case ptag_opt of
						 NONE => [I bytelen,I word]
					       | SOME ptag => [I bytelen, I word, I ptag]),
				    results = [I dest],
				    save = getLocals()})
		val _ = add_instr(BR gafter)
		val _ = do_code_align()
		val _ = add_instr(ILABEL ismall_alloc)
		val _ = needgc(state,REG gctemp)
		val tag = alloc_regi(NOTRACE_INT)
		val _ = mk_intarraytag(bytelen,tag)
		val _ = general_init_case(ptag_opt,tag,dest,
					  LOCATION(REGISTER(false,I gctemp)),
					  wordlen,word,gafter,false)
		val _ = add_instr(ICOMMENT "initializing intarray end")
		val state = new_gcstate state   (* after all this allocation, we cannot merge *)
	    in  (LOCATION(REGISTER(false, I dest)), state)
	    end

     fun xarray_ptr (state,c) (vl1,vl2) : term * state = 
	    let val tag = alloc_regi(NOTRACE_INT)
		val dest = alloc_regi TRACE
		val gctemp  = alloc_regi(NOTRACE_INT)
		val i       = alloc_regi(NOTRACE_INT)
		val tmp     = alloc_regi(LOCATIVE)
		val ptag_opt = make_ptag_opt()
		val len = load_ireg_term(vl1,NONE)
		val v = load_ireg_term(vl2,NONE)
		val gafter = fresh_code_label "array_ptr_aftert"
		val psmall_alloc = fresh_code_label "array_ptr_alloc"
		val state = new_gcstate state
	    in   add_instr(CMPUI(EQ,len,IMM 0, gctemp));
		 add_instr(ADD(gctemp,IMM 1, gctemp));
		 add_instr(ADD(gctemp,REG len, gctemp));
		 if (!HeapProfile)
		     then add_instr(ADD(gctemp, IMM 1, gctemp))
		 else ();
		 let
		     val tmp' = alloc_regi(NOTRACE_INT)
		 in
		     add_instr(LI(TilWord32.fromInt (maxByteRequest div 4),tmp'));
		     add_instr(BCNDI(LE, gctemp, REG tmp', psmall_alloc, true))
		 end;
		 add_instr(CALL{call_type = C_NORMAL,
				func = LABEL' (ML_EXTERN_LABEL "alloc_bigptrarray"),
				args = (case ptag_opt of
					    NONE => [I len, I v]
					  | SOME ptag => [I len, I v,I ptag]),
				results = [I dest],
				save = getLocals()});
		 add_instr(BR gafter);
		 do_code_align();
		 add_instr(ILABEL psmall_alloc);
		 needgc(state,REG gctemp);
		 mk_ptrarraytag(len,tag);
		 general_init_case(ptag_opt,tag,dest,
				   LOCATION(REGISTER(false,I gctemp)),
				   len,v,gafter,true);
		 (* after all this allocation, we cannot merge *)
		 (LOCATION(REGISTER(false, I dest)), new_gcstate state)
	    end

  fun xarray_known(state, c) vl_list : term * state =
      let
	  val is_ptr =
	      (case #2(simplify_type state c) of
		   Prim_c(Sum_c{totalcount,tagcount,...},_) => totalcount <> tagcount
		 | _ => true)
      in  if  is_ptr
	      then xarray_ptr(state, c) vl_list
	  else xarray_int(state,Prim.W32) vl_list
      end

  (* if we allocate arrays statically, we must add labels of pointer arrays to mutable_objects *)
 and xarray_dynamic (state,c, con_ir) (vl1 : term, vl2 : term) : term * state =
    let 
	val _ = Stats.counter("Rtlxarray_dyn")()
	val dest = alloc_regi TRACE
	val r = con_ir
	val tmp = alloc_regi NOTRACE_INT
	val afterl = fresh_code_label "array_after"
	val floatl = fresh_code_label "array_float"
	val intl = fresh_code_label "array_int"
	val charl = fresh_code_label "array_char"
	val _ = (add_instr(BCNDI(EQ, r, IMM 11, floatl, false));
		 add_instr(BCNDI(EQ, r, IMM 2, intl, false));
		 add_instr(BCNDI(EQ, r, IMM 0, charl, false)))
	val ptr_state = 
	    let val (term,state) = xarray_ptr(state,c) (vl1,vl2)
		val LOCATION(REGISTER(_, I tmp)) = term
		val _ = add_instr(MV(tmp,dest))
	    in  state 
	    end
	val _ = add_instr(BR afterl)
	    
	val _ = add_instr(ILABEL intl)
	val int_state = 
	    let val (term,state) = xarray_int(state,Prim.W32) (vl1,vl2)
		val LOCATION(REGISTER(_, I tmp)) = term
		val _ = add_instr(MV(tmp,dest))
	    in  state 
	    end
	val _ = add_instr(BR afterl)
	    
	val _ = add_instr(ILABEL charl)
	val char_state = 
	    let val (term,state) = xarray_int(state,Prim.W8) (vl1,vl2)
		val LOCATION(REGISTER(_, I tmp)) = term
		val _ = add_instr(MV(tmp,dest))
	    in  state 
	    end
	val _ = add_instr(BR afterl)
	    
	val _ = add_instr(ILABEL floatl)
	val temp = load_ireg_term(vl2,NONE)
	val fr = alloc_regf()
	val _ = add_instr(LOADQF(REA(temp,0),fr))
	    
	val float_state = 
	    let val vl2 = LOCATION(REGISTER(false, F fr))
		val (term,state) = xarray_float(state,Prim.F64) (vl1,vl2)
		val LOCATION(REGISTER(_, I tmp)) = term
		val _ = add_instr(MV(tmp,dest))
	    in  state
	    end
	val _ = add_instr(ILABEL afterl)
	val state = join_states [float_state, int_state, char_state, ptr_state]
    in  (LOCATION (REGISTER (false,I dest)), state)
    end




end