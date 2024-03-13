/*
문제 1.
-EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들의 데이터를 출력 하세요 
(AVG(컬럼) 사용)
-EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들의 수를 출력하세요
-EMPLOYEES 테이블에서 job_id가 IT_PROG인 사원들의 평균급여보다 높은 사원들의 
데이터를 출력하세요
*/

SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary)
        FROM employees)
ORDER BY salary;

SELECT COUNT(*)
FROM employees
WHERE salary > (SELECT AVG(salary)
        FROM employees)
ORDER BY salary;

SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees
                WHERE job_id = 'IT_PROG');
                

/*
문제 2.
-DEPARTMENTS테이블에서 manager_id가 100인 부서에 속해있는 사람들의
모든 정보를 출력하세요.
*/
SELECT *
FROM employees
WHERE department_id = (SELECT department_id
                        FROM departments
                        WHERE manager_id = 100);


/*
문제 3.
-EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 
출력하세요
-EMPLOYEES테이블에서 “James”(2명)들의 manager_id를 갖는 모든 사원의 데이터를 출력하세요.
*/
SELECT *
FROM employees
WHERE manager_id > (SELECT manager_id
                    FROM employees
                    WHERE first_name = 'Pat');
                    
SELECT *
FROM employees
WHERE manager_id IN (SELECT manager_id
                    FROM employees
                    WHERE first_name = 'James');


/*
문제 4.
-EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 
행 번호, 이름을 출력하세요
*/
SELECT *
FROM
    (
    SELECT 
        ROWNUM AS rn, tbl.first_name
    FROM
        (
        SELECT *
        FROM employees
        ORDER BY first_name DESC
        ) tbl
    )
WHERE rn BETWEEN 41 AND 50;
    

/*
문제 5.
-EMPLOYEES테이블에서 hire_date기준으로 오름차순 정렬하고, 31~40번째 데이터의 
행 번호, 사원id, 이름, 전화번호, 입사일을 출력하세요.
*/

SELECT *
FROM
    (
    SELECT
        ROWNUM as rn, employee_id, first_name, phone_number, hire_date
    FROM
        (
        SELECT *
        FROM employees
        ORDER BY hire_date
        )
    )
WHERE rn BETWEEN 31 AND 40;

/*
문제 6.
employees테이블 departments테이블을 left 조인하세요
조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
조건) 직원아이디 기준 오름차순 정렬
*/

SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS name,
    d.department_id,
    d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.employee_id;


/*
문제 7.
문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
*/

SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS name,
    e.department_id,
    (
        SELECT
           d.department_name
        FROM departments d 
        WHERE e.department_id = d.department_id
    ) AS 부서명
FROM employees e
ORDER BY e.employee_id;

