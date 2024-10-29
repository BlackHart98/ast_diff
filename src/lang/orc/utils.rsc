module lang::orc::utils
import ParseTree;
import lang::orc::ast::Orc;
import lang::orc::grammar::Orc;


Orc loadOrc(loc file){
    return implode(#lang::orc::ast::Orc::Orc,parse(#start[Orc], file));
}

Orc loadOrc(str file){
    return implode(#lang::orc::ast::Orc::Orc,parse(#start[Orc], file));
}