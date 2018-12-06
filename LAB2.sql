--HOST 212.51.216.168
--PORT 1521
--SID HW12
--PSW 12345678
--LGN INDEX

--ZnaleŸæ osoby najlepiej zarabiaj¹ce w ka¿dym z departamentów
SELECT
    d.department_name,
    e.last_name,
    e.salary
FROM
    hr.departments d
    JOIN hr.employees e ON d.department_id = e.department_id
ORDER BY
    1,
    3 DESC;

SELECT
    d.department_name,
    MAX(e.salary)
FROM
    hr.departments d
    JOIN hr.employees e ON d.department_id = e.department_id
GROUP BY
    d.department_name;

SELECT
    d.department_name,
    e.last_name,
    e.salary
FROM
    hr.departments d
    JOIN hr.employees e ON d.department_id = e.department_id
WHERE
    e.salary IN (
        SELECT
            MAX(e.salary)
        FROM
            hr.departments d
            JOIN hr.employees e ON d.department_id = e.department_id
        GROUP BY
            d.department_name
    )
ORDER BY
    1,
    3 DESC;
--------
--ZnaleŸæ osoby najlepiej zarabiaj¹ce w ka¿dym z departamentów

WITH temp1 ( sal ) AS (
    SELECT
        MAX(e.salary)
    FROM
        hr.departments d
        JOIN hr.employees e ON d.department_id = e.department_id
    GROUP BY
        d.department_name
),temp2 ( sal ) AS (
    SELECT
        MIN(e.salary)
    FROM
        hr.departments d
        JOIN hr.employees e ON d.department_id = e.department_id
    GROUP BY
        d.department_name
) SELECT
    d.department_name,
    e.last_name,
    e.salary
  FROM
    hr.departments d
    JOIN hr.employees e ON d.department_id = e.department_id
  WHERE
    e.salary IN (
        SELECT
            sal
        FROM
            temp1
    )
ORDER BY
    1,
    3 DESC;

SELECT
    d.department_name,
    e.last_name,
    e.salary
FROM
    hr.departments d
    JOIN hr.employees e ON d.department_id = e.department_id
WHERE
    e.salary IN (
        SELECT
            MAX(e1.salary)
        FROM
            hr.departments d1
            JOIN hr.employees e1 ON d1.department_id = e1.department_id
        WHERE
            d1.department_id = d.department_id
    --group by d1.department_name
    )
ORDER BY
    1,
    3 DESC;

SELECT
    d.department_name,
    e.last_name,
    e.salary
FROM
    hr.departments d
    JOIN hr.employees e ON d.department_id = e.department_id
WHERE
    ( d.department_name,
      e.salary ) IN (
        SELECT
            d.department_name,
            MAX(e.salary)
        FROM
            hr.departments d
            JOIN hr.employees e ON d.department_id = e.department_id
        GROUP BY
            d.department_name
    )
ORDER BY
    1,
    3 DESC;
    
--funkcje analityczne rankingowe
--row_number
--rank
--dense_rank

--pokazuje normalnie

SELECT
    last_name,
    salary,
    job_id,
    ROW_NUMBER() OVER(
        ORDER BY
            salary DESC
    )
FROM
    hr.employees
ORDER BY
    salary DESC;

--pokazuje z pominieciem

SELECT
    last_name,
    salary,
    job_id,
    RANK() OVER(
        ORDER BY
            salary DESC
    )
FROM
    hr.employees
ORDER BY
    salary DESC;

--pokazuje bez pominiec

SELECT
    last_name,
    salary,
    job_id,
    DENSE_RANK() OVER(
        ORDER BY
            salary DESC
    )
FROM
    hr.employees
ORDER BY
    salary DESC;


--pokazuje "ranking", sortuje wzgledem Salary, grupuje(przedstawia graficznie bo to nie group by) po job_id

SELECT
    last_name,
    salary,
    job_id,
    DENSE_RANK() OVER(
        PARTITION BY job_id
        ORDER BY
            salary DESC
    )
FROM
    hr.employees
ORDER BY
    job_id;

--formatowanie wyswietlania
--set pagesize 10

SELECT
    d.department_name,
    e.job_id,
    e.last_name,
    e.salary
FROM
    hr.departments d
    JOIN hr.employees e ON d.department_id = e.department_id
WHERE
    ( d.department_name,
      e.salary ) IN (
        SELECT
            d.department_name,
            MAX(e.salary)
        FROM
            hr.departments d
            JOIN hr.employees e ON d.department_id = e.department_id
        GROUP BY
            d.department_name
    )
ORDER BY
    1,
    3;

--podaj osoby zarabiajace najmniej na danym stanowisku pracy
--podaj w danym departamencie, w danym zawodzie osobe z najwyzsza pensja
--w jakim z panstw jest w danym departamencie najwiecej zatrudnionych osob
--podaj liczbe zatrudnionych w danym roku i miesiacu osob
    --(kolumny - miesiace ( bedzie 12 kolumn) ,wiersze - ilosc osob) 
    --DECODE (13kolumn- wierszy ?)

SELECT
    *
FROM
    (
        SELECT
            last_name,
            salary,
            job_id,
            RANK() OVER(
                PARTITION BY job_id
                ORDER BY
                    salary DESC
            ) AS ranking
        FROM
            hr.employees
    )
WHERE
    ranking = 1;

WITH temp1 AS (
    SELECT
        last_name,
        salary,
        job_id,
        RANK() OVER(
            PARTITION BY job_id
            ORDER BY
                salary DESC
        ) AS ranking
    FROM
        hr.employees
) SELECT
    *
  FROM
    temp1
  WHERE
    ranking = 1;

SET SERVEROUTPUT ON

DECLARE
    c   VARCHAR2(3,char);
BEGIN
    c := 'abc';
    dbms_output.put_line('Nasza zmienna c= ' || c);
END;
/

DECLARE
    c   VARCHAR2(3 CHAR);
    x   dept%rowtype;
    y   dept.dname%TYPE;
BEGIN
    x.dname := 'gsdfsdf';
    c := 'abc';
    NULL;
    dbms_output.put_line('Nasza zmienna c = ' || x.dname);
END;

DECLARE
    howmany      NUMBER;
    num_tables   NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO howmany
    FROM
        user_objects
    WHERE
        object_type = 'TABLE';

    num_tables := howmany;
    dbms_output.put_line('num_tables= ' || num_tables);
END;

SELECT
    COUNT(*)
FROM
    user_objects
WHERE
    object_type = 'TABLE';

CREATE TABLE employees
    AS
        SELECT
            *
        FROM
            hr.employees;

BEGIN
    NULL;
END;