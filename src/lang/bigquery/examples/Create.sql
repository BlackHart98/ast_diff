CREATE SCHEMA mydataset
OPTIONS(
  location="us",
  default_table_expiration_days=3.75,
  labels=[("label1","value1"),("label2","value2")]
  )

CREATE SCHEMA mydataset
OPTIONS(
  is_case_insensitive=TRUE
)

CREATE SCHEMA mydataset
DEFAULT COLLATE 'und:ci'

CREATE TABLE mydataset.newtable
(
  x INT64 OPTIONS(description="An optional INTEGER field"),
  y STRUCT<
    a ARRAY<STRING> OPTIONS(description="A repeated STRING field"),
    b BOOL
  >
)
PARTITION BY _PARTITIONDATE
OPTIONS(
  expiration_timestamp=TIMESTAMP "2025-01-01 00:00:00 UTC",
  partition_expiration_days=1,
  description="a table that expires in 2025, with each partition living for 24 hours",
  labels=[("org_unit", "development")]
)

CREATE TABLE mydataset.top_words
OPTIONS(
  description="Top ten words per Shakespeare corpus"
) AS
SELECT
  corpus,
  ARRAY_AGG(STRUCT(word, word_count) ORDER BY word_count DESC LIMIT 10) AS top_words
FROM bigquery-public-data.samples.shakespeare
GROUP BY corpus;

CREATE TABLE IF NOT EXISTS mydataset.newtable (x INT64, y STRUCT<a ARRAY<STRING>, b BOOL>)
OPTIONS(
  expiration_timestamp=TIMESTAMP "2025-01-01 00:00:00 UTC",
  description="a table that expires in 2025",
  labels=[("org_unit", "development")]
)

CREATE OR REPLACE TABLE mydataset.newtable (x INT64, y STRUCT<a ARRAY<STRING>, b BOOL>)
OPTIONS(
  expiration_timestamp=TIMESTAMP "2025-01-01 00:00:00 UTC",
  description="a table that expires in 2025",
  labels=[("org_unit", "development")]
)

CREATE TABLE mydataset.newtable (
  x INT64 NOT NULL,
  y STRUCT<
    a ARRAY<STRING>,
    b BOOL NOT NULL,
    c FLOAT64
  > NOT NULL,
  z STRING
)

CREATE TABLE mydataset.newtable (
  a STRING,
  b STRING,
  c STRUCT<
    x FLOAT64,
    y ARRAY<STRING>
  >
)
DEFAULT COLLATE 'und:ci';

CREATE TABLE mydataset.newtable (
  x STRING(10),
  y STRUCT<
    a ARRAY<BYTES(5)>,
    b NUMERIC(15, 2) OPTIONS(rounding_mode = 'ROUND_HALF_EVEN'),
    c FLOAT64
  >,
  z BIGNUMERIC(35)
)


CREATE TABLE mydataset.newtable (transaction_id INT64, transaction_date DATE)
PARTITION BY transaction_date
OPTIONS(
  partition_expiration_days=3,
  description="a table partitioned by transaction_date"
)

CREATE TABLE mydataset.days_with_rain
PARTITION BY date
OPTIONS (
  partition_expiration_days=365,
  description="weather stations with precipitation, partitioned by day"
) AS
SELECT
  DATE(CAST(year AS INT64), CAST(mo AS INT64), CAST(da AS INT64)) AS date,
  (SELECT ANY_VALUE(name) FROM `bigquery-public-data.noaa_gsod.stations` AS stations
   WHERE stations.usaf = stn) AS station_name,  -- Stations can have multiple names
  prcp
FROM `bigquery-public-data.noaa_gsod.gsod2017` AS weather
WHERE prcp != 99.9  -- Filter unknown values
  AND prcp > 0      -- Filter stations/days with no precipitation

