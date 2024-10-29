DROP DATABASE test_db;

drop database tickit_test;

DROP DATASHARE salesshare;

DROP EXTERNAL VIEW sample_schema.glue_data_catalog_view IF EXISTS

drop function f_sqrt(int);

drop function f_sqrt(int) restrict;

drop group guests;

DROP IDENTITY PROVIDER oauth_provider;

DROP MODEL demo_ml.customer_churn;

DROP MATERIALIZED VIEW tickets_mv;

DROP PROCEDURE quarterly_revenue(volume INOUT bigint, at_price IN numeric,result OUT
 int);

DROP RLS POLICY policy_concerts;

-- DROP ROLE sample_role FORCE;

-- drop schema if exists s_sales;

-- drop schema s_spectrum drop external database restrict;

-- drop schema s_sales, s_profit, s_revenue drop external database cascade;

drop table feedback cascade;

drop table if exists feedback;

drop user dwuser;

drop view eventview;