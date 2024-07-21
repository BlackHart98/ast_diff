module Main

import IO;
import List;
import ASTDiff;
import ParseTree;



start syntax SimpleExprList = simpleExprList: SimpleExpr+;

syntax SimpleExpr 
    = left add: SimpleExpr "+" SimpleExpr
    > left sub: SimpleExpr "-" SimpleExpr
    ;

syntax SimpleExpr = number: INT;

lexical INT = [0-9] !<< [0-9]+ !>> [0-9];

layout Standard 
	= WhitespaceOrComment* !>> [\u0009-\u000D \u0020 \u0085 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000] !>> "--"
	;

lexical COMMENT_LIT 
	= @category="COMMENT_LIT" "--" ![\n]* $
	;

syntax WhitespaceOrComment 
	= whitespace: Whitespace | comment_lit: COMMENT_LIT
	;

lexical Whitespace
	= [\u0009-\u000D \u0020 \u0085 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000]
	;


// ADT
data SimpleExprList = simpleExprList(list[SimpleExpr] exprList);
data SimpleExpr = \add(SimpleExpr left, SimpleExpr right);
data SimpleExpr = sub(SimpleExpr left, SimpleExpr right);
data SimpleExpr = number(str intlit);



int main(int testArgument=0) {

    iprintln(diff(#start[SimpleExprList], #SimpleExprList, "2 + 4 + 2", "4 + 2"));
    return testArgument;
}
