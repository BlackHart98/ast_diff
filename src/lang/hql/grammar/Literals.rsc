module lang::hql::grammar::Literals

extend lang::functionLang::grammar::Function;


syntax Literal
  = illegalNull: 'null'
  | Boolean
  ;
