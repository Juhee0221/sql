-- 별칭사용(조회 시 컬럼명을 변경)
-- 컬럼명을 조회 할때는 테이블명.컬럼명으로 조회
-- 통상적으로 (테이블명.) 은 생략.
SELECT emp.EMPNO
	, emp.ENAME
	, emp.SAL
FROM emp;

-- 한글도 가능
-- 별칭을 써서 컬럼을 조회하지만 컬럼명이 별칭인것은 아님
-- 별칭 사용 1) 컬럼명 AS 별칭
--				 2) 컬럼명 (한칸공백) 별칭 
SELECT EMPNO AS 사번
	, ENAME AS NM
	, SAL 급여
FROM emp;

-- 테이블에도 별칭사용이 가능.
SELECT EMPNO
	, ENAME
	, SAL
FROM emp E;

-- 두개이상의 테이블에서 정보를 조회할때
-- 주로 별칭을 사용함.
SELECT E.EMPNO
	, E.ENAME
	, E.SAL
FROM emp E;	
	

-- join

SELECT * FROM emp;
SELECT * FROM dept;

-- 사원의 사번, 이름, 부서명을 조회
-- 1.CROSS JOIN(공부를 위해 학습, 실무사용x)
SELECT EMPNO, ENAME , DNAME
FROM emp CROSS JOIN dept;

-- 2. INNER JOIN(교집합)
-- 각 테이블에서 어떤정보가 같은지 지정을 해주어야됨
-- ON : 조인하는 두 테이블이 공통적으로 지니는 컬럼의
-- 값이 같다 라는 조건을 줄 것!
SELECT EMPNO, ENAME, DNAME
FROM emp INNER JOIN dept
ON emp.DEPTNO = dept.DEPTNO;

-- 테이블명이 길거나 쿼리의 길이를 줄이고 싶을때 
-- 별칭을 사용하여 길이를 줄임.
-- 중복된 컬럼이 있을시 어떤 테이블의 컬럼을 조회할지 명확하게 적어줘야됨.
-- ON절이 아닌 WHERE절에 넣어도 조회가 가능하지만
-- JOIN을 사용하면 ON절을 사용하는것이 통상적으로 좋음.

SELECT EMPNO, ENAME, DNAME, D.DEPTNO
FROM emp E INNER JOIN dept D
ON E.DEPTNO = D.DEPTNO
WHERE E.DEPTNO = 20;

-- 데이터 조회 시 정렬하여 출력
-- 사원의 모든 정보를 조회하되, 급여가 낮은 순부터 조회
-- ASC(생략가능) : 오름차순 - ascending
-- DESC : 내림차순 - descending
SELECT *
FROM emp
ORDER BY SAL; 

-- 한글, 영어도 오름차순.내림차순이 가능
SELECT *
FROM emp
ORDER BY ENAME;

-- 사원의 모든 데이터를 조회하되, 급여 기준 내림차순 정렬
-- 급여가 같다면 사번기준 오름차순 정렬
SELECT *
FROM emp
ORDER BY SAL DESC, EMPNO ASC; 

-- 급여가 200 이상이면서 커미션은 NULL이 아닌 
-- 사번의 사번, 이름, 급여, 부서번호 , 부서명을 조회
-- 단, 부서번호 기준 오름차순 정렬 후 
-- 부서번호가 같다면 급여 기준 내림차순으로 정렬
-- 추가적으로 사번은 '사원번호'라는 별칭 사용
-- 정렬은 제일 마지막!!
SELECT EMPNO AS 사원번호
		, ENAME
		, SAL 
		, D.DEPTNO
		, DNAME
FROM emp E INNER JOIN dept D
ON E.DEPTNO = D.DEPTNO
WHERE SAL >= 200 AND COMM IS NOT NULL
ORDER BY D.DEPTNO, SAL DESC;
