signature LINKNIL = 
sig
    structure Il : IL
    structure Nil : NIL
    structure NilUtil : NILUTIL
    structure NilContext : NILCONTEXT
    structure NilStatic : NILSTATIC
    structure PpNil : PPNIL

    val compile_prelude : bool * string -> Nil.module
    val compile : string -> Nil.module
    val compiles : string list -> Nil.module list
    val test : string -> Nil.module
    val il_to_nil : Il.context * Il.sbnds * Il.sdecs -> Nil.module

    val do_opt : bool ref
end

structure Linknil (* : LINKNIL *) =
  struct
    val typecheck_before_opt = ref true
    val typecheck_after_opt = ref true
    val typecheck_after_cc = ref true

    val do_opt = ref true

    val error = fn s => Util.error "linknil.sml" s

    val select_carries_types = Stats.bool "select_carries_types"
    val profile = Stats.bool "nil_profile"
    val short_circuit = Stats.bool "subst_short_circuit"
    val hash = Stats.bool "subst_use_hash"
    val bnds_made_precise = Stats.bool "bnds_made_precise"
    val closure_print_free = Stats.bool "closure_print_free"
    val _ = (select_carries_types:=false;
	     profile := false;
	     short_circuit := true;
	     hash := false;
	     bnds_made_precise := true;
	     closure_print_free := false)

    structure Il = LinkIl.Il
    structure Stats = Stats
    structure Name = Name
    structure LinkIl = LinkIl
    structure Nil = Nil(structure ArgAnnotation = Annotation
			structure ArgPrim = LinkIl.Prim)      

    structure PpNil = Ppnil(structure ArgNil = Nil
			    structure Prim = LinkIl.Prim
			    structure Ppprim = LinkIl.Ppprim)

    structure Alpha = Alpha(structure ArgNil = Nil)

    structure NilPrimUtilParam = NilPrimUtilParam(structure Nil= Nil)
	
    structure NilPrimUtil = PrimUtil(structure Prim = LinkIl.Prim
				     structure Ppprim = LinkIl.Ppprim
				     structure PrimUtilParam = NilPrimUtilParam)

    structure NilSubst = NilSubstFn(structure Nil = Nil
				    structure PpNil = PpNil)

    structure NilUtil = NilUtilFn(structure ArgNil = Nil
				  structure IlUtil = LinkIl.IlUtil
				  structure ArgPrim = LinkIl.Prim
				  structure PrimUtil = NilPrimUtil
				  structure Alpha = Alpha
				  structure Subst = NilSubst
				  structure PpNil = PpNil)

    structure NilContext' = NilContextFn'(structure NilUtil = NilUtil
					structure ArgNil = Nil
					structure PpNil = PpNil
					structure Cont = Cont
					structure Subst = NilSubst)

    structure Normalize = NormalizeFn(structure Nil = Nil
				      structure NilUtil = NilUtil
				      structure NilContext = NilContext'
				      structure PpNil = PpNil
				      structure Subst = NilSubst)

    structure NilContext = NilContextFn(structure NilContext' = NilContext'
					structure Normalize = Normalize)

    structure NilError = NilErrorFn(structure ArgNil = Nil
				    structure PpNil = PpNil)

    structure NilStatic = NilStaticFn(structure Annotation = Annotation
				      structure Prim = LinkIl.Prim
				      structure ArgNil = Nil
				      structure PrimUtil = NilPrimUtil
				      structure NilUtil = NilUtil
				      structure NilContext = NilContext
				      structure PpNil = PpNil
				      structure Alpha = Alpha
				      structure NilError = NilError
				      structure Subst = NilSubst
				      structure Normalize = Normalize)

    val nilstatic_exp_valid = NilStatic.exp_valid

    structure Tonil = Tonil(structure ArgIl = LinkIl.Il
			    structure Nilstatic = NilStatic
			    structure NilError = NilError
			    structure Nilprimutil = NilPrimUtil
			    structure Ilutil = LinkIl.IlUtil
                            structure Ilcontext = LinkIl.IlContext
                            structure IlStatic = LinkIl.IlStatic
			    structure ArgNilcontext = NilContext
			    structure Nilutil = NilUtil
			    structure Ppnil = PpNil
			    structure Ppil = LinkIl.Ppil
			    structure ArgNil = Nil
			    structure Subst = NilSubst)

    structure Linearize = Linearize(structure Nil = Nil
				    structure NilUtil = NilUtil
				    structure Ppnil = PpNil)

    structure BetaReduce = BetaReduce(structure Prim = LinkIl.Prim
				      structure Nil = Nil
				      structure NilUtil = NilUtil
				      structure Ppnil = PpNil
				      structure IlUtil = LinkIl.IlUtil
				      structure Subst = NilSubst)

    structure Cleanup = Cleanup(structure Prim = LinkIl.Prim
				structure Nil = Nil
				structure NilUtil = NilUtil
				structure Ppnil = PpNil
				structure IlUtil = LinkIl.IlUtil
				structure Subst = NilSubst)

    structure ToClosure = ToClosure(structure Nil = Nil
				    structure Ppnil = PpNil
				    structure NilUtil = NilUtil
				    structure Subst = NilSubst)

	
    structure NilEval = NilEvaluate(structure Nil = Nil
				    structure NilUtil = NilUtil
				    structure Ppnil = PpNil
				    structure PrimUtil = NilPrimUtil
				    structure Subst = NilSubst)

    structure DoOpts = DoOpts (structure Nil = Nil
			       structure NilPrimUtil = NilPrimUtil 
			       structure PpNil = PpNil
			       structure NilContext = NilContext
			       structure NilEval = NilEval
			       structure NilStatic = NilStatic
			       structure NilSubst = NilSubst
			       structure NilUtil = NilUtil)

    fun phasesplit (ctxt,sbnds,sdecs) : Nil.module = 
	let
	    open Nil LinkIl.Il LinkIl.IlContext Name
	    fun make_cr_labels l = (internal_label((label2string l) ^ "_c"),
				    internal_label((label2string l) ^ "_r"))

            (* obtain all the imports with classifiers from the context *)
	    datatype import_type = ImpExp | ImpType | ImpMod
		
	    fun mapper v =
		let val (l,pc) = valOf (LinkIl.IlContext.Context_Lookup'(ctxt,v))
		in                
		    (case pc of
			 PHRASE_CLASS_EXP _ => SOME(ImpExp,v,l)
		       | PHRASE_CLASS_CON _ => SOME(ImpType,v,l)
		       | PHRASE_CLASS_MOD _ => SOME(ImpMod,v,l)
		       | PHRASE_CLASS_SIG _ => NONE
		       | PHRASE_CLASS_OVEREXP _ => NONE)
		end
	    val varlist = LinkIl.IlContext.Context_Varlist ctxt
	    val import_temp = List.mapPartial mapper varlist

            (* create a module-variable to pair of variables map from import_modmap *)
	    fun folder ((ImpMod,v,l),map) = let val vc = fresh_named_var (var2string v ^ "myvc")
						val vr = fresh_named_var (var2string v ^ "myvr")
					    in  VarMap.insert(map,v,(vc,vr))
					    end
	      | folder (_,map) = map
	    val import_varmap = foldl folder VarMap.empty import_temp


            (* call the phase splitter *)
	    val {nil_initial_context : NilContext.context , nil_final_context : NilContext.context, 
		 cu_bnds = bnds, vmap = total_varmap} = 
		Tonil.xcompunit ctxt import_varmap sbnds

(*
val _ = (print "Nil final context is:\n";
	 NilContext.print_context nil_final_context;
	 print "\n\n")
*)

            (* create the imports with classifiers by using the NIL context 
	      returned by the phase splitter *)
	    fun folder ((ImpExp,v,l),imps) = 
		let val c' = (case NilContext.find_con(nil_initial_context,v) of
				  SOME c' => c'
				| NONE => error "exp var not in NIL context")
		in  (ImportValue(l,v,c'))::imps
		end
	      | folder ((ImpType,v,l),imps) = 
		let 
		    fun strip_var_from_singleton (var,kind) = 
			let open NilUtil
			    fun handler (_,Singleton_k(p,k,c)) = 
				if (convar_occurs_free(var,c))
				    then CHANGE_NORECURSE(strip_var_from_singleton(var,k))
				else NOCHANGE
			      | handler _ = NOCHANGE
			    fun nada _ = NOCHANGE
			    val handlers = (nada,nada,nada,nada,handler)
			    val res = kind_rewrite handlers kind
(*
			    val _ = (print "strip_var_from_singleton: "; PpNil.pp_var var;
				     print "\n from k = "; PpNil.pp_kind kind;
				     print "\nresult = "; PpNil.pp_kind res; print "\n\n")
*)
			in  res
			end
		    val (c,k) = NilStatic.con_valid(nil_initial_context,Var_c v) 
		    val k = strip_var_from_singleton(v,Singleton_k(Runtime,k,c))
		in  (ImportType(l,v,k))::imps
		end
	      | folder ((ImpMod,v,l),imps) = 
		if (LinkIl.IlUtil.is_exportable_lab l) (* a label is exportable iff it is importable *)
		    then
			let val (cvar,rvar) = valOf (VarMap.find(import_varmap,v))
			    val (cl,rl) = make_cr_labels l
			in  folder((ImpExp,rvar,rl),folder((ImpType,cvar,cl),imps))
			end
		else imps
(*	    val _ = print "---about to compute imports\n" *)
	    val imports : import_entry list = rev (foldl folder [] import_temp)
(*	    val _ = print "---adone with compute imports\n" *)

	    (* create the export map by looking at the original sbnds;
	      labels that are "exportable" must be exported
             open labels must be recursively unpackaged 
             for module bindings, use the varmap returned by the phase-splitter *)
(*
	    fun folder cr_pathopts ((SBND(l,bnd)),exports) = 
		let open LinkIl.IlUtil
		    fun make_cpath v = (case cr_pathopts of
					   SOME (path,_) => join_path_labels(path,[l])
					 | NONE => SIMPLE_PATH v)
		    fun make_rpath v = (case cr_pathopts of
					   SOME (_,path) => join_path_labels(path,[l])
					 | NONE => SIMPLE_PATH v)

		    fun path2exp (SIMPLE_PATH v) = Var_e v
		      | path2exp (COMPOUND_PATH (v,lbls)) = 
			let fun loop e [] = e
			      | loop e (lbl::lbls) = loop (Prim_e(NilPrimOp (select lbl),[],[e])) lbls
			in loop (Var_e v) lbls
			end
		    fun path2con (SIMPLE_PATH v) = Var_c v
		      | path2con (COMPOUND_PATH (v,lbls)) = 
			let fun loop c [] = c
			      | loop c (lbl::lbls) = loop (Proj_c(c,lbl)) lbls
			in loop (Var_c v) lbls
			end
		in
		    (case (is_exportable_lab l, Name.is_label_open l, bnd) of
			 (false,false,_) => exports
		       | (true,_,BND_EXP (v,_)) => 
			     let val e = path2exp (make_rpath v)
				 val (_,c) = nilstatic_exp_valid(nil_final_context,e)
			     in  (ExportValue(l,e,c)::exports)
			     end
		       | (true,_,BND_CON (v,_)) =>
			     let val c = path2con (make_cpath v)
				 val (_,k) = NilStatic.con_valid(nil_final_context,c)
			     in  (ExportType(l,c,k)::exports)
			     end
		       | (false,true,BND_EXP _) => error "BND_EXP with open label"
		       | (false,true,BND_CON _) => error "BND_CON with open label"
		       | (is_export,is_open,BND_MOD (v,m)) => 
			     let val (lc,lr) = make_cr_labels l
				 val (vc,vr) = (case VarMap.find(total_varmap,v) of
						    SOME vrc => vrc
						  | NONE => error "total_varmap missing bindings")
				 val rpath = make_rpath vr
				 val cpath = make_rpath vc
				 val exports = 
				     if is_export
					 then
					     let val _ = print "exporting module\n"
						 val er = path2exp rpath
						 val (_,cr) = nilstatic_exp_valid(nil_final_context,er)
						 val cc = path2con cpath
						 val (_,kc) = NilStatic.con_valid(nil_final_context,cc)
						 val _ = print "done exporting module\n"
					     in (ExportValue(lr,er,cr)::
						 ExportType(lc,cc,kc)::
						 exports)
					     end
				     else exports
				 val exports = 
				     (case (is_open,m) of
					  (true,MOD_STRUCTURE sbnds) =>
					      let val _ = print "exporting open module\n"
						  val res = foldl (folder (SOME (cpath,rpath))) exports sbnds
						  val _ = print "done exporting open module\n"
					      in res
					      end
					| (true, _) => 
					      (print "BND_MOD (non-structure) with open label:\n";
					       LinkIl.Ppil.pp_mod m; print "\n";
					       error "BND_MOD (non-structure) with open label")
					| _ => exports)
			     in  exports
			     end)
		end
*)
	    fun folder cr_pathopts ((SDEC(l,dec)),exports) = 
		let open LinkIl.IlUtil
		    fun make_cpath v = (case cr_pathopts of
					   SOME (path,_) => join_path_labels(path,[l])
					 | NONE => SIMPLE_PATH v)
		    fun make_rpath v = (case cr_pathopts of
					   SOME (_,path) => join_path_labels(path,[l])
					 | NONE => SIMPLE_PATH v)

		    fun path2exp (SIMPLE_PATH v) = Var_e v
		      | path2exp (COMPOUND_PATH (v,lbls)) = 
			let fun loop e [] = e
			      | loop e (lbl::lbls) = loop (Prim_e(NilPrimOp (select lbl),[],[e])) lbls
			in loop (Var_e v) lbls
			end
		    fun path2con (SIMPLE_PATH v) = Var_c v
		      | path2con (COMPOUND_PATH (v,lbls)) = 
			let fun loop c [] = c
			      | loop c (lbl::lbls) = loop (Proj_c(c,lbl)) lbls
			in loop (Var_c v) lbls
			end
		in
		    (case (is_exportable_lab l, false andalso Name.is_label_open l, dec) of
			 (false,false,_) => exports
		       | (true,_,DEC_EXP (v,_)) => 
			     let val e = path2exp (make_rpath v)
				 val (_,c) = nilstatic_exp_valid(nil_final_context,e)
			     in  (ExportValue(l,e,c)::exports)
			     end
		       | (true,_,DEC_CON (v,_,_)) =>
			     let val c = path2con (make_cpath v)
				 val (_,k) = NilStatic.con_valid(nil_final_context,c)
			     in  (ExportType(l,c,k)::exports)
			     end
		       | (false,true,DEC_EXP _) => error "DEC_EXP with open label"
		       | (false,true,DEC_CON _) => error "DEC_CON with open label"
		       | (is_export,is_open,DEC_MOD (v,s)) => 
			     let val (lc,lr) = make_cr_labels l
				 val (vc,vr) = (case VarMap.find(total_varmap,v) of
						    SOME vrc => vrc
						  | NONE => error "total_varmap missing bindings")
(*
				 val _ = (print "v = "; PpNil.pp_var v; print "\n";
					  print "vc = "; PpNil.pp_var vc; print "\n";
					  print "vr = "; PpNil.pp_var vr; print "\n")
*)
				 val rpath = make_rpath vr
				 val cpath = make_cpath vc
				 val exports = 
				     if is_export
					 then
					     let 
(*						 val _ = print "exporting module\n"  *)
						 val er = path2exp rpath
(*						 val _ = (print "er = "; PpNil.pp_exp er; print "\n") *)
						 val (_,cr) = nilstatic_exp_valid(nil_final_context,er)
(*						 val _ = print "exporting module: type-checked exp\n"  *)
						 val cc = path2con cpath
						 val (_,kc) = NilStatic.con_valid(nil_final_context,cc)
(*						 val _ = print "done exporting module\n"  *)
					     in (ExportValue(lr,er,cr)::
						 ExportType(lc,cc,kc)::
						 exports)
					     end
				     else exports
				 val exports = 
				     (case (is_open,s) of
					  (true,SIGNAT_STRUCTURE (_,sdecs)) =>
					      let val _ = print "exporting open module\n"
						  val res = foldl (folder (SOME (cpath,rpath))) exports sdecs
						  val _ = print "done exporting open module\n"
					      in res
					      end
					| (true, _) => 
					      (print "DEC_MOD (non-structure) with open label:\n";
					       LinkIl.Ppil.pp_signat s; print "\n";
					       error "DEC_MOD (non-structure) with open label")
					| _ => exports)
			     in  exports
			     end)
		end
(*	    val _ = print "---about to compute exports\n" *)
	   val exports : export_entry list = rev(foldl (folder NONE) [] sdecs)
(*	   val _ = print "---done with compute exports\n" *)

	    val nilmod = MODULE{bnds = bnds, 
				imports = imports,
				exports = exports}

	in  nilmod
	end

    fun showmod debug str nilmod = 
	if debug
	    then (print "\n\n=======================================\n\n";
		  print str;
		  print " results:\nsize = ";
		  print (Int.toString (NilUtil.module_size nilmod));
		  PpNil.pp_module nilmod;
		  print "\n")
	else (print str; print " complete\n")
	    
    fun pcompile' debug (ctxt,sbnds,sdecs) = 
	let
	    open Nil LinkIl.Il LinkIl.IlContext Name
	    val D = NilContext.empty()

	    val nilmod = (Stats.timer("Phase-splitting",phasesplit)) (ctxt,sbnds,sdecs)	    
	    val _ = showmod debug "Phase-split" nilmod
	in
	    nilmod
	end

    fun compile' debug (ctxt,sbnds,sdecs) = 
	let
	    open Nil LinkIl.Il LinkIl.IlContext Name
	    val D = NilContext.empty()

	    val nilmod = (Stats.timer("Phase-splitting",phasesplit)) (ctxt,sbnds,sdecs)	    
	    val _ = showmod debug "Phase-split" nilmod

	    val nilmod = (Stats.timer("Cleanup",Cleanup.cleanModule)) nilmod
	    val _ = showmod debug "Cleanup" nilmod

	    val nilmod = (Stats.timer("Linearization",Linearize.linearize_mod)) nilmod
	    val _ = showmod debug "Renaming" nilmod

 	    val nilmod' = 
	      if (!typecheck_before_opt) then
		(Stats.timer("Nil typechecking - pre opt",NilStatic.module_valid)) (D,nilmod)
	      else
		nilmod
	    val _ = 
	      if (!typecheck_before_opt) then 
		  showmod debug "Pre-opt typecheck" nilmod'
	      else ()

	    val nilmod = if (!do_opt) then (Stats.timer("Nil Optimization", DoOpts.do_opts debug)) nilmod else nilmod
	    val _ = if (!do_opt)
			then showmod debug "Optimization" nilmod
		    else ()

 	    val nilmod' = 
	      if (!typecheck_after_opt) then
		(Stats.timer("Nil typechecking",NilStatic.module_valid)) (D,nilmod)
	      else
		nilmod
	    val _ = 
	      if (!typecheck_after_opt) then 
		  showmod debug "Post-opt typecheck" nilmod'
	      else ()
	
(*
	    val _ = print "starting beta-reduction\n"	  
	    val nilmod = (Stats.timer("Beta-reduction",BetaReduce.reduceModule)) nilmod
	    val _ = showmod debug  "Beta-reduction" nilmod
*)

	    val nilmod = (Stats.timer("Closure-conversion",ToClosure.close_mod)) nilmod
	    val _ = showmod debug "Closure-conversion" nilmod

	    val nilmod = (Stats.timer("Linearization2",Linearize.linearize_mod)) nilmod
	    val _ = showmod debug "Renaming2" nilmod

 	    val nilmod' = 
	      if (!typecheck_after_cc) then
		(Stats.timer("Nil typechecking (post cc)",NilStatic.module_valid)) (D,nilmod)
	      else
		nilmod
	    val _ = 
	      if (!typecheck_after_cc) then 
		  showmod debug "Post-cc Typecheck" nilmod'
	      else ()
	in  nilmod
	end

    fun linkil_tests [] = NONE
      | linkil_tests [one] = SOME [valOf (LinkIl.test one)]
      | linkil_tests _ = error "linkil_tests only defined for one file"

    fun meta_compiles debug filenames = 
	let val mods = valOf ((if debug then linkil_tests else LinkIl.compiles) filenames)
	in  map (compile' debug) mods
	end

    fun meta_pcompiles debug filenames = 
	let val mods = valOf ((if debug then linkil_tests else LinkIl.compiles) filenames)
	in  map (pcompile' debug) mods
	end

    fun pcompile filename = hd(meta_pcompiles false [filename])
    fun ptest filename = hd(meta_pcompiles true [filename])

    fun compiles filenames = meta_compiles false filenames
    fun compile filename = hd(meta_compiles false [filename])
    fun tests filenames = meta_compiles true filenames
    fun test filename = hd(meta_compiles true [filename])
    fun il_to_nil (context, sbnds, sdecs) = compile' false (context, sbnds, sdecs)

    val cached_prelude = ref (NONE : Nil.module option)
    fun compile_prelude (use_cache,filename) = 
	case (use_cache, !cached_prelude) of
		(true, SOME m) => m
	      | _ => let val (ctxt,sbnds,sdecs) = 
				LinkIl.compile_prelude(use_cache,filename)
			 val m = compile' false (ctxt,sbnds,sdecs)
			 val _ = cached_prelude := SOME m
		     in  m
		     end
end

