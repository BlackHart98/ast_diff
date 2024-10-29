module lang::ptl::translations::translate2athena::Tests

import lang::athena::prettyprint::Athena;
import IO;

import lang::ptl::Utils;
import lang::ptl::translations::translate2athena::TranslateDeclarations;



test bool testExprToAthena(value code=|project://adept-base/src/lang/ptl/examples/expression.ptl|){
    code_pt = loadPTL(code);
    athena_ast = toSQL(code_pt);
    println(toString(athena_ast));
   
    return true;
}


test bool testSCDCodeGenToAthena(value code=|project://adept-base/src/lang/ptl/examples/scdCodeGen.ptl|){
    code_pt = loadPTL(code);
    athena_ast = toSQL(code_pt);
    println(toString(athena_ast));
   
    return true;
}

test bool testViewToAthena(value code=|project://adept-base/src/lang/ptl/examples/view.ptl|){
    code_pt = loadPTL(code);
    athena_ast = toSQL(code_pt);
    println(toString(athena_ast));
   
    return true;
}

test bool testView2ToAthena(value code=|project://adept-base/src/lang/ptl/examples/view3.ptl|){
    code_pt = loadPTL(code);
    athena_ast = toSQL(code_pt);
    println(toString(athena_ast));
   
    return true;
}
test bool testViewWithModelAnnotationToAthena(value code=|project://adept-base/src/lang/ptl/examples/view4.ptl|){
    code_pt = loadPTL(code);
    athena_ast = toSQL(code_pt);
    println(toString(athena_ast));
   
    return true;
}