SELECT * FROM (SELECT "apple" AS fruit, "carrot" AS vegetable);

WITH groceries AS
  (SELECT "milk" AS dairy,
   "eggs" AS protein,
   "bread" AS grain)
SELECT g.*
FROM groceries AS g;

WITH locations AS
  (SELECT STRUCT("Seattle" AS city, "Washington" AS state) AS location
  UNION ALL
  SELECT STRUCT("Phoenix" AS city, "Arizona" AS state) AS location)
SELECT l.location.*
FROM locations l;

-- WITH locations AS
--   (SELECT ARRAY<STRUCT<city STRING, state STRING>>[("Seattle", "Washington"),
--     ("Phoenix", "Arizona")] AS location)
-- SELECT l.LOCATION[offset(0)].*
-- FROM locations l;

WITH orders AS
  (SELECT 5 as order_id,
  "sprocket" as item_name,
  200 as quantity)
SELECT * EXCEPT (order_id)
FROM orders;

WITH orders AS
  (SELECT 5 as order_id,
  "sprocket" as item_name,
  200 as quantity)
SELECT * REPLACE ("widget" AS item_name)
FROM orders;

WITH orders AS
  (SELECT 5 as order_id,
  "sprocket" as item_name,
  200 as quantity)
SELECT * REPLACE (quantity/2 AS quantity)
FROM orders;

SELECT ARRAY(SELECT AS STRUCT 1 a, 2 b);

SELECT AS VALUE STRUCT(1 AS a, 2 AS b) xyz;

SELECT * FROM UNNEST ([10,20,30]) as numbers WITH OFFSET;

SELECT *
FROM UNNEST(
  ARRAY<
    STRUCT<
      x INT64,
      y STRING,
      z STRUCT<a INT64, b INT64>>>[
        (1, 'foo', (10, 11)),
        (3, 'bar', (20, 21))]);

SELECT *, struct_value
FROM UNNEST(
  ARRAY<
    STRUCT<
    x INT64,
    y STRING>>[
      (1, 'foo'),
      (3, 'bar')]) AS struct_value;


WITH Produce AS (
  SELECT 'Kale' as product, 51 as sales, 'Q1' as quarter, 2020 as year UNION ALL
  SELECT 'Kale', 23, 'Q2', 2020 UNION ALL
  SELECT 'Kale', 45, 'Q3', 2020 UNION ALL
  SELECT 'Kale', 3, 'Q4', 2020 UNION ALL
  SELECT 'Kale', 70, 'Q1', 2021 UNION ALL
  SELECT 'Kale', 85, 'Q2', 2021 UNION ALL
  SELECT 'Apple', 77, 'Q1', 2020 UNION ALL
  SELECT 'Apple', 0, 'Q2', 2020 UNION ALL
  SELECT 'Apple', 1, 'Q1', 2021)
SELECT * FROM Produce

SELECT * FROM
  (SELECT sales, quarter FROM Produce)
  PIVOT(SUM(sales) FOR quarter IN ('Q1', 'Q2', 'Q3'))

SELECT * FROM Produce
UNPIVOT(sales FOR quarter IN (Q1, Q2, Q3, Q4))

SELECT * FROM Produce
UNPIVOT(
  (first_half_sales, second_half_sales)
  FOR semesters
  IN ((Q1, Q2) AS 'semester_1', (Q3, Q4) AS 'semester_2'))

SELECT * FROM dataset.my_table TABLESAMPLE SYSTEM (10 PERCENT)

SELECT Roster.LastName, TeamMascot.Mascot
FROM Roster JOIN TeamMascot ON Roster.SchoolID = TeamMascot.SchoolID;

SELECT Roster.LastName, TeamMascot.Mascot
FROM Roster CROSS JOIN TeamMascot;

SELECT Roster.LastName, TeamMascot.Mascot
FROM Roster LEFT JOIN TeamMascot ON Roster.SchoolID = TeamMascot.SchoolID;

SELECT * FROM Roster INNER JOIN TeamMascot USING (SchoolID);

SELECT x FROM A JOIN B USING (x);
SELECT A.x FROM A JOIN B ON A.x = B.x;

SELECT *
FROM
  Roster
JOIN
  UNNEST(
    ARRAY(
      SELECT AS STRUCT *
      FROM PlayerStats
      WHERE PlayerStats.OpponentID = Roster.SchoolID
    )) AS PlayerMatches
  ON PlayerMatches.LastName = 'Buchanan';

