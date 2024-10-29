module lang::yaml::grammar::Implode

extend lang::yaml::ast::AST;

import lang::yaml::grammar::Parse;
import ParseTree;
import IO;


public Document implode(Tree pt) = implode(#Document, pt);

public Document load(loc l) = implode(#Document, parse(l));

public void loadToFile(loc src) = iprintToFile(|project://ptl/src/lang/yaml/examples/aterm.conf|, load(src));
