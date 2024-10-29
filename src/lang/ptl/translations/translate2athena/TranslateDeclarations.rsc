module lang::ptl::translations::translate2athena::TranslateDeclarations

import Type;
extend lang::ptl::translations::translate2athena::TranslateViews;
import List;
import lang::ptl::Utils;


public Athena toSQL(Program decl){
    switch(decl){
      case lang::ptl::ast::PTL::expression(e): return lang::athena::ast::Athena::expression(toSQL(e));
      case lang::ptl::ast::PTL::\module(str moduleId, list[Import] importlist, list[Declaration] decls):{
       
        totalList=[];
        for(stm <-decls) {
         
         totalList= totalList +checkStatments(stm) ;}
      
        
        return statements(
         totalList
        );
      }
      default: throw TranslationException("message:Unresolved athena start signature ",typeCast(#node,decl).src);
    }
} 

public list[StatementWithTerminator] checkStatments(Declaration d){
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
              ): return [toSQL(dropIfExist(), entityId), statementWithTerminator(toSQL(d), [terminator()])];
              case entityExtends(
                list[Temporal] temporal
                , list[External] external
                , list[IfNotExists] ifNotExists
                , list[Drop] drop
                , str entityId
                , str baseId
                , list[Field] fields
                ): return [toSQL(dropIfExist(), entityId), statementWithTerminator(toSQL(d), [terminator()])];
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
                        if (isEmpty(viewVarOrEmpty)) {
                            return [statementWithTerminator(toSQL(d), [terminator()])];
                        }
                        else { 
                            str viewName = head(viewVarOrEmpty).views[0].oname;
                            return [toSQL(dropIfExist(), viewName), statementWithTerminator(toSQL(d), [terminator()])];
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
                  {     if (isEmpty(viewVar)) {
                            return [statementWithTerminator(toSQL(d), [terminator()])];
                        }
                        else { 
                            str viewName = head(viewVar).views[0].oname;
                            return [toSQL(dropIfExist(), viewName), statementWithTerminator(toSQL(d), [terminator()])];
                        }
                  }
              
              default : return [statementWithTerminator(toSQL(d), [terminator()])];

          }
          
  }
      else {
          return [statementWithTerminator(toSQL(d), [terminator()])];
      } 
}


public StatementWithTerminator toSQL(dropIfExist(), str id){
    return statementWithTerminator(dropTable([], name([], tabId(regularIdentifier(id))), []), [terminator()]);
}
