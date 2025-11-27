--MODULE 11
-----------


--Introduction to Cursors
-------------------------


--Cursor Manipulation


--Implicit cursor attribute kullan?m?
SET SERVEROUTPUT ON
BEGIN
  UPDATE student SET first_name = 'B' WHERE first_name LIKE 'B%';
  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
END;


--Implicit cursor �rnek
SET SERVEROUTPUT ON;
DECLARE
  v_first_name VARCHAR2(35);
  v_last_name  VARCHAR2(35);
BEGIN
  SELECT first_name,
    last_name
  INTO v_first_name,
    v_last_name
  FROM student
  WHERE student_id = 123;
  DBMS_OUTPUT.PUT_LINE ('Student name: '|| v_first_name||' '||v_last_name);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no student with student ID 123');
END;



--11.1.1 Make Use of Record Types

--Table-based record type kullan?m?
SET SERVEROUTPUT ON;
DECLARE
  vr_zip ZIPCODE%ROWTYPE;
BEGIN
  SELECT * INTO vr_zip FROM zipcode WHERE rownum < 2;
  DBMS_OUTPUT.PUT_LINE('City: '||vr_zip.city);
  DBMS_OUTPUT.PUT_LINE('State: '||vr_zip.state);
  DBMS_OUTPUT.PUT_LINE('Zip: '||VR_ZIP.ZIP);
END;



/*
A) What happens when the preceding example is run in a SQL Developer session?


B) Explain how the record type vr_student_name is being used in the following example:
*/

DECLARE
  CURSOR c_student_name
  IS
    SELECT FIRST_NAME, LAST_NAME FROM STUDENT;
    
  vr_student_name c_student_name%ROWTYPE;

/*
ANSWER: Record vr_student_name has a structure similar to a row returned by the SELECT
statement defined in the cursor. It contains two attributes�the student�s first and last names.
It is important to note that a cursor-based record can be declared only after its corresponding
cursor has been declared; otherwise, a compilation error will occur.
*/


--11.1.2 Process an Explicit Cursor

/*
A) Write the declaration section of a PL/SQL block. It should define a cursor named c_student
based on the student table, with last_name and first_name concatenated into one item
called name. It also should omit the created_by and modified_by columns.Then declare
a record based on this cursor.
*/

DECLARE
  CURSOR c_student
  IS
    SELECT first_name||' '||Last_name name FROM STUDENT;
  vr_student c_student%ROWTYPE;

/*
B) Add the necessary lines to the PL/SQL block that you just wrote to open the cursor.
*/

BEGIN
  OPEN c_student;


/*
C) In Chapter 6,�Iterative Control: Part I,� you learned how to construct a loop. For the PL/SQL block
that you have been writing, add a loop. Inside the loop, fetch the cursor into the record. Include a
DBMS_OUTPUT line inside the loop so that each time the loop iterates, all the information in the
record is displayed in a SQL*Plus session.
*/

LOOP
  FETCH C_STUDENT INTO VR_STUDENT;
  DBMS_OUTPUT.PUT_LINE(VR_STUDENT.NAME);

/*
D) Continue with the code you have developed by adding a CLOSE statement to the cursor. Is your
code complete now?
*/

CLOSE C_STUDENT;

/*
The code is not complete because there is not a proper way to exit the loop.


E) EXPLAIN WHAT IS OCCURRING IN THE FOLLOWING PL/SQL BLOCK. WHAT WILL BE THE OUTPUT FROM THIS
example?
*/

SET SERVEROUTPUT ON;
DECLARE
  CURSOR c_student_name
  IS
    SELECT first_name, last_name FROM student WHERE rownum <= 5;
  vr_student_name c_student_name%ROWTYPE; --record tanımladı
BEGIN
  OPEN c_student_name;
  LOOP
    FETCH C_STUDENT_NAME INTO VR_STUDENT_NAME;
    EXIT WHEN c_student_name%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Student name: '|| vr_student_name.first_name ||' '||vr_student_name.last_name);
  END LOOP;
  CLOSE C_STUDENT_NAME;
