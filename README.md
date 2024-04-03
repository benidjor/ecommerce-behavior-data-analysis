# 이커머스 데이터 분석 & 추천 모델링


## 프로젝트 배경 및 목적

  - 비즈니스 측면을 고려한 데이터 분석 협업 및 Action Plan 도출 경험 부족
  - E-Commerce 웹 로그 데이터를 바탕으로 매출 증대를 위한 데이터 분석 및 비즈니스 인사이트 도출
  - `Python` `EDA` `SQL` 등을 활용하여 설득력 있는 비즈니스 솔루션 제안
  - 유저 행동에 따른 구매 이벤트 전환율 증가 목표

## 프로젝트 가설 및 분석 방법
### 가설
- 고객 행동끼리는 서로 밀접한 관계가 있다
- 특정 요일, 시간에 니즈가 증가하는 카테고리가 있다
- 카테고리, 제품 특성에 따라 매력을 느끼는 포인트가 다를 것이다

### 분석 방법
1. Data Collection [바로가기](https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store)
   - Kaggle 데이터셋 `BigQuery`에 적재
   - `Google Data Studio`를 통해 시각화 + 대시보드 생성
     
2. Data Preprocessing & EDA
   - 실제 데이터 출처인 이커머스 웹사이트 발견하여, 대량의 결측치 처리
   - 대분류, 중분류, 소분류로 카테고리 세분화
   - event_type, category_code, brand 별 고객 행동 시각화
   - 퍼널 분석, 코호트 분석 시행
     
3. Action Plan
   - 분석과 데이터의 대다수를 차지하는 고관여 제품의 특성을 토대로 Action Plan 수립
   - 매주마다 이탈하는 사용자를 위한 상품 추천 및 쿠폰, 할인 행사 유도 팝업 캠페인
   - 상품을 view 했지만 cart에 담지 않는 고객을 위해 캠페인 타겟 세분화 및 문자 발송 캠페인

4. Modeling (추천 시스템)
   - `implicit(ALS)` - cart기준 유사도를 활용한 score로 랭킹화하여 모델링
   - `ALS` 선정 이유
     - 이커머스 로그데이터의 특성상, 고객의 선호도 암시적 implicit (명시적 explicit으로 드러나지 않는다)
     - 고객의 행동 패턴을 바탕으로 자연스럽게 고객의 선호 유추하는 것이 중요
     - implicit 피드백의 특성을 잘 고려한 모델이 Alternating Least Squares ALS
   - `Hit Rate : 0.87  Precision : 0.1  Recall : 0.83`
     - 낮은 정밀도
     - 이커머스에서 추천 정밀도가 낮다면 플랫폼에 대한 신뢰 하락 우려
     - 추후 다른 달의 데이터에도 적용 후 똑같이 정밀도가 저조하다면 향후 모델링 개선 필요
  
## 프로젝트 회고 및 향후 개선 방안
  - 아쉬웠던 점
    - 생소했던 이커머스 도메인 지식과 데이터셋으로 인해, 비즈니스 측면에서 인사이트를 도출하는 데 어려움 봉착
    - 추천시스템 학습 및 모델링 구현에 시간을 많이 소비했지만 만족스럽지 못한 성능 도출

  - 향후 개선 계획
    - 추천 시스템에 대한 추가 학습을 통해, 모델 성능 향상 모색
    - 추천 시스템 사용 모델 : `implicit(ALS)`
    - 프로젝트를 통해 학습한 내용을 최대한 활용하여, 복습 및 정리도 함께 진행 예정


<!--
### 개선이 필요한 부분

#### 추천 시스템 모델링
- `implicit(ALS)` - cart기준 유사도를 활용한 score로 랭킹화하여 모델링

#### 방법 적용이유
- `CF` - 소비자랑 평가 패턴이 비슷한 사람들을 한 집단으로 보고 그 집단에 속한 사람들의 취향을 활용하는 기술
- `CF` 모델 중, 행렬 분해 `Matrix Factorization` 방식 사용
    - 행렬 분해 : 사용자와 아이템 데이터에 숨어있는 특징 잠재 차원 Latent Factor를 사용하여 표시
  
  - `ALS` 선정 이유
    - 이커머스 로그데이터의 특성상, 고객의 선호도 암시적 implicit (명시적 explicit으로 드러나지 않는다)
    - 고객의 행동 패턴을 바탕으로 자연스럽게 고객의 선호 유추하는 것이 중요
    - implicit 피드백의 특성을 잘 고려한 모델이 Alternating Least Squares ALS
  
  - Collaborative Filtering (CF) : user - item 간 상호 작용 데이터를 활용하는 방법
    - ex) 어떤 사람이 특정 아이템을 좋아했다면, 이런 아이템도 좋아할 것이다
    - CF 모델은 user - item 간의 상호 작용에 기반하기 때문에, 비슷한 고객들이 실제로 함께 소비하는 경향이 높은 아이템을 발견하여 추천 가능

