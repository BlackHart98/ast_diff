module lang::ptl::checker::Checker

import lang::ptl::grammar::Expressions;
import lang::ptl::grammar::Entity;
import lang::ptl::grammar::Struct;
import lang::ptl::grammar::Declarations;
import lang::ptl::grammar::PTL;
import IO;
import String;
import Prelude;
import List;
import Map;
 
extend analysis::typepal::TypePal;
extend analysis::typepal::TestFramework;


/***********
 *  Types  *
 ***********/

data AType
    = boolType()
    | intType()
    | strType()
    | floatType()
    | dateType()
    | datetimeType()
    | entityType(str name)
    | structType(str name)
    | mappingType(str name)
    | enumType(str name)
    | listType(AType t)
    | setType(AType t)
    | mapType(AType k, AType v)
    | tupleType(list[AType] ty)
    | nilType()
    | nullType()
    | moduleType()
    | funcType(AType argTypes, AType resType)
    | objectType()
    | viewType(str name)
    | IfNotExistsType()
    ;

// ---- isSubType ------------------------

bool isSubType(objectType(), _) = true;
bool isSubType(_, objectType()) = true;

bool isSubType(nullType(), _) = true;
bool isSubType(_, nullType()) = false;

bool isSubType(AType t1, AType t2) = true
	when t1 == t2;
default bool isSubType(AType _, AType _) = false;

bool isSubType(listType(AType t1), listType(AType t2)) = isSubType(t1, t2);
bool isSubType(atypeList(vs), atypeList(ws))
	= (true | isSubType(v, w) && it | <v,w> <- zip(vs, ws))
	when (size(vs) == size(ws));


bool isSubType (setType(AType elemType1), setType(AType elemType2)) = isSubType(elemType1, elemType2);
bool isSubType(atypeList(list[AType] elems1), atypeList(list[AType] elems2)) = size(elems1) == size(elems2) && all(int i <- index(elems1), isSubType(elems1[i], elems2[i]));

AType lub(AType t1, objectType()) = objectType();
AType lub(objecType(), AType t1) = objectType();

AType lub(listType(_), listType(objecType())) = objectType();
AType lub(listType(objecType()), listType(_)) = objectType();

AType lub(AType t1, AType t2) = t1
	when t1 == t2;

bool isSubType (objectType(), strType()) = true;
bool isSubType(objectType(), floatType()) = true;
bool isSubType(objectType(), dateType()) = true;
bool isSubType(objectType(), datetimeType()) = true;
bool isSubType(objectType(), nullType()) = true;
bool isSubType(boolType(), objectType()) = true;
bool isSubType(intType(), objectType()) = true;
bool isSubType(strType(), objectType()) = true;
bool isSubType(floatType(), objectType()) = true;
bool isSubType(dateType(), objectType()) = true;
bool isSubType(datetimeType(), objectType()) = true;
bool isSubType(nullType(), objectType()) = true;

bool isSubType(intType(), floatType()) = false;

default bool isSubType(AType atype1, AType atype2) = false;


// ----  IdRoles, PathLabels and AType ------------------- 
data IdRole
    = fieldId()
    | entityId()
    | structId()
    | enumId()
    | moduleId()
    | funcId()
    | propertyId()
    | mappingId()
    | viewId()
;

data EntityInfo
    = entityInfo(EntityId name, EntityId base)
    | entityInfo(EntityId name)
    | mappingInfo(EntityId name, EntityId entity)
;

data PropertyInfo
    = propertyInfo(Id name)
;
    

data PathRole
    = importPath()
    | extendsPath()
;

data ScopeRole
    = entityScope()
    | mappingScope()
    | propertyScope()
;

str prettyAType(boolType()) = "Bool";
str prettyAType(intType()) = "Int";
str prettyAType(strType()) = "Str";
str prettyAType(floatType()) = "Float";
str prettyAType(dateType()) = "Date";
str prettyAType(datetimeType()) = "Datetime";
str prettyAType(objectType()) = "Object";
str prettyAType(entityType(name)) = "entity <name>";
str prettyAType(structType(name)) = "struct <name>";
str prettyAType(mappingType(name)) = "mapping <name>";
str prettyAType(moduleType()) = "moduleType()";
str prettyAType(enumType(name)) = "enum <name>";
str prettyAType(listType(AType t)) = "List[<prettyAType(t)>]";
str prettyAType(setType(AType t)) = "Set[<prettyAType(t)>]";
str prettyAType(mapType(AType k, AType v)) = "Map[<prettyAType(k)>, <prettyAType(v)>]";
str prettyAType(funcType(AType argTypes, AType resType)) = "function (<prettyAType(argTypes)>) : <prettyAType(resType)>";
str prettyAType(tupleType(list[AType] ty)) = "Tuple[<intercalate(",", [prettyAType(a) | a <- ty])>]";
str prettyAType(viewType(str name)) = "viewType(<name>)";
str prettyAType(IfNotExistsType()) = "IfNotExistsType";


map[str, AType] typesMap = (
    "varchar" : strType(),
    "date" : dateType(),
    "bool" : boolType(),
    "decimal" : floatType()
);


private str key_extendsRelation = "extends-relation";



data PathConfig = pathConfig(list[loc] srcs = [], list[loc] libs = []);

