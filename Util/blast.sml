structure Blaster :> BLASTER =
struct

    val error = fn s => Util.error "blast.sml" s
    val BlastDebug = Stats.ff "BlastDebug"
    exception BadMagicNumber

    structure B = BinIO
    structure W = TilWord64

    structure StringHashKey =
    struct
	type hash_key = string
	val hashVal = HashString.hashString
	val sameKey = (op= : string * string -> bool)
    end
    structure StringTable = HashTableFn (StringHashKey)
    exception STab

    type instream =
	{is : B.instream,
	 itab_count : int ref,
	 itab : string IntListMap.map ref}

    type outstream =
	{os : B.outstream,
	 stab_count : int ref,
	 stab : int StringTable.hash_table ref}

    type 'a blastin = instream -> 'a
    type 'a blastout = outstream -> 'a -> unit

    fun instream (is : B.instream) : instream =
	{is = is,
	 itab_count = ref 1,
	 itab = ref IntListMap.empty}

    fun openIn (path : string) : instream = instream (B.openIn path)

    fun outstream (os : B.outstream) : outstream =
	{os = os,
	 stab_count = ref 1,
	 stab = ref (StringTable.mkTable (100,STab))}

    fun openOut (path : string) : outstream =
	outstream (B.openOut path)

    fun openAppend (path : string) : outstream =
	outstream (B.openAppend path)

    fun resetIn ({itab_count, itab, ...} : instream) : unit =
	(itab_count := 1;
	 itab := IntListMap.empty)

    fun resetOut ({stab_count, stab, ...} : outstream) : unit =
	(stab_count := 1;
	 stab := StringTable.mkTable (100,STab))

    fun closeIn ({is, ...} : instream) : unit = B.closeIn is
    fun closeOut ({os, ...} : outstream) : unit = B.closeOut os

    fun checkMagic (magic : string) : unit =
	if size magic < 256 then ()
	else error ("magic number too large: " ^ magic)

    fun writeMagic ({os,...} : outstream, magic : string) : unit =
	(B.output1(os, Word8.fromInt (size magic));
	 B.output(os, Byte.stringToBytes magic))

    fun readMagic ({is,...} : instream, magic : string) : unit =
	let val len = (case B.input1 is
			 of SOME len => len
			  | NONE => raise BadMagicNumber)
	    val len = Word8.toInt len
	    val _ = if len = size magic then ()
		    else raise BadMagicNumber
	    val s = Byte.bytesToString (B.inputN (is, len))
	in  if s = magic then ()
	    else raise BadMagicNumber
	end

    fun magic (aout : 'a blastout, ain : 'a blastin,
	       magic : string) : ('a blastout * 'a blastin) =
	(checkMagic magic;
	 ((fn os => fn x => (writeMagic (os, magic); aout os x)),
	  (fn is => (readMagic (is, magic); ain is))))

    fun endOfStream ({is, ...} : instream) : bool = B.endOfStream is

    fun blastOutWord8 ({os, ...} : outstream) (w : Word8.word) : unit =
	B.output1 (os,w)

    fun blastInWord8 ({is, ...} : instream) : Word8.word =
	(case B.input1 is
	   of SOME c => c
	    | NONE => error "premature end of file in input1")

    fun blastOutWord64 (os : outstream) (w : W.word) : unit =
	let val a = Word8.fromInt(W.toInt (W.andb (w, W.fromInt 127)))
	    val w = W.rshiftl (w, 7)
	in
	    if W.equal (w,W.zero) then
		blastOutWord8 os a
	    else
		(blastOutWord8 os (Word8.orb(a,0w128));
		 blastOutWord64 os w)
	end
    fun blastInWord64 (is : instream) : W.word =
	let fun loop shift base =
		let val a = blastInWord8 is
		    val a' = Word8.andb(a, 0w127)
		    val a64 = W.fromInt (Word8.toInt a')
		    val base = W.orb(W.lshift(a64,shift),base)
		in
		    if (a=a') then
			base
		    else
                        loop (shift+7) base
                end
	in
	    loop 0 W.zero
	end

    fun blastOutWord32 (os : outstream) (w : Word32.word) : unit =
	blastOutWord64 os (W.fromUnsignedHalf w)
    fun blastInWord32 (is : instream) : Word32.word =
	W.toUnsignedHalf (blastInWord64 is)

    fun blastOutInt (os : outstream) (i : int) : unit =
	blastOutWord64 os (W.fromInt i)
    fun blastInInt (is : instream) : int =
	W.toInt (blastInWord64 is)

    fun blastOutBool (os : outstream) (b : bool) : unit =
	(case b
	   of true => blastOutWord8 os 0w1
	    | false => blastOutWord8 os 0w0)
    fun blastInBool (is : instream) : bool =
	(case blastInWord8 is
	   of 0w1 => true
	    | 0w0 => false
	    | _ => error "bad bool")

    fun blastOutString (os : outstream) (s : string) : unit =
	let val {os=os',stab,stab_count} = os
	in
	    (case StringTable.find (!stab) s
	       of NONE =>
		    (blastOutInt os 0;
		     blastOutInt os (size s);
		     B.output(os', Byte.stringToBytes s);
		     StringTable.insert (!stab) (s, !stab_count);
		     stab_count := !stab_count + 1)
		| SOME n =>
		     blastOutInt os n)
	end
    fun blastInString (is : instream) : string =
	let val {is=is',itab,itab_count} = is
	    val n = blastInInt is
	in
	    if n > 0 then
		(case IntListMap.find(!itab,n)
		   of SOME s => s
		    | NONE => error "bad string")
	    else
		let val sz = blastInInt is
		    val s = Byte.bytesToString (B.inputN (is',sz))
		    val _ = if size s = sz then ()
			    else error "short string"
		in
		    itab := IntListMap.insert(!itab, !itab_count, s);
		    itab_count := !itab_count + 1;
		    s
		end
	end

    fun blastOutPair (a : 'a blastout)
		     (b : 'b blastout) : ('a * 'b) blastout =
	(fn os => fn (x,y) => (a os x; b os y))
    fun blastInPair (a : 'a blastin) (b : 'b blastin) : ('a * 'b) blastin =
	(fn is => (a is, b is))

    fun blastOutTriple (a : 'a blastout) (b : 'b blastout)
		       (c : 'c blastout) : ('a * 'b * 'c) blastout =
	(fn os => fn (x,y,z) => (a os x; b os y; c os z))
    fun blastInTriple (a : 'a blastin) (b : 'b blastin)
		      (c : 'c blastin) : ('a * 'b * 'c) blastin =
	(fn is => (a is, b is, c is))

    fun blastOutOption (a : 'a blastout) : 'a option blastout =
	(fn os => fn aopt =>
	 (case aopt
	    of NONE => blastOutInt os 0
	     | SOME x => (blastOutInt os 1; a os x)))
    fun blastInOption (a : 'a blastin) : 'a option blastin =
	(fn is =>
	 (case blastInInt is
	    of 0 => NONE
	     | 1 => SOME (a is)
	     | _ => error "bad option"))

    fun blastOutList (a : 'a blastout) : 'a list blastout =
	(fn os => fn xs =>
	 (blastOutInt os (length xs);
	  app (a os) xs))
    fun blastInList (a : 'a blastin) : 'a list blastin =
	(fn is =>
	 let val len = blastInInt is
	     fun loop 0 = nil
	       | loop n = (a is) :: (loop (n-1))
	 in  loop len
	 end)
end
