CREATE TABLE MEMBER (
	MEMBER_CODE INT AUTO_INCREMENT PRIMARY KEY
	,MEMBER_NAME VARCHAR(20) NOT NULL
	,MEMBER_ID VARCHAR(20) NOT NULL UNIQUE
	,MEMBER_PW VARCHAR(50) NOT NULL
	,MEMBER_EMAIL VARCHAR(30) NOT NULL
	,MEMBER_TEL VARCHAR(30) NOT NULL
	,MEMBER_ADDR VARCHAR(50) NOT NULL
	,ADDR_DETAIL VARCHAR(30) NOT NULL
	,MEMBER_ROLL VARCHAR(20) NOT NULL DEFAULT 'USER'
	,JOIN_DATE DATETIME DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM MEMBER;