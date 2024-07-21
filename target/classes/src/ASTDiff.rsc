module ASTDiff

import lang::xml::DOM;
import lang::json::ast::JSON;
// import lang::json::ast::Implode;
import lang::json::IO;
import Node;
import Type;
import ParseTree;
import IO;
import Node;
import List;
import String;

// syntax 


@javaClass{internals.RascalGumTree}
java str compareAST(str src, str dst);


@javaClass{internals.RascalGumTree}
java str compareASTXml(str src, str dst);

// Rascal AST to GumTree XML
str toGumTree(&T <: node input_ast){

    // println("Node: <input_ast>");
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

    list[Node] toGumTreeNodeList(list[node] child_list){
        return [toGumTreeNode(x)| node x <- child_list]; 
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
        + toGumTreeNodeList(getChildren(input_ast)[0])
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


// Diff algorithms
data DiffTree 
    = insertNode(node node_) 
    | keepNode(node src, node dest) 
    | removeNode(node node_)
    | updateNode(node src)
    | moveNode(node node_)
    | matchedNode(node src, node dest)
    | emptyNode()
    ;


list[DiffTree] makeDiffTreeKeep(list[DiffTree] diff_tree_list){
    return [keepNode(src, dest) | matchedNode(src, dest)  <- diff_tree_list && src := dest];
}

DiffTree makeDiffTreeMatch(JSON json_obj){
    switch (json_obj){
        case object(x): {
            makeDiffNode(x["src"]);
            return matchedNode(makeDiffNode(x["src"]), makeDiffNode(x["dest"]));
        }
        default: return emptyNode();
    }
}


DiffTree makeDiffTree(JSON json_obj){
    switch (json_obj){
        case object(x): {
            if(x["action"] == string("move-tree")){
                return moveNode(makeDiffNode(x["tree"]));
            } else if (x["action"] == string("delete-node")){
                return removeNode(makeDiffNode(x["tree"]));
            } else if (x["action"] == string("update-node")){
                return updateNode(makeDiffNode(x["tree"]));
            } else if (x["action"] == string("insert-node")){
                return insertNode(makeDiffNode(x["tree"]));
            } else{
                return emptyNode();
            }
        }
        default: return emptyNode();
    }
}

list[DiffTree] _diff(
    JSON diff_json
    , loc src_loc=|unknown:///|
    , loc dest_loc=|unknown:///|){
    list[DiffTree] match_nodes = [makeDiffTreeMatch(x) | x <- diff_json.properties["matches"].values];
    list[DiffTree] keep_nodes = makeDiffTreeKeep(match_nodes);
    list[DiffTree] other_nodes = [makeDiffTree(action)| action <- diff_json.properties["actions"].values];

    return keep_nodes + other_nodes;
}


node makeDiffNode(string(str x)){
    list[str] temp_ = split(" ", x);
    // println("splited string: <makeNode(temp_[0], temp_[1..-1])>");
    return makeNode(replaceLast(temp_[0], ":", ""), temp_[1..-1]);
}


list[DiffTree] diff(
    type[&T <: Tree] grammar
    , type[&U <: node] ast
    , str src
    , str dest
    , loc src_loc=|unknown:///|
    , loc dest_loc=|unknown:///|){

    node temp_ast_1 = implode(ast, parse(grammar, src));
    node temp_ast_2 = implode(ast, parse(grammar, dest));
    str result_1 = toGumTree(temp_ast_1);
    str result_2 = toGumTree(temp_ast_2);
    str compare_ast = compareAST(result_1, result_2);
    JSON deserialize_actions = deserializeActions(compare_ast);

    return _diff(deserialize_actions);
}


list[DiffTree] diff(
    type[&T <: Tree] grammar
    , type[&U <: node] ast
    , loc src_file
    , loc dest_file){

    node temp_ast_1 = implode(ast, parse(grammar, readFile(src_file)));
    node temp_ast_2 = implode(ast, parse(grammar, readFile(dest_file)));
    str result_1 = toGumTree(temp_ast_1);
    str result_2 = toGumTree(temp_ast_2);
    str compare_ast = compareAST(result_1, result_2);
    JSON deserialize_actions = deserializeActions(compare_ast);

    return _diff(deserialize_actions);
}