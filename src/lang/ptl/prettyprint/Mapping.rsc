module lang::ptl::prettyprint::Mapping
extend lang::ptl::prettyprint::Expressions;
import List;




str toString(table(Expr e1, Expr e2, Expr e3, list[TableAttribute] ta)){
    return "table (<toString(e1)> , <toString(e2)> ) 
     '  .key( <toString(e3)>)  
     '   <intercalate("\n",[toString(t)|t<-ta])>
     ";
}

str toString(TableAttribute ta){
   switch(ta){
     case index(Expr e) : return ".index(<toString(e)>)";
     case discriminator(Expr e) : return ".discriminator(<toString(e)>)";
     case documentation(Expr e) : return ".tableDoc(<toString(e)>)";
   } 
   return "";
}

str toString(property(Expr e, list[PropertyType] lp)){
   return "property(<toString(e)>) 
   '  <intercalate("\n",[toString(l) | l<-lp])>
   ";
}

str toString(PropertyType pt){
    switch(pt){
  case columnName(Expr e): return ".columnName(<toString(e)>)";
  case columnOrder(Expr e): return ".columnOrder(<toString(e)>)";
  case columnDoc(Expr e): return ".columnDoc(<toString(e)>)";
  case columnType(ColumnType c): return ".columnType(<toString(c)>)";
  case nullable(Expr e): return ".isNullable(<toString(e)>)";
  case unique(Expr e): return ".isUnique(<toString(e)>)";
  case defaultValue(Expr e): return ".defaultValue(<toString(e)>)";
    }
    return "";
}

str toString(ColumnType ct){
    switch(ct){
       case intColumn(): return "int";
       case varcharColumn(Expr e):return "varchar(<toString(e)>)";
       case dateColumn():return "date";
       case datetimeColumn():return "dateTime";
       case boolColumn(): return "bool";
       case decimalColumn(Expr e1, Expr e2): return "decimal(<toString(e1)>,<toString(e2)>)";
    }
    return "";
}

str toString(entityMapping(str mappingName, str tableName, list[MappingBody] mappingBody)){
    return "entitymapping <mappingName> [<tableName>] 
     '  <intercalate("\n",[toString(mp)| mp<-mappingBody])>
     'end entitymapping
     ";
}

str toString(MappingBody mp){
    switch(mp){
       case mappingSchema(str schemaId): return "schema = <schemaId>";
       case mappingTable(str tableId):return "table = <tableId>";
       case dmappingKey(Expr keyId):{
         return "identification
         '  key(<toString(keyId)>)
         ";
         }
       case mappingIndex(list[Expr] indexes):{
         return "index
         '  <intercalate(",",[toString(i)| i<-indexes])>
         ";
         }
       case mappingAttributes(list[MappingAttribute] mapAttrs):{
         return "attribute-mappings
         '  <intercalate("\n",[toString(i)| i<-mapAttrs])>
         ";
         }
    }
    return "";
}

str toString(mapAttribute(Expr attrName, str mapName, MappingType attrType)){
    return "<toString(attrName)> -\> <mapName> <toString((attrType))>";
}


str toString(MappingType mp){
    switch(mp){
      case mapInt(): return "INT";
      case mapVarchar(str integer):return "VARCHAR(<integer>)";
      case mapBool(): return "BOOLEAN";
    }
    return "";
}