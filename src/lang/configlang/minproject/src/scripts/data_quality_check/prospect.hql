SELECT 
    P.AgencyID, 
    P.SK_RecordDateID, 
    P.SK_UpdateDateID, 
    P.BatchID,
    P.IsCustomer, 
    P.LastName, 
    P.FirstName, 
    P.MiddleInitial, 
    P.Gender,
    P.AddressLine1, 
    P.AddressLine2, 
    P.PostalCode, 
    P.City, 
    P.State, 
    P.Country,
    P.Phone, 
    P.Income, 
    P.NumberCars, 
    P.NumberChildren, 
    P.MaritalStatus,
    P.Age, 
    P.CreditRating, 
    P.OwnOrRentFlag, 
    P.Employer,
    P.NumberCreditCards, 
    P.NetWorth, 
    P.MarketingNameplate,
    DD.DateValue               -- Include DateValue for ORDER BY
FROM 
    master.Prospect AS P 
    LEFT OUTER JOIN master.DimDate AS DD 
        ON P.SK_UpdateDateID = DD.SK_DateID 
ORDER BY 
    P.LastName, 
    P.FirstName,
    DD.DateValue;