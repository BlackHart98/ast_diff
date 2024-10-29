module lang::snowflake::grammar::Query

extend lang::snowflake::grammar::Expressions;

syntax QueryExpr
  = querySnowflake: QuerySnowflake
  > left queryExcept: QueryExpr Except QueryExpr
  > left queryMinus: QueryExpr Minus QueryExpr
  > :queryUnion
  ;

syntax Except = except: 'EXCEPT';
syntax Minus = minus: 'MINUS';
syntax QuerySnowflake 
  = query: 
      SelectClause 
      IntoClause? 
      FromClause? 
      JoinClause* 
      WhereClause? 
      GroupByClause? 
      HavingClause?
      QualifyClause?
      OrderByClause? 
      LimitOffsetClauses? 
    ;
 syntax TableName = sfRef:Identifier"."Identifier"."{Identifier "."}+;

syntax VarAssign
  = varAssignString: VarAssignAs? String
  ;
syntax Expr = subQuery: QueryExpr;

syntax GroupByClause = groupByCube: 'GROUP' 'BY' 'CUBE' ExpListWithBrackets
                        | groupBySets: 'GROUP' 'BY' 'GROUPING' 'SETS' ExpListWithBrackets
                        | groupByRollup: 'GROUP' 'BY' 'ROLLUP' ExpListWithBrackets
                        | groupByAll: 'GROUP' 'BY' 'ALL'
                        ;
syntax TableIdOrSubquery = objectRefJoinClause: ObjectRef 
                                | bracketTableItemJoined: "(" TableIdOrSubquery ")"
                                ;
syntax WithExpression = withExpression: 'WITH' { CommonTableExpression "," }+;

syntax CommonTableExpression = cte: Identifier Columns? 'AS' "("QueryExpr ")";

syntax ValuesBuilder = valuesBuilder: 'VALUES' { ExpListWithBrackets ","}+;

syntax ExpListWithBrackets = expListWithBrackets: "(" ExpList ")";

syntax PivotUnpivot = pivot: 'PIVOT' "(" FunctionCall 'FOR' Identifier 'IN' "(" {Literal ","}+ ")" ")"
                    | unpivot: 'UNPIVOT' "(" Identifier 'FOR' Identifier 'IN' Columns ")"
                    ;
syntax ObjectRef = objectRefMatchWithAlias: Identifier IdParams+
                    | objectRefConnect: Identifier 'START' 'WITH' Expr 'CONNECT' 'BY' PriorList?
                    | objectRefFuncCall: 'TABLE' "(" FunctionCall ")" PivotUnpivot? AsAlias? Sample?
                    | objectRefValuesTable: ValuesTable Sample?
                    | objectRefLateralSubQuery: 'LATERAL' "(" QueryExpr ")" PivotUnpivot? AsAlias?
                    | objectRefNoLateralSubQuery: "(" QueryExpr ")" PivotUnpivot? AsAlias?
                    | objectRefLateralFlatten: 'LATERAL' FlattenTable AsAlias?
                    | objectRefLateralSplitted: 'LATERAL' SplitedTable AsAlias?
                    ;

syntax IdParams =atBefore: AtBefore| changes:Changes|matchRec:  MatchRecognize|pivotUnpivot: PivotUnpivot|asCol: AsColumnAlias|sample:Sample;
//                        //TOP and LIMIT are not allowed together

syntax Measures = measures: 'MEASURES' ExpAsAliasList;

syntax PriorList = priorList: {PriorItem ","}+;

syntax PriorItem = priorItemPriorEq: 'PRIOR' Identifier "=" Identifier
                    | priorItemPriorEqPrior: 'PRIOR' Identifier "=" 'PRIOR' Identifier
                    | priorItemNoPrior: Identifier "=" Identifier
                    | priorItemEqPrior: Identifier "=" 'PRIOR' Identifier
                    ;
syntax MatchRecognize = matchRecognize: 'MATCH_RECOGNIZE' "(" PartitionByClause? OrderElem? Measures? RowMatch? AfterMatch? Pattern? Define? ")";

syntax RowMatch = oneRow: 'ONE' 'ROW' 'PER' 'MATCH' MatchOptions?
                    | allRows: 'ALL' 'ROWS' 'PER' 'MATCH' MatchOptions?
                    ;
syntax Symbol = symbol: 'SYMBOL'; // - Dummy Reference

syntax Pattern = pattern: 'PATTERN' "=" String;

syntax Define = define: 'DEFINE' SymbolList;

syntax SymbolList = symbolList: {SymbolAsExp ","}+;

syntax SymbolAsExp = symbolAsExp: Symbol 'AS' Expr;

