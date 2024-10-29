module lang::orc::translations::translateAirflow::Workflow
import lang::orc::ast::Workflow;

extend lang::orc::translations::translateAirflow::Expressions;


public Statement toAirflow(workflow(WorkflowBuilder workflowBldr))=toAirflow(workflowBldr);

  
public Statement toAirflow(workflowBuilder(list[WorkflowStep] workflowStep)){
    starter= workflowStep[0];
    return expr((toAirflow(starter)|buildWorkStep(it,step)|step<-workflowStep,startWith(_)!:=step));
}
public Expression toAirflow(startWith(str regularId))=name(regularId,store());  
Expression buildWorkStep(Expression e,WorkflowStep wfs){
    switch(wfs){
      case then(str regularId): return rshift(e,name(regularId,store()));
      case end(str regularId): return rshift(e,name(regularId,store()));
      case \join(str regularId): return \list([e,name(regularId,store())],store());
     default: throw "<wfs> error"; 
    }
}
    
