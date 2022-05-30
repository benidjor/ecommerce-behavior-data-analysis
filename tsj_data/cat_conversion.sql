/** SQL 쿼리 설명
* view 고객의 cart 전환 비율을 확인하고자 했습니다.
* user_session, sub_cat_1 (중분류) 로 group by를 실시하였고,
* view_cnt (view count), cart_cnt, cart_pct (view -> cart 전환율), purchase_cnt, purchase_pct (cart -> purchase 전환율), cvr 순서로 정렬했습니다
* 이를 통해, view -> cart로 넘어가는 비율이 3.9 % 밖에 되지 않는 다는 것을 확인했습니다
**/

-- view 고객의 cart 전환 비율
with cat_split as (
            select table.*,
                  split(category_code, ".")[safe_ordinal(1)] as main_cat,
                  split(category_code, ".")[safe_ordinal(2)] as sub_cat_1,
                  split(category_code, ".")[safe_ordinal(3)] as sub_cat_2
            from `cp2-project-350620.cp2_dataset.oct_dataset` as table
      ),
      cnt_prod_id as (
            select  user_id,
                    product_id,
                    sub_cat_1,
                    count(case when event_type="view" then 1 end) as view,
                    count(case when event_type="cart" then 1 end) as cart,
                    count(case when event_type="purchase" then 1 end) as purchase
            from cat_split
            group by user_id, product_id, sub_cat_1
            having cat_split.sub_cat_1 = "smartphone"
                  or cat_split.sub_cat_1 = "video"
                  or cat_split.sub_cat_1 = "kitchen"
                  or cat_split.sub_cat_1 = "notebook"
            order by user_id, product_id, sub_cat_1
      )
select sum(view) as view_cnt,
       sum(cart) as cart_cnt,
       round(sum(cart) / sum(view), 3) as cart_pct,
       sum(purchase) as purchase_cnt,
       round(sum(purchase) / sum(cart), 3) as cart_pct,
       round(sum(purchase) / sum(view), 3) as cvr
from cnt_prod_id