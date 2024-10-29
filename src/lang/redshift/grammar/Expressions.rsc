module lang::redshift::grammar::Expressions



extend lang::redshift::grammar::Names;


syntax Expr
    = :uMin | uPlus: "+" Expr | absoluteVal: "@" Expr
    > :cast
    > left expo: Expr "^" Expr
    > left squareRoot: Expr "|/" expr
    > left cubeRoot: Expr "||/" Expr
    > :cct
    > :add
    > left (
        and2: Expr "&" Expr
        | or2: Expr "|" Expr
        | not2: Expr "#" Expr
    ) 
    > left (
        shiftleft: Expr "\<\<" Expr
        | shiftright: Expr "\>\>" Expr
    )
    > bitwiseNot: "~" Expr
    > :eq 
    > :neq2
    > left( 
        anyCond: Expr "=" 'ANY'"("Expr")"
        | someCond: Expr "=" 'SOME'"("Expr")"
        | isTrue: Expr "IS" "TRUE"
        | isFalse: Expr "IS" "FALSE"
        | isUnknown: Expr "IS" "UNKNOWN"
    )
    > :like
    > likeEsc: Expr 'LIKE' Expr EscapeChar | notlikeEsc: Expr 'NOT' 'LIKE' Expr EscapeChar
    > ilike: Expr 'ILIKE' Expr EscapeChar? | notilike: Expr 'NOT' 'ILIKE' Expr EscapeChar?
    > :notlike
    > :between
    > left notbetween: Expr 'NOT' 'BETWEEN' Expr!and!or 'AND' Expr!and!or
    > non-assoc (similar: Expr Not? 'SIMILAR' 'TO' Expr EscapeChar?)
    > left (posix: Expr "~" Expr | posixnot: Expr "!~" Expr)
    > :isNull
    > :or
    > left (inPredicate: Expr Not? 'IN' ArrayLiteral)
    | miscExpr: MiscExpr
    > :simpleCase
    ;


syntax EscapeChar = escapeChar: 'ESCAPE' Expr;


syntax MiscExpr
    = miscTablename: TableName"(""+"")"
    | defaultExp: 'DEFAULT'
    ; 



syntax ArrayLiteral = Array;
syntax Array = array: "(" {Expr!scalarSubquery ","}+ ")";
syntax PrimitiveType = integerType : 'INTEGER' | numericType: 'NUMERIC';
syntax SingleParameterSpec = singleParameterSpec: "(" REGULARIDENTIFIER ")";

