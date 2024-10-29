module lang::ptl::translations::translate2hql::TranslateDeclarations
import Type;

extend lang::ptl::translations::translate2hql::TranslateViews;
import List;
import lang::ptl::Utils;
import IO;
import lang::hql::prettyprint::HQL;


public HQLStart toSQL(Program decl){
    switch(decl){
      case lang::ptl::ast::PTL::expression(e): return lang::hql::ast::HQL::expression(toSQL(e));
      case lang::ptl::ast::PTL::\module(str moduleId, list[Import] importlist, list[Declaration] decls):{
       
        totalList=[];
        for(stm <-decls) {
         
         totalList= totalList +checkStatments(stm) ;}
      
        
        return statements(
         totalList
        );
      }
      default: throw TranslationException("message:Unresolved hql start signature ",typeCast(#node,decl).src);
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
          
    } else if (!isDrop) {
        switch(d) {
            case viewWithAnnotation(Annotation annotation, ViewDecl v): {
                switch(v) {
                    case viewDecl(
                        list[IfNotExists] ifNotExists
                        , list[Drop] _
                        , list[Temporal] temporal
                        , NameOrTemplate nameOrTemplate 
                        , list[Distinct] distinct 
                        , ViewNameOrWildcard viewNameOrWildcard
                        , list[MixinsOrEmpty] _
                        , list[TranspositionFunction] _
                        , list[ViewVariablesOrEmpty] _
                        , list[SubViewsOrEmpty] _
                        , list[ViewField] viewFields
                        , list[FilterOrEmpty] filterOrEmpty
                        , list[GroupingOrEmpty] groupingOrEmpty
                        , list[OrderByClauseOpt] orderByClsOpt
                        , list[JoinConditions] joinConditions

                    ): {

                        list[Columns] cols(){
                            list[Columns] result = [];
                            list[ColumnSpecification] scdFields = [toSQLCols(field) | field <- viewFields];
                            scdFields += columnSpecification(regularIdentifier("is_current"), primitiveType(PrimitiveType::booleanType()), []);
                            scdFields += columnSpecification(regularIdentifier("ptl_valid_from"), primitiveType(timestampType()), []);
                            scdFields += columnSpecification(regularIdentifier("ptl_valid_to"), primitiveType(timestampType()), []);
                            
                            result += [columns(scdFields)];
                        
                            return result;
                        }
                        str table_name = "";
                        if (name(_, tabId(regularIdentifier(str tab_name))) := toSQL(nameOrTemplate)) table_name = tab_name;


                        list[SCDConfig] scd_configs = annotation.annotationProperty[0].materialization.scdMaterialization.scdConfigList;
                        str unique_column = [ uid | prop <- scd_configs, scdUniqueId(uid) := prop][0];
                        list[str] check_these_columns = [ ids | prop <- scd_configs, scdAttrib(ids) := prop][0];

                        TableName get_table_name(str tab_name) {
                            switch(tab_name) {
                                case "new": return name([], tabId(regularIdentifier("<table_name>_new")));
                                case "staging": return name([], tabId(regularIdentifier("<table_name>_staging")));
                                case "production": return name([], tabId(regularIdentifier("<table_name>_production")));
                                default: throw TranslationException("Unknown TableName type: ", typeCast(#node, tab_name).src);
                            }
                        } 

                        Identifier get_table_id(str id_name) {
                            switch(id_name) {
                                case "staging": return regularIdentifier("s");
                                case "production": return regularIdentifier("p");
                                default: throw TranslationException("Unknown TableName type: ", typeCast(#node, id_name).src);
                            }
                        }

                        return [


                            // 1: Create a new table by copying the schema of the production table
                            statementWithTerminator(dropTable([ifExists()], get_table_name("new"), []), [terminator()])
                            , statementWithTerminator(createTable(withColumns(
                                [] // TemporaryTable
                                , [] // ExternalTable
                                , [toSQL(IfNotExists::ifNotExists())] // IfNotExists
                                , toSQL(nameOrTemplate) // TableName
                                , cols() // Columns
                                , [] // Comment
                                , [] // PartitionedByClause
                                , [] // ClusteredByClause
                                , [] // RowFormatClause
                                , [] // StorageClause
                                , [toSQL(location("\'/initial_data\'"))] // LocationClause 
                                , [] // TablePropertiesClause
                            )), [terminator()])
                            // 2: Copy all records from the production table that don't exist in the staging table
                            , statementWithTerminator(insertWithQuery(into(
                                []
                                , get_table_name("new")
                                , []
                                , []
                                , queryHQL(QueryHQL::query(
                                    selectClause([], expAsVars([projectionStar()]))
                                    , [fromClause([tableId( get_table_name("production"), [get_table_id("production")])])]
                                    , []
                                    , [
                                        JoinClause::outerJoinClause(
                                            OuterType::left()
                                            , []
                                            , tableId( get_table_name("staging"), [get_table_id("staging")])
                                            , joinCondition(Expr::eq(string("<toString(get_table_id("production"))>.<unique_column>"), string("<toString(get_table_id("staging"))>.<unique_column>")))
                                            , []
                                            )
                                    ]
                                    , [whereClause(isNull(string("<toString(get_table_id("staging"))>.<unique_column>")))]
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                ))
                            )), [terminator()])
                            // 3: Copy all inactive records from the production table
                            , statementWithTerminator(insertWithQuery(into(
                                []
                                , get_table_name("new")
                                , []
                                , []
                                , queryHQL(QueryHQL::query(
                                    selectClause([], expAsVars([projectionStar()]))
                                    , [fromClause([tableId( get_table_name("production"), [get_table_id("production")])])]
                                    , []
                                    , [
                                        JoinClause::outerJoinClause(
                                            OuterType::left()
                                            , []
                                            , tableId( get_table_name("staging"), [get_table_id("staging")])
                                            , joinCondition(
                                                Expr::and(
                                                    Expr::eq(
                                                        string("<toString(get_table_id("production"))>.<unique_column>")
                                                        , string("<toString(get_table_id("staging"))>.<unique_column>")
                                                    ), Expr::eq(
                                                        string("<toString(get_table_id("production"))>.scd_active")
                                                        , Expr::\false()
                                                    )
                                                ))
                                            , []
                                            )
                                    ]
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                ))
                            )), [terminator()])
                            // 4: Insert active records from <table>_production without SCD type 2 changes into <table>_new
                            , statementWithTerminator(insertWithQuery(into(
                                []
                                , get_table_name("new")
                                , []
                                , []
                                , queryHQL(QueryHQL::query(
                                    selectClause([], expAsVars([projectionStar()]))
                                    , [fromClause([tableId( get_table_name("production"), [get_table_id("production")])])]
                                    , []
                                    , [
                                        JoinClause::outerJoinClause(
                                            OuterType::left()
                                            , []
                                            , tableId( get_table_name("staging"), [get_table_id("staging")])
                                            , joinCondition(
                                                Expr::and(
                                                    Expr::eq(
                                                        string("<toString(get_table_id("production"))>.<unique_column>")
                                                        , string("<toString(get_table_id("staging"))>.<unique_column>")
                                                    ), Expr::eq(
                                                        string("<toString(get_table_id("production"))>.scd_active")
                                                        , Expr::\true()
                                                    )
                                                ))
                                            , []
                                            )
                                    ]
                                    , [whereClause(and(
                                        Expr::eq(
                                            string("<toString(get_table_id("production"))>.get_these_from_entity")
                                            , string("<toString(get_table_id("staging"))>.get_these_from_entity")
                                        )
                                        , Expr::eq(
                                            // TODO: might remove this, how do we know what columns we want to coalesce?
                                            function(callFunction(regularIdentifier("COALESCE"), [], [
                                                    propRef([regularIdentifier("<toString(get_table_id("production"))>"), regularIdentifier("get_this_from_annotation")])
                                                    , string("\'\'")
                                                ], [], [])
                                            , []),
                                            function(callFunction(regularIdentifier("COALESCE"), [], [
                                                    propRef([regularIdentifier("<toString(get_table_id("staging"))>"), regularIdentifier("get_this_from_annotation")])
                                                    , string("\'\'")
                                                ], [], [])
                                            , [])
                                            )   
                                        )
                                    )]
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                ))
                            )), [terminator()])
                            // 5: Insert new inactive versions with SCD Type 2 changes into <table_name>_new 
                            , statementWithTerminator(insertWithQuery(into(
                                []
                                , get_table_name("new")
                                , []
                                , []
                                , queryHQL(QueryHQL::query(
                                    selectClause([], expAsVars([projectionStar()]))
                                    , [fromClause([tableId( get_table_name("production"), [get_table_id("production")])])]
                                    , []
                                    , [
                                        JoinClause::outerJoinClause(
                                            OuterType::left()
                                            , []
                                            , tableId( get_table_name("staging"), [get_table_id("staging")])
                                            , joinCondition(
                                                Expr::and(
                                                    Expr::eq(
                                                        string("<toString(get_table_id("production"))>.<unique_column>")
                                                        , string("<toString(get_table_id("staging"))>.<unique_column>")
                                                    ), Expr::eq(
                                                        string("<toString(get_table_id("production"))>.scd_active")
                                                        , Expr::\true()
                                                    )
                                                ))
                                            , []
                                            )
                                    ]
                                    , [whereClause(and(
                                        Expr::neq1(
                                            string("<toString(get_table_id("production"))>.get_these_from_entity")
                                            , string("<toString(get_table_id("staging"))>.get_these_from_entity")
                                        )
                                        , Expr::neq1(
                                            // TODO: might remove this, how do we know what columns we want to coalesce?
                                            function(callFunction(regularIdentifier("COALESCE"), [], [
                                                    propRef([regularIdentifier("<toString(get_table_id("production"))>"), regularIdentifier("get_this_from_annotation")])
                                                    , string("\'\'")
                                                ], [], [])
                                            , []),
                                            function(callFunction(regularIdentifier("COALESCE"), [], [
                                                    propRef([regularIdentifier("<toString(get_table_id("staging"))>"), regularIdentifier("get_this_from_annotation")])
                                                    , string("\'\'")
                                                ], [], [])
                                            , [])
                                            )   
                                        )
                                    )]
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                ))
                            )), [terminator()])
                            // 6: Insert new active versions for records with SCD Type 2 changes
                            , statementWithTerminator(insertWithQuery(into(
                                []
                                , get_table_name("new")
                                , []
                                , []
                                , queryHQL(QueryHQL::query(
                                    selectClause([], expAsVars([projectionStar()]))
                                    , [fromClause([tableId( get_table_name("production"), [get_table_id("production")])])]
                                    , []
                                    , [
                                        JoinClause::innerJoinClause(
                                            []
                                            , tableIdOrSubquerySubquery(queryHQL(query(selectClause([], expAsVars([projectionStar()]))
                                            , []
                                            , []
                                            , []
                                            , []
                                            , []
                                            , []
                                            , []
                                            , []
                                            , []
                                            , []
                                            )), get_table_id("staging"))
                                            , [joinCondition(
                                                Expr::neq1(
                                                    string("<toString(get_table_id("production"))>.get_these_from_entity")
                                                    , string("<toString(get_table_id("staging"))>.get_these_from_entity")
                                                )
                                            )]
                                            , []
                                            )
                                    ]
                                    , [whereClause(and(
                                        Expr::neq1(
                                            string("<toString(get_table_id("production"))>.get_these_from_entity")
                                            , string("<toString(get_table_id("staging"))>.get_these_from_entity")
                                        )
                                        , Expr::neq1(
                                            // TODO: might remove this, how do we know what columns we want to coalesce?
                                            function(callFunction(regularIdentifier("COALESCE"), [], [
                                                    propRef([regularIdentifier("<toString(get_table_id("production"))>"), regularIdentifier("get_this_from_annotation")])
                                                    , string("\'\'")
                                                ], [], [])
                                            , []),
                                            function(callFunction(regularIdentifier("COALESCE"), [], [
                                                    propRef([regularIdentifier("<toString(get_table_id("staging"))>"), regularIdentifier("get_this_from_annotation")])
                                                    , string("\'\'")
                                                ], [], [])
                                            , [])
                                            )
                                        )
                                    )]
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                ))
                            )), [terminator()])
                            // 7: Handle records from <table_name>_staging that don't exist in the production table
                            , statementWithTerminator(insertWithQuery(into(
                                []
                                , get_table_name("new")
                                , []
                                , []
                                , queryHQL(QueryHQL::query(
                                    selectClause([], expAsVars([projectionStar()]))
                                    , [fromClause([tableId( get_table_name("staging"), [get_table_id("staging")])])]
                                    , []
                                    , [
                                        JoinClause::outerJoinClause(
                                            OuterType::left()
                                            , []
                                            , tableId( get_table_name("production"), [get_table_id("production")])
                                            , joinCondition(Expr::eq(string("<toString(get_table_id("staging"))>.<unique_column>"), string("<toString(get_table_id("production"))>.<unique_column>")))
                                            , []
                                            )
                                    ]
                                    , [whereClause(isNull(string("<toString(get_table_id("production"))>.<unique_column>")))]
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                ))
                            )), [terminator()])
                            // 8: Use ROW_NUMBER() to generate sequential numbers for <table_name>_id and overwrite <table_name>_production
                            , statementWithTerminator(insertWithQuery(overwrite(
                                []
                                , get_table_name("new")
                                , []
                                , []
                                , []
                                , queryHQL(QueryHQL::query(
                                    selectClause([], expAsVars([projectionStar()]))
                                    , [fromClause([tableId( get_table_name("new"), [])])]
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                ))
                            )), [terminator()])

                        ];
                    }
                    default: throw TranslationException("message: view declaration unresolved", typeCast(#node, v).src);
                }
            }
            default: return [statementWithTerminator(toSQL(d), [terminator()])];
        }
    }
      else {
          return [statementWithTerminator(toSQL(d), [terminator()])];
      } 
}


public StatementWithTerminator toSQL(dropIfExist(), str id){
    return statementWithTerminator(dropTable([], name([], tabId(regularIdentifier(id))), []), [terminator()]);
}
