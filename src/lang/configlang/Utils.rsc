module lang::configlang::Utils

import lang::configlang::ast::Configlang;
import lang::configlang::grammar::Configlang;

import ParseTree;

import Map;
import lib::Functools;
import lib::Utils;


public Config loadConfigLang(loc location){
  return implode(#lang::configlang::ast::Configlang::Config,parse(#start[Config], location));
}

public Config loadConfigLang(str text){
  return implode(#lang::configlang::ast::Configlang::Config,parse(#start[Config], text));
}


// public JSON addToBuildConfig(JSON buildConf, str keyName, JSON keyValue) {
	
// 	map[str,JSON] properties = extractJSONMap(buildConf);
//     bool authenticate = true;
//     lrel[str,JSON] newmap = toList(properties);
//     visit(newmap) {
//         case <keyName,_>: authenticate = false;
//   	};

//     if(!authenticate) {
//         throw BuildConfigException("Key: <keyName> already exists");
//     }
//     else {
//             properties[keyName] = keyValue;
//         }
// 	return object(properties);
// }

// public map[str,JSON] extractJSONMap(JSON buildConf) {
//     switch(buildConf) {
//         case object(map[str, JSON] properties): return properties;
// 		default: throw BuildConfigException("Unhandled JSONText: <buildConf>");
//     }
// }

// public JSON updateBuildConfig(JSON buildConf, str keyName, JSON keyValue) {

//     JSON buildConfig = buildConf;

//     JSON newBuildConfig = visit(buildConf) {
//             case object(map[str memberName, JSON memberValue] properties)=>(object((key:key==keyName?keyValue:properties[key]|key<-properties)))   
//         };

//     return newBuildConfig;

// }