module lang::yaml::grammar::Parse

extend lang::yaml::grammar::Syntax;

import ParseTree;


public start[Document] parse(str src, loc origin) = parse(#start[Document], src, origin);

public start[Document] parse(loc origin) = parse(#start[Document], origin);
