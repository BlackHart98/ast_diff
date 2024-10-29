EXPLAIN 
SELECT 
   request_timestamp, 
   elb_name, 
   request_ip 
FROM sampledb.elb_logs;

EXPLAIN 
SELECT 
   o_orderkey, 
   o_custkey, 
   o_orderdate 
FROM tpch100.orders_partitioned
WHERE o_orderdate = '1995';

EXPLAIN ANALYZE SELECT FROM cloudfront_logs LIMIT 10;

EXPLAIN (TYPE DISTRIBUTED)
   SELECT 
      c.c_custkey, 
      o.o_orderkey,
      o.o_orderstatus
   FROM tpch100.customer c 
   JOIN tpch100.orders o 
       ON c.c_custkey = o.o_custkey 
   WHERE c.c_custkey = 123;

EXPLAIN ANALYZE SELECT clerk FROM orders
WHERE orderdate > date '1995-01-01' GROUP BY clerk;

EXPLAIN ANALYZE (FORMAT JSON) SELECT * FROM cloudfront_logs LIMIT 10;