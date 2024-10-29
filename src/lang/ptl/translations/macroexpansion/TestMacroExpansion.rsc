module lang::ptl::translations::macroexpansion::TestMacroExpansion

import lang::ptl::translations::macroexpansion::ExpandMacros;
import IO;
import lang::ptl::translations::macroexpansion::LoadAST;
import lang::ptl::prettyprint::PTL;
import lang::ptl::ast::PTL;
 

test bool test_macro_call() {
  loc src = |project://adept-base/src/lang/ptl/examples/macrocall.ptl|;
  return test_macro(src);
}

test bool test_macro_for() {
  loc src = |project://adept-base/src/lang/ptl/examples/macrofor.ptl|;
  return test_macro(src);
}

test bool test_macro_view() {
  loc src = |project://adept-base/src/lang/ptl/examples/macroview.ptl|;
  return test_macro(src);
}

test bool test_macro_conditional() {
  loc src = |project://adept-base/src/lang/ptl/examples/macroif.ptl|;
  return test_macro(src);
}


bool test_macro(loc src) {
  ast = implode(src);
  // Use the ast to check if it's valid PTL
  return Program::\module(_, _, _) := \module(ast.moduleId, ast.importlist, expandMacros(ast.decls));
}

void main() {
  loc src = |project://adept-base/src/lang/ptl/examples/macrocall.ptl|;
  ast = implode(src);
  writeFile(|project://adept-base/src/lang/ptl/examples/macrocall_expanded.ptl|, toString(\module(ast.moduleId, [], expandMacros(ast.decls))));
}


