//configuration of LLVM defines the program states of running LLVM programs
requires "llvm-syntax.k"
requires "llvm-abstractsyntax.k"
requires "llvm-settings.k"

module LLVM-CONFIGURATION
    imports LLVM-SYNTAX
    imports LLVM-ABSTRACTSYNTAX
    imports LLVM-SETTINGS

    configuration
        <T>//top level
            <brk> loc(startMemoryLoc, void,
              value(nullMemoryLoc,nullMemoryLoc),heap, none, none) </brk>
            //this is a cell holding brk pointer
            <cbd> .Map </cbd> //common data bus
            <threadStatus> .Map </threadStatus> //use for storing pthread status joinable info
            <waitJoinThreads> .Map </waitJoinThreads>
                //for detaching deadlock or see if two are joining with the same threads.
            <exBuffer> .List </exBuffer>
            //a cell to hold all to commit memory ops, simulating computer north bridge
            <matchPhisWithInEdges> .List </matchPhisWithInEdges>
            //a helper cell to store all phi edges that have not been type checked
            <instructionCounter> 0 </instructionCounter>
            //a counter cell to genearte free vars for instruction location num
            <tempGlobalVars> .List </tempGlobalVars> //use for store unnamed addr global vars
            <tempUses> .Set </tempUses> //set from use vars
            <tempLabelUses> .Set </tempLabelUses>
            <tempExceptionUses> .Set </tempExceptionUses>
            <tempLandingpads> .List </tempLandingpads>
            <tempResumes> .List </tempResumes>
            <tempBlockAddrChecks> .Set </tempBlockAddrChecks>
            <tempBlockMap> .Map </tempBlockMap> //set for store inst map for a block
            <functionsToCheck> .List </functionsToCheck>
            <mutexes>
              <mutexCount> 0 </mutexCount>
              <avaMutex> .Set </avaMutex> //all alive mutexes
              <mutex multiplicity="*">
                 <mutexId> 0 </mutexId>
                 <holdThread> .K </holdThread> //holding lock thread
              </mutex>
            </mutexes>
            <threads>
              <threadCount> 1 </threadCount>
              <thread multiplicity="*"> //thread cell
                <threadId> 0 </threadId> //thread id
                <memChannelId> 0 </memChannelId> //associated mem channel id
                                             //a thread only talks to one chanel
                //<buffer> .List </buffer> //thread execution buffer, items will be moved to exBuffer
                <k color="LightGreen"> initialMemChannels(maxMemChannel) ~> 
                               ($PGM:Module ~> callMain) </k>
                //main cell containing program code
                <tomasulo>
                    <toExecute> .K </toExecute>
                    <instQueue> instList(.List) </instQueue> //instruction queue
                    <cpu> .K </cpu> //central execution unit
                    <toCommit> memList(.K, .Set, .List, .List, .List, .List) </toCommit>
                    <readBack> readMap(.Map) </readBack>
                    <specTree> .Map </specTree> //speculative tree
                    <restChoice> .Map </restChoice>
                    <blockCount> 0 </blockCount> //model cpu: tomasulo
                </tomasulo>//simulating tomosulo execution model.
                <stack>
                   <stackInfo> .List </stackInfo>
                   <stackOpList> .List </stackOpList>
                   <nextStack> startMemoryLoc </nextStack>
                    <stackList> .List </stackList>
                   <stackMap> .Map </stackMap>
                </stack>
                <callStack color="Goldenrod"> .List </callStack>
                //stack for function calls
                <control color="LightGoldenrod">
                    <currBlock color="Orchid"> basicBlockNum(0, name(localVar, "Initial")) </currBlock>
                    //the current executing basic block
                    <currModule color="Orchid"> name(globalVar, "main") </currModule>
                    //current module
                    <currFunction color="Orchid"> name(globalVar, "Initial") </currFunction>
                    //current function that is being executed
                    <vaList> .K </vaList>//a cell storing variable argument list info
                    <expResume> .K </expResume>
                    <registers color="teal"> .Map </registers>
                    //registers (infinite) for a thread
                    <specRegisters color="teal"> .Map </specRegisters>
                    <memRegisters color="teal"> .Map </memRegisters>
                    //registers to hold unordered speculative values.
                    <currentProgPoint> 0 </currentProgPoint>
                    //current program point (inst num), may not need
                    <currentModifiers color="Orchid"> .Set </currentModifiers>
                    //the modifiers (attributes) for the current functions
                    <currentMetadatas color="Orchid"> .ElemList </currentMetadatas>
                    //the metadatas for the current function
                    <localMemory> .Set </localMemory>
                    //local memory (stack) 
                </control> //control panel for function and basic blocks
              </thread>
            </threads>
            <memorys>
              <memory multiplicity="*" color="teal"> //main memory, heap
                <channelId> 0 </channelId>
                <objects> .Set </objects>
                <timeStamps> .Map </timeStamps> //vector time stamps for each channel
                <channelOps> .List </channelOps>
                <ackMap> .Map </ackMap>
                <memOpList> .List </memOpList>
                //a cell to hold the current all memory locations
                <byteMap> .Map </byteMap>
              </memory>
                <memoryList> .List </memoryList> //all allocaed mem ranges
                <nextBase color="gray"> startMemoryLoc </nextBase>
                //this is a cell to calculate the next memory start location.
                <memoryRange> value(startMemoryLoc, startMemoryLoc) </memoryRange>
            </memorys>
            // auxiliary cells:
            <output stream="stdout" color="DodgerBlue"> .List </output>
             //output channel, like standard output
            <modules color="teal"> //static information about a module
                <module multiplicity="*" color="LightSkyBlue">
                    <moduleName color="orange"> name(globalVar, "") </moduleName>
                    <targetLayout> "" </targetLayout>
                    <targetTriple> "" </targetTriple>
                    <typedefs> .Map </typedefs> //type definition
                    <savedGlobals> .K </savedGlobals>
                    <globalFunVarCounter> 0 </globalFunVarCounter>
                    <attributeGroups> .Map </attributeGroups>
                    <metaGroups> .Map </metaGroups>
                    <globalTypes color="teal"> .Map </globalTypes>
                    <globalRegisters color="teal"> .Map </globalRegisters>
                    <typeInfos color="teal">
                        <typeInfo multiplicity="*" color="LightSkyBlue">
                            <typeName color="orange"> name(globalVar, "") </typeName>
                            <offsets> .Map </offsets>
                        </typeInfo>
                    </typeInfos> //type information for the module (global types, might delete)
                </module>
            </modules>
            <functions color="teal"> //static info for functions in a module
                 <builtinFunctions> .Set </builtinFunctions> //builtin functions, might not need
                 <function multiplicity="*" color="LightSkyBlue">
                       <funModuleName color="orange"> name(globalVar, "") </funModuleName>
                        //the module the function is belong to.
                       <functionName color="orange"> name(globalVar, "") </functionName>
                       //name of the function
                       <funSize> 0 </funSize>
                       <funPosition> 0 </funPosition>
                       <funModifiers> .Set </funModifiers> //function attributes
                       <varTypes color="teal"> .Map </varTypes> //variable types in a function
                       <returnType> .K </returnType> //return type of the function
                       <formalParameters> .K </formalParameters> //parameters of a function
                       <basicBlocks> .Map </basicBlocks> //basic blocks
                       <localFunVarCounter> 0 </localFunVarCounter> //a counter to generate free vars
                       <initialBasicBlock> .K </initialBasicBlock> //the entry block
                       <labels> .Set </labels> //function labels, might delete
                 </function>
            </functions>
        </T>
        <result multiplicity="?" color="DodgerBlue">
            <returnValue> -1 </returnValue>
        </result> //result of a computation, might delete

endmodule
