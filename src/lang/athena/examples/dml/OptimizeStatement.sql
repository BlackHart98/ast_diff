OPTIMIZE iceberg_table REWRITE DATA USING BIN_PACK
  WHERE category = 'c1';