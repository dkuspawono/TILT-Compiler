(*$import Prelude Ast Source *)

signature FRONT_END = 
sig
    datatype 'a parseResult
      = EOF   
      | ERROR 
      | ABORT
      | SUCCESS of 'a

    type 'a parser = Source.inputSource -> (int * string list * 'a) parseResult

    val parse_impl : Ast.dec parser

    val parse_inter : Ast.spec list parser

end (* signature FRONT_END *)
