module lang::configlang::prettyprint::Tests

extend lang::configlang::prettyprint::Configlang;
import lang::configlang::grammar::Configlang;
import lang::configlang::ast::Configlang;
import ParseTree;
import IO;


bool parseAndPP(loc code){
  code_pt = parse(#start[Config], code);
  ast = implode(#lang::configlang::ast::Configlang::Config, code_pt);
  prettyconfiglang = toString(ast);
  writeFile(|project://adept-base/src/lang/configlang/examples/output/acmeSnippet.pcf|, prettyconfiglang);
  new_code = parse(#start[Config], prettyconfiglang);
  new_ast = implode(#lang::configlang::ast::Configlang::Config, new_code);
  return ast:=new_ast;
}

test bool testPretty() {
  loc file = |project://adept-base/src/lang/configlang/examples/Acme.pcf|;
  return parseAndPP(file);
}