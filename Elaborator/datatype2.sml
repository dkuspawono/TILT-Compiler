(* Datatype compiler and destructures of datatype signatures. *)

structure Datatype
    :> DATATYPE =
  struct

    structure IlContext = IlContext
    open Il IlStatic IlUtil Ppil
    open Util Listops Name Tyvar
    open IlContext

    val do_inline = Stats.tt("DatatypeInline")
    val debug = Stats.ff("DatatypeDebug")
    val no_eq = Stats.ff("DatatypeNoEq")

    val error = fn s => error "datatype.sml" s
    val error_sig = fn signat => fn s => error_sig "datatype.sml" signat s
    fun debugdo t = if (!debug) then (t(); ()) else ()

    val reject = fn s => (Error.error_region(); reject s)

    fun geq_string (s1,s2) =
	(case (String.compare(s1,s2)) of
	     GREATER => true
	   | EQUAL => true
	   | LESS => false)
    fun geq_sym(sym1,sym2) =
	geq_string(Symbol.symbolToString sym1, Symbol.symbolToString sym2)


    fun con_fun(args,body) =
	let val args' = map Name.derived_var args
	    fun folder ((v,v'),s) = subst_add_convar(s,v,CON_VAR v')
	    val subst = foldl folder empty_subst (zip args args')
	in  CON_FUN(args', con_subst(body,subst))
	end

    (* ------------------------------------------------------------------
       The datatype compiler for compiling a single strongly-connected type.
       ------------------------------------------------------------------ *)
    type def = Symbol.symbol * Ast.tyvar list * (Symbol.symbol * Ast.ty option) list
    fun driver (xty : Il.context * Ast.ty -> Il.con,
		context : context,
		std_list : def list,
		eqcomp : Il.context * (Il.con * Il.exp * Il.exp * (Il.con -> Il.con)) option * Il.con -> (Il.exp * Il.con) option,
		is_transparent : bool)
	: (sbnd * sdec) list =
      let
        (* ---- tyvar_vars are the polymorphic type arguments for constructor functions
	   ---- tyvar_labs name the type components when they are structure components
	 *)
	val tyvars = (case std_list
		        of nil => nil
		         | ((_, tyvars, _) :: _) => tyvars)
	val tyvar_syms = map AstHelp.tyvar_strip tyvars
	val tyvars = map Ast.Tyv tyvar_syms	(* no marks *)
	fun rename (tyc, tyv, constrs) =
	    let val vars = map AstHelp.tyvar_strip tyv
	        val subst = Listops.zip vars tyvars
		val constrs' = (map (fn (s,SOME ty) => (s,SOME(AstHelp.subst_vars_ty (subst, ty)))
				      | x => x) constrs)
	    in  (tyc, constrs')
	    end
	val std_list = map rename std_list
	val num_tyvar = length tyvars
	val tyvar_labs = map symbol_label tyvar_syms
	val tyvar_vars = map gen_var_from_symbol tyvar_syms
	(* gratuitous change from val tyvar_vars = map (fn lab => fresh_named_var "poly") tyvar_labs *)
	val tyvar_cons = map CON_VAR tyvar_vars
	val mpoly_var = fresh_named_var "mpoly_var"
	val is_monomorphic = num_tyvar = 0
	val num_datatype = length std_list
	val _ = if is_transparent andalso num_datatype > 1
		    then error "transparent datatype compilation invoked for recursive type"
		else ()
	val is_boolean = (case std_list
			    of [(b, [(f,NONE), (t,NONE)])] =>
				let fun eq (s, l) = Name.eq_label (Name.symbol_label s, l)
				in  eq (b, lab_bool) andalso
				    eq (t, lab_true) andalso
				    eq (f, lab_false)
				end
			     | _ => false)

	(* ----- create names for overall recursive type, datatype types,
	         argument to sum types, sum types, special sums, and modules *)
	val type_syms = map #1 std_list
	val type_labs = map symbol_label type_syms
	val type_vars = map (fn s => fresh_named_var (Symbol.name s)) type_syms
	val eq_labs = map (fn s => symbol_label(Symbol.varSymbol(Symbol.name s ^ "_eq"))) type_syms
	val eq_vars = map (fn s => fresh_named_var (Symbol.name s ^ "_eq")) type_syms
	val inner_type_labvars = map (fn s =>
				      let val str = Symbol.name s
				      in  (internal_label str,
					   fresh_named_var ("copy_" ^ str))
				      end) type_syms
	val top_type_string = foldl (fn (s,acc) => acc ^ "_" ^ (Symbol.name s)) "" type_syms
	val top_eq_string = top_type_string ^ "_eq"
	val private_var = fresh_named_var "private"
	val top_type_var = fresh_named_var top_type_string
	(* Could datatypes_var be defined to be the same as top_type_var,
           or is there an invariant about fresh variable names?? *)
	val datatypes_var = fresh_named_var top_type_string
	val top_type_lab = internal_label top_type_string
	val datatypes_lab = to_open top_type_lab
	val top_eq_var = fresh_named_var top_eq_string
	val top_eq_lab = Name.internal_label top_eq_string (* symbol_label (Symbol.tycSymbol top_eq_string) *)
	val module_labvars = map (fn s => let val str = Symbol.name s
					  in  (Name.to_dt (symbol_label s),
					       fresh_named_var str)
					  end) type_syms
(*
	val constr_sumarg_strings = map (fn s => (Symbol.name s) ^ "_sumarg") type_syms
	val constr_sumarg_vars = map fresh_named_var constr_sumarg_strings
	val constr_sumarg_labs = map internal_label constr_sumarg_strings
*)
	val constr_sum_strings = map (fn s => (Symbol.name s) ^ "_sum") type_syms
	val constr_sum_vars = map fresh_named_var constr_sum_strings
	val constr_sum_labs = map (to_sum o internal_label) constr_sum_strings
	val constr_tys : Ast.ty option list list = map (fn (_,def) => map #2 def) std_list
        val constr_syms = map (fn (_,def) => map #1 def) std_list
	val constr_labs = mapmap symbol_label constr_syms
	val constr_con_strings = map3 (fn (ty_sym,con_syms,con_tys) =>
				       map2 (fn (s,NONE) => NONE
					      | (s,SOME _) => SOME((Symbol.name ty_sym) ^ "_" ^
							           (Symbol.name s)))
				       (con_syms, con_tys))
	                         (type_syms,constr_syms,constr_tys)
	val constr_con_vars = mapmap (Util.mapopt fresh_named_var) constr_con_strings
	val constr_con_labs = mapmap (Util.mapopt internal_label) constr_con_strings

	val in_coercion_strings = map (fn s => (Symbol.name s) ^ "_in") type_syms
	val in_coercion_vars = map fresh_named_var in_coercion_strings
	val in_coercion_labs = map (to_coercion o internal_label) in_coercion_strings
	val out_coercion_strings = map (fn s => (Symbol.name s) ^ "_out") type_syms
	val out_coercion_vars = map fresh_named_var out_coercion_strings
	val out_coercion_labs = map (to_coercion o internal_label) out_coercion_strings


        (* -- we name the variables representing the instantited fixpoints in CON_MU *)
	val vardt_list = map (fn s => (fresh_named_var ("vdt" ^ "_" ^ (Symbol.name s)))) type_syms


	(* ---- compute sig_poly, sig_poly+, and a context context' -----------
	   ---- that has the polymorphic type variables and datatypes bound --- *)
	local
	    fun folder ((tv,v), (sdecs, sdecs_eq, ctxt)) =
		let val eq_label = to_eq tv
		    val eq_con = con_eqfun context (CON_VAR v)
		    val sdec = SDEC(tv,DEC_CON(v,KIND,NONE,false))
		    val sdec_eq = SDEC(eq_label,DEC_EXP(fresh_var(),eq_con,NONE,false))
		    val ctxt = add_context_con(ctxt,tv,v,KIND,NONE)
		in  (sdec :: sdecs, sdec :: sdec_eq :: sdecs_eq, ctxt)
		end
	    val (sdecs, sdecs_eq, ctxt) = foldr folder ([],[],context) (Listops.zip tyvar_labs tyvar_vars)
	    val k = if (num_tyvar = 0) then KIND else KIND_ARROW(num_tyvar,KIND)
	    fun folder ((tc,vty),ctxt) = add_context_con(ctxt,tc,vty,k,NONE)
	in
	    val sdecs_eq = sdecs_eq
	    val sigpoly = SIGNAT_STRUCTURE sdecs
	    val sigpoly_eq = SIGNAT_STRUCTURE sdecs_eq
	    val context' = foldl folder ctxt (Listops.zip type_labs type_vars)
	end

	(* ------ compute 3 versions of all the types carried by the constructors
	 *)
	local
	    fun tyvar_type_mapper ty = xty(context',ty)

	    fun folder ((v,c),s) = subst_add_convar(s,v,c)
	    fun vclist2subst vclist = foldl folder empty_subst vclist

	    val list_tyvar2vdt = zip type_vars (map CON_VAR vardt_list)
	    val subst_tyvar2vdt = vclist2subst list_tyvar2vdt
	    val subst_tyvar2mproj = vclist2subst (map2 (fn (l,v) => (v, CON_MODULE_PROJECT(MOD_VAR mpoly_var,l)))
						  (tyvar_labs, tyvar_vars))

	    fun conapper(CON_VAR tarv,cargs) : con option = assoc_eq(eq_var,tarv,list_tyvar2vdt)
	      | conapper _ = NONE

	in
	    fun vdt_mapper c =
		if is_monomorphic
		    then con_subst(c,subst_tyvar2vdt)
		else con_subst_conapps(c,conapper)

	    fun mproj_type_mapper c = con_subst(c,subst_tyvar2mproj)
	    val constr_tyvar_type = mapmap (Util.mapopt tyvar_type_mapper) constr_tys
	    val constr_mproj_type = mapmap (Util.mapopt mproj_type_mapper) constr_tyvar_type
	    val constr_vdt  = mapmap (Util.mapopt vdt_mapper)  constr_tyvar_type
	end

        (* ------------ now create the sum arg and sum types which use type and tyvar *)

	local
	    fun conopts_split (nca,ca) ([] : 'a option list) = (nca,rev ca)
	      | conopts_split (nca,ca) (NONE::rest) = conopts_split (nca+1,ca) rest
	      | conopts_split (nca,ca) ((SOME c)::rest) = conopts_split (nca,c::ca) rest
	    val conopts_split = fn arg => conopts_split (0,[]) arg
	    fun mapper (conopts,conopts_vdt,names) =
		let val (nca,ca) = conopts_split conopts
		    val (_,ca_vdt) = conopts_split conopts_vdt
		    val sumarg =
			(case ca of
			     [ca1] => ca1
			   | _ => CON_TUPLE_INJECT ca)
		    val sumarg_vdt = (case ca_vdt of
					  [ca_vdt1] => ca_vdt1
					| _ => CON_TUPLE_INJECT ca_vdt)
		in (CON_SUM{names=names,
			    noncarriers=nca,
			    carrier=sumarg_vdt,
			    special=NONE},
		    CON_SUM{names=names,
			    noncarriers=nca,
			    carrier=sumarg,
			    special=NONE})
		end
	in
	    val conopts_split = conopts_split
	    val (constr_fullsum_vdt,constr_sum) =
		unzip (map3 mapper (constr_tyvar_type,constr_vdt,constr_labs))
	end

(*
	local
	    fun conopts_split (nca,ca) ([] : 'a option list) = (nca,rev ca)
	      | conopts_split (nca,ca) (NONE::rest) = conopts_split (nca+1,ca) rest
	      | conopts_split (nca,ca) ((SOME c)::rest) = conopts_split (nca,c::ca) rest
	    val conopts_split = fn arg => conopts_split (0,[]) arg
	    fun mapper (conopts,conopts_vdt,constr_sumarg_var,names) =
		let val (nca,ca) = conopts_split conopts
		    val (_,ca_vdt) = conopts_split conopts_vdt
		    val (sumarg, sumarg_kind) =
			(case ca of
			     [ca1] => (ca1, KIND)
			   | _ => (CON_TUPLE_INJECT ca, KIND_TUPLE (length ca)))
		    val sumarg_vdt = (case ca_vdt of
					  [ca_vdt1] => ca_vdt1
					| _ => CON_TUPLE_INJECT ca_vdt)
		    val carrier = if is_monomorphic
				      then CON_VAR constr_sumarg_var
				  else CON_APP(CON_VAR constr_sumarg_var, tyvar_cons)
		in (sumarg, sumarg_kind,
		    CON_SUM{names=names,
			    noncarriers=nca,
			    carrier=sumarg_vdt,
			    special=NONE},
		    CON_SUM{names=names,
			    noncarriers=nca,
			    carrier=carrier,
			    special=NONE})
		end
	in
	    val conopts_split = conopts_split
	    val (constr_sumarg,constr_sumarg_kind,constr_fullsum_vdt,constr_sum) =
		unzip4 (map4 mapper (constr_tyvar_type,constr_vdt,
				     constr_sumarg_vars,constr_labs))
	end
*)
        (* ---------- now create the top datatype tuple using var_poly ------ *)
	val top_type_tyvar =
	    CON_MU(CON_FUN(vardt_list,con_tuple_inject constr_fullsum_vdt))

        (* ------------ create the polymorphic type arguments ---------------------
	   ------------- and instanitated versions of datatypes and sum types ------------------- *)
	val tyvar_mprojs = map (fn l => CON_MODULE_PROJECT (MOD_VAR mpoly_var, l)) tyvar_labs
	val type_cinsts = map (fn tv => if (is_monomorphic)
					    then (CON_VAR tv)
					else CON_APP(CON_VAR tv, tyvar_cons)) type_vars
	val type_minsts = map (fn tv => if (is_monomorphic)
					    then (CON_VAR tv)
					else CON_APP(CON_VAR tv, tyvar_mprojs)) type_vars
        val sumtype_cinsts = map (fn tv => if (is_monomorphic)
					    then (CON_VAR tv)
					else CON_APP(CON_VAR tv, tyvar_cons)) constr_sum_vars
	val sumtype_minsts = map (fn tv => if (is_monomorphic)
					    then (CON_VAR tv)
					else CON_APP(CON_VAR tv, tyvar_mprojs)) constr_sum_vars


	(* ----------------- compute the in_coercions ------------- *)
	local
	    fun in_help (mutype, sumtype) =
		make_fold_coercion(tyvar_vars,sumtype,mutype)
	in val exp_con_in = map2 in_help (type_cinsts, sumtype_cinsts)
	end

	(* ----------------- compute the out_coercions ------------- *)
	local
	    fun out_help (mutype, sumtype) =
		make_unfold_coercion(tyvar_vars,mutype,sumtype)
	in val exp_con_out = map2 out_help (type_cinsts, sumtype_cinsts)
	end

	(* ----------------- compute the constructors ------------- *)
	local
	    fun mk_help (in_coercion, mutype, sumtype,
			 constr_mproj_type_i : con option list) =
		let
		    fun help (j, constr_mproj_type_ij_opt) =
			let val var = fresh_named_var "injectee"
			in  case constr_mproj_type_ij_opt of
			    NONE => (COERCE(VAR in_coercion,
					    tyvar_mprojs,
					    INJ{sumtype = sumtype,
						field = j,
						inject = NONE}),
				     mutype)
			  | SOME constr_mproj_type_ij =>
				(make_total_lambda
				 (var, constr_mproj_type_ij, mutype,
				  COERCE(VAR in_coercion,
					 tyvar_mprojs,
					 INJ{sumtype = sumtype,
					     field = j,
					     inject = SOME (VAR var)})))
			end
		in mapcount help constr_mproj_type_i
		end
	in val exp_con_mk = map4 mk_help (in_coercion_vars, type_minsts, sumtype_minsts, constr_mproj_type)
	end


	(* ----------------- compute the exposes ------------------- *)
	local
	    fun expose_help (out_coercion, mutype, sumtype) =
		let val expose_var = fresh_named_var "exposee"
		in  make_total_lambda(expose_var,mutype,sumtype,
				      COERCE(VAR out_coercion,
					     tyvar_mprojs,
					     VAR expose_var))
		end
	in val exp_con_expose = map3 expose_help (out_coercion_vars, type_minsts, sumtype_minsts)
	end

	(* ----------------- compute the type bindings ------------------- *)
	val top_type_sbnd_sdec =
		let val (c,base_kind) =
		    if is_monomorphic
			then (top_type_tyvar, KIND_TUPLE num_datatype)
		    else (con_fun(tyvar_vars, top_type_tyvar),
			  KIND_ARROW(num_tyvar, KIND_TUPLE num_datatype))
		in  [(SBND(top_type_lab, BND_CON(top_type_var, c)),
		      SDEC(top_type_lab, DEC_CON(top_type_var, base_kind, SOME c, false)))]
		end

	val type_sbnd_sdecs =
		let val kind = KIND
		    val kind = if is_monomorphic
				   then kind
			       else KIND_ARROW(num_tyvar,kind)
		    fun mapper(i,l,v) =
			let val c = if is_transparent then top_type_tyvar
				    else CON_MODULE_PROJECT(MOD_VAR private_var, top_type_lab)
			    val c = if is_monomorphic then c
				    else CON_APP(c, tyvar_cons)
			    val c = CON_TUPLE_PROJECT(i,c)
			    val c = if is_monomorphic then c
				      else con_fun(tyvar_vars, c)
			in  (SBND(l,BND_CON(v,c)),
			     if is_transparent then SDEC(l,DEC_CON(v,kind,SOME c,true))
			     else SDEC(l,DEC_CON(v,kind,NONE,false)))
			end
		in  map2count mapper (type_labs,type_vars)
		end

	(* ----------------- compute the equality function and reduced sdecs_eq and sigpoly_eq  ------------------- *)
	local
	    val var_poly_dec = DEC_MOD(mpoly_var,false,sigpoly_eq)
	    val ctxt = add_context_dec(context, var_poly_dec)
	    val ctxt = add_context_entries(ctxt, map (CONTEXT_SDEC o #2)
						(top_type_sbnd_sdec @ type_sbnd_sdecs))
	    val eq_con = if is_monomorphic
			     then CON_VAR top_type_var
			 else CON_APP(CON_VAR top_type_var, tyvar_mprojs)
				       (*  top_type_tyvar *)
	in
	    val bool =
		if is_boolean then
		    let
			val con_bool = CON_TUPLE_PROJECT (0, CON_VAR top_type_var)
			val sumtype = hd constr_fullsum_vdt
			val fold = FOLD ([], sumtype, con_bool)
			fun field i = COERCE(fold,[],INJ{sumtype=sumtype,field=i,inject=NONE})
			val false_exp = field 0
			val true_exp = field 1

			fun con_eqfun (c : con) : con =
			    CON_ARROW([con_tuple[c,c]], con_bool,
				      false, oneshot_init PARTIAL)
		    in
			SOME (con_bool, true_exp, false_exp, con_eqfun)
		    end
		else NONE
	    val eq_exp_con = if !no_eq then NONE else eqcomp(ctxt, bool, eq_con)
	    val (sdecs_eq, sigpoly_eq) =
		if is_monomorphic orelse not (isSome eq_exp_con)
		    then (sdecs_eq, sigpoly_eq)
		else
		    let val (eq_exp,_) = valOf eq_exp_con
			val vpath = (mpoly_var, [])
			val sdecs_eq' = reduce_typearg_sdecs (eq_exp, vpath, sdecs_eq)
			val sigpoly_eq' = SIGNAT_STRUCTURE sdecs_eq'
		    in  (sdecs_eq', sigpoly_eq')
		    end
	end


	(* --------- create the inner modules ------------- *)
	fun help ((inner_type_lab_i, inner_type_var_i),type_var_i,
		  (module_lab, module_var),
		  (exp_expose_i,con_expose_i),
		  constr_labs_row,
		  expcon_mk_i) =
	  let
	    (* ----- do the type -------- *)
	    val k = KIND
	    val k = if is_monomorphic then k else KIND_ARROW(num_tyvar,k)
	    val type_sbnd = SBND(inner_type_lab_i, BND_CON(inner_type_var_i,CON_VAR type_var_i))
	    val type_sdec = SDEC(inner_type_lab_i, DEC_CON(inner_type_var_i,k,SOME(CON_VAR type_var_i),true))

	    (* ----- do the expose -------- *)
	    val expose_var = fresh_named_var "exposer"
	    val expose_modvar = fresh_named_var "exposer_mod"
	    val expose_expbnd = BND_EXP(expose_var,exp_expose_i)
	    val expose_expdec = DEC_EXP(expose_var,con_expose_i,SOME exp_expose_i, true)
	    val expose_inner_sig = SIGNAT_STRUCTURE [SDEC(it_lab,expose_expdec)]
	    val expose_modbnd = BND_MOD(expose_modvar, true,
					MOD_FUNCTOR(TOTAL, mpoly_var,sigpoly,
						    MOD_STRUCTURE[SBND(it_lab,expose_expbnd)],
						    expose_inner_sig))
	    val expose_moddec = DEC_MOD(expose_modvar, true,
					SIGNAT_FUNCTOR(mpoly_var,sigpoly,
						       expose_inner_sig,TOTAL))
	    val expose_sbnd = SBND(expose_lab,if is_monomorphic
						  then expose_expbnd else expose_modbnd)
	    val expose_sdec = SDEC(expose_lab,if is_monomorphic
						  then expose_expdec else expose_moddec)


	    (* ----- do the mk  ---- *)
	    fun inner_help (constr_lab_ij,(exp_mk_ij,con_mk_ij)) =
	      let
		  val mk_var = fresh_var()
		  val mkpoly_var = fresh_var()
		  val bnd = BND_EXP(mk_var, exp_mk_ij)
		  val dec = DEC_EXP(mk_var, con_mk_ij, SOME exp_mk_ij, true)
		  val inner_sig = SIGNAT_STRUCTURE [SDEC(it_lab,dec)]
		  val modbnd = BND_MOD(mkpoly_var, true,
					   MOD_FUNCTOR(TOTAL, mpoly_var,sigpoly,
						       MOD_STRUCTURE[SBND(it_lab,bnd)],
						       inner_sig))
		  val moddec = DEC_MOD(mkpoly_var, true,
				       SIGNAT_FUNCTOR(mpoly_var,sigpoly,
						      inner_sig,TOTAL))
	      in  (SBND(constr_lab_ij, if is_monomorphic then bnd else modbnd),
		   SDEC(constr_lab_ij, if is_monomorphic then dec else moddec))
	      end
	    val temp = map2 inner_help (constr_labs_row, expcon_mk_i)
	    val (sbnds,sdecs) = (map #1 temp, map #2 temp)

	    val sbnds = type_sbnd::expose_sbnd::sbnds
	    val sdecs = type_sdec::expose_sdec::sdecs

	    val inner_mod = MOD_STRUCTURE sbnds
	    val inner_sig = SIGNAT_STRUCTURE sdecs

	  in (SBND(module_lab,BND_MOD(module_var,false,inner_mod)),
	      SDEC(module_lab,DEC_MOD(module_var,false,inner_sig)))
	  end

	val components = map6 help (inner_type_labvars,
				    type_vars,
				    module_labvars,
				    exp_con_expose,
				    constr_labs,
				    exp_con_mk)


	local
	    fun help (top_eq_exp,top_eq_con) (i,type_lab_i,type_var_i) =
		let
		    val eq_lab = to_eq type_lab_i
		    val equal_var = fresh_named_var (label2string eq_lab)
		    val bnd_var = fresh_named_var ("poly" ^ (label2string eq_lab))
		    val short_top_eq_exp =
			if (is_monomorphic)
			    then MODULE_PROJECT(MOD_VAR private_var, top_eq_lab)
			else MODULE_PROJECT(MOD_APP(MOD_PROJECT(MOD_VAR private_var, top_eq_lab),
						    MOD_VAR mpoly_var), it_lab)
		    val exp_eq = if num_datatype = 1 then short_top_eq_exp
				 else RECORD_PROJECT(short_top_eq_exp, generate_tuple_label(i+1), top_eq_con)
		    val con_eq =
			if is_boolean then
			    CON_ARROW([con_tuple[CON_VAR type_var_i, CON_VAR type_var_i]],
				       CON_VAR type_var_i, false, oneshot_init PARTIAL)
			else
			    con_eqfun context (if is_monomorphic
						   then CON_VAR type_var_i
					       else CON_APP (CON_VAR type_var_i, tyvar_mprojs))
		    val eq_expbnd = BND_EXP(equal_var,exp_eq)
		    val eq_expdec = DEC_EXP(equal_var,con_eq,NONE,false)
		    val eq_inner_sig = SIGNAT_STRUCTURE [SDEC(it_lab,eq_expdec)]
		    val eq_sbnd =
			SBND((eq_lab,
			      if (is_monomorphic)
				  then eq_expbnd
			      else
				  BND_MOD(bnd_var, true,
					  MOD_FUNCTOR(TOTAL, mpoly_var, sigpoly_eq,
						      MOD_STRUCTURE[SBND(it_lab,eq_expbnd)],
						      eq_inner_sig))))
		    val eq_sdec =
			SDEC(eq_lab,
			     if (is_monomorphic)
				 then eq_expdec
			     else DEC_MOD(bnd_var, true,
					  SIGNAT_FUNCTOR(mpoly_var,sigpoly_eq,
							 eq_inner_sig,TOTAL)))
		in (eq_sbnd, eq_sdec)
		end
	in val eq_sbnd_sdecs = (case eq_exp_con of
				    NONE => []
				  | SOME ec => map2count (help ec) (type_labs,type_vars))
	end

	val top_eq_sbnd_sdec =
	    (case (eq_exp_con, num_datatype) of
		(NONE,_) => []
	      | (SOME (eq_exp, eq_con),_) =>
		let val equal_var = if is_monomorphic then top_eq_var
				    else fresh_named_var "top_eq"
		    val expbnd = BND_EXP(equal_var, eq_exp)
		    val expdec = DEC_EXP(equal_var, eq_con, NONE,false)
		    val inner_sig = SIGNAT_STRUCTURE [SDEC(it_lab,expdec)]
		    val modbnd = BND_MOD(top_eq_var, true, MOD_FUNCTOR(TOTAL, mpoly_var,sigpoly_eq,
							 MOD_STRUCTURE[SBND(it_lab,expbnd)],
							 inner_sig))
		    val moddec = DEC_MOD(top_eq_var, true, SIGNAT_FUNCTOR(mpoly_var,sigpoly_eq,
								    inner_sig, TOTAL))
		    val bnd = if is_monomorphic then expbnd else modbnd
		    val dec = if is_monomorphic then expdec else moddec
		in  [(SBND(top_eq_lab, bnd), SDEC(top_eq_lab, dec))]
		end)

(*
	fun mapper(constr_sumarg_lab_i,
		   constr_sumarg_var_i,
		   constr_sumarg_i,
		   constr_sumarg_kind_i) =
	    let val k = if is_monomorphic
			    then constr_sumarg_kind_i
			else KIND_ARROW(num_tyvar,constr_sumarg_kind_i)
		val c = if is_monomorphic
			    then constr_sumarg_i
			else con_fun(tyvar_vars, constr_sumarg_i)
	    in  (SBND(constr_sumarg_lab_i,BND_CON(constr_sumarg_var_i, c)),
		 SDEC(constr_sumarg_lab_i,DEC_CON(constr_sumarg_var_i, k, SOME c, false)))
	    end

	val constr_sumarg_sbnd_sdecs = map4 mapper
	    (constr_sumarg_labs, constr_sumarg_vars, constr_sumarg, constr_sumarg_kind)
*)

	fun mapper(constr_sum_lab_i, constr_sum_var_i, constr_rf_sum_i) =
	    let val (c,k) = if is_monomorphic
				then (constr_rf_sum_i, KIND)
			    else (con_fun(tyvar_vars,constr_rf_sum_i),
				  KIND_ARROW(num_tyvar,KIND))
	    in  (SBND(constr_sum_lab_i,BND_CON(constr_sum_var_i, c)),
		 SDEC(constr_sum_lab_i,DEC_CON(constr_sum_var_i, k, SOME c, false)))
	    end

	val constr_sum_sbnd_sdecs = map3 mapper (constr_sum_labs,constr_sum_vars, constr_sum)

	fun mapper(in_coercion_lab_i, in_coercion_var_i, (in_coercion_exp_i,in_coercion_con_i)) =
	    (SBND(in_coercion_lab_i,BND_EXP(in_coercion_var_i,in_coercion_exp_i)),
	     SDEC(in_coercion_lab_i,DEC_EXP(in_coercion_var_i,in_coercion_con_i,NONE,false)))

	val in_coercion_sbnd_sdecs = map3 mapper (in_coercion_labs,in_coercion_vars,exp_con_in)

	fun mapper(out_coercion_lab_i, out_coercion_var_i, (out_coercion_exp_i,out_coercion_con_i)) =
	    (SBND(out_coercion_lab_i,BND_EXP(out_coercion_var_i,out_coercion_exp_i)),
	     SDEC(out_coercion_lab_i,DEC_EXP(out_coercion_var_i,out_coercion_con_i,NONE,false)))

	val out_coercion_sbnd_sdecs = map3 mapper (out_coercion_labs,out_coercion_vars,exp_con_out)

	val (public_sbnds, public_sdecs) =
	    unzip (type_sbnd_sdecs
(*		   @ constr_sumarg_sbnd_sdecs *)
		   @ constr_sum_sbnd_sdecs
		   @ in_coercion_sbnd_sdecs
		   @ out_coercion_sbnd_sdecs
		   @ eq_sbnd_sdecs
		   @ components)

        val public_mod = MOD_STRUCTURE(public_sbnds)
	val public_sig = SIGNAT_STRUCTURE(public_sdecs)

	val (private_sbnds, _) = unzip (top_type_sbnd_sdec @ top_eq_sbnd_sdec)

        val private_mod = MOD_STRUCTURE(private_sbnds)

	val main_mod = MOD_SEAL(MOD_LET(private_var, private_mod, public_mod), public_sig)

	val final_sbnd_sdecs =
	    [(SBND(datatypes_lab,BND_MOD(datatypes_var,false,main_mod)),
	      SDEC(datatypes_lab,DEC_MOD(datatypes_var,false,public_sig)))]
      in  final_sbnd_sdecs
      end

    (* ------------------------------------------------------------------
       Syntactic checks
       ------------------------------------------------------------------ *)
    (* Given a strongly-connected datatype binding of the form
	    tyvarseq1 tycon1 = conbind1
	    tyvarseq2 tycon2 = conbind2
		    ...
	    tyvarseqn tyconn = conbindn
       we require
	    (a) No tyvarseq contains duplicates.
	    (b) There exists k s.t. every tyvarseq has length k.
	    (c) For each application tyseq tyconi occuring in conbindj, we have tyseq = tyvarseqj.
       Note that (a) is required by the definition but (b) and (c), which reject non-uniform dataytpes, are
       imposed by TILT.
    *)

  (* splitScc : Ast.db list -> def list list option *)
  (* Split datatype bindings into strongly-connected components and
     perform syntactic checks, returning NONE if the bindings are
     rejected.  *)
  fun splitScc (context,dbs) =
  let

    (* with_mark : ('a -> 'b) -> 'a * Error.region -> 'b *)
    fun with_mark f (a, region) = let val _ = Error.push_region region
				      val res = f a
				      val _ = Error.pop_region()
				  in  res
				  end

    (* non_uniform : string -> unit *)
    fun non_uniform s = (Error.error_region(); print "non-uniform datatype: "; print s; print "\n")

    (* checkTyvar : Symbol.symbol list -> Ast.tyvar -> Symbol.symbol list *)
    fun checkTyvar B (Ast.Tyv s) =
	if Listops.member_eq(Symbol.eq, s, B)
        then (Error.error_region(); print "duplicate bound tyvar"; print "\n";
	      B)
        else s :: B
      | checkTyvar B (Ast.TempTyv _) = error "temporary tyvar has not been eliminated"
      | checkTyvar B (Ast.MarkTyv mark) = with_mark (checkTyvar B) mark

    (* checkTyvars : Ast.tyvar list -> bool *)
    (* Determine if tyvars are distinct, issuing errors if not. *)
    fun checkTyvars tyvars =
	let val distinct = foldl (fn (tv, B) => checkTyvar B tv) nil tyvars
	in  length distinct = length tyvars
	end

    (* checkDbVars : string * int -> Ast.db -> bool *)
    fun checkDbVars (kname, k) (Ast.Db {tyc, tyvars, rhs}) =
	let val varsOk = checkTyvars tyvars
	    val lenOk = (length tyvars = k orelse
	                 (non_uniform (Symbol.name tyc ^ " must bind the same number of tyvars as " ^ kname);
			  false))
	in  varsOk andalso lenOk
	end
      | checkDbVars G (Ast.MarkDb mark) = with_mark (checkDbVars G) mark

    (* checkArg : Symbol.symbol * Ast.ty -> bool *)
    fun checkArg (tyvarsym, ty) =
	let fun fail() = (non_uniform ("expected " ^ Symbol.name tyvarsym); false)
	    fun sameTyvar (Ast.Tyv s) = Symbol.eq (s, tyvarsym) orelse fail()
	      | sameTyvar (Ast.MarkTyv mark) = with_mark sameTyvar mark
	      | sameTyvar _ = fail()
	    fun sameTy (Ast.VarTy tyvar) = sameTyvar tyvar
	      | sameTy (Ast.MarkTy mark) = with_mark sameTy mark
	      | sameTy _ = fail()
	in  sameTy ty
	end

    (* AND : bool * bool -> bool.  Doesn't short-circuit. *)
    fun AND (a, b) = a andalso b

    (* ALL : ('a -> bool) -> 'a list -> bool.  Doesn't short-circuit. *)
    fun ALL f L = foldl (fn (x, acc) => f x andalso acc) true L

    (* checkArgs : Symbol.symbol list * Ast.ty list -> unit *)
    fun checkArgs (nil, nil) = true
      | checkArgs (_, nil) = (non_uniform "type constructor given too few arguments"; false)
      | checkArgs (nil, _) = (non_uniform "type constructor given too many arguments"; false)
      | checkArgs (tyvar :: tvs, ty :: tys) = AND(checkArg (tyvar, ty), checkArgs (tvs, tys))

    (* checkTy : int * Symbol.symbol list * Symbol.symbol list -> ty -> bool *)
    fun checkTy G (Ast.VarTy _) = true
      | checkTy G (Ast.ConTy (typath, args)) =
	let val argsOk = ALL (checkTy G) args
	    val (tycons, tyvars) = G
	    val appOk =
		(case typath of Ast.TypathHead sym => 
                     if Listops.member_eq(Symbol.eq, sym, tycons)
		     then checkArgs (tyvars, args)
		     else true
	           | _ => true)
	in  AND(argsOk, appOk)
	end
      | checkTy G (Ast.RecordTy tyrow) = ALL (fn (_, ty) => checkTy G ty) tyrow
      | checkTy G (Ast.TupleTy tys) = ALL (checkTy G) tys
      | checkTy G (Ast.MarkTy mark) = with_mark (checkTy G) mark

    (* constrs : Ast.dbrhs -> (Symbol.symbol * Ast.ty option) list *)
    fun constrs (Ast.Constrs cs) = cs
      | constrs (Ast.Repl _) = error "datatype replication has not been eliminated"

    (* checkDbRhs : Symbol.symbol list -> Ast.db -> bool *)
    fun checkDbRhs tycons (Ast.Db {tyc, tyvars, rhs}) =
	let val tyvars = map AstHelp.tyvar_strip tyvars
	    val tys = List.mapPartial #2 (constrs rhs)
            val datacons : Symbol.symbol list = map #1 (constrs rhs)
	in  AND(ALL (checkTy (tycons, tyvars)) tys,
		ALL (fn sym => ok_to_bind(context,sym) orelse 
		       (Error.error_region(); 
			print ("Rebinding of "^(Symbol.name sym)^" not permitted\n");
			false))
		    datacons)
	end
      | checkDbRhs tycons (Ast.MarkDb mark) = with_mark (checkDbRhs tycons) mark

    val arity : Ast.db -> int           = length o #2 o AstHelp.db_strip
    val tycon : Ast.db -> Symbol.symbol = #1 o AstHelp.db_strip
    val name  : Ast.db -> string        = Symbol.name o tycon

    (* checkDbs : Ast.db list -> bool *)
    fun checkDbs nil = true
      | checkDbs (dbs as (db :: _)) = (ALL (checkDbVars (name db, arity db)) dbs andalso
      				       ALL (checkDbRhs (map tycon dbs)) dbs)

    (* checkSCCs : Ast.db list list -> bool *)
    fun checkSCCs db_list_list = ALL checkDbs db_list_list

    (* ------------------------------------------------------------------
       The datatype compiler for compiling a single datatype statement.
       ------------------------------------------------------------------ *)

    (* def : Ast.db -> def *)
    fun def db =
	let val (tyc,tyv,rhs) = AstHelp.db_strip db
	in  (tyc, tyv, constrs rhs)
	end

    val nodes = Listops.mapcount (fn (i,db) => (i,def db)) dbs
    val numnodes = length nodes
    val syms = map (fn (_,(s,_,_)) => s) nodes
    fun help (_,NONE) = []
      | help (_,SOME ty) = let val s = AstHelp.free_tyc_ty(ty,fn _ => false)
			   in list_inter_eq(Symbol.eq,s,syms)
			   end
    fun lookup tars = case List.find (fn (_,(s,_,_)) => Symbol.eq(s,tars)) nodes
	                of NONE => error "lookup should not fail"
		         | SOME (i,_) => i
    fun get_edges (i, (_,_,rhs)) = (map (fn s => (i, lookup s))
				    (Listops.flatten (map help rhs)))
    val edges = flatten (map get_edges nodes)
    val comps = rev(GraphUtil.scc numnodes edges)

    fun lookupDb tari = List.nth(dbs, tari)
    fun lookupDef tari = #2(List.nth(nodes, tari))
  in
      if checkSCCs (Listops.mapmap lookupDb comps)
	  then SOME (Listops.mapmap lookupDef comps)
      else NONE
  end

    fun compile' (context, typecompile,
		  datatycs : Ast.db list, 
		  eq_compile, 
		  is_transparent : bool) : (sbnd * sdec) list =
      let
        (* ---- call the main routine for each sorted list of datatypes
	   and retain the accumulated context *)
	fun loop context acc [] = rev acc
	  | loop context acc (std_list::rest) =
	    let fun geq_symrest((s1,_),(s2,_)) = geq_sym(s1,s2)
		val sort_symrest = ListMergeSort.sort geq_symrest
		fun sort_std' (ncs,cs) [] = (sort_symrest ncs) @ (sort_symrest cs)
		  | sort_std' (ncs,cs) ((nc as (_,NONE))::rest) = sort_std' (nc::ncs,cs) rest
		  | sort_std' (ncs,cs) ((c as (_,SOME _))::rest) = sort_std' (ncs,c::cs) rest
		fun sort_std (s,tvs,st_list) = (s,tvs,sort_std' ([],[]) st_list)
		val std_list = map sort_std std_list
		fun geq_std((s1,_,_),(s2,_,_)) = geq_sym(s1,s2)
		val std_list = ListMergeSort.sort geq_std std_list
		val sbnd_sdecs = driver(typecompile,context,
					std_list, eq_compile, is_transparent)
		val _ = if (!debug)
			    then (print "DRIVER returned SBNDS = ";
				  map (fn (sb,_) => (Ppil.pp_sbnd sb; print "\n")) sbnd_sdecs;
				  print "   and returned SDECS = ";
				  map (fn (_,sd) => (Ppil.pp_sdec sd; print "\n")) sbnd_sdecs;
				  print "\n\n")
			else ()
		val sdecs = map (#2) sbnd_sdecs
		val context' = add_context_sdecs(context,sdecs)
		val acc' = (rev sbnd_sdecs) @ acc
	    in loop context' acc' rest
	    end
      in case splitScc (context,datatycs)
	   of NONE => []
	    | SOME sym_tyvar_def_listlist => loop context [] sym_tyvar_def_listlist
      end

    fun compile_static' (context,datatycs) : sdec list =
      let
	  fun doit std_list =
	    let
		fun geq_std((s1,_,_),(s2,_,_)) = geq_sym(s1,s2)
		val std_list = ListMergeSort.sort geq_std std_list
		val num_tyvars = (case std_list of nil => error "compile_static'"
	                           | ((_, tyvars, _) :: _) => length tyvars)
		val kind = if num_tyvars = 0 then KIND
			   else KIND_ARROW(num_tyvars,KIND)
		val type_syms = map #1 std_list
		val type_labs = map symbol_label type_syms
		val type_vars = map (fn s => fresh_named_var (Symbol.name s)) type_syms
		val sdecs = map2 (fn (l,v) => SDEC(l,DEC_CON(v,kind,NONE,false))) (type_labs,type_vars)

		val top_type_string = foldl (fn (s,acc) => acc ^ "_" ^ (Symbol.name s)) "" type_syms
		val datatypes_var = fresh_named_var top_type_string
		val top_type_lab = internal_label top_type_string
		val datatypes_lab = to_open top_type_lab
		val top_sdec = SDEC(datatypes_lab,DEC_MOD(datatypes_var,false,SIGNAT_STRUCTURE(sdecs)))
	    in
		top_sdec
	    end
      in
	  case splitScc (context,datatycs)
	    of NONE => []
	     | SOME sym_tyvar_def_listlist => map doit sym_tyvar_def_listlist
      end

    (* 
       The reason that we copy each component of a datatype separately,
       instead of just copying the whole module, is that the *name* of the datatype
       may change (e.g. datatype t = datatype u), and so the label names may need
       to change accordingly.  Perhaps a smarter thing to do would be to copy the
       module whole (with an open label) and then introduce some rebindings of the
       type components (e.g. [tmod* = umod, type t = tmod.u]).  It would be worth
       thinking about, since this code seems unnecessarily complicated.
           -Derek
     *)
    fun copy_datatype(context,path,tyc) =
	let val old_type_sym = List.last path
	    val type_sym = tyc
	    val type_lab = symbol_label tyc
	    val type_var = gen_var_from_symbol tyc
	    val type_string = (Symbol.name type_sym)

            (* This is not necessary, but just to mimic the open labels given to normal
               datatype modules. *)
	    val top_string = "_" ^ type_string
	    val top_var = fresh_named_var top_string
	    val top_lab = to_open(internal_label top_string)

	    val constr_sum_string = type_string ^ "_sum"
	    val constr_sum_var = fresh_named_var constr_sum_string
	    val constr_sum_lab = to_sum(internal_label constr_sum_string)
	    val old_constr_sum_string = (Symbol.name old_type_sym) ^ "_sum"
	    val old_constr_sum_lab = to_sum(internal_label old_constr_sum_string)
(*
	    val constr_sumarg_string = (Symbol.name type_sym) ^ "_sumarg"
	    val constr_sumarg_var = fresh_named_var constr_sumarg_string
	    val constr_sumarg_lab = internal_label constr_sumarg_string
	    val old_constr_sumarg_string = (Symbol.name old_type_sym) ^ "_sumarg"
	    val old_constr_sumarg_lab = internal_label old_constr_sumarg_string
*)
	    val in_coercion_string = (Symbol.name type_sym) ^ "_in"
	    val in_coercion_var = fresh_named_var in_coercion_string
	    val in_coercion_lab = to_coercion (internal_label in_coercion_string)
	    val old_in_coercion_string = (Symbol.name old_type_sym) ^ "_in"
	    val old_in_coercion_lab = to_coercion (internal_label old_in_coercion_string)
	    val out_coercion_string = (Symbol.name type_sym) ^ "_out"
	    val out_coercion_var = fresh_named_var out_coercion_string
	    val out_coercion_lab = to_coercion (internal_label out_coercion_string)
	    val old_out_coercion_string = (Symbol.name old_type_sym) ^ "_out"
	    val old_out_coercion_lab = to_coercion (internal_label old_out_coercion_string)


	    val eq_lab = to_eq type_lab
	    val eq_var = fresh_named_var "eqfun"
	    val dt_lab = to_dt type_lab
	    val inner_type_lab = internal_label (Symbol.name tyc)
	    val old_inner_type_lab = internal_label (Symbol.name old_type_sym)
	    val dt_var = fresh_named_var "dt"
	    fun change_path [] _ = error "empty path"
	      | change_path [l] base = [base l]
	      | change_path (a::b) base = a :: change_path b base
	    val change_path = change_path (map symbol_label path)
	    val type_labs = change_path (fn l => l)
	    val eq_labs = change_path to_eq
	    val dt_labs = change_path to_dt
	    val constr_sum_labs = change_path (fn _ => old_constr_sum_lab)
(*
	    val constr_sumarg_labs = change_path (fn _ => old_constr_sumarg_lab)
*)
	    val in_coercion_labs = change_path (fn _ => old_in_coercion_lab)
	    val out_coercion_labs = change_path (fn _ => old_out_coercion_lab)


	    val eq_sbndsdec =
		(case (Context_Lookup_Labels(context,eq_labs)) of
		     SOME(_,PHRASE_CLASS_EXP (e,c,_,_)) =>
			 let val bnd = BND_EXP(eq_var,e)
			     val dec = DEC_EXP(eq_var,c,NONE,false)
			 in  [(SBND(eq_lab,bnd),SDEC(eq_lab,dec))]
			 end
		   | SOME(_,PHRASE_CLASS_MOD (m,b,s,_)) =>
			 let val bnd = BND_MOD(eq_var,b,m)
			     val dec = DEC_MOD(eq_var,b,s)
			 in  [(SBND(eq_lab,bnd),SDEC(eq_lab,dec))]
			 end
		   | _ => [])
	    val constr_sbndsdec =
		(case (Context_Lookup_Labels(context,dt_labs)) of
		     SOME(_,PHRASE_CLASS_MOD (m,b,s,_)) =>
			 let
			     fun mapper (SDEC(old_lab,dec)) =
				 let
				     val labs = dt_labs @ [old_lab]
				     fun fail msg = (debugdo(fn () =>
							     (Ppil.pp_pathlist Ppil.pp_label' labs;
							      print ": "; print msg;  print "\n"));
						     reject msg)
				     val var = (case dec
						  of DEC_EXP(v,_,_,_) => v
						   | DEC_CON(v,_,_,_) => v
						   | DEC_MOD(v,_,_) => v)
				     val bnd = (case Context_Lookup_Labels(context,labs)
						  of SOME (_, PHRASE_CLASS_EXP (e,c,eo,i)) => BND_EXP(var,e)
						   | SOME (_, PHRASE_CLASS_CON (c,k,co,i)) => BND_CON(var,c)
						   | SOME (_, PHRASE_CLASS_MOD (m,p,s,_)) => BND_MOD(var,p,m)
						   | _ => fail "datatype - undefined component")
				     val lab = if eq_label (old_lab, old_inner_type_lab)
						   then inner_type_lab
					       else old_lab
				 in  (SBND(lab,bnd), SDEC(lab,dec))
				 end
			     val SIGNAT_STRUCTURE sdecs = s
			     val sbndsdec = map mapper sdecs
			     val (sbnds,sdecs) = Listops.unzip sbndsdec
			     val m' = MOD_STRUCTURE sbnds
			     val s' = SIGNAT_STRUCTURE sdecs
			     val bnd = BND_MOD(dt_var,b,m')
			     val dec = DEC_MOD(dt_var,b,s')
			 in  [(SBND(dt_lab,bnd),SDEC(dt_lab,dec))]
			 end
		   | _ => (debugdo(fn () =>
				   (Ppil.pp_pathlist Ppil.pp_label' dt_labs; print ": ";
				    print "unbound datatype - constr labs"));
			   reject "unbound datatype - constr labs"))

	    fun copy_type str (lookup_labs, lab, var) =
		case (Context_Lookup_Labels(context,lookup_labs)) of
		     SOME(p,PHRASE_CLASS_CON (c,k,_,i)) =>
			 let
			     val bnd = BND_CON(var,c)
			     val dec = DEC_CON(var,k,SOME c,i)
			 in  (p,(SBND(lab,bnd),SDEC(lab,dec)))
			 end
		   | _ => (print "lookup_labs: "; app Ppil.pp_label lookup_labs; print "\n";
			   reject ("unbound datatype - copy type " ^ str))

	    fun copy_coercion str (lookup_labs, lab, var) =
		case (Context_Lookup_Labels(context,lookup_labs)) of
		    SOME(_,PHRASE_CLASS_EXP(e,c,_,_)) =>
			let
			    val bnd = BND_EXP(var,e)
			    val dec = DEC_EXP(var,c,NONE,false)
			in
			    (SBND(lab,bnd),SDEC(lab,dec))
			end
		  | _ => (print "lookup_labs: "; app Ppil.pp_label lookup_labs; print "\n";
			   reject ("unbound datatype - copy coercion " ^ str))

	    val (p1,type_sbndsdec) = copy_type "type" (type_labs,type_lab,type_var)
	    val (p2,constr_sum_sbndsdec) = copy_type "constr_sum"
		(constr_sum_labs,constr_sum_lab,constr_sum_var)


            (* Disregard the following comment. *)

            (* Unfortunately, this sanity check doesn't work when one or both of the paths
	       is just a variable.  Fixing the sanity check is not obvious.
	       So, for the moment, we allow invalid declarations like

                   datatype t = A
                   type t = int
                   datatype u = datatype t

               and the result will be that u = int, but the rest of u's datatype components
	       are defined in terms of the shadowed datatype t.
            *)

            (* This is just to check that the datatype being copied has not been shadowed
               by a subsequent type declaration, in which case the datatype and the sum type
               would have to differ in their paths. *)

            fun sanity_check (PATH(v1,labs1 as (_::_)),PATH(v2,labs2 as (_::_))) = 
		eq_path(PATH(v1,butlast labs1),PATH(v2,butlast labs2))
	      | sanity_check _ = false

	    val _ = sanity_check(p1,p2) orelse
		    reject "Datatype replication failed: datatype being replicated was shadowed"


(*
	    val constr_sumarg_sbndsdec = copy_type "constr_sumarg"
		(constr_sumarg_labs,constr_sumarg_lab,constr_sumarg_var)
*)
	    val in_coercion_sbndsdec = copy_coercion "in_coercion"
		(in_coercion_labs,in_coercion_lab,in_coercion_var)
	    val out_coercion_sbndsdec = copy_coercion "out_coercion"
		(out_coercion_labs,out_coercion_lab,out_coercion_var)

	    val sbndsdecs = [type_sbndsdec]
		          @ [(* constr_sumarg_sbndsdec, *) constr_sum_sbndsdec]
		          @ [in_coercion_sbndsdec,out_coercion_sbndsdec]
	                  @ eq_sbndsdec @ constr_sbndsdec

	    val (sbnds,sdecs) = unzip sbndsdecs
	    val top_sbnd = SBND(top_lab,BND_MOD(top_var,false,MOD_STRUCTURE sbnds))
	    val top_sdec = SDEC(top_lab,DEC_MOD(top_var,false,SIGNAT_STRUCTURE sdecs))

	in
	    [(top_sbnd,top_sdec)]
	end

    fun copy_datatype_static (context,path,tyc) : sdec list = 
	let
	    val type_lab = symbol_label tyc
	    val type_var = gen_var_from_symbol tyc
	    val type_labs = map symbol_label path
	    val type_string = (Symbol.name tyc)

            (* This naming convention is not necessary, 
	       but just to mimic the open labels given by copy_datatype, which in turn
	       mimics the open labels given to normal datatype modules. *)
	    val top_string = "_" ^ type_string
	    val top_var = fresh_named_var top_string
	    val top_lab = to_open(internal_label top_string)

	    val sdec = (case Context_Lookup_Labels(context,type_labs) of
                          SOME(_,PHRASE_CLASS_CON (c,k,_,i)) =>
			      SDEC(top_lab,DEC_MOD(top_var,false,
                                 SIGNAT_STRUCTURE[SDEC(type_lab,DEC_CON(type_var,k,SOME c,i))]))
    		        | _ => (print "lookup_labs: "; app Ppil.pp_label type_labs; print "\n";
			        reject ("unbound datatype")))
	in 
	    [sdec]
	end

    fun compile {context, typecompile,
		 datatycs : Ast.db list, 
		 eq_compile, 
		 is_transparent : bool} : (sbnd * sdec) list =
	let
	    fun calldriver() = compile'(context,typecompile,datatycs,eq_compile,is_transparent)
	in
	    case datatycs of
		[db] =>
		    let val (tyc,tyv,rhs) = AstHelp.db_strip db
		    in  (case rhs of
			     Ast.Repl path => copy_datatype(context,path,tyc)
			   | _ => calldriver())
		    end
	      | _ => calldriver()
	end

    fun compile_static (context,datatycs) : sdec list = 
	(case datatycs of
	     [db] =>
		 let val (tyc,tyv,rhs) = AstHelp.db_strip db
		 in  (case rhs of
			  Ast.Repl path => copy_datatype_static(context,path,tyc)
			| _ => compile_static'(context,datatycs))
		 end
	   | _ => compile_static'(context,datatycs))
	   


    (* ----- is the phrase-class for a non value-carrying constructor *)
    fun pc_is_const pc =
	let val innercon =
	    (case pc of
		 PHRASE_CLASS_MOD(_,true,SIGNAT_FUNCTOR(_,_,s,_),_) =>
		     (case s of
			  SIGNAT_STRUCTURE([SDEC(itlabel,
						   DEC_EXP(_,con,_,_))]) => con
			| _ => (Ppil.pp_phrase_class pc;
                              error "ill-formed constructor mod phrase_class"))
	       | PHRASE_CLASS_EXP(_,con,_,_) => con
	       | _ => (Ppil.pp_phrase_class pc;
                       error "ill-formed constructor phrase_class"))
	in  (case innercon of
		 CON_ARROW _ => false
	       | CON_APP _ => true
	       | CON_VAR _ => true
	       | CON_SUM _ => true
	       | CON_MODULE_PROJECT _ => true
	       | _ => (print "ill-formed constructor type: ";
		       Ppil.pp_con innercon; print "\n";
		       error "ill-formed constructor type"))
	end

    (* ---------------- constructor LOOKUP RULES ---------------------------
       --------------------------------------------------------- *)
    type lookup = (Il.context * Il.label list -> (Il.mod * Il.signat) option)
    exception NotConstructor
    datatype path_or_con = APATH of path | CON of con

    fun constr_lookup context (p : Ast.path) =
	(SOME
	 let
	    val _ = (debugdo (fn () => (print "constr_lookup called with path = ";
					app pp_label (map symbol_label p);
					print "\n")))
	    val (v,ls,pc) =
		(case (Context_Lookup_Labels(context,map symbol_label p)) of
		     NONE=> (debugdo (fn () => print "constr_lookup found no phrase class\n");
			     raise NotConstructor)
		   | SOME (constr_path, pc) =>
		      (case constr_path of
			   PATH (_,[]) => (debugdo (fn() => print "path was too short\n"); raise NotConstructor)
			 | PATH (v,ls) => (v,ls,pc)))

	    val _ = debugdo (fn () => (print "constr_lookup found v, ls, pc\n"))

	    val datatype_path = PATH(v,butlast ls)
	    val data_sig = GetModSig(context,path2mod datatype_path)
	    val sdecs = (case data_sig of
			     SIGNAT_STRUCTURE sdecs => sdecs
			   | _ => error "shortened path did not lead to a structure signature")

	    val _ = if (length sdecs < 2) then raise NotConstructor else ()
	    val internal_type_sdec:: expose_sdec :: _ = sdecs

	    val _ = debugdo (fn() => print "constr_lookup found internal_type_sdec and expose_sdec\n")

	    val (internal_type_lab,type_path) =
		(case internal_type_sdec of
		     (SDEC(internal_type_lab,DEC_CON(_,_,SOME c,_))) =>
			 (internal_type_lab, (case (con2path c) of
						  NONE => CON c
						| SOME p => APATH p))
		   | _ => raise NotConstructor)

	    val _ = debugdo (fn() => print "constr_lookup found internal_type_label and type_path\n")

	    val sum_path =
		(case expose_sdec of
		     SDEC(_,DEC_EXP(_,CON_ARROW(_,c,_,_),_,_)) => (case con2path c of
								   SOME p => APATH p
								 | NONE => CON c)
		   | SDEC(_,DEC_MOD(_,true,SIGNAT_FUNCTOR(_,_,SIGNAT_STRUCTURE sdecs,_))) =>
			 (case sdecs of
			      [SDEC(_,DEC_EXP(_,CON_ARROW(_,CON_APP(c,_),_,_),_,_))] =>
				  (case con2path c of
				       SOME p => APATH p
				     | NONE => CON c)
			    | _ => raise NotConstructor)
		   | _ => (debugdo (fn() => (print "constr_lookup got bad expose_sdec\n";
					     pp_sdec expose_sdec; print "\n")); raise NotConstructor))

	    val _ = debugdo (fn() => print "constr_lookup got sum_path\n")
	    val num_constr = (length sdecs) - 2

	in (case sdecs of
		(SDEC(type_lab,_)) ::
		(SDEC(maybe_expose,_)) :: _ =>
		    if (eq_label(maybe_expose,expose_lab))
			then {name = type_lab,
			      is_const = pc_is_const pc,
			      datatype_path = datatype_path,
			      sum_path = sum_path,
			      type_path = type_path,
			      datatype_sig = data_sig}
		    else raise NotConstructor
	      | _ => raise NotConstructor)
	end
    handle NotConstructor => NONE)


    fun is_constr ctxt path = (case constr_lookup ctxt path of
				   NONE => false
				 | SOME _ => true)

    fun is_nonconst_constr ctxt path = (case constr_lookup ctxt path of
					    NONE => false
					  | SOME {is_const,...} => not is_const)

     fun des_dec (d : dec) : ((Il.var * Il.sdecs) option * Il.con) =
       (case d of
	  DEC_MOD(_,true,SIGNAT_FUNCTOR(v,SIGNAT_STRUCTURE sdecs,
					SIGNAT_STRUCTURE([SDEC(_,DEC_EXP(_,c,_,_))]),_)) => (SOME (v, sdecs), c)
	| DEC_EXP(_,c,_,_) => (NONE, c)
	| _ => error "des_dec")


     fun destructure_datatype_signature
	 s : {name : Il.label,
	      var_sdecs_poly : (Il.var * Il.sdecs) option,
	      arm_types : {name : Il.label, arg_type : Il.con option} list}
       =
       let fun bad () = (Ppil.pp_signat s;
			 error "ill-formed datatype_signature")
	   fun good (type_name,arm_sdecs) =
	       let fun helper (SDEC(constr_name,mkdec)) =
			    let
				val (vso,mkc) = des_dec mkdec
				val argcon = case mkc of
				    CON_ARROW([c],_,_,_) => SOME c
				  | _ => NONE
			    in (vso,{name=constr_name,arg_type=argcon})
			    end
		   val arm_types = map (#2 o helper) arm_sdecs
		   val var_sdecs_poly = #1 (helper (hd arm_sdecs))
	       in {name = type_name,
		   var_sdecs_poly = var_sdecs_poly,
		   arm_types = arm_types}
	       end
	   val sdecs =
	   (case s of
		SIGNAT_STRUCTURE sdecs => sdecs
	      | _ => bad())
       in
		    (case sdecs of
			 ((SDEC(type_name,DEC_CON(_,_,_,_)))::
			  (SDEC(maybe_expose,_))::arm_sdecs) =>
			 (if (eq_label(maybe_expose,expose_lab))
			      then good(type_name,arm_sdecs)
			  else bad())
			| _ => bad())
       end


 fun instantiate_datatype_signature (context : Il.context,
				     path : Ast.path,
				     polyinst : (Il.context * Il.sdecs ->
						 Il.sbnd list * Il.sdecs * Il.con list))
     : {instantiated_type : Il.con,
	instantiated_sumtype : Il.con,
	arms : {name : Il.label, arg_type : Il.con option} list,
	expose_exp : Il.exp} =

   let

       val SOME {sum_path, type_path,
		 datatype_path, datatype_sig, ...} = constr_lookup context path
       val {name,var_sdecs_poly,arm_types} = destructure_datatype_signature datatype_sig


       val sbnds_sdecs_cons_opt =
	   (case (var_sdecs_poly) of
		SOME (vp,sp) => SOME(polyinst(context, sp))
	      | NONE => NONE)

       fun help path =
	   (case (Context_Lookup_Path(context,path)) of
		(SOME(_,PHRASE_CLASS_CON(_,_,SOME c,true))) => c
	      | _ => path2con path)

       val tycon = (case type_path of
			APATH p => help p
		      | CON c => c)
       val sumtycon = (case sum_path of
			   APATH p => help p
			 | CON c => c)

       val (sumcon,datacon) = (case sbnds_sdecs_cons_opt of
				   NONE => (sumtycon,tycon)
				 | SOME (_,_,cons) =>
				       (CON_APP(sumtycon, cons),
					CON_APP(tycon, cons)))

       val expose_path = join_path_labels(datatype_path,[expose_lab])
       val expose_exp =
	   (case
		(Context_Lookup_Path(context,expose_path), sbnds_sdecs_cons_opt) of
		(SOME(_,PHRASE_CLASS_EXP(_,_,SOME e,_)),_) => e
	      | (SOME(_,PHRASE_CLASS_MOD(_,true,s,_)),SOME(sbnds,_,_)) =>
		    (case s of
			 SIGNAT_FUNCTOR(v,argsig,SIGNAT_STRUCTURE [SDEC(_,DEC_EXP(_,_,SOME e,_))],_) =>
			     let fun folder (SBND(l,BND_CON(_,c)),s) = subst_add_conpath(s,PATH(v,[l]),c)
				   | folder _ = error "bad polymorphic instantiation of expose function"
				 val subst = foldl folder empty_subst sbnds
			     in  exp_subst(e,subst)
			     end
		       | _ => error "cannot construct exposeExp - weird signature")
	      | _ => (Ppil.pp_path expose_path;
			 error "cannot construct exposeExp - could not find path"))



     fun getconstr_namepatconoption {name,arg_type} =
	 {name=name,
	  arg_type=(case (arg_type,var_sdecs_poly,sbnds_sdecs_cons_opt) of
			(NONE,_,_) => NONE
		      | (SOME x,SOME(var_poly,_),
			        SOME(_,sdecs,_)) =>
			    (SOME(remove_modvar_type(x,var_poly,sdecs))
			    handle e => error "remove_modvar_failed")
		      | (SOME x, _, _) => SOME x)}

   in  {instantiated_type = datacon,
	instantiated_sumtype = sumcon,
	arms = map getconstr_namepatconoption arm_types,
	expose_exp = expose_exp}
   end


   (* N.B. Runtime/exn.c cares how exceptions are compiled.  If you
      change exn_lookup you almost certainly have to change
      getOverflowExn, etc. *)
   fun exn_lookup context path : {stamp : Il.exp,
				  carried_type : Il.con option} option =
       (case (Context_Lookup_Labels(context,map symbol_label path)) of
	  NONE=> NONE
	| SOME (path_mod,PHRASE_CLASS_MOD(m,_,exn_sig as
					  SIGNAT_STRUCTURE ([SDEC(lab1,DEC_EXP(_,ctag,_,_)),
							     SDEC(lab2,DEC_EXP(_,cmk,_,_))]),_)) =>
	      if (eq_label(lab1,stamp_lab) andalso eq_label(lab2,mk_lab))
		  then
		      (case (ctag,cmk) of
			      (_, CON_ANY) => SOME {stamp=MODULE_PROJECT(path2mod path_mod,stamp_lab),
						    carried_type = NONE}
			    | (CON_TAG c, _) => SOME {stamp=MODULE_PROJECT(path2mod path_mod,stamp_lab),
						      carried_type = SOME c}
			    | _ => error_sig exn_sig "bad exn signature")
	      else NONE
	| _ => NONE)


  end
