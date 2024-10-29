module lang::configlang::LanguageServer

extend analysis::typepal::TypePal;
import lang::configlang::grammar::Configlang;

import util::Reflective;
import util::LanguageServer;
import ParseTree;
import Prelude;


void setupIDE() {
  registerLanguage(
    language(
    pathConfig(srcs = [|std:///|, |project://adept-base/src|]),
    "Config Lang", 
    "pcf", 
    "lang::configlang::LanguageServer",
    "configlangContributions"
    ));
}

set[LanguageService] configlangContributions() = {
    parser(parser(#start[Config]))
};