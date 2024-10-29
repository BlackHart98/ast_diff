module lang::configlang::grammar::Expressions

extend lang::configlang::grammar::Literals;
extend lang::exprlang::grammar::Expressions;


syntax Expr = 
   typed: Id ":" Type 
   | \list: "["{Expr ","}+"]"
   | \map:  "{" {Mapping ","}+ entries "}" 
   | \set: "set{" {Expr ","}* el "}" 
   | \tuple: "\<" {Expr ","}+ el "\>" 
;

	
syntax Mapping = 
   mapping: Expr k ":" Expr v
;


syntax Type = 
     intType: "Int"
     | floatType: "Float"
     | booleanType: "Bool"
     | stringType: "Str" 
     | dateTimeType: "Datetime" 
     | dateType: "Date"
     | runtime: "Runtime"
     | source: "Source"
     | sqlEngine: "SQLEngine"
     | \setType: "Set" "[" Type t "]"
     | \mapType: "Map" "[" Type k "," Type v "]"
     | \listType: "List" "[" Type t "]"
     | \tupleType: "Tuple" "[" {Type ","}+ ty "]"
;

syntax WhereClause  = 
   whereClause: 'WHERE' Expr
;

syntax ConfigType = 
   typeOnly:Type
   | withConstraint:Type WhereClause
;
