functor PrimUtil(structure Prim : PRIM
		 structure Ppprim : PPPRIM
		 structure PrimUtilParam : PRIMUTILPARAM
		 sharing Ppprim.Prim = Prim
		 sharing type PrimUtilParam.value = Prim.value
		 sharing type PrimUtilParam.intsize = Prim.intsize
		 sharing type PrimUtilParam.floatsize = Prim.floatsize)
    : PRIMUTIL =

struct

    structure Prim = Prim
    open Util  
    open PrimUtilParam Prim
    type con = con
    type exp = PrimUtilParam.exp
    type value = (con,exp) Prim.value
    val error = fn s => error "primutil.sml" s
    structure Float = Real64

    val con_string = con_vector(con_uint W8)
    fun value_type exp_typer scon : con = 
	(case scon of
	     (int (is,_)) => con_int is
	   | (uint (is,_)) => con_uint is
	   | (float (fs,_)) => con_float fs
	   | (array (c,_)) => con_array c
	   | (vector (c,_)) => con_vector c
	   | (refcell (ref e)) => con_ref (exp_typer e)
	   | (tag (_,c)) => con_tag c)

  fun get_type prim cons =
     let 
	 fun help (arg,res) = (false,[arg],res)
	 fun help' (args,res) = (false,args,res)
	 fun thelp (arg,res) = (true,[arg],res)
	 fun thelp' (args,res) = (true,args,res)
     in
	 (case (prim,cons) of
	 ((soft_vtrap _ | soft_ztrap _ | hard_vtrap _ | hard_ztrap _),[]) => (false,[],con_unit)
       | (mk_ref, [instance]) => thelp(instance,con_ref instance)
       | (deref, [instance]) => thelp(con_ref instance,instance)
(*	      | SIZE => help(con_string, con_int)
	      | CHR  => help(con_int, con_char)
	      | ORD  => help(con_char, con_int)
	      | EXPLODE => help(CON_VECTOR con_char, CON_LIST con_char)
	      | IMPLODE => help(CON_LIST con_char, CON_VECTOR con_char) *)
(* | SQRT | SIN | COS | ARCTAN | EXP | LN *)
       | ((neg_float fs | abs_float fs),[]) => help(con_float fs, con_float fs)
       | ((not_int is | neg_int is | abs_int is),[]) => help(con_int is, con_int is)
       | (float2int,[]) => help(con_float F64, con_int W32)
       | (int2float,[]) => help(con_int W32, con_float F64)
       | (int2uint(is1,is2),[]) => help(con_int is1, con_uint is2)
       | (uint2int(is1,is2),[]) => help(con_uint is1, con_int is2)
       | (uinta2uinta(is1,is2),[]) => help(con_array(con_uint is1), con_array(con_uint is2))
       | (uintv2uintv(is1,is2),[]) => help(con_vector(con_uint is1), con_vector(con_uint is2))

       | (open_in,[]) => help(con_string, con_int W32)
       | (input,[]) => help'([con_int W32, con_int W32], con_vector (con_uint W8))
       | (input1,[]) => help(con_int W32, con_uint W8)
       | (lookahead,[]) => help(con_int W32, con_uint W8)
       | (end_of_stream,[]) => help(con_int W32, con_bool)
       | (open_out,[]) => help(con_string, con_int W32)
       | (close_in,[]) => help(con_int W32, con_unit)
       | (output,[]) => help'([con_int W32, con_vector (con_uint W8)], con_unit)
       | (flush_out,[]) => help(con_int W32, con_unit)
       | (close_out,[]) => help(con_int W32, con_unit)

(*	      | ISNIL {instance} => help(CON_LIST instance, con_bool)
	      | CAR {instance} => help(CON_LIST instance, instance)
	      | CDR {instance} => help(CON_LIST instance, CON_LIST instance)
	      | OPEN_IN => raise UNIMP
	      | OPEN_OUT => raise UNIMP
	      | INPUT => raise UNIMP
	      | LOOKAHEAD => raise UNIMP
	      | CLOSE_IN => raise UNIMP
	      | END_OF_STREAM => raise UNIMP
	      | CLOSE_OUT => raise UNIMP
	      | USE => raise UNIMP
	      | FLUSH_OUT => raise UNIMP *)


(*	      | length2 {instance} => raise UNIMP *)

(*	     and  => help'([con_bool,con_bool],con_bool) *)
	| (setref, [instance]) => thelp'([con_ref instance,instance],con_unit)
(*	   | or  => help'([con_bool,con_bool],con_bool) 
	   | eq_bool  => help'([con_bool,con_bool],con_bool)
	   | xor  => help'([con_bool,con_bool],con_bool) *)
	| (eq_ref, [instance]) => help'([con_ref instance, con_ref instance],con_bool)
(*	   | string_concat => help'([con_string,con_string],con_string) *)
(*	| ((eq_char | neq_char),[]) => help'([con_char,con_char],con_bool) *)
(*	   | (eq_string | neq_string) => help'([con_string,con_string],con_bool) *)
	 | ((plus_float fs | minus_float fs | mul_float fs | 
	      div_float fs),[]) => help'([con_float fs, con_float fs], con_float fs)
	 | ((less_float fs | greater_float fs |
	       lesseq_float fs | greatereq_float fs | 
	       eq_float fs | neq_float fs),[])  => help'([con_float fs, con_float fs], con_bool)
	 | ((plus_int is | minus_int is | mul_int is | 
	       div_int  is | mod_int is | 
	       quot_int is | rem_int is),[]) => help'([con_int is, con_int is], con_int is)
	 | ((plus_uint is | minus_uint is | mul_uint is | 
	       div_uint is),[]) => help'([con_uint is, con_uint is], con_uint is)
   	  | ((less_int is | greater_int is |
	       lesseq_int is | greatereq_int is | 
	       eq_int is | neq_int is),[])  => help'([con_int is, con_int is], con_bool)
	  | ((lshift_int is | rshift_int is),[]) => help'([con_int is, con_int W32], con_int is)
	  | (rshift_uint is,[]) => help'([con_uint is, con_int W32], con_uint is)
	  | ((and_int is | or_int is),[]) => help'([con_uint is, con_uint is], con_uint is)
	   | ((less_uint is | greater_uint is |
	       lesseq_uint is | greatereq_uint is),[]) => help'([con_uint is, con_uint is], con_bool)
(*	  | cons {instance} => help'([instance,con_list instance],con_list instance) *)

	     | (((array2vector aggregate) | (create_table aggregate) | 
		 (length_table aggregate) | (sub aggregate) | (update aggregate) | 
		 (equal_table aggregate)), cons) =>
	     let fun create_array instance = thelp'([con_uint W32, instance], con_array instance)
		 fun create_vector instance = thelp'([con_uint W32, instance], con_vector instance)
		 fun len_array instance = thelp(con_array instance, con_uint W32)
		 fun len_vector instance = thelp(con_vector instance, con_uint W32)
		 fun sub_array instance = thelp'([con_array instance, con_uint W32], instance)
		 fun sub_vector instance = thelp'([con_vector instance, con_uint W32], instance)
		 fun update_array instance =  thelp'([con_array instance, con_uint W32, instance], con_unit)
		 fun update_vector instance =  thelp'([con_vector instance, con_uint W32, instance], con_unit)
		 fun eq_array instance = help'([con_array instance, con_array instance],con_bool)
		 fun eq_vector instance = help(partial_arrow(con_tuple [instance, instance],con_bool),
					       partial_arrow(con_tuple [con_vector instance, 
									con_vector instance],con_bool))
		 fun array2vector_array instance = thelp(con_array instance, con_vector instance)
		 fun do_array instance = 
		     (case prim of
			  create_table _ => create_array instance
			| length_table _ => len_array instance
			| sub _ => sub_array instance
			| update _ => update_array instance
			| equal_table _ => eq_array instance
			| array2vector _ => array2vector_array instance
			| _ => error "pattern impossibility")
		 fun do_vector instance = 
		     (case prim of
			  create_table _ => create_vector instance
			| length_table _ => len_vector instance
			| sub _ => sub_vector instance
			| update _ => update_vector instance
			| equal_table _ => eq_vector instance
			| array2vector _ => error "no you're not turning a vector back to an array"
			| _ => error "pattern impossibility")

	     in  (case (aggregate,cons) of
		      (WordArray, [instance]) => do_array instance
		    | (WordVector, [instance]) => do_vector instance
		    | (PtrArray, [instance]) => do_array instance
		    | (PtrVector, [instance]) => do_vector instance
		    | (IntArray is, []) => do_array (con_uint is)
		    | (IntVector is, []) => do_vector (con_uint is)
		    | (FloatArray fs, []) => do_array (con_float fs)
		    | (FloatVector fs, []) => do_vector (con_float fs)
		    | _ => error "ill-formed table primitive")
	     end


	  | _ => (Ppprim.pp_prim prim;
		  error "can't get type")
(*	   | array2  {instance} => raise UNIMP
	   | SUB2    {instance} => raise UNIMP *) )

(*	 | 4 p =>
	     (case p of
		UPDATE2 {instance} => raise UNIMP) *)

     end

  fun get_iltype ilprim _ =
      (case ilprim of
	   (not_uint is) => (false,[con_uint is], con_uint is)
	 | (and_uint is | or_uint is) => (false,[con_uint is, con_uint is], con_uint is)
	 | (lshift_uint is) => (false,[con_uint is, con_int W32], con_uint is)
	 | (eq_uint is | neq_uint is) => (false, [con_uint is, con_uint is], con_bool))

	   
  fun get_type' prim args = 
      let val (total,incons,outcon) = get_type prim args
	  val arrow = if total then total_arrow else partial_arrow
      in  (case incons of
	       [incon] => arrow(incon,outcon)
	     | _ => arrow(con_tuple incons, outcon))
      end

  fun get_iltype' ilprim arg = 
      let val (total,incons,outcon) = get_iltype ilprim arg
	  val arrow = if total then total_arrow else partial_arrow
      in  (case incons of
	       [incon] => arrow(incon,outcon)
	     | _ => arrow(con_tuple incons, outcon))
      end

    fun apply prim cons vals = (* instance arg *)
	let 
	    fun bad s = (print "Error "; print s; print " while applying ";
			 Ppprim.pp_prim prim;
			 print "\n";
			 error "bad apply")
	    (* Some converters.  If the conversion is impossible, a type error has occurred *)
	    val exp2value = (fn e => (case (exp2value e) of
					  NONE => bad "exp2value"
					| SOME v => v))
	    fun value2float fs (float (fs',s)) = if (fs = fs')
						     then (case (Float.fromString s) of
							       NONE => bad "value2float"
							     | SOME f => f)
						 else bad "value2float"
	      | value2float _ _ = bad "value2float"
	    fun value2int is (int (is',w)) = if (is = is') then w else bad "value2int"
	      | value2int is (uint (is',w)) = if (is = is') then w else bad "value2int"
	      | value2int _ _ = bad "value2int"
	    fun value2int' is (int (is',w)) = if (is = is') then TilWord64.toInt w else bad "value2int'"
	      | value2int' is (uint (is',w)) = if (is = is') then TilWord64.toInt w else bad "value2int'"
	      | value2int' _ _ = bad "value2int'"
	    fun value2ref (refcell r) = r
	      | value2ref _ = bad "value2ref"
			     
	    val int2exp = value2exp o int
	    val float2exp = value2exp o float
	    val uint2exp = value2exp o uint

	    (* Some filters to perform Word canonicalization *)
	    fun filter is w =
		let val one = TilWord64.fromInt 1
		    val shift = (case is of
				     W8 => 8
				   | W16 => 16
				   | W32 => 32
				   | W64 => 64)
		in (is,TilWord64.andb(w,TilWord64.uminus(TilWord64.lshift(one,shift),one)))
		end

	    fun objbinary value2obj op2 = 
		(case vals of
		     [a,b] => let val obj1 = value2obj(exp2value a)
				  val obj2 = value2obj(exp2value b)
			      in value2exp(op2 (obj1,obj2))
			      end
		   | _ => bad "objbinary")
	    fun objbinary value2obj1 value2obj2 op2 = 
		(case vals of
		     [a,b] => let val obj1 = value2obj1(exp2value a)
				  val obj2 = value2obj2(exp2value b)
			      in value2exp(op2 (obj1,obj2))
			      end
		   | _ => bad "objbinary")
	    fun objunary value2obj op1 = 
		(case vals of
		     [a] => let val obj = value2obj(exp2value a)
			    in value2exp(op1 obj)
			    end
		   | _ => bad "objunary")
	    fun objpred value2obj op2 = 
		(case vals of
		     [a,b] => let val obj1 = value2obj(exp2value a)
				  val obj2 = value2obj(exp2value b)
			      in bool2exp(op2 (obj1,obj2))
			      end
		   | x => (print ("x has length " ^ (Int.toString (length x)) ^ "\n");
			   bad "objpred"))

	    fun ibinary is op2 = objbinary (value2int is) (value2int is) (int o (filter is) o op2)
	    fun iunary is op1 = objunary (value2int is) (int o (filter is) o op1)
	    fun fbinary fs op2 = objbinary (value2float fs) (value2float fs)
		                   ((fn f => (float(fs,Float.toString f))) o op2)
	    fun funary fs op1 = objunary (value2float fs)
		                   ((fn f => (float(fs,Float.toString f))) o op1)
	    fun isbinary is op2 = objbinary (value2int is) (value2int' is) (int o (filter is) o op2)

	    fun fpred fs pred = objpred (value2float fs) pred
	    fun ipred is pred = objpred (value2int is) pred

	in 
	    (case (prim,cons,vals) of
		 ((soft_vtrap _ | soft_ztrap _ 
			       | hard_vtrap _ | hard_ztrap _),[],_) => unit_value
	  | (mk_ref, [c], [a]) => value2exp(refcell(ref a))
	  | (deref, [c], [a]) => !(value2ref(exp2value a))
	  | (eq_ref, [c], _) => objpred value2ref (op =)
	  | (setref, [c], [loc1,exp2]) => ((value2ref(exp2value(loc1))) := exp2; unit_value)

	  | (float2int, [], _) => objunary (value2float F64)
	                                (fn f => (int(W32,TilWord64.fromInt(floor f))))
	  | (int2float, [], [v]) => objunary (value2int W32)
					(fn w => (float(F64,Float.toString(real(TilWord64.toInt w)))))
	  | (int2uint(is1,is2), [], [v]) => objunary (value2int is1) (fn w => uint(is2,w))
	  | (uint2int(is1,is2), [], [v]) => objunary (value2int is1) (fn w => int(is2,w))
	  | (uinta2uinta(is1,is2),_,_) => error "UNIMP"
	  | (uintv2uintv(is1,is2),_,_) => error "UNIMP"

	  | (neg_float fs, [], _) => funary fs (op ~)
	  | (plus_float fs, [], _) => fbinary fs (op +)
	  | (minus_float fs, [], _) => fbinary fs (op -) 
	  | (mul_float fs, [], _) => fbinary fs (op * )
	  | (div_float fs, [], _) => fbinary fs (op /)
	  | (less_float fs, [], _) => fpred fs (op <)
	  | (greater_float fs, [], _) => fpred fs (op >)
	  | (lesseq_float fs, [], _) => fpred fs (op <=)
	  | (greatereq_float fs, [], _) => fpred fs (op >=)
	  | (eq_float fs, [], _) => fpred fs (Real.==)
	  | (neq_float fs, [], _) => fpred fs (not o (Real.==))
					
	  | (plus_int is, [], _) => ibinary is TilWord64.splus
	  | (minus_int is, [], _) => ibinary is TilWord64.sminus
	  | (mul_int is, [], _) => ibinary is TilWord64.smult
	  | (div_int is, [], _) => ibinary is TilWord64.sdiv
	  | (mod_int is, [], _) => ibinary is TilWord64.smod
	  | (quot_int is, [], _) => ibinary is TilWord64.squot
	  | (rem_int is, [], _) => ibinary is TilWord64.smod

	  | (lshift_int is, [], _) => isbinary is TilWord64.lshift
	  | (rshift_int is, [], _) => isbinary is TilWord64.rshifta
	  | (rshift_uint is, [], _) => isbinary is TilWord64.rshiftl
	  | (neg_int is, [], _) => iunary is TilWord64.snegate
	  | (abs_int is, [], _) => iunary is TilWord64.absolute
	  | (not_int is, [], _) => iunary is TilWord64.notb
	  | (and_int is, [], _) => ibinary is TilWord64.andb
	  | (or_int is, [], _) => ibinary is TilWord64.orb
					
	  | (less_int is, [], _) => ipred is TilWord64.slt
	  | (greater_int is, [], _) => ipred is TilWord64.sgt
	  | (lesseq_int is, [], _) => ipred is TilWord64.slte
	  | (greatereq_int is, [], _) => ipred is TilWord64.sgte
	  | (eq_int is, [], _) => ipred is TilWord64.equal
	  | (neq_int is, [], _) => ipred is TilWord64.nequal
					
	  | (less_uint is, [], _) => ipred is (TilWord64.ult)
	  | (greater_uint is, [], _) => ipred is (TilWord64.ugt)
	  | (lesseq_uint is, [], _) => ipred is (TilWord64.ulte)
	  | (greatereq_uint is, [], _) => ipred is (TilWord64.ugte)
					
	  | (length_table _, [instance], _) => raise UNIMP
	  | (sub _,_,_)  => raise UNIMP
	  | (create_table _,_,_)  => raise UNIMP
	  | (update _, _, _) => raise UNIMP
	  | (equal_table _, _,_)  => raise UNIMP

	  | (output,_,[e]) => 
		(case (exp2value e) of
		     vector(_,a) =>
			 (case (PrimUtilParam.exp2value(Array.sub(a,0))) of
			      SOME(uint(W8,_)) => 
				  let fun folder(e,acc) = 
				      (case (PrimUtilParam.exp2value e) of
					   SOME(uint(W8,c)) => (chr(TilWord64.toInt c))::acc
					 | _ => error "bad vector value: corrupt string")
				  in  print(implode((Array.foldr folder [] a)));
				      unit_value
				  end
			    | _ => bad "output")
		   | _ => bad "output")
	  | (input,_,_) => error "UNIMP"
	  | (input1,_,_) => error "UNIMP"
	  | (open_in,_,_) => error "UNIMP"
	  | (open_out,_,_) => error "UNIMP"
	  | (close_in,_,_) => error "UNIMP"
	  | (close_out,_,_) => error "UNIMP"
	  | (lookahead,_,_) => error "UNIMP"
	  | (end_of_stream,_,_) => error "UNIMP"
	  | (flush_out,_,_) => error "UNIMP"

	  | _ => bad "general"())
	end

  fun same_intsize (size1,size2) = 
    (case (size1,size2)
       of (Prim.W8,Prim.W8) => true
	| (Prim.W16,Prim.W16) => true
	| (Prim.W32,Prim.W32) => true
	| (Prim.W64,Prim.W64) => true
	| _ => false)

  fun same_floatsize (size1,size2) =
    (case (size1,size2)
       of (Prim.F32,Prim.F32) => true
	| (Prim.F64,Prim.F64) => true
	| _ => false)
    
(*
    fun applyil  vals = 
	let 
	in
	    (case (,cons,vals) of
	  | (PLUS_uint, [], _) => uibinary (Word32.+)
	  | (MINUS_uint, [], _) => uibinary (Word32.-)
	  | (MUL_uint, [], _) => uibinary (Word32.* )
	  | (DIV_uint, [], _) => uibinary (Word32.div)
	  | (MOD_uint, [], _) => uibinary (Word32.mod)
	  | (LSHIFT_uint, [], _) => uibinary (fn (w1,w2) => Word32.<<(w1,Word31.fromLargeWord w2))
	  | (RSHIFT_uint, [], _) => uibinary (fn (w1,w2) => Word32.>>(w1,Word31.fromLargeWord w2))
	  | (AND_uint, [], _) => uibinary (Word32.andb)
	   | (OR_uint, [], _) => uibinary (Word32.orb)

	end
*)

end
