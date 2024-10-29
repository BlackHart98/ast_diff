module lang::ptl::translations::translate2bigquery::Tests

import lang::bigquery::prettyprint::BigQuery;
import IO;
import lang::ptl::Utils;

import lang::ptl::translations::translate2bigquery::TranslateDeclarations;



test bool testExprToBigQuery(value code=|project://adept-base/src/lang/ptl/examples/expression.ptl|){
    code_pt = loadPTL(code);
    bigquery_ast = toSQL(code_pt);
    println(toString(bigquery_ast));
   
    return true;
}


test bool testSCDCodeGenToBigQuery(value code=|project://adept-base/src/lang/ptl/examples/scdCodeGen.ptl|){
    code_pt = loadPTL(code);
    bigquery_ast = toSQL(code_pt);
    println(toString(bigquery_ast));
   
    return true;
}

test bool testViewToBigQuery(value code=|project://adept-base/src/lang/ptl/examples/view.ptl|){
    code_pt = loadPTL(code);
    bigquery_ast = toSQL(code_pt);
    println(toString(bigquery_ast));
   
    return true;
}

test bool testView2ToBigQuery(value code=|project://adept-base/src/lang/ptl/examples/view3.ptl|){
    code_pt = loadPTL(code);
    bigquery_ast = toSQL(code_pt);
    println(toString(bigquery_ast));
   
    return true;
}
test bool testViewWithModelAnnotationToBigQuery(value code=|project://adept-base/src/lang/ptl/examples/view4.ptl|){
    code_pt = loadPTL(code);
    bigquery_ast = toSQL(code_pt);
    println(toString(bigquery_ast));
   
    return true;
}