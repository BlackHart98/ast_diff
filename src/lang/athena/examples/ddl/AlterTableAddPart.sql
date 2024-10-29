ALTER TABLE orders ADD
  PARTITION (dt = '2016-05-14', country = 'IN');


ALTER TABLE orders ADD
  PARTITION (dt = '2016-05-31', country = 'IN')
  PARTITION (dt = '2016-06-01', country = 'IN');

ALTER TABLE orders ADD
   PARTITION (dt = '2016-05-31', country = 'IN') LOCATION 's3://mystorage/path/to/INDIA_31_May_2016/'
   PARTITION (dt = '2016-06-01', country = 'IN') LOCATION 's3://mystorage/path/to/INDIA_01_June_2016/';

 ALTER TABLE orders ADD IF NOT EXISTS
   PARTITION (dt = '2016-05-14', country = 'IN');
