(* empty records translate to 256; no allocation *)
(* to do: strive for VLABEL not VGLOBAL *)
(* xtagsum_dynamic record case is fragile *)

(* A state contains classification information(type/kind),
                    residence information(register/global label),
		    and value information(int/label).
		    Only one of the latter two must be present.
   There is a current state and a global state.
   The latter contains only variables that have to be globally visible,
      This is a subset of variables bound at the top-level (outside any lambda).
      It is a subset because we would like unreferenced top-level variables to reside
      in registers, thus reducing a proliferation of global labels. 
      However, we consider all top-level type variables (say a) to be global even if not
      apparently used inside a lambda since a type reduction of a type term (b = {l = a})
      containing another global type variable(b) may yield to this type variable a.
      All imported variables are both top-level and global.  
      The check for global and top-level variables must also consider exports.
*)
   

functor Tortl(structure Rtl : RTL
	      structure Pprtl : PPRTL
	      structure TortlBase : TORTL_BASE 
	      structure Rtltags : RTLTAGS 
	      structure Nil : NIL
	      structure NilContext : NILCONTEXT
	      structure NilStatic : NILSTATIC
	      structure NilUtil : NILUTIL
	      structure Ppnil : PPNIL
	      sharing Ppnil.Nil = NilUtil.Nil = NilContext.Nil = NilStatic.Nil = TortlBase.Nil = Nil
	      sharing Pprtl.Rtltags = Rtltags
	      sharing Rtl = Pprtl.Rtl = TortlBase.Rtl
	      sharing type NilStatic.context = NilContext.context)
    : TORTL =
struct

