DECLARE book_name STRING DEFAULT 'Ulysses';
DECLARE book_year INT64 DEFAULT 1922;
DECLARE first_date INT64;

-- Create a temporary table called Books.
EXECUTE IMMEDIATE
  "CREATE TEMP TABLE Books (title STRING, publish_date INT64)";

-- -- Add a row for Hamlet (less secure)
EXECUTE IMMEDIATE
  "INSERT INTO Books (title, publish_date) VALUES('Hamlet', 1599)";

-- -- add a row for Ulysses, using the variables declared and the ? placeholder
EXECUTE IMMEDIATE
  "INSERT INTO Books (title, publish_date) VALUES(?, ?)"
  USING book_name, book_year;

-- -- add a row for Emma, using the identifier placeholder
EXECUTE IMMEDIATE
  "INSERT INTO Books (title, publish_date) VALUES(@name, @year)"
  USING 1815 as year, "Emma" as name;

-- -- add a row for Middlemarch, using an expression
EXECUTE IMMEDIATE
  CONCAT(
    "INSERT INTO Books (title, publish_date)", "VALUES('Middlemarch', 1871)"
  );

-- save the publish date of the first book, Hamlet, to a variable called
-- first_date
EXECUTE IMMEDIATE "SELECT publish_date FROM Books LIMIT 1" INTO first_date;


DECLARE x INT64 DEFAULT 10;
BEGIN
  DECLARE y INT64;
  SET y = x;
  SELECT y;
END;
SELECT x;

CREATE OR REPLACE PROCEDURE schema1.proc1() BEGIN
  SELECT 1/0;
END;

CREATE OR REPLACE PROCEDURE schema1.proc2() BEGIN
  CALL schema1.proc1();
END;

BEGIN
  CALL schema1.proc2();
EXCEPTION WHEN ERROR THEN
  SELECT
    error.message,
    error.stack_trace,
    error.statement_text,
    error.formatted_stack_trace;
END;

-- DECLARE target_product_id INT64 DEFAULT 103;
-- CASE
--   WHEN
--     EXISTS(SELECT 1 FROM schema.products_a WHERE product_id = target_product_id)
--     THEN SELECT 'found product in products_a table';
--   WHEN
--     EXISTS(SELECT 1 FROM schema.products_b WHERE product_id = target_product_id)
--     THEN SELECT 'found product in products_b table';
--   ELSE
--     SELECT 'did not find product';
-- END CASE;

DECLARE product_id INT64 DEFAULT 1;
CASE product_id
  WHEN 1 THEN
    SELECT CONCAT('Product one');
  WHEN 2 THEN
    SELECT CONCAT('Product two');
  ELSE
    SELECT CONCAT('Invalid product');
END CASE;

-- DECLARE target_product_id INT64 DEFAULT 103;
-- IF EXISTS(SELECT 1 FROM schema.products
--            WHERE product_id = target_product_id) THEN
--   SELECT CONCAT('found product ', CAST(target_product_id AS STRING));
--   ELSEIF EXISTS(SELECT 1 FROM schema.more_products
--            WHERE product_id = target_product_id) THEN
--   SELECT CONCAT('found product from more_products table',
--   CAST(target_product_id AS STRING));
-- ELSE
--   SELECT CONCAT('did not find product ', CAST(target_product_id AS STRING));
-- END IF;

label_1: BEGIN
  SELECT 1;
  BREAK label_1;
  SELECT 2; -- Unreached
END;

label_1: LOOP
  BREAK label_1;
END LOOP label_1;

WHILE x < 1 DO
  CONTINUE label_1; -- Error
END WHILE;

label_1: BEGIN
   label_1: BEGIN -- Error
     BREAK label_1;
   END;
END;

label_1: BEGIN
   label_1: BEGIN -- Error
     BREAK label_1;
   END;
END;

label_1: LOOP
  WHILE x < 1 DO
    IF y < 1 THEN
      CONTINUE label_1;
    ELSE
      BREAK label_1;
    END IF;
  END WHILE;
END LOOP label_1;


label_1: BEGIN
  SELECT 1;
  EXCEPTION WHEN ERROR THEN
    BREAK label_1;
    SELECT 2; -- Unreached
END;

label_1: BEGIN
  SELECT 1;
  CONTINUE label_1; -- Error
  SELECT 2;
END;

DECLARE x INT64 DEFAULT 0;

REPEAT
  SET x = x + 1;
  SELECT x;
  UNTIL x >= 3
END REPEAT;

label_1: BEGIN
  SELECT 1;
  EXCEPTION WHEN ERROR THEN
    BREAK label_1;
    SELECT 2; -- Unreached
END;

DECLARE heads BOOL;
DECLARE heads_count INT64 DEFAULT 0;
LOOP
  SET heads = RAND() < 0.5;
  IF heads THEN
    SELECT 'Heads!';
    SET heads_count = heads_count + 1;
  ELSE
    SELECT 'Tails!';
    BREAK;
  END IF;
END LOOP;
SELECT CONCAT(CAST(heads_count AS STRING), ' heads in a row');

BEGIN TRANSACTION;

-- -- -- Create a temporary table of new arrivals from warehouse #1
CREATE TEMP TABLE tmp AS
SELECT * FROM myschema.NewArrivals WHERE warehouse = 'warehouse #1';

-- -- -- Delete the matching records from the original table.
DELETE myschema.NewArrivals WHERE warehouse = 'warehouse #1';

-- Merge the matching records into the Inventory table.
MERGE myschema.Inventory AS I
USING tmp AS T
ON I.product = T.product
WHEN NOT MATCHED THEN
 INSERT(product, quantity, supply_constrained)
 VALUES(product, quantity, false)
WHEN MATCHED THEN
 UPDATE SET quantity = I.quantity + T.quantity;

DROP TABLE tmp;

COMMIT TRANSACTION;

BEGIN

--   BEGIN TRANSACTION;
  INSERT INTO myschema.NewArrivals
    VALUES ('top load washer', 100, 'warehouse :#1');
  -- Trigger an error.
  SELECT 1/0;
  COMMIT TRANSACTION;

EXCEPTION WHEN ERROR THEN
  -- Roll back the transaction inside the exception handler.
  SELECT error.message;
  ROLLBACK TRANSACTION;
END;

DECLARE retCode INT64;
-- Procedure signature: (IN account_id STRING, OUT retCode INT64)
CALL mySchema.UpdateSomeTables('someAccountId', retCode);
SELECT retCode;