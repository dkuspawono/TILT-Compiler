(*$InfixParse : UTIL AST ASTHELP *)
functor InfixParse(structure Il : IL
		   structure Ppil : PPIL
		   structure AstHelp : ASTHELP
		   sharing Ppil.Il = Il)
  : INFIXPARSE = 
  struct

    structure Il = Il

    structure Symbol = Compiler.Symbol
    structure Fixity = Fixity

    open Il
    open Util AstHelp Listops Name

    val debug = ref false
    fun debugdo t = if (!debug) then (t(); ()) else ()
    val error = fn s => error "infixparse.sml" s

    (* ----------------------------------------------------------------------      
      Useful values to make application explicit
      ---------------------------------------------------------------------- *)
    val app_sym = Symbol.varSymbol("internal_app")
    val app_lab = symbol_label app_sym
    val app_exp = Ast.VarExp [app_sym]
    val app_pat = Ast.VarPat [app_sym]


    (* -----------------------------------------------------------------------------      
      Utility functions for checking if an expression or path is infix and if so
        what its fixity is.  Also convert Fixity.fixity to precedence levels(1-9)
      ----------------------------------------------------------------------------- *)
    fun fixity_to_level (Fixity.NONfix) = error "no level for NONfix"
      | fixity_to_level (Fixity.INfix (a,b)) = a div 2
    fun path_fixity_lookup path [] = NONE
      | path_fixity_lookup [s] ((l,f)::rest) = if (eq_label(l,symbol_label s)) then SOME f 
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
           and returns minimal list of nested AppExps and TupleExps.
      If is_applicable is true, then the list will be of length 1.
      Otherwise, implicit application is not assumed so
          that the result list may be of arbitrary length.
      ---------------------------------------------------------------------- *)
    fun driver(objlist       : ''a list, 	
	       print_obj     : ''a -> unit,
	       get_fixity    : ''a -> Fixity.fixity option, 
	       is_app        : ''a -> bool,
	       convert       : ''a -> ''b,
	       app_obj       : ''a, 
	       apper         : ''a * ''a -> ''a, 
	       tupler        : ''a list -> ''a)
      : ''b list = 
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
	    fun is_infix obj =  (case (get_fixity (obj)) of
				     NONE => false
				   | SOME f => true)
	    fun add_prec e = (case (get_fixity e) of
				  NONE => ()
				| SOME f =>
				      let val level = fixity_to_level f
				      in if (List.exists (fn x => x = level) (!preclist)) then ()
					 else preclist := level::(!preclist)
				      end)
	    fun loop (e1::e2::rest) = 
		(add_prec e1;
		 if ((not (is_app e1)) orelse (is_infix e1) orelse (is_infix e2))
		     then e1::(loop (e2::rest)) else 
			 (add_prec app_obj; 
			  e1 :: app_obj :: (loop (e2 :: rest))))
	      | loop leftover = leftover
	    val objs = loop objlist
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
	      in apper(f,a)
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
					      then scan (rewrite(op1,v1,v2) :: rest)
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
	val descending_prec_list = ListMergeSort.sort (op <) preclist
	val res = foldl (fn (n,acc) => collapse n acc) normed_list descending_prec_list 
      in map convert res
      end


    fun parse_exp (table : fixity_table, Ast.FlatAppExp exp_fix_list) = 
      let
	val table = (app_lab, Fixity.infixleft 10) :: table
	val _ = debugdo (fn () => 
			  (print "parse_exp: table is\n";
			   app (fn (s,f) => (Ppil.pp_label s;
					     print " -> "; 
					     print (case f of
						      Fixity.NONfix => "nonfix"
						    | Fixity.INfix(a,b) => (Int.toString a) ^ "," ^ 
							  (Int.toString b));
					     print "\n")) table;
			   print "\n"))
	fun apper ((_,f),(_,a)) = (false,Ast.AppExp{function=f,argument=a})
	fun tupler (args : (bool * Ast.exp) list) = (false,Ast.TupleExp(map #2 args))
	fun exp_recurse reduced_driver e = e
      in
	case driver(map (fn {item,fixity=NONE,...} => (false, item)
			  | {item,fixity=SOME _,...} => (true,item)) exp_fix_list,
		    fn (_,e) => pp_exp e,
		    fn (false,_) => NONE
		     | (true,e) => exp_fixity_lookup table e, 
		    fn _ => true,
		    fn (_,e) => e,
		    (true,app_exp),
		    apper,
		    tupler) of
	  [e] => (debugdo (fn () => (print "e is "; pp_exp e; print "\n")); e)
	| elist => (print "done with all precedence level and still have a list of exps";
		    app (fn e => (pp_exp e; print "\n")) elist;
		    print "\n";
		    error "done with all precedence level and still have a list of exps")
      end
      | parse_exp (table : fixity_table, e) = e

    fun parse_pat (table : fixity_table, 
		   is_constr : Ast.symbol list -> bool, 
		   pat_list : Ast.pat list) : Ast.pat list = 
      let
	fun self arg = parse_pat(table,is_constr,arg)
	fun self_one arg = (case (parse_pat(table,is_constr,[arg])) of
				[p] => p
			      | _ => error "parse_pat on subcall yielded multiple patterns")
	val _ = debugdo (fn () => (print "entered parse_pat\n"))
	val table = (app_lab, Fixity.infixleft 10) :: table  
	fun apper (f,a) = Ast.AppPat{constr=f,argument=a}
	val tupler = Ast.TuplePat
	fun is_applicable (Ast.VarPat p) = is_constr p
	  | is_applicable _ = false
	fun help (pat : Ast.pat) : Ast.pat = 
	    (case pat of
		 (Ast.WildPat | Ast.VarPat _ | Ast.IntPat _ | Ast.WordPat _ | 
		  Ast.StringPat _ | Ast.CharPat _) => pat
		| Ast.RecordPat {def,flexibility} => Ast.RecordPat{def=map (fn (s,p) => (s,self_one p)) def,
								   flexibility=flexibility}
	      | Ast.ListPat pats => Ast.ListPat (map self_one pats)
	      | Ast.TuplePat pats => Ast.TuplePat (map self_one pats)
	      | Ast.FlatAppPat fixpats => let val pats = map (fn {item,...} => item) fixpats
					      val pats' = map self_one pats
					  in case (self pats') of
					      [p] => p
					    | _ => error "parse_pat on subcall yielded multiple patterns"
					  end
	      | Ast.AppPat {constr,argument} => Ast.AppPat {constr=self_one constr,argument=self_one argument}
	      | Ast.ConstraintPat {pattern,constraint} => Ast.ConstraintPat {pattern=self_one pattern,
									     constraint=constraint}
	      | Ast.LayeredPat {varPat,expPat} => Ast.LayeredPat {varPat=self_one varPat, expPat=self_one expPat} 
	      | Ast.VectorPat pats => Ast.VectorPat (map self_one pats)
	      | Ast.MarkPat (p,r) => Ast.MarkPat(self_one p,r)
	      | Ast.OrPat pats => Ast.OrPat (map self_one pats))
	  val pat_list' = map help pat_list
	  val res = driver(pat_list', 
			   pp_pat,
			   pat_fixity_lookup table, 
			   is_applicable,
			   fn x => x,
			   app_pat, 
			   apper, 
			   tupler)
	  val _ = debugdo (fn () => (print "leaving parse_pat\n"))
      in res
      end



  end;
