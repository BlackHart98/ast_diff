CREATE TABLE Stg_new_product AS
SELECT
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
 current_timestamp() AS insertion_timestamp
FROM Product p
LEFT OUTER JOIN Supplier s
ON (s.id == p.supplier_id);