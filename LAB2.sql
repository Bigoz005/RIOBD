--HOST 212.51.216.168
--PORT 1521
--SID HW12
--PSW 12345678
--LGN INDEX

--ZnaleŸæ osoby najlepiej zarabiaj¹ce w ka¿dym z departamentów

SELECT d.department_name, e.last_name, e.salary
FROM hr.departments d  JOIN hr.employees e 
    ON d.department_id = e.department_id
    order by 1,3 desc;
    
SELECT d.department_name, max(e.salary)
FROM hr.departments d JOIN hr.employees e 
    ON d.department_id = e.department_id
    group by d.department_name;
    
SELECT d.department_name, e.last_name, e.salary
FROM hr.departments d  JOIN hr.employees e 
    ON d.department_id = e.department_id
    where e.SALARY IN (
    SELECT max(e.salary)
FROM hr.departments d JOIN hr.employees e 
    ON d.department_id = e.department_id
    group by d.department_name
    )
    order by 1,3 desc;
--------
--ZnaleŸæ osoby najlepiej zarabiaj¹ce w ka¿dym z departamentów

WITH
temp1(sal) as  (SELECT max(e.salary) FROM hr.departments d JOIN hr.employees e  
    ON d.department_id = e.department_id group by d.department_name),
temp2(sal) as  (SELECT min(e.salary) FROM hr.departments d JOIN hr.employees e  
    ON d.department_id = e.department_id  group by d.department_name)
  
SELECT d.department_name, e.last_name, e.salary
FROM hr.departments d  JOIN hr.employees e 
    ON d.department_id = e.department_id
    where e.SALARY IN (SELECT sal from temp1)
    order by 1,3 desc;
    

SELECT d.department_name, e.last_name, e.salary
FROM hr.departments d  JOIN hr.employees e 
    ON d.department_id = e.department_id
    where e.SALARY IN (
    SELECT max(e1.salary)
FROM hr.departments d1 JOIN hr.employees e1 
    ON d1.department_id = e1.department_id
    WHERE d1.department_id = d.department_id
    --group by d1.department_name
    )
    order by 1,3 desc;

SELECT d.department_name, e.last_name, e.salary
FROM hr.departments d  JOIN hr.employees e 
    ON d.department_id = e.department_id
    WHERE( d.department_name, e.SALARY )IN 
    (
SELECT d.department_name, max(e.salary)
FROM hr.departments d JOIN hr.employees e 
    ON d.department_id = e.department_id
    GROUP BY d.department_name
    )
    order by 1,3 desc;
    
--funkcje analityczne rankingowe
--row_number
--rank
--dense_rank

--pokazuje normalnie
SELECT LAST_NAME, SALARY, JOB_ID, row_number() OVER (ORDER BY salary DESC )
FROM hr.employees ORDER BY SALARY desc;

--pokazuje z pominieciem
SELECT LAST_NAME, SALARY, JOB_ID, rank() OVER (ORDER BY salary DESC )
FROM hr.employees ORDER BY SALARY desc;

--pokazuje bez pominiec
SELECT LAST_NAME, SALARY, JOB_ID, dense_rank() OVER (ORDER BY salary DESC )
FROM hr.employees ORDER BY SALARY desc;


--pokazuje "ranking", sortuje wzgledem Salary, grupuje(przedstawia graficznie bo to nie group by) po job_id
SELECT LAST_NAME, SALARY, JOB_ID, dense_rank() OVER (PARTITION BY JOB_ID ORDER BY salary DESC )
FROM hr.employees ORDER BY JOB_ID;

--formatowanie wyswietlania
--set pagesize 10

SELECT d.department_name, e.job_id, e.last_name, e.salary
FROM hr.departments d  JOIN hr.employees e 
    ON d.department_id = e.department_id
    WHERE( d.department_name, e.SALARY )IN 
    (
SELECT d.department_name, max(e.salary)
FROM hr.departments d JOIN hr.employees e 
    ON d.department_id = e.department_id
    GROUP BY d.department_name
    )
    order by 1,3 ;

--podaj osoby zarabiajace najmniej na danym stanowisku pracy
--podaj w danym departamencie, w danym zawodzie osobe z najwyzsza pensja
--w jakim z panstw jest w danym departamencie najwiecej zatrudnionych osob
--podaj liczbe zatrudnionych w danym roku i miesiacu osob
    --(kolumny - miesiace ( bedzie 12 kolumn) ,wiersze - ilosc osob) 
    --DECODE (13kolumn- wierszy ?)

SELECT * FROM (SELECT LAST_NAME, SALARY, JOB_ID, rank() OVER (PARTITION BY JOB_ID ORDER BY salary DESC ) AS RANKING
FROM hr.employees) WHERE RANKING=1;

WITH
    temp1 AS (SELECT LAST_NAME, SALARY, JOB_ID, rank() OVER (PARTITION BY JOB_ID ORDER BY salary DESC ) AS RANKING
FROM hr.employees)
SELECT * FROM temp1 WHERE RANKING=1;