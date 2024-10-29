select SK_BrokerID, BrokerID, ManagerID, FirstName, LastName,
MiddleInitial, Branch, Office, Phone, IsCurrent, BatchID, EffectiveDate,
EndDate from master.DimBroker order by BrokerID, EffectiveDate