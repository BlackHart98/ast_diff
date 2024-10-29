module lang::redshift::ast::DDL

extend lang::redshift::ast::Query;


// DDL
data Statement
    = createDatabase(
      TableName tblName
      , list[WithClause] withClauseOpt
      , list[Owner] ownerOpt
      , list[ConnectionLimit] connectionLimitOpt
      , list[Collate] collateOpt
      , list[IsolationLevel] isolationLevelOpt
      , list[FromDatashare] fromDatashareOpt
      , list[WithDataCatalog] withDataCatalogOpt
      , list[IamRole] iamRoleOpt
      )
    | createDatashare(TableName tblName, list[SetAccessible] setAccessibleOpt)
    | createExternalFunction(
      list[OrReplace] orReplaceOpt
      , TableName tblName
      , list[DataType] datatypelist
      , ReturnDatatype returnType
      , VolatileStableImmutable volatileStblImmutbl
      , list[SageMaker] sageMakerOpt
      , list[LambdaName] lambdaNameOpt
      , IamRole iamRole
      , list[RetryTimeout] retryTimeoutOpt
      , list[MatchBatchRows] matchBatchRowsOpt
      , list[MatchBatchSize] matchBatchSizeOpt
      )
    | createExternalSchema(
      list[IfNotExists] ifNotExistsOpt
      , TableName tblName
      , list[str] dataCatalogOpt
      , list[ExternalSchemaOpts] externalSchemaOptsOpt
      , list[DatabaseName] databaseNameOpt
      , list[SchemaName] schemaNameOpt
      , list[RegionName] regionNameOpt
      , list[UriPort] uriPortOpt
      , IamRole iamRole
      , list[SecretArn] secretArnOpt
      , list[Auth] authOpt
      , list[ClusterArn] clusterArnOpt
      , list[CatalogRole] catalogRoleOpt
      , list[CreateExternalDB] createExternalDBOpt
      , list[CatalogId] catalogIdOpt
      )
    | createExternalTableAsQuery1(
        TableName tblName
        , PartitionBy partitionedByCls
        , list[RowFormatClause] rowFormatClsOpt
        , list[StorageClause] storedAsOpt
        , list[LocationClause] locationClsOpt
        , list[TablePropertiesClause] tblPropertiesClsOpt
        , CreateTableQuery asSelect
       )
    | createExternalTableAsQuery2(
        TableName tblName
        , list[RowFormatClause] rowFormatClsOpt
        , list[StorageClause] storedAsOpt
        , LocationClause locationCls
        , list[TablePropertiesClause] tblPropertiesClsOpt
        , CreateTableQuery asSelect
       )
    | createExternalTableAsQuery3(
        TableName tblName
        , list[RowFormatClause] rowFormatClsOpt
        , list[StorageClause] storedAsOpt
        , TablePropertiesClause tblPropertiesCls
        , CreateTableQuery asSelect
       )
    | createExternalView(TableName tblName, list[IfNotExists] ifNotExistsOpt, CreateTableQuery asSelect)
    | createFunction(
        list[OrReplace] orReplaceOpt
        , TableName tblName
        , BracketNameModeType bracketNameModeType
        , ReturnDatatype returnDatatype
        , VolatileStableImmutable volatileStblImmutbl
        , Expr expr
        , Language language
        )
    | createGroup(TableName tblName, list[WithUser] withUserOpt)
    | createIdentityProvider(TableName tblName, Identifier identifier, Expr expr, str strLit)
    | createLibrary(list[OrReplace] orReplaceOpt, TableName tblName, Language language, LibraryOpts libraryOpts)
    | createMaterializedView(TableName tblName, list[Backup] backupOpt, list[TableAttributes] tblAttrOpt, list[AutoRefresh] autoRefreshOpt, CreateTableQuery asSelect)
    | createModel(
        TableName tblName
        , Expr expr
        , list[Target] targetOpt
        , Function function
        , list[ReturnDatatype] returnDatatypeOpt
        , IamRole iamRole
        , list[TypeId] typeIdList
        , list[Settings] settingsOpt
        )
    | createProcedure(
        list[OrReplace] orReplaceOpt
        , TableName tblName
        , BracketNameModeType bracketNameModeType
        , list[str] nonatomicOpt
        , Expr expr
        , Language language
        , list[Security] securityOpt
        )
    | createRlsPolicy(TableName tblName, list[WithRls] withRlsOpt, Expr expr)
    | createRole(TableName tblName, list[ExternalId] externalIdOpt)
    | createSchema(list[TableName] tblNameOpt1, list[str] authorizationOpt, list[IfNotExists] ifNotExistsOpt, TableName tblName2, list[Quota] quotaOpt)
    | createUser(TableName tblName, list[UserId] userIdOpt, list[str] withOpt, list[UserOptions] userOptionsList)
    | createViewWithNoSchema(list[OrReplace] orReplaceOpt, TableName tblName, list[BracketCol] bracketColOpt, CreateTableQuery asSelect, WithNoSchema withNoSchema)
    | createOrReplaceView(OrReplace orReplace, TableName tblName, list[BracketCol] bracketColOpt, CreateTableQuery asSelect)
    ;

