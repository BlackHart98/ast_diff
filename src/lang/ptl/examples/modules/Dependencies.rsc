module lang::ptl::examples::modules::Dependencies

import util::FileSystem;
import IO;
import String;
import List;
import lang::ptl::Utils; 
import lang::ptl::ast::PTL;
import Node;


loc BASE_DIRECTORY = |project://adept-base/src/lang/ptl/examples/modules/|;

data PIMArtifact 
	= artifact(
		str artifactId
		, str artifactKind
		, loc location
		, &T <: node artifactAST
		, list[str] dependencyList
        );


list[PIMArtifact] generateModuleDependencies(loc projectDir = BASE_DIRECTORY) {

    list[PIMArtifact] artifactListFlatten = [];
    set[loc] files = files(projectDir);
    for (file <- files) {
        switch (file.extension){
            case "ptl":{
                list[PIMArtifact] artifactList 
				    = extractPTLModuleArtifacts(file);
			    artifactListFlatten += artifactList;
            }
            case "el":{
                ;;
            }
            case "pcf":{
                ;;
            }
            default: continue;
        }
    }
    
    return artifactListFlatten;
}


map[str, tuple[list[str], PIMArtifact]] createArtifactMap() {
    list[PIMArtifact] artifactListFlatten = generateModuleDependencies();
    
    map[str, tuple[list[str], PIMArtifact]] artifactMap = ();
    for (artifact <- artifactListFlatten) {
        if (artifact.artifactId in artifactMap) {
            throw "duplicate artifact found artifact: <artifactId>";
        }
        else { 
            artifactMap[artifact.artifactId] = <[], artifact>;
        }    
    }
    return artifactMap;
}

void verifyModuleNameMatchesFilePath(str moduleName, loc file) {
    list[str] moduleNameParts = split("::", moduleName);
    str expectedRelativePath = intercalate("/", moduleNameParts) + ".ptl";
    loc expectedFilePath = BASE_DIRECTORY + expectedRelativePath;

    str expectedPathStr = expectedFilePath.path;
    str actualPathStr = file.path;


    expectedPathStr = replaceAll(expectedPathStr, "\\", "/"); 
    actualPathStr = replaceAll(actualPathStr, "\\", "/");



    if (expectedPathStr != actualPathStr) {
        throw "Module name does not match file path.
            Expected: <expectedPathStr>,
            Actual: <actualPathStr>";
    }
}

list[PIMArtifact] extractPTLModuleArtifacts(loc file){
    Program astNode = loadPTL(file);
    str moduleName = astNode.moduleId;
    verifyModuleNameMatchesFilePath(moduleName, file);
    list[str] dependencies = [x | \import(x) <- astNode.importlist];
    list[PIMArtifact] artifactList = [
        artifact(
            moduleName + "::" + getArtifactId(x),
            getName(x),
            getAnnotations(x)["src"],
            x,
            dependencies) 
        | x <- astNode.decls
    ];
    return artifactList;
}



str getArtifactId(&T <: node astNode){
    switch(astNode){
        case view(
            _
            , viewDecl(
                _, 
                _, 
                _, 
                viewName(viewName), 
                _, 
                _, 
                _, 
                _, 
                _, 
                _, 
                _, 
                _, 
                _, 
                _, 
                _)
        ):{
            return "<viewName>";
        }
        case entity(_, _, _, _, _, _, _, _, _, _, _, _, entityName, _):{
            return "<entityName>";
        }
        default: return "";
    }
}


list[str] getDepFromViewDef(&T <: node viewArtifact){
    list[str] result = [];

    top-down visit(viewArtifact){
        case viewDecl(
                _, 
                _, 
                _, 
                _, 
                _, 
                name(sName(name), _), 
                _, 
                _, 
                _, 
                _, 
                _, 
                _, 
                _, 
                _, 
                _): {
                    result += [name];
                }
        case joinCondition(_, tName(name, _), _, _): {
            result += [name];
        }
    }
    return result;
}


map[str, tuple[list[str], PIMArtifact]] deriveViewDependencies(list[PIMArtifact] artifactList){
    
    map[str, tuple[list[str], PIMArtifact]] depAdj = ();
    for (x <- artifactList){
        if (x.artifactKind == "view"){
            list[str] deps = getDepFromViewDef(x.artifactAST);
            depAdj += (x.artifactId : <deps, x>);
        } else {
            depAdj += (x.artifactId : <[], x>);
        }
        
    }
    
    for (artifactId <- depAdj){
        list[str] temp = [];
        str moduleName = intercalate("::", split("::", artifactId)[..-1]);
        for(element <- depAdj[artifactId][0]){
            if (
                moduleName + "::" + element in depAdj 
                && (depAdj[moduleName + "::" + element][1].artifactKind == "view"
                || depAdj[moduleName + "::" + element][1].artifactKind == "entity")){

                temp += [moduleName + "::" + element];
            } else{
                bool isFound = false;
                for (imp <- depAdj[artifactId][1].dependencyList){
                    if (imp + "::" + element in depAdj
                        && (depAdj[imp + "::" + element][1].artifactKind == "view"
                        || depAdj[imp + "::" + element][1].artifactKind == "entity")){
                        
                        if (isFound){
                            throw "duplicate occurrence of <element> in imported modules";
                        }
                        temp += [imp + "::" + element];
                        isFound = true;
                    } else{
                        continue;
                    }
                }
                if (!isFound){
                    throw "cannot resolve dependency <element>";
                }
            }
        }
        depAdj[artifactId][0] = temp;
    }

    return depAdj;
}


void main(){
    map[str, tuple[list[str], PIMArtifact]] result 
        = deriveViewDependencies(generateModuleDependencies());
        
    iprint(result);
}
bool detectCycle(str artifactId, map[str, tuple[list[str], PIMArtifact]] artifactMap, set[str] visited, set[str] recursionStack) {
    if (artifactId in recursionStack) {
        return true; 
    }
    
    if (artifactId in visited) {
        return false; 
    }
    visited += artifactId;
    recursionStack += artifactId;
    for (dep <- artifactMap[artifactId][0]) {
        if (detectCycle(dep, artifactMap, visited, recursionStack)) {
            return true; 
        }
    }
    recursionStack -= artifactId;
    return false;
}


bool hasCycles(map[str, tuple[list[str], PIMArtifact]] artifactMap) {
    set[str] visited = {};
    set[str] recursionStack = {};
    
    for (artifactId <- artifactMap) {
        if (detectCycle(artifactId, artifactMap, visited, recursionStack)) {
            return true;
        }
    }
    return false;
}
// call with hasCycles(createArtifactMap())
