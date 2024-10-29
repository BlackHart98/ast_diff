UPDATE dataset.Inventory
SET quantity = quantity - 10,
    supply_constrained = DEFAULT
WHERE product like '%washer%'

UPDATE dataset.Inventory
SET quantity = quantity +
  (SELECT quantity FROM dataset.NewArrivals
   WHERE Inventory.product = NewArrivals.product),
    supply_constrained = false
WHERE product IN (SELECT product FROM dataset.NewArrivals)

UPDATE dataset.Inventory i
SET quantity = i.quantity + n.quantity,
    supply_constrained = false
FROM dataset.NewArrivals n
WHERE i.product = n.product

UPDATE dataset.DetailedInventory
SET specifications.color = 'white',
    specifications.warranty = '1 year'
WHERE product like '%washer%'

UPDATE dataset.DetailedInventory
SET specifications
   = STRUCT<color STRING, warranty STRING,
   dimensions STRUCT<depth FLOAT64, height FLOAT64, width FLOAT64>>('white', '1 year', NULL)
WHERE product like '%washer%'

UPDATE dataset.DetailedInventory
SET comments = ARRAY(
  SELECT comment FROM UNNEST(comments) AS comment
  UNION ALL
  SELECT (CAST('2016-01-01' AS DATE), 'comment1')
)
WHERE product like '%washer%'

UPDATE dataset.DetailedInventory
SET comments = ARRAY_CONCAT(comments,
  ARRAY<STRUCT<created DATE, comment STRING>>[(CAST('2016-01-01' AS DATE), 'comment1')])
WHERE product like '%washer%'

UPDATE dataset.DetailedInventory
SET comments = ARRAY(
  SELECT comment FROM UNNEST(comments) AS comment
  UNION ALL
  SELECT (CAST('2016-01-01' AS DATE), 'comment2')
)
WHERE true

SELECT product, comments FROM dataset.DetailedInventory

UPDATE dataset.DetailedInventory
SET comments = ARRAY(
  SELECT c FROM UNNEST(comments) AS c
  WHERE c.comment NOT LIKE '%comment2%'
)
WHERE true

UPDATE dataset.DetailedInventory
SET comments = ARRAY(
  SELECT c FROM UNNEST(comments) AS c
  WHERE c.comment NOT LIKE '%comment2%'
)
WHERE true

UPDATE dataset.DetailedInventory
SET supply_constrained = true
FROM dataset.NewArrivals, dataset.Warehouse
WHERE DetailedInventory.product = NewArrivals.product AND
      NewArrivals.warehouse = Warehouse.warehouse AND
      Warehouse.state = 'WA'

UPDATE dataset.DetailedInventory
SET supply_constrained = true
FROM dataset.NewArrivals
INNER JOIN dataset.Warehouse
ON NewArrivals.warehouse = Warehouse.warehouse
WHERE DetailedInventory.product = NewArrivals.product AND
      Warehouse.state = 'WA'