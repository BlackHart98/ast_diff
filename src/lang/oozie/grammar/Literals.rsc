module lang::oozie::grammar::Literals
extend lang::oozie::grammar::Layout;

lexical Identifier 
        = ([a-z A-Z] !<< [a-z A-Z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9]) \ Keywords
        ;

syntax Literal
    = Number
    | String 
    ;

syntax Number
    = integer: Int
    | long: Long
    | decimal: UNSIGNEDDECIMAL
    | scientificnum: ScientificNumber
    ;  

lexical ScientificNumber = [0-9]* "." [0-9]+ [eE] [0-9]* !>> [0-9];
lexical Long = @category="Constant"  [0-9] !<< [0-9]+ !>> [0-9] "L";

lexical UNSIGNEDDECIMAL     = ( [0-9]* "." [0-9]+ ) | ( [0-9]+ "." );


syntax String = string: StringConstant
    ;

lexical StringConstant 
    = @category="Constant"  [\"] StringCharacter* [\"]
    | @category="Constant"  [\'] SingleQuoteStringCharacter* [\']
    ; 

lexical StringCharacter
    = "\\" [\" \\ b f n r t] 
    | UnicodeEscape 
    | ![\" \\]
    | [\n][\ \t \u00A0 \u1680 \u2000-\u200A \u202F \u205F \u3000]* [\'] // margin 
    ;

lexical SingleQuoteStringCharacter
    = "\\" [\' \\ b f n r t] 
    | UnicodeEscape 
    | ![\' \\]
    | [\n][\ \t \u00A0 \u1680 \u2000-\u200A \u202F \u205F \u3000]* [\'] // margin 
    ; 

lexical UnicodeEscape
    = utf16: "\\" [u] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] 
    | utf32: "\\" [U] (("0" [0-9 A-F a-f]) | "10") [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] // 24 bits 
    | ascii: "\\" [a] [0-7] [0-9A-Fa-f]
    ;

lexical Int 
    = @category="Constant"  [0-9] !<< [0-9]+ !>> [0-9];

keyword Keywords
    = "and"
    | "or"
    | "not"
    | "eq"
    | "ne"
    | "lt"
    | "gt"
    | "le"
    | "ge"
    | "true"
    | "false"
    | "null"
    | "instanceof"
    | "empty"
    | "div"
    | "mod"
    ;