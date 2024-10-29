module lang::oozie::grammar::Expressions

extend lang::oozie::grammar::Literals;

syntax OozieProg 
        = ooziExps: OozieExpr+
        ; 
syntax OozieExpr 
        = immediateEval: "${" Expr "}"
        | deferredEval: "#{" Expr "}"
        ;
syntax Expr
        = bracket \bracket: "(" Expr ")"
        |variable: {Identifier "."}+
        | Literal
        > functionlist: Identifier? "[" Expr? "]"
        > left uMin: "-" Expr
        > not: "!" Expr
        > logicalNot: "not" Expr
        > left empty: "empty" Expr
        > left mul: Expr lhs "*" Expr rhs
        > left div: Expr lhs "/" Expr rhs
        > left division: Expr lhs "div" Expr rhs
        > left modulus: Expr lhs "%" Expr rhs
        > left modulo: Expr lhs "mod" Expr rhs
        > left add: Expr lhs "+" Expr rhs
        > left sub: Expr lhs "-" Expr rhs
        > left concat: Expr lhs "+=" Expr rhs
        > left lt: Expr lhs "\<" Expr rhs
        > left gt: Expr lhs "\>" Expr rhs
        > left lte: Expr lhs "\<=" Expr rhs
        > left gte: Expr lhs "\>=" Expr rhs
        > left lessThan: Expr lhs "lt" Expr rhs
        > left greaterThan: Expr lhs "gt" Expr rhs
        > left lessThanOrEqual: Expr lhs "le" Expr rhs
        > left greaterThanOrEqual: Expr lhs "ge" Expr rhs
        > left twoEqual: Expr lhs "==" Expr rhs
        > left neq1: Expr lhs "!=" Expr rhs
        > left equality: Expr lhs "eq" Expr rhs
        > left inequality: Expr lhs "ne" Expr rhs
        > left and: Expr lhs "&&" Expr rhs
        > left logicalAnd: Expr lhs "and" Expr rhs
        > left cct: Expr lhs "||" Expr rhs
        > left logicalOr: Expr lhs "or" Expr rhs
        > left conditional: Expr condition "?" Expr eval1 ":" Expr eval2
        > left lambda: Expr arg "-\>" Expr exp
        > left assign: Expr lhs "=" Expr rhs
        > left semicolon: Expr lhs ";" Expr rhs
        > non-assoc function: Expr "(" Expr? ")" Expr*
        > left commaseparated: Expr exp "," {Expr ","}+
        > left colonfunction: Identifier ":" Expr
        ;