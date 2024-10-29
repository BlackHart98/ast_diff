create account a1 admin_name = adm admin_password = 'd' email = 'd' edition = standard;
create api integration i1 api_provider = p1 api_aws_role_arn = 'a' API_ALLOWED_PREFIXES = ('') enabled = true;
create database d1 clone d2;
create connection c1;
create database d1;
create external function e() returns int api_integration = i1 as 'dsd';
create external table e1 (c int as 1) location = @stg/ file_format = ( type = json );
create failover group g1 object_types = databases allowed_accounts = o.a;
create file format ff type = json ;
create function f1() returns int as '1';
create managed account ma admin_name = ma, admin_password = 'p', type = reader;
create masking policy mp as (c int) returns int -> 1;
create materialized view mv as select 1 as c;
create network policy np allowed_ip_list = ();
create notification integration ni enabled = true type = queue notification_provider = gcp_pubsub gcp_pubsub_subscription_name = 's';
create pipe p1 as copy into t from @stg/;
create replication group rg object_types = databases allowed_accounts = o.a;
create resource monitor rm  with  credit_quota = 1;
create role r;
create row access policy rap as (i int) returns boolean -> true;
create schema s;
create sequence s1;
create session policy sp comment = '';
create share s1;
create table t(i int);
create table t(i int, constraint c unique (i));
create user u;
create database public;
create sequence s1 NOORDER;
CREATE STAGE my_ext_stage2
  URL='s3://load/encrypted_files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  ENCRYPTION=(MASTER_KEY = 'eSx...');
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://mybucket1/path1/', 's3://mybucket2/path2/');

CREATE OR REPLACE STREAM mystream ON TABLE mytable AT(STREAM => 'mystream');
CREATE TAG cost_center COMMENT = 'cost_center tag';
CREATE OR REPLACE WAREHOUSE my_wh WAREHOUSE_SIZE = LARGE INITIALLY_SUSPENDED=TRUE;
create schema raw;