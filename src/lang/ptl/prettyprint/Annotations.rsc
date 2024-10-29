module lang::ptl::prettyprint::Annotations

import List;
import String;

extend lang::ptl::prettyprint::Declarations;


public str toString(ModelAnnotation::modelAnnotation(list[AnnotationProperty] annotationProperty)) = "@config ( <for(annotationProp<-annotationProperty){> 
                                                                                            '   <toString(annotationProp)> <}> 
                                                                                            ')";

public str toString(Materialization::materializationType(MaterializationType materializationType)) = "<toString(materializationType)>";
public str toString(Materialization::scdMaterialization(SCD scdMaterialization)) = "<toString(scdMaterialization)>";

public str toString(MaterializationType::tableMaterializationType()) = "Table";
public str toString(MaterializationType::materializedView()) = "MaterializedView";
public str toString(MaterializationType::embedded()) = "Embedded";
public str toString(MaterializationType::viewMaterializationType()) = "View";

public str toString(StorageFormatType::icebergFormatType()) = "Iceberg";
public str toString(StorageFormatType::parquetFormatType()) = "Parquet";
public str toString(StorageFormatType::orcFormatType()) = "Orc";

public str toString(AnnotationProperty::materializedAs(Materialization materialization)) = "materializedAs = <toString(materialization)> ";
public str toString(AnnotationProperty::partitionedByProperty(list[str] ids)) = "partitionedBy = [ <intercalate(", ",["<id>"|id<-ids])> ]";
public str toString(AnnotationProperty::clusteredByProperty(list[str] ids)) = "clusteredBy = [ <intercalate(", ",["<id>"|id<-ids])> ]";
public str toString(AnnotationProperty::storageFormatProperty(StorageFormatType storageFormatType)) = "storageFormat = <toString(storageFormatType)>";
public str toString(AnnotationProperty::dependsOnProperty(QualifiedIdentifier qid)) = "dependsOn = <toString(qid)>";

public str toString(SCD::scd(list[SCDConfig] scdConfigList)) = "SCD ( <intercalate(", ",[toString(scdConfig)|scdConfig<-scdConfigList])> )";

public str toString(SCDConfig::scdType(str integer)) = "type = <integer>";
public str toString(SCDConfig::scdStrategy(StrategyOption strategyOption)) = "strategy = <toString(strategyOption)>";
public str toString(SCDConfig::scdUniqueId(str id)) = "uniqueKey = <id>";
public str toString(SCDConfig::scdAttrib(list[str] ids)) = "checkAttrs = [ <intercalate(", ",["<id>"|id<-ids])> ]";
public str toString(SCDConfig::scdUpdatedAt(str id)) = "updatedAt = <id>";

public str toString(StrategyOption::timestampStrategy()) = "Timestamp";
public str toString(StrategyOption::checkStrategy()) = "Check";

public str toString(Declaration::viewWithAnnotation(Annotation annotation, ViewDecl viewDecl)) = "<toString(annotation)> <toString(viewDecl)>";


