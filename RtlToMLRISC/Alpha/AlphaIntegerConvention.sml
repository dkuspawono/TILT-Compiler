
(* =========================================================================
 * AlphaIntegerConvention.sml
 * ========================================================================= *)

structure AlphaIntegerConvention
	    :> INTEGER_CONVENTION
		 where type id = int
	    = struct

  (* -- types -------------------------------------------------------------- *)

  type id = int

  (* -- values ------------------------------------------------------------- *)

  val callPointer	= 27
  val returnPointer	= 26
  val globalPointer	= 29
  val stackPointer	= 30
  val heapPointer	= 11
  val heapLimit		= 10
  val exceptionPointer	= 9
  val exceptionArgument = 26
  val temporary1	= 28
  val temporary2	= 23

  val arguments	   = [16, 17, 18, 19, 20, 21]
  val results	   = [0]
  val callerSaves1 = [1, 2, 3, 4, 5, 6, 7, 8]
  val callerSaves2 = [22, (* 23, *) 24, 25]
  val calleeSaves  = [ (* 9, 10, 11, *) 12, 13, 14, 15]

  (*
   * we want to put 23 and 27 in available, but this gives the register
   * allocator heartburn ???
   *)
  val available = results@callerSaves1@calleeSaves@arguments@callerSaves2
  val dedicated = [9, 10, 11, 23, 26, 27, 28, 29, 30, 31]
  val preserve	= calleeSaves
  val define	= results@callerSaves1@arguments@callerSaves2
  val use	= arguments
  val escape	= results@calleeSaves

end
