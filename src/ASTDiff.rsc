module ASTDiff

import lang::xml::DOM;
import lang::json::ast::JSON;
import lang::json::IO;
import Node;
import Type;
import ParseTree;
import IO;
import Node;
import List;
import String;



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


// Diff 

alias DiffTree = tuple[loc src, loc dest, list[DiffNode] diffNodeList];

data DiffNode 
    = insertNode(node tree) 
    | keepNode(node src, node dest) 
    | removeNode(node tree)
    | updateNode(node src, node dest)
    | moveNode(node tree)
    | matchedNode(node src, node dest)
    | emptyNode()
    ;


list[DiffNode] makeDiffNodeKeep(list[DiffNode] diff_tree_list){
    return [keepNode(src, dest) | matchedNode(src, dest)  <- diff_tree_list && src := dest];
}

DiffNode makeDiffNodeMatch(JSON json_obj){
    switch (json_obj){
        case object(x): {
            makeDiffNode(x["src"]);
            return matchedNode(makeDiffNode(x["src"]), makeDiffNode(x["dest"]));
        }
        default: return emptyNode();
    }
}

DiffNode makeUpdateNode(map[str, JSON] x){
    node temp_ = makeDiffNode(x["tree"]);
    list[str] children = string(child_) := x["label"]? [child_]:[];
    return updateNode(temp_, makeNode(getName(temp_), children));
}

DiffNode makeDiffNode(JSON json_obj){
    switch (json_obj){
        case object(x): {
            if(x["action"] == string("move-tree")){
                return moveNode(makeDiffNode(x["tree"]));
            } else if (x["action"] == string("delete-node")){
                return removeNode(makeDiffNode(x["tree"]));
            } else if (x["action"] == string("insert-node")){
                return insertNode(makeDiffNode(x["tree"]));
            } else{
                return makeUpdateNode(x);
            }
        }
        default: return emptyNode();
    }
}

DiffTree _diff(
    JSON diff_json
    , loc src_loc=|unknown:///|
    , loc dest_loc=|unknown:///|){
    list[DiffNode] match_nodes = [makeDiffNodeMatch(x) | x <- diff_json.properties["matches"].values];
    list[DiffNode] keep_nodes = makeDiffNodeKeep(match_nodes);
    list[DiffNode] other_nodes = [makeDiffNode(action)| action <- diff_json.properties["actions"].values];

    return <src_loc, dest_loc, (keep_nodes + other_nodes)>;
}


node makeDiffNode(string(str x)){
    list[str] temp_ = split(" ", x);
    list[str] tempLast_ = split(",", replaceFirst(replaceLast(temp_[-1], "]", ""), "[", ""));

    list[int] location = [toInt(x) | str x <- tempLast_];

    return makeNode(
        replaceLast(
            temp_[0], ":", "")
            , temp_[1..-1]
            , keywordParameters = ("location":location)
        );
}


DiffTree diff(
    type[&T <: Tree] grammar
    , type[&U <: node] ast
    , str src
    , str dest){

    node temp_ast_1 = implode(ast, parse(grammar, src));
    node temp_ast_2 = implode(ast, parse(grammar, dest));
    str result_1 = toGumTree(temp_ast_1);
    str result_2 = toGumTree(temp_ast_2);
    str compare_ast = compareAST(result_1, result_2);
    JSON deserialize_actions = deserializeActions(compare_ast);

    // iprintln(deserialize_actions);
    return  _diff(deserialize_actions, src_loc=|unknown:///|, dest_loc=|unknown:///|);
}


DiffTree diff(
    type[&T <: Tree] grammar
    , type[&U <: node] ast
    , loc src_loc
    , loc dest_loc){

    node temp_ast_1 = implode(ast, parse(grammar, readFile(src_loc)));
    node temp_ast_2 = implode(ast, parse(grammar, readFile(dest_loc)));
    str result_1 = toGumTree(temp_ast_1);
    str result_2 = toGumTree(temp_ast_2);
    str compare_ast = compareAST(result_1, result_2);
    JSON deserialize_actions = deserializeActions(compare_ast);

    // iprintln("Matches&Actios:\n<deserialize_actions>");
    return _diff(deserialize_actions, src_loc=src_loc, dest_loc=dest_loc);
}