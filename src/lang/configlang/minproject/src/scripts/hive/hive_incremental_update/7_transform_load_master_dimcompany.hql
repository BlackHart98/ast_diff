INSERT INTO TABLE master.dimcompany
SELECT 
    row_number() OVER (ORDER BY cik) AS sk,
    CAST(cik AS BIGINT) AS companyid, 
    s.st_name AS status,
    companyname AS name, 
    i.in_name AS industry,
    CASE 
        WHEN sprating NOT IN ('AAA','AA','AA+','AA-','A','A+','A-','BBB','BBB+','BBB-','BB','BB+','BB-','B','B+','B-','CCC','CCC+','CCC-','CC','C','D') 
            THEN NULL
        ELSE f.sprating 
    END AS sprating, 
    CASE
        WHEN sprating NOT IN ('AAA','AA','AA+','AA-','A','A+','A-','BBB','BBB+','BBB-','BB','BB+','BB-','B','B+','B-','CCC','CCC+','CCC-','CC','C','D')
            THEN NULL
        WHEN f.sprating LIKE 'A%' OR f.sprating LIKE 'BBB%' 
            THEN false
        ELSE 
            true
    END AS islowgrade,
    ceoname AS ceo,
    addressline1,
    addressline2,
    postalcode, 
    city, 
    stateprovince,
    country, 
    description, 
    CAST(foundingdate AS DATE) AS foundingdate,
    CASE 
        WHEN LEAD(f.pts) OVER (PARTITION BY cik ORDER BY pts ASC) IS NULL 
            THEN true 
        ELSE false 
    END AS iscurrent,
    1 AS batchid,
    CAST(SUBSTR(f.pts, 1, 8) AS DATE) AS effectivedate,
    CAST('9999-12-31' AS DATE) AS enddate 
FROM 
    staging.finwire_cmp f
JOIN 
    staging.statustype s ON f.status = s.st_id 
JOIN 
    staging.industry i ON f.industryid = i.in_id;