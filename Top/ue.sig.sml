(*
	A unit environment is a finite map from unit names to crcs.
*)

signature UNIT_ENVIRONMENT =
sig

    type equiv = Crc.crc * Crc.crc -> bool
    type ue

    val blastOutUe : Blaster.outstream -> ue -> unit
    val blastInUe : Blaster.instream -> ue
    val pp_ue : ue -> Formatter.format

    val empty : ue

    val isEmpty : ue -> bool

    val equal : equiv -> ue * ue -> bool

    val insert : ue * string * Crc.crc -> ue

    val find : ue * string -> Crc.crc option

    (* Make no assumptions about the order. *)
    val listItemsi : ue -> (string * Crc.crc) list

    val appi : (string * Crc.crc -> unit) -> ue -> unit

    val foldi : (string * Crc.crc * 'b -> 'b) -> 'b -> ue -> 'b

    datatype ue_result =
	VALID of ue
      | WITNESS of string

    (* confine (UE1, UE2) =
     *	VALID (UE1 - UE2)	if for all u in Dom(UE1) intersect Dom(UE2), UE1(u) = UE2(u)
     *	WITNESS u		if UE1(u) <> UE2(u)
     *)
    val confine : equiv -> ue * ue -> ue_result

    (* confine' (UE1, UE2) = { (u,crc) in UE1 | u not in Dom(UE2) }
     * Ignores errors noticed by confine(UE1, UE2).
     *)
    val confine' : ue * ue -> ue

    (* plus_overlap (UE1, UE2) =
     *	VALID (UE1 union UE2)   if for all u in Dom(UE1) intersect Dom(UE2), UE1(u) = UE2(u)
     *  WITNESS u               if UE1(u) <> UE2(u).
     * Used on import unit environments.
     *)
    val plus_overlap : equiv -> ue * ue -> ue_result

    (* plus_no_overlap (UE1, UE2) =
     *	VALID (UE1 union UE2)   if Dom(UE1) intersect Dom(UE2) = empty
     *  WITNESS u               if u in Dom(UE1) intersect Dom(UE2).
     * Used on export unit environments.
     *)
    val plus_no_overlap : ue * ue -> ue_result

end
