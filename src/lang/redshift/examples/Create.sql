create database tickit
with owner dwuser;

CREATE DATABASE sales_db FROM DATASHARE salesshare OF NAMESPACE
 '13b8833d-17c6-4f16-8fe4-1a018f5ed00d';

CREATE DATABASE sampledb ISOLATION LEVEL SNAPSHOT;

create database sampledb collate case_insensitive;


CREATE DATASHARE salesshare;

CREATE DATASHARE demoshare SET PUBLICACCESSIBLE TRUE;

-- CREATE DATASHARE demoshare SET PUBLICACCESSIBLE TRUE, MANAGEDBY ADX;

CREATE EXTERNAL FUNCTION exfunc_sum(INT,INT)
RETURNS INT
VOLATILE
LAMBDA 'lambda_sum'
IAM_ROLE 'arn:aws:iam::123456789012:role/Redshift-Exfunc-Test';

CREATE OR REPLACE EXTERNAL FUNCTION exfunc_upper(varchar)
RETURNS varchar
VOLATILE
LAMBDA 'exfunc_sleep_3'
IAM_ROLE 'arn:aws:iam::123456789012:role/Redshift-Exfunc-Test'
RETRY_TIMEOUT 0;

CREATE OR REPLACE EXTERNAL FUNCTION exfunc_upper(varchar)
RETURNS varchar
VOLATILE
LAMBDA 'exfunc_sleep_3'
IAM_ROLE 'arn:aws:iam::123456789012:role/Redshift-Exfunc-Test'
RETRY_TIMEOUT 3000;

create external schema spectrum_schema
from data catalog
database 'sampledb'
region 'us-west-2'
iam_role 'arn:aws:iam::123456789012:role/MySpectrumRole';

create external schema spectrum_schema
from data catalog
database 'spectrum_db'
iam_role 'arn:aws:iam::123456789012:role/MySpectrumRole'
create external database if not exists;

create external schema hive_schema
from hive metastore
database 'hive_db'
uri '172.10.10.10' port 99
iam_role 'arn:aws:iam::123456789012:role/MySpectrumRole';

create external schema hive_schema
from hive metastore
database 'hive_db'
uri '172.10.10.10' port 99
iam_role 'arn:aws:iam::123456789012:role/MySpectrumRole';

create external schema spectrum_schema
from data catalog
database 'spectrum_db'
iam_role 'arn:aws:iam::123456789012:role/myRedshiftRole,arn:aws:iam::123456789012:role/
myS3Role'
catalog_role 'arn:aws:iam::123456789012:role/myAthenaRole'
create external database if not exists;

create external schema spectrum_schema
from data catalog
database 'spectrum_db'
iam_role 'arn:aws:iam::123456789012:role/myRedshiftRole,arn:aws:iam::123456789012:role/
myS3Role'
catalog_role 'arn:aws:iam::123456789012:role/myAthenaRole'
create external database if not exists;

CREATE EXTERNAL SCHEMA sales_schema FROM REDSHIFT DATABASE 'sales_db' SCHEMA 'public';

CREATE EXTERNAL SCHEMA IF NOT EXISTS myRedshiftSchema
FROM POSTGRES
DATABASE 'my_aurora_db' SCHEMA 'my_aurora_schema'
URI 'endpoint to aurora hostname' PORT 5432
IAM_ROLE 'arn:aws:iam::123456789012:role/MyAuroraRole'
SECRET_ARN 'arn:aws:secretsmanager:us-east-2:123456789012:secret:development/
MyTestDatabase-AbCdEf'


create external table spectrum.sales(
salesid integer,
listid integer,
sellerid integer,
buyerid integer,
eventid integer,
saledate date,
qtysold smallint,
pricepaid decimal(8,2),
commission decimal(8,2),
saletime timestamp)
row format delimited
fields terminated by '\t'
stored as textfile
location 's3://awssampledbuswest2/tickit/spectrum/sales/'
table properties ('numRows'='170000');

