create temporary table day2(id serial primary key, command text, value integer);
copy day2 (command, value)
from '/Users/corydingels/projects/dingels35/aoc2021/day2/day2.txt' (FORMAT CSV, DELIMITER(' '));

-- part 1
select
  sum(case command when 'up' then 0 - value when 'down' then value end)
  *
  sum(case command when 'forward' then value end)
from day2;

-- part 2
with x as (
  select command, value,
    sum(case command when 'up' then 0-value when 'down' then value else 0 end) OVER (order by id) as aim
  from day2
)
select sum(value) * sum(value * aim)
from x
where command = 'forward';
