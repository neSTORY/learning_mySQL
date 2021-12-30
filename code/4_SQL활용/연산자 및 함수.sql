USE PRACTICE;

/* ##### 비교 연산자 ##### */

-- = : 같음
SELECT * FROM CUSTOMER
 WHERE YEAR(JOIN_DATE) = 2019;
 
-- <> : 같지 않음 (!=)
SELECT * FROM CUSTOMER
 WHERE YEAR(JOIN_DATE) <> 2019;
 
-- >= : 크거나 같음
SELECT * FROM CUSTOMER
 WHERE YEAR(JOIN_DATE) >= 2020;
 
-- > : ~보다 큼
SELECT * FROM CUSTOMER
 WHERE YEAR(JOIN_DATE) > 2019;
 
/* ##### 논리 연산자 ##### */
-- AND : 앞, 뒤 조건 모두 만족
SELECT * FROM CUSTOMER
 WHERE GENDER = "MAN" AND ADDR = "GYEONGGI";
 
-- NOT : 뒤에 오는 조건과 반대
SELECT * FROM CUSTOMER
 WHERE NOT GENDER = "MAN";
 
-- OR : 둘 중 하나만 만족하면 출력
SELECT * FROM CUSTOMER
 WHERE GENDER = "MAN" OR ADDR = "GYEONGGI";
 
/* ##### 특수 연산자 ##### */
-- BETWEEN A AND B : A와 B의 값 사이
SELECT *
	FROM CUSTOMER
 WHERE YEAR(BIRTHDAY) BETWEEN 2010 AND 2011;
 
-- NOT BETWEEN A AND B : A와 B의 값 사이가 아님
SELECT *
	FROM CUSTOMER
 WHERE YEAR(BIRTHDAY) NOT BETWEEN 1950 AND 2020;
 
-- IN (LIST) : 리스트 값 (양쪽 값 모두 포함)
SELECT * FROM CUSTOMER
 WHERE YEAR(BIRTHDAY) IN (2010, 2011);
 
-- NOT IN (LIST) : 리스트 값이 아님
SELECT * FROM CUSTOMER
 WHERE YEAR(BIRTHDAY) NOT IN (2010, 2011);
 
/* ##### LIKE "비교문자열" ##### */
SELECT * FROM CUSTOMER
 WHERE ADDR LIKE "D%"; -- "D"로 시작하는

SELECT * FROM CUSTOMER
 WHERE ADDR LIKE "%U"; -- "U"로 끝나는
 
SELECT * FROM CUSTOMER
 WHERE ADDR LIKE "%EO%"; -- "EO"를 포함하는

/* ##### NOT LIKE ##### */
SELECT * FROM CUSTOMER
 WHERE ADDR NOT LIKE "%EO%"; -- "EO"를 제외한

/* ##### IS NULL : NULL 값인 것들 출력 ##### */
SELECT *
	FROM CUSTOMER AS A
  LEFT
  JOIN SALES AS B
    ON A.MEM_NO = B.MEM_NO
 WHERE B.MEM_NO IS NULL;
 
-- 확인
SELECT * FROM SALES
 WHERE MEM_NO = "1000001";
 
/* IS NOT NULL: NULL 값이 아닌 것들 출력 */
SELECT *
	FROM CUSTOMER AS A
  LEFT
  JOIN SALES AS B
		ON A.MEM_NO = B.MEM_NO
 WHERE B.MEM_NO IS NOT NULL;
 
/* ##### 산술 연산자 ##### */
SELECT *,
			 A.SALES_QTY * PRICE AS 결제금액 # 곱하기를 사용하여 판매수량*가격으로 결제금액을 구해줌
  FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE;
    
 /* ############## 집합연산자 ################# */
 -- UNION : 2개 이상 테이블의 중복된 행들을 제거하여 집합
 -- UNION ALL : 2개 이상 테이블의 중복된 행들을 제거 없이 집합
 -- 단, 열의 개수와 데이터 타입이 일치해야 함
 
CREATE TEMPORARY TABLE SALES_2019
SELECT *
	FROM SALES
 WHERE YEAR(ORDER_DATE) = "2019";
 
