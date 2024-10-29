UNLOAD (SELECT * FROM old_table) 
TO 's3://DOC-EXAMPLE-BUCKET/unload_test_1/' 
WITH (format = 'JSON');

UNLOAD (SELECT * FROM old_table) 
TO 's3://DOC-EXAMPLE-BUCKET/' 
WITH (format = 'PARQUET',compression = 'SNAPPY');

UNLOAD (SELECT name1, address1, comment1, key1 FROM table1) 
TO 's3://DOC-EXAMPLE-BUCKET/ partitioned/' 
WITH (format = 'TEXTFILE', partitioned_by = ARRAY['key1']);

UNLOAD (SELECT * FROM old_table) 
TO 's3://DOC-EXAMPLE-BUCKET/' 
WITH (format = 'PARQUET', compression = 'ZSTD', compression_level = 4);