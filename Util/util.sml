(*$import UtilError Platform TopLevel UTIL OS TextIO *)

structure Util :> UTIL = 
  struct
    exception UNIMP

    val error = fn s => UtilError.error "util.sml" s

    fun loop a b = if (a>b) then [] else a::(loop (a+1) b)
    fun count n = loop 0 (n-1)

    local 
	val precomputeMax = 10
	fun rawSpaces 0 = ""
	  | rawSpaces 1 = " "
	  | rawSpaces n = 
	    let val _ = if (n < 2) then error "rawSpaces given negative number" else ()
		val a = n div 2
		val b = n - a
		val aSpace = rawSpaces a
		val bSpace = if (a = b) then aSpace 
			     else (aSpace ^ " ")
	    in  aSpace ^ bSpace
	    end
	val precompute = Array.tabulate(precomputeMax, rawSpaces)
    in  fun spaces n = 
	if (n < 0)
	    then ""
	else if (n < precomputeMax)
		 then Array.sub(precompute,n)
	     else rawSpaces n
    end

    fun printl s = print (s^"\n")
    fun lprint s = print ("\n"^s)
    fun lprintl s = print ("\n"^s^"\n")

    fun printem strings = app print strings

    fun mapopt f NONE = NONE
      | mapopt f (SOME x) = SOME(f x)
    fun eq_opt (f, NONE, NONE) = true
      | eq_opt (f, SOME a, SOME b) = f(a,b)
      | eq_opt _ = false
    fun split_opt (NONE) = (NONE,NONE)
      | split_opt (SOME (a,b)) = (SOME a,SOME b)

    fun CharStr2char s = String.sub(s,0)


    datatype '1a oneshot = ONESHOT of int * '1a option ref
    val oneshot_count = ref 0
    fun inc r = (r := (!r) + 1; !r)
    fun oneshot() = ONESHOT(inc oneshot_count, ref NONE)
    fun oneshot_init item = ONESHOT(inc oneshot_count, ref (SOME item))
    fun oneshot_set(ONESHOT(_,ref (SOME _)),_) = error "oneshot_set called on something already set"
      | oneshot_set(ONESHOT(_,r as (ref NONE)),item) = r := (SOME item)
    fun oneshot_deref (ONESHOT (_,r)) = !r
    fun eq_oneshot (ONESHOT a,ONESHOT b) = a = b


    fun substring (pattern,target) =
	let val pattern = explode pattern
	    val target = explode target
	    fun match [] _ = true
	      | match (a::arest) (b::brest) = (a = b) andalso (match arest brest)
	      | match _ _ = false
	    fun loop n cur = if (match pattern cur)
				 then SOME n
			     else (case cur of
				       [] => NONE
				     | (_::rest) => loop (n+1) rest)
	in  loop 0 target
	end

    fun curry2 f = fn a => fn b => f (a,b)
    fun curry3 f = fn a => fn b => fn c => f (a,b,c)

    fun all_pairs p = 
      let
	fun loop [] = true
	  | loop [_]= true
	  | loop (fst::snd::rest) = 
	  (p (fst,snd)) andalso (loop (snd::rest))
      in
	loop
      end

   fun memoize thunk = 
       let val result = ref NONE
       in  fn() =>
	   (case !result of
		NONE => let val res = thunk()
			    val _ = result := SOME res
			in  res
			    end
	      | SOME res => res)
       end

   (* isUnix : unit -> bool *)
   fun isUnix () = Platform.platform() <> Platform.NT
       
   fun system command = 
       if not (isUnix())
	   then 
	       let val os = TextIO.openOut "worklist"
		   val _ = TextIO.output(os,command)
		   val _ = TextIO.closeOut os
		   fun count 0 = () | count n = count(n-1)
		   fun sleep 0 = () | sleep n = (count 1000000; sleep(n-1))
		   fun loop() = if OS.FileSys.access("worklist",[])
				    then (sleep 10; loop()) else ()
	       in  loop(); true
	       end
       else (OS.Process.system command <> OS.Process.failure)

    val raise_error = UtilError.raise_error
    val error = UtilError.error

  end
