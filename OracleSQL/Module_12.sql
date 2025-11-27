--MODULE 12
-----------


--Advanced Cursors
------------------


--Using Parameters with Cursors and Complex Nested Cursors

CURSOR c_zip (p_state IN zipcode.state%TYPE)
IS
  SELECT zip, city, state FROM ZIPCODE WHERE state = p_state;


--12.1.1 Use Parameters in a Cursor

/*
A) Complete the code for the parameter cursor that was begun in the preceding example. Include
a DBMS_OUTPUT line that displays the zip code, city, and state.This is identical to the process
you have already used in a CURSOR FOR loop, only now, when you open the cursor, you pass a
parameter.
*/

-- ch12_17a.sql
DECLARE
  CURSOR c_zip (p_state IN zipcode.state%TYPE)
  IS
    SELECT zip, city, state FROM ZIPCODE WHERE state = p_state;
BEGIN
  FOR r_zip IN c_zip('NJ')
  LOOP
     DBMS_OUTPUT.PUT_LINE(R_ZIP.CITY || ' ' ||R_ZIP.ZIP || ' ' ||r_zip.state);
  END LOOP;
END;


--12.1.2 Use Complex Nested Cursors


--Grantparent, parent, child cursor olmak �zere 3 farkl? cursor tan?mlan?yor.
--�?rencinin ad?, kusrun ad? ve ald??? notlar g�steriliyor
-- ch12_1a.sql
SET SERVEROUTPUT ON
DECLARE
  CURSOR c_student
  IS
    SELECT first_name,
      last_name,
      student_id
    FROM student
    WHERE last_name LIKE 'J%';
  CURSOR c_course (i_student_id IN student.student_id%TYPE)
  IS
    SELECT c.description,
      s.section_id sec_id
    FROM course c,
      section s,
      enrollment e
    WHERE e.student_id = i_student_id
    AND c.course_no    = s.course_no
    AND s.section_id   = e.section_id;
  CURSOR c_grade(i_section_id IN section.section_id%TYPE, i_student_id IN student.student_id%TYPE)
  IS
    SELECT gt.description grd_desc,
      TO_CHAR (AVG(g.numeric_grade), '999.99') num_grd
    FROM enrollment e,
      grade g,
      grade_type gt
    WHERE e.section_id    = i_section_id
    AND e.student_id      = g.student_id
    AND e.student_id      = i_student_id
    AND e.section_id      = g.section_id
    AND g.grade_type_code = gt.grade_type_code
    GROUP BY gt.description ;
BEGIN
  FOR r_student IN c_student
  LOOP
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(r_student.first_name|| ' '||r_student.last_name);
    FOR r_course IN c_course(r_student.student_id)
    LOOP
      DBMS_OUTPUT.PUT_LINE ('Grades for course :'|| r_course.description);
      FOR r_grade IN c_grade(r_course.sec_id, r_student.student_id)
      LOOP
        DBMS_OUTPUT.PUT_LINE(r_grade.num_grd|| ' '||r_grade.grd_desc);
      END LOOP;
    END LOOP;
  END LOOP;
END;

-----------------------------------------------------------------------------------


--FOR UPDATE and WHERE CURRENT Cursors


--12.2.1 For UPDATE and WHERE CURRENT Cursors

--Fiyat? 2500 den az olan kurslar?n fiyat?na 10 dolar zam yap?ls?n
DECLARE
  CURSOR c_course
  IS
    SELECT course_no, cost FROM course FOR UPDATE;
BEGIN
  FOR r_course IN c_course
  LOOP
    IF r_course.cost < 2500 THEN
      UPDATE course
      SET cost        = r_course.cost + 10
      WHERE course_no = r_course.course_no;
      --where CURRENT OF c_course; -- oanki işlem yapılan satırı belirtir
    END IF;
  END LOOP;
END;



/*
A) In this example, where should the COMMIT be placed? What issues are involved in deciding where
to place a COMMIT in this example?

ANSWER: Placing a COMMIT after each update can be costly. But if there are a lot of updates and
the COMMIT comes after the block loop, the rollback segment might not be large enough.
Normally, the COMMIT would go after the loop, except when the transaction count is high. In that
case you might want to code something that does a COMMIT for every 10,000 records. If this were
part of a large procedure, you may want to put a SAVEPOINT after the loop.Then, if you needed to
roll back this update later, this would be easy.

*/


