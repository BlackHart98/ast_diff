module lang::bigquery::ast::BigQuery

extend lang::bigquery::ast::DDL;



data BigQuery 
    = expression(Expr expr)
    | statements(list[StatementWithTerminator] statementWithTerminatorList)
    | simpleStatement(Statement statement)
    ;

// DCL
data Statement = dclStatement(DCL dclStatement);

data DCL
  = grantCommand(GrantStatement grantCommand)
  | revokeCommand(RevokeStatement revokeCommand)
  ;

data GrantStatement = grantStatement(Expr, ResourceType, TableName, list[Expr]);

data RevokeStatement = revokeStatement(Expr, ResourceType, TableName, list[Expr]);

data ResourceType
  = schemaType()
  | tableType()
  | viewType()
  | externalTableType()
  ;

// DML
data InsertWithQuery
    = intoWithValue(
        list[Table] tableOpt
        , TableName tableName
        , list[IfNotExists] ifNotExistsOpt
        , list[ColumnSpecificationForInsert] columnSpecOpt
  	    , Value vl
        )
    | noIntoOrOverwrite(
        list[Table] tableOpt
        , TableName tableName
        , list[PartitionWithOptionValueClause] partWithOptValueClsOpt
        , list[ColumnSpecificationForInsert] columnSpecOpt
        , QueryOrWith qryOrWith
    )
    | noIntoOrOverwriteWithValue(
        list[Table] tableOpt
        , TableName tableName
        , list[IfNotExists] ifNotExistsOpt
        , list[ColumnSpecificationForInsert] columnSpecOpt
  	    , Value vl
    )
    ;

data Value = inputValue(list[BracketExp] bracketExprList) ;
data BracketExp = bracketExp(list[ExpOrDefault] exprOrDefault);

data ExpOrDefault
    = exp(Expr expr)
    | \default()
    ;



data Statement 
    = mergeInto(TableName tblName, list[VarAssign] varAssignOpt1, Expr expr1, list[VarAssign] varAssignOpt2, Expr expr2, list[MergeWhen] mergeWhenCls)
    | mergeNoInto(TableName tblName, list[VarAssign] varAssignOpt1, Expr expr1, list[VarAssign] varAssignOpt2, Expr expr2, list[MergeWhen] mergeWhenCls)
    | updateStatement(
        TableName tblName
        , list[VarAssign] varAssignOpt
        , SetClause setCls
        , list[FromClause] fromClauseOpt
        , list[JoinClause] joinClauseOpt
        , WhereClause whereCls
    )
    ;

data MergeWhen 
    = matchedClause(list[ByTargetOrSource] byTgtOrSrcOpt, list[AndBool] andBoolOpt, MergeClause mergeCls)
    | notMatchedClause(list[ByTargetOrSource] byTgtOrSrcOpt, list[AndBool] andBoolOpt, MergeClause mergeCls)
    ;

data AndBool = andBool(Expr expr);

data MergeClause
    = mergeWithUpdate(MergeUpdate mergeUpdate)
    | mergeWithDelete(MergeDelete mergeDelete)
    | mergeWithInsert(MergeInsert mergeInsert)
    ;

data ByTargetOrSource = byTarget() | bySource();
data MergeUpdate = mergeUpdate(SetClause setCls);
data MergeDelete = mergeDelete();
data MergeInsert = mergeInsert(list[OptionalColumns] optCols, MergeInput mergeInput);
data SetClause = setClause(list[SetTo] setTo);
data SetTo = setTo(TableName tableName, ExpOrDefault expordef);
data OptionalColumns = optionalColumns(list[Identifier] ids);
data MergeInput = mergeValue(list[BracketExp] bracketExprList) | mergeRow();



data Statement = deleteStatement(list[str] fromLit, TableName tbl1, list[TableName] tbl2, WhereClause whrClause);



// Procedure

data Statement = proceduralStatement(Procedural proceduralStatement);

data Statement 
    = createProcedure(
        list[OrReplace] orReplaceOpt
        , list[IfNotExists] ifNotExistsOpt
        , TableName tblName
        , list[ProcedureArgument] procedureArgument
        , list[SchemaOptions] schemaOpts
        , BeginEnd beginEnd
        )
    | createStoredProcedure(
        list[OrReplace] orReplaceOpt
        , list[IfNotExists] ifNotExistsOpt
        , TableName tblName
        , list[ProcedureArgument] procedureArgument
        , WithConnection withConnection
        , list[SchemaOptions] schemaOpts
        , list[LangAsExp] langAsExpOpt
        )
    ;

