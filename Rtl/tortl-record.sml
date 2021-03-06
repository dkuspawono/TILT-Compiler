structure TortlRecord :> TORTL_RECORD =
struct

   (* Module-level declarations *)


    open Rtl
    open TortlBase

    fun error s = Util.error "tortl-record.sml" s

    val do_reject_nonValue = Stats.tt("Reject_NonValue")
    val debug = Stats.ff("TortlRecordDebug")

    val empty_record_int = 256
    val empty_record = VALUE (TAG 0w256)
    val maxRtlRecord = TortlBase.maxRtlRecord


    (* record_tag_from_reps : rep list -> term                                                 *)
    (* record_tag_from_reps generates code to compute the tag word for a record, given the rep's of *)
    (* its components.  The degenerate cases are the empty record, which does not need a tag,  *)
    (* and records that are too long to be allocated in one shot.  It is harmless to call      *)
    (* make_record_tag in these cases, but of course we do not want to try to use the resulting *)
    (* tag word  for anything.                                                                 *)
    fun record_tag_from_reps reps =
      let
	fun tag_to_term ({static,dynamic} : Rtltags.tag) : term =
	  (if null dynamic then VALUE (INT static)
	   else let val r = alloc_regi (NOTRACE_INT)
		in add_instr (LI(static,r));
		  add_dynamic (r,dynamic);
		  LOCATION(REGISTER (false,I r))
		end)
	val len = length reps
      in
	if len = 0 then VALUE (INT 0w0)  (* Some arbitrary thing *)
	else if len > maxRtlRecord then VALUE (INT 0w0) (* Some other thing *)
	     else tag_to_term (Rtltags.recordtag reps)
      end

  fun make_record_core_with_tag (const, state, tagword : term, terms, labopt) =
    let
	val numTerms = length terms
	val _ = if (numTerms > maxRtlRecord)
		    then error "max_record_core given too maxn terms" else ()
	val _ = add_instr(ICOMMENT ("allocating " ^ (Int.toString (length terms)) ^ "-record"))

	val heapCount = ref 0
	val nonHeapCount = ref 0
	val dest = alloc_regi TRACE

        (* total number of words needed *)
	val words_alloced = numTerms + 1 (* 1 for tag word. *)

	(* shadow heapptr with thunk to prevent accidental use *)
	val (heapptr,state) =
	    if const
		then let fun f _ = error "should not use heapptr here"
		     in (add_data(COMMENT "static record tag");
			 (f, state))
		     end
	    else let val state = needalloc(state,IMM(words_alloced))
		 in  (fn _ => heapptr, state)
		 end

	(* use if statically allocated *)
	val recordLabel = (case labopt of
			       NONE => fresh_data_label "record"
			     | SOME l => l)
	val staticComponents = (Listops.andfold (fn VALUE _ => true
						 | _ => false) (tagword::terms))

	(* The tag word comes first. *)
	val _ =
	  if const then
	    if staticComponents then
	      (* Everything in the record is static; we should just know the tag word. *)
	      case tagword of
		VALUE (INT i) => add_data (INT32 i)
	      | _ => error "making constant record with dynamic tag" (* This can't happen. joev *)
	    else
	      (* Record will be initialized at run time.  Until then, its tag word is a skip. *)
	      let val _ = add_data(INT32 (Rtltags.skip (1 + numTerms)))
		  val r = load_ireg_term(tagword,NONE)
	      in  add_instr(STORE32I(LEA(recordLabel,~4),r))
	      end
	  else
	    (* Dynamic heap allocation. *)
	    let val r = load_ireg_term(tagword,NONE)
	    in
	      add_instr(STORE32I(REA(heapptr(),0),r))
	    end

        (* Two separate loops, one for the constant case, one for the heap. *)
	(* Note: in both cases, offset starts from the point of allocation not from start of the object *)
	local
	  fun scan_vals_const (offset,[],acc) = rev acc
	    | scan_vals_const (offset,vl::vls,acc) =
	    let
	      val vl = 
		case vl of
		  VALUE v => 
		    let
		      val _ = (nonHeapCount := 1 + !nonHeapCount;
			       (case v of
				  (INT w32) => add_data(INT32 w32)
				| (TAG w32) => add_data(INT32 w32)
				| (RECORD (l,_)) => add_data(DATA l)
				| (LABEL l) => add_data(DATA l)
				| (CODE l) => add_data(DATA l)
				| (REAL l) => error "make_record_core given REAL"
				| (VOID _) => add_data(INT32 0w0) (* 0 is an ok bit pattern for any trace. *)
				    ))
		    in v
		    end
		| _ => 
		    let val nonheap = repIsNonheap (term2rep vl)
		      val _ = if nonheap then nonHeapCount := 1 + !nonHeapCount
			      else heapCount := 1 + !heapCount;
		      val r = load_ireg_term(vl,NONE)
		      val _ = (add_data(INT32 Rtltags.uninitVal);
			       add_instr(STORE32I(LEA(recordLabel,offset - 4), r)))
		    in INT Rtltags.uninitVal
		    end
	    in
	      scan_vals_const(offset+4,vls,vl::acc)
	    end

	  fun scan_vals_heap (offset,[]) = offset
	    | scan_vals_heap (offset,vl::vls) =
	    let val r = load_ireg_term(vl,NONE)
	    in add_instr (STORE32I(REA(heapptr(),offset),r));
	      scan_vals_heap(offset+4,vls)
	    end
	in
	  val scan_vals = fn vls => scan_vals_heap(4,vls)
	  val scan_vals_const = fn vls => scan_vals_const (4,vls,[])
	end

      val result =
	if const then
	  let 
	    val _ = add_data(DLABEL recordLabel)
	    val vls = scan_vals_const terms
	      (* The values of nonHeapCount and heapCount are meaningless until after scan_vals *)
	    val _ = add_static_record (recordLabel,!nonHeapCount,!heapCount)
	  in (VALUE(RECORD( recordLabel, vls)))
	  end
	else
	  let val offset = scan_vals terms
	  in
	    add (heapptr(),4,dest);
	    add (heapptr(),4*words_alloced,heapptr());
	    LOCATION (REGISTER (false,I dest))
	  end

      val _ = add_instr(ICOMMENT ("done allocating " ^ (Int.toString (length terms)) ^ " record"));

    in
      (result, state)
    end


  fun make_record_core (const, state, reps, terms, labopt) =
    let val tagword = record_tag_from_reps reps
    in make_record_core_with_tag (const,state,tagword,terms,labopt)
    end

  fun propagate_void l =
    (case l
       of [] => NONE
	| ((VALUE (VOID _))::_) => SOME (VALUE(VOID Rtl.TRACE))
	| (_::rest) => propagate_void rest)

  fun make_record_help (const, state, reps, [], _) = (empty_record, state)
    | make_record_help (const, state, reps, terms, labopt) =
      let fun loop (state,reps,terms,labopt) =
	  if (length terms < maxRtlRecord)
	      then make_record_core(const, state, reps, terms, labopt)
	  else let fun split(ls,n) = (List.take(ls,n), List.drop(ls,n))
		   val (terms1,terms2) = split(terms,maxRtlRecord-1)
		   val (reps1,reps2) = split(reps,maxRtlRecord-1)
		   val (record2,state) = loop (state,reps2,terms2,NONE)
		   val terms = terms1 @ [record2]
		   val reps = reps1 @ [TRACE]
	       in  make_record_core(const,state, map term2rep terms, terms, labopt)
	       end
      in case propagate_void terms
	   of SOME v => (v,state)
	    | NONE => loop (state,reps,terms,labopt)
      end

  fun make_record_help_with_tag (const,state,tagword,[],_) = (empty_record, state)
    | make_record_help_with_tag (const,state,tagword,terms,labopt) =
    if length terms < maxRtlRecord then
      case propagate_void terms
	of SOME v => (v,state)
	 | NONE => make_record_core_with_tag (const,state,tagword,terms,labopt)
    else (* The precomputed tag is worthless; just do it the hard way. *)
      make_record_help (const,state,map term2rep terms,terms,labopt)

  fun is_value_nonCompute terms =
      let val reps = map term2rep terms
	  fun loop (vFlag,ncFlag) [] = (vFlag,ncFlag,reps)
	    | loop (vFlag,ncFlag) ((term,rep)::rest) =
	      let val vFlag = vFlag andalso (case term of
						 VALUE _ => true
					       | _ => false)
		  val ncFlag = ncFlag andalso (case rep of
						   COMPUTE _ => false
						 | _ => true)
	      in  loop (vFlag,ncFlag) rest
	      end
      in  loop (true,true) (Listops.zip terms reps)
      end

  fun make_record_with_tag (state,tagword,terms) =
    let val (allValues, noComputes,_) = is_value_nonCompute terms
      val const = noComputes andalso (if (!do_reject_nonValue)
					then allValues
				      else (istoplevel() orelse allValues))
    in make_record_help_with_tag(const,state,tagword,terms,NONE)
    end

  (* These are the interface functions: determines static allocation *)
  fun make_record (state, terms) =
      let val (allValues, allNonComputes, reps) = is_value_nonCompute terms
	  val const = allNonComputes andalso (if (!do_reject_nonValue)
						  then allValues
					      else (istoplevel() orelse allValues))
      in  make_record_help(const,state,reps,terms,NONE)
      end

  fun make_record_const (state, terms, labopt) =
      let val (allValues, allNonComputes, reps) = is_value_nonCompute terms
	  val const = allNonComputes andalso (allValues orelse not (!do_reject_nonValue))
	  val res as (lv,_) = make_record_help(const,state, reps, terms, labopt)
	  val labopt2 = (case lv of
			     VALUE(RECORD(lab,_)) => SOME lab
			   | _ => NONE)
	  val _ = (case (labopt,labopt2) of
		       (NONE,_) => ()
		     | (SOME lab, SOME lab') =>
			   if (Rtl.eq_label(lab,lab'))
			       then () else error "make_record_const failed"
		     | _ => error "make_record_const failed")
      in  res
      end

  fun make_record_mutable_with_tag (state,tagword,terms) =
    make_record_help_with_tag(false,state,tagword,terms,NONE)

  fun make_record_mutable (state, terms) =
      let val reps = map term2rep terms
      in  make_record_help(false,state,reps,terms,NONE)
      end

  (* Record_insert takes 4 arguments: (1) a totrl state, (2) a record r : TRACE, (3) a type rt where r : rt,
                                      (4) a value v : NOTRACE_INT
        Reutrn a record r' whose first field is v and whose remaining fields are those of r.
	Note that (length of r < maxRtlRecord) and (length of r' < maxRecord).
	Note that r may be the empty record, requiring special treatment.
  *)

  fun record_insert (state,record : regi, recType : regi, field : regi) : state * regi =
      let
	  val state = needalloc(state,IMM (1+Rtltags.maxRecordLength)) (* one more for tag word *)

	  val len = alloc_regi NOTRACE_INT
	  val mask = alloc_regi NOTRACE_INT

	  (* Empty record are not pointer and have no tag *)
          val afterLenMask = fresh_code_label "afterLenMask"
	  val _ = add_instr(LI(0w0,len))
	  val _ = add_instr(LI(0w0,mask))
	  val _ = add_instr(BCNDSI(EQ,record,IMM empty_record_int,afterLenMask,false))
	  (* Non-empty record required tag extraction to compute len and mask *)
	  val tag = alloc_regi NOTRACE_INT
	  val tmp = alloc_regi NOTRACE_INT
	  val _ = add_instr(LOAD32I(REA(record,~4),tag))
	  val _ = add_instr(SRL(tag, IMM Rtltags.rec_len_offset, tmp))
	  val _ = add_instr(ANDB(tmp, IMM Rtltags.rec_len_mask, len))
	  val _ = add_instr(SRL(tag, IMM Rtltags.rec_mask_offset, mask))
	  val _ = add_instr(ILABEL afterLenMask)

	  (* Creating the new tag - Relies on all non-pointer types represented by 3 or less *)
	  val newmask = alloc_regi NOTRACE_INT
	  val _ = add_instr(SLL(mask, IMM 1, newmask))                  (* make room at the least significant end *)
	                                                                (* new slot is for an int so leave it unset *)
	  val newlen = alloc_regi NOTRACE_INT
	  val _ = add_instr(ADD(len, IMM 1, newlen))
	  val _ = if (Rtltags.record = 0w0) then () else error "record_insert relies on record aspect being zero"
	  val newtag = alloc_regi NOTRACE_INT
	  val _ = add_instr(ORB(newmask, REG newlen, newtag))
	  val _ = add_instr(STORE32I(REA(heapptr, 0), newtag))           (* write new tag *)
	  val _ = add_instr(STORE32I(REA(heapptr, 4), field))            (* write first field v *)

	  (* Now initialize the remaining fields *)
	  val copyLoop = fresh_code_label "copyLoop"
	  val afterLoop = fresh_code_label "afterLoop"
	  val current = alloc_regi NOTRACE_INT                       (* When entering the loop, current contains
								        one more than the index of the field in r
									we are copying *)
	  val _ = add_instr(MV(len, current))
	  val _ = add_instr(ILABEL copyLoop)
	  val _ = add_instr(BCNDSI(EQ,current, IMM 0, afterLoop, false))
	  val _ = add_instr(SUB(current, IMM 1, current))
	  val rLoc = alloc_regi LOCATIVE
	  val rTypeLoc = alloc_regi LOCATIVE
	  val destLoc = alloc_regi TRACE
	  val curFieldType = alloc_regi TRACE
	  val curField = alloc_regi (COMPUTE (Projvar_p (curFieldType, [])))
	  val _ = add_instr(S4ADD(current, REG record, rLoc))
	  val _ = add_instr(S4ADD(current, REG recType, rTypeLoc))
	  val _ = LOAD32I(REA(rTypeLoc, 4), curFieldType) (* First word is tag *)
	  val _ = LOAD32I(REA(rLoc, 0), curField)
	  val _ = add_instr(ADD(heapptr, IMM 8, destLoc))
	  val _ = add_instr(S4ADD(current, REG destLoc, destLoc))
	  val _ = STORE32I(REA(destLoc, 0), curField)
	  val _ = add_instr(BR copyLoop)
	  val _ = add_instr(ILABEL afterLoop)

	  (* Return result and update heap pointer *)
	  val dest = alloc_regi TRACE
	  val _ = add_instr(ADD(heapptr, IMM 4, dest))
	  val _ = add_instr(S4ADD(newlen, REG dest, heapptr))
      in  (state,dest)
      end

  fun record_delete (record : regi) : regi = error "record_delete not done"

end
