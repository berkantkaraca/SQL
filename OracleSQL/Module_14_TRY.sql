--MODULE 14 TRY IT YOURSELF
----------------------------


--Chapter 14,“Compound Triggers”

/*
1) Create a compound trigger on the INSTRUCTOR table that fires on the INSERT and UPDATE statements.
The trigger should not allow an insert or update on the INSTRUCTOR table during off
hours.Off hours are weekends and times of day outside the 9 a.m. to 5 p.m. window.The trigger
should also populate the INSTRUCTOR_ID, CREATED_BY, CREATED_DATE, MODIFIED_BY, and
MODIFIED_DATE columns with their default values.

ANSWER: The trigger should look similar to the following:
*/

CREATE OR REPLACE TRIGGER instructor_compound
FOR INSERT OR UPDATE ON instructor
COMPOUND TRIGGER
v_date DATE;
v_user VARCHAR2(30);
BEFORE STATEMENT
IS
BEGIN
  IF RTRIM(TO_CHAR(SYSDATE, 'DAY')) NOT LIKE 'S%' AND RTRIM(TO_CHAR(SYSDATE, 'HH24:MI')) BETWEEN '09:00' AND '17:00' THEN
    v_date := SYSDATE;
    v_user := USER;
  ELSE
    RAISE_APPLICATION_ERROR (-20000, 'A table cannot be modified during off hours');
  END IF;
END BEFORE STATEMENT;
BEFORE EACH ROW
IS
BEGIN
  IF INSERTING THEN
    :NEW.instructor_id := INSTRUCTOR_ID_SEQ.NEXTVAL;
    :NEW.created_by    := v_user;
    :NEW.created_date  := v_date;
  ELSIF UPDATING THEN
    :NEW.created_by   := :OLD.created_by;
    :NEW.created_date := :OLD.created_date;
  END IF;
  :NEW.modified_by   := v_user;
  :NEW.modified_date := v_date;
END BEFORE EACH ROW;
END instructor_compound;


/*
This compound trigger has two executable sections, BEFORE STATEMENT and BEFORE EACH ROW.
The BEFORE STATEMENT portion prevents any updates to the INSTRUCTOR table during off hours.
In addition, it populates the v_date and v_user variables that are used to populate the
CREATED_BY, CREATED_DATE, MODIFIED_BY, and MODIFIED_DATE columns.The BEFORE EACH
ROW section populates these columns. In addition, it assigns a value to the INSTRUCTOR_ID
column from INSTRUCTOR_ID_SEQ.
Note the use of the INSERTING and UPDATING functions in the BEFORE EACH ROW section.The
INSERTING function is used because the INSTRUCTOR_ID, CREATED_BY, and CREATED_DATE
columns are populated with new values only if a record is being inserted in the INSTRUCTOR
table.This is not so when a record is being updated. In this case, the CREATED_BY and
CREATED_DATE columns are populated with the values copied from the OLD pseudorecord.
However, the MODIFIED_BY and MODIFIED_DATE columns need to be populated with the new
values regardless of the INSERT or UPDATE operation.
The newly created trigger may be tested as follows:
SET SERVEROUTPUT ON
DECLARE
v_date VARCHAR2(20);
BEGIN
v_date := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI');
DBMS_OUTPUT.PUT_LINE ('Date: '||v_date);
INSERT INTO instructor
(salutation, first_name, last_name, street_address, zip, phone)
VALUES
('Mr.', 'Test', 'Instructor', '123 Main Street', '07112',
'2125555555');
ROLLBACK;
END;
/
The output is as follows:
Date: 25/04/2008 15:47
PL/SQL procedure successfully completed.
Here’s the second test:
SET SERVEROUTPUT ON
DECLARE
v_date VARCHAR2(20);
BEGIN
v_date := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI');
DBMS_OUTPUT.PUT_LINE ('Date: '||v_date);
UPDATE instructor
SET phone = '2125555555'
WHERE instructor_id = 101;
ROLLBACK;
END;
/
The output is as follows:
Date: 26/04/2008 19:50
DECLARE
*
ERROR at line 1:
ORA-20000: A table cannot be modified during off hours
ORA-06512: at "STUDENT.INSTRUCTOR_COMPOUND", line 15
ORA-04088: error during execution of trigger 'STUDENT.INSTRUCTOR_COMPOUND'
ORA-06512: at line 7



2) Create a compound trigger on the ZIPCODE table that fires on the INSERT and UPDATE statements.
The trigger should populate the CREATED_BY, CREATED_DATE, MODIFIED_BY, and
MODIFIED_DATE columns with their default values. In addition, it should record in the STATISTICS
table the type of the transaction, the name of the user who issued the transaction, and the date
of the transaction. Assume that the STATISTICS table has the following structure:
Name Null? Type
------------------------------- -------- ----
TABLE_NAME VARCHAR2(30)
TRANSACTION_NAME VARCHAR2(10)
TRANSACTION_USER VARCHAR2(30)
TRANSACTION_DATE DATE


ANSWER: The trigger should look similar to the following:
*/


CREATE OR REPLACE TRIGGER zipcode_compound
FOR INSERT OR UPDATE ON zipcode
COMPOUND TRIGGER
v_date DATE;
v_user VARCHAR2(30);
v_type VARCHAR2(10);
BEFORE STATEMENT
IS
BEGIN
  v_date := SYSDATE;
  v_user := USER;
END BEFORE STATEMENT;
BEFORE EACH ROW
IS
BEGIN
  IF INSERTING THEN
    :NEW.created_by   := v_user;
    :NEW.created_date := v_date;
  ELSIF UPDATING THEN
    :NEW.created_by   := :OLD.created_by;
    :NEW.created_date := :OLD.created_date;
  END IF;
  :NEW.modified_by   := v_user;
  :NEW.modified_date := v_date;
END BEFORE EACH ROW;
AFTER STATEMENT
IS
BEGIN
  IF INSERTING THEN
    v_type := 'INSERT';
  ELSIF UPDATING THEN
    v_type := 'UPDATE';
  END IF;
  INSERT
  INTO statistics
    (
      table_name,
      transaction_name,
      transaction_user,
      transaction_date
    )
    VALUES
    (
      'ZIPCODE',
      v_type,
      v_user,
      v_date
    );
END AFTER STATEMENT;
END ZIPCODE_COMPOUND;


UPDATE zipcode
SET city = 'Test City'
WHERE zip = '01247';


SELECT *
FROM statistics
WHERE TRANSACTION_DATE >= TRUNC(SYSDATE);

/*
TABLE_NAME TRANSACTION_NAME TRANSACTION_USER TRANSACTION_DATE
---------- ---------------- ---------------- ----------------
ZIPCODE UPDATE STUDENT 24-APR-08

*/
ROLLBACK;