data ProcedureArgument = procedureArg(list[InOut] inOut, NameType nameType);


data InOut
    = \in()
    | out()
    | inout()
    ;

data LangAsExp = langAsExp(Identifier id, Expr expr);



data Procedural = proceduralCommand(ProceduralCommands proceduralCommand);

data ProceduralCommands
    = declareCommand(DeclareStatement declareCommand)
    | setCommand(SetStatement setCommand)
    | executeCommand(ExecuteImmediate executeCommand)
    | beginEndCommand(BeginEnd beginEndCommand)
    | beginExecEndCommand(BeginExceptionEnd beginExecEndCommand)
    | caseCommand(Case caseCommand)
    | ifCommand(If ifCommand)
    | labelBeginCommand(LabelBegin labelBeginCommand)
    | labelBeginExceptionCommand(LabelBeginException labelBeginExceptionCommand)
    | labelForCommand(LabelFor labelForCommand)
    | labelWhileCommand(LabelWhile labelWhileCommand)
    | labelRepeatCommand(LabelRepeat labelRepeatCommand)
    | labelLoopCommand(LabelLoop labelLoopCommand)
    | loopCommand(Loop loopCommand)
    | repeatCommand(Repeat repeatCommand)
    | whileCommand(While whileCommand)
    | brkOrConCommand(BreakOrContinue brkOrConCommand)
    | forInCommand(ForIn forInCommand)
    | transactionCommand(Transaction transactionCommand)
    | raiseCommand(Raise raiseCommand)
    | returnCommand(Return returnCommand)
    | callCommand(Call callCommand)
    ;


data DeclareStatement = declare(list[TableName] tblNameOpt, list[DataType] dataTypeOpt, list[DefaultExp] defaultExprOpt);

data DefaultExp = defaultExp(Expr expr);

data SetStatement
    = setStatement(Expr exp1, Expr exp2)
    | setWithBrackets(list[TableName] tableNames, list[Expr] exps)
    ;

data ExecuteImmediate = executeImmediate(Expr, list[IntoVar], list[UsingId]);

data IntoVar = intoVar(list[Expr]);

data UsingId = usingId(list[ExpAsAliasOpt] expasaliasopt);

data ExpAsAliasOpt = expasaliasopt(Expr exp, list[VarAssign] asAlias);

data BeginEnd = beginEnd(list[StatementWithTerminator]);

data BeginExceptionEnd = beginExceptionEnd(list[StatementWithTerminator] sqlstmt1, list[StatementWithTerminator] sqlstmt2);

data Case = \case(list[Expr], list[When]);

data When = when(Expr, list[StatementWithTerminator], list[Else]);

data If = \if(Expr, list[StatementWithTerminator], list[ElseIf], list[Else]);

data ElseIf = elseIf(Expr, list[StatementWithTerminator]);

data Else = \else(list[StatementWithTerminator]);

data Loop = loop(list[StatementWithTerminator]);

data Repeat = repeat(list[StatementWithTerminator], Expr);

data While = \while(Expr, list[StatementWithTerminator]);

data BreakOrContinue = breakStatement(Break breakStatement) | continueStatement(Continue continueStatement);

data Break
    = \break(list[Identifier])
    | leave(list[Identifier])
    ;

data Continue
    = \continue(list[Identifier])
    | iterate(list[Identifier])
    ;

data ForIn = forIn(Identifier, Expr, list[StatementWithTerminator]);

data LabelBegin = labelBegin(Identifier,BeginEnd, list[TableName]);
data LabelBeginException = labelBeginException(Identifier,BeginExceptionEnd, list[TableName]);
data LabelLoop = labelLoop(Identifier,Loop, list[TableName]);
data LabelWhile = labelWhile(Identifier,While, list[TableName]);
data LabelFor = labelFor(Identifier,ForIn, list[TableName]);
data LabelRepeat = labelRepeat(Identifier,Repeat, list[TableName]);

data BlockOrLoopStatement = blockOrloop(Expr);

data Transaction = transaction(TransactionOptions topts, list[str] strConst);

data TransactionOptions = beginTxn() | commitTxn() | rollbackTxn();

data Raise = raise(Expr);

data Return = \return();

data Call = call(Expr, list[Expr]);

