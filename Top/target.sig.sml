(*$import Prelude *)

signature TARGET =
sig

    val littleEndian : bool ref		(* Is target little endian? *)
	
    datatype platform = TIL_ALPHA | TIL_SPARC (* | MLRISC_ALPHA | MLRISC_SPARC *)

    val setTargetPlatform : platform -> unit (* also sets endian-ness *)
    val getTargetPlatform : unit -> platform 

    val platformName : platform -> string
    val platformFromName : string -> platform

    val flagNames : string list
    val platformString : unit -> string	(* depends on flags named by flagsNames *)
	
    val native : unit -> bool

    val checkNative : unit -> unit
end
