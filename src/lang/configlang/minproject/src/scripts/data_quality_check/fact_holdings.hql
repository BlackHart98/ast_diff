SELECT 
    FH.TradeID, 
    FH.CurrentTradeID, 
    FH.SK_CustomerID,
    FH.SK_AccountID, 
    FH.SK_SecurityID, 
    FH.SK_CompanyID, 
    FH.SK_DateID,
    FH.SK_TimeID, 
    FH.CurrentPrice, 
    FH.CurrentHolding, 
    FH.BatchID,
    DD.DateValue,     
    DTime.TimeValue        
FROM 
    master.FactHoldings AS FH 
    LEFT OUTER JOIN master.DimTrade AS DTrade 
        ON FH.TradeID = DTrade.TradeID 
    LEFT OUTER JOIN master.DimAccount AS DA 
        ON FH.SK_AccountID = DA.SK_AccountID 
    LEFT OUTER JOIN master.DimCustomer AS DC 
        ON FH.SK_CustomerID = DC.SK_CustomerID 
    LEFT OUTER JOIN master.DimSecurity AS DS 
        ON FH.SK_SecurityID = DS.SK_SecurityID 
    LEFT OUTER JOIN master.DimCompany AS DCo 
        ON FH.SK_CompanyID = DCo.SK_CompanyID 
    LEFT OUTER JOIN master.DimDate AS DD 
        ON FH.SK_DateID = DD.SK_DateID 
    LEFT OUTER JOIN master.DimTime AS DTime
        ON FH.SK_TimeID = DTime.SK_TimeID 
ORDER BY 
    FH.TradeID,
    DD.DateValue, 
    DTime.TimeValue;
