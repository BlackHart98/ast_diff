with w1 as (select * from w2), w2 as (select * from w1)
select * from sales;

with venuecopy as (select * from venue)
select * from venuecopy order by 1 limit 10;


with venue_sales as
(select venuename, venuecity, sum(pricepaid) as venuename_sales
from sales, venue, event
where venue.venueid=event.venueid and event.eventid=sales.eventid
group by venuename, venuecity),
top_venues as
(select venuename
from venue_sales
where venuename_sales > 800000)
select venuename, venuecity, venuestate,
sum(qtysold) as venue_qty,
sum(pricepaid) as venue_sales
from sales, venue, event
where venue.venueid=event.venueid and event.eventid=sales.eventid
and venuename in(select venuename from top_venues)
group by venuename, venuecity, venuestate
order by venuename;


select caldate, sum(pricepaid) as daysales,
(with holidays as (select * from date where holiday ='t')
select sum(pricepaid)
from sales join holidays on sales.dateid=holidays.dateid
where caldate='2008-12-25') as dec25sales
from sales join date on sales.dateid=date.dateid
where caldate in('2008-12-25','2008-12-31')
group by caldate
order by caldate;

select caldate, sum(pricepaid) as daysales,
(with holidays as (select * from date where holiday ='t')
select sum(pricepaid)
from sales join holidays on sales.dateid=holidays.dateid
where caldate='2008-12-25') as dec25sales
from sales join holidays on sales.dateid=holidays.dateid
where caldate in('2008-12-25','2008-12-31')
group by caldate
order by caldate;

 with recursive john_org(id, name, manager_id, level) as
( select id, name, manager_id, 1 as level
 from employee
 where name = 'John'
 union all
 select e.id, e.name, e.manager_id, level + 1 as next_level
 from employee e, john_org j
 where e.manager_id = j.id and level < 4
 )
 select distinct id, name, manager_id from john_org order by manager_id;

 select *
from sales
limit 10;

select top 10 qtysold, sellerid
from sales
order by qtysold desc, sellerid;

select * from category order by 2, length(catdesc), 1, 3;

select distinct catgroup from category
order by 1;

select distinct week, month, year
from date
where month='DEC' and year=2008
order by 1, 2, 3;

select * from sales s, listing l
where s.listid=l.listid

SELECT *
FROM (SELECT partname, price FROM part) PIVOT ( 
    AVG(price) FOR partname IN ('prop', 'rudder', 'wing')
);

SELECT partname, avg(price)
FROM (SELECT partname, price FROM part)
WHERE partname IN ('prop', 'rudder', 'wing')
GROUP BY partname;

SELECT *
FROM (SELECT quality, manufacturer FROM part) PIVOT (
 count(*) FOR quality IN (1, 2, NULL)
);

SELECT manufacturer, quality, count(*)
FROM (SELECT quality, manufacturer FROM part)
WHERE quality IN (1, 2) OR quality IS NULL
GROUP BY manufacturer, quality
ORDER BY manufacturer;

SELECT *
FROM (SELECT quality, manufacturer FROM part) PIVOT (
 count(*) AS count FOR quality IN (1 AS high, 2 AS low, NULL AS na)
);

-- SELECT * FROM
--  (SELECT
--  booking_id,
--  (date_trunc('week', booking_date::date) + '5 days'::interval)::date as enddate,
--  hotel_code AS "hotel code"
-- FROM bookings
-- ) PIVOT (
--  count(booking_id) FOR enddate IN ('2023-02-04','2023-02-11','2023-02-18')
-- );

SELECT
 booking_date,
 MAX(CASE WHEN hotel_code = 'FOREST_L' THEN 'forest is booked' ELSE '' END) AS
 FOREST_L,
 MAX(CASE WHEN hotel_code = 'DESERT_S' THEN 'desert is booked' ELSE '' END) AS
 DESERT_S,
 MAX(CASE WHEN hotel_code = 'OCEAN_WV' THEN 'ocean is booked' ELSE '' END) AS
 OCEAN_WV
FROM bookings
GROUP BY booking_date
ORDER BY booking_date asc;

SELECT *
FROM (SELECT red, green, blue FROM count_by_color) UNPIVOT (
 cnt FOR color IN (red, green, blue)
);

SELECT * FROM (
 SELECT red, green, blue
 FROM count_by_color
) UNPIVOT INCLUDE NULLS (
 cnt FOR color IN (red, green, blue)
);

SELECT *
FROM count_by_color UNPIVOT (
 cnt FOR color IN (red, green, blue)
);

SELECT *
FROM count_by_color UNPIVOT (
 cnt FOR color IN (red AS r, green AS g, blue AS b)
);

select listing.listid, sum(pricepaid) as price, sum(commission) as comm
from listing, sales
where listing.listid = sales.listid
and listing.listid between 1 and 5
group by 1
order by 1;

select listing.listid, sum(pricepaid) as price, sum(commission) as comm
from listing left outer join sales on sales.listid = listing.listid
where listing.listid between 1 and 5
group by 1
order by 1;

select listing.listid, sum(pricepaid) as price, sum(commission) as comm
from listing right outer join sales on sales.listid = listing.listid
where listing.listid between 1 and 5
group by 1
order by 1;

select listing.listid, sum(pricepaid) as price, sum(commission) as comm
from listing full join sales on sales.listid = listing.listid
where listing.listid between 1 and 5
and (listing.listid IS NULL or sales.listid IS NULL)
group by 1
order by 1;

