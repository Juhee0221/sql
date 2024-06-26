
-- 1번
CREATE TABLE MY_EMP (
	EMP_NO INT PRIMARY KEY
	, EMP_NAME VARCHAR(10) NOT NULL
	, DEPT_NO INT NOT NULL
	, DEPT_NAME VARCHAR(20) NOT NULL
	, DEPT_RANK VARCHAR(20) NOT NULL
);

SELECT * FROM my_emp;
SELECT * FROM emp;
SELECT * FROM dept;

-- 2번
INSERT INTO MY_EMP VALUES (1,'김나비',1,'회계부','과장');
INSERT INTO MY_EMP VALUES (2,'이나비',1,'회계부','대리');
INSERT INTO MY_EMP VALUES (3,'최솔비',2,'생산부','과장');
INSERT INTO MY_EMP VALUES (4,'김지비',2,'생산부','사원');
INSERT INTO MY_EMP VALUES (5,'김누비',1,'회계부','사원');
INSERT INTO MY_EMP VALUES (6,'박최비',3,'영업부','부장');
INSERT INTO MY_EMP VALUES (7,'김자비',3,'영업부','차장');
INSERT INTO MY_EMP VALUES (8,'노자비',4,'개발부','대리');
INSERT INTO MY_EMP VALUES (9,'이홀비',4,'개발부','사원');

DELETE FROM MY_EMP;

COMMIT;

-- 3번
UPDATE MY_EMP
SET EMP_NAME = '김자바',
DEPT_RANK = '대리' 
WHERE EMP_NO = 1;

-- 4번 
SELECT EMPNO
		,ENAME
		,SAL
		,COMM
FROM emp
WHERE (SAL >= 500 OR SAL >= 1500) 
AND COMM IS NOT NULL;

-- 5번

SELECT ENAME
		,EMPNO
		,HIREDATE
FROM emp
WHERE ENAME LIKE '%이%'
ORDER BY EMPNO ASC;

-- 6번
SELECT EMPNO
	, ENAME
	, D.DEPTNO
	, CASE 
		WHEN D.DEPTNO = 10 THEN '인사부'
		WHEN D.DEPTNO = 20 THEN '영업부'
		ELSE '생산부'
		END AS ENAME
FROM emp E INNER JOIN dept D
ON E.DEPTNO = D.DEPTNO;

-- 7번
SELECT * 
FROM emp
WHERE DATE_FORMAT(HIREDATE, '%Y') = '2007'
ORDER BY ;

-- 8번
SELECT AVG(SAL)
		,SUM(SAL)
		,AVG(COMM)
WHERE JOB =	(SELECT SAL FROM emp WHERE JOB = '대리')
		,(SELECT SAL FROM emp WHERE JOB = '사원')
		,(SELECT SAL FROM emp WHERE JOB);
		
-- 9번

SELECT EMPNO
		,ENAME
		,HIREDATE
		,SAL
		,DEPTNO
		,(SELECT 
			LOC 
			FROM DEPT 
			WHERE emp.DEPTNO = DEPTNO) LOC
FROM emp 
WHERE DEPTNO = (SELECT DEPTNO
							FROM DEPT
							WHERE LOC = '서울');
-- 10번
SELECT EMPNO
		,ENAME
		,HIREDATE
		,SAL
		,LOC 
		,EMP.DEPTNO
FROM emp INNER JOIN dept
ON emp.DEPTNO = dept.DEPTNO
WHERE EMP.DEPTNO = (SELECT DEPTNO
							FROM DEPT
							WHERE LOC = '서울');
							

CREATE TABLE MOVIE_MEMBER (
	MEMBER_ID VARCHAR(10) PRIMARY KEY
	, MEMBER_PW VARCHAR(20) NOT NULL
	, MEMBER_TEL VARCHAR(20) NOT NULL
	, MEMBER_NAME VARCHAR(10) NOT NULL
);

CREATE TABLE MOVIE_SCREEN(
	SCREEN_NO INT PRIMARY KEY
	, SCREEN_NAME VARCHAR(20) NOT NULL
	, SCREEN_SEAT INT NOT NULL DEFAULT 150
);

DROP TABLE MOVIE_SCREEN;
SELECT * FROM MOVIE_SCREEN; 

INSERT INTO MOVIE_SCREEN (SCREEN_NO,SCREEN_NAME )VALUES (1,'VIP');
INSERT INTO MOVIE_SCREEN VALUES (2,'VIP', 2);
INSERT INTO MOVIE_SCREEN VALUES (3,'VIP', 3);
INSERT INTO MOVIE_SCREEN VALUES (4,'VIP', 4);
INSERT INTO MOVIE_SCREEN VALUES (5,'VIP', 5);
INSERT INTO MOVIE_SCREEN VALUES (6,'VIP', 6);
INSERT INTO MOVIE_SCREEN VALUES (7,'VIP', 7);
INSERT INTO MOVIE_SCREEN VALUES (8,'VIP', 8);
INSERT INTO MOVIE_SCREEN VALUES (9,'VIP', 9);
INSERT INTO MOVIE_SCREEN VALUES (10,'VIP', 10);
INSERT INTO MOVIE_SCREEN VALUES (11,'VIP', 11);
 
CREATE TABLE SCREEN_SEAT (
	SEAT_NO INT PRIMARY KEY 
	, SEAT_ROW INT NOT NULL DEFAULT 10
	, SEAT_COL INT NOT NULL DEFAULT 15
	, SEAT_ON VARCHAR(5) NOT NULL DEFAULT 'YES'
	, SCREEN_NO INT NOT NULL REFERENCES MOVIE_SCREEN(SCREEN_NO)
);

SELECT * FROM SCREEN_SEAT;

INSERT INTO SCREEN_SEAT (
SEAT_NO 
, SEAT_ROW 
, SEAT_COL 
,SCREEN_NO

) VALUES 
(6
,1
,6
,1);


CREATE TABLE MOVIE_TICKET(
	TICKET_CODE INT PRIMARY KEY
	, MEMBER_ID VARCHAR(10) NOT NULL REFERENCES MOVIE_MEMBER(MEMBER_ID)
	, SCREEN_NO INT NOT NULL REFERENCES MOVIE_SCREEN(SCREEN_NO)
	, SEAT_NO INT NOT NULL REFERENCES SCREEN_SEAT(SEAT_NO)
);

SELECT TICKET_CODE
	, SCREEN_NO
	, SEAT_NO
FROM MOVIE_TICKET
WHERE MEMBER_ID = 'JAVA';

SELECT SEAT_ON 
		 SCREEN_NO
		,IF((SEAT_COL * SEAT_ROW = 0 AND SEAT_ON  = 'NO'), '예매할 수 있는 좌석이 없습니다.', '예매가능')
FROM SCREEN_SEAT 
WHERE SCREEN_NO = (SELECT SCREEN_NO 
						FROM MOVIE_SCREEN WHERE SCREEN_NAME = 'VIP');