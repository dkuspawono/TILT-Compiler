(*$import Prelude StringCvt PreInt PreWord *)
(* word-sig.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)


signature WORD = 
  sig
    eqtype word

    val wordSize : int

    val toLargeWord   : word -> PreLargeWord.word
    val toLargeWordX  : word -> PreLargeWord.word
    val fromLargeWord : PreLargeWord.word -> word

    val toLargeInt   : word -> PreLargeInt.int
    val toLargeIntX  : word -> PreLargeInt.int
    val fromLargeInt : PreLargeInt.int -> word

    val toInt   : word -> int
    val toIntX  : word -> int
    val fromInt : int -> word

    val orb  : word * word -> word
    val xorb : word * word -> word
    val andb : word * word -> word
    val notb : word -> word

    val << : (word * PreWord.word) -> word
    val >> : (word * PreWord.word) -> word
    val ~>> : (word * PreWord.word) -> word

    val + : word * word -> word
    val - : word * word -> word
    val * : word * word -> word
    val div : word * word -> word
    val mod : word * word -> word

    val compare : (word * word) -> order
    val >  : word * word -> bool
    val >= : word * word -> bool
    val <  : word * word -> bool
    val <= : word * word -> bool

    val min : (word * word) -> word
    val max : (word * word) -> word

    val scan :
	  StringCvt.radix -> (char, 'a) StringCvt.reader
	    -> (word, 'a) StringCvt.reader
    val fromString : string -> word option

    val fmt : StringCvt.radix -> word -> string
    val toString   : word -> string

  end;


(*
 * $Log$
# Revision 1.1  98/03/09  19:52:51  pscheng
# added basis
# 
 * Revision 1.1.1.1  1997/01/14  01:38:18  george
 *   Version 109.24
 *
 *)