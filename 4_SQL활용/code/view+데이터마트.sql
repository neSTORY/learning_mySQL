USE PRACTICE;

/* ################ view ################ */
-- 주문(SALES) 테이블 기준, 상품(PRODUCT) 테이블 LEFT JOIN 결합

SELECT A.*, A.SALES_QTY * B.PRICE AS 결제금액
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE;
    
-- VIEW 테이블 생성
CREATE VIEW SALES_PRODUCT AS
SELECT A.*, A.SALES_QTY * B.PRICE AS 결제금액
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE;

-- VIEW 실행
SELECT *
	FROM SALES_PRODUCT;
  
-- VIEW 수정
ALTER VIEW SALES_PRODUCT AS
SELECT A.*, A.SALES_QTY * B.PRICE * 1.1 AS 결재금액_수수료포함
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE;

-- VIEW 실행
SELECT *
	FROM SALES_PRODUCT;
  
/* VIEW 삭제 */
DROP VIEW SALES_PRODCUT;

-- VIEW 특징(중복되는 열은 저장 안됨!)
CREATE VIEW SALES_PRODCUT AS
SELECT * # 중복되는 열 발생(error code 1060. product_code 중복)
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE;

/* ####### PROCEDURE ######### */
-- 매개변수를 활용해, 사용자가 정의한 작업을 저장함. 실행하지는 않는다.
-- 매개변수는 IN, OUT, INOUT 3가지로 나뉜다.
-- 함수정의랑 비슷한 개념?

/* ### IN 매개변수 ### */
DELIMITER //
CREATE PROCEDURE CST_GEN_ADDR_IN( IN INPUT_A VARCHAR(20), INPUT_B VARCHAR(20) )
BEGIN # PROCEDURE의 시작과 끝을 표기
		SELECT *
			FROM CUSTOMER
		 WHERE GENDER = INPUT_A
		   AND ADDR = INPUT_B;
END //
DELIMITER ;

-- DELIMITER : 여러 명령어들을 하나로 묶어줄 때 사용

/* PROCEDURE 실행 */
CALL CST_GEN_ADDR_IN("MAN", "SEOUL");

CALL CST_GEN_ADDR_IN("WOMEN", "INCHEON");

/* PROCEDURE 삭제 */
DROP PROCEDURE CST_GEN_ADDR_IN;

/* ### OUT 매개변수 ### */

DELIMITER //
CREATE PROCEDURE CST_GEN_ADDR_IN_CNT_MEM_OUT( IN INPUT_A VARCHAR(20), INPUT_B VARCHAR(20), OUT CNT_MEM INT )
BEGIN
		SELECT COUNT(MEM_NO)
			INTO CNT_MEM # OUT 매개변수가 반환되는 곳
      FROM CUSTOMER
		 WHERE GENDER = INPUT_A
			 AND ADDR = INPUT_B;
END //
DELIMITER ;

-- PROCEDURE 실행
CALL CST_GEN_ADDR_IN_CNT_MEM_OUT("WOMEN", "INCHEON", @CNT_MEM);
SELECT @CNT_MEM;

/* ### IN/OUT 매개변수 ### */

DELIMITER //
CREATE PROCEDURE IN_OUT_PARAMETER( INOUT COUNT INT)
BEGIN
		SET COUNT = COUNT + 10;
END //
DELIMITER ;

-- PROCEDURE 실행
SET @COUNTER = 1;
CALL IN_OUT_PARAMETER(@COUNTER);
SELECT @COUNTER;



/* ################ 데이터 마트 ################ */
-- 데이터 마트는 분석에 필요한 데이터를 가공한 분석용 데이터이다.

/* 회원 구매정보 */
SELECT A.MEM_NO, A.GENDER, A.BIRTHDAY, A.ADDR, A.JOIN_DATE,
			 SUM(B.SALES_QTY * C.PRICE) AS 구매금액,
       COUNT(B.ORDER_NO) AS 구매횟수,
       SUM(B.SALES_QTY) AS 구매수량
	FROM CUSTOMER AS A
  LEFT
  JOIN SALES AS B
		ON A.MEM_NO = B.MEM_NO
	LEFT
  JOIN PRODUCT AS C
		ON B.PRODUCT_CODE = C.PRODUCT_CODE
 GROUP
		BY A.MEM_NO, A.GENDER, A.BIRTHDAY, A.ADDR, A.JOIN_DATE;
    
