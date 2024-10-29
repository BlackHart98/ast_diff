module lang::athena::LanguageServer



import ParseTree;

import util::Reflective;
import util::LanguageServer;
import lang::athena::grammar::Athena;

import Prelude;




// a minimal implementation of a DSL in rascal
// users can add support for more advanced features
set[LanguageService] athenaContributions() = {
    parser(parser(#start[Athena]))

};



void setupIDE() {
  registerLanguage(
    language(
    pathConfig(srcs = [|std:///|, |project://adept-base/src|]),
    "Athena SQL", 
    "sql", 
    "lang::Athena::LanguageServer",
    "athenaContributions"
    ));
}