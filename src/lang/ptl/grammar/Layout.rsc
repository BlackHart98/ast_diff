module lang::ptl::grammar::Layout


lexical COMMENT_LIT =
  @category="Comment" "/**/" 
  | @category="Comment" "//" EOLCommentChars !>> ![\n \a0D] LineTerminator 
  | @category="Comment" "/*" !>> [*] CommentPart* "*/" 
  | @category="Comment" "/**" !>> [/] CommentPart* "*/" 
  ;

lexical EOLCommentChars =
  ![\n \a0D]* 
  ;

lexical CommentPart =
  UnicodeEscape 
  | BlockCommentChars !>> ![* \\] 
  | EscChar !>> [\\ u] 
  | Asterisk !>> [/] 
  | EscEscChar 
  ;

lexical LineTerminator =
  [\n] 
  | EndOfFile !>> ![] 
  | [\a0D] [\n] 
  | CarriageReturn !>> [\n] 
  ;

lexical UnicodeEscape =
   unicodeEscape: "\\" [u] [u] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] 
  ;

lexical BlockCommentChars =
  ![* \\]+ 
  ;

lexical EscChar =
  "\\" 
  ;

lexical Asterisk =
  "*" 
  ;

lexical EscEscChar =
  "\\\\" 
  ;

lexical EndOfFile =
  
  ;

lexical CarriageReturn =
  [\a0D] 
  ;