module lang::ptl::Utils
import lang::ptl::ast::PTL;
import lang::ptl::ast::Expressions;
import lang::ptl::grammar::PTL;
import ParseTree;
import List;
import lib::Utils;
import IO;
import Node;
import String;
import Type;


public Program loadPTL(loc location){
  return implode(#lang::ptl::ast::PTL::Program,parse(#start[Program], location));
}

public Program loadPTL(str text){
  return implode(#lang::ptl::ast::PTL::Program,parse(#start[Program], text));
}

public Declaration loadView(loc location){
  return implode(#lang::ptl::ast::PTL::Declaration,parse(#lang::ptl::grammar::PTL::Declaration, location));
}
public Expr loadExpr(loc location){
  return implode(#lang::ptl::ast::PTL::Expr,parse(#lang::ptl::grammar::PTL::Expr, location));
}
public Expr loadExpr(str location){
  return implode(#lang::ptl::ast::PTL::Expr,parse(#lang::ptl::grammar::PTL::Expr, location));
}

public list[FunctionData] loadPTLFunctions(){
  funcAst= loadPTL(|project://ast_diff/src/lang/ptl/checker/std.ptl|);
  functions=[x|x<-funcAst.decls,getName(x)=="function"];
  functionDatas=[];
 for(fun<-functions){
 
   anotes= fun.functionAnnotations;
   str  name= fun.functionDefintion.functionid;
    Type  ftype = fun.functionDefintion.ty;
    
   functionDatas+= fData(name,anotes,ftype);
  
  }
return functionDatas;
}

list[FunctionData] functData = loadPTLFunctions();

public str translateFunction(str platform, str name, value adt){
    if(isFunctionSupported(name,platform,adt)){
      return name;
    }
    else{
      return checkAlias(name , platform, adt);
    }
}
public loc getInvalidFunctionLoc(value adt){
  errorAnno = getAnnotations(adt)["src"];
  return typeCast(#loc, errorAnno);
}

public str checkAlias(functionName,platform, adt){
  // checking if the function with {functionName} has alias notation
  matchingData= [anotes|fData(name,anotes,_)<-functData,toLowerCase(name)==toLowerCase(functionName)];


  list[FunctionAnnotation] \alias =[al|al<-matchingData[0],getName(al.annotation)=="alias"];
    if([]:=\alias){
      matchingFunction= [name|fData(name,anotes,_)<-functData,[]!:=[al|al<-anotes,getName(al.annotation)=="alias" && al.annotation.name=="\"<functionName>\""]];
      if([]:=matchingFunction){
        throw TranslationException("function `<functionName>` can not be translated to <platform>", typeCast(#node,adt).src);
      }
      else{
        dialectNameList =[fName|fName<-matchingFunction,isFunctionSupported(fName,platform,adt)];
        if([]:=dialectNameList){
          throw TranslationException("function <functionName> can not be translated to <platform>", typeCast(#node,adt).src);
        }
        else return dialectNameList[0];
      }
    }
    else{
      dialectNameLists= [name|functionAnnotation(\alias(name))<-\alias,isFunctionSupported(replaceAll(name,"\"",""),platform,adt)];
      if([]:=dialectNameLists){
        matchingFunction= [name|fData(name,anotes,_)<-functData,[]!:=[al|al<-anotes,getName(al.annotation)=="alias" && al.annotation.name==\alias[0].annotation.name]];
      if([]:=matchingFunction){
        throw TranslationException("function <functionName> can not be translated to <platform>", typeCast(#node,adt).src);
      }
      else{
        dialectNameList =[fName|fName<-matchingFunction,isFunctionSupported(fName,platform,adt)];
        if([]:=dialectNameList){
          throw TranslationException("function <functionName> can not be translated to <platform>", typeCast(#node,adt).src);
        }
        else return dialectNameList[0];
      }
    }
    else return dialectNameLists[0];
}

}
public bool isFunctionSupported(str functionName,str platform, value adt){
    annotations= [annotes|fData(name,annotes,_)<-functData,toLowerCase(name)==toLowerCase(functionName)];
    
    if([]:=annotations){
     
      throw TranslationException("function <functionName> is an undeclared function", typeCast(#node,adt).src);
    }
    else{
    if([]:=annotations[0]){
      return true;
    }
    else{
       matchingData=annotations[0];
       platforms=[plat|plat<-matchingData,getName(plat.annotation)=="platform"];
       if([]:=platforms){
      return true;
        }
        else{
          list[str] platFormsMatch=platforms[0].annotation.platforms;
       return indexOf(platFormsMatch,"\"<platform>\"")>-1  ;
    
    }
      
    }
     
    }
}
