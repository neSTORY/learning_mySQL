USE PRACTICE;

/* FROM */
-- CUSTOMER 테이블 모든 열 조회
SELECT *
	FROM CUSTOMER;

/* WHERE */
-- 성별이 남성 조건으로 필터링
SELECT *
	FROM CUSTOMER
  WHERE GENDER = "MAN";
  
/* GROUP BY */
-- 지역별로 회원수 집계
SELECT ADDR
			,COUNT(MEM_NO) AS 회원수
	FROM CUSTOMER
  WHERE GENDER = "MAN"
  GROUP BY ADDR;

/* HAVING */
-- 집계 회원수 100명 미만 조건으로 필터링
SELECT ADDR,
				COUNT(MEM_NO) AS 회원수
	FROM CUSTOMER
  WHERE GENDER = "MAN"
  GROUP BY ADDR
  HAVING COUNT(MEM_NO) < 100; # 회원수가 100 보다 작은 데이터

/* ODER BY */
-- 집계 회원수가 높은 순으로
SELECT ADDR,
				COUNT(MEM_NO)
	FROM CUSTOMER
  WHERE GENDER = "MAN"
  GROUP BY ADDR
  HAVING COUNT(MEM_NO) < 100
  ORDER BY COUNT(MEM_NO) DESC;
  
  
/* FROM -> (WHERE) -> GROUP BY 순으로 작성 */

-- FROM -> GROUP BY 순으로 작성해도 가능
SELECT ADDR,
				COUNT(MEM_NO) AS 회원수
	FROM CUSTOMER
-- WHERE GENDER = "MAN"
	GROUP BY ADDR;
  
/* GROUP BY + 집계함수 */
-- 거지주역을 서울, 인천 조건으로 필터링
-- 거주지역 및 성별로 회원수 집계
SELECT ADDR, 
				GENDER, # GROUP BY에 있는 열들을 SELECT에도 사용해야 함
				COUNT(MEM_NO) AS 회원수
	FROM CUSTOMER
  WHERE ADDR IN ("SEOUL", "INCHEON") # IN-특수 연산자, IN (LIST) 리스트값만 가능
  GROUP BY ADDR, GENDER;

/* SQL 명령어 작성법 */
SELECT *
	FROM CUSTOMER
  WHERE GENDER = "MAN"
  GROUP
		 BY ADDR
 HAVING COUNT(MEM_NO) < 100
	ORDER
		 BY COUNT(MEM_NO) DESC;

















