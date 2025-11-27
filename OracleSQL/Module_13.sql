--MODULE 13
------------



--Triggers
------------


--What Triggers Are 

--BEFORE Trigger
CREATE OR REPLACE TRIGGER STUDENT_BI 
BEFORE INSERT
ON STUDENT 
FOR EACH ROW
BEGIN 
  :NEW.student_id       := STUDENT_ID_SEQ.NEXTVAL;
  :NEW.created_by       := USER;
  :NEW.created_date     := SYSDATE;
  :NEW.modified_by      := USER;
  :NEW.MODIFIED_DATE    := SYSDATE;
END;



--trigger �ncesi insert c�mlesi
INSERT INTO student (student_id, first_name, last_name, zip,
registration_date, created_by, created_date, modified_by,
modified_date)
VALUES (STUDENT_ID_SEQ.NEXTVAL, 'John', 'Smith', '00914', SYSDATE,
USER, SYSDATE, USER, SYSDATE);


--trigger sonras? insert c�mlesi
INSERT INTO STUDENT (FIRST_NAME, LAST_NAME, ZIP, REGISTRATION_DATE)
VALUES ('John', 'Smith', '00914', SYSDATE);



--11g �ncesi sequence kullan?m?
CREATE OR REPLACE TRIGGER student_bi
BEFORE INSERT ON student
FOR EACH ROW
DECLARE
  v_student_id STUDENT.STUDENT_ID%TYPE;
BEGIN
  SELECT STUDENT_ID_SEQ.NEXTVAL INTO v_student_id FROM dual;
  :NEW.student_id    := v_student_id;
  :NEW.created_by    := USER;
  :NEW.created_date  := SYSDATE;
  :NEW.modified_by   := USER;
  :NEW.MODIFIED_DATE := SYSDATE;
END;



--After trigger, statistics tablosunun create edilmesi gerekiyor
create table statistics(
    table_name varchar2(30),
    transaction_name varchar2(30),
    transaction_user varchar2(30),
    transaction_date DATE
);

CREATE OR REPLACE TRIGGER instructor_aud
AFTER UPDATE OR DELETE ON INSTRUCTOR
DECLARE
  v_type VARCHAR2(10);
BEGIN
  IF UPDATING THEN
    v_type := 'UPDATE';
  ELSIF DELETING THEN
    v_type := 'DELETE';
  END IF;
  UPDATE statistics
  SET transaction_user = USER,
    transaction_date   = SYSDATE
  WHERE table_name     = 'INSTRUCTOR'
  AND transaction_name = v_type;
  IF SQL%NOTFOUND THEN
    INSERT INTO statistics VALUES
      ('INSTRUCTOR', v_type, USER, SYSDATE
      );
  END IF;
END;



--AUTONOMOUS_TRANSACTION kullan?m?

CREATE OR REPLACE TRIGGER instructor_aud
AFTER UPDATE OR DELETE ON INSTRUCTOR
DECLARE
  v_type VARCHAR2(10);
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  IF UPDATING THEN
    v_type := 'UPDATE';
  ELSIF DELETING THEN
    v_type := 'DELETE';
  END IF;
  UPDATE statistics
  SET transaction_user = USER,
    transaction_date   = SYSDATE
  WHERE table_name     = 'INSTRUCTOR'
  AND transaction_name = v_type;
  IF SQL%NOTFOUND THEN
    INSERT INTO statistics VALUES
      ('INSTRUCTOR', v_type, USER, SYSDATE
      );
  END IF;
  COMMIT;
END;


--ard?ndan �al??t?rarak dene

UPDATE instructor
SET phone = '7181234567'
WHERE instructor_id = 101;

ROLLBACK;

SELECT *
FROM statistics;



--13.1.1 Understand What a Trigger Is

CREATE TRIGGER student_au
AFTER UPDATE ON STUDENT
FOR EACH ROW
WHEN (NVL(NEW.ZIP, ' ') <> OLD.ZIP)
Trigger Body...

