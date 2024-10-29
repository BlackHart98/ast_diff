module lang::ptl::grammar::Declarations

extend lang::ptl::grammar::Mapping;


syntax Declaration
    = Entity
    | Enum
    | Struct
    | EntityMapping
    | View
    | SchemaName
    | SchemaVar
    | AddFile
    | RenameEntity
    | FunctionDecl 
;

syntax FunctionDecl 
	= function: FunctionAnnotation*
      FunctionDef
	;
syntax FunctionDef 
	= funcdefwithexpr: "func" Id functionid "("{Params ","}* ")" "-\>" Type "=" Expr
	| funcdef: "func" Id functionid "("{Params ","}* ")" "-\>" Type
	| funcdefWithKW: "func" Id functionid "("{Params ","}+ "," {KWParam ","}+")" "-\>" Type
	| funcdefKWOnly: "func" Id functionid "("{KWParam ","}+ ")" "-\>" Type
	;
syntax Params 
    = params: Id ":" Type
    | types: Type
    ;

syntax FunctionAnnotation 
    = functionAnnotation: "@" Annotation
    ;

syntax Annotation 
    = scalar: "scalar" 
    | aggregate: "aggregate"
    | table: "table"
    | platform :"platform" "{" {String ","}+ "}"
    | \alias: "alias" "{" String "}"
    ;
  