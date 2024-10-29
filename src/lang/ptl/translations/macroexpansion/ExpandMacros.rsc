module lang::ptl::translations::macroexpansion::ExpandMacros

import List;
import String;
import Type;
import lib::Utils;
import lang::ptl::ast::PTL;
import lang::ptl::prettyprint::PTL;
import lang::ptl::translations::macroexpansion::MacroUtils;


@synopsis{Extract bindings and definitions from a list of Declarations}
Environment define_env_table(list[Declaration] decls) {
    map[str, tuple[MacroExpr, Type, loc]] var_def_map = 
        (name_ : <macroExpr(mac), macrodef(), cast(#loc, typeCast(#node, mac).src)> | Declaration d <- decls, mac:macrodeclaration(macroDef(macroDefSimple(name_, _, _))) := d) +
        (name_ : <macroExpr(mac), macrodef(), cast(#loc, typeCast(#node, mac).src)> | Declaration d <- decls, mac:macrodeclaration(macroDef(macroDefMixed(name_, _, _, _))) := d) +   
        (name_ : <macroExpr(mac), macrodef(), cast(#loc, typeCast(#node, mac).src)> | Declaration d <- decls, mac:macrodeclaration(macroDef(macroDefKWOnly(name_, _, _))) := d) +      
        (name_ : <macroExpr(expr), macrobind(), cast(#loc, typeCast(#node, mac).src)> | Declaration d <- decls, mac:macrodeclaration(bind(name_, expr)) := d);      
        
    Environment env = environment(var_def_map, parent=[]);
    return env;
}

@synopsis{Insert arbitrary entity into an existing environment}
Environment insert_into_env(map[str, tuple[&T containment, Type _type, loc location]] record, Environment parent_env){
    Environment env = environment(record, parent=[parent_env]);
    return env;
}

@synopsis{Helper function to match macro call arguments and definitions}
map[str, tuple[&T, Type, loc]] make_arg_param_env(list[Expr] call_args, list[MParam] def_args, MacroCall m_call, Environment env) {
    lrel[Expr, MParam] args_zip = [];
    // check if the arguments matches with definitionn parameters
    if (size(call_args) == size(def_args)) {
        args_zip = zip2(call_args, def_args);
    } else{
        throw MacroExpansionException("Undeclared macro definition <m_call.name>", typeCast(#node, m_call).src);
    }

    map[str, tuple[&T containment, Type _type, loc location]] var_subs_map = ();
    for (tuple[Expr arg, MParam param] elem <- args_zip) {
        // If the argument is a variable reference do a look up
        // before continuing execution
        Expr final_result = elem.arg;
        if (identifier([str name]) := elem.arg) {
            final_result = lookup(name, env);
        }


        var_subs_map += 
            (elem.param.name : <final_result
                              , macrobind()
                              , cast(#loc, typeCast(#node, m_call).src)>
            );

    }
    return var_subs_map;
}

@synopsis{ Main entry point of the function.
    It recursively evaluates macro statements and bindings, adding bindings and macro definitions to the environment at each lexical scope, while 
    evaluating macro statements, i.e. for loops and if-else statements as they are encountered.
}
list[Declaration] expandMacros(list[Declaration] decls, Environment env=environment((), parent=[])) {
    // Extract macro definitions at currrent level
    list[Declaration] macro_definitions = [ d | d <- decls, macrodeclaration(macroDef(_)) := d];

    // Store them in an environment table
    Environment env_table = define_env_table(macro_definitions);

    // insert them into the environment 
    env = insert_into_env(env_table.entity, env);

    // Remove the macro definitions from the rest of the program_declarations
    list[Declaration] program_wo_macro_defs = [ d | d <- decls, macrodeclaration(macroDef(_)) !:= d ];

    list[Declaration] result = [];

    for (d <- program_wo_macro_defs) {
        if (macrodeclaration(bind(_, _)) := d) {

            Environment current_env_map = define_env_table([d]);
            env = insert_into_env(current_env_map.entity, env);

        } else if (macrocall(m_call:macroCallSimple(_, _)) := d) {

            Declaration lookup_result = lookup(m_call.name, env);

            if (macrodeclaration(macroDef(_)) !:= lookup_result) {
                throw MacroExpansionException("Undeclared Macro Definition: <toString(m_call)>", typeCast(#node, m_call).src);
            } else {
                arg_def_table = make_arg_param_env(m_call.args, lookup_result.macroDecl.macroDef.mparams, m_call, env);
                new_env = insert_into_env(arg_def_table, env);
                result += expandMacros(lookup_result.macroDecl.macroDef.decls, env=new_env);
            }
        } else if (macrodeclaration(macroConditional(macroIf(Expr expr, list[Declaration] decls), list[MacroElseIf] macElseIf, list[MacroElse] macElse)) := d) {
            Expr if_eval = eval(expr, env);
            if (boolean("true") := if_eval) {
                result += expandMacros(decls, env=env);
            } else if (boolean("false") := if_eval) {
                bool ignore_else = false; // If an else if condition matches evaluates to true, we set this as true
                
                // for each else if evaluate and execute if match
                for (el <- macElseIf) {
                    Expr else_if_eval = eval(el.expr, env);
                    if (boolean("true") := else_if_eval) {
                        result += expandMacros(el.decls, env=env);
                        ignore_else = true;
                        break;
                    }
                }
                if ([macroElse(list[Declaration] decls)] := macElse && ignore_else == false) {
                    result += expandMacros(decls, env=env);
                }
            }
        } else if(macrodeclaration(macroForLoop(macroFor(str name, Expr expr, list[Declaration] decls))) := d) {
            Expr macro_iterable = lookup(expr.names[0], env);
            if (!isIterable(macro_iterable)) {
                throw "Expected an iterable: <macro_iterable>";
            }

            list[Expr] list_items = (\list(el) := macro_iterable) ? el : [];

            for (item <- list_items) {
                Environment new_env = insert_into_env((name: <macroExpr(item), macrobind(), cast(#loc, typeCast(#node, item).src)>), env);
                list[Declaration] temp_result = expandMacros(decls, env=insert_into_env((name: <macroExpr(item), macrobind(), cast(#loc, typeCast(#node, item).src)>), env));
                result += temp_result[0];
            }
        } else {
            // Handling Substitutions 
            substitution_result = top-down visit(d) {
                case macroEntity(
                    []
                    , []
                    , []
                    , []
                    , []
                    , []
                    , []
                    , []
                    , []
                    , []
                    , []
                    , macInt:macroInterpolation(_)
                    , list[Field] fields
                ):{ 
                    str stripQuote(str x) = replaceLast(replaceFirst(x, "\"", ""),"\"", "");
                    lookup_result = lookup(macInt.macroName, env);

                    if (string(_) !:= lookup_result) {
                        throw "<macInt.macroName> must be of string type";
                    }
                    
                    str entityName = stripQuote((string(lit):= lookup_result) ? lit : "<macInt>");
                    insert entity(
                        []
                        , []
                        , []
                        , []
                        , []
                        , []
                        , []
                        , []
                        , []
                        , []
                        , []
                        , []
                        , entityName
                        , fields
                    );
                }
                case macroView(list[IfNotExists] ifNotExists
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
                    , list[JoinConditions] joinConditions): {
                        
                    str stripQuote(str x) = replaceLast(replaceFirst(x, "\"", ""),"\"", "");
                    lookup_result = lookup(macroName.macroName, env);

                    if (string(_) !:= lookup_result) {
                        throw "<macroName.macroName> must be of string type";
                    }
                    
                    str view_name = stripQuote((string(lit):= lookup_result) ? lit : "<macroName>");
                    insert view([], viewDecl(ifNotExists
                                , drop
                                , temp
                                , viewName(view_name) 
                                , distinct 
                                , viewNameOrWildcard
                                , mixinsOrEmpty
                                , transpositionFunction
                                , viewVarOrEmpty
                                , subViewsOrEmpty
                                , viewFields
                                , filterOrEmpty
                                , groupingOrEmpty
                                , orderByClsOpt
                                , joinConditions
                            ));
                    
                }
            };
            // TODO: Check if it is valid PTL syntax, 
            // temp approach:- do prettyprinting and parse to check if it's valid.
            result += [substitution_result];
        }
    }
    return result;
}


bool isIterable(Expr e) {
    switch(e) {
        case \set(_): return true;
        case \tuple(_): return true;
        case \list(_): return true;
        case \map(_): return true;
        default: return false;
    }
}


&T cast(type[&T] t, value x) {
    if (&T e := x) 
        return e;
    throw "cast exception <x> can not be matched to <t>";
} 

