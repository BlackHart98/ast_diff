select SK_TimeID, TimeValue, HourID, HourDesc, MinuteID, MinuteDesc,
SecondID, SecondDesc, MarketHoursFlag, OfficeHoursFlag from
master.DimTime order by TimeValue;