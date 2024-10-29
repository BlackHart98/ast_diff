module lang::python::prettyprint::Expression

import lang::python::ast::Python;

import List;
extend util::Maybe;

// Expressions
default str prettyPython(Expression expr){
    switch(expr){
        // Arithmetic Exoression
        case add(lhs, rhs): {return "(<prettyPython(lhs)> + <prettyPython(rhs)>)";}
        case sub(lhs, rhs): {return "(<prettyPython(lhs)> - <prettyPython(rhs)>)";}
        case mult(lhs, rhs) : {return "(<prettyPython(lhs)> * <prettyPython(rhs)>)";}
        case matmult(lhs, rhs) : {return "(<prettyPython(lhs)> @ <prettyPython(rhs)>)";}
        case \div(lhs, rhs) : {return "(<prettyPython(lhs)> / <prettyPython(rhs)>)";}
        case \mod(lhs, rhs) : {return "(<prettyPython(lhs)> % <prettyPython(rhs)>)";}
        case \pow(lhs, rhs) : {return "(<prettyPython(lhs)> ** <prettyPython(rhs)>)";} 
        case uadd(operand) : {return "+<prettyPython(operand)>";}
        case usub(operand) : {return "-<prettyPython(operand)>";}
        case floordiv(lhs, rhs) : {return "(<prettyPython(lhs)> // <prettyPython(rhs)>)";}

        // Bitwise Expression
        case lshift(lhs, rhs) : {return "(<prettyPython(lhs)> \<\< <prettyPython(rhs)>)";}
        case rshift(lhs, rhs) : {return "(<prettyPython(lhs)> \>\> <prettyPython(rhs)>)";}
        case bitor(lhs, rhs) : {return "(<prettyPython(lhs)> | <prettyPython(rhs)>)";}
        case bitxor(lhs, rhs) : {return "(<prettyPython(lhs)> ^ <prettyPython(rhs)>)";}
        case bitand(lhs, rhs) : {return "(<prettyPython(lhs)> & <prettyPython(rhs)>)";}
        case bitand(lhs, rhs) : {return "(<prettyPython(lhs)> & <prettyPython(rhs)>)";}
        case invert(operand) : {return "~<prettyPython(operand)>";}

        // Logical Expression
        case \not(operand) : {return "not <prettyPython(operand)>";}
        case and(exprs):{return "<intercalate("and", [prettyPython(expr)|expr <- exprs])>";}
        case or(exprs):{return "<intercalate("or", [prettyPython(expr)|expr <- exprs])>";}

        // Lambda Expression
        case lambda(formals, body): {return "lambda <prettyPython(formals)> : <prettyPython(body)>";}

        // Named Expression
        case namedExpr(target, \value):{return "<prettyPython(target)> := <prettyPython(\value)>";}

        // If Expression
        case ifExp(\test, body, orelse): {return "<prettyPython(\test)> if <prettyPython(body)> else <prettyPython(orelse)>";}

        // Python Objects
        case dict(keys, values):{
            list[str] keys_str = [prettyPython(key) | key <- keys];
            list[str] values_str = [prettyPython(\value) | \value <- values];
            lrel[str key, str \value] dict_value = zip2(keys_str, values_str);

            dict_obj = [d.key + ":" + d.\value| d <- dict_value];
            return "{<intercalate(", ", dict_obj)>}";
        }
        case \set(elts):{return "{<intercalate(", ", [prettyPython(expr)|expr <- elts])>}";}
        
        // Comprehension Expression
        case listComp(elt, generators): {
            list[str] gen_list = [prettyPython(\value) | \value <- generators];
            return "[<prettyPython(elt)> <intercalate(" ", gen_list)>]";
        }
        case setComp(elt, generators):{
            list[str] gen_list = [prettyPython(\value) | \value <- generators];
            return "{<prettyPython(elt)> <intercalate(" ", gen_list)>}";
        }
        case dictComp(key, \value, generators):{
            list[str] gen_list = [prettyPython(\value) | \value <- generators];
            return "{<prettyPython(key)>:<prettyPython(\value)> <intercalate(" ", gen_list)>}";
        }


        // Generator Expression
        case generatorExp(elt, generators):{
            list[str] gen_list = [prettyPython(\value) | \value <- generators];
            return "(<prettyPython(elt)> <intercalate(" ", gen_list)>)";
        }
        case  await(\value): {return "await <prettyPython(\value)>";}
        case yield(\value): {return "yield"+ "<just(exp) := \value ? " <prettyPython(exp)>":"">";}
        case yieldFrom(\value):{return "yield from <prettyPython(\value)>";}
        

        // Compare Expression
        case compare(lhs, list[CmpOp] ops, list[Expression] comparators) : {
            list[str] ops_str = [prettyPython(op) | op <- ops];
            list[str] comparators_str = [prettyPython(comparator) | comparator <- comparators];
            lrel[str op, str comparator] cmp_list = zip2(ops_str, comparators_str);

            compare = <intercalate(" ", [c.op + " " + c.comparator| c <- cmp_list])>;
            return "<prettyPython(lhs)>" + "<[] := cmp_list? "" : " <compare>">";
        }

        // Function Call
        case  call(func, list[Expression] args, list[Keyword] keywords): {
            list[str] args_str = [prettyPython(arg) | arg <- args];
            list[str] keywords_str = [prettyPython(arg) | arg <- keywords];
            
            return "<prettyPython(func)>(<intercalate(", ", args_str+keywords_str)>)";
        }
        // String Formatter
        case joinedStr(values): {return "f\"<(""|it + prettyPython(v)|v <- values)>\"";}
        case formattedValue(\value, conversion, formatSpec):{
            str value_str = prettyPython(\value);
            str result = "<value_str>" + "<just(fmt) := conversion ? "<prettyPython(fmt)>":"">" + "<just(fmt) := formatSpec ? ":<prettyPython(fmt)>":"">";
            return "{<result>}";
        }

        // Constant
        case constant(\const, _): {return "<prettyPython(\const)>";}

        // Expression misc.
        case attribute(\value, attr, _):{return "<prettyPython(\value)>.<attr>";}
        case subscript(\value, slice, _):{return "<prettyPython(\value)>[<prettyPython(slice)>]";}
        case starred(\value, _):{return "*<prettyPython(\value)>";}
        case name(id, _): {return "<id>";}
        case \list(elts, _):{return "[<intercalate(", ", [prettyPython(\value) | \value <- elts])>]";}
        case \tuple(elts, _):{return "(<intercalate(", ", [prettyPython(\value) | \value <- elts])>)";}

        // Can appear only in Subscript
        case \slice(lower, upper, step):{
            str lower_str = just(exp) := lower ? "<prettyPython(exp)>":"";
            str upper_str = just(exp) := upper ? "<prettyPython(exp)>":"";
            str step_str = just(exp) := step ? "<prettyPython(exp)>":"";
            return "<lower_str>:<upper_str>:<step_str>";
        }

        default : throw "Unknown Expression";
    }
}

