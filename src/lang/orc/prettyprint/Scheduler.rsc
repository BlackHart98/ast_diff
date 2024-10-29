module lang::orc::prettyprint::Scheduler

import lang::orc::ast::Scheduler;

public str toString(schedulerDef(str schedulerId, str freq, str startDate, str endDate)) = "scheduler <schedulerId>:
                                                                                                  '   frequency = <freq>
                                                                                                  '   startDate = <startDate>
                                                                                                  '   endDate = <endDate>";


public str toString(Frequency freq){
  switch(freq){
    case once(): return "Once";
    case hourly(): return "Hourly";
    case daily(): return "Daily";
    case weekly(): return "Weekly";
    case monthly(): return "Monthly";
    case yearly(): return "Yearly";

    default: return "null";
  }
}