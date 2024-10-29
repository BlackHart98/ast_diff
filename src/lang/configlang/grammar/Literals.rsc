module lang::configlang::grammar::Literals

extend lang::configlang::grammar::Layout;

syntax Literal
        = qidExp: QualifiedId
        | litname: Name
        | boolean: BooleanLiteral
        ;
syntax QualifiedId
        = qualifiedId: {Id "."}+
        ;


lexical Id 
        = ([a-z A-Z] !<< [a-z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9]) \ Keywords
        ;
lexical EId 
        = ([A-Z] !<< [A-Z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9]) \ Keywords
        ;
lexical Name
        =  [$][a-zA-Z_][a-zA-Z0-9_]*
        ;
lexical BooleanLiteral 
        = "true" 
        | "false" 
        ;

lexical SCDType = [1-7];
keyword Keywords
        = "true"
        | "def"
        | "project"
        | "include"
        | "false"
        | "True"
        | "False"
        | "engineering"
        | "None"
        | "Undefined"
        | "import"
        | "and"
        | "or"
        | "in"
        | "is"
        | "not"
        | "as"
        | "if"
        | "else"
        | "adeptVersion"
        | "for"
        | "Cloud"
        | "OnPrem"
        | "volumes"
        | "ports"
        | "override"
        | "environment"
        | "environments"
        | "any"
        | "map" 
        | "GCP"
        | "Azure"
        | "AWS"
        | "Docker"
        | "WHERE"
        | "validate"
        | "flow"
        | "pipelines"
        | "pipeline"
        | "SQLEngine"
        | "module"
        | "except"
        | "forward"
        | "reverse"
        | "while"
        | "Database"
        | "with"
        | "Batch"
        | "RealTime"
        | "configuration"
        | "workflow"
        | "Ingestion"
        | "targetDir"
        | "srcDir"
        | "projectId"
        | "Int"
        | "Str"
        | "Bool"
        | "BigInt"
        | "Float"
        | "Datetime"
        | "Date"
        | "Object"
        | "Null"
        | "Set"
        | "Map"
        | "List"
        | "Tuple"
        | "Spark"
        | "Hive"
        | "BigQuery"
        | "Athena"
        | "Snowflake"
        | "Redshift"
        | "datasource"
        | "storageFormat"
        | "val"
        | "password"
        | "user"
        | "host"
        | "port"
        | "Postgres"
        | "MySQL"
        | "Oracle"
        | "SQLServer"
        | "redpanda"
        | "oltp"
        | "feldera"
        | "kafka"
        | "mapping"
        | "ivmPlatform"
        | "daily"
        | "ingestion"
        | "retries"
        | "dialect"
        | "view"
        | "Table"
        | "SCD"
        | "Native"
        | "Iceberg"
        | "runtime"
        | "hadoop"
        | "hostName" 
        | "sparkYarnMaster"
        
;
        