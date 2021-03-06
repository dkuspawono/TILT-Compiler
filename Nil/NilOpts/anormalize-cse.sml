(*

Routine to A-normalize Nil code. The alogorithm is taken from
Flanagan, Sabry, Duba, Felleisen "The Essence of Compiling with
Continuations", and extended to handle the NIL.

Also does cse of constructors and expressions as it names each
intermediate value.

A-normal form 'linearizes' the code. Actually the form I use is even
more restricted as it doesn't allow unnamed functions in the code, or Lets nested as
Let x= let y = 5 in y end
in x end

sc := Var_c v | Prim_c (primcon, [])        (Variables or constant primitives)

con1 := sc
     | Prim_c primcon * sc list
     | Mu_c bool * (var, con) seq * var            (can't make this (var, sc) seq as var will be unbound)
     | AllArrow_c openness * effect *       (Likewise, can't make con list and con be sc list and sc,
                    (var * kind) list *      as they could refer to type arguments.)
                    con list * w32 *con
     | Proj_c sc * label
     | Crecord_c (label*sc) list
     | App_c (Var_c f) * sc list            (con function must be named)
     | Closure_c of con * con               (Unimplemented in this version)
     | Typecase_c of { arg : sc,
                       arms : (primcon * (var*kind)list *con)list
		       default : sc,
		       kind : kind }
     | Annotate_c of annot * con


con := con1
     | Let_c letsort * conbnd list * con

conbnd :=                                   (same as nil)
     Con_cb ( var * kind * con1 )
     | Open_cb ( var * ( var * kind ) list * con * kind )
     | Code_cb ( var * ( var * kind ) list * con * kind )      (Unimplemented)


se := Var_e v | Const_e c

exp1 := exp := se
     | Prim_e allprim * con list * se list
     | Switch_e of switch
     | App_e openness * Var_e f * con list * se list * se list
     | Raise_e se * con
     | Handle_e exp * function              ( Note -- this is exp NOT se )

exp := exp1
     | Let_e letsort * bnd list * exp

switch :=
     Intsw_e of (Prim.intsize, se, w32) sw
     | Sumsw_e of (w32 * con list, se, w32) sw
     | Exncase_e of (unit, se, se) sw
     | Typecase_e of (unit, con, primcon) sw

bnd :=
     Con_b of var * kind * con1
     | Exp_b of var * con1 * exp1
     | Fixopen_b of (var, function) set
     | Fixcode_b of (var,function) set    (Unimplemented)
     | Fixclosure_b of bool * (var, {code:var, cenv:con, venv:exp, tipe:con}) set  (Unimplemented)

function := (same as nil)

*)

(*
signature ANORMALIZE =
    sig
	structure Nil : NIL

	val doModule : bool -> Nil.module -> Nil.module
	val test_exp : Nil.exp -> Nil.exp
	val debug : bool ref
    end
*)
fun squish_exp (e : Nil.exp) = e
fun squish_con (c : Nil.con) = c
fun rename_kind _ (k : Nil.kind) = k
fun rename_con _ (c : Nil.con) = c

structure Anormalize :> PASS =

struct

    structure Nil = Nil

    open Nil Name Util Prim

    type context = NilContext.context

    structure Expmap = ExpTable.Expmap                        (* Map of available expressions *)
    structure Conmap = ExpTable.Conmap                        (* Map of available constructors *)
    type avail = ((var * con) Expmap.map * var Conmap.map)

    exception FnNotFound
    exception UNIMP
    exception BUG

    val print_bind = ref false
    val debug = ref false
    val error = fn s => Util.error "anormalize-cse" s

    (* ----------- CSE aux fns ------------ *)


    val do_cse = Stats.tt("doCSE")
    val agressive_cse = ref false (* cse con-funs, mu's, arrows etc *)
    val really_agressive_cse = ref false (* cse all cons regardless of cost *)

    val cse_exp_click = (NilOpts.make_click "CSE expressions")
    val cse_con_click = (NilOpts.make_click "CSE constructors")
    val normalize_click = (NilOpts.make_click "Normalization")
    val clicks = [ cse_exp_click, cse_con_click, normalize_click ]
    val inc_click = NilOpts.inc_click


    (* When we do CSE of expressions we want to keep track of which
     functions are total so that we can eliminate their applications
     if possible. We don't want to eliminate the application of non
     total functions as there could be side effects. *)

    (*True if the function is total, not found or false o/w  *)
    val fntable = Name.mk_var_hash_table (200, FnNotFound):
	(var, bool) HashTable.hash_table


    (* What kind of cse is going on for constructors ... let's find out! *)
    exception NotFound
    fun stringHash str =
	Word.fromInt (foldl (fn (c, sum) => sum + (Char.ord c)) 0 (String.explode str))
    fun stringEq (str1, str2) =
	str1 = str2

    val csetable = HashTable.mkTable (stringHash, stringEq) (20, NotFound) :  (string, int ref) HashTable.hash_table
    fun cse_record_con con =
	let val inc = fn str =>
	    let val x = (( HashTable.lookup csetable str) handle NotFound => (HashTable.insert csetable (str, ref 0); HashTable.lookup csetable str))
	    in
		x := !x + 1
	    end
	in
	    case con of
		Prim_c _ => inc "Prim_c"
	      | Mu_c _ => inc "Mu_c"
	      | AllArrow_c _ => inc "Arrow_c"
	      | Var_c _  => inc "Var_c"
	      | Let_c (_, [Open_cb _], _) => inc "Fun_c"
	      | Let_c _ => inc "Let_c"
	      | Crecord_c _ => inc "Record_c"
	      | Proj_c _ => inc "Proj_c"
	      | App_c _ => inc "App_c"
	      | Typecase_c _ => inc "Typecase_c"
	      | Closure_c _ => inc "Closure_c"
	      | Annotate_c _ => inc "Annotate_c"
	end

    fun cse_record_exp exp =
	let val inc = fn str =>
	    let val x = (( HashTable.lookup csetable str) handle NotFound => (HashTable.insert csetable (str, ref 0); HashTable.lookup csetable str))
	    in
		x := !x + 1
	    end
	in
	    case exp of
		Var_e _ => inc "Var_e"
	      | Const_e _ => inc "Const_e"
	      | Let_e _ => inc "Let_e"
	      | Prim_e _ => inc "Prim_e"
	      | Switch_e _ => inc "Switch_e"
	      | App_e _ => inc "App_e"
	      | Raise_e _ => inc "Raise_e"
	      | Handle_e _ => inc "Handle_e"
	end

    (* Does this primitive cause any side effects? Now as I see it
     there are several ways to do this. Right now I implement (b) as
     it is the simplest.
     a. eliminate references and array subscripts, and clear out the
     available expressions after function calls.
     b. don't eliminate derefs and subs, but keep all avail expressions around.
     c. do both (only clear out available derefs and subs after
     function calls)
     *)

    fun is_elim_allp (NilPrimOp p) = true
      | is_elim_allp (PrimOp p) =
	case p of
	    ( open_in
	  | input | input1 | lookahead | open_out | close_in
	  | output | flush_out | close_out | end_of_stream ) => false
	  | update _  => false
	  | _ => true


    (* Can we eliminate this expression -- In order to keep the
     asymptotic complexity reasonable, we don't include any expressions
     that can have full expressions as part of them. (Like switch) *)

    fun is_elim_exp exp =
	case exp of
	    Prim_e( allp, _, _) => is_elim_allp allp
	  | App_e ( openness, Var_e v, _, _, _) =>
		(if HashTable.find fntable v = SOME true then true
		else false
		     handle FnNotFound =>
			 (Ppnil.pp_var v ; print " not found\n"; raise BUG))

	  | _ => false

    (* We don't need to check the types of the expressions.
       Unlike TIL1, if two expressions in the same context are identical,
       then they are (effects aside) interchangeable *)

    fun cse_exp exp ae D sigma =
	(if !debug then (print " ce ") else () ;
	 if (is_elim_exp exp) then
	      ( case Expmap.find (ae, exp) of
		    SOME (var, tau) =>
			( inc_click cse_exp_click ; cse_record_exp exp; Var_e var )
		  | NONE => exp)
	  else exp)


    fun small_con con =
	case con of
	    Var_c v => true
	  | Prim_c (primcon, clist) => length clist = 0
	  | _ => false

    fun is_elim_con con =
	(not (small_con con)) andalso
	(case con of
	    ( Prim_c _ | Crecord_c _ | Proj_c _ | App_c _ ) => true
	  | ( AllArrow_c _ | Mu_c _ ) => !agressive_cse
	  |  Let_c (s1, [Open_cb f1], Var_c v1) => !agressive_cse
	  | _ => !really_agressive_cse)


    fun is_elim_conbnd (Con_cb (_,c)) = is_elim_con c
      | is_elim_conbnd _ = false

    (* Should really check the kinds here as well to see if they match *)
    fun cse_con con ac D =
	(if !debug then  print " cse_con: " else () ;
	 if (is_elim_con con) then
	      ( case Conmap.find (ac, con) of
		    SOME (var) =>
			( inc_click cse_con_click ;
			 cse_record_con con ;
			 Var_c var )
		  | NONE => con)
	  else con)

    (* --------------------------- Nil Typechecking stuff -------------------------- *)

    (* Problem : When we name an expression and create a let binding,
     we have to have a constructor for its type.  Using nilstatic
     arbitrarily doesn't always work, unfortunately. So I wrote the
     following code to just read the types off of the expressions, and
     not do any type checking. The hard part is for selects, where we
     have to somehow get the type from the constructor of the record.
     *)


    (* This keeps track of type variables, so when we select from a
     variable we can see what record constructor it is bound to. In
     all rights this should be a VarMap and passed around instead of a
     global hashtable. *)
    val env = Name.mk_var_hash_table(200,FnNotFound): (var, con)
	HashTable.hash_table


    val empty = NilContext.empty()
    (*    val insert_con = NilContext.insert_con
    val insert_con_list = NilContext.insert_con_list *)
    fun find_con arg = (SOME (NilContext.find_con arg))
				handle NilContext.Unbound => NONE

    (*    val insert_kind = NilContext.insert_kind
    val insert_kind_list = NilContext.insert_kind_list*)
    fun find_kind arg = (SOME (NilContext.find_kind arg))
				handle NilContext.Unbound => NONE

    fun insert_con (D, var, con) =
	let  (* val newcon = NilStatic.con_reduce(D, con) *)
	in NilContext.insert_con (D, var, con )
	end

    fun insert_con_list  (C, defs) =
	List.foldl (fn ((v,c),C) => insert_con (C,v,c)) C defs

    fun insert_kind (D, var, kind) =
	let (* val kind = NilStatic.kind_reduce (D, kind) *)
	in
	    NilContext.insert_kind (D, var, kind )
	end
    fun insert_kind_list (C, defs) =
	List.foldl (fn ((v,c),C) => insert_kind (C,v,c)) C defs

    (* Extends the context with the con for each recursive function *)
    fun extend_functions D fcnlist =
	foldl ( fn ((var, Function(e,r,tformals,dep,formals,fformals,body,return)),D) =>
	       let val num_floats = Word32.fromInt (List.length fformals)
		   val (vlist,clist) = Listops.unzip formals
		   val con = AllArrow_c(Open, e, tformals, if dep then SOME vlist else NONE,
					clist,num_floats,return)
	       in
		   insert_con (D, var, con)
	       end ) D fcnlist

    fun extend_bnds D bnds  =
	foldl (fn (bnd, D) =>
	       case bnd of
		   Con_b(v, cbnd) => extend_con_bnds D [cbnd]
		 | Exp_b (v,e) => insert_con (D, v, Normalize.type_of(D,e))
		 | Fixopen_b vfset =>
		       let val fcnlist = Sequence.toList vfset
		       in extend_functions D fcnlist
		       end
		 | _ => raise UNIMP) D bnds

    and extend_con_bnds D bnds  =
	foldl (fn (bnd, D) =>
	       case bnd of
		   Con_cb(v, c) => ( HashTable.insert env (v, c) ;
				    insert_kind(D, v, Singleton_k c) )
		 | Open_cb (var, vklist, con, kind) =>
		       insert_kind (D, var, Arrow_k (Open, vklist, kind))
		 | Code_cb (var, vklist, con, kind) =>
		       insert_kind (D, var, Arrow_k (Code, vklist, kind))) D bnds

    fun avail_bnds D avail bnds =
	foldl (fn (bnd, avail as (ae,ac)) =>
	       case bnd of
		   Con_b(phase, cbnd) => avail_con_bnds avail [cbnd]
		 | Exp_b (v,e) => if (is_elim_exp e)
				      then (Expmap.insert (ae, e, (v, Normalize.type_of(D,e))), ac)
				    else avail
		 | Fixopen_b vfset => avail
		 | _ => raise UNIMP) avail bnds

    and avail_con_bnds (ae,ac) (bnds:conbnd list) =
	foldl (fn (bnd, (ae,ac)) =>
	       case bnd of
		   Con_cb(v, c) => if (is_elim_con c) then (ae, Conmap.insert (ac, c, v))
		       else (ae, ac)

		 (* In order to do CSE of con-funs *)
		 | Open_cb (v, vklist, con, kind) =>
		       (ae, if !agressive_cse then Conmap.insert (ac, Let_c (Sequential, [bnd], Var_c v), v) else ac)

		 | _ => raise UNIMP
		 ) (ae,ac) bnds



    fun con2bnd conbnd = Con_b(Runtime, conbnd)



    (* --------- Code to get the type of expressions -----------*)

    (* Unfortunately when we do this we have to alpha convert the code as well. *)
    fun strip_record (con, label) =
	case con of
	    Prim_c (Record_c (labels,vars), cons) =>
		let val SOME (label,con) =  Listops.find2 (fn (l,c) => eq_label (l,label)) (labels,cons)
		in con end
	  | Var_c var => (strip_record ((HashTable.lookup env var), label)
			  handle FnNotFound =>
			      (print "Strip record: " ; Ppnil.pp_var var ; print " not found\n"; raise BUG ))
	  | Annotate_c (annot, con') => strip_record (con', label)
	  | Let_c ( sort, conbnds, con) =>
		( app (fn (cbnd) =>
		       case cbnd of
			   Con_cb (v,c) =>
			       HashTable.insert env (v, c)
			| _ => () ) conbnds ;
		 Let_c (sort, conbnds, strip_record (con, label) ))

    fun strip_arrow (con, cons) =
	case con of
	    AllArrow_c(_,_,vklist,_,_,_,con) =>
		let val subst = NilSubst.fromList (Listops.zip (#1 (Listops.unzip vklist)) cons)
		in NilSubst.substConInCon subst con
		end
	  | Var_c var => (strip_arrow ((HashTable.lookup env var), cons)
			  handle FnNotFound =>
			      (print "Strip arrow: " ; Ppnil.pp_var var ; " not found\n"; raise BUG ) )
	  | Annotate_c (annot, con') => strip_arrow (con', cons)
	  | Let_c ( sort, conbnds, con) =>
		( app (fn (cbnd) =>
		       case cbnd of
			   Con_cb (v,c) =>
			       HashTable.insert env (v, c)
			 | _ => () ) conbnds ;
		 Let_c (sort, conbnds, strip_arrow (con, cons)))

    fun strip (D, con) =
	case con of
	    Var_c v => ( case  HashTable.find env v
			of SOME (con') => strip (D,con')
		      | NONE => con )
	  | Annotate_c (annot, con') => strip (D, con')
	  (* This is a real problem here *)
	  | Let_c ( sort, conbnds, exp) =>
		strip ( extend_con_bnds D conbnds, exp)
	  | _ => con

	 (* ---------------- Start of A-normalization code ------------------------ *)

     (* We'd like to do a little hoisting here, along with the normalization.
      Instead of leaving bindings at the con level, we'd like move them up to the term level *)

     datatype norm = EXP of exp | CON of con
                   | BNDLIST of bnd list*context*avail
                   | CONBNDLIST of  conbnd list*context*avail
	           | KIND of kind

    fun TOEXP (var, kind, con, EXP body ) =
	EXP (Let_e (Sequential, [ Con_b(Runtime, Con_cb(var, con)) ], body))
    fun TOCON (var, kind, con, CON body ) =
	CON (Let_c (Sequential, [ Con_cb(var, con) ], body))
    fun TOBNDLIST (var, kind, con, BNDLIST (body, context,avail) ) =
	BNDLIST ((Con_b(Runtime,Con_cb(var, con))) :: body, context,avail )
    fun TOCONBNDLIST (var, kind, con, CONBNDLIST (body, context,avail) ) =
	CONBNDLIST ((Con_cb(var, con)) :: body, context,avail )

    fun CONk (con, D, avail) = CON con
	(* k :  con * context * avail -> norm
	   bind : var * kind * con -> norm
	 *)


    fun normalize_kind (kind:kind) (D:context) (avail:avail) =
	(if !debug then print "k" else ();
	 case kind of
	    Type_k => kind
	  | Singleton_k con =>
		let val CON con = normalize_con con D avail (TOCON, CONk)
		in
		   Singleton_k con
		end

	  | Record_k lvkseq =>
		let val lvklist = Sequence.toList lvkseq
		    val (lvs, kinds) = Listops.unzip lvklist
		    val (ls,vs) = Listops.unzip lvs
		    val vklist = Listops.zip vs kinds
		    val (vklist,_) = normalize_kinds vklist D avail
		    val (vs,kinds) = Listops.unzip vklist
		in  Record_k (Sequence.fromList (Listops.zip lvs kinds))
		end


	  | Arrow_k (openn, vklist, knd) =>
		let val (vklist,newD) = normalize_kinds vklist D avail
		    val knd = normalize_kind knd newD avail
		in  Arrow_k (openn, vklist, knd)
		end)

    and normalize_kinds vklist D avail =
	let fun loop acc [] D = (rev acc,D)
	      | loop acc ((v,k)::rest) D =
	    let val k' = normalize_kind k D avail
		val D' = insert_kind(D, v, k')
	    in  loop ((v,k')::acc) rest D'
	    end
	in  loop [] vklist D
	end

    and normalize_con con D (avail as (ae,ac)) (bind, k) =
	(if !debug then print "c" else ();
	case con of
	    Prim_c (primcon, cons) =>
		normalize_con_names cons D avail
		(bind, (fn (cons, D, avail) =>
		 let val con = Prim_c(primcon, cons)
		     val con = if !do_cse
				   then cse_con con ac D
			       else con
		 in
		     (k (con, D, avail))
		 end ))
	  | Mu_c (bool,vcseq) =>
		let val vclist = Sequence.toList vcseq
		    val vclist = NilUtil.alpha_mu
			(fn v => (case find_kind(D, v) of
				      NONE => false
				    | SOME _ => true)) vclist
		    val var_kinds = map (fn (var,con) => (var, Type_k)) vclist
		    val newD = insert_kind_list (D, var_kinds)
		    fun do_con (var, con) =
			let val CON con = normalize_con con newD avail (TOCON, CONk)
			in (var, con)
			end
		in
		    k ( Mu_c (bool,Sequence.fromList(map do_con vclist)), D, avail)
		end
	  | AllArrow_c ( openness, effect, vklist, vlist, clist, w32, con) =>
	        if null vklist then
		    normalize_con_names clist D avail
			(bind, (fn (clist, D,avail) =>
			 normalize_con_name con D avail
			 (bind, (fn (con, D, avail) =>
				 k ( AllArrow_c( openness, effect, vklist,
						vlist, clist, w32, con),
				    D,
				    avail)))))

		(* The variables in the vklist are bound in the return
		 con and the CLIST, so we don't want to lift any thing
		 out as it may contain unbound variables.
		 *)

		else
		    let val (vklist,newD) = normalize_kinds vklist D avail
			val newD = insert_kind_list (D, vklist)
			     fun do_con con =
				 let val CON con = normalize_con con newD avail (TOCON, CONk)
				 in con
				 end
			     val clist = map do_con clist
			     val con = do_con con
		    in
			k ( AllArrow_c ( openness, effect, vklist, vlist,
					clist, w32, con), D, avail)
		    end

	  | Var_c v => k (con, D, avail)
	  | Let_c ( sort, bnds , body ) =>
		let val (bnds:conbnd list, bndD, bndavail ) = normalize_con_bnds bnds D avail
		    val CON con = normalize_con body bndD bndavail (TOCON, CONk)
		in
		    k (Let_c (sort, bnds, con), D, avail)
		end

	  | Crecord_c lclist =>
		let val (labels, cons) = Listops.unzip lclist
		in
		    normalize_con_names cons D avail (bind,
		    ( fn (cons, D, avail) =>
		     k (Crecord_c (Listops.zip labels cons), D, avail) ))
		end

	  | Proj_c (con, label) =>
		normalize_con_name con D avail (bind,
		( fn (con, D, avail) => k ( Proj_c (con, label), D, avail)))

	  | App_c ( f, cons ) =>
		(normalize_con_name f D avail (bind,
		 ( fn (t, D, avail)  =>
		  normalize_con_names cons D avail (bind,
		  (fn (cons, D, avail) =>
		   (k ( (App_c( t, cons)), D, avail)))))))

	  | Typecase_c sw  => (normalize_typecase sw D avail (bind, k))  )

    and normalize_cons ((hd :: cons) :con list) D avail (bind, k) =
	normalize_con hd D avail
	(bind, (fn (t, D, avail) => normalize_cons cons D avail
		(bind, (fn (cons', D, avail) => k ( t :: cons', D, avail ) ))))
      | normalize_cons [] D avail (bind, k) = k ([],D, avail)

    and normalize_con_names ((hd :: cons) :con list) D avail (bind, k) =
	normalize_con_name hd D avail
	(bind, (fn (t, D, avail) => normalize_con_names cons D avail
		(bind, (fn (cons', D, avail) => k ( t :: cons', D, avail ) ))))
      | normalize_con_names [] D avail (bind, k) = k ([],D, avail)

    and normalize_con_name con D (avail as (ae,ac)) (bind, k) =
	(normalize_con con D avail (bind,
	 (fn (con, D, (ae,ac)) =>
	  let val t:var = (Name.fresh_var())

	      val con = if !do_cse then cse_con con ac D else con
	      val ac = if (is_elim_con con) then Conmap.insert (ac, con, t) else ac
	  in
	      if small_con con then  k (con, D, (ae,ac))
	      else
		  let
		      val _ = HashTable.insert env (t,con)
		      val _ = if !debug then (print "Kinding "; Ppnil.pp_con con ) else ();
		      val kind =  Single_k con
		      val kind =  normalize_kind kind D (ae,ac)
		      val _ = if !debug then (print " with kind "; Ppnil.pp_kind kind ; print "\n") else ();
		      val _ = NilOpts.inc_click normalize_click
		  in
		       bind (t, kind, con, (k ((Var_c t), insert_kind (D, t, kind), (ae,ac) )))
		  end
	  end)))

     and normalize_con_bnds (hd :: bnds) D avail : conbnd list * context *avail=
	 let val CONBNDLIST return =
	     normalize_con_bnd hd D (TOCONBNDLIST,avail)
	     (fn CONBNDLIST(t, newD, avail) =>
	      ( let val (rest, newD, avail) =  normalize_con_bnds bnds newD avail
		in CONBNDLIST(t @ rest, newD, avail) end)
	   | _ => error "must be CONBNDs here")
	 in  return
	 end
       | normalize_con_bnds [] D avail =  ([], D, avail)

     (******* ACK!!!!!!!!!!!!!!!!!!!!!!!! ***********************)
    and normalize_con_bnd (bnd:conbnd) D (bind,avail as (ae,ac))
	      (k:norm->norm) : norm =
	case bnd of
       Con_cb(var, con) =>
	   let val norm_return = normalize_con con D avail
	       (bind,
		(fn (con, D, (ae,ac)) =>
		 let
		     val _ = HashTable.insert env (var, con)

		     val ac = if !do_cse andalso (is_elim_con con) then
			 Conmap.insert (ac, con, var)
			      else
				  ac
		 in
		     case con of
			 Let_c ( sort, bnds, bdy) =>
			     let val Let_c(sort, bnds, bdy) = squish_con con
				 val D = extend_con_bnds D bnds
				 val (ae,ac) = avail_con_bnds (ae,ac) bnds
			     in
				 k (CONBNDLIST( bnds @ [ Con_cb  (var, bdy) ],
					       insert_kind (D, var, Singleton_k con),
					       (ae,ac)))
			     end
		       | _ =>
			     k (CONBNDLIST
				( [ Con_cb(var,con)] ,
				 insert_kind (D, var, Singleton_k con), (ae,ac) ))
		 end))
	   in (norm_return : norm)
	   end


      | Open_cb (v, vklist, con, kind) =>
	    let val vklist = map (fn (v,k) => (v, normalize_kind k D avail)) vklist
		val newD = insert_kind_list (D, vklist)
		val kind = normalize_kind kind newD avail
		val returnD = insert_kind (D, v, Arrow_k (Open, vklist, kind))
		val CON body = normalize_con con newD avail (TOCON, CONk)
	    in
		   case Conmap.find (ac, Let_c (Sequential, [bnd], Var_c v)) of
		       SOME var => ( inc_click cse_con_click; cse_record_con (Let_c (Sequential, [bnd], Var_c v) );
				     k ( CONBNDLIST([Con_cb (v, Var_c var)], returnD, avail)))
		     | _ =>
			   k (CONBNDLIST(
					 [Open_cb (v,vklist, body, kind) ] , returnD,
					 (ae, Conmap.insert (ac, Let_c (Sequential, [bnd], Var_c v), v))))
	    end

	  (*  (fn (con, D, avail) =>
	   CONBNDLIST (k ( [Open_cb(v, vklist, con, kind) ] ,  returnD, avail ))))
	    in return
	    end *)
      | Code_cb _ => raise UNIMP (* Should be the same as Open_cb *)

    and normalize_typecase (sw as { kind, arg, arms, default }) D avail (bind, k) =
	 let fun id x = x
	     val do_sw = fn ( { kind, arg, arms, default}, D, avail)  =>
		 let val CON default = (normalize_con default D avail (TOCON, CONk))
		 in
		 { kind = normalize_kind kind D avail ,

		  arms =  map (fn ( primcon, vklist, con) =>
			       let val vklist = map (fn (v,k) => (v, normalize_kind k D avail)) vklist
				   val newD = insert_kind_list (D, vklist)
				   val CON con = normalize_con con newD avail (TOCON, CONk)
			      in
				  ( primcon, vklist, con)
			      end)  arms,
		  arg = arg,
		  default =  default
		  }
		 end
	 in
	     normalize_con_name arg D avail (bind,
	     ( fn (t, D, avail) =>
	      k ( Typecase_c (do_sw (sw, D, avail)),  D, avail)))
	 end

    fun normalize_exp exp D (avail as (ae, ac)) (k:exp*context*avail->exp) =
	( if !debug then ( print "e:" ; Ppnil.pp_exp exp ; print "\n----------------------------------\n") else ();
	  case exp of
	    Var_e v => k (exp, D, (ae, ac))
	  | Const_e c => k (exp, D, (ae, ac))
	  | Let_e ( sort, bnds , body ) =>
		let val (bnds, D, avail) = normalize_exp_bnds bnds D avail
		in
		    Let_e (sort, bnds,
			   normalize_exp body D avail k )
		end

	  | Prim_e (allp, cons, exps) =>
		let val EXP returnexp = (normalize_cons cons D (ae, ac)
			       (TOEXP, (fn (cons, D, (ae,ac)) =>
					EXP (normalize_exp_names exps D (ae, ac)
					(fn (exps, D, (ae, ac)) =>
					 let val exp = Prim_e(allp, cons, exps)
					     val exp = if !do_cse
							   then
							       (
								cse_exp exp ae D (Normalize.type_of (D, exp)) )
						       else exp
					 in
					     (k (exp, D, (ae, ac)))
					 end )))))
		in returnexp end

	  | App_e (openness, f, cons, args, exps) =>
		 (normalize_exp_name f D (ae, ac)
		  (fn (t, D, (ae, ac))  =>
		   let val EXP returnexp = (normalize_cons cons D (ae, ac)
				      (TOEXP,  (fn (cons, D, (ae, ac)) =>
						EXP (normalize_exp_names args D (ae, ac)
						     (fn (args', D, (ae, ac)) =>
						      normalize_exp_names exps D (ae, ac)
						      (fn (exps', D, (ae, ac)) =>
						       (k ( (App_e(openness, t, cons, args', exps')), D, (ae, ac)))))))))
		   in returnexp end ))
	  | Switch_e sw  => (normalize_switch sw D (ae, ac) k)
	  | Raise_e(e,c) => normalize_exp_name e D (ae, ac)
		 (fn (e', D, (ae, ac)) =>
		  let val EXP returnexp = normalize_con c D (ae,ac)
		      (TOEXP, (fn (con, D, (ae, ac)) =>
			       EXP (k (Raise_e (e',c), D, (ae, ac)))))
		  in returnexp end )
	  | Handle_e (e,bound,body) =>
		 let val e' = normalize_exp e D (ae, ac) #1
		     val D = insert_con(D, bound, Prim_c(Exn_c, []))
		     val body' = normalize_exp body D (ae, ac) #1
		 in  k (Handle_e(e', bound, body'), D, (ae, ac))
		 end)

    and name_exp exp D (ae, ac) k =
	 let val _ = if !debug then print "n" else ()
	     val t:var = (Name.fresh_var())

	     val con = Normalize.type_of (D, exp)
	     val (exp, ae) = if !do_cse then (cse_exp exp ae D con,
					      if (is_elim_exp exp)
						  then Expmap.insert (ae, exp, (t, con))
					      else ae)
			     else (exp, ae)

	     val _ = NilOpts.inc_click normalize_click
	     val EXP returnexp = normalize_con con D (ae,ac)
		 (TOEXP, (fn (con, D, (ae, ac)) =>
			  EXP (Let_e(Sequential, Exp_b( t, exp) :: [] ,
				     (k ((Var_e t), insert_con (D, t, con), (ae, ac)) )))))
	 in returnexp
	 end
    and normalize_exp_name exp D (ae, ac) (k:exp*context*avail->exp) =
	(
	 normalize_exp exp D (ae, ac)
	 (fn (exp', D, (ae, ac)) =>
	  (case exp' of
	       (Const_e _ | Var_e _) => k (exp', D, (ae, ac))
	     | _  => name_exp exp' D (ae, ac) k)))

    and normalize_exp_names ((hd :: exps) :exp list) D (ae, ac) (k:exp list*context*avail->exp) =
	normalize_exp_name hd D (ae, ac)
	(fn (t, D, (ae, ac)) =>
	 normalize_exp_names exps D (ae, ac)
	 (fn (exps', D, (ae, ac)) => k ( t :: exps', D, (ae, ac) ) ))
      | normalize_exp_names [] D (ae, ac) k = k ([],D, (ae, ac))



    and normalize_exp_bnds (bnd::bnds) D avail =
	normalize_exp_bnd bnd D avail
	(fn (bndlist, D, avail) =>
	 let val (rest, newD, ae) =  normalize_exp_bnds bnds D avail
	 in (bndlist @ rest, newD, ae) end)

      | normalize_exp_bnds [] D avail = ([], D, avail)

     (* k takes a list of normalized bnds *)
    and normalize_exp_bnd bnd D (ae, ac) (k:bnd list*context*avail->bnd list*context*avail) =
	case bnd of
	    Con_b (phase, cbnd) =>
		let val BNDLIST return = normalize_con_bnd cbnd D (TOBNDLIST,(ae,ac))
		         (fn (CONBNDLIST(cbnds,D, (ae,ac))) =>
			      BNDLIST (k (map con2bnd cbnds,D, (ae, ac)))
		           | res as (BNDLIST _) => res
			   | _ => error "expect BNDLIST or CBNDLIST")
		in return
		end

	  | Exp_b(var, exp) =>
		let  val _ = ( if !debug then( print "Normalizing bind " ; Ppnil.pp_var var ; print "\n" ) else ())
		    val con = Normalize.type_of(D,exp)
		    val BNDLIST returnbnds = normalize_con con D (ae,ac)
		    (TOBNDLIST, (fn (con, D, (ae, ac)) =>
				 let val exp' =  normalize_exp exp D (ae, ac) #1
				     val ae = if !do_cse andalso (is_elim_exp exp') then
					 Expmap.insert (ae, exp', (var, con))
					      else ae
				 in
				     BNDLIST
				     ( case exp' of
					 Let_e ( sort, bnds, bdy) =>
					     let val Let_e(sort, bnds, bdy) = squish_exp exp'
						 val D = extend_bnds D bnds
						 val (ae,ac) = avail_bnds D (ae,ac) bnds
					     in
						 k ( bnds @ [ Exp_b  (var, bdy) ], insert_con (D, var, con), (ae, ac))
					     end

					 | _ => k ( [ Exp_b(var, exp') ],
						   insert_con (D, var, con),
						   (ae, ac) ))
				 end))
		in returnbnds end
	  | Fixopen_b fcnset =>
		let val fcnlist = Sequence.toList fcnset
		    (* So that types of mutually recursive functions are available *)
		    val D = extend_functions D fcnlist
			(***** Mark total functions for CSE ****)
		    val _ = if !do_cse
				then
				    app ( fn (var, Function( eff, _, _, _, _, _, _, _)) =>
					 if eff = Total
					     then HashTable.insert fntable (var, true)
					 else () ) fcnlist
			    else ()
		    val fcnlist =
			normalize_fcns fcnlist D (ae,ac) #1
		in
		    k ( [ Fixopen_b( Sequence.fromList fcnlist) ], D,(ae,ac) )
		end
	  | Fixcode_b _ => raise UNIMP
	  | Fixclosure_b _ => raise UNIMP

     and normalize_fcn (v, (function as
			    Function(e,r,vklist, dep, vclist, vlist, exp, con))) D (ae, ac)
	 (k:(var*function)*context*avail->(var*function)list ) =
	 let val vklist = map (fn (v,k) => (v, normalize_kind k D (ae,ac))) vklist
	     val (vars, cons) = Listops.unzip vclist
	     val D = insert_kind_list (D,vklist)

	     (* Normalize the function argument types and return
	      types, but remember that since type args can appear in
	      them, we can't lift them out of the Function binding.

	      *)
	     fun do_con con =
		 let val CON con = normalize_con con D (ae,ac) (TOCON, CONk)
		 in con end

	     val con = do_con con
	     val vclist = Listops.zip vars (map do_con cons)
	     val newD = insert_con_list (D, vclist)
	     val newD = insert_con_list (newD, map (fn v=> (v, Prim_c (Float_c Prim.F32, [])))  vlist)
	     val exp = normalize_exp exp newD (ae, ac) (fn (x, D, (ae, ac))=>x)
	 in ( k ((v,Function(e,r,vklist, dep, vclist, vlist, exp, con)), D, (ae,ac)))
	 end
    and normalize_fcns (hd :: fcns) D a (k:(var*function)list*context*avail->(var*function)list) =
	normalize_fcn hd D a (fn (hd, D, a) =>
			       normalize_fcns fcns D a (fn (fcns, D, a) => (k ((hd::fcns), D, a))))
       | normalize_fcns [] D a k = k ([], D, a)

     (* arms need to be normalized ... think about that .... *)
     and normalize_switch sw D (ae, ac) k =
         let
	     fun do_exp D arg = normalize_exp arg D (ae, ac) (fn (x, D, (ae, ac)) => x)
	     fun do_default NONE = NONE
	       | do_default (SOME e) = SOME(normalize_exp e D (ae, ac) (fn (x, D, (ae, ac)) => x))
	     fun do_intarm (w,e) = (w, do_exp D e)
	     fun do_sumarm D (w,e) = (w, do_exp D e)
	     fun do_exnarm D (e1,e2) = (do_exp D e1, do_exp D e2)
         in
              case sw of
                 Intsw_e {size, arg, arms, default} =>
		     let val arg = do_exp D arg
			 val arms = map do_intarm arms
			 val default = do_default default
		     in  k(Switch_e(Intsw_e{size=size,arg=arg,arms=arms,default=default}),
			   D, (ae, ac))
		     end
	       | Sumsw_e {bound, sumtype, arg, arms, default} =>
		     let val arg = do_exp D arg
			 val CON sumtype = normalize_con sumtype D (ae,ac) (TOCON, CONk)
			 val D = insert_con(D, bound, sumtype)
			 val arms = map (do_sumarm D) arms
			 val default = do_default default
		     in  k(Switch_e(Sumsw_e{bound=bound,
					    sumtype=sumtype,
					    arg=arg,
					    arms=arms,
					    default=default}),
			   D, (ae, ac))
		     end
	       | Exncase_e {bound, arg, arms, default} =>
		     let val arg = do_exp D arg
			 val D = insert_con(D, bound, Prim_c(Exn_c,[]))
			 val arms = map (do_exnarm D) arms
			 val default = do_default default
		     in  k(Switch_e(Exncase_e{bound=bound,
					    arg=arg,
					    arms=arms,
					    default=default}),
			   D, (ae, ac))
		     end
	       | Typecase_e sw => error "typecase not done"
	 end

     (* ---- constructors ----- *)
    fun test_exp exp =
	normalize_exp exp (empty) (Expmap.empty, Conmap.empty)  (fn (exp, newD, (ae, ac)) => exp)

     fun doModule debug ( MODULE{bnds = bnds, imports=imports, exports = exports}) =
	 let val _ = print_bind := debug
	     fun clearTable table =
		 HashTable.appi ( fn (key, item) => ignore (HashTable.remove  table key)) table
	     val _ = clearTable env
	     val _ = clearTable csetable

	     val baseDFn = (fn D =>
			( foldl ( fn (entry, D) =>
			    case entry of
				ImportValue (l, v, c) => NilContext.insert_label (insert_con (D, v, c), l, v)
			      | ImportType (l , v, k) => NilContext.insert_label (insert_kind (D, v, k), l, v)
			 D imports  ))
	     val D = (baseDFn (empty))
	     val temp =  Let_e(Sequential,bnds, NilUtil.true_exp)
	     val  exp =
		 normalize_exp temp D (Expmap.empty, Conmap.empty)  (fn (exp, newD, (ae, ac)) => exp)
	     val Let_e(Sequential,bnds,_) = squish_exp exp
	     val _ = if debug then (print "Normalized bnds *********************************************************\n") else ()
	     val exports = let val D = extend_bnds D bnds
		     in
			 map ( fn entry =>
			      case entry of
				  ExportValue(lab, exp) =>
				      let
					  val exp  = normalize_exp exp D (Expmap.empty, Conmap.empty) (fn (x, c, (ae, ac))=> x)
				      in
					  ExportValue(lab, exp)
				      end
				  | ExportType (lab, con) =>
					let val CON con = normalize_con con D (Expmap.empty, Conmap.empty) (TOCON, CONk)
				      in
					  ExportType(lab, con)
				      end
				) exports
		     end
	     val _ = (print "Anormalization clicks\n***********************\n" ;
		      NilOpts.print_round_clicks clicks;
		      print "Types of cse's:\n";
		      HashTable.appi ( fn (key, item) => (print "\t"; print key; print ":\t"; print (Int.toString (!item)); print "\n")) csetable)
	 in
	     MODULE { bnds = bnds,
		     imports = imports,
		     exports = exports
		     }
	 end

end





