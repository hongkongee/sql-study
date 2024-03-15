
/*
# PL/SQL
- 오라클에서 제공하는 SQL 프로그래밍 기능이다.
- 일반적인 프로그래밍과는 차이가 있지만, 오라클 내부에서 적절한 처리를 위해
 적용해 줄 수 있는 절차지향적 코드 작성 방식입니다.
- 쿼리문의 집합으로 어떠한 동작을 일괄 처리하기 위한 용도로 사용합니다.
*/

SET SERVEROUTPUT ON; -- 출력문 활성화

-- 익명 블록 설정
DECLARE -- 변수를 선언하는 구간 (선언부)
    
    emp_num NUMBER; -- 변수 선언
    
BEGIN -- 코드를 실행하는 구간 (실행부)
    
    emp_num := 10; -- 대입 연산자 :=
    DBMS_OUTPUT.put_line(emp_num);
    DBMS_OUTPUT.put_line('Hello pl/sql');

END; -- PL/SQL이 끝나는 구간 (종료부)

/*
- DML문
DDL문은 사용이 불가능하고, 일반적으로 SQL문의 SELECT 등을 사용하는데, 
특이한 점은 SELECT절 아래에 INTO절을 사용해서 변수에 할당할 수 있습니다.
*/

DECLARE
    v_emp_name VARCHAR2(50); -- 사원명 변수 (문자열 타입은 길이제약 필요)
    v_dep_name departments.department_name%TYPE; -- 부서명 변수
BEGIN
    SELECT
        first_name,
        department_name
    INTO
        v_emp_name, v_dep_name -- 조회 결과를 변수에 대입
    FROM employees e
    LEFT JOIN departments d
    ON e.department_id = d.department_id
    WHERE e.employee_id = 103;
    
    DBMS_output.put_line(v_emp_name || '-' || v_dep_name);
END;

-- 2. employees 테이블에서 사원번호가 제일 큰 사원을 찾아낸 뒤 (MAX 함수 사용)
-- 이 번호 + 1번으로 아래의 사원을 emps 테이블에
-- employee_id, last_name, email, hire_date, job_id를 신규 삽입하는 익명 블록을 만드세요.
-- SELECT절 이후에 INSERT문 사용이 가능합니다.
/*
<사원명>: steven
<이메일>: stevenjobs
<입사일자>: 오늘날짜
<JOB_ID>: CEO
*/

DECLARE
    maxnum employees.employee_id%TYPE;
BEGIN
    SELECT
        MAX(employee_id) + 1
    INTO
        maxnum
    FROM employees;
    
    INSERT INTO emps
        (employee_id, last_name, email, hire_date, job_id)
    VALUES(maxnum, 'steven', 'stevenjobs', sysdate, 'CEO');
END;

SELECT * FROM emps;




