module lang::ptl::translations::translate2Spark::TranslateViews
import lang::ptl::Utils;
import List;
import Type;
extend lang::ptl::translations::translate2Spark::TranslateExpressions;


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
         list[FromClause] viewName= [toSQL(v)|v<-viewNameOrWildcard];
         list[JoinClause] joins = [toSQL(joinCondition)[0]|joinCondition<-joinConditions];
         list[WhereClause]  whereCls = [toSQL(jc)|jc<-filterOrEmpty];
         list[OrderByClause]  orderby = [toSQL(jc)|jc<-orderByClsOpt];
         list[GroupByClause] groupByClause= [toSQL(g)| grouping(GroupByClauseOpt g , list[HavingClauseOpt] _)<-groupingOrEmpty];
         list[HavingClause] havingClauses  =size(groupingOrEmpty)>0?toSQL(groupingOrEmpty[0].h):[];
      return  querySpark(query(
       selectClause(sq,expAsVars(eavs))
        , viewName
        , []
        , []
        , []
        , []
        , joins
        , whereCls
        , groupByClause
        , havingClauses
        , []
        , orderby 
        , []
        , []
        )
    );
      
       }
