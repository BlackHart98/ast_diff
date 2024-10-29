module lang::python::prettyprint::Python

import lang::python::ast::Python;

import List;

extend lang::python::prettyprint::Statement;




default str prettyPython(Module modl){
    switch(modl){
        case \module(body, _):{return "<intercalate("\n", [prettyPython(b)| Statement b <- body])>\n\n";}
        case \interactive(body):{return "<intercalate("\n", [prettyPython(b)| Statement b <- body])>\n\n";}
        case \expression(expr):{return "<prettyPython(expr)>";}
        default: throw "Unknown Expression";
    }
}
