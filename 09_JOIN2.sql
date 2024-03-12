
SELECT * FROM info;
SELECT * FROM auth;


-- INNER JOIN
SELECT *
FROM info i
INNER JOIN auth a
ON i.auth_id = a.auth_id;

-- Oracle Grammar (오라클 전용 문법이라 앞으로는 작성x)
SELECT *
FROM info i, auth a
WHERE i.auth_id = a.auth_id;

-- auth_id 컬럼을 그냥 쓰면 모호하다 라고 뜹니다.
-- 그 이유는 양쪽에 모두 존재하는 컬럼이니까.
-- 컬럼에 테이블 이름을 붙이던지, 별칭을 쓰셔서
-- 확실하게 지목해주세요.

-- 필요한 데이터만 조회하겠다! (일반조건) 라고 한다면
-- WHERE 구문을 통해 조건을 걸어주면 됩니다.
SELECT
    a.auth_id, i.title, i.content, a.name
FROM info i
JOIN auth a -- JOIN이라고만 쓰면 기본 INNER JOIN
ON i.auth_id = a.auth_id
WHERE a.name = '이순신';

-- OUTER JOIN
SELECT *
FROM info i LEFT OUTER JOIN auth a
ON i.auth_id = a.auth_id;

SELECT *
FROM info i auth a
WHERE i.auth_id = a.auth_id(+);

-- 
SELECT *
FROM info i RIGHT JOIN auth a
ON i.auth_id = a.auth_id;

-- 좌측 테이블과 우측 테이블 데이터를 모두 읽어 표현하는 외부 조인
SELECT *
FROM info i FULL JOIN auth a
ON i.auth_id = a.auth_id;

-- CROSS JOIN은 JOIN조건을 설정하지 않기 때문에
-- 단순히 모든 컬럼에 대한 JOIN을 진행합니다.
-- 실제로는 거의 사용하지 않습니다.
SELECT * FROM info
CROSS JOIN auth;

SELECT * FROM info, auth; -- Oracle 문법

-- 여러개 테이블 조인 -> 키 값을 찾아 구문을 연결해서 쓰면 됩니다.
SELECT *
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN locations loc ON d.location_id = loc.location_id;

/*
- 테이블 별칭 a, i를 이용하여 LEFT OUTER JOIN 사용.
- info, auth 테이블 사용
- job 컬럼이 scientist인 사람의 id, title, content, job을 출력.
*/

SELECT
    i.id, i.title, i.content, a.job
FROM auth a
LEFT OUTER JOIN info i
ON a.auth_id = i.auth_id
WHERE a.job = 'scientist';

-- 셀프 조인이란 동일 테이블 사이의 조인을 말합니다.
-- 동일 테이블 컬럼을 통해 기존의 존재하는 값을 매칭시켜 가져올 때 사용합니다.
SELECT
    e1.employee_id, e1.first_name, e1.manager_id,
    e2.first_name, e2.employee_id
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.employee_id
ORDER BY e1.employee_id;