create external table spectrum.cloudtrail_json (
event_version int,
event_id bigint,
event_time timestamp,
event_type varchar(10),
awsregion varchar(20),
event_name varchar(max),
event_source varchar(max),
requesttime timestamp,
useragent varchar(max),
recipientaccountid bigint)
row format serde 'org.openx.data.jsonserde.JsonSerDe'
with serdeproperties (
'dots.in.keys' = 'true',
'mapping.requesttime' = 'requesttimestamp'
) location 's3://mybucket/json/cloudtrail';

CREATE EXTERNAL TABLE spectrum.lineitem
STORED AS parquet
LOCATION 'S3://mybucket/cetas/lineitem/'
AS SELECT * FROM local_lineitem;

CREATE EXTERNAL TABLE spectrum.partitioned_lineitem
PARTITIONED BY (l_shipdate, l_shipmode)
STORED AS parquet
LOCATION 'S3://mybucket/cetas/partitioned_lineitem/'
AS SELECT l_orderkey, l_shipmode, l_shipdate, l_partkey FROM local_table;


-- fix for regex
create external table spectrum.types(
cbigint bigint,
cbigint_null bigint,
cint int,
cint_null int)
row format serde 'org.apache.hadoop.hive.serde2.RegexSerDe'
with serdeproperties ('input.regex'='')
stored as textfile
location 's3://mybucket/regex/types';

CREATE EXTERNAL PROTECTED VIEW sample_schema.glue_data_catalog_view IF NOT EXISTS
AS SELECT * FROM sample_database.remote_table "remote-table-name";

create function f_py_greater (a int, b int)
 returns int
stable
as $$
 'if a > b:
 return a
 return b'
 $$ language plpythonu;

create function f_sql_greater (float, float)
 returns float
stable
as $$
 'select case when $1 > $2 then $1
 else $2
 end'
$$ language sql;

create group admin_group with user admin1, admin2;

CREATE IDENTITY PROVIDER oauth_standard TYPE azure
NAMESPACE 'aad'
PARAMETERS '{"issuer":"https://sts.windows.net/2sdfdsf-d475-420d-b5ac-667adad7c702/",
"client_id":"87f4aa26-78b7-410e-bf29-57b39929ef9a",
"client_secret":"BUAH~ewrqewrqwerUUY^%tHe1oNZShoiU7",
"audience":["https://analysis.windows.net/powerbi/connector/AmazonRedshift"]
}'

create library f_urlparse
language plpythonu
from 's3://mybucket/urlparse3-1.0.3.zip'
credentialss 'aws_iam_role=arn:aws:iam::<aws-account-id>:role/<role-name>'
region as 'us-east-1'; 

create library f_urlparse
language plpythonu
from 'https://example.com/packages/urlparse3-1.0.3.zip';

CREATE MATERIALIZED VIEW tickets_mv AS 
select catgroup,
sum(qtysold) as sold
from category c, event e, sales s
where c.catid = e.catid
and e.eventid = s.eventid
group by catgroup;

CREATE MATERIALIZED VIEW tickets_mv_max AS
 select catgroup,
 max(qtysold) as sold
 from category c, event e, sales s
 where c.catid = e.catid
 and e.eventid = s.eventid
 group by catgroup;

 CREATE MATERIALIZED VIEW mv_sales_vw as
select salesid, qtysold, pricepaid, commission, saletime from publwic.sales
union all
select salesid, qtysold, pricepaid, commission, saletime from spectrum.sales

CREATE MATERIALIZED VIEW mv_fq as select firstname, lastname from apg.mv_fq_example;

CREATE MATERIALIZED VIEW mv_baseball AUTO REFRESH NO AS SELECT ball AS
 baseball FROM baseball_table;

