module lang::hql::translations::translate2ptl::Tests

import ParseTree;

import lang::hql::Utils;
import lang::hql::translations::translate2ptl::TranslateProgram;
import lang::ptl::Utils;
import lang::ptl::prettyprint::PTL;
import IO;



test bool testCreateView() {
  loc actual = |project://adept-base/src/lang/hql/examples/translate2ptl/input/createview.hql|;
  loc expected = |project://adept-base/src/lang/hql/examples/translate2ptl/expected/createview.ptl|;
  return translateCond(actual, expected, moduleName="createview");
}

test bool testCreateTable() {
  loc actual = |project://adept-base/src/lang/hql/examples/translate2ptl/input/createtable.hql|;
  loc expected = |project://adept-base/src/lang/hql/examples/translate2ptl/expected/createtable.ptl|;
  return translateCond(actual, expected, moduleName="createtable");
}

test bool testInsertTable() {
  loc actual = |project://adept-base/src/lang/hql/examples/translate2ptl/input/inserttable.hql|;
  loc expected = |project://adept-base/src/lang/hql/examples/translate2ptl/expected/inserttable.ptl|;
  return translateCond(actual, expected, moduleName="inserttable");
}

bool translateCond(loc actual, loc expected, str moduleName="minTrans") {

  actual_ast = toPTL(loadHQL(actual),moduleName=moduleName);
  
  expected_ast = loadPTL(expected);
     writeFile(|project://adept-base/src/lang/hql/examples/translation/hiveTaget/test.ptl|, toString(actual_ast));
  
  // This is the only way the deep match works for some reason at the moment
  return expected_ast := loadPTL(toString(actual_ast));
}


   