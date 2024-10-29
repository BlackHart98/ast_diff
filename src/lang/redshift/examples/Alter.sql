alter database tickit_sandbox rename to tickit_test;

alter database tickit owner to dwuser;

ALTER DATABASE sampledb ISOLATION LEVEL SNAPSHOT;


ALTER DATASHARE salesshare ADD TABLE publicc.tickit_sales_redshift;

alter default privileges for user report_admin grant select on tables to group
 report_readers; 

 alter default privileges grant select on tables to public;

--  alter default privileges in schema sales grant insert on tables to group sales_admin;

ALTER EXTERNAL VIEW sample_schema.glue_data_catalog_view
FORCE
REMOVE DEFINITION

ALTER IDENTITY PROVIDER oauth_standard
PARAMETERS '{"issuer":"https://sts.windows.net/2sdfdsf-d475-420d-b5ac-667adad7c702/",
"client_id":"87f4aa26-78b7-410e-bf29-57b39929ef9a",
"client_secret":"BUAH~ewrqewrqwerUUY^%tHe1oNZShoiU7",
"audience":["https://analysis.windows.net/powerbi/connector/AmazonRedshift"]
}'

ALTER MATERIALIZED VIEW tickets_mv AUTO REFRESH YES

ALTER RLS POLICY policy_concerts
USING (catgroup = 'piano concerts');

ALTER ROLE sample_role1 WITH RENAME TO sample_role2;

ALTER PROCEDURE quarterly_revenue(bigint, numeric) OWNER TO etl_user

ALTER ROLE sample_role1 EXTERNALID TO "XYZ456";

ALTER PROCEDURE quarterly_revenue(bigint, numeric) OWNER TO etl_user;

alter schema us_sales
owner to dwuser;

alter schema us_sales QUOTA 300 GB;
alter schema us_sales QUOTA UNLIMITED;

ALTER SYSTEM SET metadata_security = true;

ALTER SYSTEM SET data_catalog_auto_mount = true;

alter table users
rename to users_bkup;

alter table venue
rename column venueseats to venuesize;

alter table t1 alter column c3 encode runlength;

alter user admin createdb;

alter user admin password 'adminPass9'
valid until '2017-12-31 23:59';

ALTER USER dbuser SESSION TIMEOUT 300;

ALTER USER myco_aad:bob EXTERNALID "ABC123" PASSWORD DISABLE;