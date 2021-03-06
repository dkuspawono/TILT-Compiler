(* bool-sig.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

signature BOOL =
  sig

    datatype bool = datatype bool
    val not : bool -> bool

    val fromString : string -> bool option
    val scan : (char, 'a) StringCvt.reader -> (bool, 'a) StringCvt.reader
    val toString   : bool -> string

  end

