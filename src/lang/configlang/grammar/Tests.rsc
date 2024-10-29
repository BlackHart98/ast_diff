module lang::configlang::grammar::Tests

import lang::configlang::grammar::Configlang;
import lang::configlang::ast::Configlang;

import ParseTree;
import IO;



bool parseConfigLang(loc code){
  code_pt = parse(#start[Config], code);
  ast = implode(#lang::configlang::ast::Configlang::Config, code_pt);
  return true;
}


test bool testAcme() {
  loc file = |project://adept-base/src/lang/configlang/examples/Acme.pcf|;
  return parseConfigLang(file);
}

// test bool testConfig() {
//   loc file = |project://adept-base/src/lang/configlang/examples/config.pcf|;
//   return parseConfigLang(file);
// }