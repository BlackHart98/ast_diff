module lang::orc::LanguageServer

import ParseTree;

extend analysis::typepal::TypePal;
import util::Reflective;
import util::LanguageServer;
import lang::orc::grammar::Orc;
import Prelude;


// a minimal implementation of a DSL in rascal
// users can add support for more advanced features
set[LanguageService] orcContributions() = {
    parser(parser(#start[Orc])) 
};

 
void setupIDE() {
  registerLanguage(
    language(
    pathConfig(srcs = [|std:///|, |project://adept-base/src|]),
    "Orc Lang", 
    "orc", 
    "lang::orc::LanguageServer",
    "orcContributions"
    ));
}