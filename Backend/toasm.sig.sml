(* Translation of RTL to pre-annotated assembly *)

signature TOASM =
sig

   structure Machine : MACHINE
   structure Bblock : BBLOCK
   structure Tracetable : TRACETABLE


   val translateReg          : Rtl.reg -> Machine.register

   (* Returns list of labels for all the basic blocks, in the same
      order as the blocks appeared in the Rtl code, and the
      mapping from labels to basic blocks.

      Also returns set of registers much must be homed to the stack.
      These are registers used in COMPUTEs.*)
   val translateProc   : Rtl.proc ->
     (Machine.label list) * (Bblock.bblock Core.Labelmap.map)
     * ((Machine.register option * Tracetable.trace) Core.Regmap.map)
     * (Machine.stacklocation Core.Regmap.map)

end
