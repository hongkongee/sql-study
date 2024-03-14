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

/*
문제 8.
departments테이블 locations테이블을 left 조인하세요
조건) 부서아이디, 부서이름, 매니저아이디, 로케이션아이디, 스트릿_어드레스, 포스트 코드, 시티 만 출력합니다
조건) 부서아이디 기준 오름차순 정렬
*/
SELECT
    d.department_id, d.department_name, d.manager_id, d.location_id,
    loc.street_address, loc.postal_code, loc.city
FROM departments d
LEFT JOIN locations loc
ON d.location_id = loc.location_id
ORDER BY department_id;

/*
문제 9.
문제 8의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
*/

SELECT
    d.department_id, d.department_name, d.manager_id, d.location_id,
    (
        SELECT loc.street_address
        FROM locations loc
        WHERE d.location_id = loc.location_id
    ) AS street_address,

    (
        SELECT loc.postal_code
        FROM locations loc
        WHERE d.location_id = loc.location_id
    ) AS postal_code,
    
    (
        SELECT loc.city
        FROM locations loc
        WHERE d.location_id = loc.location_id
    ) AS city

FROM departments d
ORDER BY department_id;




/*
문제 10.
locations테이블 countries 테이블을 left 조인하세요
조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
조건) country_name기준 오름차순 정렬
*/
SELECT
    loc.location_id, loc.street_address, loc.city,
    c.country_id, c.country_name
FROM locations loc
LEFT JOIN countries c
ON loc.country_id = c.country_id
ORDER BY country_name;



/*
문제 11.
문제 10의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
*/

SELECT
    loc.location_id, loc.street_address, loc.city, loc.country_id,
       
    (
        SELECT c.country_name
        FROM countries c
        WHERE loc.country_id = c.country_id
    ) AS country_name

FROM locations loc
ORDER BY country_name;

/*
문제 12. 
employees테이블, departments테이블을 left조인 hire_date를 오름차순 기준으로 
11-20번째 데이터만 출력합니다.
조건) rownum을 적용하여 번호, 직원아이디, 이름, 전화번호, 입사일, 
부서아이디, 부서이름 을 출력합니다.
조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 틀어지면 안됩니다.
*/
SELECT *
FROM
    (
    SELECT
        ROWNUM AS rn, tbl.*    
    FROM
        (
        SELECT 
            e.employee_id, e.first_name, e.phone_number, e.hire_date,
            d.department_id, d.department_name
        FROM employees e
        LEFT JOIN departments d
        ON e.department_id = d.department_id
        ORDER BY e.hire_date
        ) tbl
    )
WHERE rn BETWEEN 11 AND 20;

/*
문제 13. 
--EMPLOYEES 와 DEPARTMENTS 테이블에서 JOB_ID가 SA_MAN 사원의 정보의 LAST_NAME, JOB_ID, 
DEPARTMENT_ID,DEPARTMENT_NAME을 출력하세요.
*/

SELECT
    tbl.*,
    d.department_name
FROM
    (
    SELECT
        last_name, job_id, department_id
    FROM employees
    WHERE job_id = 'SA_MAN'
    ) tbl
JOIN departments d
ON tbl.department_id = d.department_id;

--SELECT
--    e.last_name, e.job_id, e.department_id,
--    (
--        SELECT d.department_name
--        FROM departments d
--        WHERE d.department_id = e.department_id
--    ) AS department_name
--FROM employees e
--WHERE e.job_id = 'SA_MAN';


/*
문제 14
-- DEPARTMENTS 테이블에서 각 부서의 ID, NAME, MANAGER_ID와 부서에 속한 인원수를 출력하세요.
-- 인원수 기준 내림차순 정렬하세요.
-- 사람이 없는 부서는 출력하지 않습니다.
*/

SELECT
    d.department_id, d.department_name, d.manager_id, a.total
FROM departments d
JOIN 
    (
    SELECT
        department_id, COUNT(*) AS total
    FROM employees
    GROUP BY department_id
    ) a
