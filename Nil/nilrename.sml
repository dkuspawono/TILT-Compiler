structure NilRename :> NILRENAME =
  struct
    open Nil

    val lprintl = Util.lprintl
    val printl = Util.printl

    val locate = NilError.locate "Rename"
    val assert = NilError.assert

    fun error s s' = Util.error (locate s) s'

    fun error' s = error "" s

    val isSome = Option.isSome

    structure VarMap = Name.VarMap
    structure VarSet = Name.VarSet

    type 'a map = 'a Name.VarMap.map

    (* Normal renaming *)
    local
      open NilRewrite

      type state = {exp_subst : var map,con_subst : var map}

      fun exp_var_bind ({exp_subst,con_subst} : state,var) =
	let
	  val var' = Name.derived_var var
	  val exp_subst = VarMap.insert (exp_subst,var,var')
	in
	  ({exp_subst = exp_subst,con_subst = con_subst},SOME var')
	end

      fun con_var_bind ({exp_subst,con_subst} : state,var) =
	let
	  val var' = Name.derived_var var
	  val con_subst = VarMap.insert (con_subst,var,var')
	in
	  ({exp_subst = exp_subst,con_subst = con_subst},SOME var')
	end

      fun conhandler (state as {con_subst,...} : state,con : con) =
	(case con
	   of Var_c var =>
	     (case VarMap.find (con_subst,var)
		of SOME var => (CHANGE_NORECURSE (state,Var_c var))
		 | _ => NORECURSE)
	    | _ => NOCHANGE)

      fun exphandler (state as {exp_subst,...} : state,exp : exp) =
	(case exp
	   of Var_e var =>
	     (case VarMap.find (exp_subst,var)
		of SOME var => (CHANGE_NORECURSE (state,Var_e var))
		 | _ => NORECURSE)
	    | _ => NOCHANGE)

      (* Default trace handler will suffice.
       *
       *)
      val exp_handlers =
	let
	  val h = set_exphandler default_handler exphandler
	  val h = set_exp_binder h exp_var_bind
	in
	  h
	end

      val {rewrite_exp = renameEVarsExp',
	   rewrite_con = renameEVarsCon',
	   rewrite_kind = renameEVarsKind',...} = rewriters exp_handlers

      val con_handlers =
	let
	  val h = set_conhandler default_handler conhandler
	  val h = set_con_binder h con_var_bind
	in
	  h
	end

      val {rewrite_exp = renameCVarsExp',
	   rewrite_con = renameCVarsCon',
	   rewrite_kind = renameCVarsKind',...} = rewriters con_handlers

      val all_handlers =
	let
	  val h = set_conhandler exp_handlers conhandler
	  val h = set_con_binder h con_var_bind
	in
	  h
	end

      val {rewrite_exp = renameExp',
	   rewrite_con = renameCon',
	   rewrite_kind = renameKind',
	   rewrite_bnd = renameBnd',
	   rewrite_cbnd = renameCBnd',
	   rewrite_mod = renameMod',...} = rewriters all_handlers

      fun empty_state () = {exp_subst = VarMap.empty,con_subst = VarMap.empty}


    in
      val renameEVarsExp = renameEVarsExp' (empty_state())
      val renameEVarsCon = renameEVarsCon' (empty_state())
      val renameEVarsKind = renameEVarsKind' (empty_state())

      val renameCVarsExp = renameCVarsExp' (empty_state())
      val renameCVarsCon = renameCVarsCon' (empty_state())
      val renameCVarsKind = renameCVarsKind' (empty_state())

      val renameExp = renameExp' (empty_state())
      val renameCon = renameCon' (empty_state())
      val renameKind = renameKind' (empty_state())
      val renameMod = renameMod' (empty_state())

      fun renameBnd bnd =
	let
	  val (bnds,{con_subst,exp_subst}) = renameBnd' (empty_state ()) bnd
	in
	  (hd bnds,(exp_subst,con_subst))
	end

      fun renameCBnd bnd =
	let
	  val (bnds,{con_subst,...}) = renameCBnd' (empty_state()) bnd
	in
	  (hd bnds,con_subst)
	end

      fun renameFunction(f : function) =
	  let val v = Name.fresh_var()                    (* junk type *)
	      val bnd = Fixopen_b (Sequence.fromList[((v, Prim_c(Exn_c,[])),f)])
	  in  (case renameBnd bnd of
		   (Fixopen_b vfSeq, _) =>
		       (case Sequence.toList vfSeq of
			    [(_, f)] => f
			  | _ => error' "renameFunction")
		 | _ => error' "renameFunction")
	  end

    end

    (* Renaming with respect to a predicate *)
    local
      open NilRewrite

      type state = {esubst : var VarMap.map,
		    csubst : var VarMap.map,
		    epred : var -> bool,
		    cpred : var -> bool}

      fun exp_var_bind (state :state as {esubst,csubst,epred,cpred},var) =
	if epred var then
	  let
	    val var' = Name.derived_var var
	    val esubst = VarMap.insert (esubst,var,var')
	  in
	    ({esubst=esubst,csubst=csubst,epred=epred,cpred=cpred},SOME var')
	  end
	else (state,NONE)

      fun con_var_bind (state :state as {esubst,csubst,epred,cpred},var) =
	if cpred var then
	  let
	    val var' = Name.derived_var var
	    val csubst = VarMap.insert (csubst,var,var')
	  in
	    ({esubst = esubst,csubst = csubst, epred = epred, cpred = cpred},SOME var')
	  end
	else (state,NONE)

      fun conhandler (state : state as {csubst,...},con : con) =
	(case con
	   of Var_c var =>
	     (case VarMap.find (csubst,var)
		of SOME var => (CHANGE_NORECURSE (state,Var_c var))
		 | _ => NORECURSE)
	    | _ => NOCHANGE)

      fun exphandler (state : state as {esubst,...},exp : exp) =
	(case exp
	   of Var_e var =>
	     (case VarMap.find (esubst,var)
		of SOME var => (CHANGE_NORECURSE (state,Var_e var))
		 | _ => NORECURSE)
	    | _ => NOCHANGE)

      val all_handlers =
	let
	  val h = set_exphandler default_handler exphandler
	  val h = set_exp_binder h exp_var_bind
	  val h = set_conhandler h conhandler
	  val h = set_con_binder h con_var_bind
	in
	  h
	end

      val {rewrite_exp = renameExpWRT',
	   rewrite_con = renameConWRT',
	   rewrite_kind = renameKindWRT',
	   rewrite_bnd = renameBndWRT',
	   rewrite_cbnd = renameCBndWRT',
	   rewrite_mod = renameModWRT',...} = rewriters all_handlers

      fun empty (epred,cpred) = {esubst = VarMap.empty,csubst = VarMap.empty,epred = epred,cpred = cpred}

      fun renameBndWRT preds bnd =
	let
	  val (bnds,substs) = renameBndWRT' (empty preds) bnd
	in
	  (hd bnds,substs)
	end

(*      fun renameCBndWRT bnd =
	let
	  val (bnds,(esubst,subst)) = renameCBnd' empty bnd

	    if !debug then
	      assert (locate "POST:renameCBnd")
	      [
	       (is_empty esubst,fn () => TextIO.print "Renaming cbnd should not export evar changes")
	       ]
	    else ()
	in
	  (hd bnds,subst)
	end
*)
    in
      fun renameExpWRT preds = renameExpWRT' (empty preds)
      fun renameConWRT preds = renameConWRT' (empty preds)
      fun renameKindWRT preds = renameKindWRT' (empty preds)
    end

    (*Is renamed predicate *)
    local
      open NilRewrite

      val continue = Stats.tt "isRenamedContinue"

      val find = HashTable.find
      val insert = HashTable.insert

      exception Rebound of var
      exception Unbound

      type varset = (var,unit) HashTable.hash_table
      type state = {cpred : var -> bool,
		    epred : var -> bool,
		    cbound : varset,
		    ebound : varset}

      fun exp_var_bind (state : state as {epred,ebound,...},var) =
	let
	  val _ =if isSome (find ebound var) orelse (epred var)
		   then if !continue then lprintl ("Expression variable "^(Name.var2string var)^" rebound: continuing")
			else raise Rebound var
		 else insert ebound (var,())
	in (state,NONE)
	end

      fun con_var_bind (state : state as {cpred,cbound,...},var) =
	let
	  val _ =if isSome (find cbound var) orelse (cpred var)
		   then if !continue then lprintl ("Constructor variable "^(Name.var2string var)^" rebound: continuing")
			else raise Rebound var
		 else insert cbound (var,())
	in (state,NONE)
	end

      val all_handlers =
	let
	  val h = set_con_binder default_handler con_var_bind
	  val h = set_exp_binder h exp_var_bind
	in
	  h
	end

      val {rewrite_exp = checkExp,
	   rewrite_con = checkCon,
	   rewrite_kind = checkKind,
	   rewrite_mod = checkMod,...} = rewriters all_handlers

      fun isRenamedXXX checker (epred,cpred) item =
	let
	  val cbound = Name.mk_var_hash_table(20,Unbound)
	  val ebound = Name.mk_var_hash_table(20,Unbound)
	in
	  ((checker {cpred = cpred,epred = epred,cbound = cbound,ebound = ebound} item;
	    true)
	   handle Rebound var =>
	     (lprintl ("Variable "^(Name.var2string var)^" rebound");
	      false))
	end

      fun ff _ = false
    in
      val isRenamedExp = isRenamedXXX checkExp (ff,ff)
      val isRenamedCon = isRenamedXXX checkCon (ff,ff)
      val isRenamedKind = isRenamedXXX checkKind (ff,ff)
      val isRenamedMod = isRenamedXXX checkMod (ff,ff)
      val isRenamedExpWRT = isRenamedXXX checkExp
      val isRenamedConWRT = isRenamedXXX checkCon
      val isRenamedKindWRT = isRenamedXXX checkKind
    end



    (*Shadowing*)
    local
      open NilRewrite

      structure VarSet = Name.VarSet

      val add = VarSet.add
      val member = VarSet.member

      exception Rebound of var

      type state = {cbound : VarSet.set,
		    ebound : VarSet.set}

      fun exp_var_bind (state : state as {ebound,cbound},var) : (state * var option)=
	(if member (ebound, var) then
	   raise Rebound var
	 else
	   ({ebound = add (ebound,var),cbound = cbound},
	    NONE))

      fun con_var_bind (state :state as {cbound,ebound},var) : (state * var option)=
	(if member (cbound, var) then
	   raise Rebound var
	 else
	   ({cbound = add (cbound,var),ebound = ebound},
	    NONE))

      val all_handlers =
	let
	  val h = set_con_binder default_handler con_var_bind
	  val h = set_exp_binder h exp_var_bind
	in
	  h
	end

      val {rewrite_exp = checkExp,
	   rewrite_con = checkCon,
	   rewrite_kind = checkKind,
	   rewrite_mod = checkMod,...} = rewriters all_handlers

      fun noShadowsXXX checker item =
	let
	  val cbound = VarSet.empty
	  val ebound = VarSet.empty
	in
	  ((ignore (checker {ebound = ebound,cbound = cbound} item);
	    true)
	   handle Rebound var =>
	     (lprintl ("Variable "^(Name.var2string var)^" shadows");
	      false))
	end

    in
      val noShadowsExp  = noShadowsXXX checkExp
      val noShadowsCon  = noShadowsXXX checkCon
      val noShadowsKind = noShadowsXXX checkKind
      val noShadowsMod  = noShadowsXXX checkMod
    end

    (* Alpha vary items
     *)
    local
      open NilRewrite

      type state = {alpha_e : Alpha.alpha_context,
		    alpha_c : Alpha.alpha_context}

      fun con_var_bind (state as {alpha_e,alpha_c} : state,var) =
	if Alpha.bound (alpha_c,var) then ({alpha_e = alpha_e,alpha_c = Alpha.unbind (alpha_c,var)},NONE)
	else (state,NONE)

      fun conhandler (state as {alpha_e,alpha_c} : state,con : con) =
	if (Alpha.is_empty alpha_c) andalso (Alpha.is_empty alpha_e)  then NORECURSE
	else
	  (case con
	     of Var_c var =>
	       (if Alpha.renamed (alpha_c,var) then
		  CHANGE_NORECURSE(state,Var_c (Alpha.substitute(alpha_c,var)))
		else
		  NORECURSE)
	      | _ => NOCHANGE)

      fun exp_var_bind (state as {alpha_e,alpha_c} : state,var) =
	if Alpha.bound (alpha_e,var) then ({alpha_c = alpha_c,alpha_e = Alpha.unbind (alpha_e,var)},NONE)
	else (state,NONE)

      fun exphandler (state as {alpha_e,alpha_c} : state,exp : exp) =
	if (Alpha.is_empty alpha_e) andalso (Alpha.is_empty alpha_c)  then NORECURSE
	else
	  (case exp
	     of Var_e var =>
	       (if Alpha.renamed (alpha_e,var) then
		  CHANGE_NORECURSE(state,Var_e (Alpha.substitute(alpha_e,var)))
		else
		  NORECURSE)
	      | _ => NOCHANGE)

      val all_handlers =
	let
	  val h = set_conhandler default_handler conhandler
	  val h = set_exphandler h exphandler
	  val h = set_con_binder h con_var_bind
	  val h = set_exp_binder h exp_var_bind
	in
	  h
	end

      val {rewrite_exp,
	   rewrite_con,
	   rewrite_kind,...} = rewriters all_handlers

      fun rewriteItem_e rewriter alpha item =
	if Alpha.is_empty alpha then item
	else rewriter {alpha_e = alpha,alpha_c = Alpha.empty_context()} item

      fun rewriteItem_c rewriter alpha item =
	if Alpha.is_empty alpha then item
	else rewriter {alpha_c = alpha,alpha_e = Alpha.empty_context()} item

      fun rewriteItem rewriter (alpha_e,alpha_c) item =
	if (Alpha.is_empty alpha_e) andalso (Alpha.is_empty alpha_c) then item
	else rewriter {alpha_c = alpha_c,alpha_e = alpha_e} item
    in
      val alphaERenameExp  = rewriteItem_e rewrite_exp

      val alphaCRenameExp  = rewriteItem_c rewrite_exp
      val alphaCRenameCon  = rewriteItem_c rewrite_con
      val alphaCRenameKind = rewriteItem_c rewrite_kind
      val alphaECRenameCon  = rewriteItem rewrite_con
      val alphaECRenameKind = rewriteItem rewrite_kind


    end


  end