/*
A) Assume that a trigger named STUDENT_AU already exists in the database. If you use the CREATE
clause to modify the existing trigger, what error message is generated? Explain your answer.

ANSWER: You see an error message stating that the STUDENT_AU name is already being used
by another object.The CREATE clause can create new objects in the database, but it is unable to
handle modifications.To modify the existing trigger, you must add the REPLACE statement to the
CREATE clause. In this case, the old version of the trigger is dropped without warning, and the new
version of the trigger is created.


B) If an update statement is issued on the STUDENT table, how many times does this trigger fire?

ANSWER: The trigger fires as many times as there are rows affected by the triggering event,
because the FOR EACH ROW statement is present in the CREATE trigger clause.
When the FOR EACH ROW statement is not present in the CREATE trigger clause, the trigger fires
once for the triggering event. In this case, if the following UPDATE statement
UPDATE student
SET zip = '01247'
WHERE zip = '02189';
is issued against the STUDENT table, it updates as many records as there are students with a zip
code of 02189.


C) How many times does this trigger fire if an update statement is issued against the STUDENT table
but the ZIP column is not changed?

ANSWER: The trigger does not fire, because the condition of the WHEN statement evaluates
to FALSE.
The condition
(NVL(NEW.ZIP, ' ') <> OLD.ZIP)
of the WHEN statement compares the new value of the zip code to the old value of the zip code. If
the value of the zip code is not changed, this condition evaluates to FALSE. As a result, this trigger
does not fire if an UPDATE statement does not modify the value of the zip code for a specified
record.


D) Why do you think an NVL function is present in the WHEN statement of the CREATE clause?

ANSWER: If an UPDATE statement does not modify the column ZIP, the value of the field
NEW.ZIP is undefined. In other words, it is NULL. A NULL value of ZIP cannot be compared with a
non-NULL value of ZIP.Therefore, the NVL function is present in the WHEN condition.
Because the column ZIP has a NOT NULL constraint defined, there is no need to use the NVL function
for the OLD.ZIP field. An UPDATE statement issued against the STUDENT table always has a
value of ZIP present in the table.
*/



--13.1.2 Use BEFORE and AFTER Triggers


--instructor tablosu �zerinde her bir sat?r i�in �al??acak before insert trigger ? olu?turulacak
--created_by ve date ile modified_byve date kolonlar?na default deger atanacak
--ayr?ca girilen zip de?eri zipcode tablosunda ge�erlili?i kontrol edilecek, yoksa hata f?rlat?lacak
-- ch13_1a.sql, version 1.0
CREATE OR REPLACE TRIGGER instructor_bi
BEFORE INSERT ON INSTRUCTOR
FOR EACH ROW
DECLARE
  v_work_zip CHAR(1);
BEGIN
  :NEW.CREATED_BY    := USER;
  :NEW.CREATED_DATE  := SYSDATE;
  :NEW.MODIFIED_BY   := USER;
  :NEW.MODIFIED_DATE := SYSDATE;
  SELECT 'Y' INTO v_work_zip FROM zipcode WHERE zip = :NEW.ZIP;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR (-20001, 'Zip code is not valid!');
END;



/*
A) If an INSERT statement issued against the INSTRUCTOR table is missing a value for the column ZIP,
does the trigger raise an exception? Explain your answer.

ANSWER: Yes, the trigger raises an exception. When an INSERT statement does not provide a
value for the column ZIP, the value of :NEW.ZIP is NULL.This value is used in the WHERE clause of
the SELECT INTO statement. As a result, the SELECT INTO statement is unable to return data.
Therefore, the trigger raises a NO_DATA_FOUND exception.


B) Modify this trigger so that another error message is displayed when an INSERT statement is
missing a value for the column ZIP.
*/


-- ch13_1b.sql, version 2.0
CREATE OR REPLACE TRIGGER instructor_bi
BEFORE INSERT ON INSTRUCTOR
FOR EACH ROW
DECLARE
  v_work_zip CHAR(1);
BEGIN
  :NEW.CREATED_BY    := USER;
  :NEW.CREATED_DATE  := SYSDATE;
  :NEW.MODIFIED_BY   := USER;
  :NEW.MODIFIED_DATE := SYSDATE;
  IF :NEW.ZIP        IS NULL THEN
    RAISE_APPLICATION_ERROR (-20002, 'Zip code is missing!');
  ELSE
    SELECT 'Y' INTO v_work_zip FROM zipcode WHERE zip = :NEW.ZIP;
  END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR (-20001, 'Zip code is not valid!');
