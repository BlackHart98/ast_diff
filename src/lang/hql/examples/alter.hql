SELECT 
  a.b, 
  a, 
  1 + 1 AS d, 
  (CASE WHEN ((proc.income_v  IN (5,19)) OR (((proc.income_v = 7) AND (e.verify_status  IN (2,13,26,27))) AND (srn.sr_id IS NOT NULL))) THEN 1
  WHEN a.b THEN 2 
   
  END), 
  COALESCE(lpad(CAST ( CAST ( gg_rsn AS BIGINT ) AS VARCHAR(100) ), 50, '0'), 'x') AS y
FROM a.table 
WHERE (a.b = 2)
GROUP BY c
HAVING (a.b = 7.0)
ORDER BY a
LIMIT 10;

SELECT 
  c, 
  (SELECT 
    id
  FROM tab) a
FROM b;

SELECT 
  c, 
  (SELECT 
    id
  FROM tab) a
FROM b 
WHERE EXISTS (SELECT 
  id
FROM tab);

SELECT 
  c, 
  (SELECT 
    id
  FROM tab) a
FROM b 
WHERE w NOT IN (SELECT 
  id
FROM tab);

USE db;

SELECT 
  a.b
FROM (SELECT 
  a.b
FROM b.table) x UNION ALL SELECT 
  a.b
FROM b.table INTERSECT SELECT 
  a.b
FROM b.table;

SELECT 
  COUNT(*), 
  a.b, 
  a AS b, 
  COUNT(a.b)
FROM b a, a.c n, a d, (SELECT 
  a.b
FROM b.table) x, (SELECT 
  a.b
FROM b.table) s
LEFT SEMI JOIN a  ON a.b 
LEFT OUTER JOIN a  ON a.b 
CROSS JOIN a   
LEFT OUTER JOIN b  ON a.b 
JOIN b  ON (a = b) 
JOIN a  ON (a = b) 
LEFT OUTER JOIN b  ON a.b 
CROSS JOIN a   
LEFT SEMI JOIN a  ON a.b;

SELECT 
  COUNT(*), 
  a.b, 
  a AS b, 
  COUNT(a.b)
FROM a 
JOIN b   
JOIN c  ON (a.a = a.b);

SELECT 
  a, 
  b
FROM c 
CLUSTER BY a;

SELECT TRANSFORM(jresp)  
USING 'python ParseJson.py' AS (program_id , servicer )  
FROM a;

SELECT TRANSFORM(cr_accnt.loan_ext_id, '${env}')  
USING 'python calculateDmvFees.py' AS (ext_ref_id STRING, dmv_fees_val STRING)  
FROM credit_acct cr_accnt
WHERE (cr_accnt.cr_acct_prod_name = 'AUTO_REFI');

SELECT 
  a
FROM b 
WHERE ((loan_base.loan_issued_dt IS NOT NULL) AND (('${spectrumProdFlg}' = 'N') OR (NOT (('${spectrumProdFlg}' = 'Y') AND ((COALESCE(ll.current_src_id, 0) <=> ${current_loan_servicing_id}) OR (slms.loan_id IS NOT NULL))))));

SELECT 
  NAMED_STRUCT('fraud_status', '','fraud_dt', CAST ( null AS DATE ),'pri_cust_fraud_ind', '','sec_cust_fraud_ind', '')  fraud_info, 
  MAP( 'fraud_status', '','fraud_dt', CAST ( null AS DATE ),'pri_cust_fraud_ind', '','sec_cust_fraud_ind', '' ) fraud_info
FROM a;

