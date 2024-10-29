ALTER SCHEMA mydataset
SET DEFAULT COLLATE 'und:ci'

ALTER SCHEMA mydataset
SET OPTIONS(
  default_table_expiration_days=3.75
  )

ALTER SCHEMA mydataset
SET OPTIONS(
  is_case_insensitive=TRUE
)

ALTER SCHEMA cross_region_dataset
ADD REPLICA `EU` OPTIONS(location=`eu`);

ALTER TABLE mydataset.mytable
SET OPTIONS (
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 7 DAY),
  description="Table that expires seven days from now"
)

ALTER TABLE mydataset.mytable
SET OPTIONS (expiration_timestamp=NULL)

ALTER TABLE mydataset.mytable
  ADD COLUMN A STRING,
  ADD COLUMN IF NOT EXISTS B GEOGRAPHY,
  ADD COLUMN C ARRAY<NUMERIC>,
  ADD COLUMN D DATE OPTIONS(description="my description")

ALTER TABLE mydataset.mytable
   ADD COLUMN A STRUCT<
       B GEOGRAPHY,
       C ARRAY<INT64>,
       D INT64 NOT NULL,
       E TIMESTAMP OPTIONS(description="creation time")
       >

ALTER TABLE mydataset.mytable
ADD COLUMN word STRING COLLATE 'und:ci'

ALTER TABLE fk_table
ADD PRIMARY KEY (x,y) NOT ENFORCED,
ADD CONSTRAINT fk FOREIGN KEY (u, v) REFERENCES pk_table(x, y) NOT ENFORCED,
ADD CONSTRAINT fk2 FOREIGN KEY (i, j) REFERENCES pk_table(x, y) NOT ENFORCED;


ALTER TABLE pk_table ADD PRIMARY KEY (x,y) NOT ENFORCED;

ALTER TABLE mydataset.mytable
  RENAME COLUMN A TO columnA,
  RENAME COLUMN IF EXISTS B TO columnB;

ALTER TABLE mydataset.mytable
  RENAME COLUMN columnA TO temp,
  RENAME COLUMN columnB TO columnA,
  RENAME COLUMN temp TO columnB;

ALTER TABLE mytable DROP CONSTRAINT myConstraint;

ALTER TABLE myTable
DROP PRIMARY KEY;

ALTER TABLE mydataset.mytable
ALTER COLUMN price
SET OPTIONS (description = 'Price per unit');

ALTER VIEW mydataset.myview
ALTER COLUMN total
SET OPTIONS (description = 'Total sales of the product');

CREATE TABLE dataset.table(c1 INT64);

ALTER TABLE dataset.table ALTER COLUMN c1 SET DATA TYPE NUMERIC;

CREATE TABLE dataset.table(s1 STRUCT<a INT64, b STRING>);

ALTER TABLE dataset.table ALTER COLUMN s1
SET DATA TYPE STRUCT<a NUMERIC, b STRING>;

ALTER TABLE mydataset.mytable
ALTER COLUMN mycolumn
SET DEFAULT CURRENT_TIME();


ALTER PROJECT project_id
SET OPTIONS (
  `region-us.default_time_zone` = NULL,
  `region-us.default_kms_key_name` = NULL,
  `region-us.default_query_job_timeout_ms` = NULL,
  `region-us.default_interactive_query_queue_timeout_ms` = NULL,
  `region-us.default_batch_query_queue_timeout_ms` = NULL);

ALTER BI_CAPACITY my-project.region-us
SET OPTIONS(
  size_gb = 250
)

ALTER BI_CAPACITY `my-project.region-us.default`
SET OPTIONS(
  size_gb = 250,
  preferred_tables = ["data_project1.dataset1.table1",
                      "data_project2.dataset2.table2"]
)

ALTER BI_CAPACITY `region-us.default`
SET OPTIONS(
  preferred_tables = ["dataset1.table1",
                      "data_project2.dataset2.table2"]
)

ALTER CAPACITY `admin_project.region-us.my-commitment`
SET OPTIONS (
  plan = 'THREE_YEAR');

ALTER RESERVATION admin_project.region-us.my-reservation
SET OPTIONS (
  slot_capacity = 300,
  autoscale_max_slots = 400);