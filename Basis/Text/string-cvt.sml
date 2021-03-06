(* string-cvt.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure StringCvt :> STRING_CVT =
  struct

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val unsafe_array8 = TiltPrim.unsafe_array8
    val unsafe_update8 = TiltPrim.unsafe_update8
    val unsafe_vsub8 = TiltPrim.unsafe_vsub8
    val vector_length8 = TiltPrim.vector_length8

    val unsafe_array2vector8 = TiltPrim.unsafe_array2vector8

  (* get radix and realfmt types from type-only structure *)

    datatype radix = BIN | OCT | DEC | HEX
    datatype realfmt
      = EXACT
      | SCI of int option
      | FIX of int option
      | GEN of int option
    type ('a, 'b) reader = 'b -> ('a * 'b) option

    local
      fun fillStr (c, s, i, n) = let
	    val stop = i+n
	    fun fill j = if (j < stop)
		  then (unsafe_update8(s, int32touint32 j, c);
			fill(j+1))
		  else ()
	    in
	      fill i
	    end
      fun cpyStr (src : string, srcLen, dst : TiltPrim.word8array, start) = let
	    fun cpy (i, j) = if (i < srcLen)
		  then (unsafe_update8(dst, int32touint32 j, unsafe_vsub8(src, int32touint32 i));
			cpy (i+1, j+1))
		  else ()
	    in
	      cpy (0, start)
	    end
    in
	fun padLeft padChr wid s =
	    let
		val len = PreString.size s
		val pad = wid - len
	    in
		if (pad > 0)
		    then let
			     val s' = unsafe_array8(int32touint32 wid,#"\000")
			 in
			     fillStr (padChr, s', 0, pad);
			     cpyStr (s, len, s', pad);
			     unsafe_array2vector8 s'
			 end
		else s
	    end
	fun padRight padChr wid s =
	    let
		val len = PreString.size s
		val pad = wid - len
	    in
		if (pad > 0)
		    then let
			     val s' = unsafe_array8(int32touint32 wid,#"\000")
			 in
			     fillStr (padChr, s', len, pad);
			     cpyStr (s, len, s', 0);
			     unsafe_array2vector8 s'
			 end
		else s
	    end
    end (* local *)

    fun revImplode' (0,_) = ""
      | revImplode' x = PreString.revImplode x

    fun splitl pred getc rep = let
	  fun lp (n, chars, rep) = (case (getc rep)
		 of NONE => (revImplode'(n, chars), rep)
		  | SOME(c, rep') => if (pred c)
		      then lp(n+1, c::chars, rep')
		      else (revImplode'(n, chars), rep)
		(* end case *))
	  in
	    lp (0, [], rep)
	  end
    fun takel pred getc rep = let
	  fun lp (n, chars, rep) = (case (getc rep)
		 of NONE => revImplode'(n, chars)
		  | SOME(c, rep) => if (pred c)
		      then lp(n+1, c::chars, rep)
		      else revImplode'(n, chars)
		(* end case *))
	  in
	    lp (0, [], rep)
	  end
    fun dropl pred getc = let
	  fun lp rep = (case (getc rep)
		 of NONE => rep
		  | SOME(c, rep') => if (pred c) then lp rep' else rep
		(* end case *))
	  in
	    lp
	  end

    fun skipWS (getc : 'a -> (char * 'a) option) = let
          fun isWS (#" ") = true
            | isWS (#"\t") = true
            | isWS (#"\n") = true
            | isWS _ = false
          fun lp cs = (case (getc cs)
                 of (SOME(c, cs')) => if (isWS c) then lp cs' else cs
                  | NONE => cs
                (* end case *))
          in
            lp
          end

  (* the cs type is the type used by scanString to represent a stream of
   * characters; we use the current index in the string being scanned.
   *)
    type cs = int
     fun scanString (scanFn : (char, cs) reader -> ('a, cs) reader) s =
	 let
	     val n = uint32toint32(vector_length8 s)
	     fun getc i =
		 if (i < n) then SOME(unsafe_vsub8(s, int32touint32 i), i+1) else NONE
	 in
	     case (scanFn getc 0) of
		 NONE => NONE
	       | SOME(x, _) => SOME x
	 end
  end
