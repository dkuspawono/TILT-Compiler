(*$import Prelude TopLevel Rtl Core PRINTUTILS CALLCONV INTRAPROC RECURSION TOASM MACHINEUTILS Stats RTLTOASM Int Util Listops List *)
functor Rtltoasm (val commentHeader : string
		  structure Machineutils : MACHINEUTILS
		  structure Callconv : CALLCONV
		  structure Printutils : PRINTUTILS
		  structure Procalloc : PROCALLOC
		  structure Recursion : RECURSION
		  structure Toasm : TOASM

		  sharing Printutils.Machine 
		      = Callconv.Machine
		      = Procalloc.Bblock.Machine
		      = Toasm.Machine
(* should not be needed *) = Printutils.Bblock.Machine 


		  sharing Printutils.Bblock 
		    = Procalloc.Bblock
		    = Toasm.Bblock

		  sharing Printutils.Tracetable
		      = Procalloc.Tracetable 
		      = Toasm.Tracetable)

		     :> RTLTOASM  =
struct


   open Callconv Printutils Machineutils Rtl
   open Machine
   open Core

   val debug       = ref false
   val knowns      = ref false
   val msgs        = ref false

   fun msg (x: string) = if !msgs then print x else ()
   val error = fn s => Util.error "rtltoasm.sml" s


   val doTimer = Stats.ff("DoBackendTimer")
   fun subtimer (str,f) = if !doTimer
			      then Stats.subtimer(str,f)
			  else f

   fun makeUnknownSig (args,results) = 
       let val linkage = Callconv.unknown_ml (FORMALS{args=args,results=results})
       in UNKNOWN_PROCSIG
	   {linkage = linkage,
	    regs_destroyed = indirect_caller_saved_regs,
	    regs_modified = listToSet general_regs,
	    callee_saved = indirect_callee_saved_regs}
       end
	   

(* ----------------------------------------------------------------- *)

   fun allocateModule (prog as Rtl.MODULE{procs, data, main, global}) =
     let
       val names = map (fn (Rtl.PROC{name,...}) => name) procs
       local
	   val {callee_map, rtl_scc = recursive_components, ...} = Recursion.procGroups prog
	   val _ = print ("  " ^
			 (Int.toString (length procs)) ^
			 " procedures.  " ^
			 (Int.toString (length recursive_components)) ^
			 " recursive components.   Largest component has size " ^
			 (Int.toString (foldr Int.max 0
					(map length recursive_components))) ^
			 ".\n")
(*	   
	   fun getComponent groups proc =
	       let
		   fun loop [] = error "getComponent: procedure not found"
		     | loop (lst :: lsts) =
		       if Listops.member_eq(Rtl.eq_label,proc,lst) then
			   lst
		       else
			   loop lsts
	       in
		   loop groups
	       end

	   fun sameComponent groups proc1 proc2 = 
	       Listops.member_eq(Rtl.eq_label, proc2, getComponent groups proc1)
*)
       in
