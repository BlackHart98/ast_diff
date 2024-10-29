module lang::redshift::grammar::Names

extend lang::redshift::grammar::Literals;



syntax Identifier = unquotedIdentifer: UNQUOTEDIDENTIFIER;

lexical UNQUOTEDIDENTIFIER =  ([a-z A-Z _] !<< "_" [a-z A-Z 0-9 @ _ \-]* !>> [a-z A-Z 0-9 _]) \ Keywords;

lexical FUNCTIONNAME = REGULARIDENTIFIER \ IMPLEMENTED_FUNCTIONNAME;

keyword IMPLEMENTED_FUNCTIONNAME 
    = 'SUM' 
    | 'AVG'
    | 'COUNT'
    | 'MAX'
    | 'ANY_VALUE'
    | 'ARRAY_AGG'
    ;


keyword Keywords 
    = 'FULL'
    | 'DISABLE'
    | 'ROLE'
    | 'GROUP'
    | 'PUBLIC'
    | 'DEFAULT'
    | 'ALL'
    | 'LIKE'
    ; 