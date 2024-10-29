module lang::yaml::grammar::Layout


syntax WhitespaceOrComment 
  = whitespace: Whitespace
  | comment: Comment
  ; 

lexical Whitespace 
  =
  [\u0009 \u000C \u000D \u0020 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000]
  ;

lexical Comment = @lineComment @category="Comment" "#" ![\n\r]* $;
