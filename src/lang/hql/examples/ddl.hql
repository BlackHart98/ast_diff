create table amort_schedule_incr10 as
select TRANSFORM(`id`, aid,START_D, amount, `interval`, apr, int_rate, RPA ) USING 'python amort_schedule.py' AS 
(LOAN_ID String,CREDIT_ACCT_UID smallint,CREDIT_FAC_UID,BORROWER_UID,SCHEDULED_START_DT,CREDIT_FAC_AMT,TERM_PERIOD,TERM,TERM_SEQ,APR,INT_RATE,SCHEDULED_PAYMENT_AMT,ESTIMATED_PRINCIPAL,ESTIMATED_INTEREST,beg_bal,ESTIMATED_REMAINING_PRINCIPAL)
from ${tlcencDB}.lc_loan
where to_date(start_d) = '${period}';



create table interim.amort_schedule_hist_10 as
select TRANSFORM(`id`, aid,START_D, amount, `interval`, apr, int_rate, RPA ) USING 'python amort_schedule.py' AS 
(LOAN_ID,CREDIT_ACCT_UID,CREDIT_FAC_UID,BORROWER_UID,SCHEDULED_START_DT,CREDIT_FAC_AMT,TERM_PERIOD,TERM,TERM_SEQ,APR,INT_RATE,SCHEDULED_PAYMENT_AMT,ESTIMATED_PRINCIPAL,ESTIMATED_INTEREST,beg_bal,ESTIMATED_REMAINING_PRINCIPAL)
from tlc_enc.lc_loan
where start_d is not null;

drop table if exists ${workingDB}.zendesk_content2;
create table if not exists ${workingDB}.zendesk_content2 as
select TRANSFORM(id, assignee_id, assignee_name, assignee_email, created_at, json) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
USING 'python zendesk_resp.py'
AS
( assignee_name string,
  assignee_username string,
  ticket_id bigint, 
  requester_external_id bigint,  
  requester_email string, 
  requester_name string, 
  group_id bigint, 
  tags string,
  subject string,
  status string,
  customer_satisfaction_rating string,
  created_at timestamp, 
  ticket_via string,
  reopens int, 
  replies int, 
  solved_at timestamp, 
  lc_error boolean, 
  complaint_description string, 
  ls_borrower_status string,
  regulatory_case_number string,
  loan_id bigint,
  ls_borrower_was_in_front_of_computer string,
  call_language string,
  ls_outcome_of_call_abp string,
  payment_solution_type string,
  ls_what_is_lending_club string,
  time_spent_last_update int,
  ls_what_loan_amount_can_should_i_request string,
  complaint_analysis string,
  document_type string,
  ls_outcome_of_call string,
  case_origin string,
  ls_objection string,
  compliance_condition_code string,
  ls_what_income_should_i_provide string,
  case_incident_type string,
  case_subtype string,
  borrower_contact_management string,
  is_ota string,
  admin_account_status string,
  complaint_root_cause_code string,
  ls_was_there_an_objection_on_this_call string,
  complaint_elevator string,
  total_time_spent string,
  ls_is_there_a_pre_payment_penalty string,
  contact_purpose string,
  borrower_state_of_residence string,
  what_could_be_improved string,
  complaint_resolution string,
  actor_id bigint,
  ls_reason_for_call string,
  ls_how_long_does_this_process_take string,
  ls_how_will_i_get_the_funds string,
  i_could_meet_the_borrowers_needs string,
  ls_how_does_payment_work string,
  ls_how_does_the_process_work string,
  ls_will_you_close_my_payoff_close_my_credit_card string,
  first_reply_time_in_minutes string,
  first_resolution_time_in_minutes int,
  full_resolution_time_in_minutes int,
  agent_wait_time_in_minutes int,
  requester_wait_time_in_minutes int,
  deleted boolean,
  credit_dispute_type string,
  credit_dispute_resolution string,
  credit_dispute_subtype string,
  has_attachements string,
  resolution_time int
);

drop view if exists isns_mig_table; 
 
create view isns_mig_table as
select imm.actor_id,NVL(imm.servicing_source,'1100') servicing_source, 'lc10' as src
from ${tlcencDB}.investor_mig_mapping imm where env_cd='PROD';

CREATE TABLE new_key_value_store
   ROW FORMAT SERDE "org.apache.hadoop.hive.serde2.columnar.ColumnarSerDe"
   STORED AS RCFILE
   AS
SELECT (key % 1024) new_key, concat(key, value) key_value_pair
FROM key_value_store;

CREATE TABLE new_key_value_store
	ROW FORMAT SERDE "org.apache.hadoop.hive.serde2.RegexSerDe"
	WITH SERDEPROPERTIES 
	(
	"input.regex" = "<regex>"
	)
	STORED AS TEXTFILE;
	
	
CREATE TABLE apachelog (
  host STRING,
  identity STRING,
  user STRING,
  time STRING,
  request STRING,
  status STRING,
  size STRING,
  referer STRING,
  agent STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  "input.regex" = "([^]*) ([^]*) ([^]*) (-|\\[^\\]*\\]) ([^ \"]*|\"[^\"]*\") (-|[0-9]*) (-|[0-9]*)(?: ([^ \"]*|\".*\") ([^ \"]*|\".*\"))?"
)
STORED AS TEXTFILE;

CREATE TABLE my_table(a string, b bigint)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE;

CREATE TABLE my_table(a string, b bigint) STORED AS JSONFILE;

CREATE TABLE my_table(a string, b string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = "\t",
   "quoteChar"     = "'",
   "escapeChar"    = "\\"
)  
STORED AS TEXTFILE;

CREATE TABLE page_view(viewTime INT, userid BIGINT,
     page_url STRING, referrer_url STRING,
     ip STRING COMMENT 'IP Address of the User')
 COMMENT 'This is the page view table'
 PARTITIONED BY (dt STRING, country STRING)
 STORED AS SEQUENCEFILE;
 
 
CREATE EXTERNAL TABLE page_view(viewTime INT, userid BIGINT,
     page_url STRING, referrer_url STRING,
     ip STRING COMMENT 'IP Address of the User',
     country STRING COMMENT 'country of origination')
 COMMENT 'This is the staging page view table'
 ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
 STORED AS TEXTFILE
 LOCATION '<hdfs_location>';
 
CREATE TABLE empty_key_value_store LIKE key_value_store TBLPROPERTIES ("property_name"="property_value");

CREATE TABLE page_view(viewTime INT, userid BIGINT,
     page_url STRING, referrer_url STRING,
     ip STRING COMMENT 'IP Address of the User')
 COMMENT 'This is the page view table'
 PARTITIONED BY(dt STRING, country STRING)
 CLUSTERED BY(userid) SORTED BY(viewTime) INTO 32 BUCKETS
 ROW FORMAT DELIMITED
   FIELDS TERMINATED BY '\001'
   COLLECTION ITEMS TERMINATED BY '\002'
   MAP KEYS TERMINATED BY '\003'
 STORED AS SEQUENCEFILE;

-- ctas example
CREATE TABLE s2 as
with q1 as ( select key from src where key = '4')
select * from q1; 