/*
B) What do you think will happen if you run the code in the following example? After making your
analysis, run the code, and then perform a SELECT statement to determine if your guess is correct.
*/


--135 nolu kursa kay?t olan �?rencilerin final notlar? 90 olarak g�ncelleniyor
-- Ayr? bir session da enrollment tablosuna update dene ard?ndan her ikisini de rollback yap
-- ch12_3a.sql
DECLARE
  CURSOR c_grade( i_student_id IN enrollment.student_id%TYPE, i_section_id IN enrollment.section_id%TYPE)
  IS
    SELECT final_grade
    FROM enrollment
    WHERE student_id = i_student_id
    AND section_id   = i_section_id FOR UPDATE;
  CURSOR c_enrollment
  IS
    SELECT e.student_id,
      e.section_id
    FROM enrollment e,
      section s
    WHERE s.course_no = 135
    AND e.section_id  = s.section_id;
BEGIN
  FOR r_enroll IN c_enrollment
  LOOP
    FOR r_grade IN c_grade(r_enroll.student_id, r_enroll.section_id)
    LOOP
      UPDATE enrollment
      SET final_grade  = 90
      WHERE student_id = r_enroll.student_id
      AND section_id   = r_enroll.section_id;
    END LOOP;
  END LOOP;
END;

/*
C) Where should the COMMIT go in the preceding example? Explain the considerations.

ANSWER: The COMMIT should go immediately after the update to ensure that each update is
committed into the database.
FOR UPDATE OF can be used when creating a cursor FOR UPDATE that is based on multiple tables.
FOR UPDATE OF locks the rows of a table that both contain one of the specified columns and are
members of the active set. In other words, it is the means of specifying which table you want to
lock. If the FOR UPDATE OF clause is used, rows may not be fetched from the cursor until a
COMMIT has been issued.
*/


/*
D) What changes to the database take place if the following example is run? Explain specifically what
is being locked, as well as when it is locked and when it is released.
*/

-- ch12_4a.sql
DECLARE
  CURSOR c_stud_zip
  IS
    SELECT s.student_id,
      z.city
    FROM student s,
      zipcode z
    WHERE z.city = 'Brooklyn'
    AND s.zip    = z.zip FOR UPDATE OF phone;
BEGIN
  FOR r_stud_zip IN c_stud_zip
  LOOP
    UPDATE student
    SET phone = '718'
      ||SUBSTR(phone,4)
    WHERE student_id = r_stud_zip.student_id;
  END LOOP;
END;

/*
ANSWER: The phone numbers of students living in Brooklyn are being updated to change the
area code to 718.The cursor declaration only locks the phone column of the student table.The
lock is never released because there is no COMMIT or ROLLBACK statement.
*/



--WHERE CURRENT OF Kullan?m?
--update c�mlesinde kullan?l?r. where ?art?n?n yaz?lmas?na gerek kalmaz. where current of ile o anki sat?r i�in i?lem yap?l?r
-- ch12_5a.sql
DECLARE
  CURSOR c_stud_zip
  IS
    SELECT s.student_id,
      z.city
    FROM student s,
      zipcode z
    WHERE z.city = 'Brooklyn'
    AND s.zip    = z.zip FOR UPDATE OF phone;
BEGIN
  FOR r_stud_zip IN c_stud_zip
  LOOP
    DBMS_OUTPUT.PUT_LINE(r_stud_zip.student_id);
    UPDATE student SET phone = '718'||SUBSTR(phone,4) WHERE CURRENT OF c_stud_zip;
  END LOOP;
END;


/*
E) Compare the two preceding examples. Explain their similarities and differences.What has been
altered by using the WHERE CURRENT OF clause? What is the advantage of doing this?

ANSWER: These two statements perform the same update.The WHERE CURRENT OF clause
allows you to eliminate a match in the UPDATE statement, because the update is being performed
for the cursor�s current record only.
*/






