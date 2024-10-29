module lang::orc::translations::trans2oozie::TranslateWorkflow

import lang::orc::ast::Orc;
import lang::xml::DOM;
import IO;
import lang::orc::prettyprint::Orc;
import List;
import Type;
import Set;

public list[DagNode] addNames(list[DagNode] actions){
    int indexed_count = 0;
    int parallel_count = 0;
    newNodes = [];
    newTree = visit(actions){
        case defAction(ActionType actionType,list[Property] ptList):{
            indexed_count += 1;
            ppp = [p in ptList | p <- ptList, attr(name(), _) := p];
    
            if(isEmpty(ppp)){
                insert defAction(actionType, ptList + [attr(name(), exp(string("<getActionType(actionType)>_<indexed_count>")))]);
            } else{
                insert defAction(actionType, ptList);
            }
        }
        case parallelNode(list[DagNode] nodeList):{
            newNodes += nodeList;
            parallel_count += 1;
            insert parallelNode(parallelName("parallel_<parallel_count>")+addNames(nodeList));

        }
    };
    return newTree + newNodes;
}

public Node toOozieWorkflow(Orc x){
    dagActions = [dags | i <- x.statements
                , dataflow(_,_,dags) := i
                ];


    actions = addNames(head(dagActions));


    lrel[str actionT, str actionN, Node actionNode] defActions 
        = [<getActionType(actionType), toString(exp),toOozieWorkflow(i)>
                | i <- x.statements
                , actionDefinition(actionType,ptList) := i
                , p <- ptList
                , attr(name(), exp) := p
                ];
    firstDag = [a | a <-actions];
    // println(getStartDag(firstDag[0]));
    lrel[str dagName, Node dn] actualActions = [];
    lrel[str dagName, Node dn] newActs = [<getNameFromDagNode(d), toOozieWorkflow(d) > | d <- actions];

    // lrel[str pName, DagNode pNode] parallelActions = [<getNameFromDagNode(k),j>| j <- actions
    //                 , parallelNode(list[DagNode] nodeList) := j
    //                 , k <- nodeList
                    
    //                 ];
    lrel[str dagPName, map[str parallelName, DagNode pNode] mappedAct] pActions= [<getNameFromDagNode(k), (getNameFromDagNode(j): j)>| j <- actions
                    , parallelNode(list[DagNode] nodeList) := j
                    , k <- nodeList
                    , parallelName(_) !:= k
                    ];

    for(int i <-[0..size(newActs)]){
        n = newActs[i];
        str nextAction = "";
        if(n.dagName in defActions.actionN){
            n.dn = defActions.actionNode[i];
        }
        if(n.dn.name == "action"){
             n.dn.children += [element(namespace("", "uri:oozie:hive-action:1.0"), "error", [attribute(none(), "to", "fail")])];
             if (n.dagName in pActions.dagPName) {
                    nodeName = (pActions[n.dagName][0].parallelName);


                    n.dn.children += [element(namespace("", "uri:oozie:hive-action:1.0"), "ok", [attribute(none(), "to", getFirstFrom(nodeName))])];
                } else if (indexOf(newActs.dagName, n.dagName) != indexOf(newActs.dagName, newActs.dagName[-1])) {
                    // For non-parallel actions, add the nextAction as "to"
                    nextAction = newActs.dagName[indexOf(newActs.dagName, n.dagName) + 1];
                    n.dn.children += [element(namespace("", "uri:oozie:hive-action:1.0"), "ok", [attribute(none(), "to", nextAction)])];
            }
        } 

        actualActions += n;

        if(n.dn.name == "fork"){
            int join_counter = 1;
            nextAction = newActs.dagName[indexOf(newActs.dagName, n.dagName) + 1];

            Node joinElem = element(namespace("","uri:oozie:workflow:1.0"), "join", [attribute(none(), "to", nextAction)]);
            
            actualActions += <"join_<join_counter>",joinElem>;
            join_counter += 1;
            
        }
    }


    

    killAction = [generatekill(i) | i <- x.statements, actionDefinition(kill(),_) := i];




    return document(
            element(
                namespace("","uri:oozie:workflow:1.0")
                , "workflow-app"
                , [attribute(none(), "name", "flow1")] 
                // + dNode.val 
                + getStartDag(firstDag[0])
                + actualActions.dn
                + killAction[0]
            )
        );
}
public Node generatekill(actionDefinition(kill(),ptList)){
    killMsg = [toString(exp) | p <- ptList, attr(message(), exp) := p];
    return element(namespace("","uri:oozie:workflow:1.0"), "kill", [
                attribute(none(),"name", "fail")
                ,element(none(), "message", [charData(killMsg[0])])
            ]);
}
str getActionType(ActionType actType){
    switch(actType){
        case shell(): return "shell";
        case ddl(): return "shell";
        case sqoop(): return "sqoop";
        case kill(): return "kill";
        case transform(): return "transform";

        default: throw "unhandled <actType>";
    }
}

