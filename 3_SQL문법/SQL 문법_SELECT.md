# SQL 문법



## 데이터 조회(SELECT)

SELECT는 데이터 조작어(DML)이며, 데이터 분석에서 가장 많이 사용되는 명령어입니다.



데이터 조회는 여러 절들과 함께 사용되어, 분석에 필요한 데이터를 조회합니다.

- 절 : FROM, WHERE, GROUP BY, HAVING, ORDER BY

  ![image-20211230000506429](C:/Users/NaEunSu/AppData/Roaming/Typora/typora-user-images/image-20211230000506429.png)

- FROM -> WHERE -> GROUP BY 순으로 실행된다.(FROM -> GROUP BY도 가능)
- GROUP BY : 집계함수와 주로 사용되는 명령어
  - 여러 열별로 그룹화가 가능
  - <u>GROUP BY에 있는 열들을 SELECT에도 작성해야</u> 원하는 분석 결과를 확인할 수 있음

