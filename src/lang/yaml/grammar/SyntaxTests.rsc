module lang::yaml::grammar::SyntaxTests

extend lang::yaml::grammar::Syntax;

import IO;
import ParseTree;
import Exception;


// # MappingBlock
test bool testMappingToValue() {
   try {
     parse(#MappingBlock, "val: 55");
     return true;
   }
   catch ParseError(loc l): {
     println("I found a parse error at line <l.begin.line>, column <l.begin.column>"); 
     return false; 
   }
}

test bool testMappingToBlock() {
   try {
     parse(#MappingBlock, "another: \n  - run : \"world\"");
     return true;
   }
   catch ParseError(loc l): {
     println("I found a parse error at line <l.begin.line>, column <l.begin.column>"); 
     return false; 
   }
}

test bool testMappingToValueWithType() {
   try {
     parse(#MappingBlock, "test@string: \"hello\"");
     return true;
   }
   catch ParseError(loc l): {
     println("I found a parse error at line <l.begin.line>, column <l.begin.column>"); 
     return false; 
   }
}

test bool testComplexDocument() {
    try {
     parse(#start[Document], "test@string: \"hello\"\nanother: \n  - run : \"world\"\n  - second: \n    - foo : \"3\"\n  - play : 4");
     return true;
   }
   catch ParseError(loc l): {
     println("I found a parse error at line <l.begin.line>, column <l.begin.column>"); 
     return false; 
   }
}

test bool testParseValuesSeparatedByNewLine() {
   try {
     parse(#Value, "val\n val");
     return true;
   }
   catch ParseError(loc l): {
     println("I found a parse error at line <l.begin.line>, column <l.begin.column>"); 
     return false; 
   }
}

void main (){
  println(parse(#start[Document], |project://ptl/src/lang/yaml/examples/test.conf|));
}