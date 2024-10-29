INSERT OVERWRITE TABLE dim_product    SELECT 
  (CASE WHEN (new.product_id IS NOT NULL) THEN new.product_id 
        ELSE existing.product_id 
  END) AS product_id, 
  (CASE WHEN (new.product_code IS NOT NULL) THEN new.product_code 
        ELSE existing.product_code 
  END) AS product_code, 
  (CASE WHEN (new.product_name IS NOT NULL) THEN new.product_name 
        ELSE existing.product_name 
  END) AS product_name, 
  (CASE WHEN (new.description IS NOT NULL) THEN new.description 
        ELSE existing.description 
  END) AS description, 
  (CASE WHEN (new.supplier_company IS NOT NULL) THEN new.supplier_company 
        ELSE existing.supplier_company 
  END) AS supplier_company, 
  (CASE WHEN (new.standard_cost IS NOT NULL) THEN new.standard_cost 
        ELSE existing.standard_cost 
  END) AS standard_cost, 
  (CASE WHEN (new.list_price IS NOT NULL) THEN new.list_price 
        ELSE existing.list_price 
  END) AS list_price, 
  (CASE WHEN (new.reorder_level IS NOT NULL) THEN new.reorder_level 
        ELSE existing.reorder_level 
  END) AS reorder_level, 
  (CASE WHEN (new.target_level IS NOT NULL) THEN new.target_level 
        ELSE existing.target_level 
  END) AS target_level, 
  (CASE WHEN (new.quantity_per_unit IS NOT NULL) THEN new.quantity_per_unit 
        ELSE existing.quantity_per_unit 
  END) AS quantity_per_unit, 
  (CASE WHEN (new.discontinued IS NOT NULL) THEN new.discontinued 
        ELSE existing.discontinued 
  END) AS discontinued, 
  (CASE WHEN (new.minimum_reorder_quantity IS NOT NULL) THEN new.minimum_reorder_quantity 
        ELSE existing.minimum_reorder_quantity 
  END) AS minimum_reorder_quantity, 
  (CASE WHEN (new.category IS NOT NULL) THEN new.category 
        ELSE existing.category 
  END) AS category, 
  (CASE WHEN (new.attachments IS NOT NULL) THEN new.attachments 
        ELSE existing.attachments 
  END) AS attachments, 
  (CASE WHEN (new.insertion_timestamp IS NOT NULL) THEN new.insertion_timestamp 
        ELSE existing.insertion_timestamp 
  END) AS insertion_timestamp
FROM dim_product existing
FULL OUTER JOIN stg_new_product new ON (existing.product_id = new.product_id) 
WHERE ((existing.product_id IS NULL) OR (new.row_number = 1));