module Main

import IO;
import List;
// import Node;
import TestXML;
import ParseTree;



@javaClass{internals.RascalGumTree}
java str compareAST(str src, str dst);




int main(int testArgument=0) {


    // Node xml_node = parseXMLDOMTrim(readFile(|project://ast_diff/src/main/rascal/test.xml|));
    SimpleExpr temp_ast = implode(#SimpleExpr, parse(#start[SimpleExpr], "2 + 4 + 3"));
    str result = toGumTree(temp_ast);
    iprintln(compareAST(result, result));

    writeFile(|project://ast_diff/src/test_output.xml|, result);

    return testArgument;
}
