module lang::ptl::translations::macroexpansion::LoadAST

import lang::ptl::grammar::PTL;
import lang::ptl::ast::PTL;

import ParseTree;

// public Program implode(Tree pt) = implode(#Program, pt);

public Program implode(loc src) = implode(#Program, parse(#start[Program], src));

public Program loadFromString(str txt) = implode(#Program, parse(#lang::ptl::grammar::PTL::Program, txt));

public Program loadFromFile(loc l=|project://macrolang/src/lang/examples/model.mrl|) = implode(#Program, parse(#lang::ptl::grammar::PTL::Program, l));