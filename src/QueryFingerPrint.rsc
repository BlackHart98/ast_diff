module QueryFingerPrint

import util::FileSystem;
import IO;
import List;
import Map;
import String;
import lang::ptl::ast::Declarations;
import lang::ptl::grammar::View;
import lang::ptl::Utils; 
import lang::ptl::ast::PTL;
import lang::ptl::grammar::PTL; 
import Node;
import ASTDiff;
import lang::ptl::prettyprint::PTL;
import lang::ptl::grammar::Declarations;
import lang::ptl::ast::Declarations;

// Map to store both the AST and its hash
map[str, tuple[Declaration ast, str hash]] declarationFingerprints = ();

public void processPTL(loc fileLocation = |project://ast_diff/src/test.ptl|) {
    Program ptlAst = loadPTL(fileLocation);
    visit(ptlAst) {
        case Declaration d: {
            switch(d) {
                case entity(mda, prtBy, clstBy, rowFrmt, storedAs, location, tblPropties, 
                          materializedAs, temporal, external, ifNotExists, drop, entityId, fields): {
                    processDeclaration("entity", entityId, d, [
                        mda, prtBy, clstBy, rowFrmt, storedAs, location, tblPropties,
                        materializedAs, temporal, external, ifNotExists, drop, fields
                    ]);
                }
                
                case view(mda, viewDecl): {
                    processDeclaration("view", toString(viewDecl), d, [mda]);
                }
            }
        }
    }
    
    println("\nComplete Declaration Fingerprints:");
    for (key <- declarationFingerprints) {
        println("<key>: Hash = <declarationFingerprints[key][1]>");
    }
}

private void processDeclaration(str declType, str identifier, Declaration newDecl, list[value] components) {
    str qualifiedName = declType + ":" + identifier;
    
    // Check if we should add this declaration by comparing with existing ones
    if (!shouldAddDeclaration(newDecl)) {
        println("Skipping similar declaration: <qualifiedName>");
        return;
    }
    
    // Generate MD5 hash for the new declaration
    str contentString = declType + ":" + identifier;
    for (component <- components) {
        contentString += ":" + toString(component);
    }
    str hash = toLowerCase(md5Hash(contentString));
    
    // Store both the AST and its hash
    declarationFingerprints[qualifiedName] = <newDecl, hash>;
    println("Added new declaration: <qualifiedName> with hash: <hash>");
}

private bool shouldAddDeclaration(Declaration newDecl) {
    // If no existing declarations, definitely add this one
    if (isEmpty(declarationFingerprints)) {
        return true;
    }
    
    // Compare with each existing declaration
    for (existingDecl <- declarationFingerprints) {
        Declaration existingAst = declarationFingerprints[existingDecl][0];
        
        // Convert both declarations to strings for comparison
        str existingStr = lang::ptl::prettyprint::PTL::toString(existingAst);
        // println(existingStr);
        str newStr = lang::ptl::prettyprint::PTL::toString(newDecl);
        // println(newStr);
        
        // Get the diff between the two ASTs
        DiffTree diffResult = diff(
            #lang::ptl::grammar::Declarations::Declaration, 
            #lang::ptl::ast::Declarations::Declaration, 
            existingStr, 
            newStr
        );
        
        // Check if there are only keepNodes in the diff
        bool onlyKeepNodes = true;
        for (diffNode <- diffResult.diffNodeList) {
            if (keepNode(_, _) !:= diffNode) {
                onlyKeepNodes = false;
                break;
            }
        }
        
        // If we found a declaration that's similar enough (only keep nodes),
        // we shouldn't add the new one
        if (onlyKeepNodes) {
            return false;
        }
    }
    
    // If we get here, no similar declarations were found
    return true;
}

private str toString(value v) {
    return "<v>";
}