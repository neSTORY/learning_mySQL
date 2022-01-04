USE PRACTICE;

/* 회원 프로파일 분석을 위한 데이터 마트 */
CREATE TABLE CUSTOMER_PROFILE AS
SELECT A.*,
			 DATE_FORMAT(JOIN_DATE, "%Y-%m") AS 가입년월,
       2021 - YEAR(BIRTHDAY) + 1 AS 나이,
       CASE WHEN 2021 - YEAR(BIRTHDAY) + 1 < 20 THEN "10대 이하"
						WHEN 2021 - YEAR(BIRTHDAY) + 1 < 30 THEN "20대"
            WHEN 2021 - YEAR(BIRTHDAY) + 1 < 40 THEN "30대"
            WHEN 2021 - YEAR(BIRTHDAY) + 1 < 50 THEN "40대"
            ELSE "50대 이상" END AS 연령대,
            
			 CASE WHEN B.MEM_NO IS NOT NULL THEN "구매"
						ELSE "미구매" END AS 구매여부
	FROM CUSTOMER AS A
  LEFT
  JOIN (
				SELECT DISTINCT MEM_NO
					FROM SALES
			 ) AS B
		ON A.MEM_NO = B.MEM_NO;
    
-- 확인
SELECT * FROM CUSTOMER_PROFILE;

-- 1. 가입년월별 회원수
SELECT 가입년월, COUNT(MEM_NO) AS 회원수
	FROM CUSTOMER_PROFILE
 GROUP
		BY 가입년월;

-- 2. 성별 평균 연령 / 성별 및 연령대별 회원수
-- 성별 평균 연령
SELECT *, AVG(나이) AS 성별_평균_연령
	FROM CUSTOMER_PROFILE
 GROUP
		BY GENDER;
    
-- 성별 및 연령대별 회원수
SELECT GENDER, 연령대, COUNT(MEM_NO) AS 회원수
	FROM CUSTOMER_PROFILE
 GROUP
		BY GENDER, 연령대
 ORDER
		BY GENDER, 연령대 ASC;
    
-- 3. 성별 및 연령대별 회원수(+ 구매여부)
SELECT GENDER AS 성별, 연령대, 구매여부, COUNT(MEM_NO) AS 회원수
	FROM CUSTOMER_PROFILE
 GROUP
		BY GENDER, 연령대, 구매여부
 ORDER
		BY 구매여부, GENDER, 연령대 ASC;
    
    
/* ####### RFM ######## */
CREATE TABLE RFM AS
SELECT A.*, B.구매금액, B.구매횟수
	FROM CUSTOMER AS A
  LEFT
  JOIN (
				SELECT A.MEM_NO,
							 SUM(A.SALES_QTY * B.PRICE) AS 구매금액, -- Momentary : 구매금액
               COUNT(A.ORDER_NO) AS 구매횟수 -- FREQUENCY : 구매 빈도
					FROM SALES AS A
          LEFT
          JOIN PRODUCT AS B
						ON A.PRODUCT_CODE = B.PRODUCT_CODE
				 WHERE YEAR(A.ORDER_DATE) = "2020" -- Recency : 최근성
         GROUP
						BY A.MEM_NO
				) AS B
		ON A.MEM_NO = B.MEM_NO;
    
-- 확인
SELECT * FROM RFM;

-- 1. RFM 세분화별 회원수

SELECT *,
			 CASE WHEN 구매금액 > 5000000 THEN "VIP"
            WHEN 구매금액 > 1000000 OR 구매횟수 > 3 THEN "우수회원"
            WHEN 구매금액 > 		  0 THEN "일반회원"
            ELSE "잠재회원" END AS 회원세분화
	FROM RFM;
  
SELECT 회원세분화, COUNT(MEM_NO) AS 회원수
	FROM (
				SELECT *,
							 CASE WHEN 구매금액 > 5000000 THEN "VIP"
										WHEN 구매금액 > 1000000 OR 구매횟수 > 3 THEN "우수회원"
										WHEN 구매금액 > 		  0 THEN "일반회원"
										ELSE "잠재회원" END AS 회원세분화
					FROM RFM
				) AS A
 GROUP
		BY 회원세분화
 ORDER
		BY 회원수 ASC;
    
-- 2. RFM 세분화별 매출액
SELECT 회원세분화, SUM(구매금액) AS 구매금액
  FROM (
				SELECT *,
							 CASE WHEN 구매금액 > 5000000 THEN "VIP"
										WHEN 구매금액 > 1000000 OR 구매횟수 > 3 THEN "우수회원"
										WHEN 구매금액 > 		  0 THEN "일반회원"
										ELSE "잠재회원" END AS 회원세분화
					FROM RFM
          
			 ) AS A
 GROUP
		BY 회원세분화
 ORDER
		BY 구매금액 DESC;

-- 3. RFM 세분화별 인당 구매금액
SELECT 회원세분화, SUM(구매금액)/COUNT(MEM_NO) AS 인당_구매금액
  FROM (
				SELECT *,
							 CASE WHEN 구매금액 > 5000000 THEN "VIP"
										WHEN 구매금액 > 1000000 OR 구매횟수 > 3 THEN "우수회원"
										WHEN 구매금액 > 		  0 THEN "일반회원"
										ELSE "잠재회원" END AS 회원세분화
					FROM RFM
          
			 ) AS A
 GROUP
		BY 회원세분화
 ORDER
		BY 구매금액 DESC;
    
    















