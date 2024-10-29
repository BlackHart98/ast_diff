module lang::ptl::prettyprint::Declarations
import List;
extend lang::ptl::prettyprint::SCD;
extend lang::ptl::prettyprint::Mapping;
import String;



public  str toString(Declaration e){
   switch (e){
       case entity(
        list[ModelAnnotation] mda
        , list[PartitionedBy] prtBy
        , list[ClusteredBy] clstBy
        , list[RowFormat] rowFrmt
        , list[StoredAs] storedAs
        , list[Location] location
        , list[TableProperties] tblPropties
        , list[MaterializedAs] materializedAs
        , list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , list[Field] fields
        ):{
        return "<toString(entity(mda,prtBy,clstBy,rowFrmt,storedAs,location,tblPropties,materializedAs,temporal,external,ifNotExists,drop,entityId,fields))>";
       }
       case entityWithKey(
        list[ModelAnnotation] mda
        , list[PartitionedBy] prtBy
        , list[ClusteredBy] clstBy
        , list[RowFormat] rowFrmt
        , list[StoredAs] storedAs
        , list[Location] location
        , list[TableProperties] tblPropties
        , list[MaterializedAs] materializedAs
        , list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , list[Field] fields
        , str primaryKey
        ):{
        return "<toString(entityWithKey(mda,prtBy,clstBy,rowFrmt,storedAs,location,tblPropties,materializedAs,temporal,external,ifNotExists,drop,entityId,fields,primaryKey))>";
       }
       case entityExtends(
        list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , str baseId
        , list[Field] fields
        ):{
        return "<toString(entityExtends(temporal,external,ifNotExists,drop,entityId,baseId,fields))>";
       }
       case struct(str structId, list[StructField] structFields):{
        return "struct <structId>{
        '   <intercalate("\n",["<sf.structId> : <toString(sf.\type)>" |sf<-structFields])>
       '}";
       }
      //  case relationalMapping(str name, str name2, Table table , list[Property] properties, list[Relationship] relationships):{
      //   return "relational-mapping <name>[<name2>] {
      //   '   <toString(table)>
      //   '    <intercalate("\n",[toString(prop)|prop<-properties])>
      //   '    <intercalate("\n",[toString(\rel)|\rel<-relationships])>
      //  '}";
      //  }
    case enum(str name, list[EnumField] enumFields):{
      return "enum <name> 
        '    <intercalate("\n",[toString(ef)| ef<-enumFields])>
       'end enum";
    }
    case viewAs(
        list[ModelAnnotation] mda,
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , QualifiedIdentifier qid
        , list[ViewVariablesOrEmpty] viewVar
        , SubViewDecl subViewDecl
        ):{
          return "<trim("<intercalate("", [toString(model) | model <- mda])>
            '<intercalate("",["@ifNotExists"|_<-ifNotExists])> 
            '<intercalate("",[toString(drp)| drp<-drop])> 
            '<intercalate("",["@temporal"|_<-temp])>")>
            '"+
            "view <toString(qid)> <intercalate("",[toString(voe)|voe<-viewVar])>(
            '    <toString(subViewDecl)>
            ')
            'end view";
        }
    case viewWith(
        list[ModelAnnotation] mda,
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , QualifiedIdentifier qid
        , list[ViewVariablesOrEmpty] viewVar
        , list[NamedSubViewDecl] names
        , SubViewDecl subViewDecl
        ):{
          return "<intercalate("", [toString(model) | model <- mda])> 
              '<intercalate("",["@ifNotExists"|_<-ifNotExists])> 
              '<intercalate("",[toString(drp)| drp<-drop])> 
              '<intercalate("",["@temporal"|_<-temp])> 
              'view <toString(qid)> with 
              '    <intercalate("",[toString(voe)|voe<-viewVar])>
              '    <intercalate("",[toString(name)|name<-names])>
              '    <toString(subViewDecl)>
              'end view
              ";
          }
    case viewWithTransform2(
        list[ModelAnnotation] mda,
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
         , QualifiedIdentifier qid
        , list[ViewVariablesOrEmpty] viewVar
        , list[NamedSubViewDecl] names
        , TransformDecl transformDecl
        ):{
          return "<intercalate("", [toString(model) | model <- mda])> 
              '<intercalate("",["@ifNotExists"|_<-ifNotExists])> 
              '<intercalate("",[toString(drp)| drp<-drop])> 
              '<intercalate("",["@temporal"|_<-temp])> 
              'view <toString(qid)> with
              '    <intercalate("",[toString(voe)|voe<-viewVar])>
              '    <intercalate("",[toString(name)|name<-names])>
              '<toString(transformDecl)>
              'end view";
          }
    case viewWithTransform(
        list[ModelAnnotation] mda,
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , list[ViewVariablesOrEmpty] viewVar

        , list[NamedSubViewDecl] names
        , TransformDecl transformDecl
        ):{
          return "<intercalate("", [toString(model) | model <- mda])>
              '" +
              "<trim("<intercalate("",["@ifNotExists"|_<-ifNotExists])> 
              '<intercalate("",[toString(drp)| drp<-drop])> 
              '<intercalate("",["@temporal"|_<-temp])>")>
              'view with
              '    <intercalate("",[toString(voe)|voe<-viewVar])>
              '    <intercalate("",[toString(name)|name<-names])>
              '<toString(transformDecl)>
              'end view";
        }
    case view(
      list[ModelAnnotation] mda,
      ViewDecl viewDecl):{
        return "<intercalate("", [toString(model) | model <- mda])> 
          '<toString(viewDecl)>";
    }
    case viewWithCTE(
      list[ModelAnnotation] mda
      , SubViewAsCTE subViewAsCTE, ViewDecl viewDecl):{
        return "<intercalate("", [toString(model) | model <- mda])> 
          '<toString(subViewAsCTE)>
          '<toString(viewDecl)>";
    }
    case transformDef(
      list[ModelAnnotation] mda,
      TransformDecl transformDecl):{
      return "<intercalate("", [toString(model) | model <- mda])> <toString(transformDecl)>";
    }
    case schemaName(str name):{
      return "@schema ( <name> )";
    }
    case schemaVar(str name):{
      return "@schema ( ${ <name> } )";
    }
    case addFile(Url url):{
      return "@addFile ( <toString(url)> )";
    }
    case renameEnt(RenameEntity renameEnt):{
      return "<toString(renameEnt)>";
    }
    default: throw ToStringException("message: Unable to resolve Declaration signature",e);
  }
}


