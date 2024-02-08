
-- 뷰(VIEW)
-- 뷰 : 가상 테이블 
-- 뷰가 유용하게 사용되는 경우
-- 1) 특정 테이블의 데이터 조회 시 조인이 지속적으로 반복되는 경우
-- 2) 테이블의 특정 데이터의 보안성 확보
-- EMP 테이블에 대한 첫번째 뷰 생성
-- 셀렉한 결과로 뷰를 생성
CREATE VIEW EMP_VIEW_1
AS 
SELECT empNO, ENAME, JOB
FROM emp;

-- WHERE 절도 가능
SELECT * FROM emp_view_1;

-- OR REPLACE => 생성한 뒤 내용수정을 해도 무관.
CREATE OR REPLACE VIEW emp_VIEW_2
AS 
SELECT empNO, ENAME , SAL ,COMM 
FROM emp 
WHERE SAL  >= 350;

-- VIEW에 데이터에 들어간것이 아니라 
-- SELECT 한 정보를 보여주는것.
-- 즉 EMP 정보를 조회한 것을 조회해줌.

SELECT * FROM emp_VIEW_2;

-- 가상테이블 삭제
DROP VIEW ;