PathConfig pathConfig(loc _) {
   return pathConfig(srcs = [|project://ptl/src/lang/ptl/examples|]);
}

private str __MODULES_IMPORT_QUEUE = "__modulesImportQueue";

str getFileName((ModuleId) `<{Id "::"}+ moduleName>`) = replaceAll("<moduleName>.ptl", "::", "/");

tuple[bool, loc] lookupModule(str name, PathConfig pcfg) {
    for (s <- pcfg.srcs + pcfg.libs) {
        result = (s + replaceAll(name, "::", "/"))[extension = "ptl"];
        println(result);
        if (exists(result)) {
        	return <true, result>;
        }
    }
    return <false, |invalid:///|>;
}

void handleImports(Collector c, Tree root, PathConfig pcfg) {
   set[str] imported = {};
   while (list[str] modulesToImport := c.getStack(__MODULES_IMPORT_QUEUE) && modulesToImport != []) {
    	c.clearStack(__MODULES_IMPORT_QUEUE);
        for (m <- modulesToImport, m notin imported) {
            if (<true, l> := lookupModule(m, pcfg)) {
                collect(parse(#start[Program], l).top, c);
            }
            else {
                c.report(error(root, "Cannot find module %v in %v or %v", m, pcfg.srcs, pcfg.libs));
            }
            imported += m; 
        }
    }
}

tuple[list[str] typeNames, set[IdRole] idRoles] modulesGetTypeNameAndRole(entityType(str name)) = <[name], {entityId(), enumId(), structId()}>;
default tuple[list[str] typeNames, set[IdRole] idRoles] modulesGetTypeNameAndRole(AType t) = <[], {}>;

private TypePalConfig getModulesConfig(bool debug = false) = tconfig(
    getTypeNamesAndRole = modulesGetTypeNameAndRole,
    verbose=debug, 
    logTModel = debug, 
    logAttempts = debug, 
    logSolverIterations= debug, 
    logSolverSteps = debug,
    isSubType = isSubType
);


//------------------- Modules -------------------------

void collect(current: (Program) `module <ModuleId moduleName>  <Import* imports> <Declaration* decls>`, Collector c){
    c.define("<moduleName>", moduleId(), current, defType(moduleType())); 
 	c.enterScope(current); {
 		collect(imports, c);
    	collect(decls, c);
    }
    c.leaveScope(current);
}

void collect(current:(Import) `import <ModuleId moduleName>`, Collector c) {
    c.addPathToDef(moduleName, {moduleId()}, importPath());
    c.push(__MODULES_IMPORT_QUEUE, "<moduleName>");
}

void collect(current: (Declaration) 
    `<IfNotExists? ifnotEx> <Drop? drop> <Temporal? temprl> view <QualifiedIdentifier qid> <ViewVariablesOrEmpty? viewvars> ( <SubViewDecl subviewdec> ) end view`, Collector c){
    c.define("<qid>", viewId(), current, defType(viewType("<qid>")));
    c.enterScope(current);
        collect(ifnotEx, drop, temprl, viewvars, subviewdec, c);
    c.leaveScope(current);
}

void collect(current: (Declaration) 
    `<IfNotExists? ifnotEx> <Drop? drop> <Temporal? temprl> view <QualifiedIdentifier qid> with <ViewVariablesOrEmpty? viewvars> <NamedSubViewDecl+ names> <SubViewDecl subviewdec> end view`, Collector c){
    define("<qid>", viewId(), current, defType(viewType("<qid>")));
    c.enterScope(current);
        collect(ifnotEx, drop, temprl, names, viewvars, subviewdec, c);
    c.leaveScope(current);
}

void collect(current: (Declaration) 
    `<IfNotExists? ifnotEx> <Drop? drop> <Temporal? temprl> view <QualifiedIdentifier qid> with <ViewVariablesOrEmpty? viewvars> <NamedSubViewDecl+ names> <TransformDecl transformdec> end view`, Collector c){
    define("<qid>", viewId(), current, defType(viewType("<qid>")));
    c.enterScope(current);
        collect(ifnotEx, drop, temprl, names, viewvars, transformdec, c);
    c.leaveScope(current);
}

void collect(current: (Declaration) 
    `<IfNotExists? ifnotEx> <Drop? drop> <Temporal? temprl> view with <ViewVariablesOrEmpty? viewvars> <NamedSubViewDecl+ names> <TransformDecl transformdec> end view`, Collector c){
    collect(ifnotEx, drop, temprl, viewvars, names, transformdec, c);
}

void collect(current: (Declaration) `<ViewDecl viewdec>`, Collector c){
    collect(viewdec, c);
}

void collect(current: (Declaration) `<TransformDecl transformdec>`, Collector c){
    collect(transformdec, c);
}

void collect(current: (IfNotExists) `@ifNotExists`, Collector c){
    c.fact(current, IfNotExistsType());
}

void collect(current: (TransformDecl) 
    `@create transform <NameOrVariableRef name> <Distinct? distinct> with <ViewNameOrWildcard viewWild> attributes <TAttribute+ entries> <TPartition? tp> <ConstraintsOrEmpty? constr> <FilterOrEmpty? filterEty> <GroupingOrEmpty? grpEty> <OrderByClauseOpt? orderOpt> <JoinConditions? joinCond> end transform`, Collector c){
    c.enterScope(current);
        collect(name, viewWild, entries);
}

void collect(current: (TransformDecl) `transform <QualifiedIdentifier q1> rename <QualifiedIdentifier q2>`, Collector c){
    c.define("<q1>", entityId(), current, defType(entityType("<q1>")));
    c.define("<q2>", entityId(), current, defType(entityType("<q2>")));
}

// ---- identifier ------------------
void collect(current: (Expr) `<{Id "."}+ qName>`,  Collector c){
     c.useQualified(qName, {variableId(), fieldId()});
}

void collect(current: (Expr) `<Id arg> =\> <Expr exp>`, Collector c){
    c.calculate("lambda", current, [arg, exp], AType (Solver s) {
        argType = s.getType(exp);
        c.enterScope(current);
            c.define(arg, variableId(), current, defType(argType));
            collect(exp, c);
        c.leaveScope(current);
        return funcType([argType], s.getType(exp));
    });
}

void collect(current: (ColumnType) `varchar (<Expr e >)`, Collector c){
     c.calculate("varchar", current, [e],
        AType(Solver s) {
            ty = s.getType(e);
            s.requireEqual(ty, intType(), error(e, "Parameter should have type `Int`, found %t", ty));
            return s.getType(e);
        });
    collect(e, c);
} 

void collect(current: (ColumnType) `int`, Collector c){
   c.fact(current, intType());
} 

void collect(current: (ColumnType) `date`, Collector c){
   c.fact(current, dateType());
} 

void collect(current: (ColumnType) `decimal(<Expr e1> , <Expr e2>)`, Collector c){
   c.calculate("decimal", current, [e1, e2],
        AType(Solver s) {
            ty1 = s.getType(e1);
            ty2 = s.getType(e2);
            s.requireEqual(ty1, intType(), error(e1, "Parameter should have type `Int`, found %t", ty1));
            s.requireEqual(ty2, intType(), error(e2, "Parameter should have type `Int`, found %t", ty2));
            return floatType();
        });
    collect(e1, e2, c);
} 


void collect(current: (PropertyType) `. columnName ( <Expr e> )`, Collector c){
     c.calculate("columnName", current, [e],
        AType(Solver s) {
            ty = s.getType(e);
            s.requireEqual(ty, strType(), error(e, "Parameter should have type `Str`, found %t", ty));
            return s.getType(e);
        });
    collect(e, c);
} 

void collect(current: (PropertyType) `. columnOrder ( <Expr e> )`, Collector c){
     c.calculate("columnOrder", current, [e],
        AType(Solver s) {
            ty = s.getType(e);
            s.requireEqual(ty, intType(), error(e, "Parameter should have type `Int`, found %t", ty));
            return s.getType(e);
        });
    collect(e, c);
} 

void collect(current: (PropertyType) `. defaultValue ( <Expr e> )`, Collector c){
    collect(e, c);
} 


void collect(current: (PropertyType) `. columnDoc ( <Expr e> )`, Collector c){
     c.calculate("columnDoc", current, [e],
        AType (Solver s) {
            ty = s.getType(e);
            s.requireEqual(ty, strType(), error(e, "Parameter should have type `Str` found %t", ty));
            return s.getType(e);
        });
    collect(e, c);
} 

void collect(current: (PropertyType) `. columnType ( <ColumnType ct> )`, Collector c){
    collect(ct, c);
} 

void collect(current: (PropertyType) `. isUnique ( <Expr e> )`, Collector c){
    c.calculate("isUnique", current, [e],
        AType (Solver s) {
            ty = s.getType(e);
            s.requireEqual(ty, boolType(), error(e, "Parameter should have type `Bool`, found %t", ty));
            return s.getType(e);
        });
    collect(e, c);
} 

void collect(current: (PropertyType) `. isNullable(<Expr e>)`, Collector c){
     c.calculate("isNullable", current, [e],
        AType (Solver s) {
            ty = s.getType(e);
            s.requireEqual(ty, boolType(), error(e, "Parameter should have type `Bool`, found %t", ty));
            return s.getType(e);
        });
    collect(e, c);
} 


// ---- collect constraints for Expr ------------------------------------------

void collect(current: (Expr) `<BooleanLiteral _>`, Collector c){
    c.fact(current, boolType());
}

void collect(current: (Expr) `<Int _>`, Collector c){
    c.fact(current, intType());
}

void collect(current: (Expr) `<StringConstant _>`, Collector c){
     c.fact(current, strType());
}

void collect(current: (Expr) `<DateTimeLiteral dt>`, Collector c){
     c.fact(current, datetimeType());
}

void collect(current: (Expr) `<UNSIGNEDDECIMAL dt>`, Collector c){
     c.fact(current, floatType());
}

void collect(current: (Expr) `( <Expr e> )`, Collector c){
    c.fact(current, e);
    collect(e, c);
}


//----------------- Types --------------------
void collect(current:(Type) `Int`, Collector c){
    c.fact(current, intType());
}

void collect(current:(Type) `Str`, Collector c){
   c.fact(current, strType());
}

void collect(current:(Type) `Float`, Collector c){
    c.fact(current, floatType());
}

void collect(current:(Type) `Datetime`, Collector c){
    c.fact(current, datetimeType());
}

void collect(current:(Type) `Date`, Collector c){
    c.fact(current, dateType());
}

void collect(current:(Type) `Bool`, Collector c){
    c.fact(current, boolType());
}

void collect(current:(Type) `Object`, Collector c){
    c.fact(current, objectType());
}

void collect(current:(Type) `List[<Type t>]`, Collector c){
     c.calculate("list type", current, [t],
        AType(Solver s) {
            return listType(s.getType(t));
        });
    collect(t, c);
}

void collect(current:(Type) `Set[<Type t>]`, Collector c){
     c.calculate("set type", current, [t],
        AType(Solver s) {
            return setType(s.getType(t));
        });
    collect(t, c);
}

void collect(current:(Type) `Map[<Type k>, <Type v>]`, Collector c){
     c.calculate("map type", current, [k, v],
        AType(Solver s) {
            return mapType(s.getType(k), s.getType(v));
        });
    collect(k, v, c);
}

void collect(current:(Type)`<Id name>`, Collector c) {
    c.use(current, {entityId(), enumId(), structId()});
}

void collect(current:(Reference)`<Id name>`, Collector c) {
    c.use(current, {entityId()});
}


// --------------- Arithmetic ------------------------
void collect(current:(Expr)`<Expr lhs> * <Expr rhs>`, Collector c) {
     c.calculate("Mul", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [intType(), intType()] : return intType();
            case [floatType(), floatType()] : return floatType();
            case [intType(), floatType()] : return floatType();
            case [floatType(), intType()] : return floatType();
            default : s.report(error(current, "%q requires two compactibles types but found  %t and %t", "*", lhs, rhs));
        }
    }); 
    collect(lhs, rhs, c);
}

void collect(current:(Expr)`<Expr lhs> / <Expr rhs>`, Collector c) {
    c.calculate("Div", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [intType(), intType()] : return intType();
            case [floatType(), floatType()] : return floatType();
            default : s.report(error(current, "%q requires two compactibles types but found  %t and %t", "/", lhs, rhs));
        }
    }); 
    collect(lhs, rhs, c);
}

