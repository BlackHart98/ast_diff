module lang::ptl::LanguageServer

import ParseTree;
import util::Reflective;
import util::LanguageServer;
import lang::ptl::grammar::PTL;

import Prelude;


// a minimal implementation of a DSL in rascal
// users can add support for more advanced features
set[LanguageService] ptlContributions() = {
    parser(parser(#start[Program]))
};


void setupIDE() {
  registerLanguage(
    language(
    pathConfig(srcs = [|std:///|, |project://adept-base/src|]),
    "PTL Grammar", 
    "ptl", 
    "lang::ptl::LanguageServer",
    "ptlContributions"
   ));
}




