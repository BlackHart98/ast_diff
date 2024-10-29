module lang::hql::prettyprint::Query

import lang::hql::ast::HQL;
import List;
import String;

extend lang::hql::prettyprint::Functions;



// Query
public str toString(QueryExpr::queryHQL(QueryHQL queryHQL)) = "<toString(queryHQL)>";

public str toString(
  QueryHQL::query(
    SelectClause selectCls
    , list[FromClause] fromCls
    , list[LateralView] lateralView
    , list[JoinClause] joinCls
    , list[WhereClause] whereCls
    , list[GroupByClause] groupCls 
    , list[HavingClause] havingCls 
    , list[OrderByClause] orderByCls 
    , list[WindowClause] windowCls 
    , list[LimitOffsetClauses] limitOffsetCls
    , list[QueryClusterByClause] queryClusterByCls
  )
) = "<toString(selectCls)>\n" + 
    trim("<prettyOptional(fromCls, toString, sep="\n")>" + 
         "<if (!isEmpty(lateralView)) {><intercalate("\n", [ toString(latV) | latV <- lateralView ])>\n<}>" +
         "<prettyOptional(joinCls, toString)>" + 
         "<prettyOptional(whereCls, toString, sep="\n")>" + 
         "<prettyOptional(groupCls, toString, sep="\n")>"+ 
         "<prettyOptional(havingCls, toString, sep="\n")>" + 
         "<prettyOptional(orderByCls, toString, sep="\n")>" + 
         "<prettyOptional(windowCls, toString, sep="\n")>" + 
         "<prettyOptional(limitOffsetCls, toString, sep="\n")>" + 
         "<prettyOptional(queryClusterByCls, toString, sep="\n")>"
         );



public str toString(SelectClause::transform(
    list[Expr] expr
    , list[RowFormatClause] rowFormatCls1
    , str strConst
    , list[TransformColumnSpecification] transformColumnSpecifications
    , list[RowFormatClause] rowFormatCls2
    , list[RecordReaderClause] recordReader
  )
) = "SELECT TRANSFORM(<intercalate(", ", [ toString(exp) | exp <- expr ])>) <prettyOptional(rowFormatCls1, toString)> 
    'USING <strConst> AS (<intercalate(", ", [ toString(transformColumnSpecification) | transformColumnSpecification <- transformColumnSpecifications ])>) <prettyOptional(rowFormatCls2, toString)> <prettyOptional(recordReader, toString)>";


//
public str toString(
  TransformColumnSpecification::transformColumnSpecification(
    Identifier id
    , list[DataType] dType
  )
) = "<toString(id)> <prettyOptional(dType, toString)>";


// LateralView
public str toString(LateralView::lateralView(
    list[Outer] outerOpt    
    , Function func
    , Identifier id1
    , list[Identifier] ids
  )
) = "LATERAL VIEW <prettyOptional(outerOpt, prettyOuter)> <toString(func)> <toString(id1)> AS <intercalate(",", [ toString(id) | id <- ids ])>";
