module lang::bigquery::prettyprint::DCL

extend lang::bigquery::prettyprint::DML;
import List;

public str toString(dclStatement(DCL dclStatement)) = "<toString(dclStatement)>";

public str toString(DCL id){
    switch(id){
        case grantCommand(GrantStatement grantCommand):{
            return "<toString(grantCommand)>";
        }
        case revokeCommand(RevokeStatement revokeCommand):{
            return "<toString(revokeCommand)>";
        }
        default: throw "<id> not seen ";
    }
}

public str toString(grantStatement(Expr exp, ResourceType resourceType, TableName tablename, list[Expr] exps)) = "GRANT <toString(exp)> ON <toString(resourceType)> <toString(tablename)> TO <intercalate(", ", [toString(e) | e <- exps])>";

public str toString(revokeStatement(Expr exp, ResourceType resourceType, TableName tablename, list[Expr] exps)) = "REVOKE <toString(exp)> ON <toString(resourceType)> <toString(tablename)> FROM <intercalate(", ", [toString(e) | e <- exps])>";

public str toString(ResourceType id){
    switch(id){
        case schemaType(): return "SCHEMA";
        case tableType(): return "TABLE";
        case viewType(): return "VIEW";
        case externalTableType(): return "EXTERNAL TABLE";

        default: return "";
    }
}