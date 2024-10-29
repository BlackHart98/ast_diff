module lang::configlang::checker::Tests

extend analysis::typepal::TestFramework;
extend lang::configlang::checker::Checker;
import lang::configlang::grammar::Configlang;
import ParseTree;


//implementing checker test
TModel syntaxTModelFromLoc(loc code){
    pt = parse(#start[Config], code);
    return collectAndSolve(pt);
}
TModel syntaxTModelFromTree(Tree pt){
    return collectAndSolve(pt);
}
    
