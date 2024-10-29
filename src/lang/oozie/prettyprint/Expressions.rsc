module lang::oozie::prettyprint::Expressions

extend lang::oozie::ast::Expressions;
import List;
extend lang::oozie::grammar::Oozie;

public str toString(ooziExps(list[OozieExpr] oexps)) = "<intercalate(" ",[toString(exp)|exp<-oexps])>";

public str toString(immediateEval(Expr exp)) = "${<toString(exp)>}";

public str toString(deferredEval(Expr exp)) = "#{<toString(exp)>}";

public str toString(variable(list[str] ids)) = "<intercalate(".",[id|id<-ids])>";

public str toString(integer(str \int)) = \int;

public str toString(long(str \int)) = \int;

public str toString(decimal(str decim)) = decim;

public str toString(scientificnum(str scinum)) = scinum;

public str toString(string(str strConst)) = strConst;

public str toString(functionlist(list[str] idOpt, list[Expr] expOpt)) = "<intercalate("",[id|id<-idOpt])>[<intercalate("",[toString(exp)|exp<-expOpt])>]";

public str toString(\bracket(Expr exp)) = "(<toString(exp)>)";

public str toString(uMin(Expr expr)) = "- <toString(expr)>";

public str toString(not(Expr expr)) = "! <toString(expr)>";

public str toString(logicalNot(Expr expr)) = "not <toString(expr)>";

public str toString(empty(Expr exp)) = "empty <toString(exp)>";

public str toString(mul(Expr expr1, Expr expr2)) = "(<toString(expr1)> * <toString(expr2)>)";
        
public str toString(div(Expr expr1, Expr expr2)) = "(<toString(expr1)> / <toString(expr2)>)";

public str toString(division(Expr expr1, Expr expr2)) = "(<toString(expr1)> div <toString(expr2)>)";

public str toString(modulus(Expr expr1, Expr expr2)) = "(<toString(expr1)> % <toString(expr2)>)";

public str toString(modulo(Expr expr1, Expr expr2)) = "(<toString(expr1)> mod <toString(expr2)>)";

public str toString(add(Expr expr1, Expr expr2)) = "(<toString(expr1)> + <toString(expr2)>)";

public str toString(sub(Expr expr1, Expr expr2)) = "(<toString(expr1)> - <toString(expr2)>)";

public str toString(concat(Expr expr1, Expr expr2)) = "(<toString(expr1)> += <toString(expr2)>)";

public str toString(lt(Expr expr1, Expr expr2)) = "(<toString(expr1)> \< <toString(expr2)>)";

public str toString(gt(Expr expr1, Expr expr2)) = "(<toString(expr1)> \> <toString(expr2)>)";

public str toString(lte(Expr expr1, Expr expr2)) = "(<toString(expr1)> \<= <toString(expr2)>)";

public str toString(gte(Expr expr1, Expr expr2)) = "(<toString(expr1)> \>= <toString(expr2)>)";

public str toString(lessThan(Expr expr1, Expr expr2)) = "(<toString(expr1)> lt <toString(expr2)>)";

public str toString(greaterThan(Expr expr1, Expr expr2)) = "(<toString(expr1)> gt <toString(expr2)>)";

public str toString(lessThanOrEqual(Expr expr1, Expr expr2)) = "(<toString(expr1)> le <toString(expr2)>)";

public str toString(greaterThanOrEqual(Expr expr1, Expr expr2)) = "(<toString(expr1)> ge <toString(expr2)>)";

public str toString(twoEqual(Expr expr1, Expr expr2)) = "(<toString(expr1)> == <toString(expr2)>)";

public str toString(neq1(Expr expr1, Expr expr2)) = "(<toString(expr1)> != <toString(expr2)>)";

public str toString(equality(Expr expr1, Expr expr2)) = "(<toString(expr1)> eq <toString(expr2)>)";

public str toString(inequality(Expr expr1, Expr expr2)) = "(<toString(expr1)> ne <toString(expr2)>)";

public str toString(and(Expr expr1, Expr expr2)) = "(<toString(expr1)> && <toString(expr2)>)";

public str toString(logicalAnd(Expr expr1, Expr expr2)) = "(<toString(expr1)> and <toString(expr2)>)";

public str toString(cct(Expr expr1, Expr expr2)) = "(<toString(expr1)> || <toString(expr2)>)";

public str toString(logicalOr(Expr expr1, Expr expr2)) = "(<toString(expr1)> or <toString(expr2)>)";

public str toString(conditional(Expr condition, Expr eval1, Expr eval2)) = "(<toString(condition)> ? <toString(eval1)> : <toString(eval2)>)";

public str toString(lambda(Expr arg, Expr exp)) = "(<toString(arg)> -\> <toString(exp)>)";

public str toString(assign(Expr expr1, Expr expr2)) = "(<toString(expr1)> = <toString(expr2)>)";

public str toString(semicolon(Expr expr1, Expr expr2)) = "<toString(expr1)> : <toString(expr2)>";

public str toString(function(Expr exp, list[Expr] expOpt, list[Expr] explist)) = "<toString(exp)>(<intercalate("",[toString(e)|e<-expOpt])>)<intercalate(" ",[toString(ex)|ex<-explist])>";

public str toString(commaseparated(Expr exp, list[Expr] exps)) = "(<toString(exp)>, <intercalate(",",[toString(e)|e<-exps])>)";

public str toString(colonfunction(str id, Expr exp)) = "<id> : <toString(exp)>";