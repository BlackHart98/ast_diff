module lang::bigquery::prettyprint::DML

import List;
extend lang::bigquery::prettyprint::DDL;


public str toString(InsertWithQuery insWQ){
    switch(insWQ){
        case intoWithValue(list[Table] tableOpt
                    , TableName tableName
                    , list[IfNotExists] ifNotExistsOpt
                    , list[ColumnSpecificationForInsert] columnSpecOpt
                    , Value vl
                ):{
            return "INSERT INTO <intercalate("",[toString(tbo)|tbo<-tableOpt])> <toString(tableName)> <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <intercalate("",[toString(cso)|cso<-columnSpecOpt])> <toString(vl)>";
        }
        case noIntoOrOverwriteWithValue(
                    list[Table] tableOpt
                    , TableName tableName
                    , list[IfNotExists] ifNotExistsOpt
                    , list[ColumnSpecificationForInsert] columnSpecOpt
                    , Value vl
                ):{
            return "INSERT <intercalate("",[toString(tbo)|tbo<-tableOpt])> <toString(tableName)> <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <intercalate("",[toString(cso)|cso<-columnSpecOpt])> <toString(vl)>";
        }
        case noIntoOrOverwrite(
                    list[Table] tableOpt
                    , TableName tableName
                    , list[PartitionWithOptionValueClause] partWithOptValueClsOpt
                    , list[ColumnSpecificationForInsert] columnSpecOpt
                    , QueryOrWith qryOrWith
                ):{
            return "INSERT <intercalate("",[toString(tbo)|tbo<-tableOpt])> <toString(tableName)> <intercalate("",[toString(pwvc)|pwvc<-partWithOptValueClsOpt])> <intercalate("",[toString(cso)|cso<-columnSpecOpt])> <toString(qryOrWith)>";
        }
        default: throw "<insWQ> not seen ";
    }
}

public str toString(inputValue(list[BracketExp] bracketExps)) = "VALUES <intercalate(",", [toString(exp) | exp <- bracketExps])>";

public str toString(bracketExp(list[ExpOrDefault] expordef)) = "(<intercalate(",", [ toString(e) | e <- expordef])>)";

public str toString(ExpOrDefault id){
    switch(id){
        case exp(Expr exp):{
            return "<toString(exp)>";
        }
        case \default():{
            return "DEFAULT";
        }
        default: throw "<id> not seen ";
    }
}

public str toString(deleteStatement(list[str] fromLit, TableName tbl1, list[TableName] tbl2, WhereClause whrClause)) = "DELETE <intercalate("",[f|f<-fromLit])> <toString(tbl1)> <intercalate("",[toString(t2)|t2<-tbl2])> <toString(whrClause)>";

public str toString(mergeInto(TableName tblName, list[VarAssign] varAssignOpt1, Expr expr1, list[VarAssign] varAssignOpt2, Expr expr2, list[MergeWhen] mergeWhenCls))
        = "MERGE INTO <toString(tblName)> <intercalate("",[toString(vao)|vao<-varAssignOpt1])> USING <toString(expr1)> <intercalate("",[toString(vao)|vao<-varAssignOpt2])> ON <toString(expr2)> <intercalate("",[toString(mwc)|mwc<-mergeWhenCls])>";

public str toString(mergeNoInto(TableName tblName, list[VarAssign] varAssignOpt1, Expr expr1, list[VarAssign] varAssignOpt2, Expr expr2, list[MergeWhen] mergeWhenCls))
        = "MERGE <toString(tblName)> <intercalate("",[toString(vao)|vao<-varAssignOpt1])> USING <toString(expr1)> <intercalate("",[toString(vao)|vao<-varAssignOpt2])> ON <toString(expr2)> <intercalate("",[toString(mwc)|mwc<-mergeWhenCls])>";

public str toString(updateStatement(TableName tblName, list[VarAssign] varAssignOpt, SetClause setCls, list[FromClause] fromClauseOpt, list[JoinClause] joinClauseOpt, WhereClause whereCls))
        = "UPDATE <toString(tblName)> <intercalate("",[toString(vao)|vao<-varAssignOpt])> SET <toString(setCls)> <intercalate("",[toString(fco)|fco<-fromClauseOpt])> <intercalate("",[toString(jco)|jco<-joinClauseOpt])> <toString(whereCls)>";

public str toString(setClause(list[SetTo] setTo)) = "<intercalate(",", [toString(to) | to <- setTo])>";

public str toString(setTo(TableName tableName, ExpOrDefault expordef)) = "<toString(tableName)> = <toString(expordef)>";