-- 회원 구매정보 임시 테이블 생성
CREATE TEMPORARY TABLE CUSTOMER_PUR_INFO AS
SELECT A.MEM_NO, A.GENDER, A.BIRTHDAY, A.ADDR, A.JOIN_DATE,
			 SUM(B.SALES_QTY * C.PRICE) AS 구매금액,
       COUNT(B.ORDER_NO) AS 구매횟수,
       SUM(B.SALES_QTY) AS 구매수량
	FROM CUSTOMER AS A
  LEFT
  JOIN SALES AS B
		ON A.MEM_NO = B.MEM_NO
	LEFT
  JOIN PRODUCT AS C
		ON B.PRODUCT_CODE = C.PRODUCT_CODE
 GROUP
		BY A.MEM_NO, A.GENDER, A.BIRTHDAY, A.ADDR, A.JOIN_DATE;
    
-- 확인
SELECT * FROM CUSTOMER_PUR_INFO;

/* 회원 연령대 */
-- 생년월일 -> 나이
SELECT *, 2021-YEAR(BIRTHDAY) + 1 AS 나이
	FROM CUSTOMER;
  
-- 생년월일 -> 나이 -> 연령대
SELECT *,
			 CASE WHEN 나이 < 10 THEN "10대 미만"
						WHEN 나이 < 20 THEN "1O대"
            WHEN 나이 < 30 THEN "20대"
            WHEN 나이 < 40 THEN "3O대"
            WHEN 나이 < 50 THEN "40대"
            ELSE "50대 이상" END AS 연령대
  FROM (
				SELECT *, 2021-YEAR(BIRTHDAY) + 1 AS 나이
					FROM CUSTOMER
			 ) AS A;
       
-- CASE WHEN 함수 사용시 주의점 : 순차적으로 명시
-- 40대를 먼저 지정하면 그 이하 값들은 반환되지 않음(10,20,30대 반환X)
SELECT *,
			 CASE WHEN 나이 < 50 THEN "40대"
						WHEN 나이 < 10 THEN "10대 미만"
						WHEN 나이 < 20 THEN "1O대"
            WHEN 나이 < 30 THEN "20대"
            WHEN 나이 < 40 THEN "3O대"
            ELSE "50대 이상" END AS 연령대
  FROM (
				SELECT *, 2021-YEAR(BIRTHDAY) + 1 AS 나이
					FROM CUSTOMER
			 ) AS A;
       
CREATE TEMPORARY TABLE CUSTOMER_AGEBAND AS
SELECT *,
			 CASE WHEN 나이 < 10 THEN "10대 미만"
						WHEN 나이 < 20 THEN "1O대"
            WHEN 나이 < 30 THEN "20대"
            WHEN 나이 < 40 THEN "3O대"
            WHEN 나이 < 50 THEN "40대"
            ELSE "50대 이상" END AS 연령대
  FROM (
				SELECT *, 2021-YEAR(BIRTHDAY) + 1 AS 나이
					FROM CUSTOMER
			 ) AS A;

-- 확인
SELECT * FROM CUSTOMER_AGEBAND;

CREATE TEMPORARY TABLE CUSTOMER_PUR_INFO_AGEBAND AS
SELECT A.*, B.연령대
	FROM CUSTOMER_PUR_INFO AS A
  LEFT
  JOIN CUSTOMER_AGEBAND AS B
		ON A.MEM_NO = B.MEM_NO;

-- 확인
SELECT * FROM CUSTOMER_PUR_INFO_AGEBAND;

/* 회원 선호 카테고리 */
SELECT A.MEM_NO, B.CATEGORY, COUNT(A.ORDER_NO) AS 구매횟수,
			 ROW_NUMBER() OVER(PARTITION BY A.MEM_NO ORDER BY COUNT(A.ORDER_NO) DESC) AS 구매횟수_순위
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE
 GROUP
		BY A.MEM_NO, B.CATEGORY;
    
-- 회원 및 카테고리별 구매횟수 순위 + 구매횟수 순위 1위만 필터링
SELECT *
	FROM (
				SELECT A.MEM_NO, B.CATEGORY, COUNT(A.ORDER_NO) AS 구매횟수,
							 ROW_NUMBER() OVER (PARTITION BY A.MEM_NO ORDER BY COUNT(A.ORDER_NO) DESC) AS 구매횟수_순위
					FROM SALES AS A
          LEFT
          JOIN PRODUCT AS B
						ON A.PRODUCT_CODE = B.PRODUCT_CODE
				 GROUP
						BY A.MEM_NO, B.CATEGORY
			  )AS A
 WHERE 구매횟수_순위 = 1;
 
