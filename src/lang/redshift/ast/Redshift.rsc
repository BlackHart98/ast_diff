module lang::redshift::ast::Redshift

extend lang::redshift::ast::DML;

data Redshift 
    = expression(Expr expr)
    | statements(list[StatementWithTerminator] stmtWithTerminator)
    ;


data StatementWithTerminator = statementWithTerminator(Statement stmt, list[Terminator] terminator);

data Terminator = terminator();


// Auxiliary
data Statement
    = abort(list[WorkOrTransaction] workOrTransactionOpt)
    | analyze(list[str] verboseOpt, list[TableName] tblNameOpt, list[BracketCol] bracketColOpt, list[AnalyzeCols] analyzeColsOpt)
    | analyzeCompression(list[TableName] tblNameOpt, list[BracketCol] bracketColOpt, list[Comprows] comprowsOpt)
    | attachRlsPolicy(TableName tblName, list[str] tableOpt, list[TableName] tblNAmeList, list[str] toOpt, list[GrantTo] grantToList)
    | beginStatement(BeginStart beginStart, list[WorkOrTransaction] workOrTransactionOpt, list[IsolationLevel] isolationLevelOpt, list[ReadOpts] readOptsOpt)
    | call(TableName tblName, list[Expr] exprList)
    | cancel(Expr expr, list[str] strLitOpt)
    | close(Expr expr)
    | comment(CommentOpts commentOpts, Expr expr)
    | commit(list[WorkOrTransaction] workOrTransactionOpt)
    | copy(TableName tblName, list[Expr] exprOpt, Expr expr, list[IamRole] iamRoleList, list[FormatAs] formatAsOpt)
    | end(list[WorkOrTransaction] workOrTransactionOpt)
    | deallocate(list[Prepare] prepareOpt, Identifier identifier)
    | delete(
        list[WithClauseDel] withClauseDelOpt
        , list[FromWord] fromWordOpt
        , TableName tblName
        , list[UsingClause] usingClauseOpt
        , list[WhereClause] whereClauseOpt
        )
    | declareCursor(Identifier id, Query qry)
    | descDataShare(Identifier id, list[DtShNameSpace] dtShNameSpaceOpt)
    | descIDProvider(Identifier id)
	| detachMaskingPolicy(Identifier id, TableName tblName, list[Identifier] idList, DetachMaskingPolicyNames detachMaskingPolicyNames)
	| detachRLSPolicy(Identifier id, list[str] tblOpt, list[TableName] tblNameList, list[DetachMaskingPolicyNames] detachMaskingPolicyNamesList)
    ;


data Comprows = comprows(Expr expr);
data FromWord = fromWord();
data AnalyzeCols = predicateCol() | allColumns();
data BeginStart = begin() | \start();
data ReadOpts = readwrite() | readonly();
data CommentOpts 
    = commentTable(TableName tblName)
    | commentColumn(TableName tblName)
    | comment(TableName tblName1, TableName tblName2)
    | commentDatabase(TableName tblName)
    | commentView(TableName tblName)
    ;

data FormatAs = formatAs(list[str] asOpt, Expr expr);
data Prepare = prepare();
data DtShNameSpace = dtShNamespace(list[AccountId] accountIdOpt, Identifier id);
data WithClauseDel = withClauseDel(WithClause withClause, list[CTEClause] cteClauseList);
data DetachMaskingPolicyNames = username(Identifier id) | roleNameType(Identifier id) | publicNameType();