data CreateTable
    = createTable2(
      list[str] localOpt
      , list[TempVariant] tempVariantOpt
      , list[IfNotExists] ifNotExistsOpt
      , TableName tblname
      , list[BracketCrtableOpts] bracketCrtableOptsOpt
      , list[BracketCol] btacketColOpt
      , list[Backup] backupOpt
      , list[TableAttributes] tblAttrList
      , list[CreateTableQuery] createTblQryOpt
      )
    ;


data BracketCrtableOpts = bracketCrtableOpts(list[CreateTableOpts] createTblOptsOpt);

data CreateTableOpts 
    = cr1(TableName tblName, DataType datatype, list[AttrOrConst] attrOrConstList)
    | cr2(TableConstraints tblConstraints)
    | cr3(TableName tblName, IncludingOrExcluding includingOrExcluding)
    ;

data PartitionBy = partitionBy(BracketNameModeType bracketNameModeType);
data TableConstraints = tableConstraints(UniqOrPrimOrFrgn uniqOrPrimOrFrgn);
data AttrOrConst = colAttr(ColumnAttributes colAttrs) | colConst(ColumnConstraints colConstr);
data IncludingOrExcluding = including() | excluding();
data ExternalId = externalId(Expr expr)| externalIdTo(Identifier id) | externalIdToStr(str strLit);
data UserId = userId(Identifier id);

data UniqOrPrimOrFrgn
    = unique(list[BracketCol] bracketcols)
    | primaryKey(list[BracketCol] bracketcols)
    | foreignKey(BracketCol bracketCol, References refs)
    ;

data ColumnAttributes 
    = colOrAttrDef(DefaultExpr caDef)
    | colOrAttrId(Identity caId)
    | colOrAttrGen(GeneratedBy caGen)
    | colOrAttrEnc(Encode caEnc)
    | colOrAttrDist(Distkey caDist)
    | colOrAtttrSort(Sortkey caSort)
    | colOrAttrColl(Collate caColl)
    ;

data ColumnConstraints 
    = nullOpt(NullOptions nullOpt)
    | upf(UniqOrPrimOrFrgn upf)
    | ref(References ref)
    ;

data References =references(Identifier id, list[BracketCol] bracketcols);


data Identity = identity(list[ExprExpr] expexpOpt);
data ExprExpr = expexp(Expr exp1, Expr exp2);
data GeneratedBy = generatedBy(list[ExprExpr] exprexprOpt);
data Encode = encode(Expr expr);
data DefaultExpr = defaultExpr(Expr expr);

data Sortkey = sortkey();
data NullOptions = null() | notNull(); 


data TableAttributes  
    = tableDistStyle(DistStyle taDistS)
    | tableDistKey(Distkey taDistK)
    | tableSortKey(SortKey taSort)
    | tableEncode(EncodeAuto taEnc)
    ;

