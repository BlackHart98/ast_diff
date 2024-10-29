SET hive.strict.checks.cartesian.product=false;
SET hive.mapred.mode=nonstrict;

-- Create a temporary table to store sk_dateid
CREATE TEMPORARY TABLE tmp_sk_dateid AS
SELECT dd.sk_dateid
FROM master.dimdate dd
INNER JOIN staging.batchdate bd
    ON dd.datevalue = bd.batchdate
LIMIT 1;




CREATE VIEW master.prospect AS
SELECT
    p.agencyid,
    t.sk_dateid AS sk_dateid1,
    t.sk_dateid AS sk_dateid2,
    1 AS batch_id,
    false AS is_current, -- temporary before dimcustomer load dependency
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
    CASE 
        WHEN REGEXP_REPLACE(
                CONCAT_WS(
                    '+',
                    CASE WHEN p.networth > 1000000 OR p.income > 200000 THEN 'HighValue' ELSE '' END,
                    CASE WHEN p.numberchildren > 3 OR p.numbercreditcards > 5 THEN 'Expenses' ELSE '' END,
                    CASE WHEN p.age > 45 THEN 'Boomer' ELSE '' END,
                    CASE WHEN p.income < 50000 OR p.creditrating < 600 OR p.networth < 100000 THEN 'MoneyAlert' ELSE '' END,
                    CASE WHEN p.numbercars > 3 OR p.numbercreditcards > 7 THEN 'Spender' ELSE '' END,
                    CASE WHEN p.age < 25 AND p.networth > 1000000 THEN 'Inherited' ELSE '' END
                ),
                '^\\++|\\++$', ''
            ) = ''
        THEN NULL
        ELSE REGEXP_REPLACE(
                CONCAT_WS(
                    '+',
                    CASE WHEN p.networth > 1000000 OR p.income > 200000 THEN 'HighValue' ELSE '' END,
                    CASE WHEN p.numberchildren > 3 OR p.numbercreditcards > 5 THEN 'Expenses' ELSE '' END,
                    CASE WHEN p.age > 45 THEN 'Boomer' ELSE '' END,
                    CASE WHEN p.income < 50000 OR p.creditrating < 600 OR p.networth < 100000 THEN 'MoneyAlert' ELSE '' END,
                    CASE WHEN p.numbercars > 3 OR p.numbercreditcards > 7 THEN 'Spender' ELSE '' END,
                    CASE WHEN p.age < 25 AND p.networth > 1000000 THEN 'Inherited' ELSE '' END
                ),
                '^\\++|\\++$', ''
            )
    END AS flags
FROM staging.prospect p
JOIN tmp_sk_dateid t;