syntax MatchOptions = showEmpty: 'SHOW' 'EMPTY' 'MATCHES' 
                    | omitEmpty: 'OMIT' 'EMPTY' 'MATCHES' 
                    | unmatchedRows: 'WITH' 'UNMATCHED' 'ROWS'
                    ;
syntax ValuesTable = valuesTableWithoutParenthesis: ValuesBuilder AsColumnAlias?
                    | valuesTableWithParenthesis: "(" ValuesBuilder ")" AsColumnAlias?
                    ;
syntax AfterMatch = afterMatchLast: 'AFTER' 'MATCH' 'SKIP' 'PAST' 'LAST' 'ROW'
                    | afterMatchNext: 'AFTER' 'MATCH' 'SKIP' 'TO' 'NEXT' 'ROW'
                    | aftermatchSymbol: 'AFTER' 'MATCH' 'SKIP' 'TO' FirstOrLast? Symbol
                    ;



syntax SelectClause = selectClauseWithTop: 'SELECT' SetQuantifier? TopClause Projection;



syntax TopClause = topClause: 'TOP' Int;                    
syntax ExpAsVarOrStar= objectNameColPosition: (TableName ".")? "$" Int AsAlias? 
                   ;
syntax IntoClause =  intoClause: 'INTO' VarList;

syntax QualifyClause = qualifyClause: 'QUALIFY' Expr;

syntax AsAlias = asAlias: 'AS' Identifier
                | asAliasNoAs: Identifier
                ;

syntax Sample = sample: 'SAMPLE' SampleMethod? SampleOpts
                | tableSample: 'TABLESAMPLE' SampleMethod? SampleOpts
                ;


syntax SampleMethod = rowSamplMethod: RowSampling
                    | blockSampleMethod: BlockSampling
                    ;

syntax RowSampling = bernoulliSampling: 'BERNOULLI'
                    | rowSampling: 'ROW'
                    ;

syntax BlockSampling = systemSampling: 'SYSTEM' 
                        | blockSampling: 'BLOCK'
                        ;


syntax SampleOpts = sampleOpts: "(" Int 'ROWS' ")" RepeatableSeed?
                    | sampleOptNoRows: "(" Int ")" RepeatableSeed?
                    ;

syntax RepeatableSeed = repeatableSeed1: 'REPEATABLE' "(" Int ")"
                        | repeatableSeed2: 'SEED'  "(" Int ")"
                        ;


syntax AsColumnAlias = asColumnAlias: AsAlias ColumnAliasList?;

syntax ColumnAliasList = columnAliasList: "(" {Identifier ","}+ ")";

syntax FlattenTable = flattenTable: 'FLATTEN' "(" InputAssociation? Expr CommaFlattenTableOpt* ")";

syntax InputAssociation = inputAssociation: 'INPUT' "=\>";

syntax CommaFlattenTableOpt = commaFlattenTableOpt: "," FlattenTableOpt;

syntax FlattenTableOpt = pathAssoc: 'PATH' "=\>" String
                            | outerAssoc: 'OUTER' "=\>" Boolean
                            | recursiveAssoc: 'RECURSIVE' "=\>" Boolean
                            | modeAssocArray: 'MODE' "=\>" '\'ARRAY\'' 
                            | modeAssocObj: 'MODE' "=\>" '\'OBJECT\''
                            | modeAssocBoth: 'MODE' "=\>" '\'BOTH\''
                            ;

syntax SplitedTable = splitedTable: 'SPLIT_TO_TABLE' ExpListWithBrackets;

syntax Changes = changes: 'CHANGES' "(" 'INFORMATION' "=\>" DefaultAppendOnly ")" AtBefore End?;

syntax AtBefore = atTimeStamp: 'AT' "(" 'TIMESTAMP' "=\>" Expr ")"
                | atOffset: 'AT' "(" 'OFFSET' "=\>" Expr ")"
                | atStatement: 'AT' "(" 'STATEMENT' "=\>" String ")"
                | atStream: 'AT' "(" 'STREAM' "=\>" String ")"
                | beforeStatement: 'BEFORE' "(" 'STATEMENT' "=\>" String ")"
                ;
 syntax ExpAsAlias = expAsAlias: Expr AsAlias;

syntax ExpAsAliasList = expAsAliasList: {ExpAsAlias ","}+;

syntax FirstOrLast = firstOrLast1: 'FIRST' 
                    | firstOrLast2: 'LAST'
                    ;

syntax DefaultAppendOnly = defaultNoAppendOnly: 'DEFAULT'
                           | appendOnly: 'APPEND' 'ONLY'
                            ;

syntax End = endTimeStampString: 'END' "(" 'TIMESTAMP' "-\>" String ")"
            | endOffset: 'END' "(" 'OFFSET' "-\>" String ")"
            | endStatement: 'END' "(" 'STATEMENT' "-\>" Identifier ")"
            ;