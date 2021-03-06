(* Helper routines on the EL syntax tree AST *)
(* See CVS revision 1.15 for PvalDec and PletExp. *)
structure AstHelp : ASTHELP =
  struct

    structure Formatter = Formatter

    open Ast Util Listops Formatter

    val error = fn s => error "asthelp.sml" s

    val true_path = [Symbol.varSymbol "true"]
    val false_path = [Symbol.varSymbol "false"]
    val nil_path = [Symbol.varSymbol "nil"]
    val cons_path = [Symbol.varSymbol "::"]  (* NOT fixSymbol evn though it's infix *)
    val true_exp = Ast.VarExp true_path
    val false_exp = Ast.VarExp false_path
    val true_pat = Ast.VarPat(true_path)
    val false_pat = Ast.VarPat(false_path)
    val nil_exp = Ast.VarExp nil_path
    val cons_exp = Ast.VarExp cons_path

    fun tyvar_strip (Ast.Tyv s) = s
      | tyvar_strip (Ast.TempTyv _) = error "should not see this after parsing"
      | tyvar_strip (Ast.MarkTyv (tv,r)) = tyvar_strip tv
    fun db_strip (Ast.Db {tyc,tyvars,rhs}) = (tyc,tyvars,rhs)
      | db_strip (Ast.MarkDb(db,r)) = db_strip db
    fun tb_strip (Ast.MarkTb(tb,r)) = tb_strip tb
      | tb_strip (Ast.Tb {tyc,tyvars,def}) = (tyc,tyvars,def)
    fun strb_strip (Ast.MarkStrb (strb,r)) = strb_strip strb
      | strb_strip (Ast.Strb {name,def,constraint}) = (name,(def,constraint))
    fun vb_strip (Ast.MarkVb (vb,r)) = vb_strip vb
      | vb_strip (Ast.Vb {pat,exp}) = (pat,exp)
    fun fb_strip (Ast.Fb arg) = arg
      | fb_strip (Ast.MarkFb (fb,r)) = fb_strip fb

    fun exp_strip (Ast.MarkExp (e,_)) = exp_strip e
      | exp_strip e = e

    fun eq_tyvar(Tyv s1, Tyv s2) = Symbol.eq(s1,s2)
      | eq_tyvar(TempTyv s1, TempTyv s2) = Symbol.eq(s1,s2)
      | eq_tyvar(MarkTyv(tv1,_), tv2) = eq_tyvar(tv1,tv2)
      | eq_tyvar(tv1,MarkTyv(tv2,_)) = eq_tyvar(tv1,tv2)
      | eq_tyvar _ = false

    fun tyvar_member(elem : Ast.tyvar, list) = member_eq(eq_tyvar, elem, list)

    local
      fun is_tyvar_bound (tyvar,symlist) = member_eq(Symbol.eq,tyvar_strip tyvar,symlist)
      fun is_var_bound ([sym],symlist) = member_eq(Symbol.eq,sym,symlist)
	| is_var_bound _ = false
      fun f_ty (state as (doconstr, constrbound : symbol list,
			  doty, tybound : symbol list,
			  dovar, varbound : symbol list)) (ty : Ast.ty) : Ast.ty =
	(case ty of
	   Ast.VarTy tyvar => if (is_tyvar_bound(tyvar,tybound)) then ty else doty tyvar
	 | Ast.ConTy (typath,tylist) =>
	       let 
                   fun dosym s = if member_eq(Symbol.eq,s,constrbound) then s else doconstr s
		   val typath = (case typath of TypathHead(s) => TypathHead(dosym s)
		                              | TypathProj(modpath,s) => TypathProj(modpath, dosym s)
				              | _ => typath)
	       in Ast.ConTy(typath,map (f_ty state) tylist)
	       end
	 | Ast.RecordTy (symty_list) => Ast.RecordTy(map (fn (s,ty) => (s, f_ty state ty)) symty_list)
	 | Ast.TupleTy tylist => Ast.TupleTy(map (f_ty state) tylist)
	 | Ast.MarkTy (ty,r) => f_ty state ty)
      fun f_exp (state as (doconstr, constrbound,
			   doty, tybound,
			   dovar, varbound : symbol list)) (exp : Ast.exp) : Ast.exp =
	let val self = f_exp state
	in
	  (case exp of
	     Ast.VarExp var => if (is_var_bound(var,varbound)) then exp else dovar var
	   | Ast.IntExp _ => exp
	   | Ast.WordExp _ => exp
	   | Ast.RealExp _ => exp
	   | Ast.StringExp _ => exp
	   | Ast.CharExp _ => exp
	   | Ast.SelectorExp _ => exp
	   | (Ast.ListExp elist) => Ast.ListExp(map self elist)
	   | (Ast.TupleExp elist) => Ast.TupleExp(map self elist)
	   | (Ast.VectorExp elist) => Ast.VectorExp(map self elist)
	   | (Ast.SeqExp elist) => Ast.SeqExp(map self elist)
	   | (Ast.AndalsoExp (e1,e2)) => Ast.AndalsoExp(f_exp state e1,f_exp state e2)
	   | (Ast.OrelseExp (e1,e2)) => Ast.OrelseExp(f_exp state e1,f_exp state e2)
	   | (Ast.FnExp rlist) => Ast.FnExp(map (f_rule state) rlist)
	   | (Ast.FlatAppExp exp_fix_list) => Ast.FlatAppExp
		 (map (fn {item,fixity,region} => {item=self item,fixity=fixity,region=region}) exp_fix_list)
	   | (Ast.AppExp {function,argument}) => Ast.AppExp{function=self function,
							    argument=self argument}
	   | (Ast.CaseExp {expr,rules}) => Ast.CaseExp{expr=self expr,rules=map (f_rule state) rules}
	   | (Ast.HandleExp {expr,rules}) => Ast.HandleExp{expr=self expr,rules=map (f_rule state) rules}
	   | (Ast.LetExp {dec,expr}) => Ast.LetExp{dec=f_dec state dec, expr=self expr}
	   | (Ast.RecordExp symexp_list) => Ast.RecordExp(map (fn (s,e) => (s,self e)) symexp_list)
	   | (Ast.ConstraintExp {expr,constraint}) => Ast.ConstraintExp{expr=self expr,
									constraint=f_ty state constraint}
	   | (Ast.RaiseExp e) => Ast.RaiseExp(self e)
	   | (Ast.IfExp {test,thenCase,elseCase}) => Ast.IfExp{test=self test,
							       thenCase=self thenCase,
							       elseCase=self elseCase}
	   | (Ast.WhileExp {test,expr}) => Ast.WhileExp{test=self test,
							expr=self expr}
	   | (Ast.MarkExp (e,r)) => Ast.MarkExp(self e,r)
	   | (Ast.CcallExp (e, es)) => error "Don't handle Ccall expressions")
	end
      and f_rule state (Ast.Rule {pat,exp}) = Ast.Rule{pat=f_pat state pat, exp=f_exp state exp}
      and f_pat state pat =
	(case pat of
	     Ast.WildPat  => pat
	   | Ast.VarPat _  => pat
	   | Ast.IntPat _  => pat
	   | Ast.WordPat _  => pat
	   | Ast.StringPat _  => pat
	   | Ast.CharPat _ => pat
	   | (Ast.RecordPat{def,flexibility}) => Ast.RecordPat{def=(map (fn(s,p) => (s,f_pat state p)) def),
								 flexibility=flexibility}
 	 | (Ast.ListPat plist) => Ast.ListPat(map (f_pat state) plist)
	 | (Ast.VectorPat plist) => Ast.VectorPat(map (f_pat state) plist)
	 | (Ast.TuplePat plist) => Ast.TuplePat(map (f_pat state) plist)
	 | (Ast.FlatAppPat pat_fixitem_list) =>
	         Ast.FlatAppPat(map (fn {item,fixity,region} =>
				     {item=f_pat state item,fixity=fixity,region=region}) pat_fixitem_list)
	 | (Ast.AppPat {constr,argument}) => Ast.AppPat{constr=f_pat state constr,
						    argument=f_pat state argument}
 	 | (Ast.LayeredPat {varPat,expPat}) => Ast.LayeredPat{varPat=f_pat state varPat,
								  expPat=f_pat state expPat}
	 | (Ast.ConstraintPat {pattern,constraint}) => Ast.ConstraintPat{pattern=f_pat state pattern,
									     constraint=f_ty state constraint}
	 | (Ast.MarkPat (p,r)) => Ast.MarkPat(f_pat state p,r))

      and f_dec (state as (doconstr, constrbound,
			   doty, tybound,
			   dovar, varbound : symbol list)) dec =
	(case dec of
	  Ast.ValDec (vb_list,rvb_list,tvr) =>
		Ast.ValDec (map (f_vb state) vb_list, map (f_vb state) rvb_list, tvr)
	| Ast.FunDec (fb_list,tvr) => Ast.FunDec (map (f_fb state) fb_list, tvr)
	| Ast.TypeDec tb_list => Ast.TypeDec (map (f_tb state) tb_list)
	| Ast.DatatypeDec {datatycs,withtycs} =>
	      let val newconstr = map (fn db => let val (tyc,_,_) = db_strip db
						in tyc
						end) datatycs
		  val state = (doconstr, newconstr @ constrbound,
			       doty, tybound,
			       dovar,varbound)
	      in Ast.DatatypeDec{datatycs=map (f_db state) datatycs,
				 withtycs=map (f_tb state) withtycs}
	      end
	| Ast.AbstypeDec{abstycs,withtycs,body} => Ast.AbstypeDec{abstycs=map (f_db state) abstycs,
								  withtycs=map (f_tb state) withtycs,
								  body=f_dec state body}
	| Ast.ExceptionDec eb_list => Ast.ExceptionDec (map (f_eb state) eb_list)
	| Ast.StrDec strb_list => Ast.StrDec (map (f_strb state) strb_list)
	| Ast.StrRecDec {name,def,constraint} =>
	      Ast.StrRecDec{name=name,def=f_strexp state def,constraint=f_sigexp state constraint}
	| Ast.SigDec sigb_list => Ast.SigDec (map (f_sigb state) sigb_list)
	| Ast.LocalDec (d1,d2) => Ast.LocalDec(f_dec state d1, f_dec state d2)
	| Ast.SeqDec dec_list => Ast.SeqDec(map (f_dec state) dec_list)
	| Ast.OpenDec _ => dec
	| Ast.OvldDec _ => error "Don't handle overloading declaration"
	| Ast.FixDec _ => dec
	| Ast.ImportDec _ => dec
	| Ast.ExternDec (sym,ty) => error "Don't handle extern declarations"
	| Ast.MarkDec (dec,r) => Ast.MarkDec(f_dec state dec,r))
      and f_vb state (Ast.Vb{pat,exp}) = Ast.Vb{pat=f_pat state pat,exp=f_exp state exp}
	| f_vb state (Ast.MarkVb(vb,r)) = Ast.MarkVb(f_vb state vb,r)
      and f_fb state (Ast.Fb clauses) = Ast.Fb(map (f_clause state) clauses)
	| f_fb state (Ast.MarkFb(fb,r)) = Ast.MarkFb(f_fb state fb,r)
      and f_clause state (Ast.Clause{pats,resultty,exp}) =
		Ast.Clause{pats=map (fn {item,fixity,region} =>
				     {item=f_pat state item,fixity=fixity,region=region}) pats,
			   resultty=case resultty of NONE => NONE | SOME ty => SOME(f_ty state ty),
			   exp=f_exp state exp}
      and f_tb (state as (doconstr,constrbound,doty,tybound,dovar,varbound)) (Ast.Tb{tyc,def,tyvars}) =
	let val newbound = tybound @ (map tyvar_strip tyvars)
	  val newstate = (doconstr,constrbound,doty,newbound,dovar,varbound)
	in Ast.Tb{tyc=tyc,def=f_ty newstate def, tyvars=tyvars}
	end
	| f_tb state (Ast.MarkTb(tb,r)) = Ast.MarkTb(f_tb state tb,r)
      and f_db (state as (doconstr,constrbound,
			  doty,tybound,
			  dovar, varbound : symbol list)) (Ast.Db{tyc,rhs,tyvars}) =
	  let val newbound = tybound @ (map tyvar_strip tyvars)
	      val newstate = (doconstr,constrbound,doty,newbound,dovar,varbound)
	      val rhs' = (case rhs of
			      Repl _ => rhs
			    | Constrs sym_tys =>
				  Constrs(map (fn (s,SOME ty) => (s,SOME(f_ty newstate ty))
                                		| (s,NONE) => (s,NONE)) sym_tys))
	  in  Ast.Db{rhs=rhs',
		     tyc=tyc,
		     tyvars=tyvars}
	  end
	| f_db state (Ast.MarkDb(db,r)) = Ast.MarkDb(f_db state db,r)
      and f_eb state (Ast.EbGen{exn,etype=NONE}) = Ast.EbGen{exn=exn,etype=NONE}
	| f_eb state (Ast.EbGen{exn,etype=SOME ty}) = Ast.EbGen{exn=exn,etype=SOME (f_ty state ty)}
	| f_eb state (Ast.EbDef blob) = Ast.EbDef blob
	| f_eb state (Ast.MarkEb(eb,r)) = Ast.MarkEb(f_eb state eb,r)
      and f_strb state (Ast.Strb {name,def,constraint}) =
	  Ast.Strb{name=name,def=f_strexp state def,
		   constraint=case constraint of
		   Ast.NoSig => Ast.NoSig
		 | Ast.StrongOpaque se => Ast.StrongOpaque(f_sigexp state se)
		 | Ast.WeakOpaque se => Ast.WeakOpaque(f_sigexp state se)
		 | Ast.Transparent se => Ast.Transparent(f_sigexp state se)}
	| f_strb state (Ast.MarkStrb(strb,r)) = Ast.MarkStrb(f_strb state strb,r)
      and f_sigb state (Ast.Sigb{name,def}) = Ast.Sigb{name=name,def=f_sigexp state def}
	| f_sigb state (Ast.MarkSigb(sigb,r)) = Ast.MarkSigb(f_sigb state sigb,r)
      and f_strexp state strexp =
	(case strexp of
	   Ast.VarStr _ => strexp
	 | Ast.BaseStr dec => Ast.BaseStr (f_dec state dec)
	 | Ast.ConstrainedStr (strexp,constraint) =>
	       Ast.ConstrainedStr (f_strexp state strexp,
				   (case constraint of
					Ast.NoSig => Ast.NoSig
				      | Ast.Transparent se => Ast.Transparent(f_sigexp state se)
				      | Ast.StrongOpaque se => Ast.StrongOpaque(f_sigexp state se)
				      | Ast.WeakOpaque se => Ast.WeakOpaque(f_sigexp state se)))
	 | Ast.AppStr (p,strexp_bool_list) => Ast.AppStr(p, map
							 (fn(s,b) => (f_strexp state s,b)) strexp_bool_list)
	 | Ast.LetStr (dec, strexp) => Ast.LetStr(f_dec state dec, f_strexp state strexp)
	 | Ast.MarkStr (s,r) => Ast.MarkStr(f_strexp state s,r)
	 | Ast.BaseFct {params,body,constraint} =>
	     Ast.BaseFct{params=map (fn (so,sigexp) => (so,f_sigexp state sigexp)) params,
			 body=f_strexp state body,
			 constraint=(case constraint of
					 Ast.NoSig => Ast.NoSig
				       | Ast.Transparent se => Ast.Transparent(f_sigexp state se)
				       | Ast.StrongOpaque se => Ast.StrongOpaque(f_sigexp state se)
				       | Ast.WeakOpaque se => Ast.WeakOpaque(f_sigexp state se))})
      and f_sigexp state (Ast.VarSig s) = Ast.VarSig s
	| f_sigexp state (Ast.BaseSig speclist) = Ast.BaseSig(map (f_spec state) speclist)
	| f_sigexp state (Ast.RdsSig speclist) = Ast.RdsSig(map (f_spec state) speclist)
	| f_sigexp state (Ast.MarkSig (se,r)) = Ast.MarkSig(f_sigexp state se,r)
	| f_sigexp state (Ast.AugSig (se,_)) = error "f_sigexp AugSig unimplemented"
      and f_spec (state as (doconstr,constrbound,
			    doty,tybound,
			    dovar, varbound : symbol list)) spec =
	(case spec of
	   Ast.StrSpec s_se_popt_list =>
	       let fun mapper (s,se,popt) = (s,f_sigexp state se,popt)
	       in  Ast.StrSpec (map mapper s_se_popt_list)
	       end
	 | Ast.TycSpec (s_tvs_tyop_list,b) =>
	     Ast.TycSpec(map (fn (s,tvs,tyopt) =>
			      let val newbound =  tybound @ (map tyvar_strip tvs)
				val newstate = (doconstr,constrbound,doty,newbound,dovar,varbound)
			      in (s,tvs,case tyopt of
				  NONE => NONE
				| SOME ty => SOME(f_ty newstate ty))
			      end) s_tvs_tyop_list, b)
	| Ast.FctSpec s_fse_list => Ast.FctSpec(map (fn (s,fse) => (s,f_sigexp state fse)) s_fse_list)
	| Ast.ValSpec s_ty_list => Ast.ValSpec (map (fn (s,ty) => (s,f_ty state ty)) s_ty_list)
	| Ast.DataSpec{datatycs,withtycs} => Ast.DataSpec{datatycs=map (f_db state) datatycs,
							 withtycs=map (f_tb state) withtycs}
	| Ast.ExceSpec s_to_list => Ast.ExceSpec(map (fn (s,NONE) => (s,NONE)
	                                    | (s,SOME ty) => (s,SOME(f_ty state ty))) s_to_list)
	| Ast.ShareStrSpec _ => spec
	| Ast.ShareTycSpec _ => spec
	| Ast.IncludeSpec s => Ast.IncludeSpec (f_sigexp state s)
(*	| Ast.OpenSpec _ => spec
        | Ast.LocalSpec (slist1,slist2) => Ast.LocalSpec(map (f_spec state) slist1,
							 map (f_spec state) slist2) *)
	| Ast.MarkSpec (s,r) => Ast.MarkSpec(f_spec state s, r))

    in

      fun subst_vars_exp (subst : (Symbol.symbol * Ast.path) list, e : Ast.exp) : Ast.exp =
	let
	  fun do_tyvar tyvar = Ast.VarTy tyvar
	  fun do_var [sym] =
	    let fun loop [] = Ast.VarExp[sym]
		  | loop ((p,s)::rest) = if (Symbol.eq(p,sym))
					     then Ast.VarExp(s) else loop rest
	    in loop subst
	    end
	    | do_var syms = Ast.VarExp syms
	  val e = f_exp (fn s => s, [],do_tyvar,[],do_var,[]) e
	in e
	end

      fun ty2sym (Ast.Tyv s) = s
	| ty2sym (Ast.TempTyv _) = error "should not see this after parsing"
	| ty2sym (Ast.MarkTyv(ty,_)) = ty2sym ty

      fun subst_vars_ty (subst : (Symbol.symbol * Ast.tyvar) list, ty : Ast.ty) : Ast.ty =
	let
	  fun do_tyvar tyvar =
            let val sym = ty2sym tyvar
	        fun loop [] = Ast.VarTy tyvar
                  | loop ((s,v)::rest) = if (Symbol.eq(s,sym))
					     then Ast.VarTy v else loop rest
	    in loop subst
	    end
	  fun do_var syms = Ast.VarExp syms
	  val ty = f_ty (fn s => s,[],do_tyvar,[],do_var,[]) ty
	in ty
	end


      fun free_tyvar_ty (ty : Ast.ty, is_bound) : symbol list =
	let
	    val tyvars = ref ([] : Ast.tyvar list)
	    fun do_tyvar tyvar = (if ((is_bound (ty2sym tyvar)) orelse
				      (tyvar_member(tyvar,!tyvars)))
				      then ()
				  else tyvars := tyvar :: (!tyvars);
				      Ast.VarTy tyvar)
	    val _ = f_ty (fn s => s, [],
			  do_tyvar, [],
			  fn v => Ast.VarExp v,[]) ty
	in map tyvar_strip (rev (!tyvars))
	end

      fun free_tyvar_exp(e : Ast.exp, is_bound) : symbol list =
	     let
	       val tyvars = ref ([] : Ast.tyvar list)
	    fun do_tyvar tyvar = (if ((is_bound (ty2sym tyvar)) orelse
				      (tyvar_member(tyvar,!tyvars)))
				      then ()
				  else tyvars := tyvar :: (!tyvars);
				      Ast.VarTy tyvar)
	       val _ = f_exp (fn s => s, [],do_tyvar,[],fn v => Ast.VarExp v,[]) e
	       val free_tvs = map tyvar_strip (!tyvars)
	     in free_tvs
	     end

      fun free_tyvar_dec(d : Ast.dec, is_bound) : symbol list =
	     let
	       val tyvars = ref ([] : Ast.tyvar list)
	    fun do_tyvar tyvar = (if ((is_bound (ty2sym tyvar)) orelse
				      (tyvar_member(tyvar,!tyvars)))
				      then ()
				  else tyvars := tyvar :: (!tyvars);
				      Ast.VarTy tyvar)
	       val _ = f_dec (fn s => s, [],do_tyvar,[],fn v => Ast.VarExp v,[]) d
	       val free_tvs = map tyvar_strip (!tyvars)
	     in free_tvs
	     end

      (* finds all free type variables in (e : Ast.exp) not in context *)
      fun free_tyc_ty(ty : Ast.ty, is_bound) : symbol list =
	let
	  val constrs = ref ([] : symbol list)
	  fun do_constr s = (if (not (is_bound s))
				then constrs := s :: (!constrs)
			     else ();
				 s)
	  fun do_tyvar tyvar = Ast.VarTy tyvar
	  val _ = f_ty (do_constr,[],
			do_tyvar,[],
			fn v => Ast.VarExp v,[]) ty
	in !constrs
	end

    end

    fun pp_region s1 s2 fmt = HOVbox((String s1) :: (fmt @ [String s2]))
    fun pp_list doer objs (left,sep,right,break) =
      let
	fun loop [] = [String right]
	  | loop [a] = [doer a, String right]
	  | loop (a::rest) = (doer a) :: (String sep) :: Break :: (loop rest)
	val fmts = (String left) :: (loop objs)
      in (if break then Vbox0 else HOVbox0 1) (size left) 1 fmts
      end
    val pp_listid = pp_list (fn x => x)

    fun pp_sym (s : Symbol.symbol) = String (Symbol.name s)
    fun pp_tyvar (Tyv s) = pp_sym s
      | pp_tyvar (TempTyv _) = error "should not see this after parsing"
      | pp_tyvar (MarkTyv (tv,_)) = pp_tyvar tv
    fun pp_path p = pp_list pp_sym p ("",".","",false)
    fun pp_typath (TypathHead sym) = pp_sym sym
      | pp_typath (TypathProj (tp,sym)) = HOVbox0 0 0 0 [pp_typath tp, String ".", pp_sym sym]
      | pp_typath (TypathApp (tp1,tp2)) = HOVbox0 0 0 0 [pp_typath tp1, String "(", pp_typath tp2, String ")"]
    fun pp_ty ty =
	  (case ty of
	     VarTy tyvar => pp_tyvar tyvar
           (* XXX This case is broken *)
	   | ConTy (_,tys) =>  (pp_region "ConTy(" ")"
				   [(case tys of
				       [t] => pp_ty t
				     | _ => pp_list pp_ty tys ("[",", ","]",false))])
	   | RecordTy symty_list => (pp_list (fn (sym,ty) => (pp_sym sym; String " = "; pp_ty ty))
				     symty_list ("{",", ","}",false))
	   | TupleTy tys => pp_list pp_ty tys ("(",", ",")",false)
	   | MarkTy (t,r) => pp_ty t)

    fun pp_pat pat =
      (case pat of
	 Ast.WildPat => String "_"
       | Ast.VarPat p => pp_path p
       | Ast.IntPat lit => String(TilWord64.toDecimalString lit)
       | Ast.WordPat lit => String(TilWord64.toHexString lit)
       | Ast.StringPat s => String s
       | CharPat s => String s
       | Ast.RecordPat _ => String "RecordPatUNIMPED"
       | Ast.ListPat _ => String "ListPatUNIMPED"
       | Ast.TuplePat pats => pp_list pp_pat pats ("(",", ",")",false)
       | Ast.FlatAppPat patfixes =>
	     let val pats = map #item patfixes
	     in  pp_list pp_pat pats ("",", ","",false)
	     end
       | Ast.AppPat {constr,argument} => pp_region "(" ")" [pp_pat constr, String " ", pp_pat argument]
       | Ast.ConstraintPat {pattern,constraint} =>
	     pp_region "(" ")" [pp_pat pattern, String ":", pp_ty constraint]
       | Ast.LayeredPat _ => String "LayeredPatUNIMPED"
       | Ast.VectorPat pats => String "VectorPatUNIMPED"
       | Ast.MarkPat (p,r) => pp_pat p)

    fun pp_strexp strexp =
      (case strexp of
	 Ast.VarStr p => pp_path p
       | Ast.BaseStr dec => String "BaseStr"
       | Ast.ConstrainedStr (se,c) => HOVbox[String "ConstrainedStr", pp_strexp se]
       | Ast.AppStr dec => String "AppStr"
       | Ast.LetStr dec => String "LetStr"
       | Ast.MarkStr (se,r) => HOVbox[String "MarkStr ", pp_strexp se])

    fun pp_exp exp =
      (case exp of
	 Ast.VarExp p => pp_path p
       | Ast.IntExp lit => String(TilWord64.toDecimalString lit)
       | Ast.WordExp lit => String(TilWord64.toHexString lit)
       | Ast.FlatAppExp exp_fix_list => let fun help {item,fixity,region} = pp_exp item
					in pp_list help exp_fix_list ("FlatAppExp(",",",")",false)
					end
       | Ast.AppExp{function,argument} => pp_region "App(" ")"
	     [pp_exp function, String ",", Break, pp_exp argument]
       | Ast.MarkExp (e,r) => pp_exp e
       | _ => String "Asthelp.pp_exp UNIMPED")


    fun wrapper pp out obj =
      let
	val fmtstream = open_fmt out
	val fmt = pp obj
      in (output_fmt (fmtstream,fmt);
	  close_fmt fmtstream;
	  fmt)
      end

    fun help' doer = doer
    fun help pp obj = (wrapper pp TextIO.stdOut obj; ())

    val pp_tyvar'  = help' pp_tyvar
    val pp_sym'    = help' pp_sym
    val pp_path'   = help' pp_path
    val pp_typath' = help' pp_typath
    val pp_ty'     = help' pp_ty
    val pp_pat'    = help' pp_pat
    val pp_exp'    = help' pp_exp
    val pp_strexp'    = help' pp_strexp

    val pp_tyvar = help pp_tyvar
    val pp_sym   = help pp_sym
    val pp_path  = help pp_path
    val pp_typath = help pp_typath
    val pp_ty    = help pp_ty
    val pp_pat   = help pp_pat
    val pp_exp   = help pp_exp
    val pp_strexp   = help pp_strexp

    fun eq_path([],[]) = true
      | eq_path(_,[]) = false
      | eq_path([],_) = false
      | eq_path(s1::rest1,s2::rest2) = Symbol.eq(s1,s2) andalso eq_path(rest1,rest2)

  end
