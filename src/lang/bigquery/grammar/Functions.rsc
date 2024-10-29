module lang::bigquery::grammar::Functions

extend lang::bigquery::grammar::Expressions;

syntax Expr 
    = function: FunctionCall
    > :uMin
    ;

syntax FunctionCall = inBuiltFunction: InBuiltFunction AnalyticFunctionClause?;

syntax FunctionCall 
    = udf: PackageName? FUNCTIONNAME"(" {Expr ","}* ")"
    ;



syntax AnalyticFunctionClause = analyticFunctionClause: 'OVER' WindowSpecification;

syntax InBuiltFunction
    = aggregateFunction: AggregateFunction
    | approximateAggregateFunc: ApproximateAggregateFunc
    | conversionFunction: ConversionFunctions
    | dateFunction: DateFunctions
    | navigationFunctions: NavigationFunctions
    | numberingFunctions: NumberingFunctions
    | statisticalAggregateFunctions: StatisticalAggregateFunctions
    | tableFunctions: TableFunctions
    | textAnalysisFunctions: TextAnalysisFunctions
    | arrayFunctions: ArrayFunctions
    ;

syntax EncryptionFunctions
  = "AEAD.DECRYPT_BYTES""("{Expr ","}+")"
  | "AEAD.DECRYPT_STRING""("{Expr ","}+")"
  | "AEAD.ENCRYPT""("{Expr ","}+")"
  | "DETERMINISTIC_DECRYPT_BYTES""("{Expr ","}+")"
  | "DETERMINISTIC_DECRYPT_STRING""("{Expr ","}+")"
  | "DETERMINISTIC_ENCRYPT""("{Expr ","}+")"
  | "KEYS.ADD_KEY_FROM_RAW_BYTES""("{Expr ","}+")"
  | "KEYS.KEYSET_CHAIN""("{Expr ","}+")"
  | "KEYS.KEYSET_FROM_JSON""("{Expr ","}+")"
  | "KEYS.KEYSET_LENGTH""("{Expr ","}+")"
  | "KEYS.NEW_KEYSET""("{Expr ","}+")"
  | "KEYS.NEW_WRAPPED_KEYSET""("{Expr ","}+")"
  | "KEYS.REWRAP_KEYSET""("{Expr ","}+")"
  | "KEYS.ROTATE_KEYSET""("{Expr ","}+")"
  | "KEYS.ROTATE_WRAPPED_KEYSET""("{Expr ","}+")"
  ;

syntax AggregateFunction 
  = anyvalue: 'ANY_VALUE'"(" Expr HavingExp? ")" 
  | arrayagg: 'ARRAY_AGG'"(" Distinct? Expr IgnoreRespect? {OrderBy ","}*  Limit?")" 
  | arrayconcatagg: 'ARRAY_CONCAT_AGG'"(" Expr {OrderBy ","}*  Limit?")"
  | avg: 'AVG'"(" Distinct? {Expr ","}+")" 
  | bitAnd: 'BIT_AND'"("Expr")"
  | bitOr: 'BIT_OR'"("Expr")"
  | bitXor: 'BIT_XOR'"("Distinct? Expr")"
  | countAll: 'COUNT'"(""*"")" 
  | count: 'COUNT'"("Distinct? Expr")" 
  | countIf: 'COUNTIF'"("Expr")" 
  | grouping: 'GROUPING'"("Expr")"
  | logicalAnd: 'LOGICAL_AND'"("Expr")"
  | logicalOr: 'LOGICAL_OR'"("Expr")"
  | max: 'MAX'"("Expr")" 
  | maxBy: 'MAX_BY'"("{Expr ","}+")"
  | min: 'MIN'"("Expr")" 
  | minBy: 'MIN_BY'"("{Expr ","}+")"
  | stringAgg: 'STRING_AGG'"(" Distinct? {Expr ","}+ {OrderBy ","}* Limit?")" 
  | sum: 'SUM'"("Distinct? Expr")" 
  ;

syntax ApproximateAggregateFunc
  = approxCountDistinct: 'APPROX_COUNT_DISTINCT'"(" Expr ")"
  | approxQuantiles: 'APPROX_QUANTILES'"(" Distinct? {Expr ","}+ IgnoreRespect? ")"
  | approxTopCount: 'APPROX_TOP_COUNT'"(" {Expr ","}+ ")"
  | approxTopSum: 'APPROX_TOP_SUM'"(" {Expr ","}+ ")"
  ;

syntax ArrayFunctions 
  = array: 'ARRAY'"(" ExprOrQueryOrWith ")"
  | arrayConcat: 'ARRAY_CONCAT'"(" ExprOrQueryOrWith ")"
  | arrayReverse: 'ARRAY_REVERSE'"(" ExprOrQueryOrWith ")"
  | arrayToString: 'ARRAY_TO_STRING'"(" ExprOrQueryOrWith ")"
  | generateArray: 'GENERATE_ARRAY'"(" ExprOrQueryOrWith ")"
  | generateDateArray: 'GENERATE_DATE_ARRAY'"(" ExprOrQueryOrWith ")"
  | generateTimestampArray: 'GENERATE_DATE_ARRAY'"(" {ExprOrQueryOrWith ","}+ ")"
  ;

