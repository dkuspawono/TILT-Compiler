(*$import Rtl Pprtl Rtltags Nil NilContext NilUtil Ppnil Normalize TORTLBASE Listops Stats Bool *)

(* 258 is the value for an uninitialied slot *)

structure TortlBase
    :> TORTL_BASE 
   =
struct

   (* Module-level declarations *)

    open Util Listops
    open Nil
    open NilUtil
    open Rtl
    open Name
    open Rtltags 
    open Pprtl 
    type label = Rtl.label
    fun error s = Util.error "tortl-base.sml" s
    structure TW32 = TilWord32
    structure TW64 = TilWord64

    val do_constant_records = ref true
    val do_forced_constant_records = ref true
    val do_gcmerge = ref true
    val do_single_crecord = ref true
    val diag = ref true
    val debug = Stats.ff("TortlBaseDebug")
    val debug_simp = Stats.ff("tortl_base_debug_simp")
    val debug_bound = ref false
    val maxGCRequest = 2048  (* Measured in words *)

   (* ------------------ Overall Data Structures ------------------------------ *)
    
   (* A NIL variable is represented at the RTL level as one of:
     (1) a local RTL register
     (2) a global variable 
     (3) a label (either local or extern)
     (4) a code label
     In addition, in some cases, we know that the value of the variable is:
     (1) a constant integer
     (2) a constant real
     (3) a constant record which is always laid out at the given label
           Note that it is the responsibility of the caller of the constructor
	     to lay out the record.
           Components are identified by the variable names.
  	   Perform a lookup to determine if the subcomponents are constants or not.
   *)


    datatype location =
	REGISTER of bool * reg   (* flag indicates whether value is constant *)
      | GLOBAL   of label * rep  (* value resides at this label: includes unboxed real *)

    datatype value =
	VOID of rep             (* an undefined values *)
      | INT of TilWord32.word   (* an integer *)
      | TAG of TilWord32.word   (* a traceable small pointer value *)
      | REAL of label           (* an unboxed real at given label *)
      | RECORD of label * value list (* a record whose components are at the given label *)
      | LABEL of label          (* the value of this label: e.g. boxed real *)
      | CODE of label           (* code that residing at this label *)
	
   datatype term = LOCATION of location
                 | VALUE of value

   type var_rep     = location option * value option
   type convar_rep  = location option * value option 

   type varmap = var_rep VarMap.map
   type convarmap = convar_rep VarMap.map
   val uninit_val = 0w258 : TilWord32.word

   datatype gcinfo = GC_IMM of instr ref | GC_INF
   type gcstate = gcinfo list

  (* ----- Global data structures ------------------------------
   dl: list of data for module
   pl: list of procedures for the entire module
   mutable : addresses of global objects that may contain pointers to heap objects
   gvarmap: how a top-level NIL code variable is represented at the RTL level
   gconvarmap: how a top-level NIL code type variable is represented at the RTL level
   varmap: how a NIL variable is represented at the RTL level
   convarmap: how a NIL typevariable is represented at the RTL level
   ------------------------------------------------------------- *)

   exception NotFound
   val exports = ref (Name.VarMap.empty : (Rtl.label list) Name.VarMap.map)
   val globals = ref VarSet.empty
   val dl : Rtl.data list ref = ref nil
   val pl : Rtl.proc list ref = ref nil
   type suminfo     = TilWord32.word * TilWord32.word option * con list
   type state = {is_top : bool,
		 env : NilContext.context * suminfo option ref VarMap.map,
		 varmap : varmap,
		 convarmap : convarmap,
		 gcstate : gcstate}
   fun make_state() : state = {is_top = true,
			       env = (NilContext.empty(), VarMap.empty),
			       varmap = VarMap.empty,
			       convarmap = VarMap.empty,
			       gcstate = [GC_INF]}
   val global_state : state ref = ref (make_state())

   fun stat_state ({convarmap,...} : state) = 
       (VarMap.appi (fn (v,_) => (Ppnil.pp_var v; print " ")) convarmap; print "\n\n")
   fun show_state ({env,...} : state) = 
       (print "Showing environment part of state:\n";
	NilContext.print_context (#1 env);
	print "\n\n")

   local
       val mutable : label list ref = ref nil
   in  fun add_mutable lr = mutable := lr :: !mutable
       fun get_mutable() = !mutable
       fun reset_mutable() = mutable := nil
   end
   fun add_proc p = pl := p :: !pl


  fun type_of ({env,...}:state) e = 
      Stats.subtimer("RTL_typeof",Normalize.type_of)(#1 env,e)

  fun std_kind_of ({env,...}:state) c =
      Stats.subtimer("RTL_kind_of",NilContext.kind_of) (#1 env,c)

  val codeAlign = ref (Rtl.OCTA)
  fun do_code_align() = () (* add_instr(IALIGN (!codeAlign)) *)


  (* ---- Looking up and adding new variables --------------- *)

  fun top_rep (vl : location option, vv : value option) =
      (case (vl,vv) of
 	   (SOME(GLOBAL _),_) => true 
	 | (_, SOME _) => true
	 | _ => false)
(*	 | _ => (VarSet.member(!globals,v))) *)

  fun varmap_insert' ({is_top,varmap,
		       env,convarmap,gcstate} : state) (v,(lc,lv,c)) : state = 
      let val _ = if (!debug_bound)
		      then (print "varmap adding to v = "; 
			    Ppnil.pp_var v; print "\n")
		  else ()
	  val _ = case (VarMap.find(varmap,v)) of
		  NONE => ()
		| SOME _ => error ("varmap already contains "
					    ^ (Name.var2string v))
	  val env = (NilContext.insert_con(#1 env,v,c), #2 env)
	  val varmap = VarMap.insert(varmap,v,(lc,lv))
      in  {is_top=is_top,env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
      end
  
  fun varmap_insert_eq' ({is_top,varmap,
		       env,convarmap,gcstate} : state) (v,(lc,lv,e)) : state = 
      let val _ = if (!debug_bound)
		      then (print "varmap adding to v = "; 
			    Ppnil.pp_var v; print "\n")
		  else ()
	  val _ = case (VarMap.find(varmap,v)) of
		  NONE => ()
		| SOME _ => error ("varmap already contains "
					    ^ (Name.var2string v))
	  val env = (NilContext.insert_exp(#1 env,v,e), #2 env)
	  val varmap = VarMap.insert(varmap,v,(lc,lv))
      in  {is_top=is_top,env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
      end
  
  fun varmap_insert state (arg as (_,(vl,vv,_))) =
      (if (top_rep(vl,vv))
	   then global_state := varmap_insert' (!global_state) arg
       else ();
	varmap_insert' state arg)

  fun varmap_insert_eq state (arg as (_,(vl,vv,_))) =
      (if (top_rep(vl,vv))
	   then global_state := varmap_insert_eq' (!global_state) arg
       else ();
	varmap_insert_eq' state arg)

  fun convarmap_insert' ({is_top,convarmap,varmap,env,gcstate}:state) 
                        (v,(vl,vv,k)) : state = 
      let val _ = if (!debug_bound)
		      then (print "convar adding to v = "; Ppnil.pp_var v; print "\n")
		  else ()
	  val _ = (case (VarMap.find(convarmap,v)) of
		       NONE => ()
		     | SOME _ => error ("convarmap already contains "
						 ^ (Name.var2string v)))
	  val convarmap = VarMap.insert(convarmap,v,(vl,vv))
      in  {is_top=is_top,env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
      end
  

  fun env_insert' ({is_top,env,varmap,convarmap,gcstate} : state) (v,k) : state = 
      let val _ = if (!debug_bound)
		      then (print "env adding v = ";
			    Ppnil.pp_var v; print "\n")
		  else ()
	  val newenv = (NilContext.insert_kind(#1 env,v,k),
			VarMap.insert(#2 env, v, ref NONE))
	  val newstate = {is_top=is_top,env=newenv,
			  varmap=varmap,convarmap=convarmap,gcstate=gcstate}
      in  newstate
      end

  fun convarmap_insert state (arg as (v,(vl,vv,k))) =
      let val state = convarmap_insert' state arg
	  val state = env_insert' state (v,k)
	  val _ = if (#is_top state)
	      (* top_rep (vl,vv) *)
		      then let val gs = convarmap_insert' (!global_state) arg
			       val gs = env_insert' gs (v,k)
			   in  global_state := gs
			   end
		  else ()
      in  state
      end

  
  fun add_term (s,v,con,LOCATION loc) = varmap_insert s (v,(SOME loc,NONE,con))
    | add_term (s,v,con,VALUE value) = varmap_insert s (v,(NONE, SOME value,con))
  fun add_term_equation (s,v,e,LOCATION loc) = varmap_insert_eq s (v,(SOME loc,NONE,e))
    | add_term_equation (s,v,e,VALUE value) = varmap_insert_eq s (v,(NONE, SOME value,e))
  fun add_reg (s,v,con,reg)         =  add_term (s,v,con,LOCATION(REGISTER(false,reg)))
  fun add_code (s,v,con,l)          =  add_term (s,v,con,VALUE(CODE l))



  (* adding constructor-level variables and functions *)
  fun add_conterm (s,v,kind,NONE) = convarmap_insert s (v,(NONE, NONE, kind))
    | add_conterm (s,v,kind,SOME(LOCATION loc)) = convarmap_insert s (v,(SOME loc, NONE, kind))
    | add_conterm (s,v,kind,SOME(VALUE value)) = convarmap_insert s (v,(NONE, SOME value, kind))

   fun getconvarrep' ({convarmap,...} : state) v = VarMap.find (convarmap,v) 
   fun getconvarrep state v : convar_rep = 
       (case getconvarrep' state v of
	    NONE => error ("getconvarrep: variable "^(var2string v)^" not found")
	  | SOME result => result)

  fun getrep ({varmap=lm,...} : state) v = 
      (case VarMap.find(lm,v) of
	   NONE => error ("getvarrep: variable "^(var2string v)^" not found")
	 | SOME rep => rep)

    (* given a type returns true and a type in head-normal form
       or false and a type not in head-normal form 
       in either case, the returned type is possibly simpler than the argument type *)

    fun simplify_type ({env,...} : state) con : bool * con = 
	let val result = Stats.subtimer("RTL_reduce_hnf",
					Normalize.reduce_hnf)(#1 env,con)
	    val _ = if (!debug_simp)
		    then (print (Real.toString (Stats.fetch_timer_last "RTL_reduce_hnf"));
			  print "s  simplify on\n";  Ppnil.pp_con con;
			  print "\nreduced to\n"; Ppnil.pp_con (#2 result);
			  print "\n")
		    else ()
	in  result
	end


  fun reduce_to_sum str ({env,...}:state) c = 
      let fun slow() = Stats.subtimer("RTL_reduceToSum",Normalize.reduceToSumtype) (#1 env,c)
      in  (case c of
	       Var_c v => 
		   let val SOME cache = VarMap.find(#2 env,v)
		   in  (case (!cache) of
			    SOME suminfo => suminfo
			  | NONE => let val suminfo = slow()
					val _ = cache := SOME suminfo
				    in  suminfo
				    end)
		   end
	     | _ => slow())
      end


  (* Takes a constructor and returns the RTL representation.
     The head-normal form must be statically known. That is, this constructor
     must not involve any computation to determine the RTL representation. *)

  fun cpath2indices (state : state) k labs = 
      let fun loop acc _ [] = rev acc
	    | loop acc (Record_k fields_seq) (label::rest) = 
	  let fun extract acc [] = error "bad Proj_c"
		| extract acc (((l,_),fc)::rest) = 
	      if (eq_label(label,l)) then (fc,acc) else extract (acc+1) rest
	      val fields_list = (Sequence.toList fields_seq)
	      val (con,index) = extract 0 fields_list 
	      val acc = if (!do_single_crecord andalso length fields_list = 1)
			    then acc
			else (index::acc) 
	  in  loop acc con rest
	  end
	    | loop acc (Single_k c) labs = 
	  let val k = Stats.subtimer("RTLkind_of0", NilContext.kind_of) (#1 (#env state),c)
	  in  loop acc k labs
	  end
	    | loop acc (SingleType_k c) labs = 
	  loop acc Type_k labs
	    | loop acc _ labs = error "expect record kind"
      in  loop [] k labs
      end



   fun location2rep(REGISTER(_,I (SREGI HEAPALLOC))) = NOTRACE_INT
     | location2rep(REGISTER(_,I (SREGI HEAPLIMIT))) = NOTRACE_INT
     | location2rep(REGISTER(_,I (SREGI EXNSTACK))) = TRACE
     | location2rep(REGISTER(_,I (SREGI EXNARG))) = TRACE
     | location2rep(REGISTER(_,I (SREGI STACK))) = NOTRACE_INT
     | location2rep(REGISTER(_,I (SREGI THREADPTR))) = NOTRACE_INT
     | location2rep(REGISTER(_,I (SREGI HANDLER))) = NOTRACE_CODE
     | location2rep(REGISTER(_,I (REGI (_,rep)))) = rep
     | location2rep(REGISTER(_,F (REGF (_, NOTRACE_REAL)))) = NOTRACE_REAL
     | location2rep(REGISTER(_,F _)) = error "float reg has weird rep. not NOTRACE_REAL"
     | location2rep(GLOBAL(_,rep)) = rep
   fun value2rep(VOID rep) = rep
     | value2rep(INT _) = NOTRACE_INT
     | value2rep(TAG _) = TRACE
     | value2rep(REAL _) = NOTRACE_REAL
     | value2rep(RECORD _) = TRACE
     | value2rep(LABEL _) = TRACE
     | value2rep(CODE _) = NOTRACE_CODE
   fun term2rep(LOCATION loc) = location2rep loc
     | term2rep(VALUE value) = value2rep value

   fun niltrace2rep (state : state) niltrace : rep =
       let fun pathcase (v,labs) = 
	   (case getconvarrep' state v of
		SOME(_,SOME(RECORD (l,_))) => (COMPUTE(Projlabel_p (l,labs)))
	      | SOME(_,SOME(LABEL l)) => (COMPUTE(Projlabel_p (l,labs)))
	      | SOME(_,SOME(VOID _)) => error "constructor is void"
	      | SOME(_,SOME(REAL _)) => error "constructor represented as  a float"
	      | SOME(_,SOME(CODE _)) => error "constructor function cannot be a type"
	      | SOME(SOME(REGISTER (_,I r)),_) => (COMPUTE(Projvar_p (r,labs)))
	      | SOME(SOME(REGISTER (_,F _)),_) => error "constructor in float reg"
	      | SOME(SOME(GLOBAL (l,_)),_) => (COMPUTE(Projlabel_p(l,0::labs)))
	      | _ => (print "niltrace2rep convar = ";
		      print (var2string v); print "\n";
		      error "no information on this convar!!"))

       in  
	   (case niltrace of
		Nil.TraceUnknown => error "TraceUnknown"
	      | (Nil.TraceCompute v) => pathcase(v,[])
	      | (Nil.TraceKnown t) => 
		    (case t of
			 TraceInfo.Trace => TRACE
		       | TraceInfo.Unset => UNSET
		       | TraceInfo.Notrace_Int => NOTRACE_INT
		       | TraceInfo.Notrace_Code => NOTRACE_CODE
		       | TraceInfo.Notrace_Real => NOTRACE_REAL
		       | TraceInfo.Label => NOTRACE_LABEL
		       | TraceInfo.Locative => LOCATIVE
		       | TraceInfo.Compute (v,labs) => 
			     let val indices = 
				 (case labs of
				      [] => []
				    | _ => let val k = std_kind_of state (Var_c v)
					   in cpath2indices state k labs
					   end)
			     in  pathcase(v,indices)
			     end))
       end



  (* ----- Data structures for the current function being compiled 
   il: list of instructions for the current function being compiled
   localregs : computing SAVE sets for RTL interpreter 
   top: label at top of current function (past prelude code)
   currentfun: the current function being compiled
   argregs : the argument registers  
   ---> If top and currentfun and NONE, then we are at top-level 
        and the register lists will also be empty.   <--- *)



   local
       val istop : bool ref = ref false
       val top : label ref = ref (LOCAL_CODE "dummy_top")
       val currentfun : (var * label) ref = ref (fresh_named_var "dummy_fun",
					       LOCAL_CODE "dummy_fun")
       val resultreg : reg option ref = ref NONE
       val il : (Rtl.instr ref) list ref = ref nil
       val localregs : reg list ref = ref nil
       val returnreg : regi option ref = ref NONE
       val argregs : reg list ref = ref nil
       val curgc : instr ref option ref = ref NONE
       val gcstack : instr ref option list ref = ref []
       fun add_instr' i = il := (ref i) :: !il;
   in  
       fun istoplevel() = !istop
       fun getTop() = !top
       fun getCurrentFun() = !currentfun
       fun getResult thunk = 
	   (case !resultreg of
		SOME r => r
	      | NONE => let val r = thunk()
			    val _ = localregs := (r :: (!localregs))
			    val _ = resultreg := SOME r
			in  r
			end)
       fun getLocals() = !localregs
       fun getArgs() = !argregs

       fun add_data d = dl := d :: !dl

       fun join_states ([] : state list) : state = error "join_states got []"
	 | join_states (({is_top,env,varmap,convarmap,gcstate}) :: rest) = 
	   let val gcstates = gcstate :: (map #gcstate rest)
	       (* we must not have duplicates or else we get exponential blowup 
		  and the updates will also be too large since they are duplicated *)
		fun gcinfo_eq (GC_INF,GC_INF) = true
		  | gcinfo_eq (GC_IMM r1, GC_IMM r2) = r1 = r2
		  | gcinfo_eq _ = false
		fun folder(info,infos) = if (Listops.member_eq(gcinfo_eq,info,infos))
						then infos else info::infos
		val gcstate = foldl (fn (infos,acc) => foldl folder acc infos) [] gcstates
	   in   {is_top=is_top,env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
	   end
       fun shadow_state	({is_top,env,varmap,convarmap,gcstate=_},{gcstate,...}:state) = 
	   {is_top=is_top,env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}

       fun add_instr i = 
	   (add_instr' i;
	    case i of
		NEEDGC _ => error "should use needgc to add a NEEDGC"
	      | _ => ())

       fun needgc(state as {is_top,gcstate,env,convarmap,varmap}:state,operand) : state = 
	 if (not (!do_gcmerge))
	     then (add_instr'(NEEDGC operand); state)
	 else
	     let val mergeImm =
		 (case operand of 
		      IMM m => 
			  let fun loop [] = SOME m
				| loop (GC_INF::_) = NONE
				| loop ((GC_IMM (ref (NEEDGC (IMM n))))::rest) = if (m+n < maxGCRequest)
										     then loop rest
										 else NONE
				| loop ((GC_IMM _)::rest) = error "bad GC_IMM"
			  in  loop gcstate
			  end
		    | _ => NONE)
	     in  (case mergeImm of
		      NONE => let val r = ref(NEEDGC operand)
				  val _ = il := (r :: (!il))
				  val gcinfo = (case operand of
						    IMM _ => GC_IMM r 
						  | _ => GC_INF)
			      in  {is_top=is_top,env=env,convarmap=convarmap,varmap=varmap,
				   gcstate=[gcinfo]}
			      end
		    | SOME m => let fun update(GC_IMM(r as ref(NEEDGC (IMM n)))) = r := (NEEDGC(IMM(m+n)))
				      | update (GC_IMM _) = error "update given bad GC_IMM"
				      | update _ = error "update not given GC_IMM"
				in  (app update gcstate; state)
				end)
	     end

       fun new_gcstate ({is_top,env,varmap,convarmap,gcstate} : state) : state =
	   let val s = {is_top=is_top,env=env,varmap=varmap,convarmap=convarmap,gcstate=[GC_INF]}
	   in  needgc(s,IMM 0)
	   end


       fun alloc_named_regi v traceflag = 
	   let val r = REGI (v,traceflag)
	   in  localregs := (I r) :: (!localregs);
	       r
	   end
       fun alloc_regi (traceflag) = alloc_named_regi (fresh_var()) traceflag

       
       fun alloc_named_regf v = 
	   let val r = REGF (v,NOTRACE_REAL)
	   in  localregs := (F r) :: (!localregs);
	       r
	   end

       fun alloc_regf () = alloc_named_regf (fresh_var())
       
       fun alloc_reg_trace state trace = 
	   let val rep = niltrace2rep state trace
	   in  case rep of
	       NOTRACE_REAL => (rep,F(alloc_regf()))
	     | _ => (rep,I(alloc_regi rep))
	   end

	   

       fun promote_maps ({env,...} : state) : state = 
	   let val {varmap,convarmap,gcstate,...} = !global_state
	   in  {is_top = false, varmap = varmap, 
		convarmap = convarmap, env = env, gcstate = gcstate}
	   end

       fun set_args (args,return) = 
	   (argregs := args;
	    returnreg := SOME return;
	    localregs := (I return) :: args)

       fun reset_state (is_top,names) = 
	   (istop := is_top;
	    currentfun := names;
	    top := fresh_code_label "funtop";
	    il := nil; 
	    do_code_align();
	    add_instr(ILABEL (!top)))



       fun reset_global_state (exportlist,ngset) = 
	   let fun exp_adder((v,l),m) = (case VarMap.find(m,v) of
					     NONE => VarMap.insert(m,v,[l])
					   | SOME ls => VarMap.insert(m,v,l::ls))
	       fun gl_adder(v,s) = VarSet.add(s,v)
	   in  (
		global_state :=  make_state();
		exports := (foldl exp_adder VarMap.empty exportlist);
		globals := ngset;
		dl := nil;
		pl := nil;
		reset_mutable();
		reset_state(false,(fresh_named_var "code", fresh_code_label "code")))
	   end

       fun get_code() = map ! (rev (!il))
       fun get_proc() = 
	let val (_,name) = !currentfun
	    val code =  map ! (rev (!il))
	    val SOME return = !returnreg
	    val results = (case !resultreg of
			       SOME r => [r]
			     | NONE => [])
	in  PROC{name    = name,
		 return  = return,
		 args    = !argregs,
		 results = results,
		 code    = Array.fromList code,
		 known   = false,
		 save    = nil,
		 vars    = NONE}
	end

   end
	   



 

(* ---------  Helper Functions ------------------------------------------- *)
    val w2i = TW32.toInt
    val i2w = TW32.fromInt;

    local
	val counter = ref 10000
    in
	val HeapProfile = ref false
	fun GetHeapProfileCounter() = !counter
	fun SetHeapProfileCounter(x) = counter := x
	fun MakeProfileTag() = 
	    (counter := (!counter) + 1;
	     if (!counter > 65535) 
		 then error "counter must be stored in 16 bits for heap profile"
	     else ();
		 i2w((!counter) - 1))
    end

  fun in_imm_range_vl (VALUE(INT w)) = ((if in_imm_range w then SOME (w2i w) else NONE) handle _ => NONE)
   | in_imm_range_vl (VALUE(TAG w)) = ((if in_imm_range w then SOME (w2i w) else NONE) handle _ => NONE)
    | in_imm_range_vl _ = NONE
  fun in_ea_range scale (VALUE(INT i)) = 
      ((if in_ea_disp_range(w2i i * scale)
	    then SOME (w2i i * scale)
	else NONE)
	    handle _ => NONE)
    | in_ea_range scale (VALUE(TAG i)) = 
      ((if in_ea_disp_range(w2i i * scale)
	    then SOME (w2i i * scale)
	else NONE)
	    handle _ => NONE)
    | in_ea_range _ _ = NONE

 

  val heapptr  = SREGI HEAPALLOC
  val stackptr = SREGI STACK
  val exnptr   = SREGI EXNSTACK
  val exnarg   = SREGI EXNARG


  (* ------------------- End of Helper Functions -------------------------- *)



  (* --------- Tag Operation Helper Functions -------------------- *)

  (* for reals, the len reg measures quads *)

  (* measured in octets *)
  fun mk_realarraytag(len,tag) = 
    (add_instr(SLL(len,IMM (real_len_offset),tag));
     add_instr(ORB(tag,IMM (w2i realarray),tag)))
    
  (* measured in bytes *)
  fun mk_intarraytag(len,tag) = 
    (add_instr(SLL(len,IMM (int_len_offset),tag));
     add_instr(ORB(tag,IMM (w2i intarray),tag)))
    
  (* measured in words *)
  fun mk_ptrarraytag(len,tag) = 
    (add_instr(SLL(len,IMM (ptr_len_offset),tag));
     add_instr(ORB(tag,IMM (w2i ptrarray),tag)))
    
  fun mk_recordtag(flags) = recordtag(flags)
    
  (* storing a tag *)
    
  fun store_tag_zero tag =
    let val tmp = alloc_regi(NOTRACE_INT)
      in add_instr(LI(tag,tmp));
	 add_instr(STORE32I(EA(heapptr,0),tmp)) (* store tag *)
    end
  
  fun store_tag_disp (disp,tag) =
    let val tmp = alloc_regi(NOTRACE_INT)
    in add_instr(LI(tag,tmp));
      add_instr(STORE32I(EA(heapptr,disp),tmp)) (* store tag *)
    end

  (* ----- functions for loading NIL values into RTL registers ----------- *)


  (* ---------------------------------------------------------------------------
   the following are functions that load integer registers or float registers
   or load an sv; for int/float regs, one can optionally specify a dest register *)

    (* --- load an RTL location into an integer register --- *)
    fun load_ireg_loc (loc : location, destOpt : regi option) =
	(case loc of
	     GLOBAL(l,NOTRACE_REAL) => error "load_ireg called with (GLOBAL real)"
	   | GLOBAL(label,rep) =>
		 let val addr = alloc_regi NOTRACE_LABEL
		     val reg = (case destOpt of
				    NONE => alloc_regi rep
				  | SOME d => d)
		 in  add_instr(LADDR(label,0,addr));
		     add_instr(LOAD32I(EA(addr,0),reg));
		     reg
		 end
	   | REGISTER (_,I ir) => (case destOpt of
					NONE => ir
				      | SOME d => (add_instr(MV(ir,d)); d))
	   | REGISTER (_,F _) => error "load_ireg called with (REGISTER (_, F _))")

    
    fun load_ireg_val (value : value, destOpt : regi option) : regi =
      let 
	  fun help(rep,mk_instr) = (case destOpt of
				    NONE => let val r = alloc_regi rep
						val _ = add_instr(mk_instr r)
					    in  r
					    end
				  | SOME d => (add_instr(mk_instr d); d))
      in case value of
	  (* zero is a safe bit-pattern for values of any rep *)
	  VOID rep => help(rep, fn r => LI(0w0,r))
	| INT i => help (NOTRACE_INT, fn r => LI(i,r))
	| TAG i => help (TRACE, fn r => LI(i,r))
	| REAL _ => error "load_ireg: REAL"
	| RECORD(label,_) => help (TRACE, fn r => LADDR(label,0,r))
	| LABEL label => help (NOTRACE_LABEL, fn r => LADDR(label,0,r))
	| CODE label => help (NOTRACE_CODE, fn r => LADDR(label,0,r))
      end


    fun mk_named_float_data (r : string, label : label) =
	(add_data(ALIGN ODDLONG);
	 add_data(INT32 (realarraytag (i2w 1)));
	 add_data(DLABEL label);
	 add_data(FLOAT r))
	
    fun mk_float_data (r : string) : label =
	let val label = fresh_data_label "floatdata"
	    val _ = mk_named_float_data (r,label)
	in label
	end
  
    fun load_freg_loc (rep : location, destOpt : regf option) : regf =
      let 
	  val dest = (case destOpt of
			  NONE => alloc_regf()
			| SOME d => d)
      in case rep of
	  (REGISTER (_,F r)) => (case destOpt of
				      NONE => r
				    | _ => (add_instr(FMV(r,dest)); dest))
	| (REGISTER (_,I r)) => error "load_freg_loc called on REGISTER (_, I _)"
	| (GLOBAL (l,NOTRACE_REAL)) =>
	      let val addr = alloc_regi NOTRACE_LABEL
	      in  add_instr(LADDR(l,0,addr));
		  add_instr(LOADQF(EA(addr,0),dest));
		  dest
	      end
	| (GLOBAL _) => error "load_freg_loc: got GLOBAL(_, non-NOTRACE_REAL)"
      end

    fun load_freg_val (rep : value, destOpt : regf option) : regf =
	(case rep of
	     VOID rep => (print "WARNING: load_freg on VOID\n"; alloc_regf())
	   | REAL label => 
		 let val addr = alloc_regi TRACE
		     val r = (case destOpt of
				  NONE => alloc_regf()
				| SOME d => d)
		 in  add_instr(LADDR(label,0,addr));
		     add_instr(LOADQF(EA(addr,0),r));
		     r
		 end
	   | INT _ => error "load_freg_val: got INT"
	   | TAG _ => error "load_freg_val: got TAG"
	   | RECORD _ => error "load_freg_val: got RECORD"
	   | LABEL _ => error "load_freg_val: got LABEL"
	   | CODE _ => error "load_freg_val: got CODE")

    fun load_reg_loc (rep : location, destopt : reg option) : reg = 
	let val rep_is_float = (case rep of
				    REGISTER (_, F _) => true
				  | GLOBAL (_, NOTRACE_REAL) => true
				  | _ => false)
	in  if (rep_is_float)
	    then
		 (case destopt of
		      NONE => F(load_freg_loc(rep, NONE))
		    | SOME (I ir) => error "load_reg on a FLOAT rep and a SOME(I _)"
		    | SOME (F fr) => F(load_freg_loc(rep, SOME fr)))
	    else (case destopt of
		      NONE => I(load_ireg_loc(rep, NONE))
		    | SOME (F fr) => error "load_freg on a FLOAT rep and a SOME(F _)"
		    | SOME (I ir) => I(load_ireg_loc(rep, SOME ir)))
	end

    fun load_reg_val (value : value, destopt : reg option) : reg = 
	(case value of
	     REAL _ => 
		 (case destopt of
		      NONE => F(load_freg_val(value, NONE))
		    | SOME (I ir) => error "load_reg_val on a FLOAT rep and a SOME(I _)"
		    | SOME (F fr) => F(load_freg_val(value, SOME fr)))
	   | _ =>
		 (case destopt of
		      NONE => I(load_ireg_val(value, NONE))
		    | SOME (F fr) => error "load_freg_val on a FLOAT rep and a SOME(F _)"
		    | SOME (I ir) => I(load_ireg_val(value, SOME ir))))

    fun load_reg_term (LOCATION loc, destOpt) = load_reg_loc(loc,destOpt)
      | load_reg_term (VALUE value, destOpt) = load_reg_val(value,destOpt)

    fun load_ireg_term(LOCATION vl, poss_dest) = load_ireg_loc(vl,poss_dest)
      | load_ireg_term(VALUE vv, poss_dest) = load_ireg_val(vv,poss_dest)
    fun load_freg_term(LOCATION vl, poss_dest) = load_freg_loc(vl,poss_dest)
      | load_freg_term(VALUE vv, poss_dest) = load_freg_val(vv,poss_dest)
    fun load_reg_term(LOCATION vl, poss_dest) = load_reg_loc(vl,poss_dest)
      | load_reg_term(VALUE vv, poss_dest) = load_reg_val(vv,poss_dest)
    fun load_ireg_sv(vl as (VALUE(INT i))) =
	if (in_imm_range i) then IMM(TW32.toInt i) else REG(load_ireg_term(vl,NONE))
      | load_ireg_sv(vl as (VALUE(TAG i))) =
	    if (in_imm_range i) then IMM(TW32.toInt i) else REG(load_ireg_term(vl,NONE))
      | load_ireg_sv vl = REG(load_ireg_term(vl,NONE))


  (* --------- end of load(sv/int/float) ------------------------------------------ *)



  (* --------- Common Code Sequence Helper Functions ------------------------------ *)

  (* by possibly adding 4 to heapptr, make it odd-quadword aligned;
   if addition took place, store a skip tag first *)
  fun align_odd_word () =
    let val tmp0 = alloc_regi(NOTRACE_INT)
      val tmp1 = alloc_regi(TRACE)
    in add_instr(LI(Rtltags.skip,tmp0));
	 add_instr(STORE32I(EA(heapptr,0),tmp0));  (* store a skiptag *)
	 add_instr(ANDB(heapptr,IMM 4,tmp0));
	 add_instr(ADD(heapptr,IMM 4,tmp1));
	 add_instr(CMV(EQ,tmp0,REG tmp1,heapptr))
    end
  (* by possibly adding 4 to heapptr, make it even-quadword aligned;
   if addition took place, store a skip tag first *)
  fun align_even_word () =
    let val tmp0 = alloc_regi(NOTRACE_INT)
      val tmp1 = alloc_regi(NOTRACE_INT)
    in add_instr(LI(Rtltags.skip,tmp0));
      add_instr(STORE32I(EA(heapptr,0),tmp0)); (* store a skiptag *)
      add_instr(ANDB(heapptr,IMM 4,tmp0));
      add_instr(ADD(heapptr,IMM 4,tmp1));
      add_instr(CMV(NE,tmp0,REG tmp1,heapptr))
    end
  

  fun add (reg,i : int,dest) =
    if in_imm_range (i2w i) then
      add_instr(ADD(reg,IMM i,dest))
    else if in_ea_disp_range i then
	add_instr(LEA(EA(reg,i),dest))
         else let val size = alloc_regi(NOTRACE_INT)
              in add_instr(LI (i2w i,size));
		  add_instr(ADD(reg,REG size,dest))
	      end

  fun repPathIsPointer repPath = 
      let fun loop (r,[]) = let 
				val result = alloc_regi NOTRACE_INT
				val _ = add_instr(CMPUI(GT,r,IMM 3,result))
			    in  result
			    end
	    | loop (r,index::rest) = let val s = alloc_regi TRACE
	                                 (* XXX should use record_project but in tortl-record *)
					 val _ = if (index >= Rtltags.maxRecordLength)
						     then error "Record too big"
						 else ()
					 val _ = add_instr(LOAD32I(EA(r,4*index),s))
				     in  loop (s,rest)
				     end
      in  (case repPath of
	       Notneeded_p => error "load_repPath called on Notneeded_p"
	     | Projvar_p (r,ind) => loop(r,ind)
	     | Projlabel_p (lab,ind) => let val addr = alloc_regi NOTRACE_LABEL
					    val _ = add_instr(LADDR(lab,0,addr))
					in  loop(addr,ind)
					end)
      end

  fun storeWithBarrier(addr,value,rep) : bool =
      (case rep of
	   TRACE => (add_instr(MUTATE(addr, IMM 0,value, NONE)); true)
	 | COMPUTE rep_path => 
	       let val isPointer = repPathIsPointer rep_path
		   val pointerCase = fresh_code_label "allocateGlobal_pointerCase"
		   val afterStore = fresh_code_label "allocateGlobal_afterStore"
	       in  add_instr(BCNDI(EQ, isPointer, IMM 1, pointerCase,true));
		   add_instr(STORE32I(EA(addr,0),value));
		   add_instr(BR afterStore);
		   add_instr(ILABEL pointerCase);
		   add_instr(MUTATE(addr, IMM 0, value, NONE));
		   add_instr(ILABEL afterStore);
		   true
	       end
	 | _ => (add_instr(STORE32I(EA(addr,0),value)); false))

  fun allocate_global (label,labels,rtl_rep,lv) = 
      let 
	  val _ = add_data(COMMENT "Global starts here")
	  val _ = (case rtl_rep of
		       LOCATIVE => error "global locative"
		     | UNSET => error "global unset"
		     | NOTRACE_REAL => let val tagData = mk_recordtag [NOTRACE_INT, NOTRACE_INT]
					   val {dynamic=[],static} = tagData
				       in  add_data(ALIGN ODDLONG);
					   add_data(INT32 static)
				       end
		     | _ => 
			let val tagData = mk_recordtag [rtl_rep]
			    val {dynamic,static} = tagData
			    val _ = 
				(case dynamic of 
				     [] => ()
				   | _ => 
					 let val mask = alloc_regi NOTRACE_INT
					     fun do_bit {bitpos,path} = 
						 let val isPointer = repPathIsPointer path
						     val tmp = alloc_regi NOTRACE_INT
						 in  add_instr(SLL(isPointer,IMM bitpos,tmp));
						     add_instr(ORB(tmp,REG mask,mask))
						 end
					     val _ = add_instr(LI(0w0,mask))
					     val _ = app do_bit dynamic
					     val addr = alloc_regi NOTRACE_LABEL
					     val tag = alloc_regi NOTRACE_INT
					     val _ = add_instr(LADDR(label,0,addr))
					     val _ = add_instr(LOAD32I(EA(addr,~4),tag))
					     val _ = add_instr(ORB(tag,REG mask,tag))
					     val _ = add_instr(STORE32I(EA(addr,~4),tag))
					 in  ()
					 end)
			    in  add_data (INT32 static)
			    end)
	  val _ = app (fn l => add_data(DLABEL l)) (label::labels)

	  fun get_addr() = let val addr = alloc_regi NOTRACE_LABEL
			   in  add_instr(LADDR(label,0,addr)); addr
			   end
      in  (case lv of
	     LOCATION (REGISTER (_,reg)) =>
		 (case reg of
		      I r => (add_data(INT32 uninit_val);
			      if (storeWithBarrier(get_addr(), r, rtl_rep))
				  then add_mutable label
			      else ())
		    | F r => (add_data(FLOAT "0.0");
			      add_instr(STOREQF(EA(get_addr(),0),r))))
	   | LOCATION (GLOBAL (l,rep)) => 
		      let val value = alloc_regi rep
			  val loc = alloc_regi NOTRACE_LABEL
		      in  (add_data(INT32 uninit_val);
			   add_instr(LADDR(l,0,loc));
			   add_instr(LOAD32I(EA(loc,0),value));
			   if (storeWithBarrier(get_addr(), value, rtl_rep))
			       then add_mutable label
			   else ())
		      end
	   | VALUE (VOID _) => (print "Warning: alloc_global got a VOID\n";
				add_data(INT32 0w0))
	   | VALUE (INT w32) => add_data(INT32 w32)
	   | VALUE (TAG w32) => add_data(INT32 w32)
	   | VALUE (REAL l) => let val fr = alloc_regf()
				   val addr2 = alloc_regi NOTRACE_LABEL
			       in  add_data(FLOAT "0.0");
				   add_instr(LADDR(l,0,addr2));
				   add_instr(LOADQF(EA(addr2,0), fr));
				   add_instr(STOREQF(EA(get_addr(),0), fr))
			       end
	   | VALUE (RECORD (l,_)) => add_data(DATA l)
	   | VALUE (LABEL l) => add_data(DATA l)
	   | VALUE (CODE l) => add_data(DATA l))
      end


  fun help_global (add_obj, (state,v : var, obj, term : term)) : state =
    let 
	val _ = Stats.counter("RTLglobal") ()
	val (exported,label,labels) = (case (Name.VarMap.find(!exports,v)) of
					   SOME (lab::rest) => (true,lab,rest)
					 | SOME [] => error "no labels in export entry"
					 | NONE => (false,LOCAL_DATA (Name.var2string v),[]))
	val rep = term2rep term

	val isReg =
	    (case term of
		 LOCATION (REGISTER _) => true
	       | _ => false)
		 
	val _ = if (exported orelse isReg)
		    then allocate_global(label,labels,rep,term)
		else ()

	val term = 
	    (case term of
		 LOCATION (REGISTER _) => LOCATION(GLOBAL(label,rep))
	       | _ => term)

    in  add_obj (state,v,obj,term)
    end
	

  fun add_global arg : state = help_global(add_term, arg)
  fun add_global_equation arg : state = help_global(add_term_equation, arg)


  fun add_conglobal (state : state,
		     v : var,
		     kind : kind,
		     termOpt : term option) : state = 
    let 
	val _ = Stats.counter("RTLconglobal") ()
	val (exported,label,labels) = (case (Name.VarMap.find(!exports,v)) of
					   SOME (lab::rest) => (true,lab,rest)
					 | SOME [] => error "no labels in export entry"
					 | NONE => (false,LOCAL_DATA (Name.var2string v),[]))
	val is_reg = 
	    (case termOpt of
		 SOME(LOCATION(REGISTER _)) => true
	       | _ => false)

	val _ = (case (termOpt, exported orelse is_reg) of
		     (SOME term, true) => allocate_global(label,labels,TRACE,term)
		   | _ => ())

	val termOpt = 
	    (case termOpt of
		 SOME(LOCATION (REGISTER _)) => SOME(LOCATION(GLOBAL(label,TRACE)))
	       | _ => termOpt)

	val state' = add_conterm (state, v, kind, termOpt)

    in state'
    end

  fun unboxFloat regi : regf = let val fr = alloc_regf()
				   val _ = add_instr(LOADQF(EA(regi,0),fr))
			       in  fr
			       end

  fun boxFloat (state,regf) : regi * state = 
      let val dest = alloc_regi TRACE
	  val state = if (not (!HeapProfile))
		      then let val state = needgc(state,IMM 4)
			   in  align_odd_word();
			       store_tag_zero(realarraytag (i2w 1));
			       add_instr(STOREQF(EA(heapptr,4),regf)); (* allocation *)
			       add(heapptr,4,dest);
			       add(heapptr,12,heapptr);
			       state
			   end
		  else let val state = needgc(state,IMM 5)
		       in  align_even_word();
			   store_tag_disp(0,MakeProfileTag());
			   store_tag_disp(4,realarraytag (i2w 1));
			   add_instr(STOREQF(EA(heapptr,8),regf)); (* allocation *)
			   add(heapptr,8,dest);
			   add(heapptr,16,heapptr);
			   state
		       end
      in  (dest,state)
      end

  fun boxFloat_vl (state,lv) : term * state = 
      (case lv of
	  LOCATION(REGISTER (_,F fr)) => let val (ir,state) = boxFloat(state,fr)
				       in  (LOCATION(REGISTER (false,I ir)), state)
				       end
	| LOCATION(REGISTER (_,I _)) => error "can't box an int reg"
	| LOCATION(GLOBAL (l,_)) => (VALUE(LABEL l), state)
	| VALUE(REAL l) => (VALUE(LABEL l), state)
	| VALUE _ => error "can't box a non-REAL value")

 (* code for allocating an fp array at run-time given a list of LOCATIONs: return an ireg *)
       
 fun fparray (state, val_locs : term list) : regi * state = 
    let 
      val res = alloc_regi TRACE
      val len = length val_locs
      fun scan (nil,_) = ()
	| scan (h::t,offset) =
	  let val src = load_freg_term (h, NONE)
	  in  add_instr(STOREQF(EA(res,offset),src));
	      scan(t,offset+8)
	  end
      val state = 
       if (not (!HeapProfile))
	 then 
	     let val state = needgc(state,IMM((if len = 0 then 1 else 2*len)+2))
	     in  align_odd_word();
		 store_tag_zero(realarraytag(i2w len));
		 add_instr(ADD(heapptr,IMM 4,res));
		 state
	     end
       else let val state = needgc(state,IMM((if len = 0 then 1 else 2*len)+3))
	    in  align_even_word();
		store_tag_disp(0,MakeProfileTag());
		store_tag_disp(4,realarraytag(i2w len));
		add_instr(ADD(heapptr,IMM 8,res));
		state
	    end;
    in
       scan (val_locs,0);
       if (len = 0)
	   then add_instr(ADD(res,IMM 4,heapptr))
       else
	   add_instr(ADD(res,IMM (8*len),heapptr));
       (res, state)
    end 
	      


  local
    fun shuffle (eqreg : ('a * 'a) -> bool,
		 alloc : 'a -> 'a, 
		 mover: ('a * 'a) -> instr)
	        (src : 'a list,
		 dest : 'a list) = 
      let fun isdest r = member_eq(eqreg,r, dest)
	
	local
	  (* given two lists of equal length, remove corresponding equal elements *)
	  fun sieve2 (h::t,h'::t') =
	      let val (nt,nt') = sieve2 (t,t')
	      in  if eqreg(h,h') 
		      then (nt,nt')
		  else (h::nt,h'::nt')
	      end
	    | sieve2(nil,nil) = (nil,nil)
	    | sieve2 _ = error "sieve2"

	in  (* remove assignments of register to self *)
	  val (src,dest) = sieve2 (src,dest)
	end
      
	(* compute which registers are both a source and a dest *)
	val needtmp = map (fn r => (r,isdest r)) src
	  
	(* create temp regs for these, and copy sources into them.*)
	val tmps = map (fn (r,true) =>
			let val r' = alloc(r)
			in  add_instr(mover(r,r'));
			  (r,SOME r')
			end
      |  (r,_) => (r,NONE)) needtmp
	  
	fun merge (nil,nil) = ()
	  | merge ((h',tmp)::t',h::t) =
	  (case tmp
	     of NONE =>
	       if eqreg(h',h) then ()
			   else add_instr(mover(h',h))
		     | SOME r =>
			     add_instr(mover(r,h));
			     merge(t',t))
	  | merge _ = error "shuffle_regs/merge"
      in merge (tmps,dest)
      end
    fun iclone (REGI(_,rep)) = alloc_regi(rep)
      | iclone (SREGI sreg) =  error "cannot shuffle special registers"
    fun fclone (_ : regf) = alloc_regf()
    fun clone (I ir) = I(iclone ir)
      | clone (F fr) = F(fclone fr)
  in
    fun mv (I ir1, I ir2) = MV(ir1,ir2)
      | mv (F fr1, F fr2) = FMV(fr1,fr2)
      | mv _ = error "cannot move between int and float regs"
    val shuffle_fregs =	shuffle (eqregf, fclone, FMV)
    val shuffle_iregs = shuffle (eqregi, iclone, MV)
    val shuffle_regs  = shuffle (eqreg, clone, mv)
  end


end
