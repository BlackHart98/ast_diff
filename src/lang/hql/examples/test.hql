CREATE  TABLE stg_new_product   AS SELECT 
  p.id AS product_id, 
  p.product_code, 
  p.product_name, 
  p.description, 
  s.company AS supplier_company, 
  p.standard_cost, 
  p.list_price, 
  p.reorder_level, 
  p.target_level, 
  p.quantity_per_unit, 
  p.discontinued, 
  p.minimum_reorder_quantity, 
  p.category, 
  p.attachments, 
  CURRENT_TIMESTAMP() AS insertion_timestamp
FROM Product pLEFT
JOIN Supplier s ON (s.id = p.supplier_id);

CREATE  TABLE IF NOT EXISTS fact_sales (
  order_id INT, 
  product_id INT, 
  customer_id INT, 
  employee_id INT, 
  shipper_id INT, 
  quantity INT, 
  unit_price DECIMAL(10, 2), 
  discount DECIMAL(4, 2), 
  status_id INT, 
  date_allocated DATE, 
  purchase_order_id INT, 
  inventory_id INT, 
  order_date DATE, 
  shipped_date DATE, 
  paid_date DATE, 
  insertion_timestamp TIMESTAMP
)  PARTITIONED BY (
  order_date DATE
);

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

CREATE  TABLE IF NOT EXISTS dim_product LIKE stg_new_product;

CREATE VIEW IF NOT EXISTS date_dimension AS SELECT 
  date_format(d, 'yyyy-MM-dd') AS id, 
  d AS full_date, 
  YEAR(d) AS year, 
  FROM_UNIXTIME((UNIX_TIMESTAMP(d) - (86400 * (date_format(d, 'u') - 1)))) AS week_start_date, 
  date_format(d, 'u') AS week_day, 
  date_format(d, 'EEEE') AS day_name, 
  (CASE WHEN (date_format(d, 'u')  IN (6,7)) THEN 0 
        ELSE 1 
  END) AS day_is_weekday, 
  date_format(d, 'MM') AS month, 
  date_format(d, 'MMMM') AS month_name, 
  date_format(d, 'Q') AS fiscal_qtr, 
  YEAR(d) AS fiscal_year
FROM (SELECT 
  explode(split(space(DATEDIFF('2050-01-01', '2014-01-01')), ' ')) + '2014-01-01' AS d
) date_array;