(*$import TopLevel MLRISC_REGION *)


(* =========================================================================
 * AlphaMLRISCRegion.sml
 * ========================================================================= *)

structure AlphaMLRISCRegion
	    :> MLRISC_REGION
	    = struct

  (* -- types -------------------------------------------------------------- *)

  type region = unit

  (* -- values ------------------------------------------------------------- *)

  val stack  = ()
  val memory = ()

  (* -- functions ---------------------------------------------------------- *)

  fun toString _ = ""

end

