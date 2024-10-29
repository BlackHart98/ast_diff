module lang::oozie::translations::translate2orc::TranslateWorkflow

import lang::orc::ast::Orc;
import lang::orc::ast::Task;
import lang::oozie::grammar::Oozie;
import List;
import String;
import lang::oozie::translations::translate2orc::Helpers;
import IO;

public OrcStart toOrc(document(element(_, _, list[Node] children)), str schedulerId){
  actions = [x | x <- children, element(_, "action", _) := x || attribute(_,_,_) := x];

  list[Declaration] nlist = [(toOrc(child, schedulerId)) | child <- actions];

  list[Node] elem = [];
  // Get action elements
  actions_dag = [x | x <- children, element(_, "action", _) := x ];

  last_action = lastIndexOf(actions_dag, actions_dag[-1]);

  // get kill and end element
  nd_elem = [x | x <- children, element(_, "kill", _) := x || element(_, "end", _) := x];

  // remove unneeded action and add all to elem
  if(size(actions_dag) > 1){
    elem += remove(actions_dag, last_action) + nd_elem ;
  } else {
    elem += actions_dag + nd_elem;
  }
  nlist += toOrc(elem);

  return program(declarations(nlist));
}

public Declaration toOrc(Node nd, str schedulerId){
  switch(nd){
    case element(_, _, list[Node] children):{
      taskBd = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];

      // Get action name
      attr = [x | x <- children, element(_, _, _) !:= x && charData(_) !:= x ];
      
      return tasks(toOrc(taskBd, attr[0], schedulerId));
    }
    case attribute(_,_, list[OozieNode] name): {
      mod_name = validIdent(serializeExp(name));
      return \module(mod_name);
    }
    default: throw "unhandled <nd>";
  }
}


public Task toOrc(list[Node] nds, attribute(_, _,list[OozieNode] actionName), str schedulerId){
  name = validIdent(serializeExp(actionName));
  sch_ref = validIdent(schedulerId);
  for(bd <- nds){
    switch(bd){
      case element(_,"hive",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, hiveTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"pig",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, pigTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"java",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, javaTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"map-reduce",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, mapReduceTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"email",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, emailTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"fs",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, fsTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"sqoop",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, scoopTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"spark",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, sparkTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"sub-workflow",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, subWorkflowTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      case element(_,"shell",children):{
        taskDc = [x | x <- children, attribute(_, _, _) !:= x && charData(_) !:= x ];
        return (taskDef(name, shellTaskDef([toOrcDesc(x) | x <- taskDc]), schedulerRef(sch_ref)));
      }
      default: throw "unhandled <bd>";
    }
  }
  return taskDef(_, _, _);
}



public TaskDesc toOrcDesc(nds:element(_,_,children)){
  actions = [y | x <- children, charData(y) := x];
  name = (size(actions) > 0) ? serializeExp(actions[0]) : "undefined";

  switch(nds){
    case element(_,"task",_): return taskRef("\"<name>\"");
    case element(_,"job-tracker",_): return jobTracker("\"<name>\"");
    case element(_,"name-node",_): return nameNode("\"<name>\"");
    case element(_,"command",_): return nameNode("\"<name>\"");
    case element(_,"script",subchild):{
       script_data = [z | x <- subchild, charData(z) := x];
       val = (split("#", serializeExp(script_data[0])));

       script_text= replaceAll(replaceAll(val[0], "${nameNode}/user/${userName}/${oozieRoot}", "."), "hql", "ptl");
       return script("\"<script_text>\"");
       }

    default: throw "unhandled <nds>";
  }
}







// DAG 

public OrcStart toOrcDAG(document(element(_, _, list[Node] children))){
  list[Node] elem = [];
  // Get action elements
  actions = [x | x <- children, element(_, "action", _) := x ];

  last_action = lastIndexOf(actions, actions[-1]);

  // get kill and end element
  nd_elem = [x | x <- children, element(_, "kill", _) := x || element(_, "end", _) := x];

  // remove unneeded action and add all to elem
  if(size(actions) > 1){
    elem += remove(actions, last_action) + nd_elem ;
  } else {
    elem += actions + nd_elem;
  }
  
  return program(declarations([(toOrc(elem))]));
}


public Declaration toOrc(list[Node] nds){
  list[Node] required_nd = [];

  // Get first action name and add to list
  if(element(_,"action",children) := nds[0]){
    attr = [x | x <- children, element(_, _, _) !:= x && charData(_) !:= x && element(_,"ok",_) !:= x && element(_,"error",_) !:= x ];
    required_nd += attr;
  }

  for(c <- nds){
    switch(c){
      case element(_,"action",children): {

        // Filter charData
        children = [x|x <- children, charData(_) !:= x];

        ok = [x | x <- children, element(_,"ok",_) := x ];
        error = [x | x <- children, element(_,"error",_) := x ];

        required_nd += error + ok;
      }
      case element(name,"kill",children): {
        required_nd += element(name,"kill",children);
      }
      case element(name,"end",children): {
        required_nd += element(name,"end",children);
      }
      default: throw "unhandled <c>";
    }
  }
  return workflow(toOrcBldr(required_nd));
}

public WorkflowBuilder toOrcBldr(list[Node] nds){
  return workflowBuilder([toOrcStep(nd) | nd <- nds]);
}


public WorkflowStep toOrcStep(Node nd){
  switch(nd){
    case attribute(_,_,list[OozieNode] name) : {
      n = validIdent(serializeExp(name));
      return startWith(n);
    }
    case element(_,"error", children): {
      attr = [x | x <- children, element(_, _, _) !:= x && charData(_) !:= x ];
      return onError(serializeExp(attr[0].contentList));
    }
    case element(_,"ok", children): {
      attr = [x | x <- children, element(_, _, _) !:= x && charData(_) !:= x ];
      n = validIdent(serializeExp(attr[0].contentList));
      return then(n);
    }
    case element(_,"kill", children): {
      str kill_message = "";
      for(c <- children){
        if(element(_,"message", ndd) := c){
          rad = [y | x <- ndd, charData(y) := x];
          kill_message = serializeExp(rad[0]);
        }
      }
      return kill("kill", "\"<kill_message>\"");
    }
    case element(_,"end", _): {
      return end("end");
    }
    default: throw "unhandled <nd>";
  }
  
}



