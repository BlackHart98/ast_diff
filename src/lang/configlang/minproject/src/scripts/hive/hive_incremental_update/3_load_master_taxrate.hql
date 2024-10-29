INSERT INTO master.taxrate
SELECT
  *
FROM staging.taxrate;