PREPARE my_select1 FROM 
SELECT * FROM nation;

PREPARE my_select2 FROM 
SELECT order FROM orders WHERE productid = 4 and quantity < 5;

PREPARE my_select2 FROM 
SELECT order FROM orders WHERE productid = ? and quantity < ?;


PREPARE my_insert FROM 
INSERT INTO cities_usa (city, state) 
SELECT city, state 
FROM cities_world 
WHERE country = 'usa';

PREPARE my_insert FROM 
INSERT INTO cities_usa (city, state) 
SELECT city, state 
FROM cities_world 
WHERE country = ?;

