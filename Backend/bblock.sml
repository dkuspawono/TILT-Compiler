functor Bblock(structure Machine : MACHINE
	       structure Machineutils : MACHINEUTILS
	       structure Tracetable : TRACETABLE)
    :> BBLOCK where Tracetable = Tracetable
              where Machine = Machine =
struct
   structure Machine = Machine
   structure Machineutils = Machineutils
   structure Tracetable = Tracetable
   open Machineutils Machine Core

   val diag = ref false
   val doTimer = Stats.ff("DoBblockTimer")
   fun subtimer(str,f) = if (!doTimer)
			     then Stats.subtimer(str,f)
			 else f

   (* Annotations on an instruction *)
   datatype 'a annotated = NO_ANN of 'a
                         | LIVE of Regset.set * 'a

   (* All the information for a single basic block *)
   datatype bblock = BLOCK of {instrs : instruction annotated list ref,
			       def       : Regset.set,
                               use       : Regset.set,
			       in_live   : Regset.set ref,
			       out_live  : Regset.set ref,
			       truelabel : bool,
			       succs     : label list ref}

   (* utility functions *)

   val error = fn s => Util.error "bblock.sml" s

   fun listToSet lst = Regset.addList(Regset.empty, lst)

   (* Find the union of a list of sets of registers *)

   fun unionLists [] = Regset.empty
     | unionLists [s] = s
     | unionLists (s::rest) =
       let fun sum(nil,accum) = accum
             | sum(h::t,accum) = sum(t,Regset.union(accum,h))
       in sum(rest,s)
       end

   val defUse = Machine.defUse

   fun live (LIVE (s,_)) = s
     | live (NO_ANN _) = Regset.empty

   (* Remove all annotations from an instruction *)
   fun stripAnnot (NO_ANN x) = x
     | stripAnnot (LIVE (_, a)) = a

   (* Turn a liveness annotation into a string, to be shown as a
      comment *)
   fun msAnnotation (NO_ANN _) = ""
     | msAnnotation (LIVE (live,a)) =
       let
	 fun loop [] = ""
	   | loop ((R v)::ds) = ("$" ^ (Int.toString v) ^ " ") ^ (loop ds)
           | loop ((F v)::ds) = ("$f" ^ (Int.toString v) ^ " ") ^ (loop ds)
       in loop (Regset.listItems live)
       end

   val (op -) = Regset.difference
   val \/ = Regset.union
   infix 4 \/

   val special_regs_set = listToSet special_regs

   (* computes s1 + (l2 - s3) *)
   fun setPlusListMinusSet(baseset,addlist,filterset) =
       let fun folder (item,curset) =
           if (Regset.member(filterset,item))
               then curset
           else Regset.add(curset,item)
       in  foldl folder baseset addlist
       end

   fun blockDefUse compute_map (BLOCK{instrs,
				      def,
				      use,
				      in_live,
				      out_live,
				      truelabel,
				      succs}) =
       let
         (* We don't want special registers to appear in def/use sets
	    when we are done though we permit them in intermediate results *)
           fun loop ([],use,def) =
	       let val use = use - special_regs_set
		   val def = def - special_regs_set
		   val use =
		       Regset.foldl (fn (f,acc) => (case (Regmap.find(compute_map,f)) of
							SOME (SOME c,_) => Regset.add(acc,c)
						      | _ => acc)) use use
	       in  (use, def)
	       end
             | loop (h :: t,use, def) =
                 let val (instr_def, instr_use) = defUse (stripAnnot h)
                     (* we could convert these very short lists to sets and use set operation;
                    but it's more efficient to have the following specialized version *)
                     val use' = setPlusListMinusSet(use,instr_use,def)
                     val def' = setPlusListMinusSet(def,instr_def,use')
                 in loop(t,use',def')
                 end
	   val (use,def) = loop (rev (!instrs),Regset.empty,Regset.empty)
       in BLOCK{instrs=instrs,
		 def=def,
		 use=use,
		 in_live=ref Regset.empty,
		 out_live=ref Regset.empty,
		 truelabel=truelabel,
		 succs = succs}
       end


   (* Define in_live and out_live for every basic block using
      the blocks' def and use values. *)
   fun findLiveTemps block_map first_label =
     let

       val all_labels = map #1 (Labelmap.listItemsi block_map)

       fun getInLive (BLOCK{in_live,...}) = ! in_live

       fun getBlock blk =
	   case Labelmap.find(block_map, blk) of
	       SOME value => value
	     | NONE => error ("findLiveTemps: getblock" ^ (msLabel blk))

       (* Aho/Sethi/Ullman suggests traversing the blocks in the
          OPPOSITE order from a depth-first-search through the
	  control-flow graph. *)
       local
	   fun revDFS [] (seenList, seenSet) = seenList
	     | revDFS (blk :: rest) (seenList, seenSet) =
	       if (Labelset.member(seenSet, blk)) then
		   revDFS rest (seenList, seenSet)
	       else
		   let val (BLOCK{succs,...}) = getBlock blk
		   in  revDFS (!succs @ rest) (blk :: seenList, Labelset.add(seenSet, blk))
		   end
       in  (* some blocks are reachable via jsr's so we must include all labels *)
	   val rev_blocklabel_list = revDFS (first_label :: all_labels) ([], Labelset.empty)
(*	   val blocklabel_list = rev rev_blocklabel_list *)
       end

       (* Flag: have we gone an entire pass through the function
	        without changing any block's live-variable values? *)
       val unchanged = ref true

       (* Make one pass through the entire function *)
       fun reverse_step blk =
	   let
	     val (BLOCK{def, use, in_live, out_live, succs, ...}) = getBlock blk
	     val block_liveins = map (fn l => getInLive (getBlock l)) (!succs)
             val out_live' = unionLists block_liveins
	     val in_live'  =
		 if (eqLabs blk first_label) (* the in_live of the first block never changes *)
		     then (!in_live)
		 else Regset.union (use, Regset.difference(out_live', def))
(*
	     val _ = (print "reverse_step call on: ";
		      print (msLoclabel blk);
		      print "     and first_label = ";
		      print (msLoclabel first_label);
		      print "\nuse = ";
		      Regset.app (fn r => (print (msReg r); print ", ")) use;
		      print "\nin_live' = ";
		      Regset.app (fn r => (print (msReg r); print ", ")) use;
		      print "\n\n")
*)
	   in
	       unchanged := ((!unchanged) andalso
			     (Regset.equal(!in_live, in_live')));
	       out_live := out_live';
	       in_live  := in_live'
	   end


       (* Repeat loop() until a fixpoint is reached *)
       fun outerLoop n =
	 (unchanged := true;
	  app reverse_step rev_blocklabel_list;
	  if (not (! unchanged)) then outerLoop (n+1) else n)

       val stepsNeeded = outerLoop 1
       val size = length all_labels

       val _ = if (!diag andalso stepsNeeded > 1 andalso size > 50)
		   then (print "function ";
			 print (msLabel first_label);
			 print " with ";
			 print (Int.toString size);
			 print " labels. liveness analysis took ";
			 print (Int.toString stepsNeeded); print " steps\n")
	       else ()
     in ()
     end

   (* This function ignores special regs, which are *always* live *)

   (* Use the in_live and out_live values determined from findLiveTemps()
      to annotate individual instructions. *)
   fun liveVars compute_map (block_map : bblock Labelmap.map) first_label =
     let

       (* Scan backwards to compute which variables are live after each instruction in
	  the program.   Takes instructions in REVERSE order, returns
	  instructions in REVERSE order.

	  Taken from Aho, Sethi, Ullman, live-variable analysis (eq. 10.11) *)

       fun loop (out,[]) = []
	 | loop (out,instr :: instrs) =
	      let val instr = stripAnnot instr
                  val (def_list, use_list) = defUse instr
		  val instr_def = listToSet def_list
		  (* We must augment the used variables with their runtime types, if present *)
		  val use_list =
		      foldl (fn (f,acc) => (case (Regmap.find(compute_map,f)) of
						SOME (SOME c,_) => f::c::acc
					      | _ => f::acc)) [] use_list
                  (* we don't want special regs in in' so we subtract
                     them out as we add use_list;  note that we don't
                     need to remove special regs from instr_def since
                     instr_def is used to subtract away from out which
                     already doesn't have any special regs *)
		  val in' = setPlusListMinusSet(out - instr_def, use_list, special_regs_set)
              in LIVE(out,instr) :: loop(in',instrs)
	      end

       fun annotateBlock (_, BLOCK{instrs, in_live, out_live, ...}) =
	    instrs := loop (! out_live, !instrs)

      (* compute def/use and zap bblock in_live/out_line information *)
       val block_map' = subtimer("bblock_defuse", Labelmap.map (blockDefUse compute_map)) block_map
     in
       (* find live vars at block boundaries *)
       subtimer("bblock_findLiveTemp", findLiveTemps block_map') first_label;

       (* use this to annotate individual instructions *)
       subtimer("bblock_annotateBlock", Labelmap.appi annotateBlock) block_map' ;

       block_map'
     end
end








