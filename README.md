# 이커머스 데이터 분석 & 추천 모델링


## 프로젝트 배경 및 목적

- 배경
  - 비즈니스 레벨에서의 Action Plan 및 추천 시스템 도출 경험 부재
  - 비대면으로 프로젝트를 혼자 진행한 부트캠프 특성상, 협업의 필요성 증대
- 목적
  - E-Commerce 웹 로그 데이터를 바탕으로 매출 증대를 위한 비즈니스 인사이트 도출 및 유저행동 기반 추천 서비스 구축
  - 데이터에 기반한, 설득력 있는 비즈니스 솔루션 제안
        - 유저 행동에 따른 구매 이벤트 전환율 증가 목표


## 프로젝트 가설 및 분석방법
- 가설 1) cart에 넣으면 90%이상은 구매할 것이다.
  - 전체적으로는  80.17%로 확인됨. 해당 가설을 토대로 아래와 같은 가설로 접근

- 가설 2) 특정 요일, 시간에 니즈가 증가하는 카테고리가 있다
  - 요일별, 시간별,event_type 별로 구별하여 특정 요일, 시간대에 집중하여 view -> cart 비율을 높이는 action plan

    요일별 view→cart 전환율 분석해본 결과 금,토,일에 가장 많은 전환율을 볼 수 있었음.

## 사용 데이터셋
- [2019-Oct.csv.zip](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/775adf7d-bcca-4c24-b8ec-96c25f0e8af7/2019-Oct.csv.zip)
- event_time → 시간
  - UTC시간으로 표기 되었으며, 국가가 정해지지 않음 → GMT +4 시간대의 국가중 임의로 설정해서 진행
- event_type → 행동
- user_session → 유저행동의 세션 id

## 팀 구성 및 역할
### 공통 진행
- EDA, 도메인 학습, 추천 시스템 학습, 추천 시스템 모델링
### 전상택
- github 페이지 생성 및 관리, Jira를 통한 칸반보드 작성
- Action Plan 도출
- Bigquery DB 적재
- Ranking 기반의 추천 시스템 탐색 및 생성
### 전상언
- Notion 페이지 생성 및 정리
- Daily, Weekly 리포트 정리 및 공유
- 평점 기반의 추천 시스템 탐색 및 고안



## 사용한 모델
- implicit(ALS) - cart기준 유사도를 활용한 score로 랭킹화하여 모델링
- surprise(KNNBaseline,SVD,SVDpp) - event_type별 점수 반영으로 평점으로 반영하여 모델링

### 방법 적용이유
- CF - 소비자랑 평가 패턴이 비슷한 사람들을 한 집단으로 보고 그 집단에 속한 사람들의 취향을 활용하는 기술


### 베이스라인 모델 / 선정 이유?
- product_id 의 최빈값을 추천하는 것을 baseline 으로 선정했습니다.
  - 분류는 최빈값을 baseline으로 하는 것이 일반적이기 때문입니다.
- 각 user 들이 가장 많이 cart에 넣는 product을 추천하는 것을 기본으로 하여, 높은 성능의 추천 시스템을 생성하는 것을 우선적으로 생각했습니다.


### 개선 모델 / 선정 이유?
- CF - ALS / 데이터셋에 유저가 직접적으로 명시한 피드백이 없으므로 암시적 피드백의 특성을 잘 고려한 모델인 Alternating Least Squares(ALS) 모델을 활용하여 추천 시스템을 진행함.


# 모델링 결과 비교 및 최종 의견

베이스라인 
    accuracy: 0.06891920602160981

ALS Model
    Hit Rate : 0.87 / Precision : 0.1 / Recall : 0.83

모델링 결과 정밀도가 낮은데, 이커머스에서 추천 정밀도가 낮다면 이커머스 플랫폼에 대한 신뢰가 떨어질 수 있습니다. 추후 다른 달의 데이터에도 적용해본 후, 똑같이 정밀도가 저조하다면 향후 모델링을 개선해야 합니다.


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
https://brunch.co.kr/@ideawriter/59
https://techblog.woowahan.com/2536/
https://brunch.co.kr/@youup/4
https://www.cigro.io/post/%EC%9D%B4%EC%BB%A4%EB%A8%B8%EC%8A%A4-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B6%84%EC%84%9D-%EC%8B%9C-%ED%95%84%EC%88%98%EB%A1%9C-%EB%B4%90%EC%95%BC%ED%95%98%EB%8A%94-3%EA%B0%80%EC%A7%80
https://www.criteo.com/kr/blog/%EC%9D%B4%EC%BB%A4%EB%A8%B8%EC%8A%A4-%EB%A7%A4%EC%B6%9C%EC%9D%84-%ED%96%A5%EC%83%81%EC%8B%9C%ED%82%A4%EB%8A%94-4%EA%B0%80%EC%A7%80-%EB%B0%A9%EB%B2%95/
https://www.mobiinside.co.kr/2022/02/03/crm-marketing-3/

### 추천 시스템
https://buzzni.com/blog/37
https://davinci-ai.tistory.com/12
https://glanceyes.tistory.com/m/entry/%EC%B6%94%EC%B2%9C-%EC%8B%9C%EC%8A%A4%ED%85%9C%EC%9D%98-%ED%8F%89%EA%B0%80-%EB%B0%A9%EB%B2%95%EA%B3%BC-%EC%8B%A4%ED%97%98%EC%97%90%EC%84%9C%EC%9D%98-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B6%84%ED%95%A0-%EC%A0%84%EB%9E%B5
https://changyeon2.tistory.com/2
https://scvgoe.github.io/2017-02-01-%ED%98%91%EC%97%85-%ED%95%84%ED%84%B0%EB%A7%81-%EC%B6%94%EC%B2%9C-%EC%8B%9C%EC%8A%A4%ED%85%9C-(Collaborative-Filtering-Recommendation-System)/
https://alphalabs.medium.com/implicit-recommendation-systems-applied-to-e-commerce-1c9ed3f9ecca

ALS library
https://implicit.readthedocs.io/en/latest/als.html
https://github.com/benfred/implicit
https://github.com/AlphaLabsUY/recsys/blob/main/recommendation_system_instacart.ipynb
https://assaeunji.github.io/machine%20learning/2020-11-29-implicitfeedback/
https://minkithub.github.io/2020/06/24/implicit_ALS/
https://medium.com/radon-dev/als-implicit-collaborative-filtering-5ed653ba39fe

surprise library
https://surprise.readthedocs.io/en/stable/getting_started.html#load-dom-dataframe-py
https://techblog-history-younghunjo1.tistory.com/117?category=924148