END;

DECLARE
  CURSOR c_student_name
  IS
    SELECT first_name, last_name FROM student WHERE rownum <= 5;
BEGIN
  FOR vr_student_name IN c_student_name
  LOOP
    EXIT WHEN c_student_name%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Student name: '|| vr_student_name.first_name ||' '||vr_student_name.last_name);
  END LOOP;
END;


/*
F) Consider the same example with a single modification. Notice that the DBMS_OUTPUT.PUT_LINE
statement (shown in bold) has been moved outside the loop. Execute this example, and try to
explain why this version of the script produces different output.

Sadece son isim �al???r
*/

SET SERVEROUTPUT ON;
DECLARE
  CURSOR c_student_name
  IS
    SELECT first_name, last_name FROM student WHERE rownum <= 5;
  vr_student_name c_student_name%ROWTYPE;
BEGIN
  OPEN c_student_name;
  LOOP
    FETCH c_student_name INTO vr_student_name;
    EXIT
  WHEN c_student_name%NOTFOUND;
  END LOOP;
  CLOSE c_student_name;
  DBMS_OUTPUT.PUT_LINE('Student name: '|| vr_student_name.first_name||' ' ||vr_student_name.last_name);
END;


/*
G) Explain what is declared in the following example.Describe what is happening to the record, and
explain how this results in the output:
*/

-- 102 nolu e?itmenin ad?, soyad? ve verdi?i section say?s?

SET SERVEROUTPUT ON;
DECLARE
TYPE instructor_info IS RECORD
  (
    first_name instructor.first_name%TYPE,
    last_name instructor.last_name%TYPE,
    SECTIONS NUMBER
  );
    
  rv_instructor instructor_info;
BEGIN
  SELECT RTRIM(i.first_name),
    RTRIM(i.last_name),
    COUNT(*)
  INTO rv_instructor
  FROM instructor i,
    section s
  WHERE i.instructor_id = s.instructor_id
  AND i.instructor_id   = 102
  GROUP BY i.first_name,
    i.last_name;
  DBMS_OUTPUT.PUT_LINE('Instructor, '|| rv_instructor.first_name|| ' '||rv_instructor.last_name|| ', teaches '||rv_instructor.sections|| ' section(s)');
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no such instructor');
END;



--11.1.3 Make Use of Cursor Attributes


/*
A) Now that you know about cursor attributes, you can use one of them to exit the loop within the
code you developed in the previous example. Can you make a fully executable block now? Why or
why not?

ANSWER: You can make use of the attribute %NOTFOUND to close the loop. It would also be
wise to add an exception clause to the end of the block to close the cursor if it is still open. If you
add the following statements to the end of your block, it will be complete:
*/

EXIT
WHEN c_student%NOTFOUND;
END LOOP;
CLOSE c_student;
EXCEPTION
WHEN OTHERS THEN
  IF c_student%ISOPEN THEN
    CLOSE c_student;
  END IF;
END;


/*
B) What will happen if the following code is run? Describe what is happening in each phase of the
example.
*/

--zip nosu 07002 olan city i�in SQL%ROWCOUNT kullan?m?
-- ch11_3a.sql
SET SERVEROUTPUT ON
DECLARE
  v_city zipcode.city%type;
BEGIN
  SELECT city INTO v_city FROM zipcode WHERE zip = 07002;
  IF SQL%ROWCOUNT = 1 THEN
    DBMS_OUTPUT.PUT_LINE(v_city ||' has a '|| 'zipcode of 07002');
  ELSIF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('The zipcode 07002 is '|| ' not in the database');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Stop harassing me');
  END IF;
END;


/*
C) Rerun this block, changing 07002 to 99999. What do you think will happen? Explain.

no data found hatas? al?n?r. exception blo?u yaz?lmal?d?r
*/



