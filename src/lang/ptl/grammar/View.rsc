module lang::ptl::grammar::View

extend lang::ptl::grammar::Struct;


syntax SchemaName = schemaName: "@schema" "(" OID ")";

syntax SchemaVar = schemaVar: "@schema" "(" "${" OID "}" ")";

syntax AddFile = addFile: "@addFile" "(" Url ")";

syntax Url 
  = url: SchemePart? DirectoryPart FileNamePart
  | urlVarReference: "${" OID "}"
  ;



syntax SchemePart = hdfs: "hdfs://";

syntax FileNamePart = fileNamePart: OID "." OID;

syntax DirectoryPart = directoryPart: {DirectoryPath "/"}*;

syntax DirectoryPath 
  = directoryName: OID
  | aSubstitutedText: "${" OID "}"
  ;


syntax View
  =  viewAs: ModelAnnotation? IfNotExists? Drop? Temporal?
            "view" QualifiedIdentifier
                ViewVariablesOrEmpty?
               "(" SubViewDecl ")"
            "end" "view"

    | viewWith: ModelAnnotation? IfNotExists? Drop? Temporal? 
                "view" QualifiedIdentifier "with" 
                  ViewVariablesOrEmpty?
                   NamedSubViewDecl+ names
                   SubViewDecl
                "end" "view"

    | viewWithTransform2: ModelAnnotation? IfNotExists? Drop? Temporal?
                          "view" QualifiedIdentifier "with"
                             ViewVariablesOrEmpty?
                               NamedSubViewDecl+ names
                               TransformDecl
                           "end" "view"

    | viewWithTransform: ModelAnnotation? IfNotExists? Drop? Temporal?
                         "view with" 
                             ViewVariablesOrEmpty?
                             NamedSubViewDecl+ names
                             TransformDecl
                         "end view"
    | view: ModelAnnotation? ViewDecl
    | viewWithCTE: ModelAnnotation? SubViewAsCTE ViewDecl
    | transformDef: ModelAnnotation? TransformDecl
;
  

syntax SubViewAsCTE = subViewAsCTE: "subview" "(" ViewDecl+ ")";

 syntax NamedSubViewDecl
    = namedSubViewDecl: "(" SubViewDecl ")" MandatoryAlias
 ;

 syntax IfExists
   = ifExists: "@ifExists"
 ;

 syntax Temporal
   = temporal: "@temporal"
 ; 
  
syntax Drop
  = drop: "@drop"
  | dropIfExist: "@dropIfExist"
;

syntax Alias 
 =  \alias: "as" Id name
;

syntax QualifiedIdentifier
  = qualifiedIdentifier: {Identifier "."}+ ids
;

syntax Identifier
  = varRefName: "${" OID name "}"
  | regularIdentifier: OID name
  | quotedIdentifier: "`" OID name "`"
;
  
syntax VariableIdentifier
  = variableIdentifier: {IdentifierVar "."}+ ids
;

syntax IdentifierVar
  = identifierVar: VID
;

syntax Identification
  = identification: Id name
;


syntax ViewDecl 
  = viewFromTransform: IfNotExists? Drop? Temporal?
                        "view" NameOrWildcard "on" 
                           Distinct? ViewNameOrWildcard
                          TransformWithFile
                            "attributes"
                               TransformAttributes
                               FilterOrEmpty?
                               GroupingOrEmpty?
                               OrderByClauseOpt?
                               JoinConditions? 
                        "end" "view"

    | viewDecl: IfNotExists? Drop? Temporal? 
                "view" NameOrTemplate "on" 
                   Distinct? ViewNameOrWildcard MixinsOrEmpty?
                  TranspositionFunction?
                  ViewVariablesOrEmpty?
                  SubViewsOrEmpty?
                  "attributes"
                     ViewField+
                     FilterOrEmpty?
                     GroupingOrEmpty?
                     OrderByClauseOpt?
                     JoinConditions? 
                  "end" "view" 
;

syntax TransformWithFile
  =  transformWithFile: "transform""(" {QualifiedIdentifier ","}+ qid ")" "with" StringLiteral
;


syntax NameOrWildcard 
  = noWildcardOrName: "_"
  | wildcardOrName: Id name;
   

syntax ViewVariablesOrEmpty
  = variables: 
       "variables"
          ViewBinding+ views
;

syntax ViewBinding
  = viewBinding: QID oname ":" Type ty
  | viewBindingInit: QID oname ":" Type "=" Expr e
  | viewBindingInferredInit: QID name "=" Expr e
;


syntax FilterOrEmpty 
  = \filter: "filter"
       Expr e
;

syntax ViewRelationshipType
  = union: "union" 
    | intersect: "intersect" 
    | unionAll: "union" "all"
;


