(*$import TopLevel *)

(* Copyright 1989 by AT&T Bell Laboratories *)
signature INTSTRMAP =
  sig
    type 'a intstrmap
    val namednew : string * int * exn -> 'a intstrmap
    val new : int * exn -> 'a intstrmap
    val elems : 'a intstrmap -> int
    val add : 'a intstrmap -> int * string * 'a -> unit
    val rmv : 'a intstrmap -> int * string -> unit
    val map : 'a intstrmap -> int * string -> 'a
    val app : (int * string * 'a -> unit) -> 'a intstrmap -> unit
    val intStrMapToList: 'a intstrmap -> (int * string * 'a) list
    val transform : ('a -> 'b) -> 'a intstrmap -> 'b intstrmap
  end

(*
 * $Log$
# Revision 1.2  99/02/05  15:58:32  pscheng
# *** empty log message ***
# 
# Revision 1.1  1998/01/21  20:40:19  pscheng
# moved the .sig files to .sig.sml file
#
# Revision 1.1  97/03/26  18:16:04  pscheng
# added the sig file
# 
 *)