END;


/*
C) Modify this trigger so that there is no need to supply the value for the instructor�s ID at the time
of the INSERT statement.

:NEW.INSTRUCTOR_ID := INSTRUCTOR_ID_SEQ.NEXTVAL;
*/

-------------------------------------------------------------------------------------------


--Types of Triggers


--statement trigger �rnek
--sadece i? g�nleri DML �al??t?r?labilecek
CREATE OR REPLACE TRIGGER instructor_biud
BEFORE INSERT OR UPDATE OR DELETE ON INSTRUCTOR
DECLARE
  v_day VARCHAR2(10);
BEGIN
  v_day := RTRIM(TO_CHAR(SYSDATE, 'DAY'));
  IF v_day LIKE ('S%') THEN
    RAISE_APPLICATION_ERROR (-20000, 'A table cannot be modified during off hours');
  END IF;
END;


--yetkileri kontrol et yoksa sys ile yetki atamas? yap?lacak
CREATE VIEW INSTRUCTOR_SUMMARY_VIEW
AS
SELECT i.instructor_id, COUNT(s.section_id) total_courses
FROM instructor i
LEFT OUTER JOIN section s
ON (I.INSTRUCTOR_ID = S.INSTRUCTOR_ID)
GROUP BY i.instructor_id;



DELETE FROM INSTRUCTOR_SUMMARY_VIEW
WHERE instructor_id = 109;



CREATE OR REPLACE TRIGGER instructor_summary_del
INSTEAD OF DELETE ON instructor_summary_view
FOR EACH ROW
BEGIN
  DELETE FROM instructor WHERE INSTRUCTOR_ID = :OLD.INSTRUCTOR_ID;
END;



DELETE FROM INSTRUCTOR_SUMMARY_VIEW
WHERE instructor_id = 109;


--13.2.1 Use Row and Statement Triggers


-- ch13_2a.sql, version 1.0
CREATE OR REPLACE TRIGGER course_bi
BEFORE INSERT ON COURSE
FOR EACH ROW
BEGIN
  :NEW.COURSE_NO     := COURSE_NO_SEQ.NEXTVAL;
  :NEW.CREATED_BY    := USER;
  :NEW.CREATED_DATE  := SYSDATE;
  :NEW.MODIFIED_BY   := USER;
  :NEW.MODIFIED_DATE := SYSDATE;
END;



/*
A) What type of trigger is created on the COURSE table�row or statement? Explain your answer.


B) Based on the answer you just provided, explain why this particular type is chosen for the trigger.

ANSWER: This trigger is a row trigger because its operations depend on the data in the individual
records. For example, for every record inserted into the COURSE table, the trigger calculates
the value for the column COURSE_NO. All values in this column must be unique, because it is
defined as a primary key. A row trigger guarantees that every record added to the COURSE table
has a unique number assigned to the COURSE_NO column.


C) When an INSERT statement is issued against the COURSE table, which actions does the trigger
perform?

ANSWER: First, the trigger assigns a unique number derived from the sequence
COURSE_NO_SEQ to the filed COURSE_NO_SEQ to the filed COURSE_NO OF THE :NEW
PSEUDORECORD. Then, the values containing the current user�s name and date are assigned to
the fields CREATED_BY, MODIFIED_BY, CREATED_DATE, and MODIFIED_DATE of the :NEW
pseudorecord.


D) Modify this trigger so that if a prerequisite course is supplied at the time of the insert, its value is
checked against the existing courses in the COURSE table.
*/

-- ch13_2b.sql, version 2.0
CREATE OR REPLACE TRIGGER course_bi
BEFORE INSERT ON COURSE
FOR EACH ROW
DECLARE
  v_prerequisite COURSE.COURSE_NO%TYPE;
