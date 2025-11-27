--MODULE 14
------------


--Compound Triggers
--------------------


--Mutating Table Issues

--section tablosu mutating oluyor. 10 veya daha fazla section da ders veren e?itmen i�in uyar? hatas? veriliyor
CREATE OR REPLACE TRIGGER section_biu
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW
DECLARE
  v_total NUMBER;
  v_name  VARCHAR2(30);
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM section -- SECTION is MUTATING
  WHERE instructor_id = :NEW.instructor_id;
  -- check if the current instructor is overbooked
  IF v_total >= 10 THEN
    SELECT first_name
      ||' '
      ||last_name
    INTO v_name
    FROM instructor
    WHERE instructor_id = :NEW.instructor_id;
    RAISE_APPLICATION_ERROR (-20000, 'Instructor, '||v_name||', is overbooked');
  END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR (-20001, 'This is not a valid instructor');
END;


--section tablosu mutating oluyor. update edilerek. �zerinde de update edildi?inde tan?ml? olan trigger var
--dolay?s?yla bu update i?leminde mutating table hatas? al?nacak
UPDATE section
SET INSTRUCTOR_ID = 101
WHERE section_id = 80;


--11g �ncesi mutating table hatas?n?n ��z�m�

--1)--global de?i?kenlerin tutulaca?? package tan?mla

CREATE OR REPLACE PACKAGE instructor_adm AS
v_instructor_id instructor.instructor_id%TYPE;
V_INSTRUCTOR_NAME VARCHAR2(50);
END;

--2)--var olan triggeri g�ncelle. global de?i?kenleri initialize et

CREATE OR REPLACE TRIGGER section_biu
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW
BEGIN
  IF :NEW.instructor_id IS NOT NULL THEN
    BEGIN
      instructor_adm.v_instructor_id := :NEW.INSTRUCTOR_ID;
      SELECT first_name
        ||' '
        ||last_name
      INTO instructor_adm.v_instructor_name
      FROM instructor
      WHERE instructor_id = instructor_adm.v_instructor_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20001, 'This is not a valid instructor');
    END;
  END IF;
END;

--3)--yeni bir after statement level trigger tan?mla

CREATE OR REPLACE TRIGGER section_aiu
AFTER INSERT OR UPDATE ON section
DECLARE
  v_total INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM section
  WHERE instructor_id = instructor_adm.v_instructor_id;
  -- check if the current instructor is overbooked
  IF v_total >= 10 THEN
    RAISE_APPLICATION_ERROR (-20000, 'Instructor, '||instructor_adm.v_instructor_name|| ', is overbooked');
  END IF;
END;

--sonucunu test et
UPDATE section
SET INSTRUCTOR_ID = 110
WHERE section_id = 80;



--14.1.1 Understand Mutating Tables

--mutating table hatas? al?nacak trigger olu?turulur
-- ch14_1a.sql, version 1.0
CREATE OR REPLACE TRIGGER enrollment_biu
BEFORE INSERT OR UPDATE ON enrollment
FOR EACH ROW
DECLARE
  v_total NUMBER;
  v_name  VARCHAR2(30);
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM enrollment
  WHERE student_id = :NEW. student_id;
  -- check if the current student is enrolled in too
  -- many courses
  IF v_total >= 3 THEN
    SELECT first_name
      ||' '
      ||last_name
    INTO v_name
    FROM student
    WHERE student_id = :NEW.STUDENT_ID;
    RAISE_APPLICATION_ERROR (-20000, 'Student, '||v_name|| ', is registered for 3 courses already');
  END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR (-20001, 'This is not a valid student');
END;


--�al??t?rmay? dene

--ORA -20000 kullan?c? tan?ml? hata
INSERT INTO ENROLLMENT
(student_id, section_id, enroll_date, created_by, created_date,
modified_by, modified_date)
VALUES (184, 98, SYSDATE, USER, SYSDATE, USER, SYSDATE);

--hata yok
INSERT INTO ENROLLMENT
(student_id, section_id, enroll_date, created_by, created_date,
modified_by, modified_date)
VALUES (399, 98, SYSDATE, USER, SYSDATE, USER, SYSDATE);

--mutating table hatas? al?n?r
UPDATE ENROLLMENT
SET STUDENT_ID = 399
WHERE student_id = 283;


/*
B) Explain why two of the statements did not succeed.


C) Modify the trigger so that it does not cause a mutating table error when an UPDATE statement is
issued against the ENROLLMENT table.
*/

--1)

CREATE OR REPLACE PACKAGE student_adm AS
v_student_id student.student_id%TYPE;
V_STUDENT_NAME VARCHAR2(50);
END;


