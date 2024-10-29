module lang::snowflake::grammar::Names

extend lang::basesql::grammar::BaseSQL;

extend lang::snowflake::grammar::Literals;

 syntax Identifier = non-assoc withDollar:Identifier"$"Identifier;

lexical WhIdentifier = ([a-z A-Z _] !<< "$" [a-z A-Z _] [a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9 _]) \ Keywords;


syntax Literal = defaultVal: 'DEFAULT' 
                  |boolean: Boolean  
                  | null: 'NULL'             
                    ;
keyword Keywords = 
                 'UNION'
                | 'EXCEPT'
                | 'MINUS'
                | 'OVER'
                | 'LISTAGG'
                | 'ARRAY_AGG'
                | 'LEAD'
                | 'LAG'
                | 'FIRST'
                | 'LAST'
                | 'CONCAT'
                | 'CONCAT_WS'
                | 'COALESCE'
                | 'IFNULL' 
                | 'NVL'
                | 'GET'
                | 'LEFT'
                | 'RIGHT'
                | 'DATE_PART'
                | 'SPLIT'
                | 'NULLIF'
                | 'EQUAL_NULL'
                | 'CONTAINS'
                | 'COLLATE'
                | 'TO_DATE'
                | 'DATE'
                | 'CHARINDEX'
                | 'REPLACE'
                | 'SUBSTRING' 
                | 'SUBSTR'
                | 'LIKE' 
                | 'ILIKE'
                | 'NULL'
                | 'OR'
                | 'NOT'
                | 'ALL'
                | 'AND'
                | 'THEN'
                | 'ACCOUNT'
                | 'DATABASE'
                | 'TABLE'
                | 'SCHEMA'
                | 'VIEW'
                | 'IFF'
                | 'TRY_CAST'
                | 'CAST'
                | 'Pivot'
                | 'INNER'
                | 'COMMENT'
                | 'ORDER'
                ;