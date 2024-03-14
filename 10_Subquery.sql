/*
# 서브쿼리 
: SQL 문장 안에 또다른 SQL을 포함하는 방식.
 여러 개의 질의를 동시에 처리할 수 있습니다.
 WHERE, SELECT, FROM 절에 작성이 가능합니다.

- 서브쿼리의 사용방법은 () 안에 명시함.
 서브쿼리절의 리턴행이 1줄 이하여야 합니다.
- 서브쿼리 절에는 비교할 대상이 하나 반드시 들어가야 합니다.
- 해석할 때는 서브쿼리절 부터 먼저 해석하면 됩니다.
*/

-- 이름이 'Nancy'인 사원보다 급여가 높은 사원을 구하기
SELECT salary FROM employees
WHERE first_name = 'Nancy';

SELECT first_name FROM employees
WHERE salary > 12008;

-- 서브쿼리를 활용한 문장
SELECT first_name FROM employees
WHERE salary > (SELECT salary FROM employees
                WHERE first_name = 'Nancy');
                
-- employee_id가 103번인 사람의 job_id와 동일한 job_id를 가진 사람을 조회.
SELECT * FROM employees
WHERE job_id = (SELECT job_id FROM employees
                WHERE employee_id = 103);

-- 다음 문장은 서브쿼리가 리턴하는 행이 여러 개라서 단일행 연산자를 사용할 수 없습니다.
-- 단일 행 연산자: 주로 비교 연산자(=, >, <, <=, >=, <>)를 사용하는 경우 하나의 행만 반환해야 합니다.
-- 이런 경우에는 다중 행 연산을 사용해야 합니다.
SELECT * FROM employees
WHERE job_id = (SELECT job_id FROM employees
                WHERE last_name = 'King'); -- 에러

-- 다중 행 연산자 (IN, ANY, ALL, EXISTS)

-- IN: 조회된 목록의 어떤 값과 같은지를 비교합니다.
SELECT * FROM employees
WHERE job_id IN (SELECT job_id FROM employees
                WHERE last_name = 'King');
                
-- first_name이 David인 사람들의 급여와 같은 급여를 받는 사람들을 조회
SELECT * FROM employees
WHERE salary IN (SELECT salary FROM employees
                WHERE first_name = 'David');

-- ANY, SOME: 값을 서브쿼리에 의해 리턴된 각각의 값과 비교해서
-- 하나라도 만족하면 조회 대상에 포함됩니다.
-- David라는 사람이 여러 명인데, 그 중에 가장 적은 급여를 받는 David보다 급여가 높은 사람을 조회
SELECT * FROM employees
WHERE salary > ANY (SELECT salary FROM employees
                WHERE first_name = 'David');


-- ALL: 값을 서브쿼리에 의해 리턴된 각각의 값과 모두 비교해서
-- 전부 다 일치해야 조회대상에 포함됩니다.
-- David라는 사람이 여러 명인데, 그 중에 가장 많은 급여를 받는 David보다 급여가 높은 사람을 조회
SELECT * FROM employees
WHERE salary > ALL (SELECT salary FROM employees
                WHERE first_name = 'David');

-- EXISTS: 서브쿼리가 하나 이상의 행을 반환하면 참으로 간주.
-- job_history에 존재하는 직원이 employees에도 존재한다면 조회대상에 포함
-- 서브쿼리 내에서 jh에 있는 id와 e에 있는 id가 일치할 때마다 1이라는 값을 조회
-- EXISTS 연산자가 1이 조회가 될 때 데이터가 존재한다는 것을 판단하여 employees에서 해당 사원의 모든 정보를 조회
SELECT * FROM employees e
WHERE EXISTS (SELECT 1 FROM job_history jh
                WHERE e.employee_id = jh.employee_id);
                
select * from job_history;
                
SELECT * FROM employees e
WHERE EXISTS (SELECT 1 FROM departments d
                WHERE e.department_id = d.department_id);
                
                
-----------------------------------------------------------------
-- SELECT 절에 서브쿼리 붙이기
-- 스칼라 서브쿼리 라고도 칭합니다.
-- 스칼라 서브쿼리: 실행 결과가 단일 값을 반환하는 서브쿼리. 주로 SELECT절이나, WHERE 절에서 사용됨

