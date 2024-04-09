module ASTDiff

import lang::xml::DOM;
// import IO;
// import List;
import Node;
import Type;
import ParseTree;



// Actions
data Actions = actions(list[Action] action_list);

data Action 
    = \insert() 
    | move() 
    | delete() 
    | update(str old_label, str new_label)
    ;
    
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

// private Node deserializeActions(str xml){

// }