data DistStyle = distStyle(DistOpts distOpts);
data SortKey = sortKey(BracketCol bracketcol, list[str] strConst, list[str] autoConst);
data EncodeAuto = encodeAuto();
data Distkey = distkey(list[BracketCol] bracketcol);


data DistOpts
    = auto()
    | even()
    | key()
    | distall()
    ;


data UserOptions
    = createNoCreateDb(CreateNoCreateDb crdb)
    | createNoCreateUser(CreateNoCreateUser cruser)
    | sysRes(RestrictedUnrestricted restricedOrNot)
    | passw(UserOptionSecureType useroptssec,list[Validity] validityOpt)
    | renameId(TableName tablename)
    | connlimit(ConnectionLimit connlimit)
    | sessionTimeout(SessionLimit sessionLimit)
    | settoval(Expr expr1, ToEq toeq, Expr expr2)
    | resetAlter(Expr expr)
    | exterId(ExternalId eid)
    | inGroup(list[TableName] tablenames)
    ;

data ToEq = to() | eq();

data SessionLimit
    = sessionLimit(str integer)
    | timeoutSession()
    ;

data Validity = validtill(Expr expr);


data RestrictedUnrestricted
    = restricted()
    | unrestriced()
    ;

data CreateNoCreateDb
    = createDb()
    | nCreateDB()
    ;

data CreateNoCreateUser
    = createUser()
    | noCreateUser()
    ;


data TablePropertiesClause = tablePropertiesClause2(list[TableProperty] tblPropsList);


data WithUser = withUser(User user);
data User = user(list[TableName] tblNameOpt);
data Language = lang(LangOpts langOpts);
data Target = target(Expr expr);
data TypeId = typeid(Identifier id, Expr expr);
data ByteFormat = kb() | mb() | gb() | tb();
data VolatileStableImmutable = volatile() | stable() | immutable();
data OrReplace = orReplace();

data BracketCol = bracketCol(list[Expr] exprList);

data DatabaseName = databaseName(str strConst);
data SchemaName = schemaName(str strConst);
data RegionName = regionName(str strConst);
data UriPort = uriPort(str strConst,list[PortNumber] portNumber);
data PortNumber = portNumber(str integer);
data SecretArn = secretArn(str strConst);
data Auth = auth(str strConst);
data ClusterArn = clusterArn(str strConst);
data CatalogRole = catalogRole(str strConst);
data CatalogId = catalogId(str strConst);

data CreateExternalDB = createExternalDB(IfNotExists ifnotexists);
data Settings = settings(list[TypeId] typeidOpt);

data Backup = backup(YesOrNo yesorno);
data AutoRefresh = autoRefresh(YesOrNo id);
data YesOrNo = yes()| no();
data IamRole = iAmRole(Identifier id, IamRoleOptions roleOpts);

data IamRoleOptions
    = roleDefault()
    | roleSession()
    | roleCustom(str strConst)
    ;

data LangOpts 
    = plpythonu()
    | sql()
    | plpsql()
    ;

data ReturnDatatype =returnType(DataType datatype);

data SageMaker = sageMaker(str strConst);
data LambdaName =lambdaStr(str strConst);
data RetryTimeout =retryTimeout(Expr expr);
data MatchBatchRows =maxBatchRows(Expr count);
data MatchBatchSize =maxBatchSize(Expr expr, ByteFormat byteformat); 


data WithDataCatalog = withDataCatalog(list[str] noOpt, list[str] strConst);

data Owner = owner(list[str] eqLit, TableName tablename);

data ConnectionLimit = connectionLimit(ConnLimitOptions connlimitOpts);

data Quota 
    = unlimited()
    | quotaUnit(str integer, list[ByteFormat] memorySizeUnitOpt)
    ;

data Collate = collate(CaseOption caseOption);

data IsolationLevel = isolationLevel(SerializableSnapshot serialSnap);
data CaseOption = caseSensitive() | caseInsensitive();
data SerializableSnapshot = serializable() | snapshot();

data ConnLimitOptions = limit(str integer) | connunlimited();