SELECT A.name, item, ARRAY_LENGTH(A.items) item_count_for_name
FROM
  UNNEST(
    [
      STRUCT(
        'first' AS name,
        [1, 2, 3, 4] AS items),
      STRUCT(
        'second' AS name,
        [] AS items)]) AS A
LEFT JOIN
  A.items AS item;

SELECT A.name, item
FROM
  UNNEST(
    [
      STRUCT(
        'first' AS name,
        [1, 2, 3, 4] AS items),
      STRUCT(
        'second' AS name,
        [] AS items)]) AS A
CROSS JOIN
  A.items AS item;


SELECT * FROM Roster
WHERE SchoolID = 52;

SELECT * FROM Roster
WHERE STARTS_WITH(LastName, "Mc") OR STARTS_WITH(LastName, "Mac");

WITH PlayerStats AS (
  SELECT 'Adams' as LastName, 'Noam' as FirstName, 3 as PointsScored UNION ALL
  SELECT 'Buchanan', 'Jie', 0 UNION ALL
  SELECT 'Coolidge', 'Kiran', 1 UNION ALL
  SELECT 'Adams', 'Noam', 4 UNION ALL
  SELECT 'Buchanan', 'Jie', 13)
SELECT SUM(PointsScored) AS total_points, LastName
FROM PlayerStats
GROUP BY LastName;

WITH PlayerStats AS (
  SELECT 'Adams' as LastName, 'Noam' as FirstName, 3 as PointsScored UNION ALL
  SELECT 'Buchanan', 'Jie', 0 UNION ALL
  SELECT 'Coolidge', 'Kiran', 1 UNION ALL
  SELECT 'Adams', 'Noam', 4 UNION ALL
  SELECT 'Buchanan', 'Jie', 13)
SELECT SUM(PointsScored) AS total_points, LastName AS last_name
FROM PlayerStats
GROUP BY last_name;

WITH PlayerStats AS (
  SELECT 'Adams' as LastName, 'Noam' as FirstName, 3 as PointsScored UNION ALL
  SELECT 'Buchanan', 'Jie', 0 UNION ALL
  SELECT 'Coolidge', 'Kiran', 1 UNION ALL
  SELECT 'Adams', 'Noam', 4 UNION ALL
  SELECT 'Buchanan', 'Jie', 13)
SELECT SUM(PointsScored) AS total_points, LastName, FirstName
FROM PlayerStats
GROUP BY 2, 3;

WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY GROUPING SETS (product_type, product_name)
ORDER BY product_name

WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, NULL, SUM(product_count) AS product_sum
FROM Products
GROUP BY product_type
UNION ALL
SELECT NULL, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY product_name
ORDER BY product_name

WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY GROUPING SETS (
  product_type,
  (product_type, product_name))
ORDER BY product_type, product_name;

WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY GROUPING SETS(
  product_type,
  (product_type, product_name),
  product_type,
  ())
ORDER BY product_type, product_name;

WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY GROUPING SETS (
  product_type,
  CUBE (product_type, product_name))
ORDER BY product_type, product_name;

-- GROUP BY with ROLLUP
WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY ROLLUP (product_type, product_name)
ORDER BY product_type, product_name;


WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY product_type, product_name
UNION ALL
SELECT product_type, NULL, SUM(product_count)
FROM Products
GROUP BY product_type
UNION ALL
SELECT NULL, NULL, SUM(product_count) FROM Products
ORDER BY product_type, product_name;

-- GROUP BY with CUBE
WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY CUBE (product_type, product_name)
ORDER BY product_type, product_name;

WITH
  Products AS (
    SELECT 'shirt' AS product_type, 't-shirt' AS product_name, 3 AS product_count UNION ALL
    SELECT 'shirt', 't-shirt', 8 UNION ALL
    SELECT 'shirt', 'polo', 25 UNION ALL
    SELECT 'pants', 'jeans', 6
  )
SELECT product_type, product_name, SUM(product_count) AS product_sum
FROM Products
GROUP BY CUBE (product_type, (product_type, product_name))
ORDER BY product_type, product_name;

SELECT LastName
FROM Roster
GROUP BY LastName
HAVING SUM(PointsScored) > 15;

SELECT LastName, SUM(PointsScored) AS ps
FROM Roster
GROUP BY LastName
HAVING ps > 0;

SELECT LastName, COUNT(s)
FROM PlayerStats
GROUP BY LastName
HAVING SUM(PointsScored) > 15;

