module lang::ptl::ast::Mapping

import lang::ptl::grammar::Mapping;

extend lang::ptl::ast::Expressions;



data Table
  = table(Expr e1, Expr e2, Expr e3, list[TableAttribute] ta)
;

data TableAttribute
  = index(Expr e)
  | discriminator(Expr e)
  | documentation(Expr e)
;


data Property
  = property(Expr e, list[PropertyType] lp)
;

data Relationship
  = relationship(Expr e, Cardinality c)
;

data Cardinality
  = manyToOne(str entityName, Expr e)
  | oneToMany(str entityName, Expr e)
  | manyToMany(str entityName, Expr e, list[JoinTable] jt)
;

data JoinTable 
  = joinTable(Expr e)
;


data PropertyType
  = columnName(Expr e)
  | columnOrder(Expr e)
  | columnDoc(Expr e)
  | columnType(ColumnType c)
  | nullable(Expr e)
  | unique(Expr e)
  | defaultValue(Expr e)
  
;

data ColumnType
  = intColumn()
  | varcharColumn(Expr e)
  | dateColumn()
  | datetimeColumn()
  | boolColumn()
  | decimalColumn(Expr e1, Expr e2)
  
;


data MappingBody
  = mappingSchema(str schemaId)
  | mappingTable(str tableId)
  | mappingKey(Expr keyId)
  | mappingIndex(list[Expr] indexes)
  | mappingAttributes(list[MappingAttribute] mapAttrs)
  ;

data MappingAttribute = mapAttribute(Expr attrName, str mapName, MappingType attrType);

data MappingType
  = mapInt()
  | mapVarchar(str integer)
  | mapBool()
  ;
