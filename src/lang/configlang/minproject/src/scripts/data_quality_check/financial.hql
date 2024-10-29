SELECT 
    FIN.SK_CompanyID, 
    FIN.FI_YEAR, 
    FIN.FI_QTR,
    FIN.FI_QTR_START_DATE, 
    FIN.FI_REVENUE, 
    FIN.FI_NET_EARN,
    FIN.FI_BASIC_EPS, 
    FIN.FI_DILUT_EPS, 
    FIN.FI_MARGIN,
    FIN.FI_INVENTORY, 
    FIN.FI_ASSETS, 
    FIN.FI_LIABILITY, 
    FIN.FI_OUT_BASIC,
    FIN.FI_OUT_DILUT,
    DC.CompanyID              -- Include CompanyID for ORDER BY
FROM 
    master.Financial AS FIN 
    LEFT OUTER JOIN master.DimCompany AS DC 
        ON FIN.SK_CompanyID = DC.SK_CompanyID 
ORDER BY 
    DC.CompanyID, 
    FIN.FI_QTR_START_DATE;