syntax ExprOrQueryOrWith = Expr | QueryOrWith;


syntax BitFunctions = bitCount: 'BIT_COUNT'"(" Expr ")";

syntax ConversionFunctions
  = safeCast: 'SAFE_CAST'"(" Expr 'AS' DataType FormatClause?")"
  | castAsTimestamp: 'CAST'"(" Expr 'AS' DataType FormatClause? 'AT' 'TIME' 'ZONE' Expr timezone_expr")" 
  | parseBignumeric: 'PARSE_BIGNUMERIC'"(" Expr ")"
  | parseNumeric: 'PARSE_NUMERIC'"(" Expr ")"
  ;
   

syntax DateFunctions 
  = currentDate: 'CURRENT_DATE'"(" Expr? ")"
  | extract: 'EXTRACT'"(" Expr 'FROM' Expr ")"
  ;

syntax DateTimeFunctions 
  = currentDateTime: 'CURRENT_DATETIME'("(" Expr? ")")
  | dateTime: 'DATETIME'"(" {Expr ","}+ ")"
  | dateTimeAdd: 'DATETIME_ADD'"(" {Expr ","}+ ")"
  | dateTimeSub: 'DATETIME_ADD'"(" {Expr ","}+ ")"
  | dateTimeDiff: 'DATETIME_DIFF'"(" {Expr ","}+ ")"
  | dateTimeTrunc: 'DATETIME_TRUNC'"(" {Expr ","}+ ")"
  | formatDateTime: 'FORMAT_DATETIME'"(" {Expr ","}+ ")"
  | parseDateTime: 'PARSE_DATETIME'"(" {Expr ","}+ ")"
  ;

syntax DebuggingFunctions
  = error: 'ERROR'"("Expr")"
  ;

syntax FederatedQueryFunctions
  = externalQuery: 'EXTERNAL_QUERY'"("{Expr ","}+")"
  ;

syntax DLPEncryptionFunctions
  = dlpEncrypt: 'DLP_DETERMINISTIC_ENCRYPT'"("{Expr ","}+")"
  | dlpDecrypt: 'DLP_DETERMINISTIC_DECRYPT'"("{Expr ","}+")"
  | dlpChain: 'DLP_KEY_CHAIN'"("{Expr ","}+")"
  ;

syntax HashFunction 
  = farmFingerprint: 'FARM_FINGERPRINT'"("Expr")"
  | md5: 'MD5'"("Expr")"
  | shai1: 'SHA1'"("Expr")"
  | sha256: 'SHA256'"("Expr")"
  | sha512: 'SHA512'"("Expr")"
  ;

syntax HyperLoopFunctions
  = hllExtract: 'HLL_COUNT.EXTRACT'"("Expr")"
  | hllInit: 'HLL_COUNT.INIT'"("{Expr ","}+")"
  | hllMerge: 'HLL_COUNT.MERGE'"("Expr")"
  | hllMergePartial: 'HLL_COUNT.MERGE_PARTIAL'"("Expr")"
  ;

syntax IntervalFunction
  = justifyDays: 'JUSTIFY_DAYS'"("Expr")"
  | justifyHours: 'JUSTIFY_HOURS'"("Expr")"
  | justifyInterval: 'JUSTIFY_INTERVAL'"("Expr")"
  | makeInterval: 'MAKE_INTERVAL'"("{Expr ","}+")"
  ;

syntax NavigationFunctions 
  = firstValue: 'FIRST_VALUE'"("Expr IgnoreRespect?")" 
  | lag: 'LAG'"("{Expr ","}+")" 
  | lastValue: 'LAST_VALUE'"("{Expr ","}+ IgnoreRespect?")" 
  | lead: 'LEAD'"("{Expr ","}+")" 
  | nthvalue: 'NTH_VALUE'"("{Expr ","}+ IgnoreRespect?")"  
  | percentileCont: 'PERCENTILE_CONT'"("{Expr ","}+ IgnoreRespect?")"  
  | percentileDisc: 'PERCENTILE_DISC'"("{Expr ","}+ IgnoreRespect?")"  
  ;

syntax NetFunctions 
  = netHost: 'NET.HOST'"(" {Expr ","}+ ")"
  | netIpFromStr: 'NET.IP_FROM_STRING'"(" {Expr ","}+ ")"
  | netIPNetMask: 'NET.IP_NET_MASK'"(" {Expr ","}+ ")"
  | netIpToStr: 'NET.IP_TO_STRING'"(" {Expr ","}+ ")"
  | netIpTrunc: 'NET.IP_TRUNC'"(" {Expr ","}+ ")"
  | netIpFromInt64: 'NET.IPV4_FROM_INT64'"(" {Expr ","}+ ")"
  | netIpToInt64: 'NET.IPV4_TO_INT64'"(" {Expr ","}+ ")"
  | netPublicSuffix: 'NET.PUBLIC_SUFFIX'"(" {Expr ","}+ ")"
  | netRegDomain: 'NET.REG_DOMAIN'"(" {Expr ","}+ ")"
  | netSafeIpFromStr: 'NET.SAFE_IP_FROM_STRING'"(" {Expr ","}+ ")"
  ; 