CREATE TABLE mydataset.myclusteredtable
(
  timestamp TIMESTAMP,
  customer_id STRING,
  transaction_amount NUMERIC
)
PARTITION BY DATE(timestamp)
CLUSTER BY customer_id
OPTIONS (
  partition_expiration_days=3,
  description="a table clustered by customer_id"
)

CREATE TABLE mydataset.myclusteredtable
(
  customer_id STRING,
  transaction_amount NUMERIC
)
PARTITION BY DATE(_PARTITIONTIME)
CLUSTER BY
  customer_id
OPTIONS (
  partition_expiration_days=3,
  description="a table clustered by customer_id"
)

CREATE TABLE mydataset.myclusteredtable
(
  customer_id STRING,
  transaction_amount NUMERIC
)
CLUSTER BY
  customer_id
OPTIONS (
  description="a table clustered by customer_id"
)

CREATE TABLE mydataset.myclusteredtable
(
  timestamp TIMESTAMP,
  customer_id STRING,
  transaction_amount NUMERIC
)
PARTITION BY DATE(timestamp)
CLUSTER BY
  customer_id
OPTIONS (
  partition_expiration_days=3,
  description="a table clustered by customer_id"
)
AS SELECT * FROM mydataset.myothertable;

CREATE TEMP TABLE Example
(
  x INT64,
  y STRING
);

INSERT INTO Example
VALUES (5, 'foo');

INSERT INTO Example
VALUES (6, 'bar');

SELECT *
FROM Example;

CREATE OR REPLACE TABLE
  myotherdataset.orders
  PARTITION BY DATE_TRUNC(l_commitdate, YEAR) AS
SELECT
  *
FROM
  myawsdataset.orders
WHERE
  EXTRACT(YEAR FROM l_commitdate) = 1992;

CREATE TABLE mydataset.newtable
LIKE mydataset.sourcetable
AS SELECT * FROM mydataset.myothertable;

CREATE SNAPSHOT TABLE `myproject.mydataset.mytablesnapshot`
CLONE `myproject.mydataset.mytable`
OPTIONS(
  partition_expiration_days=3,
  description="a table clustered by customer_id"
);

CREATE SNAPSHOT TABLE IF NOT EXISTS `myproject.mydataset.mytablesnapshot`
CLONE `myproject.mydataset.mytable`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR),
  friendly_name="my_table_snapshot",
  description="A table snapshot that expires in 2 days",
  labels=[("org_unit", "development")]
);

CREATE TABLE `myproject.mydataset.mytable`
CLONE `myproject.mydataset.mytablesnapshot`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 365 DAY),
  friendly_name="my_table",
  description="A table that expires in 1 year",
  labels=[("org_unit", "development")]
);

CREATE TABLE IF NOT EXISTS `myproject.mydataset.mytableclone`
CLONE `myproject.mydataset.mytable`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 365 DAY),
  friendly_name="my_table",
  description="A table that expires in 1 year",
  labels=[("org_unit", "development")]
);

CREATE VIEW mydataset.age_groups(age, count) AS SELECT age, COUNT(*)
FROM mydataset.people
group by age;

CREATE MATERIALIZED VIEW myProject.myDataset.myView AS SELECT * FROM anotherDataset.myTable;


CREATE MATERIALIZED VIEW `myproject.mydataset.new_mv`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR),
  friendly_name="new_mv",
  description="a materialized view that expires in 2 days",
  labels=[("org_unit", "development")],
  enable_refresh=true,
  refresh_interval_minutes=20
)
AS SELECT column_1, SUM(column_2) AS sum_2, AVG(column_3) AS avg_3
FROM `myproject.mydataset.mytable`
GROUP BY column_1;

CREATE MATERIALIZED VIEW IF NOT EXISTS `myproject.mydataset.new_mv`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR),
  friendly_name="new_mv",
  description="a view that expires in 2 days",
  labels=[("org_unit", "development")],
  enable_refresh=false
)
AS SELECT column_1, column_2, column_3 FROM `myproject.mydataset.mytable`;

