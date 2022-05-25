/** SQL 쿼리 설명
* 요일별 카테고리들의 비중을 확인하고자 했습니다.
* day_name, sub_cat_1 (중분류) 로 group by를 실시하였고,
* cart_pct (view -> cart 전환율), view 숫자, purchase_pct (cart -> purchase 전환율), total_price (총 매출) 순서로 * 정렬하였습니다.
* 이를 통해, smartphone, video, kitchen, notebook (중분류 기준) 카테고리가 주말 (금, 토, 일)에 높은 cart_pct를 * * * 갖는 다는 것을 확인 했습니다. (기타 정렬 순서는 위의 정렬 기준 참조)
* 이에 따라, 금, 토, 일에 해당 카테고리 중심으로 맞춤형 액션플랜을 도출하자는 방향성을 확립했습니다
**/


with cat_split as (
            select table.*,
            -- 원본 category_code가 대분류.중분류.소분류의 형식으로 되어 있어, 각각 "." 단위로 분리 작업 실행
                  split(category_code, ".")[safe_ordinal(1)] as main_cat,
                  split(category_code, ".")[safe_ordinal(2)] as sub_cat_1,
                  split(category_code, ".")[safe_ordinal(3)] as sub_cat_2
            from `cp2-project-350620.cp2_dataset.oct_dataset` as table
            ),
      funnel_prac as (
            select day_name,
                  sub_cat_1,
                  count(case when event_type="view" then 1 end) as view, 
                  count(case when event_type="cart" then 1 end) as cart,
                  round(count(case when event_type="cart" then 1 end) 
                        / nullif(count(case when event_type="view" then 1 end), 0), 2) as cart_pct,
                  count(case when event_type="purchase" then 1 end) as purchase,       
                  round(count(case when event_type="purchase" then 1 end) 
                        / nullif(count(case when event_type="cart" then 1 end), 0), 2) as purchase_pct,
                  round(count(case when event_type="purchase" then 1 end) 
                        / nullif(count(case when event_type="view" then 1 end), 0), 2) as cvr,
                  round(sum(price)) as total_price,
                  -- 전체 price 더한 값 : 12323880556.039015
                  -- 요일별 합산 금액과 요일에 따른 카테고리 금액의 비율을 알기위해 서브쿼리로 pct_day 사용
                  round(sum(price) / (select sum(price) from cat_split where day_name = cs.day_name), 2) as pct_day,
                  -- (select sum(price) from cat_split where day_name = cs.day_name)
                  -- subquery는 밖에 그룹바이된 day_name, sub_cat_1과 아무 연관이 없이 혼자 도는 것이라서 where 절에 넣고 조건 거는 것이 맞다
            from cat_split as cs
            group by day_name, sub_cat_1
            order by cart_pct desc, view desc, purchase_pct desc, pct_day desc
      )
select *
from funnel_prac
where pct_day >= 0.05