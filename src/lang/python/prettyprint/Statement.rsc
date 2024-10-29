module lang::python::prettyprint::Statement


import lang::python::ast::Python;

import List;

extend lang::python::prettyprint::Expression;

default str prettyPython(Statement stmt, str tabs=""){
    switch(stmt){
        // Function Definition
        case functionDef(name, formals, body, decorators, returns, _):{
            str formals_str = prettyPython(formals);
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            list[str] decorators_str = ["@" + prettyPython(d) | d <- decorators];
            str returns_str = just(r) := returns? "-\> <prettyPython(r)>" : ""; 

            return "<[] := decorators_str ? "" : "<intercalate("\n", decorators_str)>\n" + tabs>" +
                "def <name>(<formals_str>)"+ returns_str +":" + "\n"
                    + intercalate("\n", body_str)
                ;
        }
        case asyncFunctionDef(name, formals, body, decorators, returns, _):{
            str formals_str = prettyPython(formals);
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            list[str] decorators_str = ["@" + prettyPython(d) | d <- decorators];
            str returns_str = just(r) := returns? "-\> <prettyPython(r)>" : ""; 

            return "<[] := decorators_str ? "" : "<intercalate("\n", decorators_str)>\n" + tabs>" +
                "async def <name>(<formals>)"+ returns_str +":\n"
                    + intercalate("\n", body_str)
                ;
        }

        // Class Definition
        case classDef(name, bases, list[Keyword] keywords, body, decorators):{
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            list[str] decorators_str = ["@" + prettyPython(d) | d <- decorators];
            list[str] bases_str = [prettyPython(d) | d <- bases];
            list[str] keywords_str = [prettyPython(d) | d <- keywords];

            list[str] resolved = [
                "<[] := bases ? "" : "<intercalate(", ", bases_str)>">"
                , "<[] := keywords ? "" : "<intercalate(", ", keywords_str)>">"
            ];
            return "<[] := decorators_str ? "" : "<intercalate("\n", decorators_str)>\n" + tabs>" +
                "class <name>" + "<[] := bases_str + keywords_str? "" : "(<intercalate(", ", resolved)>)">"+ ":\n" 
                    + intercalate("\n", body_str)
                ;
        }

        // Return Statement
        case \return(Maybe[Expression] optValue):{return "return" + "<just(r) := optValue ? " <prettyPython(r)>" : "">";}

        // Delete Statement
        case delete(targets):{return "del <intercalate(", ", [prettyPython(a)|a <- targets])>";}
        
        // Assignment Statement
        case assign(targets, \val, _):{
            list[str] targets_str = [prettyPython(t) | t <- targets];
            return "<intercalate(", ", targets_str)> = <prettyPython(\val)>";
        }
        case addAssign(target, \val):{return "<prettyPython(target)> += <prettyPython(\val)>";}
        case subAssign(target, \val):{return "<prettyPython(target)> -= <prettyPython(\val)>";}
        case multAssign(target, \val):{return "<prettyPython(target)> *= <prettyPython(\val)>";}
        case matmultAssign(target, \val):{return "<prettyPython(target)> @= <prettyPython(\val)>";}
        case divAssign(target, \val):{return "<prettyPython(target)> /= <prettyPython(\val)>";}
        case modAssign(target, \val):{return "<prettyPython(target)> %= <prettyPython(\val)>";}
        case powAssign(target, \val):{return "<prettyPython(target)> **= <prettyPython(\val)>";}
        case lshiftAssign(target, \val):{return "<prettyPython(target)> \<\<= <prettyPython(\val)>";}
        case rshiftAssign(target, \val):{return "<prettyPython(target)> \>\>= <prettyPython(\val)>";}
        case bitorAssign(target, \val):{return "<prettyPython(target)> |= <prettyPython(\val)>";}
        case bitandAssign(target, \val):{return "<prettyPython(target)> &= <prettyPython(\val)>";}
        case floordivAssign(target, \val):{return "<prettyPython(target)> //= <prettyPython(\val)>";}
        case multAssign(target, \val):{return "<prettyPython(target)> *= <prettyPython(\val)>";}
        case multAssign(target, \val):{return "<prettyPython(target)> *= <prettyPython(\val)>";}
        case annAssign(target, annotation, \val, _):{
            str val_str = just(ann) := \val? " = <prettyPython(ann)>" : "";
            return "<prettyPython(target)> : <prettyPython(target)> : <prettyPython(annotation)>"+val_str;
        }


        // Control statement
        case \for(target, iter, body, orElse, _):{
            str target_str = prettyPython(target);
            str iter_str = prettyPython(iter);
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            list[str] orelse_str = [tabs + "\t" + prettyPython(e, tabs=tabs + "\t") | e <- orElse];

            return "for <target_str> in <iter_str>:\n"
                   + intercalate("\n", body_str) + "\n"
                + "<[] :=  orElse ?"":"else:\n<intercalate("\n", orelse_str)>">" 
                ;
        }
        case asyncFor(target, iter, body, orElse, _):{
            str target_str = prettyPython(target);
            str iter_str = prettyPython(iter);
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            list[str] orelse_str = [tabs + "\t" + prettyPython(e, tabs=tabs + "\t") | e <- orElse];

            return "async for <target_str> in <iter_str>:\n"
                    + intercalate("\n", body_str) + "\n"
                + "else:"
                    + intercalate("\n", orelse_str)
                ;
        }
        case \while(Expression \test, list[Statement] body, list[Statement] orElse):{
            str test_str = prettyPython(\test);
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            list[str] orelse_str = [tabs + "\t" + prettyPython(e, tabs=tabs + "\t") | e <- orElse];

            return "while <test_str>:\n"
                   + intercalate("\n", body_str) + "\n"
                + "<[] :=  orElse ?"":"else:\n<intercalate("\n", orelse_str)>">" 
                ;
        }

        // Conditional statement - revisit this for cleaner pretty print
        case \if(\test, body, orElse):{
            str test_str = prettyPython(\test);
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            list[str] orelse_str = [tabs + "\t" + prettyPython(e, tabs=tabs + "\t") | e <- orElse];
            return "if <test_str>:\n" 
                + intercalate("\n", body_str) + "\n"
                + "<[] :=  orElse ?"":"else:\n<intercalate("\n", orelse_str)>">" 
            ;
        }

        // With Statement
        case with(items, body, _):{
            list[str] items_str = [prettyPython(a)|a <- items];
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            return "with <intercalate(", ", items_str)>:\n" 
                + intercalate("\n", body_str)
            ;
        }
        case asyncWith(items, body, _):{
            list[str] items_str = [prettyPython(a)|a <- items];
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            return "async with <intercalate(", ", items_str)>:\n" 
                + intercalate("\n", body_str)
            ;
        }

        // Error Handling statement
        case raise(exc, cause):{
            return "raise" +  "<just(e) := exc? " <prettyPython(e)>" : "">" + "<just(e) := cause? " from <prettyPython(e)>" : "">";
        }
        case \try(body, handlers, orElse, finalBody): {
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            list[str] handlers_str = [tabs + prettyPython(b, tabs=tabs + "\t") | b <- handlers];
            list[str] orelse_str = [tabs + "\t" + prettyPython(e, tabs=tabs + "\t") | e <- orElse];
            list[str] finalBody_str = [tabs + "\t" + prettyPython(e, tabs=tabs + "\t") | e <- finalBody];
            return "try:\n"
                    + intercalate("\n", body_str) + "\n"
                + intercalate("\n", handlers_str) + "\n"
                + "<[] :=  orElse ? "" : "else:\n<intercalate("\n", orelse_str)>" >" 
                + "<[] :=  finalBody ? "" : "finally:\n<intercalate("\n", finalBody_str)>" >"
            ;
        }
        case \assert(\test, msg):{
            return "assert <prettyPython(\test)>" + "<just(opt) := msg ? ", <prettyPython(opt)>": "" >";
        }



        // Import statement
        case \import(aliases):{return "import <intercalate(", ", [prettyPython(a)|a <- aliases])>";}
        case importFrom(\module, aliases, _):{
            str module_str = just(id) := \module? "from <id>" : "";
            str aliases_str = "import <intercalate(", ", [prettyPython(a)|a <- aliases])>";
            return "<nothing() := \module? "<aliases_str>" : "<module_str> <aliases_str>">";
        }

        case global(names): {return "global <intercalate(", ", names)>";}
        case nonlocal(list[Identifier] names): {return "nonlocal <intercalate(", ", names)>";}
        case expr(\value):{return "<prettyPython(\value)>";}
        case pass():{return "pass";}
        case \break():{return "break";}
        case \continue():{return "continue";}

        default: throw "Unknown Statement";
    }
}




// Import Alias
str prettyPython(Alias \alias){
    switch(\alias){
        case \alias(name, asname):{return "<name>" + "<just(al) := asname ? " as <prettyPython(al)>" : "">";}
        default: throw "Unknown Alias";
    }

}


// ExceptHandler
str prettyPython(ExceptHandler ehdl, str tabs=""){
    switch(ehdl){
        case exceptHandler(Maybe[Expression] \type, Maybe[Identifier] optName, list[Statement] body):{
            str type_str = "<just(t) := \type ? " <prettyPython(t)>" :"">";
            str optName_str = "<just(t) := optName ? " as <t>" :"">";
            list[str] body_str = [tabs + "\t" + prettyPython(b, tabs=tabs + "\t") | b <- body];
            return "except" + type_str + optName_str + ":\n"
                + intercalate("n", body_str) + "\n"
            ;
        }
        default: throw "Unknown With Item";
    }
}


str prettyPython(WithItem withItem){
    switch(withItem){
        case withItem(contextExpr, optionalVars):{return "<prettyPython(contextExpr)>" + "<just(opt) := optionalVars ? " as <prettyPython(opt)>" : "">";}
        default: throw "Unknown With Item";
    }
}