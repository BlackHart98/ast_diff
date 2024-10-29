module lang::oozie::translations::translate2orc::Translations

import IO;
import lang::xml::DOM;
import lang::oozie::translations::translate2orc::TranslateCoordinator;
import lang::orc::prettyprint::Orc;
import lang::oozie::grammar::Oozie;


public str translateOozie(loc file_loc){
  ast =  load(readFile(file_loc));
  code2Orc = (toOrcTasks(ast, "Users/ayomidehassan/desktop/testbed/mappings.txt"));

  return "code2Orc";
}