
(* =========================================================================
 * AlphaLink.sml
 * ========================================================================= *)

structure AlphaLink (* :> LINKALPHA ??? *) = struct

  (* -- TIL2 structures ---------------------------------------------------- *)

  structure Rtl = Linkrtl.Rtl

  structure TraceTable = Tracetable(val little_endian = true
				    structure Rtl     = Rtl)

  (* -- MLRISC structures -------------------------------------------------- *)

  structure Constant = AlphaMLRISCConstant
  structure Pseudo   = AlphaMLRISCPseudo
  structure Region   = AlphaMLRISCRegion

  structure IntSet = DenseIntSet(structure IntMap = IntBinaryMap
				 structure WordN  = Word32)

  structure RegisterMap = DenseRegisterMap(structure IntMap = IntBinaryMap)

  structure RegisterSpillMap =
    RegisterSpillMap(type offset	   = Constant.const
		     structure RegisterMap = RegisterMap)

  structure StackFrame =
    AlphaStackFrame(structure MLRISCConstant = Constant)

  structure Instr = Alpha32Instr(structure Const  = Constant
				 structure Region = Region)

  structure PseudoInstr = AlphaPseudoInstr(structure Alpha32Instr = Instr)

  structure Rewrite = Alpha32Rewrite(Instr)

  structure FlowGraph = FlowGraph(structure I = Instr
				  structure P = Pseudo)

  structure AsmEmitter = Alpha32AsmEmitter(structure Instr     = Instr
					   structure FlowGraph = FlowGraph)

  structure Props = Alpha32Props(val exnptrR		= [] (* ??? *)
				 structure Alpha32Instr = Instr)

  structure RegAlloc = Alpha32RegAlloc(structure P   = Props
				       structure I   = Instr
				       structure F   = FlowGraph
				       structure Asm = AsmEmitter)

  structure MLTree = MLTreeF(structure Const = Constant
			     structure P     = Pseudo
			     structure R     = Region)

  structure MLTreeExtra = MLTreeExtra(structure MLTree = MLTree)

  structure Float =
    AlphaFloatConvention(structure MLTreeExtra = MLTreeExtra)

  structure Integer =
    AlphaIntegerConvention(structure MLTreeExtra = MLTreeExtra)

  structure IntegerAllocation =
    AlphaIntegerAllocation(structure AlphaInstructions = Instr
			   structure AlphaRewrite      = Rewrite
			   structure Cells	       = Alpha32Cells
			   structure FlowGraph	       = FlowGraph
			   structure IntegerConvention = Integer
			   structure MLRISCRegion      = Region
			   structure RegisterMap       = RegisterMap
			   structure RegisterSpillMap  = RegisterSpillMap
			   functor RegisterAllocation  = RegAlloc.IntRa)

  structure FloatAllocation =
    AlphaFloatAllocation(structure AlphaInstructions = Instr
			 structure AlphaRewrite	     = Rewrite
			 structure Cells	     = Alpha32Cells
			 structure FloatConvention   = Float
			 structure FlowGraph	     = FlowGraph
			 structure IntegerConvention = Integer
			 structure MLRISCRegion      = Region
			 structure RegisterSpillMap  = RegisterSpillMap
			 functor RegisterAllocation  = RegAlloc.FloatRa)

  structure AsmEmit = AsmEmit(structure F = FlowGraph
			      structure E = AsmEmitter)

  val codegen = AsmEmit.asmEmit o
		FloatAllocation.allocateCluster o
		IntegerAllocation.allocateCluster

  structure FlowGraphGen = FlowGraphGen(val codegen	    = codegen
					structure Flowgraph = FlowGraph
					structure InsnProps = Props
					structure MLTree    = MLTree)

  structure MLTreeComp = Alpha32(structure Flowgen	 = FlowGraphGen
				 structure Alpha32MLTree = MLTree
				 structure Alpha32Instr	 = Instr
				 structure PseudoInstrs  = PseudoInstr)

  (* -- emitter structures ------------------------------------------------- *)

  structure CallConventionBasis =
    CallConventionBasis(structure Cells		    = Alpha32Cells
			structure IntegerConvention = Integer
			structure MLRISCRegion      = Region
			structure MLTreeExtra	    = MLTreeExtra
			structure StackFrame	    = StackFrame)

  structure ExternalConvention =
    AlphaStandardConvention(structure Basis		= CallConventionBasis
			    structure FloatConvention	= Float
			    structure IntegerConvention = Integer
			    structure MLTreeExtra	= MLTreeExtra
			    structure StackFrame	= StackFrame)

  structure RegisterTraceMap =
    RtlRegisterTraceMap(structure Cells		 = Alpha32Cells
			structure IntSet	 = IntSet
			structure MLRISCConstant = Constant
			structure RegisterMap	 = RegisterMap
			structure Rtl		 = Rtl
			structure TraceTable	 = TraceTable)

  structure BasicBlock =
    BasicBlock(structure IntMap	      = IntBinaryMap
	       structure IntSet	      = IntSet
	       structure MLRISCPseudo = Pseudo
	       structure MLTreeExtra  = MLTreeExtra)

  structure IntegerDataFlow =
    IntegerDataFlow(structure IntSet	  = IntSet
		    structure MLTreeExtra = MLTreeExtra)

  structure IntegerLiveness =
    IntegerLiveness(structure BasicBlock      = BasicBlock
		    structure IntegerDataFlow = IntegerDataFlow
		    structure IntSet	      = IntSet
		    structure MLTreeExtra     = MLTreeExtra)

  structure SpillReload = SpillReload(structure MLTreeExtra = MLTreeExtra)

  structure EmitRtlMLRISC =
    EmitRtlMLRISC(structure BasicBlock		= BasicBlock
		  structure CallConventionBasis = CallConventionBasis
		  structure Cells		= Alpha32Cells
		  structure ExternalConvention	= ExternalConvention
		  structure FloatAllocation	= FloatAllocation
		  structure FloatConvention	= Float
		  structure IntegerAllocation	= IntegerAllocation
		  structure IntegerConvention	= Integer
		  structure IntegerLiveness	= IntegerLiveness
		  structure IntSet		= IntSet
		  structure MLRISCConstant	= Constant
		  structure MLRISCPseudo	= Pseudo
		  structure MLRISCRegion        = Region
		  structure MLTreeComp		= MLTreeComp
		  structure MLTreeExtra		= MLTreeExtra
		  structure RegisterMap		= RegisterMap
		  structure RegisterSpillMap	= RegisterSpillMap
		  structure RegisterTraceMap	= RegisterTraceMap
		  structure Rtl			= Rtl
		  structure SpillReload		= SpillReload
		  structure StackFrame		= StackFrame
		  structure TraceTable		= TraceTable)

  (* -- translation functions (adapted from linkalpha.sml) ----------------- *)

  val asm_suffix = ".alpha.s"

  fun comp(asmfile, rtlmod) = 
	let
	  val stream = TextIO.openOut asmfile
	in
	  AsmStream.asmOutStream := stream;
	  EmitRtlMLRISC.emitModule rtlmod;
	  TextIO.closeOut stream;
	  print "Generation of assembly files complete\n";
	  asmfile
	end

  fun link(srcfile, labels) = 
	let
	  val asmfile = srcfile^asm_suffix
	  val stream  = TextIO.openAppend asmfile
	in
	  AsmStream.asmOutStream := stream;
	  EmitRtlMLRISC.emitEntryTable labels;
	  TextIO.closeOut stream;
	  ()
	end

  fun mk_link_file(asmfile, labels) = 
	let
	  val stream = TextIO.openOut asmfile
	in
	  AsmStream.asmOutStream := stream;
	  EmitRtlMLRISC.emitEntryTable labels;
	  TextIO.closeOut stream;
	  ()
	end

  fun compiles filenames = 
      let val rtlmods = Linkrtl.compiles filenames
	  fun doit (filename,rtlmod) = let val Rtl.MODULE{main,...} = rtlmod
				       in  (comp(filename ^ asm_suffix,rtlmod),main)
				       end
      in  Listops.map2 doit (filenames,rtlmods)
      end
  fun compile filename = hd(compiles [filename])

  fun rtl_to_alpha (filename, rtlmod) : string * Rtl.local_label =
      let val Rtl.MODULE{main,...} = rtlmod
      in (comp(filename ^ ".s",rtlmod), main)
      end

  fun test filename = 
      let val rtlmod = Linkrtl.test filename
	  val Rtl.MODULE{main,...} = rtlmod
      in  (comp(filename ^ asm_suffix,rtlmod),main)
      end

  val cached_prelude = ref (NONE : (string * Rtl.local_label) option)
  fun compile_prelude (use_cache,filename) = 
      case (use_cache, !cached_prelude) of
	  (true, SOME mlabel) => mlabel
	| _ => let val rtlmod = Linkrtl.compile_prelude(use_cache,filename)
		   val Rtl.MODULE{main=label,...} = rtlmod
		   val mlabel = (comp(filename ^ asm_suffix,rtlmod),label)
		   val _ = cached_prelude := SOME mlabel
	       in  mlabel
	       end

end

