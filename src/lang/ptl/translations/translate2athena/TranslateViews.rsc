module lang::ptl::translations::translate2athena::TranslateViews

extend lang::ptl::translations::translate2athena::TranslateExpressions;

import List;
import lang::ptl::Utils;
import Type;


public QueryExpr toSQL(subViewDecl(
        list[Distinct] distinctOpt 
        , list[ViewNameOrWildcard] viewNameOrWildcard
        , list[ViewField] viewFields
        , list[FilterOrEmpty] filterOrEmpty
        , list[GroupingOrEmpty] groupingOrEmpty
        , list[OrderByClauseOpt] orderByClsOpt
        , list[JoinConditions] joinConditions
        )){
            eavs= [toSQL(vf)|vf<-viewFields];
            sq= [distinct()|_<-distinctOpt];
         list[FromClause] vns= [toSQL(v)|v<-viewNameOrWildcard];
         list[JoinClause] joins = [toSQL(joinCondition)[0]|joinCondition<-joinConditions];
         list[WhereClause]  whereCls = [toSQL(jc)|jc<-filterOrEmpty];
         list[OrderByClause]  orderby = [toSQL(jc)|jc<-orderByClsOpt];
         list[GroupByClause] groupByClauses= [toSQL(g)| grouping(GroupByClauseOpt g , list[HavingClauseOpt] _)<-groupingOrEmpty];
         list[HavingClause] havingClauses = size(groupingOrEmpty)>0?toSQL(groupingOrEmpty[0].h):[];
      return  queryAthena(query(
        selectClause(sq,expAsVars(eavs))
        , vns
        , joins
        , whereCls
        , groupByClauses
        , havingClauses
        , []
        , orderby
        , []
        , []
    ));
      
       }