module lang::ptl::translations::translate2snowflake::Tests

import IO;
import lang::ptl::Utils;
import lang::snowflake::prettyprint::SnowFlake;
import lang::ptl::translations::translate2snowflake::TranslateDeclarations;


test bool testExprToSnowFlake(value code=|project://adept-base/src/lang/ptl/examples/expression.ptl|){
    code_pt = loadPTL(code);
    snowflake_ast = toSQL(code_pt);
    println(toString(snowflake_ast));
   writeFile(|project://adept-base/src/lang/ptl/examples/output/expression.sql|, toString(snowflake_ast));
    return true;
}

test bool testSCDCodeGenSnowFlake(value code=|project://adept-base/src/lang/ptl/examples/scdCodeGen.ptl|){
    code_pt = loadPTL(code);
    snowflake_ast = toSQL(code_pt);
    println(toString(snowflake_ast));
   
    return true;
}

test bool testViewSnowFlake(value code=|project://adept-base/src/lang/ptl/examples/view.ptl|){
    code_pt = loadPTL(code);
    snowflake_ast = toSQL(code_pt);
    println(toString(snowflake_ast));
   
    return true;
}

test bool testView2SnowFlake(value code=|project://adept-base/src/lang/ptl/examples/view3.ptl|){
    code_pt = loadPTL(code);
    snowflake_ast = toSQL(code_pt);
    println(toString(snowflake_ast));
   
    return true;
}
test bool testViewWithModelAnnotationSnowFlake(value code=|project://adept-base/src/lang/ptl/examples/view4.ptl|){
    code_pt = loadPTL(code);
    snowflake_ast = toSQL(code_pt);
    println(toString(snowflake_ast));
   
    return true;
}
