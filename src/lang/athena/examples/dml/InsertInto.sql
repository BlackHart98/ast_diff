INSERT INTO canada_pageviews 
SELECT * 
FROM vancouver_pageviews;

INSERT INTO cities_usa (city,state)
SELECT city,state
FROM cities_world
    WHERE country='usa';

INSERT INTO canada_july_pageviews
SELECT *
FROM vancouver_pageviews
WHERE date
    BETWEEN date '2019-07-01'
        AND '2019-07-31';

INSERT INTO cities 
VALUES (1,'Lansing','MI','Si quaeris peninsulam amoenam circumspice'),
       (3,'Boise','ID','Esto perpetua');