void collect(current:(Expr)`<Expr lhs> + <Expr rhs>`, Collector c) {
    c.calculate("Add", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [intType(), intType()] : return intType();
            case [strType(), strType()] : return strType();
            default : s.report(error(current, "%q requires two compactibles types but found  %t and %t", "+", lhs, rhs));
        }
    }); 
    collect(lhs, rhs, c);
}

void collect(current:(Expr)`<Expr lhs> - <Expr rhs>`, Collector c) {
     c.calculate("Sub", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [intType(), intType()] : return intType();
            case [floatType(), floatType()] : return floatType();
            case [intType(), floatType()] : return floatType();
            case [floatType(), intType()] : return floatType();
            default : s.report(error(current, "%q requires two compactibles types but found  %t and %t", "-", lhs, rhs));
        }
    }); 
    collect(lhs, rhs, c);
}

void collect(current:(Expr)`<Expr lhs> % <Expr rhs>`, Collector c) {
    c.calculate("mod", current, [lhs, rhs], 
        AType(Solver s) {
          switch([s.getType(lhs), s.getType(rhs)]){
            case [intType(), intType()] : return intType();
            default : s.report(error(current, "%q requires two Int types but found  %t and %t", "mod", lhs, rhs));
        }
        });  
     collect(lhs, rhs, c);
}

