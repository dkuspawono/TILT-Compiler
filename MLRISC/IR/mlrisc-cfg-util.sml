(*
 * Some basic local CFG transformations
 *)
functor CFGUtilFn
     (structure CFG : CONTROL_FLOW_GRAPH
      structure P   : INSN_PROPERTIES
         sharing CFG.I = P.I
     ) : CFG_UTIL =
struct

   structure CFG = CFG
   structure I   = CFG.I
   structure W   = CFG.W
   structure G   = Graph
   structure H   = HashArray
   structure S   = BitSet

   exception Can'tMerge

   fun error msg = MLRiscErrorMsg.impossible("CFGTransforms."^msg)

   fun labelOf(G.GRAPH cfg) node = CFG.defineLabel(#node_info cfg node)

   fun copyEdge(CFG.EDGE{a,w,k}) = CFG.EDGE{a=ref(!a),w=ref(!w),k=k}

   (*=====================================================================
    *
    *  Check whether block i must preceed block j in any linear layout.
    *  This may be true if i falls through to j (transitively)
    *
    *=====================================================================*)
   fun mustPreceed (G.GRAPH cfg) (i,j) =
   let val visited = H.array(23,false)
       fun chase [] = false
         | chase((u,v,CFG.EDGE{k=(CFG.FALLSTHRU|CFG.BRANCH false),...})::_) =
           if H.sub(visited,u) then false
           else u = i orelse (H.update(visited,u,true); chase(#in_edges cfg u))
         | chase(_::es) = chase es
   in  i = j orelse chase(#in_edges cfg j)
   end

   (*=====================================================================
    *
    *  Predicates on nodes and edges
    *
    *=====================================================================*)
   fun isMerge (G.GRAPH cfg) node = length(#in_edges cfg node) > 1
   fun isSplit (G.GRAPH cfg) node = length(#out_edges cfg node) > 1
   fun hasSideExits (G.GRAPH cfg) node = 
         List.exists (fn (_,_,CFG.EDGE{k=CFG.SIDEEXIT _,...}) => true 
                       | _ => false) (#out_edges cfg node)
   fun isCriticalEdge CFG (i,j,_) = isMerge CFG i andalso isSplit CFG j

   (*=====================================================================
    *
    *  Update the label of the branch instruction in a certain block
    *  to be consistent with the control flow edges.  This doesn't work
    *  on hyperblocks!!!
    *
    *=====================================================================*)
   fun updateJumpLabel(CFG as G.GRAPH cfg) =
   let val labelOf = labelOf CFG
       fun update node =
       case #node_info cfg node of
          CFG.BLOCK{insns=ref [],...} => ()
       |  CFG.BLOCK{kind=CFG.START,...} => ()
       |  CFG.BLOCK{kind=CFG.STOP,...} => ()
       |  CFG.BLOCK{insns=insns as ref(jmp::rest),...} => 
             (case #out_edges cfg node of
                [] => ()
             |  [(_,_,CFG.EDGE{k=(CFG.ENTRY | CFG.EXIT),...})] => ()
             |  [(i,j,_)] =>
                  if P.instrKind jmp = P.IK_JUMP then
                       insns := P.setTargets(jmp,[labelOf j])::rest
                  else ()
             |  [(_,i,CFG.EDGE{k=CFG.BRANCH x,...}),
                 (_,j,CFG.EDGE{k=CFG.BRANCH y,...})] =>
                  let val (i,j) = if x then (j,i) else (i,j)
                  in  insns := P.setTargets(jmp,[labelOf i,labelOf j])::rest
                  end
             |  es =>
                  let fun cmp ((_,_,CFG.EDGE{k=CFG.SWITCH i,...}),
                               (_,_,CFG.EDGE{k=CFG.SWITCH j,...})) = i < j
                        | cmp _ = error "cmp"
                      val es = Sorting.sort cmp es
                      val labels = map (fn (_,j,_) => labelOf j) es
                  in  insns := P.setTargets(jmp,labels)::rest
                  end
             )
   in  update
   end

   (*=====================================================================
    *
    *  Merge a control flow edge i -> j.
    *  Raise Can't Merge if it is illegal.
    *  After merging blocks i and j will become block i.
    *
    *=====================================================================*)
   fun mergeEdge (CFG as G.GRAPH cfg) (i,j,e as CFG.EDGE{w,k,...}) = 
   let val _ = case k of
                  (CFG.ENTRY | CFG.EXIT) => raise Can'tMerge
               |  _ => () 
       val _ = case (#out_edges cfg i,#in_edges cfg j) of
                  ([(_,j',_)],[(i',_,_)]) => 
                     if j' <> j orelse i' <> i then raise Can'tMerge
                     else ()
               |  _ => raise Can'tMerge  
       val _ = if mustPreceed CFG (i,j) then raise Can'tMerge else ()
       val CFG.BLOCK{data=d2,insns=i2,annotations=a2,...} = #node_info cfg j
       val _  = case !d2 of [] => () | _ => raise Can'tMerge
       val CFG.BLOCK{data=d1,insns=i1,annotations=a1,...} = #node_info cfg i
       val insns1 = case !i1 of
                      [] => []
                    | insns as jmp::rest => 
                        if P.instrKind jmp = P.IK_JUMP then rest else insns
   in  i1 := !i2 @ insns1;
       a1 := !a1 @ !a2;
       #set_out_edges cfg (i,map (fn (_,j',e) => (i,j',e)) (#out_edges cfg j));
       #remove_node cfg j;
       updateJumpLabel CFG i;
       true
   end handle Can'tMerge => false

   (*=====================================================================
    *
    *  Eliminate the jump at the end of a basic block if feasible
    *
    *=====================================================================*)
   fun eliminateJump (CFG as G.GRAPH cfg) i = 
       (case #out_edges cfg i of
          [e as (i,j,CFG.EDGE{k,w,a})] =>
            (case CFG.fallsThruFrom(CFG,j) of
                SOME _ => false
             |  NONE => 
                if mustPreceed CFG (j,i) then false
                else 
                let val CFG.BLOCK{insns,...} = #node_info cfg i
                    val CFG.BLOCK{data,...}  = #node_info cfg j
                in  case (!data,!insns) of 
                      ([],jmp::rest) =>
                       if P.instrKind jmp = P.IK_JUMP then
                        (insns := rest;
                         CFG.removeEdge CFG e;
                         #add_edge cfg (i,j,CFG.EDGE{k=CFG.FALLSTHRU,w=w,a=a});
                         true
                        )
                       else false
                    |  _ => false
                end
            )
       |  _ => false
       )
    
   (*=====================================================================
    *
    *  Insert a jump at the end of a basic block if feasible
    *
    *=====================================================================*)
   fun insertJump (CFG as G.GRAPH cfg) i =   
       (case #out_edges cfg i of
           [e as (i,j,CFG.EDGE{k=CFG.FALLSTHRU,w,a,...})] =>
              let val CFG.BLOCK{insns,...} = #node_info cfg i
              in  insns := P.jump(labelOf CFG j) :: !insns;
                  CFG.removeEdge CFG e;
                  #add_edge cfg (i,j,CFG.EDGE{k=CFG.JUMP,w=w,a=a});
                  true
              end
        |  _ => false
       )

   (*=====================================================================
    *
    *  Split a control flow edge, return a new edge and the new block 
    *
    *=====================================================================*)
   fun splitEdge (CFG as G.GRAPH cfg) {edge=(i,j,e as CFG.EDGE{w,...}),jump} = 
   let val k = #new_id cfg ()
       val jump = jump orelse i = j orelse
              (case CFG.fallsThruFrom(CFG,j) of 
                NONE => false
              | SOME _ => true)
       val node as CFG.BLOCK{insns,freq,...} = CFG.newBlock(k,CFG.B.default)
       val kind = if jump then CFG.JUMP else CFG.FALLSTHRU
       val _    = if jump then insns := [P.jump(labelOf CFG j)] else ()
       val edge = (k,j,CFG.EDGE{w=ref(!w),a=ref [],k=kind})
   in  CFG.removeEdge CFG (i,j,e);
       #add_edge cfg (i,k,e);
       #add_node cfg (k,node);
       #add_edge cfg edge;
       freq := !w;
       updateJumpLabel CFG i;
       {node=(k,node),edge=edge}
   end 

   (*=====================================================================
    *
    *  Split all critical edges in the CFG
    *
    *=====================================================================*)
   fun splitAllCriticalEdges (CFG as G.GRAPH cfg) =
       #forall_edges cfg (fn e => if isCriticalEdge CFG e then
                                    (splitEdge CFG {edge=e,jump=false}; ())
                                  else ())

   (*=====================================================================
    *
    *  Tail duplicate a region until there are no side entry edges
    *  entering into the region.  Return the set of new edges and nodes
    *
    *=====================================================================*)
   fun tailDuplicate (CFG as G.GRAPH cfg : CFG.cfg) 
                     {subgraph=G.GRAPH subgraph : CFG.cfg,root} =
   let exception NotFound
       val blockMap = H.array'(10,fn v => raise NotFound)
       val _ = print("[root "^Int.toString root^"]\n")

       fun duplicate v =
           H.sub(blockMap,v) handle NotFound =>
           let val w  = #new_id cfg ()
               val w' = CFG.copyBlock(w,#node_info cfg v)
           in  #add_node cfg (w,w');
               H.update(blockMap,v,(w,w'));
               app (#add_edge cfg)
                   (map (fn (i,j,e) => (w,j,copyEdge e)) (#out_edges cfg v));
               updateJumpLabel CFG w;
               (w,w')
           end

       fun process((n,_)::rest,ns,Ns,Es) =
            process(rest,collect(#entry_edges subgraph n,ns),Ns,Es)
         | process([],ns,Ns,Es) = dupl(ns,Ns,Es,false)

       and collect([],ns) = ns
         | collect((i,_,_)::es,ns) = collect(es,if i = root then ns else i::ns)

       and dupl([],Ns,Es,changed) = (Ns,Es,changed)
         | dupl(n::ns,Ns,Es,changed) =
              redirect(#out_edges cfg n,ns,Ns,Es,changed)   

       and redirect([],ns,Ns,Es,changed) = dupl(ns,Ns,Es,changed)
         | redirect((u,v,e)::es,ns,Ns,Es,changed) =
            if v <> root andalso
               #has_edge cfg (u,v) andalso
               #has_node subgraph v andalso 
               not(#has_edge subgraph (u,v)) then
               (* 
                * u -> v is a side entry edge, duplicate v
                *)
            let val _ = print("[tail duplicating "^Int.toString u^" -> "^
                              Int.toString v^"]\n")
                val (w,w') = duplicate v
            in  CFG.removeEdge CFG (u,v,e);
                #add_edge cfg (u,w,e);
                updateJumpLabel CFG u;
                redirect(es,w::ns,(w,w')::Ns,(u,w,e)::Es,true)
            end
            else redirect(es,ns,Ns,Es,changed)

       fun iter(Ns,Es) = 
           let val (Ns,Es,changed) = process(#nodes subgraph (),[],Ns,Es)
           in  if changed then (CFG.changed CFG; iter(Ns,Es))
               else {nodes=Ns,edges=Es}
           end

   in  iter([],[]) 
   end


   (*=====================================================================
    *
    *  Remove unreachable code in the CFG
    *
    *=====================================================================*)
   fun removeUnreachableCode(CFG as G.GRAPH cfg) =
   let val N = #capacity cfg ()
       val visited = S.create N 
       fun mark n = if S.markAndTest(visited,n) then ()
                    else app mark (#succ cfg n)
       val changed = ref false
       fun remove(b,CFG.BLOCK{data,insns,...}) =
           if S.contains(visited,b) then ()
           else
           (changed :=true;
            case #in_edges cfg b of
              [] => #remove_node cfg b
            |  _  => (insns := []; #set_out_edges cfg (b,[]))
           )
   in  app mark (#entries cfg ());
       #forall_nodes cfg remove;
       if !changed then CFG.changed CFG else ()
   end


   (*=====================================================================
    *
    *  Merge all edges in the CFG
    *
    *=====================================================================*)
   fun mergeAllEdges(CFG as G.GRAPH cfg) =
   let val mergeEdge = mergeEdge CFG
       fun higherFreq((_,_,CFG.EDGE{w=x,...}),(_,_,CFG.EDGE{w=y,...})) =
           W.<(!x,!y)
       fun mergeAll([],changed) = changed
         | mergeAll(e::es,changed) = mergeAll(es,mergeEdge e orelse changed) 
       val changed = mergeAll(Sorting.sort higherFreq (#edges cfg ()),false)
   in  if changed then CFG.changed CFG else ()
   end

end

(*
 * $Log$
# Revision 1.2  2001/12/13  16:31:40  swasey
# *** empty log message ***
# 
# Revision 1.1  99/02/17  21:14:29  pscheng
# *** empty log message ***
# 
# Revision 1.1  1999/02/17  20:05:57  pscheng
# *** empty log message ***
#
 *)
