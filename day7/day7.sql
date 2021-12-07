drop table if exists day7;
create temporary table day7(positions text);
copy day7 (positions)
from '/Users/corydingels/projects/dingels35/aoc2021/day7/day7.txt' (FORMAT CSV, DELIMITER(' '));

-- part 1
with initial_positions as (
  select regexp_split_to_table(positions, ',')::int as position
  from day7
), all_positions as (
  select generate_series(0,(select max(position) from initial_positions)) as position
)
select all_positions.position, sum(abs(initial_positions.position - all_positions.position)) total_distance
from initial_positions
full outer join all_positions on 1 = 1
group by all_positions.position
order by total_distance
limit 1
;

-- part 2
with initial_positions as (
  select regexp_split_to_table(positions, ',')::int as position
  from day7
), all_positions as (
  select generate_series(0,(select max(position) from initial_positions)) as position
), costs as (
  select position as distance, sum(position) over (order by position) as cost
  from all_positions
)
select all_positions.position, sum(costs.cost) total_distance
from initial_positions
full outer join all_positions on 1 = 1
join costs on costs.distance = abs(initial_positions.position - all_positions.position)
group by all_positions.position
order by total_distance
limit 1
;