void collect(current:(Expr)`<Expr lhs> == <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("Eq", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [t1, t1] : return boolType();
            default : s.report(error(current, "%q requires two comparable types but found  %t and %t", "==", lhs, rhs));
        }
    }); 
}

void collect(current:(Expr)`<Expr lhs> \<\> <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("Neq", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [t1, t1] : return boolType();
            default : s.report(error(current, "%q requires two comparable types but found  %t and %t", "==", lhs, rhs));
        }
    }); 
}

void collect(current:(Expr)`<Expr lhs> \>= <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("Geq", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [intType(), intType()] : return boolType();
            case [floatType(), floatType()] : return boolType();
            case [dateType(), dateType()] : return boolType();
            case [datetimeType(), datetimeType()] : return boolType();
            default : s.report(error(current, "%q requires two comparable types but found  %t and %t", "\>= ", lhs, rhs));
        }
    }); 
}

void collect(current:(Expr)`<Expr lhs> \<= <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("Leq", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [intType(), intType()] : return boolType();
            case [floatType(), floatType()] : return boolType();
            case [dateType(), dateType()] : return boolType();
            case [datetimeType(), datetimeType()] : return boolType();
            default : s.report(error(current, "%q requires two comparable types but found  %t and %t", "\<=", lhs, rhs));
        }
    }); 
}

void collect(current:(Expr)`<Expr lhs> and <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("and", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [boolType(), boolType()] : return boolType();
            default : s.report(error(current, "`and` requires two Bool but found  %t and %t", lhs, rhs));

        }
    }); 
}

void collect(current:(Expr)`<Expr lhs> or <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("Or", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [boolType(), boolType()] : return boolType();
            default : s.report(error(current, "Or requires two Bool but found  %t and %t", lhs, rhs));
        }
    }); 
}

void collect(current:(Expr)`<Expr e1> between <Expr e2> and <Expr e3>`, Collector c) {
    collect(e1, e2, e3, c);
    c.calculate("between", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(e1), s.getType(e2), s.getType(e3)]){
            case [dateType(_), dateType(), dateType()] : return boolType();
            case [datetimeType(_), datetimeType(), datetimeType()] : return boolType();
            case [floatType(_), floatType(), floatType()] : return boolType();
            case [intType(_), intType(), intType()] : return boolType();
            default : s.report(error(current, "%q requires three comparable types but found %t, %t and %t", "between", e1, e2, e3));
        }
    }); 
}


void collect(current:(Expr)`<Expr lhs> like <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("like", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [strType(), strType()] : return boolType();
            default : s.report(error(current, "like requires two Str but found  %t and %t", lhs, rhs));
        }
    });    
}

void collect(current:(Expr)`<Expr lhs> not like <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("not like", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [strType(), strType()] : return boolType();
            default : s.report(error(current, "not like requires two Str but found  %t and %t", lhs, rhs));
        }
    });    
}

void collect(current:(Expr)`<Expr lhs> in <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("in", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [strType(), strType()] : return boolType();
            case [t, setType(t)] : return boolType();
            case [t, listType(t)] : return boolType();
            case [t, mapType(k, t)] : return boolType();
            default :  s.report(error(current, "%q requires a Str or a Collection found  %t and %t", "in", lhs, rhs));
        }
    });    
}

void collect(current:(Expr)`<Expr lhs> in <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("not in", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [strType(), strType()] : return boolType();
            case [t, setType(t)] : return boolType();
            case [t, listType(t)] : return boolType();
            case [t, mapType(k, t)] : return boolType();
            default :  s.report(error(current, "%q requires a Str or a Collection found  %t and %t", "in", lhs, rhs));
        }
    });    
}


void collect(current: (Expr) `if <Expr cond> then <Expr thenPart> else <Expr elsePart>`, Collector c){
     c.calculate("if", current, [cond, thenPart, elsePart],
        AType (Solver s) { 
            s.requireEqual(cond, boolType(), error(cond, "Condition should have type `bool`, found %t", cond));
            s.requireEqual(thenPart, elsePart, error(current, "thenPart and elsePart should have same type"));
            return s.getType(thenPart);
        }); 
      collect(cond, thenPart, elsePart, c);
}

void collect(current:(Expr)`{<{ Expr ";" }+ e>}`, Collector c) {
    exprs = [expr | expr <- e];
    lastExpr = last(exprs);
    collect(e, c);
     c.calculate("block", current, [expr | expr <- e], AType (Solver s) {
        switch(s.getType(lastExpr)){
            case t : return s.getType(t);
        }
    });    
}


void collect(current:(Expr)`- <Expr e>`, Collector c) {
    collect(e, c);
    c.fact(current, e);
    c.requireComparable(intType(), e, error(e, "Numeric type expected, got %t", e));
}


void collect(current:(Expr)`! <Expr e>`, Collector c) {
    collect(e, c);
    c.fact(current, boolType());
    c.requireEqual(boolType(), e, error(e, "Expected bool type, got %t", e));
}

void collect(current:(Expr)`null`, Collector c) {
    c.fact(current, nullType());
}

void collect(current:(Expr)`nil`, Collector c) {
    c.fact(current, nilType());
}

void collect(current:(Expr)`<Id lhs> . <Id fieldName>`, Collector c) {
    c.useViaType(lhs, fieldName, {fieldId()});
    c.fact(current, fieldName);
    collect(lhs, c);
}


void collect(current: (Entity) `entity <EntityId name> extends <EntityId base> { <Field* fields> }`, Collector c) {
    if("<name>" == "<base>")
        c.report(error(current, "Cyclic Inheritance not allowed %q cannot  extend %q", "<name>", "<base>"));

    c.define("<name>", entityId(), current, defType(entityType("<name>"))); 
    c.enterScope(current);
        c.push(key_extendsRelation, <"<name>", "<base>">);
        scope = c.getScope();
        c.setScopeInfo(scope, entityScope(), entityInfo(name, base));
        c.addPathToDef(base, {entityId()}, extendsPath());
        collect(fields, c);
    c.leaveScope(current);
}

