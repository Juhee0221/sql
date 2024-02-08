-- 서브 쿼리 -- 하나의 쿼리 안에 또 다른 쿼리가 존재.
-- 두 개 이상의 테이블에서 데이터를 조회할 때 사용

-- 김사랑 사원과 같은 부서에 근무하는 사원들의 사번, 이름, 부서번호 

SELECT EMPNO
	, ENAME
	, DEPTNO
FROM emp
WHERE DEPTNO = (	SELECT DEPTNO
						FROM emp
						WHERE ENAME ='김사랑');
						
-- 한예슬 사원과 동일한 급여를 받는 사원들의 이름, 직급 , 급여를 조회

SELECT ENAME
		, JOB
		, SAL
FROM emp
WHERE SAL = ( SELECT SAL 
				  FROM emp
				  WHERE ENAME ='한예슬');
				  
-- 모든 사원들의 사번, 이름 , 부서번호 , 부서명을 조회
-- 단 , 서브쿼리만 사용해서 조회

SELECT empNO
		, ENAME
		, deptNO
		, (SELECT DNAME FROM dept WHERE deptNO = emp.DEPTNO) DNAME
FROM emp;

-- 모든 사원들의 급여의 합은 =? 
SELECT SUM(SAL), COUNT(EMPNO), MAX(SAL), MIN(SAL), AVG(SAL)
FROM emp;


-- 모든 사원의 급여 평균보다 더 높은 급여를 받는 사원들의 모든정보조회
SELECT * 
FROM emp
WHERE SAL > (SELECT AVG(SAL) FROM emp);

-- 근무지가 인천인 부서에 속한 사원들의
-- 급여를 현재 급여에서 100 인상하는 쿼리를 작성
UPDATE emp
SET
SAL = SAL + 100
WHERE DEPTNO = (SELECT DEPTNO
					FROM dept
					WHERE LOC = '인천');
					
SELECT * FROM shop_cart;
-- 장바구니에 저장된 상품들의 
-- 상품명, 상품가격, 장바구니 소유자 ID, 장바구니 소유자 명을 조회 


SELECT ITEM_CODE
		, (SELECT ITEM_NAME 
			FROM shop_item
			WHERE ITEM_CODE = shop_cart.ITEM_CODE) ITEM_NAME
		, (SELECT ITEM_PRICE
			FROM shop_item
			WHERE ITEM_CODE = shop_cart.ITEM_CODE) ITEM_PRICE
		,	MEMBER_ID
		,  (SELECT MEMBER_NAME 
			 FROM shop_member
			 WHERE MEMBER_ID = shop_cart.MEMBER_ID) MEMBER_NAME
FROM shop_cart;		
		


		