SELECT x, y
FROM (SELECT 1 AS x, true AS y UNION ALL
      SELECT 9, true UNION ALL
      SELECT NULL, false)
ORDER BY x NULLS LAST;

SELECT x, y
FROM (SELECT 1 AS x, true AS y UNION ALL
      SELECT 9, true UNION ALL
      SELECT NULL, false)
ORDER BY x DESC;

SELECT x, y
FROM (SELECT 1 AS x, true AS y UNION ALL
      SELECT 9, true UNION ALL
      SELECT NULL, false)
ORDER BY x DESC NULLS FIRST;

SELECT LastName, PointsScored, OpponentID
FROM PlayerStats
ORDER BY SchoolID, LastName;

SELECT * FROM Roster
UNION ALL
( SELECT * FROM TeamMascot
  ORDER BY SchoolID );

SELECT * FROM UNNEST(ARRAY<int64>[1, 2, 3]) AS number
EXCEPT DISTINCT SELECT 1;

SELECT *
FROM UNNEST(ARRAY<STRING>['a', 'b', 'c', 'd', 'e']) AS letter
ORDER BY letter ASC LIMIT 2

SELECT *
FROM UNNEST(ARRAY<STRING>['a', 'b', 'c', 'd', 'e']) AS letter
ORDER BY letter ASC LIMIT 3 OFFSET 1

WITH subQ1 AS (SELECT SchoolID FROM Roster),
     subQ2 AS (SELECT OpponentID FROM PlayerStats)
SELECT * FROM subQ1
UNION ALL
SELECT * FROM subQ2

WITH q1 AS (my_query)
SELECT *
FROM
  (WITH q2 AS (SELECT * FROM q1) SELECT * FROM q2)

WITH RECURSIVE
  T1 AS ( (SELECT 1 AS n) UNION ALL (SELECT n + 1 AS n FROM T1 WHERE n < 3) )
SELECT n FROM T1

WITH RECURSIVE
  T1 AS (
    (SELECT 1 AS n) UNION ALL
    (SELECT n + 2 FROM T1 WHERE n < 4))
SELECT * FROM T1 ORDER BY n

WITH RECURSIVE
  T0 AS (SELECT 1 AS n),
  T1 AS ((SELECT * FROM T0) UNION ALL (SELECT n + 1 FROM T1 WHERE n < 4)),
  T2 AS ((SELECT 1 AS n) UNION ALL (SELECT n + 1 FROM T2 WHERE n < 4)),
  T3 AS (SELECT * FROM T1 INNER JOIN T2 USING (n))
SELECT * FROM T3 ORDER BY n

WITH RECURSIVE
  T0 AS (SELECT 1 AS n),
  T1 AS ((SELECT 1 AS n) UNION ALL (SELECT n + 1 FROM T1 INNER JOIN T0 USING (n)))
SELECT * FROM T1 ORDER BY n

WITH RECURSIVE
  T0 AS (SELECT 2 AS p),
  T1 AS ((SELECT 1 AS n) UNION ALL (SELECT T1.n + T0.p FROM T1 CROSS JOIN T0 WHERE T1.n < 4))
SELECT * FROM T1 CROSS JOIN T0 ORDER BY n

WITH RECURSIVE
  T0 AS (SELECT 1 AS n),
  T1 AS ((SELECT 1 AS n) UNION ALL (SELECT * FROM T1 FULL OUTER JOIN T0 USING (n)))
SELECT * FROM T1;

WITH RECURSIVE
  A AS (SELECT 1 AS n UNION ALL (SELECT n + 1 FROM A WHERE n < 3))
SELECT * FROM A

SELECT WITH AGGREGATION_THRESHOLD
  OPTIONS(threshold=4)
  test_id,
  COUNT(w) AS student_count,
  AVG(test_score) AS avg_test_score
FROM mydataset.ExamView
GROUP BY test_id;

SELECT
  WITH DIFFERENTIAL_PRIVACY
    OPTIONS(epsilon=10, delta=.01, max_groups_contributed=2, privacy_unit_column=id)
    item,
    AVG(quantity, contribution_bounds_per_group = (0,100)) average_quantity
FROM professors
GROUP BY item;


SELECT SingerID AS sid, COUNT(Songid) AS s2id
FROM Songs
GROUP BY 1
ORDER BY 2 DESC;

SELECT * FROM (SELECT AS VALUE STRUCT(123 AS a, FALSE AS b))