--11.1.4 Put It All Together

-- �?renci id si 110 dan k���k olan kay?tlar cursor ile getirilsin ve id leri ekranda g�sterilsin
-- ch11_4a.sql
DECLARE
  v_sid student.student_id%TYPE;
  CURSOR c_student
  IS
    SELECT student_id FROM student WHERE student_id < 110;
BEGIN
  OPEN c_student;
  LOOP
    FETCH C_STUDENT INTO V_SID;
    EXIT WHEN c_student%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('STUDENT ID : '||v_sid);
  END LOOP;
  CLOSE c_student;
EXCEPTION
WHEN OTHERS THEN
  IF c_student%ISOPEN THEN
    CLOSE c_student;
  END IF;
END;



/*
B) Modify the example to make use of the cursor attributes %FOUND and %ROWCOUNT.
*/

-- ch11_5a.sql
SET SERVEROUTPUT ON
DECLARE
  v_sid student.student_id%TYPE;
  CURSOR c_student
  IS
    SELECT student_id FROM student WHERE student_id < 110;
BEGIN
  OPEN c_student;
  LOOP
    FETCH c_student INTO v_sid;
    IF c_student%FOUND THEN
      DBMS_OUTPUT.PUT_LINE ('Just FETCHED row ' ||TO_CHAR(c_student%ROWCOUNT)|| ' Student ID: '||v_sid);
    ELSE
      EXIT;
    END IF;
  END LOOP;
  CLOSE c_student;
EXCEPTION
WHEN OTHERS THEN
  IF c_student%ISOPEN THEN
    CLOSE c_student;
  END IF;
END;



/*
C) Demonstrate how to fetch a cursor that has data from the student table into a %ROWTYPE. Select
only students who have a student_id of less than 110.The columns are STUDENT_ID,
LAST_NAME, FIRST_NAME, and a count of the number of classes they are enrolled in (using the
enrollment table). Fetch the cursor with a loop, and then output all the columns.You will have to
use an alias for the enrollment count.
*/

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_student_enroll
  IS
    SELECT s.student_id,
      first_name,
      last_name,
      COUNT(*) enroll,
      (
      CASE
        WHEN COUNT(*) = 1
        THEN ' class.'
        WHEN COUNT(*) IS NULL
        THEN ' no classes.'
        ELSE ' classes.'
      END) class
    FROM student s,
      enrollment e
    WHERE s.student_id = e.student_id
    AND s.student_id   <110
    GROUP BY s.student_id,
      first_name,
      last_name;
  r_student_enroll c_student_enroll%ROWTYPE;
BEGIN
  OPEN c_student_enroll;
  LOOP
    FETCH c_student_enroll INTO r_student_enroll;
    EXIT WHEN c_student_enroll%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Student INFO: ID '|| r_student_enroll.student_id||' is '|| r_student_enroll.first_name|| ' ' || r_student_enroll.last_name|| ' is enrolled in '||r_student_enroll.enroll|| r_student_enroll.class);
  END LOOP;
  CLOSE c_student_enroll;
EXCEPTION
WHEN OTHERS THEN
  IF c_student_enroll %ISOPEN THEN
    CLOSE c_student_enroll;
  END IF;
END;

-------------------------------------------------------------------------------------------



--Using Cursor FOR Loops and Nested Cursors

--bo? bir tablo olu?tur

CREATE TABLE TABLE_LOG
(description VARCHAR2(250));

select * from TABLE_LOG;

--id si 110 dan klüçük olan �?rencileri cursor FOR loop ile olu?turulan tabloya kaydet
-- ch11_7a.sql
DECLARE
  CURSOR c_student
  IS
    SELECT student_id, last_name, first_name FROM student WHERE student_id < 110;
BEGIN
  FOR r_student IN c_student
  LOOP
    INSERT INTO table_log VALUES
      (r_student.last_name
      );
  END LOOP;
END;

select * from TABLE_LOG;

