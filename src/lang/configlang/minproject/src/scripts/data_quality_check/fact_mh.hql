SELECT 
    FM.SK_SecurityID, 
    FM.SK_CompanyID, 
    FM.SK_DateID,
    FM.PERatio, 
    FM.Yield, 
    FM.FiftyTwoWeekHigh,
    FM.SK_FiftyTwoWeekHighDate, 
    FM.FiftyTwoWeekLow,
    FM.SK_FiftyTwoWeekLowDate, 
    FM.ClosePrice, 
    FM.DayHigh,
    FM.DayLow, 
    FM.Volume, 
    FM.BatchID,
    DS.Symbol,               -- Include Symbol for ORDER BY
    DD.DateValue             -- Include DateValue for ORDER BY
FROM 
    master.FactMarketHistory AS FM 
    LEFT OUTER JOIN master.DimSecurity AS DS 
        ON FM.SK_SecurityID = DS.SK_SecurityID 
    LEFT OUTER JOIN master.DimCompany AS DCo 
        ON FM.SK_CompanyID = DCo.SK_CompanyID 
    LEFT OUTER JOIN master.DimDate AS DD 
        ON FM.SK_DateID = DD.SK_DateID 
ORDER BY 
    DS.Symbol, 
    DD.DateValue;