data FromDatashare = fromDatashare(list[WithPermissions] withPermissionsOpt, TableName tablename, list[AccountId] accId,Expr expr);
data SetAccessible = setAccessible(list[str] strConst, Boolean tOrf);
data AccountId = accountId(Expr expr); 
data WithPermissions = withPermissions();

data BracketNameModeType = bracketNameModeType(list[NameModeType] nameModeType);

data Function = function(TableName tblName, list[DataType] datatypeOpt);
data Security = securityInvoker() | securityDefiner();

data ArgMode = argIn() | argout() | argInOut();
data UserOptionSecureType = disable() | passExpr(Expr expr);

data NameModeType = nameModeType(Identifier id, list[ArgMode] argModeOpt, list[DataType] datatypeOpt);
data WithRls = withRls(BracketNameModeType bracketNameModeType, list[str] strConstOpt, list[TableName] tblNameOpt);
data ExternalSchemaOpts = hiveMetastore() | postgres() | mysql() | kinesis() | msk() | redshift();
data RegionAs = regionAs(list[VarAssignAs] asStr, Expr expr);
data LibraryOpts = libOpts(str strConst, list[IamRole] iamroleOpt1, list[RegionAs] regionAsOpt, list[IamRole] iamroleOpt2);

data Validity= validUntil(Expr expr);
data WithNoSchema = withNoSchema();



data AlterTable
    = addConstraints(TableName tblName, list[Constraints] constraintOpt, TableConstraints tblConstraints)
    | dropConstraints(TableName tblName, Identifier id, list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt)
    | changeOwner(TableName tblName, Identifier id)
    | renameColumn(TableName tblName, Identifier id1, Identifier id2)
    | alterColumnType(TableName tblName, Identifier id, Expr expr)
    | alterColumnEncode(TableName tblName, Identifier id, list[Identifier] idList)
    | distAndSortKeyList(list[DistAndSortKey] distAndSortKeyList)
    | encodeAutoAlter()
    | addColumn(
        TableName tblName
        , list[str] columnOpt
        , Identifier id1
        , Identifier id2
        , list[DefaultExpr] defaultExprOpt
        , list[Encode] encodeOpt
        , list[NullOptions] nullOptionsOpt
        , list[CollateOpt] collateOpt
        )
    | dropColumn(TableName tblName, list[str] columnOpt, Identifier id, list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt)
    | rowLevelSecurity(TableName tblName, OnOrOff onOrOff, list[CjnTypes] cjnTypesOpt)
    | setLocation(TableName tblName, SetLocation setLocation)
    | setFileFormat(TableName tblName, Identifier id)
    | setExternalTableProperties(TableName tblName, AlterPropsVal alterPropsVal)
    | setExternalPartition(TableName tblName, list[AlterPropsVal] alterPropsValOpt, SetLocation setLocation)
    ;

data Constraints = constraint(Identifier id); 

data CascadeOrForceOrRestrict 
    = cascade()
    | force()
    | restrict()
    ; 

data SetLocation = setLoc(str strConst);
data CjnTypes = cjnTypes(AndOr andor, list[FrDtShare] frDtShareOpt);
data CollateOpt = collOpt(CaseOption caseopt);
data OnOrOff = on() | off();
data DistAndSortKey
    = altTbDist(Identifier id)
    | altTbDistStyle(AltTbDstStyleOption a)
    | sortKey(list[AltTbCmpd] alttbcmpd, AltTbSrtOpt altTbSrtOpt)
    ;



data AlterPropsVal = altPropsVal(list[Identifier] ids, Expr expr);
data FrDtShare = frDtShare();
data AndOr = and() | or();
data AltTbCmpd = compound();
data AltTbDstStyleOption
    = dstAll()
    | dstEven()
    | dstAuto()
    | dstKey(Identifier id)
    ;

data AltTbSrtOpt 
    = srtAuto()
    | srtNone()
    | withColName(list[Identifier] ids)
    ;