-- 조회
SELECT * FROM SALES_2019; # 1235행 -> 작업도구에서 DON'T LIMIT로 바꿔야 행의 개수가 제한없이 나온다
SELECT * FROM SALES; # 3115행
    
-- UNINON
SELECT *
	FROM SALES_2019
 UNION
SELECT *
	FROM SALES; # 3115행 => 중복된 행은 제거되어 출력

-- UNION ALL
SELECT *
	FROM SALES_2019
 UNION
	 ALL
SELECT *
	FROM SALES; # 4350행 => 1235 + 3115
    
    
/* ############## 단일 행 함수 ################ */

/* 숫자형 함수 */
-- ABS(숫자) : 절대값 리턴
SELECT ABS(-200);

-- ROUND(숫자, N) : N번째 자리수에서 반올림
SELECT ROUND(2.16, 1);

-- SQRT(숫자) : 제곱근 수 리턴
SELECT SQRT(9);

/* 문자형 함수 */
-- LOWER(문자) / UPPER(문자) -> 소문자/대문자
SELECT LOWER("SQL");
SELECT UPPER("sql");

-- LEFT(문자, N) / RIGHT(문자, N) -> 왼/오른쪽 부터 N만큼 리턴
SELECT LEFT("MY_SQL", 3);
SELECT RIGHT("MY_SQL", 3);

-- LENGTH(문자) : 해당 문자열의 길이를 리턴
SELECT LENGTH("MYSQL");

/* 날짜형 함수 */
-- YEAR/ MONTH/ DAY(날짜) : 연/월/일 리턴
SELECT YEAR("2021-12-30");
SELECT MONTH("2021-12-30");
SELECT DAY("2021-12-30");
    
-- DATE_ADD(날짜, INTERVAL) : INTERVAL만큼 더한 값 반환
SELECT DATE_ADD("2021-12-30", INTERVAL +30 DAY);
SELECT DATE_ADD("2021-12-30", INTERVAL -18 DAY);

-- DATEDIFF(날짜A, 날짜B) : 날짜A- 날짜B 일수 반환
SELECT DATEDIFF("2021-12-30", "2021-12-8");

-- DATE_FORMAT(날짜, 형식) : 날짜형식으로 변환
SELECT DATE_FORMAT("2021-12-31", "%M-%D-%Y"); # sql에서 이때는 대/소문자를 구분함.. 대문자는 월이 문자열, 일도 st가 붙어서 나옴
SELECT DATE_FORMAT("2021-12-31", "%m-%d-%y");

-- CAST(형식A, 형식B) : 형식A를 형식B로 리턴
SELECT CAST("2021-12-30" AS DATETIME);
SELECT CAST("2021-12-30 12:00:00" AS DATE);

/* 일반함수 */
-- IFNULL(A, B) : A가 NULL이면 B를 반환, 아니면 A를 반환
SELECT IFNULL(NULL, 0);
SELECT IFNULL("THIS IS NOT NULL!!", 0);

/*
CASE WHEN [조건1] THEN [반환1]
		 WHEN [조건2] THEN [반환2]
     ELSE [나머지] END
=> 여러 조건별로 반환값 지정
*/
SELECT *,
			 CASE WHEN GENDER = "MAN" THEN "남성"
						ELSE "여성" END AS 성별 -- 조건 끝날 때 END 명시해줘야 함!
	FROM CUSTOMER;
  
-- 함수 중첩 사용
SELECT *,
			 YEAR(JOIN_DATE) AS 가입연도,
       LENGTH(YEAR(JOIN_DATE)) AS 가입연도_문자길이
  FROM CUSTOMER;
  
/* ############ 복수 행 함수 ############# */
-- 복수 행 함수 : 여러 행들이 하나의 결과값으로 반환됨
/* 집계 함수 */
SELECT COUNT(ORDER_NO) AS 구매횟수, -- 행의 수
			 COUNT(DISTINCT MEM_NO) AS 구매자수, -- 중복제거된 행의 수
       SUM(SALES_QTY) AS 구매수량, -- 합계
       AVG(SALES_QTY) AS 평균구매수량, -- 평균
       MAX(CAST(ORDER_DATE AS DATE)) AS 최근구매일자, -- 최대
       MIN(ORDER_DATE) AS 최초구매일자 -- 최소
