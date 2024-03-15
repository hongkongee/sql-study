
-- 사용자 계정 확인
SELECT * FROM all_users;

-- 계정 생성 명령
CREATE USER user1 IDENTIFIED BY user1;

/*
DCL: GRANT(권한 부여), REVOKE(권한 회수)

CREATE USER -> 데이터베이스 유저 생성 권한
CREATE SESSION -> 데이터베이스 접속 권한
CREATE TABLE -> 테이블 생성 권한
CREATE VIEW -> 뷰 생성 권한
CREATE SEQUENCE -> 시퀀스 생성 권한
ALTER ANY TABLE -> 어떠한 테이블도 수정할 수 있는 권한
INSERT ANY TABLE -> 어떠한 테이블에도 데이터를 삽입하는 권한.
SELECT ANY TABLE...

SELECT ON [테이블 이름] TO [유저 이름] -> 특정 테이블만 조회할 수 있는 권한.
INSERT ON....
UPDATE ON....

- 관리자에 준하는 권한을 부여하는 구문.
RESOURCE, CONNECT, DBA TO [유저 이름]
*/

GRANT CREATE SESSION TO user1;

GRANT SELECT ON hr.departments TO user1; -- 특정 테이블에 대한 select 권한 부여
GRANT INSERT ON hr.departments TO user1; -- 특정 테이블에 대한 insert 권한 부여

INSERT INTO hr.departments VALUES(300, 'test', 100, 1800);

GRANT CREATE TABLE TO user1; -- table 생성 권한 부여

GRANT RESOURCE, CONNECT, DBA TO user1;

REVOKE RESOURCE, CONNECT, DBA FROM user1; -- 권한 뺏기

-- 테이블이 저장되는 장소인 테이블 스페이스를 설정하는 코드
-- 기본적으로 제공되는 users 테이블 스페이스의 사용량을 무제한으로 지정.
ALTER USER user1
DEFAULT TABLESPACE users
QUOTA UNLIMITED ON users;

-- 사용자 계정 삭제
-- 현재 연결된 계정은 drop 불가능
-- DROP USER [유저이름] CASCADE;
-- CASCADE 없을 시 -> 테이블 or 시퀀스 등 객체가 존재한다면 계정 삭제 안됨.
DROP USER user1 CASCADE;





