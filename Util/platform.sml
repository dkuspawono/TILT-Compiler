(*$import PLATFORM Util String OS *)

structure Platform :> PLATFORM = 

struct

    val error = fn s => Util.error "platform.sml" s
    datatype platform = NT | DUNIX | SOLARIS | LINUX
	
    val platform = 
	let val sysOpt = (case OS.Process.getEnv "SYS" of
			  NONE => OS.Process.getEnv "OS"
			| some => some)
	in  (case sysOpt of
		 NONE => error "SYS and OS envoronment variable both unset"
	       | SOME sys => 
		   if (sys = "Windows_NT") then NT
		   else if (String.substring(sys,0,3) = "sun")
			  then SOLARIS
		   else if (String.substring(sys,0,5) = "alpha")
			  then DUNIX
		   else if (String.substring(sys,0,10) = "i386_linux")
			  then LINUX
		   else error ("Unrecognized system/OS type: " ^ sys))
	end

    fun spinMilli start 0 = ()
      | spinMilli start n = 
	let fun spin 0 = ()
	      | spin n = spin (n-1)
	in spin start; spinMilli start (n-1)
	end
    val spinMilliNT = spinMilli 50000      (* timed for baked *)
    val spinMilliDUNIX = spinMilli 35000   (* timed for tcl *)

    (*  Posix.Process.sleep does not work for times under 1.0 seconds
          since it seems to round down to the nearest second.
	OS.IO.poll (as a way to sleep) works on the Sun but not the Alpha.
    *)
    fun sleep duration = 
	(case platform of
	     DUNIX   => spinMilliDUNIX (1 + Real.floor(duration * 1000.0))
	   | SOLARIS => (OS.IO.poll([], SOME (Time.fromReal duration)); ())
	   | LINUX   => (OS.IO.poll([], SOME (Time.fromReal duration)); ())
	   | NT      => spinMilliNT (1 + Real.floor(duration * 1000.0)))

    fun pid() = 
	(case platform of
	     DUNIX   => Posix.Process.pidToWord(Posix.ProcEnv.getpid())
	   | SOLARIS => Posix.Process.pidToWord(Posix.ProcEnv.getpid())
	   | LINUX   => Posix.Process.pidToWord(Posix.ProcEnv.getpid())
	   | NT      => let val time = Time.toReal(Time.now())
			    val floor = Real.realFloor time
			    val pid = Word32.fromInt(Real.floor((time - floor) * 10000.0))
			in  (print "Cannot obtain pid on NT so we use first 4 decimal digits of time.";
			     print "Chose "; print (Int.toString (Word32.toInt pid)); print ".\n";
			     pid)
			end)

end