ALTER TABLE orders 
DROP PARTITION (dt = '2014-05-14', country = 'IN');

ALTER TABLE orders 
DROP PARTITION (dt = '2014-05-14', country = 'IN'), PARTITION (dt = '2014-05-15', country = 'IN');

