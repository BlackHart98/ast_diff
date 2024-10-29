module lang::ptl::grammar::Annotations

// extend lang::ptl::grammar::View;

extend lang::ptl::grammar::Expressions;

syntax ModelAnnotation = modelAnnotation: "@config" "(" AnnotationProperty+ ")";

syntax Materialization = materializationType: MaterializationType 
                        | scdMaterialization: SCD
                        ;

syntax MaterializationType = tableMaterializationType: "Table"
                                | materializedView: "MaterializedView"
                                | embedded: "Embedded"
                                | viewMaterializationType: "View"
                                ;

syntax StorageFormatType = icebergFormatType: "Iceberg"
                            | parquetFormatType: "Parquet"
                            | orcFormatType: "Orc"
                            ;

syntax AnnotationProperty = materializedAs: "materializedAs" "=" Materialization
                            | partitionedByProperty: "partitionedBy" "=" "[" {Id ","}+ "]"
                            | clusteredByProperty: "clusteredBy" "=" "[" {Id ","}+ "]"
                            | storageFormatProperty: "storageFormat" "=" StorageFormatType
                            | dependsOnProperty: "dependsOn" "=" QID
                            | schemaProperty: "schema" "=" QID
                            ;

syntax SCD = scd: "SCD" "(" 
                        {SCDConfig ","}+ 
                    ")"
                ;

syntax SCDConfig = scdType: "type" "=" [1 - 7]
                    | scdStrategy: "strategy" "=" StrategyOption
                    | scdUniqueId: "uniqueKey" "=" Id
                    | scdAttrib: "checkAttrs" "=" "[" {Id ","}+ "]"
                    | scdUpdatedAt: "updatedAt" "=" Id
                    ;

syntax StrategyOption 
    = timestampStrategy:  "Timestamp" 
    | checkStrategy:  "Check" 
    ;