data Statement
    = alterDatabase(list[TableName] tblNameOpt, AlterDBOptions alterDBOptions)
    | alterAddOrRemoveObjects(Identifier id, AddOrRemoveObjects addOrRemoveObjs, AlterDataShareOptions alterDataShareOptions)
    | alterConfigPropsOpt(Identifier id, list[SetPubAcc] setPubAccOpt, list[SetIncNew] setIncNewOpt)
    | alterExternalView(TableName tblName, list[str] forceOpt, list[CreateTableQuery] createTblQryOpt, list[RemoveDefinition] removeDefOpt)
    | alterDefaultPrivileges(list[ForUser] forUserOpt, list[InSchema] InSchemaOpt, GrantOrRevoke grantRevoke)
    | alterMaskingPolicy(TableName tblName, Expr expr) //TODO: work on Exp as masking expression 
    | alterIdentityProvider(TableName tblName, str strLit)
    | alterGroup(TableName tblName, AlterGroupOption alterGroupOption)
    | alterMaterializedView(Identifier id, list[AutoRefresh] autorefreshOpt, list[RowLevelSecurity] rowLevelSecurityOpt)
    | alterRlsPolicy(Identifier id, Expr expr)
    | alterRole(Identifier id, list[str] withOpt, list[AlterRoleOption] alterRoleOptionList, list[ExternalId] externalIdOpt)
    | alterProcedure(TableName tblName, list[AlterProcedureOptions] alterProcOptsOpt, RenameOrChange renameOrChange, ProcedureToOption procedureOption)
    | alterSchema(Identifier id, AlterSchemaOptions alterSchemaOptions)
    | alterSystem(SystemLvlConf systemLevelConf, SysLvlConfVal sysLvlConfVal) 
    | alterUser(TableName tblName, list[UserId] userIdOpt, list[str] withOpt, list[UserOptions] userOptionsList)
    ;

data SystemLvlConf = dtCat() | mtSec();

data AlterGroupOption
    = addUser(list[Identifier] ids)
    | altdropUser(list[Identifier] ids)
    | altrenameGroup(Identifier id)
    ;
data RowLevelSecurity = rowLevelSecurity(OnOrOff onoff, list[ConjuctionType] cjtypeOpt, list[ForDtShares] fordtOpt);
data SetPubAcc  = setPubAcc(list[str] strConst, Boolean torf);
data SetIncNew = setInNew(list[str] strConstOpt, Boolean torf, Identifier id);
data SysLvlConfVal
    = trueVal2()
    | falseVal2()
    | onOff(OnOrOff  onOffLit)
    | booleanVal(Boolean boolLit)
    ;

data ConjuctionType = conjuctionType(AndOr andor);
data ForDtShares = forDtShares();
data RenameOrChange = renameAlter() | ownerAlter();

data ProcedureToOption
    = newOwner(Identifier id)
    | currentUser()
    | sessionUser()
    ;

data AlterSchemaOptions
    = renameSchema(Identifier id)
    | changeSchemaOwner(Identifier id)
    | quota(Quota quota)
    ;

data AlterRoleOption = renameToRole(Identifier id)| ownerToId(Identifier id);
data AlterDBOptions 
    = rnOpt(Identifier id)
    | chOwnOpt(Identifier id)
    | conOpt(ConnectionLimitOptions connlimitOpts)
    | colOpt(CaseOption caseopt)
    | isoOpt(SerializableSnapshot sersnap)
    | integrOpt(AllOrInerror allInner, list[IntegrationRefreshOptions] integrOpt)
    ;

data ConnectionLimitOptions
    = conOptInt(str integer)
    | conOptUnlimited()
    ;

data AllOrInerror
    = aall()
    | inError()
    ;

data IntegrationRefreshOptions
    = intRefInSchema(list[TableName] tablenameList)
    | intRefTable(list[TableName] tablenameList)
    ;

data AddOrRemoveObjects
    = addObject()
    | removeObject()
    ;


data AlterDataShareOptions
    = tableOpt(list[TableName] tablenameList)
    | schemaOpt(list[TableName] tablenameList)
    | funcOpt(list[Expr] expr)
    | allTbInSchema(list[TableName] tablenameList)
    | allFnInSchema(list[TableName] tablenameList)
    ;


