module lang::ptl::translations::translate2hql::Tests

import IO;
import lang::ptl::Utils;

import lang::ptl::translations::translate2hql::TranslateDeclarations;
import lang::hql::prettyprint::HQL;



test bool testExprToHQL(value code=|project://adept-base/src/lang/ptl/examples/expression.ptl|){
    code_pt = loadPTL(code);
    hql_ast = toSQL(code_pt);
    println(toString(hql_ast));
   
    return true;
}

test bool testSCDCodeGenToHQL(value code=|project://adept-base/src/lang/ptl/examples/scdCodeGen.ptl|){
    code_pt = loadPTL(code);
    hql_ast = toSQL(code_pt);
    println(toString(hql_ast));
   
    return true;
}

test bool testViewToHQL(value code=|project://adept-base/src/lang/ptl/examples/view.ptl|){
    code_pt = loadPTL(code);
    hql_ast = toSQL(code_pt);
    println(toString(hql_ast));
   
    return true;
}

test bool testView2ToHQL(value code=|project://adept-base/src/lang/ptl/examples/view3.ptl|){
    code_pt = loadPTL(code);
    hql_ast = toSQL(code_pt);
    println(toString(hql_ast));
   
    return true;
}
test bool testViewWithModelAnnotationToHQL(value code=|project://adept-base/src/lang/ptl/examples/view4.ptl|){
    code_pt = loadPTL(code);
    hql_ast = toSQL(code_pt);
    println(toString(hql_ast));
   
    return true;
}

test bool testSCDCheckColumns(value code=|project://adept-base/src/lang/ptl/examples/scd/hive_check.ptl|){
    code_pt = loadPTL(code);
    hql_ast = toSQL(code_pt);
    iprintln(toString(hql_ast));
    return true;
}