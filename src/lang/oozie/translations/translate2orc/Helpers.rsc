module lang::oozie::translations::translate2orc::Helpers

import IO;
import lang::oozie::grammar::Oozie;
import lang::oozie::prettyprint::Oozie;

import String;



@description{
  take a file loc and returns the Node of that file
}

public Node getNode(str file_loc){
    loc bundle_path = resolveLocation(|cwd:///<file_loc>|);
    ast = load(readFile(bundle_path));
    return ast;
}

// check valid name
public str validIdent(str name){
  validName = (contains(name, "-")) ? "`<name>`" : "<name>";
  return validName;
}



public str serializeExp(list[OozieNode] contentList){
  return ("" | it + prettyOozieNode(cl)  | cl <- contentList);
}