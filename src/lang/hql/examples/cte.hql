
with q1 as ( select key from src where key = '5')
select *
from q1;

with
q1 as ( select key from q2 where key = '${tlcencDB}'),
q2 as ( select key from src where key = ${tlcencDB})
select * from (select key from q1) a;
 
-- from style
with q1 as (select * from src where key= '5')
from q1
select *; 

with q1 as ( select key, value from src where key = '5')
from q1
insert overwrite table tab 
select *;

with a as (select * from b)
insert into table ${db_name}.actor_ext_scd partition (current_flg)
select *;
