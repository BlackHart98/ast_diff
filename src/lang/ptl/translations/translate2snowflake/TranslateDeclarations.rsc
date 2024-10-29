module lang::ptl::translations::translate2snowflake::TranslateDeclarations

import Type;
import List;
import lang::ptl::Utils;

extend lang::ptl::translations::translate2snowflake::TranslateViews;



public SnowFlakeBatch toSQL(Program decl){
    switch(decl){
      case lang::ptl::ast::PTL::\module(str moduleId, list[Import] importlist, list[Declaration] decls):{
       
        totalList=[];
        for(stm <-decls) {
         
         totalList= totalList +checkStatments(stm) ;}
      
        
        return snowFlakeBatch(totalList);
      }
      default: throw TranslationException("message:Unresolved hql start signature ",typeCast(#node,decl).src);
    }
} 



public list[Statement] checkStatments(Declaration d){
    bool isDrop= false; 
    visit(d){
        case dropIfExist(): {isDrop = true;}
    }
      if(isDrop){
          switch(d){
              case entity(
              list[ModelAnnotation] mda
              , list[PartitionedBy] prtBy
              , list[ClusteredBy] clstBy
              , list[RowFormat] rowFrmt
              , list[StoredAs] storedAs
              , list[Location] location
              , list[TableProperties] tblPropties
              , list[MaterializedAs] materializedAs
              , list[Temporal] temporal
              , list[External] external
              , list[IfNotExists] ifNotExists
              , list[Drop] drop
              , str entityId
              , list[Field] fields
              ): return [toSQL(dropIfExist(), entityId), toSQL(d)];
              case entityExtends(
                list[Temporal] temporal
                , list[External] external
                , list[IfNotExists] ifNotExists
                , list[Drop] drop
                , str entityId
                , str baseId
                , list[Field] fields
                ): return [toSQL(dropIfExist(), entityId), toSQL(d)];
              case view(list[ModelAnnotation] mda, ViewDecl::viewDecl(
                        list[IfNotExists] ifNotExists
                        , list[Drop] drop
                        , list[Temporal] temp
                        , NameOrTemplate nameOrTemplate 
                        , list[Distinct] distinct 
                        , ViewNameOrWildcard viewNameOrWildcard
                        , list[MixinsOrEmpty] mixinsOrEmpty
                        , list[TranspositionFunction] transpositionFunction
                        , list[ViewVariablesOrEmpty] viewVarOrEmpty
                        , list[SubViewsOrEmpty] subViewsOrEmpty
                        , list[ViewField] viewFields
                        , list[FilterOrEmpty] filterOrEmpty
                        , list[GroupingOrEmpty] groupingOrEmpty
                        , list[OrderByClauseOpt] orderByClsOpt
                        , list[JoinConditions] joinConditions
                        )): {
                    if(isEmpty(viewVarOrEmpty)) {
                        return [toSQL(d)];
                    }
                    else {
                        str viewName = viewVarOrEmpty[0].views[0].oname;
                        return [toSQL(dropIfExist(), viewName), toSQL(d)];
                    }
              }
              case viewAs(
                  list[ModelAnnotation] mda,
                  list[IfNotExists] ifNotExists
                  , list[Drop] drop
                  , list[Temporal] temp
                  , QualifiedIdentifier qid
                  , list[ViewVariablesOrEmpty] viewVar
                  , SubViewDecl subViewDecl
                  ): 
                  {
                      if (isEmpty(viewVar)) {
                        return [toSQL(d)];
                      }
                      else {
                        str viewName = head(viewVar).views[0].oname;
                      
                        return [toSQL(dropIfExist(), viewName), toSQL(d)]; 
                      }
                  }
              
              default : return [toSQL(d)];

          }
          
  }
      else {
          return [toSQL(d)];
      } 
}


public Statement toSQL(dropIfExist(), str id){
    return dropTable([], name([], tabId(regularIdentifier(id))), []);
}
