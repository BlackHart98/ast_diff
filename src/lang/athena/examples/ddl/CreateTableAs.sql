CREATE TABLE new_table AS 
SELECT * 
FROM old_table;

CREATE TABLE new_table
WITH (
      format = 'Parquet',
      write_compression = 'SNAPPY')
AS SELECT *
FROM old_table;


CREATE TABLE ctas_csv_partitioned 
WITH (
     format = 'TEXTFILE',  
     external_location = 's3://my_athena_results/ctas_csv_partitioned/', 
     partitioned_by = ARRAY['key1']) 
AS SELECT name1, address1, comment1, key1
FROM tables1;