public str toString(MergeWhen mergedwhn){
    switch(mergedwhn){
        case matchedClause(list[ByTargetOrSource] byTgtOrSrcOpt, list[AndBool] andBoolOpt, MergeClause mergeCls):{
            return "WHEN MATCHED <intercalate("",[toString(btos)|btos<-byTgtOrSrcOpt])> <intercalate("",[toString(abo)|abo<-andBoolOpt])> THEN <toString(mergeCls)>";
        }
        case notMatchedClause(list[ByTargetOrSource] byTgtOrSrcOpt, list[AndBool] andBoolOpt, MergeClause mergeCls):{
            return "WHEN NOT MATCHED <intercalate("",[toString(btos)|btos<-byTgtOrSrcOpt])> <intercalate("",[toString(abo)|abo<-andBoolOpt])> THEN <toString(mergeCls)>";
        }
        default: throw "<mergedwhn> not seen ";
    }
}

public str toString(ByTargetOrSource id){
    switch(id){
        case byTarget():{
            return "BY TARGET";
        }
        case bySource():{
            return "BY SOURCE";
        }
        default: throw "<id> not seen ";
    }
}

public str toString(andBool(Expr exp)) = "AND <toString(exp)>";

public str toString(MergeClause id){
    switch(id){
        case mergeWithUpdate(MergeUpdate mergeUpdate):{
            return "<toString(mergeUpdate)>";
        }
        case mergeWithDelete(MergeDelete mergeDelete):{
            return "<toString(mergeDelete)>";
        }
        case mergeWithInsert(MergeInsert mergeInsert):{
            return "<toString(mergeInsert)>";
        }
        default: throw "<id> not seen ";
    }
}

public str toString(mergeUpdate(SetClause setClause)) = "UPDATE SET <toString(setClause)>";
public str toString(mergeDelete()) = "DELETE";
public str toString(mergeInsert(list[OptionalColumns] optionalColumns, MergeInput mergeInput)) = "INSERT <intercalate("",[toString(oc)|oc<-optionalColumns])> <toString(mergeInput)>";

public str toString(optionalColumns(list[Identifier] ids)) = "(<intercalate(",",[toString(i)|i<-ids])>)";

public str toString(MergeInput id){
    switch(id){
        case mergeValue(list[BracketExp] bexp):{
            return "VALUES <intercalate(",", [toString(exp) | exp <- bexp])>";
        }
        case mergeRow():{
            return "ROW";
        }
        default: throw "<id> not seen ";
    }
}

//procedural 


public str toString(proceduralStatement(Procedural proceduralStatement)) = "<toString(proceduralStatement)>";

public str toString(createProcedure(
        list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsOpt
        , TableName tblName, list[ProcedureArgument] procedureArgument
        , list[SchemaOptions] schemaOpts, BeginEnd beginEnd
        ))
        = "CREATE <intercalate("", [toString(orplc)|orplc<-orReplaceOpt])>PROCEDURE <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> 
                (<intercalate(",",[toString(pa)|pa<-procedureArgument])>) <intercalate("",[toString(scmo)|scmo<-schemaOpts])> <toString(beginEnd)>";
    
public str toString(createStoredProcedure(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsOpt, TableName tblName,
        list[ProcedureArgument] procedureArgument, WithConnection withConnection, list[SchemaOptions] schemaOpts, list[LangAsExp] langAsExpOpt))
        
        = "CREATE <intercalate("", [toString(orplc)|orplc<-orReplaceOpt])> PROCEDURE <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> 
                (<intercalate(",",[toString(pa)|pa<-procedureArgument])>) <toString(withConnection)> <intercalate("",[toString(scmo)|scmo<-schemaOpts])> <intercalate("",[toString(lae)|lae<-langAsExpOpt])>";

public str toString(procedureArg(list[InOut] inOut, NameType nameType)) = "<intercalate("", [toString(iout)|iout<-inOut])> <toString(nameType)>";

public str toString(InOut iout){
    switch(iout){
        case \in():{return "IN";}
        case out():{return "OUT";}
        case inout():{return "INOUT";}
        default: throw "<iout> not seen ";
    }
}

public str toString(langAsExp(Identifier id, Expr expr)) = "LANGUAGE <toString(id)> AS <toString(expr)>";

public str toString(proceduralCommand(ProceduralCommands proceduralCommand)) = "<toString(proceduralCommand)>";

