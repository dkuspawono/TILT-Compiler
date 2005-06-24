fun print s = (Ccall(tal_print_ml_string,s);());

(* Prelude *)
(* basic overloads - extended by TopLevel *)
overload + : 'a as TiltPrim.iplus  and TiltPrim.bplus  and TiltPrim.uplus  and TiltPrim.fplus
overload - : 'a as TiltPrim.iminus and TiltPrim.bminus and TiltPrim.uminus and TiltPrim.fminus
overload * : 'a as TiltPrim.imult  and TiltPrim.bmult  and TiltPrim.umult  and TiltPrim.fmult
overload / : 'a as TiltPrim.fdiv
overload ~ : 'a as TiltPrim.ineg and TiltPrim.fneg
overload <  : 'a as TiltPrim.ilt  and TiltPrim.blt  and TiltPrim.ult  and TiltPrim.flt
overload >  : 'a as TiltPrim.igt  and TiltPrim.bgt  and TiltPrim.ugt  and TiltPrim.fgt
overload <= : 'a as TiltPrim.ilte and TiltPrim.blte and TiltPrim.ulte and TiltPrim.flte
overload >= : 'a as TiltPrim.igte and TiltPrim.bgte and TiltPrim.ugte and TiltPrim.fgte

(* fixity *)
infix  7 * / div mod
infix  6 + - ^
infixr 5 :: @
infix  4 = <> > >= < <=
infix  3 := o
infix  0 before

