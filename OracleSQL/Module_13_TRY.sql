--MODULE 13 TRY IT YOURSELF
----------------------------



--Chapter 13,“Triggers”

/*
1) Create or modify a trigger on the ENROLLMENT table that fires before an INSERT statement.Make
sure that all columns that have NOT NULL and foreign key constraints defined on them are populated
with their proper values.

ANSWER: The trigger should look similar to the following:
*/


CREATE OR REPLACE TRIGGER enrollment_bi
BEFORE INSERT ON ENROLLMENT
FOR EACH ROW
DECLARE
  v_valid NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_valid FROM student WHERE student_id = :NEW.STUDENT_ID;
  IF v_valid = 0 THEN
    RAISE_APPLICATION_ERROR (-20000, 'This is not a valid student');
  END IF;
  SELECT COUNT(*) INTO v_valid FROM section WHERE section_id = :NEW.SECTION_ID;
  IF v_valid = 0 THEN
    RAISE_APPLICATION_ERROR (-20001, 'This is not a valid section');
  END IF;
  :NEW.ENROLL_DATE   := SYSDATE;
  :NEW.CREATED_BY    := USER;
  :NEW.CREATED_DATE  := SYSDATE;
  :NEW.MODIFIED_BY   := USER;
  :NEW.MODIFIED_DATE := SYSDATE;
END;


/*
Consider this trigger. It fires before the INSERT statement on the ENROLLMENT table. First, you validate
new values for student ID and section ID. If one of the IDs is invalid, the exception is raised,
and the trigger is terminated. As a result, the INSERT statement causes an error. If both student
and section IDs are found in the STUDENT and SECTION tables, respectively, ENROLL_DATE,
CREATED_DATE, and MODIFIED_DATE are populated with the current date, and the columns
CREATED_BY and MODIFIED_BY are populated with the current user name.
Consider the following INSERT statement:
INSERT INTO enrollment (student_id, section_id)
VALUES (777, 123);
The value 777 in this INSERT statement does not exist in the STUDENT table and therefore is
invalid. As a result, this INSERT statement causes the following error:
INSERT INTO enrollment (student_id, section_id)
*
ERROR at line 1:
ORA-20000: This is not a valid student
ORA-06512: at "STUDENT.ENROLLMENT_BI", line 10
ORA-04088: error during execution of trigger 'STUDENT.ENROLLMENT_BI'



2) Create or modify a trigger on the SECTION table that fires before an UPDATE statement.Make sure
that the trigger validates incoming values so that there are no constraint violation errors.

ANSWER: The trigger should look similar to the following:
*/


CREATE OR REPLACE TRIGGER section_bu
BEFORE UPDATE ON SECTION
FOR EACH ROW
DECLARE
  v_valid NUMBER := 0;
BEGIN
  IF :NEW.INSTRUCTOR_ID IS NOT NULL THEN
    SELECT COUNT(*)
    INTO v_valid
    FROM instructor
    WHERE instructor_id = :NEW.instructor_ID;
    IF v_valid          = 0 THEN
      RAISE_APPLICATION_ERROR (-20000, 'This is not a valid instructor');
    END IF;
  END IF;
  :NEW.MODIFIED_BY   := USER;
  :NEW.MODIFIED_DATE := SYSDATE;
END;


/*
This trigger fires before the UPDATE statement on the SECTION table. First, you check to see if
there is a new value for an instructor ID with the help of an IF-THEN statement. If the IF-THEN
statement evaluates to TRUE, the instructor’s ID is checked against the INSTRUCTOR table. If a new
instructor ID does not exist in the INSTRUCTOR table, the exception is raised, and the trigger is
terminated.Otherwise, all columns with NOT NULL constraints are populated with their respective
values.
Note that this trigger does not populate the CREATED_BY and CREATED_DATE columns with the
new values.This is because when the record is updated, the values for these columns do not
change, because they reflect when this record was added to the SECTION table.
Consider the following UPDATE statement:
UPDATE section
SET instructor_id = 220
WHERE section_id = 79;
The value 220 in this UPDATE statement does not exist in the INSTRUCTOR table and therefore is
invalid. As a result, this UPDATE statement when run causes an error:
UPDATE section
*
ERROR at line 1:
ORA-20000: This is not a valid instructor
ORA-06512: at "STUDENT.SECTION_BU", line 11
ORA-04088: error during execution of trigger 'STUDENT.SECTION_BU'
Next, consider an UPDATE statement that does not cause any errors:
UPDATE section
SET instructor_id = 105
WHERE section_id = 79;
1 row updated.
ROLLBACK;
Rollback complete.
*/



