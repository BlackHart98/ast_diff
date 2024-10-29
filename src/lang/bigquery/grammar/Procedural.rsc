module lang::bigquery::grammar::Procedural

extend lang::bigquery::grammar::DML;

syntax StatementWithTerminator
  = statementWithTerminator: Statement!createTable
   Terminator*
  ;


syntax Terminator
  = terminator: ";"
  ;


syntax Statement
  = proceduralStatement: Procedural
  ;

syntax Statement 
    = createProcedure: 'CREATE' OrReplace? 'PROCEDURE' IfNotExists?
        TableName "("{ProcedureArgument ","}*")"
        SchemaOptions?
        BeginEnd
    | createStoredProcedure: 'CREATE' OrReplace? 'PROCEDURE' IfNotExists?
        TableName "("{ProcedureArgument ","}*")"
        WithConnection
        SchemaOptions?
        LangAsExp?
    ;

syntax InOut
    = \in: 'IN'
    | out: 'OUT'
    | inout: 'INOUT'
    ;

syntax ProcedureArgument = procedureArg: InOut? NameType;

syntax LangAsExp = langAsExp: 'LANGUAGE' Identifier 'AS' Expr;


syntax BeginEnd = beginEnd: 'BEGIN' StatementWithTerminator+  'END';

syntax Procedural = proceduralCommand: ProceduralCommands;

syntax ProceduralCommands
  = declareCommand: DeclareStatement
  | setCommand: SetStatement
  | executeCommand: ExecuteImmediate
  | beginEndCommand: BeginEnd
  | beginExecEndCommand: BeginExceptionEnd
  | caseCommand: Case
  | ifCommand: If
  | labelBeginCommand: LabelBegin
  | labelBeginExceptionCommand: LabelBeginException
  | labelForCommand: LabelFor
  | labelWhileCommand: LabelWhile
  | labelRepeatCommand: LabelRepeat
  | labelLoopCommand: LabelLoop
  | loopCommand: Loop
  | repeatCommand: Repeat
  | whileCommand: While
  | brkOrConCommand: BreakOrContinue
  | forInCommand: ForIn
  | transactionCommand: Transaction
  | raiseCommand: Raise
  | returnCommand: Return
  | callCommand: Call
  ;


syntax DeclareStatement =declare: 'DECLARE' {TableName ","}+ DataType? DefaultExp?;

syntax DefaultExp = defaultExp: 'DEFAULT' Expr;



syntax SetStatement
  = setStatement: 'SET' Expr "=" Expr
  | setWithBrackets: 'SET' "(" {TableName ","}+ ")" "=" "(" {Expr ","}+ ")" 
  ;


syntax ExecuteImmediate 
  = executeImmediate: 'EXECUTE' 'IMMEDIATE' Expr sql_exp IntoVar? UsingId?
  ;

syntax IntoVar = intoVar: 'INTO' {Expr ","}+;

syntax UsingId = usingId: 'USING' {ExpAsAliasOpt ","}+;

syntax ExpAsAliasOpt = expasaliasopt: Expr VarAssign?;


//TODO: make Expr to be queries
syntax BeginEnd = beginEnd: 'BEGIN' StatementWithTerminator+  'END';

syntax BeginExceptionEnd = beginExceptionEnd: 'BEGIN' StatementWithTerminator+ 'EXCEPTION' 'WHEN' 'ERROR' 'THEN' StatementWithTerminator+ 'END';

syntax Case =\case: 'CASE' Expr? When+ 'END' 'CASE';

syntax When =when: 'WHEN' Expr bool_exp 'THEN' StatementWithTerminator+ Else?;


syntax If = \if: 'IF' Expr 'THEN' StatementWithTerminator* ElseIf* Else? 'END' 'IF';

syntax ElseIf = elseIf: 'ELSEIF' Expr 'THEN' StatementWithTerminator+ ;

syntax Else = \else:'ELSE' StatementWithTerminator+;

syntax Loop = loop:  'LOOP' StatementWithTerminator+ 'END' 'LOOP';

syntax Repeat = repeat:  'REPEAT' StatementWithTerminator+ 'UNTIL' Expr 'END' 'REPEAT';

syntax While = \while:  'WHILE' Expr 'DO' StatementWithTerminator+ 'END' 'WHILE';

syntax BreakOrContinue 
  = breakStatement: Break
  | continueStatement: Continue
  
  ; 

syntax Break = \break: 'BREAK' Identifier?
              | leave: 'LEAVE' Identifier?;

syntax Continue = \continue: 'CONTINUE' Identifier?
                | iterate: 'ITERATE' Identifier?;

syntax ForIn = forIn: 'FOR' Identifier 'IN' "(" Expr ")" 'DO' StatementWithTerminator+ 'END' 'FOR';



syntax LabelBegin =labelBegin: Identifier":" BeginEnd TableName?;
syntax LabelBeginException =labelBeginException: Identifier":" BeginExceptionEnd TableName?;
syntax LabelLoop =labelLoop: Identifier":" Loop TableName?;
syntax LabelWhile =labelWhile: Identifier":" While TableName?;
syntax LabelFor =labelFor: Identifier":" ForIn TableName?;
syntax LabelRepeat = labelRepeat: Identifier":" Repeat TableName?;

syntax BlockOrLoopStatement
  = blockOrloop: Expr;

syntax Transaction = transaction: TransactionOptions 'TRANSACTION'?;

syntax TransactionOptions 
  = beginTxn: 'BEGIN'
  | commitTxn: 'COMMIT'
  | rollbackTxn: 'ROLLBACK'
  ;

syntax Raise = raise: 'RAISE' 'USING' 'MESSAGE' "=" Expr;

syntax Return = \return: 'RETURN';

syntax Call = call: 'CALL' Expr "(" {Expr ","}* ")";

