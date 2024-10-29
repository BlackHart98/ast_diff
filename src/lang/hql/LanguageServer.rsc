module lang::hql::LanguageServer



import ParseTree;

import util::Reflective;
import util::LanguageServer;
import lang::hql::grammar::HQL;

import Prelude;




// a minimal implementation of a DSL in rascal
// users can add support for more advanced features
set[LanguageService] hqlContributions() = {
    parser(parser(#start[HQLStart]))

};



void setupIDE() {
  registerLanguage(
    language(
    pathConfig(srcs = [|std:///|, |project://adept-base/src|]),
    "Hive QL", 
    "hql", 
    "lang::hql::LanguageServer",
    "hqlContributions"
    ));
}