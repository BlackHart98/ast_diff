module lang::hql::Utils
import lang::hql::grammar::HQL;
import lang::hql::ast::HQL;   
import ParseTree;
public HQLStart loadHQL(loc input)=implode(#lang::hql::ast::HQL::HQLStart, parse(#lang::hql::grammar::HQL::HQLStart, input));