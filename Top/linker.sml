structure Linker : LINKER =
  struct

    val ld_path = "/usr/ucb/cc"
    val ld_libs = ""
    val error = fn x => Util.error "Linker" x

    structure Crc = Crc


    (* -------------------------------------------------------
     * Unit Environments:  A unit environment UE is a mapping
     * from unit names to crc's. Unit objects holds unit
     * environments for imports and exports. When unit objects
     * are linked it is checked to see if unit environments
     * match up. If this is not the case, linking is aborted.
     * ------------------------------------------------------- *)
      
    structure UE =  (* We assume entries in unit environments are lex-sorted *)
      struct
	type UE = (string * Crc.crc) list

	(* confine(UE1,UE2)=UE3 : UE3 holds those components of UE1,
	 * that does not occur in UE2. Components that do also occur
	 * in UE2, must match up; otherwise confinement fails. *)
   
	fun confine (unitname,ue1,ue2) : UE =
	  let fun conf ([],ue2,a) = rev a
		| conf (e::ue1,[],a) = conf(ue1,[],e::a)
		| conf (ue1 as ((un1,crc1)::ue1'),ue2 as ((un2,crc2)::ue2'),a) =
	        if un1 < un2 then conf(ue1',ue2,a)
		else if un2 < un1 then conf(ue1,ue2',a)
		else (* un1=un2 *)
		  if crc1=crc2 then conf(ue1',ue2',(un1,crc1)::a)
		  else error ("Link Error: The unit object " ^ unitname ^ " builds\n" ^
			      "on a version of " ^ un1 ^ " which is inconcistent\n" ^
			      "with which it is linked.") 
	  in conf(ue1,ue2,[])
	  end
	fun plus_overlap(unitname,ue1,ue2) : UE =      (* used on import unit environments *)
	  let fun plus ([],[],a) = rev a
		| plus ([],e::ue2,a) = plus([],ue2,e::a)
		| plus (e::ue1,[],a) = plus(ue1,[],e::a)
		| plus (ue1 as ((un1,crc1)::ue1'),ue2 as ((un2,crc2)::ue2'),a) =
	        if un1 < un2 then plus(ue1',ue2,(un1,crc1)::a)
		else if un2 < un1 then plus(ue1,ue2',(un2,crc2)::a)
		else (* un1=un2 *)
		  if crc1=crc2 then plus(ue1',ue2',(un1,crc1)::a)
		  else error ("Link Error: The unit object " ^ unitname ^ " builds\n" ^
			      "on a version of " ^ un1 ^ " which is inconcistent\n" ^
			      "with versions of " ^ un1 ^ " imported elsewhere.") 
	  in plus(ue1,ue2,[])
	  end
	fun plus_no_overlap(unitname,ue1,ue2) : UE =      (* used on export unit environments *)
	  let fun plus ([],[],a) = rev a
		| plus ([],e::ue2,a) = plus([],ue2,e::a)
		| plus (e::ue1,[],a) = plus(ue1,[],e::a)
		| plus (ue1 as ((un1,crc1)::ue1'),ue2 as ((un2,crc2)::ue2'),a) =
	        if un1 < un2 then plus(ue1',ue2,(un1,crc1)::a)
		else if un2 < un1 then plus(ue1,ue2',(un2,crc2)::a)
		else (* un1=un2 *)
		  error ("Link Error: You are trying to link in the unit " ^ un1 ^ " more\n" ^
			 "than once. This is not allowed.") 
	  in plus(ue1,ue2,[])
	  end
      end

    local open BinIO_Util
    in
      fun mk_uo {imports : (string * Crc.crc) list,
		 exports : (string * Crc.crc) list,
		 uo_result : string,
		 emitter : BinIO.outstream -> unit} : unit =
	let val os = BinIO.openOut uo_result
	  val out_pairs = app (fn (name,crc) =>
			       (output_string (os, name ^ ":");
				Crc.output_crc (os, crc);
				output_string (os, "\n")))
	in output_string (os, "$imports:\n");
	  out_pairs imports;
	  output_string (os, "$exports:\n");
	  out_pairs exports;
	  output_string (os, "$code:\n");
	  emitter os;
	  BinIO.closeOut os
	end

      fun read_string (is, s) : unit =
	case input_string(is,size s)
	  of SOME s' => if s = s' then () 
			else error ("read_string: expecting to read \"" ^ s ^ 
				    "\", but found \"" ^ s' ^ "\"")
	   | NONE => error ("read_string: could not read the string \"" ^ s ^ "\"")


      fun read_unitname_and_colon is =
	let fun loop a = case input_char is
			   of SOME #":" => implode (rev a)
			    | SOME c => loop (c::a)
			    | NONE => error ("read_unitname_and_colon")
	in loop []
	end
 
      fun input_pairs (is : BinIO.instream) : (string * Crc.crc) list =
	let fun loop a = case lookahead is
			   of SOME #"$" => rev a
			    | SOME _ => let val unitname = read_unitname_and_colon is
					    val crc = Crc.input_crc is
					    val _ = read_string(is,"\n")
					in loop((unitname,crc)::a)
					end
			    | NONE => error "input_pairs: nothing in stream"
	in loop []
	end

      fun read_imports (is) =
	let val _ = read_string(is, "$imports:\n")
	in input_pairs is
	end

      fun read_exports (is) =
	let val _ = read_string(is, "$exports:\n")
	in input_pairs is
	end

      (* read imports and exports from uo-file and copy code-segment
       * into the file code_o. *)
      fun read_header_and_extract_code {uo_arg : string, o_file : string} : 
	{imports : (string * Crc.crc) list,
	 exports : (string * Crc.crc) list} =
	let val is = BinIO.openIn uo_arg
	  val imports = read_imports is
	  val exports = read_exports is
	  val _ = read_string(is, "$code:\n")
	  val os = BinIO.openOut o_file
	  val _ = copy(is,os)
	  val _ = BinIO.closeOut os
	  val _ = BinIO.closeIn is
	in {imports=imports, exports=exports}
	end
    end

    fun emitter in_file os = let val is = BinIO.openIn in_file
			     in BinIO_Util.copy(is,os); 
			        BinIO.closeIn is
			     end

    (* link: Link a sequence of uo-files into a new uo-file 
     * and perform consistency check. *)

    fun link {uo_args : string list,       (* Current directory, or absolute path. *)
	      uo_result : string} : unit = (* Strings should contain extension. *) 
      let val linkinfo =
	    map (fn uo_file =>
		 let val base = OS.Path.base uo_file
		     val o_file = base ^ ".o"
		     val {imports,exports} = read_header_and_extract_code 
		       {uo_arg = uo_file, o_file = o_file}
		 in {unitname=base, imports=imports, exports=exports,ofile=o_file}
		 end) uo_args
	  fun li (iue0,eue0,[]) = (iue0,eue0)
	    | li (iue0,eue0,{unitname,imports=iue,exports=eue,ofile}::rest) =
	    let val iue' = UE.confine(unitname,iue,eue0)
	        val iue0' = UE.plus_overlap(unitname,iue0,iue') 
		val eue0' = UE.plus_no_overlap(unitname,eue0,eue)
	    in li (iue0',eue0',rest)
	    end
	  val (imports, exports) = li ([],[],linkinfo)
	  val o_files = map #ofile linkinfo
	  val o_file = OS.Path.base uo_result ^ ".o"
	  fun pr_list [] = ""
	    | pr_list [a] = a
	    | pr_list (a::xs) = a ^ " " ^ pr_list xs
      in if OS.Process.system (ld_path ^ " -r -o " ^ o_file ^ " " ^ pr_list o_files) 
	    = OS.Process.success then 
		mk_uo {imports=imports,exports=exports,uo_result=uo_result,
		       emitter=emitter o_file}
	 else error "link. System command ld failed"
      end

    (* mk_exe: Make an executable from a uo-file and check 
     * that the sequence of imports is empty. *)
    fun mk_exe {uo_arg : string,
		exe_result : string} : unit =
      let val _ = case OS.Path.ext uo_arg
		    of SOME "uo" => () 
		     | _ => error "mk_exe - argument does not have uo-extension"
	  val o_temp = OS.Path.base uo_arg ^ ".o"
	  val {imports,exports} = read_header_and_extract_code {uo_arg = uo_arg,
								o_file = o_temp}
      in case imports
	   of nil => (* everything has been resolved *)
	     (if OS.Process.system (ld_path ^ " " ^ o_temp ^ " -o " ^ exe_result ^ " " ^ ld_libs)
		= OS.Process.success then ()
		else error "mk_exe - ld failed")
	    | _ => let val units = map #1 imports
	               fun pr_units [] = error "pr_units"
			 | pr_units [a] = a
			 | pr_units (a::rest) = (a ^ ", " ^ pr_units rest)
		   in print ("\nError! The units : [" ^ pr_units units ^ 
			     "] have not been resolved. I cannot generate\n" ^
			     "an executable for you.\n"); error "mk_exe"
		   end
      end
(*
    structure Test =
      struct
	val uo_file = "/tmp/test.uo"
	val o_file = "/tmp/test.o"
	val A_ui = "/tmp/A.ui"
	val B_ui = "/tmp/B.ui"
	val C_ui = "/tmp/C.ui"
	val crc_A = Crc.crc_of_file A_ui
	val crc_B = Crc.crc_of_file B_ui
	val crc_C = Crc.crc_of_file C_ui
	val object = "/tmp/first.o"
	val _ =
	  mk_uo {imports= [("A",crc_A),("B",crc_B)],
		 exports= [("C",crc_C)],
		 uo_result= uo_file,
		 emitter= emitter object}
	val {imports,exports} = read_header_and_extract_code {uo_arg = uo_file,
							      o_file = o_file}
	val _ = if Crc.crc_of_file object = Crc.crc_of_file o_file then ()
		else error "TestError"
	val [("A",crc_A'),("B",crc_B')] = imports
	val [("C",crc_C')] = exports
	val _ = if [crc_A,crc_B,crc_C] = [crc_A',crc_B',crc_C'] then ()
		else error "TestError - imports, exports"
      end

    structure Test2 =
      struct
	val o_file = "/home/mael/tmp/hello.o"
	val uo_file =  "/home/mael/tmp/helloworld.uo" 
	val exe_result = "/home/mael/tmp/run"
	val _ = mk_uo {imports= [],
		       exports= [],
		       uo_result= uo_file,
		       emitter= emitter o_file}
	val _ = mk_exe {uo_arg = uo_file,
			exe_result = exe_result}

	val A_ui = "/tmp/A.ui"
	val crc_A = Crc.crc_of_file A_ui
	val _ = mk_uo {imports= [("A", crc_A)],
		       exports= [],
		       uo_result= uo_file,
		       emitter= emitter o_file}
	val _ = (mk_exe {uo_arg = uo_file,
			 exe_result = exe_result};
		 error "Test2 - should not get here... \n**** ERROR ****\n") handle _ => ()

      end
*)
  end
