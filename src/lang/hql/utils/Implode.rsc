module lang::hql::utils::Implode

import lang::hql::grammar::HQL;
import lang::hql::ast::HQL;
import ParseTree;


public lang::hql::ast::HQL::HQLStart loadHQL(loc location)
	= implode(#HQLStart, parse(#start[HQLStart],location));
	
public lang::hql::ast::HQL::HQLStart loadHQL(str hqlSyntax)
	= implode(#HQLStart, parse(#start[HQLStart],hqlSyntax));