syntax NumberingFunctions 
  = cumeDist: 'CUME_DIST'"("")" 
  | denseRank: 'DENSE_RANK'"("")" 
  | ntile: 'NTILE'"("Expr")" 
  | percentRank: 'PERCENT_RANK'"("")" 
  | rank: 'RANK'"("")" 
  | rowNumber: 'ROW_NUMBER'"("")" 
  ;

syntax SearchFunctions 
  = search: 'SEARCH'"("{Expr ","}+")"
  ;

syntax SecurityFunctions 
  = sessionUser: 'SESSION_USER'"("{Expr ","}+")"
  ;


syntax StatisticalAggregateFunctions
  = corr: 'CORR'"("{Expr ","}+")" 
  | covarPop: 'COVAR_POP'"("{Expr ","}+")" 
  | covarSamp: 'COVAR_SAMP'"("{Expr ","}+")" 
  | stddev: 'STDDEV'"("Distinct? {Expr ","}+")" 
  | stddevPop: 'STDDEV_POP'"("Distinct? {Expr ","}+")" 
  | stddevSamp: 'STDDEV_SAMP'"("Distinct? {Expr ","}+")" 
  | varPop: 'VAR_POP'"("Distinct? {Expr ","}+")" 
  | varSamp: 'VAR_SAMP'"("Distinct? {Expr ","}+")" 
  | variance: 'VARIANCE'"("Distinct? {Expr ","}+")" 
  ;

syntax TableFunctions
  = appends: 'APPENDS'"(" 'TABLE' Expr "," Expr ")"
  | externalObjectTransform: 'EXTERNAL_OBJECT_TRANSFORM'"(" 'TABLE' Expr "," Expr ")"
  ;

syntax TextAnalysisFunctions 
  = bagOfWords: 'BAG_OF_WORDS'"("{Expr ","}+")" 
  | textAnalyze: 'TEXT_ANALYZE'"("{Expr ","}+")" 
  | tfIdf: 'TF_IDF'"("{Expr ","}+")" 'OVER'"("")" 
  ;

syntax TimeFunctions
  =  formatTime: 'FORMAT_TIME'"("{Expr ","}+")"
  | parseTime: 'PARSE_TIME'"("{Expr ","}+")"
  | time: 'TIME'"("{Expr ","}+")"
  | timeAdd: 'TIME_ADD'"("{Expr ","}+")"
  | timeDiff: 'TIME_DIFF'"("{Expr ","}+")"
  | timeSub: 'TIME_SUB'"("{Expr ","}+")"
  | timeTrunc: 'TIME_TRUNC'"("{Expr ","}+")"
  ;

syntax TimestampFunctions 
  = 
   formatTimestamp: 'FORMAT_TIMESTAMP'"("{Expr ","}+")"
  | parseTimestamp: 'PARSE_TIMESTAMP'"("{Expr ","}+")"
  | stringTimestamp: 'STRING'"("{Expr ","}+")"
  | timestamp: 'TIMESTAMP'"("{Expr ","}+")"
  | timestampAdd: 'TIMESTAMP_ADD'"("{Expr ","}+")"
  | timestampDiff: 'TIMESTAMP_DIFF'"("{Expr ","}+")"
  | timestampMicros: 'TIMESTAMP_MICROS'"("{Expr ","}+")"
  | timestampMillis: 'TIMESTAMP_MILLIS'"("{Expr ","}+")"
  | timestampSeconds: 'TIMESTAMP_SECONDS'"("{Expr ","}+")"
  | timestampSub: 'TIMESTAMP_SUB'"("{Expr ","}+")"
  | timestampTrunc: 'TIMESTAMP_TRUNC'"("{Expr ","}+")"
  | unixMicros: 'UNIX_MICROS'"("{Expr ","}+")"
  | unixMillis: 'UNIX_MILLIS'"("{Expr ","}+")"
  | unixSeconds: 'UNIX_SECONDS'"("{Expr ","}+")"
  ;

syntax UtilityFunctions
  = generateUuid: 'GENERATE_UUID'"("")"
  ;





syntax Limit = limit: 'LIMIT' Int;

syntax IgnoreRespect
  = ignoreNulls: 'IGNORE' 'NULLS'
  | respectNulls: 'RESPECT' 'NULLS'
  ;

syntax HavingExp = havingExp: 'HAVING' MaxMin Expr;

syntax MaxMin
  = max: 'MAX'
  | min: 'MIN'
  ;

syntax PartitionByExp = partitionByExp: 'PARTITION' 'BY' Expr;


syntax OrderBy = orderSpecs: 'ORDER' 'BY' Expr AscDesc?;

syntax AscDesc 
  = asc: 'ASC' 
  | desc: 'DESC'
  ;

