(*
 * Trace subgraph adaptor
 *)

signature TRACE_SUBGRAPH_VIEW = 
sig

   val trace_view : Graph.node_id list ->
                      ('n,'e,'g) Graph.graph -> 
                      ('n,'e,'g) Graph.graph 
end

structure TraceView : TRACE_SUBGRAPH_VIEW =
struct

   structure G = Graph
   structure A = HashArray
   structure S = Subgraph_P_View

   fun trace_view nodes (G as G.GRAPH g) =
   let val ord = A.array(#capacity g (),~100)
       fun order(i,[]) = ()
         | order(i,n::ns) = (A.update(ord,n,i); order(i+1,ns))
       val _ = order(0,nodes)
       fun node_p i = A.sub(ord,i) >= 0 
       fun edge_p (i,j) = A.sub(ord,i) + 1 = A.sub(ord,j) 
   in  S.subgraph_p_view nodes node_p edge_p G
   end

end

(*
 * $Log$
# Revision 1.1  99/02/17  21:16:14  pscheng
# *** empty log message ***
# 
# Revision 1.1  1999/02/17  20:07:46  pscheng
# *** empty log message ***
#
 *)