ON d.department_id = a.department_id
ORDER BY a.total DESC;


SELECT
    d.department_id, d.department_name, d.manager_id,
    (
        SELECT COUNT(*)
        FROM employees e
        WHERE e.department_id = d.department_id
    ) AS total
FROM departments d
-- WHERE d.manager_id IS NOT NULL
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
) -- 부서에서 manager_id는 없지만 total은 존재 -> 조회 대상인 경우
ORDER BY total DESC;



/*
문제 15 (어려움)
--부서에 대한 정보 전부와, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요.
--부서별 평균이 없으면 0으로 출력하세요.
*/



SELECT 
    d.*,
    loc.street_address, loc.postal_code,
    NVL(tbl.result, 0) AS 부서별평균급여
FROM departments d
JOIN locations loc
ON d.location_id = loc.location_id
LEFT JOIN (
    SELECT
        department_id,
        TRUNC(AVG(salary), 0) AS result
    FROM employees
    GROUP BY department_id
) tbl
ON d.department_id = tbl.department_id
ORDER BY tbl.result;

---------------------------------------------------------
SELECT 
    d.*,
    loc.street_address, loc.postal_code,
    NVL((
        SELECT
            TRUNC(AVG(salary), 0)
        FROM employees e
        WHERE e.department_id = d.department_id
    ), 0) AS 부서별평균급여
FROM departments d
JOIN locations loc
ON d.location_id = loc.location_id
ORDER BY 부서별평균급여 DESC;

---------------------------------------------------------       
SELECT
    tbl.department_id, tbl.department_name, tbl.manager_id, tbl.location_id,
    tbl.address, tbl.postal_code,
    NVL(tbl.avg_salary, 0) AS 평균급여

FROM
    (
    SELECT
        d.*,
        
        (
            SELECT loc.street_address
            FROM locations loc
            WHERE d.location_id = loc.location_id
        ) AS address,
        
        (
            SELECT loc.postal_code
            FROM locations loc
            WHERE d.location_id = loc.location_id
        ) AS postal_code,
        
        
        (
            SELECT AVG(salary)
            FROM employees e
            WHERE e.department_id = d.department_id
        ) AS avg_salary
        
    FROM departments d
    ) tbl;
   


/*
문제 16
-문제 15 결과에 대해 DEPARTMENT_ID기준으로 내림차순 정렬해서 
ROWNUM을 붙여 1-10 데이터 까지만 출력하세요.
*/

SELECT * FROM
    (
    SELECT ROWNUM AS rn, tbl2.*
        FROM
        (
        SELECT 
            d.*,
            loc.street_address, loc.postal_code,
            NVL(tbl.result, 0) AS 부서별평균급여
        FROM departments d
        JOIN locations loc
        ON d.location_id = loc.location_id
        LEFT JOIN (
            SELECT
                department_id,
                TRUNC(AVG(salary), 0) AS result
            FROM employees
            GROUP BY department_id
        ) tbl
        ON d.department_id = tbl.department_id
        ORDER BY d.department_id DESC
        ) tbl2
    )
WHERE rn > 0 AND rn <= 10;

-----------------------------------------------------
SELECT * FROM
    (
    SELECT
        ROWNUM AS rn,
        tbl.department_id, tbl.department_name, tbl.manager_id, tbl.location_id,
        tbl.address, tbl.postal_code,
        NVL(tbl.avg_salary, 0) AS 평균급여
    
    FROM
        (
        SELECT
            d.*,
            
            (
                SELECT loc.street_address
                FROM locations loc
                WHERE d.location_id = loc.location_id
            ) AS address,
            
            (
                SELECT loc.postal_code
                FROM locations loc
                WHERE d.location_id = loc.location_id
            ) AS postal_code,
            
            
            (
                SELECT AVG(salary)
                FROM employees e
                WHERE e.department_id = d.department_id
            ) AS avg_salary
            
        FROM departments d
        ) tbl
    ORDER BY tbl.department_id DESC
    )
WHERE rn >= 1 AND rn < 11;