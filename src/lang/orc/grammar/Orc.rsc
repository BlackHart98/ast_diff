module lang::orc::grammar::Orc

extend lang::orc::grammar::Dataflow;



 start syntax Orc 
   = \module:"module" ModuleId name
    Import* imports
    Statement* statementList 
   ;


syntax Import
	= \import: "import" ModuleId
 	;