-- 회원별 선호 카테고리 임시 테이블
CREATE TEMPORARY TABLE CUSTOMER_PRE_CATEGORY AS
SELECT *
	FROM (
				SELECT A.MEM_NO, B.CATEGORY, COUNT(A.ORDER_NO) AS 구매횟수,
							 ROW_NUMBER() OVER(PARTITION BY A.MEM_NO ORDER BY COUNT(A.ORDER_NO) DESC) AS 구매횟수_순위
					FROM SALES AS A
					LEFT
					JOIN PRODUCT AS B
						ON A.PRODUCT_CODE = B.PRODUCT_CODE
				 GROUP
						BY A.MEM_NO, B.CATEGORY
				) AS A
WHERE 구매횟수_순위 = 1;

SELECT * FROM CUSTOMER_PRE_CATEGORY;

-- 회원 구매정보 + 연령대 + 선호 카테고리 임시테이블
CREATE TEMPORARY TABLE CUSTOMER_PUR_INFO_AGEBAND_PRE_CATEGORY AS
SELECT A.*, B.CATEGORY AS PRE_CATEGORY
	FROM CUSTOMER_PUR_INFO_AGEBAND AS A
  LEFT
  JOIN CUSTOMER_PRE_CATEGORY AS B
		ON A.MEM_NO = B.MEM_NO;
    
SELECT * FROM CUSTOMER_PUR_INFO_AGEBAND_PRE_CATEGORY;

/* 회원 분석용 데이터 마트 생성(회원 구매정보 + 연령대 + 선호 카테고리 임시테이블) */
CREATE TABLE CUSTOMER_MART AS
SELECT *
	FROM CUSTOMER_PUR_INFO_AGEBAND_PRE_CATEGORY;
  
-- 확인
SELECT * FROM CUSTOMER_MART;

/* ### 데이터 정합성 확인 ### */
-- 데이터 마트 회우너 수의 중복은 없는가?
SELECT *
	FROM CUSTOMER_MART;
  
SELECT COUNT(MEM_NO), COUNT(DISTINCT MEM_NO)
	FROM CUSTOMER_MART;
  
-- 데이터 마트의 요약 및 파생변수의 오류는 없는가?
SELECT *
	FROM CUSTOMER_MART;

-- 회원(1000005)의 구매정보
-- 구매금액 : 408000, 구매횟수 : 3, 구매수량 : 14

SELECT SUM(A.SALES_QTY * B.PRICE) AS 구매금액,
			 COUNT(A.ORDER_NO) AS 구매횟수,
       SUM(A.SALES_QTY) AS 구매수량
  FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE
 WHERE MEM_NO = "1000005";
 
-- 회원(1000005)의 선호 카테고리 확인
-- PRE_CATEGORY: HOME
SELECT *
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE
 WHERE MEM_NO = "1000005" ;

/* 데이터 마트의 구매자 비중(%)의 오류는 없는가? */
-- 회원(CUSTOMER) 테이블 기준, 주문(SALES) 테이블 구매 회원번호 LEFT JOIN 결합
SELECT *
	FROM CUSTOMER AS A
  LEFT
  JOIN (
				SELECT DISTINCT MEM_NO
					FROM SALES
			 ) AS B
		ON A.MEM_NO = B.MEM_NO;

-- 구매여부 추가
SELECT *,
			 CASE WHEN B.MEM_NO IS NOT NULL THEN "구매"
								 ELSE "미구매" END AS 구매여부
	FROM CUSTOMER AS A
  LEFT
  JOIN (
				SELECT DISTINCT MEM_NO
					FROM SALES
			 )AS B
		ON A.MEM_NO = B.MEM_NO;
    
-- 구매여부별, 회원수
SELECT 구매여부, COUNT(MEM_NO) AS 회원수
	FROM (
				SELECT A.*,
							 CASE WHEN B.MEM_NO IS NOT NULL THEN "구매"
												 ELSE "미구매" END AS 구매여부
					FROM CUSTOMER AS A
					LEFT
          JOIN (
								SELECT DISTINCT MEM_NO
									FROM SALES
							 ) AS B
					  ON A.MEM_NO = B.MEM_NO
				)AS A
 GROUP
		BY 구매여부;
    
-- 확인(미구매 : 1459, 구매 1202)
SELECT *
	FROM CUSTOMER_MART
 WHERE 구매금액 IS NULL; # 1459 ROWS

SELECT *
	FROM CUSTOMER_MART
 WHERE 구매금액 IS NOT NULL; # 1202 ROWS

















