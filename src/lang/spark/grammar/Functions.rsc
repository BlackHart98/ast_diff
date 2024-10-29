module lang::spark::grammar::Functions


extend lang::spark::grammar::Expressions;




syntax Expr 
    =  function:Function  AnalyticFunctionClause?
    > :uMin
    ;

syntax Function = overlayWithSnippet: 'overlay''(' Expr input 'PLACING' Expr replacing 'FROM' Expr pos ('FOR' Expr len)? ')' ;



syntax OrderByOrSortedBy 
    = orderByClause: OrderByClause
    | sortByClause: SortedByClause
    ;


syntax PartitionByOrDistributed 
    = partitionByClause: PartitionByClause
    | distributed: Distributed
    ;

syntax Distributed = distributed: 'DISTRIBUTE' 'BY' { Expr "," }+;


syntax TrimDir =trail:'TRAILING' |lead:'LEADING' |both:  'BOTH';

syntax From =from: 'from' Expr ('For' Number)?;
syntax ConditionalFunction
    = nvlFunction: 'NVL'"("Expr","Expr")"
    | nvl2:'nvl2'"("Expr"," Expr"," Expr")"
    | ifFunction: 'IF'"("Expr"," Expr"," Expr")"
    | coalesce: 'COALESCE'"("Expr","{Expr ","}+")"
    | ifNull: 'ifnull' "(" Expr expr1 Expr expr2 ")"
    | nullIf: 'nullif'"(" Expr expr1 Expr expr2 ")"
    ;


syntax MathFunction
    = ceilFunction: 'CEIL'"("{Expr ","}+")" 
    | ceilingFunction: 'CEILING'"("{Expr ","}+")"
    | exponent: 'EXP'"("Expr")" 
    | hex: 'hex'"("Expr ")"
    | unhex: 'unhex'"("Expr ")"
    | div: Expr 'div' Expr
    ;

syntax WindowFunction
    = lead: 'LEAD'"("Expr LeadLagOffSet?")"
    | lag: 'LAG'"("Expr LeadLagOffSet?")"
    | firstValue: 'FIRST_VALUE'"("Identifier ("," Literal)?")"
    | lastValue: 'LAST_VALUE'"("Identifier  ("," Literal)?")"
    | cumeDist:'cume_dist'"()"
    | dense:'dense_rank'"()"	
    | nthValue:'nth_value'"("Expr input (","Expr offset)?")"	
    | ntile:"ntile""("Expr")"
    | percentRank:'percent_rank'"()"	
    | rank:'rank'"()"	
    | rowNumber: 'row_number'"()"	
    ;


syntax LeadLagOffSet = leadLagOffSet: "," Number LeadLagDefault?;

syntax LeadLagDefault = leadLagDefault: ","Expr;

syntax CommaThenBoolean = commaThenBoolean: ","Expr;




syntax ArrayFunction 
    = struct: 'struct'"(" {Expr ","}+")"
    |arrayAppend:'array_append'"(" Expr"," Expr")"
    |arrayCompact:'array_compact'"("Expr")"
    | arrayContains:'array_contains'"("Expr","Expr")"
    |arrayDistinct:'array_distinct'"("Expr")"
    |arrayExcept: 'array_except'"("Expr array1"," Expr array2")"
    |\insert:'array_insert'"("Expr ","Expr "," Expr")"
    |intersect:'array_intersect'"(" Expr array1"," Expr array2")"
    |\join:'array_join'"("Expr"," Expr","(','Expr)? ")"
    | arrayMax:'array_max'"("Expr")"
    | arrayMin:'array_min'"("Expr")"
    | arrayPos: 'array_position'"("Expr"," Expr")"
    | array_prepend:'array_prepend'"("Expr"," Expr")"	
    | array_remove:'array_remove'"("Expr"," Expr")"
    |  arrayRepeat:'array_repeat'"("Expr"," Expr")"
    |union:'array_union'"("Expr"," Expr")"	
    | overlap:'arrays_overlap'"("Expr"," Expr")"	
    |zip:'arrays_zip'"("Expr"," {Expr ","}+ ")"	
    | flatten:'flatten'"("Expr")"	
    | get:'get'"("Expr"," Expr")"
    | sequence: 'sequence'"("Expr"," Expr "," Expr")"
    | shuffle: 'shuffle'"("Expr")"	
    | slice :'slice'"("Expr"," Expr"," Expr")"
    | sort :'sort_array'"("Expr ("," Expr)")"
    ;

syntax MapFunction 
    = elementAt: 'element_at'"("Expr"," Expr")"	
    | \map:'map'"("(Identifier"," Expr)+")"
    | concat:'map_concat'"("{Expr ","}+")"	
    | contain:'map_contains_key'"("Expr"," Expr")"
    | entries: 'map_entries'"("Expr")"	
    | fromArrays:'map_from_arrays'"("Expr"," Expr")"	
    | fromEntries:'map_from_entries'"("Expr")"	
    | keys: 'map_keys'"("Expr")"	
    | values:'map_values'"("Expr")"	
    | strToMap:'str_to_map'"("Expr ("," Expr("," Expr)?)? ")"	
    | tryEl:'try_element_at'"("Expr"," Expr")"	
    ;


syntax JSONFunction =
from:'from_json'"("Expr"," Expr("," Expr)?")"	
|getJson:'get_json_object'"("Expr"," Expr")"	
| arrlen: 'json_array_length'"(" Expr jsonArray")"	
| objectKeys: 'json_object_keys'"(" Expr json_object")"	
| soj: 'schema_of_json'"(" Expr("," Expr)?")"
| toJson:'to_json'"("Expr("," Expr)?")"
;

syntax BitWiseFunction =
and:Expr expr1 "&"  Expr expr2	
| xor: Expr expr1 "^" Expr expr2	
| count: 'bit_count'"(" Expr expr")"	
| bitGet:'bit_get'"(" Expr expr","  Expr pos ")"	
 | getbit:'getbit'"(" Expr expr","  Expr pos ")"		
| shiftright: 'shiftright'"(" Expr base"," Expr expr")"	
|sru:'shiftrightunsigned'"(" Expr base"," Expr expr")"		
|or: Expr expr1 "|" Expr expr2	
|not:"~" Expr expr	
;



syntax CsvFunction =fromCsv:'from_csv'"(" Expr csvStr"," Expr schema("," Expr options)?")"	
| soc: 'schema_of_csv'"(" Expr("," Expr)?")"
|toCsv: 'to_csv'"("Expr("," Expr)?")";


syntax Predicate=
 ilikeF:'ilike'"("Expr","Expr")"
 |likeF:'like'"("Expr","Expr")"
 |regExp:'regexp'"("Expr","Expr")"
 | rlikeF: 'rlike'"("Expr","Expr")"
 |\in: Expr 'in'"("{Expr ","}+")" 
 ;

 syntax TableValued =
 range: 'range'"("{Expr ","}+")" ;

 syntax Generator =
 explode :'explode'"(" Expr expr")"	
| ex_outer:'explode_outer'"(" Expr expr")"	
| inline:'inline'"(" {Expr ","}+ ")"	
| in_outer:'inline_outer'"(" Expr expr")"	
| posEx: 'posexplode'"(" Expr expr")"	
| posEx_outer:'posexplode_outer'"(" Expr expr")"	
| stack:'stack'"(" Expr n"," {Expr ","}+ ")";