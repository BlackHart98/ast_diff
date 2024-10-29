module lang::ptl::translations::translate2Spark::Tests
import lang::ptl::translations::translate2Spark::TranslateDeclarations;
import lang::spark::prettyprint::Spark;
import  lang::ptl::Utils;
import IO;


test bool testExprToSpark(value code=|project://adept-base/src/lang/ptl/examples/expression.ptl|){
    code_pt = loadPTL(code);
    spark_ast = toSQL(code_pt);
    println(toString(spark_ast));
    return true;
}

test bool testSCDCodeGenSpark(value code=|project://adept-base/src/lang/ptl/examples/scdCodeGen.ptl|){
    code_pt = loadPTL(code);
    spark_ast = toSQL(code_pt);
    println(toString(spark_ast));
   
    return true;
}
test bool testSCDCodeGenSpark2(value code=|project://adept-base/src/lang/ptl/examples/scdCodeGen2.ptl|){
    code_pt = loadPTL(code);
    spark_ast = toSQL(code_pt);
    println(toString(spark_ast));
   
    return true;
}

test bool testViewSpark(value code=|project://adept-base/src/lang/ptl/examples/view.ptl|){
    code_pt = loadPTL(code);
    spark_ast = toSQL(code_pt);
    println(toString(spark_ast));
   
    return true;
}

test bool testView2Spark(value code=|project://adept-base/src/lang/ptl/examples/view3.ptl|){
    code_pt = loadPTL(code);
    spark_ast = toSQL(code_pt);
    println(toString(spark_ast));
   
    return true;
}
test bool testViewWithModelAnnotationSpark(value code=|project://adept-base/src/lang/ptl/examples/view4.ptl|){
    code_pt = loadPTL(code);
    spark_ast = toSQL(code_pt);
    println(toString(spark_ast));
   
    return true;
}

test bool testViewWithAnnotationSpark(value code=|project://adept-base/src/lang/ptl/examples/scdCheck.ptl|){
    code_pt = loadPTL(code);
    spark_ast = toSQL(code_pt);
    println(toString(spark_ast));
    writeFile(|project://adept-base/src/lang/ptl/examples/scdCheck.sql|, toString(spark_ast));
    return true;
}
