(*Non IL specific utility routines *)
signature LISTOPS = 
  sig

    (* different arities of zip and map *)
    val zip  : 'a list -> 'b list -> ('a * 'b) list
    val zip3 : 'a list -> 'b list -> 'c list -> ('a * 'b * 'c) list
    val zip4 : 'a list -> 'b list -> 'c list -> 'd list -> ('a * 'b * 'c * 'd) list
    val zip5 : 'a list -> 'b list -> 'c list -> 'd list -> 'e list -> 
                            ('a * 'b * 'c * 'd * 'e) list
    val zip6 : 'a list -> 'b list -> 'c list -> 'd list -> 'e list -> 'f list -> 
                            ('a * 'b * 'c * 'd * 'e * 'f) list

    val map2 : ('a * 'b -> 'c) -> 'a list * 'b list -> 'c list
    val map3 : ('a * 'b * 'c -> 'd) -> 'a list * 'b list * 'c list -> 'd list
    val map4 : ('a * 'b * 'c * 'd -> 'e) -> 
                'a list * 'b list * 'c list * 'd list -> 'e list
    val map5 : ('a * 'b * 'c * 'd * 'e -> 'f) -> 
                'a list * 'b list * 'c list * 'd list * 'e list -> 'f list
    val map6 : ('a * 'b * 'c * 'd * 'e * 'f -> 'g) -> 
                'a list * 'b list * 'c list * 'd list * 'e list * 'f list -> 'g list
    val mapmap    : ('a -> 'b) -> 'a list list -> 'b list list
    val mapmapmap    : ('a -> 'b) -> 'a list list list -> 'b list list list
    val map0count : (int -> 'b) -> int -> 'b list
    val mapcount  : (int * 'a -> 'b) -> 'a list -> 'b list
    val map2count : (int * 'a * 'b -> 'c) -> 'a list * 'b list -> 'c list
    val map3count : (int * 'a * 'b * 'c -> 'd) -> 'a list * 'b list * 'c list -> 'd list
    val map4count : (int * 'a * 'b * 'c * 'd -> 'e) -> 
                           'a list * 'b list * 'c list * 'd list -> 'e list
    val map5count : (int * 'a * 'b * 'c * 'd * 'e -> 'f) -> 
                           'a list * 'b list * 'c list * 'd list * 'e list -> 'f list
    val map6count : (int * 'a * 'b * 'c * 'd * 'e * 'f -> 'g) -> 
                           'a list * 'b list * 'c list * 'd list * 'e list * 'f list -> 'g list

    (* Misc list helpers *)
    val eq_list : (('a * 'a -> bool) * 'a list * 'a list) -> bool
    val eq_listlist : (('a * 'a -> bool) * 'a list list * 'a list list) -> bool
    val count : int -> int list
    val member : ''a * ''a list -> bool
    val member_eq : ('a * 'a -> bool) * 'a * 'a list -> bool
    val assoc : (''a * (''a * 'b) list) -> 'b option
    val assoc_eq : (('a * 'a -> bool) * 'a * ('a * 'b) list) -> 'b option
    val list_diff  : ''a list * ''a list -> ''a list
    val list_diff_eq  : (('a * 'a -> bool) * 'a list * 'a list) -> 'a list
    val list_inter : ''a list * ''a list -> ''a list
    val butlast : 'a list -> 'a list
    (* these are all left to right *)
    val andfold : ('a -> bool) -> 'a list -> bool
    val orfold : ('a -> bool) -> 'a list -> bool
    val andfold' : ('a * 'b -> (bool * 'b)) -> 'b -> 'a list -> bool
    val orfold' : ('a * 'b -> (bool * 'b)) -> 'b -> 'a list -> bool

    val flatten : 'a list list -> 'a list
    val transpose : 'a list list -> 'a list list
  end