syntax SubViewDecl
  = left nestedSubViewDecl:  
     SubViewDecl
       ViewRelationshipType
     SubViewDecl
  | subViewDecl: "view" "_"  "on" 
                    Distinct? ViewNameOrWildcard?
                  "attributes"
                     ViewField+
                     FilterOrEmpty?
                     GroupingOrEmpty?
                     OrderByClauseOpt?
                     JoinConditions? joinCond
                  "end" "view"
;
  
syntax SubViewsOrEmpty
  = subViews: 
     "views"
       ViewDecl+ views
;


syntax Distinct = 
  distinct: "distinct"
;

syntax ViewNameOrWildcard
 = namedStructExp: "named_struct" "("NamedStructEntry+  entries")" Alias? al
   | referenceName: "${" Id name "}" "." Id name Alias? al
   | templatedView: "${" QualifiedNameOrShortName qname "}"
   | parentView: ViewDecl
   | wildcard:  "(" SubViewDecl ")"
   | wildcardWithAlias:  "(" SubViewDecl ")" Alias
   | name: QualifiedNameOrShortName Alias? al
;

syntax NamedStructEntry
   = namedStructEntry: Identifier name "," Expr e
;


syntax NameOrTemplate
  = templatedName:  "${" Id name "}"
    | viewName: Id name
;

syntax TranspositionFunction 
  = pivot: "pivot" 
              "attributes"
                  PivotExpression* el
               "for" Id name "in" 
                  PivotAttribute* el

  | unpivot: "unpivot" IncludeNulls?
      "for" Id name "in"
         UnpivotAttribute
      Unpivot

  | flatmap: "flatmap" Id name "(" {Id ", "}+ params ")" FilterOrEmpty? 
  | flatten: "flatten into" "(" {Id ", "}+ params ")" Expr e
;

syntax IncludeNulls
  = includeNulls: "include nulls"
;

syntax Unpivot
  = unpivotChild: 
     "for" Id name "in"
       UnpivotAttribute
;

syntax PivotAttribute 
  = pivotAttribute: PivotColumn pc "as" "(" {PivotElement ","}* el")"
;

syntax UnpivotAttribute 
  = unpivotAttribute: "(" Expr e ")" PivotAlias p
;

syntax PivotExpression 
  = pivotExpression: Id name ":" Type t "=" Expr e
  | inferredPivotValue: Id name "=" Expr e
;

syntax PivotElement 
  = pivotElement: Id name Alias? a
;

syntax PivotColumn 
  = mapAlias: StringLiteral
  | pivotColumn: Id name
;

syntax PivotAlias 
  = mapAlias: Id name "as" Id k "," Id v
  | listAlias: Id name "as" Id l
;
 
syntax MandatoryAlias 
  = mandatoryAlias: "as" Id name
;

syntax GroupingOrEmpty
  = grouping: GroupByClauseOpt g HavingClauseOpt? h;

syntax GroupByClauseOpt
  = groupby: "group by" {Expr ","}* el;





syntax HavingClauseOpt
  = havingClause: "having" Expr e
;

syntax ViewOrId 
  = fromView: ViewDecl v
  | fromId: OID name
;

syntax MixinsOrEmpty
   = mixins: "with" {Trait ","}+ t
;
  
syntax Trait 
  = trait: Id name
;

syntax TransformAttribute
  = typedTransformAttribute: OID name ":" Type t
  | transformAttribute: OID oname
;

syntax TransformAttributes
    = transformAttributes:
        TransformAttribute+ attrs
;

syntax ViewField
  = starAttribute: "*" 
  | starAttributeWithQID: QID name ".*"
  | derivedAttribute: OID oname ":" Type ty "=" Expr e
  | inferredDerivedAttribute: OID oname "=" Expr e
  | viewAttribute: OID oname "=" "("SubViewDecl ")"
  | viewfieldqname: QualifiedNameOrShortName
  | BlackList
;

syntax Projection 
  =  fromTemplateFromTemplate: "${" OID name "}"
  | sProjection: "*" BlackList?
  | qProject: OID qname ".*" BlackList?
;

syntax QualifiedNameOrShortName  
   = sName: OID name
   | qName: OID name "." OID projection
;

syntax BlackList 
   = blackList: "except" {QID ","}+ 
;

syntax ViewOption
   = leftJoinOption: SubViewDecl
   | joinOption: SubViewDecl "for" "join"
;

syntax JoinForLeftOrOpposite 
   = forJoin: "join" 
   | forLeft: "left join"
;


