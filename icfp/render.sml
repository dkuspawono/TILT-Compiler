structure Render : RENDER = 
  struct

    open Base
    open Intersect
    open Vect
    exception Error of string

    val chat = ref 0	
    val i2r = Real.fromInt
    val black = (0.0, 0.0, 0.0)

    fun add2o f obj (x : real, y : real) = 
	let val (x2,y2) = f obj
	in  (x+x2, y+y2)
	end
    fun say s = (print s; TextIO.flushOut TextIO.stdOut)

    (* bump depends on how far we are from the source *)
    fun bump (hit, dir, dist) = let val f = (Real.abs dist) / 1e5
				in  add(hit, scale(f, dir))
				end

    (* Returns a list with one interval *)
    fun primIntersect src dir obj = 
	let val (t,name,(hit,l2,l3)) = (case obj of
				  Sphere (name, m4,t) => (t,name,sphere(m4,src,dir))
				| Plane (name, m4,t) => (t,name,plane(m4,src,dir))
				| Cube (name, m4,t) => (t,name,cube(m4,src,dir))
				| Cone (name, m4,t) => (t,name,cone(m4,src,dir))
				| Cylinder (name, m4,t) => (t,name,cylinder(m4,src,dir))
				| _ => raise (Error "primIntersect for non-primitive object"))
	in  if hit
		then (case map (fn info => (t, name, info)) (l3 ()) of
			  [] => []
			| [(t,name,{u,v,face,N,dist,hit})] => 
				    let val hit' = bump(hit, dir, dist)
					val dist' = distance(src,hit')
					val dist' = if (dist > 0.0) then dist' else ~dist'
					val i1 = (t,name,{u=u,v=v,face=face,N=N,dist=dist,hit=hit})
					val i2 = (t,name,{u=u,v=v,face=face,N=N,dist=dist',hit=hit'})
				    in  [if (dist < dist')
					    then (i1,i2)
					 else (i2,i1)]
				    end
			| [i1 as (_,_,{dist,...}),
			   i2 as (_,_,{dist=dist',...})] => if (dist < dist')
								then [(i1,i2)]
							    else [(i2,i1)]
			| _ => raise (Error "primIntersect for more than 2 hits"))
	    else []
	end

    local
	fun showDist(_,n,{dist,...}:l3info) = (print n; print ": "; printR dist)
    in
	fun showIntervals intervals = 
	    let val _ = print "["
		val _ = app (fn (i1,i2) => (print "("; showDist i1;
					    print ",  "; showDist i2; print ")  ")) intervals
		val _ = print "]"
	    in ()
	    end
	fun showEndPoints eps = 
	    let val _ = print "["
		val _ = app (fn ep => (showDist ep;  print ",  ")) eps
		val _ = print "]"
	    in ()
	    end
    end

    fun getIntersects viewerPos dir scene = 
	let val in1 = ref false
	    val in2 = ref false
	    val in3 = ref false
	    fun flipOn r () = r := true
	    fun flipOff r () = r := false
	    fun flipToggle r = r := (not (!r))
	    fun help s1 s2 combine =
		let val i1 = (getIntersects viewerPos dir s1)
		    val i2 = (getIntersects viewerPos dir s2)
(*		    val _ = (showIntervals i1; print "\n"; showIntervals i2; print "\n")   *)
		    val i1 = map (fn (s,e) => [(flipOn in1,s),(flipOff in1,e)]) i1
		    val i2 = map (fn (s,e) => [(flipOn in2,s),(flipOff in2,e)]) i2
		    val flatten = foldl (op @) []
		    fun greater ((_,(_,_,{dist=d1,...}:l3info)),
				 (_,(_,_,{dist=d2,...}:l3info))) = d1 > d2
		    val iboth = ListMergeSort.sort greater ((flatten i1) @ (flatten i2))
(*		    val _ = (showEndPoints (map #2 iboth); print "\n") *)
		    val res = ref []		
		    fun process (flipper, cur) = (flipper(); 
(*
						  print (Bool.toString (!in1)); print "  ";
						  print (Bool.toString (!in2)); print "\n";
*)
						  if (combine(!in1, !in2) = !in3)
						      then ()
						  else (flipToggle in3;
							res := cur :: (!res)))
		    val _ = app process iboth
		    fun pairUp [] = []
		      | pairUp [_] = raise (Error "pairUp given odd number of elements")
		      | pairUp (a::b::rest) = (a,b) :: (pairUp rest)
		    val final = rev (!res)
(*		    val _ = (showEndPoints final; print "\n\n")  *)
		in  pairUp final
		end
	in  (case scene of
		 Union (s1, s2) => help s1 s2 (fn (a,b) => a orelse b)
	       | Intersection (s1, s2) => help s1 s2 (fn (a,b) => a andalso b)
	       | Difference (s1, s2) => help s1 s2 (fn (a,b) => a andalso (not b))
	       | _ => primIntersect viewerPos dir scene)
	end

    fun getIntersect viewerPos dir scene = 
	 let val intersects = getIntersects viewerPos dir scene 
(*	     val _ = (showIntervals intersects; print "\n") *)
             fun loop [] = NONE
               | loop ((i1 as (_,_,{dist=d1,...}:l3info),
			i2 as (_,_,{dist=d2,...}:l3info)) :: rest) = 
		    if (d1 >= 0.0)
		      then SOME i1
		    else if (d2 >= 0.0)	 
		      then NONE
	            else loop rest					      
	 in  loop intersects
	 end						 

    fun hasIntersect src dir obj : bool = case (getIntersect src dir obj) of
				       NONE => false
				     | _ => true

    (* Diffuse intensity and Specular intensity *)
    fun castShadow (hit, scene, incident, N, n) light : v3 * v3 = 
	let val (Lj, Ldist) = Light.toLight (hit, light)  
	    val shadowed = hasIntersect hit Lj scene
	in  if shadowed
		then (black, black)
	    else let 
		     val Ij = Light.illuminate(light, hit, Lj)
		     val Hj = halfway(Lj, incident)
		     val diffuse = scale(dp(N,Lj), Ij)
		     val spec = scale(Math.pow(dp(N,Hj),n), Ij)
(*
		     val _ = (print "castShadow can find light    N = "; printV3 N; print "  Lj = "; printV3 Lj; print "\n")
		     val _ = (print "           Ij = "; printV3 Ij; print "  diffuse = "; printV3 diffuse; print "\n")
*)
		 in  (diffuse, spec)
		 end
	end

    fun cast (apply, Ia, viewerPos, dir, scene, lights, 0) : color =  black
      | cast (apply, Ia, viewerPos, dir, scene, lights, depth) : color =  
	let 
	    val _ = if (!chat >= 1)
			then say "." else ()
	    val _ = if (!chat >= 2)
			then (print "Casting in direction "; printV3 dir; print "\n") 
		    else ()
	    val intersect = getIntersect viewerPos dir scene
(*
	    val _ = if (!chat >= 2)
			then for (0, (length intersects),
				  fn i => let val intersect = List.nth(intersects, i)
					      val (_,name,{hit, dist, u,v,face,N}) = intersect
					  in   (print "Intersect #"; print (Int.toString i);
						print " with face "; print (Int.toString face);
						print " at distance "; printR dist;
						print " and intersection "; printV3 hit; print "\n")
					  end)
		    else ()
*)
	in  case intersect of
	    NONE => black
	  | SOME (t, name, {u,v,face,N,hit,dist}) =>
		let  val incident = negate dir
		     val hit = bump(hit, incident, dist)
		     (* Surface properties *)
		     val (C : Base.color, kd, ks, n) = apply(t,face,u,v)
		     (* Direct contribution of light sources *)
		     val (diffuses, speculars) = ListPair.unzip (map (castShadow (hit,scene,incident,N,n)) lights)
		     val diffuse = foldl add black diffuses
		     val finalDiffuse = mult(scale(kd, diffuse),C)
		     val specular = foldl add black speculars 
		     (* Recursive reflection *)
		     val S = reverseHalfway (incident, N)
		     val Is = cast(apply, Ia, hit, S, scene, lights, depth - 1)
		     (* Combine terms *)
		     val finalIntensity = add(mult(scale(kd, Ia), C),
					      add(finalDiffuse, 
						  add(mult(scale(ks,specular),C),
						      mult(scale(ks, Is), C))))
(*
		     val _ = (print "finalDiffuse is "; printV3 finalDiffuse; print "\n")
		     val _ = (print "finalIntensity is "; printV3 finalIntensity; print "\n")
*)
		 in  finalIntensity
		 end
	end


    fun render apply
	       {amb    : color,
		lights : light list,
		scene  : obj,
		depth  : int,
		hfov   : real,
		hres   : int,
		vres   : int} : Ppm.ppm = 

	let val hresR = i2r hres
	    val vresR = i2r vres
	    val width = 2.0 * Math.tan (deg2rad(0.5 * hfov))
	    val pixelSize = width / hresR
	    val upperLeftX = ~ width / 2.0
	    val height = pixelSize * vresR  (* Since pixels are squares *)
	    val upperLeftY = height / 2.0

	    val image = Ppm.ppm (vres, hres)
	    val viewPos = (0.0, 0.0, ~1.0)   (* Viewer position *)

	    val _ = for(0, vres, fn row => 
			(say "\nRendering row "; say (Int.toString row); say ":  ";
			 for (0, hres, fn col => 
			      let val toScreen = (upperLeftX + (i2r col + 0.5) * pixelSize,
						  upperLeftY - (i2r row + 0.5) * pixelSize, 1.0)
				  val dir = normalize toScreen
				  val _ = if (col mod 10 = 0) then say "!" else ()
				  val _ = if (!chat >= 1)
					      then (print "\nDrawing pixel: "; printV3 toScreen; print "\n") 
					  else ()
				  val color = cast (apply, amb, viewPos, dir, scene, lights, depth)
			      in  Ppm.pxl(col,row,Ppm.colortorgb color, image)
			      end)))

	in  image
	end

  end

