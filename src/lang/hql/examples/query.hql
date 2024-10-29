select a.b, a, 1 + 1 as d, 
 case  when proc.income_v in (5,19) or (proc.income_v = 7 and e.verify_status in (2,13,26,27) and srn.sr_id is not null) then 1
      when a.b then 2
      end, 
        coalesce(lpad(cast(cast(gg_rsn as bigint) as varchar(100)),50,'0'),'x') as y 
 from a.table
 where a.b = 2 
 group by c
 having a.b = 7.0 
 order by a
 limit 10; 
 
 select c, (select id from tab)a
 from b; 
 --GROUP BY E30.account_number
 
 select c, (select id from tab) a
 from b
 where  EXISTS (select id from tab); 
 
 select c, (select id from tab) a
 from b
 where w not in (select id from tab); 
 
use db;
select a.b
from (select a.b
	 from b.table
	 ) x
union all
select a.b 
from b.table
intersect
select a.b 
from b.table;

select count(*), a.b, a as b, count(a.b) 
from b a, a.c n, a d,
(select a.b
	 from b.table
	 ) x,
	 
	 (select a.b
	 from b.table
	 ) s
left semi join a on a.b 
left outer join a on a.b
cross join a
left outer join b on a.b 
join b on a = b
join a on a = b
left outer join b on a.b 
cross join a
left semi join a on a.b;

select count(*), a.b, a as b, count(a.b) 
from a
join b
join c on a.a = a.b;

select a, b
from c
cluster by a;


SELECT TRANSFORM(jresp) USING 'python ParseJson.py' AS (program_id,servicer)
FROM a; 

SELECT TRANSFORM (cr_accnt.loan_ext_id,'${env}') USING 'python calculateDmvFees.py'
AS (ext_ref_id string,dmv_fees_val string) FROM credit_acct cr_accnt where cr_accnt.cr_acct_prod_name='AUTO_REFI';


select a 
from b
where loan_base.loan_issued_dt is not null
AND ('${spectrumProdFlg}' = 'N' OR not ('${spectrumProdFlg}' = 'Y' AND (coalesce(ll.current_src_id, 0) <=> ${current_loan_servicing_id} OR slms.loan_id is not null)));


select
named_struct('fraud_status',  '',
             'fraud_dt',            cast(null as date),
             'pri_cust_fraud_ind',  '',
             'sec_cust_fraud_ind',  ''
      )  fraud_info,
Map('fraud_status',  '',
             'fraud_dt',            cast(null as date),
             'pri_cust_fraud_ind',  '',
             'sec_cust_fraud_ind',  ''
      )  fraud_info
from a;


SELECT * FROM persons;