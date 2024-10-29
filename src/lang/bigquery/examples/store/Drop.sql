DROP TABLE mydataset.mytable

DROP TABLE IF EXISTS mydataset.mytable

DROP SNAPSHOT TABLE mydataset.mytablesnapshot

DROP SNAPSHOT TABLE IF EXISTS mydataset.mytablesnapshot

DROP EXTERNAL TABLE IF EXISTS mydataset.external_table

DROP VIEW mydataset.myview

DROP VIEW IF EXISTS mydataset.myview

DROP MATERIALIZED VIEW IF EXISTS mydataset.my_mv

DROP FUNCTION `other_project`.sample_dataset.parseJsonAsStruct;

DROP TABLE FUNCTION mydataset.my_table_function;

DROP ROW ACCESS POLICY my_row_filter ON project.dataset.my_table;

DROP SEARCH INDEX my_index ON dataset.my_table;