void collect(current:(Entity)`entity <EntityId name> { <Field* fields> }`, Collector c) {
    c.define("<name>", entityId(), current, defType(entityType("<name>"))); 
    c.enterScope(current);
        c.push(key_extendsRelation, <"<name>">);
        scope = c.getScope();
        c.setScopeInfo(scope, entityScope(), entityInfo(name));
        collect(fields, c);
    c.leaveScope(current);
}

void collect(current:(Enum)`enum <EntityId name> { <EnumField+ values> }`, Collector c) {
    c.define("<name>", enumId(), current, defType(enumType("<name>"))); 
    c.enterScope(current);
        collect(values, c);
    c.leaveScope(current);
}

void collect(current:(Struct)`struct <EntityId name> { <StructField+ values> }`, Collector c) {
    c.define("<name>", structId(), current, defType(structType("<name>"))); 
    c.enterScope(current);
        collect(values, c);
    c.leaveScope(current);
}


void collect(current:(Field)`<Id name> : <Type t> = <Expr e>`, Collector c) {
    c.define("<name>", fieldId(), current, defType(t));
    c.requireEqual(t, e, error(e, "Incorrect initialization, expected %t found %t", t, e));
    collect(t, e, c);
}


void collect(current:(Field)`<Id name> : <Type t> <Constraints? c>`, Collector c) {
    c.require("simple typs", current, [t], 
        void (Solver s) { switch(s.getType(t)){
                               case intType(): s.getType(t);
                               case strType(): s.getType(t);
                               case floatType(): s.getType(t);
                               case boolType(): s.getType(t);
                               case dateType(): s.getType(t);
                               case datetimeType(): s.getType(t);
                               case enumType(_): s.getType(t);    
                               case structType(_): s.getType(t);
                               default: {   
                                    ty = s.getType(t);
                                    s.report(error(t,"Type must be a primitive %t is not", ty));
                             }
                  }
                });
    c.define("<name>", fieldId(), current, defType(t));
    collect(t, c);
}

void collect(current:(RelationalMapping)`relational-mapping <EntityId name>[<EntityId entityName> ] {<Table t>  <Property+ values>  <Relationship* r>}`, Collector c) {
    c.use(entityName, {entityId()});
    c.define("<name>", mappingId(), current, defType(mappingType("<name>"))); 
    c.enterScope(current);
        scope = c.getScope();
        c.setScopeInfo(scope, mappingScope(), mappingInfo(name, entityName));
        collect(t, values, entityName, r, c);
    c.leaveScope(current);
}

void collect(Table table, Collector c) {
    <scope, eid> = getCurrentMapping(c);
    t = entityType("<eid>");

    tbl = table.e1;
    schema = table.e2;
    key = table.e3;
    attributes = table.ta;

    outer = c.getScope();

    c.enterScope(key);
       if ((Expr) `<Id arg> =\> <Expr exp>` := key){
            c.define("<arg>", variableId(), arg, defType(t));
            c.fact(exp, t);
            collect(exp, c);
        }
        else {
           c.report(error(table, "Expected a lambda expression but got %t", key));
        }
    c.leaveScope(key);

    for(attribute <-  attributes){
      c.enterScope(attribute);  
        switch(attribute){
            case (TableAttribute) `. index ( <Expr e> )` : {
              if ((Expr) `<Id arg> =\> <Expr exp>` := e) {
                  c.define("<arg>", variableId(), arg, defType(t));
                  c.fact(exp, t);
                  collect(exp, c);
                }
                else {
                 c.report(error(attribute, "Expected a lambda expression but got %t", e));
                }
            }
            case (TableAttribute) `. discriminator ( <Expr e> )` : {
                if ((Expr) `<Id arg> =\> <Expr exp>` := e) {
                  c.define("<arg>", variableId(), arg, defType(t));
                  c.fact(exp, t);
                  collect(exp, c);
                }
                else {
                 c.report(error(attribute, "Expected a lambda expression but got %t", key));
             
                }
            }
            case (TableAttribute) `. tableDoc ( <Expr e> )` : {
                if ((Expr) `<StringConstant st>` := e){
                    collect(e, c);
                }
                else{
                    c.report(error(e, "Parameter should have type `Str` found %t", e));
                }
                collect(e, c);
                
            }
        }
     c.leaveScope(attribute);
    }
}

void collect(current:(TableAttribute)`. index (<Expr e>)`, Collector c) {
    collect(e, c);
}

void collect(current:(TableAttribute)`. discriminator (<Expr e>)`, Collector c) {
    collect(e, c);
}

void collect(current:(Relationship) `reference (<Expr e>) <Cardinality crd>`, Collector c) {
      <scope, eid> = getCurrentMapping(c);
      t = entityType("<eid>");

      c.enterScope(current);
       if ((Expr) `<Id arg> =\> <Expr exp>` := e){
            c.define("<arg>", variableId(), arg, defType(t));
            c.fact(exp, t);            
            collect(exp, c);
        }
        else {
            c.report(error(e, "Expected a lambda expression but got %t", e));
        }
        collect(e, crd, c);
     c.leaveScope(current);

}

void collect(current:(Cardinality) `. manyToOne [ <EntityId entityName> ] ( <Expr e> )`, Collector c) {
     t = entityType("<entityName>");
     c.use(entityName, {entityId()});

     c.enterScope(current);
       if ((Expr) `<Id arg> =\> <Expr exp>` := e){
            c.fact(exp, t); 
            c.define("<arg>", variableId(), arg, defType(t)); 
            collect(exp, c);
        }
        else {
           c.report(error(e, "Expected a lambda expression but got %t", e));
        }

        collect(e, entityName, c);
     c.leaveScope(current);  
}

