module lang::configlang::minproject::Util
import lang::hql::Utils;
import lang::spark::translations::Spark;
import lang::hql::translations::translate2ptl::TranslateProgram;
import lang::ptl::prettyprint::PTL;
import IO;
import String;
import List;
import lang::ptl::Utils;
import util::FileSystem;
import lib::Utils;
import lang::ptl::translations::EntitytoMapping;


//This file is to automatically generate the EL and PTL


public str generatePTL(loc input){
    
    ast = loadHQL(input);
    // println(ast);
    ptlAst = toPTL(ast);
    ptlScript =toString(ptlAst);
    return ptlScript;
}


void main(){
  project_dir =|project://adept-base/src/lang/configlang/minproject/src/scripts/hive/hive_incremental_update|;
  allScript = files(project_dir);
  
  void writeTodirectory(loc model){
    ptlFile= generatePTL(model);
    writeFile(|project://adept-base/milestones/milestone_XX1/tpcdi_abbrev/models/<baseName(model)>.ptl|,ptlFile);
   
  }
  for(script <- allScript){
    println(script);
    writeTodirectory(script);
  }

} 

void generateMappingofEntity(){
 loc entLoc = |project://adept-base/milestones/milestone_XX1/tpcdi_abbrev/models/create_staging_schema_hive.ptl|;
 Program ptlAst = loadPTL(entLoc);

  entityMappings = generate(ptlAst);
   ptlScript =toString(entityMappings);
    writeFile(|project://adept-base/milestones/milestone_XX1/tpcdi_abbrev/mappings.ptl|,ptlScript);

}

void getViews(){
  project_dir =|project://adept-base/src/lang/configlang/minproject/src/scripts/hive/hive_createview_update|;
  allScript = files(project_dir);
  // // println(allScript);

  void writeTodirectory(loc model){
    ptlFile= generatePTL(model);
    writeFile(|project://adept-base/milestones/milestone_XX1/tpcdi_abbrev/models/realtime/<baseName(model)>.ptl|,ptlFile);
   
  }
  for(script <- allScript){
    
    writeTodirectory(script);
  }

}

void generatePar(){
   mappingFile=|project://adept-base/milestones/milestone_XX1/tpcdi_abbrev/models/batch/config/mappings.ptl|;
   ast= loadPTL(mappingFile).decls;
  
  println(ast);

  void writeTodirectory(entityMapping(str _, str tableName, list[MappingBody] mappingBody)){

     MappingBody sch = [body|body<-mappingBody,mappingSchema(_):=body][0];
     MappingBody tabl = [body|body<-mappingBody,mappingTable(_):=body][0];
      attributes = [body.mapAttrs|body<-mappingBody,mappingAttributes(_):=body][0];
    str  content = "--hive-table \n <toString(sch)>.<toString(tabl)> \n--map-column-hive \n<intercalate(",",["<replaceAll(att.mapName,"\"","")>= <toString(att.attrType)>"|att<-attributes])>"; 
   
    
    writeFile(|project://adept-base/milestones/milestone_XX1/tpcdi_abbrev/models/batch/config/sqoop/<tableName>.par|,content);
   
  }
 
 for(scripts <- ast){
    println(scripts);
    writeTodirectory(scripts);
  }
}