(* The Il datatypes. *)
functor Il(structure Prim : PRIM
	   structure Tyvar : TYVAR)
  : IL = 
  struct

    open Util Listops Name
    structure Prim = Prim
    structure Tyvar = Tyvar
    open Prim

    type tag = Name.tag
    type var = Name.var
    type label = Name.label
    type labels = Name.label list
    type prim = Prim.prim
    type ilprim = Prim.ilprim

    datatype path = SIMPLE_PATH   of var 
                  | COMPOUND_PATH of var * labels

    type fixity_table = (label * Fixity.fixity) list 
    type prim = Prim.prim
    type ilprim = Prim.ilprim

    datatype arrow = TOTAL | PARTIAL

    datatype exp = OVEREXP of con * bool * exp Util.oneshot
                 | SCON    of value
                 | PRIM    of prim * con list
                 | ILPRIM  of ilprim          (* for type-checking reasons *)
                 | VAR     of var
                 | APP     of exp * exp
                 | FIX     of fbnd list * var
                 | RECORD  of rbnd list
                 | RECORD_PROJECT of exp * label * con
                 | SUM_TAIL of con * exp
                 | HANDLE  of exp * exp      (* body and handler: type ANY  *)
                 | RAISE   of con * exp
                 | LET     of bnd list * exp
                 | NEW_STAMP of con
                 | EXN_INJECT of exp * exp (* tag and value *)
                 | MK_REF  of exp
                 | GET     of exp
                 | SET     of exp * exp      (* exp1 := exp2 *)
                 | ROLL    of con * exp
                 | UNROLL  of con * exp
                 | INJ     of con list * int * exp
                 | PROJ    of con list * int * exp
                 | TAG     of tag * con
                 (* case over sum types of exp with arms and defaults*)
                 | CASE    of con list * exp * (exp option) list * exp option
                 | EXN_CASE of exp * (exp * con * exp) list * exp option
                 | MODULE_PROJECT of mod * label
                 | SEAL    of exp * con


    and     rbnd = RBND    of label * exp
    and     fbnd = FBND    of var * var * con * con * exp  (* var = (var : con) : con |-> exp *)
    and      con = CON_VAR           of var
                 | CON_TYVAR         of  con Tyvar.tyvar  (* supports type inference *)
                 | CON_OVAR          of  con Tyvar.ocon   (* supports "overloaded" types *)
                 | CON_INT           of Prim.intsize
                 | CON_UINT          of Prim.intsize
                 | CON_FLOAT         of Prim.floatsize
                 | CON_ARRAY         of con
                 | CON_VECTOR        of con
                 | CON_ANY
                 | CON_REF           of con
                 | CON_TAG           of con
                 | CON_ARROW         of con * con * (arrow Util.oneshot)
                 | CON_APP           of con * con
                 | CON_MUPROJECT       of int * con
                 | CON_RECORD        of rdec list
                 | CON_FUN           of var list * con
                 | CON_SUM           of int option * con list
                 | CON_TUPLE_INJECT  of con list
                 | CON_TUPLE_PROJECT of int * con 
                 | CON_MODULE_PROJECT of mod * label
    and     rdec = RDEC    of label * con
    and     kind = KIND_TUPLE of int
                 | KIND_ARROW of int * int
    and      mod = MOD_VAR of var
                 | MOD_STRUCTURE of sbnd list
(*                 | MOD_DATATYPE  of Ast.db list * Ast.tb list * sbnd list *)
                 | MOD_FUNCTOR of var * signat * mod
                 | MOD_APP of mod * mod
                 | MOD_PROJECT of mod * label
                 | MOD_SEAL of mod * signat
    and     sbnd = SBND of label * bnd
    and      bnd = BND_EXP of var * exp
                 | BND_MOD of var * mod
                 | BND_CON of var * con
                 | BND_FIXITY    of fixity_table  (* tracks infix precedence *)
    and   signat = SIGNAT_STRUCTURE       of sdec list
                 | SIGNAT_DATATYPE of Ast.db list * Ast.tb list * sdec list
                 | SIGNAT_FUNCTOR of var * signat * signat * (arrow Util.oneshot)
    and     sdec = SDEC of label * dec
    and      dec = DEC_EXP       of var * con
                 | DEC_MOD       of var * signat
                 | DEC_CON       of var * kind * con option 
                 | DEC_EXCEPTION of tag * con
                 | DEC_FIXITY    of fixity_table   (* tracks infix precedence *)
    withtype value = exp Prim.value

    type bnds  = bnd list
    type sdecs = sdec list
    type sbnds = sbnd list
    type decs = dec list

    datatype inline = INLINE_MODSIG of mod * signat
                    | INLINE_EXPCON of exp * con
                    | INLINE_CONKIND of con * kind
                    | INLINE_OVER   of unit -> (int -> exp) * con Tyvar.ocon

    datatype context_entry = CONTEXT_INLINE of label * var * inline    
                           | CONTEXT_SDEC   of sdec
                           | CONTEXT_SIGNAT of label * var * signat
                           | CONTEXT_SCOPED_TYVAR of Symbol.symbol list (* tracks of scoped type var *)



    datatype context = CONTEXT of context_entry list

  end