Node getStartDag(DagNode dags){
    starter = dags.nodeName;
    return element(namespace("","uri:oozie:workflow:1.0"), "start", [
                attribute(none(),"to", starter)
                // ,element(namespace("", "uri:oozie:hive-action:1.0"), "to", [])
            ]);
}


str getNameFromDagNode(DagNode nd){
    switch(nd){
        case actionId(str nodeName): return nodeName;
        case defAction(_,list[Property] ptList): {
            actionName = [toString(exp) | i <- ptList, attr(name(), exp) := i];
            return actionName[0];
        }
        case parallelNode(list[DagNode] nodeList):{
            fName = [name| n <- nodeList, parallelName(name) := n];
            return fName[0];
        }
        case parallelName(str name): return name;
        default: throw "unhandled <nd>";

    }
}

Node toOozieWorkflow(Statement t){
    return toOozieWorkflow(t.actionType, t.ptList);
}

Node toOozieWorkflow(ActionType actionType,list[Property] ptList){

    children = [toOozieWorkflow(prop) | prop <- ptList, attr(name(),_) !:= prop];
    nodeName = [toString(exp)| p <- ptList, attr(name(), exp) := p];
    switch(actionType){
        case shell():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                , [attribute(none(),"name", nodeName[0])
                    ,element(namespace("", "uri:oozie:hive-action:1.0"), "shell"
                    , children
            )]
            );
        }
        case ddl():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                , [attribute(none(),"name", nodeName[0])
                    ,element(namespace("", "uri:oozie:hive-action:1.0"), "shell"
                    , children
            )]
            );
        }
        case sqoop():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                , [attribute(none(),"name", nodeName[0])
                    ,element(namespace("", "uri:oozie:hive-action:1.0"), "sqoop"
                    , children
            )]
            );
        }
        case transform():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                , [attribute(none(),"name", nodeName[0])
                    ,element(namespace("", "uri:oozie:hive-action:1.0"), "transform"
                    , children
            )]
            );
        }
        case kill():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "kill", children);
        }
        default: throw "unhandled <actionType>";
    }
}



Node toOozieWorkflow(Property p){
    switch(p){
        case attr(configFile(),ExprOrVariable exp):{
            str expOrVar = toString(exp);
            return element(namespace("", "uri:oozie:hive-action:1.0"), "exec"
                    , [charData(expOrVar)]
                    
                );
        }
        case attr(action(),ExprOrVariable exp):{
            str expOrVar = toString(exp);
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                    , [charData(expOrVar)]
                    
                );
        }
        case attr(view(),ExprOrVariable exp):{
            str expOrVar = toString(exp);
            return element(namespace("", "uri:oozie:hive-action:1.0"), "script"
                    , [charData(expOrVar)]
                    
                );
        }
        case properties(str eid, ExprOrVariable e):{
            return element(none(), "configuration", [
                element(none(), "property", [
                    element(none(), "name", [charData(eid)]),
                    element(none(), "value", [charData(toString(e))])

                ])
            ]);
        }

        default: throw "unhandled <p>";

    }
}



Node toOozieWorkflow(DagNode dag){
    str newname = getNameFromDagNode(dag);


    switch(dag){
        case actionId(str nodeName):{
           return element(namespace("","uri:oozie:workflow:1.0"), "action", [
                            attribute(none(),"name", nodeName)
                            
                        ]);
        }
        case defAction(ActionType actionType,list[Property] ptList):{
            children = [toOozieWorkflow(prop) | prop <- ptList, attr(name(),_) !:= prop];
            switch(actionType){
                case shell():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                , [attribute(none(),"name", newname)
                    ,element(namespace("", "uri:oozie:hive-action:1.0"), "shell"
                    , children
            )]
            );
        }
                case ddl():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                , [attribute(none(),"name", newname)
                    ,element(namespace("", "uri:oozie:hive-action:1.0"), "shell"
                    , children
            )]
            );
        }
                case sqoop():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                , [attribute(none(),"name", newname)
                    ,element(namespace("", "uri:oozie:hive-action:1.0"), "shell"
                    , children
            )]
            );
        }
                case transform():{
            return element(namespace("", "uri:oozie:hive-action:1.0"), "action"
                , [attribute(none(),"name", newname)
                    ,element(namespace("", "uri:oozie:hive-action:1.0"), "shell"
                    , children
            )]
            );
        }
                case kill():{
                    return element(namespace("", "uri:oozie:hive-action:1.0"), "kill", children);
                }
                default: throw "unhandled <actionType>";
            }
                }
        case parallelNode(list[DagNode] nodeList):{
           fName = [name| n <- nodeList, parallelName(name) := n];
            return {
                
                    element(namespace("","uri:oozie:workflow:1.0"), "fork", [
                        attribute(none(), "name",fName[0])
                        ,element(namespace("","uri:oozie:workflow:1.0"), "path", 
                        [attribute(none(), "start", getNameFromDagNode(nd))]) | nd <- nodeList, parallelName(_) !:= nd
                ]);
                
            }
        }
        default: throw "unhandled <dag>";
    }
}