-- 현재 쿼리탭에서는 AUTOCOMMIT을 비활성화 시키는 세팅.
SET @@AUTOCOMMIT=0;

-- 데이터 변경사항을 취소하는것.
ROLLBACK; 
-- 데이터의 변경사항을 저장.
COMMIT; 


-- 공부용 테이블 생성
CREATE TABLE STUDENT (
	STU_NO INT PRIMARY KEY -- PRIMARY KEY를 선언시 중복 값과 NULL값이 못들어감. 
	, STU_NAME VARCHAR(10)
	, SCORE INT
	, ADDR VARCHAR(20)
	
	-- 가로 속 괄호 안의 숫자는 최대로 넣을 수 있는 글자 수를 설정.
);

SELECT * FROM STUDENT;

-- 데이터 삽입
-- INSERT INTO 테이블명 (컬럼들) VALUES (값들);
-- INSERT 후 COMMIT을 해서 값을 저장한 후 에는 ROLLBACK을 해도 ROLLBACK이 안됨.
-- 컬럼값을 넣은 순서대로, 값들을 넣어주기.
-- COMMIT하지 않은 값들은 ROLLBACK시 다 ROLLBACK됨

INSERT INTO student (STU_NO, STU_NAME, SCORE, ADDR) 
VALUES (6, '김자바', 80, '울산');

INSERT INTO student (STU_NO, STU_NAME) 
VALUES (2, '이자바');

INSERT INTO student (STU_NAME, STU_NO) 
VALUES ('최자바', 3);
COMMIT;

INSERT INTO student (STU_NAME, SCORE) 
VALUES ('최자바', 70);

-- 컬럼명을 명시하지 않으면 테이블 생성시 작성한
-- 컬럼순으로 데이터를 삽입.
INSERT INTO student 
VALUES (5, '홍길동', 80,'서울');
COMMIT;

SELECT * FROM student;

-- 데이터 삭제
-- DELETE FROM 테이블명 [WHERE 조건];

DELETE FROM student;
ROLLBACK;

-- 학번이 1번인 학생을 삭제하는 쿼리

DELETE FROM student 
WHERE STU_NO = 1;

-- 학번이 3번 이상이면서 주소가 NULL인 학생을 삭제 

DELETE FROM student
WHERE STU_NO >= 3 AND ADDR IS NULL;

-- 학번이 "1"인 학생 이름 조회 
SELECT STU_NAME
FROM STUDENT
WHERE STU_NO = 1;

study_dbboard_member