public str toString(ProceduralCommands procCommand){
    switch(procCommand){
        case declareCommand(DeclareStatement declareCommand):{
            return "<toString(declareCommand)>";
        }
        case setCommand(SetStatement setCommand):{
            return "<toString(setCommand)>";
        }
        case executeCommand(ExecuteImmediate executeCommand):{
            return "<toString(executeCommand)>";
        }
        case beginEndCommand(BeginEnd beginEndCommand):{
            return "<toString(beginEndCommand)>";
        }
        case beginExecEndCommand(BeginExceptionEnd beginExecEndCommand):{
            return "<toString(beginExecEndCommand)>";
        }
        case caseCommand(Case caseCommand):{
            return "<toString(caseCommand)>";
        }
        case ifCommand(If ifCommand):{
            return "<toString(ifCommand)>";
        }
        case labelBeginCommand(LabelBegin labelBeginCommand):{
            return "<toString(labelBeginCommand)>";
        }
        case labelBeginExceptionCommand(LabelBeginException labelBeginExceptionCommand):{
            return "<toString(labelBeginExceptionCommand)>";
        }
        case labelForCommand(LabelFor labelForCommand):{
            return "<toString(labelForCommand)>";
        }
        case labelWhileCommand(LabelWhile labelWhileCommand):{
            return "<toString(labelWhileCommand)>";
        }
        case labelRepeatCommand(LabelRepeat labelRepeatCommand):{
            return "<toString(labelRepeatCommand)>";
        }
        case labelLoopCommand(LabelLoop labelLoopcmd):{
            return "<toString(labelLoopcmd)>";
        }
        case loopCommand(Loop loopcmd):{
            return "<toString(loopcmd)>";
        }
        case repeatCommand(Repeat repeatCommand):{
            return "<toString(repeatCommand)>";
        }
        case whileCommand(While whileCommand):{
            return "<toString(whileCommand)>";
        }
        case brkOrConCommand(BreakOrContinue brkOrConCommand):{
            return "<toString(brkOrConCommand)>";
        }
        case forInCommand(ForIn forInCommand):{
            return "<toString(forInCommand)>";
        }
        case transactionCommand(Transaction transactionCommand):{
            return "<toString(transactionCommand)>";
        }
        case raiseCommand(Raise raiseCommand):{
            return "<toString(raiseCommand)>";
        }
        case returnCommand(Return returnCommand):{
            return "<toString(returnCommand)>";
        }
        case callCommand(Call callCommand):{
            return "<toString(callCommand)>";
        }
        default: throw "<procCommand> not seen ";
    }
}

public str toString(declare(list[TableName] tblNameOpt, list[DataType] dataTypeOpt, list[DefaultExp] defaultExprOpt))
        = "DECLARE <intercalate(",",[toString(tid)|tid<-tblNameOpt])> <intercalate("",[toString(dt)|dt<-dataTypeOpt])> <intercalate("",[toString(dexp)|dexp<-defaultExprOpt])>";

public str toString(defaultExp(Expr expr)) = "DEFAULT <toString(expr)>";

public str toString(SetStatement setstmt){
    switch(setstmt){
        case setStatement(Expr exp1, Expr exp2):{
            return "SET <toString(exp1)> = <toString(exp2)>";
        }
        case setWithBrackets(list[TableName] tableNames, list[Expr] exps):{
            return "SET (<intercalate(",",[toString(tid)|tid<-tableNames])>) = (<intercalate(",",[toString(e)|e<-exps])>)";
        }
        default: throw "<setstmt> not seen ";
    }
}

public str toString(executeImmediate(Expr sql_exp, list[IntoVar] intovar, list[UsingId] usingid)) = "EXECUTE IMMEDIATE <toString(sql_exp)> <intercalate("",[toString(iv)|iv<-intovar])> <intercalate("",[toString(uId)|uId<-usingid])>";

public str toString(intoVar(list[Expr] exps)) = "INTO <intercalate(",",[toString(e)|e<-exps])>";

public str toString(usingId(list[ExpAsAliasOpt] expasaliasopt)) = "USING <intercalate(",",[toString(e)|e<-expasaliasopt])>";

public str toString(expasaliasopt(Expr exp, list[VarAssign] asAlias)) = "<toString(exp)> <intercalate("",[toString(aa)|aa<-asAlias])>";

public str toString(beginEnd(list[StatementWithTerminator] stmtWithTerm)) = "BEGIN <intercalate(" ",[toString(stmt)|stmt<-stmtWithTerm])> END";

public str toString(beginExceptionEnd(list[StatementWithTerminator] sqlstmt1, list[StatementWithTerminator] sqlstmt2)) = "BEGIN <intercalate(" ",[toString(stmt)|stmt<-sqlstmt1])> EXCEPTION WHEN ERROR THEN <intercalate(" ",[toString(stmt)|stmt<-sqlstmt2])> END";

public str toString(\case(list[Expr] expOpt, list[When] whenList)) = "CASE <intercalate("",[toString(e)|e<-expOpt])> <intercalate("",[toString(wl)|wl<-whenList])> END CASE";

public str toString(when(Expr bool_exp, list[StatementWithTerminator] sqlstmt, list[Else] elseList)) = "WHEN <toString(bool_exp)> THEN <intercalate(" ",[toString(stmt)|stmt<-sqlstmt])> <intercalate("",[toString(el)|el<-elseList])>";

