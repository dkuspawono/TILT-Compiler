(*$import COMPILER LinkIl Linknil Linkrtl Linkalpha Linksparc OS Stats *)
structure Til : COMPILER =
  struct

    val littleEndian = Stats.tt("littleEndian")

    datatype platform = TIL_ALPHA | TIL_SPARC | MLRISC_ALPHA | MLRISC_SPARC
    val platform = 
	let val envType = (case OS.Process.getEnv "SYS_TYPE" of
			       NONE => OS.Process.getEnv "SYS"
			     | some => some)
	in
	    ref (case envType of
		     NONE => (print "Environment variable SYS_TYPE unset. Defaulting to Alpha.\n";  
			      littleEndian := true; TIL_ALPHA)
		   | SOME sysType => 
			 if (String.substring(sysType,0,3)) = "sun"
			     then (print "Sun detected. Using Til-Sparc\n"; 
				   littleEndian := false; TIL_SPARC)
			 else if (String.substring(sysType,0,5)) = "alpha"
				  then (print "Alpha detected. Using Til-Alpha\n"; 
					littleEndian := true; TIL_ALPHA)
			      else (print "Environment variable SYS_TYPE's value ";
				    print sysType; 
				    print " is unrecognized. Defaulting to Alpha.\n";  
				    littleEndian := true; TIL_ALPHA))
	end

    type sbnd = Il.sbnd
    type context_entry = Il.context_entry
    type context = Il.context
	
    val error = fn x => Util.error "Compiler" x
    val as_path = "as"
	
    val debug_asm = Stats.ff("debug_asm")
    val keep_asm = Stats.tt("keep_asm")
    val compress_asm = Stats.tt("compress_asm")
    fun as_flag() = 
	(case !platform of
	     TIL_ALPHA => if (!debug_asm) then " -g " else ""
	   | TIL_SPARC => if (!debug_asm) then " -xarch=v8plus" else "-xarch=v8plus"
	   | MLRISC_ALPHA => if (!debug_asm) then " -g " else ""
	   | MLRISC_SPARC => if (!debug_asm) then " -xarch=v8plus" else "-xarch=v8plus")
    fun base2ui base = 
	(case !platform of
	     TIL_ALPHA => Linkalpha.base2ui
	   | TIL_SPARC => Linksparc.base2ui
	   | _ => error "No MLRISC"
(*	   | MLRISC_ALPHA => AlphaLink.base2ui
	   | MLRISC_SPARC => SparcLink.base2ui *) ) base
    fun base2s base = 
	(case !platform of
	     TIL_ALPHA => Linkalpha.base2s
	   | TIL_SPARC => Linksparc.base2s
	   | _ => error "No MLRISC"
(*	   | MLRISC_ALPHA => AlphaLink.base2s
	   | MLRISC_SPARC => SparcLink.base2s *) ) base
    fun base2o base = 
	(case !platform of
	     TIL_ALPHA => Linkalpha.base2o
	   | TIL_SPARC => Linksparc.base2o
	   | _ => error "No MLRISC"
(*	   | MLRISC_ALPHA => AlphaLink.base2o
	   | MLRISC_SPARC => SparcLink.base2o *) ) base
    fun base2uo base = 
	(case !platform of
	     TIL_ALPHA => Linkalpha.base2uo
	   | TIL_SPARC => Linksparc.base2uo
	   | _ => error "No MLRISC"
(*	   | MLRISC_ALPHA => AlphaLink.base2uo
	   | MLRISC_SPARC => SparcLink.base2uo *) ) base


    fun assemble(s_file,o_file) =
	let val as_command = as_path ^ " " ^ (as_flag()) ^ " -o " ^ o_file ^ " " ^ s_file
	    val rm_command = "rm " ^ s_file
	    val compress_command = "gzip -f " ^ s_file ^ " &"
	    val success = (Stats.timer("Assemble",Util.system) as_command)
	    val success = success andalso
		((OS.FileSys.fileSize o_file > 0) handle _ => false)
	in if success
	       then (if (!keep_asm)
			 then (if (!compress_asm)
				   then (Util.system compress_command; ())
			       else ())
		     else (Util.system rm_command; ()))
	   else error "assemble. System command as failed"
	end
    
    (* compile(ctxt, unitName, sbnds, ctxt') compiles sbnds into an
     * object file `unitName.o'. ctxt is the context in which the sbnds
     * were produced, and ctxt' contains the new bindings. unitName is
     * the name of the unit being compiled and can be used for
     * generating unique identifiers. Also, `unitName.o' must contain a
     * label for `initialization' with name `unitName_doit'. 
     *)
	exception Stop
	val uptoElaborate = Stats.ff("UptoElaborate")
	val uptoPhasesplit = Stats.ff("UptoPhasesplit")
	val uptoClosureConvert = Stats.ff("UptoClosureConvert")
	val uptoRtl = Stats.ff("UptoRtl")
	val uptoAsm = Stats.ff("UptoAsm")
	fun compile (unitName : string,
		     fileBase: string, 
		     il_module) : string = 
	    let val _ = if (!uptoElaborate) then raise Stop else ()
		val nilmod = Linknil.il_to_nil(unitName, il_module)
		val _ = if (!uptoPhasesplit orelse !uptoClosureConvert)
			    then raise Stop else ()
		val rtlmod = Linkrtl.nil_to_rtl (unitName,nilmod)
		val _ = if (!uptoRtl) then raise Stop else ()


		(* rtl_to_asm creates fileBase.s file with main label * `fileName_doit' *)
		val rtl_to_asm = 
		    case !platform of
			 TIL_ALPHA => Linkalpha.rtl_to_asm
		       | TIL_SPARC => Linksparc.rtl_to_asm
		       | _ => error "No MLRISC"
(*		       | MLRISC_ALPHA => AlphaLink.rtl_to_asm *)
(*		       | MLRISC_SPARC => SparcLink.rtl_to_asm*)
		val (sFile,_) = rtl_to_asm(fileBase, rtlmod)    
		val _ = if (!uptoAsm) then raise Stop else ()

		val oFile = base2o fileBase
		val _ = assemble(sFile, oFile)
	    in  oFile
	    end
	handle Stop => (let val oFile = base2o fileBase
			    val os = TextIO.openOut oFile
			    val _ = TextIO.output(os,"Dummy .o file\n")
			in  TextIO.closeOut os; oFile
			end)


 
    end