str prettyPython(Comprehension comprehension){
    switch(comprehension){
        case comprehension(target, iter, list[Expression] ifs, bool isAsync):{
            list[str] ifs_str = [prettyPython(\if) | \if <- ifs];
            str async = isAsync ? "async " : "";
            return async + "for <prettyPython(target)> in <prettyPython(iter)>" + "<[] := ifs? "" : intercalate(" ", ifs_str)>";
        }
        default : throw "Unknown Comparators";
    }
}

// Conversion
str prettyPython(Conversion conversion){
    switch(conversion){
        case noFormatting():{return "";}
        case stringFormatting():{return "!s";}
        case reprFormatting():{return "!r";}
        case asciiFormatting():{return "!a";}
        default : throw "Unknown Conversion";
    }
}


// Compare Operator
str prettyPython(CmpOp cmp){
    switch(cmp){
        case eq(): {return "==";}
        case noteq() :{return "!=";}
        case lt() :{return "\<";}
        case lte() :{return "\<=";}
        case gt() :{return "\>";}
        case gte() :{return "\>=";}
        case is() :{return "is";}
        case isnot() :{return "is not";}
        case \in() :{return "in";}
        case \notin() :{return "not in";}
        default : throw "Unknown Comparators";
    }
}

// Arguments
str prettyPython(Arguments arguments){
    switch(arguments){
        case arguments(posonlyargs, args, varargs, kwonlyargs, kw_defaults, kwarg, defaults): {
            list[str] posonlyargs_str = [prettyPython(arg)|arg <- posonlyargs];
            list[str] args_str = [prettyPython(arg)|arg <- args];
            list[str] varargs_str = just(exp) := varargs ? ["*"+prettyPython(exp)]:[];
            list[str] kwonlyargs_str = ["**" + prettyPython(arg)|arg <- kwonlyargs];
            list[str] kw_defaults_str = ["**" + prettyPython(arg)|arg <- kw_defaults];
            list[str] kwarg_str = just(exp) := kwarg ? ["**" + prettyPython(exp)]:[];
            list[str] defaults_str = [prettyPython(arg)|arg <- defaults];

            list[str] concat_args = concat([
                posonlyargs_str
                , args_str
                , varargs_str
                , kwonlyargs_str
                , kw_defaults_str
                , kwarg_str
                , defaults_str
                ]
            );
            return "<intercalate(", ", concat_args)>";
        }
        default : throw "Unknown Expression";
    }
}

// Arg
str prettyPython(Arg arg){
    switch(arg){
        case arg(Identifier arg, annotation, _): {
            str annotation_str = "<just(exp) := annotation ? " : <prettyPython(exp)>":"">";
            return "<arg>"+"<annotation_str>";
        }
        default : throw "Unknown Expression";
    }
}

// Constant
str prettyPython(Constant \const){
    switch(\const){
        case none(): {return "None";}
        case number(n):{return "<n>";}
        case string(s):{return "\"\"\"<s>\"\"\"";}
        case \tupleConst(elts):{return "(<intercalate(", ", [prettyPython(e)|e <- elts])>)";}
        case \setConst(elts):{return "{<intercalate(", ", [prettyPython(e)|e <- elts])>)";} 
        case \listConst(elts):{return "[<intercalate(", ", [prettyPython(e)|e <- elts])>]";} 
        case \dictConst(keys, values):{
            list[str] keys_str = [prettyPython(key) | key <- keys];
            list[str] values_str = [prettyPython(\value) | \value <- values];
            lrel[str key, str \value] dict_value = zip2(keys_str, values_str);

            dict_obj = [d.key + ":" + d.\value| d <- dict_value];
            return "{<intercalate(", ", dict_obj)>}";
        }  
        default : throw "Unknown Expression";
    }
}

// Keyword
str prettyPython(Keyword \keyword){
    switch(\keyword){
        case \keyword(arg, \value):{return "<just(a) := \arg ? "<a>=":"**">" + "<prettyPython(\value)>";}
        default : throw "Unknown Expression";
    }
}
