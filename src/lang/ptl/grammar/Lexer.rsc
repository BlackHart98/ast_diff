module lang::ptl::grammar::Lexer

extend lang::ptl::grammar::Layout;

lexical EntityId  = ([A-Z]!<< [A-Z][A-Za-z0-9 _]* !>> [a-z A-Z 0-9]) \ Keywords;

lexical Id 
    = ([a-z A-Z] !<< [a-z A-Z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9]) \ Keywords
    | [`] ![`]* [`]
    ;

lexical BooleanLiteral 
   = "true" | "false" 
;

lexical Captial = [A-Z];
lexical NilLiteral = "nil";

lexical CharacterLiteral
    = ![\']
    | "\'\'"
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
    
syntax IntegerLiteral
	= /*prefer()*/ decimalIntegerLiteral: DecimalIntegerLiteral decimal 
	| /*prefer()*/ hexIntegerLiteral: HexIntegerLiteral hex 
	| /*prefer()*/ octalIntegerLiteral: OctalIntegerLiteral octal ;

lexical DecimalIntegerLiteral
	= "0" !>> [0-9 A-Z _ a-z] 
	| [1-9] [0-9]* !>> [0-9 A-Z _ a-z] ;

lexical OctalIntegerLiteral
	= [0] [0-7]+ !>> [0-9 A-Z _ a-z] ;

lexical HexIntegerLiteral
	= [0] [X x] [0-9 A-F a-f]+ !>> [0-9 A-Z _ a-z] ;

lexical FloatLiteral =  [\-] [0-9]+ "." [0-9]* !>> [0-9] ;

lexical RegExpLiteral
	= "/" RegExp* "/" RegExpModifier ;

lexical RegExpModifier
	= [d i m s]* ;

lexical RegExp
	= ![/ \< \> \\] 
	| "\<" Name "\>" 
	| [\\] [/ \< \> \\] 
	| "\<" Name ":" NamedRegExp* "\>" 
	| Backslash 
	;

lexical Backslash
	= [\\] !>> [/ \< \> \\] ;

lexical NamedRegExp
	= "\<" Name "\>" 
	| [\\] [/ \< \> \\] 
	| NamedBackslash 
	| ![/ \< \> \\] ;

lexical Name
    // Names are surrounded by non-alphabetical characters, i.e. we want longest match.
	=  ([A-Z a-z _] !<< [A-Z _ a-z] [0-9 A-Z _ a-z]* !>> [0-9 A-Z _ a-z]) \ Keywords 
	| [\\] [A-Z _ a-z] [\- 0-9 A-Z _ a-z]* !>> [\- 0-9 A-Z _ a-z] 
    | {QID "/"}+
	;

lexical VID = ([a-z A-Z] !<< [a-z A-Z] [a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9])\ Keywords;

lexical AID = ([a-z A-Z] [a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9]) \ Keywords;

lexical OID = ([a-z A-Z] !<< [a-z A-Z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9])\ Keywords;

lexical QID = ([a-z A-Z /] !<< [a-z A-Z /] [a-z A-Z 0-9 _ . /]* !>> [a-z A-Z 0-9])\ Keywords;

lexical TID = [A-Z] [a-z A-Z 0-9 _]* \ Keywords;

lexical NamedBackslash
	= [\\] !>> [\< \> \\] ;

syntax DateTime
   = date: JustDate date
   | time: JustTime time
   | full: DateAndTime dateTime ;

lexical JustDate
	= "$" DatePart "$";
	
lexical DatePart = Year y "-" Month m "-" Day d;
	
lexical Year = [0-9] [0-9] [0-9] [0-9];
lexical Month = [0-1] [0-9];
lexical Day = [0-3] [0-9];
	
lexical DateAndTime = "$" DatePart "T" TimePart ZoneOffset? "$";

lexical ZoneOffset 
	= [+ \-] Hour h ":" Minute m
	| "Z" 
	;

lexical TimePart = Hour h ":" Minute m ":" Second s Millisecond? ms;
lexical Hour = [0-2] [0-9];
lexical Minute = [0-5] [0-9];
lexical Second = [0-5] [0-9];
lexical Millisecond = [.] [0-9] ([0-9] [0-9]?)?;

syntax DateTimeLiteral
	= /*prefer()*/ dateLiteral: JustDate date 
	| /*prefer()*/ timeLiteral: JustTime time 
	| /*prefer()*/ dateAndTimeLiteral: DateAndTime dateAndTime ;


 keyword Keywords 
     =  "like"
     | "Char"
     | "between"
     | "not"
     | "and"
     | "in"
     | "if"
     | "not like"
     | "null"
     | "Null"
     | "Nil"
     | "then"
     | "nil"
     | "Bool" 
     | "Str" 
     | "SmallInt"
	 | "Object"
     | "Float" 
     | "BigInt"
     | "Set" 
     | "Map" 
     | "inner"
     | "List" 
     | "Date" 
     | "Datetime" 
     | "Timestamp" 
     | "Int"
     | "SmallInt"
     | "BigInt"
     | "default"
	 | "true"
	 | "false"
     | "entity"
     | "end entity"
     | "enum"
     | "end enum"
     | "case" 
	 | "struct"
	 | "required"
	 | "facets"
	 | "or"
	 | "and"
	 | "set"
	 | "view"
	 | "end view"
     | "views"
    | "variables"
    | "on" 
    | "in" 
    | "filter"
    | "distinct" 
    | "include nulls"
    | "for"
    | "unpivot"
    | "union all" 
    | "Varchar"
    | "union" 
    | "intersect"
    | "flatmap" 
    | "attributes" 
    | "except" 
    | "with"
    | "transform" 
    | "add" 
    | "drop" 
    | "rename" 
    | "partition" 
    | "purge" 
    | "Directory" 
    | "@addFile" 
    | "as" 
    | "group by" 
    | "join" 
    | "left" 
    | "full" 
    | "cross" 
    | "semi" 
    | "end transform"
    | "transform"
    | "subview"
    // Aggregate Function

    // Analytic Function Clause
    | "over"
    | "by"
    | "cast"
    | "end"
    | "Byte"
    | "Interval"
;


lexical JustTime
	= "$T" TimePartNoTZ !>> [+\-] "$"
	| "$T" TimePartNoTZ TimeZonePart "$"
	;


lexical TimePartNoTZ
	= [0-2] [0-9] [0-5] [0-9] [0-5] [0-9] ([, .] [0-9] ([0-9] [0-9]?)?)? 
	| [0-2] [0-9] ":" [0-5] [0-9] ":" [0-5] [0-9] ([, .] [0-9] ([0-9] [0-9]?)?)? 
	;

lexical TimeZonePart
	= [+ \-] [0-1] [0-9] ":" [0-5] [0-9] 
	| "Z" 
	| [+ \-] [0-1] [0-9] 
	| [+ \-] [0-1] [0-9] [0-5] [0-9] 
	;