void collect(current:(Cardinality) `. oneToMany [ <EntityId entityName> ] ( <Expr e> )`, Collector c) {
     t = entityType("<entityName>");
     c.use(entityName, {entityId()});

     c.enterScope(current);
       if ((Expr) `<Id arg> =\> <Expr exp>` := e){
            c.fact(exp, t); 
            c.define("<arg>", variableId(), arg, defType(t)); 
            collect(exp, c);
        }
        else {
           c.report(error(e, "Expected a lambda expression but got %t", e));
        }

        collect(e, entityName, c);
     c.leaveScope(current);  
}

void collect(current:(Cardinality) `. manyToMany [ <EntityId entityName> ] ( <Expr e> ) <JoinTable? jt>`, Collector c) {
     t = entityType("<entityName>");
     c.use(entityName, {entityId()});

     c.enterScope(current);
       if ((Expr) `<Id arg> =\> <Expr exp>` := e){
            c.fact(exp, t); 
            c.define("<arg>", variableId(), arg, defType(t)); 
            collect(exp, c);
        }
        else {
           c.report(error(e, "Expected a lambda expression but got %t", e));
        }

        collect(e, entityName, c);
     c.leaveScope(current);  

     for((JoinTable) `. joinTable ( <Expr ex> )` <-  jt){
         c.require("JoinTable", current, [e],
          void (Solver s) {
            s.requireEqual(strType(), ex, error(ex, "Expected %t but found %t", strType(), ex)); 
          });
        collect(ex, c);
     }
}

void collect(current:(JoinTable) `. joinTable ( <Expr e> )`, Collector c) {
    c.require("JoinTable", current, [e],
        void (Solver s) {
            s.requireEqual(strType(), e, error(e, "Expected %t but found %t", strType(), e)); 
        });
       collect(e, c);
}


void collect(current:(Property)`property (<Expr e>) <PropertyType* p>`, Collector c) {
    <scope, eid> = getCurrentMapping(c);
    t = entityType("<eid>");
    map[str, int] m = ();

    for (PropertyType pt <- p){
        switch(pt){
            case (PropertyType) `. columnType ( <ColumnType _>)` : {
              if ("ColumnType" notin m){
                 m = m + ("ColumnType" : 1);
              }
              else{
               c.report(error(p, "Duplicate occurrence of %v", "columnType"));
              }
            }
            case (PropertyType) `. columnName ( <Expr e>)` : {
               if ("ColumnName" notin m){
                 m = m + ("ColumnName" : 1);
               }
               else{
                 c.report(error(p, "Duplicate occurrence of %v", "columnName"));
              }
            }
            case (PropertyType) `. isNullable ( <Expr _>)` : {
               if ("Required" notin m){
                 m = m + ("Required" : 1);
               }
               else{
                 c.report(error(p, "Duplicate occurrence of %v", "isNullable"));
              }
            }
            case (PropertyType) `. isUnique ( <Expr _>)` : {
               if ("Unique" notin m){
                 m = m + ("Unique" : 1);
               }
               else{
                 c.report(error(p, "Duplicate occurrence of %v", "isUnique"));
              }
            }
            case (PropertyType) `. columnDoc ( <Expr _>)` : {
               if ("columnDoc" notin m){
                 m = m + ("columnDoc" : 1);
               }
               else{
                 c.report(error(p, "Duplicate occurrence of %v", "columnDoc"));
              }
            }
            case (PropertyType) `. columnOrder ( <Expr _>)` : {
              if ("ColumnOrder" notin m){
                m = m + ("ColumnOrder" : 1);
              }
              else{
                c.report(error(p, "Duplicate occurrence of %v", "columnOrder"));
              }
            }
            case (PropertyType) `. defaultValue ( <Expr _>)` : {
              if ("DefaultValue" notin m){
                m = m + ("defaultValue" : 1);
              }
              else{
                c.report(error(p, "Duplicate occurrence of %v", "defaultValue"));
              }
            }
        }
    }

     c.enterScope(current);
       if ((Expr) `<Id arg> =\> <Expr exp>` := e){
            c.fact(exp, t); 
            c.define("<arg>", variableId(), arg, defType(t)); 
            collect(exp, c);
        }
        else {
           c.report(error(e, "Expected a lambda expression but got %t", e));
        }

        collect(e, p, c);
     c.leaveScope(current);  
}


void collect(current: (Field) `<Id name> -\> <Type t>`, Collector c){
     c.require("type reference", current, [t], 
        void (Solver s) { switch(s.getType(t)){
                               case entityType(_): ty = s.getType(t);
                               case listType(entityType(_)): s.getType(t);
                               case setType(entityType(_)):  s.getType(t);
                               default: {   
                                    ty = s.getType(t);
                                    s.report(error(t,"Type must be a reference %t is not", ty));
                             }  
                  }
     }); 
     c.define("<name>", fieldId(), current, defType(t));  
     collect(name, t,  c);
}

void collect(current: (Field) `<Id name> -\> <Type typ> inverse <Reference ref> :: <Id attr>`, Collector c){
    <scope, eid> = getCurrentEntity(c);
    
    c.define("<name>", fieldId(), current, defType(typ));
    c.use(ref, {entityId()});
    c.useViaType(ref, attr, {fieldId()});

    c.require("check inverse", current, [attr],
        void(Solver s){
            field_type = s.getType(typ);
            attr_type = s.getType(attr);
            ref_type = s.getType(ref);
            entity_type = entityType("<eid>");

            if (setType(at) := attr_type) {
               s.requireEqual(entity_type, at, error(attr, "Field type %t does not match Entity type %t", entity_type, at)); 
            } 
            else if (listType(at) := attr_type) {
                s.requireEqual(entity_type, at, error(attr, "Field type %t does not match Entity type %t", entity_type, at)); 
            }
            else {
                s.requireEqual(entity_type, attr_type, error(attr, "Field type %t does not match Entity type %t", entity_type, attr_type)); 
            }
            if(setType(elm_type) := field_type) {
                s.requireEqual(elm_type, ref_type, error(ref, "Field type %t does not match reference type %t", typ, ref)); 
            }
            else if(listType(elm_type) := field_type) {
                s.requireEqual(elm_type, ref_type, error(ref, "Field type %t does not match reference type %t", typ, ref)); 
            }

        });
    collect(typ, ref, attr, c);
}


