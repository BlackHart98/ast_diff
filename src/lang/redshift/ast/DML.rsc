module lang::redshift::ast::DML

extend lang::redshift::ast::DDL;


data Statement
    = insertWithValue(InsertWithValue insertWithVal)
    | mergeStatement(TableName tblName1, TableName tblName2, list[VarAssign] varAssignOpt, Expr expr, list[MergeOpts] mergerOptsOpt)
    | refreshMaterialized(TableName tblName)
    | reset(NameOrAll nameOrAll)
    | rollback(list[WorkOrTransaction] workOrTransactionOpt)
    | revoke(
        list[GrantOptFor] grantOptForOpt
        , GrantOpts grantOpts
        , list[GrantFor] grantForOpt
        , list[GrantOnStmt] grantOnStmtOpt
        , list[GrantToStmt] grantToStmtOpt
        , list[str] restrictOpt
        )
    | setStatement(SetOptions setOptions)
    | setSessionAuth(list[str] localOpt, Expr expr)
    ;


data InsertWithValue 
    = intoValue(TableName tblName, list[BracketCol] bracketColOpt, list[InsertOpts] insertOptsOpt)
    ;

data GrantOptFor = grantOptionFor();
data WorkOrTransaction = work() | transaction();

data NameOrAll
    = nameopt(TableName tblName)
    | allopt()
    ;


data InsertOpts
    = defvalue()
    | valExpr(list[ArrayLiteral] arrayLitList)
    ;

data MergeOpts  = mergeOpts(MatchedOpts matchedOpts1, MatchedOpts matchedOpts2);

data MatchedOpts 
    = thenupdate(Expr expr1, list[Expr] exprList)
    | thenDelete()
    | thenVals(list[BracketCol] bracketColOpt, list[Expr] exprList)
    | thenRemove()
    ;

data GrantOpts 
    = grantExpr(list[Expr] exprList, list[BracketCol] bracketColOpt)
    | allPrivileges(Privilege privilege, list[BracketCol] bracketColOpt)
    | usage()
    | grantModel()
    | grantExplain()
    | grantInclude()
    | grantSelect(list[str] tableOpt, list[TableName] tblNameList)
    | grantExecute(list[GrantExecute] grantExecuteList)
    ;

data Privilege = privilege(list[str] privilegeOpt);
data GrantFor = grantFor(Expr expr, list[GrantOn] grantOnList);

data GrantOnStmt = grantOnStmt(GrantOn grantOn);
data GrantToStmt = grantToStmt(list[GrantTo] grantToList, list[WithGrantOption] withGrantOptionOpt, list[WithAdminOption] withAdminOptionOpt);

data GrantTo 
    = grantToUsername(TableName tblName)
    | grantToRole(list[TableName] tblNameOpt)
    | grantToGroup(TableName tblName)
    | grantToPublic()
    | grantToIamRole(IamRole iamRole)
    | grantToNamespace(list[str] strLitList)
    | grantToAccount(str strLit, list[ViaDataCatalog] viadatacatalogOpt)
    ;

data ViaDataCatalog = viadatacatalog();
data WithGrantOption = withGrantOption();
data WithAdminOption = withAdminOption();


data GrantOn
    = gTable(list[TableName] tblNameList)
    | gAllTables(list[TableName] tblNameList)
    | gDatabase(list[TableName] tblNameList)
    | gSchema(list[TableName] tblNameList)
    | gFunction(list[TableName] tblNameList, BracketNameModeType bracketNameModeType)
    | gAllFuncs(list[TableName] tblNameList)
    | gLanguage(list[TableName] tblNameList)
    | gExternal(list[TableName] tblNameList)
    | gDatashare()
    | gModel(TableName tblName)
    ;

data SetOptions =  setOpt(list[SessionLocal] sessionLocalOpt, TableName tblName, ToEq toEp, Expr expr);
data SessionLocal = session()| local();



data GrantExecute = grantExecute();


data Statement 
    = show(TableName tblName)
    | showColumns(list[TableName] tblNameOpt, list[ShowLike] showLikeOpt, list[LimitClause] limitClauseOpt)
    | showExternalTable(TableName tblName, list[str] partitionOpt)
    | showDatabasesWithLike(ShowLike showLike, list[IamRole] iamRoleOpt)
    | showDatabasesWithIamRole(IamRole iamRole)
    | showModel(NameOrAll nameOrAll)
    | showDatashares(list[ShowLike] showLikeOpt)
    | showProcedure(TableName tblName, list[BracketNameModeType] bracketNameModeTypeOpt) // check
    | showSchemas(TableName tblName, list[ShowLike] showLikeOpt, list[LimitClause] limitClauseOpt)
    | showTable(TableName tblName)
    | showTables(TableName tblName, list[ShowLike] showLikeOpt, list[LimitClause] limitClauseOpt)
    | showView(TableName tblName)
    ;

data ShowLike = showLike(Expr expr);










