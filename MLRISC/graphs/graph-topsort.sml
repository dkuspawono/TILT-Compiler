structure GraphTopsort : GRAPH_TOPOLOGICAL_SORT = 
struct

   structure G = Graph

   (*
    * Topological sort
    *)
   fun topsort (G.GRAPH G) roots = 
   let val visited = BitSet.create (#capacity G ())
       val succ    = #succ G
       fun dfs (n, list) =
          if BitSet.markAndTest(visited,n) then list
          else dfs'(n,succ n,list)
       and dfs'(x,[],list)    = x::list
         | dfs'(x,n::ns,list) = dfs'(x,ns,dfs(n,list))
       and dfs''([], list)    = list
         | dfs''(n::ns, list) = dfs''(ns,dfs(n,list))
   in
       dfs''(roots,[])
   end

end

(* 
 * $Log$
# Revision 1.2  2001/12/13  16:32:03  swasey
# *** empty log message ***
# 
# Revision 1.1  99/02/17  21:15:56  pscheng
# *** empty log message ***
# 
# Revision 1.1  1999/02/17  20:07:25  pscheng
# *** empty log message ***
#
 *)
