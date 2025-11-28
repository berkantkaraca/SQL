--MODULE 19
------------



--Procedures
-------------


--Creating Procedures

--bütün kurslara %5 indirim uygulayan procedure
-- ch19_01a.sql
CREATE OR REPLACE
PROCEDURE Discount
AS
  CURSOR c_group_discount
  IS
    SELECT DISTINCT s.course_no,
      c.description
    FROM section s,
      enrollment e,
      course c
    WHERE s.section_id = e.section_id
    AND c.course_no    = s.course_no
    GROUP BY s.course_no,
      c.description,
      e.section_id,
      s.section_id
    HAVING COUNT(*) >=8;
BEGIN
  FOR r_group_discount IN c_group_discount
  LOOP
    UPDATE course
    SET cost        = cost * .95
    WHERE course_no = r_group_discount.course_no;
    DBMS_OUTPUT.PUT_LINE ('A 5% discount has been given to '|| r_group_discount.course_no||' '|| r_group_discount.description );
  END LOOP;
END;


/*
A) What do you see on the screen? Explain what happens.


B) Execute the Discount procedure. How do you accomplish this? What results do you see on the
screen?
*/

BEGIN
  Discount;
END;

/*
C) The script does not contain a COMMIT. Discuss the issues involved with placing a COMMIT in the
procedure, and indicate where the COMMIT could be placed.

ANSWER: Because this procedure does not have a COMMIT, the procedure will not update the
database. A COMMIT needs to be issued after the procedure is run if you want the changes to be
made. Alternatively, you can enter a COMMIT either before or after the end loop. If you put the
COMMIT before the end loop, you are committing the changes after every loop. If you put the
COMMIT after the end loop, the changes are not committed until the procedure is near completion.
It is wiser to use the second option.This way, you are better prepared to handle errors.

*/



--19.1.2 Query the Data Dictionary for Information on Procedures


/*
A) WRITE A SELECT STATEMENT TO GET PERTINENT INFORMATION FROM THE USER_OBJECTS VIEW ABOUT THE
Discount procedure you just wrote. Run the query and describe the results.
*/

SELECT *--object_name, object_type, status
FROM USER_OBJECTS
WHERE object_name = 'DISCOUNT';


/*
B) Write a SELECT statement to display the source code from the USER_SOURCE view for the
Discount procedure.
*/

select * 
FROM USER_SOURCE
WHERE name = 'DISCOUNT';


SELECT TO_CHAR(line, 99)||'>', text
FROM USER_SOURCE
WHERE name = 'DISCOUNT';

------------------------------------------------------------------------------------------------------


--Passing Parameters into and out of Procedures

--19.2.1 Use IN and OUT Parameters with Procedures


-- ch19_02a.sql
CREATE OR REPLACE
PROCEDURE find_sname(
    i_student_id IN NUMBER,
    o_first_name OUT VARCHAR2,
    o_last_name OUT VARCHAR2 )
AS
BEGIN
  SELECT first_name,
    last_name
  INTO o_first_name,
    o_last_name
  FROM student
  WHERE student_id = i_student_id;
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error in finding student_id:
'||i_student_id);
END find_sname;


/*
A) Explain what happens in the find_sname procedure. What parameters are passed into and out
of the procedure? How would you call the procedure? Call the find_sname script with the
following anonymous block:
*/

-- ch19_03a.sql
DECLARE
  v_local_first_name student.first_name%TYPE;
  v_local_last_name student.last_name%TYPE;
BEGIN
  find_sname (145, v_local_first_name, v_local_last_name);
  DBMS_OUTPUT.PUT_LINE ('Student 145 is: '||v_local_first_name|| ' '|| v_local_last_name||'.' );
END;


/*
Explain the relationship between the parameters that are in the procedure’s header definition
versus the parameters that are passed into and out of the procedure.
*/











