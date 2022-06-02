/** SQL 쿼리 설명
* category별 view, cart, purchase 전환될 때 걸리는 평균 시간을 확인하고자 했습니다.
* user_session, sub_cat_1 (중분류) 로 group by를 실시하였고,
* 카테고리별, event_type 별 평균 시간 간격을 추출하였습니다 (시간 간격 : 시간)
* 이를 통해, view -> cart로 넘어가는 시간이 최소 20시간이 걸린다는 것을 확인했습니다
**/

-- 카테고리별 view, cart, purchase 평균 전환 시간
with cat_split as (
            select table.*,
                  split(category_code, ".")[safe_ordinal(1)] as main_cat,
                  split(category_code, ".")[safe_ordinal(2)] as sub_cat_1,
                  split(category_code, ".")[safe_ordinal(3)] as sub_cat_2
            from `cp2-project-350620.cp2_dataset.oct_dataset` as table
      ),
      time_diff as (
            select user_id,
                  sub_cat_1,
                  product_id,
                  timestamp_seconds(min(unix_seconds(case when event_type="view" then event_time end))) as view_time,
                  timestamp_seconds(min(unix_seconds(case when event_type="cart" then event_time end))) as cart_time,
                  timestamp_seconds(min(unix_seconds(case when event_type="purchase" then event_time end))) as purchase_time,
                  TIMESTAMP_DIFF(timestamp_seconds(min(unix_seconds(case when event_type="cart" then event_time end))), 
                              timestamp_seconds(min(unix_seconds(case when event_type="view" then event_time end))),
                              second) as cart_view_diff,
                  TIMESTAMP_DIFF(timestamp_seconds(min(unix_seconds(case when event_type="purchase" then event_time end))), 
                              timestamp_seconds(min(unix_seconds(case when event_type="cart" then event_time end))),
                              second) as pur_cart_diff,
                  TIMESTAMP_DIFF(timestamp_seconds(min(unix_seconds(case when event_type="purchase" then event_time end))), 
                              timestamp_seconds(min(unix_seconds(case when event_type="view" then event_time end))),
                              second) as cvr_diff
            from cat_split
            group by user_id, sub_cat_1, product_id
            having cat_split.sub_cat_1 = "smartphone"
                        or cat_split.sub_cat_1 = "video"
                        or cat_split.sub_cat_1 = "kitchen"
                        or cat_split.sub_cat_1 = "notebook"
            order by user_id, sub_cat_1
                  )
-- select time_diff.sub_cat_1 as category,
--        (make_interval(second=>cast(avg(cart_view_diff)as int64))) as avg_cart_view,
--        (make_interval(second=>cast(avg(pur_cart_diff)as int64))) as avg_pur_cart,
--        (make_interval(second=>cast(avg(cvr_diff)as int64))) as avg_cvr_diff
-- from time_diff
-- group by time_diff.sub_cat_1

select time_diff.sub_cat_1 as category,
       extract(hour from (make_interval(second=>cast(avg(cart_view_diff)as int64)))) as avg_cart_view,
       extract(hour from (make_interval(second=>cast(avg(pur_cart_diff)as int64)))) as avg_pur_cart,
       extract(hour from (make_interval(second=>cast(avg(cvr_diff)as int64)))) as avg_cvr_diff
from time_diff
group by time_diff.sub_cat_1


union all

select "avg" as category,
       extract(hour from (make_interval(second=>cast(avg(cart_view_diff)as int64)))) as avg_cart_view,
       extract(hour from (make_interval(second=>cast(avg(pur_cart_diff)as int64)))) as avg_pur_cart,
       extract(hour from (make_interval(second=>cast(avg(cvr_diff)as int64)))) as avg_cvr_diff
from time_diff
order by category desc
