(*$import YaccBase TopLevel *)

(* ML-Yacc Parser Generator (c) 1989 Andrew W. Appel, David R. Tarditi 
 *
 * $Log$
# Revision 1.4  98/02/01  01:28:00  pscheng
# Changes to facilitate bootstrapping:
#   Added ascription in various places
#   Split up files into signature and code
# 
# Revision 1.3  1998/01/21  20:40:20  pscheng
# moved the .sig files to .sig.sml file
#
# Revision 1.2  1997/10/24  21:36:26  cstone
# update to 109.32 & NT
#
# Revision 1.1.1.1  1997/01/14  01:38:04  george
#   Version 109.24
#
 * Revision 1.1.1.1  1996/01/31  16:01:42  george
 * Version 109
 * 
 *)

(* functor Join creates a user parser by putting together a Lexer structure,
   an LrValues structure, and a polymorphic parser structure.  Note that
   the Lexer and LrValues structure must share the type pos (i.e. the type
   of line numbers), the type svalues for semantic values, and the type
   of tokens.
*)


(* functor JoinWithArg creates a variant of the parser structure produced 
   above.  In this case, the makeLexer take an additional argument before
   yielding a value of type unit -> (svalue,pos) token
 *)

functor JoinWithArg(structure Lex : ARG_LEXER
	     structure ParserData: PARSER_DATA
	     structure LrParser : LR_PARSER
	     sharing ParserData.LrTable = LrParser.LrTable
	     sharing ParserData.Token = LrParser.Token
	     sharing type Lex.UserDeclarations.svalue = ParserData.svalue
	     sharing type Lex.UserDeclarations.pos = ParserData.pos
	     sharing type Lex.UserDeclarations.token = ParserData.Token.token)
		 :> ARG_PARSER  where Token = ParserData.Token
				where Stream = LrParser.Stream
				where type svalue = ParserData.svalue
				where type result = ParserData.result
				where type pos = ParserData.pos
				where type arg = ParserData.arg
				where type lexarg = Lex.UserDeclarations.arg
		=
struct
    structure Token = ParserData.Token
    structure Stream = LrParser.Stream

    exception ParseError = LrParser.ParseError

    type arg = ParserData.arg
    type lexarg = Lex.UserDeclarations.arg
    type pos = ParserData.pos
    type result = ParserData.result
    type svalue = ParserData.svalue

    val makeLexer = fn s => fn arg =>
		 LrParser.Stream.streamify (Lex.makeLexer s arg)
    val parse = fn (lookahead,lexer,error,arg) =>
	(fn (a,b) => (ParserData.Actions.extract a,b))
     (LrParser.parse {table = ParserData.table,
	        lexer=lexer,
		lookahead=lookahead,
		saction = ParserData.Actions.actions,
		arg=arg,
		void= ParserData.Actions.void,
	        ec = {is_keyword = ParserData.EC.is_keyword,
		      noShift = ParserData.EC.noShift,
		      preferred_change = ParserData.EC.preferred_change,
		      errtermvalue = ParserData.EC.errtermvalue,
		      error=error,
		      showTerminal = ParserData.EC.showTerminal,
		      terms = ParserData.EC.terms}}
      )
    val sameToken = Token.sameToken
end;
