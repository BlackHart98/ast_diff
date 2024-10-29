select TradeID, SK_BrokerID, SK_CreateDateID, SK_CreateTimeID,
SK_CloseDateID, SK_CloseTimeID, Status, Type, CashFlag, SK_SecurityID,
SK_CompanyID, Quantity, BidPrice, SK_CustomerID, SK_AccountID,
ExecutedBy, TradePrice, Fee, Commission, Tax, BatchID from master.DimTrade
order by TradeID, Status;