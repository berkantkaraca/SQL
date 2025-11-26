--MODULE 9 TRY IT YOURSELF
--------------------------


--Chapter 9,“Exceptions”

/*
1) Create the following script: For a course section provided at runtime, determine the number of
students registered. If this number is equal to or greater than 10, raise the user-defined exception
e_too_many_students and display an error message.Otherwise, display how many
students are in a section.

ANSWER: The script should look similar to the following:
*/


SET SERVEROUTPUT ON
DECLARE
  v_section_id        NUMBER := &sv_section_id;
  v_total_students    NUMBER;
  e_too_many_students EXCEPTION;
BEGIN
  -- Calculate number of students enrolled
  SELECT COUNT(*)
  INTO v_total_students
  FROM enrollment
  WHERE section_id     = v_section_id;
  IF v_total_students >= 10 THEN
    RAISE e_too_many_students;
  ELSE
    DBMS_OUTPUT.PUT_LINE ('There are '||v_total_students|| ' students for section ID: '||v_section_id);
  END IF;
EXCEPTION
WHEN e_too_many_students THEN
  DBMS_OUTPUT.PUT_LINE ('There are too many '|| 'students for section '||v_section_id);
END;

/*
In this script, you declare two variables, v_section_id and v_total_students, to store
the section ID provided by the user and the total number of students in that section ID, respectively.
You also declare a user-defined exception e_too_many_students.You raise this
exception using the IF-THEN statement if the value returned by the COUNT function exceeds 10.
Otherwise, you display the message specifying how many students are enrolled in a given section.
To test this script fully, consider running it for two values of section ID.When 101 is provided for
the section ID (this section has more than ten students), this script produces the following output:
Enter value for sv_section_id: 101
old 2: v_section_id NUMBER := &sv_section_id;
new 2: v_section_id NUMBER := 101;
There are too many students for section 101
PL/SQL procedure successfully completed.
When 116 is provided for the section ID (this section has fewer than ten students), this script
produces different output:
Enter value for sv_section_id: 116
old 2: v_section_id NUMBER := &sv_section_id;
new 2: v_section_id NUMBER := 116;
There are 8 students for section ID: 116
PL/SQL procedure successfully completed.
Next, consider running this script for a nonexistent section ID:
Enter value for sv_section_id: 999
old 2: v_section_id NUMBER := &sv_section_id;
new 2: v_section_id NUMBER := 999;
There are 0 students for section ID: 999
PL/SQL procedure successfully completed.
Note that the script does not produce any errors. Instead, it states that section 999 has 0 students.
How would you modify this script to ensure that when there is no corresponding section ID in the
ENROLLMENT table, the message This section does not exist is displayed on the
screen?



2) Modify the script you just created. After the exception e_too_many_students has been
raised in the inner block, reraise it in the outer block.

ANSWER: The new version of the script should look similar to the following. Changes are shown
in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  v_section_id        NUMBER := &sv_section_id;
  v_total_students    NUMBER;
  e_too_many_students EXCEPTION;
BEGIN
  -- Add inner block
  BEGIN
    -- Calculate number of students enrolled
    SELECT COUNT(*)
    INTO v_total_students
    FROM enrollment
    WHERE section_id     = v_section_id;
    IF v_total_students >= 10 THEN
      RAISE e_too_many_students;
    ELSE
      DBMS_OUTPUT.PUT_LINE ('There are '||v_total_students|| ' students for section ID: '||v_section_id);
    END IF;
    -- Re-raise exception
  EXCEPTION
  WHEN e_too_many_students THEN
    RAISE;
  END;
EXCEPTION
WHEN e_too_many_students THEN
  DBMS_OUTPUT.PUT_LINE ('There are too many '|| 'students for section '||v_section_id);
END;

/*
In this version of the script, you introduce an inner block where the e_too_many_students
exception is raised first and then propagated to the outer block.This version of the script
produces output identical to the original script.
Next, consider a different version in which the original PL/SQL block (the PL/SQL block from the
original script) has been enclosed in another block:
SET SERVEROUTPUT ON
-- Outer PL/SQL block
BEGIN
-- This block became inner PL/SQL block
DECLARE
v_section_id NUMBER := &sv_section_id;
v_total_students NUMBER;
e_too_many_students EXCEPTION;
BEGIN
-- Calculate number of students enrolled
SELECT COUNT(*)
INTO v_total_students
FROM enrollment
WHERE section_id = v_section_id;
IF v_total_students >= 10 THEN
RAISE e_too_many_students;
ELSE
DBMS_OUTPUT.PUT_LINE ('There are '||v_total_students||
' students for section ID: '||v_section_id);
END IF;
EXCEPTION
WHEN e_too_many_students THEN
RAISE;
END;
EXCEPTION
WHEN e_too_many_students THEN
DBMS_OUTPUT.PUT_LINE ('There are too many '||
'students for section '||v_section_id);
END;
This version of the script causes the following error message:
Enter value for sv_section_id: 101
old 4: v_section_id NUMBER := &sv_section_id;
new 4: v_section_id NUMBER := 101;
WHEN e_too_many_students THEN
*
ERROR at line 26:
ORA-06550: line 26, column 9:
PLS-00201: identifier 'E_TOO_MANY_STUDENTS' must be declared
ORA-06550: line 0, column 0:
PL/SQL: Compilation unit analysis terminated
This occurs because the e_too_many_students exception is declared in the inner block
and, as a result, is not visible to the outer block. In addition, the v_section_id variable used
by the exception-handling section of the outer block is declared in the inner block as well, and, as
a result, is not accessible in the outer block.
To correct these errors, the previous version of the script can be modified as follows:
SET SERVEROUTPUT ON
-- Outer PL/SQL block
DECLARE
v_section_id NUMBER := &sv_section_id;
e_too_many_students EXCEPTION;
BEGIN
-- This block became inner PL/SQL block
DECLARE
v_total_students NUMBER;
BEGIN
-- Calculate number of students enrolled
SELECT COUNT(*)
INTO v_total_students
FROM enrollment
WHERE section_id = v_section_id;
IF v_total_students >= 10 THEN
RAISE e_too_many_students;
ELSE
DBMS_OUTPUT.PUT_LINE ('There are '||v_total_students||
' students for section ID: '||v_section_id);
END IF;
EXCEPTION
WHEN e_too_many_students THEN
RAISE;
END;
EXCEPTION
WHEN e_too_many_students THEN
DBMS_OUTPUT.PUT_LINE ('There are too many '||
'students for section '||V_SECTION_ID);
END;

*/