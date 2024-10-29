module lang::orc::prettyprint::Tests
import IO;
import lang::orc::prettyprint::Orc;
import lang::orc::grammar::Orc;
import lang::orc::ast::Orc;
import ParseTree;


test bool testOrc(){
 loc prettyTest = |project://adept-base/src/lang/orc/examples/TestPretty.orc|;
 return prettyCond(prettyTest);
}

bool prettyCond(loc file) {
  ast = implode(#Orc, parse(#start[Orc], file));
  newFile=toString(ast);
  writeFile(|project://adept-base/src/lang/orc/examples/TestPretty2.orc|,newFile);
  x = implode(#Orc, parse(#start[Orc],newFile ));
  return ast := x;
}
