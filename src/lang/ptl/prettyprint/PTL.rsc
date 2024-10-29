module lang::ptl::prettyprint::PTL
import List;
extend lang::ptl::prettyprint::Macros;
import lang::ptl::ast::PTL;
str toString(Program prg){
    switch(prg){
        case \module(str moduleId, list[Import] importlist, list[Declaration] decls):
            return "module <moduleId> \n <intercalate("\n",[toString(imp)|imp<-importlist])> 
            '<intercalate("\n \n",[toString(dec)|dec<-decls])>";
        case expression(e): return "<toString(e)>"; 
        default: return "";
    }
}

str toString(Import i){
    return "import <i.moduleId>";
}