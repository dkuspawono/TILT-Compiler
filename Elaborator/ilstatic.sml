(*$import Il IlContext PrimUtil Ppil IlUtil Util Listops ILSTATIC Stats Option *)
(* Static semantics *)
structure IlStatic
  :> ILSTATIC =
  struct


    open Util Listops
    open Il Ppil IlUtil 
    open IlContext 
    open Prim Tyvar Name

    val error = fn s => error "ilstatic.sml" s
    val trace = Stats.ff("IlstaticTrace")
    val debug = Stats.ff("IlstaticDebug")
    val showing = Stats.ff("IlstaticShowing")

    fun debugdo t = if (!debug) then (t(); ()) else ()
    fun debugdo' t = t()
    fun fail s = raise (FAILURE s)


   fun reduce_sigvar(context,v) = 
	(case (Context_Lookup'(context,v)) of
	     SOME(_,PHRASE_CLASS_SIG(v,s)) => s
	   | SOME _ => (print "reduce_sigvar given SIGVAR = "; pp_var v;
			print "in ctxt bound but not to signature: \n"; Ppil.pp_context context;
			error "reduce_sigvar given unbound SIGVAR")
	   | NONE => (print "reduce_sigvar given unbound SIGVAR = "; pp_var v;
		      print "in ctxt: \n"; Ppil.pp_context context;
		      error "reduce_sigvar given unbound SIGVAR"))

   datatype phrase = PHRASE_EXP of exp
                    | PHRASE_CON of con
                    | PHRASE_MOD of mod
                    | PHRASE_SIG of var * signat
                    | PHRASE_OVEREXP of (con * exp) list

    datatype class = CLASS_EXP of con
                   | CLASS_CON of kind
                   | CLASS_MOD of signat
                   | CLASS_SIG
                   | CLASS_OVEREXP


    fun merge_phrase_pc (PHRASE_EXP e', PHRASE_CLASS_EXP (e,c,_,i)) = PHRASE_CLASS_EXP (e,c,SOME e',i)
      | merge_phrase_pc (PHRASE_CON c', PHRASE_CLASS_CON (c,k,_,i)) = PHRASE_CLASS_CON (c,k,SOME c',i)
      | merge_phrase_pc (PHRASE_MOD m, PHRASE_CLASS_MOD (_,b,s)) = PHRASE_CLASS_MOD (m,b,s)
      | merge_phrase_pc (PHRASE_SIG (v,s), PHRASE_CLASS_SIG _) = PHRASE_CLASS_SIG (v,s)
      | merge_phrase_pc (PHRASE_OVEREXP oe, PHRASE_CLASS_OVEREXP _) = PHRASE_CLASS_OVEREXP oe 
      | merge_phrase_pc  _ = error "merge_phrase_pc got a phrase and phraseclass of conflicting flavors"
       
       
   (* --- remove references to internal variables from signature with given module ---- *)
   local
       type state = {ctxt : context,
	             expself : (var * exp) list,
		     conself : (var * con) list,
		     modself : (var * mod) list,
		     expunself : (exp * exp) list,
		     conunself : (con * con) list,
		     modunself : (mod * mod) list}
       fun initial_state ctxt = {ctxt = ctxt,
			         expunself = [],
			         conunself  = [],
			         modunself  = [],
				 expself  = [],
				 conself  = [],
				 modself  = []}
       fun isempty_state ({expself,conself,modself,expunself,conunself,modunself,...}:state) = 
	   (null expself) andalso (null conself) andalso (null modself) andalso
	   (null expunself) andalso (null conunself) andalso (null modunself) 

fun show_state ({modunself,...}:state) = 
    (print "modunself:\n";
     app (fn (m1,m2) => (pp_mod m1; print " --> "; pp_mod m2; print "\n")) modunself;
     print "\n")

       fun add_exppath({ctxt,expunself,conunself,modunself,expself,conself,modself} : state,v,p) = 
	   {ctxt=ctxt,expunself = (path2exp p, VAR v)::expunself,conunself=conunself,modunself=modunself,
	    expself = (v,path2exp p)::expself,
	    conself=conself,modself=modself}
       fun add_conpath({ctxt,expunself,conunself,modunself,expself,conself,modself}:state,v,p) = 
	   {ctxt=ctxt,conunself = (path2con p, CON_VAR v)::conunself,expunself=expunself,modunself=modunself,
	    conself = (v,path2con p)::conself,
	    expself=expself,modself=modself}
       fun add_modpath({ctxt,expunself,conunself,modunself,expself,conself,modself}:state,v,p) = 
	   {ctxt=ctxt,modunself = (path2mod p, MOD_VAR v)::modunself,expunself=expunself,conunself=conunself,
	    modself = (v,path2mod p)::modself,
	    conself=conself,expself=expself}
       fun meta_add adder (state,v,NONE) = state
	 | meta_add adder (state,v,SOME p) = adder(state,v,p)
       val add_exppath = meta_add add_exppath
       val add_conpath = meta_add add_conpath
       val add_modpath = meta_add add_modpath

       fun ehandler ({expunself,...} : state) (m,l) = assoc_eq(eq_epath, MODULE_PROJECT(m,l), expunself)
       fun chandler ({conunself,...} : state) (m,l) = 
	   let val res = assoc_eq(eq_cpath, CON_MODULE_PROJECT(m,l), conunself)
(*
	       val _ = (print "(un)-selfify chandler called with\n";
			pp_con (CON_MODULE_PROJECT(m,l));
			print "\nand conunself = ";
			app (fn (c,c') => (pp_con c; print "   -->  "; pp_con c'; print "\n")) conunself;
			print "\nand returning res = ";
			case res of 
			    NONE => print "NONE\n"
			  | SOME c => (print "SOME "; pp_con c; print "\n"))
*)
	   in  res
	   end
       fun mhandler ({modunself,...} : state) (m,l) = assoc_eq(eq_mpath,MOD_PROJECT(m,l), modunself)


       fun selfify_exp(selfify,state as {expself,conself,modself,...}:state,e) = 
	   if selfify
	       then exp_subst_expconmodvar(e,expself,conself,modself)
	   else exp_subst_allproj (ehandler state, chandler state, 
				   mhandler state, fn _ => NONE) e

       fun selfify_con(selfify,state as {conself,modself,...}:state,c) = 
	   if selfify
	       then con_subst_conmodvar(c,conself,modself)
	   else  con_subst_allproj (ehandler state, chandler state, 
				    mhandler state, fn _ => NONE) c

       fun selfify_kind(selfify,state,k : kind) = k

       fun selfify_mod(selfify,state as {conself,modself,...}:state,m) = 
	   if selfify
	       then mod_subst_conmodvar(m,conself,modself)
	   else  mod_subst_allproj(ehandler state, chandler state, 
				   mhandler state, fn _ => NONE) m
	       
       fun sdec_folder (popt,selfify) (sdec as (SDEC(l,dec)),(state:state,rev_sdecs)) = 
	   let val popt = mapopt (fn p => join_path_labels(p,[l])) popt
	   in 
	       (case dec of
		    DEC_EXP(v,c,eopt,inline) => 
			let val c = selfify_con(selfify,state,c)
			    val eopt = (case eopt of
					    NONE => NONE
					  | SOME e => SOME(selfify_exp(selfify,state,e)))
			in  (state,(SDEC(l,DEC_EXP(v,c,eopt,inline))) :: rev_sdecs)
			end

		  | DEC_CON(v,k,copt,inline) => 
		     let 
			 val this_dec = 
			 (case copt of  (*  if we do this, Unselfify is hard to write. *)
			      NONE => DEC_CON(v,selfify_kind(selfify,state,k),
					      (case popt of
						   NONE => NONE
						 | SOME p => SOME(path2con p)),
					       inline)
			    | SOME c => 
				  let val c' = selfify_con(selfify,state,c)
				      val copt' = 
					  (if (not selfify andalso 
					       case (c',popt) of
						   (CON_MODULE_PROJECT _, SOME p) => eq_cpath(c', path2con p)
(*
						       (print "l = "; pp_label l; print "\n";
							print "l' = "; pp_label l'; print "\n";
							print "m = "; pp_mod m; print "\n";
							print "p = "; pp_mod (path2mod p); print "\n";
						       eq_label(l,l') andalso eq_modproj(m,path2mod p))
*)
						 | _ => false)
					       then NONE
					   else SOME c')
				      val k' = selfify_kind(selfify,state,k)
				  in  DEC_CON(v,k',copt',inline)
				  end)
			 val state = add_conpath(state,v,popt)
		     in (state,(SDEC(l,this_dec))::rev_sdecs)
		     end
		  | DEC_MOD(v,b,s) => 
		     let val this_dec = DEC_MOD(v,b,SelfifySig(state,selfify) (popt,s))
			 val state = add_modpath(state,v,popt)
		     in (state,SDEC(l,this_dec)::rev_sdecs)
		     end)
	   end
		    

       and sbnd_folder (popt,selfify) (SBND(l,bnd),(state:state,rev_sbnds)) = 
	   let val popt = mapopt (fn p => join_path_labels(p,[l])) popt
	   in  (case bnd of
		    BND_EXP(v,e) => 
			let val state = add_exppath(state,v,popt)
			in (state,(SBND(l,BND_EXP(v,selfify_exp(selfify,state,e))))::rev_sbnds)
			end
		  | BND_MOD(v,b,m) => 
			let val this_bnd = BND_MOD(v,b,SelfifyMod(state,selfify) (popt,m))
			    val state = add_modpath(state,v,popt)
			in (state,SBND(l,this_bnd)::rev_sbnds)
			end
		  | BND_CON(v,c) =>
			let val this_bnd = BND_CON(v,selfify_con(selfify,state,c))
			    val state = add_conpath(state,v,popt)
			in (state,(SBND(l,this_bnd))::rev_sbnds)
			end)
	   end


       and do_sdecs (popt,selfify) (state:state,sdecs) = 
	   let val (_,rev_sdecs') = foldl (sdec_folder (popt,selfify)) (state,[]) sdecs
	   in  rev rev_sdecs'
	   end

       and do_sbnds (popt,selfify) (state,sbnds) = 
	   let val (_,rev_sbnds') = foldl (sbnd_folder (popt,selfify)) (state,[]) sbnds
	   in  rev rev_sbnds'
	   end

       and SelfifyMod (state:state,selfify) (popt: path option, module : mod) : mod = 
	   let val x = 5
	   in (case module of
		   MOD_FUNCTOR (a,v,s1,m,s2) => 
		       let val s1' = SelfifySig (state,selfify) (NONE,s1)
			   val s2' = SelfifySig (state,selfify) (NONE,s2)
			   val m' = SelfifyMod (state,selfify) (NONE,m)
		       in  MOD_FUNCTOR(a,v,s1',m',s2')
		       end
		 | (MOD_STRUCTURE sbnds) =>
		       let val sbnds = do_sbnds (popt,selfify) (state, sbnds)
		       in  MOD_STRUCTURE sbnds
		       end
		 | (MOD_PROJECT (m,l)) => 
		       if selfify
			   then MOD_PROJECT(SelfifyMod (state,selfify) (NONE,m), l)
		       else mod_subst_allproj(ehandler state, chandler state, 
					      mhandler state, fn _ => NONE) module
		 | (MOD_VAR v) => 
		       if selfify
			   then mod_subst_conmodvar(module,#conself state, #modself state)
		       else mod_subst_allproj(ehandler state, chandler state, 
					      mhandler state, fn _ => NONE) module
		 | _ => error "selfify_mod' given a mod which is not a functor or structure")
	   end

       and SelfifySig (state:state,selfify) (popt: path option, signat : signat) : signat = 
	   (case (selfify,signat) of
		(_,SIGNAT_FUNCTOR (v,s1,s2,a)) => 
		    if (selfify andalso isempty_state state)
			then signat
		    else let val s1' = SelfifySig (state,selfify) (NONE,s1)
			     val s2' = SelfifySig (state,selfify) (NONE,s2)
			 in  SIGNAT_FUNCTOR(v,s1',s2',a)
			 end
	      | (_,SIGNAT_STRUCTURE (NONE,sdecs)) =>
			 let val sdecs' = do_sdecs (popt,selfify) (state, sdecs)
			     val popt = if selfify then popt else NONE
			 in  SIGNAT_STRUCTURE(popt,sdecs')
			 end
	      | (false,SIGNAT_STRUCTURE (SOME _,sdecs)) =>
			 let val sdecs' = do_sdecs (popt,selfify) (state, sdecs)
			     val popt = if selfify then popt else NONE
			 in  SIGNAT_STRUCTURE(popt,sdecs')
			 end
(* re-selfifying old paths; but what about other components *)
	      | (true,s as SIGNAT_STRUCTURE (SOME p,sdecs)) =>
			 (case popt of
			      SOME p' => if (eq_path(p,p'))
					     then s
					 else SelfifySig (state,selfify) 
					     (popt, SIGNAT_STRUCTURE(NONE,sdecs))
			    | _ => s)
	      | (_, SIGNAT_VAR v) => SelfifySig (state,selfify) (popt,reduce_sigvar(#ctxt state,v))
	      | (_, SIGNAT_OF m) => 
			      let val m' = SelfifyMod(state,selfify) (NONE, m)
				  val _ = if (not selfify)
					      then (print "UNSELFIFY SIGNAT_OF: m = ";
						    pp_mod m; print "\n         m' = ";
						    pp_mod m'; print "\nstate = \n";
						    show_state state; print "\n")
					  else ()
			      in  SIGNAT_OF m'
			      end)

   in
       fun SelfifySig' ctxt = SelfifySig (initial_state ctxt, true)
       fun UnselfifySig' ctxt = SelfifySig (initial_state ctxt, false)
   end

     (* Performs lookup in a structure signature, performing
        normalization as needed with the supplied module argument. *)
    local
	fun wrap vm NONE = NONE
	  | wrap vm (SOME pc) = 
	    SOME(case pc of
		     PHRASE_CLASS_EXP(e,c,eopt,inline) => 
			 PHRASE_CLASS_EXP(e,con_subst_modvar(c,[vm]),
					  (case eopt of
					       NONE => NONE
					     | SOME e => SOME(exp_subst_modvar(e,[vm]))),
					       inline)
		   | PHRASE_CLASS_CON(c,k,copt,inline) => 
			 PHRASE_CLASS_CON(c,k,
					  (case copt of
					       NONE => NONE
					     | SOME c => SOME(con_subst_modvar(c,[vm]))),
					       inline)
		   | PHRASE_CLASS_MOD(m,b,s) => PHRASE_CLASS_MOD(mod_subst_modvar(m,[vm]),b,
							         sig_subst_modvar(s,[vm]))
		   | _ => pc)

	fun local_Sdecs_Project ctxt (mopt, sdecs, l) = 
	    let
		fun bad () = (print "local_Sdecs_Project failed on ";
			      pp_label l;
			      print "\n";
			      print "and sdecs = ";
			      pp_sdecs sdecs;
			      print "\n";
			      error "local_Sdecs_Project failed")
		fun exper l = (case mopt of
				   NONE => bad()
				 | SOME m => MODULE_PROJECT(m,l))
		fun coner l = (case mopt of
				   NONE => bad()
				 | SOME m => CON_MODULE_PROJECT(m,l))
		fun moder l = (case mopt of
				   NONE => bad()
				 | SOME m => MOD_PROJECT(m,l))
		fun eh et (VAR v) = mapopt exper (assoc_eq (eq_var,v,et))
		  | eh et _ = NONE
		fun ch ct (CON_VAR v) = mapopt coner (assoc_eq (eq_var,v,ct))
		  | ch ct _ = NONE
		fun mh mt (MOD_VAR v) = mapopt moder (assoc_eq (eq_var,v,mt))
		  | mh mt _ = NONE
		fun externalize (et,ct,mt) dec =
		    case dec of
			(DEC_MOD(_,_,s)) => SOME(CLASS_MOD(sig_all_handle(eh et,ch ct,mh mt, fn _ => NONE) s))
		      | (DEC_EXP(_,c,_,_)) => SOME(CLASS_EXP(con_all_handle(eh et,ch ct,mh mt, fn _ => NONE) c))
		      | (DEC_CON(_,k,_,_)) => SOME(CLASS_CON k)
		fun extend (et,ct,mt) (l,DEC_MOD(v,_,_)) = (et,ct,(v,l)::mt)
		  | extend (et,ct,mt) (l,DEC_EXP(v,_,_,_)) = ((v,l)::et,ct,mt)
		  | extend (et,ct,mt) (l,DEC_CON(v,_,_,_)) = (et,(v,l)::ct,mt)
		fun loop t [] = NONE
		  | loop t ((SDEC(l',dec))::rest) = if (eq_label(l,l')) 
							then externalize t dec
						    else loop (extend t (l',dec)) rest
	    in loop ([],[],[]) sdecs
	    end
    in					     

	val local_Sdecs_Project = local_Sdecs_Project

	fun UnselfifySig ctxt (p : path, signat : signat) = 
	    UnselfifySig' ctxt (SOME p,signat)

	fun SelfifySig ctxt (p : path, signat : signat) = 
	    let val res = SelfifySig' ctxt (SOME p,signat)
		val _ = debugdo 
		    (fn () => (print "SelfifySig': p is "; pp_path p;
			       print "\nsignat is\n";
			       pp_signat signat; print "\n\nand returning res:\n";
			       pp_signat res; print "\n\n"))
	    in res
	    end
	fun SelfifyDec ctxt (DEC_MOD (v,b,s)) = DEC_MOD(v,b,SelfifySig ctxt (PATH(v,[]),s))
	  | SelfifyDec ctxt dec = dec
	fun SelfifySdec ctxt (SDEC (l,dec)) = SDEC(l,SelfifyDec ctxt dec)
	fun SelfifySdecs ctxt (p : path, sdecs : sdecs) =
	    case (SelfifySig ctxt (p,SIGNAT_STRUCTURE(NONE,sdecs))) of
		SIGNAT_STRUCTURE (SOME _,sdecs) => sdecs
	      | _ => error "SelfifySdecs: SelfifySig returned non-normal structure"
	fun SelfifyEntry ctxt (CONTEXT_SDEC sdec) = CONTEXT_SDEC(SelfifySdec ctxt sdec)
	  | SelfifyEntry ctxt ce = ce
    end



   (* ------- checks for the syntactic valuability of ------- *)
   fun Exp_IsSyntacticValue exp = 
     (case exp of
	SCON _ => true
      | PRIM _ => true
      | ILPRIM _ => true
      | VAR _ => true
      | MODULE_PROJECT(m,_) => Option.isSome(mod2path m)
      | RECORD rbnds => foldr (fn (a,b) => a andalso b) true 
	                (map (fn (l,e) => Exp_IsSyntacticValue e) rbnds)
      | FIX _ => true
      | INJ {inject=NONE,...} => true
      | INJ {inject=SOME e,...} => Exp_IsSyntacticValue e
      | _ => false)
   and Module_IsSyntacticValue module = 
      (case module of
	 MOD_STRUCTURE sbnds => foldr (fn (a,b) => a andalso b) true 
	                        (map (fn SBND(l,b) => Bnd_IsSyntacticValue b) sbnds)
       | MOD_LET (v,m1,m2) => (Module_IsSyntacticValue m1) andalso (Module_IsSyntacticValue m2)
       | (MOD_FUNCTOR _) => true
       | _ => false)
   and Bnd_IsSyntacticValue bnd = 
     (case bnd of
       BND_EXP (_,e) => Exp_IsSyntacticValue e
     | BND_MOD (_,_,m) => Module_IsSyntacticValue m
     | BND_CON (_,c) => true)





   (* --------- structural equality on scons, kinds ------------ *)
   fun eq_scon (s1,s2) = s1 = s2
   fun eq_kind (KIND_TUPLE n1, KIND_TUPLE n2) = n1 = n2
     | eq_kind (KIND_ARROW (m1,n1), KIND_ARROW(m2,n2)) = (m1 = m2) andalso (n1 = n2)
     | eq_kind _ = false


   (* ---------------------------------------------------------------
      oneshot arrow unifier: note that unset does NOT unify with unset
     ---------------------------------------------------------------- *)
   fun eq_arrow(ax,ay,is_sub) = (ax = ay) orelse (is_sub andalso ax = TOTAL)
   fun eq_comp (comp1,comp2,is_sub) = 
       (case (oneshot_deref comp1,oneshot_deref comp2) of
	    (SOME x, SOME y) => (x = y) orelse (is_sub andalso x = TOTAL)
	  | (SOME x, NONE) => (oneshot_set(comp2,x); true)
	  | (NONE, SOME x) => (oneshot_set(comp1,x); true)
	  | (NONE, NONE) => ((eq_oneshot(comp1,comp2)) orelse
			     (oneshot_set(comp1,PARTIAL); 
			      oneshot_set(comp2,PARTIAL); true)))
   fun eq_onearrow (a1,a2) = eq_comp(a1,a2,false)


   (* ------------------------------------------------------------ 
      type (sub)-equality:
	 First, normalize argument types:
           (1) a module projection whose type is known to the known type
           (2) beta-reducing constructor function application
	   (3) overloaded type expression to the carried type
         Then, performs structural equality except when a type variable.
	 When a type variable is encountered, the unifier routine
	     is called with the type variable and the given type.
	     The unifier may be side-effecting or not.
    -------------------------------------------------------------- *)
   (* XXXX we are not able to undo the effects of the con_constrain *)
   fun constrain_tyvars_flexes(bools_tyvars,flexes,
			       {gen_constrain,eq_constrain,constrain_ctxts,stamp}) = 
      let
	 fun do_tyvar (is_ref,tv) = 
	     let 
		 val _ = if gen_constrain then tyvar_constrain tv else ()
		 val _ = if (eq_constrain andalso not is_ref)
			     then tyvar_use_equal tv else ()
		 val _ = tyvar_addctxts(tv,constrain_ctxts)
		 val _ = update_stamp(tv,stamp)
	     in  ()
	     end
	 fun do_flex (r as (ref (FLEXINFO (st,resolved,rdecs)))) =
	     r := FLEXINFO(stamp_join(stamp,st),resolved,rdecs)
	   | do_flex (ref (INDIRECT_FLEXINFO rf)) = do_flex rf
      in  app do_tyvar bools_tyvars;
	  app do_flex flexes
      end
  
   fun unify_maker () = 
     let 
       val table = ref ([] : {saved : (context,con) tyvar, active : (context,con) tyvar} list)
       fun fetch tv = tyvar_deref tv
       fun set (tyvar,c) = 
	   let 

	       val _ = (case (fetch tyvar) of
			    NONE => ()
			  | (SOME c') => error "cannot set an already set tyvar")
	       val same_tyvar = (case c of
				     CON_TYVAR tv => eq_tyvar(tv,tyvar)
				   | _ => false)
	   in if (same_tyvar)
		  then ()
	      else 
		  let 
		      val (tyvars,flexes) = find_tyvars_flexes c

		      val _ =  if (!showing)
				   then (print "setting "; 
					 pp_con (CON_TYVAR tyvar); print "\n  to "; 
					 pp_con c; print "\n";
					 print "  tyvars are "; 
					 app (fn (_,tv) => (pp_con (CON_TYVAR tv); 
							    print "  ")) tyvars;
					 print "\n\n")
			       else ()

		  in  if (Listops.member_eq(eq_tyvar,tyvar,map #2 tyvars)) (* occurs check *)
			  then print "Fails occurs check\n"
		      else 
			  let 
			      val tyvar_ctxts = tyvar_getctxts tyvar
			  in  if (map (fn ctxt => GetConKind(c,ctxt)) tyvar_ctxts; false
				  handle _ => true)
				  then print "Fails well-formed in tyvar contexts"
			      else 
				  let val _ = constrain_tyvars_flexes
					         (tyvars,flexes,
						  {gen_constrain = tyvar_isconstrained tyvar,
						   eq_constrain = tyvar_is_use_equal tyvar,
						   stamp = tyvar_stamp tyvar,
						   constrain_ctxts = tyvar_ctxts})
				      val entry = {saved = tyvar_copy tyvar, active = tyvar}
				      val _ = table := (entry::(!table))
				  in  tyvar_set(tyvar,c)
				  end
			  end	     
		  end;
               true
	   end
       (* Undo is not undoing effects of constrain operations *)
       fun undo() = app (fn {saved,active} => tyvar_update(active,saved)) (!table)
     in  (set, undo)
     end

   and eq_con (ctxt, con1, con2) = 
       let val (setter,undo) = unify_maker()
       in  meta_eq_con (setter,false) (con1, con2, ctxt)
       end

   and sub_con (arg as (ctxt, con1, con2)) = 
       let fun msg() = (print "subcon called with con1 = \n";
			pp_con con1; print "\nand con2 = \n";
			pp_con con2; print "\n")
	   val (setter,undo) = unify_maker()
       in  meta_eq_con (setter,true) (con1, con2, ctxt)
       end

   and soft_eq_con (ctxt,con1,con2) = 
       let val (setter,undo) = unify_maker()
	   val is_eq = meta_eq_con (setter,false) (con1,con2,ctxt)
	   val _ = undo()
       in  is_eq
       end

   and semi_sub_con (ctxt,con1,con2) = 
       let val (setter,undo) = unify_maker()
	   val is_eq = meta_eq_con (setter,true) (con1,con2,ctxt)
	   val _ = if is_eq then () else undo()
       in  is_eq
       end

   and meta_eq_con (setter,is_sub) (con1,con2,ctxt) = 
       let val self = meta_eq_con (setter, is_sub)
	   val _ = if (!showing)
		       then (print "eq_con called on:-------------\n";
			     print "con1 = "; pp_con con1; print "\n";
			     print "con2 = "; pp_con con2; print "\n")
		   else ()
       in
	   case (con1,con2) of
	       (CON_TYVAR tv1, CON_TYVAR tv2) => 
		   (eq_tyvar(tv1,tv2) orelse
		    (case tyvar_deref tv1 of
			 NONE => setter(tv1,con2)
		       | SOME c => self (c,con2,ctxt)))
	     | (CON_TYVAR tv1, _) => 
		   (case tyvar_deref tv1 of
			NONE => setter(tv1,con2)
		      | SOME c => self (c,con2,ctxt))
	     | (_, CON_TYVAR tv2) =>
		   (case tyvar_deref tv2 of
			NONE => setter(tv2,con1)
		      | SOME c => self (con1,c,ctxt))
	     | _ =>
		   let val same = 
		       (case (con1,con2) of
			    (CON_APP(c1,a1),CON_APP(c2,a2)) =>
				(self (c2,c1,ctxt)
				 andalso self (a1,a2,ctxt))
			  | _ => eq_cpath(con1,con2))
		   in  same orelse
		       let val (_, con1, path1) = HeadNormalize(con1,ctxt)
			   val (_, con2, path2) = HeadNormalize(con2,ctxt)
		       in  meta_eq_con_hidden (setter,is_sub) (con1,con2,ctxt)
		       end
		   end
       end


   (* ------------ con1 and con2 are head-normalized *)
   and meta_eq_con_hidden (setter,is_sub) (con1,con2,ctxt) = 
     let 
	 val self = meta_eq_con (setter, is_sub)

       (* the flex record considered as an entirety is not generalizeable
	  but its subparts are generalizable *)
       fun dorecord () =
		let 
		    fun match rdecs1 rdecs2 = 
			let fun help ((l1,c1),(l2,c2)) = eq_label(l1,l2) 
			    andalso self(c1,c2,ctxt)
			in  eq_list(help,rdecs1,rdecs2)
			end
		    local
			fun check_one addflag (l,c) rdecs =
			    let 
				fun loop [] = if addflag then SOME((l,c)::rdecs) else NONE
				  | loop ((l',c')::rest) = 
				    if (eq_label(l,l'))
					(* do we need to flip arguments for subbing *)
					then if (self(c,c',ctxt))
					     then SOME rdecs
					     else NONE
				    else loop rest
			    in loop rdecs
			    end
		    in
			fun union [] rdecs = SOME(sort_labelpair rdecs)
			  | union (rdec::rest) rdecs = 
			    (case (check_one true rdec rdecs) of
				 NONE => NONE
			   | SOME x => (union rest x))
			fun subset ([]) rdecs = true
			  | subset (rdec::rest) rdecs = 
			    (case (check_one false rdec rdecs) of
				 NONE => false
			       | SOME _ => subset rest rdecs)  (* _ should be same as rdecs here *)
		    end
		    fun stamp_constrain stamp rdecs = 
			let val temp = CON_RECORD rdecs
			    val (tyvars, flexes) = find_tyvars_flexes temp
			in  constrain_tyvars_flexes(tyvars,flexes,
						    {gen_constrain = false,
						     eq_constrain = false,
						     stamp = stamp,
						     constrain_ctxts = []})
			end
		    fun follow (CON_FLEXRECORD (ref (INDIRECT_FLEXINFO rf))) = follow (CON_FLEXRECORD rf)
		      | follow (CON_FLEXRECORD (ref (FLEXINFO (_,true,rdecs)))) = CON_RECORD rdecs
		      | follow c = c
		in (case (follow con1, follow con2) of
			(CON_RECORD r1, CON_RECORD r2) => match r1 r2
		      | (CON_RECORD rdecs, CON_FLEXRECORD(r as ref(FLEXINFO(stamp,false,flex_rdecs)))) =>
			((subset flex_rdecs rdecs) andalso (stamp_constrain stamp rdecs;
							    r := FLEXINFO(stamp,true,rdecs);
							    true))
		      | (CON_FLEXRECORD(r as ref(FLEXINFO(stamp,false,flex_rdecs))),CON_RECORD rdecs) =>
			((subset flex_rdecs rdecs) andalso (stamp_constrain stamp rdecs;
							    r := FLEXINFO(stamp,true,rdecs);
							    true))
		      | (CON_FLEXRECORD(ref1 as (ref (FLEXINFO (stamp1,false,rdecs1)))),
			 CON_FLEXRECORD(ref2 as (ref (FLEXINFO (stamp2,false,rdecs2))))) => 
			(case (union rdecs1 rdecs2) of
			     NONE => false
			   | SOME rdecs => (let val stamp = stamp_join(stamp1,stamp2)
						val _ = stamp_constrain stamp rdecs
						val flex = FLEXINFO(stamp,false,rdecs)
						val indirect_flex = INDIRECT_FLEXINFO ref2
						val _ = ref1 := indirect_flex
						val _ = ref2 := flex
					    in true
					    end))
		       | _ => error "must have a CON_RECORD or CON_FLEXRECORD here")
		end

     in
	 (case (con1,con2) of
	    (CON_TYVAR _, _) => self(con1,con2,ctxt)
	  | (_, CON_TYVAR _) => self(con1,con2,ctxt)
	  | (CON_VAR v1, CON_VAR v2) => eq_var(v1,v2)
	  | (CON_APP(c1_a,c1_r), CON_APP(c2_a,c2_r)) => self(c1_a,c2_a,ctxt) 
	                                                andalso self(c1_r,c2_r,ctxt)
	  | (CON_MODULE_PROJECT (m1,l1), CON_MODULE_PROJECT (m2,l2)) => eq_cpath(con1,con2)
	  | (CON_INT is1, CON_INT is2) => is1 = is2
	  | (CON_UINT is1, CON_UINT is2) => is1 = is2
	  | (CON_FLOAT fs1, CON_FLOAT fs2) => fs1 = fs2
	  | (CON_ANY, CON_ANY) => true
	  | (CON_ARRAY c1, CON_ARRAY c2) => self(c1,c2,ctxt)
	  | (CON_VECTOR c1, CON_VECTOR c2) => self(c1,c2,ctxt)
	  | (CON_REF c1, CON_REF c2) => self(c1,c2,ctxt)
	  | (CON_TAG c1, CON_TAG c2) => self(c1,c2,ctxt)
	  | (CON_ARROW (c1_a,c1_r,flag1,comp1), CON_ARROW(c2_a,c2_r,flag2,comp2)) => 
		(flag1 = flag2 
		 andalso eq_comp(comp1,comp2,is_sub)
		 andalso (length c1_a = length c2_a andalso
			  Listops.andfold (fn (c2,c1) => self (c2,c1,ctxt)) (zip c1_a c2_a))
		 andalso self(c1_r,c2_r,ctxt))
	  | (CON_MU c1, CON_MU c2) => (self(c1,c2,ctxt))
	  | (CON_RECORD _, CON_RECORD _) => dorecord()
	  | (CON_RECORD _, CON_FLEXRECORD _) => dorecord()
	  | (CON_FLEXRECORD _, CON_RECORD _) => dorecord()
	  | (CON_FLEXRECORD _, CON_FLEXRECORD _) => dorecord()
	  | (CON_FUN (vs1,c1), CON_FUN(vs2,c2)) => 
		(length vs1 = length vs2) andalso
		let fun folder (v,acc) = add_context_con'(acc,v,KIND_TUPLE 1, NONE)
		    val ctxt' = foldl folder ctxt vs1
		    val table = map2 (fn (v1,v2) => (v2,CON_VAR v1)) (vs1,vs2)
		    val c2' = con_subst_convar(c2,table)
		in self(c1,c2',ctxt')
		end
	  | (CON_SUM {names=n1,noncarriers=nc1,carrier=c1,special=i1},
	     CON_SUM {names=n2,noncarriers=nc2,carrier=c2,special=i2}) =>
		let val special = (i1=i2) orelse (i2=NONE andalso is_sub)
		    val res = special andalso (eq_list(eq_label,n1,n2)) andalso
		              (nc1=nc2) andalso self(c1,c2,ctxt)
		in  res
		end
	  | (CON_TUPLE_INJECT cs1, CON_TUPLE_INJECT cs2) => 
		eq_list (fn (a,b) => self(a,b,ctxt), cs1, cs2)
	  | (CON_TUPLE_PROJECT (i1, c1), CON_TUPLE_PROJECT(i2,c2)) => 
		(i1 =i2) andalso (self(c1,c2,ctxt))
	  | _ => false)

     end




   and Exp_IsValuable(ctxt,exp) =
     (Exp_IsSyntacticValue exp) orelse
     (case exp of
	MODULE_PROJECT (m,l) => Module_IsValuable m ctxt
      | APP(e1,e2) => let val (va1,e1_con) = GetExpCon(e1,ctxt)
			  val (va2,e2_con) = GetExpCon(e1,ctxt)
			  val _ = (print "exp_isvaluable: app case: e1_con is: \n";
				   Ppil.pp_con e1_con; print "\n")
			  val e1_con_istotal = 
			      (case e1_con of
				   CON_ARROW(_,_,_,comp) => eq_comp(comp,oneshot_init TOTAL,false)
				 | _ => false)
		      in va1 andalso e1_con_istotal andalso va2
		      end
      | EXTERN_APP(_,e1,es2) => let val (va1,e1_con) = GetExpCon(e1,ctxt)
			  val _ = (print "exp_isvaluable: app case: e1_con is: \n";
				   Ppil.pp_con e1_con; print "\n")
			  val e1_con_istotal = 
			      (case e1_con of
				   CON_ARROW(_,_,_,comp) => eq_comp(comp,oneshot_init TOTAL,false)
				 | _ => false)
		      in va1 andalso e1_con_istotal
			  andalso (Listops.andfold (fn e2 => Exp_IsValuable (ctxt,e2)) es2)
		      end
     | RECORD rbnds => foldr (fn (a,b) => a andalso b) true 
                       (map (fn (_,e) => Exp_IsValuable(ctxt,e)) rbnds)
     | RECORD_PROJECT(e,_,_) => Exp_IsValuable(ctxt,e)
     | LET (bnds,e) => (case (Bnds_IsValuable' bnds ctxt) of 
			  NONE => false
			| SOME ctxt' => Exp_IsValuable(ctxt',e))
     | ROLL (c,e) => Exp_IsValuable(ctxt,e)
     | UNROLL (c1,c2,e) => Exp_IsValuable(ctxt,e)
     | OVEREXP (_,v,os) => v orelse (case (oneshot_deref os) of
				       NONE => false
				     | SOME e => Exp_IsValuable(ctxt,e))
     | NEW_STAMP _ => true
     | SUM_TAIL (_,_,e) => Exp_IsValuable(ctxt,e)
     | EXN_INJECT(_,e1,e2) => (Exp_IsValuable(ctxt,e1)) andalso (Exp_IsValuable(ctxt,e2))
     | _ => false)

   (* Rules 140 - 143 *)
   and Bnds_IsValuable' [] ctxt = SOME ctxt
     | Bnds_IsValuable' (bnd::rest) ctxt = 
       let val self = Bnds_IsValuable' rest
       in  (case bnd of
		BND_EXP (v,e) => if (Exp_IsValuable(ctxt,e))
				     then self (add_context_exp'(ctxt,v,#2 (GetExpCon(e,ctxt))))
				 else NONE
	      | BND_MOD (v,_,m) => let val (va,s) = GetModSig(m,ctxt)
				     val s' = SelfifySig ctxt (PATH(v,[]),s)
				 in if va then self (add_context_mod'(ctxt,v,s'))
				    else NONE
				 end
	      | BND_CON (v,c) => self (add_context_con'(ctxt,v,GetConKind(c,ctxt),SOME c)))
       end

   and Bnds_IsValuable bnds ctxt = (case (Bnds_IsValuable' bnds ctxt) of
					NONE => false
				      | SOME decs => true)
   and Sbnds_IsValuable sbnds ctxt = Bnds_IsValuable (map (fn (SBND(_,b)) => b) sbnds) ctxt
     
   (* Rules 144 - 147 *)
   and Module_IsValuable m ctxt =
     (Module_IsSyntacticValue m) orelse
     (case m of
       MOD_VAR v => true
     | MOD_STRUCTURE sbnds => Sbnds_IsValuable sbnds ctxt
     | MOD_LET (v,m1,m2) => let val (va1,s1) = GetModSig(m1,ctxt)
			    in va1 andalso
				(Module_IsValuable m2 (add_context_mod'(ctxt,v,
									   SelfifySig ctxt (PATH(v,[]),s1))))
			    end
     | MOD_PROJECT (m,l) => Module_IsValuable m ctxt
     | MOD_APP (m1,m2) => let val (va1,s1) = GetModSig(m1,ctxt)
			  in case s1 of
			      SIGNAT_FUNCTOR(_,_,_,TOTAL) =>
				  va1 andalso (Module_IsValuable m2 ctxt)
			    | _ => false
			  end
     | _ => false)
	
   and GetSconCon(ctxt,scon) : con = IlPrimUtil.value_type (fn e => #2(GetExpCon(e,ctxt))) scon


  (* Rules 35 - 48 *)
   and GetConKind (arg : con, ctxt : context) : kind = 
     let fun msg() = (print "GetConKind called with con = \n";
			 pp_con arg; print "\n")
	val _ = debugdo msg
     in GetConKind'(arg,ctxt)
	  handle e => (if !trace then msg() else (); raise e)
     end

   and GetConKind' (con : con, ctxt : context) : kind = 
      (case con of
       (CON_TYVAR tv) => KIND_TUPLE 1 
     | (CON_VAR v) => 
	   (case Context_Lookup'(ctxt,v) of
		SOME(_,PHRASE_CLASS_CON(_,k,_,_)) => k
	      | SOME _ => error ("CON_VAR " ^ (var2string v) ^ " not bound to a con")
	      | NONE => error ("CON_VAR " ^ (var2string v) ^ " not bound"))
     | (CON_OVAR ocon) => KIND_TUPLE 1
     | (CON_INT _) => KIND_TUPLE 1
     | (CON_FLOAT _) => KIND_TUPLE 1
     | (CON_UINT _) => KIND_TUPLE 1
     | (CON_ANY) => KIND_TUPLE 1
     | (CON_REF _) => KIND_TUPLE 1
     | (CON_ARRAY _) => KIND_TUPLE 1
     | (CON_VECTOR _) => KIND_TUPLE 1
     | (CON_TAG _) => KIND_TUPLE 1
     | (CON_ARROW _) => KIND_TUPLE 1
     | (CON_APP (c1,c2)) => 
	   let val (k1,k2) = (GetConKind(c1,ctxt),GetConKind(c2,ctxt))
	   in (case (k1, k2) of
		   (KIND_ARROW(a,b),KIND_TUPLE c) => 
		       if (a=c) then KIND_TUPLE b
		       else (print "GetConKind: kind mismatch in "; pp_con con;
			     print "\nDomain arity = "; print (Int.toString a);
			     print "\nArgument arity = "; print (Int.toString c); print "\n";
			     error "GetConKind: kind mismatch in CON_APP")
		 | (k1,k2) => 
			(print "GetConKind: kind mismatch in "; pp_con con;
			     print "\nFunction kind = "; pp_kind k1;
			     print "\nArgument kind = "; pp_kind k2; print "\n";
			     error "GetConKind: kind mismatch in CON_APP"))
	   end
     | (CON_MU c) => (case GetConKind(c,ctxt) of
			KIND_ARROW(m,n) => KIND_TUPLE n
			| _ => error "kind of CON_MU argument not KIND_ARROW")
     | (CON_FLEXRECORD _) => KIND_TUPLE 1
     | (CON_RECORD _) => KIND_TUPLE 1
     | (CON_FUN (vs,c)) => 
	   let fun folder(v,ctxt) = add_context_con'(ctxt,v,KIND_TUPLE 1,NONE)
	       val ctxt' = foldl folder ctxt vs
	   in (case GetConKind(c,ctxt') of
		   KIND_TUPLE n => KIND_ARROW(length vs,n)
		 | (KIND_ARROW _) => error "kind of constructor body not a KIND_TUPLE")
	   end
     | (CON_SUM _) => KIND_TUPLE 1
     | (CON_TUPLE_INJECT [_]) => error "Cannot CON_TUPLE_INJECT one con"
     | (CON_TUPLE_INJECT cs) => KIND_TUPLE (length cs)
     | (CON_TUPLE_PROJECT (i,c)) => (case (GetConKind(c,ctxt)) of
				       KIND_TUPLE n =>
					 (if (i >= 0 andalso i < n)
					    then KIND_TUPLE 1
					  else
					    (print "GetConKind got: ";
					     pp_con con;
					     print "\n";
					     error "got CON_TUPLE_PROJECT in GetConKind"))
				     | k => (print "GetConKind got: ";
					     pp_con con;
					     print "\nwith kind";
					     pp_kind k;
					     print "\n";
					     error "got CON_TUPLE_PROJECT in GetConKind"))
     | (CON_MODULE_PROJECT (m,l)) => 
	   let val (_,signat) = GetModSig(m,ctxt)
	       val (self,sdecs) = 
		   (case (reduce_signat ctxt signat) of
			SIGNAT_STRUCTURE (self,sdecs) => (self,sdecs)
		      | SIGNAT_FUNCTOR _ => error "cannot project from functor"
		      | _ => error "signat_var or signat_of not reduce")
	   in  (case Sdecs_Lookup ctxt (MOD_VAR (fresh_var()),sdecs,[l]) of
		    NONE => (print "no such label = ";
			     pp_label l; print " in sig \n";
			     Ppil.pp_signat (SIGNAT_STRUCTURE(self,sdecs));
			     print "\n";
			     error "no such label in sig")
		  | SOME(_,PHRASE_CLASS_CON(_,k,_,_)) => k
		  | _ => error "label in sig not a DEC_CON")
	   end)


   and GetConKindFast (con : con, ctxt : context) : kind = 
      (case con of
       (CON_TYVAR tv) => KIND_TUPLE 1 
     | (CON_VAR v) => 
	   (case Context_Lookup'(ctxt,v) of
		SOME(_,PHRASE_CLASS_CON(_,k,_,_)) => k
	      | SOME _ => error ("CON_VAR " ^ (var2string v) ^ " not bound to a con")
	      | NONE => error ("CON_VAR " ^ (var2string v) ^ " not bound"))
     | (CON_OVAR ocon) => KIND_TUPLE 1
     | (CON_INT _) => KIND_TUPLE 1
     | (CON_FLOAT _) => KIND_TUPLE 1
     | (CON_UINT _) => KIND_TUPLE 1
     | (CON_ANY) => KIND_TUPLE 1
     | (CON_REF _) => KIND_TUPLE 1
     | (CON_ARRAY _) => KIND_TUPLE 1
     | (CON_VECTOR _) => KIND_TUPLE 1
     | (CON_TAG _) => KIND_TUPLE 1
     | (CON_ARROW _) => KIND_TUPLE 1
     | (CON_APP (c1,c2)) => 
	   let val k = GetConKindFast(c1,ctxt)
	   in (case k of
		   KIND_ARROW(a,b) =>KIND_TUPLE b
		 | _ => 
			(print "GetConKindFast: kind mismatch in "; pp_con con;
			 print "\nFunction kind = "; pp_kind k;
			 error "GetConKindFast: kind mismatch in CON_APP"))
	   end
     | (CON_MU c) => (case GetConKindFast(c,ctxt) of
			KIND_ARROW(m,n) => KIND_TUPLE n
			| _ => error "kind of CON_MU argument not KIND_ARROW")
     | (CON_FLEXRECORD _) => KIND_TUPLE 1
     | (CON_RECORD _) => KIND_TUPLE 1
     | (CON_FUN (vs,c)) => 
	   let fun folder(v,ctxt) = add_context_con'(ctxt,v,KIND_TUPLE 1,NONE)
	       val ctxt' = foldl folder ctxt vs
	   in (case GetConKindFast(c,ctxt') of
		   KIND_TUPLE n => KIND_ARROW(length vs,n)
		 | (KIND_ARROW _) => error "kind of constructor body not a KIND_TUPLE")
	   end
     | (CON_SUM _) => KIND_TUPLE 1
     | (CON_TUPLE_INJECT [_]) => error "Cannot CON_TUPLE_INJECT one con"
     | (CON_TUPLE_INJECT cs) => KIND_TUPLE (length cs)
     | (CON_TUPLE_PROJECT (i,c)) => (case (GetConKindFast(c,ctxt)) of
				       KIND_TUPLE n =>
					 (if (i >= 0 andalso i < n)
					    then KIND_TUPLE 1
					  else
					    (print "GetConKind got: ";
					     pp_con con;
					     print "\n";
					     error "got CON_TUPLE_PROJECT in GetConKindFast"))
				     | k => (print "GetConKindFast got: ";
					     pp_con con;
					     print "\nwith kind";
					     pp_kind k;
					     print "\n";
					     error "got CON_TUPLE_PROJECT in GetConKindFast"))
     | (CON_MODULE_PROJECT (m,l)) => 
	   let val (_,signat) = GetModSig(m,ctxt)
	       val (self,sdecs) = 
		   (case (reduce_signat ctxt signat) of
			SIGNAT_STRUCTURE (self,sdecs) => (self,sdecs)
		      | SIGNAT_FUNCTOR _ => error "cannot project from functor"
		      | _ => error "signat_var or signat_of not reduced")
	   in  (case Sdecs_Lookup ctxt (MOD_VAR (fresh_var()),sdecs,[l]) of
		    NONE => (print "no such label = ";
			     pp_label l; print " in sig \n";
			     Ppil.pp_signat (SIGNAT_STRUCTURE(self,sdecs));
			     print "\n";
			     error "no such label in sig")
		  | SOME(_,PHRASE_CLASS_CON(_,k,_,_)) => k
		  | _ => error "label in sig not a DEC_CON")
	   end)



   (* --------- Rules 69 to 96 ----------- *)
   and GetExpCon (exparg,ctxt) : bool * con = 
     let fun msg() = (print "GetExpCon called with exp = \n";
			 pp_exp exparg; print "\n")
	val _ = debugdo msg
     in GetExpCon'(exparg,ctxt) 
	  handle e => (if !trace then msg() else (); raise e)
     end

  and etaize c = (case c of
		      CON_ARROW([c],rescon,b,a) => CON_ARROW([c],rescon,b,a)
		    | CON_ARROW(cons,rescon,b,a) => CON_ARROW([con_tuple cons],rescon,b,a)
		    | _ => c)

   and GetExpAppCon' (exparg,ctxt) : bool * con = 
	   let val ((va1,con1),es2) = 
	       (case exparg of
		    APP(e1,e2) => (GetExpCon(e1,ctxt),[e2])
		  | EXTERN_APP(_,e1,es2) => (GetExpCon(e1,ctxt),es2)
		  | PRIM(p,cs,es) => ((true, IlPrimUtil.get_type' p cs), es)
		  | ILPRIM(ip,cs,es) => ((true, IlPrimUtil.get_iltype' ip cs),es)
		  | _ => error "GetExpAppCon' got unexpected argument")
	       val (_,con1,_) = HeadNormalize(con1,ctxt)
	       val vacon2 = map (fn e => GetExpCon(e,ctxt)) es2
	       val va2 = Listops.andfold #1 vacon2
	       val cons2 = map #2 vacon2
	       val res_con = fresh_con ctxt
	       val (guesscon,arrow) = 
		   (case con1 of
			CON_ARROW(_,_,closed,arrow) => 
			    (CON_ARROW(cons2,res_con,closed,arrow),arrow)
		      | _ => (CON_ARROW (cons2,res_con,false,oneshot()), oneshot()))
	       val is_sub = sub_con(ctxt,guesscon,con1) 
	       val total = (case oneshot_deref arrow of
				NONE => false
			      | SOME PARTIAL => false
			      | SOME TOTAL => true)
	       val va = va1 andalso va2 andalso total
	   in  if is_sub
		   then (va,con_deref res_con)
	       else (print "\nfunction type is = "; pp_con con1;
		     (case cons2 of
			  [con2] => (print "\nargument type is = "; pp_con con2; print "\n")
			| _ => (print "\nargument types are = "; app pp_con cons2; print "\n"));
		     print "Type mismatch in expression application:\n";
		     pp_exp exparg;
		     error "Type mismatch in expression application")
	   end

   and GetExpRollCon' (ctxt,isroll,e,c) : bool * con = 
       let val (_,cNorm,_) = HeadNormalize(c,ctxt)
	   val (va,econ) = GetExpCon(e,ctxt)
	   val error = fn str => (print "typing roll/unroll expression:\n";
				  Ppil.pp_exp e;
				  print "\n";
				  error str)
	   val (i,cInner) = (case cNorm of
			       (CON_TUPLE_PROJECT(i,CON_MU cInner)) => (i, cInner)
	                     | CON_MU cInner => (0, cInner)
  	                     | _ => (print "\nUnnormalized Decoration of (UN)ROLL was ";
				   pp_con c; print "\n";
				   print "\nNormalized Decoration of (UN)ROLL was ";
				   pp_con cNorm; print "\n";
				   error "decoration of ROLL not a recursive type CON_MU or CON_TUPLE_PROJ(CON_MU)"))
       in (va,
	   (case GetConKind(cInner,ctxt) of
			KIND_ARROW(n,n') =>
			    (if ((n = n') andalso (0 <= i) andalso (i < n))
				 then 
				     let 
					 fun temp j = if n = 1 then cInner else CON_TUPLE_PROJECT(j,CON_MU cInner)
					 val contemp = CON_APP(cInner,con_tuple_inject(map0count temp n))
					 val con2 = if (n = 1) then contemp
						    else CON_TUPLE_PROJECT(i,contemp)
				     in
					 if isroll
					     then
						 (if (sub_con(ctxt,econ,con2))
						      then cNorm
						  else
						      (Ppil.pp_con econ; print "\n";
						       Ppil.pp_con con2; print "\n";
						      error "ROLL: expression type does not match decoration"))
					 else 
					     (if (eq_con(ctxt,econ,cNorm))
						  then #2(HeadNormalize(con2,ctxt))
					      else (print "UNROLL: expression type does not match decoration";
						    print "\necon = "; pp_con econ;
						    print "\ncNorm = "; pp_con cNorm;
						    print "\nctxt = "; pp_context ctxt;
						    error "UNROLL: expression type does not match decoration"))
				     end
			     else error "projected decoration has the wrong KIND_ARROW")
		      | _ => error "projected decoration has the wrong kind"))
       end

   and GetExpCon' (exparg,ctxt) : bool * con = 
     (case exparg of
       SCON scon => (true,GetSconCon(ctxt,scon))
     | OVEREXP (con,va,eone) => (case oneshot_deref eone of
				     SOME e => if va then (va,con)
					       else GetExpCon(e,ctxt)
				   | NONE => (va,con))
     | ETAPRIM (p,cs) => (true, etaize (IlPrimUtil.get_type' p cs))
     | ETAILPRIM (ip,cs) => (true, etaize(IlPrimUtil.get_iltype' ip cs))
     | (VAR v) => (case Context_Lookup'(ctxt,v) of
		       SOME(_,PHRASE_CLASS_EXP(_,c,_,_)) => (true,c)
		     | SOME _ => error "VAR looked up to a non-value"
		     | NONE => error ("GetExpCon: (VAR " ^ (Name.var2string v) ^ "v) not in context"))
     | (PRIM _) => GetExpAppCon' (exparg,ctxt)
     | (ILPRIM _) => GetExpAppCon' (exparg,ctxt)
     | (APP _) => GetExpAppCon' (exparg,ctxt)
     | (EXTERN_APP _) => GetExpAppCon' (exparg,ctxt)
     | (FIX (r,a,fbnds)) => (* must check that there are no function calls for TOTAL *)
	   let fun get_arm_type(FBND(_,_,c,c',_)) = CON_ARROW([c],c',false,oneshot_init a)
	       val res_type = (case fbnds of
				   [fbnd] => get_arm_type fbnd
				 | _ => con_tuple(map get_arm_type fbnds))
	       fun folder (FBND(v',v,c,c',e), ctxt) = 
		   add_context_exp'(ctxt,v',CON_ARROW([c],c',false,oneshot_init PARTIAL))
	       val full_ctxt = foldl folder ctxt fbnds
	       fun ttest lctxt (FBND(v',v,c,c',e)) =
		   let val (va,bodyc) = GetExpCon(e,add_context_exp'(lctxt,v,c))
		   in va andalso sub_con(lctxt,bodyc,c')
		   end
	       fun ptest lctxt (FBND(v',v,c,c',e)) =
		   let val (_,bodyc) = GetExpCon(e,add_context_exp'(lctxt,v,c))
		       val res = sub_con(lctxt,bodyc,c')
		       val _ = if res
				   then ()
			       else (print "ILSTATIC - ptest yielded false\n";
				     print "e = \n"; pp_exp e; print "\n";
				     print "c' = \n"; pp_con c'; print "\n";
				     print "bodyc = \n"; pp_con bodyc; print "\n")

		   in res
		   end
	   in (true,
	       case a of
	       PARTIAL => if (andfold (ptest full_ctxt) fbnds)
			      then res_type
			  else (print "could not type-check FIX expression:\n";
				pp_exp exparg;
				error "could not type-check FIX expression")
	     | TOTAL =>  if ((andfold (ttest ctxt) fbnds))
			     then res_type
			 else (print "could not type-check TOTALFIX expression:\n";
			       pp_exp exparg;
			       error "could not type-check TOTALFIX expression"))
	   end
     | (RECORD (rbnds)) => 
	   let fun help (l,e) = let val (va,c) = GetExpCon(e,ctxt)
				in (va,(l,c))
				end
	       val temp = map help rbnds
	       val va = andfold #1 temp
	       val rdecs = sort_labelpair(map #2 temp)
	   in (va, CON_RECORD rdecs)
	   end
     | (RECORD_PROJECT (exp,l,c)) => 
	   let 
	       val (va,con) = GetExpCon(exp,ctxt)
	       val con' = #2(HeadNormalize(con,ctxt))
	       fun RdecLookup (label,[]) = (print "RdecLookup could not find label ";
					    pp_label label; print "in type ";
					    pp_con con';
					    error "RdecLookup could not find label")
		 | RdecLookup (label,(l,c)::rest) = if eq_label(label,l) then c
						    else RdecLookup (label,rest)
	       fun chase (ref (FLEXINFO(_,_,rdecs))) = rdecs
		 | chase (ref (INDIRECT_FLEXINFO fr)) = chase fr
	   in (case con' of
		   (CON_RECORD rdecs) => (va,RdecLookup(l,rdecs))
		 | (CON_FLEXRECORD fr) => (va,RdecLookup(l,chase fr))
		 | _ => (print "Record Proj on exp not of type CON_RECORD; type = ";
			 pp_con con; print "\n";
			 error "Record Proj on exp not of type CON_RECORD"))
	   end
     | (SUM_TAIL (_,c,e)) => 
	   let val (va,con) = GetExpCon(e,ctxt)
	   in if (eq_con(ctxt,c,con)) 
		  then (case c of
			    CON_SUM{names,noncarriers,carrier,special=SOME i} => 
				if (i<noncarriers) 
				    then error "SUM_TAIL projecting noncarrier"
				else (va,CON_TUPLE_PROJECT((i-noncarriers),carrier))
			  | _ => error "adornment of SUM_TAIL not a CON_SUM(SOME _,...)")
	      else error "SUM_TAIL: adornment mismatches type of expression"
	   end
     | (HANDLE (body,handler)) => 
	   let val (_,bcon) = GetExpCon(body,ctxt)
	       val (_,hcon) = GetExpCon(handler,ctxt)
	       val res_con = fresh_con ctxt
	       val hcon' = CON_ARROW ([CON_ANY],res_con,false,oneshot())
	   in  if (eq_con(ctxt,hcon,hcon')) 
		   then (false,bcon)
	       else error "Type mismatch between handler and body of HANDLE"
	   end
     | (RAISE (c,e)) => 
	   let val (_,econ) = GetExpCon(e,ctxt)
	       val _ = (GetConKind(c,ctxt) 
		   handle _ => error "RAISE: con decoration ill-formed")
	   in (case econ of
		   CON_ANY => (false,c)
		 | _ => error "type of expression raised is not ANY")
	   end
     | (LET (bnds,e)) => 
	   let 
	       fun folder ((_,dec),ctxt) = add_context_dec(ctxt,SelfifyDec ctxt dec)
	       val vdecs = GetBndsDecs(ctxt,bnds)
	       val va_decs = andfold #1 vdecs
	       val ctxt' = foldl folder ctxt vdecs
	       val (va,econ) = GetExpCon(e,ctxt')
	   in (va andalso va_decs,econ)
	   end
     | (NEW_STAMP con) => ((GetConKind(con,ctxt); (true,CON_TAG con))
			   handle _ => error "NEW_STAMP: type is ill-formed")
     | (EXN_INJECT (_,e1,e2)) => 
	   let 
	       val (va1,c1) = GetExpCon(e1,ctxt)
	       val (va2,c2) = GetExpCon(e2,ctxt)
	   in if (eq_con(ctxt,c1,CON_TAG c2))
		  then (va1 andalso va2, CON_ANY)
	      else error "EXN_INJECT tag type and value: type mismatch"
	   end
     | ROLL(c,e) => GetExpRollCon'(ctxt,true,e,c)
     | UNROLL(c,_,e) => GetExpRollCon'(ctxt,false,e,c)
     | (INJ {sumtype,field,inject}) =>
	   let val (_,sumtype,_) = HeadNormalize(sumtype,ctxt)
	       val {names,carrier,noncarriers,...} = 
		   (case sumtype of
			CON_SUM info => info
		      | _ => error "INJ's decoration not reudcible to a sumtype")
	   in  
	       (case (field<noncarriers,inject) of
		    (true,NONE) => 
			(true,CON_SUM{names=names,
				      noncarriers=noncarriers,
				      carrier=carrier,
				      special=NONE})
		  | (false, NONE) => error "INJ: bad injection"
		  | (true,SOME e) => error "INJ: bad injection" 
		  | (false, SOME e) => 
		      let val (va,econ) = GetExpCon(e,ctxt)
			  val (_,carrier,_) = HeadNormalize(carrier,ctxt)
			  val i = field - noncarriers (* i >= 0 *)
			  val (n,fieldcon_opt) = 
			      (case carrier of 
				   CON_TUPLE_INJECT [] => (0,NONE)
				 | CON_TUPLE_INJECT clist => (length clist, SOME(List.nth(clist,i)))
				 | _ => (1,SOME carrier))
		      in if (i >= n)
			     then
				 (print "INJ: injection field out of range in exp:";
				  Ppil.pp_exp exparg; print "\n";
				  error "INJ: injection field out of range")
			 else
			     if (eq_con(ctxt, econ, valOf fieldcon_opt))
				 then (va,CON_SUM{names=names,noncarriers=noncarriers,
						  carrier=carrier,special=NONE})
			     else (print "INJ: injection does not type check eq_con failed on: ";
				   Ppil.pp_exp exparg; print "\n";
				   print "econ is "; Ppil.pp_con econ; print "\n";
				   print "nth clist is "; Ppil.pp_con (valOf fieldcon_opt); print "\n";
				   error "INJ: injection does not typecheck")
		      end)
	   end
     | (EXN_CASE {arg,arms,default,tipe}) =>
	   let 
	       val (_,argcon) = GetExpCon(arg,ctxt)
	       val _ = if (eq_con(ctxt,argcon,CON_ANY))
			   then () 
		       else error "arg not a CON_ANY in EXN_CASE"
	       fun checkarm(e1,c,e2) = 
		   let val (_,c1) = GetExpCon(e1,ctxt)
		       val (_,c2) = GetExpCon(e2,ctxt)
		   in if ((eq_con(ctxt,c1,CON_TAG c))
			  andalso eq_con(ctxt,c2,CON_ARROW([c],tipe,false,oneshot())))
			  then ()
		      else error "rescon does not match in EXN_CASE"
		   end
	       val _ = app checkarm arms
	       val _ = 
		   (case default of 
			NONE => ()
		      | (SOME e) =>
			    let val (_,optcon) = GetExpCon(e,ctxt)
			    in if (eq_con(ctxt,optcon,tipe))
				   then ()
			       else (print "EXN_CASE: default case mismatches";
				     print "default con is:\n";
				     Ppil.pp_con optcon; print "\n";
				     print "tipe con is :\n";
				     Ppil.pp_con tipe; print "\n";
				     error "EXN_CASE: default case mismatches")
			    end)
	   in (false, tipe)
	   end
     | (CASE {sumtype,arg,bound,arms,tipe,default}) => 
	   let 
	       val sumtype = (case sumtype of
				  CON_SUM _ => sumtype
				| _ => #2(HeadNormalize(sumtype,ctxt)))
	       val {names,carrier,noncarriers,special=_} = 
		   (case sumtype of
			CON_SUM info => info
		      | _ => error "CASE got type irreducible to a sumtype")
	       val n = length arms
	       val (_,carrier,_) = HeadNormalize(carrier,ctxt)
	       val (va,eargCon) = GetExpCon(arg,ctxt)
	       val sumcon = CON_SUM {names = names,
				     special = NONE,
				     carrier = carrier,
				     noncarriers = noncarriers}
	       fun loop _ va [] =  
		   (case default of 
			NONE => (va, tipe)
		      | SOME edef => 
			    let val (va',defcon) = GetExpCon(edef,ctxt)
			    in  if (sub_con(ctxt,defcon,tipe))
				    then (va andalso va', tipe)
				else error "default arm type mismatch"
			    end)
		 | loop n va (NONE::rest) = loop (n+1) va rest
		 | loop n va ((SOME exp)::rest) = 
			let val ctxt =  if (n < noncarriers) then ctxt
					else add_context_exp'(ctxt,bound,CON_SUM{names = names,
										 special = SOME n,
										 carrier = carrier,
										 noncarriers = noncarriers})
			    val (va',c) = GetExpCon(exp,ctxt)
			    val va = va andalso va'
			in  
			    if (sub_con(ctxt,c,tipe))
				then loop (n+1) va rest
			    else (print "case arm type mismatch: checking exp = ";
				  pp_exp exparg; print "\nwith ctxt = ";
				  pp_context ctxt; print "\n";
				  print "exp = \n"; pp_exp exp;
				  print "c = \n"; pp_con c;
				  print "tipe = \n"; pp_con tipe;
				  error "case arm type mismatch")
			end
	   in if (eq_con(ctxt,eargCon,sumcon))
		  then (loop 0 va arms)
	      else 
		  (Ppil.convar_display := Ppil.VAR_VALUE;
		   print "CASE: expression type and decoration con mismatch";
		   print "eargCon = "; pp_con eargCon; print "\n";
		   print "sumcon = "; pp_con sumcon; print "\n";
		   error "CASE: expression type and decoration con mismatch")
	   end
     | (MODULE_PROJECT(m,l)) => 
	   let val (va,signat) = GetModSig(m,ctxt)
	       fun self_case(p,sdecs) = 
		   (case Sdecs_Lookup ctxt (path2mod p, sdecs,[l]) of
		       NONE => ((* print "Normalize: label "; pp_label l;
				 print " not in signature s = \n";
				 pp_signat signat; print "\n"; *)
				fail "MODULE_PROJECT: label not in modsig")
		     | (SOME (_,PHRASE_CLASS_EXP(_,con,_,_))) => (va,con)
		     | SOME _ => fail "MODULE_PROJECT: label not of exp")
	       fun notself_case(sdecs) = 
		   (case local_Sdecs_Project ctxt(if va then SOME m else NONE, sdecs, l) of
			NONE => error "MODULE_PROJECT: label not in modsig"
		      | SOME (CLASS_EXP con) => (va,con)
		      | SOME _ => fail "MODULE_PROJECT: label not of exp")
	   in case (reduce_signat ctxt signat) of
	       SIGNAT_STRUCTURE(SOME p,sdecs) => self_case(p,sdecs)
	     | SIGNAT_STRUCTURE(NONE,sdecs) => notself_case sdecs
	     | SIGNAT_FUNCTOR _ => error "cannot project from module with functor signature"
	     | _ => error "signat_var of signat_of is not reduced"
	   end

     | (SEAL (e,c)) => let val (va,c') = GetExpCon(e,ctxt)
		       in if sub_con(ctxt,c',c)
			      then (va,c)
			  else error "SEAL: expression type does not match sealing type"
		       end)



   (* ----------- rules 22 - 25 ------------------------- *)
   and GetBndDec (ctxt,BND_EXP (v,e))  = let val (va,c) = GetExpCon (e,ctxt)
					 in (va,DEC_EXP(v,c,NONE,false))
					 end
     | GetBndDec (ctxt,BND_MOD (v,b,m))  = let val (va,s) = GetModSig(m,ctxt)
					 in (va,DEC_MOD(v,b,s))
					 end
     | GetBndDec (ctxt,BND_CON (v,c))  = (true,DEC_CON(v,GetConKind(c,ctxt),SOME c,false))
   and GetBndsDecs (ctxt,bnds) = GetBndsDecs'(ctxt,bnds,[])
   and GetBndsDecs' (ctxt,[],acc) = rev acc
     | GetBndsDecs' (ctxt,bnd::rest,acc) = 
       let val (va,d) = GetBndDec(ctxt,bnd)
	   val ctxt' = add_context_dec(ctxt,SelfifyDec ctxt d)
       in GetBndsDecs' (ctxt',rest, (va,d)::acc)
       end
   and GetSbndSdec (ctxt,SBND (l, bnd)) = let val (va,dec) = GetBndDec(ctxt,bnd)
					  in (va,SDEC(l,dec))
					  end

   and GetSbndsSdecs (ctxt, []) = []
     | GetSbndsSdecs (ctxt, (sbnd as (SBND(l,bnd))) :: rest) = 
       let val (va,dec) = GetBndDec(ctxt,bnd)
	   val sdec = SDEC(l,dec)
	   val ctxt' = add_context_dec(ctxt, SelfifyDec ctxt dec)
       in (sbnd,sdec)::(GetSbndsSdecs(ctxt',rest))
       end



    and Sbnds_Lookup ctxt (sbnds, labs) : (labels * phrase) option =
	let 
(*
	    val _ = (print "sbnds_lookup called with labs = ";
		     app (fn l => (print (Name.label2string l); print ".")) labs; 
		     print "\nand sbnds are:\n";
		     app (fn (SBND(l,_)) => (print (Name.label2string l); print " ...")) sbnds;
		     print "\n\n")
*)
	    fun loop (lbl,[]) = NONE
	      | loop (lbl,(sbnd as SBND(l,b))::r) = 
		 (case b of
			 (BND_EXP (_,e)) => if (eq_label(l,lbl)) 
						then SOME([l],PHRASE_EXP e) else loop(lbl,r)
		       | (BND_CON (_,c)) => if (eq_label(l,lbl)) 
						then let val c' = c (* XXX *)
						     in SOME([l],PHRASE_CON c') 
						     end
					    else loop(lbl,r)
		       | (BND_MOD (_,_,m)) => (if (eq_label(l,lbl)) 
						 then SOME([l],PHRASE_MOD m) 
					     else if (is_open l)
						      then 
							  (case m of 
							       MOD_STRUCTURE sbnds =>
								   (case (loop (lbl,rev sbnds)) of
									SOME(lbls',phrase) => SOME(l::lbls',phrase)
								      | NONE => loop (lbl,r))
							     | _ => loop(lbl,r))
						  else loop(lbl,r)))
	in
	    (case labs of
		 [] => error "Sbnds_Lookup got []"
	       | [lbl] => loop (lbl,rev sbnds)
	       | (lbl :: lbls) =>
		     (case (loop (lbl,rev sbnds)) of
			 SOME(labs,PHRASE_MOD (MOD_STRUCTURE sbnds)) => 
			     (case (Sbnds_Lookup ctxt (sbnds,lbls)) of
				  SOME(labs2,phrase2) => SOME(labs@labs2,phrase2)
				| _ => NONE)
		       | _ => NONE))
	end

    and Sdecs_Lookup_help ctxt (om, sdecs, labs) : (bool * (phrase_class * labels)) option = 
	let 
	    fun loop m lbl [] = NONE
	      | loop m lbl ((sdec as (SDEC(l,d)))::rest) =
		if (eq_label(l,lbl)) 
		    then (case d of
			      (DEC_EXP (_,c,eopt,inline)) => 
				  SOME(false,(PHRASE_CLASS_EXP(MODULE_PROJECT(m,l), c, eopt,inline),[l]))
			    | (DEC_CON (_,k,copt,inline)) =>
				  SOME(true,(PHRASE_CLASS_CON(CON_MODULE_PROJECT(m,l),k,copt,inline),[l]))
			    | (DEC_MOD (_,b,s)) => 
				SOME(false,(PHRASE_CLASS_MOD(MOD_PROJECT(m,l),b,s),[l])))
		else if (is_open l)
		    then 
		     (case d of
		       (DEC_MOD(_,_,s)) =>
			   (case s of
			       SIGNAT_STRUCTURE (_,sdecs) =>
				  (case (loop (MOD_PROJECT(m,l)) lbl (rev sdecs)) of
				       SOME (flag,(class,lbls')) => SOME(flag,(class,l::lbls'))
				     | NONE => loop m lbl rest)
			    | _ => loop m lbl rest)
		        | _ => loop m lbl rest)
		     else loop m lbl rest

	in
	    (case labs of
		 [] => error "Sdecs_Lookup_help got []"
	       | [lbl] => loop om lbl (rev sdecs)
	       | (lbl :: lbls) =>
		     case (loop om lbl (rev sdecs)) of
		       SOME(_,(phrase_class,labs)) =>
			 let fun doit(m',s) =
			     (case s of
				  SIGNAT_STRUCTURE (_,sdecs') =>
				      (case (Sdecs_Lookup_help ctxt(m',sdecs',lbls)) of
					   SOME(nontrivial,(pc2,labs2)) => 
					       SOME(nontrivial,(pc2,labs @ labs2))
					 | NONE => NONE)
				| _ => NONE)
			 in  (case phrase_class of
				  PHRASE_CLASS_MOD (m,_,s) => 
				      doit(m,reduce_signat ctxt s)
				| _ => NONE)
			 end
		     | _ => (print "Sdecs_Lookup_help could not find label";
			     pp_label lbl; print " in sdecs:\n";
			     pp_sdecs sdecs; print "\n";
			     error "Sdecs_Lookup_help could not find label"))
	end

    and Sdecs_Lookup ctxt (m, sdecs, labs) : (labels * phrase_class) option =
	let 
	    fun loop lbl [] = NONE
	      | loop lbl ((sdec as (SDEC(l,d)))::rest) =
		if (eq_label(l,lbl)) 
		  then 
		      (case d of
			   (DEC_EXP (_,c,eopt,inline)) => 
			       SOME([l],PHRASE_CLASS_EXP(MODULE_PROJECT(m,l), c, eopt, inline))
			 | (DEC_CON (_,k,copt,inline)) => 
			       SOME([l],PHRASE_CLASS_CON(CON_MODULE_PROJECT(m,l), k,copt, inline))
			 | (DEC_MOD (_,b,s)) => 
			       SOME([l],PHRASE_CLASS_MOD(MOD_PROJECT(m,l),b,s)))
		else loop lbl rest

	in
	    (case labs of
		 [] => error "Sdecs_Lookup got []"
	       | [lbl] => loop lbl (rev sdecs)
	       | (lbl :: lbls) =>
		     case (loop lbl (rev sdecs)) of
			 SOME(labs,PHRASE_CLASS_MOD (m',_,((SIGNAT_STRUCTURE (_,sdecs'))))) =>
			     (case (Sdecs_Lookup ctxt (m',sdecs',lbls)) of
				  SOME(labs2, pc2) => SOME(labs @ labs2, pc2)
				| NONE => NONE)
		       | SOME _ => NONE
		       | NONE => NONE)
	end



    and Sdecs_Lookup' ctxt (m,sdecs,labels) = 
	  (case (Sdecs_Lookup_help ctxt (m,sdecs,labels)) of
	       SOME(_,(pc,labels)) => SOME(labels,pc)
	     | NONE => NONE)




   (* ------------ Return a module's signature    -------------- *)
   and reduce_signat context (SIGNAT_VAR v) = reduce_signat context (reduce_sigvar(context,v))
     | reduce_signat context (SIGNAT_OF m ) = reduce_signat context (#2(GetModSig(m,context)))
     | reduce_signat context s = s

   and GetModSig (module, ctxt : context) : bool * signat =
     let fun msg() = (print "GetModSig called with module = \n";
			 pp_mod module; print "\n")
	 val _ = debugdo msg
     in GetModSig'(module,ctxt)
	  handle e => (if !trace then msg() else (); raise e)
     end

   and GetModSig' (module, ctxt : context) : bool * signat =
     (case module of
       (MOD_VAR v) => 
	   (case Context_Lookup'(ctxt,v) of
		SOME(_,PHRASE_CLASS_MOD(_,_,s)) => (true,s)
	      | SOME _ => error ("MOD_VAR " ^ (Name.var2string v) ^ " bound to a non-module")
	      | NONE => error ("MOD_VAR " ^ (Name.var2string v) ^ " not bound"))
     | MOD_STRUCTURE (sbnds) => 
	   let fun loop va [] acc ctxt = (va,rev acc)
		 | loop va (sb::sbs) acc ctxt = 
		   let 
		       val (lva,sdec) = GetSbndSdec(ctxt,sb)
		       val SDEC(_,dec) = sdec
		   in loop (va andalso lva) sbs (sdec::acc) (add_context_dec(ctxt,SelfifyDec ctxt dec))
		   end
	       val (va,sdecs) = (loop true sbnds [] ctxt)
	       val res = SIGNAT_STRUCTURE(NONE,sdecs)
	   in (va,res)
	   end
     | MOD_FUNCTOR (a,v,s,m,s2) => 
	   let val ctxt' = add_context_dec(ctxt,DEC_MOD(v,false,SelfifySig ctxt (PATH(v,[]), s)))
	       val (va,signat) = GetModSig(m,ctxt')
	       val a = 
		case a of
		 TOTAL => if va then TOTAL 
			else error "TOTAL annotation on non-valuable functor"
		| PARTIAL => a
	       (* check equivalence of s2 and signat *)
	   in  (true,SIGNAT_FUNCTOR(v,s,s2,a))
	   end
     | MOD_APP (a,b) => 
	   let val _ = debugdo (fn () => (print "\n\nMOD_APP case in GetModSig\n";
					  print "a is\n"; pp_mod a; print "\n";
					  print "b is\n"; pp_mod b; print "\n"))
	       val (vaa,asignat) = GetModSig(a,ctxt)
	       val (vab,bsignat) = GetModSig(b,ctxt)
	       val _ = debugdo (fn () => (print "\n\nMOD_APP case in GetModSig got asignat and bsignat\n";
					  print "asignat is\n"; pp_signat asignat; print "\n";
					  print "bsignat is\n"; pp_signat bsignat; print "\n"))
	   in case (reduce_signat ctxt asignat) of
	       SIGNAT_FUNCTOR (v,csignat,dsignat,ar) =>
		   if (Sig_IsSub(ctxt, bsignat, csignat))
		       then (vaa andalso vab andalso (ar = TOTAL),
			     sig_subst_modvar(dsignat,[(v,b)]))
			    else error ("Module Application where" ^ 
					" argument and parameter signature mismatch")
	     | (SIGNAT_STRUCTURE _) => error "Can't apply a structure"
	     | _ => error "signat_var or signat_of is not reduced"
	   end
     | MOD_LET (v,m1,m2) => 
	   let val (va1,s1) = GetModSig(m1,ctxt)
	       val s1' = SelfifySig ctxt (PATH(v,[]),s1)
	       val ctxt' = add_context_mod'(ctxt,v,s1')
	       val (va2,s2) = GetModSig(m2,ctxt')
	   in (va1 andalso va2,sig_subst_modvar(s2,[(v,m1)]))
	   end
     | MOD_PROJECT (m,l) => 
	   let 
	       val _ = debugdo (fn () => (print "GetModSig called with: "; 
					  pp_mod module; print "\n"))
	       val (va,signat) = GetModSig(m,ctxt)
	       val _ = debugdo (fn () => (print "retrieved signat of \n"; 
					  pp_signat signat; print "\n"))
	       fun self_case(p,sdecs) = 
		   (case Sdecs_Lookup ctxt (path2mod p, sdecs,[l]) of
			NONE =>  
			 (print "GetModSig: SignatLookup MOD_PROJECT failed with label ";
			     pp_label l;
			     print "\nand with signat = \n";  pp_signat signat; 
			     print "\n";
			     fail "MOD_PROJECT failed to find label ")
		      | (SOME (_,PHRASE_CLASS_MOD(_,_,s))) => (va,s)
		      | _ => (print "MOD_PROJECT at label "; pp_label l; 
			      print "did not find DEC_MOD.  \nsig was = ";
			      pp_signat signat; print "\n";
			      fail "MOD_PROJECT found label not of flavor DEC_MOD"))
	       fun notself_case(sdecs) = 
		   (case local_Sdecs_Project ctxt(if va then SOME m else NONE, sdecs, l) of
			NONE => error "MOD_PROJECT: label not in modsig"
		      | SOME (CLASS_MOD s) => (va,s)
		      | SOME _ => fail "MOD_PROJECT: label found wrong flavor")

	   in case (reduce_signat ctxt signat) of
	       SIGNAT_STRUCTURE (SOME p,sdecs) => self_case(p,sdecs)
	     | SIGNAT_STRUCTURE (NONE,sdecs) => notself_case sdecs
	     | SIGNAT_FUNCTOR _ => error "cannot project from functor"
	     | _ => error "signat_var or signat_of is not reduced"
	   end

     | MOD_SEAL (m,s) => let val (va,ps) = GetModSig(m,ctxt)
			     val _ = if (Sig_IsSub(ctxt,ps,s)) then()
				     else error "MOD_SEAL: Sig_IsSub failed"
			 in (va,s)
			 end)

    and Normalize (con,ctxt) : (bool * con) = 
	let fun msg() = (print "HeadNormalize called with con =\n";
			 pp_con con; print "\n")
	in  (case Reduce(true,con,ctxt) of
		 NONE => (false, con)
	       | SOME(c,_) => (true, c))
	  handle e => (if !trace then msg() else (); raise e)
	end


    and HeadNormalize (con,ctxt) : (bool * con * path list) = 
	let fun msg() = (print "HeadNormalize called with con =\n";
			 pp_con con; print "\n")
	in  (case Reduce(false,con,ctxt) of
		 NONE => (false, con, [])
	       | SOME(c,p) => (true, c, p))
	  handle e => (if !trace then msg() else (); raise e)
	end

    
    (* if full is true, then do full normalization; otherwise, just head normalization
       if NONE, constructor was already (head-)normal
       is SOME(c,paths), the reduced constructor is returned
                         with a list of (some) intermediate paths it went through *)
    and Reduce (full,argcon,ctxt) : (con * path list) option = 
       let 
	    fun ReduceFolder (c,change) =
		(case Reduce (full,c,ctxt) of
		     NONE => (c, change)
		   | SOME(c,paths) => (c, true))
	    fun ReduceAgain c =
		(case Reduce (full,c,ctxt) of
		     NONE => SOME(c, [])
		   | someopt => someopt)
	    fun ReduceAgainWith (c, p) =
		(case Reduce (full,c,ctxt) of
		     NONE => SOME(c, [p])
		   | SOME(c,paths) => SOME(c, p :: paths))
	    fun help constr c = 
	      (case Reduce(full,c,ctxt) of
		   NONE => NONE
		 | SOME (c,_) => SOME(constr c, []))
       in
	   (case (full,argcon) of
	      (_, CON_INT _)  => NONE
	    | (_, CON_UINT _)  => NONE
	    | (_, CON_FLOAT _) => NONE
	    | (_, CON_ANY) => NONE
	    | (false, CON_REF _) => NONE
	    | (true, CON_REF c) => help CON_REF c
	    | (false, CON_ARRAY _) => NONE
	    | (true, CON_ARRAY c) => help CON_ARRAY c
	    | (false, CON_VECTOR _) => NONE
	    | (true, CON_VECTOR c) => help CON_VECTOR c
	    | (false, CON_TAG _) => NONE
	    | (true, CON_TAG c) => help CON_TAG c
	    | (false, CON_SUM _) => NONE
	    | (true, CON_SUM{names,carrier,noncarriers,special}) =>
		  let fun constr c = CON_SUM{names=names,
					     carrier=c,
					     noncarriers=noncarriers,
					     special=special}
		  in  help constr carrier
		  end
	    | (false, CON_ARROW _) => NONE
	    | (true, CON_ARROW (cs1,c2,closed,comp)) =>
		  let val (cs1,change) = foldl_acc ReduceFolder false cs1
		      val (c2,change) = ReduceFolder (c2,change)
		  in  if change
			  then SOME(CON_ARROW (cs1, c2, closed, comp), [])
		      else NONE
		  end
	    | (false, CON_MU _) => NONE
	    | (true, CON_MU c) => help CON_MU c
	    | (false, CON_RECORD _) => NONE
	    | (true, CON_RECORD rdecs) => 
		  let val (labs,cons) = Listops.unzip rdecs
		      val (cons,change) = foldl_acc ReduceFolder false cons
		  in  if change 
			  then SOME(CON_RECORD (Listops.zip labs cons), [])
		      else NONE
		  end

	    | (_, CON_FLEXRECORD (ref (INDIRECT_FLEXINFO rf))) => 
		  ReduceAgain(CON_FLEXRECORD rf)
	    | (_, CON_FLEXRECORD (r as ref (FLEXINFO (stamp,flag,rdecs)))) => 
				    let fun f (l,c)= (l,#1(ReduceFolder (c,false)))
					val _ = r := FLEXINFO(stamp,flag,map f rdecs)
				    in  NONE
				    end
	    | (_, CON_OVAR ocon) => let val tv = ocon_deref ocon
				    in  ReduceAgain(CON_TYVAR tv)
				    end
	    | (_, CON_TYVAR tv) => (case tyvar_deref tv of
					NONE => NONE
				      | SOME c => ReduceAgain c)
	    | (_, CON_VAR v) => 
		   (case (Context_Lookup'(ctxt,v)) of
			SOME(_,PHRASE_CLASS_CON (_,_,SOME c,_)) => 
			    ReduceAgainWith(c,PATH(v,[]))
		      | SOME(_,PHRASE_CLASS_CON (_,_,NONE,_)) => NONE
		      | SOME _ => error ("Normalize: CON_VAR " ^ (var2string v) ^ " not bound to a con")
		      | NONE => error ("Normalize: CON_VAR " ^ (var2string v) ^ " not bound"))
	    | (false, CON_TUPLE_INJECT _) => NONE
	    | (true, CON_TUPLE_INJECT cons) => 
			let val (cons,change) = foldl_acc ReduceFolder false cons
			in  if change
				then SOME(CON_TUPLE_INJECT cons, [])
			    else NONE
			end
	    | (_,CON_TUPLE_PROJECT (i,c)) => 
		  (case Reduce(full,c,ctxt) of
		       NONE => NONE
		     | SOME(CON_TUPLE_INJECT cons, _) => 
			   let val len = length cons
			       val _ = if (i >= 0 andalso i < len)
					   then ()
				       else
					   error "Reduce: con tuple projection - index wrong"
			       val c = List.nth(cons,i)
			   in  ReduceAgain c
			   end
		    | SOME(c,_) => SOME(CON_TUPLE_PROJECT(i,c), []))
	    (* Eta contract functions *)
	    | (_, CON_FUN([v],CON_APP(f,CON_VAR v'))) => 
		       if (eq_var(v,v'))
			   then 
			       ReduceAgain f
		       else NONE
	    | (_, CON_FUN(vars,CON_APP(f,CON_TUPLE_INJECT args))) =>
		let fun match (v,(CON_VAR v')) = eq_var(v,v')
		      | match _ = false
		in  if (eq_list(match,vars,args))
			then ReduceAgain f
		    else NONE
		end
	    | (_, CON_FUN _) => NONE
	    | (_, CON_APP(c1,c2)) => 
		  let val (c1,change) = ReduceFolder (c1,false)
		      val (c2,change) = ReduceFolder (c2,change)
		  in  (case c1 of
			   (CON_FUN(vars,body)) => ReduceAgain(ConApply(false,c1,c2))
			 | _ => if change
				    then SOME(CON_APP(c1,c2),[])
				else NONE)
		  end
	    | (_, CON_MODULE_PROJECT (m,l)) =>
		(let 
		   val (_,s) = GetModSig(m,ctxt)
		   fun break_loop c = 
		       let val argpath = con2path argcon
			   val path = con2path c
		       in  (case (argpath,path) of
				(SOME argpath, SOME path) =>
				    if (eq_path(argpath,path))
					then NONE
				    else ReduceAgainWith(c,argpath)
			      | (SOME argpath, _) => ReduceAgainWith(c,argpath)
			      | _ => ReduceAgain c)
		       end
		   fun lookup _ [] = NONE
		     | lookup (tables as (ctable,mtable)) ((SDEC(curl,dec))::rest) = 
		       (case dec of
			    DEC_CON(v,_,SOME curc, _) =>
				if eq_label(curl,l)
				    then let val curc = con_subst_conmodvar(curc,#1 tables,#2 tables)
					 in break_loop curc
					 end
				else 
				    let val centry = (v,CON_MODULE_PROJECT(m,curl))
					val tables = (centry::ctable, mtable)	   
				    in  lookup tables rest
				    end
			  | DEC_MOD(v,_,s) => 
				let val mentry = (v,MOD_PROJECT(m,curl))
				    val tables = (ctable, mentry::mtable)
				in lookup tables rest
				end
			  | _ => lookup tables rest)
		   fun self_case(p,sdecs) = 
		       (case Sdecs_Lookup ctxt (path2mod p, sdecs, [l]) of
			    SOME(_,PHRASE_CLASS_CON(_,_,SOME c,_)) => break_loop c
			  | SOME(_,PHRASE_CLASS_CON(c,_,NONE,_)) => break_loop c
			  | SOME _ => error "CON_MOD_PROJECT found signature with wrong flavor"
			  | NONE => NONE)
		   fun notself_case sdecs = 
		       (debugdo (fn () => 
				 (print "Reduce: CON_MODULE_PROJECT case: l = "; 
				  pp_label l; print "\n and sdecs = ";
				  pp_sdecs sdecs;
				  print "\n"));
			lookup ([],[]) sdecs)
	       in (case (reduce_signat ctxt s) of 
		       SIGNAT_STRUCTURE(NONE,sdecs) => notself_case sdecs
		     | SIGNAT_STRUCTURE (SOME p,sdecs) => self_case(p,sdecs)
		     | SIGNAT_FUNCTOR _ => (print "CON_MODULE_PROJECT from a functor = \n";
					    pp_mod m;
					    error "CON_MODULE_PROJECT from a functor")
		     | _ => error "signat_var of signat_of is not reduced")
	       end))
       end	

     and Kind_Valid (KIND_TUPLE n,_)     = n >= 0
       | Kind_Valid (KIND_ARROW (m,n),_) = (m >= 0) andalso (n >= 0)

     and Context_Valid ctxt = raise Util.UNIMP

     and Decs_Valid (ctxt,[]) = true
       | Decs_Valid (ctxt,a::rest) = Dec_Valid(ctxt,a) andalso 
	 Decs_Valid(add_context_dec(ctxt,SelfifyDec ctxt a),rest)

     and Dec_Valid (ctxt : context, dec) = 
	 let fun var_notin v  = (Context_Lookup'(ctxt,v); false) handle _ => true
       in  (case dec of
	      DEC_EXP(v,c,eopt,_) => 
		  (var_notin v) andalso 
		  (case GetConKind(c,ctxt) of
		       KIND_TUPLE 1 => true
		     | _ => false) andalso
		  (case eopt of
		       SOME e => eq_con(ctxt,c,#2 (GetExpCon(e,ctxt)))
		     | NONE => true)
	    | DEC_CON (v,k,NONE, _) => (var_notin v) andalso (Kind_Valid(k,ctxt))
	    | DEC_CON (v,k,SOME c, _) => (var_notin v) andalso (Kind_Valid(k,ctxt)) 
		       andalso (GetConKind(c,ctxt); true)
	    | DEC_MOD(v,_,s) => (var_notin v) andalso (Sig_Valid(ctxt,s)))
       end
				

     and Sdecs_Domain sdecs = map (fn SDEC(l,_) => l) sdecs
     and Sdecs_Valid (ctxt, []) = Context_Valid ctxt
       | Sdecs_Valid (ctxt, (SDEC(label,dec)::rest)) = 
	 (Dec_Valid(ctxt,dec) andalso 
	  Sdecs_Valid(add_context_dec(ctxt,SelfifyDec ctxt dec),rest) andalso 
	  (not (List.exists (fn l => eq_label(label,l))
		(Sdecs_Domain rest))))

     and Sig_Valid (ctxt : context, SIGNAT_STRUCTURE (_, sdecs)) = Sdecs_Valid(ctxt,sdecs)
       | Sig_Valid (ctxt, SIGNAT_FUNCTOR(v,s_arg,s_res,arrow)) = 
	 (Sig_Valid(ctxt,s_arg) andalso 
	  Sig_Valid(add_context_mod'(ctxt,v,SelfifySig ctxt (PATH(v,[]),s_arg)),s_res))
       | Sig_Valid (ctxt : context, SIGNAT_VAR v) = Sig_Valid(ctxt,reduce_sigvar(ctxt,v))
       | Sig_Valid (ctxt : context, SIGNAT_OF m) = ((GetModSig(m,ctxt); true) handle _ => false)

     and Dec_IsSub (ctxt,d1,d2) = Dec_IsSub' true (ctxt,d1,d2) 
     and Dec_IsEqual (ctxt,d1,d2) = Dec_IsSub' false (ctxt,d1,d2) 

     and Dec_IsSub' isSub (ctxt,d1,d2) = 
	 (case (d1,d2) of
	      (DEC_MOD(v1,b1,s1),DEC_MOD(v2,b2,s2)) => 
		  eq_var(v1,v2) andalso (b1 = b2) andalso 
                  (if isSub then Sig_IsSub(ctxt,s1,s2) else Sig_IsEqual(ctxt,s1,s2))
	    | (DEC_CON(v1,k1,SOME c1,inline1),DEC_CON(v2,k2,NONE,inline2)) => 
		  isSub andalso eq_var(v1,v2) andalso eq_kind(k1,k2) 
		  andalso eq_kind(k1,GetConKind(c1,ctxt))
		  andalso inline1=inline2
	    | (DEC_CON(v1,k1,NONE,_),DEC_CON(v2,k2,SOME _,_)) => false
	    | (DEC_CON(v1,k1,SOME c1,inline1),DEC_CON(v2,k2,SOME c2,inline2)) => 
		  eq_var(v1,v2) andalso eq_kind(k1,k2) 
		  andalso if isSub then sub_con(ctxt,c1,c2) else eq_con(ctxt,c1,c2)
		  andalso inline1=inline2
	    | (DEC_EXP(v1,c1,eopt1,inline1),DEC_EXP(v2,c2,eopt2,inline2)) =>
		  eq_var(v1,v2) andalso (if isSub then sub_con(ctxt,c1,c2) else eq_con(ctxt,c1,c2))
		  andalso (case (eopt1,eopt2) of
			       (SOME e1, SOME e2) => eq_exp(ctxt,e1,e2)
			     | (NONE, NONE) => true
			     | (NONE, SOME _) => false
			     | (SOME _, NONE) => isSub)
		  andalso inline1=inline2
	    | _ => false)

     and eq_exp(ctxt,e1,e2) = (print "alpha-equivalence of expression not done\n";
			       true)

     (* Rules 99 - 100 *)
     and Sdecs_IsSub (ctxt,sdecs1,sdecs2) = Sdecs_IsSub' true (ctxt,sdecs1,sdecs2)
     and Sdecs_IsEqual (ctxt,sdecs1,sdecs2) = Sdecs_IsSub' false (ctxt,sdecs1,sdecs2)

     and Sdecs_IsSub' isSub (ctxt,sdecs1,sdecs2) =
	 let 
	     exception NOPE
	     fun help subster (v1,v2,sdecs) =
		 (case (subster(SIGNAT_STRUCTURE (NONE,sdecs),[(v1,v2)])) of
		      SIGNAT_STRUCTURE (_,sdecs') => sdecs'
		    | _ => error "Sdecs_IsSub subst failed")
	     fun match_var [] [] = []
	       | match_var (SDEC(l1,dec1)::rest1) ((sdec2 as (SDEC(l2,dec2)))::rest2) : sdec list = 
		 if (eq_label (l1,l2))
		     then (case (dec1,dec2) of
			       (DEC_MOD(v1,b1,s1),DEC_MOD(v2,b2,s2)) =>
				   if (eq_var(v1,v2))
				       then sdec2::(match_var rest1 rest2)
				   else SDEC(l2,(DEC_MOD(v1,b1,s2)))::
				       (match_var rest1 (help sig_subst_modvar (v2,MOD_VAR v1,rest2)))
			     | (DEC_EXP(v1,c1,e1,i1),DEC_EXP(v2,c2,e2,i2)) =>
				   if (eq_var(v1,v2))
				       then sdec2::(match_var rest1 rest2)
				   else SDEC(l2,(DEC_EXP(v1,c2,e2,i2)))
				       ::(match_var rest1 (help sig_subst_expvar (v2,VAR v1,rest2)))
			     | (DEC_CON(v1,k1,c1,i1),DEC_CON(v2,k2,c2,i2)) =>
				   if (eq_var(v1,v2))
				       then sdec2::(match_var rest1 rest2)
				   else SDEC(l2,(DEC_CON(v1,k2,c2,i2)))
				       ::(match_var rest1 (help sig_subst_convar (v2,CON_VAR v1,rest2)))
			     | _ => SDEC(l2,dec2)::(match_var rest1 rest2))
		 else raise NOPE
	       | match_var _ _ = (print "Sdecs_IsSub: length mismatch\n";
				  raise NOPE)
	     fun loop ctxt [] [] = true
	       | loop ctxt (SDEC(_,dec1)::rest1) (SDEC(_,dec2)::rest2) = 
		 let val dec1 = SelfifyDec ctxt dec1
		 in (Dec_IsSub' isSub (ctxt,dec1,dec2)
		     andalso loop (add_context_dec(ctxt,dec1)) rest1 rest2)
		 end
	       | loop ctxt _ _ = false
	 in (loop ctxt sdecs1 (match_var sdecs1 sdecs2))
	     handle NOPE => false
	 end

     (* Rules 109 - 112 *)
     and Sig_IsSub (ctxt, sig1, sig2) = Sig_IsSub' true (ctxt, sig1, sig2)
     and Sig_IsEqual (ctxt, sig1, sig2) = Sig_IsSub' false (ctxt, sig1, sig2)

     and Sig_IsSub' isSub (ctxt, sig1, sig2) = 
	 let fun help(ctxt,sdecs1,sdecs2) = Sdecs_IsSub' isSub (ctxt,sdecs1,sdecs2)
	 in
	     (case (reduce_signat ctxt sig1,reduce_signat ctxt sig2) of
		  (SIGNAT_STRUCTURE (NONE,sdecs1), 
		   SIGNAT_STRUCTURE (NONE,sdecs2)) => 
		  let val v = fresh_named_var "selfvar"
		      val p = PATH(v,[])
		      val sdecs1 = SelfifySdecs ctxt (p,sdecs1)
		      val sdecs2 = SelfifySdecs ctxt (p,sdecs2)
		      val ctxt = add_context_mod'(ctxt,v,SIGNAT_STRUCTURE(SOME p,sdecs1))
		  in help(ctxt,sdecs1,sdecs2)
		  end
		| (SIGNAT_STRUCTURE (NONE,sdecs1), 
		   SIGNAT_STRUCTURE (SOME p,sdecs2)) => help(ctxt,SelfifySdecs ctxt (p,sdecs1),sdecs2)
		| (SIGNAT_STRUCTURE (SOME p,sdecs1), 
		   SIGNAT_STRUCTURE (NONE, sdecs2)) => help(ctxt,sdecs1,SelfifySdecs ctxt (p,sdecs2))
		| (SIGNAT_STRUCTURE (SOME p1,sdecs1), 
		   SIGNAT_STRUCTURE (SOME p2,sdecs2)) => (* eq_path(p1,p2) orelse *) help(ctxt,sdecs1,sdecs2)
		| (SIGNAT_FUNCTOR(v1,s1_arg,s1_res,a1), 
		   SIGNAT_FUNCTOR(v2,s2_arg,s2_res,a2)) =>
		  ((eq_arrow(a1,a2,isSub)) andalso 
		   let val s1_res = if (eq_var(v1,v2)) then s1_res
				    else sig_subst_modvar(s1_res,[(v1,MOD_VAR v2)])
		       val s2_arg = SelfifySig ctxt (PATH (v2,[]), s2_arg)
		       val ctxt' = add_context_dec(ctxt,DEC_MOD(v2,false,s2_arg))
		       val b1 = Sig_IsSub' isSub (ctxt',s2_arg,s1_arg) 
		       val b2 = Sig_IsSub' isSub (ctxt',s1_res,s2_res)
		       val _ = if b1 then () else print "argument sig mismatch\n"
		       val _ = if b2 then () else  print "result sig mismatch\n" 
		   in  b1 andalso b2
		   end)
		 | _ => (print "Warning: ill-formed call to Sig_IsSub' with sig1 = \n";
			 pp_signat sig1; print "\n and sig2 = \n";
			 pp_signat sig2; print "\n";
			 false))
	 end


  local
      fun LookupHelp (ctxt, labs, path, pc) = 
	  let fun sbnds_sdecs (sbnds,sdecs) = 
	      (case (Sbnds_Lookup ctxt (sbnds,labs)) of
		   SOME(labels,phrase) =>
		       (case (Sdecs_Lookup_help ctxt (path2mod path,sdecs,labs)) of
			    SOME(_,(pc,labels')) => 
				let val p = join_path_labels(path,labels)
				in  SOME(p,merge_phrase_pc(phrase,pc)) 
				end
			  | NONE => NONE)
		 | NONE => NONE)
	  in case pc of
	      (PHRASE_CLASS_MOD(m,_,s)) =>
		  (case (m,reduce_signat ctxt s) of
		       (MOD_STRUCTURE sbnds,SIGNAT_STRUCTURE (_,sdecs)) =>
			   sbnds_sdecs(sbnds,sdecs)
		     | (_,SIGNAT_STRUCTURE (_,sdecs)) =>
			   (case (Sdecs_Lookup_help ctxt (path2mod path,sdecs,labs)) of
				SOME(_,(pc,labels)) =>
				    let val p = join_path_labels(path,labels)
				    in  SOME (p,pc)
				    end
			      | _ => NONE)
		     | _ => NONE)
	    | _ => NONE
	  end
  in
      fun Context_Lookup_Labels (ctxt, [] : label list) : (path * phrase_class) option = NONE
	| Context_Lookup_Labels (ctxt as CONTEXT{label_list, ...}, (lab::labrest)) = 
	(case (labrest,Name.LabelMap.find(label_list,lab)) of
	    (_,NONE) => NONE
	  | ([],SOME (path,pc)) => ((* print "Context_Lookup_Labels found label: ";
                                    pp_label lab;
                                    print "\nreturned path: ";
                                    pp_path path;
                                    print "\nreturned pc: ";
                                    pp_phrase_class pc;
                                    print "\ncontext was: ";
                                    pp_context ctxt;
                                    print "\n"; *)
                                    SOME(path,pc))
	  | (_,SOME (path,pc)) => LookupHelp(ctxt,labrest,path,pc))
      fun Context_Lookup_Path (ctxt as CONTEXT{var_list,...}, p as PATH (v,labs)) = 
	  (case (Name.VarMap.find(#1 var_list, v),labs) of
	      (NONE,_) => NONE
	    | (SOME (_,pc),[]) => SOME(p,pc)
	    | (SOME (_,pc),_) => LookupHelp(ctxt,labs,PATH(v,[]), pc))
  end

    fun con_normalize (context,c) = #2(Normalize(c,context))
    fun con_head_normalize (context,c) = #2(HeadNormalize(c,context))

    val GetExpCon = fn (d,e) => #2(GetExpCon(e,d))
    val GetConKind = fn (d,c) => GetConKind(c,d)
    val GetConKindFast = fn (d,c) => GetConKindFast(c,d)
    val GetModSig = fn (d,m) => ((* Stats.counter "ilstatic.externgetmodsig" (); *)
				#2(GetModSig(m,d)))
    val GetBndDec = fn arg => #2(GetBndDec arg)
    val GetBndsDecs = fn arg => map #2 (GetBndsDecs arg)
    val GetSbndsSdecs = fn arg => map #2(GetSbndsSdecs arg)
    val Module_IsValuable = fn (d,m) => Module_IsValuable m d
    val Bnds_IsValuable = fn (d,bs) => Bnds_IsValuable bs d
    val Sbnds_IsValuable = fn (d,ss) => Sbnds_IsValuable ss d

  end