(*	   val is_mutual_recursive = sameComponent recursive_components *)
	   val component_names = recursive_components
       end

       val Labelmap = ref (Labelmap.empty) : procsig Labelmap.map ref

       fun getSig proc_name = (case (Labelmap.find (!Labelmap, proc_name)) of
				   SOME s => s
				 | _ => error ("getSig " ^ (msLabel proc_name)))

       fun existsSig proc_name = 
	   case Labelmap.find (!Labelmap,proc_name) of
	       SOME _ => true
	     | _ => false

       fun setSig proc_name proc_sig = 
	 Labelmap := Labelmap.insert(!Labelmap, proc_name, proc_sig)

       fun initSig proc =
	   let 
	     val (Rtl.PROC{name, args, results, return, ...}) = proc
	     val args = map Toasm.translateReg args
	     val results  = map Toasm.translateReg results

	     val sign = makeUnknownSig(args,results)

           in if existsSig name 
		  then error ("function names not unique: " ^ (msLabel name) ^ " occurs twice")
	      else setSig name sign
	   end

       fun findRtlProc p [] = error "findRtlProc"
	 | findRtlProc p ((p' as Rtl.PROC{name,...})::rest) =
	 if (Rtl.eq_label (p, name)) then
	   p'
	 else
	   findRtlProc p rest

       fun allocateProc (name : label) =
	 let 
	   val (psig as (UNKNOWN_PROCSIG{linkage,regs_destroyed, 
					 regs_modified,callee_saved})) = getSig name

	   val _ = 
	       if (! debug) then
		   (emitString commentHeader;
		    emitString ("  Allocating " ^ 
				(msLabel name) ^ "\n")) 
	       else ()

	   val _ = msg ((msLabel name) ^ "\n")
	   val _ = msg "\ttranslating\n"

	   val rtlproc = findRtlProc name procs
	   val (blocklabels, block_map, tracemap,stack_resident) =
	       subtimer("backend_toasm",
			Toasm.translateProc) rtlproc
	   val Rtl.PROC{args,results,...} = rtlproc
	   val temp_psig = 
	       KNOWN_PROCSIG {linkage = linkage,
			      framesize  = 0,
			      ra_offset = 0,
			      callee_saved = callee_saved,
			      regs_destroyed  = regs_destroyed,
			      regs_modified = regs_modified,
			      blocklabels = blocklabels,
			      argFormal = map Toasm.translateReg args,
			      resFormal = map Toasm.translateReg results}
	       
	   val _ = msg "\tabout to dump initial version\n"
	       
	   val _ = 
	       if !debug
		   then (emitString commentHeader;
			 emitString (" dumping initial version of procedure");
			 dumpProc(name,temp_psig, block_map, blocklabels, true))
	       else ()
		   
	   val _ = msg "\tallocating\n"

	   val (new_sig, new_block_map, new_block_labels, gc_data) =
	       subtimer("backend_chaitin",
			Procalloc.allocateProc) 
	       {getSignature = getSig,
		name = name,
		block_map = block_map,
		tracemap = tracemap,
		procsig = temp_psig,
		stack_resident = stack_resident}
	       
	
	   val _ = setSig name new_sig
	   val _ = msg "\tdumping\n"
	   val _ = if !debug 
		       then (emitString commentHeader;
			     emitString(" dumping final version of procedure "))
		   else ()
	   val _ = subtimer("backend_output",
			    fn() => (dumpProc (name, 
					       new_sig, new_block_map, 
					       new_block_labels, !debug);
				     dumpGCDatalist gc_data)) ()
	   val _ = if !debug 
		       then (emitString commentHeader;
			     emitString(" done procedure "))
		   else ()
	 in  ()
	 end
	   
       fun allocateComponent (count,chunk) = 
	 let 
	     val _ = if (!debug)
			 then (print "allocating component #"; 
			       print (Int.toString count); print "\n")
		     else ()
	     val _ = app allocateProc chunk
	     val _ = if (!debug)
			 then (print "done allocating component #"; 
			       print (Int.toString count); print "\n")
		     else ()
	 in ()
	 end


       val main' = Machine.msLabel main
       val client_entry = main'^"_client_entry"
       val global_start = main'^"_GLOBALS_BEGIN_VAL"
       val global_end = main'^"_GLOBALS_END_VAL"
       val trace_global_start = main'^"_TRACE_GLOBALS_BEGIN_VAL"
       val trace_global_end = main'^"_TRACE_GLOBALS_END_VAL"

       
       val _ = app emitString programHeader;
       val _ = dumpGCDatalist (Tracetable.MakeTableHeader main');

       val _ = app initSig procs

       val _ = app emitString textStart;
       val _ = emitString ("\t.globl "^main'^"_CODE_END_VAL\n");
       val _ = emitString ("\t.globl "^main'^"_CODE_BEGIN_VAL\n");
       val _ = emitString (""^main'^"_CODE_BEGIN_VAL:\n");
       val _ = Listops.mapcount allocateComponent component_names

     in (* allocateProg *)

       subtimer("backend_output",
		fn() => (app emitString textStart;
			 emitString (main'^"_CODE_END_VAL:\n");
			 dumpGCDatalist (Tracetable.MakeTableTrailer main');
			 app emitString dataStart;
			 dumpDatalist data;
			 emitString ("\t.long 0" ^ commentHeader ^ "filler\n\n");
			 let val globalData = map DATA global
			     val globalData = [DLABEL (ML_EXTERN_LABEL trace_global_start)] @ globalData @
				              [DLABEL (ML_EXTERN_LABEL trace_global_end), 
					       COMMENT "filler so label is defined", INT32 0w0]
			 in  dumpDatalist globalData
			 end;
			 ())) ()
     end (* allocateProg *)
       handle e => (Printutils.closeOutput (); raise e)

end
