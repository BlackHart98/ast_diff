module lang::oozie::grammar::Oozie

extend lang::xml::DOM;
import lang::oozie::grammar::Expressions;
import ParseTree;
import lang::oozie::ast::Expressions;


data Node (map[str key, str val] attrs = ()) 
        = charData(list[OozieNode] contentList)
        | attribute(Namespace namespace, str name, list[OozieNode] contentList)
        ;


data OozieNode 
        = stringData(str before)
        | oozieExpr(OozieProg expression)
        ;

list[OozieNode] processEL(str text){
    list[OozieNode] contentList = [];
    if (/(\$\{.*?\}|\#\{.*?\})/ := text){
        list[tuple[str, str, str]] matches = [ <before, match, after> | /<before:.*?>(<match:\$\{.*?\}|\#\{.*?\}>)(<after:.*?>(?=\$\{|\#\{|$))/ := text ];
        for (<before, match, after> <- matches){
            OozieProg expression = implode(#lang::oozie::ast::Expressions::OozieProg, parse(#lang::oozie::grammar::Expressions::OozieProg, match, filters={}));
            contentList += [stringData(before), oozieExpr(expression), stringData(after)];
        }
        return contentList;
    }else{
        contentList += [stringData(text)];
        return contentList;
    }
}

Node load(str code){
    Node dom = parseXMLDOM(code);

    result = toOozie(dom);
    return result;
}

Node toOozie(Node dom){
    switch(dom){
        case document(Node root):{
             return document(toOozie(root));
        }
        case element(Namespace namespace, str name, list[Node] children):{
             list[Node] newChildren = [ toOozie(child) | child <- children ];
             return element(namespace, name, newChildren);
        }
        case charData(str text):{
            list[OozieNode] result = processEL(text);
            return charData(result);
        }
        case attribute(Namespace namespace, str name, str text):{
            list[OozieNode] result = processEL(text);
            return attribute(namespace,name,result);
        }
        default: return dom;
    }
}