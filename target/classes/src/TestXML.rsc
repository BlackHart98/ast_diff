module TestXML

import lang::xml::DOM;
import IO;
import List;
import Node;
import Type;
import ParseTree;


start syntax SimpleExpr = left add: SimpleExpr "+" SimpleExpr;

syntax SimpleExpr = number: INT;

lexical INT = [0-9] !<< [0-9]+ !>> [0-9];

layout Standard 
	= WhitespaceOrComment* !>> [\u0009-\u000D \u0020 \u0085 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000] !>> "--"
	;

lexical COMMENT_LIT 
	= @category="COMMENT_LIT" "--" ![\n]* $
	;

syntax WhitespaceOrComment 
	= whitespace: Whitespace | comment_lit: COMMENT_LIT
	;

lexical Whitespace
	= [\u0009-\u000D \u0020 \u0085 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000]
	;


// ADT
data SimpleExpr = \add(SimpleExpr left, SimpleExpr right);
data SimpleExpr = number(str intlit);


    

// Rascal AST to GumTree XML
str toGumTree(&T <: node input_ast){
    Node toGumTreeNode(&T <: node child){
        loc temp_loc = typeCast(#loc, getKeywordParameters(child)["src"]);
        Node result = element(none(), "tree", []); 
        result.children += [attribute(none(), "type", getName(child))]
            + [attribute(none(), "length", "<temp_loc.length>")]
            + [attribute(none(), "pos", "<temp_loc.offset>")]
            + [toGumTreeNode(x, length=temp_loc.length, offset=temp_loc.offset)| x <- getChildren(child) && [*_] !:= x]
            + ([]|it + toGumTreeNode(y, length=temp_loc.length, offset=temp_loc.offset)| list[&T] x <- getChildren(child), [*&T _] := x, y <- x)
            + ([]|it + toGumTreeNode(y, length=temp_loc.length, offset=temp_loc.offset)| list[str] x <- getChildren(child), [*str _] := x, y <- x)
            ;

        return result;
    }


    Node toGumTreeNode(str child, int length=0, int offset=0){
        Node result = element(none(), "tree", []);
        result.children += [attribute(none(), "type", "token")]
            + [attribute(none(), "length", "<length>")]
            + [attribute(none(), "pos", "<offset>")]
            + [attribute(none(), "label", child)]
            ; 

        return result;
    }

    Node result = element(none(), "tree", []);

    loc temp_loc = typeCast(#loc, getKeywordParameters(input_ast)["src"]);
    result.children += [attribute(none(), "type", getName(input_ast))]
        + [attribute(none(), "length", "<temp_loc.length>")]
        + [attribute(none(), "pos", "<temp_loc.offset>")]
        + [toGumTreeNode(x)| x <- getChildren(input_ast) && [*_] !:= x]
        ;
    
    
    return xmlPretty(document(result));
}

