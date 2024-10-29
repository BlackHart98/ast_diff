insert into category_stage
(select * from category);

insert into category_stage values
(12, 'Concerts', 'Comedy', 'All stand-up comedy performances');

insert into category_stage values
(14, default, default, default),
(15, default, default, default);

-- SELECT * FROM #venuetemp ORDER BY venueid;

INSERT INTO spectrum.lineitem
SELECT * FROM local_lineitem;


MERGE INTO targets USING source ON target.id = source.id
WHEN MATCHED THEN UPDATE SET id = source.id, name = source.name
WHEN NOT MATCHED THEN INSERT VALUES (source.id, source.name);

MERGE INTO target USING source ON target.id = source.id
WHEN MATCHED THEN DELETE
WHEN NOT MATCHED THEN INSERT VALUES (source.id, source.name);

MERGE INTO target USING source ON target.id = source.id
WHEN MATCHED THEN UPDATE SET id = source.id, name = source.name
WHEN NOT MATCHED THEN INSERT VALUES (source.id, source.name);

MERGE INTO target USING source ON target.id = source.id
WHEN MATCHED THEN DELETE
WHEN NOT MATCHED THEN INSERT VALUES (source.id, source.name);


-- PREPARE prep_select_plan (int)
-- AS (select * from prep1 where c1 = $1);

REFRESH MATERIALIZED VIEW tickets_mv;

reset query_group;

rollback;

set datestyle to 'SQL,DMY';
set query_group to 'priority';
select tbl, count(*)from stv_blocklist;


SET LOCAL SESSION AUTHORIZATION 'dwuser';

set seed to .25;


show query_group;

SHOW COLUMNS FROM TABLE dev.publictb;

SHOW EXTERNAL TABLE my_schema.alldatatypes_parquet_test_partitioned;

SHOW EXTERNAL TABLE my_schema.alldatatypes_parquet_test_partitioned PARTITION;

SHOW DATABASES FROM DATA CATALOG ACCOUNT '123456789012';

SHOW MODEL ALL;

SHOW MODEL customer_churn; 

-- SHOW DATASHARES;
-- SHOW DATASHARES LIKE 'sales%';

-- show procedure test_sp2(int, varchar); 

SHOW SCHEMAS FROM DATABASE dev;

SHOW SCHEMAS FROM DATABASE awsdatacatalog LIMIT 5;

show table sales;