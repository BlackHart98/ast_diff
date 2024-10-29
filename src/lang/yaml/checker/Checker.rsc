module lang::yaml::checker::Checker

extend analysis::typepal::TypePal;

import lang::yaml::grammar::Syntax;

data AType 
         = intType()
         | stringType()
         | boolType()
         | dateType()
         | timeType()
         ;

data IdRole = mappingId() | blockId();

str prettyAType(boolType()) = "boolean";
str prettyAType(intType()) = "integer";
str prettyAType(stringType()) = "string";
str prettyAType(dateType()) = "date";
str prettyAType(timeType()) = "time";




// Mappings

void collect(current: (Document) `<MappingBlock+ mp>`, Collector c) {
  c.enterScope(current);
    collect(mp, c);
  c.leaveScope(current);
}

void collect(current: (MappingBlock) `<Id name> @ <Type t> : <Value val>`, Collector c) {
  c.define("<name>", mappingId(), current, defType(t));
  c.requireEqual(t, val, error(val, "Incorrect initialization, expected %t, found %t", t, val));
  collect(t, val, c);
}

// Values
void collect(current: (Value) `<Number _>`, Collector c) {
  c.fact(current, intType());
}

void collect(current: (Value) `<QuotedScalar _>`, Collector c) {
  c.fact(current, stringType());
}

void collect(current: (Value) `<BooleanScalar _>`, Collector c) {
  c.fact(current, boolType());
}

void collect(current: (Value) `<Date _>`, Collector c) {
  c.fact(current, dateType());
}

void collect(current: (Value) `<Time _>`, Collector c) {
  c.fact(current, timeType());
}


// Type Constraints

void collect(current: (Type) `integer`, Collector c) {
  c.fact(current, intType());
}

void collect(current: (Type) `string`, Collector c) {
  c.fact(current, stringType());
}

void collect(current: (Type) `boolean`, Collector c) {
  c.fact(current, boolType());
}

void collect(current: (Type) `date`, Collector c) {
  c.fact(current, dateType());
}

void collect(current: (Type) `time`, Collector c) {
  c.fact(current, timeType());
}

TModel yamlTModelForTree(Tree pt){
    return collectAndSolve(pt);
}
