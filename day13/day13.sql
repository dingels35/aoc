-- note - need to separate input in to 2 files for this exercise

create temporary table if not exists day13(lines text);
create temporary table if not exists day13_inputs(id serial primary key, x int, y int);
create temporary table if not exists day13_instructions(id serial primary key, instruction text, value int);
create temporary table if not exists part1 (id serial primary key, part1 int);

-- load input
copy day13 (lines)
from '/Users/corydingels/projects/dingels35/aoc2021/day13/day13.txt' (FORMAT CSV, DELIMITER('*'));

-- put input lines in to a table
insert into day13_inputs (x, y)
select split_part(lines,',',1)::int, split_part(lines,',',2)::int from day13 where lines not like 'fold along%';

-- put instruction lines in a tabl
insert into day13_instructions(instruction, value)
select split_part(lines,'=',1), split_part(lines,'=',2)::int from day13 where lines like 'fold along%';

-- update instruction so it is just an "x" or a "y"
update day13_instructions set instruction = replace(instruction, 'fold along ','');

-- loop through instructions and update inputs
do
$do$
begin
  for i in 1..(select count(*) from day13_instructions) loop

    -- get rid of values on the fold line
    delete from day13_inputs as inputs
      using day13_instructions as instructions
    where instructions.id = i
      and (
        (instructions.instruction = 'x' and inputs.x = instructions.value)
        or (instructions.instruction = 'y' and inputs.y = instructions.value)
      );

    -- transpose values on the fold line
    update day13_inputs as inputs
      set y = inputs.y - case when instructions.instruction = 'y' then 2 * (inputs.y - instructions.value) else 0 end,
        x = inputs.x - case when instructions.instruction = 'x' then 2 * (inputs.x - instructions.value) else 0 end
    from day13_instructions as instructions
    where instructions.id = i
      and (
        (instructions.instruction = 'x' and inputs.x > instructions.value)
        or (instructions.instruction = 'y' and inputs.y > instructions.value)
      );

    -- save current count of inputs in order to output part 1
    insert into part1(part1) select count(*)from (select distinct x, y from day13_inputs) as x;
  end loop;
end
$do$;

select part1 from part1 where id = 1; -- 664

with coordinates as (
  select *
  from (select generate_series(0,(select max(x) from day13_inputs)) as x) as x,
    (select generate_series(0,(select max(y) from day13_inputs)) as y) as y
), distinct_inputs as (
  select distinct x, y
  from day13_inputs
)
select string_agg(case when distinct_inputs is null then ' ' else '#' end, null order by coordinates.x) as part2
from coordinates
left join distinct_inputs on distinct_inputs.x = coordinates.x and distinct_inputs.y = coordinates.y
group by coordinates.y
order by coordinates.y;
-- EFJKZLBL