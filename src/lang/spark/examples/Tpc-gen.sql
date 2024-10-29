-- Insert into the target table
INSERT INTO master.dimcustomer
SELECT
    sk,
    c_id AS customerid,
    c_tax_id AS taxid,
    status,
    c_l_name AS lastname,
    c_f_name AS firstname,
    c_m_name AS middleinitial,
    gender,
    c_tier AS tier,
    c_dob AS dob,
    c_adline1 AS addressline1,
    c_adline2 AS addressline2,
    c_zipcode AS postalcode,
    c_city AS city,
    c_state_prov AS stateprov,
    c_ctry AS country,
    phone1,
    phone2,
    phone3,
    c_prim_email AS email1,
    c_alt_email AS email2,
    nat_tx_name AS nationaltaxratedesc,
    nat_tx_rate AS nationaltaxrate,
    lcl_tx_name AS localtaxratedesc,
    lcl_tx_rate AS localtaxrate,
    NULL AS agencyid,  -- Placeholder as per the SQL logic
    NULL AS creditrating,  -- Placeholder as per the SQL logic
    NULL AS networth,  -- Placeholder as per the SQL logic
    NULL AS marketingnameplate,  -- Placeholder as per the SQL logic
    iscurrent,
    batchid,
    effectivedate,
    enddate
FROM (
    SELECT
        row_number() OVER (ORDER BY cm.c_id) AS sk,
        cm.c_id,
        cm.c_tax_id,
        CASE
            WHEN cm.actiontype = 'INACT' THEN 'INACTIVE'
            ELSE 'ACTIVE'
        END AS status,
        cm.c_l_name,
        cm.c_f_name,
        cm.c_m_name,
        CASE
            WHEN UPPER(cm.c_gndr) = 'M' OR UPPER(cm.c_gndr) = 'F' THEN UPPER(cm.c_gndr)
            ELSE 'U'
        END AS gender,
        cm.c_tier,
        cm.c_dob,
        cm.c_adline1,
        cm.c_adline2,
        cm.c_zipcode,
        cm.c_city,
        cm.c_state_prov,
        cm.c_ctry,
        CASE
            WHEN cm.c_p_1_ctry_code IS NOT NULL AND cm.c_p_1_area_code IS NOT NULL AND cm.c_p_1_local IS NOT NULL
            THEN CONCAT_WS(' ', CONCAT_WS('(', CONCAT('+', cm.c_p_1_ctry_code, cm.c_p_1_area_code), ')'), cm.c_p_1_local, COALESCE(cm.c_p_1_ext, ''))
            WHEN cm.c_p_1_ctry_code IS NULL AND cm.c_p_1_area_code IS NOT NULL AND cm.c_p_1_local IS NOT NULL
            THEN CONCAT_WS(' ', CONCAT('(', cm.c_p_1_area_code, ')'), cm.c_p_1_local, COALESCE(cm.c_p_1_ext, ''))
            WHEN cm.c_p_1_area_code IS NULL AND cm.c_p_1_local IS NOT NULL
            THEN CONCAT(cm.c_p_1_local, COALESCE(cm.c_p_1_ext, ''))
            ELSE NULL
        END AS phone1,
        CASE
            WHEN cm.c_p_2_ctry_code IS NOT NULL AND cm.c_p_2_area_code IS NOT NULL AND cm.c_p_2_local IS NOT NULL
            THEN CONCAT_WS(' ', CONCAT_WS('(', CONCAT('+', cm.c_p_2_ctry_code, cm.c_p_2_area_code), ')'), cm.c_p_2_local, COALESCE(cm.c_p_2_ext, ''))
            WHEN cm.c_p_2_ctry_code IS NULL AND cm.c_p_2_area_code IS NOT NULL AND cm.c_p_2_local IS NOT NULL
            THEN CONCAT_WS(' ', CONCAT('(', cm.c_p_2_area_code, ')'), cm.c_p_2_local, COALESCE(cm.c_p_2_ext, ''))
            WHEN cm.c_p_2_area_code IS NULL AND cm.c_p_2_local IS NOT NULL
            THEN CONCAT(cm.c_p_2_local, COALESCE(cm.c_p_2_ext, ''))
            ELSE NULL
        END AS phone2,
        CASE
            WHEN cm.c_p_3_ctry_code IS NOT NULL AND cm.c_p_3_area_code IS NOT NULL AND cm.c_p_3_local IS NOT NULL
            THEN CONCAT_WS(' ', CONCAT_WS('(', CONCAT('+', cm.c_p_3_ctry_code, cm.c_p_3_area_code), ')'), cm.c_p_3_local, COALESCE(cm.c_p_3_ext, ''))
            WHEN cm.c_p_3_ctry_code IS NULL AND cm.c_p_3_area_code IS NOT NULL AND cm.c_p_3_local IS NOT NULL
            THEN CONCAT_WS(' ', CONCAT('(', cm.c_p_3_area_code, ')'), cm.c_p_3_local, COALESCE(cm.c_p_3_ext, ''))
            WHEN cm.c_p_3_area_code IS NULL AND cm.c_p_3_local IS NOT NULL
            THEN CONCAT(cm.c_p_3_local, COALESCE(cm.c_p_3_ext, ''))
            ELSE NULL
        END AS phone3,
        cm.c_prim_email,
        cm.c_alt_email,
        ntr.tx_name AS nat_tx_name,
        ntr.tx_rate AS nat_tx_rate,
        ltr.tx_name AS lcl_tx_name,
        ltr.tx_rate AS lcl_tx_rate,
        CASE
            WHEN cm.actionts = MAX(cm.actionts) OVER (PARTITION BY cm.c_id)
            THEN TRUE
            ELSE FALSE
        END AS iscurrent,
        1 AS batchid,
        CAST(cm.actionts AS DATE) AS effectivedate,
        CAST('9999-12-31' AS DATE) AS enddate,
        cm.actiontype
    FROM staging.customermgmt cm
    CROSS JOIN staging.batchdate bd
    LEFT JOIN master.taxrate ntr
        ON cm.c_nat_tx_id = ntr.tx_id
    LEFT JOIN master.taxrate ltr
        ON cm.c_lcl_tx_id = ltr.tx_id
    WHERE cm.actiontype IN ('NEW', 'UPDCUST', 'INACT')
) subquery;
