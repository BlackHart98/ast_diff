INSERT dataset.Inventory (product, quantity)
VALUES('top load washer', 10),
      ('front load washer', 20),
      ('dryer', 30),
      ('refrigerator', 10),
      ('microwave', 20),
      ('dishwasher', 30),
      ('oven', 5);


ALTER TABLE dataset.NewArrivals ALTER COLUMN quantity SET DEFAULT 100;

INSERT dataset.NewArrivals (product, quantity, warehouse)
VALUES('top load washer', DEFAULT, 'warehouse #1'),
      ('dryer', 200, 'warehouse #2'),
      ('oven', 300, 'warehouse #3');

INSERT dataset.Warehouse (warehouse, state)
SELECT *
FROM UNNEST([('warehouse #1', 'WA'),
      ('warehouse #2', 'CA'),
      ('warehouse #3', 'WA')])

INSERT dataset.Warehouse (warehouse, state)
WITH w AS (
  SELECT ARRAY<STRUCT<warehouse string, state string>>
      [('warehouse #1', 'WA'),
       ('warehouse #2', 'CA'),
       ('warehouse #3', 'WA')] col
)
SELECT warehouse, state FROM w, UNNEST(w.col)

INSERT dataset.DetailedInventory (product, quantity, supply_constrained)
SELECT product, quantity, false
FROM dataset.Inventory;

-- INSERT dataset.DetailedInventory (product, quantity)
-- VALUES('countertop microwave',
--   (SELECT quantity FROM dataset.DetailedInventory
--    WHERE product = 'microwave'))

INSERT dataset.Warehouse VALUES('warehouse #4', 'WA'), ('warehouse #5', 'NY')

INSERT dataset.DetailedInventory
VALUES('top load washer', 10, FALSE, [(CURRENT_DATE, "comment1")], ("white","1 year",(30,40,28))),
      ('front load washer', 20, FALSE, [(CURRENT_DATE, "comment1")], ("beige","1 year",(35,45,30)))


CREATE TABLE IF NOT EXISTS dataset.table1 (names ARRAY<STRING>);

INSERT INTO dataset.table1 (names)
VALUES (["name1","name2"])

