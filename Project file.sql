create database employee;
use employee;

-- Q3
select Emp_ID, First_Name, Last_Name, Gender, Dept
	from emp_record_table
    order by Dept;

-- Q4
select Emp_ID, First_Name, Last_Name, Gender, Dept, Emp_Rating
	from emp_record_table
    where Emp_Rating between 2 AND 4;

-- Q5
select concat(First_Name,' ', Last_Name) as NAME
	from emp_record_table
    where Dept = 'Finance';

-- Q6
select m.First_Name, count(*) as No_Employees
	from emp_record_table e JOIN emp_record_table m
    ON e.MANAGER_ID = m.EMP_ID
    group by m.FIRST_NAME;

-- Q7
select * from emp_record_table where dept = 'Healthcare' 
    UNION
select * from emp_record_table where dept = 'Finance';

-- Q8
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING, 
	max(EMP_RATING)  Over(partition by Dept) as Max_by_Dept
	from emp_record_table;

-- Q9
select ROLE, min(salary) as Min_Salary, max(salary) as Max_Salary 
	from emp_record_table
    group by Role;
    
-- Q10
select EMP_ID, FIRST_NAME, Last_Name, Exp, 
	rank() over(order by Exp desc) as Rank_Exp
	from emp_record_table;
    
-- Q11
create view Emp_salabove6k
as
select EMP_ID, FIRST_NAME, Last_Name, Role, Dept, Salary, Country
	from emp_record_table
    where salary > 6000
    order by Country;
select * from Emp_salabove6k;

-- Q12
select * from emp_record_table where EMP_ID in(
select EMP_ID from emp_record_table where exp > 10);

-- Q13
select * from emp_record_table where exp > 3;

-- Q14
DELIMITER $$
CREATE PROCEDURE empabove3yrs ()
BEGIN
select * from emp_record_table where exp > 3;
END$$
DELIMITER ;
call empabove3yrs;

-- Q14

DELIMITER //
CREATE PROCEDURE Check_JobProfiles_Procedure(IN eid VARCHAR(5), OUT status VARCHAR(10))
BEGIN
    DECLARE ex INT;
    DECLARE vrole VARCHAR(100);
    DECLARE expected_role VARCHAR(100);

    -- Fetch experience and assigned role for the given Emp_ID
    SELECT exp, role INTO ex, vrole FROM data_science_team WHERE Emp_ID = eid;

    -- Determine expected role based on experience
    IF ex <= 2 THEN
        SET expected_role = 'JUNIOR DATA SCIENTIST';
    ELSEIF ex > 2 AND ex <= 5 THEN
        SET expected_role = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF ex > 5 AND ex <= 10 THEN
        SET expected_role = 'SENIOR DATA SCIENTIST';
    ELSEIF ex > 10 AND ex <= 12 THEN
        SET expected_role = 'LEAD DATA SCIENTIST';
    ELSEIF ex > 12 AND ex <= 16 THEN
        SET expected_role = 'MANAGER';
    ELSE
        SET expected_role = 'UNKNOWN';  -- Handle unexpected cases
    END IF;

    -- Compare assigned role with expected role
    IF vrole = expected_role THEN
        SET status = 'MATCH';
    ELSE
        SET status = 'MISMATCH';
    END IF;
END //
DELIMITER ;

CALL Check_JobProfiles_Procedure('E1001', @result);
SELECT @result as Result;

-- Q15
select * from emp_record_table
	where FIRST_NAME = 'Eric';
create index idx_fn ON emp_record_table(First_Name);

-- Q16
select *, Salary * 0.05 * EMP_RATING as BONUS
	from emp_record_table;

-- Q17
select Continent, Country, avg(Salary) as Avg_Salary
	from emp_record_table
    group by Continent, Country with rollup
    order by Continent, Country;