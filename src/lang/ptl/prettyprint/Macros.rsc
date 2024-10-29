module lang::ptl::prettyprint::Macros

import List;
import String;

extend lang::ptl::prettyprint::Annotations;

public str toString(Declaration::macrodeclaration(MacroDecl macroDecl)) = "<toString(macroDecl)>";
public str toString(Declaration::macrocall(MacroCall macroCall)) = "<toString(macroCall)>";

public str toString(macroEntity(list[PartitionedBy] prtBy
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
        , list[Field] fields)){

    return trim("<intercalate("",[toString(prt)|prt<-prtBy])> <intercalate("",["\n<toString(clst)>"|clst<-clstBy])> <intercalate(" ",["\n<toString(rf.fmtType)>"|rf<-rowFrmt])> <intercalate("",["\n<toString(sa)>"|sa<-storedAs])>
        '<intercalate("\n ",["@location(<l.locationEntry>)"|l<-location])>
        '<intercalate("\n ",[toString(tp)|tp<-tblPropties])>
        '<intercalate("\n ",["@tableAs(<mta.identifier>)"|mta<-materializedAs])>
        '<intercalate("",["@temporal"|_<-temporal])>
        '<intercalate("",["@extenal"|_<-external])>
        '<intercalate("",["@ifNotExists"|_<-ifNotExists])>
        '<intercalate("",[toString(drp)| drp<-drop])>
        'entity <toString(macroName)> 
        '    <intercalate("\n",[toString(field)|field<-fields])>
        'end entity");
}

public str toString(macroEntityExtends(
        list[Temporal] temporal,
        list[External] ext,
        list[IfNotExists] ifNotExists,
        list[Drop] drop,
        MacroInterpolation macroName,
        MacroInterpolation base,
        list[Field] fields)){
            
    return "<intercalate("",["@temporal"|_<-temporal])>
        '<intercalate("",["@extenal"|_<-ext])>
        '<intercalate("",["@ifNotExists"|_<-ifNotExists])>
        '<intercalate("",[toString(drp)| drp<-drop])>
        '<toString(macroName)> extends <toString(base)> 
        '<intercalate("\n",[toString(field)|field<-fields])>
    end entity";
}

public str toString(MacroDecl macroDecl) {
    switch (macroDecl) {
        case bind(str name, Expr expr):{
            return "{% let <name> = <toString(expr)> %}";
        }
        case macroDef(MacroDef macroDef):{
            return "<toString(macroDef)>";
        }
        case macroConditional(MacroIf macroIf, list[MacroElseIf] macroElseIf, list[MacroElse] macroElse):{
            return "<toString(macroIf)> 
                '<intercalate("\n",[toString(elseIf)|elseIf<-macroElseIf])> 
                '<intercalate("\n",[toString(el)|el<-macroElse])>";
        }
        case macroForLoop(MacroFor macroFor):{
            return "<toString(macroFor)>";
        }
        default:
            throw ToStringException("message: Unable to resolve MacroDecl signature", macroDecl);
    }
}

public str toString(MacroIf macroIf) {
    return "{% if <toString(macroIf.expr)> %} { 
        '    <intercalate("",[toString(decl)|decl<-macroIf.decls])>
        '}";
}

public str toString(MacroElse macroElse) {
    return "{% else %} { 
        '    <intercalate("\n",[toString(decl)|decl<-macroElse.decls])> 
        '}";
}

public str toString(MacroElseIf macroElseIf) {
    return "{% else if <toString(macroElseIf.expr)> %} { 
        '    <intercalate("\n",[toString(decl)|decl<-macroElseIf.decls])>
        '}";
}

public str toString(MacroFor macroFor) {
    return "{% for <macroFor.name> in <toString(macroFor.expr)> %} { 
        '    <intercalate("\n",[toString(decl)|decl<-macroFor.decls])> 
        '}";
}

public str toString(MacroDef macroDef) {
    switch (macroDef) {
        case macroDefSimple(str name, list[MParam] mparams, list[Declaration] decls):
            return "defmacro <name>(<intercalate(",",[toString(param)|param<-mparams])>)
                '    <intercalate("",[toString(decl)|decl<-decls])> 
                'end defmacro";
        case macroDefMixed(str name, list[MParam] mparams, list[KWParam] kwparams, list[Declaration] decls):
            return "defmacro <name>(<intercalate(",",[toString(param)|param<-mparams])>, <intercalate(",",[toString(param)|param<-kwparams])>)
                '    <intercalate("",[toString(decl)|decl<-decls])> 
                'end defmacro";
        case macroDefKWOnly(str name, list[KWParam] kwparams, list[Declaration] decls):
            return "defmacro <name>(<intercalate(",",[toString(param)|param<-kwparams])>)
                '    <intercalate("",[toString(decl)|decl<-decls])> 
                'end defmacro";
        default:
            throw ToStringException("message: Unable to resolve MacroDef signature", macroDef);
    }
}

public str toString(MParam param) {
    return "<param.name>";
}

public str toString(KWParam param) {
    return "<param.name> = <toString(param.val)>";
}

public str toString(MacroInterpolation macroInterpolation) {
    return "#{<macroInterpolation.macroName>}";
}

public str toString(Expr::macroExpr(MacroInterpolation macroInterpolation)) = "<toString(macroInterpolation)>";

public str toString(Alias::macroAlias(MacroInterpolation macroInterpolation)) = "as <toString(macroInterpolation)>";

public str toString(QualifiedIdentifier::macroQualifiedIdentifier(MacroInterpolation macroInterpolation)) = "<toString(macroInterpolation)>";

public str toString(ViewNameOrWildcard::macroViewNameOrWildcard(MacroInterpolation macroInterpolation)) = "<toString(macroInterpolation)>";

public str toString(QualifiedNameOrShortName::macroQualifiedNameOrShortName(MacroInterpolation macroInterpolation)) = "<toString(macroInterpolation)>";

public str toString(Field::macroField(MacroInterpolation fieldName, Type t, list[Constraints] constraint)) = "<toString(fieldName)>: <toString(t)> <intercalate("",[toString(con)|con<-constraint])>";

public str toString(ViewField::macroViewField(MacroInterpolation macroInterpolation)) = "<toString(macroInterpolation)>";

public str toString(MacroCall macroCall) {
    switch (macroCall) {
        case macroCallSimple(str name, list[Expr] args):
            return "<name>!(<intercalate(",",[toString(arg)|arg<-args])>)";
        default:
            throw ToStringException("message: Unable to resolve MacroCall signature", macroDef);
    }
}