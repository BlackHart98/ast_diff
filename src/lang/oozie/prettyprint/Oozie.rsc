module lang::oozie::prettyprint::Oozie

import List;
extend lang::oozie::grammar::Oozie;
extend lang::oozie::prettyprint::Expressions;

public str toString(Node dom){
    xmldom = prettyExp(dom);
    result = xmlPretty(xmldom);
    return result;
}

Node prettyExp(Node dom){
  switch(dom){
    case document(Node root):{
      return document(prettyExp(root));
    }
    case element(namespace(str prefix, str uri), str name, list[Node] children):{
      list[Node] newChildren = [prettyExp(child) | child <- children];
      return element(namespace(prefix, uri), name, newChildren);
    }
    case element(none(), str name, list[Node] children):{
      list[Node] newChildren = [prettyExp(child) | child <- children];
      return element(none(), name, newChildren);
    }
    case charData(list[OozieNode] contentList):{
      str newContents = intercalate(" ",[prettyOozieNode(child) | child <- contentList]);
      return charData(newContents);
    }
    case attribute(Namespace namespace, str name, list[OozieNode] contentList):{
      str newContents = intercalate(" ",[prettyOozieNode(child) | child <- contentList]);
      return attribute(namespace, name, newContents);
    }
    default: return dom;
  }
}

str prettyOozieNode(OozieNode oznode) {
    switch (oznode) {
        case oozieExpr(OozieProg expression): {
          str exprString = toString(expression);
          stringResult = extractstr(stringData(exprString));

          return stringResult;
        }
        case stringData(str before):{
          return before;
        }
        default: {
          return "<oznode>: unknown ";
        }
    }
}

str extractstr(OozieNode stringdata){
    switch(stringdata){
        case stringData(str before):{
            return before;
        }
        default: return "error in extractstr";
    }
}

