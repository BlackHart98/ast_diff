module lang::spark::utils::Implode


import lang::spark::grammar::Spark;
import lang::spark::ast::Spark;
import ParseTree;


public Spark loadSpark(loc file)=implode(#Spark, parse(#start[Spark], file));


public Spark loadSpark(str input)=implode(#Spark, parse(#start[Spark], input));

public Spark ParseFunction(){
    location=|project://adept-base/src/lang/functionLang/examples/Aggregate.sql|;
   return loadSpark(location);
}