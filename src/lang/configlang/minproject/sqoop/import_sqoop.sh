#!/bin/bash

# Remove old data from HDFS if it exists
hdfs dfs -rm -r /user/sqoop

# Create a new directory in HDFS for the import
hdfs dfs -mkdir -p /user/sqoop

# 1. Trade Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table trade \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.trade \
    --map-column-hive t_id=STRING,t_dts=STRING,t_st_id=STRING,t_tt_id=STRING,t_is_cash=INT,t_s_symb=STRING,t_qty=INT,t_bid_price=FLOAT,t_ca_id=STRING,t_exec_name=STRING,t_trade_price=FLOAT,t_chrg=FLOAT,t_comm=FLOAT,t_tax=FLOAT \
    --target-dir /user/sqoop/trade

# 2. HR Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table hr \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.hr \
    --map-column-hive employeeid=STRING,managerid=STRING,employeefirstname=STRING,employeelastname=STRING,employeemi=STRING,employeejobcode=INT,employeebranch=STRING,employeeoffice=STRING,employeephone=STRING \
    --target-dir /user/sqoop/hr

# 3. Industry Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table industry \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.industry \
    --map-column-hive in_id=STRING,in_name=STRING,in_sc_id=STRING \
    --target-dir /user/sqoop/industry

# 4. Batchdate Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table batchdate \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.batchdate \
    --map-column-hive batchdate=STRING \
    --target-dir /user/sqoop/batchdate

# 5. Cashtransaction Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table cashtransaction \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.cashtransaction \
    --map-column-hive ct_ca_id=STRING,ct_dts=STRING,ct_amt=FLOAT,ct_name=STRING \
    --target-dir /user/sqoop/cashtransaction

# 6. Customermgmt Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table customermgmt \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.customermgmt \
    --map-column-hive actiontype=STRING,actionts=STRING,c_id=STRING,c_tax_id=STRING,c_gndr=STRING,c_tier=INT,c_dob=STRING,c_l_name=STRING,c_f_name=STRING,c_m_name=STRING,c_adline1=STRING,c_adline2=STRING,c_zipcode=STRING,c_city=STRING,c_state_prov=STRING,c_ctry=STRING,c_prim_email=STRING,c_alt_email=STRING,c_p_1_ctry_code=STRING,c_p_1_area_code=STRING,c_p_1_local=STRING,c_p_1_ext=STRING,c_p_2_ctry_code=STRING,c_p_2_area_code=STRING,c_p_2_local=STRING,c_p_2_ext=STRING,c_p_3_ctry_code=STRING,c_p_3_area_code=STRING,c_p_3_local=STRING,c_p_3_ext=STRING,c_lcl_tx_id=STRING,c_nat_tx_id=STRING,ca_id=STRING,ca_tax_st=INT,ca_b_id=STRING,ca_name=STRING \
    --target-dir /user/sqoop/customermgmt

# 7. Dailymarket Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table dailymarket \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.dailymarket \
    --map-column-hive dm_date=STRING,dm_s_symb=STRING,dm_close=FLOAT,dm_high=FLOAT,dm_low=FLOAT,dm_vol=FLOAT \
    --target-dir /user/sqoop/dailymarket

# 8. Date Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table date \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.date \
    --map-column-hive sk_dateid=STRING,datevalue=STRING,datedesc=STRING,calendaryearid=STRING,calendaryeardesc=STRING,calendarqtrid=STRING,calendarqtrdesc=STRING,calendarmonthid=STRING,calendarmonthdesc=STRING,calendarweekid=STRING,calendarweekdesc=STRING,dayofweeknum=INT,dayofweekdesc=STRING,fiscalyearid=STRING,fiscalyeardesc=STRING,fiscalqtrid=STRING,fiscalqtrdesc=STRING,holidayflag=STRING \
    --target-dir /user/sqoop/date

# 9. Finwire Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table finwire \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.finwire \
    --map-column-hive text=STRING \
    --target-dir /user/sqoop/finwire

# 10. Holdinghistory Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table holdinghistory \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.holdinghistory \
    --map-column-hive hh_h_t_id=STRING,hh_t_id=STRING,hh_before_qty=INT,hh_after_qty=INT \
    --target-dir /user/sqoop/holdinghistory

# 11. Time Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table time \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.time \
    --map-column-hive sk_timeid=STRING,timevalue=STRING,hourid=INT,hourdesc=STRING,minuteid=INT,minutedesc=STRING,secondid=INT,seconddesc=STRING,markethoursflag=STRING,officehoursflag=STRING \
    --target-dir /user/sqoop/time

# 12. Tradehistory Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table tradehistory \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.tradehistory \
    --map-column-hive th_t_id=STRING,th_dts=STRING,th_st_id=STRING \
    --target-dir /user/sqoop/tradehistory

# 13. Tradetype Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table tradetype \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.tradetype \
    --map-column-hive tt_id=STRING,tt_name=STRING,tt_is_sell=INT,tt_is_mrkt=INT \
    --target-dir /user/sqoop/tradetype

# 14. Watchhistory Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table watchhistory \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.watchhistory \
    --map-column-hive w_c_id=STRING,w_s_symb=STRING,w_dts=STRING,w_action=STRING \
    --target-dir /user/sqoop/watchhistory

# 15. Audit Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table audit \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.audit \
    --map-column-hive dataset=STRING,batchid=STRING,audit_date=STRING,attribute=STRING,value=FLOAT,dvalue=FLOAT \
    --target-dir /user/sqoop/audit

# 16. Statustype Table
/usr/lib/sqoop/bin/sqoop import \
    --connect jdbc:postgresql://database:5432/postgres?currentSchema=temp_db \
    --table statustype \
    --username postgres \
    --password passw0rd \
    --num-mappers 1 \
    --hive-import \
    --hive-table staging.statustype \
    --map-column-hive st_id=STRING,st_name=STRING \
    --target-dir /user/sqoop/statustype
