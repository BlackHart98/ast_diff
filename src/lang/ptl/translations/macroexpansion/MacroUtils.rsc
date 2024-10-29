module lang::ptl::translations::macroexpansion::MacroUtils

import lang::ptl::ast::PTL;
import String;


// macro as type
data Type = /*macrovardecl() |*/ macrodef() | macrobind() | macrolistvalue() //| iterator() | unresloved()
;

// A generic ADT for all types used with macro expansion
// data MacroType = macroType(&T macrotype);

// A generic ADT for all expressions used with macro expansion
data MacroExpr = macroExpr(&T macroexp);

data Environment = environment(
    map[str, tuple[&T containment, Type _type, loc location]] entity
    , list[Environment] parent=[]
);

// Look up function - work in progress
&T lookup(str identifier, Environment env){
    // println("Searching for: <identifier>");
    if (!(identifier in env.entity) && env.parent == []){
        throw "Undeclared identifier: <identifier>";
    }else if (!(identifier in env.entity) && [_] := env.parent){
        return lookup(identifier, env.parent[0]);
    } else{ 
        // println("Found: <env.entity[identifier].containment>");
        if (macroExpr(Expr expr) := env.entity[identifier].containment){
            return expr;
        } else if(macroExpr(Declaration decl) := env.entity[identifier].containment){
            return decl;
        }else{
            return env.entity[identifier].containment;
        }
        
    }
}

// Insert expression here
default Expr eval(Expr e, Environment env) = 
    bottom-up visit(e){ 
        // Relational
        case twoEqual(e1, e2): {
            e1_ = (identifier([str name]) := e1)?lookup(name, env) : e1;
            e2_ = (identifier([str name]) := e2)?lookup(name, env) : e2;
            insert boolEval(twoEqual(e1_, e2_));
        }

        // Primitive types
        case i:integer(_) => i
        case r:decimal(_) => r
        case b:boolean(_) => b
        case s:string(_) => s
        // Variable
        // case v:var(_) => lookup(v.name, env)
        // Literal -> this just returns the identity i.e., "7" returns "7"
        case str s => s
    };


// Boolean - insert all boolean expression evaluation here
Expr boolEval(Expr e){
    switch (e){ 
        case twoEqual(e1, e2): {
            if (comparable(e1, e2)){
                 return boolean("<getValue(e1) == getValue(e2)>"); 
            }else{
                throw "Incompatible operands";
            }
        }
        case lt(e1, e2): {
            if (comparable(e1, e2)){
                 return boolean("<getValue(e1) < getValue(e2)>"); 
            }else{
                throw "Incompatible operands";
            }
        }
        case gt(e1, e2): {
            if (comparable(e1, e2)){
                 return boolean("<getValue(e1) > getValue(e2)>"); 
            }else{
                throw "Incompatible operands";
            }
        }
        case lte(e1, e2): {
            if (comparable(e1, e2)){
                 return boolean("<getValue(e1) <= getValue(e2)>"); 
            }else{
                throw "Incompatible operands";
            }
        }
        case gte(e1, e2): {
            if (comparable(e1, e2)){
                 return boolean("<getValue(e1) >= getValue(e2)>"); 
            }else{
                throw "Incompatible operands";
            }
        }
        case neq1(e1, e2): {
            if (comparable(e1, e2)){
                 return boolean("<getValue(e1) != getValue(e2)>"); 
            }else{
                throw "Incompatible operands";
            }
        }
        default: throw "Operation not yet implemented";
    }
}


bool comparable(Expr e1, Expr e2){
    if (integer(_):= e2 && integer(_):= e1){
        return true;
    }else if (decimal(_):= e2 && decimal(_):= e1){
        return true;
    }else if (boolean(_):= e2 && boolean(_):= e1){
        return true;
    }else if (string(_):= e2 && string(_):= e1){
        return true;
    }else{
        return false;
    }
}

int getValue(integer(n)) =  toInt(n);
real getValue(decimal(d)) = toReal(d);
bool getValue(boolean(b)){
    if (b == "true"){
        return true;
    } else{
        return false;
    }
}
str getValue(string(s)) = s;


