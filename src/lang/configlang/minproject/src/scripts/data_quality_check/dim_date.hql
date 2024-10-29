select SK_DateID, DateValue, DateDesc, CalendarYearID,
CalendarYearDesc, CalendarQtrID, CalendarQtrDesc, CalendarMonthID,
CalendarMonthDesc, CalendarWeekID, CalendarWeekDesc,
DayOfWeekNum, DayOfWeekDesc, FiscalYearID, FiscalYearDesc,
FiscalQtrID, FiscalQtrDesc, HolidayFlag from master.DimDate order by
DateValue;