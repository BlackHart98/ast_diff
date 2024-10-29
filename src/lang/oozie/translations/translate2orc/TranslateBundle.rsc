module lang::oozie::translations::translate2orc::TranslateBundle

import lang::orc::ast::Orc;
import lang::orc::ast::Scheduler;
import lang::oozie::grammar::Oozie;
import lang::xml::DOM;
import lang::oozie::translations::translate2orc::TranslateCoordinator;
import lang::oozie::translations::translate2orc::Helpers;
import IO;


public OrcStart toOrcSchdlr(document(element(_,_,list[Node] children))){
  elem = [ x | x <- children, charData(_) !:= x && element(_, "controls", _) !:= x];
  return program(declarations([toOrcDec(x) | x <- elem]));
}

public Declaration toOrcDec(Node nd){
  switch(nd){
    case attribute(_,_,list[OozieNode] name): {
      str mod_name = validIdent(serializeExp(name));
      return \module(mod_name);
    }
    case element(_,"coordinator",children): {
      return scheduler(toOrc(children));
    }
  default: throw "unhandled <nd>";
  }
}

public &T transOozieNode(list[OozieNode] ozn){
  for(elem <- ozn){
    if(stringData(ctn) := elem){
      return ctn;
    }
    
  }
  return -1;

}




public Scheduler toOrc(list[Node] nds){
  elem = [x | x <- nds, element(_,_,_) := x];
  for(element(_,_,children) <- elem){
    name = serializeExp(children[0].contentList);
    new_name = name;
    return toOrcSch(getNode(new_name));
  }
  
  return schedulerDef(_,_,_,_);
}


