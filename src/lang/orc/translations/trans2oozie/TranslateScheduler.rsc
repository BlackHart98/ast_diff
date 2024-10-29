module lang::orc::translations::trans2oozie::TranslateScheduler

import lang::orc::ast::Orc;

import lang::xml::DOM;
import IO;
import String;
import lang::orc::prettyprint::Orc;


// Node toOozieCoordinator(Orc x){
//     list[Node] schdlrr = [toOozieCoordinator(sch) | sch <- x.statements, dataflow(_,_,_) := sch];
//     freq = [e | sch <- x.statements
//             , dataflow(_,dataflowPropList,_) := sch
//             , a <- dataflowPropList
//             , frequency(e) := a

//         ];
//     return document(
//             element(
//                 namespace("","uri:oozie:workflow:1.0")
//                 , "coordinator-app"
//                 , schdlrr +
//                 attribute(none(), "name", ("freq"))

//             )
//         );
// }

Node toOozieCoordinator(dataflow(str flowId, list[DataFlowProp] dataflowPropList, list[DagNode] dags )){
    return element(
        none(),
        "workflow"
        , [element(none(), "app-path",[charData(flowId)])]
    );
}

str toConfigurationProperty(Orc x){
 list[Prop] props = [a.properties | sch <- x.statements
            , dataflow(_,dataflowPropList,_) := sch
            , a <- dataflowPropList
            , configProp(_) := a

        ][0];
        
   
    return xmlPretty(document(
            element(
                none()
                , "configuration"
                , [toConfigurationProperty(prop)|prop<-props]

            )
        ));
}

Node toConfigurationProperty(prop(str sc, ExprOrVariable e)){
   return element(
                none()
                , "property"
                , [element(none(),"name",[charData(sc)]),element(none(),"name",[charData(toString(e))])]

            );
}