FROM SALES;
-- DISTINCT : 중복 제거

/* 그룹 함수 */
-- WITH ROLLUP : GROUP BY 열들을 오른쪽에서 왼쪽으로 그룹 (소계, 합계)
SELECT YEAR(JOIN_DATE) AS 가입연도,
			 ADDR,
       COUNT(MEM_NO) AS 회원수
  FROM CUSTOMER
 GROUP
		BY YEAR(JOIN_DATE),
			 ADDR
	WITH ROLLUP;
  
/* 집계 함수 + GROUP BY */
SELECT MEM_NO,
			 SUM(SALES_QTY) AS 구매수량
	FROM SALES
 GROUP
		BY MEM_NO;
-- 확인
SELECT *
	FROM SALES
 WHERE MEM_NO = "1000970"; -- 구매수량이 5개임을 확인
 
/* ########## 윈도우 함수 ############# */
-- 윈도우 함수는 행과 행간의 관계를 정의하여 결과 값을 반환해줌
-- ex) ORDER_DATE의 순위, SALES_QTY의 누적 집계를 구해줄 수 있음
-- 윈도우 함수는 ORDER BY로 행과 행간의 순서를 정하며 PARTITION BY로 그룹화가 가능

/* 순위 함수 */
-- ROW_NUMBER : 동일한 값이라도 고유한 순위 반환 (1,2,3,4,5... )
-- RANK : 동일한 값이면 동일한 순위 반환 (1,2,3,3,5... )
-- DENSE_RANK : 동일한 값이면 동일한 순위 반환(+ 하나의 동수로 취급) EX) (1,2,3,3,4... )

SELECT ORDER_DATE,
			 ROW_NUMBER() OVER (ORDER BY ORDER_DATE ASC) AS 고유한_순위_반환,
       RANK() 			OVER (ORDER BY ORDER_DATE ASC) AS 동일한_순위_반환,
       DENSE_RANK() OVER (ORDER BY ORDER_DATE ASC) AS 동일한_순위_반환_동수
	FROM SALES;
  
-- 순위 함수 + PARTITION BY : 그룹별 순위
SELECT MEM_NO,
			 ORDER_DATE,
       ROW_NUMBER() OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 고유한_순위_반환,
       RANK() 			OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 동일한_순위_반환,
       DENSE_RANK() OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 동일한_순위_반환_동수
	FROM SALES;
  
/* 집계 함수(누적) */
SELECT ORDER_DATE,
			 SALES_QTY,
       "-" AS 구분,
       COUNT(ORDER_NO) OVER (ORDER BY ORDER_DATE ASC) AS 누적_구매횟수,
       SUM(SALES_QTY)  OVER (ORDER BY ORDER_DATE ASC) AS 누적_구매수량,
       AVG(SALES_QTY)  OVER (ORDER BY ORDER_DATE ASC) AS 누적_평균구매수량,
       MAX(SALES_QTY)  OVER (ORDER BY ORDER_DATE ASC) AS 누적_가장높은구매수량,
       MIN(SALES_QTY)  OVER (ORDER BY ORDER_DATE ASC) AS 누적_가장낮은구매수량
	FROM SALES;
  
  /* 집계 함수 + PARTITION BY : 그룹별 집계 함수(누적) */
  SELECT MEM_NO,
				 ORDER_DATE,
				 SALES_QTY,
				 "-" AS 구분,
				 COUNT(ORDER_NO) OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_구매횟수,
				 SUM(SALES_QTY)  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_구매수량,
				 AVG(SALES_QTY)  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_평균구매수량,
				 MAX(SALES_QTY)  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_가장높은구매수량,
				 MIN(SALES_QTY)  OVER (PARTITION BY MEM_NO ORDER BY ORDER_DATE ASC) AS 누적_가장낮은구매수량
	FROM SALES;