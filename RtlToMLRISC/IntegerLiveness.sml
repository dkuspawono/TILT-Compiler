(*$import TopLevel BASIC_BLOCK REGISTER_DATA_FLOW MLTREE_EXTRA REGISTER_LIVENESS DenseIntSet ListPair Array *)


(* =========================================================================
 * IntegerLiveness.sml
 * ========================================================================= *)

functor IntegerLiveness(
	  structure BasicBlock:	     BASIC_BLOCK
	  structure IntegerDataFlow: REGISTER_DATA_FLOW
				       where type idSet = DenseIntSet.set
	  structure MLTreeExtra:     MLTREE_EXTRA

	  sharing type MLTreeExtra.MLTree.mltree =
		       BasicBlock.mltree =
		       IntegerDataFlow.mltree
	) :> REGISTER_LIVENESS
	       where type idSet	 = DenseIntSet.set
		 and type mltree = MLTreeExtra.MLTree.mltree
	  = struct

  (* -- structures --------------------------------------------------------- *)

  structure IntSet = DenseIntSet

  structure MLTree = MLTreeExtra.MLTree

  (* -- types -------------------------------------------------------------- *)

  type idSet = IntSet.set

  type mltree = MLTree.mltree

  type block = mltree list

  (* -- list functions ----------------------------------------------------- *)

  (*
   * Return whether or not a given predicate is true for any element of a list
   * and its index.
   * f	   -> the predicate to test over the list
   * index -> the index of the first element
   * list  -> the list to test f over
   * <- true if any element of list satisifies f
   *)
  fun existsIndex _ (_, nil) =
	false
    | existsIndex f (index, head::tail) =
	if f(index, head) then true else existsIndex f (index+1, tail)

  (* -- functions ---------------------------------------------------------- *)

  local
    (*
     * The is a naive adaptation of the iterative live-variable analysis
     * algorithm given in Aho, Sethi, and Ullman, page 631.  A better
     * implementation might use bit vectors to represent the register sets.
     *)

    (*
     * Return a list of (use, define, successors) block triples for a given
     * list of basic blocks.
     *)
    local
      fun triples1(block, successors) = (IntegerDataFlow.use_ block,
					 IntegerDataFlow.define block,
					 successors)
    in
      fun triples blocks =
	    ListPair.map triples1 (blocks, BasicBlock.successors blocks)
    end

    (*
     * Return the in and out sets of a given block triple according to a given
     * in set lookup function.
     *)
    fun liveness1 lookup (use, define, successors) =
	  let
	    val out = foldr IntSet.union IntSet.empty (map lookup successors)
	    val in_ = IntSet.union(use, IntSet.difference(out, define))
	  in
	    (in_, out)
	  end

    (*
     * Return whether or not the size of a given in set has increased.
     *)
    fun changed lookup (index, (in_, _)) =
	  IntSet.numItems in_>IntSet.numItems(lookup index)

    (*
     * Return the liveness of a given set of block triples according to a
     * given in set lookup function.
     *)
    fun liveness' triples lookup =
	  let
	    val sets = map (liveness1 lookup) triples
	  in
	    if existsIndex (changed lookup) (0, sets) then
	      let
		val vector = Array.fromList sets

		fun lookup' index = #1(Array.sub(vector, index))
		    handle Subscript => (print "index = "; print (Int.toString index); 
					 print "\n"; raise Subscript)
	      in
		liveness' triples lookup'
	      end
	    else
	      sets
	  end
  in
    fun liveness blocks =
	  map IntSet.intersection
	      (liveness' (triples blocks) (fn _ => IntSet.empty))
  end

end

