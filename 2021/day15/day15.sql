drop table if exists day15;
create temporary table if not exists day15(id serial primary key, values text);
drop table if exists day15_data;
create temporary table if not exists day15_data(x int, y int, value int, total_cost int, execute_order int);

-- load input
copy day15 (values)
from '/Users/corydingels/projects/dingels35/aoc2021/day15/day15.txt' (FORMAT CSV, DELIMITER('*'));

insert into day15_data (x, y, value, total_cost, execute_order)
select id, idx, value::int, 0, rank() over (order by 10 * id + idx desc)
from day15,
  unnest(regexp_split_to_array(values, '')) with ordinality as x(value, idx);


-- for day2, need to blow up the map
insert into day15_data (x, y, value, total_cost, execute_order)
select
  x + x2.multiplier * 10, y + y2.multiplier * 10, (value + x2.multiplier + y2.multiplier) % 9, 0, 0
from day15_data,
  (select generate_series(0,4) as multiplier) as x2,
  (select generate_series(0,4) as multiplier) as y2
where x2.multiplier <> 0 or y2.multiplier <> 0
;
update day15_data set value = 9 where value = 0;

with calculated_order as (
  select x, y, rank() over (order by 10 * x + y desc) rnk
  from day15_data
)
update day15_data set execute_order = rnk
from calculated_order
where calculated_order.x = day15_data.x and calculated_order.y = day15_data.y;
-- end day2 stuff


do
$do$
begin
  for i in 1..(select max(execute_order) from day15_data) loop
    update day15_data as d1
    set total_cost = coalesce((
      select min(d2.total_cost + d1.value)
      from day15_data as d2
      where (d2.x = d1.x + 1 and d2.y = d1.y)
        or (d2.x = d1.x and d2.y = d1.y+ 1)
    ), d1.value)
    where execute_order = i;
  end loop;
end
$do$;

select total_cost - value as day2 from day15_data where x = 1 and y = 1;

select * from day15_data order by execute_order;


