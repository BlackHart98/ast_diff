module lang::yaml::ast::AST


import lang::yaml::grammar::Syntax;


data Document 
              = documentValues(list[Value] v)
              | documentMappings(list[MappingBlock] mb)
              ;



data MappingBlock 
                  = mappingBlock(str id , list[Value] vs)
                  | mappingBlockWType(str id, str typeName, Value val)
                  | mappingToBlock(str id, MappingBlock mb)
                  | mappingToBlocks(str id , list[MappingBlock] mbs)
                  | sequenceMapping(MappingBlock sm)
                  ;

data Value
          = sequenceVal(Value sv)
          | quotedVal(QuotedScalar qv)
          | plainVal(PlainScalar pv)
          | numberVal(Number numb)
          | time(Time t)
          | date(Date d)
          | booleanVal(BooleanScalar b)
          ;


data QuotedScalar = quotedScalar(str quotedVal);


data PlainScalar = plainScalar(str plainV);

data Number = number(int number);

data BooleanScalar = booleanScalar(str boolVal);

data Time = timeScalar(str timeVal);

data Date = date(str dateVal);

data Type 
         = integer()
         | string()
         | boolean()
         | date()
         | time()
         ;
