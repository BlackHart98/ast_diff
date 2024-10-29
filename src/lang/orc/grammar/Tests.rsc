module lang::orc::grammar::Tests


import lang::orc::grammar::Orc;
import lang::orc::ast::Orc;

import ParseTree;


bool parseAndImplode(loc code) {
  code_pt = parse(#start[Orc], code, filters={});

  
  code_ast = implode(#Orc, code_pt);
  return true;
}


test bool testTesst() {
  loc file = |project://adept-base/src/lang/orc/examples/tesst.orc|;
  return parseAndImplode(file);
}