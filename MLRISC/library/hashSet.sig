signature HASH_SET =
sig

   type 'a set

   val create : { order : 'a * 'a -> order,
                  hash  : 'a -> int
                } -> int -> 'a set 

   val size       : 'a set -> int
   val bucketSize : 'a set -> int
   val isEmpty    : 'a set -> bool
   val insert     : 'a set -> 'a -> unit
   val remove     : 'a set -> 'a -> unit
   val toList     : 'a set -> 'a list
   val clear      : 'a set -> unit
   val contains   : 'a set -> 'a -> bool
   val app        : ('a -> unit) -> 'a set -> unit
   val fold       : ('a * 'b -> 'b) -> 'b -> 'a set -> 'b
   val toString   : ('a -> string) -> 'a set -> string

end

(*
 * $Log$
# Revision 1.1  99/02/17  21:17:04  pscheng
# *** empty log message ***
# 
# Revision 1.1  1999/02/17  20:08:55  pscheng
# *** empty log message ***
#
 *)
