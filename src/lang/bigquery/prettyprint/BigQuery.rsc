module lang::bigquery::prettyprint::BigQuery

import String;
import List;
extend lang::bigquery::prettyprint::DCL;

public str toString(BigQuery bigqry){
    switch(bigqry){
        case expression(Expr expr):{
            return "<toString(expr)>";
        }
        case statements(list[StatementWithTerminator] statementWithTerminatorList):{
            return "<trim(intercalate("\n\n",[toString(swt) | swt <- statementWithTerminatorList]))>";
        }
        case simpleStatement(Statement statement):{
            return "<toString(statement)>";
        }
        default: throw "<bigqry> not seen ";
    }
}

public str toString(statementWithTerminator(Statement stmt, list[Terminator] terminator)) = "<toString(stmt)> <intercalate("",[toString(tmnt) | tmnt <- terminator])>";

public str toString(terminator()) = ";";
