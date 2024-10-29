CREATE  TABLE IF NOT EXISTS dim_product LIKE stg_new_product;

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
FROM Product p
LEFT JOIN Supplier s ON (s.id = p.supplier_id);

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