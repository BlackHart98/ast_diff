module lang::ptl::translations::translate2Spark::TranslateDeclarations
extend lang::ptl::translations::translate2Spark::TranslateViews;
import Type;
import IO;
import List;
import lang::ptl::Utils;


public Spark toSQL(Program decl){
    switch(decl){
      case lang::ptl::ast::PTL::expression(e): return lang::spark::ast::Spark::expression(toSQL(e));
      case lang::ptl::ast::PTL::\module(str _, list[Import] _, list[Declaration] decls):{
       
        totalList=[];
        for(stm <-decls) {        
         totalList= totalList +checkStatments(stm) ;}
        return statements(
         totalList
        );
      }
      default: throw TranslationException("message: unhandled start spark signature",typeCast(#node,decl).src);
    }
} 


public list[StatementWithTerminator] checkStatments(Declaration d){
    list[StatementWithTerminator] result = [];
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
                list[Temporal] _
                , list[External] _
                , list[IfNotExists] _
                , list[Drop] _
                , str entityId
                , str _
                , list[Field] _
                ): return [toSQL(dropIfExist(), entityId), statementWithTerminator(toSQL(d), [terminator()])];
              case view(list[ModelAnnotation] _, ViewDecl::viewDecl(
                        list[IfNotExists] _
                        , list[Drop] _
                        , list[Temporal] temp
                        , NameOrTemplate _ 
                        , list[Distinct] _ 
                        , ViewNameOrWildcard _
                        , list[MixinsOrEmpty] _
                        , list[TranspositionFunction] _
                        , list[ViewVariablesOrEmpty] viewVarOrEmpty
                        , list[SubViewsOrEmpty] _
                        , list[ViewField] _
                        , list[FilterOrEmpty] _
                        , list[GroupingOrEmpty] _
                        , list[OrderByClauseOpt] __
                        , list[JoinConditions] _
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
        switch(d){
            case viewWithAnnotation(Annotation annotation, ViewDecl v): {
                switch(v){
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
                        
                    ):{

                        SCD scdProperty = annotation.annotationProperty[0].materialization.scdMaterialization;
                        StrategyOption scdStrategy = head([strategy | scdStrategy(strategy) <- scdProperty.scdConfigList]);

                        switch(scdStrategy) {
                            case StrategyOption::timestampStrategy(): {
                                list[Columns] cols(){
                                    list[Columns] result = [];
                                    list[ColumnSpecification] scdFields = [toSQLCols(field) | field <- viewFields];
                                    scdFields += columnSpecification(regularIdentifier("isCurrent"), primitiveType(booleanType()), []);
                                    scdFields += columnSpecification(regularIdentifier("ptl_valid_from"), primitiveType(timestampType()), []);
                                    scdFields += columnSpecification(regularIdentifier("ptl_valid_to"), primitiveType(timestampType()), []);
                                    
                                    result += [columns(scdFields)];
                                
                                    return result;
                                }

                                // get the unique id for the table
                                SCD scdProps = annotation.annotationProperty[0].materialization.scdMaterialization;
                                uniqueId = [uid | props<- scdProps.scdConfigList, scdUniqueId(uid) := props];
                                updateId = [uid[0] | props<- scdProps.scdConfigList, scdUpdatedAt(uid) := props];
                                // println(updateId[0]);
                            
                                
                                // table names
                                NameOrTemplate current_table_name = nameOrTemplate;
                                NameOrTemplate updates_table_name = viewName("staging_table"); 
                                NameOrTemplate temp_view_name = viewName("temp_update_table"); 

                                // alias table names
                                str alias_initial = "initial";
                                str alias_update = "staging";


                                // updates_table columns
                                list[Columns] updateTableCols(){
                                    list[Columns] result = [];
                                    list[ColumnSpecification] timestampedFields = [toSQLCols(field) | field <- viewFields];
                
                                    result += [columns(timestampedFields)];
                                
                                    return result;
                                };

                                // get the fields of the tables and their names
                                table_attributes = [getColNames(attr)|c <- updateTableCols()
                                        , columns(list[ColumnSpecification] colSpecs) := c
                                        , attr <- colSpecs
                                        ];

                                
                                // select unchanged records
                                list[ExpAsVarOrStar] getFieldProjectionUnchanged(list[Expr] table_attributes){
                                    projections = [];
                                    for(i <- table_attributes){
                                        i.strConst = "<alias_initial>.<i.strConst>";

                                        projections += projectionExpAsVar(expAsVar(i, []));

                                    }
                                    projections += projectionExpAsVar(expAsVar(string("<alias_initial>.isCurrent"), []));
                                    projections += projectionExpAsVar(expAsVar(string("<alias_initial>.ptl_valid_from"), []));
                                    projections += projectionExpAsVar(expAsVar(string("<alias_initial>.ptl_valid_to"), []));
                                
                                    return projections;
                                }

                                // select updated records
                                list[ExpAsVarOrStar] getFieldProjectionUpdated(list[Expr] table_attributes){
                                    projections = [];
                                    for(i <- table_attributes){
                                        if(i.strConst == updateId[0]) i.strConst = "<alias_update>.<i.strConst>";
                                        else
                                        i.strConst = "<alias_initial>.<i.strConst>";

                                        projections += projectionExpAsVar(expAsVar(i, []));

                                    }
                                    projections += projectionExpAsVar(expAsVar(string("false"), [varAssign([as()], regularIdentifier("isCurrent"))]));
                                    projections += projectionExpAsVar(expAsVar(string("<alias_initial>.ptl_valid_from"), []));
                                    projections += projectionExpAsVar(expAsVar(string("<alias_update>.<updateId[0]>"), [varAssign([as()], regularIdentifier("ptl_valid_to"))]));
                                
                                    return projections;
                                }

                                // insert new or updated records
                                list[ExpAsVarOrStar] getFieldProjectionInsert(list[Expr] table_attributes){
                                    projections = [];
                                    for(i <- table_attributes){
                                        projections += projectionExpAsVar(expAsVar(Expr::string("<alias_update>.<i.strConst>"), []));

                                    }
                                    projections += projectionExpAsVar(expAsVar(string("true"), [varAssign([as()], regularIdentifier("isCurrent"))]));
                                    projections += projectionExpAsVar(expAsVar(string("<alias_update>.<updateId[0]>"), [varAssign([as()], regularIdentifier("ptl_valid_from"))]));
                                    projections += projectionExpAsVar(expAsVar(string("\'9999-12-31\'"), [varAssign([as()], regularIdentifier("ptl_valid_to"))]));
                                
                                    return projections;
                                }
                            

                                Expr getOrs(list[Expr] table_attributes){
                                    list[Expr] req_attr = [attr | attr <- table_attributes, attr.strConst != "<uniqueId[0]>" && attr.strConst != "<updateId[0]>" ];

                                    Expr result = neq1(string("<alias_update>.<req_attr[0].strConst>")
                                                , string("<alias_initial>.<req_attr[0].strConst>"));

                                    for (int i <- [1..size(req_attr)]) {
                                        result = or(result, neq1(string("<alias_update>.<req_attr[i].strConst>")
                                    , string("<alias_initial>.<req_attr[i].strConst>")));
                                    }
                                    return result;
                                }
                            
                                return [
                                    statementWithTerminator(
                                            createTable(
                                                fromSource(
                                                    [toSQL(IfNotExists::ifNotExists())]
                                                    , [toSQL(current_table_name)]
                                                    , cols()
                                                    , usingClause(parquet(), [option([pair("path", Expr::string("\"/initial_data\""))])])
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                )), [terminator()])
                                    , statementWithTerminator(
                                        createTable(
                                            fromSource(
                                                [toSQL(IfNotExists::ifNotExists())]
                                                , [toSQL(updates_table_name)]
                                                , updateTableCols()
                                                , usingClause(parquet(), [option([pair("path", Expr::string("\"/update_data\""))])])

                                                , []
                                                , []
                                                , []
                                                , []
                                                , []
                                                , []
                                            )), [terminator()])

                                    ,  statementWithTerminator(
                                            createViewWithReplace(
                                                replaceTemporary(
                                                    temporaryTable()
                                                ),
                                                [],
                                                toSQL(temp_view_name),
                                                [],
                                                queryOrWithQuery(
                                                    queryUnion(
                                                querySpark(
                                                        query(
                                                    selectClause(
                                                        []
                                                        , expAsVars(getFieldProjectionUnchanged(table_attributes)))
                                                    , [fromClause([tableId(toSQL(current_table_name), [regularIdentifier(alias_initial)])])]
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , [outerJoinClause(
                                                        left(), [], tableId(toSQL(updates_table_name), [regularIdentifier(alias_update)]), joinCondition(Expr::eq(string("<alias_initial>.<uniqueId[0]>"), string("<alias_update>.<uniqueId[0]>"))), []
                                                    )]
                                                    , [
                                                        whereClause(
                                                        and(
                                                            Expr::eq(
                                                                string("<alias_initial>.isCurrent"), Expr::\true())
                                                        ,   or(
                                                            isNull(string("<alias_update>.<uniqueId[0]>"))
                                                            , Expr::gte(string("<alias_initial>.<updateId[0]>"), string("<alias_update>.<updateId[0]>"))
                                                        )))
                                                        ]
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    ))
                                                , union([\all()])
                                                ,queryUnion(
                                                querySpark(
                                                        query(
                                                    selectClause(
                                                        []
                                                        , expAsVars(getFieldProjectionUpdated(table_attributes)))
                                                    , [fromClause([tableId(toSQL(current_table_name), [regularIdentifier(alias_initial)])])]
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    ,  [innerJoinClause(
                                                        [], tableId(toSQL(updates_table_name), [regularIdentifier(alias_update)]), [joinCondition(Expr::eq(string("<alias_initial>.<uniqueId[0]>"), string("<alias_update>.<uniqueId[0]>")))], []
                                                    )]
                                                    , [
                                                        whereClause(
                                                        and(
                                                            Expr::eq(
                                                                string("<alias_initial>.isCurrent"), Expr::\true())
                                                        ,   Expr::lt(string("<alias_initial>.<updateId[0]>"), string("<alias_update>.<updateId[0]>"))))
                                                        ]
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    ))
                                                , union([\all()])
                                                ,querySpark(
                                                        query(
                                                    selectClause(
                                                        []
                                                        , expAsVars(getFieldProjectionInsert(table_attributes)))
                                                    , [fromClause([tableId(toSQL(updates_table_name), [regularIdentifier(alias_update)])])]
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , [outerJoinClause(
                                                        left(), [], tableId(toSQL(current_table_name), [regularIdentifier(alias_initial)]), joinCondition(
                                                            and(
                                                                Expr::eq(string("<alias_initial>.<uniqueId[0]>"), string("<alias_update>.<uniqueId[0]>"))
                                                                , Expr::eq(string("<alias_initial>.isCurrent"), Expr::\true())
                                                                )
                                                        ), []
                                                    )]
                                                    , [
                                                        whereClause(
                                                        or(
                                                        isNull(string("<alias_initial>.<uniqueId[0]>"))
                                                        ,   Expr::lt(string("<alias_initial>.<updateId[0]>"), string("<alias_update>.<updateId[0]>"))))
                                                        ]
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    , []
                                                    ))
                                                )
                                                )
                                                )
                                            )
                                            , [terminator()])
                                    , statementWithTerminator(
                                        insertWithQuery(
                                            overwrite(
                                                [table()]
                                                , toSQL(current_table_name)
                                                , []
                                                , []
                                                , []
                                                , querySpark(
                                                query(
                                                    selectClause(
                                                        []
                                                        , expAsVars([projectionStar()]))
                                                    , [fromClause([tableId(toSQL(temp_view_name), [])])]
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
                                                    , []
                                                    , []
                                                    ))
                                                    )
                                        )
                                        , [terminator()]
                                    )
                                        
                                ];
                            }
                            case StrategyOption::checkStrategy(): {
                                str uniqueId = head([id | scdUniqueId(id) <- scdProperty.scdConfigList]);
                                list[str] scdAttributes = [attribute | scdAttrib(attribute) <- scdProperty.scdConfigList][0];
                                
                                list[ColumnSpecification] existingColsSpec = [];
                                list[ColumnSpecification] stagingColsSpec = [];
                                existingColsSpec += [columnSpecification(regularIdentifier(uniqueId), primitiveType(intType()), [])];
                                existingColsSpec += [toSQLColumns(viewField) | viewField <- viewFields];
                                existingColsSpec += [columnSpecification(regularIdentifier("ptl_valid_from"), primitiveType(timestampType()), [])];
                                existingColsSpec += [columnSpecification(regularIdentifier("ptl_valid_to"), primitiveType(timestampType()), [])];
                                existingColsSpec += [columnSpecification(regularIdentifier("ptl_is_current"), primitiveType(booleanType()), [])];

                                stagingColsSpec += [columnSpecification(regularIdentifier(uniqueId), primitiveType(intType()), [])];
                                stagingColsSpec += [toSQLColumns(viewField) | viewField <- viewFields];
                                
                                Identifier naturalKey = existingColsSpec[0].identifier;
                                
                                list[ExpAsVarOrStar] columnProjection = [];
                                list[ExpAsVarOrStar] columnProjectionInactiveVersion = [];
                                list[ExpAsVarOrStar] columnProjectionNewActiveVersion = [];
                                list[ExpAsVarOrStar] columnProjectionInsertNewProductionVersion = [];
                                list[ExpAsVarOrStar] columnProjectionInsertNewStagingVersion = [];

                                Identifier ptl_is_active = regularIdentifier("");
                                for(i <- existingColsSpec) {
                                    columnProjection += projectionExpAsVar(expAsVar(propRef([regularIdentifier("production"), i.identifier]), []));
                                    if(i == existingColsSpec[-1]) {
                                        ptl_is_active = i.identifier;
                                    }
                                }

                                for(i <- existingColsSpec) {
                                if(i.identifier == regularIdentifier("ptl_valid_to")) {
                                    columnProjectionInactiveVersion +=  projectionExpAsVar(expAsVar(function(callFunction(regularIdentifier("current_timestamp"), [], [], [], []), []), []));
                                    }
                                    else if(i.identifier == ptl_is_active) {
                                    columnProjectionInactiveVersion +=  projectionExpAsVar(expAsVar(Expr::\false(), []));
                                    }
                                    else {
                                        columnProjectionInactiveVersion += projectionExpAsVar(expAsVar(propRef([regularIdentifier("production"), i.identifier]), []));
                                    }
                                }

                                for(i <- existingColsSpec) {
                                    if(i.identifier == regularIdentifier("ptl_valid_to")) {
                                    columnProjectionNewActiveVersion +=  projectionExpAsVar(expAsVar(function(callFunction(regularIdentifier("to_timestamp"), [], [string("\'9999-12-31 23:59:59\'")], [], []), []), []));
                                    }
                                    else if(i.identifier == regularIdentifier("ptl_valid_from")) {
                                    columnProjectionNewActiveVersion +=  projectionExpAsVar(expAsVar(function(callFunction(regularIdentifier("current_timestamp"), [], [], [], []), []), []));
                                    }
                                    else if(i.identifier == ptl_is_active) {
                                    columnProjectionNewActiveVersion +=  projectionExpAsVar(expAsVar(Expr::\true(), []));
                                    }
                                    else {
                                        columnProjectionNewActiveVersion += projectionExpAsVar(expAsVar(propRef([regularIdentifier("new"), i.identifier]), []));
                                    }
                                }

                                for(i <- existingColsSpec) {
                                    if(i.identifier == regularIdentifier(uniqueId)) {
                                        columnProjectionInsertNewProductionVersion += projectionExpAsVar(expAsVar(propRef([regularIdentifier("production"), i.identifier]), []));
                                    }
                                    else if(i.identifier == regularIdentifier("ptl_valid_to")) {
                                    continue;
                                    }
                                    else if(i.identifier == regularIdentifier("ptl_valid_from")) {
                                    continue;
                                    }
                                    else if(i.identifier == ptl_is_active) {
                                    continue;
                                    }
                                    else {
                                        columnProjectionInsertNewProductionVersion += projectionExpAsVar(expAsVar(propRef([regularIdentifier("staging"), i.identifier]), []));
                                    }
                                }

                                for(i <- stagingColsSpec) {
                                    columnProjectionInsertNewStagingVersion += projectionExpAsVar(expAsVar(propRef([regularIdentifier("staging"), i.identifier]), []));
                                }

                                Columns existing_cols = columns(existingColsSpec);
                                Columns staging_cols = columns(stagingColsSpec);

                                return [statementWithTerminator(createTable(fromSource(
                                    [toSQL(ifNotExist) | ifNotExist <- ifNotExists]
                                    , [toSQLProductionTable(nameOrTemplate)]
                                    , [existing_cols]
                                    , usingClause(parquet(),[])
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                )), [terminator()])
                                , statementWithTerminator(createTable(fromSource(
                                    [toSQL(ifNotExist) | ifNotExist <- ifNotExists]
                                    , [toSQLStagingTable(nameOrTemplate)]
                                    , [staging_cols]
                                    , usingClause(parquet(),[])
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                    , []
                                )), [terminator()])
                                , statementWithTerminator(dropTable([ifExists()], toSQLNewTable(nameOrTemplate), []), [terminator()])
                                , statementWithTerminator(createTable(withQuery(
                                    []
                                    , []
                                    , [toSQL(ifNotExist) | ifNotExist <- ifNotExists] 
                                    , toSQLNewTable(nameOrTemplate)
                                    , [] 
                                    , []
                                    , createTableQuery(queryOrWithQuery(querySpark(query(
                                        selectClause([], expAsVars([projectionStar()])) 
                                        , [fromClause([tableId(toSQLProductionTable(nameOrTemplate), [])])]
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
                                        , [limitOffsetClauses(limitClause(integer("0")), [])]
                                        , []
                                        ))
                                    ))
                                    )), [terminator()])
                                , statementWithTerminator(insertWithQuery(into(
                                    [Table::table()]
                                    , toSQLNewTable(nameOrTemplate)
                                    , []
                                    , []
                                    , querySpark(query(
                                        selectClause([], expAsVars([tableNameDotStar(toTableName("production"))])) 
                                        , [fromClause([tableId(toSQLProductionTable(nameOrTemplate), [regularIdentifier("production")])])]
                                        , []
                                        , []
                                        , []
                                        , []
                                        , [outerJoinClause(
                                            left()
                                            , [] 
                                            , tableId(toSQLStagingTable(nameOrTemplate), [regularIdentifier("staging")]) 
                                            , joinCondition(twoEqual(propRef([regularIdentifier("production"), naturalKey]), propRef([regularIdentifier("staging"), naturalKey]))) 
                                            , []
                                        )]
                                        , [whereClause(isNull(propRef([regularIdentifier("staging"), naturalKey])))]
                                        , []
                                        , []  
                                        , []
                                        , []
                                        , []
                                        , []
                                        ))
                                    )
                                ), [terminator()])
                                , statementWithTerminator(insertWithQuery(into(
                                    [Table::table()]
                                    , toSQLNewTable(nameOrTemplate)
                                    , []
                                    , []
                                    , querySpark(query(
                                        selectClause([], expAsVars(columnProjection)) 
                                        , [fromClause([tableId(toSQLProductionTable(nameOrTemplate), [regularIdentifier("production")])])]
                                        , []
                                        , []
                                        , []
                                        , []
                                        , [innerJoinClause(
                                            []
                                            , tableId(toSQLStagingTable(nameOrTemplate), [regularIdentifier("staging")]) 
                                            , [joinCondition(and(twoEqual(propRef([regularIdentifier("production"), naturalKey]), propRef([regularIdentifier("staging"), naturalKey])), twoEqual(propRef([regularIdentifier("production"), ptl_is_active]), Expr::\false())))]
                                            , []
                                        )]
                                        , []
                                        , []
                                        , []  
                                        , []
                                        , []
                                        , []
                                        , []
                                        ))
                                    )
                                ), [terminator()])
                                , statementWithTerminator(insertWithQuery(into(
                                    [Table::table()]
                                    , toSQLNewTable(nameOrTemplate)
                                    , []
                                    , []
                                    , querySpark(query(
                                        selectClause([], expAsVars(columnProjection)) 
                                        , [fromClause([tableId(toSQLProductionTable(nameOrTemplate), [regularIdentifier("production")])])]
                                        , []
                                        , []
                                        , []
                                        , []
                                        , [innerJoinClause(
                                            []
                                            , tableId(toSQLStagingTable(nameOrTemplate), [regularIdentifier("staging")]) 
                                            , [joinCondition(and(twoEqual(propRef([regularIdentifier("production"), naturalKey]), propRef([regularIdentifier("staging"), naturalKey])), twoEqual(propRef([regularIdentifier("production"), ptl_is_active]), Expr::\true())))]
                                            , []
                                        )]
                                        , [checkAndAttributeList(scdAttributes)]
                                        , []
                                        , []  
                                        , []
                                        , []
                                        , []
                                        , []
                                        ))
                                    )
                                ), [terminator()])
                                , statementWithTerminator(insertWithQuery(into(
                                    [Table::table()]
                                    , toSQLNewTable(nameOrTemplate)
                                    , []
                                    , []
                                    , querySpark(query(
                                        selectClause([], expAsVars(columnProjectionInactiveVersion)) 
                                        , [fromClause([tableId(toSQLProductionTable(nameOrTemplate), [regularIdentifier("production")])])]
                                        , []
                                        , []
                                        , []
                                        , []
                                        , [innerJoinClause(
                                            []
                                            , tableId(toSQLStagingTable(nameOrTemplate), [regularIdentifier("staging")]) 
                                            , [joinCondition(and(twoEqual(propRef([regularIdentifier("production"), naturalKey]), propRef([regularIdentifier("staging"), naturalKey])), twoEqual(propRef([regularIdentifier("production"), ptl_is_active]), Expr::\true())))]
                                            , []
                                        )]
                                        , [checkOrAttributeList(scdAttributes)]
                                        , []
                                        , []  
                                        , []
                                        , []
                                        , []
                                        , []
                                        ))
                                    )
                                ), [terminator()])
                                , statementWithTerminator(insertWithQuery(into(
                                    [Table::table()]
                                    , toSQLNewTable(nameOrTemplate)
                                    , []
                                    , []
                                    , querySpark(query(
                                        selectClause([], expAsVars(columnProjectionNewActiveVersion)) 
                                        , [fromClause([tableIdOrSubquerySubquery(querySpark(query(
                                                selectClause([], expAsVars(columnProjectionInsertNewProductionVersion))
                                                , [fromClause([tableId(toSQLProductionTable(nameOrTemplate), [regularIdentifier("production")])])]
                                                , []
                                                , []
                                                , []
                                                , []
                                                , [innerJoinClause(
                                                    []
                                                    , tableId(toSQLStagingTable(nameOrTemplate), [regularIdentifier("staging")]) 
                                                    , [joinCondition(and(twoEqual(propRef([regularIdentifier("production"), naturalKey]), propRef([regularIdentifier("staging"), naturalKey])), twoEqual(propRef([regularIdentifier("production"), ptl_is_active]), Expr::\true())))]
                                                    , []
                                                    )
                                                ]
                                                , [checkOrAttributeList(scdAttributes)]
                                                , []
                                                , []  
                                                , []
                                                , []
                                                , []
                                                , []
                                            )), regularIdentifier("new"))
                                            ])
                                            ]
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
                                        , []
                                        , []
                                        ))
                                    )
                                ), [terminator()])
                                , statementWithTerminator(insertWithQuery(into(
                                    [Table::table()]
                                    , toSQLNewTable(nameOrTemplate)
                                    , []
                                    , []
                                    , querySpark(query(
                                        selectClause([], expAsVars(columnProjectionNewActiveVersion)) 
                                        , [fromClause([tableIdOrSubquerySubquery(querySpark(query(
                                                selectClause([], expAsVars(columnProjectionInsertNewStagingVersion))
                                                , [fromClause([tableId(toSQLStagingTable(nameOrTemplate), [regularIdentifier("staging")])])]
                                                , []
                                                , []
                                                , []
                                                , []
                                                , [outerJoinClause(
                                                    left()
                                                    , []
                                                    , tableId(toSQLProductionTable(nameOrTemplate), [regularIdentifier("production")])
                                                    , joinCondition(twoEqual(propRef([regularIdentifier("staging"), naturalKey]), propRef([regularIdentifier("production"), naturalKey]))) 
                                                    , [])
                                                ]
                                                , [whereClause(isNull(propRef([regularIdentifier("production"), naturalKey])))]
                                                , []
                                                , []  
                                                , []
                                                , []
                                                , []
                                                , []
                                            )), regularIdentifier("new"))
                                            ])
                                            ]
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
                                        , []
                                        , []
                                        ))
                                    )
                                ), [terminator()])
                                , statementWithTerminator(insertWithQuery(overwrite([Table::table()]
                                    , toSQLProductionTable(nameOrTemplate)
                                    , []
                                    , []
                                    , []
                                    , querySpark(query(
                                        selectClause([], expAsVars([projectionStar()]))
                                        , [fromClause([tableId(toSQLNewTable(nameOrTemplate), [])])]
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
                                        , []
                                        , []
                                        )
                                        )
                                    )
                                ), [terminator()])
                            ];
                        }
                            default: throw TranslationException("message: scd strategy not resolved",typeCast(#node,scdStrategy).src);

                        }
                    }
                    default: throw TranslationException("message: view declaration not resolved",typeCast(#node,v).src);
                }
            }
            default: return [statementWithTerminator(toSQL(d), [terminator()])];
    
        }
        
    } 
}

public ColumnSpecification toSQLColumns(ViewField viewField) {
    switch(viewField) {
        case derivedAttribute(str oname, Type ty, Expr _): return columnSpecification(regularIdentifier(oname), toSQL(ty), []);
        default: throw TranslationException("message: viewField not resolved",typeCast(#node,viewField).src);
    }
}

public TableName toSQLStagingTable(viewName(str nam))=toTableName(nam+"_staging");
public TableName toSQLNewTable(viewName(str nam))=toTableName(nam+"_new");
public TableName toSQLProductionTable(viewName(str nam))=toTableName(nam+"_production");

public WhereClause checkAndAttributeList(list[str] attribs) {
    if(size(attribs) > 1) {
        Expr andAttributes = (twoEqual(propRef([regularIdentifier("production"), regularIdentifier(attribs[0])]), propRef([regularIdentifier("staging"), regularIdentifier(attribs[0])]))| and(it, twoEqual(propRef([regularIdentifier("production"), regularIdentifier(attrib)]), propRef([regularIdentifier("staging"), regularIdentifier(attrib)]))) | str attrib <- attribs[1..]);
        return whereClause(andAttributes);
    }
    else {
        return whereClause(twoEqual(propRef([regularIdentifier("production"), regularIdentifier(attribs[0])]), propRef([regularIdentifier("staging"), regularIdentifier(attribs[0])])));
    }
}

public WhereClause checkOrAttributeList(list[str] attribs) {
    if(size(attribs) > 1) {
        Expr orAttributes = (neq1(propRef([regularIdentifier("production"), regularIdentifier(attribs[0])]), propRef([regularIdentifier("staging"), regularIdentifier(attribs[0])]))| and(it, neq1(propRef([regularIdentifier("production"), regularIdentifier(attrib)]), propRef([regularIdentifier("staging"), regularIdentifier(attrib)]))) | str attrib <- attribs[1..]);
        return whereClause(orAttributes);
    }
    else {
        return whereClause(neq1(propRef([regularIdentifier("production"), regularIdentifier(attribs[0])]), propRef([regularIdentifier("staging"), regularIdentifier(attribs[0])])));
    }
}

public StatementWithTerminator toSQL(dropIfExist(), str id){
    return statementWithTerminator(dropTable([ifExists()], name([], tabId(regularIdentifier(id))), []), [terminator()]);
}

public Expr getColNames(columnSpecification(Identifier identifier, DataType datatype, list[Comment] comment)){
    return string("<identifier.regularId>");

}