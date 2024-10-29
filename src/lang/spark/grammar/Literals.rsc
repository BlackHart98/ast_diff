module lang::spark::grammar::Literals

extend lang::functionLang::grammar::Function;


syntax Literal
    = illegalNull: 'null'
    | Boolean
    ;
