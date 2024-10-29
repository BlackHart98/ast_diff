module lang::orc::translations::translateAirflow::Scheduler
import lang::orc::ast::Scheduler;
import lang::python::ast::Python;
  

public Statement toAirflow(schedulerDef(str schedulerId, str freq, str startDate, str endDate))=expr(call(name("DAG",load()),[constant(string(schedulerId),nothing())],[\keyword(just("start_date"),constant(string(startDate),nothing())),\keyword(just("end_date"),constant(string(endDate),nothing())),\keyword(just("schedule_interval"),constant(string(freq),nothing()))]));


