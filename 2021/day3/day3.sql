create temporary table day3(id serial primary key, bits text);
copy day3 (bits)
from '/Users/corydingels/projects/dingels35/aoc2021/day3/day3-test.txt' (FORMAT CSV, DELIMITER(' '));

-- part 1
-- with x as (
--   -- split each string to rows with an index
--   select day3.*, x.*
--   from day3,
--     unnest(regexp_split_to_array(bits, '')) with ordinality as x(bit, idx)
-- ), y as (
--   -- count number of bits for each index
--   select idx, bit, count(*) ct
--   from x
--   group by idx, bit
-- ), z as (
--   -- find most comon and least common bits
--   select distinct idx,
--     first_value(bit) over (partition by idx order by ct desc) gamma,
--     first_value(bit) over (partition by idx order by ct) epsilon
--   from y
-- )
-- select string_agg(gamma, '' order by idx)::bit(12)::integer *
--   string_agg(epsilon, '' order by idx)::bit(12)::integer
-- from z;
-- -- 2498354


-- part 2
-- with x as (
--   -- split each string to rows with an index
--   select day3.*, x.*
--   from day3,
--     unnest(regexp_split_to_array(bits, '')) with ordinality as x(bit, idx)
-- ), y as (
--   -- count number of bits for each index
--   select idx, bit, count(*) ct
--   from x
--   group by idx, bit
-- ), z as (
--   -- find most comon and least common bits
--   select distinct idx,
--     first_value(bit) over (partition by idx order by ct desc) gamma,
--     first_value(bit) over (partition by idx order by ct) epsilon
--   from y
-- ), o2_gen_rating as (
--   select x.id, x.bits,
--     string_agg(case when x.bit = z.gamma then '1' else '0' end, '' order by x.idx) matching_bits
--   from x
--   join z on x.idx = z.idx
--   group by x.id, x.bits
-- )
-- select * from x;
--select * from o2_gen_rating order by matching_bits desc;
-- select *
-- from o2_gen_rating
-- join day3 on day3.id = o2_gen_rating.id
-- order by ct desc limit 1;

with recursive x as (
  -- split each string to rows with an index
  select day3.id, day3.bits, 1 as i
  from day3
  UNION
  (
    with y as (
      select max(id) id from x
    )
    select id, bits, i + 1
    from day3
    join y on day3.id = y.id
  )
)
select * from x
