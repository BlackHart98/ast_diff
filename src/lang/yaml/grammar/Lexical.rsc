module lang::yaml::grammar::Lexical

lexical Id = ([a-z A-Z] !<< [a-z A-Z +][a-z A-Z 0-9_\-]* !>> [a-z A-Z 0-9 _\-]) \ Keywords;
lexical Integer = [0-9] !<< [0-9]+ !>> [0-9];
lexical Unit =[0-9];
lexical String 
                = [\"] String_Char* [\"]
                > [\'] String_Char* [\']
                ;
lexical String_Char  = ![\\ \" \n] | "\\" [\\ \"];

layout Standard 
	= WhitespaceOrComment* !>> [\ \n\r\t] !>> "#"
	;

lexical WhitespaceOrComment 
  = whitespace: Whitespace
  | comment: Comment
  ; 

lexical Whitespace 
  =  [\ \n\r\t]
  ;

lexical Comment = @lineComment @category="Comment" ^"#" ![\n\r]* $; //!>> [\n];


lexical DatePart
	= [0-9] [0-9] [0-9] [0-9] "-" [0-1] [0-9] "-" [0-3] [0-9] 
	| [0-9] [0-9] [0-9] [0-9] [0-1] [0-9] [0-3] [0-9] 
  ;

lexical TimePartNoTZ
	= tests: [0-2] [0-9] ":" [0-5] [0-9] ":" [0-5] [0-9]  
	;
lexical TimeZonePart
	= [+ \-] [0-1] [0-9] ":" [0-5] [0-9] 
	| "Z" 
	| [+ \-] [0-1] [0-9] 
	| [+ \-] [0-1] [0-9] [0-5] [0-9] 
	;
lexical JustTime
	=  ntz:TimePartNoTZ 
	|  tz:TimePartNoTZ TimeZonePart 
	;
lexical Boolean = "true"| "false";

lexical FloatLiteral =  [\-]? [0-9]+ "." [0-9]* !>> [0-9] ;


keyword Keywords
         = "true"
         | "false"
         | "integer"
         | "string"
         | "boolean"
         | "date"
         | "time"
         ;

 
 