syntax TransformDecl
  = createAction: 
    "@create"
      "transform" NameOrVariableRef name Distinct? "with" ViewNameOrWildcard viewWild
        "attributes"
          TAttribute* entries
        TPartition? tp
        ConstraintsOrEmpty? constr
        FilterOrEmpty? filterEty
        GroupingOrEmpty? grpEty
        OrderByClauseOpt? orderOpt
        JoinConditions? joinCond
      "end" "transform"

  | updateAction:
    "@update" IfNotExists?
     "transform" NameOrVariableRef name Distinct? "with" ViewNameOrWildcard viewWild
       "attributes"
          TAttribute+ entries
      TPartition? tp
      ConstraintsOrEmpty? constr
      FilterOrEmpty? filterEty
      GroupingOrEmpty? grpEty
      OrderByClauseOpt? orderOpt
      JoinConditions? joinCond
     "end" "transform"

  | directoryUpdateAction: 
    "@update" IfNotExists?
      "transform" LocalDirectory lclDir Expr e
       "attributes"
          TAttribute+ entries
      TPartition? tp
      ConstraintsOrEmpty? constr
      JoinConditions? joinCond
      "end" "transform"

  | directoryCreateAction:
    "@create" 
      "transform" LocalDirectory lclDir Expr e
       "attributes"
          TAttribute+ entries
      TPartition? tp
      ConstraintsOrEmpty? constr
      JoinConditions? joinCond
      "end" "transform"

  |renameEnt:RenameEntity
  | addPart:AddPartition
  | dropPart: DropPartition
  | renamePart: RenamePartition
;



syntax LocalDirectory
  = local: "Local Directory"
  | nonLocal: "Directory"
;

syntax RenameEntity 
  = renameEntity: "transform" QualifiedIdentifier q1 "rename" QualifiedIdentifier q2
;

syntax AddPartition 
  = addPartition: IfNotExists? "transform" QualifiedIdentifier q "add" {PartitionClauseWithLocation ","}+ entries
;
  
syntax RenamePartition 
  = renamePartition: "transform" QualifiedIdentifier q "rename" PartitionClause p "to" PartitionClause pc
;

syntax DropPartition 
  = dropPartition: IgnoreProtection i
    Drop d Purge? p "transform" QualifiedIdentifier q "drop" {PartitionClause ","}+ entries
;

syntax TPartitionValue
  = tPartitionValue: "=" Expr e
;

syntax TPartition
  = tPartition: "partition" "(" {TPartitionOn ", "}+ ")"
;

syntax TPartitionOn
  = tPartitionOn: AID name TPartitionValue p
;

syntax IgnoreProtection
  = ignoreProtection: "@ignoreProtection"
;

syntax ConstraintsOrEmpty
  = transformConstraints: 
      "constraints"
          Expr e
;

syntax TAttribute
  = starTAttribute: "*" 
  | starTAttributeWithQID: OID name ".*"
  | derivedTAttribute: OID oname ":" Type ty "=" Expr e
  | inferredDerivedTAttribute: OID oname "=" Expr e
  | viewTAttribute: OID oname "=" "("SubViewDecl ")"
  | tattributeqname: QualifiedNameOrShortName
  | BlackList
;


syntax Purge
  = purge: "@purge"
;

syntax JoinType
   = \join: "join"
   | inner: "inner" "join"
   | leftOuterJoin: "left" "outer" "join"
   | rightJoin : "right" "join"
   | rightOuterJoin: "right" "outer" "join"
   | fullJoin: "full" "join"
   | fullOuterJoin: "full" "outer" "join"
   | crossJoin: "cross" "join"
   | semiJoin: "semi" "join"
   | leftSemiJoin: "left" "semi" "join" 
;

syntax JoinCondition
  = joinCondition: JoinType jt NameOrVariableRef name Alias? a OnCondition? cond
  | viewJoinCondition: JoinType jt "(" SubViewDecl sub ")" MandatoryAlias m "on" "("Expr ")"
;

syntax OnCondition
  = onCondition: "on" Expr e
;

syntax JoinConditions
  = joinConditions: JoinCondition+ conds
;

syntax NameOrVariableRef
  = refName: "${" AID name "}" {Path " "}* paths
  | tName: AID name {Path " "}* paths
;

syntax Path
  = path: "." AID name
;


syntax PartitionClause
  = partitionClause: "partition" "(" {PartitionPart ","}+ entries")"
;

syntax PartitionPart
  = partitionPart: QID name PartitionPartValue v
;

syntax PartitionPartWithOptionalValue
  = partitionPartWithOptionalValue: QID name PartitionPartValue v
  |  partitionPartWithOptionalValue2: QID name
;

syntax PartitionPartValue
  = partitionPartValue: "=" Expr e
;

syntax PartitionWithOptionValueClause
 = partitionWithOptionValueClause: "partition" "(" {PartitionPartWithOptionalValue ","}+ entries")"
;

syntax PartitionClauseWithLocation
  = partitionClauseWithLocation: PartitionClause PLocation
;

syntax PLocation
  = pLocation: "location" "(" StringLiteral ")"
;

syntax IfNotExists 
  =  ifNotExists: "@ifNotExists"
;
