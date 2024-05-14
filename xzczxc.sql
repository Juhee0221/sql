-- group by 통계 쿼리에서 사용

SELECT * FROM emp;

-- 각 직급별 급여의 합 조회
SELECT JOB, SUM(SAL)
FROM emp
GROUP BY JOB;

-- 중복을 제거한  각 직급별 데이터 조회
SELECT DISTINCT JOB FROM emp;

-- 부서번호 별 인원수를 조회 
SELECT COUNT(EMPNO), DEPTNO , ENAME
FROM emp
GROUP BY DEPTNO; 

-- 다중행 함수 : 데이터의 개수와 상관없이 
-- 					조회 결과가 1행 나오는 함수
-- ex > SUM (), COUNT() , MIN (), MAX () , AVG ()
-- 사번 , 사원명 , 모든 직원의 급여의 합 조회


-- 만약, 커미션의 평균이 null이라면 0.0으로 조회
SELECT SUM(SAL)
	  , AVG(SAL)
	  , IFNULL(AVG(COMM), 0.0) COMM
	  , JOB
FROM emp
GROUP BY JOB
ORDER BY JOB ASC;


-- 입사한 월별 사원들의 급여의 합

-- 사원들의 입사 월을 조회
-- 첫번째 방법
SELECT HIREDATE
	,SUBSTRING(HIREDATE, 6,2)
FROM emp;	

SELECT DATE_FORMAT(HIREDATE, '%M')
	, SUM(SAL)
FROM emp
GROUP BY DATE_FORMAT(HIREDATE, '%M');

-- 1월에 입사한 사원들을 제외하고 입사한 월별사원들의 입사자 수 
-- GRUOP BY 가 없어도 조회가능
SELECT DATE_FORMAT(HIREDATE, '%m')
	, COUNT(EMPNO)
FROM emp
WHERE DATE_FORMAT(HIREDATE, '%m') != '01'
GROUP BY DATE_FORMAT(HIREDATE, '%M'); 

-- 월별 입사자 수를 조회
-- 월별 입사자 수가 2명 이상인 데이터만 조회
SELECT DATE_FORMAT(HIREDATE, '%m') 입사월
		,COUNT(EMPNO) 입사인원
FROM emp
WHERE DATE_FORMAT(HIREDATE, '%m') != '10'
GROUP BY 입사월
HAVING COUNT(EMPNO) >=2
ORDER BY 입사인원 DESC;
-- 조회 시 월별 입사자 수가 높은 순으로 조회
	
-- 
SELECT DATE_FORMAT(HIREDATE, '%M') 입사월 -- 3
	,COUNT(EMPNO)
FROM emp -- 1
WHERE DATE_FORMAT(HIREDATE, '%M') != '01' -- 2
GROUP BY 입사월 -- 4
ORDER BY 입사월; -- 5 