(* real64.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure Real64 :> REAL
	where type real = real
	where type Math.real = real =
struct
    val abs_float = TiltPrim.fabs
    (* Respects NaN on x86. *)
    fun float_eq (a:real, b:real) : bool =
	TiltPrim.fgte(a,b) andalso TiltPrim.fgte(b,a)
    val float_neq = not o float_eq

    structure Math = Math64
    val logb  : real -> int = fn arg => Ccall(real_logb, arg)
    val scalb : real * int -> real = fn (x,k) => (* Ccall(real_scalb, x, k) *)
	raise TiltExn.LibFail "real_scalb not implemented"

    infix 4 == !=
    type real = real

    val plus : int * int -> int = op +
    val minus : int * int -> int = op -
    val negate : int -> int = ~
    val gt : int * int -> bool = op >
    val lt : int * int -> bool = op <

    val ~ : real -> real = ~
    val op + : real * real -> real = op +
    val op - : real * real -> real = op -
    val op * : real * real -> real = op *
    val op / : real * real -> real = op /
    fun *+(a,b,c) = a*b+c
    fun *-(a,b,c) = a*b-c

    val op >  : real * real -> bool = op >
    val op <  : real * real -> bool = op <
    val op >= : real * real -> bool = op >=
    val op <= : real * real -> bool = op <=
    val op == : real * real -> bool = float_eq
    val op != : real * real -> bool = float_neq

    fun unordered(x,y) = not(x>y orelse x <= y)
    fun ?= (x, y) = (x == y) orelse unordered(x, y)

  (* The next three values are computed laboriously, partly to
   * avoid problems with inaccurate string->float conversions
   * in the compiler itself.
   *)
    val maxFinite = let
	  fun f(x,i) = if i=1023 then x else f(x*2.0, plus(i, 1))
	  val y = f(1.0,0)
	  fun g(z, y, 0) = z
	    | g(z, y, i) = g(z+y, y*0.5, minus(i, 1))
	  in
	    g(0.0,y,53)
	  end

    val minNormalPos = let
	  fun f(x) = let
		val y = x * 0.5
		in
		  if logb y = ~1023 then x else f y
		end
	  in
	    f 1.0
	  end

    val minPos = let
	  fun f(x) = let
		val y = x * 0.5
		in
		  if y == 0.0 then x else f y
                end
	  in
	    f minNormalPos
	  end


    val posInf = maxFinite * maxFinite
    val negInf = ~posInf

    fun isFinite x = negInf < x andalso x < posInf
    fun isNan x = not(x==x)
    fun isNormal x = (case logb x
	   of ~1023 => (x != 0.0)
	    | 1024 => false
	    | _ => true
	  (* end case *))

    local
	val SOME minInt = Int32.minInt
	val minInt = TiltPrim.int2float minInt
	val minInt' = minInt - 1.0

	val SOME maxInt = Int32.maxInt
	val maxInt = TiltPrim.int2float maxInt
	val maxInt' = maxInt + 1.0

	fun wrap f (r : real) : int =
	    if r == 0.0 then 0
	    else if isNan r then raise Domain
		 else if isNormal r then f r
		      else raise Overflow
    in
	val floor = wrap (fn r =>
			  if r < minInt orelse r >= maxInt'
			      then raise Overflow
			  else
			      let val a = TiltPrim.float2int r
			      in  if (TiltPrim.int2float a) <= r then a
				  else TiltPrim.iminus(a,1)
			      end)
	val trunc = wrap (fn r =>
			  if r <= minInt' orelse r >= maxInt'
			      then raise Overflow
			  else TiltPrim.float2int r)
	val ceil = wrap (fn r =>
			 if r <= minInt' orelse r > maxInt
			     then raise Overflow
			 else
			     let val a = TiltPrim.float2int r
			     in  if (TiltPrim.int2float a) >= r then a
				 else TiltPrim.iplus(a,1)
			     end)
	fun round r = floor (r + 0.5)
    end
    val abs : real -> real = abs_float
    val fromInt : int -> real = real

    (* bug: operates correctly but slowly *)
    fun fromLargeInt(x : Int32.int) =
       let val i = Int32.quot(x,2)
           val j = Int32.-(x,Int32.+(i,i))
           val i' = Int32.toInt i
	   val j' = Int32.toInt j
        in fromInt(i')*2.0+fromInt(j')
       end

     (* bug: only one rounding mode implemented *)
    fun toInt IEEEReal.TO_NEGINF = floor
      | toInt _ = raise TiltExn.LibFail "toInt supports only NEGINF rounding mode now"

      (* bug: doesn't support full range of large ints *)
    fun toLargeInt mode x = Int32.fromInt(toInt mode x)

    fun toLarge x = x
    fun fromLarge _ x = x

    fun sign x = if (x < 0.0) then ~1 else if (x > 0.0) then 1
                  else if isNan x then raise Domain else 0
    fun signBit x = (* Bug: negative zero not handled properly *)
	scalb(x, negate(logb x)) < 0.0

    fun sameSign (x, y) = signBit x = signBit y

    fun copySign(x,y) = (* may not work if x is Nan *)
           if sameSign(x,y) then x else ~x

    fun compare(x,y) = if x<y then LESS else if x>y then GREATER
                       else if x == y then EQUAL
			    else raise IEEEReal.Unordered

    fun compareReal(x,y) =
           if x<y then IEEEReal.LESS else if x>y then IEEEReal.GREATER
                       else if x == y then IEEEReal.EQUAL
			    else IEEEReal.UNORDERED


(** This proably needs to be reorganized **)
    fun class x =  (* does not distinguish between quiet and signalling NaN *)
      if signBit x
       then if x>negInf then if x == 0.0 then IEEEReal.ZERO
	                     else if logb x = ~1023
			          then IEEEReal.SUBNORMAL
			          else IEEEReal.NORMAL
	                else if x==x then IEEEReal.INF
			             else IEEEReal.NAN IEEEReal.QUIET
       else if x<posInf then if x == 0.0 then IEEEReal.ZERO
	                     else if logb x = ~1023
			          then IEEEReal.SUBNORMAL
			          else IEEEReal.NORMAL
	                else if x==x then IEEEReal.INF
			             else IEEEReal.NAN IEEEReal.QUIET

    val radix = 2
    val precision = 52

    val two_to_the_neg_1000 =
      let fun f(i,x) = if i=0 then x else f(minus(i,1), x*0.5)
       in f(1000, 1.0)
      end

    fun toManExp x =
      case logb x
	of ~1023 => if x==0.0 then {man=x,exp=0}
		    else let val {man=m,exp=e} = toManExp(x*1048576.0)
		              in {man=m,exp=minus(e,20)}
			 end
         | 1024 => {man=x,exp=0}
         | i => {man=scalb(x,negate i),exp=i}

    fun fromManExp {man=m,exp=e:int} =
      if (m >= 0.5 andalso m <= 1.0  orelse m <= ~0.5 andalso m >= ~1.0)
	then if gt(e, 1020)
	  then if gt(e, 1050) then if m>0.0 then posInf else negInf
	       else let fun f(i,x) = if i=0 then x else f(minus(i,1),x+x)
		       in f(minus(e,1020),  scalb(m,1020))
		      end
	  else if lt(e, negate 1020)
	       then if lt(e, negate 1200) then 0.0
		 else let fun f(i,x) = if i=0 then x else f(minus(i,1), x*0.5)
		       in f(minus(1020,e), scalb(m,negate 1020))
		      end
	       else scalb(m,e)  (* This is the common case! *)
      else let val {man=m',exp=e'} = toManExp m
            in fromManExp{man=m', exp=plus(e',e)}
           end

  (* This is the IEEE double-precision maxint *)
    val maxint = 4503599627370496.0


    local
    (* realround mode x returns x rounded to the nearest integer using the
     * given rounding mode.
     * May be applied to inf's and nan's.
     *)
      fun realround mode x = let
            val saveMode = TiltFc.getfc ()
            in
              TiltFc.setfc(mode,TiltFc.DOUBLE);
              if x>=0.0 then x+maxint-maxint else x-maxint+maxint
                before TiltFc.setfc saveMode
            end
    in
    val realFloor = realround TiltFc.TO_NEGINF
    val realCeil = realround TiltFc.TO_POSINF
    val realTrunc = realround TiltFc.TO_ZERO
    end

  (* realround(x) returns x rounded to some nearby integer, almost always
   * the nearest integer.
   *  May be applied to inf's and nan's.
   *)
    fun realround x = if x>=0.0 then x+maxint-maxint else x-maxint+maxint

  (* whole and split could be implemented more efficiently if we had
   * control over the rounding mode; but for now we don't.
   *)
    fun whole x = if x>0.0
		    then if x > 0.5
		      then x-0.5+maxint-maxint
		      else whole(x+1.0)-1.0
	          else if x<0.0
                    then if x < ~0.5
		      then x+0.5-maxint+maxint
		      else whole(x-1.0)+1.0
	          else x

    fun split x = let val w = whole x
                      val f = x-w
		   in if abs(f)==1.0
		     then {whole=w+f,frac=0.0}
		     else {whole=w, frac=f}
		  end

    fun realMod x = let
	  val f = x - whole x
	  in
	    if abs f == 1.0 then 0.0 else f
	  end
    nonfix rem
    fun rem(x,y) = y * #frac(split(x/y))

    fun checkFloat x = if x>negInf andalso x<posInf then x
                       else if isNan x then raise Div
			 else raise Overflow

    fun nextAfter _ = raise TiltExn.LibFail "Real.nextAfter unimplemented"

    fun min(x,y) = if x<y orelse isNan y then x else y
    fun max(x,y) = if x>y orelse isNan y then x else y

    fun toDecimal _ = raise TiltExn.LibFail "Real.toDecimal unimplemented"
    fun fromDecimal _ = raise TiltExn.LibFail "Real.fromDecimal unimplemented"

    val fmt = RealFormat.fmtReal
    val toString = fmt (StringCvt.GEN NONE)
    val scan = NumScan.scanReal
    val fromString = StringCvt.scanString scan

end
