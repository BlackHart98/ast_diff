INSERT OVERWRITE LOCAL DIRECTORY '/tmp/destination'
     STORED AS orc
     SELECT * FROM test_table;

INSERT OVERWRITE LOCAL DIRECTORY '/tmp/destination'
     ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
     SELECT * FROM test_table;
     

INSERT OVERWRITE DIRECTORY '${outputFileName}'
select distinct loan_id, curr_borr_timezone,is_joint_loan
from  ${workingDB}.coll_manualdialer_list_stage
where listtype = 'PS'; 

INSERT OVERWRITE DIRECTORY '${autoalertfifsmissingloans_ael}'
SELECT DISTINCT loanid FROM ${auto}.fifs_ael_loan_onboarding lb
LEFT JOIN ${auto}.fifs_ls_loan_snapshot_lcnp_ael 
ON  loanid  = uf_alpha10_1
WHERE  lb.period != current_date AND uf_alpha10_1 IS NULL;

insert overwrite directory '${dailyInvestmentAssetDetailValPath}/iad_duplicates'
select * from ${interimDB}.iad_dup_check;

insert overwrite directory '/tmp/destination/iad_duplicates'
select * from ${interimDB}.iad_dup_check;

insert into table ${db_name}.actor_ext_scd partition(currentflg)
select *;

INSERT INTO TABLE ${auto}.prog_servicer_map
SELECT program_id,t1.servicer 
FROM 
(
SELECT TRANSFORM(jresp) USING 'python ParseJson.py' AS (program_id,servicer)
FROM (SELECT TRANSFORM(${Prgurl}) USING 'CallUrl.sh' AS (jresp )) jsrc 
) t1
LEFT JOIN ${auto}.prog_servicer_map mp
ON ( mp.prog_id = program_id) 
WHERE mp.prog_id is NULL;

