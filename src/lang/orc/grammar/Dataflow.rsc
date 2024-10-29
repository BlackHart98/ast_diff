module lang::orc::grammar::Dataflow
extend lang::orc::grammar::Expressions;
extend lang::orc::grammar::Literals;
extend lang::orc::grammar::Layout;


syntax Statement =  
  ActionDefinition
  |@foldable DataFlow
  | ZoneAction
;

syntax ActionDefinition = 
    actionDefinition: "define" "action" ":"
        ActionType ":"
          Property+
;

syntax ZoneAction
   = zoneAction : "define" "action"":"
      "zone"":"
      "name""="ZoneName
      (PropId!name "=" ExprOrVariable)*
      ;


syntax ZoneName =
     "staging" | "transformation"
     ;      
syntax ActionType = 
    shell: "shell"
    | sqoop: "sqoop"
    | kill:  "kill"
    | transform: "transform" // hive, spark actions
;

syntax ExprOrVariable = 
   exp: Expr
   | variable: Variable
   
;

syntax Property = 
    attr: PropId "=" ExprOrVariable
    | properties: "properties" ":" 
                      Id "=" ExprOrVariable
;

syntax PropId = 
    name: "name"
    | file: "file"
    | action: "action"
    | configFile: "configFile"
    | command:  "command"
    | message: "message"
    | success: "onSuccess"
    | onError: "onActionError"
    | view: "view"
;

syntax DataFlow = 
    dataflow: "dataflow" Id ":"
                  DataFlowProp+
                "dag" ":"
                   DagNode+
;


syntax DataFlowProp = 
   error: "onError" "=" ExprOrVariable
   | configProp: "configurationProperties"":"
     Prop+
;

syntax Prop =
   prop: StringConstant "=" ExprOrVariable   
;

syntax DagNode = 
   actionId: Id
   | defAction: ActionType ":"
                   Property+
   | defZone: "zone:"
               "name""=" ZoneName
               (PropId!name "=" ExprOrVariable)*
   | parallelNode: "parallel" ":"
                   {DagNode "&&"}+
               
   | \case: "case" ":"
            WhenClause+
            "default" ":" DagNode
  ;



syntax WhenClause = 
  when: "when" ExprOrVariable "-\>"
      DagNode
;

