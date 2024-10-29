module lang::orc::translations::translateAirflow::Orc

import lang::xml::DOM;
import util::FileSystem;
import IO;
import String;
import List;
import util::ShellExec;





str o2a_home = "src/oozie-to-airflow"; 
str o2a_orches = "src/oozie-to-airflow/orchestration_2"; 
str bundle_file = "src/oozie-to-airflow/orchestration_2/bundle.xml"; 
str bundle_name = "bundle.xml"; 
loc static_config_prop = |cwd:///<"src/oozie-to-airflow/orchestration_2/configuration.properties">|;

node parseBundleFile(str file_loc=bundle_file) {
    return parseXMLDOM(readFile(|cwd:///<file_loc>|));
}



list[str] getAppPath(node tree = parseBundleFile()) {
    list[str] coordinator_list = [];
    visit(tree) {
        case element(none(), "app-path", [charData(requiredName)]):
            coordinator_list += requiredName;
      }
      return coordinator_list;
}

list[loc] getCoord() {
    list[str] coords = getAppPath();
    list[loc] loc_coord = [|cwd:///<o2a_orches>/<coord>| |coord<-coords];
    return loc_coord;
}

list[node] parseCoordinatorFile() {
    list[loc] parsecoords = getCoord();
    return [parseXMLDOM(readFile(parsecoord)) | parsecoord <- parsecoords]; 
}

map[str, list[str]] processDatasets(list[node] trees = parseCoordinatorFile()) {

    map[str, list[str]] dataset_dict = ( );

    for(tree<-trees){
        str name = "";
        str frequency = "";
        str dataset_uri = "";

        visit(tree){
            case attribute(none(), "name", dataset_name):
                name = dataset_name; 

            case attribute(none(), "frequency", dataset_frequency):
                frequency = dataset_frequency;
                            
                            
            case element(_, "uri-template", [charData(uriText)]):
                dataset_uri = uriText;           
        }

        dataset_dict += (name : [frequency, dataset_uri]);

    } 

    return dataset_dict;

}

list[str] ExtractWorkFlow(list[node] trees = parseCoordinatorFile()){
    list[str] workflowNames = [];

    for(tree<-trees){
        visit(tree) {
             case element(none(), "app-path", [charData(workflowName)]):
             workflowNames += o2a_orches + "/" + workflowName;
            }
    }
    return workflowNames;

}
list[loc] transformWorkflow(){
    list[str] workflows = ExtractWorkFlow();
    list[loc] loc_workflow = [|cwd:///<workflow>| |workflow<-workflows];
    return loc_workflow;

}


list[node] parseWorkflowFile() {
    list[loc] parseworkflows = transformWorkflow();
    return [parseXMLDOM(readFile(parseworkflow)) | parseworkflow <- parseworkflows]; 
}

list[str] getInputDatasetList(list[node] trees = parseCoordinatorFile()) {

    list[str] input_dataset_lst = [];
    str dataset = "n/a";
    str start_instance = "n/a";
    str end_instance = "n/a";
    str instance = "n/a";
    str cordinator_name = "";
    
    
    for(tree<-trees){
        visit(tree) {

        case element(_, "data-in", children):
            for (attribute(_, "dataset", datasetValue) <- children) {
                dataset = datasetValue;
            }

        case element(_, "start-instance", [charData(startValue)]):
            start_instance = startValue;

        case element(_, "end-instance", [charData(endValue)]):
            end_instance = endValue;

        case element(_, "instance", [charData(instanceValue)]):
            instance = instanceValue;
        
        case element(none(), "app-path", [charData(requiredName)]):
                cordinator_name = requiredName;
    }

    input_dataset_lst += dataset + "|" + start_instance + "|" + end_instance + "|" + instance + "|" + cordinator_name + "|" + bundle_name;

    }

    return input_dataset_lst;
    
}

map[str, set[str]] processJobProperties(list[node] trees = parseWorkflowFile()) {

     map[str, set[str]] job_properties_dict = ();

     for (tree <- trees) {
        str document_name = "";
        list[str] job_props_list = [];

        visit(tree) {
            case element(_, "workflow-app", workflow_children): 
                for (attribute(none(), "name", docName) <- workflow_children) {
                    document_name = docName;
                }
                

            case element(_, "configuration", config_children):
                for (element(_, "property", property_children) <- config_children) { 
                    str prop_name = "";
                    str prop_value = "";

                    for (element(_, "name", [charData(name_value)]) <- property_children) {
                        prop_name = name_value;
                    }

                    for (element(_, "value", [charData(value_value)]) <- property_children) {
                        prop_value = value_value;

                    }
                    job_props_list += prop_name + "=" + prop_value;
                    toSet(job_props_list);
            }
           
            
        }
        
        job_properties_dict += (replaceAll(document_name, "-", "") : toSet(job_props_list));  

                
    }
    return job_properties_dict;
}

list[str] ExtractWorkFlowDags(list[node] trees = parseCoordinatorFile()){
    list[str] workflowNames = [];

    for(tree<-trees){
        visit(tree) {
             case element(none(), "app-path", [charData(workflowName)]):
             workflowNames +=workflowName;
            }
    }
    return workflowNames;

}
str processFileName(str fileName) {
    str baseName = replaceLast(fileName, ".xml", "");

    return replaceAll(baseName, "workflow-", "");
}


list[str] ExtractWorkFlowWithProcessedNames() {
    list[str] fileNames = ExtractWorkFlowDags();
    
    return [processFileName(fileName) | fileName <- fileNames];
}            


list[str] createDagDirectories() {
    list[str] dagNames = ExtractWorkFlowWithProcessedNames();
    list[str] directory_locs = [];

    for (str dagName <- dagNames) {
        loc o2p_dir_hdfs = |cwd:///<o2a_home + "/examples/" + dagName + "/hdfs">|; 
        loc o2p_dir_base = |cwd:///<o2a_home + "/examples/" + dagName>|; 
        str o2p_dir_hdfs_str = o2a_home + "/examples/" + dagName + "/hdfs";
        directory_locs += o2p_dir_hdfs_str;
         
        try {
            mkDirectory(o2p_dir_hdfs); 
            println("Directory created: <o2p_dir_hdfs>");
        }
        catch PathNotFound(_): {
            println("Path not found: <o2p_dir_hdfs>");
        }
        catch IO(_): {
            println("IO error while creating directory: <o2p_dir_hdfs>");
        }
        catch: {
            println("An unexpected error occurred while creating directory: <o2p_dir_hdfs>");
        }
        finally {
            println("Attempted to create directory: <o2p_dir_hdfs>");
        }
        copyFile(static_config_prop, o2p_dir_base+"/configuration.properties");
    }
    return directory_locs;
    
}


map[str, list[str]] extractWorkflowScriptsMap(list[node] workflows = parseWorkflowFile()) {
    map[str, list[str]] workflowScriptsMap = ();

    for (workflow <- workflows) {
        str workflowName = "";  
        list[str] scriptPaths = [];  

        visit (workflow) {
            case element(_, "workflow-app", attributes): 
                workflowName = [val | attribute(_, "name", val) <- attributes][0]; 

            case element(_, "script", [charData(filePath)]):
                scriptPaths += filePath;
        }


        if (workflowName != "") {
            workflowScriptsMap[workflowName] = scriptPaths;
        }
    }

    return workflowScriptsMap;
}



void copyFile(){
    list[str] directory_hdfs = createDagDirectories();
    list[loc] fileNames = transformWorkflow();
    list[str] dagNames = ExtractWorkFlowWithProcessedNames();

    map[str, list[str]] workflowScriptsMap = extractWorkflowScriptsMap();

    map[str, list[str]] workflowScriptsMapNoDashes = ();

    for (str key <- workflowScriptsMap) {
        str keyNoDashes = replaceAll(key, "-", "");
        workflowScriptsMapNoDashes[keyNoDashes] = workflowScriptsMap[key];
    }

    for (int i <- [0 .. size(fileNames)]) {
        str directory = directory_hdfs[i];     
        loc file_to_copy = fileNames[i];       
        loc destination = |cwd:///<directory + "/workflow.xml">|;  

        try {
            mkDirectory(|cwd:///<directory>|);
            println("Directory created: <" + directory + ">");
        }
        catch PathNotFound(_): {
            println("Path not found: <" + directory + ">");
        }
        catch IO(_): {
            println("IO error while creating directory: <" + directory + ">");
        }
        finally {
            println("Attempted to create directory: <" + directory + ">");
        }

        copyFile(file_to_copy, destination);
        println("workflow.xml file copied: <" + file_to_copy + "> to <" + destination + ">");

        str workflowName = dagNames[i];
        if (workflowName in workflowScriptsMapNoDashes) {
            list[str] scriptPaths = workflowScriptsMapNoDashes[workflowName];

            for (str scriptPath <- scriptPaths) {
                loc sourceFile = |cwd:///<o2a_orches + "/" + scriptPath>|;

                str fileName = scriptPath;

                loc hqlDestination = |cwd:///<directory + "/" + fileName>|;

                try {
                    copyFile(sourceFile, hqlDestination);
                    println("File copied: <" + sourceFile + "> to <" + hqlDestination + ">");
                }
                catch PathNotFound(_): {
                    println("Path not found when copying file: <" + sourceFile + ">");
                }
                catch IO(_): {
                    println("IO error while copying file: <" + sourceFile + ">");
                }
                finally {
                    println("Attempted to copy .hql file: <" + sourceFile + "> to <" + hqlDestination + ">");
                }
            }
        } else {
            println("No additional .hql files found for workflow: " + workflowName);
        }
    }
}




void jPropertiestoFile(){
    map[str, set[str]] job_properties_dict = processJobProperties();
    list[str] dagNames = ExtractWorkFlowWithProcessedNames();
    
    for (dagName<-dagNames){
        loc dag_job_prop_file = |cwd:///<o2a_home + "/examples/" + dagName + "/job.properties">|; 

        str static_job_prop = "
nameNode=s3_bucket_name_for_script+
examplesRoot=examples
oozie.use.system.libpath = true
oozie.wf.application.path=${nameNode}/user/${user.name}/${examplesRoot}/apps/subwf
queueName=default
";

        writeFile(dag_job_prop_file, static_job_prop);

        if (dagName in job_properties_dict) {
            set[str] job_prop_lst = job_properties_dict[dagName];
            for (str job_prop <- job_prop_lst) {
                appendToFile(dag_job_prop_file, job_prop + "\n");
            }
        }
               
    }
}




void runO2ACommands() {
    loc bash_script = |cwd:///<"src/oozie-to-airflow/run_o2a.sh">|;
    args=["-m", "chmod +x src/oozie-to-airflow/run_o2a.sh; ./src/oozie-to-airflow/run_o2a.sh"];
    println(exec(bash_script, args=args));
}

void parseBundle() {
    createDagDirectories();
    
    copyFile();
    
    jPropertiestoFile();

    runO2ACommands();
}


