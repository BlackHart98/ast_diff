select FCB.SK_CustomerID, FCB.SK_AccountID, FCB.SK_DateID,
FCB.Cash, FCB.BatchID, DA.AccountID, DD.DateValue from master.FactCashBalances as FCB left outer join
master.DimAccount as DA on FCB.SK_AccountID=DA.SK_AccountID left outer
join master.DimCustomer as DC on FCB.SK_CustomerID=DC. SK_CustomerID left
outer join master.DimDate as DD on FCB.SK_DateID=DD.SK_DateID order by
DA.AccountID, DD.DateValue;