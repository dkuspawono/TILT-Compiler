(*$import *)
(* TestProgram: R-017-G-ACCEPT

   TestSuite for Standard ML

   Michael Vium and Sten Schmidt
   Technical University of Denmark

   September 1994


   Note: Applicative type variable not free in C is quantified
         exp in valbind: expansive

*)


val test = let                                             (* 17, 26, 42, 35,
                                                              9, 6, *)
              val r = (fn x => (x, ref [])) (fn y => y)    (* 17, 26, 42, 35,
                                                              10, 9, 7, 14, 15,
                                                              16, 42, 35, 9, 5,
                                                              8, 9, 2, 10, 9,
                                                              3, 3, 7, 14, 15,
                                                              16, 42, 35, 9,
                                                              2, *)
           in
              let                                          (* 9, 6, *)
                 val (f,y) = r                             (* 17, 26, 42, 38,
                                                              41, 42, 35, 42,
                                                              35, 9, 2, *)
              in
                 f 3 = 3 andalso f true andalso ( y := [1]; [1] = !y)

                 (* 10, 9, 2, 5, 8, 10, 9, 2, 5, 8, 10, 9, 2, 1, 1, 10, 9, 2, 5,
                    8, 10, 9, 2, 3, 9, 7, 25, 10, 9, 2, 5, 8, 9, 2, 10,
                    9, 2, 5, 8, 9, 1, 9, 3, 10, 9, 2, 5, 8, 10, 9, 2,
                    5, 8, 9, 1, 9, 3, 10, 9, 2, 2, *)

              end
           end;


(******************************************************************************

  Expected:

       val test = true : bool;

 ******************************************************************************)


