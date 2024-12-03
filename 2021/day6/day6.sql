drop table if exists day6;
create temporary table day6(id serial primary key, timers text);
copy day6 (timers)
from '/Users/corydingels/projects/dingels35/aoc2021/day6/day6.txt' (FORMAT CSV, DELIMITER(' '));

-- part 1
with recursive x as (
    select regexp_split_to_table(timers, ',')::int timer, 0 i
    from day6
    union all
    select regexp_split_to_table(
      case when timer > 0 then (timer - 1)::text else '6,8' end, ','
    )::int, i + 1
    from x
    where i < 80
)
select count(*) from x where i = 80; -- 373378

-- part 2

with recursive x as (
    select
      regexp_split_to_table('0,1,2,3,4,5,6,7,8', ',')::int original,
      regexp_split_to_table('0,1,2,3,4,5,6,7,8', ',')::int timer,
      0 i

    union all

    select
      original,
      regexp_split_to_table(case when timer > 0 then (timer - 1)::text else '6,8' end, ',')::int,
      i + 1
    from x
    where i < 64
), count_after_64_iterations as (
  select original, timer, count(*) ct
  from x
  where i = 64
  group by original, timer
), day6_after_0_iterations as (
  select regexp_split_to_table(timers, ','):: int timer, count(*) ct
  from day6
  group by regexp_split_to_table(timers, ','):: int
), day6_afer_64_iterations as (
    select
      count_after_64_iterations.timer, sum(day6_after_0_iterations.ct * count_after_64_iterations.ct) ct
    from day6_after_0_iterations
      join count_after_64_iterations on day6_after_0_iterations.timer = count_after_64_iterations.original
    group by count_after_64_iterations.timer
), day6_afer_128_iterations as (
    select
      count_after_64_iterations.timer, sum(day6_afer_64_iterations.ct * count_after_64_iterations.ct) ct
    from day6_afer_64_iterations
      join count_after_64_iterations on day6_afer_64_iterations.timer = count_after_64_iterations.original
    group by count_after_64_iterations.timer
), day6_afer_192_iterations as (
    select
      count_after_64_iterations.timer, sum(day6_afer_128_iterations.ct * count_after_64_iterations.ct) ct
    from day6_afer_128_iterations
      join count_after_64_iterations on day6_afer_128_iterations.timer = count_after_64_iterations.original
    group by count_after_64_iterations.timer
), day6_afer_256_iterations as (
    select
      count_after_64_iterations.timer, sum(day6_afer_192_iterations.ct * count_after_64_iterations.ct) ct
    from day6_afer_192_iterations
      join count_after_64_iterations on day6_afer_192_iterations.timer = count_after_64_iterations.original
    group by count_after_64_iterations.timer
)
select sum(ct)
from day6_afer_256_iterations
;




