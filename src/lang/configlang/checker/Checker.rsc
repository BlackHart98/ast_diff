module lang::configlang::checker::Checker

extend analysis::typepal::TypePal;
import lang::configlang::grammar::Configlang;
import Prelude;
import IO;
import String;
import List;


data IdRole
    = variableId()
    | nameId()
    | moduleId()
    | pathId()
    | functionId()
    ;
data AType
    = boolType()
    | intType()
    | strType()
    | floatType()
    | dateType()
    | datetimeType()
    | enumType(str name)
    | listType(AType t)
    | setType(AType t)
    | mapType(AType k, AType v)
    | tupleType(list[AType] ty)
    | nilType()
    | nullType()
    | moduleType()
    | funcType(str name)
    | objectType()
    ;

data PathRole
    = importPath()
    | includePath()
    ;

str prettyAType(boolType()) = "Bool";
str prettyAType(intType()) = "Int";
str prettyAType(strType()) = "Str";
str prettyAType(floatType()) = "Float";
str prettyAType(dateType()) = "Date";
str prettyAType(datetimeType()) = "Datetime";
str prettyAType(objectType()) = "Object";
str prettyAType(moduleType()) = "moduleType()";
str prettyAType(enumType(str name)) = "enum <name>";
str prettyAType(listType(AType t)) = "List[<prettyAType(t)>]";
str prettyAType(setType(AType t)) = "Set[<prettyAType(t)>]";
str prettyAType(mapType(AType k, AType v)) = "Map[<prettyAType(k)>, <prettyAType(v)>]";
str prettyAType(funcType(str name)) = "funcType(<name>)";

void collect(current: (Config) `module <QualifiedId qualifiedid> <Imports* imports> <Declaration+ decl> end module`, Collector c){
    c.enterScope(current);{
        c.define("<qualifiedid>", moduleId(), current, defType(moduleType()));
        collect(imports, decl, c);
    }
    c.leaveScope(current);
}
void collect(current:(Imports)`import <QualifiedId qualifiedid>`,Collector c){
    c.addPathToDef(qualifiedid, {moduleId()}, importPath());
    c.push(__MODULES_IMPORT_QUEUE, "<qualifiedid>");
}
void collect(current:(Imports)`include <QualifiedId qualifiedid>`,Collector c){
    c.addPathToDef(qualifiedid, {moduleId()}, includePath());
    c.push(__MODULES_IMPORT_QUEUE, "<qualifiedid>");
}
void collect(current:(Declaration)`action <ActionDef actiondef>`,Collector c){
    collect(actiondef,c);
}
void collect(current:(ActionDef)`reverse-engineering { sql-dialect = { <Type? ty1> name : <Expr exp1> <Type? ty2> version : <Expr exp2> } orchestration = { <Type? ty3> name : <Expr exp3> <Type? ty4> version : <Expr exp4> } }`,Collector c){
    c.enterScope(exp1);{
        for(t <- ty1){
            if ((Type)`Str` := t){
                c.fact(current,strType());
            }
            else c.report(error(t,"Type annotation for orchestration name can not be of type <t>, only Str"));
        }
        c.requireEqual(exp1,strType(),error(exp1, "sql-dialect name can only be Type Str not %t",exp1));
        collect(exp1,c);
    }
    c.leaveScope(exp1);

    c.enterScope(exp2);{
        for(t <- ty2){
            if ((Type)`Str` := t){
                c.requireEqual(exp2,strType(),error(exp2, "sql-dialect version should be same Type <t>, not %t",exp2));
            }
            else if ((Type)`Int` := t){
                c.requireEqual(exp2,intType(),error(exp2, "sql-dialect version should be same Type <t>, not %t",exp2));
            }
            else if ((Type)`Float` := t){
                c.requireEqual(exp2,floatType(),error(exp2, "sql-dialect version should be same Type <t>, not %t",exp2));
            }
            else c.report(error(t,"Type annotation for dialect version can not be of type <t>, only Str, Int Or Float"));
        }
        c.calculate("sql-dialect version", current, [exp2],
            AType (Solver s){
                switch(s.getType(exp2)){
                    case intType(): return intType();
                    case strType(): return strType();
                    case floatType(): return floatType();
                    default: s.report(error(exp2,"sql-dialect version can only be Str, Float or Int, not %t",exp2));
                }
                //won't get to this
                return strType();
            });
        collect(exp2,c);
    }
    c.leaveScope(exp2);

    //orchestration
    c.enterScope(exp3);{
        for(t <- ty3){
            if ((Type)`Str` := t){
                c.requireEqual(exp3,strType(),error(exp3,"orchestration name should be same Type <t> with TypeAnnotation"));
            }
            else c.report(error(t,"Type annotation for orchestration name can not be of type <t>, only Str"));
        }
        collect(exp3,c);
    }
    c.leaveScope(exp3);

    c.enterScope(exp4);{
        for(t <- ty4){
            if ((Type)`Str` := t){
                c.requireEqual(exp4,strType(),error(exp4,"orchestration version should be same Type <t> with TypeAnnotation"));
            }
            else if ((Type)`Int` := t){
                c.requireEqual(exp4,intType(),error(exp4,"orchestration version should be same Type <t> with TypeAnnotation"));
            }
            else if ((Type)`Float` := t){
                c.requireEqual(exp4,floatType(),error(exp4,"orchestration version should be same Type <t> with TypeAnnotation"));
            }
            else c.report(error(t,"Type annotation for orchestration version can not be of type <t>, only Str, Int or Float"));
        }
        c.calculate("orchestration version", current, [exp4],
            AType (Solver s){
                switch(s.getType(exp4)){
                    case intType(): return intType();
                    case strType(): return strType();
                    case floatType(): return floatType();
                    default: s.report(error(exp4,"orchestration version can only be Str, Float or Int"));
                }
                //won't get to this
                return strType();
            });
        collect(exp4,c);
    }
    c.leaveScope(exp4);
}
void collect(current:(Declaration)`project { <Type? ty1> name : <String string1> <Type? ty2> version : <String string2> <Type? ty3> author : <String string3> }`, Collector c){
    c.enterScope(string1);{
        for(t <- ty1){
            if ((Type)`Str` := t){
                c.fact(current,strType());
            }
            else c.report(error(t,"Type annotation for project name can not be of type <t>, only Str"));
        }
        collect(string1,c);
    }
    c.leaveScope(string1);

    c.enterScope(string2);{
        for(t <- ty2){
            if ((Type)`Str` := t){
                c.fact(current,strType());
            }
            else c.report(error(t,"Type annotation for project version can not be of type <t>, only Str"));
        }
        collect(string2,c);
    }
    c.leaveScope(string2);

    c.enterScope(string3);{
        for(t <- ty3){
            if ((Type)`Str` := t){
                c.fact(current,strType());
            }
            else c.report(error(t,"Type annotation  for project author can not be of type <t>, only Str"));
        }
        collect(string3,c);
    }
    c.leaveScope(string3);
}

