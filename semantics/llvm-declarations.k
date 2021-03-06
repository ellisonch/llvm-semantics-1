//Liyi Li and Elsa Gunter 2020
//This file is a derivative of work by Charles Ellison and David Lazar
requires "llvm-syntax.k"
requires "llvm-abstractsyntax.k"
requires "llvm-settings.k"
requires "llvm-helpers.k"
requires "llvm-standard-library-syntax.k"
requires "llvm-syscalls-syntax.k"
requires "llvm-configuration.k"
requires "llvm-preprocessing.k"
requires "llvm-normalizing.k"

module LLVM-DECLARATIONS
    imports LLVM-SYNTAX
    imports LLVM-ABSTRACTSYNTAX
    imports LLVM-SETTINGS
    imports LLVM-HELPERS
    imports LLVM-STANDARD-LIBRARY-SYNTAX
    imports LLVM-SYSCALLS-SYNTAX
    imports LLVM-CONFIGURATION
    imports LLVM-PREPROCESSING
    imports LLVM-NORMALIZING

    // TODO: semantic design pattern: assignment rule
    rule
        <k> alias(Mod:K, X:SymbolicValueRef, K:KResult) => .K ...</k>
        <globalRegisters> Map:Map => Map[X <- K] </globalRegisters>

    // TODO KListToK module sections
    // TODO: semantic design pattern: multi-arity (want multiple pieces of data at the same time like key/value pairs) vs. variadic (when you don't need to do things at the same time)
    rule
        <k> theModule(Label:SymbolicValueRef, TargetLayout:K, TargetTriple:K, MetaVars:K
            , Typedefs:K, GlobalVars:K, Aliases:K, Functions:K)
            => MetaVars
            ~> (Typedefs
            ~> (GlobalVars
            ~> (dealWithUnnamed
            ~> (Aliases
            ~> (Functions
            ~> (initGlobals
            ~> nextCheckPoint))))))
        ...</k>
        <currModule> _ => Label </currModule>
        <modules>...
            <module>...
                <moduleName> Label </moduleName>
                <targetLayout> _ => TargetLayout </targetLayout>
                <targetTriple> _ => TargetTriple </targetTriple>
            ...</module>
        ...</modules>

    rule [typedef-assignment]:
        <k> typedef(X:LocalName, UnresolvedType:KResult) => .K ...</k>
        //<currentModifiers> _ => List(L) </currentModifiers> TODO not printing modifiers
        <currModule> Label:SymbolicValueRef </currModule>
        <moduleName> Label:SymbolicValueRef </moduleName>
        <typedefs> M:Map => M[X <- UnresolvedType] </typedefs>

    rule [typedef-lookup]:
        <k> 'namedType(X:LocalName) => UnresolvedType ...</k>
        <typedefs>... X |-> UnresolvedType:K ...</typedefs>

    // TODO: hack because hybrids don't seem to be working
    rule fields(L:ElemList) => L
    rule types(L:ElemList) => L
    //rule funptr(A:SymbolicValueRef) => A

    rule <k> nextCheckPoint => .K ...</k>
         <functionsToCheck> .List </functionsToCheck>

    rule <k> nextCheckPoint => A ...</k>
         <functionsToCheck> (ListItem(functionStore(Label:K, A:K)) => .List) L:List </functionsToCheck>
        <currFunction> _ => Label </currFunction>
         <currentProgPoint> ProgCount:Int => 0 </currentProgPoint>
        <instructionCounter> InstCount:Int => 1 </instructionCounter>
        <tempLabelUses> TL:Set => .Set </tempLabelUses>
        <tempExceptionUses> ETL:Set => .Set </tempExceptionUses>

    rule
        <k> functionDef(Attributes:Set,RetType:KResult, Label:SymbolicValueRef, Arguments:KResult, F:K)
            => .K ...</k>
        <functionsToCheck> Funs:List (.List => ListItem(functionStore(Label, setInitBlock(F) 
                ~> checkSingleAssignment(F) ~> nextCheckPoint))) </functionsToCheck>
        <cbd> CM:Map => CM[aLoc(FunCount, pointerTypeValue(functionTypeValue(RetType,
                                 getArgTypes(Arguments)), defaultAddrSpace),heap) <- value(
                   functionTypeValue(RetType, getArgTypes(Arguments)), funptr(Label))] </cbd>
        <globalRegisters> M:Map => M[Label <-
                loc(FunCount, pointerTypeValue(functionTypeValue(RetType,
                              getArgTypes(Arguments)), defaultAddrSpace),
                         value(FunCount, FunCount),heap, none, none)] </globalRegisters>
        <currModule> ModName:SymbolicValueRef </currModule>
        <nextBase> FunCount:Int => FunCount +Int
                         sizeOfFunArg(Arguments) +Int numBytesFunHeader </nextBase>
        (.Bag =>
            <function>...
                <funModuleName> ModName </funModuleName>
                <funModifiers> Attributes </funModifiers>
                <returnType> RetType </returnType>
                <formalParameters> arguments(Arguments) </formalParameters>
                <functionName> Label </functionName>
                <funPosition> FunCount </funPosition>
                <funSize> sizeOfFunArg(Arguments) +Int numBytesFunHeader </funSize>
            ...</function> )

    rule
        <k> functionDecl(Attributes:Set,RetType:KResult, Label:SymbolicValueRef, Arguments:KResult)
            => .K ...</k>
        <cbd> CM:Map => CM[aLoc(FunCount, pointerTypeValue(functionTypeValue(RetType,
                                 getArgTypes(Arguments)), defaultAddrSpace),heap) <- value(
                   functionTypeValue(RetType, getArgTypes(Arguments)), funptr(Label))] </cbd>
        <globalRegisters> M:Map => M[Label <-
             loc(FunCount, pointerTypeValue(functionTypeValue(RetType,
                  getArgTypes(Arguments)), defaultAddrSpace),
                        value(FunCount, FunCount),heap, none,none)] </globalRegisters>
        <nextBase> FunCount:Int => FunCount +Int numBytesFunHeader </nextBase>
        <currModule> ModName:SymbolicValueRef </currModule>
        (.Bag =>
            <function>...
                <funModuleName> ModName </funModuleName>
                <funModifiers> Attributes </funModifiers>
                <returnType> RetType </returnType>
                <formalParameters> arguments(Arguments) </formalParameters>
                <functionName> Label </functionName>
                <funPosition> FunCount </funPosition>
                <funSize> sizeOfFunArg(Arguments) +Int numBytesFunHeader </funSize>
            ...</function>
        )

    rule BB:BasicBlock BBL:BasicBlockList => BB ~> BBL

    //install the sequence point for each instruction.

    rule <k> seqPoint(N:Int, I:Int, A:K) => A ...</k>
         <currentProgPoint> N:Int => I </currentProgPoint>

    //rule for setting initial basic block of a given block
    rule <k> setInitBlock(I:InstructionList B:BBTerminatorInstruction) => .K ...</k>
        <currModule> ModName:SymbolicValueRef </currModule>
        <funModuleName> ModName </funModuleName>
        <currFunction> FunName:SymbolicValueRef </currFunction>
        <functionName> FunName </functionName>
         <localFunVarCounter> N:Int </localFunVarCounter>
        <initialBasicBlock> _ => name(localVar, Int2String(N)) </initialBasicBlock>

    rule <k> setInitBlock(L:LabelStringConstant
                     I:InstructionList B:BBTerminatorInstruction) => .K ...</k>
        <currModule> ModName:SymbolicValueRef </currModule>
        <funModuleName> ModName </funModuleName>
        <currFunction> FunName:SymbolicValueRef </currFunction>
        <functionName> FunName </functionName>
        <initialBasicBlock> _ => addNameToString(L) </initialBasicBlock>

    rule <k> setInitBlock(I:InstructionList B:BBTerminatorInstruction
                            BBL:BasicBlockList) => .K ...</k>
        <currModule> ModName:SymbolicValueRef </currModule>
        <funModuleName> ModName </funModuleName>
        <currFunction> FunName:SymbolicValueRef </currFunction>
        <functionName> FunName </functionName>
         <localFunVarCounter> N:Int </localFunVarCounter>
        <initialBasicBlock> _ => name(localVar, Int2String(N)) </initialBasicBlock>

    rule <k> setInitBlock(L:LabelStringConstant I:InstructionList
                  B:BBTerminatorInstruction BBL:BasicBlockList) => .K ...</k>
        <currModule> ModName:SymbolicValueRef </currModule>
        <funModuleName> ModName </funModuleName>
        <currFunction> FunName:SymbolicValueRef </currFunction>
        <functionName> FunName </functionName>
        <initialBasicBlock> _ => addNameToString(L) </initialBasicBlock>

    rule
        <k> startInitBlock(Label:K) =>
              blockExecution(basicBlockNum(Count, Label),
                  formInstList(1, .K, Body)) ...</k>
        <currBlock> Label':K => basicBlockNum(Count, Label) </currBlock>
        <blockCount> Count:Int => Count +Int 1 </blockCount>
        <specTree> M:Map => M[Count <-
                       runBlock(Count, Label, none,
                     formMemList(Count, formInstList(1, .K, Body), getCoreVaLog(VaLoc)),
                 getDefVarsInBody(.K, Body), .Set)] </specTree>
        <vaList> VaLoc:K </vaList>
        <currModule> ModName:SymbolicValueRef </currModule>
        <funModuleName> ModName </funModuleName>
        <functionName> FunName </functionName>
         <currFunction> FunName:SymbolicValueRef </currFunction>
        <basicBlocks>... Label |-> blockContent(Body:Map,
               _:Bool, _:Set, _:Set, InDefs:Set,
                 _:Set, OutDefs:Set, _:Set, _:Set) ...</basicBlocks>

endmodule