--11.2.1 Use a Cursor FOR Loop

/*
A) Write a PL/SQL block that reduces the cost of all courses by 5 percent for courses having an enrollment
of eight students or more.Use a cursor FOR loop that updates the course table.
*/

--Kay?t olmu? �?renci say?s? 8 veya daha fazla olan kurslar?n fiyatlar?n? %5 d�?�relim
-- ch11_7b.sql
DECLARE
  CURSOR c_group_discount
  IS
    SELECT DISTINCT s.course_no
    FROM section s,
      enrollment e
    WHERE s.section_id = e.section_id
    GROUP BY s.course_no,
      e.section_id,
      s.section_id
    HAVING COUNT(*)>=8;
BEGIN
  FOR r_group_discount IN c_group_discount
  LOOP
    UPDATE course
    SET cost        = cost * .95
    WHERE course_no = r_group_discount.course_no;
  END LOOP;
  COMMIT;
END;



--11.2.2 Process Nested Cursors


--zipcode tablosunda state bilgisi CT olan kay?tlar cursor ile al?ns?n.
--Ayr?ca student tablosundan ilk cursor ile gelen zip konuna sahip kay?tlar getirilen bir cursor daha tan?mlans?n
--?ki cursor i� i�e yaz?larak her bir ?ehirde ya?ayan �?rencilerin isimleri g�sterilsin
-- ch11_8a.sql
DECLARE
  v_zip zipcode.zip%TYPE;
  v_student_flag CHAR;
  CURSOR c_zip
  IS
    SELECT zip, city, state FROM zipcode WHERE state = 'CT';
  CURSOR c_student
  IS
    SELECT first_name, last_name FROM student WHERE zip = v_zip;
BEGIN
  FOR r_zip IN c_zip
  LOOP
    v_student_flag := 'N';
    v_zip          := r_zip.zip;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Students living in '|| r_zip.city);
    FOR r_student IN c_student
    LOOP
      DBMS_OUTPUT.PUT_LINE( r_student.first_name|| ' '||r_student.last_name);
      v_student_flag := 'Y';
    END LOOP;
    IF v_student_flag = 'N' THEN
      DBMS_OUTPUT.PUT_LINE ('No Students for this zipcode');
    END IF;
  END LOOP;
END;


/*
A) Write a PL/SQL block with two cursor for loops.The parent cursor will call the student_id,
first_name, and last_name from the student table for students with a student_id less
than 110 and output one line with this information. For each student, the child cursor will loop
through all the courses that the student is enrolled in, outputting the course_no and the
description.
*/

--id si 110 dan k���k olan �?rencileri bir cursor ile getir
--ilk cursor ile gelen �?rencinin idsini kullanarak kay?tl? oldu?u kurslar?n bilgisini getiren ikinci bir cursor olu?tur
-- ch11_09a.sql
SET SERVEROUTPUT ON
DECLARE
  v_sid student.student_id%TYPE;
  CURSOR c_student
  IS
    SELECT student_id, first_name, last_name FROM student WHERE student_id < 110;
  CURSOR c_course
  IS
    SELECT c.course_no,
      c.description
    FROM course c,
      section s,
      enrollment e
    WHERE c.course_no = s.course_no
    AND s.section_id  = e.section_id
    AND e.student_id  = v_sid;
BEGIN
  FOR r_student IN c_student
  LOOP
    v_sid := r_student.student_id;
    DBMS_OUTPUT.PUT_LINE(chr(10));
    DBMS_OUTPUT.PUT_LINE(' The Student '|| r_student.student_id||' '|| r_student.first_name||' '|| r_student.last_name);
    DBMS_OUTPUT.PUT_LINE(' is enrolled in the '|| 'following courses: ');
    FOR r_course IN c_course
    LOOP
      DBMS_OUTPUT.PUT_LINE(r_course.course_no|| ' '||r_course.description);
    END LOOP;
  END LOOP;
END;











