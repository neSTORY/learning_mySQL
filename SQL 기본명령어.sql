### 테이블 정의어(DLL) ###

/* Practice 이름으로 데이터베이스 생성 */
CREATE DATABASE Practice;

/* Practice 데이터베이스 사용 */
USE Practice;

/* 테이블 생성 */
# 회원테이블 생성
CREATE TABLE 회원테이블 (
회원번호 INT PRIMARY KEY, # 고유키 설정(중복 허용X)
이름 VARCHAR(20), # 20 : BYTE 수 (최대 20 바이트)
가입일자 DATE NOT NULL, # 제약조건 -> NULL 값 허용 X
수신동의 BIT # BIT : BOOLEAN (논리형)
);

/* 기본키(PRIMARY KEY) : 중복되어 나타날 수 없는 단일 값 + NOT NULL */
/* NOT NULL : NULL 허용하지 않음 */

# 회원테이블 조회
SELECT * # 모든 열을 조회하겠다.
	FROM 회원테이블; # 조회하고자 하는 테이블 명
    
    
/* 테이블 열 추가 */
# 성별 열 추가
ALTER TABLE 회원테이블 ADD 성별 VARCHAR(2);

# 다시 회원테이블 조회
SELECT * FROM 회원테이블;

/* 테이블 열 데이터 타입 변경 */
# 성별 열 타입 변경
ALTER TABLE 회원테이블 MODIFY 성별 VARCHAR(20); # 성별 컬럼의 데이터 타입이 VARCHAR(20)으로 바뀐 것을 확인

/* 테이블 열 이름 변경 */
ALTER TABLE 회원테이블 CHANGE 성별 성 VARCHAR(2); # CHAGE (기존 열 이름) (변경 열 이름) (데이터 타입)

  
/* 테이블 명 변경 */
-- 테이블 명 변경
ALTER TABLE 회원테이블 RENAME 회원정보; 

-- 회원테이블 조회 => 이름이 변경되었기 때문에 조회되지 않음
SELECT * FROM 회원테이블; # 불가능
SELECT * FROM 회원정보; # 가능

/* 테이블 삭제 */
-- 테이블 삭제
DROP TABLE 회원정보;

-- 회원정보 테이블 조회
SELECT * FROM 회원테이블; # 삭제되어 조회가 불가능


### 테이블 조작어(DML) ###

-- CREATE DATABASE practice # 데이터 베이스 생성
USE PRACTICE;

/* 테이블 생성(CREATE) */
-- 회원테이블 생성
CREATE TABLE 회원테이블(
회원번호 INT PRIMARY KEY,
이름 VARCHAR(20),
가입일자 DATE NOT NULL,
수신동의 BIT
);

/* 데이터 삽입 */
INSERT INTO 회원테이블 VALUES (1001, "홍길동", "2021-01-02", 1); # 열 순서에 맞게 데이터 입력
INSERT INTO 회원테이블 VALUES (1002, "이순신", "2021-01-03", 0);
INSERT INTO 회원테이블 VALUES (1003, "장영실", "2021-01-04", 1);
INSERT INTO 회원테이블 VALUES (1004, "유관순", "2021-01-05", 0);

/* 회원테이블 조회 */
SELECT * FROM 회원테이블;

/* 조건을 위반한 예제 */
-- PRIMARY KEY 제약 조건 위반
INSERT INTO 회원테이블 VALUES(1004, "장보고", "2021-01-06", 0); # 회원번호 컬럼 유일값 조건 위반

-- NOT NULL 제약 조건 위반
INSERT INTO 회원테이블 VALUES (1005, "장보고", NULL, 0); # 가입일자 컬럼 NOT NULL 위반

-- 데이터 타입 조건 위반
INSERT INTO 회원테이블 VALUES (1005, "장보고", 1, 0); # 가입일자 컬ㄹ머 데이터타입 위반


/* 특정 열 이름 변경하여 조회 */
-- 전체 열 조회
SELECT * FROM 회원테이블;

-- 특정 열 조회
SELECT 이름, 가입일자 FROM 회원테이블;

-- 특정 열 이름 변경하여 조회
SELECT 회원번호, 
		이름 AS 성명 # 이름 컬럼을 성명으로 변경하여 조회 but 저장X
	FROM 회원테이블; 

/* 데이터 수정 */
-- 모든 데이터 수정
UPDATE 회원테이블 # UPDATE 테이블 명
	SET 수신동의 = 0; # 수신동의 컬럼 내 데이터가 모두 0으로 변경
    
SELECT * FROM 회원테이블;

-- 특정 조건 데이터 수정
UPDATE 회원테이블
	SET 수신동의 = 1
    WHERE 이름 = "홍길동"; # WHERE으로 조건을 주어 이름 컬럼에서 "홍길동"인 행의 데이터를 바꿔줌

SELECT * FROM 회원테이블;

/* 데이터 삭제 */
-- 특정 데이터 삭제
DELETE
	FROM 회원테이블
    WHERE 이름 = "홍길동";

SELECT * FROM 회원테이블; # 홍길동 행 데이터 삭제 확인

-- 모든 데이터 삭제
DELETE
	FROM 회원테이블;

SELECT * FROM 회원테이블; # 모든 데이터 삭제 확인














