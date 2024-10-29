DROP TABLE IF EXISTS staging.batchdate;

CREATE TABLE staging.batchdate (
    batchdate DATE 
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;


DROP TABLE IF EXISTS staging.`date`;

CREATE TABLE staging.`date` (
    sk_dateid DECIMAL,
    datevalue CHAR(20),
    datedesc CHAR(20),
    calendaryearid DECIMAL,
    calendaryeardesc CHAR(20),
    calendarqtrid DECIMAL,
    calendarqtrdesc CHAR(20),
    calendarmonthid DECIMAL,
    calendarmonthdesc CHAR(20),
    calendarweekid DECIMAL,
    calendarweekdesc CHAR(20),
    dayofweeknum DECIMAL,
    dayofweekdesc CHAR(10),
    fiscalyearid DECIMAL,
    fiscalyeardesc CHAR(20),
    fiscalqtrid DECIMAL,
    fiscalqtrdesc CHAR(20),
    holidayflag BOOLEAN 
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;

DROP TABLE IF EXISTS staging.finwire;
CREATE TABLE staging.finwire (
  text STRING
)
STORED AS TEXTFILE;

DROP TABLE IF EXISTS staging.finwire_cmp;
CREATE TABLE staging.finwire_cmp (
  pts CHAR(15),
  rectype CHAR(3),
  companyname CHAR(60),
  cik CHAR(10),
  status CHAR(4),
  industryid CHAR(2),
  sprating CHAR(4),
  foundingdate CHAR(8),
  addressline1 CHAR(80),
  addressline2 CHAR(80),
  postalcode CHAR(12),
  city CHAR(25),
  stateprovince CHAR(20),
  country CHAR(24),
  ceoname CHAR(46),
  description CHAR(150)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

DROP TABLE IF EXISTS staging.finwire_sec;
CREATE TABLE staging.finwire_sec (
  pts CHAR(15),
  rectype CHAR(3),
  symbol CHAR(15),
  issuetype CHAR(6),
  status CHAR(4),
  name CHAR(70),
  exid CHAR(6),
  shout CHAR(13),
  firsttradedate CHAR(8),
  firsttradeexchg CHAR(8),
  dividend CHAR(12),
  conameorcik CHAR(60)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

DROP TABLE IF EXISTS staging.finwire_fin;
CREATE TABLE staging.finwire_fin (
  pts CHAR(15),
  rectype CHAR(3),
  year CHAR(4),
  quarter CHAR(1),
  qtrstartdate CHAR(8),
  postingdate CHAR(8),
  revenue CHAR(17),
  earnings CHAR(17),
  eps CHAR(12),
  dilutedeps CHAR(12),
  margin CHAR(12),
  inventory CHAR(17),
  assets CHAR(17),
  liability CHAR(17),
  shout CHAR(13),
  dilutedshout CHAR(13),
  conameorcik CHAR(60)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;


DROP TABLE IF EXISTS staging.hr;

CREATE TABLE staging.hr (
    employeeid DECIMAL,
    managerid DECIMAL,
    employeefirstname CHAR(30),
    employeelastname CHAR(30),
    employeemi CHAR(1),
    employeejobcode DECIMAL,
    employeebranch CHAR(30),
    employeeoffice CHAR(10),
    employeephone CHAR(14)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;


DROP TABLE IF EXISTS staging.industry;

CREATE TABLE staging.industry (
    in_id CHAR(2),
    in_name CHAR(50),
    in_sc_id CHAR(4)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;


DROP TABLE IF EXISTS staging.prospect;

CREATE TABLE staging.prospect (
    agencyid CHAR(30),
    lastname CHAR(30),
    firstname CHAR(30),
    middleinitial CHAR(1),
    gender CHAR(1),
    addressline1 CHAR(80),
    addressline2 CHAR(80),
    postalcode CHAR(12),
    city CHAR(25),
    state CHAR(20),
    country CHAR(24),
    phone CHAR(30),
    income DECIMAL,
    numbercars DECIMAL,
    numberchildren DECIMAL,
    maritalstatus CHAR(1),
    age DECIMAL,
    creditrating DECIMAL,
    ownorrentflag CHAR(1),
    employer CHAR(30),
    numbercreditcards DECIMAL,
    networth DECIMAL
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

DROP TABLE IF EXISTS staging.statustype;

CREATE TABLE staging.statustype (
    st_id CHAR(4),
    st_name CHAR(10) 
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;


DROP TABLE IF EXISTS staging.taxrate;

CREATE TABLE staging.taxrate (
    tx_id CHAR(4),
    tx_name CHAR(50),
    tx_rate DECIMAL(6, 5) 
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;


DROP TABLE IF EXISTS staging.time;

CREATE TABLE staging.time (
    sk_timeid DECIMAL,
    timevalue CHAR(20),
    hourid DECIMAL,
    hourdesc CHAR(20),
    minuteid DECIMAL,
    minutedesc CHAR(20),
    secondid DECIMAL,
    seconddesc CHAR(20),
    markethoursflag BOOLEAN,
    officehoursflag BOOLEAN
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;


DROP TABLE IF EXISTS staging.tradetype;

CREATE TABLE staging.tradetype (
    tt_id CHAR(3),
    tt_name CHAR(12),
    tt_is_sell DECIMAL,
    tt_is_mrkt DECIMAL
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;