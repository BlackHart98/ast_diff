module lang::spark::translations::Test

import lang::spark::translations::Spark;

import lang::ptl::prettyprint::PTL;
import lang::spark::utils::Implode;
import  lang::ptl::Utils;
import IO;


bool testSpark(loc input,loc output){
    spark_ast = loadSpark(input);
    input_ptl = toPTL(spark_ast);
    ptl_ast = loadPTL(output);
   writeFile(|project://adept-base/src/lang/ptl/examples/translations/ptlInput/output.ptl|, toString(input_ptl));

   return ptl_ast:=loadPTL(|project://adept-base/src/lang/ptl/examples/translations/ptlInput/output.ptl|);
}

test bool testEntity(){
    input = |project://adept-base/src/lang/ptl/examples/translations/ptlInput/entity.ptl|;
    output = |project://adept-base/src/lang/spark/examples/translation/sparkTarget/createTable.sql|;
    return testSpark(output,input);

}

test bool testEntityExtends(){
    input = |project://adept-base/src/lang/ptl/examples/translations/ptlInput/entityExtends.ptl|;
    output = |project://adept-base/src/lang/spark/examples/translation/sparkTarget/createLike.sql|;
    return testSpark(output,input);

}

test bool testViewAs(){
    input = |project://adept-base/src/lang/ptl/examples/translations/ptlInput/viewWith.ptl|;
    output = |project://adept-base/src/lang/spark/examples/translation/sparkTarget/createTableWithQuery.sql|;
    return testSpark(output,input);

}

test bool testFunctionParameters(){
     input = |project://adept-base/src/lang/ptl/examples/translations/ptlInput/functionWithParameters.ptl|;
    output = |project://adept-base/src/lang/spark/examples/translation/sparkTarget/functionWithParameters.sql|;
    return testSpark(output,input);

}