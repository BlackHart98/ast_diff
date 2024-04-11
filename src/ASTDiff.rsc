module ASTDiff

import lang::xml::DOM;
import lang::json::ast::JSON;
// import lang::json::ast::Implode;
import lang::json::IO;
import Node;
import Type;
import ParseTree;
// import IO;

    
@javaClass{internals.RascalGumTree}
java str compareAST(str src, str dst);


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
        result.children += [attribute(none(), "type", "$token")]
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
    
    Node t = document(result);

    Node collapseToken(Node t){
        return top-down visit(t){
            case element(_, _,[x, y, z, element(_, _, [attribute(_, _, "$token"), _, _, w])]) 
            => element(none(), "tree", [x, y, z, w])
        };
    }

    return xmlPretty(collapseToken(t));
}



JSON deserializeActions(str json) = fromJSON(#JSON, json);


