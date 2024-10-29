CREATE TEMPORARY TABLE temp_current_active_customer AS 
SELECT DISTINCT
  upper(p.lastname) AS lastname,
  upper(p.firstname) AS firstname,
  upper(p.addressline1) AS addressline1,
  upper(p.addressline2) AS addressline2,
  upper(p.postalcode) AS postalcode
FROM master.prospect p
INNER JOIN master.dimcustomer c
ON upper(c.lastname) = upper(p.lastname)
AND upper(c.firstname) = upper(p.firstname)
AND upper(c.addressline1) = upper(p.addressline1)
AND upper(c.addressline2) = upper(p.addressline2)
AND upper(c.postalcode) = upper(p.postalcode)
WHERE c.status = 'ACTIVE'
AND c.iscurrent = true;

-- Step 2: Create or replace the master.prospect table with updated values
CREATE TABLE master.prospect_new AS
SELECT
  p.agencyid,
  p.sk_recorddateid,
  p.sk_updatedateid,
  p.batchid,
  CASE
    WHEN t.lastname IS NOT NULL THEN true
    ELSE p.iscustomer
  END AS iscustomer,
  p.lastname,
  p.firstname,
  p.middleinitial,
  p.gender,
  p.addressline1,
  p.addressline2,
  p.postalcode,
  p.city,
  p.state,
  p.country,
  p.phone,
  p.income,
  p.numbercars,
  p.numberchildren,
  p.maritalstatus,
  p.age,
  p.creditrating,
  p.ownorrentflag,
  p.employer,
  p.numbercreditcards,
  p.networth,
  p.marketingnameplate
FROM master.prospect p
LEFT JOIN temp_current_active_customer t
ON upper(t.lastname) = upper(p.lastname)
AND upper(t.firstname) = upper(p.firstname)
AND upper(t.addressline1) = upper(p.addressline1)
AND upper(t.addressline2) = upper(p.addressline2)
AND upper(t.postalcode) = upper(p.postalcode);

-- Step 3: Replace the old table with the updated table
DROP TABLE master.prospect;
-- ALTER TABLE master.prospect_new RENAME TO master.prospect;

-- Step 4: Drop the temporary table
DROP TABLE temp_current_active_customer;