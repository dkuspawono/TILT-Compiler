signature NILOPTS = 
sig
    val do_cse : bool ref
    val do_flatten : bool ref
    val do_reduce : bool ref 

    type click
    val make_click : string -> click
    val inc_click : click -> unit

    val init_clicks : unit -> unit
    val print_clicks : unit -> unit

    (* How many clicks have gone by since the last execution 
     of round_clicks ? *)
    val round_clicks : click list -> int
    val print_round_clicks : click list -> unit 

end 