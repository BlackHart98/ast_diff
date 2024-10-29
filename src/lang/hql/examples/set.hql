-- Value of set must allow the entire syntax 
set hivevar:select_sql=aid,ph1_id,ph2_id,fax,addr_id,emp_id,charity_id,landing_page_id,campaign_id,flags,no_cr_push_until_d,intended_load,name_in_review,funnel,ext_ref_id,marital_status,honourific,ext_id,cr_score_notice_id,net_worth,email_optout,fraud_v,fraud_v_d,fraud_type,fee,waive_srvc_fee_until_d,last_mod_aid,prime_enroll_d,ssn_try_count,inv_lead_score,self_rpt_mkt_attribution_cd,dob_enc,modified_d,gg_flag,gg_scn,gg_seqno,gg_rba,gg_username,gg_rsn,gg_rsnts,gg_tknid;


set hivevar:a = "b";
set hivevar:db_tlc=${tlcencDB};
set tez.grouping.min-size=67108864;
set tez.grouping.max-size=67108864;
set hive.compute.query.using.stats = a;
use db;
