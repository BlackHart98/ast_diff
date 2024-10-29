module lang::ptl::grammar::Entity
 
extend lang::ptl::grammar::View;



syntax Entity
  =  @Foldable entity:
      ModelAnnotation?
      PartitionedBy?
      ClusteredBy?
      RowFormat?
      StoredAs?
      Location?
      TableProperties? 
      MaterializedAs?
      Temporal?
      External?
      IfNotExists?
      Drop?
      "entity" EntityId name  Field* fields "end" "entity"
   | @Foldable entityWithKey:
      ModelAnnotation?
      PartitionedBy?
      ClusteredBy?
      RowFormat?
      StoredAs?
      Location?
      TableProperties? 
      MaterializedAs?
      Temporal?
      External?
      IfNotExists?
      Drop?
      "entity" EntityId name  
         Field* fields 
         "identification"
            "key" "(" Id primaryKey ")" 
      "end" "entity"
   | @Foldable entityExtends: 
      Temporal?
      External?
      IfNotExists?
      Drop?
      "entity" EntityId name "extends" EntityId base  Field* fields "end" "entity"
;

syntax PartitionedBy = partitionedBy: "@partitionedBy""(" {(OID Type?) ","}+ ")";   

syntax ClusteredBy = clusteredBy: "@clusteredBy""("{OID ","}+")" "into" IntegerLiteral "buckets";

syntax RowFormat = rowFormat: "@rowFormat" "(" FormatType ")";

syntax FormatType 
   = serDe: "SERDE" StringLiteral
   | delimitedFields: "DELIMITED" "FIELDS" "TERMINATED" "BY" StringLiteral? Lines?
   ;

   
syntax Lines = lines: "LINES" "TERMINATED" "BY" StringLiteral;

syntax StoredAs = storedAs: "@storedAs""("FileType")";

syntax Location = location: "@location""("StringLiteral")";

syntax TableProperties = tableProperties: "@tblProperties" "("{TableProperty ","}+")";

syntax TableProperty = tableProperty: StringLiteral "=" StringLiteral;

syntax FileType =
   textFile: "TEXTFILE"
   | orc: "ORC"
   | parquet: "PARQUET"
   | avro: "AVRO"
   | jsonFile: "JSONFILE"
   | rcFile: "RCFILE"
   | sequenceFile: "SEQUENCEFILE"
   ;

syntax External = external: "@external";

syntax MaterializedAs = materializedAs: "@tableAs""("OID")";

syntax Field 
   = derived: Id name ":" Type t "=" Expr e
   | field: Id fieldName ":" Type t Constraints? constraint
   | uniReference: Id referenceName "-\>" Type typ
   | biReference: Id referenceName "-\>" Type typ "inverse" Reference ref "::" Id name

;

syntax Enum
   = @Foldable enum: "enum" EntityId name  EnumField+ values "end" "enum"
;

syntax EnumField 
   = enumField: Id name ","
   | labeledEnumField: Id name "(" Id value ")" ","
;

syntax Constraints = 
   constraints: "(" {Facet ","}+ facet ")"
;

syntax Facet = 
  required:  "required" 
  | size: "size" "[" IntegerLiteral "]"
  | masked: "masked"
  | redacted: "redacted"
;






