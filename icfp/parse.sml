(* parse.sml by Tom 7 *)

structure Parse :> PARSE =
struct

  fun curry2 f a b = f (a, b)

  val VERSION = "$Id$"

  exception Impossible

  open Parsing Gml Tokens

  infixr 4 << >>
  infixr 3 &&
  infix  2 -- ##
  infixr 2 wth suchthat return guard
  infixr 1 ||

	fun lit x = (anyWord suchthat (curry2 op= x))

	val binder = (anyWord suchthat (fn x => CharVector.sub(x, 0) = #"/")) 
			          wth (fn x => Binder (implode (tl (explode x))))

(* val operator = [ "addi", "addf", "acos", "asin", "clampf", "cos",
	"divi", "divf", "eqi", "equif", "floor", "frac", "lessi",
	"lessf", "modi", "muli", "mulf", "negi", "negf", "real",
	"sin", "sqrt", "subi", "subf", "getx", "gety", "getz",
	"point", "get", "length", "sphere", "cube", "cylinder",
	"cone", "plane", "translate", "scale", "uscale", "rotatex",
	"rotatey", "rotatez", "light", "pointlight", "spotlight",
	"union", "intersect", "difference", "render" ] *)

	val literal = anyWord wth Var

	fun array () = (lit "[" >> repeat ($exp) << lit "]") 
			wth (Array o Vector.fromList)

	and function () = (lit "{" >> repeat ($exp) << lit "}") wth Fun

	and exp () =
			alt [ anyNumber wth Int,
					  anyFloat wth Real,
						anyString wth String,
						binder,
						literal,
						$array,
						$function ]

	val prog = repeat ($exp)
						
end
