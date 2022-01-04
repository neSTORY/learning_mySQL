USE PRACTICE;

CREATE TABLE RE_PUR_CYCLE AS
SELECT *,
			 CASE WHEN DATE_ADD(최초구매일자, INTERVAL + 1 DAY) <= 최근구매일자 THEN "Y"
						ELSE "N" END AS 재구매여부,
			 DATEDIFF(최근구매일자, 최초구매일자) AS 구매간격,
       CASE WHEN 구매횟수 -1 = 0 OR DATEDIFF(최근구매일자, 최초구매일자) = 0 THEN 0
						ELSE DATEDIFF(최근구매일자, 최초구매일자) / (구매횟수 -1) END AS 구매주기
	FROM (
				SELECT MEM_NO,
							 MIN(ORDER_DATE) AS 최초구매일자,
               MAX(ORDER_DATE) AS 최근구매일자,
               COUNT(ORDER_NO) AS 구매횟수
					FROM SALES
				 WHERE MEM_NO <> "9999999" -- 비회원 제외
         GROUP
						BY MEM_NO
			 ) AS A;
       
			
-- 확인
SELECT * FROM RE_PUR_CYCLE;

-- 회원(1000021)의 구매정보
-- 최초구매일자: 2019-05-07 / 최근 구매일자 : 2019-05-21 / 구매횟수 : 3
SELECT *
	FROM RE_PUR_CYCLE
 WHERE MEM_NO = "1000021";
 
-- 1. 재구매 회원수 비중(%)
SELECT COUNT(DISTINCT MEM_NO) AS 구매회원수,
			 COUNT(DISTINCT CASE WHEN 재구매여부 = "Y" THEN MEM_NO END) AS 재구매회원수
	FROM RE_PUR_CYCLE;
 
-- 2. 평균 구매주기 및 구매주기 구간별 회원수
SELECT *,
			 CASE WHEN 구매주기 <= 7 THEN "7일 이내"
						WHEN 구매주기 <= 14 THEN "14일 이내"
            WHEN 구매주기 <= 21 THEN "21일 이내"
            WHEN 구매주기 <= 28 THEN "28일 이내"
            ELSE "29일 이후" END AS 구매주기_구간
	FROM RE_PUR_CYCLE
 WHERE 구매주기 > 0;
 
SELECT 구매주기_구간, COUNT(MEM_NO) AS 회원수
	FROM (
				SELECT *,
							 CASE WHEN 구매주기 <= 7 THEN "7일 이내"
										WHEN 구매주기 <= 14 THEN "14일 이내"
										WHEN 구매주기 <= 21 THEN "21일 이내"
										WHEN 구매주기 <= 28 THEN "28일 이내"
										ELSE "29일 이후" END AS 구매주기_구간
					FROM RE_PUR_CYCLE
			 ) AS A
 GROUP
		BY 구매주기_구간;
    
/* 제품 성장률 분석 */
CREATE TABLE PRODUCT_GROWTH AS
SELECT A.MEM_NO,
			 B.CATEGORY,
       B.BRAND,
       A.SALES_QTY * B.PRICE AS 구매금액,
       A.ORDER_DATE,
       CASE WHEN DATE_FORMAT(ORDER_DATE, "%Y-%m") BETWEEN "2020-01" AND "2020-03" THEN "1분기"
						WHEN DATE_FORMAT(ORDER_DATE, "%Y-%m") BETWEEN "2020-04" AND "2020-06" THEN "2분기"
            WHEN DATE_FORMAT(ORDER_DATE, "%Y-%m") BETWEEN "2020-07" AND "2020-09" THEN "3분기"
            ELSE "4분기" END AS 분기
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE
 WHERE DATE_FORMAT(ORDER_DATE, "%Y-%m") BETWEEN "2020-01" AND "2020-06";
 
SELECT * FROM PRODUCT_GROWTH;

-- 1. 카테고리별 구매금액 성장률(2020년 1분기 -> 2020년 2분기
SELECT *,
			 2분기_구매금액 / 1분기_구매금액 -1 AS 성장률
	FROM (
				SELECT CATEGORY,
							 SUM(CASE WHEN 분기 = "1분기" THEN 구매금액 END) AS 1분기_구매금액,
               SUM(CASE WHEN 분기 = "2분기" THEN 구매금액 END) AS 2분기_구매금액
				  FROM PRODUCT_GROWTH
				 GROUP
						BY CATEGORY
			 ) AS A
 ORDER
		BY 4 DESC; -- 4 : 4번째 컬럼
    
-- 2. BEAUTY 카테고리 중, 브랜드 별 구매지표
SELECT BRAND,
			 COUNT(DISTINCT MEM_NO) AS 구매자수,
       SUM(구매금액) AS 구매금액_합계,
       SUM(구매금액) / COUNT(DISTINCT MEM_NO) AS 인당_구매금액
	FROM PRODUCT_GROWTH
 WHERE CATEGORY = "BEAUTY"
 GROUP
		BY BRAND
 ORDER
		BY 4 DESC;


       
       
       
       
       
       
       
       
       
	