(*
	Check a few cases of Char.fromCString.
*)
fun c2s (c:char) : string =
	let	val num = Int.toString(ord c)
		val rep = Char.toString c
	in	num ^ "(" ^ rep ^ ")"
	end

fun check (s:string, c:char) : unit =
	(case (Char.fromCString s) of
		SOME c' =>
			if c = c' then ()
			else print (s ^ " -> SOME " ^ c2s c' ^ ", expected " ^ c2s c ^ "\n")
	|	NONE =>
			print (s ^ " -> NONE, expected " ^ c2s c ^ "\n"))
	handle e =>
		print (s ^ " -> " ^ exnName e ^ "\n")

val _ = app check
	[("\\n", #"\010"),
	("\\t", #"\009"),
	("\\v", #"\011"),
	("\\b", #"\008"),
	("\\r", #"\013"),
	("\\f", #"\012"),
	("\\a", #"\007"),
	("\\\\",  #"\\"),
	("\\?", #"?"),
	("\\'", #"'"),
	("\\\"", #"\""),
	("\\1", #"\001"),
	("\\11", #"\009"),
	("\\111", #"\073"),
	("\\1007", #"\064"),
	("\\100A", #"\064"),
	("\\0",   #"\000"),
	("\\377", #"\255"),
	("\\18", #"\001"),
	("\\178", #"\015"),
	("\\1C", #"\001"),
	("\\17C", #"\015"),
	("\\x0", #"\000"),
	("\\xff", #"\255"),
	("\\xFF", #"\255"),
	("\\x1", #"\001"),
	("\\x11", #"\017"),
	("\\xag", #"\010"),
	("\\xAAg", #"\170"),
	("\\x0000000a", #"\010"),
	("\\x0000000a2", #"\162"),
	("\\x0000000ag", #"\010"),
	("\\x0000000A", #"\010"),
	("\\x0000000A2", #"\162"),
	("\\x0000000Ag", #"\010"),
	("\\x00000000000000000000000000000000000000000000000000000000000000011+",
	#"\017")]