## VIEW

View는 하나 이상의 테이블들을 활용하여, 사용자가 정의한 가상 테이블이다.

- join 사용을 최소화하여, 편의성을 최대화
- 가상 테이블이기 때문에 **중복되는 열이 저장될 수 없다**

``` mysql
CREATE VIEW SALES_PRODUCT AS
SELECT A.*, A.SALES_QTY * B.PRICE AS 결제금액
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE;
```



## PROCEDURE

Procedure는 매개변수를 활용해 사용자가 정의한 작업을 저장(함수 정의와 비슷)

Procedure의 매개변수는 IN, OUT, INOUT 3가지로 나뉨

![image-20220104141630870](C:/Users/NaEunSu/AppData/Roaming/Typora/typora-user-images/image-20220104141630870.png)



- IN

  ```mysql
  DELIMITER //
  CREATE PROCEDURE CST_GEN_ADDR_IN( IN INPUT_A VARCHAR(20), INPUT_B VARCHAR(20) )
  BEGIN # PROCEDURE의 시작과 끝을 표기
  		SELECT *
  			FROM CUSTOMER
  		 WHERE GENDER = INPUT_A
  		   AND ADDR = INPUT_B;
  END //
  DELIMITER ;
  
  /* PROCEDURE 실행 */
  CALL CST_GEN_ADDR_IN("MAN", "SEOUL");
  ```

- OUT

  ```mysql
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
  CALL CST_GEN_ADDR_IN_CNT_MEM_OUT("WOMEN", "INCHEON", @CNT_MEM); # OUT 매개변수는 @로 구분
  SELECT @CNT_MEM;
  ```

- IN/OUT

  ``` mysql
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
  ```

  

## 데이터 마트

데이터 마트는 분석에 필요한 데이터를 가공한 분석용 데이터이다.

- 요약 변수 : 수집된 데이터를 분석에 맞게 종합한 변수(기간별 구매 금액, 횟수, 수량 등)
- 파생 변수 : 사용자가 특정 조건 또는 함수로 의미를 부여한 변수(연령대, 선호 카테고리 등)

ex) 연령대 파생변수 생성

```mysql
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
```



ex) 선호 카테고리 생성

``` mysql
SELECT A.MEM_NO, B.CATEGORY, COUNT(A.ORDER_NO) AS 구매횟수,
			 ROW_NUMBER() OVER(PARTITION BY A.MEM_NO ORDER BY COUNT(A.ORDER_NO) DESC) AS 구매횟수_순위
	FROM SALES AS A
  LEFT
  JOIN PRODUCT AS B
		ON A.PRODUCT_CODE = B.PRODUCT_CODE
 GROUP
		BY A.MEM_NO, B.CATEGORY;
```



### 데이터 정합성

데이터 정합성은 데이터가 서로 모순없이 일관되게 일치함을 나타낼 때 사용

1.  회원수의 중복은 없는가?
2. 요약 및 파생변수의 오류는 없는가?
3. 구매자 비중(%)의 오류는 없는가?

ex)  회원수의 중복 확인

``` mysql
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
```

