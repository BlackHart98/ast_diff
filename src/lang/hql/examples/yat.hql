DROP TABLE IF EXISTS product;

CREATE TABLE product AS
WITH source AS (
    SELECT 
        CAST(supplier_ids AS INT) AS supplier_id,
        id,
        product_code,
        product_name,
        description,
        standard_cost,
        list_price,
        reorder_level,
        target_level,
        quantity_per_unit,
        discontinued,
        minimum_reorder_quantity,
        category,
        attachments
    FROM northwind.products
    WHERE NOT (supplier_ids LIKE "%;%")
)
SELECT 
    *,
    current_timestamp() AS ingestion_timestamp
FROM source;