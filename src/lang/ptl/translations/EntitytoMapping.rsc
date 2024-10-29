module lang::ptl::translations::EntitytoMapping
import lang::ptl::ast::PTL;

public Program generate(Program::\module(str moduleId, list[Import] importlist, list[Declaration] decls)){
    entityMappingList= [generateMapping(enDecl)|enDecl<-decls,entity(
        list[ModelAnnotation] _
        , list[PartitionedBy] _
        , list[ClusteredBy] _
        , list[RowFormat] _
        , list[StoredAs] _
        , list[Location] _
        , list[TableProperties] _
        , list[MaterializedAs] _
        , list[Temporal] _
        , list[External] _
        , list[IfNotExists] _
        , list[Drop] _
        , str _
        , list[Field] _
        ):=enDecl];
   
    return Program::\module(moduleId,importlist,entityMappingList);
}

public Declaration generateMapping(entity(
        list[ModelAnnotation] _
        , list[PartitionedBy] _
        , list[ClusteredBy] _
        , list[RowFormat] _
        , list[StoredAs] _
        , list[Location] _
        , list[TableProperties] _
        , list[MaterializedAs] _
        , list[Temporal] _
        , list[External] _
        , list[IfNotExists] _
        , list[Drop] _
        , str entityId
        , list[Field] fields
        ))= entityMapping("<entityId>Mapping", entityId, [mappingSchema(""),mappingTable(entityId),mappingAttributes([mapAttribute(identifier([field.fieldId]), field.fieldId,generateMapping(field.\type))|field<-fields])]);


public MappingType generateMapping(Type t){
    switch(t){
       case \int() : return mapInt();
       case smallInt():return mapInt();
       case bigInt(): return mapInt();
       case float(): return mapInt();
       case booleanType(): return mapBool();
       default: return mapVarchar("11");
    }
}