data RemoveDefinition = removeDefinition();
data InSchema = inSchema(list[Identifier] ids);
data ForUser = forUser(list[Identifier] idList);

data GrantOrRevoke
    = grantPrivileges(GrantPrivileges grantPrivileges)
    | revokePrivileges(RevokePrivileges revokePrivileges)
    ;

data GrantPrivileges
    = grantOnTables(CommandListOrAll cmdlistorall, list[T1] t1)
    | grantOnFn(ExecuteOrAll exorall, list[T1] t1)
    | grantOnProced(ExecuteOrAll exorall, list[T1] t1)
    ;


data RevokePrivileges
    = revokeUserOnTable(list[GrantOptionFor] grantoptFor, CommandListOrAll cmdlistorall, list[Identifier] ids, list[Restrict] restrict)
    | revokeCategoryOnTable(CommandListOrAll cmdlistorall, list[GroupRoles] grouproles, list[Restrict] restrict)
    | revokeUserOnFunctions(list[GrantOptionFor] grantoptFor, ExecuteOrAll exorall, list[Identifier] ids, list[Restrict] restrict)
    | revokeCategoryOnFunctions(ExecuteOrAll exorall, list[GroupRoles] grouproles, list[Restrict] restrict)
    | revokeUserOnProcedures(list[GrantOptionFor] grantoptFor, ExecuteOrAll exorall, list[Identifier] ids, list[Restrict] restrict)
    | revokeCategoryOnPocedures(ExecuteOrAll exorall, list[GroupRoles] grouproles, list[Restrict] restrict)
    ;


data Restrict = restrictKey();

data GrantOptionFor = grantOptionFor();

data ExecuteOrAll
    = execute()
    | allPrivOnFn(AllPrivileges allPriv)
    ;

data CommandListOrAll
    = command(list[Command] cmdList)
    | allPrivOnTb(AllPrivileges allPriv)
    ;

data AllPrivileges = allPrivileges(list[str] strConst);

data T1
    = gUser(Identifier id, list[WithGrant] withGrantOpt)
    | groupRoles(GroupRoles grouproles)
    ;


data GroupRoles 
    = groupRole(Identifier id)
    | groupGroup(Identifier id)
    | groupPublic()
    ;

data WithGrant = withGrant();

data Privileges = privileges();

data Command
    = selectCmd()
    | insertCmd()
    | updateCmd()
    | deleteCmd()
    | dropCmd(DropStatement dstmnt)
    | referenceCmd()
    | truncateCmd()
    ;


data AlterProcedureOptions = altProcOptionParenthesis(list[AlterProcOptionArg] altargList);
data AlterProcOptionArg = alterProcOptionArg(list[Identifier] idOpt, list[ArgMode] argModeOpt, DataType datatype);

data Statement = dropStmt(DropStatement dropStmt);

data DropStatement 
    = dropFunction(list[IfExists] ifExists, Identifier id, BracketNameModeType2 bracketNMT2, list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt)
    | dropTable(list[IfExists] ifExists, TableName tblName, list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt)
    | dropStatement(
        DropOptions dropType
        , list[IfExists] ifExists1
        , list[TableName] tblNameList
        , list[DropExternalDatabase] dropExtDB
        , list[BracketNameModeType] bracketNMTOpt
        , list[IfExists] ifExists2
        , list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt
        , list[TableName] tblNameOpt)
    ;

data DropOptions
    = dDatabase()
    | dDatashare()
    | dExternalView()
    | dGroup()
    | dIdentityProvider()
    | dLibrary()
    | dMaskingPolicy()
    | dModel()
    | dMaterializedView()
    | dProcedure()
    | dRlsPolicy()
    | dRole()
    | dSchema()
    | dUser()
    | dView()
    ;

data BracketNameModeType2 = bracketNameModeType(list[NameModeType2] nameModeType2);
data DropExternalDatabase = dropExternalDatabase();
data NameModeType2 = nameModeType2(list[Identifier] idOpt, list[ArgMode] argModeOpt, DataType datatype);