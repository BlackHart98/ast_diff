module lang::snowflake::grammar::Literals



lexical HexString = [A-Za-z0-9|.] [A-Za-z0-9+\-|._]*;

lexical Uri = HexString DivideHexString*
            | HexString DivideHexString* "/"
            ;

lexical WindowsPath = [A-Z] ":" BackSlashHexString*
                    | [A-Z] ":" BackSlashHexString* "\\"
                    ;

lexical BackSlashHexString = backSlashHexString: "\\" HexString;

lexical DivideHexString = divideHexString: "/" HexString;



lexical DollarStringCharacter = ![$]  | "\\$" | "$" ![$];

lexical StringConstant = @category="Constant" "$$" DollarStringCharacter* "$$";

lexical COMMENT_LIT 
	= @category="Comment" "//" ![\n]* $
    | @category="Comment" "--" ![\n]* $
	;
