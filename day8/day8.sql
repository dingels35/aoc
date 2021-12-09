drop table if exists day8;
create temporary table day8(id serial primary key, signals text, outputs text);
copy day8 (signals, outputs)
from '/Users/corydingels/projects/dingels35/aoc2021/day8/day8.txt' (FORMAT CSV, DELIMITER('|'));

-- part 1
with all_outputs as (
  select regexp_split_to_table(btrim(outputs), ' ') as output_value
  from day8
)
select count(*)
from all_outputs
where length(output_value) in (2, 4, 3, 7);


-- part 2
drop table if exists signals;
create temporary table signals(id int, signal text, signal_length int, signal_array char[], value int);
insert into signals(id, signal)
select id, regexp_split_to_table(btrim(signals),' ') from day8;

-- reorder signals so they're all in the same order
update signals set signal = (
  select string_agg(x,'')
  from  (select unnest(string_to_array(signal,null)) as x order by x) as _
);

-- persist string lengths and array representations to make queries easier
update signals set signal_length = length(signal), signal_array = string_to_array(signal,null);

-- #1: length of 2 is always a 1
update signals set value = 1 where signal_length = 2;

-- #4: length of 4 is always a 4
update signals set value = 4 where signal_length = 4;

-- #7: length of 3 is always a 7
update signals set value = 7 where signal_length = 3;

-- #8: length of 7 is always a 8
update signals set value = 8 where signal_length = 7;

-- #3: only number with length of 5 that shares all letters as #1
update signals as s set value = 3
from signals as s2
where s2.id = s.id and s2.value = 1 and s.signal_length = 5 and
  cardinality(array( (select unnest(s.signal_array)) intersect (select unnest(s2.signal_array)))) = 2;

-- #2: only number with length of 4 that shares 2 letters with #4
update signals as s set value = 2
from signals as s2
where s2.id = s.id and s2.value = 4 and s.signal_length = 5 and
  cardinality(array( (select unnest(s.signal_array)) intersect (select unnest(s2.signal_array)))) = 2;

-- #5: only number with length of 5 that hasn't already been determined
update signals set value = 5 where signal_length = 5 and value is null;

-- #9: only number with length of 6 that shares 4 letters with #4
update signals as s set value = 9
from signals as s2
where s2.id = s.id and s2.value = 4 and s.signal_length = 6 and
  cardinality(array( (select unnest(s.signal_array)) intersect (select unnest(s2.signal_array)))) = 4;

-- #0: only remaining number with length of 6 that shares 2 letters with #1
update signals as s set value = 0
from signals as s2
where s2.id = s.id and s2.value = 1 and s.signal_length = 6 and s.value is null and
  cardinality(array( (select unnest(s.signal_array)) intersect (select unnest(s2.signal_array)))) = 2;

-- #6: only remaining number
update signals set value = 6 where value is null;

with outputs as (
  select id, regexp_split_to_table(btrim(outputs), ' ') as output_value
  from day8
), ordered_outputs as (
    select id, (
      select string_agg(x,'')
      from  (select unnest(string_to_array(output_value,null)) as x order by x) as _
    ) as output_value,
    row_number() over (partition by id) rn
    from outputs
), output_values as (
  select ordered_outputs.id, string_agg(value::char,'' order by rn) output_value
  from ordered_outputs
  left join signals on signals.signal = ordered_outputs.output_value and signals.id = ordered_outputs.id
  group by ordered_outputs.id
)
select sum(output_value::int) from output_values;
