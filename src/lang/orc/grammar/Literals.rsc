module lang::orc::grammar::Literals

lexical EId 
        = ([a-z A-Z] !<< [A-Z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9]) \ Keywords
        ;

lexical Id 
        = ([a-z A-Z] !<< [a-z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9]) \ Keywords
        ;


keyword Keywords = 
    "shell"
    |  "ddl"
    |  "sqoop"
    |  "kill"
    |  "transform"
    |  "define" 
    |  "action" 
    |  "dataflow"
    |  "dag"
    |  "onError"
    |  "startTime"
    |  "frequency" 
    |  "timeZone" 
    |  "properties" 
    |  "module"
    |  "name"
    |  "file"
    |  "action"
    |  "configFile"
    |  "command"
    |  "message"
    |  "onSuccess"
    |  "onActionError"
    |  "view"
    |  "parallel"
;

lexical StringLiteral = [\"] StrChar* contents [\"]| [\'] SStrChar* contents [\'];

lexical StrChar
	= escaped: "\\" [\" \\ b f n r t] 
	| rest: ![\" \\]+ !>> ![\" \\]
	;

lexical SStrChar
	= escaped: "\\" [\' \\ b f n r t] 
	| rest: ![\' \\]+ !>> ![\' \\]
	;


syntax Strings = 
  string: StringLiteral
;

lexical UnicodeEscape
  = utf16: "\\" [u] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] 
  | utf32: "\\" [U] (("0" [0-9 A-F a-f]) | "10") [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] // 24 bits 
  | ascii: "\\" [a] [0-7] [0-9A-Fa-f]
;

lexical Int = @category="Constant"  [0-9] !<< [0-9]+ !>> [0-9];



