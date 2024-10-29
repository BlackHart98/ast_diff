module lib::Functools

import IO;
import String;
import List;
extend Exception;

import lang::orc::utils;

import lang::hql::ast::HQL;
import lang::spark::ast::Spark;
import lang::python::ast::Python;

import lang::orc::utils;
import lang::ptl::Utils;
import lang::python::utils::Implode;

import lang::ptl::translations::translate2hql::TranslateDeclarations;
import lang::ptl::translations::translate2Spark::TranslateDeclarations;
import lang::orc::translations::translateAirflow::Orc;
import lang::json::IO;
import lib::Utils;


// Pipeline 
data Pipeline 
    = _pipe_(str name, &B(&A) function, str desc);



// the functions in this `compose`` must be composable 
&C compose(&T input, Pipeline pipelines...) 
    = (input | pipeline.function(it) | pipeline <- pipelines);




void writeToOutputSubDir(
	lrel[loc script_location, str script_content] result
	, str project_dir="" 
	, str target_folder = ""
	, str project = ""){
	project_dir = toLowerCase(project_dir);

	str project_dir_ = intercalate("/", split("/", project_dir)[..-2]);
	for (t <- result){
		temp = toLowerCase(t.script_location.authority + t.script_location.path);
    
		loc writeLocation = |file://<replaceFirst(temp, project_dir, "<project>/<target_folder>")>|;
		writeFile(writeLocation, t.script_content);
	}
}


data Result[&T] = 
  ok(&T \value)
  | error(
	  tuple[str message, RuntimeException ex] exception
	)  
  ;


data Either[&A, &B] = 
  left(&A left)
  | right(&B right)  
;

&Z(&A) compose(&B(&A) f1, &D(&C) f2...){
  &W(&U) _compose(&T(&U) func, &W(&T) func2) = &W(&T x){
		return func2(func(x));
	};
  return (&B(&A x){return f1(x);} | _compose(it, f) | f <- f2);
}

Result[&B](Result[&A]) bind(Result[&B](&A) f){
  Result[&B] _adapt(Result[&A] double_track){
    if (ok(_) := double_track){
      return f(double_track.\value);
    } else {
      return double_track;
    }
  }
  return _adapt;
}

public loc transformExtension(loc l, str dialect) {
  l.extension = dialect;
  return l;
    
}


public Module getAirflowAst (loc file) {
    orcAst = getOrcAst(file);
    return toAirflow(orcAst);
}


loc changeExt(loc ext, str ext_target="xml"){
    if (/orc/ := ext.extension) {
        ext.extension = ext_target;
    }
    return ext;
}
loc renameExt(loc l){
        l.extension = "py";
        return l;
}

public map[str, value] buildReport(Result[&U] result){
  if(ok(_) := result){
    map[str, value] output = ("status": "success", "message": "build successful.");
    return output;
  } else {

    map[str, value] output = ("status": "error", "message": result.exception.message);
    tuple[str, RuntimeException] exception = result.exception;

    switch(exception){
      case TranslationException(error_summary, ast_node): {
          output = output + ("error": ("summary": error_summary, "location": resolveLocation(ast_node) ));
      }
      case ToStringException( error_summary, ast_node ): {
          output = output + ("error": ("summary": error_summary, "location": resolveLocation(ast_node) ));
      }
      case ParseError( location ): {
          output = output + ("error": ("summary": "Parse error", "location": location ));
      }
      case PathNotFound( location ): {
          output = output + ("error": ("summary": "Path not found", "location": location ));
      }
      case NoSuchKey( key ): {
          output = output + ("error": ("summary": key, "location": ""));
      }
      case UnrecognizedDialect( error_summary ): {
          output = output + ("error": ("summary": error_summary, "location": "" ));
      }
      case UnrecognizedCommand( error_summary ) : {
          output = output + ("error": ("summary": error_summary, "location": "" ));
      }
      case IO( msg ) : {
          output = output + ("error": ("summary": msg, "location": "" ));
      }
      case BuildConfigException( msg ): {
          output = output + ("error": ("summary": msg ));
      }
      default: output = output + ("error": ("summary": "undefined error"));
    }
    return output;
  }
}

public void(value) _writer(loc location=|unknown:///|, bool unpackedLocations=true){
  return void(value v) {return writeJSON(location, v, unpackedLocations=unpackedLocations);};
}



public void sendReport(list[Result[&U]] results, void(&T) writer = println){
  list[map[str, value]] outcome = [];
  for(Result[&U] x <- results){
    outcome = outcome + buildReport(x);
  }
  writer(outcome);
}

public str sendReportAsJSON(list[Result[&U]] results){
  list[map[str, value]] outcome = [];
  for(Result[&U] x <- results){
    outcome = outcome + buildReport(x);
  }

  str json = toJSON(outcome, true);
  println(json);
  return json;
}

void tryToWriteToOutput(tuple[Result[&T] scripts, Result[&T] orc_scripts, str project_dir, str project_name] result){
    if(ok(_) := result.scripts && ok(_) := result.orc_scripts){
        writeToOutputSubDir(
            result.scripts.\value
            , project_dir=result.project_dir+"/models/scripts"
            , target_folder = "models/scripts"
            , project = result.project_name
        );

        writeToOutputSubDir(
            filtr(result.orc_scripts.\value, category= "tasks")
            , project_dir=result.project_dir+"/orchestration/tasks"
            , target_folder = "orchestration/workflows"
            , project = result.project_name
        );
        writeToOutputSubDir(
            filtr(result.orc_scripts.\value, category= "coordinators")
            , project_dir=result.project_dir+"/orchestration/coordinators"
            , target_folder = "orchestration/coordinators"
            , project = result.project_name
        );
        writeToOutputSubDir(
            filtr(result.orc_scripts.\value, category= "schedulers")
            , project_dir=result.project_dir+"/orchestration/schedulers"
            , target_folder = "orchestration/bundles"
            , project = result.project_name
        );


        // Reverse
        writeToOutputSubDir(
            filtr(result.orc_scripts.\value, category= "bundles")
            , project_dir=result.project_dir+"/orchestration/bundles"
            , target_folder = "orchestration/schedulers"
            , project = result.project_name
        );
        writeToOutputSubDir(
            filtr(result.orc_scripts.\value, category= "workflows")
            , project_dir=result.project_dir+"/orchestration/workflows"
            , target_folder = "orchestration/tasks"
            , project = result.project_name
        );
    }
}


void checkThenReport(tuple[Result[&T] scripts, Result[&T] orc_scripts, str project_dir, str target_name] result){
  if(<ok(_), ok(_), _, _> := result){
    tryToWriteToOutput(result);

    list_ok = [r | r <- result, ok(_) := r];
    sendReportAsJSON(list_ok);
  }
  else{
      list_err = [r | r <- result, error(_) := r];
      sendReportAsJSON(list_err);
  }

}
