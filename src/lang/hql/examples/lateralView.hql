use ${interimDB};
SELECT * 
FROM exampleTable
LATERAL VIEW  explode(col1) myTable1 AS myCol1, myCol2
LATERAL VIEW explode(myCol1) myTable2 AS myCol2;
 
create table ${interimDB}.${ck_refid_lookup_tbl} as
 select ref_exp.ref_id_splitted as ref_id,
   partner,
   product
from marketing.partner_report_lkp
lateral view explode(referrer_id)ref_exp as ref_id_splitted     
where product='PL' and partner='creditkarma';

add file /scriptpath.py;
add file ${path};
add file hdfs://a/b/c/scriptpath.py;
add file hdfs://${applicationPath}/scripts/qual_resp/A.PS;
add file hdfs://${applicationPath}/scripts/qual_resp.py;

add file hdfs://${scriptpath}/CallUrl.sh;
add file hdfs://${scriptpath}/ParseJson.py;
  
