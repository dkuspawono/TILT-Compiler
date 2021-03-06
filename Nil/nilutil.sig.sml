signature NILUTIL =
  sig
      type arrow = {openness : Nil.openness, effect : Nil.effect,
		    tFormals : (Nil.var*Nil.kind) list,
		    eFormals : Nil.con list,
		    fFormals : Nil.w32,
		    body_type : Nil.con}


    val makeLetC : Nil.conbnd list -> Nil.con -> Nil.con
    val makeLetE : Nil.letsort -> Nil.bnd list -> Nil.exp -> Nil.exp
    val makeAppE : Nil.exp -> Nil.con list -> Nil.exp list -> Nil.exp list -> Nil.exp
    val makeExpB : Nil.var * Nil.niltrace * Nil.exp -> Nil.bnd list


    (* The free??? functions take
         (1) a flag indicating whether to look inside kinds (true when not present)
         (2) an integer indicating the minimum lambda depth a free variable has to be
         (3) the object whose free variables are needed
       The free variables are returned as set.
       When 2 sets are returned, the first is the term level fvs followed by the type level ones
    *)
    val freeExpConVarInExnHandler  : bool * int * Nil.exp  -> Name.VarSet.set * Name.VarSet.set
    val freeExpConVarInExp  : bool * int * Nil.exp  -> Name.VarSet.set * Name.VarSet.set
    val freeExpConVarInCon  : bool * int * Nil.con  -> Name.VarSet.set * Name.VarSet.set
    val freeExpConVarInKind : bool * int * Nil.kind -> Name.VarSet.set * Name.VarSet.set
    val freeExpConVarInBnd  : bool * int * Nil.bnd  -> Name.VarSet.set * Name.VarSet.set
    val freeConVarInCon     : bool * int * Nil.con  -> Name.VarSet.set
    val freeConVarInCbnd    : bool * int * Nil.conbnd -> Name.VarSet.set
    val freeConVarInKind    :        int * Nil.kind -> Name.VarSet.set
    val freeVarInKind       :        int * Nil.kind -> Name.VarSet.set

    (* get the bound var from a conbnd *)
    val varBoundByCbnd : Nil.conbnd -> Nil.var

    val varsBoundByCbnds : Nil.conbnd list -> Nil.var list
    val varsBoundByBnds  : Nil.bnd list -> Nil.var list

    val generate_tuple_label : int -> Name.label

    val convert_sum_to_special : Nil.con * TilWord32.word -> Nil.con

    val flattenCbnds : Nil.conbnd list -> Nil.conbnd list    

    val flattenCLet  : Nil.con -> Nil.con

    val extractCbnd : Nil.conbnd -> Nil.var * Nil.con

    val makeConb        : Nil.conbnd -> Nil.bnd  (* Annotated as Runtime *)
    val cbnds2bnds      : Nil.conbnd list -> Nil.bnd list (* Annotated as Runtime *)

    (* Marks as Runtime *)
    val cbnds2importbnds: Nil.conbnd list -> Nil.import_entry list
    (*Bnds must all be Con_b *)
    val bnds2importbnds : Nil.bnd list -> Nil.import_entry list
  (* Given a record expression r and a list lbls
     of labels, produce the term corresponding to r.lbls *)
    val makeSelect  : Nil.exp -> Nil.label list -> Nil.exp


    val nameType : string -> Nil.con -> Nil.conbnd list * Nil.con

    (* Make a record type with bindings for all non-variable types *)
    val makeNamedRecordType : string -> Nil.label list -> Nil.con list -> Nil.conbnd list * Nil.con

    val makeNamedArrowType : string -> Nil.effect -> Nil.con -> Nil.con -> Nil.conbnd list * Nil.con

    val same_openness : Nil.openness * Nil.openness -> bool
    val same_effect   : Nil.effect * Nil.effect -> bool
    val sub_effect    : bool * Nil.effect * Nil.effect -> bool

    datatype 'a changeopt = NOCHANGE | CHANGE_RECURSE of 'a | CHANGE_NORECURSE of 'a
    type bound = {isConstr : bool,     (* Are we in a constructor?  Initially true. *)
		  level : int,
		  boundcvars : Name.VarSet.set,
		  boundevars : Name.VarSet.set}
    type handlers =
	{exphandler : bound * Nil.exp -> Nil.exp changeopt,
	 bndhandler : bound * Nil.bnd -> (Nil.bnd list) changeopt,
	 conhandler : bound * Nil.con -> Nil.con changeopt,
	 cbndhandler : bound * Nil.conbnd -> (Nil.conbnd list) changeopt,
	 kindhandler : bound * Nil.kind -> Nil.kind changeopt}

    val default_exphandler : bound * Nil.exp -> Nil.exp changeopt
    val default_bndhandler : bound * Nil.bnd -> (Nil.bnd list) changeopt
    val default_conhandler : bound * Nil.con -> Nil.con changeopt
    val default_cbndhandler : bound * Nil.conbnd -> (Nil.conbnd list) changeopt
    val default_kindhandler : bound * Nil.kind -> Nil.kind changeopt

    val exp_rewrite : handlers -> Nil.exp -> Nil.exp
    val bnd_rewrite : handlers -> Nil.bnd -> Nil.bnd list
    val kind_rewrite : handlers -> Nil.kind -> Nil.kind
    val con_rewrite : handlers -> Nil.con -> Nil.con
    val cbnd_rewrite : handlers -> Nil.conbnd -> Nil.conbnd

    val exp_size : Nil.exp -> int
    val con_size : Nil.con -> int
    val kind_size : Nil.kind -> int
    val module_size : Nil.module -> int

    val primequiv : Nil.primcon * Nil.primcon -> bool
    val covariant_prim: Nil.primcon -> bool

    val alpha_subequiv_con : bool -> Nil.con * Nil.con -> bool
    val alpha_equiv_con    : Nil.con * Nil.con -> bool
    val alpha_equiv_kind   : Nil.kind * Nil.kind -> bool

    val sub_phase : Nil.phase * Nil.phase -> bool

    val is_var_e : Nil.exp -> bool
    val is_mu_c : Nil.con -> bool

    val strip_var : Nil.con -> Nil.var option
    val strip_exntag : Nil.con -> Nil.con option
    val strip_recursive : Nil.con -> (bool * (Nil.var,Nil.con) Sequence.sequence) option
    val strip_boxfloat : Nil.con -> Prim.floatsize option
    val strip_float : Nil.con -> Prim.floatsize option
    val strip_int : Nil.con -> Prim.intsize option
    val strip_sum : Nil.con -> (Nil.w32 * Nil.w32 * Nil.w32 option * Nil.con) option
    val strip_arrow : Nil.con -> {openness : Nil.openness, effect : Nil.effect,
				  tFormals : (Nil.var*Nil.kind) list,
				  eFormals : Nil.con list,
				  fFormals : Nil.w32,
				  body_type: Nil.con} option
    val strip_externarrow : Nil.con -> (Nil.con list * Nil.con) option
    val strip_record : Nil.con -> (Nil.label list * Nil.con list) option
    val strip_crecord : Nil.con -> (Nil.label*Nil.con) list option
    val strip_proj : Nil.con -> (Nil.con*Nil.label) option
    val strip_prim : Nil.con -> (Nil.primcon*Nil.con list) option
    val strip_app : Nil.con -> (Nil.con*Nil.con list) option
    val strip_coercion : Nil.con -> {vars:Nil.var list,from:Nil.con,to:Nil.con} option

    val alpha_mu : (Nil.var -> bool) -> (Nil.var * Nil.con) list -> (Nil.var * Nil.con) list
    val is_exn_con : Nil.con -> bool
    val is_var_c : Nil.con -> bool
    val is_float_c : Nil.con -> bool
    val is_unit_c : Nil.con -> bool

    val selfify  : (Nil.con * Nil.kind) -> Nil.kind
    val selfify' : (Nil.con * Nil.kind * NilSubst.con_subst) -> Nil.kind

    val get_arrow_return : Nil.con -> Nil.con option

    (*Get the kind of a projection*)
    val project_from_kind : ((Nil.label * Nil.var), Nil.kind) Nil.sequence * Nil.con * Nil.label -> Nil.kind
    val project_from_kind_nondep : Nil.kind * Nil.label -> Nil.kind

    val is_taglike : Nil.con -> bool

    val sum_project_carrier_type : Nil.con -> Nil.con


    (* Rename the constructor parameters in an arrow type *)
    val rename_arrow : arrow * Nil.var list -> arrow

    (* Find the strongly connected components of a graph. 
     * Result is a list of list of vars and their info.
     * Each list is a scc.  The sccs are ordered such
     * that there are no edges from an earlier component 
     * to a later one (the opposite of the ordering returned 
     * by GraphUtil).
     *)
    val scc : ((Nil.var * 'info) * Name.VarSet.set) list -> (Nil.var * 'info) list list 

    (* Break a fix binding into its strongly connected components *)
    val break_fix : ((Nil.var * Nil.con) * Nil.function) list -> ((Nil.var * Nil.con) * Nil.function) list list 

  end
