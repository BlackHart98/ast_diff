module lang::orc::translations::trans2oozie::Translations


import lang::oozie::prettyprint::Oozie;

import ParseTree;
import lang::orc::grammar::Orc;
import lang::orc::ast::Orc;

import IO;
import lang::orc::translations::trans2oozie::TranslateWorkflow;
import lang::orc::translations::trans2oozie::TranslateScheduler;
import lang::xml::DOM;



Orc loadOrc(loc code = |project://adept-base/src/lang/orc/examples/tesst.orc|) = implode(#lang::orc::ast::Orc::Orc, parse(#start[Orc], code));

public void toOozie(){
    workflows = [];
    coordinator = [];
    configuration =[];

    worktemp = toOozieWorkflow(loadOrc());
    // coordtemp = toOozieCoordinator(loadOrc());
    configs= toConfigurationProperty(loadOrc());
    writeFile(|project://adept-base/src/lang/orc/examples/orc2Oozie/output/workflow.xml|, toString(worktemp));
    // writeFile(|project://adept-base/src/lang/orc/examples/orc2Oozie/output/coord.xml|, (coordtemp));

}
void toWorkflow(){
    return writeFile(|project://adept-base/src/lang/orc/examples/orc2Oozie/tesstout.xml|, (toOozieWorkflow(loadOrc())));
}
void toConfig(){
    return writeFile(|project://adept-base/src/lang/orc/examples/orc2Oozie/tesstout.xml|, (toConfigurationProperty(loadOrc())));
}

// |project://adept-base/src/lang/orc/examples/orc2Oozie/tesstout.xml|