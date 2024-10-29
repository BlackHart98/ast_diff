ALTER TABLE orders 
SET TBLPROPERTIES ('notes'="Please don't drop this table.");

ALTER TABLE existing_table 
SET TBLPROPERTIES ('parquet.compression' = 'ZSTD', 'compression_level' = 4)