public str toString(subViewAsCTE(list[ViewDecl] viewDeclList)){
  return "subview(\n<intercalate("\n", [toString(viewDecl) | viewDecl <- viewDeclList])>\n)";
}


public str toString(entity(list[ModelAnnotation] mda
        , list[PartitionedBy] prtBy
        , list[ClusteredBy] clstBy
        , list[RowFormat] rowFrmt
        , list[StoredAs] storedAs
        , list[Location] location
        , list[TableProperties] tblPropties
        , list[MaterializedAs] materializedAs
        , list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , list[Field] fields)){

  return "<trim("<intercalate("", [toString(model) | model <- mda])>
      '")>"+
      "<trim("<intercalate("",["\n<toString(prt)>"|prt<-prtBy])> 
      '<intercalate("",["<toString(clst)>"|clst<-clstBy])> 
      '<intercalate(" ",["@rowFormat(<toString(rf.fmtType)>)"|rf<-rowFrmt])>
      '<intercalate("\n ",["\n<toString(sa)>"|sa<-storedAs])> 
      '<intercalate("\n ",["@location(<l.locationEntry>)"|l<-location])>
      '<intercalate("\n ",[toString(tp)|tp<-tblPropties])> 
      '<intercalate("\n ",["@tableAs(<mta.identifier>)"|mta<-materializedAs])>
      '<intercalate("",["@temporal"|_<-temporal])> 
      '<intercalate("",["@extenal"|_<-external])> 
      '<intercalate("",["@ifNotExists"|_<-ifNotExists])> <intercalate("",[toString(drp)| drp<-drop])>")>
      'entity <entityId> 
      '    <intercalate("\n",[toString(field)|field<-fields])>
      end entity";
}

public str toString(entityWithKey(list[ModelAnnotation] mda
        , list[PartitionedBy] prtBy
        , list[ClusteredBy] clstBy
        , list[RowFormat] rowFrmt
        , list[StoredAs] storedAs
        , list[Location] location
        , list[TableProperties] tblPropties
        , list[MaterializedAs] materializedAs
        , list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , list[Field] fields
        , str primaryKey)){

  return "<trim("<intercalate("", [toString(model) | model <- mda])>
      '")>"+
      "<trim("<intercalate("",["\n<toString(prt)>"|prt<-prtBy])> 
      '<intercalate("",["<toString(clst)>"|clst<-clstBy])> 
      '<intercalate(" ",["@rowFormat(<toString(rf.fmtType)>)"|rf<-rowFrmt])>
      '<intercalate("\n ",["\n<toString(sa)>"|sa<-storedAs])> 
      '<intercalate("\n ",["@location(<l.locationEntry>)"|l<-location])>
      '<intercalate("\n ",[toString(tp)|tp<-tblPropties])> 
      '<intercalate("\n ",["@tableAs(<mta.identifier>)"|mta<-materializedAs])>
      '<intercalate("",["@temporal"|_<-temporal])> 
      '<intercalate("",["@extenal"|_<-external])> 
      '<intercalate("",["@ifNotExists"|_<-ifNotExists])> <intercalate("",[toString(drp)| drp<-drop])>")>
      'entity <entityId> 
      '    <intercalate("\n",[toString(field)|field<-fields])>
      '    identification
      '        key(<primaryKey>)
      end entity";
}