void collect(current: (String) `<StringConstant _>`, Collector c){
     c.fact(current, strType());
}

void collect(current: (Expr) `<BooleanLiteral _>`, Collector c){
    c.fact(current, boolType());
}

void collect(current: (Expr) `<Int _>`, Collector c){
    c.fact(current, intType());
}

void collect(current: (Expr) `<StringConstant _>`, Collector c){
     c.fact(current, strType());
}

void collect(current: (Expr) `<UNSIGNEDDECIMAL dt>`, Collector c){
     c.fact(current, floatType());
}

void collect(current: (Expr) `( <Expr e> )`, Collector c){
    c.fact(current, e);
    collect(e, c);
}

void collect(current:(Expr) `<QualifiedId name> ( <{Expr ","}*  args> )`,Collector c){ 
    c.define("<name>", functionId, current, defType(funcType("<name>")));
    collect(name, args, c);
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
        //won't get to this
        return strType();
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
        //won't get to this
        return strType();
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
        //won't get to this
        return strType();
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
        //won't get to this
        return strType();
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
        //won't get to this
        return strType();
    });  
     collect(lhs, rhs, c);
}
void collect(current: (Expr)`<QualifiedId qualifiedid>`, Collector c){
    c.use(qualifiedid,{nameId(),variableId()});
}
void collect(current:(Expr)`<Expr lhs> == <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("Eq", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [t1, t1] : return boolType();
            default : s.report(error(current, "%q requires two comparable types but found  %t and %t", "==", lhs, rhs));
        }
        //won't get to this
        return strType();
    }); 
}

void collect(current:(Expr)`<Expr lhs> \<\> <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("Neq", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [t1, t1] : return boolType();
            default : s.report(error(current, "%q requires two comparable types but found  %t and %t", "==", lhs, rhs));
        }
        //won't get to this
        return strType();
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
        //won't get to this
        return strType();
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
        //won't get to this
        return strType();
    }); 
}

void collect(current:(Expr)`<Expr lhs> or <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("Or", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [boolType(), boolType()] : return boolType();
            default : s.report(error(current, "Or requires two Bool but found  %t and %t", lhs, rhs));
        }
        //won't get to this
        return strType();
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
            default : s.report(error(current, "%q requires a Str or a Collection found  %t and %t", "in", lhs, rhs));
        }
        //won't get to this
        return strType();
    });    
}

void collect(current:(Expr)`<Expr lhs> not in <Expr rhs>`, Collector c) {
    collect(lhs, rhs, c);
    c.calculate("not in", current, [lhs, rhs], AType (Solver s) {
        switch([s.getType(lhs), s.getType(rhs)]){
            case [strType(), strType()] : return boolType();
            case [t, setType(t)] : return boolType();
            case [t, listType(t)] : return boolType();
            case [t, mapType(k, t)] : return boolType();
            default : s.report(error(current, "%q requires a Str or a Collection found  %t and %t", "in", lhs, rhs));
        }
        //won't get to this
        return strType();
    });    
}

void collect(current:(Expr)`- <Expr e>`, Collector c) {
    collect(e, c);
    c.fact(current, e);
    c.requireComparable(intType(), e, error(e, "Numeric type expected, got %t", e));
}


data PathConfig = pathConfig(list[loc] srcs = [], list[loc] libs = []);

PathConfig pathConfig(loc _) {

   return pathConfig(srcs = [|project://adept-base/src/lang/configlang/examples|]);
}

private str __MODULES_IMPORT_QUEUE = "__modulesImportQueue";


void handleImports(Collector c, Tree root, PathConfig pcfg) {
   set[str] imported = {};
   while (list[str] modulesToImport := c.getStack(__MODULES_IMPORT_QUEUE) && modulesToImport != []) {
    	c.clearStack(__MODULES_IMPORT_QUEUE);
        for (m <- modulesToImport, m notin imported) {
            if (<true, l> := lookupModule(m, pcfg)) {
                collect(parse(#start[Config], l).top, c);
            }
            else {
                c.report(error(root, "Cannot find module %v in %v or %v", m, pcfg.srcs, pcfg.libs));
            }
            imported += m; 
        }
    }
}

tuple[bool, loc] lookupModule(str name, PathConfig pcfg) {
    for (s <- pcfg.srcs + pcfg.libs) {
        result = (s + replaceAll(name, ".", "/"))[extension = "pcf"];
        println(result);
        if (exists(result)) {
        	return <true, result>;
        }
    }
    return <false, |invalid:///|>;
}

public str toString(Id identifier) = "<identifier>";