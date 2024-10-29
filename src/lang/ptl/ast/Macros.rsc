module lang::ptl::ast::Macros

extend lang::ptl::ast::Annotations;

data Declaration
    = macrodeclaration(MacroDecl macroDecl)
    | macrocall(MacroCall macroCall)
    | macroEntity(
        list[PartitionedBy] prtBy
        , list[ClusteredBy] clstBy
        , list[RowFormat] rowFrmt
        , list[StoredAs] storedAs
        , list[Location] location
        , list[TableProperties] tblPropties
        , list[MaterializedAs] materializedAs
        , list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , MacroInterpolation macroName
        , list[Field] fields)
    | macroEntityExtends(
        list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , MacroInterpolation macroName
        , MacroInterpolation base
        , list[Field] fields)
    | macroView(list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , MacroInterpolation macroName 
        , list[Distinct] distinct 
        , ViewNameOrWildcard viewNameOrWildcard
        , list[MixinsOrEmpty] mixinsOrEmpty
        , list[TranspositionFunction] transpositionFunction
        , list[ViewVariablesOrEmpty] viewVarOrEmpty
        , list[SubViewsOrEmpty] subViewsOrEmpty
        , list[ViewField] viewFields
        , list[FilterOrEmpty] filterOrEmpty
        , list[GroupingOrEmpty] groupingOrEmpty
        , list[OrderByClauseOpt] orderByClsOpt
        , list[JoinConditions] joinConditions)
    ;

data MacroDecl
    = bind(str name, Expr expr)
    | macroDef(MacroDef macroDef)
    | macroConditional(MacroIf macroIf, list[MacroElseIf] macroElseIf, list[MacroElse] macroElse)
    | macroForLoop(MacroFor macroFor)
    ;

data MacroIf
    = macroIf(Expr expr, list[Declaration] decls)
    ;

data MacroElse
    = macroElse(list[Declaration] decls)
    ;

data MacroElseIf
    = macroElseIf(Expr expr, list[Declaration] decls)
    ;

data MacroFor
    = macroFor(str name, Expr expr, list[Declaration] decls)
    ;

data MacroDef
    = macroDefSimple(str name, list[MParam] mparams, list[Declaration] decls)
    | macroDefMixed(str name, list[MParam] mparams, list[KWParam] kwparams, list[Declaration] decls)
    | macroDefKWOnly(str name, list[KWParam] kwparams, list[Declaration] decls)
;

data MacroCall
    = macroCallSimple(str name, list[Expr] args)
;

data MParam
    = mParam(str name)
    ;


data Expr
    = macroExpr(MacroInterpolation macroInterpolation)
    ;

data Alias
    = macroAlias(MacroInterpolation macroInterpolation)
    ;

data QualifiedIdentifier
    = macroQualifiedIdentifier(MacroInterpolation macroInterpolation)
    ;

data ViewNameOrWildcard
    = macroViewNameOrWildcard(MacroInterpolation macroInterpolation)
    ;

data MacroInterpolation
    = macroInterpolation(str macroName)
    ;

data QualifiedNameOrShortName
    = macroQualifiedNameOrShortName(MacroInterpolation macroInterpolation)
    ;

data Field
    = macroField(MacroInterpolation fieldName, Type t, list[Constraints] constraint)
    ;

data ViewField
    = macroViewField(MacroInterpolation macroInterpolation)
    ;