#### 베이스라인 모델 / 선정 이유?
- product_id 의 최빈값을 추천하는 것을 baseline 으로 선정
- 각 user 들이 가장 많이 cart에 넣는 product을 추천하는 것을 기본으로 하여, 높은 성능의 추천 시스템을 생성하는 것을 우선적으로 진행


#### 개선 모델 / 선정 이유?
- `CF - ALS` / 데이터셋에 유저가 직접적으로 명시한 피드백이 없으므로 암시적 피드백의 특성을 잘 고려한 모델인 Alternating Least Squares(ALS) 모델을 활용하여 추천 시스템을 진행


#### 모델링 결과 비교

- Baseline
  - accuracy: 0.07

- ALS Model
  - Hit Rate : 0.87
  - Precision : 0.1
  - Recall : 0.83

- 모델링 결과 분석
  - 낮은 정밀도
    - 이커머스에서 추천 정밀도가 낮다면 플랫폼에 대한 신뢰 하락 우려
  - 추후 다른 달의 데이터에도 적용 후 똑같이 정밀도가 저조하다면 향후 모델링 개선 필요
-->
## Reference

### 이커머스 도메인 지식
- https://brunch.co.kr/@ideawriter/59
- https://techblog.woowahan.com/2536/
- https://brunch.co.kr/@youup/4
- https://www.cigro.io/post/%EC%9D%B4%EC%BB%A4%EB%A8%B8%EC%8A%A4-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B6%84%EC%84%9D-%EC%8B%9C-%ED%95%84%EC%88%98%EB%A1%9C-%EB%B4%90%EC%95%BC%ED%95%98%EB%8A%94-3%EA%B0%80%EC%A7%80
- https://www.criteo.com/kr/blog/%EC%9D%B4%EC%BB%A4%EB%A8%B8%EC%8A%A4-%EB%A7%A4%EC%B6%9C%EC%9D%84-%ED%96%A5%EC%83%81%EC%8B%9C%ED%82%A4%EB%8A%94-4%EA%B0%80%EC%A7%80-%EB%B0%A9%EB%B2%95/
https://www.mobiinside.co.kr/2022/02/03/crm-marketing-3/

### 추천 시스템
- https://buzzni.com/blog/37
-https://davinci-ai.tistory.com/12
- https://glanceyes.tistory.com/m/entry/%EC%B6%94%EC%B2%9C-%EC%8B%9C%EC%8A%A4%ED%85%9C%EC%9D%98-%ED%8F%89%EA%B0%80-%EB%B0%A9%EB%B2%95%EA%B3%BC-%EC%8B%A4%ED%97%98%EC%97%90%EC%84%9C%EC%9D%98-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B6%84%ED%95%A0-%EC%A0%84%EB%9E%B5
- https://changyeon2.tistory.com/2
- https://scvgoe.github.io/2017-02-01-%ED%98%91%EC%97%85-%ED%95%84%ED%84%B0%EB%A7%81-%EC%B6%94%EC%B2%9C-%EC%8B%9C%EC%8A%A4%ED%85%9C-(Collaborative-Filtering-Recommendation-System)/
- https://alphalabs.medium.com/implicit-recommendation-systems-applied-to-e-commerce-1c9ed3f9ecca

#### ALS library
- https://tech.kakao.com/2021/10/18/collaborative-filtering/
- https://implicit.readthedocs.io/en/latest/als.html
- https://github.com/benfred/implicit
- https://github.com/AlphaLabsUY/recsys/blob/main/recommendation_system_instacart.ipynb
- https://assaeunji.github.io/machine%20learning/2020-11-29-implicitfeedback/
- https://minkithub.github.io/2020/06/24/implicit_ALS/
- https://medium.com/radon-dev/als-implicit-collaborative-filtering-5ed653ba39fe

#### 평점 기반 library (surprise)
- https://surprise.readthedocs.io/en/stable/getting_started.html#load-dom-dataframe-py
- https://techblog-history-younghunjo1.tistory.com/117?category=924148

