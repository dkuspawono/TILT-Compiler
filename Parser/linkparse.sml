(*$import FrontEnd TVClose NamedForm *)

signature LINK_PARSE =
 sig 
   exception Parse of FrontEnd.parseResult
   type filepos = SourceMap.charpos -> string * int * int
   val parse_impl : string -> filepos * string list * Ast.dec
   val parse_inter : string -> filepos * string list * Ast.spec list
 end

structure LinkParse :> LINK_PARSE =
struct
  exception Parse of FrontEnd.parseResult

  local
    fun make_source s = 
	let val instream = TextIO.openIn s
	in  (instream,
	     Source.newSource(s,0,instream,true,
			      ErrorMsg.defaultConsumer()))
	end

    fun parse s = let val (instream,src) = make_source s
		  in  (instream,Source.filepos src, FrontEnd.parse src)
		  end
		  
    fun tvscope_dec dec = (TVClose.closeDec dec; dec)
    fun named_form_dec dec = NamedForm.namedForm dec
  in
    type filepos = SourceMap.charpos -> string * int * int
    fun parse_impl s =
      case parse s of 
	(ins,fp,FrontEnd.PARSE_IMPL (imports,dec)) => 
	  let val dec = tvscope_dec dec
	      val dec = named_form_dec dec
	      val _ = TextIO.closeIn ins
	  in (fp,imports,dec)
	  end
      | (ins,_,result) => (TextIO.closeIn ins; raise Parse result)
    fun parse_inter s =
      case parse s of 
	(ins,fp,FrontEnd.PARSE_INTER (includes,specs)) => (TextIO.closeIn ins; (fp,includes,specs))
      | (ins,_,result) => (TextIO.closeIn ins; raise Parse result)
  end
end;
(*
structure X =
struct
  fun ppdec message dec =
    let val ppstream = PrettyPrint.mk_ppstream (ErrorMsg.defaultConsumer())
	val style = PrettyPrint.CONSISTENT
	val offset = 0
    in
      PrettyPrint.begin_block ppstream style offset;
      PrettyPrint.add_newline ppstream;
      PrettyPrint.add_newline ppstream;
      PrettyPrint.add_string ppstream message;
      PrettyPrint.add_newline ppstream;
      PPAst.ppDec ppstream (dec, 50);
      PrettyPrint.end_block ppstream
    end

  fun do_close dec =
    (ppdec "Declaration as parsed:" dec;
     TVClose.closeDec dec;
     ppdec "Declaration after type variable binding:" dec;
     dec)
end
*)
