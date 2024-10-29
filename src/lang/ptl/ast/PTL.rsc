module lang::ptl::ast::PTL

extend lang::ptl::ast::Macros;



data Program
    = \module(str moduleId, list[Import] importlist, list[Declaration] decls)
    | expression(Expr expr)
    ;


data Import = \import(str moduleId);