public str toString(PartitionedBy pb){
  return "@partitionedBy( <intercalate(",",["<ent.id> <intercalate("",[toString(t)|t<-ent.\type])>"|ent<-pb.prtByEntries])> )";
}

public str toString(clusteredBy(list[str] clstEntries, str \int)){
  return "@clusteredBy(<intercalate(",",["<ent>"|ent<- clstEntries])>) into <\int> buckets";
}

public str toString(FormatType ft){
  switch (ft){
   case serDe(str serdeEntry):{
    return "SERDE <serdeEntry>";
   }
   case delimitedFields(list[str] dlm, list[Lines] lines):{
   
    return "DELIMITED FIELDS TERMINATED BY <intercalate(",",["<ent>"|ent<- dlm])> <toString(lines)>";
   }
   default: throw ToStringException("message: Unable to resolve signature",ft);
  }
}

public str toString(list[Lines] ls){
  return "<intercalate(" ",["LINES TERMINATED BY <l.terminator>"|l<-ls])>";
}

public str toString(tableProperties(list[TableProperty] tblPty)){

  public str toString(tableProperty(str e1, str e2)){
    return "<e1> = <e2>";
  }  
  return "@tblProperties (<intercalate(",",[toString(tp)|tp<-tblPty])>)";
}

public str toString(storedAs(FileType fileType)){
  return "@storedAs(<toString(fileType)>)";
}

public str toString(FileType ft){
  switch(ft){
    case textFile():{
      return "TEXTFILE";
    }
    case orc():{
      return "ORC";
    }
    case parquet():{
      return "PARQUET";
    }
    case avro():{
      return "AVRO";
    }
    case jsonFile():{
      return "JSONFILE";
    }
    case rcFile():{
      return "RCFILE";
    }
    case sequenceFile():{
      return "SEQUENCEFILE";
    }
    default: throw ToStringException("message: Unable to resolve file type signature",asc);
  }
}
public str toString(entityExtends(
          list[Temporal] temporal
          ,list[External] ext
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , str baseId
        , list[Field] fields)){
  return "<intercalate("",["@temporal"|_<-temporal])>
          ' <intercalate("",["@extenal"|_<-ext])>
         '<intercalate("",["@ifNotExists"|_<-ifNotExists])>
         '<intercalate("",[toString(drp)| drp<-drop])>
         entity <entityId> extends <baseId> 
          <intercalate("\n",[toString(field)|field<-fields])>
  end entity";
}
public str toString(derived(str identifier, Type \type, Expr expr) ){
  
  return "<identifier>: <toString(\type)> = <toString(expr)>";
}
public str toString(Field f){
  switch(f){
    case field(str fieldId, Type \type, list[Constraints] constraints):{
      return "<fieldId>: <toString(\type)> <intercalate("",[toString(constraint)|constraint<-constraints])>";
    }
    case uniReference(str refId, Type \type):{
      return "<refId> -\> <toString(\type)>";
    }
    case biReference(str refId, Type \type, Reference ref, str identifier):{
      return "<refId> -\> <toString(\type)> inverse <toString(ref)>::<identifier>";
    }
    default: throw ToStringException("message: Unable to resolve signature",f);
  }
}

public str toString( constraints(list[Facet] facet)){
 return "(<intercalate(",",[toString(f)|f<-facet])>)";
}

public str toString(Facet f){
  switch(f){
    case required():{
      return "required";
    }
    case size(str \int):{
      return "size[ <\int>]";
    }
    case masked():{
      return "masked";
    }
    case redacted():{
      return "redacted";
    }
    default: throw ToStringException("message: Unable to resolve signature",f);
  }
}

public str toString(Reference r){
  switch(r){
    case objectType():{
      return "Object";
    }
    case referenceType(str entityName):{
      return "<entityName>";
    }
    case nullType():{
      return "Null";
    }
    default: throw ToStringException("message: Unable to resolve signature",r);
  }
}

public str toString(Drop d){
  switch(d){
    case drop():{
      return "@drop";
    }
    case dropIfExist():{
      return "@dropIfExist";
    }
    default: throw ToStringException("message: Unable to resolve signature",d);
  }
}

public str toString(qualifiedIdentifier(list[Identifier] ids)){
  return "<intercalate(".",[toString(id)|id<-ids])>";
}

public str toString(variables(list[ViewBinding] views)){
   return "variables
   '<intercalate(" ",[toString(v)|v<-views])>";
}

