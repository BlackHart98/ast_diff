select SK_CompanyID, CompanyID, Status, Name, Industry, SPrating,
isLowGrade, CEO, AddressLine1, AddressLine2, PostalCode, City,
StateProv, Country, Description, FoundingDate, IsCurrent, BatchID,
EffectiveDate, EndDate from master.DimCompany order by CompanyID,
EffectiveDate;