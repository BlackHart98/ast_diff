select SK_CustomerID, CustomerID, TaxID, Status, LastName, FirstName,
MiddleInitial, Gender, Tier, DOB, AddressLine1, AddressLine2,
PostalCode, City, StateProv, Country, Phone1, Phone2, Phone3, Email1,
Email2, NationalTaxRateDesc, NationalTaxRate, LocalTaxRateDesc,
LocalTaxRate, AgencyID, CreditRating, NetWorth, MarketingNameplate,
IsCurrent, BatchID, EffectiveDate, EndDate from master.DimCustomer order by
CustomerID, EffectiveDate;