select SK_SecurityID, Symbol, Issue, Status, Name, ExchangeID,
SK_CompanyID, SharesOutstanding, FirstTrade, FirstTradeOnExchange,
Dividend, IsCurrent, BatchID, EffectiveDate, EndDate from master.DimSecurity
order by Symbol, EffectiveDate;