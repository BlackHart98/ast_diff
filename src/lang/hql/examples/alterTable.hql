TRUNCATE table table1 PARTITION(currentflag=1) ; 

TRUNCATE  table1 PARTITION(currentflag=1) ; 

TRUNCATE  table table1 ; 

ANALYZE TABLE a PARTITION(currentflag=1, part2=a)  COMPUTE STATISTICS;

alter table table1 rename to db.table2;


alter table table1 add if not exists partition(currentflag=1, part2=a) location 'a/b', partition(currentflag=1, part2=a) location 'a/b'; 

ALTER TABLE table_name PARTITION (currentflag=1, part2=a) RENAME TO PARTITION (currentflag=1, part2=b);

ALTER TABLE table_name DROP IF EXISTS PARTITION(currentflag=1, part2=a)
  IGNORE PROTECTION PURGE;
  
ALTER TABLE table_name DROP IF EXISTS PARTITION(currentflag=1, part2=a), PARTITION(currentflag=1, part2=a);

MSCK REPAIR  table_name ADD PARTITIONS;

MSCK table_name ADD PARTITIONS;

MSCK REPAIR table_name;

MSCK table_name;

