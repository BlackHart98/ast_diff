module lang::ptl::ast::Annotations

import lang::ptl::grammar::PTL;
extend lang::ptl::ast::Declarations;

data ModelAnnotation = modelAnnotation(list[AnnotationProperty] annotationProperty);

data Materialization = materializationType(MaterializationType materializationType)
                        | scdMaterialization(SCD scdMaterialization)
                        ;

data MaterializationType = tableMaterializationType()
                                | materializedView()
                                | embedded()
                                | viewMaterializationType()
                                ;

data StorageFormatType = icebergFormatType()
                            | parquetFormatType()
                            | orcFormatType()
                            ;

data AnnotationProperty = materializedAs(Materialization materialization)
                            | partitionedByProperty(list[str] ids)
                            | clusteredByProperty(list[str] ids)
                            | storageFormatProperty(StorageFormatType storageFormatType)
                            | dependsOnProperty(str qid)
                            | schemaProperty(str qid)
                            | updatedAtProperty(str id)
                            ;

data SCD = scd(list[SCDConfig] scdConfigList);

data SCDConfig = scdType(str integer)
                    | scdStrategy(StrategyOption strategyOption)
                    | scdUniqueId(str id)
                    | scdAttrib(list[str] ids)
                    | scdUpdatedAt(str id)
                    ;

data StrategyOption
    = timestampStrategy()
    | checkStrategy()
    ;

data Declaration = viewWithAnnotation(Annotation annotation, ViewDecl viewDecl);
