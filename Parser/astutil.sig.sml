(*$import Prelude ErrorMsg Symbol Ast *)

(* Copyright 1992 by AT&T Bell Laboratories 
 *
 *)
signature ASTUTIL =
  sig

    val checkFix : int * ErrorMsg.complainer -> int

    (* BUILDS VARIOUS CONSTRUCTIONS *)
    val makeSEQdec : Ast.dec * Ast.dec -> Ast.dec

    val layered : Ast.pat * Ast.pat * ErrorMsg.complainer -> Ast.pat

    (* SYMBOLS *)
    val arrowTycon : Symbol.symbol
    val bogusID : Symbol.symbol
    val exnID : Symbol.symbol
    val symArg : Symbol.symbol
    val itsym : Symbol.symbol list

    val unitExp : Ast.exp
    val unitPat : Ast.pat

    (* QUOTES *)
    val QuoteExp : string -> Ast.exp
    val AntiquoteExp : Ast.exp -> Ast.exp

  end


(*
 * $Log$
# Revision 1.3  2000/09/12  18:56:46  swasey
# Changes for cutoff compilation
# 
# Revision 1.2  98/02/15  22:43:18  pscheng
# bootstrapping changes
# 
# Revision 1.1  1998/01/21  20:40:08  pscheng
# moved the .sig files to .sig.sml file
#
# Revision 1.1  97/03/26  18:16:02  pscheng
# added the sig file
# 
 * Revision 1.1.1.1  1997/01/14  01:38:43  george
 *   Version 109.24
 *
 *)