public str toString(\if(Expr exp, list[StatementWithTerminator] sqlstmt, list[ElseIf] elsIF, list[Else] elseList)) = "IF <toString(exp)> THEN <intercalate(" ",[toString(stmt)|stmt<-sqlstmt])> <intercalate(" ",[toString(eif)|eif<-elsIF])> <intercalate("",[toString(el)|el<-elseList])> END IF";

public str toString(elseIf(Expr exp, list[StatementWithTerminator] sqlstmt)) = "ELSEIF <toString(exp)> THEN <intercalate(" ",[toString(stmt)|stmt<-sqlstmt])>";

public str toString(\else(list[StatementWithTerminator] sqlstmt)) = "ELSE <intercalate(" ",[toString(stmt)|stmt<-sqlstmt])>";

public str toString(loop(list[StatementWithTerminator] sqlstmt)) = "LOOP <intercalate(" ",[toString(stmt)|stmt<-sqlstmt])> END LOOP";

public str toString(repeat(list[StatementWithTerminator] sqlstmt, Expr exp)) = "REPEAT <intercalate(" ",[toString(stmt)|stmt<-sqlstmt])> UNTIL <toString(exp)> END REPEAT";

public str toString(\while(Expr exp, list[StatementWithTerminator] sqlstmt)) = "WHILE <toString(exp)> DO <intercalate(" ",[toString(stmt)|stmt<-sqlstmt])> END WHILE";

public str toString(BreakOrContinue brkContinue){
    switch(brkContinue){
        case breakStatement(Break breakStatement):{
            return "<toString(breakStatement)>";
        }
        case continueStatement(Continue continueStatement):{
            return "<toString(continueStatement)>";
        }
        default: throw "<brkContinue> not seen ";
    }
}

public str toString(Break brk){
    switch(brk){
        case \break(list[Identifier] ids):{
            return "BREAK <intercalate("",[toString(i)|i<-ids])>";
        }
        case leave(list[Identifier] ids):{
            return "LEAVE <intercalate("",[toString(i)|i<-ids])>";
        }
        default: throw "<brk> not seen ";
    }
}

public str toString(Continue contn){
    switch(contn){
        case \continue(list[Identifier] ids):{
            return "CONTINUE <intercalate("",[toString(i)|i<-ids])>";
        }
        case iterate(list[Identifier] ids):{
            return "ITERATE <intercalate("",[toString(i)|i<-ids])>";
        }
        default: throw "<contn> not seen ";
    }
}

public str toString(forIn(Identifier id, Expr exp, list[StatementWithTerminator] sqlstmt)) 
        = "FOR <toString(id)> IN (<toString(exp)>) DO <intercalate(" ",[toString(stmt)|stmt<-sqlstmt])> END FOR";

public str toString(labelBegin(Identifier id, BeginEnd beginEnd, list[TableName] tblNameOpt))
        = "<toString(id)>:<toString(beginEnd)> <intercalate("",[toString(tn)|tn<-tblNameOpt])>";

public str toString(labelBeginException(Identifier id, BeginExceptionEnd beginExecEndCommand, list[TableName] tblNameOpt))
        = "<toString(id)>:<toString(beginExecEndCommand)> <intercalate("",[toString(tn)|tn<-tblNameOpt])>";

public str toString(labelLoop(Identifier id, Loop loop, list[TableName] tblNameOpt))
        = "<toString(id)>:<toString(loop)> <intercalate("",[toString(tn)|tn<-tblNameOpt])>";

public str toString(labelWhile(Identifier id, While whl, list[TableName] tblNameOpt))
        = "<toString(id)>:<toString(whl)> <intercalate("",[toString(tn)|tn<-tblNameOpt])>";

public str toString(labelFor(Identifier id, ForIn forin, list[TableName] tblNameOpt))
        = "<toString(id)>:<toString(forin)> <intercalate("",[toString(tn)|tn<-tblNameOpt])>";

public str toString(labelRepeat(Identifier id,Repeat repeat, list[TableName] tblNameOpt))
        = "<toString(id)>:<toString(repeat)> <intercalate("",[toString(tn)|tn<-tblNameOpt])>";

public str toString(blockOrloop(Expr exp)) = "<toString(exp)>";

public str toString(transaction(TransactionOptions topts, list[str] strConst))
        = "<toString(topts)> <intercalate("",[t|t<-strConst])>";

public str toString(TransactionOptions transctOpt){
    switch(transctOpt){
        case beginTxn():{
            return "BEGIN";
        }
        case commitTxn():{
            return "COMMIT";
        }
        case rollbackTxn():{
            return "ROLLBACK";
        }
        default: throw "<transctOpt> not seen ";
    }
}

public str toString(raise(Expr exp)) = "RAISE USING MESSAGE = <toString(exp)>";

public str toString(\return()) = "RETURN";

public str toString(call(Expr exp, list[Expr] exps)) = "CALL <toString(exp)> (<intercalate(",",[toString(e)|e<-exps])>)";