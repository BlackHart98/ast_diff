module lang::oozie::translations::translate2orc::Tests

import lang::oozie::translations::translate2orc::TranslateExpressions;
import IO;
import ParseTree;
import lang::oozie::ast::Expressions;
import lang::oozie::grammar::Oozie; 

void main(){
  loc code = |project://adept-base/src/lang/oozie/examples/expressioneasy.xml|;
  result = testExptranslation(code);
  println(result);
}

list[Expr] testExptranslation(loc code) {
  code_pt = parse(#lang::oozie::grammar::Expressions::OozieProg, code, filters={});
  ast = implode(#lang::oozie::ast::Expressions::OozieProg, code_pt);
  orc = toOrc(ast);
  return orc;
}