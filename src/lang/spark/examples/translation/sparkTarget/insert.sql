INSERT OVERWRITE TABLE dim_product
SELECT
 CASE WHEN new.product_id IS NOT NULL THEN new.product_id ELSE existing.product_id END AS product_id
FROM dim_product existing
FULL OUTER JOIN stg_new_product new
ON existing.product_id = new.product_id
WHERE existing.product_id IS NULL OR new.row_number = 1;