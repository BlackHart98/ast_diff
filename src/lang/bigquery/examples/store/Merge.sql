MERGE dataset.DetailedInventory T
USING dataset.Inventory S
ON T.product = S.product
WHEN NOT MATCHED AND quantity < 20 THEN
  INSERT(product, quantity, supply_constrained, comments)
  VALUES(product, quantity, true, ARRAY<STRUCT<created DATE, comment STRING>>[(DATE('2016-01-01'), 'comment1')])
WHEN NOT MATCHED THEN
  INSERT(product, quantity, supply_constrained)
  VALUES(product, quantity, false)

MERGE dataset.Inventory T
USING dataset.NewArrivals S
ON T.product = S.product
WHEN MATCHED THEN
  UPDATE SET quantity = T.quantity + S.quantity
WHEN NOT MATCHED THEN
  INSERT (product, quantity) VALUES(product, quantity)

MERGE dataset.NewArrivals T
USING (SELECT * FROM dataset.NewArrivals WHERE warehouse <> 'warehouse #2') S
ON T.product = S.product
WHEN MATCHED AND T.warehouse = 'warehouse #1' THEN
  UPDATE SET quantity = T.quantity + 20
WHEN MATCHED THEN
  DELETE

MERGE dataset.Inventory T
USING dataset.NewArrivals S
ON FALSE
WHEN NOT MATCHED AND product LIKE '%washer%' THEN
  INSERT (product, quantity) VALUES(product, quantity)
WHEN NOT MATCHED BY SOURCE AND product LIKE '%washer%' THEN
  DELETE

MERGE dataset.DetailedInventory T
USING dataset.Inventory S
ON T.product = S.product
WHEN MATCHED AND S.quantity < (SELECT AVG(quantity) FROM dataset.Inventory) THEN
  UPDATE SET comments = ARRAY_CONCAT(comments, ARRAY<STRUCT<created DATE, comment STRING>>[(CAST('2016-02-01' AS DATE), 'comment2')])

MERGE dataset.Inventory T
USING (SELECT product, quantity, state FROM dataset.NewArrivals t1 JOIN dataset.Warehouse t2 ON t1.warehouse = t2.warehouse) S
ON T.product = S.product
WHEN MATCHED AND state = 'CA' THEN
  UPDATE SET quantity = T.quantity + S.quantity
WHEN MATCHED THEN
  DELETE

MERGE dataset.Inventory T
USING dataset.NewArrivals S
ON T.product = S.product
WHEN MATCHED THEN
  UPDATE SET quantity = T.quantity + S.quantity

MERGE dataset.NewArrivals
USING (SELECT * FROM UNNEST([('microwave', 10, 'warehouse #1'),
                             ('dryer', 30, 'warehouse #1'),
                             ('oven', 20, 'warehouse #2')]))
ON FALSE
WHEN NOT MATCHED THEN
  INSERT ROW
WHEN NOT MATCHED BY SOURCE THEN
  DELETE