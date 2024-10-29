module lang::orc::prettyprint::Orc

import lang::orc::ast::Orc;
import List;
extend lang::orc::prettyprint::Expressions;



public str toString(\module(ModuleId name, list[Statement] statements))="module <toString(name)>"+
      intercalate("",["\n<toString(stat)>"|stat<-statements])
     ;

public str toString(moduleId(list[str] mid))= intercalate(".",[id|id<-mid]);
public str toString(actionDefinition(ActionType actionType,list[Property] ptList))="define action:"+
    "\n\t <toString(actionType)>:"
    + "\n\t <intercalate("\n\t",[toString(prop)|prop<-ptList])>"
    ;

public str toString(zoneAction(str zn, lrel[PropId pid,ExprOrVariable eov] props))="define action:"+
    "\n\t zone:"+"\n\t name=<zn>"
    + "\n\t <intercalate("\n\t",["<toString(prop.pid)>=<toString(prop.eov)>"|prop<-props])>"
    ;

public str toString(ActionType aType){
    switch(aType){
      case shell():return "shell";
      case sqoop(): return "sqoop";
      case kill(): return "kill";
      case transform(): return "transform";
      default :throw "";
    }
}
     
public str toString(variable(simpleId(str id)))=id;

public str toString(attr(PropId propId,ExprOrVariable exp)) = "<toString(propId)> = <toString(exp)>";

public str toString(properties(str eid, ExprOrVariable e))="properties \n\t <eid> = <toString(e)>"
    ;

public str toString(PropId pid) {
       switch(pid){
       case name():return"name";
       case file(): return "file";
       case action(): return "action";
       case configFile(): return "configFile";
       case command(): return "command";
       case message(): return "message";
       case success(): return "onSuccess";
       case onError(): return "onActionError";
       case view(): return "view";
       default: throw ""; 
       } 
    
    } 
    
public str toString(dataflow(str flowId, list[DataFlowProp] dataflowPropList, list[DagNode] dags ))="dataflow <flowId>:"+
        "\n\t <intercalate("\n",[toString(prop)|prop<-dataflowPropList])>"
        +"\n dag:"
        + "\n\t <intercalate("\n",[toString(prop)|prop<-dags])>"
    ;

public str toString(DataFlowProp dfp){
    switch(dfp){
        case error(ExprOrVariable e): return "onError = <toString(e)>";
        // case startTime(ExprOrVariable e): return "startTime = <toString(e)>";
        // case endTime(ExprOrVariable e):  return "endTime = <toString(e)>";
        // case frequency(ExprOrVariable e): return "frequency = <toString(e)>";
        // case timeZone(ExprOrVariable e):return "timeZone = <toString(e)>";
        // case props(list[Prop] properties): return "properties:"+
        // "\n\t<intercalate("\n",["<toString(p)>"|p<-properties])>"
        //  ;
       default: throw "";
    }
} 
    
public str toString(prop(str sc, ExprOrVariable e))= "<sc>=<toString(e)>";
public str toString(DagNode dn){
    switch(dn){
        case actionId(str nodeName):return nodeName;
        case defAction(ActionType actionType,list[Property] ptList):return "<toString(actionType)>:"
    + "\n\t <intercalate("\n",[toString(prop)|prop<-ptList])>";
      
        case parallelNode(list[DagNode] nodeList):return "parallel:"+
          "\n\t <intercalate("\n&&\n",[toString(prop)|prop<-nodeList])>";
       
       case defZone(str zn,lrel[PropId pid,ExprOrVariable eov] props): return  "\n\t zone:"+"\n\t name=<zn>"
    + "\n\t <intercalate("\n\t",["<toString(prop.pid)>=<toString(prop.eov)>"|prop<-props])>"
    ;
        case \case(list[WhenClause] whenList, DagNode def): return "case"+
             "\n\t <intercalate("\n",[toString(prop)|prop<-whenList])>"+
             "\ndefault:<toString(def)>";

        default: throw "";
}
}
public str toString(when(ExprOrVariable e,DagNode dag))= "when <toString(e)> -\>\n\t"+
     toString(dag)
    ;

public str toString(idExp(list[str] qid))= intercalate(".",[id|id<-qid])
    ;

public str toString(exp(Expr exp))=toString(exp);
public str toString(variable(variable(str varId, list[ModuleId]path)))= "${<varId>}<intercalate("",["#<toString(p)>"|p<-path])>"
    ;