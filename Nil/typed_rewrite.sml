(*
 * A simple rewriter that does not try to synthesize types.
 *
 * The idea is to provide a generic traversal algorithm that crawls over
 * a parse tree in simple block structured fashion.  At every node, it
 * provides the client code with the current node under consideration
 * and a current state.  The client then returns
 *
 * NOCHANGE        if the node was not changed, and should be
 *                 recursively traversed
 * NORECURSE       if the node was not changed, and should not be
 *                 recursively traversed
 * CHANGE_RECURSE (state,term)
 *                 if the node was changed to "term" with new state "state",
 *                 and the new term should be recursively traversed
 * CHANGE_NORECURSE (state,term)
 *                 if the node was changed to "term" with new state "state",
 *                 and the new term should not be recursively traversed
 *
 * One benefit of using this code is that it tries extremely hard to preserve
 * physical sharing.
 *)

signature TYPEDNILREWRITE =
  sig
    datatype 'a changeopt = NOCHANGE | NORECURSE | CHANGE_RECURSE of 'a | CHANGE_NORECURSE of 'a

    type ('state,'term) termhandler = 'state * 'term -> ('state * 'term) changeopt
    type ('state, 'bnd) bndhandler  = 'state * 'bnd -> ('state * 'bnd list) changeopt
    type ('state,'class) binder     = 'state * Nil.var * 'class -> ('state * Nil.var option)
    type ('state,'term) definer     = 'state * Nil.var * 'term -> ('state * Nil.var option)

    datatype 'state handler =
      HANDLER of {
		  bndhandler : ('state, Nil.bnd) bndhandler,
		  cbndhandler : ('state, Nil.conbnd) bndhandler,
		  (*For cbnds, a return of CHANGE_NORECURSE (state,cbnds)
		   * will result in cbnds being bound in state before being returned.
		   *)

		  conhandler   : ('state,Nil.con) termhandler,
		  exphandler   : ('state,Nil.exp) termhandler,
		  kindhandler  : ('state,Nil.kind) termhandler,
		  tracehandler : ('state,Nil.niltrace) termhandler,
		  con_var_bind   : ('state,Nil.kind) binder,
		  con_var_define : ('state,Nil.con) definer,
		  exp_var_bind   : ('state,Nil.con) binder,
		  exp_var_define : ('state,Nil.exp) definer,
		  sum_var_bind   : ('state,(Nil.con * Nil.w32)) binder,
		  exn_var_bind   : ('state,Nil.exp) binder
		  }

    val rewriters : 'state handler -> {
				       rewrite_kind : 'state -> Nil.kind -> Nil.kind,
				       rewrite_con :  'state -> Nil.con -> Nil.con,
				       rewrite_exp :  'state -> Nil.exp -> Nil.exp,
				       rewrite_bnd :  'state -> Nil.bnd -> (Nil.bnd list * 'state),
				       rewrite_cbnd :  'state -> Nil.conbnd -> (Nil.conbnd list * 'state),
				       rewrite_trace : 'state -> Nil.niltrace -> Nil.niltrace,
				       rewrite_mod : 'state -> Nil.module -> Nil.module
				       }
    val null_handler        : 'state * 'a -> ('state * 'b) changeopt

    val null_binder         : ('state,'a) binder

    val default_handler     : 'state handler

    val set_kindhandler     : 'state handler -> ('state, Nil.kind) termhandler -> 'state handler
    val set_conhandler      : 'state handler -> ('state, Nil.con) termhandler  -> 'state handler
    val set_exphandler      : 'state handler -> ('state, Nil.exp) termhandler  -> 'state handler

    val set_con_binder      : 'state handler -> ('state,Nil.kind) binder -> 'state handler
    val set_con_definer     : 'state handler -> ('state,Nil.con) definer -> 'state handler

    val set_exp_binder      : 'state handler -> ('state,Nil.con) binder  -> 'state handler
    val set_exp_definer     : 'state handler -> ('state,Nil.exp) definer -> 'state handler

    val set_sum_binder      : 'state handler -> ('state,(Nil.con * Nil.w32)) binder -> 'state handler
    val set_exn_binder      : 'state handler -> ('state,Nil.exp) binder -> 'state handler

  end

structure TypedNilRewrite :> TYPEDNILREWRITE =
  struct
    open Nil

    val foldl_acc = Listops.foldl_acc
    val foldl_acc2 = Listops.foldl_acc2
    val map_second = Listops.map_second
    val mapopt = Util.mapopt
    fun error s = Util.error "NilRewrite" s
    val lprintl = Util.lprintl

    datatype 'a changeopt = NOCHANGE | NORECURSE | CHANGE_RECURSE of 'a | CHANGE_NORECURSE of 'a

    type ('state,'term) termhandler = 'state * 'term -> ('state * 'term) changeopt
    type ('state, 'bnd) bndhandler  = 'state * 'bnd -> ('state * 'bnd list) changeopt
    type ('state,'class) binder     = 'state * Nil.var * 'class -> ('state * Nil.var option)
    type ('state,'term) definer     = 'state * Nil.var * 'term -> ('state * Nil.var option)

    datatype 'state handler =
      HANDLER of {
		  bndhandler : ('state,Nil.bnd) bndhandler,
		  cbndhandler : ('state, Nil.conbnd) bndhandler,
		  (*For cbnds, a return of CHANGE_NORECURSE (state,cbnds)
		   * will result in cbnds being bound in state before being returned.
		   *)

		  conhandler   : ('state,Nil.con) termhandler,
		  exphandler   : ('state,Nil.exp) termhandler,
		  kindhandler  : ('state,Nil.kind) termhandler,
		  tracehandler : ('state,Nil.niltrace) termhandler,
		  con_var_bind   : ('state,Nil.kind) binder,
		  con_var_define : ('state,Nil.con) definer,
		  exp_var_bind   : ('state,Nil.con) binder,
		  exp_var_define : ('state,Nil.exp) definer,
		  sum_var_bind   : ('state,(Nil.con * Nil.w32)) binder,
		  exn_var_bind   : ('state,Nil.exp) binder
		  }

    fun rewriters (handler : 'state handler)
      : {
	 rewrite_kind  : 'state -> Nil.kind -> Nil.kind,
	 rewrite_con   : 'state -> Nil.con -> Nil.con,
	 rewrite_exp   : 'state -> Nil.exp -> Nil.exp,
	 rewrite_bnd   : 'state -> Nil.bnd -> (Nil.bnd list * 'state),
	 rewrite_cbnd  : 'state -> Nil.conbnd -> (Nil.conbnd list * 'state),
	 rewrite_trace : 'state -> Nil.niltrace -> Nil.niltrace,
	 rewrite_mod   : 'state -> Nil.module -> Nil.module
	 }
      =
      let

	val (HANDLER{bndhandler,
		     exphandler,
		     cbndhandler,
		     conhandler,
		     kindhandler,
		     tracehandler,
		     con_var_bind,
		     con_var_define,
		     exp_var_bind,
		     exp_var_define,
		     sum_var_bind,
		     exn_var_bind}) = handler

	fun ensure (NONE,item) = SOME item
	  | ensure (opt,_)     = opt

	fun map_f f flag state list =
	  let val changed = ref false
	    val temp = map (f changed state) list
	    val _ = flag := (!flag orelse !changed)
	  in if !changed then temp else list
	  end

	fun foldl_acc_f f flag state list =
	  let
	    val changed = ref false
	    val (temp,state) = foldl_acc (f changed) state list
	    val _ = flag := (!flag orelse !changed)
	  in if !changed then (temp,state) else (list,state)
	  end

	fun define_e changed (s,v,e) =
	  (case exp_var_define(s,v,e)
	     of (s,SOME v) => (changed := true;(s,v))
	      | (s,NONE) => (s,v))

	fun bind_e changed (s,v,c) =
	  (case exp_var_bind(s,v,c)
	     of (s,SOME v) => (changed := true;(s,v))
	      | (s,NONE) => (s,v))

	fun define_c changed (s,v,c) =
	  (case con_var_define(s,v,c)
	     of (s,SOME v) => (changed := true;(s,v))
	      | (s,NONE) => (s,v))

	fun bind_c changed (s,v,k) =
	  (case con_var_bind(s,v,k)
	     of (s,SOME v) => (changed := true;(s,v))
	      | (s,NONE) => (s,v))

	(*If this becomes a performance critical piece of code,
	 * it may be useful to bind these locally to encourage inlining
	 *)
	fun recur_e flag state exp =
	  (case rewrite_exp state exp
	     of SOME exp => (flag := true;exp)
	      | NONE => exp)

	and recur_c flag state con =
	  (case rewrite_con state con
	     of SOME con => (flag := true;con)
	      | NONE => con)

	and recur_k flag state kind =
	  (case rewrite_kind state kind
	     of SOME kind => (flag := true;kind)
	      | NONE => kind)
	and recur_trace flag state trace =
	  (case rewrite_trace state trace
	     of SOME trace => (flag := true;trace)
	      | NONE => trace)

	and rewrite_cbnd (state : 'state) (cbnd : conbnd) : (conbnd list option * 'state) =
	  let

	    fun define wrap (var,vklist,c) state =
	      let
		val var' = Name.derived_var var
		val con = Let_c (Sequential,[wrap (var',vklist,c)],Var_c var')
		val (state,varopt) = con_var_define(state,var,con)
	      in
		case varopt
		  of SOME var => (SOME (wrap(var, vklist, c)), state)
		   | NONE => (NONE,state)
	      end

	    fun cbnd_recur wrap (var, vklist, c) oldstate =
	      let

		fun folder changed ((v,k),state) =
		  let
		    val k = recur_k changed state k
		    val (state,v) = bind_c changed (state,v,k)
		  in  ((v,k),state)
		  end
		val changed = ref false
		val (vklist,state) = foldl_acc_f folder changed state vklist
		val c = recur_c changed state c
	      in
		case define wrap (var,vklist,c) oldstate
		  of (SOME bnd,state) => (SOME bnd,state)
		   | (NONE,state) =>
		    if !changed then
		      (SOME (wrap (var,vklist,c)),state)
		    else
		      (NONE,state)
	      end

	    fun do_cbnd recur (cbnd,state) =
	      (case cbnd
		 of Con_cb(var, con) =>
		   let
		     val changed = ref false
		     val con =
		       if recur then
			 recur_c changed state con
		       else con
		     val (state,var) = define_c changed(state,var,con)
		   in if !changed then (SOME (Con_cb(var, con)), state) else (NONE,state)
		   end
		  | Open_cb args =>
		   (if recur then
		      cbnd_recur Open_cb args state
		    else
		      define Open_cb args state)
		  | Code_cb args =>
		      (if recur then
			 cbnd_recur Code_cb args state
		       else
			 define Code_cb args state))

	    fun do_cbnds recur state cbnds =
	      let
		val changed = ref false
		fun doit (cbnd,state) =
		  (case do_cbnd recur (cbnd,state)
		     of (SOME cbnd,state) => (changed := true;(cbnd,state))
		      | (NONE,state) => (cbnd,state))
		val (cbnds,state) = foldl_acc doit state cbnds
	      in (if !changed then SOME cbnds else NONE,state)
	      end
	  in
	    (case (cbndhandler (state,cbnd))
	       of CHANGE_NORECURSE (state,cbnds) => do_cbnds false state cbnds
		| CHANGE_RECURSE (state,cbnds) =>
		 let val (opt,state) = do_cbnds true state cbnds
		 in (ensure (opt,cbnds),state)
		 end
		| NOCHANGE =>
		 (case do_cbnd true (cbnd,state)
		    of (SOME cb,s) => (SOME [cb],s)
		     | (NONE,s) => (NONE,s))
		| NORECURSE => (NONE,state))
	  end

	and rewrite_con (state : 'state) (con : con) : con option =
	  let
	    fun docon (state,con) =
	      let
	      in
		(case con
		   of (Prim_c (pcon,args)) =>
		     let
		       val changed = ref false
		       val args = map_f recur_c changed state args
		     in if !changed then SOME (Prim_c (pcon,args)) else NONE
		     end
		    | (Mu_c (flag,defs)) =>
		     let
		       val changed = ref false
		       fun folder ((v,c),state) =
			 let
			   val (state,v) = bind_c changed (state,v,Type_k)
			 in
			   ((v,c),state)
			 end
		       val (defs,state) =
			 if flag then
			   let val (temp,state) = Sequence.foldl_acc folder state defs
			   in if !changed then (temp,state) else (defs,state)
			   end
			 else (defs,state)
		       val defs = Sequence.map_second (recur_c changed state) defs
		     in  if !changed then SOME (Mu_c (flag,defs)) else NONE
		     end

		    | (AllArrow_c {openness, effect, tFormals,
				   eFormals, fFormals, body_type}) =>
		     let
		       val changed = ref false

		       val (tFormals,state) = tformals_helper changed state tFormals
		       val (eFormals,state) =
			   let
			       fun efolder((vopt,c),s) =
				   let
				       val c = recur_c changed state c
				       val (vopt,s) =
					   (case vopt of
						NONE => (vopt, s)
					      | SOME v => let val (s,v) = bind_e changed (s,v,c)
							  in  (SOME v, s)
							  end)
				   in  ((vopt,c),s)
				   end
			       val (new_eFormals,state) = foldl_acc efolder state eFormals
			       val eFormals = if !changed then new_eFormals else eFormals
			   in  (eFormals, state)
			   end

		       val body_type = recur_c changed state body_type
		     in
		       if !changed
			 then SOME (AllArrow_c{openness = openness, effect = effect,
					       tFormals = tFormals, eFormals = eFormals,
					       fFormals = fFormals, body_type = body_type})
		       else NONE
		     end

		    | ExternArrow_c (cons,con) =>
		     let
		       val changed = ref false
		       val cons = map_f recur_c changed state cons
		       val con = recur_c changed state con
		     in if !changed then SOME (ExternArrow_c (cons,con)) else NONE
		     end
		    | (Var_c var) => NONE

		    (*This may need to be changed to handler parallel lets separately.
		     * It's not clear what the semantics should be.
		     *)
		    | (Let_c (letsort, cbnds, body)) =>
		     let
		       val changed = ref false
		       fun folder(cbnd,state) =
			 let
			   val (cbnds,state) =
			     (case rewrite_cbnd state cbnd
				of (SOME cbnds,state) => (changed := true;(cbnds,state))
				 | (NONE,state) => ([cbnd],state))
			 in  (cbnds, state)
			 end
		       val (cbnds_list,state) = foldl_acc folder state cbnds
		       val cbnds = if !changed then List.concat cbnds_list else cbnds
		       val body = recur_c changed state body
		     in if !changed then SOME (Let_c (letsort, cbnds, body)) else NONE
		     end
		    | (Closure_c (code,env)) =>
		     let
		       val changed = ref false
		       val code = recur_c changed state code
		       val env = recur_c changed state env
		     in if !changed then SOME (Closure_c(code, env)) else NONE
		     end

		    | (Crecord_c entries) =>
		     let
		       val changed = ref false
		       val entries = map_second (recur_c changed state) entries
		     in if !changed then SOME (Crecord_c entries) else NONE
		     end

		    | (Proj_c (con,lbl)) =>
		     (case rewrite_con state con
			of SOME con => SOME (Proj_c (con,lbl))
			 | NONE => NONE)
		    | (App_c (cfun,actuals)) =>
		     let
		       val changed = ref false
		       val cfun = recur_c changed state cfun
		       val actuals = map_f recur_c changed state actuals
		     in if !changed then SOME (App_c (cfun, actuals)) else NONE
		     end
		    | (Coercion_c {vars,from,to}) =>
		     let
		       val changed = ref false
		       fun folder (v,s) =
			 let
			   val (s,v) = bind_c changed (s,v,Type_k)
			 in (v,s)
			 end
		       val (vars,state) = foldl_acc folder state vars
		       val from = recur_c changed state from
		       val to = recur_c changed state to
		     in if !changed then SOME (Coercion_c {vars=vars,from=from,to=to})
			else NONE
		     end)
	      end
	  in
	    case (conhandler (state,con))
	      of CHANGE_NORECURSE (state,c) => SOME c
	       | CHANGE_RECURSE (state,c) => ensure (docon (state,c),c)
	       | NOCHANGE => docon (state,con)
	       | NORECURSE => NONE
	  end


	and rewrite_kind (state : 'state) (kind : kind) : kind option =
	  let
	    fun dokind (state,kind) =
	      (case kind
		 of Type_k => NONE
		  | (SingleType_k con) => mapopt SingleType_k (rewrite_con state con)
		  | (Single_k con) => mapopt Single_k (rewrite_con state con)
		  | (Record_k fieldseq) =>
		   let
		     val changed = ref false
		     fun fold_one (((lbl,var),kind),state) =
		       let
			 val kind  = recur_k changed state kind
			 val (state,var) = bind_c changed (state,var,kind)
		       in
			 (((lbl, var), kind),state)
		       end
		     val (fieldseq,state) = Sequence.foldl_acc fold_one state fieldseq
		   in if !changed then SOME(Record_k fieldseq) else NONE
		   end

		  | (Arrow_k (openness, args, result)) =>
		   let
		     val changed = ref false
		     val (args, state) = tformals_helper changed state args
		     val result = recur_k changed state result
		   in if !changed then SOME(Arrow_k (openness, args, result)) else NONE
		   end)

	  in
	    (case (kindhandler (state,kind)) of
	       CHANGE_NORECURSE (state,k) => SOME k
	     | CHANGE_RECURSE (state,k) => ensure (dokind (state,k),k)
	     | NOCHANGE => dokind (state,kind)
	     | NORECURSE => NONE)
	  end

	and tformals_helper (flag : bool ref) (state : 'state) (vklist : (var * kind) list) : (var * kind) list * 'state =
	  let
	    fun bind changed ((var,knd),state) =
	      let
		val knd =
		  (case rewrite_kind state knd
		     of SOME knd => (changed := true;knd)
		      | NONE => knd)
		val (state,var) = bind_c changed (state, var,knd)
	      in
		((var,knd),state)
	      end

	    val (vklist,state) = foldl_acc_f bind flag state vklist
	  in (vklist,state)
	  end

	and fun_helper (state : 'state) (Function{effect, recursive,
						  tFormals, eFormals, fFormals,
						  body}) : function option =
	  let
	    val changed = ref false
	    val (tFormals,state1) = tformals_helper changed state tFormals
	    local
	      fun vtrfolder changed ((v,trace),s) =
		let
		  val trace = recur_trace changed state trace
		  val (s,v) = bind_e changed (s,v,c')
		in  ((v,trace,c'),s)
		end
	    in
	      val (eFormals, state2) = foldl_acc_f vcfolder changed state1 eFormals
	    end
	    val ftype = Prim_c (Float_c Prim.F64,[])
	    fun folder changed (v,s) = let val (s,v) = bind_e changed (s,v,ftype) in (v,s) end
	    val (fFormals,state2) = foldl_acc_f folder changed state2 fFormals
	    val body = recur_e changed state2 body
	  in
	    if !changed then
	      SOME (Function({effect = effect , recursive = recursive,
			      tFormals = tFormals, eFormals = eFormals, fFormals = fFormals,
			      body = body}))
	    else NONE
	  end

	and rewrite_bnd (state : 'state) (bnd : bnd) : (bnd list option * 'state) =
	  let
	    fun do_fix (recur,maker,vfset) =
	      let
		val changed = ref false
		fun folder ((v,f),s) =
		  let
		    val (s,v) = define_e changed (s,v,Let_e (Sequential,[maker vfset],Var_e v))
		  in
		    ((v,f),s)
		  end
		val (vfset,s) =
		  let val (temp,s) = Sequence.foldl_acc folder state vfset
		  in if !changed then (temp,s) else (vfset,s)
		  end
		fun doer changed (v,f) =
		  (v,case fun_helper s f
		       of SOME f => (changed := true;f)
			| NONE => f)
		val vfset =
		  if recur then
		    let val flag = ref false
		      val temp = (Sequence.map (doer flag) vfset)
		      val _ = changed := (!flag orelse !changed)
		    in if !flag then temp else vfset
		    end
		  else vfset
	      in
		(if !changed then SOME [maker vfset] else NONE,s)
	      end

	    fun do_bnd recur (bnd,state) : bnd list option * 'state =
	      (case bnd
		 of Con_b(p,cb) =>
		   let val (cb_opt,state) =
		     if recur
		       then rewrite_cbnd state cb
		     else (NONE,state)
		   in  (mapopt (fn cbnds => map (fn cb => Con_b(p,cb)) cbnds) cb_opt, state)
		   end
		  | Exp_b(v,trace,e) =>
		   let
		     val changed = ref false
		     val e = if recur then recur_e changed state e else e
		     val trace = recur_trace changed state trace
		     val (state,v) = define_e changed (state,v,e)
		   in
		     (if !changed then SOME [Exp_b(v,trace,e)] else NONE, state)
		   end
		  | Fixopen_b vfset => do_fix (recur,Fixopen_b,vfset)
		  | Fixcode_b vfset => do_fix (recur,Fixcode_b,vfset)
		  | Fixclosure_b (is_recur,vcset) =>
		   let
		     val changed = ref false
		     fun folder ((v,{tipe,cenv,venv,code}),s) =
		       let
			 val bnd = Fixclosure_b(is_recur,vcset)
			 val (s,v) = define_e changed (s,v,Let_e (Sequential,[bnd],Var_e v))
		       in
			 ((v,{tipe=tipe,cenv=cenv,venv=venv,code=code}),s)
		       end

		     val (vcset,s) = Sequence.foldl_acc folder state vcset

		     fun doer flag s (arg as (v,{code,cenv,venv,tipe})) =
		       let
			 val changed = ref false
			 val code = (case (exphandler (state,Var_e code)) of
				       NOCHANGE => code
				     | NORECURSE => code
				     | (CHANGE_RECURSE (state,Var_e v')) => (changed := true;v')
				     | (CHANGE_NORECURSE (state,Var_e v')) => (changed := true;v')
				     | _ => error "can't have non-var in closure code comp")
			   val cenv = recur_c changed s cenv
			   val venv = recur_e changed s venv
			   val tipe = recur_c changed s tipe
			   val _ = flag := (!flag orelse !changed)
		       in
			 if !changed then
			   (v,{code=code,cenv=cenv,venv=venv,tipe=tipe})
			 else arg
		       end
		     val vcset =
		       if recur
			 then let val flag = ref false
				  val temp = if is_recur then Sequence.map (doer flag s) vcset
					     else Sequence.map (doer flag state) vcset
				  val _ = changed := (!changed orelse !flag)
			      in if !flag then temp else vcset
			      end
		       else vcset
		   in  (if !changed then SOME [Fixclosure_b(is_recur,vcset)] else NONE, s)
		   end)

	    fun do_bnds recur (state,bs) =
	      let
		val changed = ref false
		fun do_bnd' (bnd,state) =
		  case do_bnd recur (bnd,state)
		    of (SOME bnds,state) => (changed := true;(bnds,state))
		     | (NONE,state) => ([bnd],state)
		val (bnds,state) = foldl_acc do_bnd' state bs
	      in
		(if !changed then SOME (List.concat bnds) else NONE,state)
	      end
	  in
	    (case (bndhandler (state,bnd))
	       of CHANGE_NORECURSE (state,bs) => do_bnds false (state,bs)
		| CHANGE_RECURSE (state,bs) =>
		 let val (opt,state) = do_bnds true (state,bs)
		 in (ensure (opt,bs),state)
		 end
		| NOCHANGE => do_bnd true (bnd,state)
		| NORECURSE => (NONE,state))
	  end

	and switch_helper (state : 'state) (sw : switch) : exp option =
	  (case sw of
	     Intsw_e {arg, size, arms, default, result_type} =>
	       let
		 val changed = ref false
		 val arg = recur_e changed state arg
		 val result_type = recur_c changed state result_type
		 fun recur changed state (t,e) = (t,recur_e changed state e)
		 val arms = map_f recur changed state arms
		 val default = Util.mapopt (recur_e changed state) default
	       in
		 if !changed then
		   SOME (Switch_e
			 (Intsw_e {arg = arg,
				   size = size,
				   arms = arms,
				   default = default,
				   result_type = result_type}))
		 else NONE
	       end
	   | Sumsw_e {arg, sumtype, bound, arms, default, result_type} =>
	       let
		 val changed = ref false
		 val arg = recur_e changed state arg
		 val sumtype = recur_c changed state sumtype
		 val result_type = recur_c changed state result_type
		 val bnd_ref = ref bound
		 fun recur changed state (t,tr,e) =
		   let
		     val (state',bnd_opt) = sum_var_bind (state,!bnd_ref,(sumtype,t))
		     val _ = (case bnd_opt
				of SOME bnd => (changed := true;bnd_ref := bnd)
				 | NONE     => ())
		   in (t,recur_trace changed state tr,recur_e changed state' e)
		   end
		 val arms = map_f recur changed state arms
		 val default = Util.mapopt (recur_e changed state) default
	       in
		 if !changed then
		   SOME (Switch_e
			 (Sumsw_e {arg = arg,
				   sumtype = sumtype,
				   bound = !bnd_ref,
				   arms = arms,
				   default = default,
				   result_type = result_type}))
		 else NONE
	       end
	   | Exncase_e {arg, bound, arms, default, result_type} =>
	       let
		 val changed = ref false
		 val arg = recur_e changed state arg
		 val result_type = recur_c changed state result_type
		 val bnd_ref = ref bound
		 fun recur changed state (t,tr,e) =
		   let
		     val t = recur_e changed state t
		     val (state',bnd_opt) = exn_var_bind (state,!bnd_ref,t)
		     val _ = (case bnd_opt
				of SOME bnd => (changed := true;bnd_ref := bnd)
				 | NONE     => ())
		   in (t,recur_trace changed state tr,recur_e changed state' e)
		   end
		 val arms = map_f recur changed state arms
		 val default = Util.mapopt (recur_e changed state) default
	       in
		 if !changed then
		   SOME (Switch_e
			 (Exncase_e {arg = arg,
				     bound = bound,
				     arms = arms,
				     default = default,
				     result_type = result_type}))
		 else NONE
	       end
	   | Typecase_e {arg,arms,default, result_type} =>
	       let
		 val changed = ref false
		 fun doarm(pc,vklist,body) =
		   let
		     val (vklist,state) = tformals_helper changed state vklist
		     val body = recur_e changed state body
		   in  (pc, vklist, body)
		   end
		 val arg = recur_c changed state arg
		 val arms = map doarm arms
		 val default = recur_e changed state default
		 val result_type = recur_c changed state result_type
	       in
		 if !changed then
		   SOME (Switch_e
			 (Typecase_e{arg = arg,
				     arms = arms,
				     default = default,
				     result_type = result_type}))
		 else NONE
	       end
	   | Ifthenelse_e {arg,thenArm,elseArm,result_type} =>
	       let
		 val changed = ref false
		 fun do_cc cc =
		   (case cc
		      of Exp_cc exp       => Exp_cc (recur_e changed state exp)
		       | And_cc (cc1,cc2) => And_cc (do_cc cc1,do_cc cc2)
		       | Or_cc (cc1,cc2)  => Or_cc  (do_cc cc1,do_cc cc2)
		       | Not_cc cc        => Not_cc (do_cc cc))

		 val arg     = do_cc arg
		 val thenArm = recur_e changed state thenArm
		 val elseArm = recur_e changed state elseArm
		 val result_type = recur_c changed state result_type
	       in
		 if !changed then
		   SOME (Switch_e
			 (Ifthenelse_e {arg         = arg,
					thenArm     = thenArm,
					elseArm     = elseArm,
					result_type = result_type}))
		 else NONE
	       end
	     )

	and rewrite_exp (state : 'state) (exp : exp) : exp option =
	  let
	    fun doexp (state,e) =
	      let
		val map_e = map_f recur_e
		val map_c = map_f recur_c
	      in
		(case e of
		   (Var_e _) => NONE
		 | (Const_e v) =>
		     (case v of
			(Prim.int _) => NONE
		      | (Prim.uint _) => NONE
		      | (Prim.float _) => NONE
		      | (Prim.array (c,array)) =>
			  let
			    val changed = ref false
			    val _ = Array.modify (recur_e changed state) array
			    val c = recur_c changed state c
			  in
			    if !changed then
			      SOME (Const_e (Prim.array(c,array)))
			    else NONE
			  end
		      | (Prim.vector (c,array)) =>
			  let
			    val changed = ref false
			    val _ = Array.modify (recur_e changed state) array
			    val c = recur_c changed state c
			  in
			    if !changed then
			      SOME (Const_e (Prim.vector(c,array)))
			    else NONE
			  end
		      | Prim.refcell (r as (ref e)) =>
			  (case rewrite_exp state e
			     of SOME e => (r := e; SOME (Const_e v))
			      | NONE => NONE)
		      | Prim.tag (t,c) =>
			 (case rewrite_con state c
			    of SOME c => SOME (Const_e (Prim.tag(t,c)))
			     | NONE => NONE))
		 | (Let_e (sort,bnds,body)) =>
		    let
		      val changed = ref false
		      fun folder (bnd,s) =
			let
			  val (bnds,s) = (case rewrite_bnd s bnd
					    of (SOME bnds,s) => (changed := true; (bnds,s))
					     | (NONE,s) => ([bnd],s))
			in  (bnds,s)
			end
		      val (bndslist,state) = foldl_acc folder state bnds
		      val bnds = if !changed then List.concat bndslist else bnds
		      val body = recur_e changed state body
		    in if !changed then SOME (Let_e(sort,bnds,body)) else NONE
		    end
		 | (Prim_e (ap,trlist, clist,elist)) =>
		    let
		      val changed = ref false
		      val trlist = map_f recur_trace changed state trlist
		      val clist = map_c changed state clist
		      val elist = map_e changed state elist
		    in
		      if !changed then
			SOME (Prim_e(ap,trlist,clist,elist))
		      else NONE
		    end
		 | (Switch_e switch) => switch_helper state switch
		 | (App_e (openness,func,clist,elist,eflist)) =>
		    let
		      val changed = ref false
		      val func = recur_e changed state func
		      val clist = map_c changed state clist
		      val elist = map_e changed state elist
		      val eflist = map_e changed state eflist
		    in
		      if !changed
			then SOME (App_e(openness,func,clist,elist,eflist))
		      else NONE
		    end
		 | ExternApp_e (exp,args) =>
		    let
		      val changed = ref false
		      val exp = recur_e changed state exp
		      val args = map_e changed state args
		    in
		      if !changed then
			SOME (ExternApp_e (exp,args))
		      else NONE
		    end
		 | Raise_e (e,c) =>
		    let
		      val changed = ref false
		      val e = recur_e changed state e
		      val c = recur_c changed state c
		    in if !changed then SOME (Raise_e(e,c)) else NONE
		    end
		 | Handle_e {body,bound,handler,result_type} =>
		    let
		      val changed = ref false
		      val body = recur_e changed state body
		      val result_type = recur_c changed state result_type
		      val (state,bound) =
			  bind_e changed (state,bound,Prim_c(Exn_c,[]))
		      val handler = recur_e changed state handler
		    in if !changed then
			SOME (Handle_e{body = body, bound = bound,
				       handler = handler,
				       result_type = result_type})
		       else NONE
		    end
		 | Coerce_e (coercion,cargs,e) =>
		    let
		      val changed = ref false
		      val coercion = recur_e changed state coercion
		      val cargs = map (recur_c changed state) cargs
		      val e = recur_e changed state e
		    in if !changed then
		         SOME (Coerce_e (coercion,cargs,e))
		       else NONE
		    end
		 | Fold_e stuff => coercion_helper Fold_e stuff
		 | Unfold_e stuff => coercion_helper Unfold_e stuff)
	      end
	    and coercion_helper whichc (vars,from,to) =
	      let
		val changed = ref false
		fun folder (v,s) =
		  let val (s,v) = bind_c changed (s,v,Type_k)
		  in (v,s)
		  end
		val (vars,state) = foldl_acc folder state vars
		val from = recur_c changed state from
		val to = recur_c changed state to
	      in
		if !changed then
		  SOME (whichc (vars,from,to))
		else NONE
	      end

	  in
      	    (case (exphandler (state,exp))
	       of CHANGE_NORECURSE (state,e) => SOME e
		| CHANGE_RECURSE (state,e) => ensure(doexp (state,e),e)
		| NOCHANGE => doexp (state,exp)
		| NORECURSE => NONE)
	  end
	and rewrite_trace (state : 'state) (trace : niltrace) : niltrace option =
	  let

	    fun loop (Var_c v) labs = TraceKnown (TraceInfo.Compute (v,labs))
	      | loop (Proj_c (c,l)) labs = loop c (l::labs)
	      | loop _ _ = error "Non path returned from rewriting trace info"

	    fun do_trace (state,trace) =
	      (case trace of
		 TraceCompute var =>
		   let val changed = ref false
		       val trace = loop (recur_c changed state (Var_c var)) []
		   in
		     if !changed then SOME trace else NONE
		   end
	       | TraceKnown (TraceInfo.Compute (var,labels)) =>
		   let val changed = ref false
		       val trace = loop (recur_c changed state (Var_c var)) labels
		   in
		     if !changed then SOME trace else NONE
		   end
	       | _ => NONE)
	  in
      	    (case (tracehandler (state,trace))
	       of CHANGE_NORECURSE (state,t) => SOME t
		| CHANGE_RECURSE (state,t) => ensure(do_trace (state,t),t)
		| NOCHANGE => do_trace (state,trace)
		| NORECURSE => NONE)
	  end

	fun import_helper flag (import as (ImportValue (label,var,trace,con)),state) =
	  let
	    val changed = ref false
	    val trace = recur_trace changed state trace
	    val con = recur_c changed state con
	    val (state,var) = bind_e changed (state,var,con)
	    val _ = flag := (!changed orelse !flag)
	  in (if !changed then ImportValue (label,var,trace,con) else import,state)
	  end
	  | import_helper flag (import as (ImportType (label,var,kind)),state) =
	  let
	    val changed = ref false
	    val kind = recur_k changed state kind
	    val (state,var) = bind_c changed (state,var,kind)
	    val _ = flag := (!changed orelse !flag)
	  in (if !changed then ImportType (label,var,kind) else import,state)
	  end

	fun export_helper flag state (export as (ExportValue (label,var))) =
	  (case rewrite_exp state (Var_e var)
		 of SOME (Var_e var) => (flag := true;ExportValue (label,var))
		  | NONE => export
		  | _ => error "Export value rewritten to non variable! Don't know what to do!")
	  | export_helper flag state (export as (ExportType (label,var))) =
	   (case rewrite_con state (Var_c var)
	      of SOME (Var_c var) => (flag := true;ExportType (label,var))
	       | NONE => export
	       | _ => error "Export type rewritten to non variable! Don't know what to do!")

      fun rewrite_mod (state : 'state) (module : module) : module =
	let
	  val changed = ref false
	  val (MODULE {bnds,imports,exports}) = module
	  val (imports,state) = foldl_acc_f import_helper changed state imports
	  local
	    val flag = ref false
	    fun folder (bnd,s) =
	      (case rewrite_bnd s bnd
		 of (SOME bndslist,state) => (flag := true;(bndslist,state))
		  | (NONE,state) => ([bnd],state))
	    val (bndslist,state) = foldl_acc folder state bnds
	    val _ = changed := (!flag orelse !changed)
	  in
	    val state = state
	    val bnds = if !flag then List.concat bndslist else bnds
	  end
	  val exports = map_f export_helper changed state exports
	in if !changed then MODULE {bnds=bnds,imports=imports,exports=exports} else module
	end

      fun rewrite_item rewriter state item =
	(case rewriter state item
	   of SOME item => item
	    | NONE => item)

      val rewrite_exp = rewrite_item rewrite_exp
      val rewrite_con = rewrite_item rewrite_con
      val rewrite_kind = rewrite_item rewrite_kind
      val rewrite_trace = rewrite_item rewrite_trace

      val rewrite_bnd =
	(fn state => fn bnd =>
	 (case rewrite_bnd state bnd
	    of (SOME bnds,state) => (bnds,state)
	     | (NONE,state) => ([bnd],state)))

      val rewrite_cbnd =
	(fn state => fn cbnd =>
	 (case rewrite_cbnd state cbnd
	    of (SOME cbnds,state) => (cbnds,state)
	     | (NONE,state) => ([cbnd],state)))

      in
	{
	 rewrite_kind  = rewrite_kind,
	 rewrite_con   = rewrite_con,
	 rewrite_exp   = rewrite_exp,
	 rewrite_bnd   = rewrite_bnd,
	 rewrite_cbnd  = rewrite_cbnd,
	 rewrite_trace = rewrite_trace,
	 rewrite_mod   = rewrite_mod
	 }
      end


      fun null_binder (state,_,_) = (state,NONE)

      fun null_handler _ = NOCHANGE

      val default_handler =
	HANDLER {
		 bndhandler     = null_handler,
		 cbndhandler    = null_handler,
		 conhandler     = null_handler,
		 exphandler     = null_handler,
		 kindhandler    = null_handler,
		 tracehandler   = null_handler,
		 con_var_bind   = null_binder,
		 exp_var_bind   = null_binder,
		 con_var_define = null_binder,
		 exp_var_define = null_binder,
		 sum_var_bind   = null_binder,
		 exn_var_bind   = null_binder
		 }

      fun set_kindhandler (HANDLER {bndhandler,cbndhandler,
				    conhandler,exphandler,kindhandler,tracehandler,
				    con_var_bind,exp_var_bind,
				    con_var_define,exp_var_define,
				    sum_var_bind,exn_var_bind}) new_kindhandler =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = conhandler,
		 exphandler     = exphandler,
		 kindhandler    = new_kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = con_var_bind,
		 exp_var_bind   = exp_var_bind,
		 con_var_define = con_var_define,
		 exp_var_define = exp_var_define,
		 sum_var_bind   = sum_var_bind,
		 exn_var_bind   = exn_var_bind
		 }

      fun set_conhandler (HANDLER {bndhandler,cbndhandler,
				   conhandler,exphandler,kindhandler,tracehandler,
				   con_var_bind,exp_var_bind,
				   con_var_define,exp_var_define,
				   sum_var_bind,exn_var_bind}) new_conhandler =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = new_conhandler,
		 exphandler     = exphandler,
		 kindhandler    = kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = con_var_bind,
		 exp_var_bind   = exp_var_bind,
		 con_var_define = con_var_define,
		 exp_var_define = exp_var_define,
		 sum_var_bind   = sum_var_bind,
		 exn_var_bind   = exn_var_bind
		 }

      fun set_exphandler (HANDLER {bndhandler,cbndhandler,
				   conhandler,exphandler,kindhandler,tracehandler,
				   con_var_bind,exp_var_bind,
				   con_var_define,exp_var_define,
				   sum_var_bind,exn_var_bind}) new_exphandler =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = conhandler,
		 exphandler     = new_exphandler,
		 kindhandler    = kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = con_var_bind,
		 exp_var_bind   = exp_var_bind,
		 con_var_define = con_var_define,
		 exp_var_define = exp_var_define,
		 sum_var_bind   = sum_var_bind,
		 exn_var_bind   = exn_var_bind
		 }

      fun set_exp_binder (HANDLER {bndhandler,cbndhandler,
				   conhandler,exphandler,kindhandler,tracehandler,
				   con_var_bind,exp_var_bind,
				   con_var_define,exp_var_define,
				   sum_var_bind,exn_var_bind}) new_exp_var_bind =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = conhandler,
		 exphandler     = exphandler,
		 kindhandler    = kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = con_var_bind,
		 exp_var_bind   = new_exp_var_bind,
		 con_var_define = con_var_define,
		 exp_var_define = exp_var_define,
		 sum_var_bind   = sum_var_bind,
		 exn_var_bind   = exn_var_bind
		 }

      fun set_exp_definer (HANDLER {bndhandler,cbndhandler,
				   conhandler,exphandler,kindhandler,tracehandler,
				   con_var_bind,exp_var_bind,
				   con_var_define,exp_var_define,
				   sum_var_bind,exn_var_bind}) new_exp_var_define =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = conhandler,
		 exphandler     = exphandler,
		 kindhandler    = kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = con_var_bind,
		 exp_var_bind   = exp_var_bind,
		 con_var_define = con_var_define,
		 exp_var_define = new_exp_var_define,
		 sum_var_bind   = sum_var_bind,
		 exn_var_bind   = exn_var_bind
		 }

      fun set_con_binder (HANDLER {bndhandler,cbndhandler,
				   conhandler,exphandler,kindhandler,tracehandler,
				   con_var_bind,exp_var_bind,
				   con_var_define,exp_var_define,
				   sum_var_bind,exn_var_bind}) new_con_var_bind =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = conhandler,
		 exphandler     = exphandler,
		 kindhandler    = kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = new_con_var_bind,
		 exp_var_bind   = exp_var_bind,
		 con_var_define = con_var_define,
		 exp_var_define = exp_var_define,
		 sum_var_bind   = sum_var_bind,
		 exn_var_bind   = exn_var_bind
		 }

      fun set_con_definer (HANDLER {bndhandler,cbndhandler,
				    conhandler,exphandler,kindhandler,tracehandler,
				    con_var_bind,exp_var_bind,
				    con_var_define,exp_var_define,
				    sum_var_bind,exn_var_bind}) new_con_var_define =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = conhandler,
		 exphandler     = exphandler,
		 kindhandler    = kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = con_var_bind,
		 exp_var_bind   = exp_var_bind,
		 con_var_define = new_con_var_define,
		 exp_var_define = exp_var_define,
		 sum_var_bind   = sum_var_bind,
		 exn_var_bind   = exn_var_bind
		 }

      fun set_sum_binder (HANDLER {bndhandler,cbndhandler,
				   conhandler,exphandler,kindhandler,tracehandler,
				   con_var_bind,exp_var_bind,
				   con_var_define,exp_var_define,
				   sum_var_bind,exn_var_bind}) new_sum_var_bind =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = conhandler,
		 exphandler     = exphandler,
		 kindhandler    = kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = con_var_bind,
		 exp_var_bind   = exp_var_bind,
		 con_var_define = con_var_define,
		 exp_var_define = exp_var_define,
		 sum_var_bind   = new_sum_var_bind,
		 exn_var_bind   = exn_var_bind
		 }

      fun set_exn_binder (HANDLER {bndhandler,cbndhandler,
				   conhandler,exphandler,kindhandler,tracehandler,
				   con_var_bind,exp_var_bind,
				   con_var_define,exp_var_define,
				   sum_var_bind,exn_var_bind}) new_exn_var_bind =
	HANDLER {
		 bndhandler     = bndhandler,
		 cbndhandler    = cbndhandler,
		 conhandler     = conhandler,
		 exphandler     = exphandler,
		 kindhandler    = kindhandler,
		 tracehandler   = tracehandler,
		 con_var_bind   = con_var_bind,
		 exp_var_bind   = exp_var_bind,
		 con_var_define = con_var_define,
		 exp_var_define = exp_var_define,
		 sum_var_bind   = sum_var_bind,
		 exn_var_bind   = new_exn_var_bind
		 }

  end
