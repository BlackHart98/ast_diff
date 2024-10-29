module lang::yaml::grammar::Syntax

extend lang::yaml::grammar::Lexical;

start syntax Document 
                      = documentValues: Value!sequenceVal+ 
                      | documentMappings: MappingBlock!sequenceMapping+;

syntax MappingBlock
                    = mappingBlock: Id name ":" Value+ vals
                    | mappingBlockWType: Id name "@" Type t ":" Value!sequenceVal val
                    | mappingToBlock: Id name ":" MappingBlock
                    | mappingToBlocks: Id name ":" "{" MappingBlock+ "}"
                    | sequenceMapping: "-" MappingBlock //nesting syntax
                    ;


syntax Value
            = quotedVal: QuotedScalar 
            | plainVal: PlainScalar 
            | numberVal: Number
            | time: Time 
            | date: Date
            | booleanVal: BooleanScalar
            | sequenceVal: "-" Value
            ;


syntax QuotedScalar = quotedScalar: String;

syntax PlainScalar = plainScalar: Id;

syntax Number = number: Integer;

syntax BooleanScalar = booleanScalar: Boolean;

syntax Time = timeScalar: JustTime;

syntax Date = date: DatePart;


syntax Type 
            = integer: "integer"
            | string: "string"
            | boolean: "boolean"
            | date: "date"
            | time: "time"
            ;