--2)

CREATE OR REPLACE TRIGGER enrollment_biu
BEFORE INSERT OR UPDATE ON enrollment
FOR EACH ROW
BEGIN
  IF :NEW.STUDENT_ID IS NOT NULL THEN
    BEGIN
      student_adm.v_student_id := :NEW. student_id;
      SELECT first_name
        ||' '
        ||last_name
      INTO student_adm.v_student_name
      FROM student
      WHERE student_id = student_adm.v_student_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20001, 'This is not a valid student');
    END;
  END IF;
END;

--3)

CREATE OR REPLACE TRIGGER enrollment_aiu
AFTER INSERT OR UPDATE ON enrollment
DECLARE
  v_total INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM enrollment
  WHERE student_id = student_adm.v_student_id;
  -- check if the current student is enrolled in too
  -- many courses
  IF v_total >= 3 THEN
    RAISE_APPLICATION_ERROR (-20000, 'Student, '|| student_adm.v_student_name|| ', is registered for 3 courses already ');
  END IF;
END;

---------------------------------------------------------------------------------------------


--Compound Triggers

--Sadece before statement ve before each row tan?ml? compound trigger
--i? g�nlerinde insert edilmesini sa?layan ve insert edilmeden �nce initialize eden triggerlar yaz?l?yor

CREATE OR REPLACE TRIGGER student_compound
FOR INSERT ON STUDENT
COMPOUND TRIGGER
-- Declaration section
v_day  VARCHAR2(10);
v_date DATE;
v_user VARCHAR2(30);
BEFORE STATEMENT
IS
BEGIN
  v_day := RTRIM(TO_CHAR(SYSDATE, 'DAY'));
  IF v_day LIKE ('S%') THEN
    RAISE_APPLICATION_ERROR (-20000, 'A table cannot be modified during off hours');
  END IF;
  v_date := SYSDATE;
  v_user := USER;
END BEFORE STATEMENT;
BEFORE EACH ROW
IS
BEGIN
  :NEW.student_id    := STUDENT_ID_SEQ.NEXTVAL;
  :NEW.created_by    := v_user;
  :NEW.created_date  := v_date;
  :NEW.modified_by   := v_user;
  :NEW.modified_date := v_date;
END BEFORE EACH ROW;
END student_compound;



--�nceki mod�lde yaz?lan mutating table hatas? veren trigger

CREATE OR REPLACE TRIGGER section_biu
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW
DECLARE
  v_total NUMBER;
  v_name  VARCHAR2(30);
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM section -- SECTION is MUTATING
  WHERE instructor_id = :NEW.instructor_id;
  -- check if the current instructor is overbooked
  IF v_total >= 10 THEN
    SELECT first_name
      ||' '
      ||last_name
    INTO v_name
    FROM instructor
    WHERE instructor_id = :NEW.instructor_id;
    RAISE_APPLICATION_ERROR (-20000, 'Instructor, '||v_name||', is overbooked');
  END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR (-20001, 'This is not a valid instructor');
END;



--COMPOUND TRIGGER ile çözümü
-- bir tablo üzerinde birden fazla trigger tanımlanacaksa compound trigger kullanmak daha mantıklı
CREATE OR REPLACE TRIGGER section_compound
FOR INSERT OR UPDATE ON SECTION
COMPOUND TRIGGER
-- Declaration Section
v_instructor_id INSTRUCTOR.INSTRUCTOR_ID%TYPE;
v_instructor_name VARCHAR2(50);
v_total           INTEGER;
BEFORE EACH ROW
IS
BEGIN
  IF :NEW.instructor_id IS NOT NULL THEN
    BEGIN
      v_instructor_id := :NEW.instructor_id;
      SELECT first_name
        ||' '
        ||last_name
      INTO v_instructor_name
      FROM instructor
      WHERE instructor_id = v_instructor_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20001, 'This is not a valid instructor');
    END;
  END IF;
END BEFORE EACH ROW;
AFTER STATEMENT
IS
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM section
  WHERE instructor_id = v_instructor_id;
  -- check if the current instructor is overbooked
  IF v_total >= 10 THEN
    RAISE_APPLICATION_ERROR (-20000, 'Instructor, '||v_instructor_name|| ', is overbooked');
  END IF;
END AFTER STATEMENT;
END section_compound;


--test et, kullan?c? hatas? al?n?r
UPDATE section
SET INSTRUCTOR_ID = 101
WHERE section_id = 80;


--14.2.1 Understand Compound Triggers

--�nceki lab da yap?lan de?i?iklikler kald?r?l?yor
DROP TRIGGER enrollment_biu;
DROP TRIGGER enrollment_aiu;
DROP PACKAGE student_adm;
DELETE FROM enrollment
WHERE STUDENT_ID = 399;
COMMIT;