public str toString(SubViewDecl s){
    switch(s){
        case nestedSubViewDecl(SubViewDecl subView1, ViewRelationshipType viewRelType, SubViewDecl subView2):{
          return "<toString(subView1)>
              '<toString(viewRelType)>
              '<toString(subView2)>";
        }
        case subViewDecl(list[Distinct] distinct, list[ViewNameOrWildcard] viewNameOrWildcard
            , list[ViewField] viewFields, list[FilterOrEmpty] filterOrEmpty
            , list[GroupingOrEmpty] groupingOrEmpty, list[OrderByClauseOpt] orderByClsOpt, list[JoinConditions] joinConditions
            ):{
              return "view _ on <intercalate("",["distinct"|_<-distinct])> <intercalate("",[toString(vnw)|vnw<-viewNameOrWildcard])>
              '    attributes
              '        <intercalate("\n",[toString(vf)|vf<-viewFields])>
              '" + 
              
              trim("<intercalate("",[toString(foe)|foe<-filterOrEmpty])>
              '    <intercalate("",[toString(goe)|goe<-groupingOrEmpty])>
              '    <intercalate("",[toString(obc)|obc<-orderByClsOpt])>
              '    <intercalate("",[toString(jc)|jc<-joinConditions])>
              'end view")
              ;
            }
  }
      return "";
}


public str toString(TransformDecl td){
  switch(td){
    case createAction( 
        NameOrVariableRef name
        , list[Distinct] distinct
        , ViewNameOrWildcard viewWild
        , list[TAttribute] entries
        , list[TPartition] tp
        , list[ConstraintsOrEmpty] constr
        , list[FilterOrEmpty] filterEty
        , list[GroupingOrEmpty] grpEty
        , list[OrderByClauseOpt] orderOpt
        , list[JoinConditions] joinCond
        ): return "@create
              'transform <toString(name)> <intercalate("",["distinct"|_<-distinct])> with <toString(viewWild)>
              '    attributes
              '        <intercalate("",[toString(ta)|ta<-entries])>
              '"+
              trim("<intercalate("",[toString(t)|t<-tp])>
              '    <intercalate("",[toString(con)|con<-constr])>
              '    <intercalate("",[toString(foe)|foe<-filterEty])>
              '    <intercalate("",[toString(goe)|goe<-grpEty])>
              '    <intercalate("",[toString(obc)|obc<-orderOpt])>
              '    <intercalate("",[toString(jc)|jc<-joinCond])>
              'end transform");

    case updateAction(list[IfNotExists] ifNotExists, NameOrVariableRef name
        , list[Distinct] distinct, ViewNameOrWildcard viewWild, list[TAttribute] entries
        , list[TPartition] tp, list[ConstraintsOrEmpty] constr, list[FilterOrEmpty] filterEty
        , list[GroupingOrEmpty] grpEty, list[OrderByClauseOpt] orderOpt, list[JoinConditions] joinCond
        ):{
          return trim("@update <intercalate("",["@ifNotExists"|_<-ifNotExists])>
              'transform <toString(name)> <intercalate("",["distinct"|_<-distinct])> with <toString(viewWild)>
              '    attributes
              '        <intercalate("\n",[toString(ta)|ta<-entries])>
              '    <intercalate("",[toString(t)|t<-tp])>
              '    <intercalate("",[toString(con)|con<-constr])>
              '    <intercalate("",[toString(foe)|foe<-filterEty])>
              '    <intercalate("",[toString(goe)|goe<-grpEty])>
              '    <intercalate("",[toString(obc)|obc<-orderOpt])>
              '    <intercalate("",[toString(jc)|jc<-joinCond])>
              'end transform");
        }
    case directoryUpdateAction(list[IfNotExists] ifNotExists, LocalDirectory lclDir
        , Expr e, list[TAttribute] entries, list[TPartition] tp, list[ConstraintsOrEmpty] constr, list[JoinConditions] joinCond):{
          
          return trim("@update <intercalate("",["@ifNotExists"|_<-ifNotExists])>
              'transform <toString(lclDir)> <toString(e)>
              '    attributes
              '        <intercalate("",[toString(ta)|ta<-entries])>
              '    <intercalate("",[toString(t)|t<-tp])>
              '    <intercalate("",[toString(con)|con<-constr])>
              '    <intercalate("",[toString(jc)|jc<-joinCond])>
              'end transform ");
        }

    case directoryCreateAction(
        LocalDirectory lclDir
        , Expr e
        , list[TAttribute] entries 
        , list[TPartition] tp
        , list[ConstraintsOrEmpty] constr
        , list[JoinConditions] joinCond
        ):{
          return "@create 
              'transform <toString(lclDir)> <toString(e)>
              '    attributes
              '        <intercalate("",[toString(ta)|ta<-entries])>
              '    <intercalate("",[toString(t)|t<-tp])>
              '    <intercalate("",[toString(con)|con<-constr])>
              '    <intercalate("",[toString(jc)|jc<-joinCond])>
              'end transform";
        }
  }
  return "";
}

public str toString(updateAction(
        list[IfNotExists] ifNotExists
        , NameOrVariableRef name
        , list[Distinct] distinct
        , ViewNameOrWildcard viewWild
        , list[TAttribute] entries
        , list[TPartition] tp
        , list[ConstraintsOrEmpty] constr
        , list[FilterOrEmpty] filterEty
        , list[GroupingOrEmpty] grpEty
        , list[OrderByClauseOpt] orderOpt
        , list[JoinConditions] joinCond
        )){
          return "@update
              '" +
              "<trim("<intercalate("",["@ifNotExists"|_<-ifNotExists])>
              'transform")> <trim("<toString(name)> <intercalate("",["distinct"|_<-distinct])>")> with <toString(viewWild)>
              '    attributes
              '        <intercalate("\n",[toString(ta)|ta<-entries])>
              '    " +
              "<trim("<intercalate("",[toString(t)|t<-tp])>
              '    <intercalate("",[toString(con)|con<-constr])>
              '    <intercalate("",[toString(foe)|foe<-filterEty])>")>
              '    "+
              "<trim("<intercalate("",[toString(goe)|goe<-grpEty])>
              '    <intercalate("",[toString(obc)|obc<-orderOpt])>
              '    <intercalate("",[toString(jc)|jc<-joinCond])>
              'end transform")>";
}

public str toString(Relationship r){
  return "reference ( <toString(r.e)>) 
  '    <toString(r.c)>
  ";
}

public str toString(Cardinality c){
  switch(c){
    case manyToOne(str entityName, Expr e):{
      return ".manyToOne[<entityName>](<toString(e)>)";
    }
    case oneToMany(str entityName, Expr e):{
      return ".oneToMany[<entityName>](<toString(e)>)";
    }
    case manyToMany(str entityName, Expr e, list[JoinTable] jt):{
      return ".manyToMany[<entityName>](<toString(e)>)
    '<intercalate("",[toString(j)|j<-jt])>";
    }
    default: throw ToStringException("message: Unable to resolve Cardinality signature",c);
  }
}
public str toString(JoinTable jt){
  return ".joinTable(<toString(jt.e)>)";
}
public str toString(EnumField ef){
  switch(ef){
    case  enumField(str fieldName):{
      return "<fieldName> ,";
    }
    case labeledEnumField(str labeledFieldName, str \value):{
      return "<labeledFieldName> (<\value>),";
    }
    default: throw ToStringException("message: Unable to resolve signature",ef);
  }
}

public str toString( namedSubViewDecl(SubViewDecl subViewDecl, MandatoryAlias mandatoryAlias)){
  return "(<toString(subViewDecl)> )<toString(mandatoryAlias)>";
}

public str toString(MandatoryAlias ma){
  return "as <ma.name>";
}
public str toString(ViewDecl vds){
  switch(vds){
      case viewFromTransform( 
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , NameOrWildcard nameOrWildcard
        , list[Distinct] distinct 
        , ViewNameOrWildcard viewNameOrWildcard
        , TransformWithFile transformWithFile
        , TransformAttributes transformAttribute
        , list[FilterOrEmpty] filterOrEmpty
        , list[GroupingOrEmpty] groupingOrEmpty
        , list[OrderByClauseOpt] orderByClsOpt
        , list[JoinConditions] joinConditions
        ):{
          return "<trim("<intercalate("",["@ifNotExists"|_<-ifNotExists])> 
              '<intercalate("",[toString(drp)| drp<-drop])> 
              '<intercalate("",["@temporal"|_<-temp])>")>
              'view <toString(nameOrWildcard)> on
              '    <intercalate("",["distinct"|_<-distinct])> <toString(viewNameOrWildcard)>
              '    <toString(transformWithFile)>
              '    attributes
              '        <toString(transformAttribute)>
              '    <trim("<intercalate("",[toString(j)|j<-filterOrEmpty])>
              '    <intercalate(" ",[toString(j)|j<-groupingOrEmpty])> 
              '    <intercalate(" ",[toString(j)|j<-orderByClsOpt])> 
              '    <intercalate(" ",[toString(j)|j<-joinConditions])> 
              '")>
              'end view";
        }

    case viewDecl(
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , NameOrTemplate nameOrTemplate 
        , list[Distinct] distinct 
        , ViewNameOrWildcard viewNameOrWildcard
        , list[MixinsOrEmpty] mixinsOrEmpty
        , list[TranspositionFunction] transpositionFunction
        , list[ViewVariablesOrEmpty] viewVarOrEmpty
        , list[SubViewsOrEmpty] subViewsOrEmpty
        , list[ViewField] viewFields
        , list[FilterOrEmpty] filterOrEmpty
        , list[GroupingOrEmpty] groupingOrEmpty
        , list[OrderByClauseOpt] orderByClsOpt
        , list[JoinConditions] joinConditions
    ):{
      return "<trim("<intercalate("",["@ifNotExists"|_<-ifNotExists])> 
             '<intercalate("",[toString(drp)| drp<-drop])> 
             '<intercalate("",["@temporal"|_<-temp])>")>
             'view <toString(nameOrTemplate)> on 
             '    <intercalate("",["distinct"|_<-distinct])> <toString(viewNameOrWildcard)> <intercalate("",[toString(moe)|moe<-mixinsOrEmpty])>
             '    <trim("<intercalate("",[toString(tf)|tf<-transpositionFunction])>
             '    <intercalate("",[toString(vvoe)|vvoe<-viewVarOrEmpty])>
             '    <intercalate("",[toString(sv)|sv<-subViewsOrEmpty])>
             '    attributes
             '        <intercalate("\n",[toString(vf)|vf<-viewFields])>                  
             '    <trim(intercalate("",[toString(j)|j<-filterOrEmpty]))>
             '    <intercalate("",[toString(j)|j<-groupingOrEmpty])> 
             '    <intercalate("",[toString(j)|j<-orderByClsOpt])> 
             '    <intercalate("",[toString(j)|j<-joinConditions])>
             '")> 
             'end view";
    }
    default: throw ToStringException("message: Unable to resolve view Declaration signature",vds);
  }
}

public str toString( mixins(list[Trait] t)){
  return "with <intercalate(",",["<tr.name>"|tr<-t])>";
}

public str toString(TranspositionFunction tf){
  switch(tf){
    case pivot(list[PivotExpression] pivotExpr, str name, list[PivotAttribute] pivotAttr):{
        return trim("pivot
              '    attributes
              '        <intercalate("",[toString(pe)|pe<-pivotExpr])>
              '    for <name> in 
              '        <intercalate("",[toString(pe)|pe<-pivotAttr])>");
        }
    case unpivot(
        list[IncludeNulls] includeNulls
        , str name
        , UnpivotAttribute unpivotAttr
        , Unpivot unpivot
        ):{
          return "unpivot <intercalate("",["include nulls"| _<-includeNulls])>
          'for <name> in
          '    <toString(unpivotAttr)>
          '    <toString(unpivot)>";
        }
    case flatmap(str name, list[str] params, list[FilterOrEmpty] filterOrEmpty):{
      return "flatmap <name> ( <intercalate(",",[param | param <- params])>) <intercalate("",[toString(j)|j<-filterOrEmpty])>";
    } 
    case flatten(list[str] params, Expr e):{
      return "flatten into ( <intercalate(",",[param | param <- params])>) <toString(e)>";
    }
    default: throw ToStringException("message: Unable to resolve signature",tf);
  }
}

public str toString(PivotAttribute pa){
  return "<toString(pa.pc)> as (<intercalate(",",[toString(e)|e<-pa.el])>)";
}

public str toString(PivotColumn pc){
  switch(pc){
    case mapAlias(str strLit):{
      return "<strLit>";
    }
    case pivotColumn(str name):{
      return "<name>";
    }
    default: throw ToStringException("message: Unable to resolve signature",pc);
  }
}
public str toString(PivotElement pel){
  return "<pel.name> <intercalate("",[toString(a)|a<-pel.a])>";
}
public str toString(Unpivot up){
  return "for <up.name> in
        '    <toString(up.unpivotAttr)>";
}

public str toString(PivotExpression pe){
  switch(pe){
    case pivotExpression(str name, Type t, Expr e):{
      return "<name>: <toString(t)> =<toString(e)>";
    }
    case inferredPivotValue(str name, Expr e):{
      return "<name>=<toString(e)>";
    }
    default: throw ToStringException("message: Unable to resolve signature",pe);
  }
}
public str toString(unpivotAttribute(Expr e, PivotAlias p)){
  return "(<toString(e)>) <toString(p)>";
}

public str toString(PivotAlias pa){
  switch(pa){
    case mapAlias(str name, str k, str v):{
      return "<name> as <k>,<v>";
    }
    case listAlias(str name, str l):{
      return "<name> as <l>";
    }
    default: throw ToStringException("message: Unable to resolve signature",pa);
  }
} 
public str toString(variables(list[ViewBinding] views)){
  return "variables
        '    <intercalate("\n",[toString(view)|view <-views])>";
}
public str toString(subViews(list[ViewDecl] views)){
  return "views
        '    <intercalate(" ",[toString(view) | view <-views])>";
}
public str toString(TransformAttribute tra){
  switch(tra){
    case typedTransformAttribute(str name, Type t):{
      return "<name>:<toString(t)>";
    }
    case transformAttribute(str oname):{
      return "<oname>";
    }
    default: throw ToStringException("message: Unable to resolve signature",tra);
  }
}
public str toString(NameOrTemplate not){
  switch(not){
    case templatedName(str templName):{
      return "${<templName>}";
    }
    case viewName(str name):{
      return "<name>";
    }
    default: throw ToStringException("message: Unable to resolve signature",not);
  }
}
public str toString(transformAttributes(
        list[TransformAttribute] attrs
        )){
  
  return "<intercalate("",[toString(att)|att<-attrs])>";
}
public str toString(transformWithFile(list[QualifiedIdentifier] qid, str strLit)){
  return "transform(<intercalate(",",[toString(q)|q<-qid])>) with <strLit>";
}
public str toString(NameOrWildcard now){
  switch(now){
    case noWildcardOrName():{
      return "_";
    }
    case wildcardOrName(str name):{
      return "<name>";
    }
    default: throw ToStringException("message: Unable to resolve signature",now);
  }
}

public str toString(Identifier id){
  switch(id){
    case varRefName(str name):{
      return "${\" <name> \"}";
    }
    case regularIdentifier(str name):{
      return "<name>";
    }
    case quotedIdentifier(str name ):{
      return "`\" <name> \"`";
    }
    default: throw ToStringException("message: Unable to resolve Identifier signature",id);
  }
}

public str toString(FilterOrEmpty foe){
 
  return "filter <toString(foe.e)>";
}
public str toString(grouping(GroupByClauseOpt g, list[HavingClauseOpt] hs)){
  return "<toString(g)> <intercalate("",[toString(h)|h<-hs])>";
}
public str toString(ViewField vf){
  switch(vf){
    case starAttribute():{
      return "*";
    } 
    case starAttributeWithQID(str name):{
      return "<name>.*";
    }
    case attributeWithAlias(Expr e, QualifiedIdentifier q):{
      return "<toString(e)> as <toString(q)>";
    }
    case derivedAttribute(str oname, Type ty, Expr e):{
      return "<oname> : <toString(ty)> = <toString(e)>";
    }
    case inferredDerivedAttribute(str oname, Expr e):{
      return "<oname> = <toString(e)>";
    }
    case viewAttribute(str oname, SubViewDecl subViewDecl):{
      return "<oname> = (<toString(subViewDecl)>)";
    }
    case viewfieldqname(QualifiedNameOrShortName qshortname):{
      return "<toString(qshortname)>";
    }
    case blackList(list[str] qid):{
      return "except <intercalate(",",[q|q<-qid])>";
    }
    default: throw ToStringException("message: Unable to resolve View Field signature",vf);
  }
}

public str toString(namedStructExp(list[NamedStructEntry] namedStructEntry, list[Alias] allist)) = "named_struct (<intercalate("",[toString(ent)|ent<-namedStructEntry])> ) <intercalate("",[toString(al)|al<-allist])>";
public str toString(referenceName(str name1, str name2, list[Alias] allist)) = "${<name1>}.<name2>  <intercalate("",[toString(al)|al<-allist])>";
public str toString(templatedView(QualifiedNameOrShortName qid)) = "${<toString(qid)>}";
public str toString(parentView(ViewDecl viewDecl)) = "<toString(viewDecl)>";
public str toString(wildcard(SubViewDecl subViewDecl)) = "(<toString(subViewDecl)>)";
public str toString(wildcardWithAlias(SubViewDecl subViewDecl, Alias al)) = "(<toString(subViewDecl)>) <toString(al)>";
public str toString(name(QualifiedNameOrShortName qid, list[Alias] allist)) = "<toString(qid)> <intercalate("",[toString(al)|al<-allist])>";

public str toString(\alias(str name)) = "as <name>";

public str toString(QualifiedNameOrShortName qualifiedshortname){
  switch(qualifiedshortname){
    case sName(str name):{
      return "<name>";
    }
    case qName(str name, str projection):{
      return "<name>.<projection>";
    }
    default: throw ToStringException("message: Unable to resolve signature",qualifiedshortname);
  }
}

 public str toString(NamedStructEntry nse){
   return "<toString(nse.identifier)>, <toString(nse.e)>";
}
public str toString(ViewRelationshipType vrt){
  switch(vrt){
    case union(): return "union";
    case intersect(): return "intersect";
    case unionAll(): return "union all";
     default: throw ToStringException("message: Unable to resolve relationship signature",vrt);
  }
 
}

public str toString(JoinConditions jc){
  return "<intercalate("",[toString(j)|j<-jc.conds])>";
}
public str toString(JoinCondition jc){
  switch(jc){
    case joinCondition(JoinType jt, NameOrVariableRef nam, list[Alias] as, list[OnCondition] cond):{
      return trim("<toString(jt)> <toString(nam)> <intercalate("",[toString(a)|a<-as])> <intercalate("",["on <toString(c.e)>"|c<-cond])>");
    }
    case viewJoinCondition(JoinType jt, SubViewDecl sub, MandatoryAlias m, Expr expr):{
      return "<toString(jt)> (<toString(sub)>) <toString(m)> on (<toString(expr)>)";
    }
    default: throw ToStringException("message: Unable to resolve signature",jc);
  }
}

public str toString(JoinType jt){
  switch(jt){
    case \join():{
      return "join";
    }
    case inner():{
      return "inner join";
    }
    case leftOuterJoin():{
      return "left outer join";
    }
    case rightJoin():{
      return "right join";
    }
    case rightOuterJoin():{
      return "right outer join";
    }
    case fullJoin():{
      return "full join";
    }
    case fullOuterJoin():{
      return "full outer join";
    }
    case crossJoin():{
      return "cross join";
    }
    case semiJoin():{
      return "semi join";
    }
    default: throw ToStringException("message: Unable to resolve join type signature",jt);
  }
}
public str toString(ViewBinding vb){
  switch(vb){
    case viewBinding(str oname, Type ty):{
      return "<oname>:<toString(ty)>";
    }
    case viewBindingInit(str oname, Type ty, Expr e):{
      return "<oname>:<toString(ty)>=<toString(e)>";
    }
    case  viewBindingInferredInit(str oname, Expr e):{
      return "<oname>=<toString(e)>";
    }
    default: throw ToStringException("message: Unable to resolve signature",vb);
  }
}
public str toString(Url url){
  switch(url){
    case url(list[SchemePart] schemePart, DirectoryPart dirPart, FileNamePart filePart):{
      return "<intercalate("",[toString(sp)|sp<-schemePart])> <toString(dirPart)> <toString(filePart)>";
    }
    case urlVarReference(str varRef):{
      return "${<varRef>}";
    }
    default: throw ToStringException("message: Unable to resolve signature",url);
  }
}

public str toString(DirectoryPart dp){
  return "<intercalate("/",[toString(d)|d<-dp])>";
}

public str toString(DirectoryPath dp){
  switch(dp){
    case directoryName(str dirName):{
      return "<dirName>";
    }
    case aSubstitutedText(str subText):{
      return "${<subText>}";
    }
  default: throw ToStringException("message: Unable to resolve signature",dp);
  }
}
public str toString(FileNamePart fp){
  return "<fp.file>.<fp.ext>";
}
public str toString(SchemePart _ ){
  return "hdfs://";
}
public str toString(GroupByClauseOpt url){
  return "group by <intercalate(",",[toString(e)|e<-url.el])>";
}
public str toString(HavingClauseOpt url){
  return "having <toString(url.e)>";
}
public str toString(LocalDirectory lcd){
  switch(lcd){
    case local():{
      return "Local Directory";
    }
    case nonLocal():{
      return"Directory";
    }
    default: throw ToStringException("message: Unable to resolve signature",lcd);
  }
}

public str toString(NameOrVariableRef nvr){

  switch(nvr){
    case refName(str name, list[Path] paths):{
      return "${ <name> } <intercalate(" ",[toString(path)|path<-paths])>";
    }
    case tName(str name, list[Path] paths):{
      return "<name> <intercalate(" ",[toString(path)|path<-paths])>";
    }
    default: throw ToStringException("message: Unable to resolve signature",nvr);
  }
}
public str toString(Path p){
  return ".<p.name>";
}
public str toString(TAttribute ta){
  switch(ta){
    case starTAttribute():{
      return "*";
    }
    case starTAttributeWithQID(str name):{
      return "<name>.*";
    }
    case tAttributeWithAlias(Expr e, QualifiedIdentifier q):{
      return "<toString(e)> as <toString(q)>";
    }
    case derivedTAttribute(str oname, Type ty, Expr e):{
      return "<oname> : <toString(ty)> = <toString(e)>";
    }
    case inferredDerivedTAttribute(str oname, Expr e):{
      return "<oname> = <toString(e)>";
    }
    case viewAttribute(str oname, SubViewDecl subViewDecl):{
      return "<oname> = (<toString(subViewDecl)>)";
    }
    case tattributeqname(QualifiedNameOrShortName qshortname):{
      return "<toString(qshortname)>";
    }
    case blackList(list[str] qid):{
      return "except <intercalate(",",[q|q<-qid])>";
    }
  default: throw ToStringException("message: Unable to resolve table attribute signature",ta);
  }
}

public str toString(referenceType(e)){
  return "<e>";
}
public str toString(Type ty){
  switch(ty){
    case booleanType():{
      return "Bool";
    }
    case stringType():{
      return "Str";
    }
    case dateTimeType():{
      return "Datetime";
    }
    case dateType():{
      return "Date";
    }
    case \setType(Type t):{
      return "Set[<toString(t)>]";
    }
    case \mapType(Type k , Type v):{
      return "Map[ <toString(k)> , <toString(v)>]";
    }
    case \listType(Type t):{
      return "List[<toString(t)>]";
    }
    case \tupleType(list[Type] ty):{
      return "Tuple[<intercalate(",",[toString(t)|t<-ty])> ]";
    }
    case objectType():{
      return "Object";
    }
    case nullType():{
      return "Null";
    }
    default: throw ToStringException("message: Unable to resolve Type signature",ty);
  }
}
public str toString(tPartition(list[TPartitionOn] tPartitionOn)){
  return "partition ( <intercalate(",",[toString(t)|t<-tPartitionOn])>)";
}
public str toString(ConstraintsOrEmpty coe){
  return "constraints
         '<toString(coe.e)>";
}

public str toString(tPartitionOn(str name, TPartitionValue p)){
  return "<name> <toString(p)> ";
}

public str toString(TPartitionValue tpv){
  return "= <toString(tpv.e)>";
}
public str toString(renameEntity(QualifiedIdentifier q1, QualifiedIdentifier q2)){

  return "transform <toString(q1)> rename <toString(q2)>";
}

public str toString(Expr::identifier(list[str] nms)){
    
    return "<intercalate(".",[nm|nm<-nms])>";
}