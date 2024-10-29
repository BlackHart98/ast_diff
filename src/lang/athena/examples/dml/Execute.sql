PREPARE my_select1 FROM 
SELECT name FROM nation;

EXECUTE my_select1;

PREPARE my_select2 FROM 
SELECT * FROM "my_database"."my_table" WHERE year = ?;

EXECUTE my_select2 USING 2012;

PREPARE my_select3 FROM 
SELECT order FROM orders WHERE productid = ? and quantity < ?;

EXECUTE my_select3 USING 346078, 12;