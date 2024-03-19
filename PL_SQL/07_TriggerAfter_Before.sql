
/*
AFTER 트리거 - INSERT, UPDATE, DELETE 작업 이후에 동작하는 트리거를 의미합니다.
BEFORE 트리거 - INSERT, UPDATE, DELETE 작업 이전에 동작하는 트리거를 의미합니다.

:OLD = 참조 전 열의 값 (INSERT: 입력 전 자료, UPDATE: 수정 전 자료, DELETE: 삭제될 값)
:NEW = 참조 후 열의 값 (INSERT: 입력 할 자료, UPDATE: 수정 된 자료)

테이블에 UPDATE나 DELETE를 시도하면 수정, 또는 삭제된 데이터를
별도의 테이블에 보관해 놓는 형식으로 트리거를 많이 사용합니다.

트리거 자체를 트랜잭션의 일부로 처리하기 때문에 COMMIT이나 ROLLBACK을 포함 할 수 없습니다.
*/

CREATE TABLE tbl_user(
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30)
);

CREATE TABLE tbl_user_backup(
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30),
    update_date DATE DEFAULT sysdate, -- 정보 변경 시간(기본값: INSERT 되는 시간)
    m_type VARCHAR2(10), -- 변경 타입
    m_user VARCHAR2(20) -- 변경한 사용자
);

-- AFTER 트리거
CREATE OR REPLACE TRIGGER trg_user_backup
    AFTER UPDATE OR DELETE
    ON tbl_user
    FOR EACH ROW
DECLARE
    v_type VARCHAR2(10);
BEGIN
    -- 현재 트리거가 발동된 상황이 UPDATE인지 DELETE인지를 파악하는 조건문
    IF UPDATING THEN -- UPDATING은 시스템 자체에서 상태에 대한 내용을 지원하는 빌트인 구문
        v_type := '수정';
    ELSIF DELETING THEN
        v_type := '삭제';
    END IF;
    
    -- 본격적인 실행 구문 작성 (backup 테이블에 값을 INSERT
    -- -> 원본 테이블에서 UPDATE or DELETE 된 사용자의 정보 및 기타 정보)
    
    INSERT INTO tbl_user_backup
    VALUES(:OLD.id, :OLD.name, :OLD.address, sysdate, v_type, USER());
END;

-- 확인!
INSERT INTO tbl_user VALUES('test01', 'kim', '서울');
INSERT INTO tbl_user VALUES('test02', 'lee', '경기');
INSERT INTO tbl_user VALUES('test03', 'hong', '부산');

SELECT * FROM tbl_user;
SELECT * FROM tbl_user_backup;

UPDATE tbl_user SET address = '인천' WHERE id = 'test01';
DELETE FROM tbl_user WHERE id = 'test02';

-- BEFORE 트리거
CREATE OR REPLACE TRIGGER trg_user_insert
    BEFORE INSERT
    ON tbl_user
    FOR EACH ROW
BEGIN
    -- INSERT 예정인 name의 값에서 첫글자만 추출 후 뒤에 *을 3개 붙이겠다.
    :NEW.name := SUBSTR(:NEW.name, 1, 1) || '***';
END;

INSERT INTO tbl_user VALUES('test04', '메롱이', '대전');
INSERT INTO tbl_user VALUES('test05', '김오라클', '광주');

SELECT * FROM tbl_user;
ROLLBACK;

--------------------------------------------------------------------------------
-- 주문 히스토리
CREATE TABLE order_history (
    history_no NUMBER(5) PRIMARY KEY,
    order_no NUMBER(5),
    product_no NUMBER(5),
    total NUMBER(10),
    price NUMBER(10)
);

-- 상품
CREATE TABLE product(
    product_no NUMBER(5) PRIMARY KEY,
    product_name VARCHAR2(20),
    total NUMBER(5),
    price NUMBER(5)
);

CREATE SEQUENCE order_history_seq NOCYCLE NOCACHE;
CREATE SEQUENCE product_seq NOCYCLE NOCACHE;


INSERT INTO product VALUES(product_seq.NEXTVAL, '피자', 100, 10000);
INSERT INTO product VALUES(product_seq.NEXTVAL, '치킨', 100, 20000);
INSERT INTO product VALUES(product_seq.NEXTVAL, '햄버거', 10, 5000);

SELECT * FROM product;

-- 주문 히스토리에 데이터가 들어오면 실행하는 트리거
CREATE OR REPLACE TRIGGER trg_order_history
    BEFORE INSERT
    ON order_history
    FOR EACH ROW
DECLARE
    v_total NUMBER;
    v_product_no NUMBER;
    v_product_total NUMBER;
    quantity_shortage_exception EXCEPTION;
    zero_total_exception EXCEPTION;
BEGIN
    dbms_output.put_line('트리거 실행!');
    
    v_total := :NEW.total; -- 주문 수량을 얻어옴
    v_product_no := :NEW.product_no; -- 주문 상품의 번호를 얻어옴
    
    SELECT
        total
    INTO v_product_total -- 재고 수량
    FROM product
    WHERE product_no = v_product_no; -- 상품 번호를 가지고 재고 수량을 조회 -> 할당
    
    IF v_product_total <= 0  THEN -- 재고가 없는 경우
        RAISE zero_total_exception;
    ELSIF v_total > v_product_total THEN -- 주문 수량이 재고 수량보다 많은 경우
        RAISE quantity_shortage_exception; 
    END IF;
    
    
    -- 재고수량이 넉넉하다면 주문수량만큼 재고수량을 조정
    UPDATE product
    SET total = total - v_total
    WHERE product_no = v_product_no;
    
    EXCEPTION
        WHEN quantity_shortage_exception THEN
            -- 오라클에서 제공하는 사용자 정의 예외를 발생시키는 함수
            -- 첫번째 매개값: 에러 코드 (사용자 정의 예외 -20000 ~ -20999까지)
            -- 두번째 매개값: 에러 메세지
            RAISE_APPLICATION_ERROR(-20001, '주문하신 수량보다 재고가 적어서 주문할 수 없습니다.');
        WHEN zero_total_exception THEN
            RAISE_APPLICATION_ERROR(-20002, '주문하신 상품의 재고가 없어 주문할 수 없습니다.');        
END;


INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 200, 1, 5, 50000);
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 200, 2, 1, 20000);
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 200, 3, 5, 25000);

SELECT * FROM order_history;
SELECT * FROM product;
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 201, 3, 5, 25000);
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 202, 3, 5, 25000);

-- 트리거 내에서 예외가 발생하면 수행중인 INSERT 작업은 중단되며 ROLLBACK이 진행됩니다.
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 203, 1, 100, 1000000);
SELECT order_history_seq.CURRVAL FROM dual;