BEGIN
  IF :NEW.PREREQUISITE IS NOT NULL THEN
    SELECT course_no
    INTO v_prerequisite
    FROM course
    WHERE course_no = :NEW.PREREQUISITE;
  END IF;
  :NEW.COURSE_NO     := COURSE_NO_SEQ.NEXTVAL;
  :NEW.CREATED_BY    := USER;
  :NEW.CREATED_DATE  := SYSDATE;
  :NEW.MODIFIED_BY   := USER;
  :NEW.MODIFIED_DATE := SYSDATE;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR (-20002, 'Prerequisite is not
valid!');
END;

--test i�in dene
INSERT INTO COURSE (DESCRIPTION, COST, PREREQUISITE)
VALUES ('Test Course', 0, 999);



--13.2.2 Use INSTEAD OF Triggers


CREATE VIEW student_address AS
SELECT s.student_id,
  s.first_name,
  s.last_name,
  s.street_address,
  z.city,
  z.state,
  z.zip
FROM student s
JOIN ZIPCODE Z
ON (s.zip = z.zip);



-- ch13_3a.sql, version 1.0
CREATE OR REPLACE TRIGGER student_address_ins
INSTEAD OF INSERT ON student_address
FOR EACH ROW
BEGIN
  INSERT
  INTO STUDENT
    (
      student_id,
      first_name,
      last_name,
      street_address,
      zip,
      registration_date,
      created_by,
      created_date,
      modified_by,
      modified_date
    )
    VALUES
    (
      :NEW.student_id,
      :NEW.first_name,
      :NEW.last_name,
      :NEW.street_address,
      :NEW.zip,
      SYSDATE,
      USER,
      SYSDATE,
      USER,
      SYSDATE
    );
END;



--test i�in ikisini de dene
INSERT INTO student_address
VALUES (STUDENT_ID_SEQ.NEXTVAL, 'John', 'Smith', '123 Main Street',
'New York', 'NY', '10019');

INSERT INTO student_address
VALUES (STUDENT_ID_SEQ.NEXTVAL, 'John', 'Smith', '123 Main Street',
'New York', 'NY', '12345');



/*
B) Explain why the second INSERT statement causes an error.


C) Modify the trigger so that it checks the value of the zip code provided by the INSERT statement
against the ZIPCODE table and raises an error if there is no such value.
*/

-- ch13_3b.sql, version 2.0
CREATE OR REPLACE TRIGGER student_address_ins
INSTEAD OF INSERT ON student_address
FOR EACH ROW
DECLARE
  v_zip VARCHAR2(5);
BEGIN
  SELECT zip INTO v_zip FROM zipcode WHERE zip = :NEW.ZIP;
  INSERT
  INTO STUDENT
    (
      student_id,
      first_name,
      last_name,
      street_address,
      zip,
      registration_date,
      created_by,
      created_date,
      modified_by,
      modified_date
    )
    VALUES
    (
      :NEW.student_id,
      :NEW.first_name,
      :NEW.last_name,
      :NEW.street_address,
      :NEW.zip,
      SYSDATE,
      USER,
      SYSDATE,
      USER,
      SYSDATE
    );
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR (-20002, 'Zip code is not valid!');
END;


/*
D) Modify the trigger so that it checks the value of the zip code provided by the INSERT statement
against the ZIPCODE table. If the ZIPCODE table has no corresponding record, the trigger should
create a new record for the given value of zip before adding a new record to the STUDENT table.
*/

-- ch13_3c.sql, version 3.0
CREATE OR REPLACE TRIGGER student_address_ins
INSTEAD OF INSERT ON student_address
FOR EACH ROW
DECLARE
  v_zip VARCHAR2(5);
BEGIN
  BEGIN
    SELECT zip INTO v_zip FROM zipcode WHERE zip = :NEW.zip;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT
    INTO ZIPCODE
      (
        zip,
        city,
        state,
        created_by,
        created_date,
        modified_by,
        modified_date
      )
      VALUES
      (
        :NEW.zip,
        :NEW.city,
        :NEW.state,
        USER,
        SYSDATE,
        USER,
        SYSDATE
      );
  END;
  INSERT
  INTO STUDENT
    (
      student_id,
      first_name,
      last_name,
      street_address,
      zip,
      registration_date,
      created_by,
      created_date,
      modified_by,
      modified_date
    )
    VALUES
    (
      :NEW.student_id,
      :NEW.first_name,
      :NEW.last_name,
      :NEW.street_address,
      :NEW.zip,
      SYSDATE,
      USER,
      SYSDATE,
      USER,
      SYSDATE
    );
END;














