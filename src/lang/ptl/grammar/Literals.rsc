module lang::ptl::grammar::Literals

extend lang::ptl::grammar::Lexer;


syntax Literal
	= @category="Constant" boolean: BooleanLiteral booleanLiteral 
	| @category="Constant" dateTime: DateTimeLiteral dateTimeLiteral 
	| @category="Constant" regExp: RegExpLiteral regExpLiteral 
	| @category="Constant" nullLiteral: "null" 
	| nilLiteral: NilLiteral
;

