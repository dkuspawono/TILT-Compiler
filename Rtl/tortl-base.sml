

functor TortlBase(structure Rtl : RTL
		  structure Pprtl : PPRTL 
		  structure Rtltags : RTLTAGS 
		  structure Nil : NIL
		  structure NilContext : NILCONTEXT
		  structure NilStatic : NILSTATIC
		  structure NilUtil : NILUTIL
		  structure Ppnil : PPNIL
		  sharing Ppnil.Nil = NilUtil.Nil = NilContext.Nil = NilStatic.Nil = Nil
		  sharing Pprtl.Rtltags = Rtltags
		  sharing Rtl = Pprtl.Rtl
		  sharing type NilStatic.context = NilContext.context)
    :> TORTL_BASE where Rtl = Rtl where Nil = Nil
   =
struct

val do_constant_records = ref true
val do_forced_constant_records = ref true

val do_gcmerge = ref true
val do_single_crecord = ref true


val diag = ref true
val debug = ref false
val debug_full = ref false
val debug_full_env = ref false
val debug_simp = ref false
val debug_bound = ref false

   (* Module-level declarations *)

    structure Rtl = Rtl
    structure Nil = Nil
    open Util Listops
    open Nil
    open NilUtil
    open Rtl
    open Name
    open Rtltags 
    open Pprtl 
    type label = Rtl.label

    val exncounter_label = ML_EXTERN_LABEL "exncounter"
    val error = fn s => (Util.error "tortl.sml" s)
    structure TW32 = TilWord32
    structure TW64 = TilWord64




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

   datatype reg = I of Rtl.regi | F of Rtl.regf
   datatype var_loc = VREGISTER of bool * reg 
		    | VGLOBAL of label * rep  (* I am located at this label: closure, data, ... *)
   and var_val = VINT of TW32.word
               | VREAL of label           (* I am a real located at this label *)
               | VRECORD of label * var_val list (* I have the value of this label *)
               | VVOID of rep
               | VLABEL of label         (* I have the value of this label *)
               | VCODE of label          (* I have the value of this code label *)

   type var_rep = var_loc option * var_val option * con
   type convar_rep = var_loc option * var_val option * kind
   datatype loc_or_val = VAR_LOC of var_loc
                       | VAR_VAL of var_val
   type varmap = var_rep VarMap.map
   type convarmap = convar_rep VarMap.map
   val unitval = VINT 0w256
   val unit_vvc = (VAR_VAL unitval, Prim_c(Record_c[],[]))

   datatype gcinfo = GC_IMM of instr ref | GC_INF
   type gcstate = gcinfo list

  (* ----- Global data structures ------------------------------
   dl: list of data for module
   pl: list of procedures for the entire module
   mutable_objects : objects in global data area that can point to heap objects
                     (e.g.) pointer arrays
   mutable_variables : global variables that may contain pointers to heap objects
   gvarmap: how a top-level NIL code variable is represented at the RTL level
   gconvarmap: how a top-level NIL code type variable is represented at the RTL level
   varmap: how a NIL variable is represented at the RTL level
   convarmap: how a NIL typevariable is represented at the RTL level
   ------------------------------------------------------------- *)

   exception NotFound
   val exports = ref (Name.VarMap.empty : (Name.label list) Name.VarMap.map)
   val globals = ref VarSet.empty
   val dl : Rtl.data list ref = ref nil
   val pl : Rtl.proc list ref = ref nil
   type state = {env : NilContext.context,
		 varmap : varmap,
		 convarmap : convarmap,
		 gcstate : gcstate}
   fun make_state() : state = {env = NilContext.empty,
			       varmap = VarMap.empty,
			       convarmap = VarMap.empty,
			       gcstate = [GC_INF]}
   val global_state : state ref = ref (make_state())

   fun stat_state ({convarmap,...} : state) = 
       (VarMap.appi (fn (v,_) => (Ppnil.pp_var v; print " ")) convarmap; print "\n\n")
   fun show_state ({env,...} : state) = 
       (print "Showing environment part of state:\n";
	NilContext.print_context env;
	print "\n\n")

   local
       val mutable_objects : label list ref = ref nil
       val mutable_variables : (label * rep) list ref = ref nil
   in  fun add_mutable_object l = mutable_objects := l :: !mutable_objects
       fun get_mutable_objects () = !mutable_objects
       fun reset_mutable_objects() = mutable_objects := nil
       fun add_mutable_variable (l,r) = mutable_variables := (l,r) :: !mutable_variables
       fun get_mutable_variables () = !mutable_variables
       fun reset_mutable_variables() = mutable_variables := nil
   end
   fun add_proc p = pl := p :: !pl

  fun alloc_code_label s = LOCAL_CODE(fresh_named_var s)
  fun alloc_data_label s = LOCAL_DATA(fresh_named_var s)
  fun alloc_local_code_label s = LOCAL_LABEL(alloc_code_label s)
  fun alloc_local_data_label s = LOCAL_LABEL(alloc_data_label s)
  fun named_local_data_label v = LOCAL_LABEL(LOCAL_DATA v)
  fun named_local_code_label v = LOCAL_LABEL(LOCAL_CODE v)



  val codeAlign = ref (Rtl.OCTA)
  fun do_code_align() = () (* add_instr(IALIGN (!codeAlign)) *)


  (* ---- Looking up and adding new variables --------------- *)

  fun top_rep (v,rep) = 
      (case rep of
(* 	   (SOME(VGLOBAL _),_,_) => true *)
	   (_, SOME(VCODE _), _) => true
(*	 | (_, SOME(VLABEL _), _) => true *)
	 | _ => (VarSet.member(!globals,v)))

  fun varmap_insert' ({varmap,env,convarmap,gcstate} : state) (v,vr : var_rep) : state = 
      let val _ = if (!debug_bound)
		      then (print "varmap adding to v = "; 
			    Ppnil.pp_var v; print "\n")
		  else ()
	  val _ = case (VarMap.find(varmap,v)) of
		  NONE => ()
		| SOME _ => error ("varmap contains "
					    ^ (Name.var2string v))
	  val varmap = VarMap.insert(varmap,v,vr)
      in  {env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
      end
  
  fun varmap_insert state arg =
      (if (top_rep arg)
	   then global_state := varmap_insert' (!global_state) arg
       else ();
	varmap_insert' state arg)

  fun convarmap_insert' ({convarmap,varmap,env,gcstate}:state) (v,cvr : convar_rep) : state = 
      let val _ = if (!debug_bound)
		      then (print "convar adding to v = "; Ppnil.pp_var v; print "\n")
		  else ()
	  val _ = (case (VarMap.find(convarmap,v)) of
		       NONE => ()
		     | SOME _ => error ("convarmap already contains "
						 ^ (Name.var2string v)))
	  val convarmap = VarMap.insert(convarmap,v,cvr)
      in  {env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
      end
  
  fun insert_kind(ctxt,v,k,copt : con option) = 
      let fun default() = 
	  let val _ = if (!debug)
			  then (print "inserting kind with unreduced k = \n";
				Ppnil.pp_kind k; print "\n")
		      else ()
	  in  Stats.subtimer("tortl_insert_kind_plain",
			  NilContext.insert_kind)(ctxt,v,k) 
	  end
	  fun equation c =
 	   let val _ = if (!debug)
			   then (print "inserting equation with c = \n";
				 Ppnil.pp_con c; print "\n")
		       else ()
	   in  Stats.subtimer("tortl_insert_kind_equation",
			   NilContext.insert_kind_equation)(ctxt,v,c,k)
	   end
      in
	  (case (k,copt) of
	       (Singleton_k(_,_,c'),SOME c) => 
		   (
(*
		    print "insert_kind: c' = ";
		    Ppnil.pp_con c'; print "\n c = \n";
		    Ppnil.pp_con c'; print "\n";
*)
		    equation c)
	     | (_,SOME c) => equation c
	     | (Singleton_k(_,_,c),_) => equation c
	     | _ => default())
	       handle e => (print "Error in tortl_insert_kind\n"; raise e)
      end


val insert_kind = Stats.subtimer("tortl_insert_kind",insert_kind)

  fun env_insert' istop ({env,varmap,convarmap,gcstate} : state) (v,k,copt) : state = 
      let val _ = if (!debug_bound)
		      then (print "env adding v = ";
			    Ppnil.pp_var v; print "   istop = ";
			    print (Bool.toString istop); print "\n")
		  else ()
	  val newenv = insert_kind(env,v,k,copt)
	  val newstate = {env=newenv,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
(*
	      (* should not call insert_kind again: doing normalization work twice *)
	  val _ = if istop
		      then let val {env,varmap,convarmap,gcstate} = !global_state
			       val env = insert_kind(env,v,k,copt)
			       val new_globalstate = {env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
			   in  global_state := new_globalstate
			   end
		  else ()
	  val _ = if (!debug_bound)
		      then (print "env done adding to v = ";
			    Ppnil.pp_var v; print "   istop = ";
			    print (Bool.toString istop); print "\n")
		  else ()
*)
      in  newstate
      end

  fun convarmap_insert state (arg as (v,(_,_,k))) copt =
      let val state = convarmap_insert' state arg
	  val istop = top_rep arg
	  val _ = if istop
		      then global_state := convarmap_insert' (!global_state) arg
		  else ()
      in  env_insert' istop state (v,k,copt)
      end

  
  fun add_var' s (v,vlopt,vvopt,con) =  varmap_insert s (v,(vlopt,vvopt,con))
  fun add_var  s (v,reg,con)         =  add_var' s (v,SOME(VREGISTER(false,reg)), NONE, con)
  fun add_varloc s (v,vl,con)        =  add_var' s (v,SOME vl,NONE,con)
  fun add_code s (v,l,con)           =  add_var' s (v,NONE, SOME(VCODE l), con)

  (* adding constructor-level variables and functions *)
  fun add_convar s (v,vlopt,vvopt,kind,copt) = 
      convarmap_insert s (v,(vlopt, vvopt, kind)) copt
  fun add_concode s (v,l,kind,copt) = 
      convarmap_insert s (v,(NONE, SOME(VCODE l),kind)) copt

  fun getconvarrep' ({convarmap=lm,...} : state) v : convar_rep option = VarMap.find (lm,v) 
   fun getconvarrep ({convarmap=lm,...} : state) v : convar_rep = 
       (case VarMap.find (lm,v) of
	   NONE => error ("getconvarrep: variable "^(var2string v)^" not found")
	 | SOME convar_rep => convar_rep)

  fun getrep ({varmap=lm,...} : state) v = 
      (case VarMap.find(lm,v) of
	   NONE => error ("getvarrep: variable "^(var2string v)^" not found")
	 | SOME rep => rep)

    (* given a type returns true and a type in head-normal form
       or false and a type not in head-normal form 
       in either case, the returned type is possibly simpler than the argument type *)
    fun is_hnf c : bool = 
	(case c of
	     Prim_c(pc,clist) => true
	   | AllArrow_c _ => true
	   | Var_c _ => false
	   | Let_c _ => false
	   | Mu_c _ => true
	   | Proj_c (Mu_c _,_) => true
	   | Proj_c _ => false
	   | App_c _ => false
	   | Crecord_c _ => true
	   | Closure_c _ => error "Closure_c not a type"
	   | Typecase_c _ => false
	   | Annotate_c (_,c) => is_hnf c)

    fun reduce_until_hnf(env,c) : con = 
	let fun diagnose n [] = error "reduce_until_hnf: diagnose"
	      | diagnose n (c::rest) = (print "reduce_until_hnf(";
					print (Int.toString n);
					print ") =\n"; Ppnil.pp_con c; print "\n";
					diagnose (n+1) rest)
	    
	    fun loop (n,past) (subst,c) = 
	    if (n>1000) then diagnose 0 (rev past)
		else 
	    if (is_hnf c)
		then (subst,c )
	    else let val next = (n+1,c::past)
		     val (progress,subst,c) = NilStatic.con_reduce_once(env,subst) c
		 in  if progress then loop next (subst,c) else (subst,c)
		 end
	    val (subst,c) = loop (0,[]) (NilStatic.empty_subst,c)
	in  NilStatic.con_subst(subst,c)
	end

    fun simplify_type_help env c : bool * con = 
	(case c of
	     Prim_c(pc,clist) => 
		 let val clist' = map (simplify_type_help env) clist
		 in  (true,Prim_c(pc,map #2 clist'))
		 end
	   | Mu_c _ => (true,c)
	   | _ => let val _ = if (!debug_simp)
				  then (print "simplify type calling type reducer on:\n";
					Ppnil.pp_con c;
					print "\nwith env = \n";
					NilContext.print_context env;
					print "\n")
			      else 
			       if (!debug)
				  then (print "simplify type called\n")
				   else ()

		      val c' = reduce_until_hnf(env,c)
		      val _ = if (!debug_simp)
				  then (print "simplify type: reducer on type returned:\n";
					Ppnil.pp_con c';
					print "\n")
			      else if (!debug)
				  then (print "simplify type returned\n")
				   else ()
		  in (is_hnf c',c')
		  end)

    fun simplify_type_help' env c : bool * con = 
	let fun help(is_recur,v,vc_seq) = 
	    let val env' = insert_kind(env,v,Word_k Runtime,NONE)
	    in  simplify_type_help' env' (NilUtil.muExpand(is_recur,vc_seq,v))
	    end
	in
	    (case simplify_type_help env c of
		 (_, Mu_c (is_recur,vc_seq)) => 
		     (case (sequence2list vc_seq) of
			  [(v,c)] => help (is_recur,v, vc_seq)
			| _ => error "simplify_type given non-single Mu_c")
	       | (_, Proj_c(Mu_c (is_recur,vc_seq),l)) => 
			  let fun loop n [] = error "bad Proj_c(Mu_c,...)"
				| loop n ((v,_)::rest) = if (eq_label(NilUtil.generate_tuple_label n,l))
							     then v else loop (n+1) rest
			  in  help(is_recur,loop 1 (sequence2list vc_seq), vc_seq)
			  end
	       | (hnf,c) => (hnf,c))
	end

    fun simplify_type ({env,...} : state) c : bool * con = 
	simplify_type_help env c
    fun simplify_type' ({env,...} : state) c : bool * con = 
	simplify_type_help' env c

    local
	fun help2 state (tagcount,totalcount,known,carrier) = 
	    if (TilWord32.equal(totalcount,TilWord32.uplus(tagcount,0w1))) 
		then SOME(tagcount,known,[carrier])
	    else (case carrier of
		      Crecord_c lcons => SOME(tagcount,known,map #2 lcons)
		    | _ => (case #2(simplify_type state carrier) of
				Crecord_c lcons => SOME(tagcount,known,map #2 lcons)
			      | _ => NONE))
	fun help state sumcon = 
	    (case sumcon of
		 Prim_c(Sum_c {tagcount,totalcount,known}, [carrier]) => 
		     help2 state (tagcount,totalcount,known,carrier)
	       | _ => 
		     (case #2(simplify_type state sumcon) of
		        Prim_c(Sum_c {tagcount,totalcount,known}, [carrier]) => 
			    help2 state (tagcount,totalcount,known,carrier)
	       | _ => NONE))
    in  fun reduce_to_sum str state sumcon = 
	(case help state sumcon of
	     NONE => error (str ^ " got sum not reducible to a sum type")
	   | SOME (tag,_,s) => (tag,s))
	fun reduce_to_known_sum str state sumcon = 
	    (case help state sumcon of
		 NONE => error (str ^ " got sum not reducible to a sum type")
	       | SOME (tag,NONE,s) => error (str ^ " got sum reducible to a unknown sum type")
	       | SOME (tag,SOME k,s) => (tag,k,s))
    end





  (* Takes a constructor and returns the RTL representation.
     The head-normal form must be statically known. That is, this constructor
     must not involve any computation to determine the RTL representation. *)
   fun con2rep_raw (state : state) con : rep option = 
       let fun primcon2rep (pcon,clist) = 
	   case (pcon,clist) of
	       (Int_c _,_) => SOME NOTRACE_INT
	     | (Float_c Prim.F32,_) => error "32-bit floats not supported"
	     | (Float_c Prim.F64,_) => SOME NOTRACE_REAL
	     | (((BoxFloat_c _) | Exn_c | Array_c | Vector_c | Ref_c | Exntag_c | 
		   (Sum_c _) | (Record_c _) | (Vararg_c _)),_) => SOME TRACE
       in case con of
	   Prim_c(pcon,clist) => primcon2rep(pcon,clist)
	 | AllArrow_c (Open,_,_,_,_,_) => error "no open lambdas allowed by this stage"
	 | AllArrow_c(Closure,_,_,_,_,_) => SOME TRACE
	 | AllArrow_c(Code,_,_,_,_,_) => SOME NOTRACE_CODE
	 | AllArrow_c(ExternCode,_,_,_,_,_) => SOME NOTRACE_CODE
	 | Var_c v => 
	       (case (getconvarrep' state v) of
		    (* these cases are wrong *)
		    SOME(_,SOME(VRECORD (l,_)),_) => SOME(COMPUTE(Label_p l))
		  | SOME(_,SOME(VLABEL l),_) => SOME(COMPUTE(Label_p l))
		  | SOME(_,SOME(VVOID _),_) => error "constructor is void"
		  | SOME(_,SOME(VREAL _),_) => error "constructor represented as  a float"
		  | SOME(_,SOME(VCODE _),_) => error "constructor function cannot be a type"

			(* WRONG just an experiment *)
		  (* we could actually return an answer but this depends on xcon *)
		  | SOME(_,SOME(VINT _),_) => SOME TRACE


		  | SOME(SOME(VREGISTER (_,I r)),_,_) => SOME(COMPUTE(Var_p r))
		  | SOME(SOME(VREGISTER (_,F _)),_,_) => error "constructor in float reg"
		  | SOME(SOME(VGLOBAL (l,_)),_,_) => SOME(COMPUTE(Projlabel_p(l,[0])))
		  | SOME(NONE,NONE,_) => error "no information on this convar!!"
		  | NONE => NONE)
	 | Mu_c (is_recur,vc_seq) => SOME TRACE
	 | Proj_c(Mu_c _,_) => SOME TRACE
	 | (Proj_c _) =>
	       (let fun koop (Proj_c (c,l)) acc = koop c (l::acc)
		     | koop (Var_c v) acc = (v,acc)
		     | koop _ _ = error "projection is not a chain of projections from a variable"
		   val (v,labels) = koop con []
		   fun loop acc _ [] = rev acc
		     | loop acc (Record_k fields_seq) (label::rest) = 
		       let fun extract acc [] = error "bad Proj_c"
			     | extract acc (((l,_),fc)::rest) = 
			       if (eq_label(label,l)) then (fc,acc) else extract (acc+1) rest
			   val fields_list = (sequence2list fields_seq)
			   val (con,index) = extract 0 fields_list 
			   val acc = if (!do_single_crecord andalso length fields_list = 1)
					 then acc
				     else (index::acc) 
		       in  loop acc con rest
		       end
		     | loop acc (Singleton_k(_,k,c)) labs = loop acc k labs
		     | loop acc _ labs = error "expect record kind"
		   fun indices wrap kind = let val temp = loop [] kind labels
					   in  if (length temp > 3)
						then NONE else SOME(wrap temp)
					   end
	       in  (case (getconvarrep' state v) of
		       SOME(_,SOME(VINT _),_) => error "expect constr record: got int"
		     | SOME(_,SOME(VREAL _),_) => error "expect constr record: got real"
		     | SOME(_,SOME(VRECORD _),_) => error "expect constr record: got term record"
		     | SOME(_,SOME(VVOID _),_) => error "expect constr record: got void"
		     | SOME(_,SOME(VLABEL l),kind) => indices(fn [] => COMPUTE(Label_p l)
							       | x => COMPUTE(Projlabel_p(l,x))) kind
		     | SOME(_,SOME(VCODE _),_) => error "expect constr record: got code"
		     | SOME(SOME(VREGISTER (_,I ir)),_,kind) => 
			   indices (fn [] => COMPUTE(Var_p ir)
			             | x => COMPUTE(Projvar_p(ir,x))) kind
		     | SOME(SOME(VREGISTER (_,F _)),_,_) => error "constructor in float reg"
		     | SOME(SOME(VGLOBAL (l,_)),_,kind) => indices 
			   (fn x => COMPUTE(Projlabel_p(l,0::x))) kind
		     | SOME(NONE,NONE,_) => error "no info on convar"
		     | NONE => NONE) 
	       end handle e => NONE)
	 | (Let_c _) => NONE
	 | (App_c _) => NONE
	 | (Typecase_c _) => NONE
	 | (Crecord_c _) => error "Crecord_c not a type"
	 | (Closure_c _) => error "Closure_c not a type"
	 | (Annotate_c (_,c)) => con2rep_raw state c
       end

   fun con2rep state con : rep =
       (let fun failure copt = (print "con2rep failed original con = \n";
				Ppnil.pp_con con; print "\n";
				(case copt of
				    SOME c => (print "reduced con = \n";
					       Ppnil.pp_con c; print "\n")
				  | _ => print "no reduced con\n"))
	    fun reduce c = 
		 (case c of
		      (Proj_c _) => #2(simplify_type state c)
		    | (Let_c _) => #2(simplify_type state c)
		    | (App_c _) => #2(simplify_type state c)
		    | (Var_c _) => #2(simplify_type state c)
		    | _ => c)

	in  (case (con2rep_raw state con) of
		 NONE => 
		     let val c = reduce con handle e => (print "reduce failed\n"; failure NONE; raise e)
		     in  (case ((con2rep_raw state c) handle e => (failure (SOME c); raise e)) of
			      SOME rep => rep
			    | NONE => (print "con2rep failed on orig and reduced con; assuming TRACE\n";
				     failure (SOME c); 
					TRACE))
				(* error "con2rep failed" *)
		     end
	       | SOME(rep as (COMPUTE _)) => (* a reduction here might be advantageous *)
		     let val c = reduce con handle e => (print "reduce failed\n"; failure NONE; raise e)
		     in  (case ((con2rep_raw state c) handle e => (failure (SOME c); raise e)) of
			      SOME rep => rep
			    | NONE => rep (* well, we default back to unreduced rep *))
		     end
	       | SOME rep => rep)
	end)

val con2rep = Stats.subtimer("tortl_con2rep",con2rep)
val simplify_type = fn state => Stats.subtimer("tortl_simplify_type",simplify_type state)
val simplify_type' = fn state => Stats.subtimer("tortl_simplify_type",simplify_type' state) 

   fun varloc2rep varloc =
       (case varloc of
	    VREGISTER (_,reg) =>
		(case reg of
		     F (REGF(_,frep)) => frep
		   | I (REGI(_,irep)) => irep
		   | I (SREGI _) => error "tracetable_value on SREG")
	  | VGLOBAL (_,rep) => rep)
	    
  fun varval2rep varval =
      (case varval of
	   VINT _ => NOTRACE_INT
	 | VREAL _ => NOTRACE_REAL
	 | VRECORD _ => TRACE
	 | VLABEL _ => TRACE (* LABEL the whole idea of varval2rep is suspect *)
	 | VCODE _ => NOTRACE_CODE
	 | VVOID r => r)

  fun valloc2rep (VAR_VAL varval) = varval2rep varval
    | valloc2rep (VAR_LOC varloc) = varloc2rep varloc




  (* ----- Data structures for the current function being compiled 
   il: list of instructions for the current function being compiled
   localreg{i/f} : computing SAVE sets for RTL interpreter 
   top: label at top of current function (past prelude code)
   currentfun: the current function being compiled
   argreg{i/f}: the argument registers  
   ---> If top and currentfun and NONE, then we are at top-level 
        and the register lists will also be empty.   <--- *)



   local
       val istop : bool ref = ref false
       val top : local_label ref = ref (alloc_code_label "dummy_top")
       val currentfun : local_label ref = ref (alloc_code_label "dummy_fun")
       val resultreg : reg ref = ref (F(REGF(fresh_named_var "badreg",NOTRACE_REAL)))
       val il : (Rtl.instr ref) list ref = ref nil
       val localregi : regi list ref = ref nil
       val localregf : regf list ref = ref nil
       val argregi : regi list ref = ref nil
       val argregf : regf list ref = ref nil
       val curgc : instr ref option ref = ref NONE
       val gcstack : instr ref option list ref = ref []
       fun add_instr' i = il := (ref i) :: !il;
   in  
       fun istoplevel() = !istop
       fun getTop() = !top
       fun getCurrentFun() = !currentfun
       fun getResult() = !resultreg
       fun getLocals() = (!localregi, !localregf)
       fun getArgI() = !argregi
       fun getArgF() = !argregf

       fun add_data d = dl := d :: !dl

       fun join_states ([] : state list) : state = error "join_states got []"
	 | join_states (({env,varmap,convarmap,gcstate}) :: rest) = 
	   let val gcstates = gcstate :: (map #gcstate rest)
	       (* we must not have duplicates or else we get exponential blowup 
		  and the updates will also be too large since they are duplicated *)
		fun gcinfo_eq (GC_INF,GC_INF) = true
		  | gcinfo_eq (GC_IMM r1, GC_IMM r2) = r1 = r2
		  | gcinfo_eq _ = false
		fun folder(info,infos) = if (Listops.member_eq(gcinfo_eq,info,infos))
						then infos else info::infos
		val gcstate = foldl (fn (infos,acc) => foldl folder acc infos) [] gcstates
	   in   {env=env,varmap=varmap,convarmap=convarmap,gcstate=gcstate}
	   end
       fun add_instr i = 
	   (add_instr' i;
	    case i of
		NEEDGC _ => error "should use needgc to add a NEEDGC"
	      | _ => ())

       fun needgc(state as {gcstate,env,convarmap,varmap}:state,operand) : state = 
	 if (not (!do_gcmerge))
	     then (add_instr'(NEEDGC operand); state)
	 else
	      let val has_inf = List.exists (fn GC_INF => true
                                              | _ => false) gcstate
		  val is_imm = (case operand of
				    IMM _ => true
				  | _ => false)
	      in  if (has_inf orelse (not is_imm))
		      then let val r = ref(NEEDGC operand)
			       val _ = il := r :: !il
			       val gcinfo = if is_imm then GC_IMM r else GC_INF
			   in  {env=env,convarmap=convarmap,varmap=varmap,
				gcstate=[gcinfo]}
			   end
		  else (* the merge case where everything is IMM *)
		      let val (IMM m) = operand
			  fun update(GC_IMM(r as ref(NEEDGC (IMM n)))) = 
			      r := (NEEDGC(IMM(m+n)))
			    | update (GC_IMM _) = error "update given bad GC_IMM"
			    | update _ = error "update not given GC_IMM"
		      in  (app update gcstate; state)
		      end
	      end

       fun new_gcstate ({env,varmap,convarmap,gcstate} : state) : state =
	   let val s = {env=env,varmap=varmap,convarmap=convarmap,gcstate=[GC_INF]}
	   in  needgc(s,IMM 0)
	   end


       fun alloc_regi (traceflag) = 
	   let val r = REGI(fresh_var(),traceflag)
	   in localregi := r :: (!localregi);
	       r
	   end
       
       fun alloc_regf () = 
	   let val r = REGF(fresh_var(),NOTRACE_REAL)
	   in localregf := r :: (!localregf);
	       r
	   end
       
       fun alloc_named_regi v traceflag = 
	   let val r = REGI (v,traceflag)
	   in localregi := r :: (!localregi);
	       r
	   end
       
       fun alloc_named_regf v = 
	   let val r = REGF (v,NOTRACE_REAL)
	   in localregf := r :: (!localregf);
	       r
	   end
       
       fun alloc_reg state c = 
	   case c of (* might need to normalize *)
	       Nil.Prim_c(Float_c _,[]) => F(alloc_regf())
	     | _ => I(alloc_regi (con2rep state c))
		   
       fun alloc_named_reg state (c,v : var) = 
	   case c of
	       Nil.Prim_c(Float_c _,[]) => F(alloc_named_regf v)
	     | _ => I(alloc_named_regi v (con2rep state c))
		   

       fun promote_maps is_top ({env,...} : state) : state = 
	   let val {varmap,convarmap,gcstate,...} = !global_state
	   in  {varmap = varmap, convarmap = convarmap, env = env, gcstate = gcstate}
	   end

       fun set_args_result ((iargs,fargs),result,return) = 
	   (resultreg := result;
	    argregi := iargs;
	    argregf := fargs;
	    localregi := (case result of
			      I ir => ir :: return :: iargs
			    | _ => return :: iargs);
	    localregf := (case result of
			      F fr => fr :: fargs
			    | _ => fargs))

       fun reset_state (is_top,name) = 
	   (istop := is_top;
	    currentfun := LOCAL_CODE name;
	    top := alloc_code_label "funtop";
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
		reset_mutable_objects();
		reset_mutable_variables();
		reset_state(false,fresh_var()))
	   end

       fun get_state() = {name = !currentfun,
			  code = map ! (rev (!il))}
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

  fun in_imm_range_vl (VAR_VAL(VINT w)) = ((if in_imm_range w then SOME (w2i w) else NONE) handle _ => NONE)
    | in_imm_range_vl _ = NONE
  fun in_ea_range scale (VAR_VAL(VINT i)) = 
      ((if in_ea_disp_range(w2i i * scale)
	    then SOME (w2i i * scale)
	else NONE)
	    handle _ => NONE)
    | in_ea_range _ _ = NONE






 
  (* printing functions *)
  fun regi2s (Rtl.REGI (v,_)) = var2string v
    | regi2s (Rtl.SREGI HEAPPTR) = "HEAPPTR"
    | regi2s (Rtl.SREGI HEAPLIMIT) = "HEAPLIMIT"
    | regi2s (Rtl.SREGI STACKPTR) = "STACKPTR"
    | regi2s (Rtl.SREGI EXNPTR) = "EXNPTR"
    | regi2s (Rtl.SREGI EXNARG) = "EXNARG"

  fun regf2s (Rtl.REGF (v,_)) = var2string v
  fun reg2s (I x) = regi2s x
    | reg2s (F x) = regf2s x

  (* coercing/getting registers *)
    
  fun coercef (r : reg) : regf =
    case r
      of F r => r
    | I r => error("coercef: expected float register, found int register "^regi2s r)
	
  fun coercei str (r : reg) : regi =
    case r
      of I r => r
       | F r => (print "coercei: "; print (str : string) ; print "\n";
		 error("coercei: expected int register, found float register "^regf2s r))
				      

    
  val heapptr  = SREGI HEAPPTR
  val stackptr = SREGI STACKPTR
  val exnptr   = SREGI EXNPTR
  val exnarg   = SREGI EXNARG


  (* ------------------- End of Helper Functions -------------------------- *)



  (* --------- Tag Operation Hlper Functions -------------------- *)

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
    
  fun mk_recordtag(flags) = recordtag(flags);
    
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

    (* --- given the RTL representation of a variable, load the
           variable into the optional register i *)
    fun load_ireg_loc (loc : var_loc, poss_dest : regi option) =
      let 
	  fun pickdest rep = (case poss_dest of
				  NONE => alloc_regi rep
				| SOME d => d)
      in case loc of
	   VGLOBAL(l,NOTRACE_REAL) => error "load_ireg called with (VGLOBAL real)"
	 | VGLOBAL(label,rep) =>
	       let val addr = alloc_regi(LABEL)
		   val reg = pickdest rep
	       in  add_instr(LADDR(label,0,addr));
		   add_instr(LOAD32I(EA(addr,0),reg));
		   reg
	       end
	 | VREGISTER (_,I r) => (case poss_dest of
				   NONE => r
				 | SOME d => (add_instr(MV(r,d)); d))
	 | VREGISTER (_,F r) => error "moving from float to int register"
      end
    
    fun load_ireg_val (value : var_val, poss_dest : regi option) : regi =
      let 
	  fun pickdest rep = (case poss_dest of
				  NONE => alloc_regi rep
				| SOME d => d)
      in case value of
	  VVOID rep => let val r = pickdest rep
		       in  add_instr (LI(0w0,r)); (* zero is a safe bit-pattern for values of any rep *)
			   r
		       end
	| VINT i => let val r = pickdest NOTRACE_INT
			in  add_instr (LI(i,r));
			    r
			end
	| VREAL l => error ("load_ireg: VREAL")

	| VRECORD(label,_) => 
			let val reg = pickdest TRACE
			in  add_instr(LADDR(label,0,reg));
			    reg
			end
	| (VLABEL l) => 
	       let val reg = pickdest LABEL
	       in  add_instr(LADDR(l,0,reg));
		   reg
	       end
	| (VCODE l) => 
	       let val reg = pickdest NOTRACE_CODE
	       in  add_instr(LADDR(l,0,reg));
		   reg
	       end

      end


    fun mk_named_float_data (r : string, label : label) =
	(add_data(ALIGN (ODDLONG));
	 add_data(INT32 (realarraytag (i2w 1)));
	 add_data(DLABEL (label));
	 add_data(FLOAT (r)))
	
    fun mk_float_data (r : string) : label =
	let val label = alloc_local_data_label "floatdata"
	    val _ = mk_named_float_data (r,label)
	in label
	end
  
    fun load_freg_loc (rep : var_loc, poss_dest : regf option) : regf =
      let 
	  fun pickdest ()  = (case poss_dest of
				  NONE => alloc_regf()
				| SOME d => d)
      in case rep of
	  (VREGISTER (_,F r)) => (case poss_dest of
				      NONE => r
				    | SOME d => (add_instr(FMV(r,d)); d))
	| (VREGISTER (_,I r)) => error "moving from integer register to float register"
	| (VGLOBAL (l,NOTRACE_REAL)) =>
	      let val addr = alloc_regi(LABEL)
		  val dest = pickdest()
	      in  add_instr(LADDR(l,0,addr));
		  add_instr(LOADQF(EA(addr,0),dest));
		  dest
	      end
	(* this depends on globals being quadword aligned *)
	| (VGLOBAL (l,NOTRACE_INT)) => error "moving from global integer to float register"
	| (VGLOBAL (l,_)) => error "load_freg: got VGLOBAL(_,non-int and non-float)"
      end

    fun load_freg_val (rep : var_val, poss_dest : regf option) : regf =
      let 
	  fun doit label  = let val addr = alloc_regi LABEL
				val r = (case poss_dest of
					     NONE => alloc_regf()
					   | SOME d => d)
			    in  add_instr(LADDR(label,0,addr));
				add_instr(LOADQF(EA(addr,0),r));
				r
			    end
      in case rep of
	  (VINT i) => error "load_freg: got VINT"
	| (VVOID rep) => alloc_regf()
	| (VREAL l) => doit l
	| (VRECORD _) => error "load_freg: got VRECORD"
	| (VLABEL _) => error "load_freg: got VLABEL"
	| (VCODE _) => error "load_freg: got VCODE"
      end

    fun load_reg_loc (rep : var_loc, destopt : reg option) : reg = 
	(case rep of
	     ((VREGISTER (_,F _)) | (VGLOBAL (_, NOTRACE_REAL))) =>
		 (case destopt of
		      NONE => F(load_freg_loc(rep, NONE))
		    | SOME (I ir) => error "load_reg on a FLOAT rep and a SOME(I _)"
		    | SOME (F fr) => F(load_freg_loc(rep, SOME fr)))
	   | _ =>
		 (case destopt of
		      NONE => I(load_ireg_loc(rep, NONE))
		    | SOME (F fr) => error "load_freg on a FLOAT rep and a SOME(F _)"
		    | SOME (I ir) => I(load_ireg_loc(rep, SOME ir))))

    fun load_reg_val (rep : var_val, destopt : reg option) : reg = 
	(case rep of
	     VREAL _ => 
		 (case destopt of
		      NONE => F(load_freg_val(rep, NONE))
		    | SOME (I ir) => error "load_reg_val on a FLOAT rep and a SOME(I _)"
		    | SOME (F fr) => F(load_freg_val(rep, SOME fr)))
	   | _ =>
		 (case destopt of
		      NONE => I(load_ireg_val(rep, NONE))
		    | SOME (F fr) => error "load_freg_val on a FLOAT rep and a SOME(F _)"
		    | SOME (I ir) => I(load_ireg_val(rep, SOME ir))))


    fun load_ireg_locval(VAR_LOC vl, poss_dest) = load_ireg_loc(vl,poss_dest)
      | load_ireg_locval(VAR_VAL vv, poss_dest) = load_ireg_val(vv,poss_dest)
    fun load_freg_locval(VAR_LOC vl, poss_dest) = load_freg_loc(vl,poss_dest)
      | load_freg_locval(VAR_VAL vv, poss_dest) = load_freg_val(vv,poss_dest)
    fun load_reg_locval(VAR_LOC vl, poss_dest) = load_reg_loc(vl,poss_dest)
      | load_reg_locval(VAR_VAL vv, poss_dest) = load_reg_val(vv,poss_dest)
    fun load_ireg_sv(vl as (VAR_VAL(VINT i))) =
	if (in_imm_range i) then IMM(TW32.toInt i) else REG(load_ireg_locval(vl,NONE))
      | load_ireg_sv vl = REG(load_ireg_locval(vl,NONE))


  (* --------- end of load(sv/int/float) ------------------------------------------ *)



  (* --------- Common Code Sequence Helper Functions ------------------------------ *)

  (* by possibly adding 4 to heapptr, make it odd-quadword aligned;
   if addition took place, store a skip tag first *)
  fun align_odd_word () =
    let val tmp0 = alloc_regi(NOTRACE_INT)
      val tmp1 = alloc_regi(TRACE)
    in add_instr(LI(Rtltags.skiptag,tmp0));
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
    in add_instr(LI(Rtltags.skiptag,tmp0));
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

  fun alloc_global (state,v : var,
		    con : con,
		    lv : loc_or_val) : state =
    let 

	val (label_opt,labels) = 
	    (case (Name.VarMap.find(!exports,v)) of
		 SOME [] => error "no label for export"
	       | SOME (first::rest) => 
		     (SOME(ML_EXTERN_LABEL(Name.label2string first)),
		      map (fn l => ML_EXTERN_LABEL(Name.label2string l)) rest)
	       | NONE => (NONE,[]))

	val (label_opt,vv_opt) = 
	    (case (lv,label_opt) of
               (VAR_VAL vv, NONE) => (NONE,SOME vv)
	     | (_, NONE) => (SOME(LOCAL_LABEL(LOCAL_DATA v)),NONE)
	     | (VAR_VAL vv, SOME _) => (label_opt, SOME vv)
	     | (_, SOME _) => (label_opt, NONE))



      val addr = alloc_regi LABEL
      val loc = alloc_regi LABEL
      val rtl_rep = con2rep state con

      val state' = add_var' state (v,
				   case label_opt of
				       NONE => NONE
				     | SOME label => 
					   SOME(VGLOBAL(label,rtl_rep)),
				   vv_opt,
				   con)
    in  (case label_opt of
	NONE => ()
      | SOME label =>
	    (Stats.counter("RTLglobal") ();
	     (case rtl_rep of
		  (TRACE | COMPUTE _) => add_mutable_variable(label,rtl_rep)
		| _ => ());
	      (case lv of
		   VAR_VAL (VREAL _) => add_data(ALIGN (QUAD))
		 | _ => ());
	       app (fn l => add_data(DLABEL l)) labels;
	       add_data(DLABEL (label));
	       (case lv of
		    VAR_LOC (VREGISTER (_,reg)) => 
			(add_instr(LADDR(label,0,addr));
			 (case reg of
			      I r => (add_data(INT32(i2w 0));
				      add_instr(STORE32I(EA(addr,0),r)))
			    | F r => (add_data(FLOAT "0.0");
				      add_instr(STOREQF(EA(addr,0),r)))))
		  | VAR_LOC (VGLOBAL (l,rep)) => let val value = alloc_regi rep
						 in  (add_data(INT32 0w99);
						      add_instr(LADDR(label,0,addr));
						      add_instr(LADDR(l,0,loc));
						      add_instr(LOAD32I(EA(loc,0),value));
						      add_instr(STORE32I(EA(addr,0),value)))
						 end
		  | VAR_VAL (VVOID _) => error "alloc_global got nvoid"
		  | VAR_VAL (VINT w32) => add_data(INT32 w32)
		  | VAR_VAL (VREAL l) => add_data(DATA l)
		  | VAR_VAL (VRECORD (l,_)) => add_data(DATA l)
		  | VAR_VAL (VLABEL l) => add_data(DATA l)
		  | VAR_VAL (VCODE l) => add_data(DATA l))));
	state'
    end

  fun alloc_conglobal (state : state,
		       v : var,
		       lv : loc_or_val,
		       kind : kind,
		       copt : con option) : state = 
    let 
	(* we lay out the convar as a global if it is exported or we
	   don't already know its value; if the value is known and
	   it is not exported, then later code will simply use the VAR_VAL *)
	val (label_opt,labels) = 
	    (case (Name.VarMap.find(!exports,v)) of
		 SOME [] => error "no label for export"
	       | SOME (first::rest) => 
		     (SOME(ML_EXTERN_LABEL(Name.label2string first)),
		      map (fn l => ML_EXTERN_LABEL(Name.label2string l)) rest)
	       | NONE => (NONE,[]))
	val (label_opt,vv_opt) = 
	    (case (lv,label_opt) of
               (VAR_VAL vv, NONE) => (NONE,SOME vv)
	     | (_, NONE) => (SOME(named_local_data_label v),NONE)
	     | (VAR_VAL vv, SOME _) => (label_opt, SOME vv)
	     | (_, SOME _) => (label_opt, NONE))
      val state' = add_convar state(v,
				    case label_opt of
					NONE => NONE
				      | SOME label => 
					    SOME(VGLOBAL(label,TRACE)),
				    vv_opt, kind, copt)
    in
	(case label_opt of
	    SOME label => 
		let val _ = Stats.counter("RTLconglobal") ()
		    val addr = alloc_regi LABEL
		    val _ = add_mutable_variable(label,TRACE)
		in 
		    app (fn l => add_data(DLABEL l)) labels;
		    add_data(DLABEL (label));
		    (case lv of
			 (VAR_VAL(VLABEL l)) => add_data(DATA l)
		       | _ => (let val ir = load_ireg_locval(lv,NONE)
			       in  add_data(INT32(i2w 0));
				   add_instr(LADDR(label,0,addr));
				   add_instr(STORE32I(EA(addr,0),ir))
			       end))
		end
	    | NONE => ());
	state'
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

  fun boxFloat_vl (state,lv) : loc_or_val * state = 
      (case lv of
	  VAR_LOC(VREGISTER (_,F fr)) => let val (ir,state) = boxFloat(state,fr)
				       in  (VAR_LOC(VREGISTER (false,I ir)), state)
				       end
	| VAR_LOC(VREGISTER (_,I _)) => error "float in int reg"
	| VAR_LOC(VGLOBAL (l,_)) => (VAR_VAL(VLABEL l), state)
	| VAR_VAL(VINT _) => error "can't boxfloat an int"
	| VAR_VAL(VREAL l) => (VAR_VAL(VLABEL l), state)
	| VAR_VAL(VRECORD _) => error "can't boxfloat a record"
	| VAR_VAL(VVOID _) => error "can't boxfloat a void"
	| VAR_VAL(VLABEL _) => error "can't boxfloat a label; labels can't be floats"
	| VAR_VAL(VCODE _) => error "can't boxfloat a code")

 (* code for allocating an fp array at run-time given a list of var_locs: return an ireg *)
       
 fun fparray (state, val_locs : loc_or_val list) : regi * state = 
    let 
      val res = alloc_regi TRACE
      val len = length val_locs
      fun scan (nil,_) = ()
	| scan (h::t,offset) =
	  let val src = load_freg_locval (h, NONE)
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
    fun shuffle_regs (src : 'a list,dest : 'a list, 
		      eqreg : ('a * 'a) -> bool,
		      alloc : 'a -> 'a, 
		      mover: ('a * 'a) -> instr) =
      let fun isdest r = member_eq(eqreg,r, dest)
	
	local
	  (* given two lists, zip the lists, and remove any pairs 
	   whose two components are equal.*)
	  fun sieve2 (a,b) =
	    let fun f(h::t,h'::t') =
	      let val (nt,nt') = f (t,t')
	      in if eqreg(h,h') then (nt,nt')
		 else (h::nt,h'::nt')
	      end
		  | f(nil,nil) = (nil,nil)
		  | f _ = error "sieve2"
		      in f (a,b)
		      end
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
  in
    fun shuffle_fregs (src : regf list,dest : regf list) =
      shuffle_regs(src, dest, eqregf, fn (arg) => alloc_regf(), FMV)
    fun shuffle_iregs (src : regi list,dest : regi list) =
      shuffle_regs(src, dest, eqregi, 
		   (fn (REGI(_,rep)) => alloc_regi(rep)
		 | (SREGI EXNARG) => alloc_regi(TRACE)
		 | (SREGI EXNPTR) => alloc_regi(TRACE)
		 | (SREGI _) => alloc_regi(NOTRACE_INT))
		   , MV)
  end


  (* -- create a record given a list of tagwords for the fields,
   the first n fields which are already in integer registers,
   and the rest of the fields, which are values *)


  fun make_record_help (const, state, destopt, _ , []) : loc_or_val * state = (VAR_VAL unitval, state)
    | make_record_help (const, state, destopt, reps : rep list, vl : loc_or_val list) = 
    let 

	val _ = add_instr(ICOMMENT ("allocating " ^ (Int.toString (length vl)) ^ "-record"))
	val tagwords = mk_recordtag reps
	val dest = (case destopt of
			NONE => alloc_regi TRACE
		      | SOME d => d)
	val tagwords = 
	    if (not (!HeapProfile))
		then tagwords
	    else ({dynamic=nil,static=MakeProfileTag()}) :: tagwords
        (* total number of words needed *)
	val words_alloced = length vl+length tagwords


	(* shadow heapptr with thunk to prevent accidental use *)
	val (heapptr,state) = 
	    if const
		then let fun f _ = error "should not use heapptr here"
		     in (add_data(COMMENT "static record tag");
			 (f, state))
		     end
	    else let val state = needgc(state,IMM(words_alloced))
		 in  (fn _ => heapptr, state)
		 end

	fun scan_vals (offset,[]) = offset
	  | scan_vals (offset,vl::vls) =
	    ((case (const,vl) of
		  (true, VAR_VAL (VINT w32)) => add_data(INT32 w32)
		| (true, VAR_VAL (VRECORD (l,_))) => add_data(DATA l)
		| (true, VAR_VAL (VLABEL l)) => add_data(DATA l)
		| (true, VAR_VAL (VCODE l)) => add_data(DATA l)
		| (true, VAR_VAL (VREAL l)) => add_data(DATA l)
		| (true, VAR_VAL (VVOID _)) => error "make_record given VVOID"
		| _ => let val r = load_ireg_locval(vl,NONE)
		       in  if const 
			       then 
				   let val fieldl = alloc_local_data_label "var_loc"
				       val addr = alloc_regi LABEL
				   in  (add_data(DLABEL fieldl);
					add_data(INT32 0w0);
					add_instr(LADDR(fieldl,0,addr));
					add_instr(STORE32I(EA(addr,0),r)))
				   end
			   else add_instr(STORE32I(EA(heapptr(),offset),r))  (* allocation - not a mutation *)
		       end);
	    scan_vals(offset+4,vls))

        (* sometime the tags must be computed at run-time *)
	fun do_dynamic (r,{bitpos,path}) =
	    let val tipe = 
		case path of
		    Var_p regi => regi
		  | Projvar_p (regi,indices) =>
			let val tipe = alloc_regi TRACE
			    fun loop src [] = ()
			      | loop src (i::rest) = (add_instr(LOAD32I(EA(src,4*i),tipe)); loop tipe rest)
			in  loop regi indices; tipe
			end
		  | Label_p label =>
			let val addr = alloc_regi LABEL
			    val tipe = alloc_regi TRACE
			in add_instr(LADDR(label,0,addr));
			    add_instr(LOAD32I(EA(addr,0),tipe));
			    tipe
			end
		  | Projlabel_p(label,indices) =>
			let val addr = alloc_regi LABEL
			    val addr' = alloc_regi LABEL
			    val tipe = alloc_regi TRACE
			    fun loop src [] = ()
			      | loop src (i::rest) = (add_instr(LOAD32I(EA(src,4*i),tipe)); loop tipe rest)
			in  add_instr(LADDR(label,0,addr));
			    add_instr(LOAD32I(EA(addr,0),addr'));
			    loop addr' indices;
			    tipe
			end
		  | Notneeded_p => error "record: Notneeded_p hit"
		val tmp1 = alloc_regi NOTRACE_INT
		val tmp2 = alloc_regi NOTRACE_INT
	    in (* add_instr(LI(i2w 0,tmp1));
		add_instr(CMV(NE,tipe,IMM 1,tmp1)); *)
		add_instr(CMPUI(GT, tipe, IMM 3, tmp1)); (* is it not an int *)
		add_instr(SLL(tmp1,IMM (bitpos-1),tmp2));
		add_instr(ORB(tmp2,REG r,r))
	    end

      (* usually, the tags are known at compile time *)	
      fun scantags (offset,nil : Rtltags.tags) = offset
	| scantags (offset,({static,dynamic}::vl) : Rtltags.tags) =
	  (if const
	       then (if (null dynamic)
			 then add_data(INT32 static)
		     else error "making constant record with dynamic tag")
	   else 
	       let val r = alloc_regi(NOTRACE_INT)
	       in  add_instr (LI(static,r));
		   app (fn a => do_dynamic(r,a)) dynamic;
		   add_instr(STORE32I(EA(heapptr(),offset),r)) (* allocation *)
	       end;
	   scantags(offset+4,vl))

      val offset = 0
      val offset = scantags(offset,tagwords);
      val (result,templabelopt) = 
	  if const
	      then let val label = alloc_local_data_label "record"
		   in  (
			add_mutable_object label; 
			add_data(DLABEL label);
			(VAR_VAL(VLABEL label), SOME label))
		   end
	  else (VAR_LOC (VREGISTER (false,I dest)), NONE)

      val offset = scan_vals (offset, vl)
      val _ = if const
		  then ()
	      else (add(heapptr(),4 * length tagwords,dest);
		    add(heapptr(),4 * words_alloced,heapptr()))
      val _ = add_instr(ICOMMENT ("done allocating an " ^ (Int.toString (length vl)) ^ " record"))
    in  (result, state)
    end

  (* These are the interface functions: determines static allocation *)
  fun make_record (state, destopt, reps, vl) = 
      let fun is_varval (VAR_VAL vv) = true 
	    | is_varval _ = false
	  val const = (!do_constant_records andalso (andfold is_varval vl))
      in  make_record_help(const,state,destopt,reps,vl)
      end

  and make_record_const (state, destopt, reps, vl) = 
      make_record_help(!do_forced_constant_records,state, destopt, reps, vl)

  and make_record_mutable (state, destopt, reps, vl) = 
      make_record_help(false,state, destopt, reps, vl)


end