void collect(current:(StructField)`<Id name> : <Type t>`, Collector c) {
    c.define("<name>", fieldId(), current, defType(t));
    collect(t, c);
}

void collect(current:(EnumField)`<Id name>,`, Collector c) {
    c.define("<name>", fieldId(), current, defType(intType()));
    c.fact(current, intType());
}

void collect(current:(EnumField)`<Id name>(<Id v>),`, Collector c) {
    c.define("<name>", fieldId(), current, defType(intType()));
    c.fact(current, intType());
}

void collect(current:(Expr)`[<{Expr ","} *entries>]`, Collector c) {
    if (e <- entries) {
        collect(entries, c);
        c.calculate("list type", current, [et | et <- entries], AType (Solver s) {
            for (et <- entries) {
                s.requireEqual(e, et, error(et, "Expected same type in the list, found %t and %t", e, et));
            }
           return listType(s.getType(e));
        });
    }
     c.fact(current, listType(objectType()));
}

void collect(current:(Expr)`\< <{Expr ","}* elem> \>`, Collector c){
    c.fact(current, tupleType(elem));
    collect(elem, c);
}

void collect(current:(Expr)`set{<{Expr ","}* entries>}`, Collector c) {
    if (e <- entries) {
        collect(entries, c);
        c.calculate("Set type", current, [et | et <- entries], AType (Solver s) {
            for (et <- entries) {
                ty1 = s.getType(et);
                ty2 = s.getType(e);
                s.requireEqual(ty1, ty2, error(et, "Expected same type in the set, found %t and %t", ty1, ty2));
            }
           return setType(s.getType(e));
        });
    }
    c.fact(current, setType(objectType()));
}

void collect(current: (Expr) `<Expr l> [<Expr e>]`, Collector c){
    collect(l, e, c);
    c.calculate("list Indexing", current, [l, e], AType (Solver s) {
        s.requireEqual(e, intType(), error(e, "Expected an %t found %t", intType(), e));
        switch(s.getType(l)){
            case listType(t) : return s.getType(t);
            default : s.report(error(current, "Indexing requires a list but found a %t", l));
        }
    });
}

void collect(current: (Expr) `<Expr l> {<Expr e>}`, Collector c){
    collect(l, e, c);
    c.calculate("set Indexing", current, [l, e], AType (Solver s) {
        s.requireEqual(e, intType(), error(e, "Expected an %t found %t", intType(), e));
        switch(s.getType(l)){
            case setType(t) : return s.getType(t);
            default : s.report(error(current, "Indexing requires a set but found a %t", l));
        }
    });
}

void collect(current: (Expr) `<Expr l>.get(<Expr e>)`, Collector c){
    collect(l, e, c);
    c.calculate("set Indexing", current, [l, e], AType (Solver s) {
        switch(s.getType(l)){
            case mapType(k, v) : return s.getType(v);
            default : s.report(error(current, "Get requires a map but found a %t", l));
        }
    });
}

void collect(current: (Expr) `<Expr e> is null`, Collector c){
    collect(e, c);
    c.calculate("set Indexing", current, [e], AType (Solver s) {
        switch(s.getType(e)){
            case Reference(_) : return boolType();
            default : s.report(error(current, "null check requires a reference type but found %t", e));
        }
    });
}

void collect(current: (Expr) `<Expr e> is not null`, Collector c){
    collect(e, c);
    c.calculate("set Indexing", current, [e], AType (Solver s) {
        switch(s.getType(e)){
            case Reference(_) : return boolType();
            default :  s.report(error(current, "null check requires a reference type but found %t", e));
        }
    });
}


void collect(current:(Expr)`{ <{Mapping ","}+ entries> }`, Collector c) {
    mappings = [<k, v> | (Mapping) `<Expr k> -\> <Expr v>` <- entries];
    if (<k, v>  <- mappings){
        collect(entries, c);
        c.calculate("map type", current, [m | Mapping m <- entries], AType (Solver s) {
           for (<key, val> <- mappings) {
                s.requireEqual(k, key, error(key, "Expected same type in the map, found %t and %t", k, key));
                s.requireEqual(v, val, error(val, "Expected same type in the map, found %t and %t", v, val));
            }
           return mapType(s.getType(k), s.getType(v));
        });
    }
}


void collect(current: (Mapping) `<Expr k> -\> <Expr v>`, Collector c){
    c.calculate("mapping type", current, [k, v],
        AType(Solver s){ return mapType(s.getType(k), s.getType(v)); });
    collect(k, v, c);
}

void collect(current: (Expr) `(<Expr e>) match  { <Case+ cases> <Default? d>}`, Collector c){
    caseMappings = [<e1, e2> | (Case) `case <Expr e1> =\> <Expr e2>;` <- cases];

    if (<_, e2> <- caseMappings){
        c.calculate("case expr", current, [et | Case et <- cases], AType (Solver s) {
            for (<ex1, ex2> <- caseMappings) {
                s.requireEqual(e, ex1, error(ex1, "Expected same type in the case, found %t and %t", e, ex1));
                s.requireEqual(e2, ex2, error(ex2, "Expected same type in the case, found %t and %t", e2, ex2));
            }
            for((Default) `default =\> <Expr ex>;` <-  d){
                 s.requireEqual(e2, ex, error(ex, "Expected same type in the case, found %t and %t", e2, ex)); 
            }
            return s.getType(e2);
        });
    }
    if ((Default) `default =\> <Expr ex>;` <-  d){
       collect(e, cases, ex, c);
    }
    else {
      collect(e, cases, c);
    }

}

void collect(current: (Case) `case <Expr e1> =\> <Expr e2>;`, Collector c){
    c.calculate("mapping type", current, [e1, e2],
        AType(Solver s){ return mapType(s.getType(e1), s.getType(e2)); });
    c.enterScope(current);
       collect(e1, e2, c); 
    c.leaveScope(current);
  
}

void collect(current: (Default) `default =\> <Expr e>;`, Collector c){
     c.fact(current, e);
     collect(e, c);
}

void collect(current: (Expr) `<Expr e> as [<Type t>]`, Collector c){
   	  c.calculate("casting", current, [e], AType (Solver s){
        ty = s.getType(t);
		return ty;
	  });
      collect(e, t, c);
}

