(*$import IL PPPRIM PPIL ILUTIL ILCONTEXT ILSTATIC BASIS ILCONTEXTEQ Ast SourceMap *)

signature LINKIL = 
  sig
      structure Ppprim : PPPRIM
      structure Ppil : PPIL
      structure IlUtil : ILUTIL
      structure IlContext : ILCONTEXT
      structure IlContextEq : ILCONTEXTEQ
      structure IlStatic : ILSTATIC
      structure Basis : BASIS

      type sbnd = Il.sbnd
      type context_entry = Il.context_entry
      type context = Il.context
      type filepos = SourceMap.charpos -> string * int * int
      type module = Il.module

      (* Adding contexts is useful for compilation management *)
      val plus_context : context list -> context

      (* Compiling interfaces to generate a new context *)
      val elab_specs : context * filepos * Ast.spec list -> context option

      (* Compiling source files possibly with an interface constraint to produce some HIL code *)
      val elab_dec : context * filepos * Ast.dec -> module option
      val elab_dec_constrained : context * filepos * Ast.dec * filepos * Ast.spec list -> module option


  end
