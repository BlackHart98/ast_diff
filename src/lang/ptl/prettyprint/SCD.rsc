module lang::ptl::prettyprint::SCD

import lang::ptl::ast::SCD;
extend lang::ptl::prettyprint::Expressions;
import List;
import String;

str toString(modelAnnotation(list[ConfigKeyValue] configKeyValue)){
    return "@config(<for(i <- configKeyValue){>
        <toString(i)>
    <}>)";
}

str toString(ConfigKeyValue ckv){
    switch(ckv){
        case kindValue(Expr scdType):
            return "kind: <toString(scdType)>";
        case strategyValue(StrategyOptions strategyOptions):
            return "strategy: <toString(strategyOptions)>";
        case uniqueKeyValue(str uniqueAttribute):
            return "unique_key: <uniqueAttribute>";
        case strategyAttributes(StrategyAttributes stratAtrributes):
            return "<toString(stratAtrributes)>";
        default:
            return "";
    }
}

str toString(StrategyOptions stratOptions){
    switch(stratOptions){
        case timestampStrategy():
            return "timestamp";
        case checkColumnStrategy():
            return "check";
        default:
            return "";
    }
}

str toString(StrategyAttributes stratAttrs){
    switch(stratAttrs){
        case updatedAt(str updateAtAttribute):
            return "updated_at: <updateAtAttribute>";
        case checkAttr(list[str] checkListAttributes):
            return "check_attrs: [<intercalate(",",[t|t <- checkListAttributes])>]";
        default:
            return "";
    }
}