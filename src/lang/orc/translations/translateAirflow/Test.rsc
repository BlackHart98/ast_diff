module lang::orc::translations::translateAirflow::Test
import lang::orc::translations::translateAirflow::Orc;
import lang::orc::utils;
import IO;
import lang::python::prettyprint::Python;

bool translator(loc input){
   orcast= getOrcAst(input);
   airflowAst = toAirflow(orcast);
      return true;
}

test bool testScheduler(){
    input =|project://adept-base/src/lang/orc/examples/tesst.orc|;
    return translator(input);
}
