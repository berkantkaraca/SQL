--MODULE 8 TRY IT YOURSELF
---------------------------


--Chapter 8,“Error Handling and Built-In Exceptions”

/*
1) Create the following script: Check to see whether there is a record in the STUDENT table for a
given student ID. If there is not, insert a record into the STUDENT table for the given student ID.

ANSWER: The script should look similar to the following:
*/

SET SERVEROUTPUT ON
DECLARE
  v_student_id NUMBER       := &sv_student_id;
  v_first_name VARCHAR2(30) := '&sv_first_name';
  v_last_name  VARCHAR2(30) := '&sv_last_name';
  v_zip        CHAR(5)      := '&sv_zip';
  v_name       VARCHAR2(50);
BEGIN
  SELECT first_name
    ||' '
    ||last_name
  INTO v_name
  FROM student
  WHERE student_id = v_student_id;
  DBMS_OUTPUT.PUT_LINE ('Student '||v_name||' is a valid student');
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('This student does not exist, and will be '|| 'added to the STUDENT table');
  INSERT
  INTO student
    (
      student_id,
      first_name,
      last_name,
      zip,
      registration_date,
      created_by,
      created_date,
      modified_by,
      modified_date
    )
    VALUES
    (
      v_student_id,
      v_first_name,
      v_last_name,
      v_zip,
      SYSDATE,
      USER,
      SYSDATE,
      USER,
      SYSDATE
    );
  COMMIT;
END;

/*
This script accepts a value for student’s ID from a user. For a given student ID, it determines the
student’s name using the SELECT INTO statement and displays it on the screen. If the value
provided by the user is not a valid student ID, control of execution is passed to the exceptionhandling
section of the block, where the NO_DATA_FOUND exception is raised. As a result, the
message This student does not exist ... is displayed on the screen, and a new record is
inserted into the STUDENT table.
To test this script fully, consider running it for two values of student ID. Only one value should
correspond to an existing student ID. It is important to note that a valid zip code must be
provided for both runs.Why do you think this is necessary?
When 319 is provided for the student ID (it is a valid student ID), this exercise produces the following
output:
Enter value for sv_student_id: 319
old 2: v_student_id NUMBER := &sv_student_id;
new 2: v_student_id NUMBER := 319;
Enter value for sv_first_name: John
old 3: v_first_name VARCHAR2(30) := '&sv_first_name';
new 3: v_first_name VARCHAR2(30) := 'John';
Enter value for sv_last_name: Smith
old 4: v_last_name VARCHAR2(30) := '&sv_last_name';
new 4: v_last_name VARCHAR2(30) := 'Smith';
Enter value for sv_zip: 07421
old 5: v_zip CHAR(5) := '&sv_zip';
new 5: v_zip CHAR(5) := '07421';
Student George Eakheit is a valid student
PLSQL procedure successfully completed.
Notice that the name displayed by the script does not correspond to the name entered at
runtime.Why do you think this is?
When 555 is provided for the student ID (it is not a valid student ID), this exercise produces the
following output:
Enter value for sv_student_id: 555
old 2: v_student_id NUMBER := &sv_student_id;
new 2: v_student_id NUMBER := 555;
Enter value for sv_first_name: John
old 3: v_first_name VARCHAR2(30) := '&sv_first_name';
new 3: v_first_name VARCHAR2(30) := 'John';
Enter value for sv_last_name: Smith
old 4: v_last_name VARCHAR2(30) := '&sv_last_name';
new 4: v_last_name VARCHAR2(30) := 'Smith';
Enter value for sv_zip: 07421
old 5: v_zip CHAR(5) := '&sv_zip';
new 5: v_zip CHAR(5) := '07421';
This student does not exist, and will be added to the STUDENT table
PLSQL procedure successfully completed.
Next, you can select this new record from the STUDENT table as follows:
SELECT student_id, first_name, last_name
FROM student
WHERE student_id = 555;
STUDENT_ID FIRST_NAME LAST_NAME
---------- ------------------------- ----------------
555 John Smith



2) Create the following script: For a given instructor ID, check to see whether it is assigned to a valid
instructor.Then check to see how many sections this instructor teaches, and display this information
on the screen.

ANSWER: The script should look similar to the following:
*/


SET SERVEROUTPUT ON
DECLARE
  v_instructor_id NUMBER := &sv_instructor_id;
  v_name          VARCHAR2(50);
  v_total         NUMBER;
BEGIN
  SELECT first_name
    ||' '
    ||last_name
  INTO v_name
  FROM instructor
  WHERE instructor_id = v_instructor_id;
  -- check how many sections are taught by this instructor
  SELECT COUNT(*)
  INTO v_total
  FROM section
  WHERE instructor_id = v_instructor_id;
  DBMS_OUTPUT.PUT_LINE ('Instructor, '||v_name|| ', teaches '||v_total||' section(s)');
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('This is not a valid instructor');
END;


/*
This script accepts a value for the instructor’s ID from a user. For a given instructor ID, it determines
the instructor’s name using the SELECT INTO statement.This SELECT INTO statement checks
to see if the ID provided by the user is a valid instructor ID. If this value is not valid, control of
execution is passed to the exception-handling section of the block, where the NO_DATA_FOUND
exception is raised. As a result, the message This is not a valid instructor is displayed
on the screen. On the other hand, if the value provided by the user is a valid instructor ID, the
second SELECT INTO statement calculates how many sections are taught by this instructor.
To test this script fully, consider running it for two values of instructor ID.When 105 is provided for
the instructor ID (it is a valid instructor ID), this exercise produces the following output:
Enter value for sv_instructor_id: 105
old 2: v_instructor_id NUMBER := &sv_instructor_id;
new 2: v_instructor_id NUMBER := 105;
Instructor, Anita Morris, teaches 10 section(s)
PLSQL procedure successfully completed.
When 123 is provided for the instructor ID (it is not a valid student ID), this exercise produces the
following output:
Enter value for sv_instructor_id: 123
old 2: v_instructor_id NUMBER := &sv_instructor_id;
new 2: v_instructor_id NUMBER := 123;
THIS IS NOT A VALID INSTRUCTOR
PLSQL procedure successfully completed.
*/



