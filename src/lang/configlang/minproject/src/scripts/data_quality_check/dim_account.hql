select SK_AccountID, AccountID, SK_BrokerID, SK_CustomerID, Status,
AccountDesc, TaxStatus, IsCurrent, BatchID, EffectiveDate, EndDate
from master.DimAccount order by AccountID, EffectiveDate;