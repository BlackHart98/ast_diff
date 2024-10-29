module lang::yaml::prettyprint::Yaml

import lang::yaml::ast::AST;

// Document
public str prettyConfig(documentValues(list[Value] v)) = "<for(val <- v) {> 
                                                            '<prettyConfig(val)> <}>";
public str prettyConfig(documentMappings(list[MappingBlock] mb)) = "<for(mapb <- mb) {> 
                                                                    '<prettyConfig(mapb)> <}>";

// Values
public str prettyConfig(sequenceVal(Value sv)) = "-<prettyConfig(sv)>";

public str prettyConfig(quotedVal(QuotedScalar qv)) = "<prettyConfig(qv)>";

public str prettyConfig(plainVal(PlainScalar pv)) = "<prettyConfig(pv)>";

public str prettyConfig(numberVal(Number numb)) = "<prettyConfig(numb)>";

public str prettyConfig(time(Time t)) = "<prettyConfig(t)>";

public str prettyConfig(date(Date d)) = "<prettyConfig(d)>";

public str prettyConfig(booleanVal(BooleanScalar b)) = "<prettyConfig(b)>";


// Value Types
public str prettyConfig(quotedScalar(str quotedVal)) = "<quotedVal>";

public str prettyConfig(plainScalar(str plainV)) = "<plainV>";

public str prettyConfig(number(int number)) = "<number>";

public str prettyConfig(timeScalar(str timeVal)) = "<timeVal>";

public str prettyConfig(booleanScalar(str boolVal)) = "<boolVal>";

public str prettyConfig(date(str dateVal)) = "<dateVal>";


// Mapping Blocks
public str prettyConfig(mappingBlock(str id , list[Value] vs)) = "<id>: 
                                                                    ' <for(val <- vs) {> <prettyConfig(val)> 
                                                                    ' <}>";

public str prettyConfig(mappingBlockWType(str id, str typeName, Value val)) = "<id>@<typeName>: <prettyConfig(val)>";

public str prettyConfig(mappingToBlock(str id, MappingBlock mb)) = "<id>: <prettyConfig(mb)>";

public str prettyConfig(mappingToBlocks(str id , list[MappingBlock] mbs)) = "<id> : { 
                                                                            '<for(mapbs <- mbs) {> 
                                                                            ' <prettyConfig(mapbs)> 
                                                                            '<}>}";

public str prettyConfig(sequenceMapping(MappingBlock sm)) = "-<prettyConfig(sm)>";



// Types
public str prettyConfig(integer()) = "integer";
public str prettyConfig(string()) = "string";
public str prettyConfig(boolean()) = "boolean";
public str prettyConfig(date()) = "date";
public str prettyConfig(time()) = "time";






