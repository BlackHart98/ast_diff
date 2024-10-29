

-- Create a temporary table to store the minimum date
CREATE TEMPORARY TABLE tmp_mindate AS
SELECT MIN(datevalue) AS effectivedate
FROM master.dimdate;

-- Retrieve the minimum date value into a Hive variable
--SET hivevar:effectivedate = (SELECT effectivedate FROM tmp_mindate);

-- Insert data into dimbroker using the computed effectivedate

CREATE VIEW master.dimbroker AS
SELECT 
    row_number() OVER (ORDER BY hr.employeeid) AS sk,
    hr.employeeid AS brokerid,
    hr.managerid,
    hr.employeefirstname,
    hr.employeelastname,
    hr.employeemi,
    hr.employeebranch,
    hr.employeeoffice,
    hr.employeephone,
    true AS iscurrent,
    1 AS batchid,
    '${hivevar:effectivedate}' AS effectivedate,  -- Use the variable here
    CAST('9999-12-31' AS DATE) AS enddate
FROM 
    staging.hr hr
WHERE 
    hr.employeejobcode = 314;
