-- CREATE TEMP TABLE IF NOT EXISTS mydataset.newtable (x INT64, b BOOL)

-- -- ALTER TABLE zen
-- -- RENAME TO xen;

-- DROP TABLE IF EXISTS  mydataset.newtable
-- CREATE SCHEMA mydataset
-- OPTIONS(
--   location="us",
--   default_table_expiration_days=3.75
--   )
-- CREATE SNAPSHOT TABLE `myproject.mydataset.mytablesnapshot`
-- CLONE `myproject.mydataset.mytable`
-- OPTIONS(
--   expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR),
--   friendly_name="my_table_snapshot",
--   description="A table snapshot that expires in 2 days",
--   labels=[("org_unit", "development")]
-- )
-- DROP TABLE IF EXISTS tableproject;
-- CREATE VIEW mydataset.age AS SELECT * FROM (SELECT apple AS fruit, carrot AS vegetable);
CREATE TABLE mydataset.top_words
OPTIONS(
  description="Top ten words per Shakespeare corpus"
) AS
SELECT
  corpus
FROM bigquerypublicdata.samples.shakespeare
GROUP BY corpus;