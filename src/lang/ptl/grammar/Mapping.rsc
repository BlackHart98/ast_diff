module lang::ptl::grammar::Mapping

extend lang::ptl::grammar::Entity;




syntax EntityMapping
  = entityMapping: "entityMapping" EntityId "[" QualifiedIdentifier "]"":"
    MappingBody+
    "end" "entityMapping"
  ;

syntax MappingBody
  = mappingSchema: "schema" "=" StringLiteral 
  | mappingTable: "table" "=" StringLiteral
  | mappingAttributes: "attributeMappings" MappingAttribute+
  ;

syntax MappingAttribute = mapAttribute: Expr "-\>" StringLiteral ":" MappingType;

syntax MappingType
  = mapInt: 'INT'
  | mapVarchar: 'VARCHAR'"("IntegerLiteral")"
  | mapBool: 'BOOLEAN'
  | mapString: 'STRING'
  | mapTimestamp: 'TIMESTAMP'
  ;