val do_constant_records = ref true
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
    open TortlBase

    val exncounter_label = ML_EXTERN_LABEL "exncounter"
    val error = fn s => (Util.error "tortl.sml" s)
    structure TW32 = TilWord32
    structure TW64 = TilWord64
    val w2i = TW32.toInt
    val i2w = TW32.fromInt;

       val local_sub = Name.fresh_named_var "local_subscript"
       val local_update = Name.fresh_named_var "local_update"
       val local_array = Name.fresh_named_var "local_array"
       val local_sub_used = ref false
       val local_update_used = ref false
       val local_array_used = ref false
       val con_depth = ref 0
       val exp_depth = ref 0
       fun resetDepth() = (con_depth := 0;
			   exp_depth := 0)

      
   type translate_params = { HeapProfile : int option, do_write_list : bool, 
                             codeAlign : Rtl.align, FullConditionalBranch : bool, 
                             elim_tail_call : bool, recognize_constants : bool }
   val cur_params = ref { HeapProfile = NONE : int option, 
			 do_write_list = true,
			 codeAlign = Rtl.OCTA, FullConditionalBranch = false, 
			 elim_tail_call = true, recognize_constants = true}


   datatype work = FunWork of (state * var * function)
                 | ConFunWork of (state * var * (var * kind) list * con * kind)
   local
       val worklist : work list ref = ref nil
       val workcount = ref 0
   in
       fun addWork more = (worklist := more :: (!worklist))
       fun getWork() = (case (!worklist) of
			    [] => NONE
			  | (a::b) => (workcount := (!workcount) + 1;
				       worklist := b; SOME (!workcount, a)))
       fun resetWork() = (workcount := 0; worklist := [])
   end

  (* Context: is the context around an expression the identity
   context, or not the identity context.   The identity context
   carries the register containing the return address for the
   function with it.*)
  
  datatype context = ID of regi | NOTID
   
  fun xbnd state (bnd : bnd) : state =
      (case bnd of
	      Con_b (v,k,c) => 
		  let val (_,lv,k,state) = xcon'(state,v,c,SOME k)
		      val s' =  
			(if (istoplevel())
			     then alloc_conglobal (state,v,lv,k,SOME c)
			 else (case lv of
			   VAR_LOC vl => add_convar state (v,SOME vl,NONE,k , SOME c)
			 | VAR_VAL vv => add_convar state (v,NONE,SOME vv, k, SOME c)))
		  in  s'
		  end
	    | Exp_b (v,c,e) => 
		  let val (loc_or_val,_,state) = xexp(state,v,e,SOME c,NOTID)
		      val s' = (if istoplevel() 
				    then alloc_global (state,v,c,loc_or_val)
				else 
				    case loc_or_val of
					VAR_LOC(var_loc) => add_varloc state (v,var_loc,c)
				      | VAR_VAL(var_val) => 
					    let val reg = load_reg_val(var_val, NONE)
					    in  add_var' state (v,SOME(VREGISTER reg),SOME var_val,c)
					    end)
		  in  s'
		  end
	    | Fixopen_b (var_fun_set : (var,function) Nil.set) => error "no open functions permitted"
	    | Fixcode_b (var_fun_set : (var,function) Nil.set) => 
		  let 
		      fun folder ((v,f as Function(effect,recur,vklist,vclist,vflist,b,c)),s) =
			  let val funcon = AllArrow_c(Code,effect,vklist,map #2 vclist,
						      TW32.fromInt (length vflist),c)
			  in  add_code s (v, LOCAL_LABEL (LOCAL_CODE v), funcon)
			  end
		      val var_fun_list = (sequence2list var_fun_set)
		      val state = foldl folder state var_fun_list
		      val s' = promote_maps (istoplevel()) state
		      val _ = app (fn (v,f) => addWork (FunWork(s',v,f))) var_fun_list
		  in state
		  end
	    | Fixclosure_b (is_recur,var_varconexpset) => 
		  let 
		      val var_vcelist = sequence2list var_varconexpset
		      val _ = add_instr(ICOMMENT ("allocating " ^ 
						  (Int.toString (length var_vcelist)) ^ " closures"))
		      fun loadcl ((v,{code,cenv,venv,tipe}),state) = 
			  let val (code_lv,_,state) = xexp(state,fresh_named_var "codereg",Var_e code,NONE,NOTID)
			      val (_,con_lv,_,state) = xcon'(state,fresh_named_var "cenv", cenv,NONE)
			      val (exp_lv,_,state) = if is_recur
					       then (VAR_VAL(VINT 0w0),Crecord_c[],state)
					   else xexp(state,fresh_named_var "venv",venv,NONE,NOTID)
			      val vls = [code_lv,
					 con_lv,
					 exp_lv]
			      val reps = [NOTRACE_CODE, TRACE, TRACE]
			      val (lv,state) = make_record_mutable(state,NONE,reps,vls)
			      val ir = load_ireg_locval(lv,NONE)
			      val s' = if (istoplevel())
					   then alloc_global(state,v,tipe,lv)
				       else add_var state (v,I(load_ireg_locval(lv,NONE)),tipe)
			  in  (ir,s')
			  end
		      val (clregsi,rec_state) = foldl_list loadcl state var_vcelist
		      fun dowrite (clregi, (_,{code,cenv,venv,tipe}),s) = 
				   let val (I ir,_,s) = xexp'(s,fresh_named_var "venv", venv, NONE, NOTID)
				   in  (add_instr(STORE32I(EA(clregi,8), ir)); s)
				   end
		      val _ = if is_recur 
				  then (foldl2 dowrite rec_state (clregsi, var_vcelist); ())
			      else ()
		      val _ = add_instr(ICOMMENT ("done allocating " ^ 
						  (Int.toString (length var_vcelist)) ^ " closures"))
		  in  rec_state
		  end)

  
  and xconbnd state (cbnd : conbnd) : state = 
      (case cbnd of
	   Con_cb (v,k,c) => let val (_,lv,k,state) = xcon'(state,v,c,SOME k)
			     in  case lv of
				 VAR_LOC vl => add_convar state (v,SOME vl,NONE,k,SOME c)
			       | VAR_VAL vv => add_convar state (v,NONE,SOME vv,k,SOME c)
			     end
	 | Code_cb (conwork as (name,vklist,c,k)) => 
			     let val funkind = Arrow_k(Code,vklist,k)
				 val l = LOCAL_LABEL(LOCAL_CODE name)
				 val state = add_concode state (name,l,funkind,
								SOME(Let_c(Sequential,[cbnd],Var_c name)))
				 val s' = promote_maps (istoplevel()) state
			     in  (addWork (ConFunWork(s',name,vklist,c,k)); state)
			     end
	 | Open_cb _ => (print "open Fun_cb:\n";
			     Ppnil.pp_conbnd cbnd; print "\n";
			     error "open Fun_cb"))

  and xconst (state : state, arg_v : (con,exp) Prim.value) 
      : loc_or_val * con * state =
      let
	  open Prim
	  open TW64
	  fun xvector (c,a : exp Array.array) : loc_or_val * con * state =
	      let 
		  val label = alloc_local_data_label "string"
		  val sz = Array.length a
		  val tagword = TW32.orb(TW32.lshift(TW32.fromInt sz,int_len_offset),intarray)
		  val _ = add_data(COMMENT "static string tag")
		  val _ = add_data(INT32 tagword)
		  val _ = add_data(DLABEL label)
		  val (state,vl) = (Array.foldr (fn (e,(state,vls)) => 
					 let val (a,b,state) = xexp(state,Name.fresh_var(),e,NONE,NOTID)
					 in  (state,(a,b)::vls)
					 end)
				    (state,[]) a)
		  fun layout segsize packager = 
		  let fun pack [] = ()
			| pack acc = packager(rev acc)
		      fun loop ls 0 acc = (pack acc; loop ls segsize [])
			| loop [] remain acc = pack acc
			| loop (a::rest) remain acc = loop rest (remain-1) (a::acc)
		  in  loop vl segsize []
		  end
		  fun getword(VAR_VAL(VINT w), _) = w
		    | getword vl = (print "bad value in vector: ";
				    print "\n";
				    error "bad string")
		  fun boxfloat_packager [(VAR_VAL(VREAL l),_)] = add_data(DATA l)
		    | boxfloat_packager [(VAR_VAL(VLABEL l),_)] = add_data(DATA l)
		    | boxfloat_packager _ = error "did not receive 1 boxed float"
		  fun word_packager [w] = add_data(INT32(getword w))
		    | word_packager _ = error "did not receive 1 word"
		  fun char_packager vals = 
		      let val (a,b,c,d) = (case (map getword vals) of
					       [a,b,c,d] => (a,b,c,d)
					     | [a,b,c] => (a,b,c,TW32.zero)
					     | [a,b] => (a,b,TW32.zero,TW32.zero)
					     | [a] => (a,TW32.zero,TW32.zero,TW32.zero)
					     | _ => error "did not receieve 1 to 4 characters")
			  val b = TW32.lshift(b,8)
			  val c = TW32.lshift(c,16)
			  val d = TW32.lshift(d,24)
		      in  add_data(INT32 (TW32.orb(TW32.orb(a,b),TW32.orb(c,d))))
		      end
		  val c = (case c of
			       Prim_c _ => c
			     | _ => #2(simplify_type state c))
		  val _ = (case c of
			       Prim_c(Int_c Prim.W8, []) => layout 4 char_packager
			     | Prim_c(Int_c Prim.W32, []) => layout 1 word_packager
			     | Prim_c(BoxFloat_c Prim.F64, []) => layout 1 boxfloat_packager
			     | _ => (print "xvector not done on type = \n";
				     Ppnil.pp_con c; print "\n";
				     error "xvector not fully done"))
	      in  (VAR_VAL(VLABEL label), Prim_c(Vector_c, [c]), state)
	      end
      in
	  (case arg_v of
	       ((uint (ws as (W8 | W16 | W32),w64)) |
		(int (ws as (W8 | W16 | W32),w64))) =>  
	       let val w32 = TW64.toUnsignedHalf w64
	       in  (VAR_VAL(VINT w32), Prim_c(Int_c ws, []),state)
	       end
	      | ((uint (W64, _)) | (int (W64, _))) => error "64-bit ints not done"
	      | (float (F64, s)) => (VAR_VAL(VREAL (mk_float_data s)), Prim_c(Float_c F64, []),state)				    
	      | (float (F32, _)) => error "32 bit floats not done"
	      | (vector (c,a)) => xvector(c,a)
	      | (array _ | refcell _) => error "array/vector/refcell constants not implemented"
	      | (tag(t,c)) => let val i = TW32.fromInt (tag2int t)
			      in  (VAR_VAL(VINT i), Prim_c(Int_c W32, []),state)
			      end)
      end



  and xexp' (state : state, (* state of bound variables *)
	     name : var, (* Purely for debugging and generation of useful names *)
	     e : exp,    (* The expression being translated *)
	     copt : con option,    (* The type of the expression being translated *)
	     context     (* The evaluation context this expression is in *)
	     ) : reg * con * state =
      (case xexp(state,name,e,copt,context) of
	   (VAR_LOC var_loc, c, s) => (load_reg_loc(var_loc,NONE),c, s)
	 | (VAR_VAL var_val, c, s) => (load_reg_val(var_val,NONE),c, s))

  and xexp (state : state, (* state of bound variables *)
	    name  : var, (* Purely for debugging and generation of useful names *)
	    arg_e : exp,         (* The expression being translated *)
	    copt  : con option,  (* The type of the expression being translated *)
	    context     (* The evaluation context this expression is in *)
	    ) : loc_or_val * con * state =
      let 
	  val _ = exp_depth := !exp_depth + 1
	  val _ = if (!debug)
		      then (print "xexp ";  print (Int.toString (!exp_depth));
			    print " called";
			    if (!debug_full)
				then (print " on exp = \n";
				      Ppnil.pp_exp arg_e)
			    else ();
			    print "\n")
		  else ()  
	  val res = xexp''(state,name,arg_e,copt,context)
	  val _ = if (!debug)
		      then (print "xexp ";  print (Int.toString (!exp_depth));
			    print " returned\n")
		  else ()
	  val _ = exp_depth := !exp_depth - 1
	      
      in  res
      end

  and xexp'' (state : state, (* state of bound variables *)
	    name  : var, (* Purely for debugging and generation of useful names *)
	    arg_e : exp,         (* The expression being translated *)
	    copt  : con option,  (* The type of the expression being translated *)
	    context     (* The evaluation context this expression is in *)
	    ) : loc_or_val * con * state =
      let 
	  fun pickdesti rep = alloc_named_regi name rep
	  fun pickdestf () = alloc_named_regf name
	  val res = 
	  case arg_e of
	      Var_e v => (case (getrep state v) of
			      (_,SOME vv,c) => (VAR_VAL vv, c, state)
			    | (SOME vl,_,c) => (VAR_LOC vl, c, state)
			    | (NONE,NONE,_) => error "no info on var")
	    | Const_e v => xconst(state,v)
	    | Let_e (_, bnds, body) => 
		  let fun folder (bnd,s) = xbnd s bnd
		      val state = foldl folder state bnds
		      val (lv,c,state) = xexp(state,fresh_var(),body,copt,context)
		      val cbnds = List.mapPartial (fn (Con_b vkc) => SOME(Con_cb vkc)
		    | _ => NONE) bnds
		      val c' = Let_c(Sequential,cbnds,c)
		  in  (lv,c',state)
		  end
	    | Prim_e (NilPrimOp nilprim, clist, elist) => xnilprim(state,nilprim,clist,elist,context,copt)
	    | Prim_e (PrimOp prim, clist, elist) => xprim(state,prim,clist,elist,context)
	    | Switch_e sw => xswitch(state,name,sw,copt,context)
	    | App_e (openness, f, clist, elist, eflist) => (* assume the environment is passed in first *)
		  let 
		      val callcount = Stats.counter("RTLcall")()
		      val call_type = 
			      (case openness of
				    Open => error "no open calls permitted here"
				  | Code => "direct call "
				  | ExternCode => "direct extern call "
				  | Closure => (if (length elist = 0 andalso length eflist = 0)
						    then "closure polycall"
						else "closure call ")
				    ^ (Int.toString callcount))
		      local

			  val _ = add_instr (ICOMMENT ("making " ^ call_type))


			  fun cfolder (c,state) =
			      let val (res,_,state) = xcon(state,fresh_named_var "call_carg", c, NONE)
			      in  (res,state)
			      end
			  fun efolder(e,state) = 
			      let val (res,_,state) = xexp'(state,fresh_named_var "call_e", 
							    e, NONE, NOTID)
			      in  (res,state)
			      end

			  val (cregsi,state) = foldl_list cfolder state clist
			  val (eregs, state) = foldl_list efolder state elist
			  val (efregs, state) = foldl_list efolder state eflist

			  val (extern_call,selfcall,fun_reglabel,funcon,cregsi',eregs',state) = 
			      (case (openness,f) of
				   ((ExternCode | Code),Var_e expvar) =>
				       let 
					   val (vlopt,vvopt,funcon) = getrep state expvar
				       in  (openness = ExternCode,
					    (case (getCurrentFun()) of
						 LOCAL_CODE v => eq_var(expvar,v)
					       | _ => false),
					    (case (vlopt,vvopt) of
						 (NONE,SOME(VCODE l)) => LABEL' l
					       | (SOME(VREGISTER (I r)),_) => REG' r
					       | (SOME(VGLOBAL (l,_)),_) => let val addr = alloc_regi LABEL
										val reg = alloc_regi NOTRACE_CODE
									    in  (add_instr(LADDR(l,0,addr));
										 add_instr(LOAD32I(EA(addr,0),reg));
										 REG' reg)
									    end
					       | _ => error "bad varloc or varval for function"),
					    funcon, [], [],state)
				       end
				 | (Closure,cl) =>
				       let val (clreg,funcon,state) = xexp'(state,fresh_var(),cl,NONE,NOTID)
					   val clregi = (case clreg of
							     I ir => ir
							   | F _ => error "closure compiled to float reg")
					   val funregi = alloc_named_regi (fresh_named_var "funreg") NOTRACE_CODE
					   val cregi =  alloc_named_regi (fresh_named_var "creg") TRACE
					   val eregi =  alloc_named_regi (fresh_named_var "ereg") TRACE
					   val _ = (add_instr(LOAD32I(EA(clregi,0),funregi));
						    add_instr(LOAD32I(EA(clregi,4),cregi));
						    add_instr(LOAD32I(EA(clregi,8),eregi)))
				       in  (false, false, REG' funregi, funcon, [cregi], [I eregi],state)
				       end
				 | ((ExternCode | Code),_) => error "ill-formed application"
				 | (Open,_) => error "no open apps allowed")
		      in
			  val extern_call = extern_call
			  val selfcall = selfcall
			  val fun_reglabel = fun_reglabel
			  val cregsi = cregsi
			  val cregsi' = cregsi'
			  val eregs = eregs 
			  val eregs' = eregs'
			  val efregs = efregs
			  fun reduce(vklist,clist,rescon) = 
			      let fun nada _ = NOCHANGE
				  val table = map2 (fn ((v,_),c) => (v,c)) (vklist,clist)
				  fun ch (bound,Var_c v) = (case (assoc_eq(eq_var,v,table)) of
								NONE => NOCHANGE
							      | SOME c => CHANGE_NORECURSE c)
				    | ch _ = NOCHANGE
				  val handlers = (nada,nada,ch,nada,nada)
			      in  con_rewrite handlers rescon
			      end
			  val rescon = 
			      (case (copt,funcon) of
				   (SOME c,_) => c
				 | (NONE,AllArrow_c(_,_,vklist,_,_,rescon)) => reduce(vklist,clist,rescon)
				 | (_,c) => 
				       (case #2(simplify_type state c) of
					    AllArrow_c(_,_,vklist,_,_,rescon) => reduce(vklist,clist,rescon)
					  | c => (print "cannot compute type of result of call\n";
						  print "funcon = \n"; Ppnil.pp_con funcon; print "\n";
						  print "reduced to \n"; Ppnil.pp_con c; print "\n";
						  error "cannot compute type of result of call")))
						     
		      end
(*
		      val iregs = (cregsi @ (map (coercei "call") eregs)
				   @ cregsi' @ (map (coercei "call") eregs'))
*)
		      val iregs = (cregsi @ cregsi' @ 
				   (map (coercei "call") eregs) @
				   (map (coercei "call") eregs'))

		      val fregs = map coercef efregs

		      fun do_call return_opt = 
			  let val tailcall=(case return_opt of
						       SOME _ => true
						     | NONE => false)
			      val dest = if tailcall
					     then getResult()
					 else alloc_reg state rescon
			      val results = (case dest of
						 F fr => ([],[fr])
					       | I ir => ([ir],[]))	      
			      val _ = add_instr(CALL{extern_call = extern_call,
						     func=fun_reglabel,
						     return=return_opt,
						     args=(iregs,fregs),
						     results=results,
						     tailcall = tailcall,
						     save=SAVE(getLocals())})
			  in  dest
			  end
		      val dest = (case (context,#elim_tail_call(!cur_params),selfcall) of
					(NOTID,_,_) => do_call NONE
				      | (_, false,_) => do_call NONE
				      | (ID r,true,true) =>  
					    (shuffle_iregs(iregs,getArgI());
					     shuffle_fregs(fregs,getArgF());
					     add_instr(BR (getTop()));
					     alloc_reg state rescon)
				      | (ID r,true,false) => do_call (SOME r))
		      val result = (VAR_LOC(VREGISTER dest), rescon,
				     new_gcstate state)
		      val _ = add_instr (ICOMMENT ("done making " ^ call_type))

		  in  result
		  end

	    | Raise_e (exp, con) =>
		  let val (I ir,_,state) = xexp'(state,name,exp,SOME(Prim_c(Exn_c,[])),NOTID)
		      val newpc = alloc_regi LABEL
		      val rep = con2rep state con
		  in  add_instr(LOAD32I(EA(exnptr,0),newpc));
		      add_instr(MV (ir,exnarg));
		      add_instr RESTORE_CS;
		      add_instr (JMP(newpc,nil));
		      (VAR_VAL(VVOID rep), con, state)
		  end
            (* --- We rely on the runtime to unwind the stack so we don't need to save the
	           free variables of the continuation of this expression. *)
	    | Handle_e (exp, Function(effect,recur,
				      [],[(exnvar,exncon)], [], handler_body, hcon)) => 
		  let
		      (* compute free variables that need to be saved for handler *)


		      local
			  val handler_body' = Let_e(Sequential,[Exp_b(exnvar,exncon,NilUtil.match_exn)],
						    handler_body)
			  val (free_evars,free_cvars) = NilUtil.freeExpConVarInExp(false, handler_body')
			  val evar_reps = map (fn v => #1(getrep state v)) free_evars
			  val free_cvars = (List.filter 
					    (fn v => (case (getconvarrep' state v) of
							  NONE => false
							| SOME _ => true)) free_cvars)
			  val cvar_reps = map (fn v => #1(getconvarrep state v)) free_cvars
			  val vlopts = cvar_reps @ evar_reps
			  fun loop [] (irep,ir,fr) = (irep,ir,fr)
			    | loop (vlopt::rest) (irep,ir,fr) = 
			      (case vlopt of
				   SOME(VREGISTER (I (r as (REGI (_,rep))))) => loop rest 
				       (rep::irep,r::ir,fr)
				 | SOME(VREGISTER (I (SREGI _))) => error "SREGI free in handler!!!"
				 | SOME(VREGISTER (F r)) => loop rest (irep,ir,r::fr)
				  (* don't need to save globals - or varval only *)
				 | SOME(VGLOBAL _) => loop rest (irep,ir,fr)
				 | NONE => loop rest (irep,ir,fr))
		      in
			  val (local_int_reps,local_iregs, local_fregs) = loop vlopts ([],[],[])
		      end



		      val hl = alloc_code_label "exn_handler"
		      val hlreg = alloc_regi LABEL
		      val bl = alloc_code_label "exn_after"

		      val reps = (LABEL :: LABEL :: TRACE :: local_int_reps)

		      val (fpbase,state) = (* --- save the floating point values, if any *)
			  (case local_fregs of
			       [] => (NONE,state)
			     | _ => let val (ir,state) = (fparray(state,map (VAR_LOC o VREGISTER o F) local_fregs))
				    in  (SOME ir, state)
				    end)


		      (* --- create the exn record and set the exnptr to it to install it *)
		      val int_vallocs = (map (VAR_LOC o VREGISTER o I) 
					 ([hlreg, stackptr,exnptr] @ local_iregs))
		      val _ = add_instr(LADDR(LOCAL_LABEL hl,0,hlreg))
		      val (_,state) = make_record(state,SOME exnptr,reps, int_vallocs)
			  

                      (* --- compute the body; restore the exnpointer; branch to after handler *)
		      (* NOTID and not context because we have to remove the exnrecord *)
		      val (reg,arg_c,state) = xexp'(state,name,exp,copt,NOTID)
		      val _ = (add_instr(LOAD32I(EA(exnptr,8),exnptr));
			       add_instr(BR bl));


		      (* --- now the code for handler --- *)
		      val _ = add_instr(ILABEL hl)

		      (* --- restore the int registers - stack-pointer FIRST --- *)
		      val _ = let 
				  val int_regs =
				      (case fpbase of
					   SOME r => [stackptr, exnptr, r] 
					 | NONE => [stackptr, exnptr]) @ local_iregs
				  fun f (h :: t,offset) =
				      (if eqregi(h,exnptr) then ()
				       else add_instr(LOAD32I(EA(exnptr,offset),h));
					   f (t,offset+4))
				    | f (nil,offset) = ()
			      in f (int_regs,4)
			      end


		      (* --- restore the float registers --- *)			  
		      val _ = let fun f (base, h :: t,offset) = 
			                    (add_instr(LOADQF(EA(base,offset),h));
					     f (base, t,offset+8))
				    | f (base,nil,offset) = ()
			      in (case fpbase of
				      SOME base => f (base,local_fregs,0)
				    | NONE => ())
			      end
			  
		      (* --- now that stack-pointer is restored, 
		         ---    we can move the exn arg 
		         ---    we can call new_gcstate 
		         ---    note that since the exnarg and ra register are the same
		                  the exn arg must be moved before the gc_check *)
		      val xr = alloc_named_regi exnvar TRACE
		      val _ = add_instr(MV(exnarg,xr))
		      val hstate = new_gcstate state
		      val hstate = add_var hstate (exnvar,I xr,exncon)


                      (* --- restore exnptr; compute the handler; move result into same register
                             as result reg of expression; add after label; and fall-through *)
		      val _ = add_instr(LOAD32I(EA(exnptr,8),exnptr))
		      val (hreg,_,hstate) = xexp'(hstate,name,handler_body,SOME hcon,context)
		      val _ = (case (hreg,reg) of
				   (I hreg,I reg) => add_instr(MV(hreg,reg))
				 | (F hreg,F reg) => add_instr(FMV(hreg,reg))
				 | _ => error "hreg/ireg mismatch in handler")
		      val _ = add_instr(ILABEL bl)
		      val state = join_states[state,hstate]

		  in 
		      (* for debugging, should check that arg_c and hcon are the same *)
		      (VAR_LOC(VREGISTER reg), arg_c, state)
		  end
	    | Handle_e _ => error "ill-formed handler"

(*
	  val _ = (print "xexp translating: ";
		   Ppnil.pp_exp arg_e;
		   print "\nreturning a";
		   case #1 res of
		       (VAR_VAL (VINT _)) => (print "varval int\n")
		     | (VAR_VAL (VREAL _)) => (print "varval float\n")
		     | (VAR_VAL (VRECORD _)) => (print "varval record\n")
		     | (VAR_VAL (VLABEL _)) => (print "varval label\n")
		     | (VAR_VAL (VCODE _)) => (print "varval code\n")
		     | (VAR_VAL (VVOID _)) => (print "varval void\n")
		     | (VAR_LOC _) => (print "varloc\n"))
*)

      in res
      end



      (* The trick is to notice that for certain args, the comparison and computation
         can be folded into one instruction. *)
      and zero_one (state : state, r : regi, copt : con option, zeroexp, oneexp, context) : loc_or_val * con * state = 
	  let 
	      val thenl = alloc_code_label "zero_case"
	      val elsel = alloc_code_label "one_case"
	      val afterl = alloc_code_label "after_zeroone"
	      val _ = add_instr(BCNDI(NE,r,elsel,false))
	      val _ = add_instr(ILABEL thenl)
	      val (zero,zcon,state_zero) = xexp'(state,fresh_named_var "zero_result", zeroexp, copt, context)
	      val result = zero
	      val _ = add_instr(BR afterl)
	      val _ = add_instr(ILABEL elsel)
	      val (one,ocon,state_one) = xexp'(state,fresh_named_var "nonzero_result", oneexp, copt, context)
	      val state = join_states[state_zero,state_one]
	      val _ = (case (zero,one) of 
			   (I zz, I oo) => add_instr(MV (oo,zz))
			 | (F zz, F oo) => add_instr(FMV (oo,zz))
			 | _ => error "zero_one: different arms have results in float and int registers")
	      val _ = add_instr(ILABEL afterl)
	  in (VAR_LOC (VREGISTER result), zcon,state)
	  end


  and xswitch (state : state,
	       name : var,  (* Purely for debugging and generation of useful names *)
	       sw : switch, (* The switch expression being translated *)
	       arg_c : con option, (* The type of the switch expression *)
	       context      (* The evaluation context this expression is in *)
	       ) : loc_or_val * con * state =
      let
	  val rescon = ref NONE
	  val dest = ref NONE
	  fun mv (r,c) = (case (r,!dest) of
			      (_,NONE) => (dest := (SOME r); rescon := (SOME c))
			    | (I ir1, SOME(I ir2)) => add_instr(MV(ir1,ir2))
			    | (F fr1, SOME(F fr2)) => add_instr(FMV(fr1,fr2))
			    | _ => error "register mismatch")
	  fun get_body (Function(_,_,[],[],[],e,c)) = e
	    | get_body _ = error "get_body of xswitch got a function with arguments"
	  fun no_match state = 
	      (case (!rescon) of
		   SOME c => let val (r,c,newstate) = xexp'(state,fresh_var(),Raise_e(NilUtil.match_exn,c),
				       NONE, NOTID)
			     in  mv(r,c); newstate
			     end
		 | NONE => error "empty switch statement")
	  val switchcount = Stats.counter("RTLswitch")()
      in
	  case sw of
	      Intsw_e {info, arg, arms, default} => 
		  let val (r,state) = (case (xexp'(state,fresh_named_var "intsw_arg",arg,
					   SOME(Prim_c(Int_c info,[])),NOTID)) of
				   (I ireg,_,state) => (ireg,state)
				 | (F _,_,_) => error "intsw argument in float register")
		  in  case (arms,default) of
		      ([(0w0,z)],SOME e) => zero_one(state, r, arg_c, get_body z, e, context)
		    | ([(0w0,z),(0w1,one)],NONE) => zero_one(state, r, arg_c, 
							     get_body z, get_body one, context)
		    | _ => (* general case *)
			  let 
			      val afterl = alloc_code_label "after_intcase"
			      fun scan(states,lab,[]) = 
				  (add_instr(ILABEL lab);
				   case default of
				       NONE => (no_match state::states)
				     | SOME e => 
					   let val (r,c,newstate) = (xexp'(state,fresh_var(),e,arg_c,context))
					   in  mv(r,c); newstate::states
					   end)
				| scan(states,lab,(i,Function(_,_,_,_,_,body,con))::rest) = 
				  let val next = alloc_code_label "intarm"
				      val test = alloc_regi(NOTRACE_INT)
				  in  add_instr(ILABEL lab);
				      (if in_imm_range i then
					  add_instr(CMPSI(EQ,r,IMM(w2i i),test))
				      else 
					  let val tmp = alloc_regi(NOTRACE_INT)
					  in add_instr(LI(i,tmp));
					      add_instr(CMPSI(EQ,r,REG tmp,test))
					  end);
				      add_instr(BCNDI(EQ,test,next,true));
				      let val (r,c,newstate) = 
					  xexp'(state,fresh_var(),body,SOME con,context)
				      in  mv(r,c);
					  add_instr(BR afterl);
					  scan(newstate::states,next,rest)
				      end
				  end
			      val new_states = scan([],alloc_code_label "intarm",arms)
			      val state = join_states new_states
			  in  
			      add_instr(ILABEL afterl);
			      case (!dest,!rescon) of
				  (SOME r,SOME c) => (VAR_LOC(VREGISTER r),c,state)
				| _ => error "no arms"
			  end
		  end
	    | Exncase_e {info, arg, arms, default} => 
		  let
		      val (I exnarg,_,state) = xexp'(state,fresh_named_var "exntsw_arg",arg,NONE,NOTID)

		      val exntag = alloc_regi(NOTRACE_INT)
		      val _ = add_instr(LOAD32I(EA(exnarg,0),exntag))
		      val afterl = alloc_code_label "after+exncase"
		      fun scan(states,lab,[]) =
			  (add_instr(ILABEL lab);
			   case default of
			       NONE => 
				   let val con = (case !rescon of
						  SOME c => c 
						| NONE => error "no arms")
				       val (r,c,newstate) = xexp'(state,fresh_var(),Raise_e(arg,con),SOME con,context)
				   in  mv(r,c); newstate :: states
				   end
			     | SOME e => 
				   let val (r,c,newstate) = xexp'(state,fresh_var(),e,arg_c,context)
				   in  mv(r,c); newstate :: states
				   end)
			| scan(states,lab,(armtag,Function(_,_,_,[(v,c)],_,body,con))::rest) = 
			  let 
			      val next = alloc_code_label "exnarm"
			      val test = alloc_regi(NOTRACE_INT)
			      val carried = alloc_reg state c
			      val carriedi = (case carried of
						  I ir => ir
						| _ => error "carried value is an unboxed float")
			      val state = add_var state (v,carried,c)
			      val _ = add_instr(ILABEL lab)
			      val (I armtagi,_,state) = xexp'(state,fresh_var(),armtag,NONE,NOTID)
			  in  add_instr(CMPSI(EQ,exntag,REG armtagi,test));
			      add_instr(BCNDI(EQ,test,next,true));
			      add_instr(LOAD32I(EA(exnarg,4),carriedi));
			      let val (r,c,state) = xexp'(state,fresh_var(),body,SOME con,context)
			      in  mv(r,c);
				  add_instr(BR afterl);
				  scan(state::states,next,rest)
			      end
			  end
			| scan(_,_,_) = error "ill-typed exnsw_e Function"
		      val states = scan([],alloc_code_label "exnarm",arms)
		      val state = join_states states
		  in  
		      add_instr(ILABEL afterl);
		      case (!dest,!rescon) of
			  (SOME r,SOME c) => (VAR_LOC(VREGISTER r),c,state)
			| _ => error "no arms"
		  end 
	    | Typecase_e _ => error "typecase_e not implemented"
	    | Sumsw_e {info, arg, arms, default} =>
	      let val (tagcount,cons) = reduce_to_sum "sumsw" state info
	      in 
	       (case (tagcount,cons,arms, default) of
		  (0w2,[], [(0w0,zerofun),(0w1,onefun)], NONE) => 
			let val (r,state) = 
			    (case (xexp'(state,fresh_named_var "intsw_arg",arg,
					 SOME(Prim_c(Sum_c{tagcount=0w2,totalcount=0w2,known=NONE},[])),NOTID)) of
				 (I ireg,_,state) => (ireg,state)
			       | (F _,_,_) => error "intsw argument in float register")
			in  zero_one(state,r, arg_c, get_body zerofun, get_body onefun, context)
			end
		| _ =>
		  let val (I r,_,state) = xexp'(state,fresh_named_var "sumsw_arg",arg,NONE,NOTID)
		      val afterl = alloc_code_label "after_sum"
		      val nomatchl = alloc_code_label "nomatch_sum"
		      val one_carrier = (length cons) = 1
		      val total = TW32.uplus(tagcount, i2w(length cons))
		      val exhaustive = 
			  let val handled = map (fn (w,_) => (w2i w)) arms
			      fun mem i = member(i,handled)
			  in  List.all mem (count (w2i total))
			  end
		      val tag = alloc_regi(NOTRACE_INT)
		      fun scan(newstates,lab,[]) = 
			  (add_instr(ILABEL lab);
			   if exhaustive
			       then newstates
			   else (add_instr(ILABEL nomatchl);
				case default of
				     NONE => (no_match state)::newstates
				   | SOME e => 
					 let val (r,c,state) = xexp'(state,fresh_var(),e,arg_c,context)
					 in  mv(r,c); state::newstates
					 end))
			| scan(newstates,lab,(i,Function(_,_,_,elist,_,body,con))::rest) = 
			  let val next = alloc_code_label "sumarm"
			      val test = alloc_regi(NOTRACE_INT)
			      val _ = add_instr(ILABEL lab)
			      val state =
				  if (TW32.ult(i,tagcount))
				      then state
				  else (case elist of
					    [(v,spcon)] => add_var state (v,I r,spcon)
					  | _ => error "bad function for carrier case of sum switch")
			       (* perform check and branch to next case *)
			      fun check lbl cmp i tag = (if in_imm_range i
						     then add_instr(CMPSI(cmp,tag,IMM(w2i i),test))
						 else 
						     let val tmp = alloc_regi(NOTRACE_INT)
						     in  add_instr(LI(i,tmp));
							 add_instr(CMPSI(cmp,tag,REG tmp,test))
						     end;
						  add_instr(BCNDI(EQ,test,lbl,true)))
			      val check_ptr_done = ref false
			      val load_tag_done = ref false
			      fun check_ptr() = 
				  (if (!check_ptr_done) 
				       then () 
				   else check nomatchl GT 0w255 r;
				       check_ptr_done := true)
			      fun load_tag() = 
				  (if (!load_tag_done) 
				       then () 
				   else add_instr(LOAD32I(EA(r,0),tag));
				      load_tag_done := true)
			  in  add_instr(ICOMMENT ("switch # : " ^ (Int.toString switchcount) ^ "case " 
						  ^ (TW32.toDecimalString i)));
			      (case (exhaustive andalso TW32.equal(TW32.uplus(i,0w1),total),
				     TW32.ult(i,tagcount)) of
				  (true,_) => ()
				| (_,true) => check next EQ i r
				| (_,false) => (if exhaustive then () else check_ptr();
						if one_carrier
						    then ()
						else (load_tag();
						     check next EQ (TW32.uminus(i,tagcount)) tag)));
			      let val (r,c,state) = xexp'(state,fresh_var(),body,SOME con,context)
			      in mv(r,c);
				  add_instr(BR afterl);
				  scan(state::newstates,next,rest)
			      end
			  end
		      val states = scan([],alloc_code_label "sumarm",arms)
		      val state = join_states states
		  in  
		      add_instr(ILABEL afterl);
		      case (!dest,!rescon) of
			  (SOME r,SOME c) => (VAR_LOC(VREGISTER r),c,state)
			| _ => error "no arms"
		  end)
	      end
      end



  (* First, we assume that datatypes are translated by 
     rearranging the non value-carrying components to the beginning.
     To support efficient representations, we let m and n denote
     the length of the maximal initial segment of non value-carrying components 
     and n the rest of the components.  Note that this m is
     NOT the number(k) of non-value-carrying constructors in the datatype.
     It is possible for m > k. There are then 6 cases to consider:

         1. m=0, n=0    we use the unit representation
         2. m<>0, n=0   we use tags to represent the datatype
         3. m=0, n=1    we use the argument type to represent the datatype
         4. m<>0, n=1   we use tag or pointer to represent the datatype
         5. m<>0, n>1   we use tag or tagged sum to represent the datatype
         6. m=0, n>1    we use tagged sum to represent the datatype

     Tag sums are flat if the carrier is a record type.
     
     is_record indicates that the injectee is of a record type and the 
       that the term arguments are passed in separately as record components
  *)

  and xsum is_record (orig_state : state,
		      sumcon : con, 
		      elist,context) : loc_or_val * con * state = 
      let
	  open Prim
	  val (tagcount,known,sumtypes) = reduce_to_known_sum "xsum" orig_state sumcon

	  val field_64 = TW64.fromInt(TW32.toInt known)
	  val field_sub = TW32.uminus(known,tagcount)
	  val nontagcount = length sumtypes
	  val single_carrier = nontagcount = 1

	  val (varlocs,orig_state) = 
	      foldl_list (fn (e,s) => let val (vl,_,s) = xexp(s,fresh_var(),e,NONE,NOTID)
				      in (vl,s)
				      end) orig_state elist


          fun xtagsum_tag state = 
	      let val (vl,_,state) = xexp(state,fresh_var(),Const_e(uint(W32,field_64)),NONE,context)
	      in (vl,state)
	      end

	  fun xtagsum_single state =
	      let 
		  val field_type = List.nth(sumtypes, TW32.toInt field_sub)
		  val desti = alloc_regi(con2rep state field_type)
		  fun box_case_vl state = 
		      let val reps = map valloc2rep varlocs
		      in  make_record(state,NONE,reps,varlocs)
		      end
		  fun nobox_case_vl state = 
		      if is_record
			  then box_case_vl state
		      else (hd varlocs, state)
	      in  (case simplify_type' orig_state field_type of
			  (true,Prim_c(Int_c _, _)) => box_case_vl state
			| (true,Prim_c(Sum_c _, _)) => box_case_vl state
			| (true,_) => nobox_case_vl state
			| _ =>
			      let val beginl = alloc_code_label "tagsum_begin"
				  val boxl = alloc_code_label "tagsum_boxcase"
				  val mul = alloc_code_label "tagsum_mucase"
				  val noboxl = alloc_code_label "tagsum_noboxcase"
				  val afterl = alloc_code_label "tagsum_after"
				  val (con_ir,_,state) = xcon(state,fresh_var(),sumcon, NONE)
				  (* the first 4 fields are: tag, known, tagcount, total *)
				  val _ = add_instr(LOAD32I(EA(con_ir,4*(4+(w2i field_sub))),con_ir))
				  val tmp = alloc_regi NOTRACE_INT
				  val tagi = alloc_regi NOTRACE_INT
				  val _ = (add_instr(ILABEL beginl);
					   add_instr(CMPUI(LE, con_ir, IMM 4, tmp)); (* check ints *)
					   add_instr(BCNDI(NE, tmp, boxl, false));
					   add_instr(CMPUI(GE, con_ir, IMM 255, tmp));
					   add_instr(BCNDI(EQ, tmp, noboxl, false));
					   add_instr(LOAD32I(EA(con_ir,0),tagi));
					   add_instr(CMPUI(EQ, tagi, IMM 4, tmp)); (* check sums *)
					   add_instr(BCNDI(NE, tmp, boxl, false));
					   add_instr(CMPUI(EQ, tagi, IMM 7, tmp)); (* check mu *)
					   add_instr(BCNDI(NE, tmp, mul, false)))
				  (* no box case *)
				  val _ = add_instr(ILABEL noboxl)
				  val (vl,nobox_state) = nobox_case_vl state
				  val _ = add_instr(MV(load_ireg_locval(vl,NONE),desti))
				  val _ = add_instr(BR afterl)

				  (* mu case - must expand *)
				  val _ = (add_instr(ILABEL mul);
					   add_instr(LOAD32I(EA(con_ir,4),con_ir));
					   add_instr(BR beginl))

				  (* box case *)
				  val _ = add_instr(ILABEL boxl)
				  val (vl,box_state) = box_case_vl state
				  val _ = add_instr(MV(load_ireg_locval(vl,NONE), desti))
				  val _ = add_instr(ILABEL afterl)

			      in  (VAR_LOC(VREGISTER(I desti)),
				   join_states[nobox_state,box_state])
			      end)
	      end

	  fun xtagsum_dynamic (state,vl) =
	      let val numfields = alloc_regi NOTRACE_INT
		  val gctemp = alloc_regi NOTRACE_INT
		  val tmp = alloc_regi NOTRACE_INT
		  val tmp2 = alloc_regi NOTRACE_INT
		  val data = alloc_regi NOTRACE_INT
		  val tagi = alloc_regi NOTRACE_INT
		  val rectagi = alloc_regi NOTRACE_INT
		  val newtag = alloc_regi NOTRACE_INT
		  val srccursor = alloc_regi LOCATIVE
		  val destcursor = alloc_regi LOCATIVE
		  val field_type = List.nth(sumtypes, TW32.toInt field_sub)
		  val desti = alloc_regi(con2rep state field_type)

		  val nonrecordl = alloc_code_label "dyntagsum_norecord"
		  val afterl = alloc_code_label "dyntagsum_after"
		  val loopl = alloc_code_label "dyntagsum_loop"
		  val recordl = alloc_code_label "dyntagsum_record"

		  val (con_ir,_,state) = xcon(state,fresh_var(),sumcon,NONE)
		  (* the first 4 fields are: tag, known, tagcount, total *)	
	  val _ = add_instr(LOAD32I(EA(con_ir,4*(4+(w2i field_sub))),con_ir))

		  val _ = (add_instr(CMPUI(LE, con_ir, IMM 255, tmp)); (* check for small types *)
			   add_instr(BCNDI(NE, tmp, nonrecordl, false));
			   add_instr(LOAD32I(EA(con_ir,0),tagi));  (* load tag *)
			   add_instr(CMPUI(NE, tagi, IMM 5, tmp)); (* check for record *)
			   add_instr(BCNDI(NE, tmp, nonrecordl, false)))

		  val _ = add_instr(ILABEL recordl) (* difficult record case *)
		  val vl_ir = load_ireg_locval(vl,NONE)
		  val _ = add_instr(LOAD32I(EA(con_ir,0),rectagi));  (* load record tag *)
  (* XXX this will break if record is a multi-record or tag format changes *)
		  val _ = add_instr(SRL(rectagi,IMM 27,numfields))
		  val _ = add_instr(SLL(rectagi,IMM 5, tmp)) 
		  val _ = add_instr(SRL(tmp,IMM (3+5), tmp)) 
		  val _ = add_instr(SLL(tmp,IMM 4, tmp))      (* compute new mask *)
		  val _ = add_instr(ORB(tmp,IMM 3, tmp))       (* add record aspect *)
		  val _ = add_instr(ADD(numfields,IMM 1, tmp2))
		  val _ = add_instr(SLL(tmp2,IMM 27, tmp2))   (* compute new length *)
		  val _ = add_instr(ORB(tmp,REG tmp2,newtag))      (* final record tag *)
				    
		  val _ = add_instr(ADD(numfields,IMM 2, gctemp))
		  val state = needgc(state,REG gctemp)             (* allocate space for sum record *)

		  val _ = add_instr(STORE32I(EA(heapptr,0),newtag))  (* store record tag *)
		  val _ = add_instr(LI(field_sub, tmp))
		  val _ = add_instr(STORE32I(EA(heapptr,4),tmp))     (* store sum tag *)
		  val _ = add_instr(S4ADD(numfields, REG vl_ir, srccursor)) (* initialize src cursor *)
		  val _ = add_instr(ADD(heapptr,IMM 8, destcursor))
		  val _ = add_instr(S4ADD(numfields, REG destcursor, destcursor)) (* init dest cursor *)

		  (* record has at least one field *)
		  val _ = (add_instr(ILABEL loopl); 
			   add_instr(LOAD32I(EA(srccursor,0),data));
			   add_instr(STORE32I(EA(destcursor,0),data));
			   add_instr(SUB(srccursor,IMM 4, srccursor));
			   add_instr(SUB(destcursor,IMM 4, destcursor));
			   add_instr(CMPUI(LE,srccursor,REG vl_ir, tmp));
			   add_instr(BCNDI(EQ, tmp, loopl,false)))  (* loop will copy record fields *)

		  val _ = add_instr(MV(heapptr,desti))
		  val _ = add_instr(S4ADD(gctemp, REG heapptr, heapptr))
		  val _ = add_instr(BR afterl)

		  val _ = add_instr(ILABEL nonrecordl) (* easier non-record case *)
		  val vls = (case varlocs of
				 [vl] => [VAR_VAL(VINT field_sub),vl]
			       | _ => error "xtagsum_dynamic not with one arg")
		  val (lv,state) = make_record(state,NONE,map valloc2rep vls,vls)
		  val ir = load_ireg_locval(lv,NONE)
		  val _ = add_instr(MV(ir,desti))

		  val _ = add_instr(ILABEL afterl) (* result is in desti at this point *)

	      in  (VAR_LOC(VREGISTER(I desti)),state)
	      end

	  fun xtagsum state = 
	      let fun decompose vl reccon labs cons = 
		    let val bind = fresh_named_var "xtagsum_var"
			val ir = load_ireg_locval(vl,NONE)
			val state = add_var state (bind, I ir, reccon)
			fun folder((l,c),state) = 
			    let val (vl,_,state) = 
				xexp(state,fresh_var(),
				 Prim_e(NilPrimOp(select (l)),
						 [],[Var_e bind]),
						  NONE, NOTID)
			    in  (vl,state)
			    end
		    in  foldl_list folder state
				(Listops.zip labs cons)
		    end
		  val field_type = List.nth(sumtypes, TW32.toInt field_sub)
		  val (hnf,field_type') = simplify_type' orig_state field_type
		  val (vls,state) = 
		      (case (is_record,hnf,field_type',varlocs) of
			   (true,_,_,_) => (SOME varlocs, state)
			 | (_,_,reccon as Prim_c(Record_c labs, cons),[vl]) => 
			       let val (vls,state) = decompose vl reccon labs cons
			       in  (SOME vls, state)
			       end
			 | (_,true,_,[vl]) => (SOME [vl], state)
			 | _ => (NONE, state))
	      in  case (vls,varlocs) of
		  (NONE,[vl]) => xtagsum_dynamic(state, vl)
		| (NONE,_) => error "xtagsum_dynamic case not with one vl"
		| (SOME varlocs,_) =>
		      let 
			  val varlocs = (VAR_VAL(VINT field_sub)) :: varlocs
			  val reps = map valloc2rep varlocs
		      in  make_record(state,NONE,reps,varlocs)
		      end
	      end
	  val (varloc,state) =
	      case (TW32.toInt tagcount,nontagcount) of
		  (0,0) => xtagsum_tag orig_state
		| (_,0) => xtagsum_tag orig_state
		| (_,1) => if (TW32.equal(known,tagcount))
			       then xtagsum_single orig_state
			   else xtagsum_tag orig_state
		| (_,_) => if (TW32.ult(known,tagcount))
			       then xtagsum_tag orig_state
			   else xtagsum orig_state
      in (varloc, sumcon, state) 
      end

  and xdynamic_project_sum(state : state, sumcon, (tagcount,sumtype), 
			   summand_types, summand_type,
			   e, context) : loc_or_val * con * state = 
      let val single_carrier = (length summand_types) = 1
	  val (r,_,state) = xexp'(state,fresh_var(),e,NONE,NOTID)	
	  val exp_ir = coercei "" r
	  val field_sub = TW32.uminus(sumtype,tagcount)
	  fun single_case() = 
	      let val desti = alloc_regi(con2rep state summand_type)
		  fun nobox_case() = add_instr(MV(exp_ir,desti))
		  fun box_case() = add_instr(LOAD32I(EA(exp_ir,0),desti))
		  val afterl = alloc_code_label "projsum_single_after"
		  val boxl = alloc_code_label "projsum_single_box"
		  val noboxl = alloc_code_label "projsum_single_nobox"
		  val (con_ir,_,state) = xcon(state,fresh_var(),sumcon, NONE)
		  (* the first 4 fields are: tag, known, tagcount, total *)
		  val _ = add_instr(LOAD32I(EA(con_ir,4*(4+(TW32.toInt field_sub))),con_ir))
		  val tmp = alloc_regi NOTRACE_INT
		  val tagi = alloc_regi NOTRACE_INT
		  val _ = (add_instr(CMPUI(LE, con_ir, IMM 4, tmp)); (* check ints *)
			   add_instr(BCNDI(NE, tmp, boxl, false));
			   add_instr(CMPUI(GE, con_ir, IMM 255, tmp));
			   add_instr(BCNDI(EQ, tmp, noboxl, false));
			   add_instr(LOAD32I(EA(con_ir,0),tagi));
			   add_instr(CMPUI(EQ, tagi, IMM 4, tmp)); (* check sums *)
			   add_instr(BCNDI(NE, tmp, boxl, false)))
		  (* no box case *)
		  val _ = (add_instr(ILABEL noboxl);
			   nobox_case();
			   add_instr(BR afterl))
		  (* box case *)
		  val _ = (add_instr(ILABEL boxl);
			   box_case();
			   add_instr(ILABEL afterl))
	      in  (desti, state)
	      end

	  fun multi_case() = 
	      let val afterl = alloc_code_label "projsum_multi_after"
		  val nonrecordl = alloc_code_label "projsum_multi_nonrecord"
		  val recordl = alloc_code_label "projsum_multi_record"
		  val loopl = alloc_code_label "projsum_multi_loop"
		  val tag = alloc_regi NOTRACE_INT
		  val rectag = alloc_regi NOTRACE_INT
		  val tmp = alloc_regi NOTRACE_INT
		  val tmp2 = alloc_regi NOTRACE_INT
		  val gctemp = alloc_regi NOTRACE_INT
		  val sumrectag = alloc_regi NOTRACE_INT
		  val numfields = alloc_regi NOTRACE_INT
		  val data = alloc_regi NOTRACE_INT
		  val srccursor = alloc_regi LOCATIVE
		  val destcursor = alloc_regi LOCATIVE
		  val desti = alloc_regi(con2rep state summand_type)

		  val (con_ir,_,state) = xcon(state,fresh_var(),sumcon, NONE)
		  (* the first 4 fields are: tag, known, tagcount, total *)	
		  val _ = add_instr(LOAD32I(EA(con_ir,4*(4+(TilWord32.toInt field_sub))),con_ir))

		  val _ = (add_instr(CMPUI(GE, con_ir, IMM 255, tmp));
			   add_instr(BCNDI(EQ, tmp, nonrecordl, false));
			   add_instr(LOAD32I(EA(con_ir,0),tag));
			   add_instr(CMPUI(EQ, tag, IMM 5, tmp));
			   add_instr(BCNDI(NE, tmp, recordl, false)))
		  (* non-record case *)
		  val _ = (add_instr(ILABEL nonrecordl);
			   add_instr(LOAD32I(EA(exp_ir,4),desti));
			   add_instr(BR afterl))
		  (* record case *)
		  val _ = (add_instr(ILABEL recordl);
			   add_instr(LOAD32I(EA(con_ir,4),numfields)))

		  (* XXX this will break if record is a multi-record or tag format changes *)
		  val _ = add_instr(LOAD32I(EA(exp_ir,~4),sumrectag))
		  val _ = add_instr(SRL(sumrectag,IMM 27,gctemp))
		  val _ = add_instr(SUB(gctemp,IMM 1, numfields))   (* # of fields in final rec *)
		  val _ = add_instr(SLL(sumrectag,IMM 3, tmp)) 
		  val _ = add_instr(SRL(tmp,IMM (3 + 27 + 1), tmp)) (* new mask *)
		  val _ = add_instr(SLL(tmp,IMM 3, tmp))      (* compute new mask *)
		  val _ = add_instr(ORB(tmp,IMM 3, tmp))      (* add record aspect *)
		  val _ = add_instr(SLL(numfields,IMM 27, tmp2))   (* compute new length *)
		  val _ = add_instr(ORB(tmp,REG tmp2,rectag))      (* final record tag *)


		  val _ = add_instr(ADD(numfields,IMM 1, gctemp))
		  val state = needgc(state,REG gctemp)       (* allocate space for record *)

		  val _ = add_instr(STORE32I(EA(heapptr,0),rectag))
		  val _ = add_instr(S4ADD(numfields, REG heapptr, destcursor)) (* record tag *)
		  val _ = add_instr(S4ADD(numfields, REG exp_ir, srccursor)) (* sum tag *)
			   
		  val _ = (add_instr(ILABEL loopl); 
			   add_instr(LOAD32I(EA(srccursor,0),data));
			   add_instr(STORE32I(EA(destcursor,0),data));
			   add_instr(SUB(srccursor,IMM 4, srccursor));
			   add_instr(SUB(destcursor,IMM 4, destcursor));
			   add_instr(CMPUI(EQ,srccursor,REG exp_ir, tmp));
			   add_instr(BCNDI(EQ, tmp, loopl,false)); (* loop will copy record fields *)
			   add_instr(MV(heapptr,desti));
			   add_instr(S4ADD(gctemp, REG heapptr,heapptr));
			   add_instr(ILABEL afterl))
	      in  (desti,state)
	      end
	  val (ir,state) = if single_carrier then single_case() 
			   else multi_case()
	  val lv = VAR_LOC(VREGISTER (I ir))
      in  (lv,summand_type,state)
      end



  and xnilprim(state : state, nilprim,clist,elist,context,copt) : loc_or_val * con * state = 
      let fun error' s = (print "NIL primexpression was:\n";
			  Ppnil.pp_exp (Nil.Prim_e(Nil.NilPrimOp nilprim, clist,elist));
			  print "\n";
			  error s)
      in
      (case nilprim of 
	   Nil.record labels => 
	       let fun folder(e,state) = 
		     let val (vl,c,state) = xexp(state,fresh_var(), e,NONE,NOTID)
		     in  ((vl,c),state)
		     end
		   val (vallocs_types,state) = foldl_list folder state elist
		   val types = map #2 vallocs_types
		   val vallocs = map #1 vallocs_types
		   val c = Prim_c(Record_c labels, types)
		   val reps = map valloc2rep vallocs
		   val (lv,state) = make_record(state,NONE,reps,vallocs)
	       in  (lv, c, state)
	       end
	 | select label => 
	       let val [e] = elist 
		   val (I addr,reccon,state) = xexp'(state,fresh_var(),e,NONE,NOTID)
		   fun loop [] _ n = error' "bad select 1"
		     | loop _ [] n = error' "bad select 2"
		     | loop (l1::lrest) (c1::crest) n = if (eq_label(l1,label))
							    then (n,c1)
							else loop lrest crest (n+1)
		   val oldreccon = reccon
		   val reccon = case reccon of
		       Prim_c(Record_c _, _) => reccon
		     | _ => #2(simplify_type state reccon)
		   val (labels,fieldcons) = 
		       (case reccon of
			    Prim_c(Record_c labels,cons) => (labels,cons)
			  | c => (print "selecting from exp of type: ";
				  Ppnil.pp_con oldreccon; print "\nwhich reduces to\n";
				  Ppnil.pp_con reccon; print "\n";
				  error' "selecting from a non-record"))
		   val (which,con) = loop labels fieldcons 0
		   val con = (case copt of 
				  NONE => con 
				| SOME c => c)
		   val desti = (case (alloc_reg state con) of
				    I ir => ir
				  | _ => error "records cannot have floats")
		   val _ = add_instr(LOAD32I(EA(addr,which * 4), desti))
	       in  (VAR_LOC(VREGISTER(I desti)), con, state)
	       end
	 | inject_record => xsum true (state,hd clist,elist,context)
	 | inject => xsum false (state,hd clist,elist,context)

	 | project_sum_record field =>
	       let val (tagcount, sumtype, summands) = 
		         reduce_to_known_sum "project_sum_record" state (hd clist)
		   val index = TW32.toInt(TW32.uminus(sumtype, tagcount))
		   val (base,econ,state) = (case elist of
					  [e] => let val (r,c,s) = xexp'(state,fresh_var(),e,NONE,NOTID)
						 in  (coercei "" r, c,s)
						 end
					| _ => error' "bad project_sum_record: base")

		   val fieldcon = List.nth(summands,index) handle _ => error "list.nth 2"
		   val field' = 
		        let fun loop n [] = 
				     (print "bad project_sum_record: missing field ";
				      Ppnil.pp_label field; print "\n in type = \n";
				      Ppnil.pp_con fieldcon; print "\n";
				      error "bad project_sum_record: bad econ field not found")
			      | loop n (a::rest) = if (Name.eq_label(a,field))
						       then n else loop (n+1) rest
			in  (case fieldcon of
				 (Prim_c(Record_c labels, _)) => loop 0 labels
			       | _ => (case #2(simplify_type state fieldcon) of
					   (Prim_c(Record_c labels, _)) => loop 0 labels
					 | c => (print "bad project_sum_record: not record\n";
						 Ppnil.pp_con c;
						 error "bad project_sum_record: not record\n")))
			end
		   val single_carrier = (length summands) = 1
		   local
		       val record_con = (List.nth(summands,index)
					 handle _ => error' "bad project_sum_record: record_con")
		   in
		       val field_con = 
			   (case (copt,record_con) of
				(SOME c, _) => c
			      | (_,Prim_c(Record_c _,cons)) => (List.nth(cons,field')
							    handle _ => error "list.nth 4")
			      | _ => (case #2(simplify_type state record_con) of
					  Prim_c(Record_c _,cons) => (List.nth(cons,field')
								      handle _ => error "list.nth 5")
					| c => (print "bad project_sum_record: field_con";
						Ppnil.pp_con c;
					    error' "bad project_sum_record: field_con")))
		   end
		   val desti = alloc_regi (con2rep state field_con)
		   val subscript = if single_carrier then field' else field' + 1
		   val _ = add_instr(LOAD32I(EA(base,4*subscript),desti))
	       in (VAR_LOC(VREGISTER(I desti)), field_con, state)
	       end
	 | project_sum =>
	       let val sumcon = hd clist
		   val (tagcount, sumtype, summand_types) = 
		         reduce_to_known_sum "project_sum_record" state sumcon
	           val index = TW32.toInt(TW32.uminus(sumtype, tagcount))
		   val summand_type = (List.nth(summand_types,index)
				     handle _ => error' "bad project_sum: record_con")
		   fun record_case labels field_cons = 
		       let fun make_e l = Prim_e(NilPrimOp(project_sum_record l),
						 [sumcon],elist)
			   val elist' = map make_e labels
		       in  xnilprim(state,Nil.record labels,field_cons,elist',context,copt)
		       end
		   fun nonrecord_case() = 
		       let 
			   val (single_carrier,need_unbox) = 
			       if (length summand_types) = 1
				   then
				       (case simplify_type' state (hd summand_types) of
					    (_,Prim_c(Int_c _,_)) => (true,true)
					  | (_,Prim_c(Sum_c _,_)) => (true,true)
					  | (true,_) => (true,false)
					  | _ => error "project_sum not fully done")
			       else  (false,false)

			   val [e] = elist
			   val (lv,c,state) = xexp(state,fresh_var(),e,NONE,NOTID)

			   fun unbox offset =
			       let val ir = load_ireg_locval(lv,NONE)
				   val desti = alloc_regi(con2rep state summand_type)
				   val _ = add_instr(LOAD32I(EA(ir,offset), desti))
			       in  (VAR_LOC(VREGISTER(I desti)), summand_type,state)
			       end
		       in  (case (single_carrier,need_unbox) of
				(true,false) => (lv,c,state)
			      | (true,true) => unbox 0
			      | (false,_) => unbox 4)
		       end
	       in  (case summand_type of
			Prim_c(Record_c labs,cons) => record_case labs cons
		      | c => 
			    (case (simplify_type' state summand_type,elist) of
				 ((_,Prim_c(Record_c labs,cons)),_) => record_case labs cons
			       | ((true,_),_) => nonrecord_case()
			       | (_,[e]) => xdynamic_project_sum(state,sumcon,
								 (tagcount,sumtype),
								 summand_types,
								 summand_type,
								 e, context)))
	       end
	 | box_float Prim.F64 => 
	       let val [e] = elist
		   val (lv,_,state) = xexp(state,fresh_var(),e,NONE,NOTID)
		   val (vl,state) = boxFloat_vl(state,lv)
	       in (vl, Prim_c(BoxFloat_c Prim.F64,[]),state)
	       end
	 | unbox_float Prim.F64 => 
	       let val [e] = elist
		   val (I ir,_,state) = xexp'(state,fresh_var(),e,NONE,NOTID)
		   val fr = alloc_regf()
		   val _ = add_instr(LOADQF(EA(ir,0),fr))
	       in (VAR_LOC(VREGISTER(F fr)), Prim_c(Float_c Prim.F64,[]),state)
	       end
	 | box_float Prim.F32 => error "32-bit floats not done"
	 | unbox_float Prim.F32 => error "32-bit floats not done"
	 | roll => let val ([c],[e]) = (clist,elist) 
	               (* the type returned is not right *)
		   in  xexp(state,fresh_var(),e,NONE,context)
		   end
	 | unroll => 
		   let val ([c],[e]) = (clist,elist)
		       (* the type returned is not right *)
		   in  xexp(state,fresh_var(),e,NONE,context)
		   end
	 | make_exntag => 
		   let val [c] = clist 
		       val c' = Prim_c(Exntag_c,[c])
		       val desti = alloc_regi NOTRACE_INT
		       val addr = alloc_regi TRACE
		       val tmp = alloc_regi NOTRACE_INT
		       val _ = (add_instr(LADDR(exncounter_label,0,addr));
				add_instr(LOAD32I(EA(addr,0),desti));
				add_instr(ADD(desti,IMM 1,tmp));
				add_instr(STORE32I(EA(addr,0),tmp)))
		   in  (VAR_LOC(VREGISTER (I desti)), c',state)
		   end
	 | inj_exn name => 
		   let val [e1,e2] = elist
		       val desti = alloc_regi NOTRACE_INT
		       val (vl1,_,state) = xexp(state,fresh_var(),e1,NONE,NOTID)
		       val (vl2,_,state) = xexp(state,fresh_var(),e2,NONE,NOTID)
		       fun char2val c = Const_e(Prim.uint(Prim.W8, TW64.fromInt (ord c)))
		       val name_array = Array.fromList (map char2val (explode name))
		       val (vl3,_,state) = xconst(state, Prim.vector(char_con,name_array))
		       val vallocs = [vl1,vl2,vl3]
		       val reps = map valloc2rep vallocs
		       val (lv,state) = make_record(state,NONE,reps,vallocs)
		   in  (lv, Prim_c(Exn_c,[]),state)
		   end
	 | make_vararg _ => raise Util.UNIMP
	 | make_onearg _ => raise Util.UNIMP
	 | peq => error "peq not done")
      end

  and xprim(state : state, prim,clist,elist,context) : loc_or_val * con * state = 
      let open Prim
	  fun makecall str arg_types ret_type =
	  let 
	      val codevar = fresh_var()
	      val label = C_EXTERN_LABEL str
	      val tipe = AllArrow_c(ExternCode,Partial,[],arg_types,0w0,ret_type)
	      val state' = add_var' state (codevar,NONE,SOME(VCODE label), tipe)
	      val exp = App_e(ExternCode,Var_e codevar,[],elist,[])
	  in xexp(state',fresh_var(),exp,NONE,context)
	  end
      in (case prim of
	      output => makecall "ml_output" [int_con,string_con] unit_con
	    | input => makecall "ml_input"  [int_con] string_con
	    | input1 => makecall "ml_input1" [int_con] char_con
	    | lookahead => makecall "ml_lookahead" [int_con] char_con
	    | open_in => makecall "ml_open_in" [string_con] int_con
	    | open_out => makecall "ml_open_out" [string_con] int_con
	    | close_in => makecall "ml_close_in" [int_con] unit_con
	    | close_out => makecall "ml_close_out" [int_con] unit_con
	    | end_of_stream => makecall "ml_end_of_stream" [int_con] bool_con
	    | flush_out => makecall "ml_flush_out" [int_con] unit_con
	    | neg_int is => xprim'(state,minus_int Prim.W32,clist,
				   (Const_e(Prim.int(Prim.W32,TW64.zero)))::elist,context)
	    | _ => xprim'(state,prim,clist,elist,context))
      end


  and xprim'(state : state, prim,clist,elist,context) : loc_or_val * con * state = 
      let 
	  fun error' s = (print "nilprimexpression was:\n";
			  Ppnil.pp_exp (Nil.Prim_e(Nil.PrimOp prim, clist,elist));
			  print "\n";
			  error s)
	  open Prim
	  val (vlcon_list,state) = 
	      foldl_list (fn (e,state) => let val (r,c,state) = xexp(state,fresh_var(),e,NONE,NOTID)
					  in  ((r,c),state)
					  end) state elist
	  val vl_list = map #1 vlcon_list
	  val int32 = Prim_c(Int_c W32, []) 
	  val float64 = Prim_c(Float_c F64, []) 
	  fun xtt int_tt = INT_TT
	    | xtt real_tt = REAL_TT
	    | xtt both_tt = BOTH_TT
	  fun commute (v1 as (VAR_VAL(VINT i)),v2) = 
	      if in_imm_range i then (v2,v1) else (v1,v2)
	    | commute arg = arg
	  (* ----------- integer comparisons ----------------------- *)
	  fun flip EQ = EQ
	    | flip LE = GE
	    | flip LT = GT
	    | flip GE = LE
	    | flip GT = LT
	    | flip NE = NE
	    | flip LBS = error "flip: LBS shouldn't be here"
	    | flip LBC = error "flip: LBC shouldn't be here"
	  fun swap (a,v1 as VAR_VAL(VINT i),v2) = 
	      if in_imm_range i 
		  then (flip a,v2,v1)
	      else (a,v1,v2)
	    | swap arg = arg
          fun stdcmp2i signed oper =
                   let val [vl1,vl2] = vl_list
		       val (oper,vl1,vl2) = swap(oper,vl1,vl2)
		       val a' = load_ireg_locval(vl1,NONE)
		       val b' = load_ireg_sv vl2
		       val dest = alloc_regi NOTRACE_INT
		       val cmp = if signed then CMPSI else CMPUI
		       val _ =  add_instr(cmp(oper,a',b',dest))
		   in (VAR_LOC(VREGISTER(I dest)),bool_con, state)
		   end

          val stdcmp2si = stdcmp2i true
          val stdcmp2ui = stdcmp2i false

          (* ----------- floatint point comparison ---------------- *)
	  fun cmpf oper =
	      let val [vl1,vl2] = vl_list
		  val a' = load_freg_locval(vl1,NONE)
		  val b' = load_freg_locval(vl2,NONE)
		  val dest = alloc_regi NOTRACE_INT
		  val _ =  add_instr(CMPF(oper,a',b',dest))
	      in (VAR_LOC(VREGISTER(I dest)),bool_con,state)
	      end


	  (* ----------- unary integer operations ----------------- *)
	  fun op1i oper : loc_or_val * con * state =
	      let val [vl1] = vl_list
		  val a' = load_ireg_locval(vl1,NONE)
		  val dest = alloc_regi NOTRACE_INT
		  val _ = add_instr(oper(a',dest))
	      in (VAR_LOC(VREGISTER(I dest)), int32, state)
	      end

	  (* ----------- binary integer operations ----------------- *)
	  fun op2i comflag oper : loc_or_val * con * state =
	      let val [vl1,vl2] = vl_list 
		  (* commute values if the first arg is a small imm *)
		  val (vl1,vl2) = if comflag then commute(vl1,vl2) else (vl1,vl2)
		  val a' = load_ireg_locval(vl1,NONE)
		  val b' = load_ireg_sv vl2
		  val dest = alloc_regi NOTRACE_INT
		  val _ = add_instr(oper(a',b',dest))
	      in (VAR_LOC(VREGISTER(I dest)), int32, state)
	      end

	  val commutesop2i = op2i true
	  val stdop2i = op2i false
	  fun add_ibar b1 b2 = (add_instr (b1 INT_TT); add_instr (b2 INT_TT))
	  fun trapZero result = (add_ibar SOFT_ZBARRIER HARD_ZBARRIER; result)
	  fun trapOver result = (add_ibar SOFT_VBARRIER HARD_VBARRIER; result)
	  (* ----------- binary and unary float operations ----------------- *)
	  fun op2f oper : loc_or_val * con * state =
	      (case vl_list of
		   [vl1,vl2] => 
		       let val a' = load_freg_locval(vl1,NONE)
			   val b' = load_freg_locval(vl2,NONE)
			   val dest = alloc_regf()
			   val _ = add_instr(oper(a',b',dest))
		       in (VAR_LOC(VREGISTER(F dest)), float64, state)
		       end
		 | _ => error "need exactly 2 arguments for this primitive")
	  fun op1f oper : loc_or_val * con * state =
	      (case vl_list of
		   [vl] => 
		       let val a' = load_freg_locval(vl,NONE)
			   val dest = alloc_regf()
			   val _ = add_instr(oper(a',dest))
		       in (VAR_LOC(VREGISTER(F dest)), float64, state)
		       end
		 | _ => error "need exactly 2 arguments for this primitive")
	  fun extract_type (t,clist) = 
	      (case (t,clist) of
		   (((IntArray is) | (IntVector is)),_) => Prim_c(Int_c is,[])
		 | (((FloatArray fs) | (FloatVector fs)),_) => Prim_c(Float_c fs,[])
		 | ((PtrArray | PtrVector), [c]) => c
		 | ((WordArray | WordVector), [c]) => c
		 | _ => error' "table primitive did not have right type args")
	  val unit_vvc = (#1 unit_vvc, #2 unit_vvc, state)
      in (case prim of
	      soft_vtrap tt => (add_instr(SOFT_VBARRIER(xtt tt)); unit_vvc)
	    | soft_ztrap tt => (add_instr(SOFT_ZBARRIER(xtt tt)); unit_vvc)
	    | hard_vtrap tt => (add_instr(HARD_VBARRIER(xtt tt)); unit_vvc)
	    | hard_ztrap tt => (add_instr(HARD_ZBARRIER(xtt tt)); unit_vvc)
	       
	    | mk_ref => let val ([vl],[c]) = (vl_list,clist) 
			in  xarray(state,c,VAR_VAL(VINT 0w1),vl)
			end
	    | deref =>  let val ([vl],[c]) = (vl_list,clist)
			in xsub(state,c,vl,VAR_VAL(VINT 0w0))
			end

	    | setref => let val ([vl1,vl2],[c]) = (vl_list,clist)
			in xupdate(state,c,vl1,VAR_VAL(VINT 0w0),vl2)
			end

	    | eq_ref => let val ([vl1,vl2],[c]) = (vl_list,clist)
			in  xeqarray(state,c,vl1,vl2)
			end

	    | float2int => 
		  let val [vl] = vl_list 
		      val src = load_freg_locval(vl,NONE)
		      val dest = alloc_regi NOTRACE_INT
		      val _ = add_instr(CVT_REAL2INT(src,dest))
		  in (VAR_LOC(VREGISTER(I dest)), int32, state)
		  end

	    | int2float => 
		  let val [vl] = vl_list
		      val src = load_ireg_locval(vl,NONE)
		      val dest = alloc_regf()
		      val _ = add_instr(CVT_INT2REAL(src,dest))
		  in (VAR_LOC(VREGISTER(F dest)), float64,state)
		  end

            (* XXX do we want overflow in some cases or are these casts? *)
	    | int2uint _ => 
		  let val [vl] = vl_list 
		  in  (vl, int32, state)
		  end

	    | uint2uint _ => 
		  let val [vl] = vl_list 
		  in (vl, int32, state)
		  end

	    | uint2int _ => 
		  let val [vl] = vl_list 
		  in (vl, int32, state)
		  end

	    | int2int _ => 
		  let val [vl] = vl_list 
		  in (vl, int32, state)
		  end

	    | neg_float fs => op1f FNEGD
	    | abs_float fs => op1f FABSD
	    | plus_float fs => op2f FADDD
	    | minus_float fs => op2f FSUBD
	    | mul_float fs => op2f FMULD
	    | div_float fs => op2f FDIVD
	    | less_float fs => cmpf LT
	    | greater_float fs => cmpf GT
	    | lesseq_float fs => cmpf LE
	    | greatereq_float fs => cmpf GE
	    | eq_float fs => cmpf EQ
	    | neq_float fs => cmpf NE

	    | plus_int W32 =>  trapOver(commutesop2i ADDT)
	    | mul_int W32 =>   trapOver(commutesop2i MULT)
	    | minus_int W32 => trapOver(stdop2i SUBT)
	    | div_int W32 =>   error "ml style div not implemented!"
	    | mod_int W32 =>   error "ml style mod not implemented!"
	    | quot_int W32 =>  trapZero(stdop2i DIVT)
	    | rem_int W32 =>   trapZero(stdop2i MODT)

	    | plus_uint W32 =>  (commutesop2i ADDT)
	    | mul_uint W32 =>   (commutesop2i MULT)
	    | minus_uint W32 => (stdop2i SUBT)
	    | div_uint W32 =>   (stdop2i DIVT)
	    | mod_uint W32 =>   (stdop2i MODT)

	    (* XXXXX should this mod with 255 *)
	    | plus_uint W8 =>  (commutesop2i ADDT)
	    | mul_uint W8 =>   (commutesop2i MULT)
	    | minus_uint W8 => (stdop2i SUBT)
	    | div_uint W8 =>   (stdop2i DIVT)
	    | mod_uint W8 =>   (stdop2i MODT)

	    | less_int W32 => stdcmp2si LT
	    | greater_int W32 => stdcmp2si GT
	    | lesseq_int W32 => stdcmp2si LE
	    | greatereq_int W32 => stdcmp2si GE
	    | eq_int _ => stdcmp2ui EQ
	    | neq_int _ => stdcmp2ui NE

	    (* assume upper bits of 8-bit and 16-bit unsigned ints are zero *)
	    | less_uint _ => stdcmp2ui LT
	    | greater_uint _ => stdcmp2ui GT
	    | lesseq_uint _ => stdcmp2ui LE
	    | greatereq_uint _ => stdcmp2ui GE

	    | neg_int is => error "should not get here"
	    | abs_int is => error "abs_int not done"

	    | not_int (W8 | W16 | W32) => op1i NOTB
	    | and_int (W8 | W16 | W32) => commutesop2i ANDB
	    | or_int (W8 | W16 | W32) => commutesop2i ORB
	    | xor_int (W8 | W16 | W32) => commutesop2i XORB
	    | lshift_int W32 => stdop2i SLL
	    | rshift_int W32 => stdop2i SRA
	    | rshift_uint W32 => stdop2i SRL

(*
	    | ((plus_int _) | (mul_int _) | (minus_int _) | (div_int _) | 
	       (mod_int _) | (quot_int _) | (rem_int _) | 
	       (plus_uint _) | (mul_uint _) | (minus_uint _) |
	       (div_uint _) | (mod_uint _) |
	       (less_int _) | (greater_int _) | (lesseq_int _) | (greatereq_int _) |
	       (less_uint _) | (greater_uint _) | (lesseq_uint _) | (greatereq_uint _) |
	       (eq_int _) | (neq_int _) | (not_int _) | (and_int _) | (or_int _) | 
	       (lshift_int _) | (rshift_int _) | (rshift_uint _)
	       ) => (print "non 32-bit math not done: ";
		     Ppnil.pp_prim prim; print "\n";
		     error "non 32-bit math not done")
*)

	    | (uinta2uinta (is1,is2)) =>
		  let val [vl] = vl_list 
		  in (vl, Prim_c(Array_c, [Prim_c(Int_c is2,[])]),state)
		  end
		       
	    | (uintv2uintv (is1,is2)) =>
		  let val [vl] = vl_list 
		  in  (vl, Prim_c(Array_c, [Prim_c(Int_c is2,[])]),state)
		  end

	    | (array2vector table) => 
		  (case (table,vl_list,clist) of 
		       (IntArray is,[vl],_) => (vl,Prim_c(Vector_c, [Prim_c(Int_c is,[])]),state)
		     | (FloatArray fs,[vl],_) => (vl,Prim_c(Vector_c, [Prim_c(Float_c fs,[])]),state)
		     | (PtrArray,[vl],[c]) => (vl,Prim_c(Vector_c, [c]),state)
		     | (WordArray,[vl],[c]) => (vl,Prim_c(Vector_c, [c]),state)
		     | _ => error "illegal array2vector")

	    | (vector2array table) => 
		  (case (table,vl_list,clist) of 
		       (IntVector is,[vl],_) => (vl,Prim_c(Array_c, [Prim_c(Int_c is,[])]),state)
		     | (FloatVector fs,[vl],_) => (vl,Prim_c(Array_c, [Prim_c(Float_c fs,[])]),state)
		     | (PtrVector,[vl],[c]) => (vl,Prim_c(Array_c, [c]),state)
		     | (WordVector,[vl],[c]) => (vl,Prim_c(Array_c, [c]),state)
		     | _ => error "illegal array2vector")
				
	     | (length_table t) => 
		       let val [vl] = vl_list 
			   val c = extract_type(t,clist)
		       in xlength(state,c,vl)
		       end
	     | (sub t) => 
		       let val [vl1,vl2] = vl_list 
		       in  xsub(state,extract_type(t,clist),vl1,vl2)
		       end
	     | (update t) => 
		       let val [vl1,vl2,vl3] = vl_list 
		       in  xupdate(state,extract_type(t,clist),vl1,vl2,vl3)
		       end

	     (* zero is legal as a pointer *)
	     | (create_empty_table table) => 
		       (VAR_VAL(VINT 0w0), 
			(case (table, clist) of
			    (IntArray is,_) => Prim_c(Array_c, [Prim_c(Int_c is,[])])
			  | (IntVector is,_) => Prim_c(Vector_c, [Prim_c(Int_c is,[])])
			  | (FloatArray fs,_) => Prim_c(Array_c, [Prim_c(Float_c fs,[])])
			  | (FloatVector fs,_) => Prim_c(Vector_c, [Prim_c(Float_c fs,[])])
			  | (PtrArray, [c]) => Prim_c(Array_c, [c])
			  | (PtrVector, [c]) => Prim_c(Vector_c, [c])
			  | (WordArray, [c]) => Prim_c(Array_c, [c])
			  | (WordVector, [c]) => Prim_c(Vector_c, [c])
			  | (PtrArray, _) => error "ill-formed aggregate type"
			  | (PtrVector, _) => error "ill-formed aggregate type"
			  | (WordArray, _) => error "ill-formed aggregate type"
			  | (WordVector, _) => error "ill-formed aggregate type"),
			     state)

	     | (create_table t) => 
		       let val [vl1,vl2] = vl_list
		       in xarray(state,extract_type(t,clist),vl1,vl2)
		       end

	     | (equal_table (t as ((IntArray _) | (FloatArray _) | WordArray | PtrArray))) =>
		       let val [vl1,vl2] = vl_list 
		       in  xeqarray(state,extract_type(t,clist),vl1,vl2)
		       end
	     | (equal_table (t as ((IntVector _) | (FloatVector _) | WordVector | PtrVector))) => 
		       let val [vl1,vl2] = vl_list 
		       in xeqvector(state,extract_type(t,clist),vl1,vl2)
		       end
             | _ => (print "primitive: ";
                       Ppnil.pp_prim prim;
                       print "not implemented\n";
                       raise Util.UNIMP))
      end

 


  (* ---------------- array and vector operations --------------------
     --- the array/vector type may or may not be statically known ---- *)

  and xfloatsub(vl1 : loc_or_val, vl2 : loc_or_val) : regf = 
      let
	  val a' = load_ireg_locval(vl1,NONE)
	  val destf = alloc_regf()
	  val _ =  (case (in_ea_range 8 vl2) of
			SOME i => add_instr(LOADQF(EA(a',i),destf))
		      | NONE =>
			    let val b' = load_ireg_locval(vl2,NONE)
				val addr = alloc_regi (LOCATIVE)
			    in  add_instr(S8ADD(b',REG a',addr));
				add_instr(LOADQF(EA(addr,0),destf))
			    end)
      in  destf
      end

  and xintptrsub(state : state, is, c, vl1 : loc_or_val, vl2 : loc_or_val) : regi =
      let
	  val a' = load_ireg_locval(vl1,NONE)
	  val desti = alloc_regi(con2rep state c)
      in  (case is of
	       Prim.W32 => (add_instr(ICOMMENT "int sub start");
			    (case (in_ea_range 4 vl2) of
				SOME i => add_instr(LOAD32I(EA(a',i),desti))
			      | NONE => let val b' = load_ireg_locval(vl2,NONE)
					    val addr = alloc_regi (LOCATIVE)
					in  add_instr(S4ADD(b',REG a',addr));
					    add_instr(LOAD32I(EA(addr,0),desti))
					end);
				 add_instr(ICOMMENT "int sub end"))
	     | Prim.W8 => let val addr = alloc_regi LOCATIVE
			      val offset = load_ireg_locval(vl2,NONE) (* cannot reuse *)
			      val subaddr = alloc_regi NOTRACE_INT
			      val data = alloc_regi NOTRACE_INT
			      val temp = alloc_regi NOTRACE_INT
			      val _ = (add_instr(ICOMMENT "character sub start\n");
				       add_instr(ANDB(offset,IMM 3, subaddr));
				       add_instr(NOTB(subaddr,temp));
				       add_instr(SLL(subaddr,IMM 3, subaddr));
				       add_instr(ANDB(offset,REG temp, temp));
				       add_instr(ADD(a',REG temp,addr));
				       add_instr(LOAD32I(EA(addr,0),data));
				       add_instr(SRL(data,REG subaddr,data));
				       add_instr(ANDB(data,IMM 255, desti));
				       add_instr(ICOMMENT "character sub end\n"))
			  in ()
			  end
	     | _ => error "xintptrsub not done on all int sizes");
	  desti
      end

  and xsub(state,c, vl1 : loc_or_val, vl2 : loc_or_val) : loc_or_val * con * state =
      let
	  fun floatcase s = let val fr = xfloatsub(vl1,vl2)
				val (ir,s) = boxFloat(s,fr)
			    in  (I ir, s)
			    end
	  fun nonfloatcase (s,is) = let val ir = xintptrsub(s,is,c,vl1,vl2)
				    in  (I ir,s)
				    end
	  val (r,state) = 
	      (case (simplify_type' state c) of
		   (true,Prim_c(Float_c Prim.F64,[])) => floatcase state
		 | (true,Prim_c(BoxFloat_c Prim.F64,[])) => floatcase state
		 | (true,Prim_c(Int_c Prim.W8,[])) => nonfloatcase(state, Prim.W8)
		 | (true,_) => nonfloatcase(state, Prim.W32)
		 | (false,_) => 
		     if ((case getCurrentFun() of
			      LOCAL_CODE v => not(Name.eq_var(local_sub,v))
			    | _ => false))
			 then 
			     let val _ = local_sub_used := true
				 val v1 = Name.fresh_named_var "array"
				 val v2 = Name.fresh_named_var "index"
				 val ir1 = load_ireg_locval(vl1,NONE)
				 val ir2 = load_ireg_locval(vl2,NONE)
				 val state = add_var state (v1, I ir1, 
							    Prim_c(Array_c, [c]))
				 val state = add_var state (v2, I ir2, 
							    Prim_c(Int_c Prim.W32,[]))
				 val e = App_e(Code,Var_e local_sub,[c],[Var_e v1, Var_e v2],[])
				 val (r,_,s) = xexp'(state, Name.fresh_named_var "subscript", e,
						     SOME c, NOTID)
			     in  (r,s)
			     end
		     else 
                       let val (r,_,state) = xcon(state,fresh_var(),c, NONE)
			   val tmp = alloc_regi NOTRACE_INT
			   val desti = alloc_regi(con2rep state c)
			   val afterl = alloc_code_label "sub_after"
			   val floatl = alloc_code_label "sub_float"
			   val charl = alloc_code_label "sub_char"
			   val nonfloatl = alloc_code_label "sub_nonfloat"
			   val _ = (add_instr(CMPUI(EQ, r, IMM 11, tmp));
				    add_instr(BCNDI(NE,tmp,floatl,false));
				    add_instr(CMPUI(EQ, r, IMM 0, tmp));
				    add_instr(BCNDI(NE,tmp,charl,false)))
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
		       in  (I desti, join_states[w8_state,w32_state,float_state])
		       end)
      in (VAR_LOC(VREGISTER r), c, state)
      end
 
  and xfloatupdate(vl1 : loc_or_val, vl2 : loc_or_val, vl3 : loc_or_val) : loc_or_val * con =
      let val a' = load_ireg_locval(vl1,NONE)
	  val argf = load_freg_locval(vl3,NONE)
      in (case (in_ea_range 8 vl2) of
	      SOME i => add_instr(STOREQF(EA(a',i),argf))
	    | NONE => let val b' = load_ireg_locval(vl2,NONE)
			  val addr = alloc_regi (LOCATIVE)
		      in  add_instr(S8ADD(b',REG a',addr));
			  add_instr(STOREQF(EA(addr,0),argf))
		      end);
	  unit_vvc
      end

  and xintupdate(is, vl1 : loc_or_val, vl2 : loc_or_val, vl3 : loc_or_val) : loc_or_val * con =
      let
	  val a' = load_ireg_locval(vl1,NONE)
	  val argi = load_ireg_locval(vl3,NONE)
      in  (case is of
	       Prim.W32 => (add_instr(ICOMMENT "int update start");
			    (case (in_ea_range 4 vl2) of
				SOME i => add_instr(STORE32I(EA(a',i),argi))
			      | NONE => let val b' = load_ireg_locval(vl2,NONE)
					    val addr = alloc_regi (LOCATIVE)
					in  add_instr(S4ADD(b',REG a',addr));
					    add_instr(STORE32I(EA(addr,0),argi))
					end);
				 add_instr(ICOMMENT "int update end"))
	     | Prim.W8 => let val addr = alloc_regi LOCATIVE
			      val offset = load_ireg_locval(vl2,NONE)
			      val subaddr = alloc_regi NOTRACE_INT
			      val temp = alloc_regi NOTRACE_INT
			      val temp2 = alloc_regi NOTRACE_INT
			      val data = alloc_regi NOTRACE_INT
			      val ordata = alloc_regi NOTRACE_INT
			      val mask = alloc_regi NOTRACE_INT
			      val _ = (add_instr(ICOMMENT "character update start");
				       add_instr(ANDB(offset,IMM 3, subaddr));
				       add_instr(NOTB(subaddr,temp));
				       add_instr(SLL(subaddr,IMM 3, subaddr));
				       add_instr(ANDB(offset,REG temp, temp2));
				       add_instr(ADD(a',REG temp2,addr));
				       add_instr(LOAD32I(EA(addr,0),data));
				       add_instr(LI(0w255, mask));
				       add_instr(SLL(mask,REG subaddr, mask));
				       add_instr(NOTB(mask,mask));
				       add_instr(ANDB(data,REG mask, data));
				       add_instr(SLL(argi,REG subaddr, ordata));
				       add_instr(ORB(data,REG ordata, data));
				       add_instr(STORE32I(EA(addr,0),data));
				       add_instr(ICOMMENT "character update start"))
			  in ()
			  end
	     | _ => error "xintupdate not implemented on this size");
	  unit_vvc
      end

  and xptrupdate(c, vl1 : loc_or_val, vl2 : loc_or_val, vl3 : loc_or_val) : loc_or_val * con =
      let
	  val a' = load_ireg_locval(vl1,NONE)
	  val argi = load_ireg_locval(vl3,NONE)
	  val addr = alloc_regi (LOCATIVE)
	  val wloc = alloc_regi (LOCATIVE)
	  val _ =  if (#do_write_list(!cur_params))
		       then (add_instr(NEEDMUTATE wloc);
			     (case (in_imm_range_vl vl2) of
				  SOME i' => add_instr(ADD(a',IMM (i'),addr))
				| NONE => let val t = load_ireg_locval(vl2,NONE)
					  in  add_instr(S4ADD(t,REG a',addr))
					  end);
				  add_instr(STORE32I(EA(wloc,0),addr)))
		   else ()
      in  xintupdate(Prim.W32, vl1, vl2, vl3)
      end

  and xupdate(state : state,c, vl1 : loc_or_val, vl2 : loc_or_val, vl3 : loc_or_val) 
      : loc_or_val * con * state =
      let
	  val state = 
	      (case (simplify_type' state c) of
		   (true,Prim_c(Float_c Prim.F64,[])) => (xfloatupdate(vl1,vl2,vl3); state)
		 | (true,Prim_c(BoxFloat_c Prim.F64,[])) => 
		       let val fr = unboxFloat(load_ireg_locval(vl3,NONE))
			   val _ = xfloatupdate(vl1,vl2,VAR_LOC(VREGISTER (F fr)))
		       in state
		       end
		 | (true,Prim_c(Float_c Prim.F32,[])) => error "32-bit floats not done"
		 | (true,Prim_c(Int_c is,[])) => (xintupdate(is,vl1,vl2,vl3); state)
		 | (true,_) => (xptrupdate(c,vl1,vl2,vl3); state)
		 | (false,_) => (* simplified type may involve variable not in scope *)
		     if ((case getCurrentFun() of
			      LOCAL_CODE v => not(Name.eq_var(local_update,v))
			    | _ => false))
			 then 
			     let val _ = local_update_used := true
				 val v1 = Name.fresh_named_var "array"
				 val v2 = Name.fresh_named_var "index"
				 val v3 = Name.fresh_named_var "item"
				 val ir1 = load_ireg_locval(vl1,NONE)
				 val ir2 = load_ireg_locval(vl2,NONE)
				 val ir3 = load_ireg_locval(vl3,NONE)
				 val state = add_var state (v1, I ir1, 
							    Prim_c(Array_c, [c]))
				 val state = add_var state (v2, I ir2, 
							    Prim_c(Int_c Prim.W32,[]))
				 val state = add_var state (v3, I ir3, c)
				 val e = App_e(Code,Var_e local_update,[c],
					       [Var_e v1, Var_e v2, Var_e v3],[])
				 val (r,_,s) = xexp'(state, Name.fresh_named_var "update", e,
						     SOME c, NOTID)
			     in  s
			     end
		     else
		       let val (r,_,state) = xcon(state,fresh_var(),c, NONE)
			   val tmp = alloc_regi NOTRACE_INT
			   val afterl = alloc_code_label "update_after"
			   val floatl = alloc_code_label "update_float"
			   val intl = alloc_code_label "update_int"
			   val charl = alloc_code_label "update_char"
			   val _ = (add_instr(CMPUI(EQ, r, IMM 11, tmp));
				    add_instr(BCNDI(NE,tmp,floatl,false));
				    add_instr(CMPUI(EQ, r, IMM 2, tmp));
				    add_instr(BCNDI(NE,tmp,intl,false));
				    add_instr(CMPUI(EQ, r, IMM 0, tmp));
				    add_instr(BCNDI(NE,tmp,charl,false)))
			   val _ = xptrupdate(c,vl1,vl2,vl3)
			   val _ = add_instr(BR afterl)
			   val _ = add_instr(ILABEL intl)
			   val _ = xintupdate(Prim.W32,vl1,vl2,vl3)
			   val _ = add_instr(BR afterl)
			   val _ = add_instr(ILABEL charl)
			   val _ = xintupdate(Prim.W8,vl1,vl2,vl3)
			   val _ = add_instr(BR afterl)
			   val _ = add_instr(ILABEL floatl)
			   val fr = unboxFloat(load_ireg_locval(vl3,NONE))
			   val _ = xfloatupdate(vl1,vl2,VAR_LOC(VREGISTER (F fr)))
			   val _ = add_instr(ILABEL afterl)
		       in  state
		       end)
      in (#1 unit_vvc, #2 unit_vvc, state)
      end

  and xeqarray(state : state,c, vl1 : loc_or_val, vl2 : loc_or_val) : loc_or_val * con * state =
      let val ir1 = load_ireg_locval(vl1,NONE)
	  val ir2 = load_ireg_locval(vl2,NONE)
	  val desti = alloc_regi NOTRACE_INT
	  val _ = add_instr(CMPUI(EQ,ir1,REG ir2,desti))
      in  (VAR_LOC(VREGISTER (I desti)),NilUtil.bool_con, state)
      end

  and xeqvector(state : state,c, vl1 : loc_or_val, vl2 : loc_or_val) : loc_or_val * con * state =
      error "xeqvector not implemented: should be done at ML source level"

  and xlength(state,c, vl : loc_or_val) : loc_or_val * con * state =
      let val dest = alloc_regi NOTRACE_INT
	  val src = load_ireg_locval(vl,NONE)
	  val _ = add_instr(LOAD32I(EA(src,~4),dest))
	  val (_,cc) = (simplify_type' state c) 
	  val state = 
	      (case (simplify_type' state c) of
		   (true,Prim_c(Float_c Prim.F64,[])) => (add_instr(SRL(dest,IMM real_len_offset,dest)); state)
		 | (true,Prim_c(BoxFloat_c Prim.F64,[])) => (add_instr(SRL(dest,IMM real_len_offset,dest)); state)
		 | (true,Prim_c(Int_c Prim.W8,[])) => (add_instr(SRL(dest,IMM int_len_offset,dest)); state)
		 | (true,Prim_c(Int_c Prim.W16,[])) => (add_instr(SRL(dest,IMM (1 + int_len_offset),dest)); state)
		 | (true,Prim_c(Int_c Prim.W32,[])) => (add_instr(SRL(dest,IMM (2 + int_len_offset),dest)); state)
		 | (true,c) => 
		       (print "------xlength: default head-normal case. con = \n";
			Ppnil.pp_con c; print "\n";
			add_instr(SRL(dest,IMM (2+int_len_offset),dest));
			state)
		 | (false,_) => let val (r,_,state) = xcon(state,fresh_var(),c, NONE)
				     val tmp = alloc_regi NOTRACE_INT
				     val afterl = alloc_code_label "length_after"
				     val floatl = alloc_code_label "length_float"
				     val charl = alloc_code_label "length_char"
				 in (add_instr(CMPUI(EQ, r, IMM 11, tmp));
				     add_instr(BCNDI(NE,tmp,floatl,false));
				     add_instr(CMPUI(EQ, r, IMM 0, tmp));
				     add_instr(BCNDI(NE,tmp,charl,false));
					 add_instr(SRL(dest,IMM (2+int_len_offset),dest));
					 add_instr(BR afterl);
					 add_instr(ILABEL floatl);
					 add_instr(SRL(dest,IMM real_len_offset,dest));
					 add_instr(BR afterl);
					 add_instr(ILABEL charl);
					 add_instr(SRL(dest,IMM (int_len_offset),dest));
					 add_instr(ILABEL afterl);
					 state)
				     end)
      in  (VAR_LOC (VREGISTER (I dest)), Prim_c(Int_c Prim.W32, []),state)
      end

    and floatcase (state, dest, Prim.F32, _, _) : state = error "no 32-bit floats"
      | floatcase (state, dest, Prim.F64, len, fr) = 
	let 
	    val ptag = if (!HeapProfile) then MakeProfileTag() else (i2w 0)
	    val skiptag      = alloc_regi NOTRACE_INT
	    val tag = alloc_regi(NOTRACE_INT)
	    val i = alloc_regi(NOTRACE_INT)
	    val tmp = alloc_regi(NOTRACE_INT)
	    val gctemp  = alloc_regi(NOTRACE_INT)
	    val cmptemp = alloc_regi(NOTRACE_INT)
	    val fsmall_alloc = alloc_code_label "array_float_smallalloc"
	    val fafter       = alloc_code_label "array_float_after" 
	    val fbottom      = alloc_code_label "array_float_bottom"
	    val ftop         = alloc_code_label "array_float_top"
	    val v = fr
	    (* store object tag and profile tag with alignment so that
	     raw data is octaligned;  then loop through and initialize *)

	in 
	    (* if array is too large, call runtime to allocate *)
	    add_instr(LI(0w4096,cmptemp));
	    add_instr(CMPUI(LE, len, REG cmptemp, cmptemp));
	    add_instr(BCNDI(NE,cmptemp,fsmall_alloc,true));
	    add_instr(FLOAT_ALLOC(len,v,dest,ptag));
	    add_instr(BR fafter);
	     
	    (* inline allocation code - start by doing the tag stuff*)
	    do_code_align();
	    add_instr(ILABEL fsmall_alloc);
	    add_instr(ADD(len,REG len, gctemp));
	    if (not (!HeapProfile))
		then
		    (add_instr(ADD(gctemp,IMM 3, gctemp));
		     needgc(state,REG gctemp);
		     align_odd_word();
		     mk_realarraytag(len,tag);
		     add_instr(STORE32I(EA(heapptr,0),tag)); (* store tag *)
		     add_instr(ADD(heapptr,IMM 4,dest)))
	    else
		(add_instr(ADD(gctemp,IMM 4, gctemp)));
		needgc(state,REG gctemp);
		align_even_word();
		store_tag_disp(0,ptag);                 (* store profile tag *)
		mk_realarraytag(len,tag);               
		add_instr(STORE32I(EA(heapptr,4),tag)); (* store tag *)
		add_instr(ADD(heapptr,IMM 8,dest));
		
		(* now use a loop to initialize the data portion *)
		add_instr(S8ADD(len,REG dest,heapptr));
		add_instr(LI(Rtltags.skiptag, skiptag));
		add_instr(STORE32I(EA(heapptr,0),skiptag));
		add_instr(ADD(heapptr,IMM 4,heapptr));
		add_instr(SUB(len,IMM 1,i));      (* init val *)
		add_instr(BR fbottom);             (* enter loop from bottom *)
		do_code_align();
		add_instr(ILABEL ftop);            (* loop start *)
		add_instr(S8ADD(i,REG dest,tmp));
		add_instr(STOREQF(EA(tmp,0),v));  (* initialize value *)
		add_instr(SUB(i,IMM 1,i));
		add_instr(ILABEL fbottom);
		add_instr(BCNDI(GE,i,ftop,true));
		do_code_align();
		add_instr(ILABEL fafter);
		new_gcstate state   (* after all this allocation, we cannot merge *)
	end (* end of floatcase *)


  and general_init_case(ptag : Word32.word, (* profile tag *)
			tag  : regi,        (* tag *)
			dest : regi,        (* destination register *)
			gctemp : loc_or_val,   (* number of words to increment heapptr by *)
			len : regi,         (* number of words to write *)
			v : regi,           (* write v (len) times *)
			gafter               (* label to jump to when done *)
			) = 
      let 
	  val skiptag      = alloc_regi NOTRACE_INT
	  val tmp          = alloc_regi NOTRACE_INT
	  val i            = alloc_regi NOTRACE_INT
	  val gbottom      = alloc_code_label "array_init_bottom"
	  val gtop         = alloc_code_label "array_init_top"
      in 
	  (if (not (!HeapProfile))
	       then
		   (add_instr(ICOMMENT "storing tag");
		    add_instr(STORE32I(EA(heapptr,0),tag)); (* allocation *)
		    add_instr(ADD(heapptr,IMM 4,dest)))
	   else
	       (store_tag_disp(0,ptag);
		add_instr(STORE32I(EA(heapptr,4),tag)); (* allocation *)
		add_instr(ADD(heapptr,IMM 8,dest))));
	       
	   (* gctemp's contents reflects the profile tag already *)
	   (case gctemp of
		   (VAR_VAL (VINT n)) => add_instr(ADD(heapptr, IMM (4*(w2i n)), heapptr))
		  | _ => let val gctemp = load_ireg_locval(gctemp,NONE)
			 in  add_instr(S4ADD(gctemp,REG heapptr,heapptr))
			 end);

		add_instr(LI(Rtltags.skiptag, skiptag));
		add_instr(STORE32I(EA(heapptr,0),skiptag));
		add_instr(SUB(len,IMM 1,i));  (* init val and enter loop from bot *)
		add_instr(BR gbottom);
		do_code_align();
		add_instr(ILABEL gtop);        (* top of loop *)
		add_instr(S4ADD(i,REG dest,tmp));
		add_instr(STORE32I(EA(tmp,0),v)); (* allocation *)
		add_instr(SUB(i,IMM 1,i));
		add_instr(ILABEL gbottom);
		add_instr(BCNDI(GE,i,gtop,true));
		do_code_align();
		add_instr(ILABEL gafter)
      end

    and intcase (state,dest,is,vl1,vl2) : state = 
	    let val tag = alloc_regi(NOTRACE_INT)
		val gctemp  = alloc_regi(NOTRACE_INT)
		val cmptemp = alloc_regi(NOTRACE_INT)
		val i       = alloc_regi(NOTRACE_INT)
		val tmp     = alloc_regi(LOCATIVE)
		val vtemp = load_ireg_locval(vl2,NONE)
		val loglen = load_ireg_locval(vl1,NONE)
		val ptag = if (!HeapProfile) then MakeProfileTag() else (i2w 0)
		val _ = add_instr(ICOMMENT "initializing int/ptr array start")
		val (wordlen,v,afteropt) = 
		    (case is of
			 Prim.W8 => 
			     let val fullres = alloc_regi NOTRACE_INT
				 val endres = alloc_regi NOTRACE_INT
				 val wordlen = alloc_regi(NOTRACE_INT)
				 val shift = alloc_regi(NOTRACE_INT)
				 val _ = (add_instr(ICOMMENT "about to make tag");
					  mk_intarraytag(loglen,tag);
					  add_instr(ICOMMENT "done making tag");
					  add_instr(ANDB(loglen,IMM 3,tmp));     (* tmp = loglen % 3 *)
					  add_instr(ADD(loglen,IMM 3,wordlen));
					  add_instr(SRL(wordlen,IMM 2,wordlen)); (* wordlen = (loglen + 3)/4*4 *)
					  add_instr(LI(0w4,shift));              (* use shift as a temp *)
					  add_instr(SUB(tmp,REG shift,tmp));
					  add_instr(ANDB(tmp,IMM 3,tmp));  (* tmp = (4 - (loglen % 4)) % 4 *)
					  add_instr(SLL(tmp, IMM 3,shift));         (* computed shift amount *)
					  
					  add_instr(SLL(vtemp,IMM 8,fullres));
					  add_instr(ORB(fullres,REG vtemp,vtemp));
					  add_instr(SLL(vtemp,IMM 16,fullres));
					  add_instr(ORB(fullres,REG vtemp,fullres)); (* computed fullres *)
					  add_instr(SRL(fullres,REG shift, endres)))   (* computed endres *)
				     
			     in  (wordlen,fullres, SOME endres)
			     end
		       | Prim.W16 => error "someday"
		       | Prim.W32 => (let val bytelen = alloc_regi NOTRACE_INT
				      in  add_instr(SLL(loglen,IMM 2, bytelen));
					  mk_intarraytag(bytelen,tag);
					  (loglen,vtemp,NONE)
				      end)
		       | Prim.W64 => error "someday")
		val gafter = alloc_code_label "array_int_after"
		val ismall_alloc = alloc_code_label "array_int_small"
	    in  (add_instr(LI(i2w 4096,cmptemp));
		 add_instr(CMPUI(LE, wordlen, REG cmptemp, cmptemp));
		 add_instr(BCNDI(NE,cmptemp,ismall_alloc,true));
		 add_instr(INT_ALLOC(wordlen,v,dest,ptag));
		 add_instr(BR gafter);
		 do_code_align();
		 add_instr(ILABEL ismall_alloc);
		 add_instr(CMPUI(EQ,loglen,IMM 0, gctemp));
		 add_instr(ADD(gctemp,IMM 1, gctemp));
		 add_instr(ADD(gctemp,REG wordlen, gctemp));
		 if (!HeapProfile)
		     then add_instr(ADD(gctemp, IMM 1, gctemp))
		 else ();
		 let val state = needgc(state,REG gctemp)
		 in  general_init_case(ptag,tag,dest,
				       VAR_LOC(VREGISTER(I gctemp)),
				       wordlen,v,gafter);
		     (case afteropt of
			  NONE => ()
			| SOME ir => (add_instr(SUB(wordlen,IMM 1,i));
				      add_instr(S4ADD(i,REG dest,tmp));
				      add_instr(STORE32I(EA(tmp,0),ir))));
		     add_instr(ICOMMENT "initializing int/ptr array end");
		     new_gcstate state   (* after all this allocation, we cannot merge *)
		 end)
	    end

     and ptrcase (state,dest,vl1,vl2) : state = 
	    let val tag = alloc_regi(NOTRACE_INT)
		val gctemp  = alloc_regi(NOTRACE_INT)
		val cmptemp = alloc_regi(NOTRACE_INT)
		val i       = alloc_regi(NOTRACE_INT)
		val tmp     = alloc_regi(LOCATIVE)
		val ptag = if (!HeapProfile) then MakeProfileTag() else (i2w 0)
		val len = load_ireg_locval(vl1,NONE)
		val v = load_ireg_locval(vl2,NONE)
		val gafter = alloc_code_label "array_ptr_aftert"
		val psmall_alloc = alloc_code_label "array_ptr_alloc"
		val state = new_gcstate state
	    in  (add_instr(LI((i2w 4096),cmptemp));
		 add_instr(CMPUI(LE, len, REG cmptemp, cmptemp));
		 add_instr(BCNDI(NE,cmptemp,psmall_alloc,true));
		 add_instr(PTR_ALLOC(len,v,dest,ptag));
		 add_instr(BR gafter);
		 do_code_align();
		 add_instr(ILABEL psmall_alloc);
		 add_instr(CMPUI(EQ,len,IMM 0, gctemp));
		 add_instr(ADD(gctemp,IMM 1, gctemp));
		 add_instr(ADD(gctemp,REG len, gctemp));
		 if (!HeapProfile)
		     then add_instr(ADD(gctemp, IMM 1, gctemp))
		 else ();
		     needgc(state,REG gctemp);
		     mk_ptrarraytag(len,tag);
		     general_init_case(ptag,tag,dest,
				       VAR_LOC(VREGISTER(I gctemp)),
				       len,v,gafter);
		     (* after all this allocation, we cannot merge *)
		     new_gcstate state)
	    end


  (* if we allocate arrays statically, we must add labels of pointer arrays to mutable_objects *)
 and xarray(state,c, vl1 : loc_or_val, vl2 : loc_or_val) : loc_or_val * con * state =
    let 
	val dest = alloc_regi TRACE
	val state = 
	    (case (simplify_type' state c) of
		 (true,Prim_c(Float_c Prim.F64,[])) => 
		     error "can't have WordArray of float (use boxfloat)"
	       | (true,Prim_c(Int_c is,[])) => intcase(state,dest,is,vl1,vl2)
	       | (true,Prim_c(BoxFloat_c fs,[])) => 
		     floatcase(state,dest,fs,
			       load_ireg_locval(vl1,NONE),
			       unboxFloat(load_ireg_locval(vl2,NONE)))
	       | (true,_) => ptrcase(state,dest,vl1,vl2)
	       | (false,_) => 
		     if ((case getCurrentFun() of
			      LOCAL_CODE v => not(Name.eq_var(local_array,v))
			    | _ => false))
			 then 
			     let val _ = local_array_used := true
				 val v1 = Name.fresh_named_var "size"
				 val v2 = Name.fresh_named_var "item"
				 val ir1 = load_ireg_locval(vl1,NONE)
				 val ir2 = load_ireg_locval(vl2,NONE)
				 val state = add_var state (v1, I ir1, 
							    Prim_c(Int_c Prim.W32,[]))
				 val state = add_var state (v2, I ir2, c)
				 val e = App_e(Code,Var_e local_array,[c],
					       [Var_e v1, Var_e v2],[])
				 val (I r,_,s) = xexp'(state, Name.fresh_named_var "array", e,
						     SOME c, NOTID)
				 val _ = add_instr(MV(r,dest))
			     in  s
			     end
		     else
		     let val (r,_,state) = xcon(state,fresh_var(),c, NONE)
			 val tmp = alloc_regi NOTRACE_INT
			 val afterl = alloc_code_label "array_after"
			 val floatl = alloc_code_label "array_float"
			 val intl = alloc_code_label "array_int"
			 val charl = alloc_code_label "array_char"
			 val _ = (add_instr(CMPUI(EQ, r, IMM 11, tmp));
				  add_instr(BCNDI(NE,tmp,floatl,false));
				  add_instr(CMPUI(EQ, r, IMM 2, tmp));
				  add_instr(BCNDI(NE,tmp,intl,false));
				  add_instr(CMPUI(EQ, r, IMM 0, tmp));
				  add_instr(BCNDI(NE,tmp,charl,false)))
			 val ptr_state = ptrcase(state,dest,vl1,vl2)
			 val _ = add_instr(BR afterl)

			 val _ = add_instr(ILABEL intl)
			 val int_state = intcase(state,dest,Prim.W32,vl1,vl2)
			 val _ = add_instr(BR afterl)

			 val _ = add_instr(ILABEL charl)
			 val char_state = intcase(state,dest,Prim.W8,vl1,vl2)
			 val _ = add_instr(BR afterl)

			 val _ = add_instr(ILABEL floatl)
			 val temp = load_ireg_locval(vl2,NONE)
			 val fr = alloc_regf()
			 val _ = add_instr(LOADQF(EA(temp,0),fr))
			 val float_state = floatcase(state,dest,Prim.F64,load_ireg_locval(vl1,NONE),fr)

			 val _ = add_instr(ILABEL afterl)
		     in  join_states [float_state, int_state, char_state, ptr_state]
		     end)
    in  (VAR_LOC (VREGISTER (I dest)), Prim_c(Array_c, [c]),state)
    end





   (* ------------------- translate constructors ------------------------ *)

  and xcon arg : regi * kind * state = 
      (case xcon' arg of
	   (_,VAR_LOC var_loc, k, s) => (load_ireg_loc(var_loc,NONE),k,s)
	 | (_,VAR_VAL var_val, k, s) => (load_ireg_val(var_val,NONE),k,s))

  and xcon' (state : state,
	    name : var, (* Purely for debugging and generation of useful names *)
	    arg_con : con,     (* The expression being translated *)
	    kopt : kind option (* Caller may know kind of con being translated *)
	    ) : bool * loc_or_val * kind * state = 
      let 
	  val _ = con_depth := !con_depth + 1
	  val _ = if (!debug)
		      then (print "xcon ";  print (Int.toString (!con_depth));
			    print " called";
			    if (!debug_full)
				then (print " on con = \n";
				      Ppnil.pp_con arg_con)
			    else ();
			    if (!debug_full_env)
				then (print "\nand with env = \n";
				      show_state state; print "\n")
			    else ();
			    print "\n")
		  else ()
	  val res = xcon''(state,name,arg_con,kopt)
	  val _ = if (!debug)
		      then (print "xcon ";  print (Int.toString (!con_depth));
			    print " returned\n")
		  else ()
	  val _ = con_depth := !con_depth - 1
      in  res
      end

  and xcon'' (state : state,
	    name : var, (* Purely for debugging and generation of useful names *)
	    arg_con : con,     (* The expression being translated *)
	    kopt : kind option (* Caller may know kind of con being translated *)
	    ) : bool * loc_or_val * kind * state = 
      let 
	  fun mk_ptr  i = (true, VAR_VAL (VINT (TW32.fromInt i)), Word_k Runtime, state)
	  fun mk_ptr' i = (true, VAR_VAL (VINT (TW32.fromInt i)), Type_k Runtime, state)
	  fun mk_sum_help (state,kinderopt,indices,cons) = 
	      let val indices' = map (fn i => VAR_VAL(VINT (TW32.fromInt i))) indices
	          fun folder (c,(const,s)) =
		       let val (const',c,k,s) = xcon'(s,fresh_named_var "xcon_sum",c, NONE)
		       in ((c,k),(const andalso const', s))
		       end
		  val (con_kinds,(const,state)) = foldl_list folder (true,state) cons
		  val cons' = map #1 con_kinds
		  val reps = (map (fn _ => NOTRACE_INT) indices') @ (map (fn _ => TRACE) cons')
		  val kind = (case kinderopt of
				  NONE => Word_k Runtime
				| SOME kinder => kinder con_kinds)
		  val (lv,state) = if const 
				       then make_record_const(state,NONE,reps, indices' @ cons')
				   else make_record(state,NONE,reps, indices' @ cons')
	      in (const, lv, kind, state)
	      end
	  fun mk_sum' (s,indices,cons) = mk_sum_help(s,NONE,indices,cons)
	  fun mk_sum (s,index,cons) = mk_sum_help(s,NONE,[index],cons)
	  open Prim
      in
	  (case arg_con of
	       Prim_c(Int_c W8, []) => mk_ptr 0
	     | Prim_c(Int_c W16, []) => mk_ptr 1
	     | Prim_c(Int_c W32, []) => mk_ptr 2
	     | Prim_c(Int_c W64, []) => mk_ptr' 3
	     | Prim_c(Float_c F32, []) => mk_ptr' 6 
	     | Prim_c(Float_c F64, []) => mk_ptr' 7
	     | Prim_c(BoxFloat_c F32, []) => mk_ptr 10
	     | Prim_c(BoxFloat_c F64, []) => mk_ptr 11
	     | Prim_c(Exn_c,[]) => mk_ptr 12
	     | Prim_c(Exntag_c,[c]) => mk_sum(state,12,[c])
	     | Prim_c(Array_c,[c]) => mk_sum(state,0,[c])
	     | Prim_c(Vector_c,[c]) => mk_sum(state,1,[c])
	     | Prim_c(Ref_c,[c]) => mk_sum(state,2,[c])
	     | Prim_c(Sum_c {known,totalcount,tagcount},cons) => 
		   mk_sum'(state,
			   [4,(case known of
				   NONE => ~1
				 | SOME w => TW32.toInt w), 
			    TW32.toInt tagcount,
			    TW32.toInt totalcount],cons)
	     | Prim_c(Record_c _,cons) => mk_sum_help(state,NONE,[5,length cons],cons)
	     | Prim_c(Vararg_c _,cons) => mk_sum(state,6,cons)
	     | Prim_c _ => error "ill-formed primitive type"
	     | Mu_c (is_recur,vcset) => 
		   let val (const,lv,k,state) = mk_sum_help(state,NONE,[8],[])
		       val num_mu = length (Util.sequence2list vcset)
		   in  if (num_mu = 1) then (const,lv,k,state)
		       else let val kind = kind_tuple(Listops.map0count (fn _ => k) num_mu)
				val reps = Listops.map0count (fn _ => TRACE) num_mu
				val vl = Listops.map0count (fn _ => lv) num_mu
				val (lv,state) = if const 
						     then make_record_const(state,NONE,reps,vl)
						 else make_record_const(state,NONE,reps,vl)
			    in  (const,lv,kind,state)
			    end
		   end
(*
		   let val vclist = sequence2list vcset
		       fun loop _ [] (s,rev_lvs) = (s,rev rev_lvs)
			 | loop n ((v',c)::vrest) (s,rev_lvs) = 
			   let val (lv,k,s) = if is_recur
						then mk_sum'(s,[7,0],[])
					    else mk_sum(s,7,[c])
			   in  loop (n+1) vrest (s,lv::rev_lvs)
			   end
		       val (state,lvs) = loop 0 vclist (state,[])
			   
		       val state = 
			   if is_recur
			       then
				   let val clregs = map (fn lv => load_ireg_locval(lv,NONE)) lvs
				       fun folder (((v,_),clreg),s) = add_convar s (v,SOME(VREGISTER (I clreg)),
										    NONE,Word_k Runtime,NONE)
				       val recstate = foldl folder state (zip vclist clregs)
				       fun do_write ((clreg,(v,c)),s) = 
					   let val (r,_,s) = xcon(s,v,c, NONE)
					   in  add_instr(STORE32I(EA(clreg,4),r)); s
					   end
				   in  foldl do_write recstate (zip clregs vclist)
				   end
			       else state
		   in (case lvs of
			   [lv] => (lv, Word_k Runtime, state)
			 | _ => let val kind = kind_tuple (map (fn _ => Word_k Runtime) lvs)
				    val reps = map (fn _ => TRACE) lvs
				    val (lv,state) = make_record(state,NONE,reps,lvs)
				in  (lv,kind,state)
				end)
		   end
*)
	     | AllArrow_c (Open,_,_,_,_,_) => error "open Arrow_c"
	     | AllArrow_c (Closure,_,_,clist,numfloat,c) => 
		   mk_sum_help(state,NONE,[9],[])
(*		   mk_sum_help(NONE,[9,TW32.toInt numfloat],c::clist) *)
	     | AllArrow_c (Code,_,_,clist,numfloat,c) => 
(*		   mk_sum_help(state,NONE,[10,TW32.toInt numfloat],c::clist) *)
		   mk_sum_help(state,NONE,[10],[])
	     | AllArrow_c (ExternCode,_,_,clist,numfloat,c) => 
(*		   mk_sum_help(NONE,[11,TW32.toInt numfloat],c::clist) *)
		   mk_sum_help(state,NONE,[11],[])
	     | Var_c v => (case (getconvarrep state v) of
			       (_,SOME vv, k) => (true, VAR_VAL vv,k,state)
			     | (SOME vl,_, k) => 
				   let val const = (case vl of
							VGLOBAL _ => true
						      | _ => false)
				   in  (const, VAR_LOC vl,k,state)
				   end
			     | (NONE,NONE,_) => error "no info on convar")
	     | Let_c (letsort, cbnds, c) => 
		   let fun folder (cbnd,s) = xconbnd s cbnd
		       val s' = foldl folder state cbnds
		   in  xcon'(s',fresh_var(),c, kopt)
		   end
	     | Crecord_c lclist => 
		   let val vars = map (fn (l,_) => fresh_named_var (label2string l)) lclist
		       fun folder ((v,(l,c)),(const,state)) = 
			   let val (const',vl,k,state) = xcon'(state,v,c,NONE)
			   in ((l,v,(vl,k)), (const andalso const', state))
			   end
		       val (lvregikind,(const,state)) = foldl_list folder (true,state) (zip vars lclist)
		       val lvkList = map (fn (l,v,(_,k)) => ((l,v),k)) lvregikind
		       val kind = Record_k(list2sequence lvkList)
		       val lvs = map (fn (_,_,(lv,_)) => lv) lvregikind
		       val reps = map (fn _ => TRACE) lvs
		       val (lv,state) = (case (!do_single_crecord,lclist) of
					     (true,[_]) => (hd lvs, state)
					   | _ => if const 
						    then make_record_const(state,NONE,reps,lvs)
						  else make_record(state,NONE,reps,lvs))
		   in  (const,lv,kind,state)
		   end
	     | Proj_c (c, l) => 
		   let val (const,lv,k,state) = xcon'(state,fresh_named_var "proj_c",
								   c,NONE)
		       val k as Record_k lvk_seq = NilUtil.kill_singleton k
		       fun default() = 
			   let fun loop [] _ = error "ill-formed projection"
				 | loop (((l',_),k)::vrest) n = if (eq_label(l,l')) 
							    then (n,k) else loop vrest (n+1)
		       (* fieldk may have dependencies *)			
			       val (which,fieldk) = 
				   (case k of
					Record_k lvk_seq => loop (sequence2list lvk_seq) 0
				      | _ => error "bad kind to proj_c from")
			       val dest = alloc_regi TRACE
			       val ir = load_ireg_locval(lv,NONE)
			       val _ = add_instr(LOAD32I(EA(ir,4 * which),dest))
			   in (const,VAR_LOC(VREGISTER (I dest)), fieldk, state)
			   end
		   in  (case (!do_single_crecord,Util.sequence2list lvk_seq) of
			    (true,[(_,k)]) => (const,lv,k,state)
			  | _ => default())
		   end
	     | Closure_c (c1,c2) => 
		   let 
		       fun kinder [(_,Arrow_k(_,vklist : (var * kind) list, k)),_] = 
			   let val vklist' = butlast vklist
			   in  Arrow_k(Closure,vklist',k)
			   end
			 | kinder _ = error "bad Closure_c"
		   in  mk_sum_help(state,SOME kinder,[],[c1,c2])
		   end
	     | Typecase_c _ => error "typecase_c not implemented"
	     | App_c (c,clist) => (* pass in env argument first *)
		   let val (const_fun,lv,k,state) = xcon'(state,fresh_named_var "closure",c,NONE)
		       val clregi = load_ireg_locval(lv,NONE)
		       val resk = (case (kopt,NilUtil.strip_singleton k) of
				       (SOME k, _) => k
				     | (_,Arrow_k(_,_,resk)) => resk (* getshape?? *)
				     | _ => (Ppnil.pp_kind k; print "\n";
					     error "bad kind to App_c"))
		       val (cregsi,(const_arg,state)) = 
			   foldl_list  (fn (c,(const,state)) => 
				   let val (const',vl,_,state) = xcon'(state,fresh_named_var "clos_arg",c,NONE)
				   in  (load_ireg_locval(vl,NONE),(const andalso const', state))
				   end) (true,state) clist
		       val const = const_fun andalso const_arg
		       val coderegi = alloc_regi NOTRACE_CODE
		       val envregi = alloc_regi TRACE
		       val _ = (add_instr(LOAD32I(EA(clregi,0),coderegi));
				add_instr(LOAD32I(EA(clregi,4),envregi)))
		       val desti = alloc_regi TRACE
		       val _ = add_instr(CALL{extern_call = false,
					      func=REG' coderegi,
					      return=NONE,
					      args=(cregsi @ [envregi],[]),
					      results=([desti],[]),
					      tailcall=false,
					      save=SAVE(getLocals())})
		       val state = new_gcstate state
		   in (const,VAR_LOC (VREGISTER (I desti)),resk,state)
		   end
	     | Annotate_c (_,c) => xcon'(state,name,c,kopt))
      end

  

  local 
      fun doconfun is_top (state,name,vklist,body,kind) = 
	  let 
	      val _ = reset_state(is_top,name)
	      val _ = if (!debug)
			  then (print "-----doconfun on "; Ppnil.pp_var name; 
				if (!debug_full)
				    then (print " with body\n"; Ppnil.pp_con body)
				else ();
				print "\n")
		      else ()
              fun folder ((v,k),s) = let val r = alloc_named_regi v TRACE
					       val s' = add_convar s (v,SOME(VREGISTER (I r)),NONE,k,NONE)
					   in  (r,s')
                                           end
	      val (cargs,state) = foldl_list folder state vklist
	      val args = (cargs,[])
	      val resulti = alloc_regi TRACE
	      val results = ([resulti],[])
	      val return = alloc_regi(LABEL)
	      val _ = set_args_result(args, I resulti, return)
	      val state = needgc(state,IMM 0)
	      val (ir,k,state) = xcon(state,fresh_named_var "result",body,NONE)
	      val _ = (add_instr(MV(ir,resulti));
		       add_instr(RETURN return))
	      val {name=label_name,code} = get_state()
	      val extern = (case (Name.VarMap.find(!exports,name)) of
			      NONE => NONE
			    | SOME [] => error "export has no labels"
			    | SOME (l::_) => SOME (ML_EXTERN_LABEL(Name.label2string l)))
	      val p = PROC{external_name=extern,
			   name=label_name,
			   return=return,
			   args=args,
			   results=results,
			   code=Array.fromList code,
			   known=false,
			   save=SAVE(nil,nil),
			   vars=NONE}
	  in add_proc p
	  end
     fun dofun_help is_top (state,name,Function(effect,recur,vklist,vclist,vflist,body,con)) = 
	  let 
	      val _ = reset_state(is_top, name)
	      val _ = if (!debug)
			  then (print "-----dofun_help : "; Ppnil.pp_var name; print "\n")
		      else ()
              fun folder ((v,k),s) = let val r = alloc_named_regi v TRACE
					       val s' = add_convar s (v,SOME(VREGISTER (I r)),NONE,k,NONE)
					   in  (r,s')
                                           end
	      val (cargs,state) = foldl_list folder state vklist
              fun folder ((v,c),s) = let val r as (I ir) = alloc_named_reg s (c,v)
					 val s' = add_var s (v,r,c)
			             in  (ir, s')
                                     end
	      val (eiargs,state) = foldl_list folder state vclist
              fun folder (v,s) = let val fr = alloc_named_regf v
					       val s' = add_var s (v,F fr,Prim_c(Float_c Prim.F64,[]))
					   in  (fr,s')
                                           end
              val (efargs,state) = foldl_list folder state vflist

	      val args = (cargs @ eiargs, efargs)
	      val result = alloc_reg state con
	      val results = (case result of
				 I ir => ([ir],[])
			       | F fr => ([],[fr]))
	      val return = alloc_regi(LABEL)
	      val _ = set_args_result(args, result, return)
	      val state = needgc(state,IMM 0)
	      val (r,c,state) = xexp'(state,fresh_named_var "result",body,
				SOME con, ID return)
	      val mvinstr = (case (r,result) of
				 (I ir1,I ir2) => MV(ir1,ir2)
			       | (F fr1,F fr2) => FMV(fr1,fr2)
			       | _ => error "register mismatch")
	      val _ = (add_instr mvinstr;
		       add_instr(RETURN return))
	      val {name=label_name,code} = get_state()
	      val extern = (case (Name.VarMap.find(!exports,name)) of
			      NONE => NONE
			    | SOME [] => error "export has no labels"
			    | SOME (l::_) => SOME (ML_EXTERN_LABEL(Name.label2string l)))
	      val p = PROC{external_name=extern,
			   name=label_name,
			   return=return,
			   args=args,
			   results=results,
			   code=Array.fromList code,
			   known=false,
			   save=SAVE(nil,nil),
			   vars=NONE}
	  in  p
	  end
     fun dofun arg = add_proc(dofun_help false arg)
  in
      fun dofun_top arg = dofun_help true arg
      fun worklist_loop () = 
	  (case getWork() of
	       NONE => ()
	     | SOME (n,FunWork vf) => 
		   (if (!diag)
			then (print "*** Working on fun "; print (Int.toString n); print "\n")
		    else ();
		    dofun vf; 
		    if (!diag)
		      then (print "*** Finished fun "; print (Int.toString n); print "\n")
		    else ();
		    worklist_loop())
	     | SOME (n,ConFunWork vvkck) => 
			(if (!diag) 
			     then (print "*** Working on confun "; 
				   print (Int.toString n); print "\n")
			 else ();
			 doconfun false vvkck; 
			 if (!diag)
			     then (print "*** Finished confun "; 
				   print (Int.toString n); print "\n")
			 else ();
			 worklist_loop()))
  end

  (* compute toplevel non-globals: that is, "globals"
   that are not accessed inside any function and that are unexported;
   when this is the case, we can allocate statically *)
  fun compute_globals (bnds : bnd list, exports : export_entry list, imports : import_entry list) =
      let 
	  val toplevels = ref VarSet.empty
	  val globals = ref VarSet.empty
	  fun addtop v = toplevels := VarSet.add(!toplevels,v)
	  fun addglobal v = globals := VarSet.add(!globals,v)
	  val numfuns = ref 0
	  val numconfuns = ref 0
	  val inner = 
	      let 
		  fun add v = (if (VarSet.member(!toplevels,v))
				   then (addglobal v
					 handle e => (print "yep, this delete\n";
						      raise e))
			       else ();
				   NOCHANGE)
		  fun ehandle (_,Var_e v) = add v
		    | ehandle _ = NOCHANGE
		  fun chandle (_,Var_c v) = add v
		    | chandle _ = NOCHANGE
		  fun bndhandle (_,Fixcode_b s) = (numfuns := (!numfuns) + (length (sequence2list s)); 
						   NOCHANGE)
		    | bndhandle _ = NOCHANGE
		  fun cbndhandle (_,Code_cb _) = (numconfuns := (!numconfuns) + 1; NOCHANGE)
		    | cbndhandle _ = NOCHANGE
		      
	      in  (ehandle,
		   bndhandle,
		   chandle,
		   cbndhandle,
		   fn _ => NOCHANGE)
	      end
	  
	  val outer = 
	      let 
		  fun bndhandle (_,Con_b(v,_,_)) = (addtop v; addglobal v; NOCHANGE)
		    | bndhandle (_,Exp_b(v,_,_)) = (addtop v; NOCHANGE)
		    | bndhandle (_,Fixopen_b _) = error "encountered fixopen"
		    | bndhandle (_,bnd as (Fixcode_b vfset)) = 
		      let val _ = numfuns := (!numfuns) + 1
			  val vflist = set2list vfset
			  fun dofun (Function (_,_,vklist,vclist,_,e,c)) = 
			      let
				  val _ = map (fn (_,k) => kind_rewrite inner k) vklist
				  val _ = map (fn (_,c) => con_rewrite inner c) vclist
				  val _ = exp_rewrite inner e
				  val _ = con_rewrite inner c
			      in  ()
			      end
			  val _ = app (fn (v,f) => dofun f) vflist
		      in  CHANGE_NORECURSE [bnd]
		      end
		    | bndhandle (_,bnd as (Fixclosure_b(_,vclset))) = 
		      let val vcllist = set2list vclset
			  fun docl {code,cenv,venv,tipe} = 
			      let
				  val _ = exp_rewrite inner venv
				  val _ = con_rewrite inner cenv
			      (* don't need to do tipe *)
			      in  ()
			      end
			  val _ = app (fn (v,cl) => (addtop v; docl cl)) vcllist
		      in  CHANGE_NORECURSE [bnd]
		      end
		  
		  fun chandle (_,Mu_c(_,vcseq)) = (map (fn (v,_) => 
							  (addtop v; addglobal v))
						     (sequence2list vcseq);
						     NOCHANGE)
		    | chandle _ = NOCHANGE
		  fun cbhandle (_,Con_cb (v,_,_)) = (addtop v; addglobal v; NOCHANGE)
		    | cbhandle (_,Open_cb _) = error "encountered open_cb"
		    | cbhandle (_,cbnd as (Code_cb (_,vklist,c,k))) = 
		      let val _ = numconfuns := (!numconfuns) + 1
			  val _ = map (fn (_,k) => kind_rewrite inner k) vklist
			  val _ = kind_rewrite inner k
			  val _ = con_rewrite inner c
		      in  CHANGE_NORECURSE [cbnd]
		      end
		  fun khandle (_,k) = CHANGE_NORECURSE k
	      in  (fn _ => NOCHANGE,
		   bndhandle,
		   chandle,
		   cbhandle,
		   khandle)
	      end
	  fun do_export (ExportValue(l,e,c)) = (exp_rewrite inner e;
						con_rewrite inner c; ())
	    | do_export (ExportType(l,c,k)) = (con_rewrite inner c;
					       kind_rewrite inner k; ())
	  fun do_import (ImportValue(l,v,_)) = (addtop v; addglobal v)
	    | do_import (ImportType(l,v,_)) =  (addtop v; addglobal v)
	  val _ = map (bnd_rewrite outer) bnds
	  val _ = app do_export exports
	  val _ = app do_import imports
	  val _ = (print "There are "; print (Int.toString (!numfuns));
		   print " functions and "; print (Int.toString (!numconfuns));
		   print " constructor functions\n")
	  val _ = if (!debug)
		      then (print "Globals are: ";
			    VarSet.app (fn v => (Pprtl.pp_var v; print "\n")) (!globals);
			    print "\n\n";
			    print "Top-levels are: ";
			    VarSet.app (fn v => (Pprtl.pp_var v; print "\n")) (!toplevels);
			    print "\n\n")
		  else ()
      in  !globals
      end (* compute_globals *)


  (* unitname is the name of the unit; unit names are globally unique. *)

   fun translate (unitname:string) trans_params (Nil.MODULE{bnds : bnd list,
					  imports : import_entry list,
					  exports : export_entry list}) =
         let 

	     val _ = if (!debug)
			 then print "tortl - entered translate\n"
		     else ()


	     val globals = compute_globals(bnds,exports,imports)

	     val _ = if (!debug)
			 then print "tortl - handling exports now\n"
		     else ()

	     (* we do something special for exports of a variable *)
	     local
		 fun mapper (exp as ExportValue(l,Var_e v,_)) = ((v,l),exp)
		   | mapper (exp as ExportType(l,Var_c v,_)) = ((v,l),exp)
		   | mapper (exp as ExportValue(l,_,_)) = ((fresh_var(),l),exp)
		   | mapper (exp as ExportType(l,_,_)) = ((fresh_var(),l),exp)
	     in  val named_exports = map mapper exports
	     end

	     val _ = (local_sub_used := false;
		      local_update_used := false;
		      local_array_used := false)
	     val _ = resetDepth()
		 val _ = resetWork()
	     val _ = reset_global_state (map #1 named_exports,globals)

	     (* we put non-variable exports at the tail of the program;
              creating a main expression to be translated  *)
	     local fun mapper (_,ExportValue(l,Var_e v,_)) = NONE
		     | mapper (_,ExportType(l,Var_c v,_)) = NONE
		     | mapper ((v,_),ExportValue(l,e,c)) = SOME(Exp_b(v,c,e))
		     | mapper ((v,_),ExportType(l,c,k)) = SOME(Con_b(v,k,c))
		   val local_bnds = 
		       let val c = Name.fresh_named_var "subscript_type"
			   val array = Name.fresh_named_var "subscript_array"
			   val index = Name.fresh_named_var "subscript_index"
			   val body = Prim_e(PrimOp(Prim.sub Prim.WordArray), [Var_c c], 
					     [Var_e array, Var_e index])
			   val sub_fun = Function(Partial,Leaf,[(c,Word_k Runtime)],
						  [(array,Prim_c(Array_c,[Var_c c])),
						   (index,Prim_c(Int_c Prim.W32 ,[]))], [],
						  body, Var_c c)
			   val c = Name.fresh_named_var "update_type"
			   val array = Name.fresh_named_var "update_array"
			   val index = Name.fresh_named_var "update_index"
			   val item = Name.fresh_named_var "update_item"
			   val body = Prim_e(PrimOp(Prim.update Prim.WordArray), [Var_c c], 
					     [Var_e array, Var_e index, Var_e item])
			   val update_fun = Function(Partial,Leaf,[(c,Word_k Runtime)],
						  [(array,Prim_c(Array_c,[Var_c c])),
						   (index,Prim_c(Int_c Prim.W32 ,[])),
						   (item,Var_c c)], [],
						  body, Var_c c)
			   val c = Name.fresh_named_var "array_type"
			   val size = Name.fresh_named_var "array_size"
			   val item = Name.fresh_named_var "array_item"
			   val body = Prim_e(PrimOp(Prim.create_table Prim.WordArray), [Var_c c], 
					     [Var_e size, Var_e item])
			   val array_fun = Function(Partial,Leaf,[(c,Word_k Runtime)],
						  [(size,Prim_c(Int_c Prim.W32 ,[])),
						   (item,Var_c c)], [],
						  body, Prim_c(Array_c,[Var_c c]))
		       in  [Fixcode_b (Util.list2sequence [(local_sub,sub_fun)]),
			    Fixcode_b (Util.list2sequence [(local_update,update_fun)]),
			    Fixcode_b (Util.list2sequence [(local_array,array_fun)])]
		       end
		   val export_bnds = List.mapPartial mapper named_exports
	     in  val exp = Let_e(Sequential,local_bnds,
				 Let_e(Sequential, bnds,
				   Let_e(Sequential,export_bnds,
				   Const_e(Prim.int(Prim.W32,TW64.zero)))))
		 val con = Prim_c(Int_c Prim.W32,[])
	     end

	     (* set the translation parameters *)
	     val _ = cur_params := trans_params
	     val _ = (case trans_params of
			  {HeapProfile = SOME c, ...} => (HeapProfile := true;
							  SetHeapProfileCounter c)
			| {HeapProfile = NONE, ...} => HeapProfile := false)

		 
	     val _ = if (!debug)
			 then print "tortl - handling imports now\n"
		     else ()

	    (* translate the expression as a function taking no arguments *)
	     val mainName = non_generative_named_var ("main_" ^ unitname ^ "_doit")
	     fun folder (ImportValue(l,v,c),s) = 
		 (* hack, the imports are not making a distinction between labels
		    as values (as in the first case) or labels as positions where the value is located *)
		 let val mllab = ML_EXTERN_LABEL(Name.label2string l)
		 in  (case c of
			  AllArrow_c(ExternCode,_,_,_,_,_) => add_var' s (v,NONE,SOME(VCODE mllab),c)
			| _ => add_var' s (v,SOME(VGLOBAL(mllab,con2rep s c)),NONE,c))
		 end
	       | folder (ImportType(l,v,k),s) = 
		 add_convar s (v,SOME(VGLOBAL(ML_EXTERN_LABEL(Name.label2string l),TRACE)),
			       NONE,k,NONE)
	     val state = foldl folder (make_state()) imports
	     val PROC{external_name,name,return,args,results,code,known,save,vars} =
		 dofun_top (state,mainName,Function(Partial,Nonleaf,[],[],[],exp,con))
	     val p' = PROC{external_name=external_name,
			   name=name,
			   return=return,
			   args=args,
			   results=([],[]),
			   code=code,
			   known=known,
			   save=save,
			   vars=vars}
	     val _ = add_proc p'

	     val _ = if (!debug)
			 then print "tortl - calling worklist now\n"
		     else ()

	     val _ = worklist_loop()

	     val _ = print "tortl - returned from worklist now\n"
	     val _ = if (!debug)
			 then print "tortl - returned from worklist now\n"
		     else ()

	     val procs = let fun revFilter acc [] = acc
			       | revFilter acc ((a as PROC{name,...})::b) = 
		                   let val v = (case name of
						    LOCAL_CODE v => v
						  | LOCAL_DATA v => v)
				       val is_sub = Name.eq_var(local_sub,v) 
				       val is_update = Name.eq_var(local_update,v) 
				       val is_array = Name.eq_var(local_array,v) 
				       val discard = (is_sub andalso  not (!local_sub_used))
					   orelse (is_update andalso  not (!local_update_used))
					   orelse (is_array andalso  not (!local_array_used))
				   in  if discard 
					   then revFilter acc b
				       else revFilter (a::acc) b
				   end
			 in  revFilter [] (!pl)
			 end

	     val module = Rtl.MODULE {procs = procs,
				      data = rev(!dl),
				      main=LOCAL_CODE mainName,
				      mutable_objects = get_mutable_objects(),
				      mutable_variables = get_mutable_variables()}
	 in module
	 end


end;
