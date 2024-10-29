module lib::Utils

import String;
import Exception;
import ParseTree;

import IO;

import lang::json::IO;
import lang::json::ast::JSON;
import Map;
import Exception;


public str replaceTemplateValues(map[str, str] params, 
                                 loc template = |project://adept-base/src/lang/dockercompose/examples/docker-compose.yaml|)
{
   str yaml_content = ""; 
   try {
       yaml_content = readFile(template);
       for (<key, val> <- toList(params)){
         yaml_content = replaceAll(yaml_content, "<key>", "<val>");
       }
    }
    catch NoSuchKey(e): 
        println("Invalid key: <e>");
    catch IO(e):   
        println("File not found: <e>");

    return yaml_content;
}

public void writeTemplate(str content, loc output = |project://adept-base/src/lang/dockercompose/examples/output.yaml|){
  try {
      writeFile(output, content);
    }
    catch IO(e):   
        println("File not found: <e>");
}


public str baseName(loc l, str ext="hql") {
	if (/\/<base:[a-zA-Z0-9_]+>\.<ext>$/ := l.path) {
		return base;
	}
	throw "Could not match basename in <l.path>";
}

public lrel[loc script_location, str script_content] filtr(&U input, str category= "tasks"){
    lrel[loc script_location, str script_content] oozie_list = input;
    str getCategory(loc _file){
      return split("/", _file.path)[-2];
    }
    return [x|x <- oozie_list, getCategory(x.script_location) == category];
}

public bool tryParse(type[&T <: Tree] tree, type[&U] ast, loc l) {
  try {
    code_pt = parse(tree, l);
    code_ast = implode(ast, code_pt);
    }
  catch ParseError(_):{
      return false;
   }
  return true;
}

data RuntimeException 
	= TranslationException(str error_summary, &T location_or_node) 
	| ToStringException(str error_summary, &T ast_node) 
	| UnrecognizedDialect(str error_summary) 
	| UnrecognizedCommand(str error_summary) 
  | BuildConfigException(str msg )
  // TODO: | MacroExpansionException(str error_summary, loc call_location, loc macro_location)
  | MacroExpansionException(str error_summary, loc location)
	;


@description{
  Takes a script_path as input, removes # in script_path and replaces the script_path in Oozie format to accessible file format and returns the new script_path
}
public loc replaceLoc(str file_loc){
  new_loc = stripQuote(file_loc);
  req_loc = resolveLocation(|cwd:///<new_loc>|);
  return req_loc;
}

str stripQuote(str x) = replaceLast(replaceFirst(x, "\"", ""),"\"", "");


data Request = ArgRequest(Action action, str projectLoc, Dialect dialect, Orchestration orchestration, str targetLoc)
               | MigrateArgs(Action action,str projectLoc,str targetName,str targetDialect, str targetOrc, str targetPlatform,str configLoc, str config);

data Dialect
    = Hive()
    | Spark()
    | BigQuery()
    | PTL()
    | UnknownDialect(str dialect)
    ;

data Orchestration
    = Oozie()
    | Airflow()
    | Orc()
    | UnknownOrc(str orc)
    ;

data Action
    = Build()
    | ReverseInit()
    | Migrate()
    | UnknownAction(str action)
    ;

data TargetOpt
    = Dialect(str dialect)
    | Orchestration(str orchestration)
    ;

Action toAction(str action) {
  switch (action) {
    case "build": return Build();
    case "reverse": return ReverseInit();
    case "migrate": return Migrate();
    default: return UnknownAction(action);
  }
}
Dialect toDialect(str dialect) {
  switch (dialect) {
    case "hive": return Hive();
    case "spark": return Spark();
    case "ptl": return PTL();
    default: return UnknownDialect(dialect);
  }
}
Orchestration toOrchestration(str orc) {
  switch (orc) {
    case "oozie": return Oozie();
    case "airflow": return Airflow();
    default: return UnknownOrc(orc);
  }
}


public Request parseRequest(str jsonString){
    json = fromJSON(#JSON, jsonString);

    action = json.properties["action"].s;
    project_dir = json.properties["project-location"].s;
    config_loc = json.properties["config-location"].s;

    // Read the config file sent from the request
    new_file = readFile(|file:///<config_loc>|);
    config_json = fromJSON(#JSON, new_file);
  
    // Check if target-location is part of request
    if( Migrate() := toAction(action) ){ 
      str new_name = json.properties["target-project-name"].s;
      str new_dialect = json.properties["target-project-dialect"].s;
      str new_orchestration = json.properties["target-project-orchestration"].s;
      str new_platform = json.properties["target-project-platform"].s;
      return MigrateArgs(toAction(action), project_dir,new_name,new_dialect, new_orchestration, new_platform,config_loc,new_file);
    } 
    else {
        str sqldialect = config_json.properties["target"].properties["dialect"].s;
        str orc_target = config_json.properties["target"].properties["orchestration"].s;

      return "target-location" in json.properties 
        ? ArgRequest(toAction(action), project_dir, toDialect(sqldialect), toOrchestration(orc_target), json.properties["target-location"].s) 
        : ArgRequest(toAction(action), project_dir, toDialect(sqldialect), toOrchestration(orc_target), project_dir+"/target");
    }

}
