module lang::ptl::grammar::Macros

extend lang::ptl::grammar::Declarations;

syntax Declaration
  = macrodeclaration: MacroDecl
  | macrocall: MacroCall
;

syntax MacroDecl
  = bind:"{%""let" Id name "=" Expr"%}"
  | macroDef: MacroDef
  | macroConditional: MacroIf MacroElseIf* MacroElse?
  | macroForLoop: MacroFor
;

syntax MacroIf
  = macroIf: "{%" "if" Expr "%}"  "{" Declaration* "}"
;

syntax MacroElse
  = macroElse: "{%" "else" "%}" "{" Declaration* "}"
;

syntax MacroElseIf
  = macroElseIf: "{%" "else" "if" Expr "%}" "{" Declaration* "}"
;

syntax MacroFor
  = macroFor: "{%" "for" Id name "in" Expr "%}" "{" Declaration* "}"
;

syntax MacroDef
    = macroDefSimple: "defmacro" Id name "(" {MParam ","}* ")"  Declaration* "end" "defmacro"
    | macroDefMixed: "defmacro" Id name "(" {MParam ","}+ "," {KWParam ","}+ ")" Declaration* "end" "defmacro"
    | macroDefKWOnly: "defmacro" Id name "(" {KWParam ","}+ ")" Declaration* "end" "defmacro"
    ;

syntax MParam = mParam: Id name;

syntax KWParam = keywordParam: Id name "=" Expr;


syntax Expr
  = macroExpr: MacroInterpolation
;

syntax MacroInterpolation 
  = macroInterpolation: "#{" Id macroName "}"
;

syntax Entity
  = @Foldable macroEntity:
      PartitionedBy?
      ClusteredBy?
      RowFormat?
      StoredAs?
      Location?
      TableProperties? 
      MaterializedAs?
      Temporal?
      External?
      IfNotExists?
      Drop?
      "entity" MacroInterpolation name   Field* fields "end" "entity"
  | @Foldable macroEntityExtends: 
      Temporal?
      External?
      IfNotExists?
      Drop?
      "entity" MacroInterpolation name "extends" MacroInterpolation base   Field* fields "end" "entity"
;

syntax View
 = macroView:  IfNotExists? Drop? Temporal? 
                "view" MacroInterpolation macroName "on" 
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

syntax Field
  = macroField: MacroInterpolation fieldName ":" Type t Constraints? constraint
;

syntax Alias
  = macroAlias: "as" MacroInterpolation
;

syntax QualifiedIdentifier
  = macroQualifiedIdentifier: MacroInterpolation  
;

syntax ViewNameOrWildcard
  = macroViewNameOrWildcard: MacroInterpolation
;

syntax QualifiedNameOrShortName
  = macroQualifiedNameOrShortName: MacroInterpolation
;

syntax ViewField
  = macroViewField: MacroInterpolation macroInterpolation
;

syntax MacroCall
  = macroCallSimple: Id macroName "!" "(" {Expr ","}* ")"
;