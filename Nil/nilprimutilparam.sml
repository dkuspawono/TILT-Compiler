(*$import NIL PRIMUTILPARAM *)
functor NilPrimUtilParam(structure Nil : NIL)
    :> PRIMUTILPARAM where type con = Nil.con 
		       and type exp = Nil.exp 
		       and type intsize = Nil.Prim.intsize
		       and type floatsize = Nil.Prim.floatsize 
		       and type ('con,'exp) value = ('con,'exp) Nil.Prim.value =
    struct

	open Nil
	open Prim

	type con = con
	type exp = exp
	type ('con,'exp) value = ('con,'exp) Prim.value

	fun partial_arrow (cons,c2) = AllArrow_c(Code,Partial,[],cons,0w0,c2)
	fun total_arrow (cons,c2) = AllArrow_c(Code,Total,[],cons,0w0,c2)
	fun con_int is = Prim_c(Int_c is,[])
	fun con_uint is = Prim_c(Int_c is,[])
	fun con_float fs = Prim_c(Float_c fs,[])
	fun con_array c = Prim_c(Array_c,[c])
	fun con_ref c = Prim_c(Ref_c,[c])
	fun con_vector c = Prim_c(Vector_c,[c])
	fun con_tag c = Prim_c(Exntag_c,[c])
	val con_bool = Prim_c(Sum_c{tagcount=0w2,totalcount=0w2,known=NONE},[Crecord_c[]])
	val con_unit = Prim_c(Record_c [], [])
	val unit_value = Prim_e(NilPrimOp(record []),[],[])

	fun exp2value (Const_e v) = SOME v
	  | exp2value _ = NONE

	val value2exp = Const_e
	    
	fun generate_tuple_symbol (i : int) = Symbol.labSymbol(Int.toString i)
	fun generate_tuple_label (i : int) = Name.symbol_label(generate_tuple_symbol i)
	fun con_tuple clist = 
	    let val labels = Listops.mapcount (fn (i,_) => generate_tuple_label(i+1)) clist
	    in Prim_c(Record_c labels,clist)
	    end
	val false_con = Prim_c(Sum_c{tagcount=0w2,totalcount=0w2,known=SOME 0w0},[Crecord_c[]])
	val true_con = Prim_c(Sum_c{tagcount=0w2,totalcount=0w2,known=SOME 0w1},[Crecord_c[]])
	val false_exp = Prim_e(NilPrimOp (inject 0w0),[false_con],[])
	val true_exp = Prim_e(NilPrimOp (inject 0w1),[true_con],[])
	fun bool2exp false = false_exp
	  | bool2exp true = true_exp

    end
