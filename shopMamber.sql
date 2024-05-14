-- 쇼핑몰 프로젝트 테이블 

-- 회원 정보 테이블
CREATE TABLE SHOP_MEMBER (
	MEMBER_ID VARCHAR(20) PRIMARY KEY
	, MEMBER_PW VARCHAR(20) NOT NULL
	, MEMBER_NAME VARCHAR(20) NOT NULL
	, GENDER VARCHAR(10) NOT NULL -- MALE , FEMALE
	, MEMBER_EMAIL VARCHAR(50) NOT NULL UNIQUE -- UNIQUE (중복X)
	, MEMBER_TEL VARCHAR(20) -- 010-1111-2222
	, MEMBER_ADDR VARCHAR(50) 
	, ADDR_DETAIL VARCHAR(50)
	, POST_CODE VARCHAR(10)
	, JOIN_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
	, MEMBER_ROLL VARCHAR(20) DEFAULT 'USER' -- 권한 USER, ADMIN
);
-- 상품 카테고리 정보 테이블 
CREATE TABLE ITEM_CATEGORY (
	CATE_CODE INT AUTO_INCREMENT PRIMARY KEY
	,	CATE_NAME VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO item_category VALUES (1, 'IT/인터넷');
INSERT INTO item_category VALUES (2, '소설/에세이');
INSERT INTO item_category VALUES (3, '문화/여행');
COMMIT; 

SELECT * FROM item_category;
SELECT * FROM shop_member;


COMMIT;

-- 상품정보 테이블 
CREATE TABLE SHOP_ITEM(
	ITEM_CODE INT AUTO_INCREMENT PRIMARY KEY
	, ITEM_NAME VARCHAR(50) NOT NULL UNIQUE
	, ITEM_PRICE INT NOT NULL
	, ITEM_STOCK INT DEFAULT 10
	, ITEM_INTRO VARCHAR(100)
	, REG_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
	, CATE_CODE INT NOT NULL REFERENCES item_category (CATE_CODE) 
);

-- 준비 중 : 1, 판매중 : 2, 매진 : 3
ALTER TABLE shop_item ADD COLUMN ITEM_STATUS INT DEFAULT 1;

UPDATE shop_item
SET ITEM_STATUS = 2;

ALTER TABLE shop_item DROP COLUMN ITEM_STATUS;
  
-- 상품의 이미지 정보를 관리하는 테이블
CREATE TABLE ITEM_IMAGE(
	IMG_CODE INT AUTO_INCREMENT PRIMARY KEY
	, ORIGIN_FILE_NAME VARCHAR(100) NOT NULL
	, ATTACHED_FILE_NAME VARCHAR(100) NOT NULL
	, IS_MAIN VARCHAR(2) NOT NULL -- 'Y', 'N'
	, ITEM_CODE INT NOT NULL REFERENCES shop_item (ITEM_CODE)
);

-- 다중 등록
INSERT INTO item_image (
	IMG_CODE 
	, ORIGIN_FILE_NAME
	, ATTACHED_FILE_NAME
	, IS_MAIN
	, ITEM_CODE
) VALUES 
(1, 'aa.jpg', 'aaa.jpg', 'Y', 1) , 
(2, 'bb.jpg', 'bbb.jpg', 'N', 1) , 
(3, 'cc.jpg', 'ccc.jpg', 'N', 1) ;




SELECT * FROM item_image;
SELECT * FROM shop_item;
SELECT * FROM shop_member;

SELECT * FROM boardboard;
COMMIT;


-- 다음에 들어갈 ITEM_CODE를 조회 
-- 현재 등록된 ITEM_CODE중 가장 큰 값을 구한 후 + 1

SELECT MAX(ITEM_CODE) +1 FROM shop_item;

SELECT ITEM_NAME
      , ITEM.ITEM_CODE
      , ITEM_PRICE
      , ATTACHED_FILE_NAME
  FROM SHOP_ITEM ITEM INNER JOIN ITEM_IMAGE IMG
  ON ITEM.ITEM_CODE = IMG.ITEM_CODE
  -- 메인이미지만 조회 
  WHERE IS_MAIN ='Y'
  ORDER BY REG_DATE DESC;

-- 상품 상세 정보 조회
-- ITEM_CODE, ITEM_NAME, ITEM_PRICE, ITEM_INTRO
-- 
SELECT ITEM.ITEM_CODE
		, ITEM_NAME_
		, ITEM_PRICE
		, ITEM_INTRO
		, ATTACHED_FILE_NAME
FROM shop_item ITEM INNER JOIN item_image IMG
ON ITEM.ITEM_CODE = IMG.ITEM_CODE
WHERE ITEM.ITEM_CODE = 1;

-- 장바구니 정보 조회
SELECT 
* FROM shop_cart;

WHERE CART_CODE = 1;
-- 장바구니 정보 테이블
CREATE TABLE SHOP_CART (
	CART_CODE INT AUTO_INCREMENT PRIMARY KEY
	, ITEM_CODE INT NOT NULL REFERENCES shop_item (ITEM_CODE)
	, MEMBER_ID VARCHAR(20) NOT NULL REFERENCES shop_member (MEMBER_ID)
	, CART_CNT INT NOT NULL 
	, CART_DATE DATETIME DEFAULT CURRENT_TIMESTAMP 
);


-- 상품명, 가격 , 개수 , 총가격
SELECT ITEM_NAME
		, ITEM_PRICE
		, CART_CNT
		, ITEM_PRICE * CART_CNT
FROM SHOP_CART CART INNER JOIN shop_item ITEM
ON CART.ITEM_CODE = ITEM.ITEM_CODE;		

-- 회원 아이디가 'JAVA'인 회원의
-- 장바구니에 담긴 장바구니목록을 조회

-- 장바구니 코드, 대표이미지명(첨부된파일명)
-- 상품명, 가격 , 개수 , 총가격 

SELECT ITEM_NAME
	  , CART_CODE
	  , CART_CNT
	  , ITEM_PRICE
	  , ITEM_PRICE * CART_CNT AS TOTAL_PRICE
	  , ATTACHED_FILE_NAME
FROM SHOP_CART CART 
INNER JOIN shop_item ITEM INNER JOIN item_image IMG
ON CART.ITEM_CODE = ITEM.ITEM_CODE
INNER JOIN item_image IMG
ON IMG.ITEM_CODE = CART.ITEM_CODE 
WHERE MEMBER_ID = 'JAVA' 
AND IS_MAIN = 'Y';

-- 장바구니와 관련된 모든 정보를 조회할 수 있는 VIEW 생성

SELECT * FROM CART_VIEW;


CREATE OR REPLACE VIEW CART_VIEW
AS
SELECT CART_CODE
	, CART.ITEM_CODE
	, CART.MEMBER_ID
	, CART_CNT
	, CART_DATE
	 -- CART 테이블
	 , ITEM_NAME
	 , ITEM_PRICE
	 , ITEM_INTRO
	 , ITEM_PRICE * CART_CNT TOTAL_PRICE
	 -- 상품 테이블
	 , MEMBER_NAME
	 , MEMBER_TEL
	 -- 우편번호 나열 
	 , CONCAT(POST_CODE , ' ', MEMBER_ADDR , ' ', ADDR_DETAIL) ADDRESS
	 -- 이미지 테이블
	 , ATTACHED_FILE_NAME 
	 , ORIGIN_FILE_NAME
	 , IS_MAIN 
	 , IMG_CODE 
	 -- 카테고리 테이블 
	 , CATE.CATE_CODE
	 , CATE_NAME 
FROM shop_cart CART 
INNER JOIN shop_item ITEM 
ON CART.ITEM_CODE = ITEM.ITEM_CODE
INNER JOIN shop_member MEMBER
ON MEMBER.MEMBER_ID = CART.MEMBER_ID
INNER JOIN item_image IMG
ON IMG.ITEM_CODE = ITEM.ITEM_CODE
INNER JOIN item_category CATE
ON CATE.CATE_CODE = ITEM.CATE_CODE
WHERE IS_MAIN = 'Y'; 	 

-- 15514 울산 남구 그린아파트 ...	 
SELECT POST_CODE
	, MEMBER_ADDR
	, ADDR_DETAIL
	-- CONCAT() 문자열 나열 
	, CONCAT(POST_CODE , ' ', MEMBER_ADDR , ' ', ADDR_DETAIL)
FROM shop_member; 
	  
	  
-- 내 장바구니에 지금 추가하려는 상품이 있는지 확인

-- ID가 'JAVA'인 회원의 장바구니에 
-- ITEM_CODE가 1인 상품이 있는지 확인
-- COUNT
SELECT CART_CODE
FROM shop_cart
WHERE MEMBER_ID = 'hong' 
AND ITEM_CODE = 3;

DELETE FROM shop_cart;

DELETE FROM shop_cart

-- IN을 사용하면 여러가지 코드를 지우는것과 똑같음. 
-- EX) CART_CODE 1 OR CART_CODE 2 ...
WHERE CART_CODE IN (1, 2, 3);

