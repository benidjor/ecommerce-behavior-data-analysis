# 이커머스 데이터 분석 & 추천 모델링


## 프로젝트 배경 및 목적

- 배경
  - 비즈니스 레벨에서의 Action Plan 및 추천 시스템 도출 경험 부재
  - 비대면으로 프로젝트를 혼자 진행한 부트캠프 특성상, 협업의 필요성 증대

- 목적
  - E-Commerce 웹 로그 데이터를 바탕으로 매출 증대를 위한 비즈니스 인사이트 도출 및 유저행동 기반 추천 서비스 구축
  - 데이터에 기반한, 설득력 있는 비즈니스 솔루션 제안
    - 유저 행동에 따른 구매 이벤트 전환율 증가 목표

- 프로젝트 선정 이유
  - e-commerce 시장은 방대한 로그 데이터를 기반으로 하기 때문에, 고객 분석 및 추천 시스템 학습에 적합
  - EDA, 시각화, SQL 등을 활용하여 다양한 방법으로 데이터 분석 및 인사이트 도출
  - 비즈니스 레벨에 입각하여, 데이터 분석가로서 유효한 솔루션과 액션 플랜 수립

## 프로젝트 가설 및 분석방법
- 고객 행동끼리는 서로 밀접한 관계가 있다
  - cart에 넣으면 90% 이상은 구매할 것이다
- 특정 요일, 시간에 니즈가 증가하는 카테고리가 있다
- 카테고리, 제품 특성에 따라 매력을 느끼는 포인트가 다를 것이다

## 사용 데이터셋
- https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store
  
- event_time → 시간
  - UTC시간으로 표기 되었으며, 국가가 정해지지 않음 → GMT +4 시간대의 국가중 임의로 설정해서 진행
- event_type → 행동
- user_session → 유저행동의 세션 id

## 사용한 모델
- implicit(ALS) - cart기준 유사도를 활용한 score로 랭킹화하여 모델링
- surprise(KNNBaseline,SVD,SVDpp) - event_type별 점수 반영으로 평점으로 반영하여 모델링

### 방법 적용이유
- CF - 소비자랑 평가 패턴이 비슷한 사람들을 한 집단으로 보고 그 집단에 속한 사람들의 취향을 활용하는 기술
- CF 모델 중, 행렬 분해 Matrix Factorization 방식 사용
    - 행렬 분해 : 사용자와 아이템 데이터에 숨어있는 특징 잠재 차원 Latent Factor를 사용하여 표시
  
  - ALS 선정 이유
    - 이커머스 로그데이터의 특성상, 고객의 선호도 암시적 implicit (명시적 explicit으로 드러나지 않는다)
    - 고객의 행동 패턴을 바탕으로 자연스럽게 고객의 선호 유추하는 것이 중요
    - implicit 피드백의 특성을 잘 고려한 모델이 Alternating Least Squares ALS
  
  - Collaborative Filtering (CF) : user - item 간 상호 작용 데이터를 활용하는 방법
    - ex) 어떤 사람이 특정 아이템을 좋아했다면, 이런 아이템도 좋아할 것이다
    - CF 모델은 user - item 간의 상호 작용에 기반하기 때문에, 비슷한 고객들이 실제로 함께 소비하는 경향이 높은 아이템을 발견하여 추천 가능

### 베이스라인 모델 / 선정 이유?
- product_id 의 최빈값을 추천하는 것을 baseline 으로 선정
  - 분류는 최빈값을 baseline으로 하는 것이 일반적이기 때문
- 각 user 들이 가장 많이 cart에 넣는 product을 추천하는 것을 기본으로 하여, 높은 성능의 추천 시스템을 생성하는 것을 우선적으로 진행


### 개선 모델 / 선정 이유?
- CF - ALS / 데이터셋에 유저가 직접적으로 명시한 피드백이 없으므로 암시적 피드백의 특성을 잘 고려한 모델인 Alternating Least Squares(ALS) 모델을 활용하여 추천 시스템을 진행


# 모델링 결과 비교 및 최종 의견

- Baseline
  - accuracy: 0.06891920602160981

- ALS Model
  - Hit Rate : 0.87
  - Precision : 0.1
  - Recall : 0.83

- 모델링 결과 분석
  - 낮은 정밀도
    - 이커머스에서 추천 정밀도가 낮다면 플랫폼에 대한 신뢰 하락 우려
  - 추후 다른 달의 데이터에도 적용 후 똑같이 정밀도가 저조하다면 향후 모델링 개선 필요

### 프로젝트 회고

- 아쉬웠던 점
  - 생소했던 이커머스 도메인 지식과 데이터셋 EDA로 인해, 비즈니스 측면에서 인사이트를 도출하는 데 어려움을 겪었습니다.
  - 프로젝트 일정에 따라 계획대로 진행하려 했으나, 예상하지 못했던 문제(기술 부족 등) 봉착하였습니다.
  - 협업으로 진행해본 프로젝트는 서로 처음이라 진행 방향성 구성부터 쉽지 않았습니다.
  - 추천시스템 학습 및 모델링 구현에 시간을 많이 소비하여, 추가적인 개선 미흡했습니다.

- 향후 개선 계획
  - 작업 초기 오래 걸리던 작업들이 익숙해지면서 속도가 빨라졌음. 아직 기술적으로 부족한 부분이 남아 있지만 앞의 경험을 살려 추후 비슷한 문제에 직면하면 빠르게 대처할 수 있을 것입니다.
  - 협업 환경을 구축하여 서로 업무 규칙을 만들어 커뮤니케이션을 원활하게 함.
  - 짧은 시간이었지만 서로 프로젝트 진행 방식이 다르다 보니 각자 몰랐던 부분을 배워가는 시간이었습니다.
  - 향후 모델 성능을 향상 및 다양한 추천 시스템 모델링 적용 방향 모색
  - 프로젝트를 통해 학습한 내용을 최대한 활용하여, 복습 및 정리도 함께 진행 예정


# Reference

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

