(*$import Prelude FUNSYN FORMATTER *)
(* Printing of functional proof terms *)
(* Author: Carsten Schuermann *)

signature FUNPRINT =
sig
  structure FunSyn : FUNSYN
  structure Formatter : FORMATTER

  val formatForBare : FunSyn.IntSyn.Dec FunSyn.IntSyn.Ctx(*FunSyn.IntSyn.dctx*) * FunSyn.For -> Formatter.format
  val formatFor : FunSyn.LFDec FunSyn.IntSyn.Ctx(*FunSyn.lfctx*) * FunSyn.For -> string list -> Formatter.format
  val formatPro : FunSyn.LFDec FunSyn.IntSyn.Ctx(*FunSyn.lfctx*) * FunSyn.Pro -> string list -> Formatter.format
  val formatLemmaDec: FunSyn.LemmaDec -> Formatter.format

  val forToString : FunSyn.LFDec FunSyn.IntSyn.Ctx(*FunSyn.lfctx*) * FunSyn.For -> string list -> string
  val proToString : FunSyn.LFDec FunSyn.IntSyn.Ctx(*FunSyn.lfctx*) * FunSyn.Pro -> string list -> string
  val lemmaDecToString : FunSyn.LemmaDec -> string
end;  (* signature PRINT *)