CREATE MODEL customer_churn
FROM customer_data
TARGET 'Churn'
FUNCTION predict_churn
IAM_ROLE 'arn:aws:iam::<account-id>:role/<role-name>'
PROBLEM_TYPE BINARY_CLASSIFICATION
OBJECTIVE 'F1'
PREPROCESSORS '[
...
 {"ColumnSet": [
 "t1",
 "t2"
 ],
 "Transformers": [
 "OneHotEncoder",
 "Imputer"
 ]
 },
 {"ColumnSet": [
 "t3"
 ],
 "Transformers": [
 "OneHotEncoder"
 ]
 },
 {"ColumnSet": [
 "temp"
 ],
 "Transformers": [
 "Imputer",
 "NumericPassthrough"
 ]
 }
]'
SETTINGS ( 
    S3_BUCKET 'bucket'
)

CREATE OR REPLACE PROCEDURE test_sp1(f1 int, f2 varchar(20))
AS $$
'DECLARE
 min_val int;
BEGIN
 DROP TABLE IF EXISTS tmp_tbl;
 CREATE TEMP TABLE tmp_tbl(id int);
 INSERT INTO tmp_tbl values (f1),(10001),(10002);
 SELECT INTO min_val MIN(id) FROM tmp_tbl;
 RAISE INFO, min_val, f2;
END;'
$$ LANGUAGE plpgsql;

CREATE RLS POLICY policy_concerts
WITH (catgroup VARCHAR(10))
USING (catgroup = 'Concerts');

CREATE RLS POLICY policy_concerts
WITH (catgroup VARCHAR(10))
USING (catgroup = 'Concerts');

CREATE ROLE sample_role1 EXTERNALID "ABC123";

CREATE ROLE sample_role1;

create schema us_sales authorization dwuser;

create schema us_sales authorization dwuser QUOTA 50 GB;

create table sales(
salesid integer not null,
listid integer not null,
sellerid integer not null,
buyerid integer not null,
eventid integer not null encode ssww,
dateid smallint not null,
qtysold smallint not null encode mostly,
pricepaid decimal(8,2) encode mostly,
commission decimal(8,2) encode mostly,
saletime timestamp,
primary key(salesid),
foreign key(listid) references listing(listid),
foreign key(sellerid) references users(userid),
foreign key(buyerid) references users(userid),
foreign key(dateid) references date(dateid))
distkey(listid);

create table venue(
venueid smallint not null,
venuename varchar(100),
venuecity varchar(30),
venuestate char(2),
venueseats integer,
primary key(venueid))
diststyle all;

create table myevent(
eventid int,
eventname varchar(200),
eventcity varchar(30))
diststyle even;

CREATE TABLE t1(
 hist_id BIGINT IDENTITY NOT NULL, 
 base_id BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
 business_key varchar(10) ,
 some_field varchar(10)
);

create table categorydef(
catid smallint not null default 0,
catgroup varchar(10) default 'Special',
catname varchar(10) default 'Other',
catdesc varchar(50) default 'Special events',
primary key(catid)); 

create table t3(col1 int, col2 int sortkey) diststyle all;


create table eventdistsort
distkey (1)
sortkey (1,3)
as
select eventid, venueid, dateid, eventname
from event;

create table eventdistsort1
distkey (eventid)
sortkey (eventid, dateid)
as
select eventid, venueid, dateid, eventname
from event;

create table eventdisteven
diststyle even
as
select eventid, venueid, dateid, eventname
from event;


create table eventdistevensort diststyle even sortkey (venueid)
as select eventid, venueid, dateid, eventname from event;

create table venuedistevent distkey(venueid)
as select * from event;

create user dbuser with password 'abcD1234' createdb connection limit 30;

create user dbuser with password 'abcD1234' valid until '2017-06-10';

create user newman with password '@AbC4321!';

create user slashpass password 'md50c983d1a624280812631c5389e60d48c';

CREATE USER dbuser password 'abcD1234' SESSION TIMEOUT 120;

CREATE USER myco_aad:bob EXTERNALID "ABC123" PASSWORD DISABLE;

create view myevent as select eventname from event
where eventname = 'LeAnn Rimes';

create view myuser as select lastname from users;

create or replace view myuser as select lastname from users;

create view myevent as select eventname from publicc.event
with no schema binding;