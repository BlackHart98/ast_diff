module lang::orc::ast::Scheduler

  

data Scheduler = schedulerDef(str schedulerId, str freq, str startDate, str endDate);

data Frequency 
    = once()
    | hourly()
    | daily()
    | weekly()
    | monthly()
    | yearly()
    ;