--yine ayn? DML c�mlelerini �al??t?rmay? dene
--user defined error al?n?r
INSERT INTO ENROLLMENT
(student_id, section_id, enroll_date, created_by, created_date,
modified_by, modified_date)
VALUES (184, 98, SYSDATE, USER, SYSDATE, USER, SYSDATE);

--hata al?nmaz
INSERT INTO ENROLLMENT
(student_id, section_id, enroll_date, created_by, created_date,
modified_by, modified_date)
VALUES (399, 98, SYSDATE, USER, SYSDATE, USER, SYSDATE);

--mutating table hatas? al?n?r
UPDATE ENROLLMENT
SET STUDENT_ID = 399
WHERE student_id = 283;



/*
A) Create a new compound trigger so that it does not cause a mutating table error when an UPDATE
statement is issued against the ENROLLMENT table.
*/


CREATE OR REPLACE TRIGGER enrollment_compound
FOR INSERT OR UPDATE ON enrollment
COMPOUND TRIGGER
v_student_id STUDENT.STUDENT_ID%TYPE;
v_student_name VARCHAR2(50);
v_total        INTEGER;
BEFORE EACH ROW
IS
BEGIN
  IF :NEW. student_id IS NOT NULL THEN
    BEGIN
      v_student_id := :NEW.student_id;
      SELECT first_name
        ||' '
        ||last_name
      INTO v_student_name
      FROM student
      WHERE student_id = v_student_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20001, 'This is not a valid student');
    END;
  END IF;
END BEFORE EACH ROW;
AFTER STATEMENT
IS
BEGIN
  SELECT COUNT(*) INTO v_total FROM enrollment WHERE student_id = v_student_id;
  -- check if the current student is enrolled in too
  -- many courses
  IF v_total >= 3 THEN
    RAISE_APPLICATION_ERROR (-20000, 'Student, '||v_student_name|| ', is registered for 3 courses already ');
  END IF;
END AFTER STATEMENT;
END enrollment_compound;

/*
B) Run the UPDATE statement listed in the exercise text again. Explain the output produced.
*/

--farkl? bir hata al?n?r. integrity constraint hatas?
UPDATE ENROLLMENT
SET student_id = 399
WHERE student_id = 283;


/*
C) MODIFY THE COMPOUND TRIGGER SO THAT THE TRIGGER POPULATES THE VALUES FOR THE CREATED_BY,
CREATED_DATE, MODIFIED_BY, and MODIFIED_DATE columns.
*/

-- ch14_2b.sql, version 2.0
CREATE OR REPLACE TRIGGER enrollment_compound
FOR INSERT OR UPDATE ON enrollment
COMPOUND TRIGGER
v_student_id STUDENT.STUDENT_ID%TYPE;
v_student_name VARCHAR2(50);
v_total        INTEGER;
v_date         DATE;
v_user STUDENT.CREATED_BY%TYPE;
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
    :NEW.created_date := v_date;
    :NEW.created_by   := v_user;
  ELSIF UPDATING THEN
    :NEW.created_date := :OLD.created_date;
    :NEW.created_by   := :OLD.created_by;
  END IF;
  :NEW.MODIFIED_DATE := v_date;
  :NEW.MODIFIED_BY   := v_user;
  IF :NEW.STUDENT_ID IS NOT NULL THEN
    BEGIN
      v_student_id := :NEW.STUDENT_ID;
      SELECT first_name
        ||' '
        ||last_name
      INTO v_student_name
      FROM student
      WHERE student_id = v_student_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20001, 'This is not a valid student');
    END;
  END IF;
END BEFORE EACH ROW;
AFTER STATEMENT
IS
BEGIN
  SELECT COUNT(*) INTO v_total FROM enrollment WHERE student_id = v_student_id;
  -- check if the current student is enrolled in too
  -- many courses
  IF v_total >= 3 THEN
    RAISE_APPLICATION_ERROR (-20000, 'Student, '||v_student_name|| ', is registered for 3 courses already ');
  END IF;
END AFTER STATEMENT;
END enrollment_compound;


--test et

--user defined error
INSERT INTO enrollment
(student_id, section_id, enroll_date, final_grade)
VALUES (102, 155, sysdate, null);

--hata yok
INSERT INTO enrollment
(student_id, section_id, enroll_date, final_grade)
VALUES (103, 155, sysdate, null);

--hata yok
UPDATE ENROLLMENT
SET final_grade = 85
WHERE student_id = 105
AND section_id = 155;


ROLLBACK;







