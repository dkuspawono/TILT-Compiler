(*$InfixParse : UTIL AST ASTHELP *)
functor InfixParse(structure Il : IL
		   structure Ppil : PPIL
		   structure AstHelp : ASTHELP
		   sharing Ppil.Il = Il)
  : INFIXPARSE = 
  struct

    structure Il = Il

    structure Ast = Compiler.Ast
    structure Symbol = Compiler.Symbol
    structure Fixity = Fixity
    exception UNIMP
    exception BUG of string

    open Il
    open Util AstHelp Name

    val debug = ref false
    fun debugdo t = if (!debug) then (t(); ()) else ()
    val error = error "infixparse.sml"

    (* ----------------------------------------------------------------------      
      Useful values to make application explicit
      ---------------------------------------------------------------------- *)
    val app_sym = Symbol.varSymbol("internal_app")
    val app_lab = symbol2label app_sym
    val app_exp = Ast.VarExp [app_sym]
    val app_pat = Ast.VarPat [app_sym]


    (* -----------------------------------------------------------------------------      
      Utility functions for checking if an expression or path is infix and if so
        what its fixity is.  Also convert Fixity.fixity to precedence levels(1-9)
      ----------------------------------------------------------------------------- *)
    fun fixity_to_level (Fixity.NONfix) = error "no level for NONfix"
      | fixity_to_level (Fixity.INfix (a,b)) = a div 2
    fun path_fixity_lookup path [] = NONE
      | path_fixity_lookup [s] ((l,f)::rest) = if (eq_label(l,symbol2label s)) then SOME f 
					       else path_fixity_lookup [s] rest
      | path_fixity_lookup _ _ = NONE
    fun exp_fixity_lookup table (Ast.VarExp p) = path_fixity_lookup p table
      | exp_fixity_lookup table (Ast.MarkExp (e,r)) = exp_fixity_lookup table e
      | exp_fixity_lookup _ _ = NONE
    fun pat_fixity_lookup table (Ast.VarPat p) = path_fixity_lookup p table
      | pat_fixity_lookup table (Ast.MarkPat (p,r)) = pat_fixity_lookup table p
      | pat_fixity_lookup _ _ = NONE

    (* ----------------------------------------------------------------------
      driver is the main work routine.  
      It takes a list of objects, 
	        a routine for printing objects,
		  a routine to look up the fixity/precedence of a possibly infix object,
               a predicate for whether an object is applicable,
		  a unique application object,
		  a routine to perform an application,
	        a routine to perform a tupling.
           and a recurser,
           and returns minimal list of nested AppExps and TupleExps.
      If is_app is true, then the list will be of length 1.
      Otherwise, implicit application is not assumed so
          that the result list may be of arbitrary length.
      ---------------------------------------------------------------------- *)
    fun driver(objlist       : ''a list, 	
	       print_obj     : ''a -> unit,
	       get_fixity    : ''a -> Fixity.fixity option, 
	       is_app        : ''a -> bool,
	       app_obj       : ''a, 
	       apper         : ''a * ''a -> ''a, 
	       tupler        : ''a list -> ''a,
	       recurs        : (''a list -> ''a list) -> ''a -> ''a)
      : ''a list = 
      let
	fun get_fix obj = (case (get_fixity obj) of
			     NONE => (print "obj has no fixity: ";
				      print_obj obj;
				      print "\n";
				      error "no fixity for this obj")
			   | SOME f => f)
	(* --------------------------------------------------------
	 normalize takes the FlatAppExp and returns a list of exps 
            with implicit application made explicit;
            at the same time, preclist is updated to contain only 
	     the precendence levels we need to collapse 
	     -------------------------------------------------- *)
	fun normalize (objlist : ''a list) : (''a list * int list) = 
	  let 
	    val preclist = ref []
	    fun is_infix obj =  (case (get_fixity obj) of
				   NONE => false
				 | SOME f => true)
	    fun add_prec e = (case (get_fixity e) of
				NONE => ()
			      | SOME f =>
				  let val level = fixity_to_level f
				  in if (List.exists (fn x => x = level) (!preclist)) then ()
				     else preclist := level::(!preclist)
				  end)
	    fun reduced_self objs = driver(objs, print_obj, get_fixity, is_app, 
					   app_obj, apper, tupler, recurs)
	    val flattened : ''a list = map (recurs reduced_self) objlist
	    fun loop (e1::e2::rest) = (add_prec e1;
				       if ((not (is_app e1)) orelse (is_infix e1) orelse (is_infix e2))
					 then e1::(loop (e2::rest)) else 
					   (add_prec app_obj; e1 :: app_obj :: (loop (e2 :: rest))))
	      | loop leftover = leftover
	    val objs = loop flattened
	    val _ = debugdo (fn () => (print "objs are\n"; 
				       app (fn e => (print_obj e; print "\n")) objs; print "\n"))
	  in  (objs, !preclist)
	  end
	(* --------------------------------------------------------
	 takes a precedence level and a list of expression and collapses the list
	 of all left AND right associative operators at that precendence level
	   -------------------------------------------------------- *)
	fun collapse cur_prec acc = 
	  let
            fun rewrite(op1,v1,v2) = 
	      let 
		val (f,a) = if (app_obj = op1) then (v1,v2) else (op1,tupler([v1,v2]))
	      in  apper(f,a)
	      end
            fun right_rewrite_list(v2::op1::v1::rest) = right_rewrite_list((rewrite(op1,v1,v2))::rest)
	      | right_rewrite_list [e] = e
	      | right_rewrite_list _ = error "right_rewrite_list got ill-formed exp list"
	     (* --------------------------------------------------------
	     The list we maintain is of the form "var op var op var ...".
	      We scan left to right until we find the first operator of that precendence.
	      If the operator is left-associative, we rewrite that operator. 
		 If the operator is right-associative, we scan oprators to the right
		 until we come to the end or find an operator that is not right-associative
		 and of the current precendence.  We take this subsequence and
		 right-rewrite it. 
		 -------------------------------------------------------- *)
	    fun scan (v1::op1::v2::rest) = (if ((get_fix op1) = Fixity.infixleft cur_prec)
					      then scan ((rewrite(op1,v1,v2)) :: rest)
					    else if ((get_fix op1) = Fixity.infixright cur_prec)
						   then scan(rightscan rest [v2,op1,v1])
						 else v1::op1::(scan (v2::rest)))
              | scan [e] = [e]
              | scan _ = raise (BUG "scan encountered ill-formed expression")
            and rightscan (op1::v2::rest) acc = if ((get_fix op1) = Fixity.infixright cur_prec)
						   then rightscan rest (v2::op1::acc)
						 else (right_rewrite_list acc)::op1::v2::rest
	      | rightscan [] acc = [right_rewrite_list acc]
              | rightscan _ acc = raise (BUG "rightscan encountered ill-formed expression")
	  in
	    scan acc
	  end

	(* -------------------------------------------------------------
	 call normalize to do implcit aplpication and compute precedence 
	 levels that are used.  then sort the precendence levels and
	 iterate over the sorted precedence levels from highest to lowest
       and calls collapse repeatedlty 
	  ------------------------------------------------------------- *)
	val (normed_list,preclist) = normalize objlist
	val descending_prec_list = Sort.sort (op <) preclist

      in foldl (fn (n,acc) => collapse n acc) normed_list descending_prec_list 
      end

    fun parse_exp (table : fixity_table, exp_list : Ast.exp list) = 
      let
	val table = (app_lab, Fixity.infixleft 3) :: table
	val _ = debugdo (fn () => 
			  (print "parse_exp: table is\n";
			   app (fn (s,f) => (Ppil.pp_label s;
					     print " -> "; 
					     print (case f of
						      Fixity.NONfix => "nonfix"
						    | Fixity.INfix(a,b) => (makestring a) ^ "," ^ 
							(makestring b));
					     print "\n")) table;
			   print "\n"))
	fun apper (f,a) = Ast.AppExp{function=f,argument=a}
	val tupler = Ast.TupleExp
	fun exp_recurse reduced_driver e = e
      in
	case driver(exp_list,
		    pp_exp,
		    exp_fixity_lookup table, 
		    fn _ => true,
		    app_exp,
		    apper,
		    tupler,
		    exp_recurse) of
	  [e] => (debugdo (fn () => (print "e is "; pp_exp e; print "\n")); e)
	| elist => (print "done with all precedence level and still have a list of exps";
		    app (fn e => (pp_exp e; print "\n")) elist;
		    print "\n";
		    error "done with all precedence level and still have a list of exps")
      end
    fun parse_pat (table : fixity_table, 
		   is_constr : Ast.symbol -> bool, 
		   pat_list : Ast.pat list) : Ast.pat list = 
      let
	val _ = debugdo (fn () => (print "entered parse_pat\n"))
	val table = (app_lab, Fixity.infixleft 3) :: table
	fun apper (f,a) = Ast.AppPat{constr=f,argument=a}
	val tupler = Ast.TuplePat
	fun is_applicable (Ast.VarPat [s]) = is_constr s
	  | is_applicable _ = false
	fun pat_recurse (reduced_driver : Ast.pat list -> Ast.pat list) (pat : Ast.pat) : Ast.pat = 
	  let val self = pat_recurse reduced_driver 
	  in
	    (case pat of
	       (Ast.WildPat | Ast.VarPat _ | Ast.IntPat _ | Ast.WordPat _ | 
		Ast.RealPat _ | Ast.StringPat _ | Ast.CharPat _) => pat
	      | Ast.RecordPat {def,flexibility} => Ast.RecordPat{def=map (fn (s,p) => (s,self p)) def,
								 flexibility=flexibility}
	      | Ast.ListPat pats => Ast.ListPat (map self pats)
	      | Ast.TuplePat pats => Ast.TuplePat (map self pats)
	      | Ast.FlatAppPat fixpats => let val pats = map (fn {item,...} => item) fixpats
					  in (case (reduced_driver pats) of
						[p] => p
					      | pats => (print "reduced_driver returned multiple patterns";
							 app (fn p => (pp_pat p; print "\n")) pats;
							 error "reduced_driver returned multiple patterns"))
					  end
	      | Ast.AppPat {constr,argument} => Ast.AppPat {constr=self constr,argument=self argument}
	      | Ast.ConstraintPat {pattern,constraint} => Ast.ConstraintPat {pattern=self pattern,constraint=constraint}
	      | Ast.LayeredPat {varPat,expPat} => Ast.LayeredPat {varPat=self varPat, expPat=self expPat} 
	      | Ast.VectorPat pats => Ast.VectorPat (map self pats)
	      | Ast.MarkPat (p,r) => Ast.MarkPat(self p,r)
	      | Ast.OrPat pats => Ast.OrPat (map self pats))
	  end
	val res = driver(pat_list, 
			 pp_pat,
			 pat_fixity_lookup table, 
			 is_applicable,
			 app_pat, 
			 apper, 
			 tupler, 
			 pat_recurse)
	val _ = debugdo (fn () => (print "leaving parse_pat\n"))
      in res
      end



  end;