-- 구매 정보 테이블

CREATE TABLE SHOP_BUY (
	BUY_CODE INT AUTO_INCREMENT PRIMARY KEY 
	, MEMBER_ID VARCHAR(20) NOT NULL REFERENCES shop_member (MEMBER_ID)
	, BUY_PRICE INT NOT NULL 
	, BUY_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- 구매 상세 정보 테이블
CREATE TABLE BUY_DETAIL (
	BUY_DETAIL_CODE INT AUTO_INCREMENT PRIMARY KEY 
	, ITEM_CODE INT NOT NULL REFERENCES shop_item (ITEM_CODE)
	, BUY_CNT INT NOT NULL
	, TOTAL_PRICE INT NOT NULL 
	, BUY_CODE INT NOT NULL REFERENCES SHOP_BUY (BUY_CODE)
);

DROP TABLE buy_detail;
DROP TABLE shop_buy;

SELECT * FROM shop_buy;
SELECT * FROM buy_detail;
SELECT * FROM board;

SELECT ITEM_CODE
	, CART_CNT
	, TOTAL_PRICE
FROM cart_view
WHERE CART_CODE IN ();

SELECT ITEM_CODE
		, CART_CNT
		, TOTAL_PRICE
FROM cart_view
WHERE CART_CODE = 4;

SELECT MAX(BUY_CODE) FROM shop_buy;

-- 구매 날짜 및 총 구매 금액
SELECT BUY_DATE
	, BUY_PRICE
FROM shop_buy
-- DESC 내림차순
ORDER BY BUY_DATE DESC;

-- 상품코드, 상품명, 대표이미지명, 구매수량 , 구매 가격

SELECT BUY.ITEM_CODE
	, BUY.BUY_CODE
	, BUY_CNT
	, TOTAL_PRICE
	, ATTACHED_FILE_NAME
	, ITEM_NAME
	, BUY_DATE
	, BUY_PRICE
FROM BUY_DETAIL BUY INNER JOIN shop_item ITEM
ON BUY.ITEM_CODE = ITEM.ITEM_CODE
INNER JOIN item_image IMG
ON BUY.ITEM_CODE = IMG.ITEM_CODE
INNER JOIN shop_buy SHOP
ON SHOP.BUY_CODE = BUY.BUY_CODE
WHERE IS_MAIN ='Y'
AND MEMBER_ID = 'HONG'; 

SELECT ITEM_CODE
	, (SELECT ITEM_NAME 
		FROM SHOP_ITEM
		WHERE ITEM_CODE = buy_detail.ITEM_CODE) ITEM_NAME
	, (SELECT ATTACHED_FILE_NAME
		FROM item_image
		WHERE ITEM_CODE = buy_detail.ITEM_CODE
		AND IS_MAIN = 'Y') ATTACHED_FILE_NAME
	, (SELECT BUY_DATE
		FROM shop_buy
		WHERE BUY_CODE = buy_detail.BUY_CODE) BUY_DATE
	, 	TOTAL_PRICE
	, 	BUY_CNT
FROM buy_detail;	
	
SELECT  BUY.BUY_CODE
		, MEMBER_ID
		, BUY_PRICE
		, BUY_DATE
		, BUY_CNT
		, TOTAL_PRICE
		, ITEM_NAME
		, ATTACHED_FILE_NAME	
FROM shop_buy BUY
INNER JOIN buy_detail DETAIL
ON BUY.BUY_CODE = DETAIL.BUY_CODE
INNER JOIN shop_item ITEM
ON ITEM.ITEM_CODE = DETAIL.ITEM_CODE
INNER JOIN item_image IMG
ON IMG.ITEM_CODE = ITEM.ITEM_CODE
WHERE IS_MAIN = 'Y'
AND BUY.BUY_CODE = 1;

-- 원하는 날짜의 구매 정보 조회
-- 둘다 문자로 바꾸거나, DATE로 바꾸거나

SELECT * FROM shop_buy
WHERE BUY_DATE > '2024-02-02';

-- 문자열 -> 날짜 
-- SELECT NOW : SELECT 한 날짜를 보여줌 
-- Y : 소문자일 경우 형식에 맞지 않아 데이터 조회 X
SELECT NOW()
	, STR_TO_DATE('2024-01-01','%Y-%m-%d');
	
SELECT * FROM shop_buy
WHERE DATE_FORMAT(BUY_DATE,'%Y-%m-%d') = '2024-02-02';
	
-- 날짜 -> 문자열
-- DATE_FORMAT => 날짜를 문자형식으로 교체
SELECT BUY_DATE
	, DATE_FORMAT(BUY_DATE,'%Y-%m-%d')
	, DATE_FORMAT(BUY_DATE,'%Y-%m-%d %h:%i:%s')
	, DATE_FORMAT(BUY_DATE,'%Y')
FROM shop_buy;

SELECT DATE_FORMAT(BUY_DATE,'%Y-%m-%d %h:%i') BUY_DATE
	, BUY_CODE
FROM shop_buy;

SELECT BUY_CODE
	, MEMBER_ID 
	, BUY_PRICE
	, BUY_DATE
FROM shop_buy
WHERE BUY_CODE LIKE ''
AND DATE_FORMAT(BUY_DATE, '%Y-%m-%d') >= '?'
AND DATE_FORMAT(BUY_DATE, '%Y-%m-%d') >= '?';


SELECT ITEM_CODE 
	, ITEM_NAME
	, ITEM_STOCK
	, ITEM_STATUS
	, IF(ITEM_STATUS = 1 , '준비중' , IF(ITEM_STATUS = 2, '판매중', '매진')) AS '상태1'
	, CASE
		WHEN ITEM_STATUS = 1 THEN '준비 중' 
		WHEN ITEM_STATUS = 2 THEN '판매 중' 
		ELSE '매진' 
		END AS '상태2'
FROM shop_item;

SELECT CATE_NAME
	, CATE.CATE_CODE
	, ITEM_NAME
	, ITEM_STOCK
	, ITEM_STATUS
	, ITEM.ITEM_CODE
	, ORIGIN_FILE_NAME
	, ATTACHED_FILE_NAME
	, IMG_CODE
FROM shop_item ITEM 
INNER JOIN item_category CATE
ON ITEM.CATE_CODE = CATE.CATE_CODE
INNER JOIN item_image IMG
ON ITEM.ITEM_CODE = IMG.ITEM_CODE
WHERE ITEM.ITEM_CODE = 1;


CREATE TABLE PYTHON_BOARD (
	BOARD_NUM INT PRIMARY KEY
	, TITLE VARCHAR(50)
	, WRITER VARCHAR(50)
	, READ_CNT INT
);

SELECT * FROM PYTHON_BOARD;