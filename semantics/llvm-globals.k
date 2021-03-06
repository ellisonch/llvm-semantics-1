//
requires "llvm-syntax.k"
requires "llvm-abstractsyntax.k"
requires "llvm-settings.k"
requires "llvm-helpers.k"
requires "llvm-standard-library-syntax.k"
requires "llvm-syscalls-syntax.k"
requires "llvm-configuration.k"
requires "llvm-preprocessing.k"
requires "llvm-normalizing.k"
requires "llvm-declarations.k"

module LLVM-GLOBALS
    imports LLVM-SYNTAX
    imports LLVM-ABSTRACTSYNTAX
    imports LLVM-SETTINGS
    imports LLVM-HELPERS
    imports LLVM-STANDARD-LIBRARY-SYNTAX
    imports LLVM-SYSCALLS-SYNTAX
    imports LLVM-CONFIGURATION
    imports LLVM-PREPROCESSING
    imports LLVM-NORMALIZING
    imports LLVM-DECLARATIONS

    //deal with constant expr
    rule <k> blockAddAST(name(globalVar, X:String), name(localVar, Y:String))
        => loc(FunCount, blockAddressType, value(FunCount, FunCount),heap,
           blockAddVal(name(globalVar, X:String),name(localVar, Y:String)), none)  ...</k>
        <nextBase> FunCount:Int => FunCount +Int numBytesBlockAddress </nextBase>

    //for the pointer type of global variable.

    rule <k> globalVariable(X:SymbolicValueRef, L:Set,
                      Ty:KResult, Init:K, Ad:Int, Al:Int) => .K ...</k>
         <globalTypes> M:Map => M[X <- flagType(L, pointerTypeValue(Ty, Ad))] </globalTypes> 
         <tempGlobalVars> TL:List => insertPostInit(postInit(L,
                                    Ty, X, Init, Ad, Al), TL) </tempGlobalVars>
         requires isUnnamed(L) andBool notBool X in keys(M)
                   andBool Init =/=K skipValue

    rule <k> globalVariable(X:SymbolicValueRef, L:Set,
                      Ty:KResult, Init:K, Ad:Int, Al:Int) ~> K:K => .K </k>
         <globalTypes> M:Map </globalTypes> 
         <output>... .List => ListItem("error: redefinition of the global variable") </output>
         requires X in keys(M) andBool Init =/=K skipValue

    rule <k> globalVariable(X:SymbolicValueRef, L:Set,
                      Ty:KResult, Init:K, Ad:Int, Al:Int) =>
              preInit(L, Ty, X, alloca(Ty, 1, Ad, Al, true), Init, Ad, Al) ...</k>
         <globalTypes> M:Map => M[X <- flagType(L, pointerTypeValue(Ty, Ad))] </globalTypes> 
         requires notBool isUnnamed(L) andBool isThreadLocal(L)
                andBool constant in L andBool notBool X in keys(M)
                andBool Init =/=K skipValue

    rule <k> globalVariable(X:SymbolicValueRef, L:Set,
                      Ty:KResult, Init:K, Ad:Int, Al:Int) =>
              preInit(L, Ty, X, alloca(Ty, 1, Ad, Al, false), Init, Ad, Al) ...</k>
         <globalTypes> M:Map => M[X <- flagType(L, pointerTypeValue(Ty, Ad))] </globalTypes> 
         requires notBool isUnnamed(L) andBool isThreadLocal(L)
                andBool notBool (constant in L) andBool notBool X in keys(M)

    rule <k> globalVariable(X:SymbolicValueRef, L:Set,
                      Ty:KResult, Init:K, Ad:Int, Al:Int) =>
              preInit(L, Ty, X, globalAlloca(Ty, 1, Ad, Al, true), Init, Ad, Al) ...</k>
         <globalTypes> M:Map => M[X <- flagType(L, pointerTypeValue(Ty, Ad))] </globalTypes> 
         requires notBool isUnnamed(L) andBool notBool isThreadLocal(L)
                andBool constant in L andBool notBool X in keys(M)
                andBool Init =/=K skipValue

    rule globalVariable(X:SymbolicValueRef, L:Set,
                      Ty:KResult, skipValue, Ad:Int, Al:Int) => .K

    rule <k> globalVariable(X:SymbolicValueRef, L:Set,
                      Ty:KResult, Init:K, Ad:Int, Al:Int) =>
              preInit(L, Ty, X, globalAlloca(Ty, 1, Ad, Al, false), Init, Ad, Al) ...</k>
         <globalTypes> M:Map => M[X <- flagType(L, pointerTypeValue(Ty, Ad))] </globalTypes> 
         requires notBool isUnnamed(L) andBool notBool isThreadLocal(L)
                andBool notBool (constant in L) andBool notBool X in keys(M)
                   andBool Init =/=K skipValue

    rule <k> preInit(L:Set, Ty:KResult, X:SymbolicValueRef,
                      Loc:Loc, Init:K, Ad:Int, Al:Int) => .K ...</k>
        <savedGlobals>... .K => preStaticStore(Ty, typeCheckExpr(Ty, Init),
                       pointerTypeValue(Ty, Ad), Loc, Al) </savedGlobals>
         <globalRegisters> GM => GM[X <- Loc] </globalRegisters>
         requires notBool isExternal(L)

    rule <k> preInit(L:Set, Ty:KResult, X:SymbolicValueRef,
                      Loc:Loc, Init:K, Ad:Int, Al:Int) => .K ...</k>
        <savedGlobals>... .K => staticStore(Ty, guessExternal,
                             pointerTypeValue(Ty, Ad), Loc, Al) </savedGlobals>
         <globalRegisters> GM => GM[X <- Loc] </globalRegisters>
         requires isExternal(L)

    //after checking for unnamed global
    rule <k> postPreStaticStore(L:Set, Ty:KResult, X:SymbolicValueRef,
                      Loc:Loc, Init:K, Ad:Int, Al:Int) => .K ...</k>
         <globalRegisters> GM => GM[X <- Loc] </globalRegisters>
         <savedGlobals>... .K => preStaticStore(Ty, typeCheckExpr(Ty, Init),
                       pointerTypeValue(Ty, Ad), Loc, Al) </savedGlobals>
         requires notBool isExternal(L)

    rule <k> postPreStaticStore(L:Set, Ty:KResult, X:SymbolicValueRef,
                      Loc:Loc, Init:K, Ad:Int, Al:Int) => .K ...</k>
         <globalRegisters> GM => GM[X <- Loc] </globalRegisters>
         <savedGlobals>... .K => staticStore(Ty, guessExternal,
                             pointerTypeValue(Ty, Ad), Loc, Al) </savedGlobals>
         requires isExternal(L)

    //if unname not exist similar content item
    rule postInitAux(Mods:Set, .List, Ty:KResult, X:K, Init:K, Ad:Int, Al:Int)
           => postPreStaticStore(Mods, Ty, X,
                      alloca(Ty, sizeof(Ty), Ad, Al, true), Init, Ad, Al)
         requires isThreadLocal(Mods) andBool constant in Mods

    rule postInitAux(Mods:Set, .List,Ty:KResult, X:K, Init:K, Ad:Int, Al:Int)
           => postPreStaticStore(Mods, Ty, X,
                      alloca(Ty, sizeof(Ty), Ad, Al, false), Init, Ad, Al)
         requires isThreadLocal(Mods) andBool notBool constant in Mods

    rule postInitAux(Mods:Set, .List,Ty:KResult, X:K, Init:K, Ad:Int, Al:Int)
           => postPreStaticStore(Mods, Ty, X,
                          globalAlloca(Ty, sizeof(Ty), Ad, Al, true), Init, Ad, Al)
         requires notBool isThreadLocal(Mods) andBool constant in Mods

    rule postInitAux(Mods:Set, .List,Ty:KResult, X:K, Init:K, Ad:Int, Al:Int)
           => postPreStaticStore(Mods, Ty, X,
                         globalAlloca(Ty, sizeof(Ty), Ad, Al, false), Init, Ad, Al)
         requires notBool isThreadLocal(Mods) andBool notBool constant in Mods

    rule postInitAux(Mods:Set, ListItem(aLoc(Ba:Int,
                          pointerTypeValue(Ty, Ad), R:K)) L:List,
                   Ty:KResult, X:K, Init:K, Ad':Int, Al:Int)
           => postInitAux(Mods:Set, L:List,
                   Ty:KResult, X:K, Init:K, Ad':Int, Al:Int)
         requires Ad =/=K Ad'

    rule <k> postInitAux(Mods:Set, ListItem(aLoc(Ba:Int,
                          pointerTypeValue(Ty, Ad), R:K)) L:List,
                   Ty:KResult, X:K, Init:K, Ad:Int, Al:Int)
            => postInitNext(Mods, findVarByLocs(aLoc(Ba,
                       pointerTypeValue(Ty, Ad), R:K), M, .K, .K),
                          L, Ty, X, Init, Ad, Al) ...</k>
         <globalRegisters> M:Map </globalRegisters>

    rule <k> postInitNext(Mods:Set, badValue, L:List, Ty:K, X:K, Init:K,
              Ad:Int, Al:Int) ~> K:K => .K </k>
        <output>... .List => ListItem("error: impossible to happen.") </output>

    rule <k> postInitNext(Mods:Set, mapEntry(Y:K, Loc:K), L:List, Ty:KResult,
              X:K, Init:K, Ad:Int, Al:Int) => 
             postInitAux(Mods, L, Ty, X, Init, Ad, Al) ...</k>
         <globalTypes>... Y |-> flagType(Mods':Set, T:K) ...</globalTypes>
         requires (notBool (constant in Mods' andBool constant in Mods))
               andBool (notBool (global in Mods' andBool global in Mods))

    rule <k> postInitNext(Mods:Set, mapEntry(Y:K, Loc:K), L:List, Ty:KResult,
              X:K, Init:K, Ad:Int, Al:Int) => .K ...</k>
         <globalTypes>... Y |-> flagType(Mods':Set, T:K) ...</globalTypes>
         <globalRegisters> M:Map => M[X <- Loc] </globalRegisters>
         requires (constant in Mods' andBool constant in Mods)
               orBool (global in Mods' andBool global in Mods)

    rule <k> postInit(L:Set, Ty:K, X:K, Init:K, Ad:Int, Al:Int)
                => postInitAux(L, findItemsInMap(value(Ty, Init), M, .K, .K),
                     Ty, X, Init, Ad, Al) ...</k>
         <registers> M:Map </registers>
         requires isThreadLocal(L)

    rule <k> postInit(L:Set, Ty:K, X:K, Init:K, Ad:Int, Al:Int)
                => postInitAux(L, findItemsInMap(value(Ty, Init), M, .K, .K),
                     Ty, X, Init, Ad, Al) ...</k>
         <cbd> M:Map </cbd>
         requires notBool isThreadLocal(L)

    rule dealWithUnnamed(.List) => .K
    rule dealWithUnnamed(ListItem(A:K) L:List) => A ~> dealWithUnnamed(L)

    rule <k> dealWithUnnamed => dealWithUnnamed(L) ...</k>
         <tempGlobalVars> L:List </tempGlobalVars>

    //initialize all lib functions.
    rule <k> initGlobals => 
                   initBuiltins(val(typeOperand(
               'functionType(i(32),, 'functionType(i(32),, ('argListUnit(.KList)))
                     ('addrEmpty(.KList)) * .ParamAttrs, i(32) .ParamAttrs,
                    i(8) ('addrEmpty(.KList)) * ('addrEmpty(.KList)) * .ParamAttrs,
            'functionType(i(32),, i(32) .ParamAttrs, i(8) ('addrEmpty(.KList))*
                              ('addrEmpty(.KList))* .ParamAttrs, i(8) ('addrEmpty(.KList))*
                        ('addrEmpty(.KList))* .ParamAttrs) ('addrEmpty(.KList)) * .ParamAttrs,
           'functionType(void,, 'argListUnit(.KList)) ('addrEmpty(.KList)) * .ParamAttrs,
           'functionType(void,, 'argListUnit(.KList)) ('addrEmpty(.KList)) * .ParamAttrs),
                     name(globalVar, "__libc_start_main_0"))),
        val(typeOperand('functionType(i(32),, 
         'functionType(i(32),, i(32) .ParamAttrs, i(8) ('addrEmpty(.KList)) *
           ('addrEmpty(.KList)) * .ParamAttrs) ('addrEmpty(.KList))* .ParamAttrs,
             i(32) .ParamAttrs, i(8) ('addrEmpty(.KList))* ('addrEmpty(.KList))* .ParamAttrs,
          'functionType(i(32),, i(32) .ParamAttrs, i(8) ('addrEmpty(.KList))*
                ('addrEmpty(.KList))* .ParamAttrs, i(8) ('addrEmpty(.KList))*
                         ('addrEmpty(.KList))* .ParamAttrs) ('addrEmpty(.KList))* .ParamAttrs,
         'functionType(void,, 'argListUnit(.KList)) ('addrEmpty(.KList))* .ParamAttrs,
        'functionType(void,, 'argListUnit(.KList)) ('addrEmpty(.KList))* .ParamAttrs),
                                  name(globalVar, "__libc_start_main_2"))),
         val(typeOperand('functionType(void,, 'argTypeTwo(i(32),, .ParamAttrs))
                       , name(globalVar, "exit"))),
         val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs,
           i(8) ('addrEmpty(.KList)) * .ParamAttrs,
              i(32) .ParamAttrs, i(1) .ParamAttrs), name(globalVar, "llvm.memcpy.p0i8.p0i8.i32"))),
         val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs,
           i(8) ('addrEmpty(.KList)) * .ParamAttrs,
              i(64) .ParamAttrs, i(1) .ParamAttrs), name(globalVar, "llvm.memcpy.p0i8.p0i8.i64"))),
         val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs,
           i(8) ('addrEmpty(.KList)) * .ParamAttrs,
              i(32) .ParamAttrs, i(1) .ParamAttrs), name(globalVar, "llvm.memmove.p0i8.p0i8.i32"))),
         val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs,
           i(8) ('addrEmpty(.KList)) * .ParamAttrs,
              i(64) .ParamAttrs, i(1) .ParamAttrs), name(globalVar, "llvm.memmove.p0i8.p0i8.i64"))),
        val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs,
             i(8) .ParamAttrs, i(32) .ParamAttrs, i(1) .ParamAttrs)
                ,name(globalVar, "llvm.memset.p0i8.i32"))),
        val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs,
             i(8) .ParamAttrs, i(64) .ParamAttrs, i(1) .ParamAttrs)
                ,name(globalVar, "llvm.memset.p0i8.i64"))),
      val(typeOperand('functionType(void,, i(64) .ParamAttrs, i(8) ('addrEmpty(.KList))* .ParamAttrs),
                      name(globalVar, "llvm.lifetime.start"))),
      val(typeOperand('functionType(void,, i(64) .ParamAttrs, i(8) ('addrEmpty(.KList))* .ParamAttrs),
               name(globalVar, "llvm.lifetime.end"))),
       val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs),
               name(globalVar, "llvm.va_start"))),
       val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs,
                 i(8) ('addrEmpty(.KList))* .ParamAttrs), name(globalVar, "llvm.va_copy"))),
        val(typeOperand('functionType(void,, i(8) ('addrEmpty(.KList))* .ParamAttrs),
                name(globalVar, "llvm.va_end"))),
        val(typeOperand('functionType(void,, 'argListUnit(.KList)),
                name(globalVar, "abort"))),
           val(typeOperand('functionType(i(64),,
                     i(64) .ParamAttrs, vaListType), name(globalVar, "__syscall"))),
            val(typeOperand('functionType(i(32),, i(8) ('addrEmpty(.KList))* .ParamAttrs,
              { i(32), i(32), i(8) ('addrEmpty(.KList))*,
                 i(8) ('addrEmpty(.KList))*, .TypeList } ('addrEmpty(.KList))* .ParamAttrs),
                name(globalVar, "vprintf"))),
            val(typeOperand('functionType(i(32),, i(8) ('addrEmpty(.KList))* .ParamAttrs,
                    vaListType), name(globalVar, "printf"))),
                val(typeOperand('functionType(i(8) ('addrEmpty(.KList))*,,
               'argTypeTwo(i(64),, .ParamAttrs)), name(globalVar, "malloc"))),
                val(typeOperand('functionType(i(8) ('addrEmpty(.KList))*,,
                i(64) .ParamAttrs, i(64) .ParamAttrs), name(globalVar, "calloc"))),
                val(typeOperand('functionType(void,,
               'argTypeTwo(i(8) ('addrEmpty(.KList))*,, .ParamAttrs)), name(globalVar, "free"))),
                val(typeOperand('functionType(i(8) ('addrEmpty(.KList))*,,
                 i(8) ('addrEmpty(.KList))* .ParamAttrs, i(64) .ParamAttrs),
                        name(globalVar, "realloc"))),
                val(typeOperand('functionType(i(8) ('addrEmpty(.KList))*,,
                 i(8) ('addrEmpty(.KList))* .ParamAttrs, i(64) .ParamAttrs),
                        name(globalVar, "realloc"))),
                val(typeOperand('functionType(i(32),,
                 i(64) ('addrEmpty(.KList))* .ParamAttrs,
                  { i(64), arrayType(48, i(8)), .TypeList } ('addrEmpty(.KList))* .ParamAttrs,
                 'functionType(i(8) ('addrEmpty(.KList))*,,
                       i(8) ('addrEmpty(.KList))*) ('addrEmpty(.KList))* .ParamAttrs,
                   i(8) ('addrEmpty(.KList))* .ParamAttrs), name(globalVar, "pthread_create"))),
                val(typeOperand('functionType(i(32),, i(64) .ParamAttrs,
                  i(8) ('addrEmpty(.KList))* ('addrEmpty(.KList))* .ParamAttrs),
                    name(globalVar, "pthread_join"))),
                val(typeOperand('functionType(i(32),, 'argTypeTwo(i(64),, .ParamAttrs)),
                    name(globalVar, "pthread_detach"))),
                val(typeOperand('functionType(void,,
                      'argTypeTwo(i(8) ('addrEmpty(.KList))*,, .ParamAttrs)),
                    name(globalVar, "pthread_exit"))),
                val(typeOperand('functionType(i(32),, 'argTypeTwo(i(64),, .ParamAttrs)),
                    name(globalVar, "pthread_cancel"))),
                val(typeOperand('functionType(i(32),,
                     { arrayType(40, i(8)) } ('addrEmpty(.KList))* .ParamAttrs,
                     { arrayType(4, i(8)) } ('addrEmpty(.KList))* .ParamAttrs),
                    name(globalVar, "pthread_mutex_init"))),
                val(typeOperand('functionType(i(32),, 'argTypeTwo(
                        { arrayType(40, i(8)) } ('addrEmpty(.KList))*,, .ParamAttrs)),
                    name(globalVar, "pthread_mutex_destroy"))),
                val(typeOperand('functionType(i(32),, 'argTypeTwo(
                        { arrayType(40, i(8)) } ('addrEmpty(.KList))*,, .ParamAttrs)),
                    name(globalVar, "pthread_mutex_lock"))),
                val(typeOperand('functionType(i(32),, 'argTypeTwo(
                        { arrayType(40, i(8)) } ('addrEmpty(.KList))*,, .ParamAttrs)),
                    name(globalVar, "pthread_mutex_trylock"))),
                val(typeOperand('functionType(i(32),, 'argTypeTwo(
                        { arrayType(40, i(8)) } ('addrEmpty(.KList))*,, .ParamAttrs)),
                    name(globalVar, "pthread_mutex_unlock"))), .ElemList)
                  ~> (K ~> staticSeqFence) ...</k>
        <savedGlobals> K:K => .K </savedGlobals>

    rule initGlobalTypes(.ElemList) => .K
    rule initGlobalTypes(val(A:K),Es:ElemList) => A ~> initGlobalTypes(Es)

    rule initBuiltins(.ElemList) => .K
    rule <k> initBuiltins(valValue(typeOperandResult(T:KResult,
           X:SymbolicValueRef)), Ls:ElemList => Ls) ...</k>
         <nextBase> FunCount:Int => FunCount +Int numBytesFunHeader </nextBase>
        <cbd> CM:Map => CM[aLoc(FunCount,pointerTypeValue(T,
                            defaultAddrSpace), heap) <- value(T, funptr(X))] </cbd>
         <globalRegisters> M:Map
             => M[X <- loc(FunCount,pointerTypeValue(T, defaultAddrSpace),
                    value(FunCount, FunCount), heap, none, none)] </globalRegisters>

    //initialize channels
    rule initialMemChannels(0) => .K
    rule <k> initialMemChannels(N:Int) => initialMemChannels(N -Int 1) ...</k>
         (.Bag => <memory>... <channelId> N -Int 1 </channelId>
                        <timeStamps> initTimeStamp(0,maxMemChannel) </timeStamps> ...</memory>)

endmodule