(* types *)
(* unit, int, word, real, char -- primitive *)
(* eqtype string -- primitive *)
(* type substring -- provided by TopLevel *)
(* exn, 'a array, 'a vector, 'a ref -- primitive *)
(* datatype bool = false | true -- primitive *)
datatype 'a option = NONE | SOME of 'a
datatype order = LESS | EQUAL | GREATER
datatype 'a list = nil | :: of 'a * 'a list

(* exceptions *)
exception Chr
exception Domain
exception Empty
exception Fail of string
exception Option
exception Size
exception Span
exception Subscript

(* values *)
(* o, before, ignore, not -- primitive *)
fun exnName (exn:exn) : string = Ccall(exnNameRuntime,exn)
fun exnMessage (exn:exn) : string= Ccall(exnMessageRuntime,exn)

fun getOpt (SOME x, _) = x | getOpt (NONE, y) = y
fun isSome (SOME _) = true | isSome NONE = false
fun valOf (SOME x) = x | valOf NONE = raise Option
fun rev l =
    let fun revappend([],x) = x
	  | revappend(hd::tl,x) = revappend(tl,hd::x)
    in  revappend(l,[])
    end

(* end prelude *)

exception Div
exception Overflow
structure TiltExn =
struct
    exception SysErr of string * int option
    exception LibFail of string
end

(* The runtime needs to know the stamps for these exceptions.  
 * See General/tal_extern.sml
 *)
val _ = Ccall(registerSubExnRuntime, Subscript)
val _ = Ccall(registerDivExnRuntime, Div)
val _ = Ccall(registerOvflExnRuntime, Overflow)
val _ = Ccall(registerSysErrExnRuntime, TiltExn.SysErr ("",NONE))
val _ = Ccall(registerLibFailExnRuntime, TiltExn.LibFail "")

structure General (*:> GENERAL where type unit = unit
			       and type exn = exn
			       and type order = order*) =
  struct

    type unit = unit
    type exn = exn

    exception Bind = Bind
    exception Chr = Chr
    exception Div = Div
    exception Domain = Domain
    exception Fail = Fail
    exception Match = Match
    exception Overflow = Overflow
    exception Size = Size
    exception Span = Span
    exception Subscript = Subscript

    val exnName = exnName
    val exnMessage = exnMessage

    datatype order = datatype order

    val ! = fn x => !x
    val op := = fn (x,y) => x := y
    val op o = op o

    val op before = (op before)
    val ignore = ignore

  end (* structure General *)


(* option.sml
 *
 * COPYRIGHT (c) 1997 AT&T Labs Research.
 *)

structure Option (*:> OPTION where type 'a option = 'a option *) =
  struct

    datatype option = datatype option

    exception Option = Option

    val getOpt = getOpt
    val isSome = isSome
    val valOf = valOf

    fun filter pred x = if (pred x) then SOME x else NONE
    fun join (SOME opt) = opt
      | join NONE = NONE
    fun map f (SOME x) = SOME(f x)
      | map f NONE = NONE
    fun mapPartial f (SOME x) = f x
      | mapPartial f NONE = NONE
    fun compose (f, g) x = map f (g x)
    fun composePartial (f, g) x = mapPartial f (g x)

  end;



(* Pre String **)
(* pre-string.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 * Some common operations that are used by both the String and
 * Substring structures.
 *
 *)

structure PreString =
  struct

    val int32touint32 = TiltPrim.int32touint32
    val int32touint8 = TiltPrim.int32touint8
    val uint32toint32 = TiltPrim.uint32toint32
    val uint8touint32 = TiltPrim.uint8touint32

    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult

    val uminus = TiltPrim.uminus
    val uplus = TiltPrim.uplus

    val unsafe_vsub = TiltPrim.unsafe_vsub8
    val vector_length = TiltPrim.vector_length8
    val unsafe_sub = TiltPrim.unsafe_sub8
    val unsafe_update = TiltPrim.unsafe_update8
    val unsafe_array = TiltPrim.unsafe_array8
    val unsafe_array2vector = TiltPrim.unsafe_array2vector8

    val unsafe_vsub32 = TiltPrim.unsafe_vsub
    val unsafe_update32 = TiltPrim.unsafe_update
    val unsafe_array32 = TiltPrim.unsafe_array
    val unsafe_array2vector32 = TiltPrim.unsafe_array2vector


    local
	val unsafeSub = unsafe_sub
	val unsafeUpdate = unsafe_update
	val unsafeUpdate32 = unsafe_update32
	fun unsafeCreate (sz : int) : TiltPrim.word8array = unsafe_array(int32touint32 sz,#"\000")
	val maxOrd = 255
    in

    datatype substring = SS of (string * int * int)

  (* allocate an uninitialized string of given length (with a size check) *)
    fun create n = if n > 0 then unsafeCreate n else raise Size

  (* a vector of single character strings *)
    val chars : string vector =
	let
	    val a = unsafe_array32 (int32touint32 (maxOrd+1),"")
	    fun next i = if (i <= maxOrd)
			     then let val s = unsafeCreate 1
				      val _ = unsafeUpdate(s, 0w0, int32touint8 i)
				      val _ = unsafeUpdate32(a, int32touint32 i, unsafe_array2vector s)
				  in  next(i+1)
				  end
			 else unsafe_array2vector32 a
	in  next 0
	end

    fun unsafeSubstring (_, _, 0w0) = ""
      | unsafeSubstring (s : string, i, 0w1) = unsafe_vsub32 (chars, uint8touint32 (unsafe_vsub (s, i)))
      | unsafeSubstring (s, i, n) =
	let
	    val ss = unsafeCreate (uint32toint32 n)
	    fun copy j = if (j = n)
			     then unsafe_array2vector ss
			 else (unsafeUpdate(ss, j, unsafe_vsub(s, uplus(i,j))); copy(uplus(j,0w1)))
	in  copy 0w0
	end

    fun size (x : string) : int = TiltPrim.uint32toint32(TiltPrim.vector_length8 x)

  (* concatenate a pair of non-empty strings *)
    fun concat2 (x, y) =
	let
	    val xl = size x
	    val yl = size y
	    val ss = create(xl+yl)
	    val xl = int32touint32 xl
	    val yl = int32touint32 yl
	    fun copyx n = if (n = xl)
			      then ()
			  else (unsafeUpdate(ss, n, unsafe_vsub(x, n)); copyx(uplus(n,0w1)))
	    fun copyy n = if (n = yl)
			      then ()
			  else (unsafeUpdate(ss, uplus(xl,n), unsafe_vsub(y,n)); copyy(uplus(n,0w1)))
	in
	    copyx 0w0; copyy 0w0;
	    unsafe_array2vector ss
	end

  (* given a reverse order list of strings and a total length, return
   * the concatenation of the list.
   *)
    fun revConcat (0, _) = ""
      | revConcat (1, lst : string list) = let
	  fun find ("" :: r) = find r
	    | find (s :: _) = s
	    | find _ = "" (** impossible **)
	  in
	    find lst
	  end
      | revConcat (totLen : int, lst : string list) =
	  let val ss = create totLen
	      fun copy ([], _) = ()
		| copy (s::r, i) =
		  let
		      val len = vector_length s
		      val i = uminus(i,len)
		      fun copy' j = if (j = len)
					then ()
				    else (
					  unsafeUpdate(ss, uplus(i,j), unsafe_vsub(s, j));
					  copy'(uplus(j,0w1)))
		  in
		      copy' 0w0;
		      copy (r, i)
		  end
	  in  copy (lst, int32touint32 totLen);
	      unsafe_array2vector ss
	  end

  (* map a translation function across the characters of a substring *)
    fun translate (tr, s, i, n) = let
	  val stop = uplus(i,n)
	  fun mkList (j, totLen, lst) = if ult(j,stop)
		then let val s' = tr (unsafe_vsub (s, j))
		  in
		    mkList (uplus(j,0w1), totLen + size s', s' :: lst)
		  end
		else revConcat (totLen, lst)
	  in
	    mkList (i, 0, [])
	  end

  (* implode a non-empty list of characters into a string where both the
   * length and list are given as arguments.
   *)
    fun implode (len, cl) =
	let
	    val ss = create len
	    fun copy ([], _) = unsafe_array2vector ss
	      | copy (c::r, i) = (unsafe_update(ss, i, c); copy(r, uplus(i,0w1)))
	in  copy (cl, 0w0)
	end

  (* implode a reversed non-empty list of characters into a string where both the
   * length and list are given as arguments.
   *)
    fun revImplode (len, cl) = let
	  val ss = create len
	  fun copy ([], _) = unsafe_array2vector ss
	    | copy (c::r, i) = (unsafe_update(ss, i, c); copy(r, uminus(i,0w1)))
	  in  copy (cl, int32touint32(len-1))
	  end

    fun isPrefix (s1, s2, i2, n2) = let
	  val n1 = vector_length s1
	  fun eq (i, j) =
		(ugte(i,n1))
		orelse ((unsafe_vsub(s1, i) = unsafe_vsub(s2, j)) andalso eq(uplus(i,0w1), uplus(j,0w1)))
	  in
	      ugte(n2,n1) andalso eq (0w0, i2)
	  end

    fun collate cmpFn (s1 : string, i1, n1, s2 : string, i2, n2) = let
	  val (n, order) =
		if (n1 = n2) then (n1, EQUAL)
		else if (n1 < n2) then (n1, LESS)
		else (n2, GREATER)
	  val n = int32touint32 n
	  fun cmp' i = if (i = n)
		then order
		else let
		  val c1 = unsafe_vsub(s1, uplus(i1,i))
		  val c2 = unsafe_vsub(s2, uplus(i2,i))
		  in
		    case (cmpFn(c1, c2))
		     of EQUAL => cmp' (uplus(i,0w1))
		      | order => order
		    (* end case *)
		  end
	  in  cmp' 0w0
	  end

    fun cmp (s1, i1, n1, s2, i2, n2) = let
	  fun cmpFn (c1, c2) =
		if (c1 = c2) then EQUAL
		else if ((c1 > c2)) then GREATER
		else LESS
	  in
	    collate cmpFn (s1, i1, n1, s2, i2, n2)
	  end

    end (* local *)

    (* getNChars : (char, 'a) reader -> ('a * int) -> (char list * 'a) option *)
    fun getNChars (getc : 'a -> (char * 'a) option) (cs, n) = let
          fun rev ([], l2) = l2
            | rev (x::l1, l2) = rev(l1, x::l2)
          fun get (cs, 0, l) = SOME(rev(l, []), cs)
            | get (cs, i, l) = (case getc cs
                 of NONE => NONE
                  | (SOME(c, cs')) => get (cs', i-1, c::l)
                (* end case *))
          in
            get (cs, n, [])
          end

  end; (* PreString *)



(* End PreString*)

(**)

(* string-cvt.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure StringCvt (*:> STRING_CVT *) =
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


(* StringCvt *)


(* bool *)
(* bool.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *)

structure Bool (*:> BOOL where type bool = bool*)  =
  struct

    datatype bool = datatype bool

    val not = not

  (* NOTE: this should probably accept a wider range of arguments, but the
   * spec hasn't been written yet.
   *)
    fun scan (getc : (char, 'a) StringCvt.reader) cs = (
	  case (getc (StringCvt.skipWS getc cs))
	   of (SOME(#"t", cs')) => (case (PreString.getNChars getc (cs', 3))
		 of (SOME([#"r", #"u", #"e"], cs'')) => SOME(true, cs'')
		  | _ => NONE
		(* end case *))
	    | (SOME(#"f", cs')) => (case (PreString.getNChars getc (cs', 4))
		 of (SOME([#"a", #"l", #"s", #"e"], cs'')) => SOME(false, cs'')
		  | _ => NONE
		(* end case *))
	    | _ => NONE
	  (* end case *))

    fun toString true = "true"
      | toString false = "false"
    val fromString = StringCvt.scanString scan

  end


(* bool *)

(* List *)
(* list.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure List (*:> LIST where type 'a list = 'a list *) =
  struct

(*
    val op +  = InlineT.DfltInt.+
    val op -  = InlineT.DfltInt.-
    val op <  = InlineT.DfltInt.<
    val op <= = InlineT.DfltInt.<=
    val op >  = InlineT.DfltInt.>
    val op >= = InlineT.DfltInt.>=
    val op =  = InlineT.=
*)
    datatype list = datatype list

    exception Empty = Empty

    fun null [] = true | null _ = false

    fun hd (h::_) = h | hd _ = raise Empty
    fun tl (_::t) = t | tl _ = raise Empty
    fun last [] = raise Empty
      | last [x] = x
      | last (_::r) = last r

    fun getItem [] = NONE
      | getItem (x::r) = SOME(x, r)

    fun nth (l,n) = let
          fun loop ((e::_),0) = e
            | loop ([],_) = raise Subscript
            | loop ((_::t),n) = loop(t,n-1)
          in
            if n >= 0 then loop (l,n) else raise Subscript
          end

    fun take (l, n) = let
          fun loop (l, 0) = []
            | loop ([], _) = raise Subscript
            | loop ((x::t), n) = x :: loop (t, n-1)
          in
            if n >= 0 then loop (l, n) else raise Subscript
          end

    fun drop (l, n) = let
          fun loop (l,0) = l
            | loop ([],_) = raise Subscript
            | loop ((_::t),n) = loop(t,n-1)
          in
            if n >= 0 then loop (l,n) else raise Subscript
          end

    fun length l = let
          fun loop(acc,[]) = acc
            | loop(acc, _::x) = loop(acc+1,x)
          in loop(0,l) end

(*
    fun rev l = let
          fun loop ([], acc) = acc
            | loop (a::r, acc) = loop(r, a::acc)
          in
	    loop (l, [])
	  end
*)
    val rev = rev

    fun op @(x,[]) = x
      | op @(x,l) = let
          fun f([],l) = l
            | f([a],l) = a::l
            | f([a,b],l) = a::b::l
            | f([a,b,c],l) = a::b::c::l
            | f(a::b::c::d::r,l) = a::b::c::d::f(r,l)
          in f(x,l) end

    fun concat [] = []
      | concat (l::r) = l @ concat r

    fun revAppend ([],l) = l
      | revAppend (h::t,l) = revAppend(t,h::l)

    fun app f = let
          fun a2 (e::r) = (f e; a2 r) | a2 [] = ()
          in a2 end

    fun map f = let
          fun m [] = []
            | m [a] = [f a]
            | m [a,b] = [f a, f b]
            | m [a,b,c] = [f a, f b, f c]
            | m (a::b::c::d::r) = f a :: f b :: f c :: f d :: m r
          in m end

    fun mapPartial pred l = let
          fun mapp ([], l) = rev l
            | mapp (x::r, l) = (case (pred x)
                 of SOME y => mapp(r, y::l)
                  | NONE => mapp(r, l)
                (* end case *))
          in
            mapp (l, [])
          end

    fun find pred [] = NONE
      | find pred (a::rest) = if pred a then SOME a else (find pred rest)

    fun filter pred l = 
      let
	fun loop (l,acc) = 
	  (case l 
	     of [] => rev acc
	      | (a::rest) => 
	       if pred a then loop (rest,a::acc)
	       else loop (rest,acc))
      in loop (l,[])
      end

    fun partition pred l = let
          fun loop ([],trueList,falseList) = (rev trueList, rev falseList)
            | loop (h::t,trueList,falseList) =
                if pred h then loop(t, h::trueList, falseList)
                else loop(t, trueList, h::falseList)
          in loop (l,[],[]) end

    fun foldr f b = let
          fun f2 [] = b
            | f2 (a::t) = f(a,f2 t)
          in f2 end

    fun foldl f b l = let
          fun f2 ([],b) = b
            | f2 (a::r,b) = f2(r,f(a,b))
          in f2 (l,b) end

    fun exists pred = let
          fun f [] = false
            | f (h::t) = pred h orelse f t
          in f end
    fun all pred = let
          fun f [] = true
            | f (h::t) = pred h andalso f t
          in f end

    fun tabulate (len, genfn) =
          if len < 0 then raise Size
          else let
            fun loop n = if n = len then []
                         else (genfn n)::(loop(n+1))
            in loop 0 end

  end (* structure List *)


(* List*)


(* NumFormat *)
(* num-format.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 * The word to string conversion for the largest word and int types.
 * All of the other fmt functions can be implemented in terms of them.
 *
 *)

structure NumFormat : sig

    val fmtWord : StringCvt.radix -> word -> string
    val fmtInt  : StringCvt.radix -> int -> string

  end = struct

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val && = TiltPrim.&&
    val >> = TiltPrim.>>

    val udiv = TiltPrim.udiv
    val umult = TiltPrim.umult
    val uminus = TiltPrim.uminus

    val ult = TiltPrim.ult

    val unsafe_vsub8 = TiltPrim.unsafe_vsub8
(*
    structure W = InlineT.Word32
    structure I = InlineT.Int31
    structure I32 = InlineT.Int32

    val op < = W.<
    val op - = W.-
    val op * = W.*
    val op div = W.div
*)

    val plus = (op +) : int * int -> int
    val less = (op <) : int * int -> bool
    val negate = ~ : int -> int

    val op < = ult
    val op - = uminus
    val op * = umult
    val op div = udiv
    val w2i = uint32toint32
    val i2w = int32touint32


    fun mkDigit (w : word) = unsafe_vsub8("0123456789abcdef", w)

    fun wordToBin w = let
	  fun mkBit w = if (&&(w, 0w1) = 0w0) then #"0" else #"1"
	  fun f (0w0, n, l) = (plus(n : int, 1), #"0" :: l)
	    | f (0w1, n, l) = (plus(n : int, 1), #"1" :: l)
	    | f (w, n, l) = f(>>(w, 1), plus(n, 1), (mkBit w) :: l)
	  in
	    f (w, 0, [])
	  end
    fun wordToOct w = let
	  fun f (w, n, l) = if (w < 0w8)
		then (plus(n, 1), (mkDigit w) :: l)
		else f(>>(w, 3), plus(n : int, 1), mkDigit(&&(w, 0wx7)) :: l)
	  in
	    f (w, 0, [])
	  end
    fun wordToDec w = let
	  fun f (w, n, l) = if (w < 0w10)
		then (plus(n, 1), (mkDigit w) :: l)
		else let val j = w div 0w10
		  in
		    f (j,  plus(n, 1), mkDigit(w - 0w10*j) :: l)
		  end
	  in
	    f (w, 0, [])
	  end
    fun wordToHex w = let
	  fun f (w, n, l) = if (w < 0w16)
		then (plus(n, 1), (mkDigit w) :: l)
		else f(>>(w, 4), plus(n, 1), mkDigit(&&(w, 0wxf)) :: l)
	  in
	    f (w, 0, [])
	  end

    fun fmtW StringCvt.BIN = wordToBin
      | fmtW StringCvt.OCT = wordToOct
      | fmtW StringCvt.DEC = wordToDec
      | fmtW StringCvt.HEX = wordToHex

    fun fmtWord radix = PreString.implode o (fmtW radix)

    fun fmtInt radix i =
      if i2w i = 0wx80000000 then "~2147483648"
      else let
	  val w32 = i2w(if less(i, 0) then negate(i) else i)
          val (n, digits) = fmtW radix w32
	in
	  if less(i, 0) then PreString.implode(plus(n,1), #"~"::digits)
	  else PreString.implode(n, digits)
	end
  end;


(* NumFormat *)

(* Char *)
(* char.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure Char (*:> CHAR
    where type char = char
    where type string = string *)=
struct

    val int32touint32 = TiltPrim.int32touint32
    val && = TiltPrim.&&
    val uplus = TiltPrim.uplus
    val ult = TiltPrim.ult
    val ilt = TiltPrim.ilt
    val igt = TiltPrim.igt
    val unsafe_sub8 = TiltPrim.unsafe_sub8
    val unsafe_update8 = TiltPrim.unsafe_update8
    val unsafe_vsub = TiltPrim.unsafe_vsub
    val unsafe_vsub8 = TiltPrim.unsafe_vsub8
    val unsafe_array8 = TiltPrim.unsafe_array8

    val itoc = TiltPrim.int32touint8
    val ctoi = ord

    type char = char
    type string = string

    val minChar : char	= itoc 0
    val maxOrd		= 255
    val maxChar	: char	= itoc maxOrd

    fun chr (i : int) : char = if 0 <= i andalso i <= maxOrd then itoc i
			       else raise Chr
    val ord = ord

    fun pred (c : char) : char = let
	  val c' = (ctoi c - 1)
	  in
	    if (c' < 0) then raise Chr else (itoc c')
	  end
    fun succ (c : char) : char = let
	  val c' = (ctoi c + 1)
	  in
	    if (maxOrd < c') then raise Chr else (itoc c')
	  end


    val (op <)  = (op <  : char * char -> bool)
    val (op <=) = (op <= : char * char -> bool)
    val (op >)  = (op >  : char * char -> bool)
    val (op >=) = (op >= : char * char -> bool)


    fun compare (c1 : char, c2 : char) =
	if (c1 = c2) then EQUAL
	else if (c1 < c2) then LESS
	     else GREATER

  (* testing character membership *)
    local
      fun ord' c = int32touint32(ord c)
      fun mkArray (s, sLen) =
	  let
	      val sLen = int32touint32 sLen
	      val ca = unsafe_array8 (int32touint32 (maxOrd+1),#"\000")
	      fun ins i = if ult(i,sLen)
			      then (unsafe_update8 (ca, ord'(unsafe_vsub8(s, i)), #"\001");
				    ins(uplus(i,0w1)))
			  else ()
	      val _ = ins 0w0
	  in  ca
	  end
    in
	fun contains "" = (fn c => false)
	  | contains s =
	    let val sLen = PreString.size s
	    in
		if (sLen = 1)
		    then let val c' = unsafe_vsub8(s, 0w0)
			 in fn c => (c = c') end
		else let val cv = mkArray (s, sLen)
		     in fn c => (unsafe_sub8(cv, ord' c) <> #"\000")
		     end
	    end
	fun notContains "" = (fn c => true)
	  | notContains s =
	    let val sLen = PreString.size s
	    in
		if (sLen = 1)
		    then let val c' = unsafe_vsub8(s,0w0)
			 in fn c => (c <> c') end
		else let val cv = mkArray (s, sLen)
		     in fn c => (unsafe_sub8(cv, ord' c) = #"\000")
		     end
	    end
    end (* local *)

  (* For each character code we have an 8-bit vector, which is interpreted
   * as follows:
   *   0x01  ==  set for upper-case letters
   *   0x02  ==  set for lower-case letters
   *   0x04  ==  set for digits
   *   0x08  ==  set for white space characters
   *   0x10  ==  set for punctuation characters
   *   0x20  ==  set for control characters
   *   0x40  ==  set for hexadecimal characters
   *   0x80  ==  set for SPACE
   *)
    val ctypeTbl = "\
	    \\032\032\032\032\032\032\032\032\032\040\040\040\040\040\032\032\
	    \\032\032\032\032\032\032\032\032\032\032\032\032\032\032\032\032\
	    \\136\016\016\016\016\016\016\016\016\016\016\016\016\016\016\016\
	    \\068\068\068\068\068\068\068\068\068\068\016\016\016\016\016\016\
	    \\016\065\065\065\065\065\065\001\001\001\001\001\001\001\001\001\
	    \\001\001\001\001\001\001\001\001\001\001\001\016\016\016\016\016\
	    \\016\066\066\066\066\066\066\002\002\002\002\002\002\002\002\002\
	    \\002\002\002\002\002\002\002\002\002\002\002\016\016\016\016\032\
	    \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
	    \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
	    \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
	    \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
	    \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
	    \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
	    \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
	    \\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
	  \"
    fun inSet (c : char, s : word) = let
	  val m = int32touint32(ord(unsafe_vsub8(ctypeTbl, int32touint32 (ord c))))
	  in  &&(m, s) <> 0w0
	  end

  (* predicates on integer coding of Ascii values *)
    fun isAlpha c	= inSet(c, 0wx03)
    fun isUpper c	= inSet(c, 0wx01)
    fun isLower c	= inSet(c, 0wx02)
    fun isDigit c	= inSet(c, 0wx04)
    fun isHexDigit c	= inSet(c, 0wx40)
    fun isAlphaNum c	= inSet(c, 0wx07)
    fun isSpace c	= inSet(c, 0wx08)
    fun isPunct c	= inSet(c, 0wx10)
    fun isGraph c	= inSet(c, 0wx17)
    fun isPrint c	= inSet(c, 0wx97)
    fun isCntrl c	= inSet(c, 0wx20)
    fun isAscii c    	= c < chr 128

    val offset = ctoi #"a" - ctoi #"A"
    fun toUpper c = if (isLower c) then itoc(ctoi c - offset) else c
    fun toLower c = if (isUpper c) then itoc(ctoi c + offset) else c

  (* conversions between characters and printable representations *)
    fun digit (c:char) : int = ord c - 48

    fun hdigit (c:char) : int =
	let val n = ord c
	in  if ilt(n,65) then n - 48
	    else if ilt(n,97) then n - 55
	    else n - 87
	end

    fun numtochar (rep:'a, base:int, revdigits:int list) : (char * 'a) option =
	let fun loop (ds:int list, m:int, n:int) : (char * 'a) option =
		(case ds of
		    nil => if igt(n,maxOrd) then NONE else SOME(chr n,rep)
		|   d::ds => loop(ds,m*base,n+d*m))
	in  loop(revdigits,1,0)
	end handle Overflow => NONE

    (*
	Removes a prefix of zeros so that scanC can handle escapes like
	\x00000000000001 without causing numtochar to overflow when it
	computes base^i for digit i.
    *)
    fun dropzeros (revdigits:int list) : int list =
	let val digits = rev revdigits
	    fun skip (ds:int list) : int list =
		(case ds of
		    0 :: ds => skip ds
		|   _ => rev ds)
	in  skip digits
	end
	    
    fun scan getc rep = let
	  fun get2 rep = (case (getc rep)
		 of (SOME(c1, rep')) => (case (getc rep')
		       of (SOME(c2, rep'')) => SOME(c1, c2, rep'')
			| _ => NONE
		      (* end case *))
		  | _ => NONE
		(* end case *))
	  fun get4 rep =
		(case (get2 rep) of
		    SOME (c1,c2,rep) =>
			(case (get2 rep) of
			    SOME (c3,c4,rep) => SOME(c1,c2,c3,c4,rep)
			|   NONE => NONE)
		|   NONE => NONE)
	  in
	    case (getc rep)
	     of NONE => NONE
	      | (SOME(#"\\", rep')) => (case (getc rep')
		   of NONE => NONE
		    | (SOME(#"a", rep'')) => (SOME(#"\a", rep''))
		    | (SOME(#"b", rep'')) => (SOME(#"\b", rep''))
		    | (SOME(#"t", rep'')) => (SOME(#"\t", rep''))
		    | (SOME(#"n", rep'')) => (SOME(#"\n", rep''))
		    | (SOME(#"v", rep'')) => (SOME(#"\v", rep''))
		    | (SOME(#"f", rep'')) => (SOME(#"\f", rep''))
		    | (SOME(#"r", rep'')) => (SOME(#"\r", rep''))
		    | (SOME(#"\\", rep'')) => (SOME(#"\\", rep''))
		    | (SOME(#"\"", rep'')) => (SOME(#"\"", rep''))
		    | (SOME(#"^", rep'')) => (case (getc rep'')
			 of NONE => NONE
	    		  | (SOME(c, rep''')) =>
			      if ((#"@" <= c) andalso (c <= #"_"))
			        then SOME(chr(ord c - 64), rep''')
			        else NONE
			(* end case *))
		    | (SOME(#"u", rep)) =>
			(case (get4 rep) of
			    NONE => NONE
			|   SOME (d1,d2,d3,d4,rep) =>
				if isHexDigit d1 andalso isHexDigit d2 andalso
				    isHexDigit d3 andalso isHexDigit d4
				then numtochar(rep,16,[hdigit d4,hdigit d3,hdigit d2,hdigit d1])
				else NONE)
		    | (SOME(d1, rep'')) => if (isDigit d1)
			then (case (get2 rep'')
			   of SOME(d2, d3, rep''') =>
				if isDigit d2 andalso isDigit d3
				then numtochar(rep''',10,[digit d3,digit d2,digit d1])
				else NONE
			    | NONE => NONE
			  (* end case *))
			else if (isSpace d1) then
			    let fun loop rep =
				    (case (getc rep) of
					SOME (#"\\",rep) => scan getc rep
				    |	SOME (c,rep) =>
					    if isSpace c then loop rep else NONE
				    |	NONE => NONE)
			    in  loop rep''
			    end
			else NONE
		  (* end case *))
	      | (SOME(#"\"", rep')) => NONE	(* " *)
	      | (SOME(c, rep')) => if (isPrint c) then (SOME(c, rep')) else NONE
	    (* end case *)
	  end

    val fromString = StringCvt.scanString scan

    val itoa = (NumFormat.fmtInt StringCvt.DEC) (* o Int.fromInt *)

    fun toString #"\a" = "\\a"
      | toString #"\b" = "\\b"
      | toString #"\t" = "\\t"
      | toString #"\n" = "\\n"
      | toString #"\v" = "\\v"
      | toString #"\f" = "\\f"
      | toString #"\r" = "\\r"
      | toString #"\"" = "\\\""
      | toString #"\\" = "\\\\"
      | toString c =
	  if (isPrint c)
	    then unsafe_vsub (PreString.chars, int32touint32(ord c))
	    else let
	      val c' = ord c
	      in
		if (c > chr 32)
		  then PreString.concat2("\\", itoa c')
		  else PreString.concat2("\\^",
		    unsafe_vsub (PreString.chars, int32touint32(c'+64)))
	      end

    fun scanC getc rep =
	(case (getc rep) of
	    NONE => NONE
	|   SOME (#"\\",rep) =>
		(case (getc rep) of
		    NONE => NONE
		|   SOME (#"a",rep) => SOME(#"\a",rep)
		|   SOME (#"b",rep) => SOME(#"\b",rep)
		|   SOME (#"t",rep) => SOME(#"\t",rep)
		|   SOME (#"n",rep) => SOME(#"\n",rep)
		|   SOME (#"v",rep) => SOME(#"\v",rep)
		|   SOME (#"f",rep) => SOME(#"\f",rep)
		|   SOME (#"r",rep) => SOME(#"\r",rep)
		|   SOME (#"?",rep) => SOME(#"?",rep)
		|   r as SOME (#"\\",rep) => r
		|   r as SOME (#"\"",rep) => r
		|   r as SOME (#"'",rep) => r
		|   SOME (#"^",rep) =>
			(case (getc rep) of
			    NONE => NONE
			|   SOME (c,rep) =>
				let val n = ord c
				in  if ilt(63,n) andalso ilt(n,96) then
					SOME(chr(n - 64),rep)
				    else NONE
				end)
		|   SOME (#"x",rep) =>
			let fun cvt (rep,revdigits:int list) =
				(case revdigits of
				    nil => NONE
				|   _ => numtochar(rep,16,dropzeros revdigits))
			    fun scan (rep,acc) =
				(case (getc rep) of
				    NONE => cvt(rep,acc)
				|   SOME(c,rep') =>
					if isHexDigit c then
					    scan(rep',hdigit c::acc)
					else cvt(rep,acc))
			in  scan(rep,nil)
			end
		|   SOME (d1,rep) =>
			let fun cvt (rep,revdigits:int list) =
				numtochar(rep,8,revdigits)
			    fun isOctal (c:char) : bool =
				let val n = ord c
				in  ilt(47,n) andalso ilt(n,56)
				end
			    fun scan (0,rep,acc) = cvt(rep,acc)
			      | scan (n,rep,acc) =
				(case (getc rep) of
				    NONE => cvt(rep,acc)
				|   SOME(c,rep') =>
					if isOctal c then
					    scan(n-1,rep',digit c::acc)
					else cvt(rep,acc))
			in  if isOctal d1 then
				scan(2,rep,[digit d1])
			    else NONE
			end)
	|   SOME (#"\"",rep) => NONE
	|   r as SOME (c,rep) => if isPrint c then r else NONE)

    val fromCString = StringCvt.scanString scanC

    fun toCString #"\a" = "\\a"
      | toCString #"\b" = "\\b"
      | toCString #"\t" = "\\t"
      | toCString #"\n" = "\\n"
      | toCString #"\v" = "\\v"
      | toCString #"\f" = "\\f"
      | toCString #"\r" = "\\r"
      | toCString #"\"" = "\\\""
      | toCString #"\\" = "\\\\"
      | toCString #"?" = "\\?"
      | toCString #"'" = "\\'"
      | toCString c =
	let val n = ord c
	in  if (isPrint c) then
		unsafe_vsub (PreString.chars, int32touint32 n)
	    else
		let val s = NumFormat.fmtInt StringCvt.OCT n
		    val s = StringCvt.padLeft #"0" 3 s
		in  PreString.concat2("\\",s)
		end
	end

end

(* Char *)

(* String *)
(* string.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure String (*:> STRING where type string = string
			     and type Char.char = char
			     and type Char.string = string *)=
  struct

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32
    val uint8touint32 = TiltPrim.uint8touint32

    val unsafe_array8 = TiltPrim.unsafe_array8
    val unsafe_update8 = TiltPrim.unsafe_update8
    val unsafe_vsub8 = TiltPrim.unsafe_vsub8
    val vector_length8 = TiltPrim.vector_length8
    val unsafe_array2vector8 = TiltPrim.unsafe_array2vector8

    val unsafe_vsub32 = TiltPrim.unsafe_vsub

    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult

    val uplus = TiltPrim.uplus

    type string = string
    structure Char = Char

    val maxSize = 1024 * 1024

  (* the length of a string *)
    val i2w = int32touint32
    val w2i = uint32toint32
    fun size(x : string) : int = uint32toint32(vector_length8 x)


  (* allocate an uninitialized string of given length *)
    fun create sz : TiltPrim.word8array = if (sz>0)
				   then unsafe_array8(i2w sz,#"\000")
				 else raise Size


  (* convert a character into a single character string *)
    fun str (c : Char.char) : string =
	  unsafe_vsub32(PreString.chars, uint8touint32 c)

  (* get a character from a string *)
    fun sub(x : string, i : int) =
	let val index = int32touint32 i
	in  if (ugte(index, vector_length8 x))
		then raise Subscript
	    else unsafe_vsub8(x,index)
	end

    fun substring (s, i, n) =
	  if ((i < 0) orelse (n < 0) orelse (size s < i+n))
	    then raise Subscript
	    else PreString.unsafeSubstring (s, i2w i, i2w n)

    fun extract (v : string, base, optLen) = let
	  val len = size v
	  val base' = i2w base
	  fun newVec n = let
		val newV : TiltPrim.word8array = create n
		val n = i2w n
		fun fill (i : word) = if ult(i,n)
		      then let val temp : word = uplus(base',i)
			       val c : char = unsafe_vsub8(v,temp)
			       val i' : word = uplus(i,0w1)
			  in  (unsafe_update8(newV, i, c);
			       fill i')
			   end
		      else ()
		in  fill 0w0; unsafe_array2vector8 newV
		end
	  in
	    case (base, optLen)
	     of (0, NONE) => v
	      | (_, SOME 0) => if ((base < 0) orelse (len < base))
		    then raise Subscript
		    else ""
	      | (_, NONE) => if ((base < 0) orelse (len < base))
		      then raise Subscript
		    else if (base = len)
		      then ""
		      else newVec (len - base)
	      | (_, SOME 1) =>
		  if ((base < 0) orelse (len < base+1))
		    then raise Subscript
		    else str(unsafe_vsub8(v, i2w base))
	      | (_, SOME n) =>
		  if ((base < 0) orelse (n < 0) orelse (len < (base+n)))
		    then raise Subscript
		    else newVec n
	    (* end case *)
	  end

    fun op ^ ("", s) = s
      | op ^ (s, "") = s
      | op ^ (x, y) = PreString.concat2 (x, y)

  (* concatenate a list of strings together *)
    fun concat [s] = s
      | concat (sl : string list) = let
	fun length (i, []) = i
	  | length (i, s::rest) = length(i+size s, rest)
	in
	  case length(0, sl)
	   of 0 => ""
	    | 1 => let
		fun find ("" :: r) = find r
		  | find (s :: _) = s
		  | find _ = "" (** impossible **)
		in
		  find sl
		end
	    | totLen => let
		val ss = create totLen
		fun copy ([], _) = ()
		  | copy (s::r, i) = let
		      val len = i2w(size s)
		      fun copy' j = if (j = len)
			    then ()
			    else (
			      unsafe_update8(ss, uplus(i,j),
					    unsafe_vsub8(s, j));
			      copy'(uplus(j,0w1)))
		      in
			copy' 0w0;
			copy (r, uplus(i,len))
		      end
		in
		  copy (sl, 0w0);  unsafe_array2vector8 ss
		end
	  (* end case *)
	end (* concat *)

  (* implode a list of characters into a string *)
    fun implode [] = ""
      | implode cl =  let
	  fun length ([], n) = n
	    | length (_::r, n) = length (r, n+1)
	  in
	    PreString.implode (length (cl, 0), cl)
	  end

  (* explode a string into a list of characters *)
    fun explode s = let
	  fun f(l, ~1) = l
	    | f(l,  i) = f(unsafe_vsub8(s, i2w i) :: l, i-1)
	  in
	    f(nil, size s - 1)
	  end

    fun map f vec = (case (size vec)
	   of 0 => ""
	    | len => let
		val newVec = create len
		val len = i2w len
		fun mapf i = if ult(i,len)
		      then (unsafe_update8(newVec, i,
					 f(unsafe_vsub8(vec, i)));
			    mapf(uplus(i,0w1)))
		      else ()
		in  mapf 0w0; unsafe_array2vector8 newVec
		end
	  (* end case *))

  (* map a translation function across the characters of a string *)
    fun translate tr s = PreString.translate (tr, s, 0w0, i2w (size s))

  (* tokenize a string using the given predicate to define the delimiter
   * characters.
   *)
    fun tokens isDelim s = let
	  val n = size s
	  fun substr (i, j, l) = if (i = j)
		then l
		else PreString.unsafeSubstring(s, i2w i, i2w(j-i))::l
	  fun scanTok (i, j, toks) = if (j < n)
		  then if (isDelim (unsafe_vsub8 (s, i2w j)))
		    then skipSep(j+1, substr(i, j, toks))
		    else scanTok (i, j+1, toks)
		  else substr(i, j, toks)
	  and skipSep (j, toks) = if (j < n)
		  then if (isDelim (unsafe_vsub8 (s, i2w j)))
		    then skipSep(j+1, toks)
		    else scanTok(j, j+1, toks)
		  else toks
	  in
	    rev (scanTok (0, 0, []))
	  end
    fun fields isDelim s = let
	  val n = size s
	  fun substr (i, j, l) = PreString.unsafeSubstring(s, i2w i, i2w(j-i))::l
	  fun scanTok (i, j, toks) = if (j < n)
		  then if (isDelim (unsafe_vsub8 (s, i2w j)))
		    then scanTok (j+1, j+1, substr(i, j, toks))
		    else scanTok (i, j+1, toks)
		  else substr(i, j, toks)
	  in
	    rev (scanTok (0, 0, []))
	  end

  (* String comparisons *)
    fun isPrefix s1 s2 = PreString.isPrefix (s1, s2, 0w0, i2w(size s2))
    fun compare (a, b) = PreString.cmp (a, 0w0, size a, b, 0w0, size b)
    fun collate cmpFn (a, b) = PreString.collate cmpFn (a, 0w0, size a, b, 0w0, size b)

  (* String greater or equal *)
    fun sgtr (a, b) = let
	  val al = size a and bl = size b
	  val n = if (al < bl) then al else bl
	  fun cmp i = if (i = n)
		then (al > bl)
		else let
		  val ai = unsafe_vsub8(a,i2w i)
		  val bi = unsafe_vsub8(b,i2w i)
		  in
		    Char.>(ai, bi) orelse ((ai = bi) andalso cmp(i+1))
		  end
	  in
	    cmp 0
	  end

    fun op <= (a,b) = if sgtr(a,b) then false else true
    fun op < (a,b) = sgtr(b,a)
    fun op >= (a,b) = b <= a
    val op > = sgtr

    fun fromString s = let
	  val len = i2w(size s)
	  fun getc i = if ult(i,len)
		then SOME(unsafe_vsub8(s, i), uplus(i,0w1))
		else NONE
	  val scanChar = Char.scan getc
	  fun accum (i, chars) = (case (scanChar i)
		 of NONE => if ult(i,len)
		      then NONE (* bad format *)
		      else SOME(implode(rev chars))
		  | (SOME(c, i')) => accum(i', c::chars)
		(* end case *))
	  in
	    accum (0w0, [])
	  end
    val toString = translate Char.toString

    fun fromCString s = raise TiltExn.LibFail "String.fromCString not implemented"
    val toCString = translate Char.toCString

  end (* structure String *)

(* String *)

(* Substring *)
(* substring.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure Substring (*:> SUBSTRING where type substring = PreString.substring
				   and type String.string = string
				   and type String.Char.char = char
				   and type String.Char.string = string *)=
  struct

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val unsafe_vsub8 = TiltPrim.unsafe_vsub8

    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult

    val uminus = TiltPrim.uminus
    val uplus = TiltPrim.uplus
(*
    val op + = InlineT.DfltInt.+
    val op - = InlineT.DfltInt.-
    val op < = InlineT.DfltInt.<
    val op <= = InlineT.DfltInt.<=
    val op > = InlineT.DfltInt.>
    val op >= = InlineT.DfltInt.>=
    val op = = InlineT.=
    val unsafeSub = InlineT.CharVector.sub
*)

    val i2w = int32touint32
    val w2i = uint32toint32

  (* list reverse *)
    fun rev ([], l) = l
      | rev (x::r, l) = rev (r, x::l)

    structure String = String
    datatype substring = datatype PreString.substring
    fun base (PreString.SS arg) = arg

    fun string (PreString.SS(s,st,sz)) = PreString.unsafeSubstring(s,i2w st,i2w sz)

    infix 6 ++
	fun op++ (i:int, j:int) : int =
		(i+j) handle Overflow => raise Subscript

    fun substring (s, i, n) =
	  if ((0 <= i) andalso (0 <= n) andalso (i++n <= String.size s))
	    then PreString.SS(s, i, n)
	    else raise Subscript

    fun extract (s, i, NONE) = if ((0 <= i) andalso (i <= String.size s))
				   then PreString.SS(s, i, String.size s - i)
			       else raise Subscript
      | extract (s, i, SOME n) = substring (s, i, n)

    fun all s = PreString.SS(s, 0, String.size s)

    fun isEmpty (PreString.SS(_, _, 0)) = true
      | isEmpty _ = false

    fun getc (PreString.SS(s, i, 0)) = NONE
      | getc (PreString.SS(s, i, n)) = SOME(unsafe_vsub8(s, i2w i), PreString.SS(s, i+1, n-1))
    fun first (PreString.SS(s, i, 0)) = NONE
      | first (PreString.SS(s, i, n)) = SOME(unsafe_vsub8(s, i2w i))
    fun triml k (PreString.SS(s, i, n)) =
	  if (k < 0) then raise Subscript
	  else if (k >= n) then PreString.SS(s, i+n, 0)
	  else PreString.SS(s, i+k, n-k)
    fun trimr k (PreString.SS(s, i, n)) =
	  if (k < 0) then raise Subscript
	  else if (k >= n) then PreString.SS(s, i, 0)
	  else PreString.SS(s, i, n-k)

    fun sub (PreString.SS(s, i, n), j) =
	  if (j >= n)
	    then raise Subscript
	    else unsafe_vsub8(s, i2w(i+j))
    fun size (PreString.SS(_, _, n)) = n
    fun slice (PreString.SS(s, i, n), j, SOME m) =
	  if ((0 <= j) andalso (0 <= m) andalso (j++m <= n))
	    then PreString.SS(s, i+j, m)
	    else raise Subscript
      | slice (PreString.SS(s, i, n), j, NONE) =
	  if (0 <= j) andalso (j <= n)
	    then PreString.SS(s, i+j, n-j)
	    else raise Subscript

  (* concatenate a list of substrings together *)
    fun concat ssl = let
	fun length (len, sl, []) = (len, sl)
	  | length (len, sl, (PreString.SS(s, i, n)::rest)) =
	      length(len+n, PreString.unsafeSubstring(s, i2w i, i2w n)::sl, rest)
	in
	  PreString.revConcat (length (0, [], ssl))
	end

  (* explode a substring into a list of characters *)
    fun explode (PreString.SS(s, i, n)) = let
	  fun f(l, j) = if ult(j,i2w i)
		then l
		else f(unsafe_vsub8(s, j) :: l, uminus(j,0w1))
	  in
	    f(nil, i2w((i + n) - 1))
	  end

  (* Substring comparisons *)
    fun isPrefix s1 (PreString.SS(s2, i2, n2)) = PreString.isPrefix (s1, s2,i2w  i2, i2w n2)
    fun compare (PreString.SS(s1, i1, n1), PreString.SS(s2, i2, n2)) =
	  PreString.cmp (s1, i2w i1, n1, s2, i2w i2, n2)
    fun collate cmpFn (PreString.SS(s1, i1, n1), PreString.SS(s2, i2, n2)) =
	  PreString.collate cmpFn (s1, i2w i1, n1, s2, i2w i2, n2)

    fun splitAt (PreString.SS(s, i, n), k) =
	  if (n < k)
	    then raise Subscript
	    else (PreString.SS(s, i, k), PreString.SS(s, i+k, n-k))

    local
      fun scanl chop pred (PreString.SS(s, i, n)) = let
	    val stop = i2w(i+n)
	    fun scan j = if ((j <> stop) andalso pred(unsafe_vsub8(s, j)))
		  then scan(uplus(j,0w1))
		  else j
	    in
	      chop (s, i, n, w2i(scan (i2w(i - i))))
	    end
      fun scanr chop pred (PreString.SS(s, i, n)) = let
	    val stop = i2w(i-1)
	    fun scan j = if ((j <> stop) andalso pred(unsafe_vsub8(s, j)))
		  then scan(uminus(j,0w1))
		  else j
	    val k : int = (w2i (scan (i2w (i+n-1)))) - i + 1
	    in
	      chop (s, i, n, k)
	    end
    in
    val splitl = scanl (fn (s, i, n, k) => (PreString.SS(s, i, k), PreString.SS(s, i+k, n-k)))
    val splitr = scanr (fn (s, i, n, k) => (PreString.SS(s, i, k), PreString.SS(s, i+k, n-k)))
    val dropl  = scanl (fn (s, i, n, k) => PreString.SS(s, i+k, n-k))
    val dropr  = scanr (fn (s, i, n, k) => PreString.SS(s, i, k))
    val takel  = scanl (fn (s, i, n, k) => PreString.SS(s, i, k))
    val taker  = scanr (fn (s, i, n, k) => PreString.SS(s, i+k, n-k))
    end (* local *)




  (* find the position of the first occurrence of s in the substring.
   * NOTE: some day we might want to implement KMP matching for this
   *)
    fun position s (PreString.SS (s', i, n)) = let
	  val len = String.size s
	  val len' = i2w len
	  fun eq (j, k) = ugte(j,len') orelse
		((unsafe_vsub8(s, j) = unsafe_vsub8(s', k)) andalso
		 eq (uplus(j,0w1),uplus(k,0w1)))
	  val stop = i+n-len
	  fun cmp k =
		if (k > stop) then i+n (* failure *)
		else if eq(0w0, i2w k) then k
		else cmp(k+1)
	  val indx = cmp i
	  in
	    (PreString.SS(s', i, indx-i), PreString.SS(s', indx, i+n-indx))
	  end

    fun span (PreString.SS(s1, i1, n1), PreString.SS(s2, i2, n2)) =
	  if ((s1 = s2) andalso (i1 < i2+n2))
	    then PreString.SS(s1, i1, (i2+n2)-i1)
	    else raise Span

    fun translate tr (PreString.SS(s, i, n)) =
	  PreString.translate (tr, s, i2w i, i2w n)

    fun tokens isDelim (PreString.SS(s, i, n)) = let
	  val stop = i+n
	  fun substr (i, j, l) =
		if (i = j) then l else PreString.SS(s, i, j-i)::l
	  fun scanTok (i, j, toks) = if (j < stop)
		  then if (isDelim (unsafe_vsub8 (s, i2w j)))
		    then skipSep(j+1, substr(i, j, toks))
		    else scanTok (i, j+1, toks)
		  else substr(i, j, toks)
	  and skipSep (j, toks) = if (j < stop)
		  then if (isDelim (unsafe_vsub8 (s, i2w j)))
		    then skipSep(j+1, toks)
		    else scanTok(j, j+1, toks)
		  else toks
	  in
	    rev (scanTok (i, i, []), [])
	  end
    fun fields isDelim (PreString.SS(s, i, n)) = let
	  val stop = i+n
	  fun substr (i, j, l) = PreString.SS(s, i, j-i)::l
	  fun scanTok (i, j, toks) = if (j < stop)
		  then if (isDelim (unsafe_vsub8 (s, i2w j)))
		    then scanTok (j+1, j+1, substr(i, j, toks))
		    else scanTok (i, j+1, toks)
		  else substr(i, j, toks)
	  in
	    rev (scanTok (i, i, []), [])
	  end

    fun foldl f init (PreString.SS(s, i, n)) = let
	  val stop = i+n
	  fun iter (j, accum) = if (j < stop)
		then iter (j+1, f (unsafe_vsub8(s, i2w j), accum))
		else accum
	  in
	    iter (i, init)
	  end
    fun foldr f init (PreString.SS(s, i, n)) = let
	  fun iter (j, accum) = if (j >= i)
		then iter (j-1, f (unsafe_vsub8(s, i2w j), accum))
		else accum
	  in
	    iter (i+n-1, init)
	  end
    fun app f (PreString.SS(s, i, n)) = let
	  val stop = i+n
	  fun iter j = if (j < stop)
		then (f (unsafe_vsub8(s, i2w j)); iter (j+1))
		else ()
	  in
	    iter i
	  end

  end;

(* Substring *)


(* PreInt *)
structure PreInt =
    struct
	fun imod(a : int, b : int) =
	    let val temp = TiltPrim.irem(a,b)
	    in if ((b>0 andalso temp>=0) orelse
		   (b<0 andalso temp<=0))
		   then temp
	       else temp+b
	    end

	fun idiv(a : int, b : int) =
	    let val temp = TiltPrim.iquot(a,b)
	    in  (* same if sign of a and b agree *)
		if ((a>=0 andalso b>0) orelse (a<=0 andalso b<0))
		    then temp
		else
		    if (b * temp = a)   (* same if exact div *)
			then temp
		    else temp - 1       (* here's where they differ *)
	    end

	(* Note ineg includes overflow check. *)
	fun iabs (a : int) : int = if TiltPrim.igt (a, 0) then a else TiltPrim.ineg a

    end

structure PreLargeInt =
    struct
	type int = int
    end


(* PreInt *)

(* PreReal *)
structure PreLargeReal =
    struct
	type real = real
    end

structure PreReal =
    struct
	type real = real
    end

(* PreREal *)

(*PreWord*)
structure PreWord =
    struct
	type word = word
    end

structure PreLargeWord =
    struct
	type word = word
    end


(* PreWord *)

(* PreVector *)

structure PreVector :
    sig
	val maxLen : int
	val checkLen : int -> unit
	val arrayFromList' : int * 'a list -> 'a array (* known length *)
	val arrayFromList : 'a list -> 'a array
	val vectorFromList' : int * 'a list -> 'a vector (* known length *)
	val vectorFromList : 'a list -> 'a vector
    end =
struct

    fun list_length l =
	let
	    fun len ([], n) = n
	      | len ([_], n) = n+1
	      | len (_::_::r, n) = len(r, n+2)
	in  len (l, 0)
	end
    fun list_hd' (h :: _) = h		(* list_hd' nil does not behave like List.hd nil *)

    val maxLen = 1024 * 1024
    fun checkLen n = if maxLen < n then raise Size else ()

    fun arrayFromList'(n,l) =
	let val _ = checkLen n
	in
	    if (n = 0)
		then TiltPrim.empty_array
	    else let val e = list_hd' l
		     val ar = TiltPrim.unsafe_array(TiltPrim.int32touint32 n, e)
		     fun loop [] _ = ()
		       | loop (a::b) n = (TiltPrim.unsafe_update(ar,n,a);
					  loop b (TiltPrim.uplus(n,0w1)))
		     val _ = loop l 0w0
		 in  ar
		 end
	end

    fun arrayFromList l = arrayFromList' (list_length l, l)

    fun vectorFromList' arg = TiltPrim.unsafe_array2vector(arrayFromList' arg)

    fun vectorFromList arg = TiltPrim.unsafe_array2vector(arrayFromList arg)
end


(* NumScan *)
(* num-scan.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 * The string conversion for the largest int and word types.
 * All of the other scan functions can be implemented in terms of them.
 *
 *)

structure NumScan : sig

    val scanWord : StringCvt.radix
	  -> (char, 'a) StringCvt.reader -> (PreLargeWord.word, 'a) StringCvt.reader
    val scanInt  : StringCvt.radix
	  -> (char, 'a) StringCvt.reader -> (PreLargeInt.int, 'a) StringCvt.reader
    val scanReal : (char, 'a) StringCvt.reader -> (PreLargeReal.real, 'a) StringCvt.reader
	(** should be to LargeReal.real **)

  end = struct

    val && = TiltPrim.&&
    val << = TiltPrim.<<

    type int32 = TiltPrim.int32
    type word32 = TiltPrim.uint32

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val unsafe_vsub = TiltPrim.unsafe_vsub

    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult

    val uminus = TiltPrim.uminus
    val uplus = TiltPrim.uplus
    val umult = TiltPrim.umult
(*
    structure W = InlineT.Word32
    structure I = InlineT.Int31
    structure I32 = InlineT.Int32
    structure R = InlineT.Real64
    type word = word32
*)
    val iplus : int * int -> int = op +
    val iminus : int * int -> int = op -
    val imult : int * int -> int = op *
    val iless : int * int -> bool = op <
    val ineg : int -> int = ~
    val rplus : real* real -> real = op +
    val rmult : real* real -> real = op *
    val rneg : real -> real = ~
    val op <  = ult
    val op >= = ugte
    val op +  = uplus
    val op -  = uminus
    val op *  = umult

    val largestWordDiv10 : word = 0w429496729	(* 2^32-1 divided by 10 *)
    val largestWordMod10 : word = 0w5		(* remainder *)

    val largestNegInt32 : word = 0wx80000000
    val largestPosInt32 : word = 0wx7fffffff
    val minInt32 : int32 = ~2147483648

  (* A table for mapping digits to values.  Whitespace characters map to
   * 128, "+" maps to 129, "-","~" map to 130, "." maps to 131, and the
   * characters 0-9,A-V,X-Z,a-z map to their base-36 value.  All other
   * characters map to 255.
   *)
    local
      val cvtTable = "\
	    \\255\255\255\255\255\255\255\255\255\128\128\255\255\255\255\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	    \\128\255\255\255\255\255\255\255\255\255\255\129\255\130\131\255\
	    \\000\001\002\003\004\005\006\007\008\009\255\255\255\255\255\255\
	    \\255\010\011\012\013\014\015\016\017\018\019\020\021\022\023\024\
	    \\025\026\027\028\029\030\031\255\033\034\035\255\255\255\255\255\
	    \\255\010\011\012\013\014\015\016\017\018\019\020\021\022\023\024\
	    \\025\026\027\028\029\030\031\032\033\034\035\255\255\255\130\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	    \\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
	  \"
(*      val ord = InlineT.Char.ord *)
    in
    fun code (c : char) = (* W.fromInt(ord(InlineT.CharVector.sub(cvtTable, ord c))) *)
	int32touint32(ord(String.sub(cvtTable, ord c)))
    val wsCode : word = 0w128		(* code for whitespace *)
    val plusCode : word = 0w129		(* code for #"+" *)
    val minusCode : word = 0w130	(* code for #"-" and #"~" *)
    val ptCode : word = 0w131		(* code for #"." *)
    val eCode : word = 0w14		(* code for #"e" and #"E" *)
    val wCode : word = 0w32		(* code for #"w" *)
    val xCode : word = 0w33		(* code for #"X" and #"X" *)
    end (* local *)

    type prefix_pat = {
	wOkay : bool,		(* true if 0w prefix is okay; if this is
				 * true, then signs (+, -, ~) are not okay.
				 *)
	xOkay : bool,		(* true if 0w?[xX] prefix is okay *)
	isDigit : word -> bool	(* returns true for allowed digits *)
      }

    fun scanPrefix (p : prefix_pat) getc cs = let
	  fun getNext cs = (case (getc cs)
		 of NONE => NONE
		  | (SOME(c, cs)) => SOME(code c, cs)
		(* end case *))
	  fun skipWS cs = (case (getNext cs)
		 of NONE => NONE
		  | (SOME(c, cs')) =>
		      if (c = wsCode) then skipWS cs' else SOME(c, cs')
		(* end case *))
	  fun getOptSign NONE = NONE
	    | getOptSign (next as SOME(c, cs)) =
		if (#wOkay p)
		  then getOpt0 (false, SOME(c, cs))
		else if (c = plusCode)
		  then getOpt0 (false, getNext cs)
		else if (c = minusCode)
		  then getOpt0 (true, getNext cs)
		  else getOpt0 (false, next)
	  and getOpt0 (neg, NONE) = NONE
	    | getOpt0 (neg, SOME(c, cs)) =
		if ((c = 0w0) andalso ((#wOkay p) orelse (#xOkay p)))
		  then getOptW (neg, (c, cs), getNext cs)
		  else finish (neg, (c, cs))
	  and getOptW (neg, savedCS, NONE) = finish (neg, savedCS)
	    | getOptW (neg, savedCS, arg as SOME(c, cs)) =
		if ((c = wCode) andalso (#wOkay p))
		  then getOptX (neg, savedCS, getNext cs)
		  else getOptX (neg, savedCS, arg)
	  and getOptX (neg, savedCS, NONE) = finish (neg, savedCS)
	    | getOptX (neg, savedCS, arg as SOME(c, cs)) =
		if ((c = xCode) andalso (#xOkay p))
		  then chkDigit (neg, savedCS, getNext cs)
		  else if (#xOkay p)
			 then finish (neg, savedCS)
			 else chkDigit (neg, savedCS, arg)
	  and chkDigit (neg, savedCS, NONE) = finish (neg, savedCS)
	    | chkDigit (neg, savedCS, SOME(c, cs)) =
		if ((#isDigit p) c)
		  then SOME{neg=neg, next = c, rest = cs}
		  else finish (neg, savedCS)
	  and finish (neg, (c, cs)) =
		if ((#isDigit p) c)
		  then SOME{neg=neg, next = c, rest = cs}
		  else NONE
	  in
	    getOptSign (skipWS cs)
	  end

  (* for power of 2 bases (2, 8 & 16), we can check for overflow by looking
   * at the hi (1, 3 or 4) bits.
   *)
    fun chkOverflow mask w =
	  if (&&(mask, w) = 0w0) then () else raise Overflow

    fun isBinDigit d = (d < 0w2)
    fun isOctDigit d = (d < 0w8)
    fun isDecDigit d = (d < 0w10)
    fun isHexDigit d = (d < 0w16)
    fun isAlphaDec d = (d < 0w36)
    fun isAlpha d    = (d > 0w9) andalso (d < 0w36)

    fun binPat wOkay = {wOkay=wOkay, xOkay=false, isDigit=isBinDigit}
    fun octPat wOkay = {wOkay=wOkay, xOkay=false, isDigit=isOctDigit}
    fun decPat wOkay = {wOkay=wOkay, xOkay=false, isDigit=isDecDigit}
    fun hexPat wOkay = {wOkay=wOkay, xOkay=true, isDigit=isHexDigit}
    fun alphaDecPat wOkay = {wOkay=wOkay, xOkay=false, isDigit=isAlphaDec}

    fun scanBin isWord getc cs = (case (scanPrefix (binPat isWord) getc cs)
	   of NONE => NONE
	    | (SOME{neg, next, rest}) => let
		val chkOverflow = chkOverflow 0wx80000000
		fun cvt (w, rest) = (case (getc rest)
		       of NONE => SOME{neg=neg, word=w, rest=rest}
			| SOME(c, rest') => let val d = code c
			    in
			      if (isBinDigit d)
				then (
				  chkOverflow w;
				  cvt(<<(w, 1) + d, rest'))
				else SOME{neg=neg, word=w, rest=rest}
			    end
		      (* end case *))
		in
		  cvt (next, rest)
		end
	  (* end case *))

    fun scanOct isWord getc cs = (case (scanPrefix (octPat isWord) getc cs)
	   of NONE => NONE
	    | (SOME{neg, next, rest}) => let
		val chkOverflow = chkOverflow 0wxE0000000
		fun cvt (w, rest) = (case (getc rest)
		       of NONE => SOME{neg=neg, word=w, rest=rest}
			| SOME(c, rest') => let val d = code c
			    in
			      if (isOctDigit d)
				then (
				  chkOverflow w;
				  cvt(<<(w, 3) + d, rest'))
				else SOME{neg=neg, word=w, rest=rest}
			    end
		      (* end case *))
		in
		  cvt (next, rest)
		end
	  (* end case *))

    fun scanDec isWord getc cs = (case (scanPrefix (decPat isWord) getc cs)
	   of NONE => NONE
	    | (SOME{neg, next, rest}) => let
		fun cvt (w, rest) = (case (getc rest)
		       of NONE => SOME{neg=neg, word=w, rest=rest}
			| SOME(c, rest') => let val d = code c
			    in
			      if (isDecDigit d)
				then (
				  if ((w >= largestWordDiv10)
				  andalso ((largestWordDiv10 < w)
				    orelse (largestWordMod10 < d)))
				    then raise Overflow
				    else ();
				  cvt (0w10*w+d, rest'))
				else SOME{neg=neg, word=w, rest=rest}
			    end
		      (* end case *))
		in
		  cvt (next, rest)
		end
	  (* end case *))

    fun scanHex isWord getc cs = (case (scanPrefix (hexPat isWord) getc cs)
	   of NONE => NONE
	    | (SOME{neg, next, rest}) => let
		val chkOverflow = chkOverflow 0wxF0000000
		fun cvt (w, rest) = (case (getc rest)
		       of NONE => SOME{neg=neg, word=w, rest=rest}
			| SOME(c, rest') => let val d = code c
			    in
			      if (isHexDigit d)
				then (
				  chkOverflow w;
				  cvt((<<(w, 4) + d), rest'))
				else SOME{neg=neg, word=w, rest=rest}
			    end
		      (* end case *))
		in
		  cvt (next, rest)
		end
	  (* end case *))

    fun finalWord scanFn getc cs = (case (scanFn true getc cs)
	   of NONE => NONE
	    | (SOME{neg, word, rest}) => SOME(word, rest)
	  (* end case *))

    fun scanWord StringCvt.BIN = finalWord scanBin
      | scanWord StringCvt.OCT = finalWord scanOct
      | scanWord StringCvt.DEC = finalWord scanDec
      | scanWord StringCvt.HEX = finalWord scanHex


(*
      val fromword32 = W.toLargeIntX
       val fromword32' = W.toIntX
*)
	val fromword32 = uint32toint32
	val fromword32' = uint32toint32

    fun finalInt scanFn getc cs = (case (scanFn false getc cs)
	   of NONE => NONE
	    | (SOME{neg=true, word, rest}) =>
		if (word < largestNegInt32) then
		   SOME(ineg(fromword32 word), rest)
		else if (largestNegInt32 < word) then
		   raise Overflow
		else
		   SOME(minInt32, rest)
	    | (SOME{word, rest, ...}) =>
		if (largestPosInt32 < word) then
		   raise Overflow
	        else
	           SOME(fromword32 word, rest)
	  (* end case *))


    fun scanInt StringCvt.BIN = finalInt scanBin
      | scanInt StringCvt.OCT = finalInt scanOct
      | scanInt StringCvt.DEC = finalInt scanDec
      | scanInt StringCvt.HEX = finalInt scanHex

  (* scan a string of decimal digits (starting with d), and return their
   * value as a real number.  Also return the number of digits, and the
   * rest of the stream.
   *)
    fun fscan10 getc (d, cs) = let
	  fun wordToReal w = real(fromword32' w)
	  fun scan (accum, n, cs) = (case (getc cs)
		 of (SOME(c, cs')) => let val d = code c
		      in
			if (isDecDigit d)
			  then scan(rplus(rmult(10.0, accum), wordToReal d), iplus(n, 1), cs')
			  else SOME(accum, n, cs)
		      end
		  | NONE => SOME(accum, n, cs)
		(* end case *))
	  in
	    if (isDecDigit d) then scan(wordToReal d, 1, cs) else NONE
	  end


    local
      val negTbl = PreVector.vectorFromList [
	      1.0E~0, 1.0E~1, 1.0E~2, 1.0E~3, 1.0E~4,
	      1.0E~5, 1.0E~6, 1.0E~7, 1.0E~8, 1.0E~9
	    ]
      val posTbl = PreVector.vectorFromList [
	      1.0E0, 1.0E1, 1.0E2, 1.0E3, 1.0E4,
	      1.0E5, 1.0E6, 1.0E7, 1.0E8, 1.0E9
	    ]
      fun scale (tbl, step10 : real) = let
	    fun f (r, 0) = r
	      | f (r, exp) = if (iless(exp, 10))
		  then (rmult(r, unsafe_vsub(tbl, int32touint32 exp)))
		  else f (rmult(step10, r), iminus(exp, 10))
	    in
	      f
	    end
    in
    val scaleUp = scale (posTbl, 1.0E10)
    val scaleDown = scale (negTbl, 1.0E~10)
    end

    fun scanReal getc cs = let
	  fun scan10 cs = (case (getc cs)
		 of (SOME(c, cs)) => fscan10 getc (code c, cs)
		  | NONE => NONE
		(* end case *))
	  fun getFrac rest = (case (scan10 rest)
		 of SOME(frac, n, rest) => (SOME(scaleDown(frac, n)), rest)
		  | NONE => (NONE, rest)
		(* end case *))
	  fun combine (SOME whole, SOME frac) = rplus(whole, frac)
	    | combine (SOME whole, NONE) = whole
	    | combine (NONE, SOME frac) = frac
	    | combine _ = raise Option.Option
	  fun negate (true, num) = rneg num
	    | negate (false, num) = num
	  fun scanExp cs = (case (getc cs)
		 of SOME(c, cs) => let
		      val d = code c
		      fun scan (accum, cs) = (case (getc cs)
			     of SOME(c, cs') => let val d = code c
				  in
				    if (isDecDigit d)
				      then scan (iplus(imult(accum, 10), fromword32' d), cs')
				      else (accum, cs)
				  end
			      | NONE => (accum, cs)
			    (* end case *))
		      in
			if (isDecDigit d)
			  then SOME (scan (fromword32' d, cs))
			  else NONE
		      end
		  | NONE => NONE
		(* end case *))
	  fun getExp cs = (case (getc cs)
		 of (SOME(c, cs)) => if (code c = eCode)
		      then (case (getc cs)
			 of SOME(c, cs') => let
			      val (isNeg, cs) = if (code c = minusCode)
				    then (true, cs')
				    else (false, cs)
			      in
			        case scanExp cs
				 of SOME(exp, cs) => SOME(isNeg, exp, cs)
				  | NONE => NONE
				(* end case *)
			      end
			  | NONE => NONE
			(* end case *))
		      else NONE
		  | NONE => NONE
		(* end case *))

	  fun getSpecial getc (next,rest) = 
	    let
	      val (s,rest) = StringCvt.splitl (isAlpha o code) getc rest
	    in 
	      if (next = (code #"n")) andalso (s = "an") then SOME(0.0/0.0,rest)
	      else if (next = (code #"i")) andalso (s = "nf" orelse s = "nfinity") then SOME (1.0/0.0,rest)
	      else NONE
	    end
	  
	  in
	    case (scanPrefix (alphaDecPat false) getc cs)
	     of NONE => NONE
	      | (SOME{neg, next, rest}) => 
	       if isAlpha next then 
		 (case getSpecial getc (next,rest)
		    of SOME (r,rest) => SOME (negate (neg,r),rest)
		     | NONE => NONE)
	       else
		 let
		   val (whole, hasPt, rest) = if (next = ptCode)
			then (NONE, true, rest)
			else let
			  val (whole, rest) = (case fscan10 getc (next, rest)
				 of SOME(whole, _, rest) => (SOME whole, rest)
				  | NONE => (NONE, rest)
				(* end case *))
			  in
			    case (getc rest)
			     of SOME(#".", rest) => (whole, true, rest)
			      | _ => (whole, false, rest)
			    (* end case *)
			  end
		  val (frac, rest) = if hasPt then getFrac rest else (NONE, rest)
		  val num = negate (neg, combine (whole, frac))
		  in
		    case (getExp rest)
		     of (SOME(isNeg, exp, rest)) =>
			  if isNeg
			    then SOME(scaleDown(num, exp), rest)
			    else SOME(scaleUp(num, exp), rest)
		      | NONE => SOME(num, rest)
		    (* end case *)
		  end
	    (* end case *)
	  end
	    handle Option => NONE

  end;





(* NumScan *)

(* Int *)
(* int32.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure Int32 (*:> INTEGER where type int = int *) =
  struct
    val quot = TiltPrim.iquot
    val andb = TiltPrim.andb
    val xorb = TiltPrim.xorb
    type int = int

    val precision = SOME 32

    val minIntVal : int = ~2147483648
    val minInt : int option = SOME minIntVal
    val maxInt : int option = SOME 2147483647

    val op *    : int * int -> int  = *
    val op quot : int * int -> int  = quot
    val op +    : int * int -> int  = +
    val op -    : int * int -> int  = -
    val ~       : int -> int = ~
    val op <    : int * int -> bool = <
    val op <=   : int * int -> bool = <=
    val op >    : int * int -> bool = >
    val op >=   : int * int -> bool = >=
    val op =    : int * int -> bool = =
    val op <>   : int * int -> bool = <>
    nonfix * quot + - < <= > >= = <>

  (* min, max, abs, rem, div, and mod should be inlined.
   *     ... but this is not the time!
   *)
    fun min(a:int, b:int):int = if <(a,b) then a else b
    fun max(a:int, b:int):int = if >(a,b) then a else b
    fun op rem(a:int,b:int):int =  -(a, *(b, quot(a, b)))
(*
    fun abs(a:int):int = if >(a, 0) then ~(a) else a
    fun op div(a:int, b:int):int = if >=(b, 0)
	  then if >=(a, 0)
	    then quot(a, b)
	    else -(quot(+(a, 1), b), 1)
	  else if >(a,0)
	    then -(quot(-(a, 1), b), 1)
	    else quot(a, b)

    fun op mod(a:int, b:int):int = if >=(b, 0)
	  then if >=(a, 0)
	    then -(a, *(quot(a, b), b))
	    else -(a, +( *(quot(+(a,1), b), b), b))
	  else if >(a, 0)
	    then -(a, +( *(quot(-(a,1), b), b), b))
	  else if =(a, ~2147483648) andalso =(b, ~1)
	    then 0
	    else -(a, * (quot(a, b), b))
*)
    val abs = PreInt.iabs
    val op div = PreInt.idiv
    val op mod = PreInt.imod

    fun sign(0) = 0
      | sign i = if <(i, 0) then ~1 else 1

    fun sameSign(i, j) = let val x : int = andb(xorb(i, j), minIntVal)
			 in  =(x,0)
			 end


    fun compare (i:int, j:int) =
	  if (<(i, j)) then LESS
	  else if (>(i, j)) then GREATER
	  else EQUAL

    val scan = NumScan.scanInt
    val fmt = NumFormat.fmtInt
    val toString = fmt StringCvt.DEC
    val fromString = StringCvt.scanString (scan StringCvt.DEC)

(*
    val toInt : int -> Int.int = toInt
    val fromInt : Int.int -> int = fromInt
    val toLarge : int -> LargeInt.int = toLarge
    val fromLarge : LargeInt.int -> int = fromLarge
*)
    fun toInt (x : int) : TiltPrim.int32 = x
    fun fromInt (x : TiltPrim.int32) : int = x
    fun toLarge (x : int) : PreLargeInt.int = x
    fun fromLarge (x : TiltPrim.int32) : int = x

  end



(* Int32 *)

(* Int *)

structure Int = Int32

(* Int *)

structure Position = Int32

structure LargeInt = Int32

structure SysInt = Int32

(* TiltFC *)
(*
	The corresponding runtime functions should probably throw
	SysErr for unsupported modes.

	The basis library assumes all rounding modes are supported but
	only uses the default precision and DOUBLE.
*)
structure TiltFc =
struct

	datatype rounding_mode =
		TO_NEAREST
	|	TO_NEGINF
	|	TO_POSINF
	|	TO_ZERO

	datatype precision =
		SINGLE
	|	DOUBLE
	|	EXTENDED

	fun ccall2 (f : ('a, 'b, 'c cresult) -->, a:'a, b:'b) : 'c =
		(case (Ccall(f,a,b)) of
			Normal r => r
		|	Error e => raise e)

	(* Must agree with the runtime. *)
	val getfc : unit -> rounding_mode * precision =
		fn () =>
		let	val (r,p) = Ccall(getfc,())
			val p =
				(case p of
					0 => SINGLE
				|	1 => DOUBLE
				|	2 => EXTENDED)
			val r =
				(case r of
					0 => TO_NEAREST
				|	1 => TO_ZERO
				|	2 => TO_POSINF
				|	3 => TO_NEGINF)
		in	(r,p)
		end

	(* Must agree with the runtime. *)
	val setfc : rounding_mode * precision -> unit =
		fn (r,p) =>
		let	val p =
				(case p of
					SINGLE => 0
				|	DOUBLE => 1
				|	EXTENDED => 2)
			val r =
				(case r of
					TO_NEAREST => 0
				|	TO_ZERO => 1
				|	TO_POSINF => 2
				|	TO_NEGINF => 3)
		in	ccall2(setfc,r,p)
		end

end


(* TiltFC *)

(* math64c *)
structure Math64 (*:> MATH where type real = real *) =
  struct
    (* Respects NaN on x86. *)
    fun float_eq (a:real, b:real) : bool =
	TiltPrim.fgte(a,b) andalso TiltPrim.fgte(b,a)
    val floor = TiltPrim.float2int

    (* div and mod will eventually be overloaded to work at multiple types *)
    val div = PreInt.idiv
    val mod = PreInt.imod

    type real = real

    val NaN = 0.0 / 0.0
    val pi = 3.14159265358979323846
    val e  = 2.7182818284590452354

    (* eta expansion to distingush between ML arrows and external arrows *)
    val sqrt  : real -> real = fn arg => Ccall(sqrt, arg)
    val sin   : real -> real = fn arg => Ccall(sin, arg)
    val cos   : real -> real = fn arg => Ccall(cos, arg)
    val tan   : real -> real = fn arg => Ccall(tan, arg)
    val asin  : real -> real = fn arg =>
	if arg < ~1.0 orelse arg > 1.0 then NaN else Ccall(asin,arg)
    val acos  : real -> real = fn arg =>
	if arg < ~1.0 orelse arg > 1.0 then NaN else Ccall(acos,arg)
    val atan  : real -> real = fn arg => Ccall(atan, arg)
    val exp   : real -> real = fn arg => Ccall(exp, arg)
    val ln    : real -> real = fn arg =>
	if arg < 0.0 then NaN else Ccall(ln, arg)
    val log10 : real -> real = fn arg => Ccall(log10, arg)
    val sinh  : real -> real = fn arg => Ccall(sinh, arg)
    val cosh  : real -> real = fn arg => Ccall(cosh, arg)
    val tanh  : real -> real = fn arg => Ccall(tanh, arg)

    infix 4 ==
    val (op ==) = float_eq
    local
	val one = 1.0
	val PIo2   =  1.5707963267948966192E0
	val PI = pi
	fun atanpy y = (* y>=0 *)
	    if y>one then PIo2 - atan(one/y) else atan(y)

	fun atan2pypx(x,y) =
	    if y>x then PIo2 - atan(x/y) else atan(y/x)

	fun atan2py(x,y) =
	    if x == 0.0 andalso y == 0.0 then 0.0
	    else if x >= 0.0 then atan2pypx(x,y)
	    else PI - atan2pypx(~x,y)

    in  fun atan y = (* miraculously handles inf's and nan's correctly *)
	if y<=0.0 then ~(atanpy(~y)) else atanpy y
	fun atan2(y,x) = (* miraculously handles inf's and nan's correctly *)
	    if y>=0.0 then atan2py(x,y) else ~(atan2py(x,~y))
    end

    local
	val zero = 0.0
	fun copysign(a,b) = (case (a<zero, b<zero)
				 of (true,true) => a
			       | (false,false) => a
			       | _ => ~a)
	fun isNaN x = not(x==x)
	val plusInfinity = 1E300 * 1E300
	val minusInfinity = ~plusInfinity

        (* This is the IEEE double-precision maxint; won't work accurately on VAX *)
	val maxint = 4503599627370496.0

	(* realround(x) returns x rounded to some nearby integer, almost always
	 * the nearest integer.
	 *  May be applied to inf's and nan's.
	 *)
	fun realround x =
	    let val fc = TiltFc.getfc()
		val () = TiltFc.setfc(#1 fc,TiltFc.DOUBLE)
		val x = if x>=0.0 then x+maxint-maxint else x-maxint+maxint
		val () = TiltFc.setfc fc
	    in  x
	    end
	fun isInt y = realround(y)-y == 0.0
	fun isOddInt(y) = isInt((y-1.0)*0.5)
	fun intpow(x,0) = 1.0
	  | intpow(x,y) = let val h = y div 2
			      val z = intpow(x,h)
			      val zz = z*z
			  in if y=(h+h) then zz else x*zz
			  end
	(* may be applied to inf's and nan's *)
	fun abs x = if x < zero then ~x else x
    in
	fun pow(x : real,y : real) =
	    if y>0.0
		then if y<plusInfinity
			 then if x > minusInfinity
			 then if x > 0.0
				then exp(y*ln(x))
				else if x == 0.0
			          then if isOddInt(y)
				       then x
				       else 0.0
			          else if isInt(y)
				       then intpow(x,floor(y+0.5))
				       else NaN
			 else if isNaN x
			  then x
			  else if isOddInt(y)
				then x
				else plusInfinity
		   else let val ax = abs(x)
			 in if ax>1.0 then plusInfinity
			    else if ax<1.0 then 0.0
			    else NaN
                        end
               else if y < 0.0
	         then if y>minusInfinity
		   then if x > minusInfinity
			then if x > 0.0
		             then exp(y*ln(x))
			     else if x==0.0
			          then if isOddInt(y)
		  		     then copysign(plusInfinity,x)
			             else plusInfinity
				  else if isInt(y)
				       then 1.0 / intpow(x, floor(~y+0.5))
				       else NaN
			else if isNaN x
			 then x
			 else if isOddInt(y)
			     then ~0.0
			     else 0.0
		   else let val ax = abs(x)
			 in if ax>1.0 then 0.0
			    else if ax<1.0 then plusInfinity
			    else NaN
                        end
               else if isNaN y
		 then y
	       else 1.0
    end
  end

(* math64c *)

structure Math = Math64

(* ieee-real.sml
 *
 * COPYRIGHT (c) 1996 AT&T Bell Laboratories.
 *)

structure IEEEReal (*:> IEEE_REAL *)=
  struct

    exception Unordered

    datatype real_order = LESS | EQUAL | GREATER | UNORDERED

    datatype nan_mode = QUIET | SIGNALLING

    datatype float_class
      = NAN of nan_mode
      | INF
      | ZERO
      | NORMAL
      | SUBNORMAL

    datatype rounding_mode = datatype TiltFc.rounding_mode

    fun setRoundingMode (r:rounding_mode) : unit =
	let val (_,p) = TiltFc.getfc()
	    val () = TiltFc.setfc(r,p)
	in  ()
	end

    fun getRoundingMode () : rounding_mode =
	#1(TiltFc.getfc())

    type decimal_approx = {
	kind : float_class,
	sign : bool,
	digits : int list,
	exp : int
      }

    fun toString {kind, sign, digits, exp} = let
	  fun fmtExp 0 = []
	    | fmtExp i = ["E", Int.toString i]
	  fun fmtDigits ([], tail) = tail
	    | fmtDigits (d::r, tail) = (Int.toString d) :: fmtDigits(r, tail)
	  in
	    case (sign, kind, digits)
	     of (true, ZERO, _) => "~0.0"
	      | (false, ZERO, _) => "0.0"
	      | (true, NORMAL, []) => "~0.0"
	      | (true, SUBNORMAL, []) => "~0.0"
	      | (false, NORMAL, []) => "0.0"
	      | (false, SUBNORMAL, []) => "0.0"
	      | (true, NORMAL, _) =>
		  String.concat("~0." :: fmtDigits(digits, fmtExp exp))
	      | (true, SUBNORMAL, _) =>
		  String.concat("~0." :: fmtDigits(digits, fmtExp exp))
	      | (false, NORMAL, _) =>
		  String.concat("0." :: fmtDigits(digits, fmtExp exp))
	      | (false, SUBNORMAL, _) =>
		  String.concat("0." :: fmtDigits(digits, fmtExp exp))
	      | (true, INF, _) => "~inf"
	      | (false, INF, _) => "inf"
	      | (_, NAN _, []) => "nan"
	      | (_, NAN _, _) => String.concat("nan(" :: fmtDigits(digits, [")"]))
	    (* end case *)
	  end

(** TODO: implement fromString **)
    fun fromString s = NONE

  end;
(* ieee-real *)

(* real-format.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 * Code for converting from real (IEEE 64-bit floating-point) to string.
 * This ought to be replaced with David Gay's conversion algorithm.
 *
 *)

structure RealFormat : sig

    val fmtReal : StringCvt.realfmt -> real -> string

  end = struct
    (* Respects NaN on x86. *)
    fun float_eq (a:real, b:real) : bool =
	TiltPrim.fgte(a,b) andalso TiltPrim.fgte(b,a)
    val float_neq = not o float_eq
    val floor = TiltPrim.float2int
    val floor = 
      fn r =>
      let val a = TiltPrim.float2int r
      in  if (TiltPrim.int2float a) <= r then a
	  else TiltPrim.iminus(a,1)
      end

    val int32touint32 = TiltPrim.int32touint32
    val unsafe_vsub = TiltPrim.unsafe_vsub8

    infix 4 == !=

    val plus : int * int -> int = op +
    val minus : int * int -> int = op -
    val negate : int -> int = ~
    val gt : int * int -> bool = op >
    val lt : int * int -> bool = op <
    val gte : int * int -> bool = op >=
    val lte : int * int -> bool = op <=

    val ~ : real -> real = ~
    val op + : real * real -> real = op +
    val op - : real * real -> real = op -
    val op * : real * real -> real = op *
    val op / : real * real -> real = op /
    val op >  : real * real -> bool = op >
    val op <  : real * real -> bool = op <
    val op >= : real * real -> bool = op >=
    val op <= : real * real -> bool = op <=
    val op == : real * real -> bool = float_eq
    val op != : real * real -> bool = float_neq


    val op^  = String.^
    val implode = String.implode
    val concat = String.concat
    val size = String.size


    fun inc i = plus(i, 1)
    fun dec i = minus(i, 1)
    fun min (i, j) = if lt(i, j) then i else j
    fun max (i, j) = if gt(i, j) then i else j

    val atoi = (NumFormat.fmtInt StringCvt.DEC)

    fun zeroLPad (s, wid) = StringCvt.padLeft #"0" wid s
    fun zeroRPad (s, wid) = StringCvt.padRight #"0" wid s

    fun mkDigit d = unsafe_vsub("0123456789", int32touint32 d)

  (* decompose a non-zero real into a list of at most maxPrec significant digits
   * (the first digit non-zero), and integer exponent. The return value
   *   (a::b::c..., exp)
   * is produced from real argument
   *   a.bc... * (10 ^^ exp)
   * If the list would consist of all 9's, the list consisting of 1 followed by
   * all 0's is returned instead.
   *)
    val maxPrec = 15
    fun decompose (f, e, precisionFn) = let
	  fun scaleUp (x, e) =
		if (x < 1.0) then scaleUp(10.0*x, dec e) else (x, e)
	  fun scaleDn (x, e) =
		if (x >= 10.0) then scaleDn(0.1*x, inc e) else (x, e)
	  fun mkdigits (f, 0, odd) = ([], if f < 5.0 then 0
					  else if f > 5.0 then 1
					  else odd)
	    | mkdigits (f, i, _) = let 
		val d = floor f
		val (digits, carry) = mkdigits (10.0 * (f - real d), dec i,
						PreInt.imod(d,2))
		val (digit, c) = (case (d, carry)
		       of (9, 1) => (0, 1)
			| _ => (plus(d, carry), 0)
		      (* end case *))
		in
		  (digit::digits, c)
		end
	  val (f, e) = if (f < 1.0)
		  then scaleUp (f, e)
		else if (f >= 10.0)
		  then scaleDn (f, e)
		  else (f, e)
	  val (digits, carry) = mkdigits(f, max(0, min(precisionFn e, maxPrec)),0)
	  in
	    case carry
	     of 0 => (digits, e)
	      | _ => (1::digits, inc e)
	    (* end case *)
          end

    fun realFFormat (r, prec) = let
	  fun pf e = plus(e, inc prec)
	  fun rtoa (digits, e) = let
		fun doFrac (_, 0, n, l) = PreString.revImplode(n, l)
		  | doFrac ([], p, n, l) = doFrac([], dec p, inc n, #"0"::l)
		  | doFrac (hd::tl, p, n, l) =
		      doFrac(tl, dec p, inc n, (mkDigit hd) :: l)
		fun doWhole ([], e, n, l) = if gte(e, 0)
			then doWhole ([], dec e, inc n, #"0" :: l)
		      else if prec = 0
			then PreString.revImplode(n, l)
			else doFrac ([], prec, inc n, #"." :: l)
		  | doWhole (arg as (hd::tl), e, n, l) = if gte(e, 0)
			then doWhole(tl, dec e, inc n, (mkDigit hd) :: l)
		      else if prec = 0
			then PreString.revImplode(n, l)
			else doFrac(arg, prec, inc n, #"." :: l)
		fun doZeros (_, 0, n, l) = PreString.revImplode(n, l)
		  | doZeros (1, p, n, l) = doFrac(digits, p, n, l)
		  | doZeros (e, p, n, l) = doZeros(dec e, dec p, inc n, #"0" :: l)
		in
		  if gte(e, 0)
		    then doWhole(digits, e, 0, [])
		  else if (prec = 0)
		    then "0"
		    else doZeros (negate e, prec, 2, [#".", #"0"])
		end
	  in
	    if lt(prec, 0) then raise Size else ();
	    if (r < 0.0)
	      then {sign = "~", mantissa = rtoa(decompose(~r, 0, pf))}
	    else if (r > 0.0)
	      then {sign="", mantissa = rtoa(decompose(r, 0, pf))}
	    else if (prec = 0)
	      then {sign="", mantissa = "0"}
	      else {sign="", mantissa = zeroRPad("0.", plus(prec, 2))}
	  end (* realFFormat *)

    fun realEFormat (r, prec) = let
	  fun pf _ = inc prec
	  fun rtoa (sign, (digits, e)) = let
		fun mkRes (m, e) = {sign = sign, mantissa = m, exp = e}
		fun doFrac (_, 0, l)  = implode(List.rev l)
		  | doFrac ([], n, l) = zeroRPad(implode(List.rev l), n)
		  | doFrac (hd::tl, n, l) = doFrac (tl, dec n, (mkDigit hd) :: l)
		in
		  if (prec = 0)
		    then mkRes(String.str(mkDigit(List.hd digits)), e)
		    else mkRes(
		      doFrac(List.tl digits, prec, [#".", mkDigit(List.hd digits)]), e)
		end
	  in
	    if lt(prec, 0) then raise Size else ();
	    if (r < 0.0)
	      then rtoa ("~", decompose(~r, 0, pf))
	    else if (r > 0.0)
	      then rtoa ("", decompose(r, 0, pf))
	    else if (prec = 0)
	      then {sign = "", mantissa = "0", exp = 0}
	      else {sign = "", mantissa = zeroRPad("0.", plus(prec, 2)), exp = 0}
	  end (* realEFormat *)

    fun realGFormat (r, prec) = let
	  fun pf _ = prec
	  fun rtoa (sign, (digits, e)) = let
		fun mkRes (w, f, e) = {sign = sign, whole = w, frac = f, exp = e}
		fun doFrac [] = []
		  | doFrac (0::tl) = (case doFrac tl
		       of [] => []
			| rest => #"0" :: rest
		      (* end case *))
		  | doFrac (hd::tl) = (mkDigit hd) :: (doFrac tl)
		fun doWhole ([], e, wh) =
		      if gte(e, 0)
			then doWhole([], dec e, #"0"::wh)
			else mkRes(implode(List.rev wh), "", NONE)
		  | doWhole (arg as (hd::tl), e, wh) =
		      if gte(e, 0)
			then doWhole(tl, dec e, (mkDigit hd)::wh)
			else mkRes(implode(List.rev wh), implode(doFrac arg), NONE)
		in
		  if lt(e, ~4) orelse gte(e, prec)
		    then mkRes(
		      String.str(mkDigit(List.hd digits)),
		      implode(doFrac(List.tl digits)), SOME e)
		  else if gte(e, 0)
		    then doWhole(digits, e, [])
		    else let
		      val frac = implode(doFrac digits)
		      in
			mkRes("0", zeroLPad(frac, plus(size frac, minus(~1, e))), NONE)
		      end
		end
	  in
	    if lt(prec, 1) then raise Size else ();
	    if (r < 0.0)
	      then rtoa("~", decompose(~r, 0, pf))
	    else if (r > 0.0)
	      then rtoa("", decompose(r, 0, pf))
	      else {sign="", whole="0", frac="", exp=NONE}
	  end (* realGFormat *)

   val infinity = let fun bigger x = let val y = x*x
				     in if y>x then bigger y else x
				     end
                   in bigger 100.0
                  end

   fun fmtInfNan x =
        if x==infinity then "inf"
        else if x == ~infinity then "~inf"
        else "nan"

  (* convert a real number to a string of the form [~]d.dddE[~]dd, where
   * the precision (number of fractional digits) is specified by the
   * second argument.
   *)
    fun realToSciStr prec r =
	if ~infinity < r andalso r < infinity
	then let
	  val {sign, mantissa, exp} = realEFormat (r, prec)
	  in
	    (* minimum size exponent string, no padding *)
	    concat[sign, mantissa, "E", atoi exp]
	  end
        else fmtInfNan r

  (* convert a real number to a string of the form [~]ddd.ddd, where
   * the precision (number of fractional digits) is specified by the
   * second argument.
   *)
    fun realToFixStr prec x =
	if ~infinity < x andalso x < infinity
	then let
	  val {sign, mantissa} = realFFormat (x, prec)
	  in
	    sign^mantissa
	  end
        else fmtInfNan x

      fun realToGenStr prec r = 
	if ~infinity < r andalso r < infinity
	then let
  	  val {sign, whole, frac, exp} = realGFormat(r, prec)
	  val frac = if (frac = "") then frac else "." ^ frac
	  val expStr = (case exp
 		 of NONE => ""
 		  | (SOME e) => "E" ^ atoi e
  		(* end case *))
  	  in
  	    concat[sign, whole, frac, expStr]
  	  end
        else fmtInfNan r

    fun fmtReal (StringCvt.SCI NONE) = realToSciStr 6
      | fmtReal (StringCvt.SCI(SOME prec)) = realToSciStr prec
      | fmtReal (StringCvt.FIX NONE) = realToFixStr 6
      | fmtReal (StringCvt.FIX(SOME prec)) = realToFixStr prec
      | fmtReal (StringCvt.GEN NONE) = realToGenStr 12
      | fmtReal (StringCvt.GEN(SOME prec)) = realToGenStr prec
      | fmtReal StringCvt.EXACT =
	raise TiltExn.LibFail "RealFormat: fmtReal: EXACT not supported"

  end

(* realformat *)

(* real64.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure Real64 (*:> REAL where type real = real
			   and type Math.real = real *) =
  struct
    val abs_float = TiltPrim.fabs
    (* Respects NaN on x86. *)
    fun float_eq (a:real, b:real) : bool =
	TiltPrim.fgte(a,b) andalso TiltPrim.fgte(b,a)
    val float_neq = not o float_eq

    structure Math = Math64
    val real_logb  : real -> int = fn arg => Ccall(real_logb, arg)

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

    fun real_scalb (x, k) = raise TiltExn.LibFail "scalb and real_scalb not implemented: multiarg C fun..."

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
		  if real_logb y = ~1023 then x else f y
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
    fun isNormal x = (case real_logb x
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
	real_scalb(x, negate(real_logb x)) < 0.0

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
	                     else if real_logb x = ~1023
			          then IEEEReal.SUBNORMAL
			          else IEEEReal.NORMAL
	                else if x==x then IEEEReal.INF
			             else IEEEReal.NAN IEEEReal.QUIET
       else if x<posInf then if x == 0.0 then IEEEReal.ZERO
	                     else if real_logb x = ~1023
			          then IEEEReal.SUBNORMAL
			          else IEEEReal.NORMAL
	                else if x==x then IEEEReal.INF
			             else IEEEReal.NAN IEEEReal.QUIET

    val radix = 2
    val precision = 52

    val two_to_the_54 = 18014398509481984.0

    val two_to_the_neg_1000 =
      let fun f(i,x) = if i=0 then x else f(minus(i,1), x*0.5)
       in f(1000, 1.0)
      end

    fun toManExp x =
      case real_logb x
	of ~1023 => if x==0.0 then {man=x,exp=0}
		    else let val {man=m,exp=e} = toManExp(x*1048576.0)
		              in {man=m,exp=minus(e,20)}
			 end
         | 1024 => {man=x,exp=0}
         | i => {man=real_scalb(x,negate i),exp=i}

    fun fromManExp {man=m,exp=e:int} =
      if (m >= 0.5 andalso m <= 1.0  orelse m <= ~0.5 andalso m >= ~1.0)
	then if gt(e, 1020)
	  then if gt(e, 1050) then if m>0.0 then posInf else negInf
	       else let fun f(i,x) = if i=0 then x else f(minus(i,1),x+x)
		       in f(minus(e,1020),  real_scalb(m,1020))
		      end
	  else if lt(e, negate 1020)
	       then if lt(e, negate 1200) then 0.0
		 else let fun f(i,x) = if i=0 then x else f(minus(i,1), x*0.5)
		       in f(minus(1020,e), real_scalb(m,negate 1020))
		      end
	       else real_scalb(m,e)  (* This is the common case! *)
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

(** NOTE logb and scalb are also defined in math64.sml; do we need both??? **)
    fun logb x = (case real_logb x
	   of ~1023 => (* denormalized number *)
		minus(real_logb(x * two_to_the_54), 54)
	    | i => i
	  (* end case *))

(*
  (* This function is IEEE double-precision specific;
     we do not apply it to inf's and nan's *)
    fun scalb (x, k) = if lessu(I.+(k,1022),2046)
	  then Assembly.A.scalb(x,k)
          else let val k1 = I.div(k, 2)
	    in
	      scalb(scalb(x, k1), I.-(k, k1))
	    end
*)
    fun scalb (x, k) = raise TiltExn.LibFail "scalb and real_scalb not implemented: multiarg C fun..."
(*
if lt(plus(k,1022),2046)
	  then Assembly.A.scalb(x,k)
          else let val k1 = div(k, 2)
	    in
	      scalb(scalb(x, k1), minus(k, k1))
	    end
*)

    fun nextAfter _ = raise TiltExn.LibFail "Real.nextAfter unimplemented"

    fun min(x,y) = if x<y orelse isNan y then x else y
    fun max(x,y) = if x>y orelse isNan y then x else y

    fun toDecimal _ = raise TiltExn.LibFail "Real.toDecimal unimplemented"
    fun fromDecimal _ = raise TiltExn.LibFail "Real.fromDecimal unimplemented"

    val fmt = RealFormat.fmtReal
    val toString = fmt (StringCvt.GEN NONE)
    val scan = NumScan.scanReal
    val fromString = StringCvt.scanString scan

  end (* Real64 *)

(* Real64 *)

structure Real = Real64

(* word8.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure LargeReal = Real64


structure Word8 (*:> WORD
    where type word = TiltPrim.uint8 *) =
struct
    type word = TiltPrim.uint8
    type w32 = TiltPrim.uint32

    val !! : w32 -> w32 = TiltPrim.!!	(* notb *)
    val && : w32 * w32 -> w32 = TiltPrim.&& (* andb *)
    val << : w32 * int -> w32 = TiltPrim.<<
    val >> : w32 * int -> w32 = TiltPrim.>>
    val ^^ : w32 * w32 -> w32 = TiltPrim.^^ (* xorb *)
    val || : w32 * w32 -> w32 = TiltPrim.|| (* orb *)
    val ~>> : int * int -> int = TiltPrim.~>>

    val int32touint32 : int -> w32 = TiltPrim.int32touint32
    val uint8toint32 : word -> int = TiltPrim.uint8toint32
    val toi32 : w32 -> int = TiltPrim.uint32toint32
    val tow32 : word -> w32 = TiltPrim.uint8touint32
    val tow8 : w32 -> word = TiltPrim.uint32touint8

    val ugt : w32 * w32 -> bool = TiltPrim.ugt
    val ugte : w32 * w32 -> bool = TiltPrim.ugte
    val ult : w32 * w32 -> bool = TiltPrim.ult
    val ulte : w32 * w32 -> bool = TiltPrim.ulte

    val udiv : w32 * w32 -> w32 = TiltPrim.udiv
    val uminus : w32 * w32 -> w32 = TiltPrim.uminus
    val umod : w32 * w32 -> w32 = TiltPrim.umod
    val uplus : w32 * w32 -> w32 = TiltPrim.uplus
    val umult : w32 * w32 -> w32 = TiltPrim.umult

    fun adapt (w : w32) : word =
	tow8(&& (w, 0wxFF))

    fun sextend (w : word) : w32 =
	let val w32 = tow32 w
	    val neg = &&(w32, 0w128)
	    val mask = int32touint32(~>>(toi32(<<(neg,24)),23))
	in  ||(w32,mask)
	end

    val wordSize = 8

    val toInt : word -> int = uint8toint32
    val toIntX : word -> int = toi32 o sextend
    val fromInt : int -> word = adapt o int32touint32

    val toLargeInt : word -> int = toInt
    val toLargeIntX : word -> int = toIntX
    val fromLargeInt : int -> word = fromInt

    val toLargeWord : word -> w32 = tow32
    val toLargeWordX : word -> w32 = sextend
    val fromLargeWord : w32 -> word = adapt

    fun lshift (w : word, k : w32) : word =
	if ulte(0w8,k) then 0w0
	else adapt(<<(tow32 w, toi32 k))

    fun rshiftl (w : word, k : w32) : word =
	if ulte(0w8,k) then 0w0
	else tow8(>>(tow32 w, toi32 k))

    fun rshifta (w : word, k : w32) : word =
	let val h : int = toi32(<<(tow32 w,24))
	    val k : int =
		if ulte(0w8,k) then 31
		else 24 + (toi32 k)
	in  adapt(int32touint32(~>>(h,k)))
	end

    nonfix << >> ~>> + - * div mod <= = >= < >

    val << = lshift
    val >> = rshiftl
    val ~>> = rshifta

    fun orb (x : word, y : word) : word = tow8(||(tow32 x, tow32 y))
    fun andb (x : word, y : word) : word = tow8(&&(tow32 x, tow32 y))
    fun xorb (x : word, y : word) : word = tow8(^^(tow32 x, tow32 y))
    fun notb (x : word) : word = adapt(!!(tow32 x))

    fun + (x : word, y : word) : word = adapt(uplus(tow32 x, tow32 y))
    fun - (x : word, y : word) : word = adapt(uminus(tow32 x, tow32 y))
    fun * (x : word, y : word) : word = adapt(umult(tow32 x, tow32 y))
    fun div (x : word, y : word) : word = tow8(udiv(tow32 x, tow32 y))
    fun mod (x : word, y : word) : word = tow8(umod(tow32 x, tow32 y))

    fun compare (x : word, y : word) : order =
	let val x = tow32 x
	    val y = tow32 y
	 in if ult(x,y) then LESS
	    else if ugt(x,y) then GREATER
	    else EQUAL
	end

    fun > (x : word, y : word) : bool = ugt(tow32 x, tow32 y)
    fun >= (x : word, y: word) : bool = ugte(tow32 x, tow32 y)
    fun < (x : word, y: word) : bool = ult(tow32 x, tow32 y)
    fun <= (x : word, y: word) : bool = ulte(tow32 x, tow32 y)

    fun min (x : word, y : word) : word = if <(x,y) then x else y
    fun max (x : word, y : word) : word = if <(x,y) then y else x

    fun fmt (radix : StringCvt.radix) : word -> string =
	(NumFormat.fmtWord radix) o tow32

    val toString : word -> string =
	fmt StringCvt.HEX

    type ('ty,'stream) scanner =
	(char,'stream) StringCvt.reader -> ('ty,'stream) StringCvt.reader

    fun scan (radix : StringCvt.radix) : (word,'stream) scanner =
	let val scanLarge : (w32,'stream) scanner =
		NumScan.scanWord radix
	in  fn (getc : 'stream -> (char * 'stream) option) =>
	    fn (s : 'stream) =>
		(case (scanLarge getc s) of
		    NONE => NONE
		|   SOME(w,s') =>
			if ugt(w,0w255) then raise Overflow
			else SOME(tow8 w,s'))
	end

    val fromString : string -> word option =
	StringCvt.scanString (scan StringCvt.HEX)

end

(* word32.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)


structure Word32 (*:> WORD where type word = word *) =
  struct
    val !! = TiltPrim.!!
    val && = TiltPrim.&&
    val << = TiltPrim.<<
    val >> = TiltPrim.>>
    val ^^ = TiltPrim.^^
    val || = TiltPrim.||
    val ~>> = TiltPrim.~>>

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val ugt = TiltPrim.ugt
    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult
    val ulte = TiltPrim.ulte

    val udiv = TiltPrim.udiv
    val umod = TiltPrim.umod
    val uminus = TiltPrim.uminus
    val umult = TiltPrim.umult
    val uplus = TiltPrim.uplus

    type word = TiltPrim.uint32

    val wordSize = 32
    val wordSizeW = 0w32

    (* the X versions treat the word as signed *)
    fun toInt   (x : word) : int = if (ult(x,0wx7fffffff))
				       then uint32toint32 x else raise Overflow
    fun toIntX  (x : word) : int = uint32toint32 x
    fun fromInt (x : int) : word = int32touint32 x

    val toLargeInt   : word -> int = toInt
    val toLargeIntX  : word -> int = toIntX
    val fromLargeInt : int -> word = fromInt

    fun toLargeWord (x : word) : PreLargeWord.word = x
    fun toLargeWordX (x : word) : PreLargeWord.word = x
    fun fromLargeWord (x : PreLargeWord.word) : word = x

    val toi32 = uint32toint32



  (** These should be inline functions **)
    fun lshift (w : word, k) = if ulte(wordSizeW, k)
					 then 0w0
				     else <<(w, toi32 k)
    fun rshiftl (w : word, k) = if ulte(wordSizeW, k)
					  then 0w0
				      else >>(w, toi32 k)
    fun rshifta (w : word, k) = int32touint32
				      (if ulte(wordSizeW, k)
					   then ~>>(toi32 w, 31)
				       else ~>>(toi32 w, toi32 k))

    nonfix << >> ~>> + - * div mod <= = >= < > || && ^^
    val << = lshift
    val >> = rshiftl
    val ~>> = rshifta

    val orb  : word * word -> word = ||
    val xorb  : word * word -> word = ^^
    val andb : word * word -> word = &&
    val notb : word -> word = !!

    val +  : (word * word -> word) = uplus
    val -  : (word * word -> word) = uminus
    val *  : (word * word -> word) = umult
    val div  : (word * word -> word) = udiv
    val mod  : (word * word -> word) = umod


    fun compare (w1, w2) =
      if (ult(w1, w2)) then LESS
	 else if (ugt(w1, w2)) then GREATER
	      else EQUAL

    val >  : (word * word -> bool) = ugt
    val >=  : (word * word -> bool) = ugte
    val <  : (word * word -> bool) = ult
    val <=  : (word * word -> bool) = ulte

    fun min (w1, w2) = if <(w1,w2) then w1 else w2
    fun max (w1, w2) = if >(w1,w2) then w1 else w2

    fun fmt radix = (NumFormat.fmtWord radix)
    val toString = fmt StringCvt.HEX

    val scan = NumScan.scanWord
    val fromString = StringCvt.scanString (NumScan.scanWord StringCvt.HEX)

  end  (* structure Word32 *)

(* Word32 *)

structure Word = Word32

structure LargeWord = Word32

structure SysWord = Word32

(* array.sml
 *
 * COPYRIGHT (c) 1994 AT&T Bell Laboratories.
 *
 *)

structure Array (*:> ARRAY where type 'a array = 'a array
			   and type 'a vector = 'a vector*) =
  struct
    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val array_length = TiltPrim.array_length
    val empty_array = TiltPrim.empty_array
    val empty_vector = TiltPrim.empty_vector
    val unsafe_array = TiltPrim.unsafe_array
    val unsafe_sub = TiltPrim.unsafe_sub
    val unsafe_update = TiltPrim.unsafe_update
    val unsafe_vsub = TiltPrim.unsafe_vsub
    val vector_length = TiltPrim.vector_length

    val unsafe_array2vector = TiltPrim.unsafe_array2vector

    val ugt = TiltPrim.ugt
    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult
    val ulte = TiltPrim.ulte

    val uminus = TiltPrim.uminus
    val uplus = TiltPrim.uplus

    val maxLen = PreVector.maxLen
    val checkLen = PreVector.checkLen
    val fromList' = PreVector.arrayFromList'
    val fromList = PreVector.arrayFromList

    type 'a array = 'a array
    type 'a vector = 'a vector

    val array0 : 'a array = empty_array
    val vector0 : 'a vector = empty_vector

    fun array (0, _) = array0
      | array (n, init) = (checkLen n;
			   unsafe_array(int32touint32 n, init))

    fun rev ([], l) = l
      | rev (x::r, l) = rev (r, x::l)

    fun tabulate (0, _) = array0
      | tabulate (n, f) : 'a array =
          let val _ = if (n < 0) then raise Size else ()
	      val a = array(n, f 0)
	      val n = int32touint32 n
              fun tab i =
                if ult(i,n) then (unsafe_update(a, i, f (uint32toint32 i));
				  tab(uplus(i,0w1)))
                else a
           in tab 0w1
          end

    fun length (ar : 'a array) : int = uint32toint32(array_length ar)

    fun sub (a : 'a array, index :int) : 'a =
	let val index = int32touint32 index
	in  unsafe_sub(a,index)
	end
    fun update (a, index :int, e : 'a) : unit =
	let val index = int32touint32 index
	in  unsafe_update(a,index,e)
	end

    fun extract (v, base : int, optLen : int option) = let
	  val len = length v
	  fun newVec (n : int) = let
		fun tab (~1, l) = unsafe_array2vector(fromList'(n,l))
		  | tab (i, l) = tab(i-1, (unsafe_sub(v, int32touint32(base+i)))::l)
		in  tab (n-1, [])
		end
	  in
	    case (base, optLen)
	     of (0, NONE) => if (0 < len) then newVec len else vector0
	      | (_, SOME 0) => if ((base < 0) orelse (len < base))
		  then raise Subscript
		  else vector0
	      | (_, NONE) => if ((base < 0) orelse (len < base))
		    then raise Subscript
		  else if (len = base)
		    then vector0
		    else newVec (len - base)
	      | (_, SOME n) =>
		  if ((base < 0) orelse (n < 0) orelse (len < (base+n)))
		    then raise Subscript
		    else newVec n
	    (* end case *)
	  end

    fun copy {src, si=si', len, dst, di} =
        let

            val (sstop', dstop') =
                let val srcLen = length src
                in  case len
                    of NONE => if ((si' < 0) orelse (srcLen < si'))
                                   then raise Subscript
                               else (srcLen, di+srcLen-si')
                  | (SOME n) => if ((n < 0) orelse (si' < 0) orelse (srcLen < si'+n))
                                    then raise Subscript
                                else (si'+n, di+n)
                (* end case *)
                end

            val sstop = int32touint32 sstop'
            val dstop = int32touint32 dstop'
            val si = int32touint32 si'
            fun copyUp (j, k) = if ult(j,sstop)
                                    then (unsafe_update(dst, k, unsafe_sub(src, j));
                                          copyUp (uplus(j,0w1),uplus(k,0w1)))
                                else ()

        (* check to continue *after* update; otherwise we might underflow j  - Tom 7 *)
            fun copyDown (j, k) =
                let in
                    unsafe_update(dst, k, unsafe_sub(src, j));
                    if ult(si,j) then copyDown (uminus(j, 0w1),
                                                uminus(k, 0w1))
                    else ()
                end

        in  if ((di < 0) orelse (length dst < dstop'))
                then raise Subscript
            else if (si' < di) then
                if (0w0 = sstop) then ()
                else copyDown (uminus(sstop,0w1), uminus(dstop,0w1))
              else copyUp (si, int32touint32 di)
        end


    fun copyVec {src, si, len, dst, di} = let
	  val (sstop', dstop') = let
		val srcLen = uint32toint32(vector_length src)
		in
		  case len
		   of NONE => if ((si < 0) orelse (srcLen < si))
		        then raise Subscript
		        else (srcLen, di+srcLen-si)
		    | (SOME n) => if ((n < 0) orelse (si < 0) orelse (srcLen < si+n))
		        then raise Subscript
		        else (si+n, di+n)
		  (* end case *)
		end
	  val sstop = int32touint32 sstop'
	  val dstop = int32touint32 dstop'
	  fun copyUp (j, k) = if ult(j,sstop)
		then (unsafe_update(dst, k, unsafe_vsub(src, j));
		      copyUp (uplus(j,0w1),uplus(k,0w1)))
		else ()
	  in
	    if ((di < 0) orelse (length dst < dstop'))
	      then raise Subscript
	      else copyUp (int32touint32 si, int32touint32 di)
	  end

    fun app f arr = let
	  val len = array_length arr
	  fun app i = if ult(i,len)
			  then (f (unsafe_sub(arr, i)); app(uplus(i,0w1)))
		      else ()
	  in
	    app 0w0
	  end

    fun foldl f init arr = let
	  val len = array_length arr
	  fun fold (i, accum) = if ult(i,len)
				    then fold (uplus(i,0w1), f (unsafe_sub(arr, i), accum))
				else accum
	  in
	    fold (0w0, init)
	  end

    fun chkSlice (vec, i, NONE) = let val len = length vec
	  in
	    if (len < i)
	      then raise Subscript
	      else (vec, int32touint32 i, int32touint32 len)
	  end
      | chkSlice (vec, i, SOME n) = let val len = length vec
	  in
	    if ((0 <= i) andalso (0 <= n) andalso (i+n <= len))
	      then (vec, int32touint32 i, int32touint32(i+n))
	      else raise Subscript
	  end

    fun foldr f init arr =
	let
	    fun fold (i, accum) =
		let val accum' = f (unsafe_sub(arr, i), accum)
		in  if (i = 0w0)
			then accum'
		    else fold (uminus(i,0w1), accum')
		end
	    val len = length arr
	in  if len = 0 then init else fold (int32touint32(len - 1), init)
	end


    fun modify f arr = let
	  val len = array_length arr
	  fun modify' i = if ult(i,len)
			      then (unsafe_update(arr, i, f (unsafe_sub(arr, i)));
				    modify'(uplus(i,0w1)))
		else ()
	  in
	    modify' 0w0
	  end



    fun appi f slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun app i = if ult(i,stop)
		then (f (uint32toint32 i, unsafe_sub(vec, i)); app(uplus(i,0w1)))
		else ()
	  in
	    app start
	  end

    fun mapi f slice = let
	  val (vec, start, stop) = chkSlice slice
	  val len = uminus(stop,start)
	  fun mapf (i, l) = if ult(i,stop)
		then mapf (uplus(i,0w1), f (uint32toint32 i, unsafe_sub(vec, i)) :: l)
		else fromList'(uint32toint32 len, rev(l, []))
	  in
	    if ugt(len,0w0)
	      then mapf (start, [])
	      else array0
	  end

    fun foldli f init slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun fold (i, accum) = if ult(i,stop)
				    then fold (uplus(i,0w1), f (uint32toint32 i,
								unsafe_sub(vec, i), accum))
				else accum
	  in  fold (start, init)
	  end

    fun foldri f init slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun fold (i, accum) = if ugt(i,start)
		then let val i' = uminus(i,0w1)
		     in fold (i', f (uint32toint32 i', unsafe_sub(vec, i'), accum))
		     end
		else accum
	  in
	    fold (stop, init)
	  end

    fun modifyi f slice = let
	  val (arr, start, stop) = chkSlice slice
	  fun modify' i = if ult(i,stop)
		then (unsafe_update(arr, i,
				    f (uint32toint32 i, unsafe_sub(arr, i)));
		      modify'(uplus(i,0w1)))
		else ()
	  in
	    modify' start
	  end


  end (* structure Array *)

structure PreVector8 :
    sig
	val maxLen : int
	val checkLen : int -> unit
	val arrayFromList' : int * char list -> TiltPrim.word8array (* known length *)
	val arrayFromList : char list -> TiltPrim.word8array
	val vectorFromList' : int * char list -> TiltPrim.word8vector (* known length *)
	val vectorFromList : char list -> TiltPrim.word8vector
    end =
struct

    fun list_length l =
	let
	    fun len ([], n) = n
	      | len ([_], n) = n+1
	      | len (_::_::r, n) = len(r, n+2)
	in  len (l, 0)
	end
    fun list_hd' (h :: _) = h		(* list_hd' nil does not behave like List.hd nil *)

    val maxLen = 1024 * 1024
    fun checkLen n = if maxLen < n then raise Size else ()

    fun arrayFromList'(n,l) =
	let val _ = checkLen n
	in
	    if (n = 0)
		then TiltPrim.empty_array8
	    else let val e = list_hd' l
		     val ar = TiltPrim.unsafe_array8(TiltPrim.int32touint32 n, e)
		     fun loop [] _ = ()
		       | loop (a::b) n = (TiltPrim.unsafe_update8(ar,n,a);
					  loop b (TiltPrim.uplus(n,0w1)))
		     val _ = loop l 0w0
		 in  ar
		 end
	end

    fun arrayFromList l = arrayFromList' (list_length l, l)

    fun vectorFromList' arg = TiltPrim.unsafe_array2vector8(arrayFromList' arg)

    fun vectorFromList arg = TiltPrim.unsafe_array2vector8(arrayFromList arg)
end


(* PreVector8 *)

(* vector.sml
 *
 * COPYRIGHT (c) 1994 AT&T Bell Laboratories.
 *
 *)

structure Vector (*:> VECTOR where type 'a vector = 'a vector*) =
  struct

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val empty_vector = TiltPrim.empty_vector
    val unsafe_array = TiltPrim.unsafe_array
    val unsafe_update = TiltPrim.unsafe_update
    val unsafe_vsub = TiltPrim.unsafe_vsub
    val vector_length = TiltPrim.vector_length

    val unsafe_array2vector = TiltPrim.unsafe_array2vector
    val unsafe_vector2array = TiltPrim.unsafe_vector2array

    val ugt = TiltPrim.ugt
    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult

    val uminus = TiltPrim.uminus
    val uplus = TiltPrim.uplus

    val maxLen = PreVector.maxLen
    val checkLen = PreVector.checkLen
    val fromList' = PreVector.vectorFromList'
    val fromList = PreVector.vectorFromList

    type 'a vector = 'a vector

    val vector0 : 'a vector = empty_vector

    fun tabulate(n,f) = unsafe_array2vector(Array.tabulate(n,f))
    fun length (a : 'a vector) : int = uint32toint32(vector_length a)

    fun sub (a : 'a vector, index :int) : 'a =
	let val index = int32touint32 index
	in unsafe_vsub(a,index)
	end


  (* a utility function *)
    fun rev ([], l) = l
      | rev (x::r, l) = rev (r, x::l)

    fun extract (v : 'a vector, base : int, optLen : int option) =
	Array.extract (unsafe_vector2array v, base, optLen)

    fun concat [v] = v
      | concat vl = let
	(* get the total length and flatten the list *)
	  fun len ([], n, l) = (checkLen n; (n, rev(l, [])))
	    | len (v::r, n, l) = let
		val n' = length v
		fun explode (i, l) = if (i < n')
		      then explode(i+1, unsafe_vsub(v, int32touint32 i)::l)
		      else l
		in
		  len (r, n + n', explode(0, l))
		end
	  in
	    case len (vl, 0, [])
	     of (0, _) => vector0
	      | (n, l) => fromList'(n, l)
	    (* end case *)
	  end

    fun map f vec = let
          val len = vector_length vec
          fun mapf (i, l) = if ult(i,len)
                then mapf (uplus(i,0w1), f (unsafe_vsub(vec, i)) :: l)
                else fromList'(uint32toint32 len, rev(l, []))
          in
            if ugt(len,0w0)
              then mapf (0w0, [])
              else vector0
          end

    fun chkSlice (vec, i, NONE) = let val len = length vec
	  in
	    if (len < i)
	      then raise Subscript
	      else (vec, int32touint32 i, int32touint32 len)
	  end
      | chkSlice (vec, i, SOME n) = let val len = length vec
	  in
	    if ((0 <= i) andalso (0 <= n) andalso (i+n <= len))
	      then (vec, int32touint32 i, int32touint32(i+n))
	      else raise Subscript
	  end
     fun mapi f slice = let
          val (vec, start, stop) = chkSlice slice
          val len = uminus(stop,start)
          fun mapf (i, l) = if ult(i,stop)
                then mapf (uplus(i,0w1), f (uint32toint32 i, unsafe_vsub(vec, i)) :: l)
                else fromList'(uint32toint32 len, rev(l, []))
          in
            if ugt(len,0w0)
              then mapf (start, [])
              else vector0
          end

    fun app f vec = Array.app f (unsafe_vector2array vec)
    fun foldl f init vec = Array.foldl f init (unsafe_vector2array vec)
    fun foldr f init vec = Array.foldr f init (unsafe_vector2array vec)
    fun appi f (vec,start,len) = Array.appi f (unsafe_vector2array vec,start,len)
    fun foldli f acc (vec,start,len) = Array.foldli f acc (unsafe_vector2array vec,start,len)
    fun foldri f acc (vec,start,len) = Array.foldri f acc (unsafe_vector2array vec,start,len)




  end  (* Vector *)


(* Tal Vector *)

(* XENDX*)
(* word8-vector.sml specialized copy of vector.sml
 *
 * COPYRIGHT (c) 1994 AT&T Bell Laboratories.
 *
 *)

structure Word8Vector (*:> MONO_VECTOR where type elem = char
				       and type vector = string *) =
  struct

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val empty_vector = TiltPrim.empty_vector8
    val unsafe_array = TiltPrim.unsafe_array8
    val unsafe_update = TiltPrim.unsafe_update8
    val unsafe_vsub = TiltPrim.unsafe_vsub8
    val vector_length = TiltPrim.vector_length8

    val unsafe_array2vector = TiltPrim.unsafe_array2vector8
    val unsafe_vector2array = TiltPrim.unsafe_vector2array8

    val ugt = TiltPrim.ugt
    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult

    val uminus = TiltPrim.uminus
    val uplus = TiltPrim.uplus

    type elem = char
    type vector = TiltPrim.word8vector

    val maxLen = PreVector8.maxLen

    fun checkLen n = if maxLen < n then raise Size else ()
    val vector0 : vector = empty_vector

    val fromList' = PreVector8.vectorFromList'
    val fromList = PreVector8.vectorFromList

    fun tabulate (0, _) = vector0
      | tabulate (n, f) : TiltPrim.word8vector =
      let 
	val _ = if (n < 0) orelse (maxLen < n) then raise Size else ()
	val n = int32touint32 n
	val a = unsafe_array(n, f 0)

	fun tab i =
	  if ult(i,n) then (unsafe_update(a, i, f (uint32toint32 i));
			    tab(uplus(i,0w1)))
	  else a
	val arr = tab 0w1
      in unsafe_array2vector arr
      end

    fun length (a : vector) : int = uint32toint32(vector_length a)

    fun sub (a : vector, index :int) =
	let val index = int32touint32 index
	in unsafe_vsub(a,index)
	end

  (* a utility function *)
    fun rev ([], l) = l
      | rev (x::r, l) = rev (r, x::l)

    fun extract (v, base : int, optLen : int option) = 
      let
	val len = length v
	fun newVec (n : int) = 
	  let
	    fun tab (~1, l) = fromList'(n,l)
	      | tab (i, l) = tab(i-1, (unsafe_vsub(v, int32touint32(base+i)))::l)
	  in  tab (n-1, [])
	  end
      in
	case (base, optLen)
	  of (0, NONE) => if (0 < len) then newVec len else vector0
	   | (_, SOME 0) => if ((base < 0) orelse (len < base))
			      then raise Subscript
			    else vector0
	   | (_, NONE) => if ((base < 0) orelse (len < base))
			    then raise Subscript
	   else if (len = base)
		  then vector0
		else newVec (len - base)
	   | (_, SOME n) =>
		  if ((base < 0) orelse (n < 0) orelse (len < (base+n)))
		    then raise Subscript
		  else newVec n
      (* end case *)
      end

    fun concat [v] = v
      | concat vl = let
	(* get the total length and flatten the list *)
	  fun len ([], n, l) = (checkLen n; (n, rev(l, [])))
	    | len (v::r, n, l) = let
		val n' = length v
		fun explode (i, l) = if (i < n')
		      then explode(i+1, unsafe_vsub(v, int32touint32 i)::l)
		      else l
		in
		  len (r, n + n', explode(0, l))
		end
	  in
	    case len (vl, 0, [])
	     of (0, _) => vector0
	      | (n, l) => fromList'(n, l)
	    (* end case *)
	  end

    fun map f vec = let
          val len = vector_length vec
          fun mapf (i, l) = if ult(i,len)
                then mapf (uplus(i,0w1), f (unsafe_vsub(vec, i)) :: l)
                else fromList'(uint32toint32 len, rev(l, []))
          in
            if ugt(len,0w0)
              then mapf (0w0, [])
              else vector0
          end

    fun chkSlice (vec, i, NONE) = let val len = length vec
	  in
	    if (len < i)
	      then raise Subscript
	      else (vec, int32touint32 i, int32touint32 len)
	  end
      | chkSlice (vec, i, SOME n) = let val len = length vec
	  in
	    if ((0 <= i) andalso (0 <= n) andalso (i+n <= len))
	      then (vec, int32touint32 i, int32touint32(i+n))
	      else raise Subscript
	  end
     fun mapi f slice = let
          val (vec, start, stop) = chkSlice slice
          val len = uminus(stop,start)
          fun mapf (i, l) = if ult(i,stop)
                then mapf (uplus(i,0w1), f (uint32toint32 i, unsafe_vsub(vec, i)) :: l)
                else fromList'(uint32toint32 len, rev(l, []))
          in
            if ugt(len,0w0)
              then mapf (start, [])
              else vector0
          end
    fun app f vec = let
	  val len = vector_length vec
	  fun app i = if ult(i,len)
			  then (f (unsafe_vsub(vec, i)); app(uplus(i,0w1)))
		      else ()
	  in
	    app 0w0
	  end

    fun foldl f init vec = let
	  val len = vector_length vec
	  fun fold (i, accum) = if ult(i,len)
				    then fold (uplus(i,0w1), f (unsafe_vsub(vec, i), accum))
				else accum
	  in
	    fold (0w0, init)
	  end

    fun foldr f init vec =
	let
	    fun fold (i, accum) =
		let val accum' = f (unsafe_vsub(vec, i), accum)
		in  if (i = 0w0)
			then accum'
		    else fold (uminus(i,0w1), accum')
		end
	    val len = length vec
	in  if len = 0 then init else fold (int32touint32(len - 1), init)
	end


    fun appi f slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun app i = if ult(i,stop)
		then (f (uint32toint32 i, unsafe_vsub(vec, i)); app(uplus(i,0w1)))
		else ()
	  in
	    app start
	  end

    fun foldli f init slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun fold (i, accum) = if ult(i,stop)
				    then fold (uplus(i,0w1), f (uint32toint32 i,
								unsafe_vsub(vec, i), accum))
				else accum
	  in  fold (start, init)
	  end

    fun foldri f init slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun fold (i, accum) = if ugt(i,start)
		then let val i' = uminus(i,0w1)
		     in fold (i', f (uint32toint32 i', unsafe_vsub(vec, i'), accum))
		     end
		else accum
	  in
	    fold (stop, init)
	  end




  end  (* Vector *)

(* XENDX*)

(* array.sml
 *
 * COPYRIGHT (c) 1994 AT&T Bell Laboratories.
 *
 *)

structure Word8Array (*:> MONO_ARRAY where type elem = char
				     and type array = TiltPrim.word8array
				     and type Vector.vector = string
				     and type Vector.elem = char *)=
  struct

    val int32touint32 = TiltPrim.int32touint32
    val uint32toint32 = TiltPrim.uint32toint32

    val array_length = TiltPrim.array_length8
    val empty_array = TiltPrim.empty_array8
    val empty_vector = TiltPrim.empty_vector8
    val unsafe_array = TiltPrim.unsafe_array8
    val unsafe_sub = TiltPrim.unsafe_sub8
    val unsafe_update = TiltPrim.unsafe_update8
    val unsafe_vsub = TiltPrim.unsafe_vsub8
    val vector_length = TiltPrim.vector_length8

    val unsafe_array2vector = TiltPrim.unsafe_array2vector8

    val uminus = TiltPrim.uminus
    val uplus = TiltPrim.uplus

    val ugt = TiltPrim.ugt
    val ugte = TiltPrim.ugte
    val ult = TiltPrim.ult
    val ulte = TiltPrim.ulte

    type elem = char
    type array = TiltPrim.word8array
    structure Vector = Word8Vector

    val maxLen = PreVector8.maxLen

    val array0 : array = empty_array
    val vector0 : Vector.vector = empty_vector

    fun array (0, _) = array0
      | array (n, init) =
	if (maxLen < n)
	    then raise Size
	else unsafe_array(int32touint32 n, init)

    fun checkLen n = if maxLen < n then raise Size else ()
    fun rev ([], l) = l
      | rev (x::r, l) = rev (r, x::l)
    fun fromList'(n,l) =
	let val _ = checkLen n
	in
	    if (n = 0)
		then array0
	    else let val ar = unsafe_array(int32touint32 n, List.hd l)
		     fun loop [] _ = ()
		       | loop (a::b) n = (unsafe_update(ar,n,a);
					  loop b (uplus(n,0w1)))
		     val _ = loop l 0w0
		 in  ar
		 end
	end
    fun fromList l =
	let
	    fun len ([], n) = n
	      | len ([_], n) = n+1
	      | len (_::_::r, n) = len(r, n+2)
	    val n = len (l, 0)
	in  fromList'(n,l)
	end

    fun tabulate (0, _) = array0
      | tabulate (n, f) : array =
          let val _ = if (n < 0) then raise Size else ()
	      val a = array(n, f 0)
	      val n = int32touint32 n
              fun tab i =
                if ult(i,n) then (unsafe_update(a, i, f (uint32toint32 i));
				  tab(uplus(i,0w1)))
                else a
           in tab 0w1
          end

    fun length (ar : array) : int = uint32toint32(array_length ar)
    fun sub (a : array, index :int) =
	let val index = int32touint32 index
	in unsafe_sub(a,index)
	end
    fun update (a, index :int, e : char) : unit =
	let val index = int32touint32 index
	in unsafe_update(a,index,e)
	end

    fun extract (v, base : int, optLen : int option) = let
	  val len = length v
	  fun newVec (n : int) : Vector.vector = let
		fun tab (~1, l) = unsafe_array2vector(fromList'(n,l))
		  | tab (i, l) = tab(i-1, (unsafe_sub(v, int32touint32(base+i)))::l)
		in  tab (n-1, [])
		end
	  in
	    case (base, optLen)
	     of (0, NONE) => if (0 < len) then newVec len else vector0
	      | (_, SOME 0) => if ((base < 0) orelse (len < base))
		  then raise Subscript
		  else vector0
	      | (_, NONE) => if ((base < 0) orelse (len < base))
		    then raise Subscript
		  else if (len = base)
		    then vector0
		    else newVec (len - base)
	      | (_, SOME n) =>
		  if ((base < 0) orelse (n < 0) orelse (len < (base+n)))
		    then raise Subscript
		    else newVec n
	    (* end case *)
	  end

    fun copy {src, si=si', len, dst, di} =
        let

            val (sstop', dstop') =
                let val srcLen = length src
                in  case len
                    of NONE => if ((si' < 0) orelse (srcLen < si'))
                                   then raise Subscript
                               else (srcLen, di+srcLen-si')
                  | (SOME n) => if ((n < 0) orelse (si' < 0) orelse (srcLen < si'+n))
                                    then raise Subscript
                                else (si'+n, di+n)
                (* end case *)
                end

            val sstop = int32touint32 sstop'
            val dstop = int32touint32 dstop'
            val si = int32touint32 si'
            fun copyUp (j, k) = if ult(j,sstop)
                                    then (unsafe_update(dst, k, unsafe_sub(src, j));
                                          copyUp (uplus(j,0w1),uplus(k,0w1)))
                                else ()

        (* check to continue *after* update; otherwise we might underflow j  - Tom 7 *)
            fun copyDown (j, k) =
                let in
                    unsafe_update(dst, k, unsafe_sub(src, j));
                    if ult(si,j) then copyDown (uminus(j, 0w1),
                                                uminus(k, 0w1))
                    else ()
                end

        in  if ((di < 0) orelse (length dst < dstop'))
                then raise Subscript
            else if (si' < di) then
                if (0w0 = sstop) then ()
                else copyDown (uminus(sstop,0w1), uminus(dstop,0w1))
              else copyUp (si, int32touint32 di)
        end

    fun copyVec {src, si, len, dst, di} = let
	  val (sstop', dstop') = let
		val srcLen = uint32toint32(vector_length src)
		in
		  case len
		   of NONE => if ((si < 0) orelse (srcLen < si))
		        then raise Subscript
		        else (srcLen, di+srcLen-si)
		    | (SOME n) => if ((n < 0) orelse (si < 0) orelse (srcLen < si+n))
		        then raise Subscript
		        else (si+n, di+n)
		  (* end case *)
		end
	  val sstop = int32touint32 sstop'
	  val dstop = int32touint32 dstop'
	  fun copyUp (j, k) = if ult(j,sstop)
		then (unsafe_update(dst, k, unsafe_vsub(src, j));
		      copyUp (uplus(j,0w1),uplus(k,0w1)))
		else ()
	  in
	    if ((di < 0) orelse (length dst < dstop'))
	      then raise Subscript
	      else copyUp (int32touint32 si, int32touint32 di)
	  end

    fun app f arr = let
	  val len = array_length arr
	  fun app i = if ult(i,len)
			  then (f (unsafe_sub(arr, i)); app(uplus(i,0w1)))
		      else ()
	  in
	    app 0w0
	  end

    fun foldl f init arr = let
	  val len = array_length arr
	  fun fold (i, accum) = if ult(i,len)
				    then fold (uplus(i,0w1), f (unsafe_sub(arr, i), accum))
				else accum
	  in
	    fold (0w0, init)
	  end

    fun chkSlice (vec, i, NONE) = let val len = length vec
	  in
	    if (len < i)
	      then raise Subscript
	      else (vec, int32touint32 i, int32touint32 len)
	  end
      | chkSlice (vec, i, SOME n) = let val len = length vec
	  in
	    if ((0 <= i) andalso (0 <= n) andalso (i+n <= len))
	      then (vec, int32touint32 i, int32touint32(i+n))
	      else raise Subscript
	  end

    fun foldr f init arr =
	let
	    fun fold (i, accum) =
		let val accum' = f (unsafe_sub(arr, i), accum)
		in  if (i = 0w0)
			then accum'
		    else fold (uminus(i,0w1), accum')
		end
	    val n = length arr
	in  if n = 0 then init
	    else fold (int32touint32(n - 1), init)
	end


    fun modify f arr = let
	  val len = array_length arr
	  fun modify' i = if ult(i,len)
			      then (unsafe_update(arr, i, f (unsafe_sub(arr, i)));
				    modify'(uplus(i,0w1)))
		else ()
	  in
	    modify' 0w0
	  end



    fun appi f slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun app i = if ult(i,stop)
		then (f (uint32toint32 i, unsafe_sub(vec, i)); app(uplus(i,0w1)))
		else ()
	  in
	    app start
	  end

    fun mapi f slice = let
	  val (vec, start, stop) = chkSlice slice
	  val len = uminus(stop,start)
	  fun mapf (i, l) = if ult(i,stop)
		then mapf (uplus(i,0w1), f (uint32toint32 i, unsafe_sub(vec, i)) :: l)
		else fromList'(uint32toint32 len, rev(l, []))
	  in
	    if ugt(len,0w0)
	      then mapf (start, [])
	      else array0
	  end

    fun foldli f init slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun fold (i, accum) = if ult(i,stop)
				    then fold (uplus(i,0w1), f (uint32toint32 i,
								unsafe_sub(vec, i), accum))
				else accum
	  in  fold (start, init)
	  end

    fun foldri f init slice = let
	  val (vec, start, stop) = chkSlice slice
	  fun fold (i, accum) = if ugt(i,start)
		then let val i' = uminus(i,0w1)
		     in fold (i', f (uint32toint32 i', unsafe_sub(vec, i'), accum))
		     end
		else accum
	  in
	    fold (stop, init)
	  end

    fun modifyi f slice = let
	  val (arr, start, stop) = chkSlice slice
	  fun modify' i = if ult(i,stop)
		then (unsafe_update(arr, i,
				    f (uint32toint32 i, unsafe_sub(arr, i)));
		      modify'(uplus(i,0w1)))
		else ()
	  in
	    modify' start
	  end


  end (* structure Array *)

(* XENDX*)
(* pack-word-b32.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 * This is the non-native implementation of 32-bit big-endian packing
 * operations.
 *
 *)

structure Pack32Big (*:> PACK_WORD *) =
  struct
    structure W = Word32
    structure W8 = Word8
    structure W8V = Word8Vector
    structure W8A = Word8Array

    val bytesPerElem = 4
    val isBigEndian = true

  (* convert the byte length into word32 length (n div 4), and check the index *)
    fun chkIndex (len, i) = let
	  val len = W.toIntX(W.>>(W.fromInt len, 0w2))
	  in
	    if (i <= len) then () else raise Subscript
	  end

    fun mkWord (b1, b2, b3, b4) =
	  W.orb (W.<<(Word8.toLargeWord b1, 0w24),
	  W.orb (W.<<(Word8.toLargeWord b2, 0w16),
	  W.orb (W.<<(Word8.toLargeWord b3,  0w8),
		      Word8.toLargeWord b4)))

    fun subVec (vec, i) = let
	  val _ = chkIndex (W8V.length vec, i)
	  val k = W.toIntX(W.<<(W.fromInt i, 0w2))
	  in
	    mkWord (W8V.sub(vec, k), W8V.sub(vec, k+1),
	      W8V.sub(vec, k+2), W8V.sub(vec, k+3))
	  end
  (* since LargeWord is 32-bits, no sign extension is required *)
    fun subVecX(vec, i) = subVec (vec, i)

    fun subArr (arr, i) = let
	  val _ = chkIndex (W8A.length arr, i)
	  val k = W.toIntX(W.<<(W.fromInt i, 0w2))
	  in
	    mkWord (W8A.sub(arr, k), W8A.sub(arr, k+1),
	      W8A.sub(arr, k+2), W8A.sub(arr, k+3))
	  end
  (* since LargeWord is 32-bits, no sign extension is required *)
    fun subArrX(arr, i) = subArr (arr, i)

    fun update (arr, i, w) = let
	  val _ = chkIndex (W8A.length arr, i)
	  val k = W.toIntX(W.<<(W.fromInt i, 0w2))
	  in
	    W8A.update (arr, k,   W8.fromLargeWord(W.>>(w, 0w24)));
	    W8A.update (arr, k+1, W8.fromLargeWord(W.>>(w, 0w16)));
	    W8A.update (arr, k+2, W8.fromLargeWord(W.>>(w,  0w8)));
	    W8A.update (arr, k+3, W8.fromLargeWord w)
	  end

  end;


(* XENDX*)
(* byte.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure Byte (*:> BYTE *) =
  struct
    val int32touint32 = TiltPrim.int32touint32

    val unsafe_update = TiltPrim.unsafe_update8
    val unsafe_vsub = TiltPrim.unsafe_vsub8

    val uplus = TiltPrim.uplus
    val uminus = TiltPrim.uminus

    fun chr (b : Word8.word) : char = b
    fun ord (c : char) : Word8.word = c
    fun vectorToString (v,pos,len) : string = Word8Vector.extract(v,pos,SOME len)
    fun arrayToString (a,pos,len) : string = Word8Array.extract(a,pos,SOME len)

    val byteToChar = chr
    val charToByte = ord

    fun bytesToString (cv : Word8Vector.vector) : string = cv
    fun stringToBytes (str : string) : Word8Vector.vector = str

    val unpackStringVec : (Word8Vector.vector * int * int option) -> string
	 = Word8Vector.extract
    val unpackString  : (Word8Array.array * int * int option) -> string
	 = Word8Array.extract


    fun packString (arr : Word8Array.array, i : int, ss : Substring.substring) : unit =
	let
	    val PreString.SS(src, srcStart, srcLen) = ss
	    val dstLen = Word8Array.length arr
	    fun cpy (_, _, 0w0) = ()
	      | cpy (srcIndx, dstIndx, n) =
		(unsafe_update (arr, dstIndx, unsafe_vsub(src, srcIndx));
		 cpy (uplus(srcIndx,0w1), uplus(dstIndx,0w1), uminus(n,0w1)))
	in
	    if (i < 0) orelse (i > dstLen-srcLen) then raise Subscript else ();
		cpy (int32touint32 srcStart, int32touint32 i, int32touint32 srcLen)
	end

  end



(* XENDX*)

structure CharVector = Word8Vector

(* XENDX*)
(* XENDX*)
(* XENDX*)
(* XENDX*)
(* XENDX*)
(* XENDX*)
(* XENDX*)
(* XENDX*)
(* XENDX*)

(* XXXX *)

(*ListPair*)


(* list-pair.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 * If lists are of unequal length, the excess elements from the
 * tail of the longer one are ignored. No exception is raised.
 *
 *)

structure ListPair (*:> LIST_PAIR*) =
  struct

  (* for inlining *)
    fun rev l = let
          fun loop ([], acc) = acc
            | loop (a::r, acc) = loop(r, a::acc)
          in
	    loop (l, [])
	  end

    fun zip (l1, l2) = let
	  fun zip' ((a :: r1), (b :: r2), l) = zip' (r1, r2, (a, b)::l)
	    | zip' (_, _, l) = rev l
	  in
	    zip' (l1, l2, [])
	  end

    fun unzip l = let
	  fun unzip' ([], l1, l2) = (l1, l2)
	    | unzip' ((a, b) :: r, l1, l2) = unzip' (r, a::l1, b::l2)
	  in
	    unzip' (rev l, [], [])
	  end

    fun map f = let
	  fun mapf (a::r1, b::r2, l) = mapf (r1, r2, f(a, b) :: l)
	    | mapf (_, _, l) = rev l
	  in
	    fn (l1, l2) => mapf (l1, l2, [])
	  end

    fun app f = let
	  fun appf (a::r1, b::r2) = (f(a, b); appf(r1, r2))
	    | appf _ = ()
	  in
	    appf
	  end

    fun all pred = let
	  fun allp (a::r1, b::r2) = pred(a, b) andalso allp (r1, r2)
	    | allp _ = true
	  in
	    allp
	  end

    fun foldl f init (l1, l2) = let
	  fun foldf (x::xs, y::ys, accum) = foldf(xs, ys, f(x, y, accum))
	    | foldf (_, _, accum) = accum
	  in
	    foldf (l1, l2, init)
	  end

    fun foldr f init (l1, l2) = let
	  fun foldf (x::xs, y::ys) = f(x, y, foldf(xs, ys))
	    | foldf _ = init
	  in
	    foldf (l1, l2)
	  end

    fun exists pred = let
	  fun existsp (a::r1, b::r2) = pred(a, b) orelse existsp (r1, r2)
	    | existsp _ = false
	  in
	    existsp
	  end

  end (* structure ListPair *)


(* ListPair*)


(* Time *)

(* time.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 *)

structure Time (*:> TIME*) =
  struct
    val uint8touint32 = TiltPrim.uint8touint32
    val ulte = TiltPrim.ulte
    val op^ = String.^

    fun ccall (f : ('a, 'b cresult) -->, a:'a) : 'b =
	(case (Ccall(f,a)) of
	    Normal r => r
	|   Error e => raise e)

(*    structure PB = PreBasis *)

  (* get time type from type-only structure *)
(*    open Time *)

    datatype time = TIME of {sec : int, usec : int}
    exception Time

    val zeroTime = TIME{sec=0, usec=0}

    fun toSeconds (TIME{sec, ...}) = sec  (* should we round? *)
    fun fromSeconds sec =
	  if (sec < 0)
	    then raise Time
	    else TIME{sec=sec, usec=0}

    fun toMilliseconds (TIME{sec, usec}) =
	  (sec * 1000) + Int.quot(usec, 1000)
    fun fromMilliseconds msec =
	  if (msec < 0)
	    then raise Time
	  else if (msec >= 1000)
	    then TIME{sec= Int.quot(msec, 1000), usec= 1000*(Int.rem(msec, 1000))}
	    else TIME{sec= 0, usec= 1000*msec}

    fun toMicroseconds (TIME{sec, usec}) =
	  (sec * 1000000) + usec
    fun fromMicroseconds usec =
	  if (usec < 0)
	    then raise Time
	  else if (usec >= 1000000)
	    then TIME{sec= Int.quot(usec, 1000000), usec= Int.rem(usec,  1000000)}
	    else TIME{sec=0, usec=usec}

    fun fromReal rt = if (rt < 0.0)
	  then raise Time
	  else let
	    val sec = Real.floor rt
	    in
	      TIME{sec=sec, usec=Real.floor((rt - Real.fromInt sec) * 1000000.0)}
	    end

    fun toReal (TIME{sec, usec}) =
	  (Real.fromInt sec) + ((Real.fromInt usec) * 0.000001)

    fun add (TIME{sec=s1, usec=u1}, TIME{sec=s2, usec=u2}) = let
	  val s = s1 + s2
	  val u = u1+u2
	  in
	    if (u >= 1000000)
	      then TIME{sec=s+1, usec=u-1000000}
	      else TIME{sec=s, usec=u}
	  end
    fun sub (TIME{sec=s1, usec=u1}, TIME{sec=s2, usec=u2}) = let
	  val s = s1 - s2
	  val u = u1 - u2
	  val (s, u) = if (u < 0) then (s-1, u+1000000) else (s, u)
	  in
	    if (s < 0)
	      then raise Time
	      else TIME{sec=s, usec=u}
	  end

    fun compare (TIME{sec=s1, usec=u1}, TIME{sec=s2, usec=u2}) =
	  if (s1 < s2) then LESS
	  else if (s1 = s2)
	    then if (u1 < u2) then LESS
	    else if (u1 = u2) then EQUAL
	    else GREATER
	  else GREATER

    fun less (TIME{sec=s1, usec=u1}, TIME{sec=s2, usec=u2}) =
	  (s1 < s2) orelse ((s1 = s2) andalso (u1 < u2))
    fun lessEq (TIME{sec=s1, usec=u1}, TIME{sec=s2, usec=u2}) =
	  (s1 < s2) orelse ((s1 = s2) andalso (u1 <= u2))


    fun now () = let val (ts, tu) = ccall(posix_time_gettimeofday,())
	  in
	    TIME{sec=ts, usec=tu}
	  end


    local
      val zeros = "0000000000"
      val numZeros = String.size zeros
      fun pad 0 = []
	| pad n = if (n <= numZeros)
	    then [String.substring(zeros, 0, n)]
	    else zeros :: pad(n - numZeros)
      val fmtInt = (NumFormat.fmtInt StringCvt.DEC) o Int.fromInt
    in
    fun fmt prec (TIME{sec, usec}) = let
	  val sec' = fmtInt sec
	  in
	    if (prec <= 0)
	      then sec'
	      else let
		val usec' = fmtInt usec
		val frac = String.substring(zeros, 0, 6 - String.size usec') ^ usec'
		in
		  if (prec < 6)
		    then String.concat [
			sec', ".", String.substring(frac, 0, prec)
		      ]
		    else String.concat (sec' :: "." :: frac :: pad(prec-6))
		end
	  end
    end (* local *)

  (* scan a time value; this has the syntax:
   *
   *  [0-9]+(.[0-9]+)? | .[0-9]+
   *)
    fun scan getc charStrm = let
	  fun chrLE (x : char, y : char) : bool = ulte(uint8touint32 x, uint8touint32 y)
	  fun isDigit c = (chrLE(#"0", c) andalso chrLE(c, #"9"))
	  fun incByDigit (n, c) = 10*n + (Char.ord c - Char.ord #"0")
	  fun scanSec (secs, cs) = (case (getc cs)
		 of NONE => SOME(TIME{sec=secs, usec=0}, cs)
		  | (SOME(#".", cs')) => (case (getc cs')
		       of NONE => SOME(TIME{sec=secs, usec=0}, cs)
			| (SOME(d, cs'')) => if (isDigit d)
			    then scanUSec (secs, cs')
			    else SOME(TIME{sec=secs, usec=0}, cs)
		      (* end case *))
		  | (SOME(d, cs')) => if (isDigit d)
		      then scanSec(incByDigit(secs, d), cs')
		      else SOME(TIME{sec=secs, usec=0}, cs)
		(* end case *))
	  and scanUSec (secs, cs) = let
		fun normalize (usecs, 6) = usecs
		  | normalize (usecs, n) = normalize(10*usecs, n+1)
		fun scan' (usecs, 6, cs) = (case (getc cs)
		       of NONE => (usecs, cs)
			| (SOME(d, cs')) => if (isDigit d)
			    then scan' (usecs, 6, cs')
			    else (usecs, cs)
		      (* end case *))
		  | scan' (usecs, ndigits, cs) = (case (getc cs)
		       of NONE => (normalize(usecs, ndigits), cs)
			| (SOME(d, cs')) => if (isDigit d)
			    then scan' (incByDigit(usecs, d), ndigits+1, cs')
			    else (normalize(usecs, ndigits), cs)
		      (* end case *))
		val (usecs, cs) = scan' (0, 0, cs)
		in
		  SOME(TIME{sec=secs, usec=usecs}, cs)
		end
	  val cs = StringCvt.skipWS getc charStrm
	  in
	    case (getc cs)
	     of NONE => NONE
	      | (SOME(#".", cs')) => (case (getc cs')
		   of NONE => NONE
		    | (SOME(d, _)) =>
			if (isDigit d) then scanUSec (0, cs') else NONE
		  (* end case *))
	      | (SOME(d, _)) => if (isDigit d) then scanSec(0, cs) else NONE
	    (* end case *)
	  end

    val toString   = fmt 3
    val fromString = StringCvt.scanString scan

    val (op +) = add
    val (op -) = sub

    val (op <)  = less
    val (op <=) = lessEq
    val (op >)  = Bool.not o lessEq
    val (op >=) = Bool.not o less

  end (* TIME *)

(* Time *)


(* Timer *)
structure Timer (*:> TIMER*) =
  struct

    type cpu_timer = {user : Time.time, sys : Time.time, gc : Time.time}
    type real_timer = {real : Time.time}

    fun ccall (f : ('a, 'b cresult) -->, a:'a) : 'b =
	(case (Ccall(f,a)) of
	    Normal r => r
	|   Error e => raise e)

    fun getCPUTimer() : cpu_timer =
	let val (user_sec, user_usec, sys_sec, sys_usec) = ccall(posix_time_getrusage_self,())
	in  {user = Time.+(Time.fromSeconds(user_sec),
			   Time.fromMicroseconds(user_usec)),
	     sys =  Time.+(Time.fromSeconds(sys_sec),
			   Time.fromMicroseconds(sys_usec)),
	     gc = Time.zeroTime}
	end
    fun getRealTimer() : real_timer =
	let val (sec, msec) = Ccall(posix_time_ftime,())
	in  {real = Time.+(Time.fromSeconds(sec),
			   Time.fromMilliseconds(msec))}
	end

    fun totalCPUTimer() = {user = Time.zeroTime, sys = Time.zeroTime, gc = Time.zeroTime}
    fun startCPUTimer() = getCPUTimer()
    fun checkCPUTimer ({user = user1, sys = sys1, gc = gc1} : cpu_timer) =
	let val {user = user2, sys = sys2, gc = gc2} = getCPUTimer()
	in  {usr = Time.-(user2, user1),
	     sys = Time.-(sys2, sys1),
	     gc = Time.-(gc2, gc1)}
	end

    fun totalRealTimer() = {real = Time.zeroTime}
    fun startRealTimer() = getRealTimer()
    fun checkRealTimer ({real = real1} : real_timer) =
	let val {real = real2} = getRealTimer()
	in  Time.-(real2, real1)
	end

  end

(* Timer *)

(* Toplevel *)
(* see http://www.dina.kvl.dk/%7Esestoft/sml/top-level-chapter.html *)

(* The interface provided by TopLevel should not be assumed by users
   of the basis library.

   Users who want the standard top-level environment should import
   Prelude and TopLevel.
*)

(* overloads - complement's Prelude *)
overload div : 'a as PreInt.idiv and TiltPrim.bdiv and TiltPrim.udiv
overload mod : 'a as PreInt.imod and TiltPrim.bmod and TiltPrim.umod
overload abs : 'a as PreInt.iabs and TiltPrim.fabs
overload <  : 'a as String.<
overload >  : 'a as String.>
overload <= : 'a as String.<=
overload >= : 'a as String.>=

exception Div = Div
exception Overflow = Overflow

(* types *)
type substring = PreString.substring

(* values *)
(* !, := primitive, ref -- primitive *)
(* before, ignore, o -- primitive *)
(* exnName, exnMessage, getOpt, isSome, valOf -- Prelude *)
(* not -- Prelude *)

(* real -- primitive *)
val trunc = Real.trunc
val floor = Real.floor
val ceil = Real.ceil
val round = Real.round

(* ord -- primitive *)
val chr = Char.chr

val size = String.size
val str = String.str
val concat = String.concat
val implode = String.implode
val explode = String.explode
val substring = String.substring
val op^ = String.^

val null = List.null
val hd = List.hd
val tl = List.tl
val length = List.length
(* rev -- Prelude *)
val op@ = List.@
val app = List.app
val map = List.map
val foldr = List.foldr
val foldl = List.foldl

val print = print

val vector = Vector.fromList

fun use (_ : string) : unit = raise TiltExn.LibFail "use unimplemented"

(* Toplevel *)
(* END BASIS *)

(* BEGIN LIBRARY *)

(* array2.sml
 *
 * COPYRIGHT (c) 1993 by AT&T Bell Laboratories.  See COPYRIGHT file for details.
 *
 * Two-dimensional arrays.
 *)

structure Array2 (*:> ARRAY2 *)=
  struct
    datatype 'a array2 = A2 of {
	nrows : int,
	ncols : int,
	elems : 'a array
      }

    fun index (A2{nrows, ncols, ...}, i, j) =
	  if ((i < 0) orelse (nrows <= i) orelse (j < 0) orelse (ncols <= j))
	    then raise Subscript
	    else (i*ncols + j)

  (* array(n,m,x) creates an n*m array initialized to x.
   * Raises Size, if m or n is < 0.
   *)
    fun array (nRows, nCols, initVal) =
	  if (nCols < 0) orelse (nRows < 0)
	    then raise Size
	    else A2{
		nrows = nRows, ncols = nCols,
		elems = Array.array(nRows*nCols, initVal)
	      }

  (* tabulate(n,m,f) creates an n*m array, where the (i,j) element
   * is initialized to f(i,j).  Raises Size, if m or n is < 0.
   *)
    fun tabulate (nRows, nCols, f) =
	  if (nCols < 0) orelse (nRows < 0)
            then raise Size
	    else let
	      fun mkElems (i, j, elems) = if (j < nCols)
		      then mkElems (i, j+1, f(i,j) :: elems)
		    else let val i = i+1
		      in
			if (i < nRows)
			  then mkElems (i, 0, elems)
			  else Array.fromList(rev elems)
		      end
	      in
		A2{nrows = nRows, ncols = nCols, elems = mkElems(0, 0, [])}
	      end

  (* sub(a,i,j) returns the (i,j) element. Raises Subscript if i or j
   * is out of range.
   *)
    fun sub (arr as A2{elems, ...}, i, j) = Array.sub(elems, index(arr, i, j))

  (* update(a,i,j,x) sets the (i,j) element to x. Raises Subscript if
   * i or j is out of range.
   *)
    fun update (arr as A2{elems, ...}, i, j, x) =
	  Array.update(elems, index(arr, i, j), x)

  (* return the size of the array *)
    fun dimensions (A2{nrows, ncols, ...}) = (nrows, ncols)

  (* project a column of the array. *)
    fun column (arr as A2{elems, nrows, ncols, ...}, j) = let
	  val k = index(arr, 0, j)
	  in
	    Array.tabulate(nrows, fn n => Array.sub(elems, k+(n*ncols)))
	  end

  (* project a row of the array. *)
    fun row (arr as A2{elems, ncols, ...}, i) = let
	  val k = index(arr, i, 0)
	  in
	    Array.tabulate(ncols, fn n => Array.sub(elems, k+n))
	  end

  end (* Array2 *)


(* END LIBRARY *)
(* END IMPORTS *)

structure TimeAndRun (*:> TIMEANDRUN*) =
  struct
    val stringem = String.concat
    val printem = List.app print
    val unzip = ListPair.unzip 

    type result = {name : string, 
		   cpu : {usr : Time.time, sys : Time.time, gc : Time.time},
		   real : Time.time}
      
    fun indent' n = 
      let 
	fun loop 0 acc = acc
	  | loop n acc = loop (n-1) (#" "::acc)
	val l = loop n []
      in String.implode l
      end
    
    
    fun indent 0 = ()
      | indent n = (print " ";indent (n-1))
      
    fun timerToString ind {usr : Time.time, sys : Time.time, gc : Time.time} = 
      (stringem [indent' ind,indent' ind,"usr=    ",Time.toString usr,"\n",
		 indent' ind,indent' ind,"sys=    ",Time.toString sys,"\n",
		 indent' ind,indent' ind,"gc=     ",Time.toString gc,"\n",
		 indent' ind,"total=  ",Time.toString(Time.+(usr,sys)),"\n"])  (*User time includes gc*)
      
    fun print_result ({name,cpu,real} : result) : unit = 
      let
	val ind = 10
      in
	printem ["Timings for ",name,":\n"];
	print (timerToString ind cpu);
	indent ind;printem ["real =",Time.toString real,"\n"]
      end
    
    
    fun sumsummaries [] = raise Fail "no summaries to sum"
      | sumsummaries (fst::rest) = 
      let
	fun loop([],_,acc) = rev acc
	  | loop (hd::tl,rest,acc) = 
	  let 
	    val (hds,tls) = unzip (map (fn (h::t) => (h,t)) rest)
	    val hd = foldl Real.+ hd hds
	  in loop(tl,tls, hd ::acc)
	  end
      in loop (fst,rest,[])
      end
    
    fun avgsummaries (n,l) = 
      let 
	val n = Real.fromInt n
	val sums = sumsummaries l
      in map (fn r => Real./(r,n)) sums
      end
    
    fun summarize (results : result list)  = 
      let 
	val names = map #name results
	val times = map #real results
	val treals = map Time.toReal times
	val total = (foldl Real.+ 0.0 treals)
      in
	("TOTAL"::names,total::treals)
      end
    
    fun print_summary (names,totals) = 
      let
	val tstrings = map Real.toString totals
	val _ = ListPair.app (fn (n,t) => (print (n^"="^t^"    "))) (names,tstrings)
      in print "\n"
      end
    
    fun run (f,name) : result = 
      let
	val _ = printem ["\n=============Running ",name," ======================\n"]
	val cpu_timer = Timer.startCPUTimer()
	val real_timer = Timer.startRealTimer()
	val _ = f ()
	val cpu =  Timer.checkCPUTimer cpu_timer
	val real =  Timer.checkRealTimer real_timer
      in {name = name,cpu = cpu,real=real}
      end

    fun run1 benchmarks _ = map run benchmarks;
    fun runn (n,benchmarks) = List.tabulate (n,run1 benchmarks)
    fun report (n,benchmarks) = 
      let
	val results = runn (n,benchmarks)
	val summaries = map summarize results
	val (namess,totalss) = unzip summaries
	val names = hd namess
	val totals = avgsummaries (n,totalss)
	val _ = app (fn rs => app print_result rs) results;
	val _ = print_summary (names,totals)
      in ()
      end
  end

(* msort *)

(* Thread safety guaranteed by lack of mutable types *)

signature RUN = 
  sig
    val run : unit -> unit
  end

(* Life  *)
(* Thread safety automatic since no mutable types are used *)

(*
extern fastTimerOn : (unit) -->
extern fastTimerOff : (unit) -->
*)

structure Life :> RUN = 
  struct
    fun (f o g) x = f(g x)
    exception ex_undefined of string
    fun error str = raise ex_undefined str
	
    fun accumulate f = let fun foldf a [] = a
			     | foldf a (b::x) = foldf (f a b) x
		       in foldf 
		       end
		   
    fun filter p = let fun consifp x a = if p a then a::x else x
		   in rev o accumulate consifp [] 
		   end
	       
    fun equal (a:int*int) b = a=b

    fun exists p = let fun existsp [] = false
			 | existsp (a::x) = if p a then true else existsp x
		   in existsp 
		   end

    fun member x a = let (* val _ = Ccall(fastTimerOn) *)
			 val res =  exists (equal a) x
			 (* val _ = Ccall(fastTimerOff) *)
		     in  res
		     end
	
    fun C f x y = f y x
	
    fun cons a x = a::x
	
    val revonto = fn a => fn l => accumulate (C cons) a l
	
    val length = fn l => let fun count n a = n+1 in accumulate count 0 l end

    fun repeat f = let fun rptf n x = if n=0 then x else rptf(n-1)(f x)
		       fun check n = if n<0 then error "repeat<0" else n
		   in rptf o check 
		   end

    fun copy n x = repeat (cons x) n []
	
    fun spaces n = implode (copy n #" ")
	
    fun lexless(a1:int,b1:int)(a2,b2) = 
	if a2<a1 then true else if a2=a1 then b2<b1 else false
    fun lexgreater pr1 pr2 = lexless pr2 pr1
    fun lexordset [] = []
      | lexordset (a::x) = lexordset (filter (lexless a) x) @ [a] @
	lexordset (filter (lexgreater a) x)
	
    fun collect f list =
	let fun accumf sofar [] = sofar
	      | accumf sofar (a::x) = accumf (revonto sofar (f a)) x
	in accumf [] list
	end
    fun flatten [] = []
      | flatten (first::rest) = 
	let fun loop [] = flatten rest
	      | loop (a::rest) = a::(loop rest)
	in  loop first
	end

    fun occurs3 x = 
    (* finds coords which occur exactly 3 times in coordlist x *)
    let fun diff x y = filter (not o member y) x
	fun f xover x3 x2 x1 [] = diff x3 xover
	  | f xover x3 x2 x1 (a::x) = 
	    if member xover a then f xover x3 x2 x1 x else
		if member x3 a then f (a::xover) x3 x2 x1 x else
		    if member x2 a then f xover (a::x3) x2 x1 x else
			if member x1 a then f xover x3 (a::x2) x1 x else
			    f xover x3 x2 (a::x1) x
(*	val _ = Ccall(fastTimerOn) 	     *)
	val res =  f [] [] [] [] x 
(*	val _ = Ccall(fastTimerOff) 	    *)
    in  res
    end

    datatype generation = GEN of (int*int) list


    fun alive (GEN livecoords) = livecoords
    fun mkgen coordlist = GEN (lexordset coordlist)
    fun mk_nextgen_fn neighbours gen =
	let 
	    fun twoorthree 2 = true
	      | twoorthree 3 = true
	      | twoorthree _ = false
	    val living = alive gen
	    val isalive = member living
	    val liveneighbours = length o filter isalive o neighbours
	    val survivors = filter (twoorthree o liveneighbours) living
(*	    val _ = Ccall(fastTimerOn)  *)
	    val newnbrlist = flatten(map (filter (not o isalive) o neighbours) living)
(*	    val _ = Ccall(fastTimerOff) *)
	    val newborn = occurs3 newnbrlist
	    val nextGen = mkgen(survivors @ newborn)
	in  nextGen
	end
    
    
    fun neighbours (i,j) = [(i-1,j-1),(i-1,j),(i-1,j+1),
			    (i,j-1),(i,j+1),
			    (i+1,j-1),(i+1,j),(i+1,j+1)]

    val xstart = 0 
    val ystart = 0
    
    fun markafter n string = string ^ spaces n ^ "0"
    fun plotfrom (x,y) (* current position *)
	str   (* current line being prepared -- a string *)
	((x1,y1)::more)  (* coordinates to be plotted *)
	= if x=x1
	      then (* same line so extend str and continue from y1+1 *)
                  plotfrom(x,y1+1)(markafter(y1-y)str)more
	  else (* flush current line and start a new line *)
	      str :: plotfrom(x+1,ystart)""((x1,y1)::more)
      | plotfrom (x,y) str [] = [str]
    fun good (x,y) = x>=xstart andalso y>=ystart
    fun plot coordlist = plotfrom(xstart,ystart) "" 
	(filter good coordlist)


infix 6 at
fun coordlist at (x:int,y:int) = let fun move(a,b) = (a+x,b+y) 
                                  in map move coordlist end

val rotate = map (fn (x:int,y:int) => (y,~x))

val glider = [(0,0),(0,2),(1,1),(1,2),(2,1)]
val bail = [(0,0),(0,1),(1,0),(1,1)]
fun barberpole n =
   let fun f i = if i=n then (n+n-1,n+n)::(n+n,n+n)::nil
                   else (i+i,i+i+1)::(i+i+2,i+i+1)::f(i+1)
    in (0,0)::(1,0):: f 0
   end

val genB = mkgen(glider at (2,2) @ bail at (2,12)
		 @ rotate (barberpole 4) at (5,20))

val show = app (fn s => (print s; print "\n")) o plot o alive
fun nthgen g 0 = g 
  | nthgen g i = 
    let 
(* 	val _ = Ccall(fastTimerOn)   *)
	val res = mk_nextgen_fn neighbours g
(*	val _ = Ccall(fastTimerOff)  *)
    in  nthgen res (i-1)
    end

(*
fun run g = (show g;
             input_line std_in;
	     run(mk_nextgen_fn neighbours g))

fun read filename = 
  let val f = open_in filename
      fun g(x,y) = case input(f,1)
                    of "." => g(x,y+1)
                     | "O" => (x,y)::g(x,y+1)
                     | "\n" => g(x+1,0)
                     | "" => nil
   in mkgen(g(0,0))
  end
*)

val gun = mkgen
 [(2,20),(3,19),(3,21),(4,18),
  (4,22),(4,23),(4,32),(5,7),
  (5,8),(5,18),(5,22),(5,23),
  (5,29),(5,30),(5,31),(5,32),
  (5,36),(6,7),(6,8),(6,18),
  (6,22),(6,23),(6,28),(6,29),
  (6,30),(6,31),(6,36),(7,19),
  (7,21),(7,28),(7,31),(7,40),
  (7,41),(8,20),(8,28),(8,29),
  (8,30),(8,31),(8,40),(8,41),
  (9,29),(9,30),(9,31),(9,32)
]

  fun doit start step thing = 
      let fun loop 0 thing = ()
	    | loop count thing = let 
				     val _ = show thing 
(*				     val _ = Ccall(fastTimerOn)  *)
				     val nextThing =  nthgen thing step
(*				     val _ = Ccall(fastTimerOff) *)
				 in loop (count-1) nextThing
				 end
      in  loop start thing
      end


    fun run () = doit 5 30 gun
end


(* Life  *)

(* Leroy *) 
(* Thread safety automatic since no mutable types are used *)

structure Leroy :> RUN = 
  struct

  val silent = true

  exception failure of string;
  fun failwith s = raise(failure s)

  (* 1- les paires *)
  fun fst (x,y) = x
  fun snd (x,y) = y

  fun do_list f =
      let fun do_rec [] = ()
	    | do_rec (a::L) = (f a; do_rec L)
      in do_rec
      end

  fun it_list f =
      let fun it_rec a [] = a
	    | it_rec a (b::L) = it_rec (f a b) L
      in it_rec
      end

  fun it_list2 f =
      let fun it_rec  a    []       []    = a
	    | it_rec  a (a1::L1) (a2::L2) = it_rec (f a (a1,a2)) L1 L2
	    | it_rec  _    _        _     = failwith "it_list2"
      in it_rec
      end

  fun exists p =
      let fun exists_rec []  = false
	    | exists_rec (a::L) = (p a) orelse (exists_rec L)
      in exists_rec
      end

  fun for_all p =
      let fun for_all_rec []  = true
	    | for_all_rec (a::L) = (p a) andalso (for_all_rec L)
      in for_all_rec
      end

  fun rev_append   []    L  = L 
    | rev_append (x::L1) L2 = rev_append L1 (x::L2)

  fun try_find f =
      let fun try_find_rec  []    = failwith "try_find"
            | try_find_rec (a::L) = (f a) handle failure _ => try_find_rec L
      in try_find_rec
      end

  fun rem_eq equiv =
      let fun remrec x [] = failwith "rem_eq"
	    | remrec x (y::l) = if equiv (x,y) then l else y :: remrec x l
      in remrec
      end

(* 3- Les ensembles et les listes d'association *)

  fun mem a =
      let fun mem_rec [] = false
	    | mem_rec (b::L) = (a=b) orelse mem_rec L
      in mem_rec
      end

  fun union L1 =
      let fun union_rec [] = L1
	    | union_rec (a::L) = if mem a L1 then union_rec L else a :: union_rec L
      in union_rec
      end

  fun mem_assoc a =
      let fun mem_rec [] = false
	    | mem_rec ((b,_)::L) = (a=b) orelse mem_rec L
      in mem_rec
      end

  fun assoc a =
      let fun assoc_rec [] = failwith "find"
	    | assoc_rec ((b,d)::L) = if a=b then d else assoc_rec L
      in assoc_rec
      end

  (* 4- Les sorties *)
  val print_string = print
  val print_num = print o Int.toString
  fun print_newline () = print "\n";
  fun message s = (print s; print "\n");


  (****************** Term manipulations *****************)

  datatype term =
    Var of int
  | Term of string * term list;;

  fun vars (Var n) = [n]
    | vars (Term(_,L)) = vars_of_list L
  and vars_of_list [] = []
    | vars_of_list (t::r) = union (vars t) (vars_of_list r)

  fun substitute subst =
      let fun subst_rec (Term(oper,sons)) = Term(oper, map subst_rec sons)
	    | subst_rec (t as (Var n))     = (assoc n subst) handle failure _ => t
      in subst_rec
      end

  fun change f =
      let fun change_rec (h::t) n = if n=1 then f h :: t
				    else h :: change_rec t (n-1)
	    | change_rec _ _      = failwith "change"
      in change_rec
      end

  (* Term replacement replace M u N => M[u<-N] *)
  fun replace M u N = 
      let fun reprec (_, []) = N
	    | reprec (Term(oper,sons), (n::u)) = Term(oper, change (fn P => reprec(P,u)) sons n)
	    | reprec _ = failwith "replace"
      in reprec(M,u)
      end

  (* matching = - : (term -> term -> subst) *)
  fun matching term1 term2 =
      let fun match_rec subst (Var v, M) =
          if mem_assoc v subst then
	      if M = assoc v subst then subst else failwith "matching"
          else
	      (v,M) :: subst
	    | match_rec subst (Term(op1,sons1), Term(op2,sons2)) =
	      if op1 = op2 then it_list2 match_rec subst sons1 sons2
	      else failwith "matching"
	    | match_rec _ _ = failwith "matching"
      in match_rec [] (term1,term2)
      end

  (* A naive unification algorithm *)
  fun compsubst subst1 subst2 = 
      (map (fn (v,t) => (v, substitute subst1 t)) subst2) @ subst1

  fun occurs n =
      let fun occur_rec (Var m) = (m=n)
	    | occur_rec (Term(_,sons)) = exists occur_rec sons
      in occur_rec
      end

  
  fun unify ((term1 as (Var n1)), term2) =
          if term1 = term2 then []
	  else if occurs n1 term2 then failwith "unify"
	       else [(n1,term2)]
    | unify (term1, Var n2) =
	  if occurs n2 term1 then failwith "unify"
	  else [(n2,term1)]
    | unify (Term(op1,sons1), Term(op2,sons2)) =
	      if op1 = op2 then 
		  it_list2 (fn s => fn (t1,t2) => compsubst (unify(substitute s t1,
								   substitute s t2)) s)
		  [] sons1 sons2
	      else failwith "unify"

  (* We need to print terms with variables independently from input terms
   obtained by parsing. We give arbitrary names v1,v2,... to their variables. *)

  val INFIXES = ["+","*"];

  fun pretty_term (Var n) =
      (print_string "v"; print_num n)
    | pretty_term (Term (oper,sons)) =
      if mem oper INFIXES then
        case sons of
            [s1,s2] =>
              (pretty_close s1; print_string oper; pretty_close s2)
          | _ =>
              failwith "pretty_term : infix arity <> 2"
      else
       (print_string oper;
        case sons of
	     []   => ()
          | t::lt =>(print_string "(";
                     pretty_term t;
                     do_list (fn t => (print_string ","; pretty_term t)) lt;
                     print_string ")"))
  and pretty_close (M as Term(oper, _)) =
      if mem oper INFIXES then
	  (print_string "("; pretty_term M; print_string ")")
      else pretty_term M
    | pretty_close M = pretty_term M


(****************** Equation manipulations *************)

  (* standardizes an equation so its variables are 1,2,... *)
  fun mk_rule M N =
      let val all_vars = union (vars M) (vars N);
	  val (k,subst) =
	      it_list (fn (i,sigma) => fn v => (i+1,(v,Var(i))::sigma))
	      (1,[]) all_vars
      in (k-1, (substitute subst M, substitute subst N))
      end

  (* checks that rules are numbered in sequence and returns their number *)
  val check_rules = fn l => 
      it_list (fn n => fn (k,_) =>
	       if k=n+1 then k
	       else failwith "Rule numbers not in sequence") 0 l

  fun pretty_rule (k,(n,(M,N))) =
      (print_num k; print_string " : ";
       pretty_term M; print_string " = "; pretty_term N;
       print_newline())


  val pretty_rules = fn l => do_list pretty_rule l


  (****************** Rewriting **************************)
      
  (* Top-level rewriting. Let eq:L=R be an equation, M be a term such that L<=M.
   With sigma = matching L M, we define the image of M by eq as sigma(R) *)
  fun reduce L M = substitute (matching L M)


  (* A more efficient version of can (rewrite1 (L,R)) for R arbitrary *)
  fun reducible L =
      let fun redrec M =
	  (matching L M; true)
	  handle failure _ =>
	      case M of Term(_,sons) => exists redrec sons
	    |        _     => false
      in redrec
      end

  (* mreduce : rules -> term -> term *)
  fun mreduce rules M =
      let fun redex (_,(_,(L,R))) = reduce L M R 
      in try_find redex rules 
      end

  (* One step of rewriting in leftmost-outermost strategy, with multiple rules *)
  (* fails if no redex is found *)
  (* mrewrite1 : rules -> term -> term *)
  fun mrewrite1 rules =
      let fun rewrec M =
	  (mreduce rules M) handle failure _ =>
	      let fun tryrec [] = failwith "mrewrite1"
		    | tryrec (son::rest) =
		  (rewrec son :: rest) handle failure _ => son :: tryrec rest
	      in case M of
		  Term(f, sons) => Term(f, tryrec sons)
		| _ => failwith "mrewrite1"
	      end
      in rewrec
      end

  
  (* Iterating rewrite1. Returns a normal form. May loop forever *)
  (* mrewrite_all : rules -> term -> term *)
  fun mrewrite_all rules M =
      let fun rew_loop M =
	  rew_loop(mrewrite1 rules M)  handle  failure _ => M
      in rew_loop M
      end

  (************************ Recursive Path Ordering ****************************)
  datatype ordering = Greater | Equal | NotGE;
  fun ge_ord order pair = case order pair of NotGE => false | _ => true
  fun gt_ord order pair = case order pair of Greater => true | _ => false
  fun eq_ord order pair = case order pair of Equal => true | _ => false


  fun diff_eq equiv (x,y) =
      let fun diffrec (p as ([],_)) = p
	    | diffrec ((h::t), y) =
	  diffrec (t,rem_eq equiv h y) handle failure _ =>
              let val (x',y') = diffrec (t,y) in (h::x',y') end
      in if length x > length y then diffrec(y,x) else diffrec(x,y)
      end


  (* multiset extension of order *)
  fun mult_ext order (Term(_,sons1), Term(_,sons2)) =
      (case diff_eq (eq_ord order) (sons1,sons2) of
           ([],[]) => Equal
         | (l1,l2) =>
             if for_all (fn N => exists (fn M => order (M,N) = Greater) l1) l2
             then Greater else NotGE)
    | mult_ext order _ = failwith "mult_ext"


  (* lexicographic extension of order *)
  fun lex_ext order ((M as Term(_,sons1)), (N as Term(_,sons2))) =
        let fun lexrec ([] , []) = Equal
	      | lexrec ([] , _ ) = NotGE
	      | lexrec ( _ , []) = Greater
	      | lexrec (x1::l1, x2::l2) =
	        case order (x1,x2) of
		    Greater => if for_all (fn N' => gt_ord order (M,N')) l2 
				   then Greater else NotGE
		  | Equal => lexrec (l1,l2)
		  | NotGE => if exists (fn M' => ge_ord order (M',N)) l1 
				 then Greater else NotGE
	in lexrec (sons1, sons2)
	end
    | lex_ext order _ = failwith "lex_ext"


  (* recursive path ordering *)
  fun rpo op_order ext =
      let fun rporec (M,N) =
	  if M=N then Equal else 
	      case M of
		  Var m => NotGE
		| Term(op1,sons1) =>
		      case N of
			  Var n =>
			      if occurs n M then Greater else NotGE
			| Term(op2,sons2) =>
				  case (op_order op1 op2) of
				      Greater => if for_all (fn N' => gt_ord rporec (M,N')) sons2
						     then Greater else NotGE
				    | Equal => ext rporec (M,N)
				    | NotGE => if exists (fn M' => ge_ord rporec (M',N)) sons1
						   then Greater else NotGE
      in rporec
      end


  (****************** Critical pairs *********************)
  (* All (u,sig) such that N/u (&var) unifies with M, with principal unifier sig *)
  fun super M =
      let fun suprec (N as Term(_,sons)) =
	  let fun collate (pairs,n) son =
	      (pairs @ map (fn (u,sigma) => (n::u,sigma)) (suprec son), n+1);
	      val insides =
		  fst (it_list collate ([],1) sons)
	  in ([], unify(M,N)) :: insides  handle failure _ => insides
	  end
	    | suprec _ = []
      in suprec 
      end


(* Ex :
let (M,_) = <<F(A,B)>> 
and (N,_) = <<H(F(A,x),F(x,y))>> in super M N;;
==> [[1],[2,Term ("B",[])];                      x <- B
     [2],[2,Term ("A",[]); 1,Term ("B",[])]]     x <- A  y <- B
*)

  (* All (u,sigma), u&[], such that N/u unifies with M *)
  (* super_strict : term -> term -> (num list & subst) list *)
  fun super_strict M (Term(_,sons)) =
      let fun collate (pairs,n) son =
          (pairs @ map (fn (u,sigma) => (n::u,sigma)) (super M son), n+1)
      in fst (it_list collate ([],1) sons) 
      end
    | super_strict _ _ = []


  (* Critical pairs of L1=R1 with L2=R2 *)
  (* critical_pairs : term_pair -> term_pair -> term_pair list *)
  fun critical_pairs (L1,R1) (L2,R2) =
      let fun mk_pair (u,sigma) =
	  (substitute sigma (replace L2 u R1), substitute sigma R2) 
      in  map mk_pair (super L1 L2)
      end

  (* Strict critical pairs of L1=R1 with L2=R2 *)
  (* strict_critical_pairs : term_pair -> term_pair -> term_pair list *)
  fun strict_critical_pairs (L1,R1) (L2,R2) =
      let fun mk_pair (u,sigma) =
	  (substitute sigma (replace L2 u R1), substitute sigma R2) 
      in  map mk_pair (super_strict L1 L2)
      end

  (* All critical pairs of eq1 with eq2 *)
  fun mutual_critical_pairs eq1 eq2 =
      (strict_critical_pairs eq1 eq2) @ (critical_pairs eq2 eq1);

  (* Renaming of variables *)
  fun rename n (t1,t2) =
      let fun ren_rec (Var k) = Var(k+n)
	    | ren_rec (Term(oper,sons)) = Term(oper, map ren_rec sons)
      in (ren_rec t1, ren_rec t2)
      end


  (************************ Completion ******************************)

  fun deletion_message (k,_) =
    (print_string "Rule ";print_num k; message " deleted")
    ;

  (* Generate failure message *)
  fun non_orientable (M,N) =
    (pretty_term M; print_string " = "; pretty_term N; print_newline())
    ;

  (* Improved Knuth-Bendix completion procedure *)
  (* kb_completion : (term_pair -> bool) -> num -> rules -> term_pair list -> (num & num) -> term_pair list -> rules *)
  fun kb_completion greater =
    let fun kbrec n rules =
      let val normal_form = mrewrite_all rules;
        fun get_rule k = assoc k rules;
        fun process failures =
          let fun processf (k,l) =
            let fun processkl [] =
              if k<l then next_criticals (k+1,l) else
		if l<n then next_criticals (1,l+1) else
		  (case failures of
		     [] => rules (* successful completion *)
		   | _  => (message "Non-orientable equations :";
			    do_list non_orientable failures;
			    failwith "kb_completion"))
		  | processkl ((M,N)::eqs) =
		     let val M' = normal_form M;
		       val N' = normal_form N;
		       fun enter_rule(left,right) =
			 let val new_rule = (n+1, mk_rule left right) in
			   (if silent
			      then ()
			    else pretty_rule new_rule;
			      let fun left_reducible (_,(_,(L,_))) = reducible left L;
				val (redl,irredl) = List.partition left_reducible rules
			      in (if silent
				    then ()
				  else do_list deletion_message redl;
				    let fun right_reduce (m,(_,(L,R))) = 
				      (m,mk_rule L (mrewrite_all (new_rule::rules) R));
					val irreds = map right_reduce irredl;
					val eqs' = map (fn (_,(_,pair)) => pair) redl
				    in kbrec (n+1) (new_rule::irreds) [] (k,l)
				      (eqs @ eqs' @ failures)
				    end)
			      end)
			 end
		     in if M'=N' then processkl eqs else
		       if greater(M',N') then enter_rule(M',N') else
			 if greater(N',M') then enter_rule(N',M') else
			   process ((M',N')::failures) (k,l) eqs
		     end
            in processkl
            end
	      and next_criticals (k,l) =
		(let val (v,el) = get_rule l in
		   if k=l then
		     processf (k,l) (strict_critical_pairs el (rename v el))
		   else
		     (let val (_,ek) = get_rule k in 
			processf (k,l) (mutual_critical_pairs el (rename v ek))
		      end
			handle failure "find" (*rule k deleted*) =>
			  next_criticals (k+1,l))
		 end
		   handle failure "find" (*rule l deleted*) =>
		     next_criticals (1,l+1))
          in processf
          end
      in process
      end
    in kbrec
    end
  ;

  fun kb_complete greater complete_rules rules =
    let val n = check_rules complete_rules;
      val eqs = map (fn (_,(_,pair)) => pair) rules;
      val completed_rules =
	kb_completion greater n complete_rules [] (n,n) eqs
    in (message "Canonical set found :";
        if (silent)
	  then ()
	else pretty_rules (rev completed_rules);
	  ())
    end
  ;

  val Group_rules = [
		     (1, (1, (Term("*", [Term("U",[]), Var 1]), Var 1))),
		     (2, (1, (Term("*", [Term("I",[Var 1]), Var 1]), Term("U",[])))),
		     (3, (3, (Term("*", [Term("*", [Var 1, Var 2]), Var 3]),
			      Term("*", [Var 1, Term("*", [Var 2, Var 3])]))))];

  val Geom_rules = [
		    (1,(1,(Term ("*",[(Term ("U",[])), (Var 1)]),(Var 1)))),
		    (2,(1,(Term ("*",[(Term ("I",[(Var 1)])), (Var 1)]),(Term ("U",[]))))),
		    (3,(3,(Term ("*",[(Term ("*",[(Var 1), (Var 2)])), (Var 3)]),
			   (Term ("*",[(Var 1), (Term ("*",[(Var 2), (Var 3)]))]))))),
		    (4,(0,(Term ("*",[(Term ("A",[])), (Term ("B",[]))]),
			   (Term ("*",[(Term ("B",[])), (Term ("A",[]))]))))),
		    (5,(0,(Term ("*",[(Term ("C",[])), (Term ("C",[]))]),(Term ("U",[]))))),
		    (6,(0,
			(Term
			 ("*",
			  [(Term ("C",[])),
			   (Term ("*",[(Term ("A",[])), (Term ("I",[(Term ("C",[]))]))]))]),
			 (Term ("I",[(Term ("A",[]))]))))),
		    (7,(0,
			(Term
			 ("*",
			  [(Term ("C",[])),
			   (Term ("*",[(Term ("B",[])), (Term ("I",[(Term ("C",[]))]))]))]),
			 (Term ("B",[])))))
		    ];

  fun Group_rank "U" = 0
    | Group_rank "*" = 1
    | Group_rank "I" = 2
    | Group_rank "B" = 3
    | Group_rank "C" = 4
    | Group_rank "A" = 5
    | Group_rank _ = raise Match
    ;

  fun Group_precedence op1 op2 =
    let val r1 = Group_rank op1;
      val r2 = Group_rank op2
    in
      if r1 = r2 then Equal else
	if r1 > r2 then Greater else NotGE
    end


  val Group_order = rpo Group_precedence lex_ext 
    
    
  fun greater pair =
    case Group_order pair of Greater => true | _ => false


  fun run () = kb_complete greater [] Geom_rules 
    handle e => (print "top-level exception caught and re-raised"; raise e)
end

(* Leroy *)

(* Simple *)
(* PreReal provides extern definitions for the Ccalls.
 *)

structure Simple :> RUN = 
  struct


    val makestring_real = Real64.toString
    val makestring_int = Int.toString

  val Control_trace = ref false

  val grid_max=20 (* was originally 100; don't make this < 5 *)


  fun min(x:real,y:real) = if x<y then x else y
  fun max(x:real,y:real) = if x<y then y else x
  fun abs(x:real) = if x < 0.0 then ~x else x
  exception MaxList
  exception MinList
  exception SumList
  fun max_list [] = raise MaxList | max_list l = List.foldl max (hd l) l
  fun min_list [] = raise MinList | min_list l = List.foldl min (hd l) l
  fun sum_list [] = raise SumList
    | sum_list (l:real list) = List.foldl (op +) 0.0 l
  fun for {from=start:int,step=delta:int, to=endd:int} body =
      if delta>0 andalso endd>=start then 
	  let fun f x = if x > endd then () else (body x; f(x+delta))
	  in f start
	  end
      else if endd<=start then
	  let fun f x = if x < endd then () else (body x; f(x+delta))
	  in f start
	  end
      else ()
  fun from(n,m) = if n>m then [] else n::from(n+1,m)
  fun flatten [] = []
    | flatten (x::xs) = x @ flatten xs
  fun pow(x:real,y:int) = if y = 0 then 1.0 else x * pow(x,y-1)

  val array2 = fn(bounds as ((l1,u1),(l2,u2)),v) =>
      (Array2.array(u1-l1+1,u2-l2+1,v), bounds) 
  val sub2 = fn((A,((lb1:int,ub1:int),(lb2:int,ub2:int))),(k,l)) =>
      Array2.sub(A, k-lb1, l-lb2) 
  val update2 = fn((A,((lb1,_),(lb2,_))),(k,l), v) => 
      Array2.update(A,k-lb1,l-lb2,v)
  fun bounds2(_,b) = b
  fun printarray2 (A as (M:real Array2.array2,((l1,u1),(l2,u2)))) =
      for {from=l1,step=1,to=u1} 
      (fn i =>
       (print "[";
	for {from=l2,step=1,to=u2-1} 
	(fn j => 
	 print (makestring_real (sub2(A,(i,j))) ^ ", "));
	print (makestring_real (sub2(A,(i,u2))) ^ "]\n")))
  val array1 = fn ((l,u),v) => (Array.array(u-l+1,v),(l,u))
  val sub1 = fn ((A,(l:int,u:int)),i:int) => Array.sub(A,i-l) 
  val update1 = fn((A,(l,_)),i,v) => Array.update(A,i-l,v)
  fun bounds1(_,b) = b
 (*
  * Specification of the state variable computation
  *)
  val grid_size = ((2,grid_max), (2,grid_max))
  fun north (k,l) = (k-1,l)	
  fun south (k,l) = (k+1,l)		
  fun east (k,l) = (k,l+1)
  fun west (k,l) = (k,l-1)
  val northeast = north o east
  val southeast = south o east
  val northwest = north o west		
  val southwest = south o west
  val farnorth = fn a => (north o north) a
  val farsouth = fn a => (south o south) a
  val fareast = fn a => (east o east) a
  val farwest = fn a => (west o west) a
  fun zone_A(k,l) = (k,l)
  fun zone_B(k,l) = (k+1,l)
  fun zone_C(k,l) = (k+1,l+1)		
  fun zone_D(k,l) = (k,l+1)
  val  zone_corner_northeast = north   
  val  zone_corner_northwest = northwest
  fun  zone_corner_southeast zone = zone
  val  zone_corner_southwest = west
      
  val ((kmin,kmax),(lmin,lmax)) 	= grid_size
  val dimension_all_nodes   	= ((kmin-1,kmax+1),(lmin-1,lmax+1))
  fun for_all_nodes f =
      for {from=kmin-1, step=1, to=kmax+1} 
      (fn k =>
       for {from=lmin-1, step=1, to=lmax+1} (fn l => f k l))
  val dimension_interior_nodes  	= ((kmin,kmax),(lmin,lmax))
  fun for_interior_nodes f =
      for {from=kmin, step=1, to=kmax} 
      (fn k =>
       for {from=lmin, step=1, to=lmax} (fn l => f k l))
  val dimension_all_zones  	= ((kmin,kmax+1),(lmin,lmax+1))
  fun for_all_zones f =
      for {from=kmin, step=1, to=kmax+1} 
      (fn k =>
       for {from=lmin, step=1, to=lmax+1} (fn l => f (k,l)))
  val dimension_interior_zones  	= ((kmin+1,kmax),(lmin+1,lmax))
  fun for_interior_zones f =
      for {from=kmin+1, step=1, to=kmax} 
      (fn k =>
       for {from=lmin+1, step=1, to=lmax} (fn l => f (k,l)))
  fun map_interior_nodes f =
      flatten(map (fn k => (map (fn l => f (k,l)) 
			    (from(lmin,lmax))))
	      (from(kmin,kmax)))
  fun map_interior_zones f =
      flatten(map (fn k => (map (fn l => f (k,l)) 
			    (from(lmin+1,lmax))))
	      (from(kmin+1,kmax)))

  fun for_north_ward_interior_zones f =
      for {from=kmax, step= ~1, to=kmin+1} 
      (fn k =>
       for {from=lmin+1, step=1, to=lmax} (fn l => f (k,l)))
  fun for_west_ward_interior_zones f = 
    for {from=kmin+1, step=1, to=kmax} 
    (fn k =>
     for {from=lmax, step= ~1, to=lmin+1} (fn l => f (k,l)))

  fun for_north_zones f = 
      for {from=lmin, step=1, to=lmax+1} (fn l => f (kmin,l))
  fun for_south_zones f = 
      for {from=lmin+1, step=1, to=lmax} (fn l => f (kmax+1,l))
  fun for_east_zones f = 
      for {from=kmin+1, step=1, to=kmax+1}(fn k => f (k,lmax+1))
  fun for_west_zones f = 
      for {from=kmin+1, step=1, to=kmax+1}(fn k => f (k,lmin))

  type real_array2 = (real Array2.array2) * ((int * int) * (int * int))
  fun reflect dir (node:int*int) (A:real_array2) = sub2(A, dir node)
  val reflect_north = reflect north
  val reflect_south = reflect south
  val reflect_east = reflect east
  val reflect_west = reflect west

  fun for_north_nodes f =
      for {from=lmin, step=1, to=lmax-1} (fn l => f (kmin-1,l))
  fun for_south_nodes f =
      for {from=lmin, step=1, to=lmax-1} (fn l => f (kmax+1,l))
  fun for_east_nodes f  = 
      for {from=kmin, step=1, to=kmax-1} (fn k => f (k,lmax+1))
  fun for_west_nodes f =
      for {from=kmin, step=1, to=kmax-1} (fn k => f (k,lmin-1))

  val north_east_corner = (kmin-1,lmax+1)
  val north_west_corner = (kmin-1,lmin-1)
  val south_east_corner = (kmax+1,lmax+1)
  val south_west_corner = (kmax+1,lmin-1)

  val west_of_north_east = (kmin-1, lmax)
  val west_of_south_east = (kmax+1, lmax)
  val north_of_south_east = (kmax, lmax+1)
  val north_of_south_west = (kmax, lmin-1)

  (*
   * Initialization of parameters
   *)
  val  constant_heat_source = 0.0
  val  deltat_maximum = 0.01
  val  specific_heat = 0.1
  val  p_coeffs = let val M = array2(((0,2),(0,2)), 0.0)
		  in update2(M, (1,1), 0.06698); M
		  end
  val e_coeffs = let val M = array2(((0,2),(0,2)), 0.0)
		 in update2(M, (0,1), 0.1); M
		 end

  val p_poly   = array2(((1,4),(1,5)),p_coeffs)
      
  val e_poly   = array2(((1,4),(1,5)), e_coeffs)
  val rho_table = let val V = array1((1,3), 0.0)
		  in  update1(V,2,1.0);
		      update1(V,3,100.0);
		      V
		  end
  val theta_table = let val V = array1((1,4), 0.0)
		    in update1(V,2,3.0);
			update1(V,3,300.0);
			update1(V,4,3000.0);
			V
		    end

  val extract_energy_tables_from_constants  = (e_poly,2,rho_table,theta_table)
  val extract_pressure_tables_from_constants = (p_poly,2,rho_table,theta_table)

  val nbc = let val M = array2(dimension_all_zones, 1)
	    in for {from=lmin+1,step=1,to=lmax} (fn j => update2(M,(kmax+1, j),2));
		update2(M,(kmin,lmin),4);
		update2(M,(kmin,lmax+1),4);
		update2(M,(kmax+1,lmin),4);
		update2(M,(kmax+1,lmax+1),4);
		M
	    end
  val pbb = let val A = array1((1,4), 0.0)
	    in update1(A,2,6.0); A
	    end
  val pb  = let val A = array1((1,4), 1.0)
	    in update1(A,2,0.0); update1(A,3,0.0); A
	    end
  val qb  = pb

  val all_zero_nodes = array2(dimension_all_nodes, 0.0)
  val all_zero_zones = array2(dimension_all_zones, 0.0)


  (*
   * Positional Coordinates. (page 9-10)
   *)
  fun make_position_matrix interior_function =
    let val r' = array2(dimension_all_nodes, 0.0)
	val z' = array2(dimension_all_nodes, 0.0)
	fun boundary_position (rx,zx,ry,zy,ra,za) =
	    let val (rax, zax)  =  (ra - rx, za - zx)
		val (ryx, zyx)  =  (ry - rx, zy - zx)
		val omega       =  2.0*(rax*ryx + zax*zyx)/(ryx*ryx + zyx*zyx)
		val rb 	    	=  rx - rax + omega*ryx
		val zb 	    	=  zx - zax + omega*zyx
	    in (rb, zb)
	    end
	
	fun reflect_node (x_dir, y_dir, a_dir, node) =
	    let val rx = reflect x_dir  node  r'
		val zx = reflect x_dir  node  z'
		val ry = reflect y_dir  node  r'
		val zy = reflect y_dir  node  z'
		val ra = reflect a_dir  node  r'
		val za = reflect a_dir  node  z'
	    in boundary_position (rx, zx, ry, zy, ra, za)
	    end
	fun u2 (rv,zv) n = (update2(r',n,rv); update2(z',n,zv))
    in
	for_interior_nodes (fn k => fn l => u2 (interior_function (k,l)) (k,l));
	for_north_nodes(fn n => u2 (reflect_node(south,southeast,farsouth,n)) n);
	for_south_nodes (fn n => u2(reflect_node(north,northeast,farnorth,n)) n);
	for_east_nodes (fn n => u2(reflect_node(west, southwest, farwest, n)) n);
	for_west_nodes (fn n => u2(reflect_node(east, southeast, fareast, n)) n);
	u2 (reflect_node(south, southwest, farsouth, west_of_north_east))
	   west_of_north_east;
        u2 (reflect_node(north, northwest, farnorth, west_of_south_east)) 
	   west_of_south_east;
	u2 (reflect_node(west, northwest, farwest, north_of_south_east))
	   north_of_south_east;
	u2 (reflect_node(east, northeast, fareast, north_of_south_west))
	   north_of_south_west;
	u2 (reflect_node(southwest, west, farwest, north_east_corner))
	   north_east_corner;
	u2 (reflect_node(northwest, west, farwest, south_east_corner))
	   south_east_corner;
	u2 (reflect_node(southeast, south, farsouth, north_west_corner))
	   north_west_corner;
	u2 (reflect_node(northeast, east, fareast, south_west_corner))
	   south_west_corner; 
        (r',z')
    end

      


  (*
   * Physical Properties of a Zone (page 10)
   *)
  fun zone_area_vol ((r,z), zone) =
    let val (r1,z1)=(sub2(r,zone_corner_southwest zone),
		     sub2(z,zone_corner_southwest zone))
	val (r2,z2)=(sub2(r,zone_corner_southeast zone),
		     sub2(z,zone_corner_southeast zone))
	val (r3,z3)=(sub2(r,zone_corner_northeast zone),
		     sub2(z,zone_corner_northeast zone))
	val (r4,z4)=(sub2(r,zone_corner_northwest zone),
		     sub2(z,zone_corner_northwest zone))
	val area1  =  (r2-r1)*(z3-z1) - (r3-r2)*(z3-z2)
	val radius1  =  0.3333  *(r1+r2+r3)
	val volume1  =  area1 * radius1
	val area2  =  (r3-r1)*(z4-z3) - (r4-r3)*(z3-z1)
	val radius2  =  0.3333 *(r1+r3+r4)
	val volume2  =  area2 * radius2
    in  (area1+area2, volume1+volume2)
    end

  (*
   * Velocity (page 8)
   *)
  fun make_velocity((u,w),(r,z),p,q,alpha,rho,delta_t) =
    let fun line_integral (p,z,node) : real =
 	    sub2(p,zone_A node)*(sub2(z,west node) - sub2(z,north node)) +
	    sub2(p,zone_B node)*(sub2(z,south node) - sub2(z,west node)) +
	    sub2(p,zone_C node)*(sub2(z,east node) - sub2(z,south node)) +
	    sub2(p,zone_D node)*(sub2(z,north node) - sub2(z,east node))
	fun regional_mass node =
	    0.5 * (sub2(rho, zone_A node)*sub2(alpha,zone_A node) +
		   sub2(rho, zone_B node)*sub2(alpha,zone_B node) +
		   sub2(rho, zone_C node)*sub2(alpha,zone_C node) +
		   sub2(rho, zone_D node)*sub2(alpha,zone_D node))
	fun velocity node =
	    let val d = regional_mass node
		val n1 = ~(line_integral(p,z,node)) - line_integral(q,z,node)
		val n2 = line_integral(p,r,node) + line_integral(q,r,node)
		val u_dot = n1/d
		val w_dot = n2/d
	    in (sub2(u,node)+delta_t*u_dot, sub2(w,node)+delta_t*w_dot)
	    end
	val U = array2(dimension_interior_nodes,0.0)
	val W = array2(dimension_interior_nodes,0.0)
    in for_interior_nodes (fn k => fn l => let val (uv,wv) = velocity (k,l)
					   in update2(U,(k,l),uv);
					      update2(W,(k,l),wv)
					   end);
       (U,W)
    end



  fun make_position ((r,z),delta_t:real,(u',w')) =
    let fun interior_position node = 
            (sub2(r,node) + delta_t*sub2(u',node), 
	     sub2(z,node) + delta_t*sub2(w',node))
    in make_position_matrix interior_position
    end
	

  fun make_area_density_volume(rho, s, x') =
    let val alpha' = array2(dimension_all_zones, 0.0)
	val s' = array2(dimension_all_zones, 0.0)
	val rho' = array2(dimension_all_zones, 0.0)
	fun interior_area zone = 
 	    let val (area, vol) = zone_area_vol (x', zone)
		val density =  sub2(rho,zone)*sub2(s,zone) / vol
	    in (area,vol,density)
	    end
	fun reflect_area_vol_density reflect_function = 
	    (reflect_function alpha',reflect_function s',reflect_function rho')
	fun update_asr (zone,(a,s,r)) = (update2(alpha',zone,a);
					 update2(s',zone,s);
					 update2(rho',zone,r))
	fun r_area_vol_den (reflect_dir,zone) =
	    let val asr =  reflect_area_vol_density (reflect_dir zone)
	    in update_asr(zone, asr)
	    end
    in
	for_interior_zones (fn zone => update_asr(zone, interior_area zone));
        for_south_zones (fn zone => r_area_vol_den(reflect_north, zone));
        for_east_zones (fn zone => r_area_vol_den(reflect_west, zone));
        for_west_zones (fn zone => r_area_vol_den(reflect_east, zone));
        for_north_zones (fn zone => r_area_vol_den(reflect_south, zone));
	(alpha', rho', s')
    end 


  (*
   * Artifical Viscosity (page 11)
   *)
  fun make_viscosity(p,(u',w'),(r',z'), alpha',rho') = 
    let	fun interior_viscosity zone =
	let fun upper_del f = 
	    0.5 * ((sub2(f,zone_corner_southeast zone) - 
		    sub2(f,zone_corner_northeast zone)) +
		   (sub2(f,zone_corner_southwest zone) - 
		    sub2(f,zone_corner_northwest zone)))
	    fun lower_del f = 
		0.5 * ((sub2(f,zone_corner_southeast zone) - 
			sub2(f,zone_corner_southwest zone)) +
		       (sub2(f,zone_corner_northeast zone) - 
			sub2(f,zone_corner_northwest zone)))
	    val xi 	= pow(upper_del   r',2) + pow(upper_del   z',2)
	    val eta = pow(lower_del   r',2) + pow(lower_del   z',2)
	    val upper_disc =  (upper_del r')*(lower_del w') - 
		              (upper_del z')*(lower_del u')
	    val lower_disc = (upper_del u')*(lower_del z') -
		             (upper_del w') * (lower_del r')
	    val upper_ubar = if upper_disc<0.0   then upper_disc/xi    else 0.0
	    val lower_ubar = if lower_disc<0.0   then lower_disc/eta    else 0.0
	    val gamma    = 1.6
	    val speed_of_sound  =  gamma*sub2(p,zone)/sub2(rho',zone)
	    val ubar  =  pow(upper_ubar,2) + pow(lower_ubar,2)
	    val viscosity   =  
		sub2(rho',zone)*(1.5*ubar + 0.5*speed_of_sound*(Ccall(sqrt, ubar)))
	    val length   = Ccall(sqrt,pow(upper_del r',2) + pow(lower_del r',2))
	    val courant_delta = 0.5* sub2(alpha',zone)/(speed_of_sound*length)
	in (viscosity, courant_delta)
	end
	val q' = array2(dimension_all_zones, 0.0)
	val d  = array2(dimension_all_zones, 0.0)
	fun reflect_viscosity_cdelta (direction, zone) =
	    sub2(q',direction zone) * sub1(qb, sub2(nbc,zone))
	fun do_zones (dir,zone) = 
	    update2(q',zone,reflect_viscosity_cdelta (dir,zone))
    in
	for_interior_zones (fn zone => let val (qv,dv) = interior_viscosity zone
				       in update2(q',zone,qv);
					   update2(d,zone,dv)
				       end);
	for_south_zones (fn zone => do_zones(north,zone));
	for_east_zones (fn zone => do_zones(west,zone));
	for_west_zones (fn zone => do_zones(east,zone));
	for_north_zones (fn zone => do_zones(south,zone));
        (q', d) 
    end

  (*
   * Pressure and Energy Polynomial (page 12)
   *)
  fun polynomial(G,degree,rho_table,theta_table,rho_value,theta_value) =
    let fun table_search (table, value:real) =
	    let val (low, high) = bounds1  table
		fun search_down  i =  if  value > sub1(table,i-1)  then i
				      else search_down (i-1)
	    in  
		if  value>sub1(table,high)  then  high+1
		else if  value <= sub1(table,low)  then low
		     else search_down   high
	    end
	val rho_index = table_search(rho_table, rho_value)
	val theta_index = table_search(theta_table, theta_value)
	val A =  sub2(G, (rho_index, theta_index))
	fun from(n,m) = if n>m then [] else n::from(n+1,m)
	fun f(i,j) = sub2(A,(i,j))*pow(rho_value,i)*pow(theta_value,j)
    in
	sum_list (map (fn i => sum_list(map (fn j => f (i,j)) (from(0,degree))))
		      (from (0,degree)))
    end
  fun zonal_pressure  (rho_value:real,  theta_value:real)  =
    let val (G,degree,rho_table,theta_table) = 
		            extract_pressure_tables_from_constants
    in polynomial(G, degree, rho_table, theta_table, rho_value, theta_value)
    end


  fun zonal_energy (rho_value, theta_value) = 
    let val (G, degree, rho_table, theta_table) = 
	   		    extract_energy_tables_from_constants
    in polynomial(G, degree, rho_table, theta_table, rho_value, theta_value)
    end
  val dx =   0.000001
  val tiny = 0.000001


  fun newton_raphson (f,x) =
    let	fun iter (x,fx) =
	    if fx > tiny then 
		let val fxdx = f(x+dx)
		    val denom = fxdx - fx
		in if denom < tiny then iter(x,tiny)
		   else iter(x-fx*dx/denom, fxdx)
		end
	    else x
    in iter(x, f x)
    end

  (*
   * Temperature (page 13-14)
   *)
  fun make_temperature(p,epsilon,rho,theta,rho_prime,q_prime) =
    let fun interior_temperature   zone =
	    let val qkl = sub2(q_prime,zone)
		val rho_kl = sub2(rho,zone)
		val rho_prime_kl = sub2(rho_prime,zone)
		val tau_kl = (1.0 /rho_prime_kl - 1.0/rho_kl)
		fun energy_equation epsilon_kl   theta_kl =
		    epsilon_kl -  zonal_energy(rho_kl,theta_kl)
		val epsilon_0 = sub2(epsilon,zone)
		fun revised_energy pkl =  epsilon_0 - (pkl + qkl) * tau_kl
		fun revised_temperature  epsilon_kl   theta_kl =
		    newton_raphson ((energy_equation epsilon_kl), theta_kl)
		fun revised_pressure  theta_kl = zonal_pressure(rho_kl, theta_kl)
		val p_0 = sub2(p,zone)
		val theta_0 = sub2(theta,zone)
		val epsilon_1 =  revised_energy    p_0
		val theta_1 =  revised_temperature    epsilon_1    theta_0
		val p_1 =  revised_pressure    theta_1
		val epsilon_2 =  revised_energy    p_1
		val theta_2 =  revised_temperature    epsilon_2    theta_1
	    in  theta_2
	    end
	val M = array2(dimension_all_zones, constant_heat_source)
    in
	for_interior_zones
	      (fn zone => update2(M, zone, interior_temperature zone));
	M
    end


  (*
   * Heat conduction
   *)
  fun make_cc(alpha_prime, theta_hat) =
    let fun interior_cc zone =  
	    (0.0001 * pow(sub2(theta_hat,zone),2) *
	    (Ccall(sqrt,abs(sub2(theta_hat,zone)))) / sub2(alpha_prime,zone))
	    handle Sqrt => (print (makestring_real (sub2(theta_hat, zone)));
			    print ("\nzone =(" ^ makestring_int (#1 zone) ^ "," ^ 
				   makestring_int (#2 zone) ^ ")\n");
			    printarray2 theta_hat;
			    raise Sqrt)
	val cc = array2(dimension_all_zones, 0.0)
    in
       for_interior_zones(fn zone => update2(cc,zone, interior_cc zone));
       for_south_zones(fn zone => update2(cc,zone, reflect_north zone cc));
       for_west_zones(fn zone => update2(cc,zone,reflect_east zone cc));
       for_east_zones(fn zone => update2(cc,zone,reflect_west zone cc));
       for_north_zones(fn zone => update2(cc,zone, reflect_south zone cc)); 
       cc
    end

  fun make_sigma(deltat, rho_prime, alpha_prime) =
    let fun interior_sigma   zone =  
	    sub2(rho_prime,zone)*sub2(alpha_prime,zone)*specific_heat/ deltat
	val M = array2(dimension_interior_zones, 0.0)
	fun ohandle zone =
	    (print (makestring_real (sub2(rho_prime, zone)) ^ " ");
	     print (makestring_real (sub2(alpha_prime, zone)) ^ " ");
	     print (makestring_real specific_heat ^ " ");
	     print (makestring_real deltat ^ "\n");
	     raise Overflow)
		    
    in  if !Control_trace 
        then print ("\t\tmake_sigma:deltat = " ^ makestring_real deltat ^ "\n")
	else ();
(***	for_interior_zones(fn zone => update2(M,zone, interior_sigma zone)) **)
	for_interior_zones(fn zone => (update2(M,zone, interior_sigma zone)
				       handle Overflow => ohandle zone));
	M
    end

  fun make_gamma  ((r_prime,z_prime), cc, succeeding, adjacent) =
    let fun interior_gamma   zone =
	    let val r1 = sub2(r_prime, zone_corner_southeast   zone)
		val z1 = sub2(z_prime, zone_corner_southeast   zone)
		val r2 = sub2(r_prime, zone_corner_southeast (adjacent   zone))
		val z2 = sub2(z_prime, zone_corner_southeast (adjacent   zone))
		val cross_section = 0.5*(r1+r2)*(pow(r1 - r2,2)+pow(z1 - z2,2))
		val (c1,c2) = (sub2(cc, zone), sub2(cc, succeeding zone))
		val specific_conductivity =  2.0 * c1 * c2 / (c1 + c2)
	    in cross_section  *  specific_conductivity
	    end
	val M = array2(dimension_all_zones, 0.0)
    in
	for_interior_zones(fn zone => update2(M,zone,interior_gamma zone));
 	M
    end

  fun make_ab(theta, sigma, Gamma, preceding) =
    let val a = array2(dimension_all_zones, 0.0)
	val b = array2(dimension_all_zones, 0.0)
	fun interior_ab   zone =
  	    let val denom = sub2(sigma, zone) + sub2(Gamma, zone) +
		            sub2(Gamma, preceding zone) * 
			    (1.0 - sub2(a, preceding zone))
		val nume1 = sub2(Gamma,zone)
		val nume2 = sub2(Gamma,preceding zone)*sub2(b,preceding zone) +
		            sub2(sigma,zone) * sub2(theta,zone)
	    in  (nume1/denom,  nume2 / denom)  
	    end
	val f  = fn zone => update2(b,zone,sub2(theta,zone))
    in
	for_north_zones f;
	for_south_zones f;
	for_west_zones f;
	for_east_zones f;
	for_interior_zones(fn zone => let val ab = interior_ab zone
				      in update2(a,zone,#1 ab);
					  update2(b,zone,#2 ab)
				      end);
	(a,b)
    end

  fun make_theta (a, b, succeeding, int_zones) =
    let val theta = array2(dimension_all_zones, constant_heat_source)
	fun interior_theta zone =  
	    sub2(a,zone) * sub2(theta,succeeding zone)+ sub2(b,zone)
    in
	int_zones (fn (k,l) => update2(theta, (k,l), interior_theta (k,l)));
	theta
    end

  fun compute_heat_conduction(theta_hat, deltat, x', alpha', rho') =
    let val sigma 	= make_sigma(deltat,  rho',  alpha')
	val _ = if !Control_trace then print "\tdone make_sigma\n" else ()

	val cc 		= make_cc(alpha',  theta_hat)
	val _ = if !Control_trace then print "\tdone make_cc\n" else ()

	val Gamma_k  	= make_gamma(  x', cc, north, east)
	val _ = if !Control_trace then print "\tdone make_gamma\n" else ()

	val (a_k,b_k)  	= make_ab(theta_hat, sigma, Gamma_k, north)
	val _ = if !Control_trace then print "\tdone make_ab\n" else ()

	val theta_k  	= make_theta(a_k,b_k,south,for_north_ward_interior_zones)
	val _ = if !Control_trace then print "\tdone make_theta\n" else ()

	val Gamma_l  	= make_gamma(x', cc, west, south)
	val _ = if !Control_trace then print "\tdone make_gamma\n" else ()

	val (a_l,b_l) 	= make_ab(theta_k, sigma, Gamma_l, west)
	val _ = if !Control_trace then print "\tdone make_ab\n" else ()

	val theta_l  	= make_theta(a_l,b_l,east,for_west_ward_interior_zones)
	val _ = if !Control_trace then print "\tdone make_theta\n" else ()
    in  (theta_l, Gamma_k, Gamma_l)
    end


  (*
   * Final Pressure and Energy calculation
   *)
  fun make_pressure(rho', theta')  =
    let val p = array2(dimension_all_zones, 0.0)
	fun boundary_p(direction, zone) = 
	    sub1(pbb, sub2(nbc, zone)) + 
	    sub1(pb,sub2(nbc,zone)) * sub2(p, direction zone)
    in
	for_interior_zones
	    (fn zone => update2(p,zone,zonal_pressure(sub2(rho',zone),
						      sub2(theta',zone))));
	for_south_zones(fn zone => update2(p,zone,boundary_p(north,zone)));
	for_east_zones(fn zone => update2(p,zone,boundary_p(west,zone)));
	for_west_zones(fn zone => update2(p,zone,boundary_p(east,zone)));
	for_north_zones(fn zone => update2(p,zone,boundary_p(south,zone)));
	p
    end

  fun make_energy(rho', theta')  =
    let val epsilon' = array2(dimension_all_zones, 0.0)
    in
	for_interior_zones
	  (fn zone => update2(epsilon', zone, zonal_energy(sub2(rho',zone),
							   sub2(theta',zone))));
        for_south_zones
	  (fn zone => update2(epsilon',zone, reflect_north zone epsilon'));
        for_west_zones
	  (fn zone => update2(epsilon',zone, reflect_east zone epsilon'));
        for_east_zones
	  (fn zone => update2(epsilon',zone, reflect_west  zone epsilon'));
	for_north_zones
	  (fn zone => update2(epsilon',zone, reflect_south zone epsilon'));
	epsilon'
    end


  (*
   * Energy Error Calculation (page 20)
   *)

  fun compute_energy_error  ((u',w'),(r',z'),p',q',epsilon',theta',rho',alpha',
			   Gamma_k,Gamma_l,deltat)  =
    let fun mass zone =  sub2(rho',zone) * sub2(alpha',zone):real
	val internal_energy = 
	    sum_list (map_interior_zones (fn z => sub2(epsilon',z)*(mass z)))
	fun kinetic   node =
	    let val average_mass =  0.25*((mass (zone_A  node)) + 
					  (mass (zone_B  node)) +
					  (mass (zone_C  node)) + 
					  (mass (zone_D  node)))
		val v_square = pow(sub2(u',node),2) + pow(sub2(w',node),2)
	    in 0.5 * average_mass * v_square
	    end
	val kinetic_energy =  sum_list (map_interior_nodes kinetic)
      fun work_done (node1, node2)  =
	  let val (r1, r2) = (sub2(r',node1), sub2(r',node2))
	      val (z1, z2) = (sub2(z',node1), sub2(z',node2))
	      val (u1, u2) = (sub2(p',node1), sub2(p',node2))
	      val (w1, w2) = (sub2(z',node1), sub2(z',node2))
	      val (p1, p2) = (sub2(p',node1), sub2(p',node2))
	      val (q1, q2) = (sub2(q',node1), sub2(q',node2))
	      val force =  0.5*(p1+p2+q1+q2)
	      val radius = 0.5* (r1+r2)
	      val area =   0.5* ((r1-r2)*(u1-u2) - (z1-z2)*(w1-w2))
	  in  force * radius * area * deltat
	  end

      fun from(n,m) = if n > m then [] else n::from(n+1,m)
      val north_line = 
	  map (fn l => (west(kmin,l),(kmin,l))) (from(lmin+1,lmax))
      val south_line =
	  map (fn l => (west(kmax,l),(kmax,l))) (from(lmin+1,lmax))
      val east_line  =
	  map (fn k => (south(k,lmax),(k,lmax))) (from(kmin+1,kmax))
      val west_line  =
	  map (fn k => (south(k,lmin+1),(k,lmin+1))) (from(kmin+1,kmax))

      val w1 = sum_list (map work_done north_line)
      val w2  = sum_list (map work_done south_line)
      val w3  = sum_list (map work_done east_line)
      val w4  = sum_list (map work_done west_line)
      val boundary_work =  w1 + w2 + w3 + w4

      fun heat_flow  Gamma (zone1,zone2)  =
	deltat * sub2(Gamma, zone1) * (sub2(theta',zone1) - sub2(theta',zone2))

      val north_flow =
	  let val k = kmin+1 
	  in map (fn l => (north(k,l),(k,l))) (from(lmin+1,lmax))
	  end
      val south_flow =
	  let val k = kmax
	  in map (fn l => (south(k,l),(k,l))) (from(lmin+2,lmax-1))
	  end
      val east_flow  =
	  let val l = lmax
	  in map (fn k => (east(k,l),(k,l))) (from(kmin+2,kmax))
	  end
      val west_flow  =
	  let val l = lmin+1
	  in map (fn k => (west(k,l),(k,l))) (from(kmin+2,kmax))
	  end

     val h1  = sum_list    (map (heat_flow  Gamma_k)   north_flow)
     val h2  = sum_list    (map (heat_flow  Gamma_k)   south_flow)
     val h3  = sum_list    (map (heat_flow  Gamma_l)   east_flow)
     val h4  = sum_list    (map (heat_flow  Gamma_l)   west_flow)
     val boundary_heat =  h1 + h2 + h3 + h4
    in 
	internal_energy  +  kinetic_energy  -  boundary_heat  -  boundary_work
    end

  fun compute_time_step(d, theta_hat,  theta') =
    let val deltat_courant =
	    min_list (map_interior_zones (fn zone => sub2(d,zone)))
	val deltat_conduct =
	    max_list (map_interior_zones 
		        (fn z => (abs(sub2(theta_hat,z) - sub2(theta', z))/
				  sub2(theta_hat,z))))
	val deltat_minimum = min (deltat_courant, deltat_conduct)
    in min   (deltat_maximum,  deltat_minimum)
    end


  fun compute_initial_state () = 
    let 
(*	val _ = output(1,"entered initial_state\n") *)
        val v  = (all_zero_nodes, all_zero_nodes)
(*	val _ = output(1,"entered initial_state 1\n") *)
	val x  = let fun interior_position  (k,l)  =
	                 let val pi = 3.1415926535898
			     val rp = real (lmax - lmin)
			     val z1 = real(10 + k - kmin)
			     val zz = (~0.5 + real(l - lmin) / rp) * pi
			 in (z1 * (Ccall(cos,zz)),  z1 * (Ccall(sin, zz)))
			 end
		 in  make_position_matrix interior_position
		 end
(*	val _ = output(1,"entered initial_state 2\n") *)
	val (alpha,s) = 
	    let val (alpha_prime,s_prime) = 
		    let 
			val A = array2(dimension_all_zones, 0.0)
			val S = array2(dimension_all_zones, 0.0)
			
			fun reflect_area_vol f = (f A, f S)

			fun u2 (f,z) = 
			    let val (a,s) = reflect_area_vol(f z)
			    in update2(A,z,a);
				update2(S,z,s)
			    end
		    in
			for_interior_zones 
		   (fn z => let val (a,s) = zone_area_vol(x, z)
				    in update2(A,z,a);
					update2(S,z,s)
				    end);
			for_south_zones (fn z => u2 (reflect_north, z));
			for_east_zones (fn z => u2 (reflect_west, z));
			for_west_zones (fn z => u2 (reflect_east, z));
			for_north_zones (fn z => u2 (reflect_south, z));
			(A,S)
		    end
	    in  (alpha_prime,s_prime)
	    end
	val rho  = let val R = array2(dimension_all_zones, 0.0)
		   in for_all_zones (fn z => update2(R,z,1.4)); R
		   end
	val theta = 
	    let val T = array2(dimension_all_zones, constant_heat_source)
	    in for_interior_zones(fn z => update2(T,z,0.0001));
		T
	    end

	val p       = make_pressure(rho, theta)

	val q       = all_zero_zones

	val epsilon = make_energy(rho, theta)

	val  deltat  = 0.01
	val  c       = 0.0
    in
	(v,x,alpha,s,rho,p,q,epsilon,theta,deltat,c)
    end


  fun compute_next_state state =
    let
	val (v,x,alpha,s,rho,p,q,epsilon,theta,deltat,c) = state
	val v'  = make_velocity (v, x, p, q, alpha, rho, deltat)
	val _ = if !Control_trace then print "done make_velocity\n" else ()

	val x'  = make_position(x,deltat,v') 
	          handle Overflow =>(printarray2 (#1 v'); 
				     printarray2 (#2 v');
				     raise Overflow)
	val _ = if !Control_trace then print "done make_position\n" else ()

	val (alpha',rho',s')  = make_area_density_volume (rho,  s , x')
	val _ = if !Control_trace then print "done make_area_density_volume\n"
		else ()

	val (q',d)  = make_viscosity (p,  v',  x',  alpha',  rho')
	val _ = if !Control_trace then print "done make_viscosity\n" else ()

	val theta_hat  = make_temperature (p, epsilon, rho, theta, rho', q')
	val _ = if !Control_trace then print "done make_temperature\n" else ()

	val (theta',Gamma_k,Gamma_l) =
	    compute_heat_conduction (theta_hat, deltat, x', alpha', rho')
	val _ = if !Control_trace then print "done compute_heat_conduction\n"
		else ()

	val p'  = make_pressure(rho', theta')
	val _ = if !Control_trace then print "done make_pressure\n" else ()

	val epsilon'  = make_energy (rho', theta')
	val _ = if !Control_trace then print "done make_energy\n" else ()

	val c'  = compute_energy_error (v', x', p', q', epsilon', theta', rho', 
					alpha', Gamma_k, Gamma_l,  deltat)
	val _ = if !Control_trace then print "done compute_energy_error\n" 
		else ()

	val deltat'  = compute_time_step (d, theta_hat, theta')
	val _ = if !Control_trace then print "done compute_time_step\n\n" else ()
    in
	(v',x',alpha',s',rho',p',q',  epsilon',theta',deltat',c')
    end

  fun print_state ((v1,v2),(r,z),alpha,s,rho,p,q,epsilon,theta,deltat,c) =
    (print "Velocity matrices = \n";
     printarray2 v1; print "\n\n";
     printarray2 v2;

     print "\n\nPosition matrices = \n";
     printarray2 r; print "\n\n";
     printarray2 z;
     
     print "\n\nalpha = \n";
     printarray2 alpha;

     print "\n\ns = \n";
     printarray2 s;

     print "\n\nrho = \n";
     printarray2 rho;

     print "\n\nPressure = \n";
     printarray2 p;

     print "\n\nq = \n";
     printarray2 q;
     
    
     print "\n\nepsilon = \n";
     printarray2 epsilon;

     print "\n\ntheta = \n";
     printarray2 theta;

     print ("delatat = " ^ makestring_real deltat ^ "\n");
     print ("c = " ^ makestring_real c ^ "\n"))

  fun runit (step_count,printflag) = 
    let
	val initial_state = compute_initial_state()
	fun iter (i,state) = if i = 0 then state
			     else (if (printflag) 
				       then (print_state state)
				   else print ".";
				   iter(i-1, compute_next_state state))
    in iter(step_count, initial_state)
    end


    fun run() = let val state = runit(4,false) 
		      (*  val _ = print_state state *)
		      in  ()
		      end
end

(* Simple *)


(* XENDX*)
(*  Compute the 100th Fibonacci number.
*)

structure Arithmetic :> RUN = 
  struct
  fun fib 0 = 1
    | fib 1 = 1
    | fib n = (fib(n-1)) + (fib(n-2))

  fun fastfib x = 
    let
      fun loop x x0 x1 = 
	if x = 0 then x0
	else loop (x-1) (x1) (x0 + x1)
    in loop x 1 1
    end

  fun fact x = if x = 0
		 then 1 
	       else x * fact (x -1)
    
  fun run () = 
    let
      val x = fib 40
      val _ = print "This should be 165580141: "
      val _ = print (Int.toString x)
      val _ = print "\n"
      val x = fastfib 40
      val _ = print "This should be 165580141: "
      val _ = print (Int.toString x)
      val _ = print "\n"
      val x = fact 12
      val _ = print "This should be 479001600: "
      val _ = print (Int.toString x)
      val _ = print "\n"
    in ()
    end
end

(* XENDX*)
(*  Compute the 100th Fibonacci number.
*)

structure Arithmetic32 :> RUN = 
  struct
   open Int32
  fun fib 0 = 1
    | fib 1 = 1
    | fib n = (fib(n-1)) + (fib(n-2))

  fun fastfib x = 
    let
      fun loop x x0 x1 = 
	if x = 0 then x0
	else loop (x-1) (x1) (x0 + x1)
    in loop x 1 1
    end

  fun fact x = if x = 0
		 then 1 
	       else x * fact (x -1)
    
  fun run () = 
    let
      val x = fib 40
      val _ = print "This should be 165580141: "
      val _ = print (Int32.toString x)
      val _ = print "\n"
      val x = fastfib 40
      val _ = print "This should be 165580141: "
      val _ = print (Int32.toString x)
      val _ = print "\n"
      val x = fact 12
      val _ = print "This should be 479001600: "
      val _ = print (Int32.toString x)
      val _ = print "\n"
    in ()
    end
end

(* XENDX*)
(*  
     Compute an approximation (2000th iterate)
       using the arc-tangent expansion. (McLauren series)
*)

structure F_Arithmetic :> RUN = 
  struct
    
   fun computePi steps = 
    let 
      fun loop (0,acc,_) = acc
	| loop (steps,acc,n) = 
	let val acc' = acc + (1.0 / n) - (1.0 / (n+2.0))
	in  loop (steps-1,acc',n+4.0)
	end
    in  4.0 * loop (steps,0.0,1.0)
    end
  

  fun run () = 
    let
      val y = computePi 100000000
      val _ = print "This should be an approximation of pi: "
      val _ = print (Real.toString y)
      val _ = print "\n"
    in ()
    end
end

(* XENDX*)
(* This benchmark runs a randomized search for solutions to the n-queens
   problem. (for n = 256, 1024, 8192)

    The program has very C-like behavior, allocating only a little
    memory and iterating over it many times. The efficiency of the
    code is probably bound tighly to the performance of standard
    bounds-checked, polymorphic arrays. This program also has several
    good candidates for inlining.
    
    RC4 is used as a deterministic arbitrary number generator.
*)

local

  signature RANDGEN = 
    sig
      
      exception KeyLength
      
      (* seed the generator with a string 1-256 characters long *)
      val seed : string -> unit
	
      (* get the next number in the sequence.
       return value will be in the range 0-255. *)
      val byte : unit -> int
	
    end
  (* 
   The RC4 algorithm by Rivest.
   Initialize the key with the seed function.
   
   SML by Tom 7, 2000
   Code in the public domain.
   *)

  structure Randgen :> RANDGEN =
    struct
      
      exception KeyLength
      
      val tub = Array.tabulate (256, fn x => x)
      fun S x = Array.sub (tub, x)
      val i = ref 0
      val j = ref 0
	
      fun seed key =
	let
	  val l = size key
	  val _ = (l = 0 orelse l > 256) andalso raise KeyLength
	  (* fill 0 -> 255 *)
	  val _ = Array.appi (fn (i,_) => Array.update (tub, i, i)) (tub, 0, NONE)
	  fun K x = ord (CharVector.sub(key, x mod l))
	  fun loop (256, u) = ()
	    | loop (x, u) = 
	    let val u = (u + S x + K x) mod 256
	      val old = S u
	    in  Array.update(tub, u, S x);
	      Array.update(tub, x, old);
	      loop(x+1, u)
	    end
	in
	  loop (0,0);
	  j := 0; 
	  i := 0
	end

      fun byte () =
	let
	  val _ = i := (!i + 1) mod 256
	  val _ = j := (!j + S(!i)) mod 256
	  val t = S(!i)
	in
	  Array.update (tub, !i, S(!j));
	  Array.update (tub, !j, t);
	  S ( (S(!i) + S(!j)) mod 256 )
	end
      
    end

  signature RAND =
    sig
      val rand : int * int -> int
    end 

  structure Rand :> RAND =
    struct
      
      fun rand (low, hi) =
	let val u = 
	  Randgen.byte () * 256 * 256 +
	  Randgen.byte () * 256 +
	  Randgen.byte ()
	in low + (u mod (hi - low))
	end
      
    end

  (* Random search for a solution to the n-queens problem,
   using patching and a hill-climbing heuristic.
   "Polynomial" time!
   
   "A Polynomial Time Algorithm for the N-Queens Problem",
   Rok Sosic and Jun Gu
   SIGART Bulletin, Vol. 1, 3, pp. 7-11, Oct 1990
   
   SML by Tom 7, 2001
   (distributed under the GPL)
   *)

  functor Queens (R : RAND) =
    struct
      
      exception Inconsistent
      
      structure A = Array
	
      fun I x = x
	
      fun inc (a, n) = A.update(a, n, A.sub(a, n) + 1)
      fun dec (a, n) = A.update(a, n, A.sub(a, n) - 1)
	
      fun aall f a = A.foldl (fn (a, b) => b andalso (f a)) true a
	
      fun ar2s a =
	(A.foldl (fn (a, b) => b ^ ", " ^ Int.toString a) "" a)
	
      fun random_permutation n =
	let
	  val arr = A.tabulate (n, I)
	in
	  A.appi (fn (i, a) =>
		  let val j = R.rand (0, n)
		    val t = A.sub (arr, j)
		  in
		    A.update (arr, j, A.sub(arr, i));
		    A.update (arr, i, t)
		  end) (arr, 0, NONE);
	  arr
	end
      
      fun queen_search n =
	let
	  val board = random_permutation n
	  val diagu = A.array (n * 2 - 1, 0)
	  val diagd = A.array (n * 2 - 1, 0)
	    
	  val didswap = ref false
	    
	  fun du i = A.sub(board, i) + i
	  fun dd i = A.sub(board, i) + ((n - 1) - i)

	  (* intialize diagonals *)
	  fun initd (u, d) i = 
	    if i = n then ()
	    else 
	      let in
		inc (u, du i);
		inc (d, dd i);
		initd (u, d) (i + 1)
	      end

	  fun swap ii jj =
	    let
	      val t = A.sub(board, ii)
	    in
	      dec (diagu, du ii);
	      dec (diagd, dd ii);
	      dec (diagu, du jj);
	      dec (diagd, dd jj);
	      A.update(board, ii, A.sub(board,jj));
	      A.update(board, jj, t);
	      inc (diagu, du ii);
	      inc (diagd, dd ii);
	      inc (diagu, du jj);
	      inc (diagd, dd jj)
	    end
	  
	  fun tryswaps () =
	    let
	      
	      val _ = didswap := false

	      fun allpairs ii =
		if ii >= n then ()
		else
		  let
		    fun allj jj =
		      if jj >= n then ()
		      else
			let
			in
			  if (A.sub (diagu, du ii) > 1 orelse
			      A.sub (diagd, dd ii) > 1 orelse
			      A.sub (diagu, du jj) > 1 orelse
			      A.sub (diagd, dd jj) > 1) then
			    (* one of ii and jj is attacked.
			     will swapping them help? *)
			    let
			      val Then = (A.sub (diagu, du ii) +
					  A.sub (diagd, dd ii) +
					  A.sub (diagu, du jj) +
					  A.sub (diagd, dd jj))

			      val _ = swap ii jj
				
			      val Now = (A.sub (diagu, du ii) +
					 A.sub (diagd, dd ii) +
					 A.sub (diagu, du jj) +
					 A.sub (diagd, dd jj))
			    in
			      if Now >= Then then
				(* made it worse! swap back. *)
				let in
				  swap ii jj
				end
			      else let in
				didswap := true
				   end
			    end
			  
			  else ();

			    allj (jj + 1)
			end
		  in
		    allj (ii + 1);
		    allpairs (ii + 1)
		  end
	    in
	      allpairs 0;
	      if (!didswap) then
		tryswaps ()
	      else 
		(* we are either done or stuck.
		 check it! *)
		(if aall (fn u => u <= 1) diagu andalso
		   aall (fn u => u <= 1) diagd
		   then
		     board
		 else
		   queen_search n)

	    end

	in
	  initd (diagu, diagd) 0;
	  tryswaps ()
	end
      
      
      fun printboard b =
	let
	  val _ = print ("      \tb (" ^ ar2s b ^ ") u (pb)\n")
	  val n = A.length b
	  fun alln i = if i = n then ()
		       else let in
			 A.app (fn j => print (if i = j then "X " else "- ")) b;
			 print "\n";
			 alln (i + 1)
			    end
	in
	  alln 0
	end
    end
in

  structure PQueens :> RUN = 
    struct
      
      structure Q = Queens(Rand);
	
	
      fun solve n = 
	let
	  val b = Q.queen_search n
	in
	  Q.printboard b
	end
      
    
      
      fun run () =
	let in
	  Randgen.seed "SML";
	  Q.queen_search 256;
	  Q.queen_search 1024;
	  (*           Q.queen_search 8192;*)
	  ()
	end
    end
end


(* XENDX*)
(***********************************************************************)
(*                                                                     *)
(*                         Caml Special Light                          *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1995 Institut National de Recherche en Informatique et   *)
(*  Automatique.  Distributed only by permission.                      *)
(*                                                                     *)
(***********************************************************************)

(* $Id$ *)

structure Takc :> RUN = 
  struct

    fun tak x y z =
      if x > y then tak (tak (x-1) y z) (tak (y-1) z x) (tak (z-1) x y)
      else z

    fun repeat n = if n <= 0 then 0 else tak 18 12 6 + repeat(n-1)
      
    fun run () = (print (Int.toString (repeat 500)); print "\n")

end

(* XENDX*)
(***********************************************************************)
(*                                                                     *)
(*                         Caml Special Light                          *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1995 Institut National de Recherche en Informatique et   *)
(*  Automatique.  Distributed only by permission.                      *)
(*                                                                     *)
(***********************************************************************)

(* $Id$ *)
(* *)
structure Taku :> RUN = 
  struct
    fun tak (x, y, z) =
      if x > y then tak(tak (x-1, y, z), tak (y-1, z, x), tak (z-1, x, y))
      else z

    fun repeat n =
      if n <= 0 then 0 else tak(18,12,6) + repeat(n-1)
	
    fun run () = (print (Int.toString (repeat 500)); print "\n")
end

(* XENDX*)
(* XENDX*)
(* XENDX*)


(* Merge sort *)

structure Msort :> RUN = 
  struct

fun revappend([],l2) = l2
  | revappend(hd::tl,l2) = revappend(tl,hd::l2)

fun sort (gt:int*int->bool) l = 
    let fun split l = foldl (fn (x,(a,b)) => (b,x::a)) ([],[]) l
	fun merge (l1,l2) = 
	    let fun m(l1,[],prev) = revappend(prev,l1)
		  | m([],l2,prev) = revappend(prev,l2)
		  | m(l1 as (x1::y1),l2 as (x2::y2),prev) = 
		if gt(x1,x2) then
		    m(l1,y2,x2::prev)
		else 
		    m(y1,l2,x1::prev)
	    in
			m(sort gt l1,sort gt l2,[])
	    end 
    in
	case l of
	    [] => l
	  | [_] => l
	  | _ => merge(split l) 
    end


fun gen (prev,i) = if (i = 0) then prev else gen(i::prev,i-1)
fun square(l,i) = if (i=0) then l else square(l @ l,i-1)

(* Goes from [start,stop] *)
fun for(start,stop,f) = 
  let fun loop i = if i > stop then () else (f i; loop (i+1))
  in
    loop start
  end



fun run () : unit = (print "Msort Started\n";
		     for(1,10,fn _ => sort (op >) (square(gen([],10),9)));
		     print "Msort Done\n")
             
end

(* msort *)

(*tyan *)

structure TextIO = 
struct
 val stdOut = 0
 val stdIn = 1
 fun flushOut x = 0
 exception Unimp
 fun inputLine _ = raise Unimp
 fun inputN _ = raise Unimp
 fun openIn s = raise Unimp
 fun closeIn s = raise Unimp
 fun endOfStream s = raise Unimp
end

functor makeRunTyan() :> RUN = 
struct
local


fun fold f l acc = List.foldr f acc l
fun revfold f l acc = List.foldl f acc l
val update = Array.update
val sub = Array.sub
val max = Int.max
val array = Array.array 

val int32touint32 = TiltPrim.int32touint32
val uint32toint32 = TiltPrim.uint32toint32

val && = TiltPrim.&&
val || = TiltPrim.||
val << = TiltPrim.<<
val >> = TiltPrim.>>

infix 7 && || << >>

val makestring_int = Int.toString
(* val andb = fn(x,y) => uint32toint32((int32touint32 x) && (int32touint32 y)) *)
val andb = fn(x,y) => uint32toint32((int32touint32 x) && (int32touint32 y))
val orb = fn(x,y) => uint32toint32((int32touint32 x) || (int32touint32 y))
val rshift = fn(x,y : int) => uint32toint32((int32touint32 x) >> y)
val lshift = fn(x,y : int) => uint32toint32((int32touint32 x) << y)
val (op >>) = rshift
val (op <<) = lshift

nonfix smlnj_mod
nonfix smlnj_div
val smlnj_mod = op mod
val smlnj_div = op div
infix 7 smlnj_mod
infix 7 smlnj_div

val char_implode = implode
val char_explode = explode
fun string_implode [] = ""
  | string_implode (s1::srest) = s1 ^ (string_implode srest)
fun string_explode s = map (fn c => implode[c]) (explode s)

exception Tabulate
fun tabulate (i,f) = 
if i <= 0 then raise Tabulate else
let val a = array(i,f 0)
    fun tabify j = if j < i then (update(a,j,f j); tabify (j+1)) else a
in
    tabify 1
end

exception ArrayofList
fun arrayoflist (hd::tl) =
let val a = array((length tl) + 1,hd)
    fun al([],_) = a
      | al(hd::tl,i) = (update(a,i,hd); al(tl,i+1))
in
    al(tl,1)
end
  | arrayoflist ([]) = raise ArrayofList


structure Util = struct
    datatype relation = Less | Equal | Greater

    exception NotImplemented of string
    exception Impossible of string (* flag "impossible" condition  *)
    exception Illegal of string (* flag function use violating precondition *)

    fun error exn msg = raise (exn msg)
    fun notImplemented msg = error NotImplemented msg
    fun impossible msg = error Impossible msg
    fun illegal msg = error Illegal msg

    (* arr[i] := obj :: arr[i]; extend non-empty arr if necessary *)
    fun insert (obj,i,arr) = let
	  val len = Array.length arr
          val res =  if i<len then (update(arr,i,obj::sub(arr,i)); arr)
	     else let val arr' = array(max(i+1,len+len),[])
		      fun copy ~1 = (update(arr',i,[obj]); arr')
			| copy j = (update(arr',j,sub(arr,j));
				    copy(j-1))
		      in copy(len-1) end 
          in res
          end

(*
    fun arrayoflists [] = arrayoflist []
      | arrayoflists ([]::ls) = arrayoflists ls
      | arrayoflists [l] = arrayoflist l
      | arrayoflists (ls as (obj0::_)::_) = let	 
	  val a = array(revfold (fn (l,n) => length l + n) ls 0,obj0)
	  fun ins (i,[]) = i | ins (i,x::l) = (update(a,i,x); ins(i+1,l))
	  fun insert (i,[]) = a | insert (i,l::ll) = insert(ins(i,l),ll)
          in insert(0,ls) end
*)

    (* given compare and array a, return list of contents of a sorted in
     * ascending order, with duplicates stripped out; which copy of a duplicate
     * remains is random.  NOTE that a is modified.
     *)
    fun stripSort compare = fn a => let
	  infix sub

(*	  val op sub = sub and update = update *)
	  fun swap (i,j) = let val ai = a sub i
			   in update(a,i,a sub j); update(a,j,ai) end
	  (* sort all a[k], 0<=i<=k<j<=length a *)
	  fun s (i,j,acc) = if i=j then acc else let
	        val pivot = a sub ((i+j) smlnj_div 2)
		fun partition (lo,k,hi) = if k=hi then (lo,hi) else
		      case compare (pivot,a sub k) of
			  Less => (swap (lo,k); partition (lo+1,k+1,hi))
			| Equal => partition (lo,k+1,hi)
			| Greater => (swap (k,hi-1); partition (lo,k,hi-1))
		val (lo,hi) = partition (i,i,j)
	        in s(i,lo,pivot::s(hi,j,acc)) end
	   val res = s(0,Array.length a,[]) 

          in 
	   res
	  end
end

structure F = struct
    val p = 17

    datatype field = F of int (* for (F n), always 0<=n<p *)
    (* exception Div = Integer.Div *)
    fun show (F x) = print (makestring_int x)

    val char = p

    val zero = F 0
    val one = F 1
    fun coerceInt n = F (n smlnj_mod p)

    fun add (F n,F m) = let val k = n+m in if k>=p then F(k-p) else F k end
    fun subtract (F n,F m) = if n>=m then F(n-m) else F(n-m+p)
    fun negate (F 0) = F 0 | negate (F n) = F(p-n)
    fun multiply (F n,F m) = F ((n*m) smlnj_mod p)
    fun reciprocal (F 0) = raise Div
      | reciprocal (F n) = let
          (* consider euclid gcd alg on (a,b) starting with a=p, b=n.
           * if maintain a = a1 n + a2 p, b = b1 n + b2 p, a>b,
	   * then when 1 = a = a1 n + a2 p, have a1 = inverse of n mod p
           * note that it is not necessary to keep a2, b2 around.
           *)
 	  fun gcd ((a,a1),(b,b1)) =
	      if b=1 then (* by continued fraction expansion, 0<|b1|<p *)
		 if b1<0 then F(p+b1) else F b1
	      else let val q = a smlnj_div b
	           in gcd((b,b1),(a-q*b,a1-q*b1)) end
          in gcd ((p,0),(n,1)) end
    fun divide (n,m) = multiply (n, reciprocal m)


    fun power(n,k) =
	  if k<=3 then case k of
	      0 => one
	    | 1 => n
	    | 2 => multiply(n,n)
	    | 3 => multiply(n,multiply(n,n))
	    | _ => reciprocal (power (n,~k)) (* know k<0 *)
	  else if andb(k,1)=0 then power(multiply(n,n),rshift(k,1))
	       else multiply(n,power(multiply(n,n),rshift(k,1)))

    fun isZero (F n) = n=0
    fun equal (F n,F m) = n=m

    fun display (F n) = if n<=p smlnj_div 2 then makestring_int n
			else "-" ^ makestring_int (p-n)
end


structure M = struct (* MONO *)
    local
	infix sub << >> andb
    in

(* encode (var,pwr) as a long word: hi word is var, lo word is pwr
   masks 0xffff for pwr, mask ~0x10000 for var, rshift 16 for var
   note that encoded pairs u, v have same var if u>=v, u andb ~0x10000<v
*)

    datatype mono = M of int list
(*
    fun show (M x) = (print "<"; app (fn i => (print (makestring_int i); print ",")) x; print">")
*)
    exception DoesntDivide

    val numVars = 32

    val one = M []
    fun x_i v = M [(v<<16)+1]
    fun explode (M l) = map (fn v => (v>>16,v andb 65535)) l
    fun implode l = M (map (fn (v,p) => (v<<16)+p) l)

    val deg = let fun d([],n) = n | d(u::ul,n) = d(ul,(u andb 65535) + n)
              in fn (M l) => d(l,0) end

    (* x^k > y^l if x>k or x=y and k>l *)
    val compare = let
	  fun cmp ([],[]) = Util.Equal
	    | cmp (_::_,[]) = Util.Greater
	    | cmp ([],_::_) = Util.Less
	    | cmp ((u::us), (v::vs)) = if u=v then cmp (us,vs)
		                  else if u<v then Util.Less
		                  else (* u>v *)   Util.Greater
          in fn (M m,M m') => cmp(m,m') end

    fun display (M l) = 
	let
	    val aa : int = ord #"a"
	    val AA : int = ord #"A"
	    fun dv (v : int) : string = 
		let val c : char = if v<26 then chr (v+aa) else chr (v-26+AA)
		in  char_implode[c]
		end
	    fun d (vv,acc) = 
		let val v = vv>>16 
		    val p = vv andb 65535
		in if p=1 then (dv v) ^ acc
		   else (dv v) ^ (makestring_int p) ^ acc
		end
	in foldl d "" l
	end

    val multiply = let
	  fun mul ([],m) = m
	    | mul (m,[]) = m
	    | mul (u::us, v::vs) = let
	        val uu = u andb ~65536
		in if uu = (v andb ~65536) then let
		      val w = u + (v andb 65535)
		      in if uu = (w andb ~65536) then w::mul(us,vs)
			 else Util.illegal 
			     (("Mono.multiply overflow: ") ^ 
			      (display (M(u::us))) ^ ", " ^ (display (M(v::vs))))
		      end
	           else if u>v then u :: mul(us,v::vs)
		   else (* u<v *) v :: mul(u::us,vs)
		end
          in fn (M m,M m') => M (mul (m,m')) end

    val lcm = let
	  fun lcm ([],m) = m
	    | lcm (m,[]) = m
	    | lcm (u::us, v::vs) =
	        if u>=v then if (u andb ~65536)<v then u::lcm(us,vs)
			     			    else u::lcm(us,v::vs)
			else if (v andb ~65536)<u then v::lcm(us,vs)
			     			    else v::lcm(u::us,vs)
          in fn (M m,M m') => M (lcm (m,m')) end
    val tryDivide = let
	  fun rev([],l) = l | rev(x::xs,l)=rev(xs,x::l)
	  fun d (m,[],q) = SOME(M(rev(q,m)))
	    | d ([],_::_,_) = NONE
	    | d (u::us,v::vs,q) =
	        if u<v then NONE
		else if (u andb ~65536) = (v andb ~65536) then
		    if u=v then d(us,vs,q) else d(us,vs,u-(v andb 65535)::q)
	        else d(us,v::vs,u::q)
          in fn (M m,M m') => d (m,m',[]) end
    fun divide (m,m') =
	  case tryDivide(m,m') of SOME q => q | NONE => raise DoesntDivide

end end (* local, structure M *)



structure MI = struct (* MONO_IDEAL *)

    (* trie:
     * index first by increasing order of vars
     * children listed in increasing degree order
     *)
    datatype 'a mono_trie = MT of 'a option * (int * 'a mono_trie) list
	                    (* tag, encoded (var,pwr) and children *)
    datatype 'a mono_ideal = MI of (int * 'a mono_trie) ref
	                    (* int maxDegree = least degree > all elements *)
    
    fun rev ([],l) = l | rev (x::xs,l) = rev(xs,x::l)
    fun tl (_::l) = l | tl [] = raise (Util.Impossible "MONO_IDEAL.tl")
    fun hd (x::_) = x | hd [] = raise (Util.Impossible "MONO_IDEAL.hd")

    val emptyTrie = MT(NONE,[])
    fun mkEmpty () = MI(ref (0,emptyTrie))

    fun maxDeg (MI(x)) = #1(!x)


    fun encode (var,pwr) = lshift(var,16)+pwr
    fun decode vp = (rshift(vp,16),andb(vp,65535))
    fun grabVar vp = andb(vp,~65536)
    fun grabPwr vp = andb(vp,65535)
    fun smallerVar (vp,vp') = vp < andb(vp',~65536)

    exception Found
    fun search (MI(x),M.M m') = let 
	  val (d,mt) = !x
	  val result = ref NONE
	  (* exception Found of M.mono * '_a *)
	  (* s works on remaining input mono, current output mono, tag, trie *)
	  fun s (_,m,MT(SOME a,_)) =
	        raise(result := SOME (M.M m,a); Found)
	    | s (m',m,MT(NONE,trie)) = s'(m',m,trie)
	  and s'([],_,_) = NONE
	    | s'(_,_,[]) = NONE
	    | s'(vp'::m',m,trie as (vp,child)::children) =
		if smallerVar(vp',vp) then s'(m',m,trie)
		else if grabPwr vp = 0 then (s(vp'::m',m,child);
					     s'(vp'::m',m,children))
		else if smallerVar(vp,vp') then NONE 
		else if vp<=vp' then (s(m',vp::m,child);
				      s'(vp'::m',m,children))
		else NONE
          in s(rev(m',[]),[],mt)
             handle Found (* (m,a) => SOME(m,a) *) => !result 
          end



   (* assume m is a new generator, i.e. not a multiple of an existing one *)
    fun insert (MI (mi),m,a) = let
	  val (d,mt) = !mi
	  fun i ([],MT (SOME _,_)) = Util.illegal "MONO_IDEAL.insert duplicate"
	    | i ([],MT (NONE,children)) = MT(SOME a,children)
	    | i (vp::m,MT(a',[])) = MT(a',[(vp,i(m,emptyTrie))])
	    | i (vp::m,mt as MT(a',trie as (vp',_)::_)) = let
		fun j [] = [(vp,i(m,emptyTrie))]
		  | j ((vp',child)::children) =
		      if vp<vp' then (vp,i(m,emptyTrie))::(vp',child)::children
		      else if vp=vp' then (vp',i(m,child))::children
		      else (vp',child) :: j children
		in 
		   if smallerVar(vp,vp') then
		       MT(a',[(grabVar vp,MT(NONE,trie)),(vp,i(m,emptyTrie))])
		   else if smallerVar(vp',vp) then i(grabVar vp'::vp::m,mt)
		   else MT(a',j trie)
	        end
	  in mi := (max(d,M.deg m),i (rev(map encode(M.explode m),[]),mt)) end

    fun mkIdeal [] = mkEmpty() 
      | mkIdeal (orig_ms : (M.mono * '_a) list)= let
	  fun ins ((m,a),arr) = Util.insert((m,a),M.deg m,arr)
	  val msa = arrayoflist orig_ms
	  val ms : (M.mono * '_a) list = 
	      Util.stripSort (fn ((m,_),(m',_)) => M.compare (m,m')) msa
	  val buckets = revfold ins ms (array(0,[]))
	  val n = Array.length buckets
	  val mi = mkEmpty()
          fun sort i = if i>=n then mi else let
	        fun redundant (m,_) = case search(mi,m) of NONE => false
						         | SOME _ => true
		fun filter ([],l) = app (fn (m,a) => insert(mi,m,a)) l
		  | filter (x::xx,l) = if redundant x then filter(xx,l)
				       else filter(xx,x::l)
		in filter(sub(buckets,i),[]);
		   update(buckets,i,[]);
		   sort(i+1)
		end
          in sort 0 end

    fun fold g (MI(x)) init = let
	  val (_,mt) = !x
	  fun f(acc,m,MT(NONE,children)) = f'(acc,m,children)
	    | f(acc,m,MT(SOME a,children)) =
	        f'(g((M.M m,a),acc),m,children)
	  and f'(acc,m,[]) = acc
	    | f'(acc,m,(vp,child)::children) =
	        if grabPwr vp=0 then f'(f(acc,m,child),m,children)
		else f'(f(acc,vp::m,child),m,children)
	  in f(init,[],mt) end

    fun searchDeg (mi,d) =
	  if d>maxDeg mi then []
	  else fold (fn ((m,a),l) => if M.deg m=d then (m,a)::l else l) mi []

end (* structure MI *)



val maxLeft = ref 0
val maxRight = ref 0
val counts = tabulate(20,fn _ => array(20,0))
val indices = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
fun resetCounts() = app(fn i => app (fn j => update(sub(counts,i),j,0)) indices) indices
fun pair(l,r) = let
      val log = let fun log(n,l) = if n<=1 then l else log((n >> 1),1+l)
          in fn n => log(n,0) end
      val l = log l and r = log r
      val _ = maxLeft := max(!maxLeft,l) and _ = maxRight := max(!maxRight,r)
      val a = sub(counts,l)
      in update(a,r,sub(a,r)+1) end
fun getCounts () = 
  map (fn i => map (fn j => sub(sub(counts,i),j)) indices) indices


structure P = struct

    datatype poly = P of (F.field*M.mono) list (* descending mono order *)
(*	
    fun show (P x) = (print "[ "; 
		      app (fn (f, m) =>
			   (print "("; F.show f; print ","; M.show m; print ") ")) x;
		      print " ]")
*)
    val zero = P []
    val one = P [(F.one,M.one)]
    fun coerceInt n = P [(F.coerceInt n,M.one)]
    fun coerceField a = P [(a,M.one)]
    fun coerceMono m = P [(F.one,m)]
    fun coerce (a,m) = P [(a,m)]
    fun implode p = P p
    fun cons (am,P p) = P (am::p)

local
    fun neg p = (map (fn (a,m) => (F.negate a,m)) p)
    fun plus ([],p2) = p2
      | plus (p1,[]) = p1
      | plus ((a,m)::ms,(b,n)::ns) = case M.compare(m,n) of
	    Util.Less => (b,n) :: plus ((a,m)::ms,ns)
	  | Util.Greater => (a,m) :: plus (ms,(b,n)::ns)
	  | Util.Equal => let val c = F.add(a,b)
       		             in if F.isZero c then plus(ms,ns)
		                else (c,m)::plus(ms,ns)
		             end
    fun minus ([],p2) = neg p2
      | minus (p1,[]) = p1
      | minus ((a,m)::ms,(b,n)::ns) = case M.compare(m,n) of
	    Util.Less => (F.negate b,n) :: minus ((a,m)::ms,ns)
	  | Util.Greater => (a,m) :: minus (ms,(b,n)::ns)
	  | Util.Equal => let val c = F.subtract(a,b)
       		             in if F.isZero c then minus(ms,ns)
			        else (c,m)::minus(ms,ns)
		             end
    fun termMult (a,m,p) =
	  (map (fn (a',m') => (F.multiply(a,a'),M.multiply(m,m'))) p)
in
    fun negate (P p) = P (neg p)
    fun add (P p1,P p2) = (pair(length p1,length p2); P (plus(p1,p2)))
    fun subtract (P p1,P p2) = (pair(length p1,length p2); P (minus(p1,p2)))
    val multiply = let
	  fun times (p1,p2) = 
	        revfold (fn ((a,m),tot) => plus (termMult(a,m,p2),tot)) p1 []
          in fn (P p1,P p2) => if length p1 > length p2 then P(times (p2,p1))
			       else P(times (p1,p2))
          end
    fun singleReduce (P y,a,m,P x) = (pair(length y,length x); P(minus(y,termMult(a,m,x))))
    fun spair (a,m,P f,b,n,P g) = (pair(length f,length g); P(minus(termMult(a,m,f),termMult(b,n,g))))
    val termMult = fn (a,m,P f) => P(termMult(a,m,f))
end

    fun scalarMult (a,P p) = P (map (fn (b,m) => (F.multiply(a,b),m)) p)
    fun power(p,k) =
	  if k<=3 then case k of
	      0 => one
	    | 1 => p
	    | 2 => multiply(p,p)
	    | 3 => multiply(p,multiply(p,p))
	    | _ => Util.illegal "POLY.power with k<0"
	  else if andb(k,1)=0 then power(multiply(p,p),rshift(k,1))
	       else multiply(p,power(multiply(p,p),rshift(k,1)))

    fun isZero (P []) = true | isZero (P (_::_)) = false
    val equal = let
	  fun eq ([],[]) = true
	    | eq (_::_,[]) = false
	    | eq ([],_::_) = false
	    | eq ((a,m)::p,(b,n)::q) =
	        F.equal(a,b) andalso M.compare(m,n)=Util.Equal
		andalso eq (p,q)
          in fn (P p,P q) => eq (p,q) end

    (* these should only be called if there is a leading term, i.e. poly<>0 *)
    fun leadTerm (P(am::_)) = am
      | leadTerm (P []) = Util.illegal "POLY.leadTerm"
    fun leadMono (P((_,m)::_)) = m
      | leadMono (P []) = Util.illegal "POLY.leadMono"
    fun leadCoeff (P((a,_)::_)) = a
      | leadCoeff (P []) = Util.illegal "POLY.leadCoeff"
    fun rest (P (_::p)) = P p
      | rest (P []) = Util.illegal "POLY.rest"
    fun leadAndRest (P (lead::rest)) = (lead,P rest)
      | leadAndRest (P []) = Util.illegal "POLY.leadAndRest"

    fun deg (P []) = Util.illegal "POLY.deg on zero poly"
      | deg (P ((_,m)::_)) = M.deg m (* homogeneous poly *)
    fun numTerms (P p) = length p

    fun display (P []) = F.display F.zero
      | display (P p) = let
	  fun dsp (a,m) = let
	        val s = 
		      if M.deg m = 0 then F.display a
 		      else if F.equal(F.one,F.negate a) then "-" ^ M.display m
		      else if F.equal(F.one,a) then M.display m
		      else F.display a ^ M.display m
	        in if substring(s,0,1)="-" then s else "+" ^ s end
	  in string_implode(map dsp p) end
end

structure HP = struct
	datatype hpoly = HP of P.poly array
	val log = let
	      fun log(n,l) = if n<8 then l else log((n >> 2),1+l)
	      in fn n => log(n,0) end
	fun mkHPoly p = let
	      val l = log(P.numTerms p)
	      in HP(tabulate(l+1,fn i => if i=l then p else P.zero)) end
	fun add(p,HP ps) = let
	      val l = log(P.numTerms p)
	      in if l>=Array.length ps then let
		   val n = Array.length ps
		   in HP(tabulate(n+n,
			 fn i => if i<n then sub(ps,i)
			         else if i=l then p else P.zero))
		   end
		 else let
		   val p = P.add(p,sub(ps,l))
		   in if l=log(P.numTerms p) then (update(ps,l,p); HP ps)
		      else (update(ps,l,P.zero); add (p,HP ps))
		   end
	      end
	fun leadAndRest (HP ps) = let
	      val n = Array.length ps
	      fun lar (m,indices,i) = if i>=n then lar'(m,indices) else let
		    val p = sub(ps,i)
		    in if P.isZero p then lar(m,indices,i+1)
		       else if null indices then lar(P.leadMono p,[i],i+1)
			    else case M.compare(m,P.leadMono p) of
				Util.Less => lar(P.leadMono p,[i],i+1)
			      | Util.Equal => lar(m,i::indices,i+1)
			      | Util.Greater => lar(m,indices,i+1)
		    end
	      and lar' (_,[]) = NONE
		| lar' (m,i::is) = let
		    fun extract i = case P.leadAndRest(sub(ps,i)) of
			  ((a,_),rest) => (update(ps,i,rest); a)
		    val a = revfold (fn (j,b) => F.add(extract j,b))
				    is (extract i)
		    in if F.isZero a then lar(M.one,[],0) else SOME(a,m,HP ps)
		    end
	      in lar(M.one,[],0) end
end


structure G = struct
    val autoReduce = ref true
    val maxDeg = ref 10000
    val maybePairs = ref 0
    val primePairs = ref 0
    val usedPairs = ref 0
    val newGens = ref 0

    fun reset () = (maybePairs:=0; primePairs:=0; usedPairs:=0; newGens:=0)

    fun inc r = r := !r + 1

    fun reduce (f,mi) = if P.isZero f then f else let
          (* use accumulator and reverse at end? *)
	  fun r hp = case HP.leadAndRest hp of
	        NONE => []
	      | (SOME(a,m,hp)) => case MI.search(mi,m) of
		    NONE => (a,m)::(r hp)
		  | SOME (m',p) => r (HP.add(P.termMult(F.negate a,M.divide(m,m'),!p),hp))
	  in P.implode(r (HP.mkHPoly f)) end

    (* assume f<>0 *)
    fun mkMonic f = P.scalarMult(F.reciprocal(P.leadCoeff f),f)

    (* given monic h, a monomial ideal mi of m's tagged with g's representing
     * an ideal (g1,...,gn): a poly g is represented as (lead mono m,rest of g).
     * update pairs to include new s-pairs induced by h on g's:
     * 1) compute minimal gi1...gik so that <gij:h's> generate <gi:h's>, i.e.
     *    compute monomial ideal for gi:h's tagged with gi
     * 2) toss out gij's whose lead mono is rel. prime to h's lead mono (why?)
     * 3) put (h,gij) pairs into degree buckets: for h,gij with lead mono's m,m'
     *    deg(h,gij) = deg lcm(m,m') = deg (lcm/m) + deg m = deg (m':m) + deg m
     * 4) store list of pairs (h,g1),...,(h,gn) as vector (h,g1,...,gn)
     *)
    fun addPairs (h,mi,pairs) = 
	let
	    val m = P.leadMono h
	    val d = M.deg m
	    fun tag ((m' : M.mono,g' : P.poly ref),quots) = (inc maybePairs;
							     (M.divide(M.lcm(m,m'),m),(m',!g'))::quots)
	    fun insert ((mm,(m',g')),arr) = (* recall mm = m':m *)
	        if M.compare(m',mm)=Util.Equal then (* rel. prime *)
		    (inc primePairs; arr)
		else (inc usedPairs;
		      Util.insert(P.cons((F.one,m'),g'),M.deg mm+d,arr))
	    val buckets = MI.fold insert (MI.mkIdeal (MI.fold tag mi []))
		(array(0,[]))
	    fun ins (~1,pairs) = pairs
	      | ins (i,pairs) = case sub(buckets,i) of
		[] => ins(i-1,pairs)
	      | gs => ins(i-1,Util.insert(arrayoflist(h::gs),i,pairs))
	in ins(Array.length buckets - 1,pairs) 
	end

    fun grobner fs = let
	 fun pr l = print (string_implode (l@["\n"]))
	  val fs = revfold (fn (f,fs) => Util.insert(f,P.deg f,fs))
	      		   fs (array(0,[]))
	  (* pairs at least as long as fs, so done when done w/ all pairs *)
	  val pairs = ref(array(Array.length fs,[]))
	  val mi = MI.mkEmpty()
	  val newDegGens = ref []
          val addGen = (* add and maybe auto-reduce new monic generator h *)
	        if not(!autoReduce) then
		    fn h => MI.insert (mi,P.leadMono h,ref (P.rest h))
		else fn h => let
		    val ((_,m),rh) = P.leadAndRest h
		    fun autoReduce f =
			  if P.isZero f then f
			  else let val ((a,m'),rf) = P.leadAndRest f
			       in case M.compare(m,m') of
				   Util.Less => P.cons((a,m'),autoReduce rf)
				 | Util.Equal => P.subtract(rf,P.scalarMult(a,rh))
				 | Util.Greater => f
			       end
		    val rrh = ref rh
		    in
			MI.insert (mi,P.leadMono h,rrh);
			app (fn f => f:=autoReduce(!f)) (!newDegGens);
			newDegGens := rrh :: !newDegGens
		    end
	  val tasksleft = ref 0
	  fun feedback () = let
	        val n = !tasksleft
	        in 
		    if andb(n,15)=0 then print (makestring_int n) else (); 
			print "."; 
			TextIO.flushOut TextIO.stdOut;
			tasksleft := n-1
		end
	  fun try h = 
	      let
		  val _ = feedback ()
		  val h = reduce(h,mi)
	      in if P.isZero h 
		     then ()
		 else let val h = mkMonic h
			  val _ = (print "#"; TextIO.flushOut TextIO.stdOut)
		      in pairs := addPairs(h,mi,!pairs);
			  addGen h;
			  inc newGens
		      end
	      end
	  fun tryPairs fgs = 
	      let
		  val ((a,m),f) = P.leadAndRest (sub(fgs,0))
		  fun tryPair 0 = ()
		    | tryPair i =
		      let val ((b,n),g) = P.leadAndRest (sub(fgs,i))
			  val k = M.lcm(m,n)
		      in  try (P.spair(b,M.divide(k,m),f,a,M.divide(k,n),g));
			  tryPair (i-1)
		      end
	      in tryPair (Array.length fgs -1) 
	      end
	  fun numPairs ([],n) = n
	    | numPairs (p::ps,n) = numPairs(ps,n-1+Array.length p)
	  fun gb d = 
	      if d>=Array.length(!pairs) 
		  then mi 
	      else (* note: i nullify entries to reclaim space *)
	        (pr ["DEGREE ",makestring_int d," with ",
		     makestring_int(numPairs(sub(!pairs,d),0))," pairs ",
		     if d>=Array.length fs then "0" else makestring_int(length(sub(fs,d))),
			 " generators to do"];
		 tasksleft := numPairs(sub(!pairs,d),0);
		 if d>=Array.length fs 
		     then () 
		 else tasksleft := !tasksleft + length (sub(fs,d));
		 if d>(!maxDeg) 
		     then ()
		 else (reset();
		       newDegGens := [];
		       app tryPairs (sub(!pairs,d));
		       update(!pairs,d,[]);
		       if d>=Array.length fs then ()
		       else (app try (sub(fs,d)); update(fs,d,[]));
		       pr ["maybe ",makestring_int(!maybePairs)," prime ",makestring_int (!primePairs),
			   " using ",makestring_int (!usedPairs),"; found ",makestring_int (!newGens)]);
		 gb(d+1))
	in gb 0 
        end


local
    (* grammar:
     dig  ::= 0 | ... | 9
     var  ::= a | ... | z | A | ... | Z
     sign ::= + | -
     nat  ::= dig | nat dig
     mono ::=  | var mono | var num mono
     term ::= nat mono | mono
     poly ::= term | sign term | poly sign term
    *)
    datatype char = Dig of int | Var of int | Sign of int
    fun char ch =
	let val och = ord ch in
	  if ord #"0"<=och andalso och<=ord #"9" then Dig (och - ord #"0")
	  else if ord #"a"<=och andalso och<=ord #"z" then Var (och - ord #"a")
	  else if ord #"A"<=och andalso och<=ord #"Z" then Var (och - ord #"A" + 26)
	  else if och = ord #"+" then Sign 1
	  else if och = ord #"-" then Sign ~1
	       else Util.illegal ("bad ch in poly: " ^ (implode[ch]))
        end

    fun nat (n,Dig d::l) = nat(n*10+d,l) | nat (n,l) = (n,l)
    fun mono (m,Var v::Dig d::l) =
	  let val (n,l) = nat(d,l)
	  in mono(M.multiply(M.implode[(v,n)],m),l) end
      | mono (m,Var v::l) = mono(M.multiply(M.x_i v,m),l)
      | mono (m,l) = (m,l)

    fun term l = let
	  val (n,l) = case l of (Dig d::l) => nat(d,l) | _ => (1,l)
	  val (m,l) = mono(M.one,l)
    	  in ((F.coerceInt n,m),l) end
    fun poly (p,[]) = p
      | poly (p,l) = let
	  val (s,l) = case l of Sign s::l => (F.coerceInt s,l) | _ => (F.one,l)
	  val ((a,m),l) = term l
	  in poly(P.add(P.coerce(F.multiply(s,a),m),p),l) end

in
    fun parsePoly s = poly (P.zero,map char(char_explode s))

    fun readIdeal stream = let
	  fun readLine () = let
	        val s = TextIO.inputLine stream
		val n = size s
		val n = if n>0 andalso substring(s,n-1,1)="\n" then n-1 else n
		fun r i = if i>=n then []
			  else case substring(s,i,1) of
			      ";" => r(i+1)
			    | " " => r(i+1)
			    | _ => map char (char_explode(substring(s,i,n-i)))
		in r 0 end
	  fun r () = if TextIO.endOfStream stream then []
		     else poly(P.zero,readLine()) :: r()
	  fun num() = if TextIO.endOfStream stream then Util.illegal "missing #"
		      else case nat(0,readLine()) of
			  (_,_::_) => Util.illegal "junk after #"
			| (n,_) => n
	  val _ = 1=num() orelse Util.illegal "stream doesn't start w/ `1'"
	  val n = num()
	  val i = r()
	  val _ = length i = n orelse Util.illegal "wrong # poly's"
	  in i end

fun read filename = let
      val stream = TextIO.openIn filename
      val i = readIdeal stream
      val _ = TextIO.closeIn stream
      in i end
end (* local *) 

end (* structure G *)



val _ = G.maxDeg:=1000000

fun grab mi = MI.fold (fn ((m,g),l) => P.cons((F.one,m),!g)::l) mi []
fun r mi s = let
      val p = G.parsePoly s
      in print (P.display p); print "\n";
	 print (P.display(G.reduce(p,mi))); print "\n"
      end
fun p6 i= let val s= makestring_int (i:int)
	      val n= size s
          in print(substring("      ",0,6-n)); print s end
fun hex n = let
      fun h n = if n=0 then ""
		else h(n smlnj_div 16) ^ substring("0123456789ABCDEF",n smlnj_mod 16,1)
      in if n=0 then "0" else h n end
fun printCounts () = map (fn l => (map p6 l; print "\n")) (getCounts())
fun totalCount () = revfold (fn (l,c) => revfold op + l c) (getCounts()) 0
fun maxCount () = revfold (fn (l,m) => revfold max l m) (getCounts()) 0

fun terms (p,tt) = if P.isZero p then tt else terms(P.rest p,P.leadMono p::tt)
fun tails ([],tt) = tt
  | tails (t as _::t',tt) = tails (t',t::tt)

local
    val a = 16807.0  and  m = 2147483647.0
in
    val seed = ref 1.0
    fun random n = let val t = a*(!seed)
                   in seed := t - m * real(floor(t/m));
                      floor(real n * !seed/m)
                   end
end

fun sort [] = []
  | sort a = 
let
    val a = arrayoflist a
    val b = tabulate(Array.length a,fn i => i)
    val sub = sub and update = update
    infix sub
    fun swap (i,j) = let val ai = a sub i in update(a,i,a sub j); update(a,j,ai) end
    (* sort all k, 0<=i<=k<j<=length a *)
    fun s (i,j,acc) = if i=j then acc else let
        val pivot = a sub (b sub (i+random(j-i)))
	fun partition (dup,lo,k,hi) = if k=hi then (dup,lo,hi) else
	    (case M.compare (pivot, a sub (b sub k)) of
		 Util.Less => (swap (lo,k); partition (dup,lo+1,k+1,hi))
	       | Util.Equal => partition (dup+1,lo,k+1,hi)
	       | Util.Greater => (swap (k,hi-1); partition (dup,lo,k,hi-1)))
	val (dup,lo,hi) = partition (0,i,i,j)
	in s(i,lo,(dup,pivot)::s(hi,j,acc)) end
    in s(0,Array.length a,[]) end
;

fun sum f l = revfold op + (map f l) 0

fun analyze gb = let
      val aa = revfold terms gb []
      val bb = map M.explode aa
      val aa = sort aa
      fun len m = length (M.explode m)
      fun prt (s:string) (i:int) = (print s; print(makestring_int i); print "\n"; i)
      val m=  sum #1 aa
      val u=  length aa
      val cm =sum (fn (d,l) => d*len l) aa
      val cu =sum (len o #2) aa
      val for=length(sort(map M.implode (revfold tails bb [])))
      val bak=length(sort(map (M.implode o rev) (revfold tails (map rev bb) [])))
    in
     {m=prt "m  = " m, u=prt "u  = " u, cm =prt "cm = " cm, cu =prt "cu = " cu, for=prt "for= " for, bak=prt "bak= " bak}
    end

fun gb fs = let
      val g = G.grobner fs handle (Util.Illegal s) => (print s; raise Div)
      val fs = grab g
      fun info f = app print
	  [M.display(P.leadMono f),
	   " + ", makestring_int(P.numTerms f - 1), " terms\n"]
      in app info fs end
;

fun report (e as Tabulate) = (print "exn: Tabulate\n"; raise e)
  | report (e as ArrayofList) = (print "exn: ArrayofList\n"; raise e)
  | report (e as (Util.NotImplemented s)) = (print ("exn: NotImplemented " ^ s ^ "\n"); raise e)
  | report (e as (Util.Impossible s)) = (print ("exn: Impossible " ^ s ^ "\n"); raise e)
  | report (e as (Util.Illegal s)) = (print ("exn: Illegal " ^ s ^ "\n"); raise e)
  | report (e as (M.DoesntDivide)) = (print ("exn: DoesntDivide\n"); raise e)
  | report (e as (MI.Found)) = (print ("exn: Found\n"); raise e)


val fs = map G.parsePoly ["-El-Dh-Cd+Bo+xn+tm","-Fo+Ep-Ek-Dg-Cc+Ao+wn+sm","-Fn-Ej+Dp-Df-Cb+zo+vn+rm",
"-Fm-Ei-De+Cp-Ca+yo+un+qm","Fl-Bp+Bk-Al-zh-yd+xj+ti","El-Bo-zg-yc+wj+si",
"Dl-Bn-Aj+zk-zf-yb+vj+ri","Cl-Bm-Ai-ze+yk-ya+uj+qi","Fh+Bg-xp+xf-wl-vh-ud+te",
"Eh+Ag-xo-wk+wf-vg-uc+se","Dh+zg-xn-wj-ub+re","Ch+yg-xm-wi-ve+uf-ua+qe",
"Fd+Bc+xb-tp+ta-sl-rh-qd","Ed+Ac+wb-to-sk+sa-rg-qc","Dd+zc+vb-tn-sj-rf+ra-qb",
"Cd+yc+ub-tm-si-re"]

val u7 = map G.parsePoly
["abcdefg-h7","a+b+c+d+e+f+g","ab+bc+cd+de+ef+fg+ga","abc+bcd+cde+def+efg+fga+gab","abcd+bcde+cdef+defg+efga+fgab+gabc","abcde+bcdef+cdefg+defga+efgab+fgabc+gabcd","abcdef+bcdefg+cdefga+defgab+efgabc+fgabcd+gabcde"]

val u6 = map G.parsePoly
["abcdef-g6","a+b+c+d+e+f","ab+bc+cd+de+ef+fa","abc+bcd+cde+def+efa+fab","abcd+bcde+cdef+defa+efab+fabc","abcde+bcdef+cdefa+defab+efabc+fabcd"]

val u5 = map G.parsePoly ["abcde-f5","a+b+c+d+e","ab+bc+cd+de+ea","abc+bcd+cde+dea+eab","abcd+bcde+cdea+deab+eabc"]

val u4 = map G.parsePoly ["abcd-e4","a+b+c+d","ab+bc+cd+da","abc+bcd+cda+dab"]


fun runit s = 
    let	val data = if (s = "fs") then fs else if (s = "u7") then u7 else if (s = "u6") then u6 else 
	    if (s = "u5") then u5 else if (s = "u4") then u4 else 
		(print "no such data\n"; raise (Util.Impossible "no such data"))
    in
	gb data handle e => report e
    end

fun readTyanInput() = 
    let val _ = (print "Enter fs, u7, u6, u5, or u4: "; TextIO.flushOut TextIO.stdOut);
	val s = TextIO.inputN(TextIO.stdIn,2)
    in s
    end
in
    fun run () = runit "u6"  (* readTyanInput() *)
end
end

structure Tyan :> RUN = makeRunTyan()


(*tyan*)
(* btimes *)
(*
 Harness to run and time the benchmarks, individually or as a group.
 Usage:  btimes [-r n] [ benchmarks ]
   -r n, if present, indicates that n runs should be done, and the results
         averaged before reporting.  Defaults to 1.
   benchmarks is an optional list of which benchmarks to run.  Defaults
         to all of them.
   *)
structure Benchmarks :> RUN = 
  struct
    
    val benchmarks = 
      [
       (Life.run,"Life"),
       (Leroy.run,"Leroy"),
(*       (Fft.run,"Fft"),
       (Boyer.run,"Boyer"),*)
       (Simple.run,"Simple"),
       (Tyan.run,"Tyan"),(*
       (Tyan1.run,"Tyan1"),*)
(*	(Tyan2.run,"Tyan2"),
	(Tyan3.run,"Tyan3"),*)
	(Msort.run,"Msort"),
(*       (Pia.run,"Pia"),*)
       (* Data files don't exist.
	* (Pia1.run,"Pia1"),
	*   (Pia2.run,"Pia2"),
	*  (Pia3.run,"Pia3"),
	*) 
(*       (Lexgen.run,"Lexgen"),*)
       (*  Data files don't exist
	*  (Lexgen1.run,"Lexgen1"),
	*  (Lexgen2.run,"Lexgen2"),
	*  (Lexgen3.run,"Lexgen3"),
	*)
(*       (Frank.run,"Frank"),*)
       (Arithmetic.run,"Arithmetic"),
       (Arithmetic32.run,"Arithmetic32"),
       (F_Arithmetic.run,"F_Arithmetic"),
(*       (BarnesHut.run,"BarnesHut"),*)
       (PQueens.run,"PQueens"),
(*       (Quicksort.run,"Quicksort"),
       (Quicksort2.run,"Quicksort2"),*)
       (Takc.run,"Takc"),
       (Taku.run,"Taku") 
       ]
      

    fun eprint (s : string) : unit = print s
(*      TextIO.output(TextIO.stdErr, s)*)

    fun FAIL msg = raise Fail msg
      
    fun findall [] _ = []
      | findall (a::aa) l = 
      let
	fun isb b (_,b') = b = b'

	val bench = 
	  (case List.find (isb a) l
	     of SOME bench => bench
	      | NONE => (print "Benchmarks are \n";
			 List.app (fn (_,name) => print ("\t"^name^"\n")) l;
			 FAIL (a^" is not a known benchmark\n")))
      in bench :: findall aa l
      end
    
    fun main () : unit =
      (let
       in TimeAndRun.report (3,benchmarks)
       end)
	 handle e => ((print "exception raised";
		       raise e))

	   
    val run = main
  end


val _ = Benchmarks.run()

