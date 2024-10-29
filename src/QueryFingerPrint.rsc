module QueryFingerPrint

import util::FileSystem;
import IO;
import List;
import String;
import lang::ptl::ast::Declarations;
import lang::ptl::grammar::View;
import lang::ptl::Utils; 
import lang::ptl::ast::PTL;
import Node;



// public str fingerPrint(loc file = |project://ast_diff/src/test.ptl|){
//     Program ptl_ast = loadPTL(file);
//     println(ptl_ast);
// }



map[str, str] declarationFingerprints = ();

public void processPTL(loc fileLocation = |project://ast_diff/src/test.ptl|) {
    Program ptlAst = loadPTL(fileLocation);
    visit(ptlAst) {
        case Declaration d: {
            switch(d) {
                case entity(mda, prtBy, clstBy, rowFrmt, storedAs, location, tblPropties, 
                          materializedAs, temporal, external, ifNotExists, drop, entityId, fields): {
                    generateFingerprint("entity", entityId, [
                        mda, prtBy, clstBy, rowFrmt, storedAs, location, tblPropties,
                        materializedAs, temporal, external, ifNotExists, drop, fields
                    ]);
                }

                
                case view(mda, viewDecl): {
                    generateFingerprint("view", toString(viewDecl), [mda]);
                }
                
                
            }
        }
    }
    
    println("\nComplete Declaration Fingerprints:");
    for (key <- declarationFingerprints) {
        println("<key>: <declarationFingerprints[key]>");
    }
}


private void generateFingerprint(str declType, str identifier, list[value] components) {

    str contentString = declType + ":" + identifier;
    
    for (component <- components) {
        contentString += ":" + toString(component);
    }
    

    str fingerprint = toLowerCase(md5Hash(contentString));
    

    str qualifiedName = declType + ":" + identifier;
    declarationFingerprints[qualifiedName] = fingerprint;
}


private str toString(value v) {
    return "<v>";
}