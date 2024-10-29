module lang::orc::ast::Orc
extend lang::orc::ast::Expressions;

data Orc 
     = \module(ModuleId name, list[Import] importList, list[Statement] statements)
;

data Import = \import(ModuleId name);


data Statement = 
   actionDefinition(ActionType actionType,list[Property] ptList)
;

data ActionType = 
    shell()
    | ddl()
    | sqoop()
    | kill()
    | transform()
;

data Property = 
    attr(PropId propId,ExprOrVariable exp)
    | properties(str eid, ExprOrVariable e)
;

data PropId = 
    name()
    | file()
    | action()
    | configFile()
    | command()
    | message()
    | success()
    | onError()
    | view() 
;
    
data Statement = 
    dataflow(str dataflowId, list[DataFlowProp] dataflowPropList, list[DagNode] dags )
;

data DataFlowProp = 
    error(ExprOrVariable e)
    | startTime(ExprOrVariable e)
    | endTime(ExprOrVariable e)
    | frequency(ExprOrVariable e)
    | timeZone(ExprOrVariable e)
    | props(list[Prop] properties)
;

data DagNode = 
    actionId(str nodeName)
    | defAction(ActionType actionType,list[Property] ptList)
    | parallelNode(list[DagNode] nodeList)
    | \case(list[WhenClause] whenList, DagNode def)
;

data WhenClause = 
   when(ExprOrVariable e,DagNode dag)
;

data Expr = 
   idExp(list[str] qid)
;

data ExprOrVariable 
    = exp(Expr exp)
    | variable(Variable var)
    ;

data Variable 
    = variable(str varId, list[ModuleId] pathOpt)
    | simpleId(str simpleId)
    | refId(str name, list[str] nameList)
;

data Prop =
   prop(Expr sc, ExprOrVariable e)
;


data ModuleId =  
    moduleId(list[str] name)
;