void collect(current: (Expr) `<Id name> (<{Expr ","}* args>) <AnalyticFunctionClause? a>`, Collector c){
      c.use(name, {funcId()});
   	  c.calculate("function", current, [e | e <- args], 
        AType (Solver s){
          funcType(formals, ret) = s.getType(name); 
          argx = [s.getType(a) | a <- args];
          argTypes = atypeList(argx);
        
          if (atypeList([listType(l)]) := formals){
            switch(size(argx)){
                case 0 : s.requireEqual(argTypes, formals, error(current, "Wrong type of arguments %t instead %t", argTypes, formals));
                default : { typ = getFirstFrom(argx);
                            s.requireEqual(l, typ, error(current, "Wrong type of arguments %t instead %t", l, typ));
                          }
            }          
          }
          else{
            s.requireEqual(argTypes, formals, error(current, "Wrong type of arguments %t instead %t", argTypes, formals));
          }
         
	   return ret;
	  });
      collect(name, args, c);
}

anno loc Tree@src;

void ptlPreCollectInitialization(Tree t, Collector c){
    container = t@src;

    c.predefine("sum", funcId(), container, defType(funcType(atypeList([floatType()]), floatType())));
    c.predefine("rtrim", funcId(),  container, defType(funcType(atypeList([strType()]), strType())));
    c.predefine("ltrim",   funcId(),    container, defType(funcType(atypeList([strType()]), strType())));
    c.predefine("abs",     funcId(),   container, defType(funcType(atypeList([intType()]), intType())));
    c.predefine("date",  funcId(),   container, defType(funcType(atypeList([intType()]), intType())));
    c.predefine("limit",   funcId(),   container, defType(funcType(atypeList([intType()]), intType())));
    c.predefine("round",   funcId(),   container, defType(funcType(atypeList([floatType()]), intType())));
    c.predefine("length",   funcId(),   container, defType(funcType(atypeList([strType()]), intType())));
    c.predefine("lower",   funcId(),   container, defType(funcType(atypeList([strType()]), strType())));
    c.predefine("upper",   funcId(),   container, defType(funcType(atypeList([strType()]), strType())));
    c.predefine("lcase",   funcId(),   container, defType(funcType(atypeList([strType()]), strType())));
    c.predefine("lpad",   funcId(),   container, defType(funcType(atypeList([strType(), strType(), strType()]), strType())));
    c.predefine("rpad",   funcId(),   container, defType(funcType(atypeList([strType(), strType(), strType()]), strType())));
    c.predefine("currentDate", funcId(), container, defType(funcType(atypeList([]), dateType())));
    c.predefine("today",   funcId(),   container, defType(funcType(atypeList([]), dateType())));
    c.predefine("toDate",   funcId(),   container, defType(funcType(atypeList([strType()]), dateType())));
    c.predefine("now",   funcId(),   container, defType(funcType(atypeList([]), datetimeType())));
    c.predefine("concat",   funcId(),   container, defType(funcType(atypeList([listType(strType())]), strType())));
    c.predefine("coalesce",   funcId(),   container, defType(funcType(atypeList([listType(objectType())]), strType())));

}

void collectInfix(Expr lhs, Expr rhs, str op, Expr current, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("<op>", current, [lhs, rhs], AType (Solver s) {
        try {
            return calcInfix(op, {s.getType(lhs), s.getType(rhs)}, s);
        } catch "unsupported": {
            s.report(error(current, "%v not supported between %t and %t", op, lhs, rhs));
            return intType(); // never reached since error throws an exception
        }
    });
}


AType calcInfix(str op, {AType singleType}, _) = singleType
    when op in mathOps && singleType in numericTypes;

AType calcInfix(str op, {intType(), floatType()}, _) = floatType()
    when op in mathOps;
   
AType calcInfix("+", {strType(), _}, _) = strType(); // allow concat on many things
    
default AType calcInfix(_, _, _) {
    throw "unsupported";
}


void comparisonOp(Expr e, Expr e1, str op, Expr e2, Collector c){
    c.calculate("comparison operator", e, [e1, e2],
        AType(Solver s){
            s.requireTrue({s.getType(e1), s.getType(e2)} <= {intType(), floatType()},
                          error(e, "Illegal arguments %t and %t for %q", e1, e2, op));
            return boolType();
         });
    collect(e1, e2, c);
}


void boolOp(Expr e, Expr e1, str op, Expr e2, Collector c){
    c.calculate("boolean operator", e, [e1, e2],
        AType(Solver s){
            s.requireEqual(e1, boolType(), error(e1, "Illegal argument %t for %q", e1, op));
            s.requireEqual(e2, boolType(), error(e2, "Illegal argument %t for %q", e2, op));
            return boolType();
         });
    collect(e1, e2, c);
}

tuple[loc scope, EntityId eid] getCurrentEntity(Collector c){
    entityScopes = c.getScopeInfo(entityScope());
    for(<scope, scopeInfo> <- entityScopes){
        if(entityInfo(eid1, eeid1) := scopeInfo){
            return <scope, eid1>;
        }
        else if(entityInfo(eid1) := scopeInfo){
            return <scope, eid1>;
        }
        else {
            throw "Inconsistent info from entity scope: <scopeInfo>";
        }
    }
    throw  "No surrounding entity scope found";
}

tuple[loc scope, EntityId eid] getCurrentMapping(Collector c){
    mappingScopes = c.getScopeInfo(mappingScope());
    for(<scope, scopeInfo> <- mappingScopes){
        if(mappingInfo(eid1, eeid1) := scopeInfo){
            return <scope, eeid1>;
        }
        else {
            throw "Inconsistent info from mapping scope: <scopeInfo>";
        }
    }
    throw  "No surrounding mapping scope found";
}

TModel ptlTModelForTree(Tree pt){
    if (pt has top) pt = pt.top;
    c = newCollector("collectAndSolve", pt, getModulesConfig()); 
    collect(pt, c);
    ptlPreCollectInitialization(pt, c);;
    handleImports(c, pt, pathConfig(pt@\loc));
    return newSolver(pt, c.run()).run();
}

bool ptlTests() {
     return runTests([|project://ast_diff/src/lang/ptl/examples/test.ttl|], 
                     #start[Program], ptlTModelForTree);
}