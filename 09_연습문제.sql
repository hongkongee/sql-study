/*
문제 1.
-EMPLOYEES 테이블과, DEPARTMENTS 테이블은 DEPARTMENT_ID로 연결되어 있습니다.
-EMPLOYEES, DEPARTMENTS 테이블을 엘리어스를 이용해서
각각 INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER 조인 하세요. (달라지는 행의 개수 주석으로 작성)
*/

SELECT -- INNER
    *
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id; -- 106

SELECT -- LEFT OUTER
    e.employee_id, e.first_name,
    d.department_id, d.department_name
FROM employees e
LEFT OUTER JOIN departments d
ON e.department_id = d.department_id; -- 107

SELECT -- RIGHT OUTER
    e.employee_id, e.first_name,
    d.department_id, d.department_name
FROM employees e
RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id; -- 122

SELECT -- FULL OUTER
    e.employee_id, e.first_name,
    d.department_id, d.department_name
FROM employees e
FULL OUTER JOIN departments d
ON e.department_id = d.department_id; -- 123


/*
문제 2.
-EMPLOYEES, DEPARTMENTS 테이블을 INNER JOIN하세요
조건)employee_id가 200인 사람의 이름, department_name를 출력하세요
조건)이름 컬럼은 first_name과 last_name을 합쳐서 출력합니다
*/

SELECT -- INNER
    e.first_name || ' ' || e.last_name AS name,
    d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id
WHERE e.employee_id = 200;


/*
문제 3.
-EMPLOYEES, JOBS테이블을 INNER JOIN하세요
조건) 모든 사원의 이름과 직무아이디, 직무 타이틀을 출력하고, 이름 기준으로 오름차순 정렬
HINT) 어떤 컬럼으로 서로 연결되어 있는지 확인
*/

SELECT
    e.first_name, e.job_id, j.job_title
FROM employees e
INNER JOIN jobs j
ON e.job_id = j.job_id
ORDER BY e.first_name;



/*
문제 4.
--JOBS테이블과 JOB_HISTORY테이블을 LEFT_OUTER JOIN 하세요.
*/

SELECT
    *
FROM jobs j
LEFT OUTER JOIN job_history jh
ON j.job_id = jh.job_id;

select * from jobs;
select * from job_history;


/*
문제 5.
--Steven King의 부서명을 출력하세요.
*/
SELECT
    e.first_name || ' ' || e.last_name AS name,
    d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE first_name = 'Steven' 
AND last_name = 'King';



/*
문제 6.
--EMPLOYEES 테이블과 DEPARTMENTS 테이블을 Cartesian Product(Cross join)처리하세요
*/
SELECT * FROM employees
CROSS JOIN departments;
-- 107 * 27 = 2889

/*
문제 7.
--EMPLOYEES 테이블과 DEPARTMENTS 테이블의 부서번호를 조인하고 SA_MAN 사원만의 사원번호, 이름, 
급여, 부서명, 근무지를 출력하세요. (Alias를 사용)
*/
select * from employees;
select * from departments;
select * from locations;
select * from jobs;

SELECT
    e.employee_id, e.first_name, e.salary, 
    d.department_name, loc.city
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations loc
ON d.location_id = loc.location_id
WHERE e.job_id = 'SA_MAN';


/*
문제 8.
-- employees, jobs 테이블을 조인 지정하고 job_title이 'Stock Manager', 'Stock Clerk'인 
직원 정보만 출력하세요.
*/

SELECT 
    *
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
WHERE j.job_title = 'Stock Manager'
OR j.job_title = 'Stock Clerk';

/*
문제 9.
-- departments 테이블에서 직원이 없는 부서를 찾아 출력하세요. LEFT OUTER JOIN 사용
*/

SELECT
    d.department_name
FROM departments d
LEFT JOIN employees e
ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;


/*
문제 10. 
-join을 이용해서 사원의 이름과 그 사원의 매니저 이름을 출력하세요
힌트) EMPLOYEES 테이블과 EMPLOYEES 테이블을 조인하세요.
*/



SELECT
    e1.first_name,
    e2.first_name
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.employee_id;


/*
문제 11. 
-- EMPLOYEES 테이블에서 left join하여 관리자(매니저)id와, 매니저의 이름, 매니저의 급여 까지 출력하세요.
-- 매니저 아이디가 없는 사람은 배제하고 급여는 역순으로 정렬하세요.
*/

SELECT
    e1.manager_id,
    e2.first_name AS 매니저이름,
    e2.salary AS 매니저급여
FROM employees e1
LEFT JOIN employees e2
ON e1.manager_id = e2.employee_id
WHERE e1.manager_id IS NOT NULL
ORDER BY e2.salary DESC;