select listing.listid, sum(pricepaid) as price, sum(commission) as comm
from sales join listing
on sales.listid=listing.listid and sales.eventid=listing.eventid
where listing.listid between 1 and 5
group by 1
order by 1;

select sales.listid as sales_listid, listing.listid as listing_listid
from sales cross join listing
where sales.listid between 1 and 5
and listing.listid between 1 and 5
order by 1,2;

select catgroup1, sold, unsold
from
(select catgroup, sum(qtysold) as sold
from category c, event e, sales s
where c.catid = e.catid and e.eventid = s.eventid
group by catgroup) as a(catgroup1, sold)
join
(select catgroup, sum(numtickets)-sum(qtysold) as unsold
from category c, event e, sales s, listing l
where c.catid = e.catid and e.eventid = s.eventid
and s.listid = l.listid
group by catgroup) as b(catgroup2, unsold)
on a.catgroup1 = b.catgroup2
order by 1;


select eventname, starttime, pricepaid/qtysold as costperticket, qtysold
from sales, event
where sales.eventid = event.eventid
and eventname='Hannah Montana'
and date_part(quarter, starttime) in(1,2)
and date_part(year, starttime) = 2008
order by 3 desc, 4, 2, 1 limit 10;

select count(*)
from sales, listing
where sales.listid = listing.listid(+);

select catname, catgroup, eventid
from category, event
where category.catid=event.catid(+) and eventid(+)=796;

select catname, catgroup, eventid
from category, event
where category.catid=event.catid(+) and eventid=796;

select listid, eventid, sum(pricepaid) as revenue,
count(qtysold) as numtix
from sales
group by listid, eventid
order by 3, 4, 2, 1
limit 5;

select listid, eventid, sum(pricepaid) as revenue,
count(qtysold) as numtix
from sales
group by 1,2
order by 3, 4, 2, 1
limit 5;

SELECT category, product, sum(cost) as total
FROM orders
GROUP BY GROUPING SETS(category, product); 

SELECT category, product, sum(cost) as total
FROM orders
GROUP BY ROLLUP(category, product) ORDER BY 1,2; 

SELECT category, product, sum(cost) as total
FROM orders
GROUP BY CUBE(category, product) ORDER BY 1,2; 

SELECT category, product,
 GROUPING(category) as grouping0, 
 GROUPING(product) as grouping1,
 GROUPING(category, product) as grouping2,
 sum(cost) as total
FROM orders
GROUP BY CUBE(category, product) ORDER BY 3,1,2;

SELECT pre_owned, category, product,
 GROUPING(category, product, pre_owned) as group_id,
 sum(cost) as total
FROM orders
GROUP BY pre_owned, ROLLUP(category, product) ORDER BY 4,1,2,3;

SELECT pre_owned, category, product,
 GROUPING(category, product, pre_owned) as group_id,
 sum(cost) as total
FROM orders
GROUP BY pre_owned, CUBE(category, product) ORDER BY 4,1,2,3; 

select eventname, sum(pricepaid)
from sales join event on sales.eventid = event.eventid
group by 1
having sum(pricepaid) > 800000
order by 2 desc, 1;

select eventname, sum(pricepaid)
from sales join event on sales.eventid = event.eventid
group by 1
having sum(qtysold) >2000
order by 2 desc, 1;


SELECT *
FROM store_sales ss
WHERE ss_sold_time > time '12:00:00'
QUALIFY row_number()
OVER (PARTITION BY ss_sold_date ORDER BY ss_sales_price DESC) <= 2

SELECT *
FROM store_sales ss
QUALIFY last_value(ss_item)
OVER (PARTITION BY ss_sold_date ORDER BY ss_sold_time ASC
 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) = ss_item;

 SELECT * FROM (
 SELECT *,
 last_value(ss_item)
 OVER (PARTITION BY ss_sold_date ORDER BY ss_sold_time ASC
 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ss_last_item
 FROM store_sales ss
)
WHERE ss_last_item = ss_item;

select * from t1
union
select * from t2
except
select * from t3
order by c1;

select listid, sellerid, eventid from listing
union select listid, sellerid, eventid from sales
order by listid, sellerid, eventid desc limit 5;

select listid, lastname, firstname, username,
pricepaid as price, 'S' as buyorsell
from sales, users
where sales.sellerid=users.userid
and pricepaid >=10000
union
select listid, lastname, firstname, username, pricepaid,
'B' as buyorsell
from sales, users
where sales.buyerid=users.userid
and pricepaid >=10000
order by 1, 2, 3, 4, 5;

select eventid, listid, 'Yes' as salesrow
from sales
where listid in(500,501,502)
union all
select eventid, listid, 'No'
from listing
where listid in(500,501,502)
order by listid asc;

select eventid, listid, 'Yes' as salesrow
from sales
where listid in(500,501,502)
union
select eventid, listid, 'No'
from listing
where listid in(500,501,502)
order by listid asc;

select distinct eventname from event, sales, venue
where event.eventid=sales.eventid and event.venueid=venue.venueid
and date_part(month,starttime)=3 and venuecity='Los Angeles'
intersect
select distinct eventname from event, sales, venue
where event.eventid=sales.eventid and event.venueid=venue.venueid
and date_part(month,starttime)=3 and venuecity='New York City'
order by eventname asc;

SELECT COUNT(*)
FROM Employee "start"
CONNECT BY PRIOR id = manager_id
START WITH name = 'John';