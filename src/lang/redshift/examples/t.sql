DROP DATABASE  test_db      ;
DROP DATABASE  tickit_test      ;
DROP DATASHARE  salesshare      ;
DROP EXTERNAL VIEW  sample_schema.glue_data_catalog_view   IF EXISTS   
DROP FUNCTION  f_sqrt  (int  )    ;
DROP FUNCTION  f_sqrt  (int  )  RESTRICT  ;
DROP GROUP  guests      ;
DROP IDENTITY PROVIDER  oauth_provider      ;
DROP MODEL  demo_ml.customer_churn      ;
DROP MATERIALIZED VIEW  tickets_mv      ;
DROP PROCEDURE  quarterly_revenue  (volume INOUT BIGINT, at_price IN NUMERIC, result OUT INT)    ;
DROP RLS POLICY  policy_concerts      ;
DROP ROLE  sample_role    FORCE  ;
DROP TABLE  feedback    CASCADE  ;
DROP TABLE IF EXISTS feedback      ;
DROP USER  dwuser      ;
DROP VIEW  eventview      ;