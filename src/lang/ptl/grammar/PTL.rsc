module lang::ptl::grammar::PTL


extend lang::ptl::grammar::Macros;

start syntax Program 
    = @Foldable \module: "module" ModuleId Import* imports Declaration* declarations
    ;

lexical ModuleId
    = moduleId: {Id "."}+ moduleName
    ;

syntax Import
	= \import: "import" ModuleId
 	;

