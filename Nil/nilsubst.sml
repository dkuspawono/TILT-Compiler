
(* This stucture implements and abstract type of substitutions, supporting
 * both simultaneuous (parallel) and sequential substitutions.  Included
 * are notions of composition of substitutions
 *)

structure NilSubst :> NILSUBST = 
  struct

    (* IMPORTS *)
    open Nil

    (* Stats *)
    val debug         = Stats.ff "nil_debug"
    val profile       = Stats.ff "nil_profile"
    val subst_profile = Stats.ff "subst_profile"

    val subtimer = fn args => fn args2 => if !profile orelse !subst_profile then Stats.subtimer args args2 else #2 args args2


    (* Option *)
    val isSome = Option.isSome

    (*Listops *)
    val foldl_acc  = Listops.foldl_acc
    val map_second = Listops.map_second
    val unzip      = Listops.unzip
    val zip        = Listops.zip

    (* NilError *) 
    val locate = NilError.locate "Subst"
    val assert = NilError.assert

    (* Util *)
    val mapopt   = Util.mapopt
    val lprintl  = Util.lprintl
    val printl   = Util.printl

    fun error s s' = Util.error (locate s) s'

    fun error' s = error "" s

    (* Name *)
    structure VarMap = Name.VarMap
    structure VarSet = Name.VarSet


    (* Thunks.  This is useful to avoid renaming things that
     * won't actually be substituted in.
     *)
    structure Delay :> SUBST_DELAY =
    struct
      datatype 'a thunk = FROZEN of (unit -> 'a) | THAWED of 'a
      type 'a delay = 'a thunk ref
      val eager = Stats.ff "subst_eager"
      fun delay thunk = ref(if (!eager)
			      then THAWED (thunk())
			    else FROZEN thunk)
      fun immediate value = ref (THAWED value)
      fun thaw (ref (THAWED v)) = v
	| thaw (r as ref(FROZEN t)) = let val v = t()
					  val _ = r := (THAWED v)
				      in  v
				      end
      fun delayed (ref (FROZEN _)) = true
	| delayed (ref (THAWED _)) = false
    end (* Delay *)
    open Delay


    type 'a map = 'a VarMap.map

    (* The definition of the types.  These are exported*)
    type con_subst = con delay map 
    type exp_subst = exp delay map 

    (* How to carry out substitutions on the various levels.  Uses the rewriter.
     *)
    local
      open NilRewrite


      type state = {esubst : exp_subst,csubst : con_subst}

      fun substitute (s,var) = VarMap.find (s,var)

      fun is_empty s = (VarMap.numItems s) = 0

      fun empty ()   = VarMap.empty

      (* What to do with constructors.  If the constructor is a variable,
       * see if it is in the subst.  If it is a projection, you might as
       * well beta-reduce it.  (This turns out to be a big win) 
       *)
      fun conhandler (state : state as {csubst,...},con : con) =
	(case con
	   of Var_c var => 
	     (case substitute (csubst,var)
		of SOME con_delay => 
		  CHANGE_NORECURSE (state,thaw con_delay)
		 | _ => NORECURSE)
	    | (Proj_c (Var_c var,label)) => 
	     (case substitute (csubst,var)
		of SOME con_delay => 
		  let val con2 = thaw con_delay
		      val res = (case con2 of
				   (Crecord_c entries) => 
				     #2(valOf(List.find (fn ((l,_)) => Name.eq_label (l,label)) entries ))
				 | _ => Proj_c(con2,label))
		  in CHANGE_NORECURSE (state,res)
		  end
		 | _ => NORECURSE)
	    | _ => NOCHANGE)

      (* What to do with an exp.
       *)
      fun exphandler (state : state as {esubst,...},exp : exp) =
	(case exp
	   of Var_e var => 
	     (case substitute (esubst,var)
		of SOME exp_delay => CHANGE_NORECURSE (state,thaw exp_delay)
		 | _ => NORECURSE)
	    | _ => NOCHANGE)

      (* Set the handlers, starting with a default handler
       *)
      val exp_con_handler = 
	let
	  val h = set_conhandler default_handler conhandler
	  val h = set_exphandler h  exphandler
	in h 
	end

      (* Generate the rewriters.
       *)
      val {rewrite_con = substExpConInCon',
	   rewrite_exp = substExpConInExp',
	   rewrite_kind = substExpConInKind',
           rewrite_cbnd = substExpConInCBnd',
           rewrite_bnd = substExpConInBnd',
	   rewrite_trace = substExpConInTrace',...} = rewriters exp_con_handler
 
      fun empty_state (esubst : exp_subst,csubst : con_subst) : state = 
	{esubst = esubst, csubst = csubst}

      (* Given a rewriter, carry out an expression and constructor
       * substitution in an item
       *)
      fun substExpConInXXX substituter (esubst,csubst) item = 
	let
	  val item =  	
	    if (is_empty esubst) andalso (is_empty csubst) then item 
	    else substituter (empty_state (esubst,csubst)) item
	in item
	end

      (* Given a rewriter, carry out an expression substitutions
       *)
      fun substExpInXXX substituter esubst item =
	if (is_empty esubst) then item
	else substituter (empty_state (esubst, empty())) item

      (* Given a rewriter, carry out a constructor substitutions
       *)
      fun substConInXXX substituter csubst item =
	if (is_empty csubst) then item
	else substituter (empty_state (empty(), csubst)) item

    in
      val substConInCon   = fn s => subtimer("Subst:substConInCon",  substConInXXX substExpConInCon' s)
      val substExpInExp   = fn s => subtimer("Subst:substExpInExp",  substExpInXXX substExpConInExp' s)
      val substExpInCon   = fn s => subtimer("Subst:substExpInCon",  substExpInXXX substExpConInCon' s)
      val substConInExp   = fn s => subtimer("Subst:substConInExp",  substConInXXX substExpConInExp' s)
      val substConInKind  = fn s => subtimer("Subst:substConInKind", substConInXXX substExpConInKind' s)
      val substExpInKind  = fn s => subtimer("Subst:substExpInKind", substExpInXXX substExpConInKind' s)
      val substConInTrace = fn s => subtimer("Subst:substConInTrace",substConInXXX substExpConInTrace' s) 

      val substExpConInExp  = fn s => subtimer("Subst:substExpConInExp", substExpConInXXX(substExpConInExp') s)
      val substExpConInCon  = fn s => subtimer("Subst:substExpConInCon", substExpConInXXX(substExpConInCon') s) 
      val substExpConInKind = fn s => subtimer("Subst:substExpConInKind",substExpConInXXX(substExpConInKind') s) 

      (* Bnds are a bit different, since the rewriter rewrites a bnd to a bnd list
       *)
      fun substConInCBnd csubst bnd = 
	let
	  val bnd = 
	    if is_empty csubst then bnd
	    else
	      case substExpConInCBnd' (empty_state (empty(), csubst)) bnd
		of ([bnd],state) => bnd
		 | _ => error "substConInCBnd" "Substitution should not change number of bnds"
	in
	  bnd
	end

      fun substConInBnd csubst bnd = 
	let
	  val bnd = 
	    if is_empty csubst then bnd
	    else
	      case substExpConInBnd' (empty_state (empty(), csubst)) bnd
		of ([bnd],state) => bnd
		 | _ => error "substConInBnd" "Substitution should not change number of bnds"
	in
	  bnd
	end
      val substConInBnd = fn s => subtimer("Subst:substExpConInBnd",substConInBnd s)
      val substConInCBnd = fn s => subtimer("Subst:substExpConInCbnd",substConInCBnd s)

    end  


    (* Here we define the abstract interface for substitutions.  This section 
     * defines the bits that are generic to all levels in a functor parameterized 
     * by the actual substitution functions, which are level specific. 
     *)
    structure Help =
    struct
	structure Delay = Delay
	val error = error
    end

    (* Instantiate the functor for constructors*)
    structure C = SubstFn(structure Help = Help
			  type item = con
			  type item_subst = con_subst
			  val substItemInItem = substConInCon
			  val renameItem = NilRename.renameCon
			  val printer = Ppnil.pp_con)
      
    (* Instantiate the functor for expressions*)
    structure E = SubstFn(structure Help = Help
			  type item = exp
			  type item_subst = exp_subst
			  val substItemInItem = substExpInExp
			  val renameItem = NilRename.renameExp
			  val printer = Ppnil.pp_exp)

    (*Substitutions for one variable
     *)
    local 
      fun renameCon (con :con) : con delay = delay (fn () => NilRename.renameCon con)
      fun renameExp (exp :exp) : exp delay = delay (fn () => NilRename.renameExp exp)

      fun item_insert (s,var,delay) = 
	VarMap.insert(s,var,delay)
    in
      fun varConExpSubst var con exp   = substConInExp  (item_insert(C.empty(),var,renameCon con)) exp
      fun varConConSubst var con con2  = substConInCon  (item_insert(C.empty(),var,renameCon con)) con2
      fun varConKindSubst var con kind = substConInKind (item_insert(C.empty(),var,renameCon con)) kind

      fun varExpExpSubst var exp1 exp2 = substExpInExp  (item_insert(E.empty(),var,renameExp exp1)) exp2
      fun varExpConSubst var exp con   = substExpInCon  (item_insert(E.empty(),var,renameExp exp))  con
      fun varExpKindSubst var exp kind = substExpInKind (item_insert(E.empty(),var,renameExp exp))  kind
    end

  end
