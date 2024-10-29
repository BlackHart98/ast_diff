SELECT 
    FW.SK_CustomerID, 
    FW.SK_SecurityID,
    FW.SK_DateID_DatePlaced, 
    FW.SK_DateID_DateRemoved, 
    FW.BatchID,
    DC.CustomerID,          -- Include CustomerID for ORDER BY
    DS.Symbol,              -- Include Symbol for ORDER BY
    DD.DateValue            -- Include DateValue for ORDER BY
FROM 
    master.FactWatches AS FW 
    LEFT OUTER JOIN master.DimSecurity AS DS 
        ON FW.SK_SecurityID = DS.SK_SecurityID 
    LEFT OUTER JOIN master.DimCustomer AS DC 
        ON FW.SK_CustomerID = DC.SK_CustomerID 
    LEFT OUTER JOIN master.DimDate AS DD 
        ON FW.SK_DateID_DatePlaced = DD.SK_DateID 
ORDER BY 
    DC.CustomerID, 
    DS.Symbol, 
    DD.DateValue;