abort;

set analyze_threshold_percent to 0.01;

ANALYZE SKIP

analyze venue(venueid, venuename);

analyze venue predicate columns;

analyze compression sales(qtysold, commission, saletime);

ATTACH RLS POLICY policy_concerts ON tickit_category_redshift TO ROLE analyst, ROLE
;

begin read write;

CALL outer_proc(5);

cancel 802;

close movie_cursor;
commit;

COMMENT ON TABLE sales IS 'This table stores tickets sales data';

COMMENT ON COLUMN sales.eventid IS 'Foreign-key reference to the EVENT table.';

copy catdemo
from 's3://awssampledbuswest2/tickit/category_pipe.txt'
iam_role 'arn:aws:iam::<aws-account-id>:role/<role-name>'
region 'us-west-2';


deallocate prepare usernames;

declare lollapalooza cursor for
select eventname, starttime, pricepaid/qtysold as costperticket, qtysold
from sales, event
where sales.eventid = event.eventid
and eventname='Lollapalooza';

delete from event using sales where event.eventid=sales.eventid;

delete from category
where catid between 0 and 9;

DESC DATASHARE salesshare;

DESC IDENTITY PROVIDER azure_idp;

--  end transaction;

-- EXPLAIN
-- SELECT D.cint
-- FROM fact_tbl F INNER JOIN dim_tbl D ON F.k_dim = D.k
-- WHERE F.k_dim / 10 > 0; 

-- explain
-- select eventid, eventname, event.venueid, venuename
-- from event, venue
-- where event.venueid = venue.venueid;

-- fetch forward 5 from lollapalooza;

-- begin;
-- lock event, sales;

DETACH RLS POLICY policy_concerts ON tickit_category_redshift FROM ROLE analyst, ROLE
 dbadmin;