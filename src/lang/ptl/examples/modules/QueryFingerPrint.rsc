module lang::ptl::examples::modules::QueryFingerPrint

import util::FileSystem;
import IO;
import List;
import String;
import lang::ptl::ast::Declarations;
import lang::ptl::grammar::View;
import lang::ptl::Utils; 
import lang::ptl::ast::PTL;
import Node;



public str fingerPrint(loc file = |project://adept-base/src/lang/ptl/examples/modules/desugar.ptl|){
    Program ptl_ast = loadPTL(file);
    println(ptl_ast);
}



// Hashmap to store fingerprints of each declaration by type and identifier
map[str, str] declarationFingerprints = ();

// Function to load, parse, and process the PTL file
public void processPTL(loc fileLocation = |project://adept-base/src/lang/ptl/examples/modules/desugar.ptl|) {
    // Load the PTL program AST
    Program ptlAst = loadPTL(fileLocation);
    
    // Visit nodes and generate fingerprints for each declaration type
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
                    // Extract view name from viewDecl if possible
                    str viewName = "view_" + toString(viewDecl);
                    generateFingerprint("view", viewName, [mda, viewDecl]);
                }
    
            }
        }
    }
    
    // Output final results
    println("\nComplete Declaration Fingerprints:");
    for (key <- declarationFingerprints) {
        println("<key>: <declarationFingerprints[key]>");
    }
}

// Helper function to generate and store fingerprints
private void generateFingerprint(str declType, str identifier, list[value] components) {
    // Create a comprehensive string representation of the declaration
    str contentString = declType + ":" + identifier;
    
    // Add all components to the content string
    for (component <- components) {
        contentString += ":" + toString(component);
    }
    
    // Generate MD5 hash
    str fingerprint = toLowerCase(md5Hash(contentString));
    
    // Store in hashmap with qualified name
    str qualifiedName = declType + ":" + identifier;
    declarationFingerprints[qualifiedName] = fingerprint;
}

// Helper function for consistent string representation of values
private str toString(value v) {
    return "<v>";
}