CREATE OR REPLACE EXTERNAL TABLE mydataset.newtable (x INT64, y STRING, z BOOL)
  WITH CONNECTION myconnection
  OPTIONS(
    format ="PARQUET",
    max_staleness = STALENESS_INTERVAL,
    metadata_cache_mode = 'AUTOMATIC');

CREATE EXTERNAL TABLE dataset.CsvTable OPTIONS (
  format = 'CSV',
  uris = ['gs://bucket/path1.csv', 'gs://bucket/path2.csv']
);

CREATE OR REPLACE EXTERNAL TABLE dataset.CsvTable
(
  x INT64,
  y STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bucket/path1.csv'],
  field_delimiter = '|',
  max_bad_records = 5
);

CREATE EXTERNAL TABLE dataset.AutoHivePartitionedTable
WITH PARTITION COLUMNS
OPTIONS (
  uris = ['gs://bucket/path/*'],
  format = 'PARQUET',
  hive_partition_uri_prefix = 'gs://bucket/path',
  require_hive_partition_filter = false);

CREATE EXTERNAL TABLE dataset.CustomHivePartitionedTable
WITH PARTITION COLUMNS (
  field_1 STRING, -- column order must match the external path
  field_2 INT64)
OPTIONS (
  uris = ['gs://bucket/path/*'],
  format = """PARQUET""",
  hive_partition_uri_prefix = 'gs://bucket/path',
  require_hive_partition_filter = false);

CREATE FUNCTION mydataset.multiplyInputs(x FLOAT64, y FLOAT64)
RETURNS FLOAT64
AS (x * y);

CREATE TEMP FUNCTION multiplyInputs(x FLOAT64, y FLOAT64)
RETURNS FLOAT64
LANGUAGE js
AS r"""
  return x*y;
""";

SELECT multiplyInputs(a, b) FROM (SELECT 3 as a, 2 as b);

CREATE FUNCTION mydataset.remoteMultiplyInputs(x FLOAT64, y FLOAT64)
RETURNS FLOAT64
REMOTE WITH CONNECTION us.myconnection
OPTIONS(endpoint="https://us-central1-myproject.cloudfunctions.net/multiply");

CREATE OR REPLACE TABLE FUNCTION mydataset.names_by_year(y INT64)
RETURNS TABLE<name STRING, year INT64, total INT64>
AS
  SELECT year, name, SUM(number) AS total
  FROM `bigquery-public-data.usa_names.usa_1910_current`
  WHERE year = y
  GROUP BY year, name;

CREATE PROCEDURE mydataset.AddDelta(INOUT x INT64, delta INT64)
BEGIN
  SET x = x + delta
END;

-- CREATE PROCEDURE mydataset.SelectFromTablesAndAppend(
--   target_date DATE, OUT rows_added INT64)
-- BEGIN
--   CREATE TEMP TABLE DataForTargetDate AS
--   SELECT t1.id, t1.x, t2.y
--   FROM dataset.partitioned_table1 AS t1
--   JOIN dataset.partitioned_table2 AS t2
--   ON t1.id = t2.id
--   WHERE t1.date = target_date
--     AND t2.date = target_date

--   SET rows_added = (SELECT COUNT(*) FROM DataForTargetDate)

--   SELECT id, x, y, target_date  -- note that target_date is a parameter
--   FROM DataForTargetDate

--   DROP TABLE DataForTargetDate
-- END

CREATE CAPACITY `admin_project.region-us.my-commitment`
OPTIONS (
  slot_count = 100,
  plan = 'ANNUAL');

CREATE TABLE dataset.complex_table(
  a STRING,
  my_struct STRUCT<string_field STRING, int_field INT64>,
  b ARRAY<STRING>
);

CREATE SEARCH INDEX my_index
ON dataset.complex_table(a, my_struct, b)
OPTIONS (analyzer = 'NO_OP_ANALYZER');