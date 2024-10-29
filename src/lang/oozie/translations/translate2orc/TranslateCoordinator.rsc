module lang::oozie::translations::translate2orc::TranslateCoordinator

import lang::orc::ast::Orc;
import lang::orc::ast::Scheduler;
import lang::orc::prettyprint::Orc;
import lang::oozie::grammar::Oozie;
import lang::oozie::translations::translate2orc::TranslateWorkflow;
import lang::oozie::translations::translate2orc::Helpers;
import IO;

public OrcStart toOrcTasks(document(element(_,_, children))){
  elem = [ x | x <- children, charData(_) !:= x && element(_, "controls", _) !:= x];
  coord_name = [ name | x <- children, attribute(_,"name",list[OozieNode] name) := x];

  link = [
    serializeExp(name)
    | x <- elem
    , element(_, "action", action_children) := x
    , y <- action_children
    , element(_, "workflow", workflow_children) := y
    , z <- workflow_children
    , element(_, "app-path", app_children) := z
    , a <- app_children
    , charData(name) := a];
  wf_node = (getNode(link[0]));
  return toOrc(wf_node, serializeExp(coord_name[0]));
}


public Scheduler toOrcSch(document(element(_,_, children))){
  name = [y | x <- children, attribute(_,"name", list[OozieNode] y) := x];
  freq_val = [y | x <- children, attribute(_,"frequency", list[OozieNode] y) := x];
  start_val = [x | x <- children, attribute(_,"start",_) := x];
  end_val = [x | x <- children, attribute(_,"end",_) := x];

  elem = [x | x <- children, element(_,"action",_) := x];

  for(element(_,_,child) <- elem){
    action = [x | x <- child, element(_,_,_) := x];
    for(element(_,_,subchild) <- action){
      path = [x | x <- subchild, element(_,_,_) := x];
      path_name = serializeExp(path[0].children[0].contentList);
      new_path = path_name;
      
    }
  }
  return schedulerDef(validIdent(serializeExp(name[0])), "\"<serializeExp(freq_val[0])>\"", "\"start_val[0].text\"", "\"end_val[0].text\"");
}




