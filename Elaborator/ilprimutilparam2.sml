signature ILPRIMUTILPARAM =
sig
    include PRIMUTILPARAM
      where type con = Il.con
      where type exp = Il.exp
      where type context = Il.context

    val installHelpers : {con_bool  : Il.context -> Il.con,
			  true_exp  : Il.context -> Il.exp,
			  false_exp : Il.context -> Il.exp
			  } -> unit
end

structure IlPrimUtilParam :> ILPRIMUTILPARAM =
    struct

	open Il
	open Util
	open Prim

	type context = context
	type con = con
	type exp = exp
	type ('con,'exp) value = ('con,'exp) Prim.value
	val error = fn s => error "ilprimutilparam.sml" s

	val debug = Stats.tt("IlPrimUtilParamDebug") (* XXX *)
	fun debugdo t = if (!debug) then (t(); ()) else ()

	local
	    val Cbool : (context -> con) ref =
		ref (fn _ => error "con_bool not installed")
	    val Ctrue : (context -> exp) ref =
		ref (fn _ => error "true_exp not installed")
	    val Cfalse : (context -> exp) ref =
		ref (fn _ => error "false_exp not installed")
	in
	    fun installHelpers {con_bool : context -> con,
				true_exp : context -> exp,
				false_exp : context -> exp} : unit =
		(Cbool := con_bool;
		 Ctrue := true_exp;
		 Cfalse := false_exp)

	    (* This must agree exactly with the sum type generated for
	     * bool in Firstlude.sml
	     *)
	    fun con_bool arg = 
	      let
		val t = Name.symbol_label (Symbol.varSymbol "true")
		val f = Name.symbol_label (Symbol.varSymbol "false")
	      in
		CON_SUM {names = [f,t],
			 noncarriers = 2,
			 carrier = CON_TUPLE_INJECT [],
			 special = NONE}
	      end

	    fun true_exp arg = 
	      INJ {sumtype =con_bool arg,
		   field = 1,
		   inject = NONE}

	    fun false_exp arg = 
	      INJ {sumtype =con_bool arg,
		   field = 0,
		   inject = NONE}
				
	end

	fun partial_arrow (cons,c2) = CON_ARROW(cons,c2,false,oneshot_init PARTIAL)
	fun total_arrow (cons,c2) = CON_ARROW(cons,c2,false,oneshot_init TOTAL)
	fun generate_tuple_symbol (i : int) = Symbol.labSymbol(Int.toString i)
	fun generate_tuple_label (i : int) = Name.symbol_label(generate_tuple_symbol i)
	val unit_exp : exp = RECORD[]
	val con_unit = CON_RECORD[]

	fun bool2exp context false = false_exp context
	  | bool2exp context true = true_exp context

	fun con_tuple conlist = CON_RECORD(Listops.mapcount (fn (i,c) =>
							     (generate_tuple_label (i+1),c)) conlist)

	val con_int = CON_INT
	val con_uint = CON_UINT
	val con_float = CON_FLOAT
	val con_array = CON_ARRAY
	val con_vector = CON_VECTOR
	val con_intarray  = CON_INTARRAY
	val con_intvector = CON_INTVECTOR
	val con_floatarray  = CON_FLOATARRAY
	val con_floatvector = CON_FLOATVECTOR
	val con_ref = CON_REF
	val unit_value = unit_exp
	val con_tag = CON_TAG

	fun exp2value (SCON v) = SOME v
	  | exp2value _ = NONE

	val value2exp = SCON

    end