SELECT
    e.first_name,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.first_name;

SELECT
    e.first_name,
    (
        SELECT
            department_name
        FROM departments d
        WHERE d.department_id = e.department_id
    ) AS department_name
FROM employees e
ORDER BY e.first_name;

-- 각 부서의 매니저 이름 조회
SELECT
    d.*,
    e.first_name AS manager_name
FROM departments d
LEFT JOIN employees e
ON d.manager_id = e.employee_id
ORDER BY d.manager_id; -- LEFT JOIN

SELECT
    d.*,
    (
        SELECT 
            first_name
        FROM employees e
        WHERE e.employee_id = d.manager_id
    ) AS manager_name
FROM departments d
ORDER BY d.manager_id;

/*
- 스칼라 서브쿼리가 조인보다 좋은 경우
: 함수처럼 한 레코드당 정확히 하나의 값만을 리턴할 때.

- 조인이 스칼라 서브쿼리보다 좋은 경우
: 조회할 컬럼이나 데이터가 대용량인 경우, 해당 데이터가
수정, 삭제 등이 빈번한 경우 (sql 가독성이 조인이 좀 더 뛰어납니다.)
*/

-- 각 부서별 사원 수 뽑기 (스칼라)
SELECT
    d.*,
    (
        SELECT
            COUNT(*)
        FROM employees e
        WHERE d.department_id = e.department_id
    ) AS 사원수
FROM departments d;

SELECT
    d.department_name AS 부서명,
    COUNT(e.employee_id) AS 사원수
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY e.department_id, d.department_name
ORDER BY 사원수 DESC;

-- 인라인 뷰 (FROM 구문에 서브쿼리가 오는 것.)
-- 특정 테이블 전체가 아닌 SELECT를 통해 일부 데이터를 조회한 것을 가상 테이블로 사용하고 싶을 때. 
-- 순번을 정해놓은 조회 자료를 범위를 지정해서 가지고 오는 경우.

-- salary로 정렬을 진행하면서 바로 ROWNUM을 붙이면
-- ROWNUM이 정렬이 되지 않는 상황이 발생합니다.
-- 이유: ROWNUM이 먼저 붙고 정렬이 진행되기 때문. ORDER BY는 항상 마지막에 진행.
-- 해결: 정렬이 미리 진행된 자료에 ROWNUM을 붙여서 다시 조회하는 것이 좋을 것 같아요.
SELECT
    employee_id, first_name, salary, ROWNUM AS rn
FROM employees
ORDER BY salary DESC;

-- ROWNUM을 붙이고 나서 범위를 지정해서 조회하려고 하는데,
-- 범위 지정도 불가능하고, 지목할 수 없는 문제가 발생하더라.
-- 이유: WHERE절부터 먼저 실행하고 나서 ROWNUM이 SELECT 되기 때문에.
-- 해결: ROWNUM까지 붙여 놓고 다시 한 번 자료를 SELECT 해서 범위를 지정해야 되겠구나.
SELECT
    ROWNUM AS rn, tbl.*
    FROM
    (
    SELECT
        employee_id, first_name, salary
    FROM employees
    ORDER BY salary DESC
    ) tbl
WHERE rn > 10 AND rn <= 20; -- error

/*
가장 안쪽 SELECT 절에서 필요한 테이블 형식(인라인 뷰)을 생성.
바깥쪽 SELECT 절에서 ROWNUM을 붙여서 다시 조회
가장 바깥쪽 SELECT 절에서는 이미 붙어있는 ROWNUM의 범위를 지정해서 조회.

** SQL의 실행 순서
FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
*/
SELECT *
    FROM
    (
    SELECT
        ROWNUM AS rn, tbl.*
        FROM
        (
        SELECT
            employee_id, first_name, salary
        FROM employees
        ORDER BY salary DESC
        ) tbl
    )
WHERE rn > 10 AND rn <= 20;


SELECT 
    e.employee_id, e.salary, 
    avg_salaries.average_salary
FROM 
    employees e 
    INNER JOIN 
        (SELECT 
            department_id, 
            AVG(salary) AS average_salary 
        FROM employees 
        GROUP BY department_id) avg_salaries
ON e.department_id = avg_salaries.department_id;

