CREATE VIEW test AS
SELECT 
orderkey, 
orderstatus, 
totalprice / 2 AS half
FROM orders;

CREATE VIEW orders_by_date AS
SELECT orderdate, sum(totalprice) AS price
FROM orders
GROUP BY orderdate;

CREATE OR REPLACE VIEW test AS
SELECT orderkey, orderstatus, totalprice / 4 AS quarter
FROM orders;