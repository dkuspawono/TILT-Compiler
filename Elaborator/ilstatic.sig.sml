(* Static Semantics of the IL. *)
signature ILSTATIC =
  sig

    val trace : bool ref
    val debug : bool ref

    val installHelpers : {eq_compile : Il.context * Il.con -> (Il.exp * Il.con) option}
	                 -> unit

    val reduce_signat : Il.context -> Il.signat -> Il.signat

    (* ------------ functions that manipulate constructors --------------------
       eq_onearrow: returns true if the arrows are equal: will set the oneshot if needed
       eq_con: returns true if the types are equal: will set tyvars to ensure equality
       soft_eq_con: a version of eq_con that will not set any tyvars
       sub_con: tests whether the first constructor is a subtype of the second
       semi_sub_con: a version of sub_con that will not set any tyvars if not true
       con_head_normalize: returns an equivalent constructor in head-normal form
       con_normalize: returns an equivalent constructor in normal form
       eq_exp: alpha equivalence of expressions
    *)
    val eq_onearrow        : Il.arrow Util.oneshot * Il.arrow Util.oneshot -> bool
    val eq_con             : Il.context * Il.con * Il.con -> bool
    val soft_eq_con        : Il.context * Il.con * Il.con -> bool
    val sub_con            : Il.context * Il.con * Il.con -> bool
    val semi_sub_con       : Il.context * Il.con * Il.con -> bool
    val con_reduce_once    : Il.context * Il.con -> Il.con option
    val con_head_normalize : Il.context * Il.con -> Il.con
    val con_normalize      : Il.context * Il.con -> Il.con
    val eq_exp             : Il.context * Il.exp * Il.exp -> bool
    val eq_kind            : Il.kind * Il.kind -> bool

    (* ---------- Tests for well-formedness ---------------------- *)
    val Decs_Valid  : Il.context * Il.decs -> bool
    val Dec_Valid   : Il.context * Il.dec -> bool
    val Sdecs_Valid : Il.context * Il.sdecs -> bool
    val Sig_Valid   : Il.context * Il.signat -> bool

    (* --------- signature/sdec equivalence and subtyping -------- *)
    val Sdecs_IsSub   : Il.context * Il.sdecs * Il.sdecs -> bool
    val Sdecs_IsEqual : Il.context * Il.sdecs * Il.sdecs -> bool
    val Sig_IsSub     : Il.context * Il.signat * Il.signat -> bool
    val Sig_IsEqual   : Il.context * Il.signat * Il.signat -> bool

    (* ---------- Obtain types and kinds and signatures ---------- *)
    val GetExpCon     : Il.context * Il.exp  -> Il.con
    val GetConKind    : Il.context * Il.con  -> Il.kind
    val GetModSig     : Il.context * Il.mod  -> Il.signat
    val GetBndDec     : Il.context * Il.bnd  -> Il.dec
    val GetBndsDecs   : Il.context * Il.bnds -> Il.decs
    val GetSbndsSdecs : Il.context * Il.sbnds-> Il.sdecs

    (* ---------- Valuability ------------------------------------- *)
    val Module_IsValuable : Il.context * Il.mod   -> bool
    val Exp_IsValuable    : Il.context * Il.exp   -> bool
    val Bnds_IsValuable   : Il.context * Il.bnds  -> bool
    val Sbnds_IsValuable  : Il.context * Il.sbnds -> bool

    (* ----- Useful structure-related helper functions ------- *)
    (* ----- These look inside starred structures --------- *)
    val Context_Lookup_Labels : Il.context * Il.label list -> (Il.path * Il.phrase_class) option
    val Context_Lookup_Path : Il.context * Il.path -> (Il.path * Il.phrase_class) option
    val Sdecs_Lookup : Il.context -> Il.mod * Il.sdecs * Il.label list ->
	                            (Il.label list * Il.phrase_class) option

    val supertype : Il.con -> Il.con  (* compute supertype by removing total arrows and special sum types *)

  end
