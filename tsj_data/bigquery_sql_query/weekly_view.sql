/** SQL 쿼리 설명
* view 한 user_session 중, 1번만 기록된 데이터들의 비율을 파악하고자 했습니다.
* 각 주마다 event_type="view"인 데이터를 user_session별로 groupby 하여, 갯수를 count 한 것을 with 문에 작성했습니다
* (1 ~ 5주차)
* 이후, 각 주마다 1번만 view한 데이터 숫자를 week, 비율을 pct에 표시했고,
* 해당 주에 발생한 user_session 전체 데이터를 total에 카운팅 했습니다.
**/

with week_1st as(
            select user_session, count(user_session) as counts, sum(price)
            from `cp2-project-350620.cp2_dataset.oct_dataset` as table
            where day between 1 and 7 and month=10 and event_type = "view"
            group by user_session
      ),
      week_2nd as(
            select user_session, count(user_session) as counts, sum(price)
            from `cp2-project-350620.cp2_dataset.oct_dataset` as table
            where day between 8 and 14 and month=10 and event_type = "view"
            group by user_session
      ),
      week_3rd as(
            select user_session, count(user_session) as counts, sum(price)
            from `cp2-project-350620.cp2_dataset.oct_dataset` as table
            where day between 15 and 21 and month=10 and event_type = "view"
            group by user_session
      ),
      week_4th as(
            select user_session, count(user_session) as counts, sum(price)
            from `cp2-project-350620.cp2_dataset.oct_dataset` as table
            where day between 22 and 28 and month=10 and event_type = "view"
            group by user_session
            ),
      week_5th as(
            select user_session, count(user_session) as counts, sum(price)
            from `cp2-project-350620.cp2_dataset.oct_dataset` as table
            -- timezone을 +4로 바꾸어, 10월에서 11월로 넘어간 session이 발생함 -> 11월 1일 데이터도 함께 집계
            where day between 29 and 31 or month=11 and event_type = "view"
            group by user_session
            )
select 1 as week,
       -- subquery를 사용하여, user_session 중 1개만 카운팅 된 것들의 숫자를 셈
       (select sum(counts) from week_1st where counts = 1) as count,
        round((select sum(counts) from week_1st where counts = 1) / sum(counts), 3) as pct,
        sum(counts) as total
from week_1st

-- union all을 통해 각 주 데이터를 아래로 함께 나열
union all

select 2 as week,
        (select sum(counts) from week_2nd where counts = 1) as week_2,
        round((select sum(counts) from week_2nd where counts = 1) / sum(counts), 3) as week_2_pct,
        sum(counts) as total
from week_2nd

union all

select 3 as week,
       (select sum(counts) from week_3rd where counts = 1) as week_3,
        round((select sum(counts) from week_3rd where counts = 1) / sum(counts), 3) as week_3_pct,
        sum(counts) as total
from week_3rd

union all

select 4 as week,
       (select sum(counts) from week_4th where counts = 1) as week_4,
        round((select sum(counts) from week_4th where counts = 1) / sum(counts), 3) as week_4_pct,
        sum(counts) as total
from week_4th

union all

select 5 as week,
       (select sum(counts) from week_5th where counts = 1) as week_5,
        round((select sum(counts) from week_5th where counts = 1) / sum(counts), 3) as week_5_pct,
        sum(counts) as total
from week_5th

order by week
