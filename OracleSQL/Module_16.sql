--MODULE 16
-------------


--Records
---------



--Record Types

--table-valued record type
DECLARE
  course_rec course%ROWTYPE;
BEGIN
  SELECT * INTO course_rec FROM course WHERE course_no = 25;
  DBMS_OUTPUT.PUT_LINE ('Course No: '||course_rec.course_no);
  DBMS_OUTPUT.PUT_LINE ('Course Description: '|| course_rec.description);
  DBMS_OUTPUT.PUT_LINE ('Prerequisite: '|| COURSE_REC.PREREQUISITE);
END;


--cursor-based record type

DECLARE
  CURSOR student_cur
  IS
    SELECT first_name,
      last_name,
      registration_date
    FROM student
    WHERE rownum <= 4;
  student_rec student_cur%ROWTYPE;
BEGIN
  OPEN student_cur;
  LOOP
    FETCH student_cur INTO student_rec;
    EXIT
  WHEN student_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE ('Name: '|| student_rec.first_name||' '||student_rec.last_name);
    DBMS_OUTPUT.PUT_LINE ('Registration Date: '|| student_rec.registration_date);
  END LOOP;
END;


--Hatalı kullanım. Önce cursor ardından record tanımlanmalı
DECLARE
  student_rec student_cur%ROWTYPE;
  CURSOR student_cur
  IS
    SELECT first_name,
      last_name,
      registration_date
    FROM student
    WHERE rownum <= 4;
BEGIN
  OPEN student_cur;
  LOOP
    FETCH student_cur INTO student_rec;
    EXIT
  WHEN student_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE ('Name: '|| student_rec.first_name||' '||student_rec.last_name);
    DBMS_OUTPUT.PUT_LINE ('Registration Date: '|| student_rec.registration_date);
  END LOOP;
END;


--user-defined record type

DECLARE
TYPE time_rec_type
IS
  RECORD
  (
    curr_date DATE,
    curr_day  VARCHAR2(12),
    curr_time VARCHAR2(8) := '00:00:00');
  time_rec TIME_REC_TYPE;
BEGIN
  SELECT sysdate INTO time_rec.curr_date FROM dual;
  time_rec.curr_day  := TO_CHAR(time_rec.curr_date, 'DAY');
  time_rec.curr_time := TO_CHAR(time_rec.curr_date, 'HH24:MI:SS');
  DBMS_OUTPUT.PUT_LINE ('Date: '||time_rec.curr_date);
  DBMS_OUTPUT.PUT_LINE ('Day: '||time_rec.curr_day);
  DBMS_OUTPUT.PUT_LINE ('Time: '||TIME_REC.CURR_TIME);
END;


--hatal? kullan?m. not null alan initialize (default de?er) edilmiyor

DECLARE
TYPE sample_type
IS
  RECORD
  (
    field1 NUMBER(3),
    field2 VARCHAR2(3) NOT NULL);
  sample_rec sample_type;
BEGIN
  sample_rec.field1 := 10;
  sample_rec.field2 := 'ABC';
  DBMS_OUTPUT.PUT_LINE ('sample_rec.field1 = '||sample_rec.field1);
  DBMS_OUTPUT.PUT_LINE ('sample_rec.field2 = '||SAMPLE_REC.FIELD2);
END;


--iki farkl? type tamamen ayn? yap?da tan?mlansalar bile birbirine atama i?lemi a?a??daki gibi ger�ekle?tirilemez
DECLARE
TYPE name_type1
IS
  RECORD
  (
    first_name VARCHAR2(15),
    LAST_NAME  VARCHAR2(30));
TYPE name_type2
IS
  RECORD
  (
    first_name VARCHAR2(15),
    last_name  VARCHAR2(30));
  name_rec1 name_type1;
  name_rec2 name_type2;
BEGIN
  name_rec1.first_name := 'John';
  name_rec1.last_name  := 'Smith';
  NAME_REC2            := NAME_REC1; -- illegal assignment
END;



--do?ru atama ?ekli
DECLARE
TYPE name_type1
IS
  RECORD
  (
    first_name VARCHAR2(15),
    last_name  VARCHAR2(30));
  name_rec1 name_type1;
  name_rec2 name_type1;
BEGIN
  name_rec1.first_name := 'John';
  name_rec1.last_name  := 'Smith';
  NAME_REC2            := NAME_REC1; -- no longer illegal assignment
END;



--farkl? tipte olduklar?ndan sorunsuz �al???r. sadece user-defined ile user-defined aras? yap?lamaz
DECLARE
  CURSOR course_cur
  IS
    SELECT * FROM course WHERE rownum <= 4;
TYPE course_type
IS
  RECORD
  (
    course_no     NUMBER(38),
    description   VARCHAR2(50),
    cost          NUMBER(9,2),
    prerequisite  NUMBER(8),
    created_by    VARCHAR2(30),
    created_date  DATE,
    modified_by   VARCHAR2(30),
    modified_date DATE);
  course_rec1 course%ROWTYPE;     -- table-based record
  course_rec2 course_cur%ROWTYPE; -- cursor-based record
  course_rec3 course_type;        -- user-defined record
BEGIN
  -- Populate table-based record
  SELECT *
  INTO course_rec1
  FROM course
  WHERE course_no = 10;
  -- Populate cursor-based record
  OPEN course_cur;
  LOOP
    FETCH course_cur INTO course_rec2;
    EXIT
  WHEN course_cur%NOTFOUND;
  END LOOP;
  course_rec1 := course_rec2;
  COURSE_REC3 := COURSE_REC2;
END;



--16.1.1 Use Table-Based and Cursor-Based Records


-- ch16_1a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  zip_rec zipcode%ROWTYPE;
BEGIN
  SELECT * INTO zip_rec FROM zipcode WHERE ROWNUM < 2;
END;


/*
A) Explain the preceding script.

ANSWER: The declaration portion of the script contains a declaration of the table-based record,
zip_rec, that has the same structure as a row from the ZIPCODE table.The executable portion
of the script populates the zip_rec record using the SELECT INTO statement with a row from
the ZIPCODE table.Notice that a restriction applied to the ROWNUM enforces the SELECT INTO
statement and always returns a random single row. As mentioned earlier, there is no need to reference
individual record fields when the SELECT INTO statement populates the zip_rec record,
because zip_rec has a structure identical to a row of the ZIPCODE table.



B) Modify the script so that zip_rec data is displayed on the screen.
*/

SET SERVEROUTPUT ON
DECLARE
  zip_rec zipcode%ROWTYPE;
BEGIN
  SELECT * INTO zip_rec FROM zipcode WHERE rownum < 2;
  DBMS_OUTPUT.PUT_LINE ('Zip: '||zip_rec.zip);
  DBMS_OUTPUT.PUT_LINE ('City: '||zip_rec.city);
  DBMS_OUTPUT.PUT_LINE ('State: '||zip_rec.state);
  DBMS_OUTPUT.PUT_LINE ('Created By: '||zip_rec.created_by);
  DBMS_OUTPUT.PUT_LINE ('Created Date: '||zip_rec.created_date);
  DBMS_OUTPUT.PUT_LINE ('Modified By: '||zip_rec.modified_by);
  DBMS_OUTPUT.PUT_LINE ('Modified Date: '||ZIP_REC.MODIFIED_DATE);
END;


/*
C) Modify the script created in the preceding exercise (ch16_1b.sql) so that zip_rec is defined as
a cursor-based record.
*/

-- ch16_1c.sql, version 3.0
SET SERVEROUTPUT ON
DECLARE
  CURSOR zip_cur
  IS
    SELECT * FROM zipcode WHERE rownum < 4;
  zip_rec zip_cur%ROWTYPE;
BEGIN
  OPEN zip_cur;
  LOOP
    FETCH zip_cur INTO zip_rec;
    EXIT WHEN zip_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE ('Zip: '||zip_rec.zip);
    DBMS_OUTPUT.PUT_LINE ('City: '||zip_rec.city);
    DBMS_OUTPUT.PUT_LINE ('State: '||zip_rec.state);
    DBMS_OUTPUT.PUT_LINE ('Created By: '||zip_rec.created_by);
    DBMS_OUTPUT.PUT_LINE ('Created Date:'||zip_rec.created_date);
    DBMS_OUTPUT.PUT_LINE ('Modified By:'||zip_rec.modified_by);
    DBMS_OUTPUT.PUT_LINE ('Modified Date:'||zip_rec.modified_date);
  END LOOP;
END;


/*
D) Modify the script created in the preceding exercise (ch16_1c.sql). Change the structure of the
zip_rec record so that it contains the total number of students in a given city, state, and zip
code.Do not include audit columns such as CREATED_BY and CREATED_DATE in the record
structure.
*/


-- ch16_1d.sql, version 4.0
SET SERVEROUTPUT ON SIZE 40000
DECLARE
  CURSOR zip_cur
  IS
    SELECT city,
      state,
      z.zip,
      COUNT(*) students
    FROM zipcode z,
      student s
    WHERE z.zip = s.zip
    GROUP BY city,
      state,
      z.zip;
  zip_rec zip_cur%ROWTYPE;
BEGIN
  OPEN zip_cur;
  LOOP
    FETCH zip_cur INTO zip_rec;
    EXIT
  WHEN zip_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE ('Zip: '||zip_rec.zip);
    DBMS_OUTPUT.PUT_LINE ('City: '||zip_rec.city);
    DBMS_OUTPUT.PUT_LINE ('State: '||zip_rec.state);
    DBMS_OUTPUT.PUT_LINE ('Students: '||zip_rec.students);
  END LOOP;
END;



--16.1.2 Use User-Defined Records


-- ch16_2a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  CURSOR zip_cur
  IS
    SELECT zip, COUNT(*) students FROM student GROUP BY zip;
TYPE zip_info_type
IS
  RECORD
  (
    zip_code VARCHAR2(5),
    students INTEGER);
  zip_info_rec zip_info_type;
BEGIN
  FOR zip_rec IN zip_cur
  LOOP
    zip_info_rec.zip_code := zip_rec.zip;
    zip_info_rec.students := zip_rec.students;
  END LOOP;
END;


/*
B) Modify the script so that zip_info_rec data is displayed on the screen for only the first five
records returned by the ZIP_CUR cursor.
*/

-- ch16_2b.sql, version 2.0
SET SERVEROUTPUT ON
DECLARE
  CURSOR zip_cur
  IS
    SELECT zip, COUNT(*) students FROM student GROUP BY zip;
TYPE zip_info_type
IS
  RECORD
  (
    zip_code VARCHAR2(5),
    students INTEGER);
  zip_info_rec zip_info_type;
  v_counter INTEGER := 0;
BEGIN
  FOR zip_rec IN zip_cur
  LOOP
    zip_info_rec.zip_code := zip_rec.zip;
    zip_info_rec.students := zip_rec.students;
    v_counter             := v_counter + 1;
    IF v_counter <= 5 THEN
      DBMS_OUTPUT.PUT_LINE ('Zip Code: '||zip_info_rec.zip_code);
      DBMS_OUTPUT.PUT_LINE ('Students: '||zip_info_rec.students);
      DBMS_OUTPUT.PUT_LINE ('--------------------');
    END IF;
  END LOOP;
END;


/*
C) Modify the script created in the preceding exercise (ch16_2b.sql). Change the structure of the
zip_info_rec record so that it also contains the total number of instructors for a given zip
code. Populate this new record, and display its data on the screen for the first five records returned
by the ZIP_CUR cursor.
*/

-- ch16_2c.sql, version 3.0
SET SERVEROUTPUT ON
DECLARE
  CURSOR zip_cur
  IS
    SELECT zip FROM zipcode WHERE ROWNUM <= 5;
TYPE zip_info_type
IS
  RECORD
  (
    zip_code    VARCHAR2(5),
    students    INTEGER,
    instructors INTEGER);
  zip_info_rec zip_info_type;
BEGIN
  FOR zip_rec IN zip_cur
  LOOP
    zip_info_rec.zip_code := zip_rec.zip;
    SELECT COUNT(*)
    INTO zip_info_rec.students
    FROM student
    WHERE zip = zip_info_rec.zip_code;
    SELECT COUNT(*)
    INTO zip_info_rec.instructors
    FROM instructor
    WHERE zip = zip_info_rec.zip_code;
    DBMS_OUTPUT.PUT_LINE ('Zip Code: '||zip_info_rec.zip_code);
    DBMS_OUTPUT.PUT_LINE ('Students: '||zip_info_rec.students);
    DBMS_OUTPUT.PUT_LINE ('Instructors:'||zip_info_rec.instructors);
    DBMS_OUTPUT.PUT_LINE ('--------------------');
  END LOOP;
END;


----------------------------------------------------------------------------------

--Nested Records


DECLARE
TYPE name_type
IS
  RECORD
  (
    first_name VARCHAR2(15),
    last_name  VARCHAR2(30));
TYPE person_type
IS
  RECORD
  (
    name name_type,
    street VARCHAR2(50),
    city   VARCHAR2(25),
    state  VARCHAR2(2),
    zip    VARCHAR2(5));
  person_rec person_type;
BEGIN
  SELECT first_name,
    last_name,
    street_address,
    city,
    state,
    zip
  INTO person_rec.name.first_name,
    person_rec.name.last_name,
    person_rec.street,
    person_rec.city,
    person_rec.state,
    person_rec.zip
  FROM student
  JOIN zipcode USING (zip)
  WHERE rownum < 2;
  DBMS_OUTPUT.PUT_LINE ('Name: '|| person_rec.name.first_name||' '||person_rec.name.last_name);
  DBMS_OUTPUT.PUT_LINE ('Street: '||person_rec.street);
  DBMS_OUTPUT.PUT_LINE ('City: '||person_rec.city);
  DBMS_OUTPUT.PUT_LINE ('State: '||person_rec.state);
  DBMS_OUTPUT.PUT_LINE ('Zip: '||PERSON_REC.ZIP);
END;


--16.2.1 Use Nested Records

-- ch16_3a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
TYPE last_name_type
IS
  TABLE OF student.last_name%TYPE INDEX BY BINARY_INTEGER;
TYPE zip_info_type
IS
  RECORD
  (
    zip VARCHAR2(5),
    last_name_tab last_name_type);
  CURSOR name_cur (p_zip VARCHAR2)
  IS
    SELECT last_name FROM student WHERE zip = p_zip;
  zip_info_rec zip_info_type;
  v_zip     VARCHAR2(5) := '&sv_zip';
  v_counter INTEGER     := 0;
BEGIN
  zip_info_rec.zip := v_zip;
  FOR name_rec IN name_cur (v_zip)
  LOOP
    v_counter                             := v_counter + 1;
    zip_info_rec.last_name_tab(v_counter) := name_rec.last_name;
  END LOOP;
END;


/*
B) Modify the script so that zip_info_rec data is displayed on the screen.Make sure that a
value of the zip code is displayed only once. Provide the value of 11368 when running the script.
*/


-- ch16_3b.sql, version 2.0
SET SERVEROUTPUT ON
DECLARE
TYPE last_name_type
IS
  TABLE OF student.last_name%TYPE INDEX BY BINARY_INTEGER;
TYPE zip_info_type
IS
  RECORD
  (
    zip VARCHAR2(5),
    last_name_tab last_name_type);
  CURSOR name_cur (p_zip VARCHAR2)
  IS
    SELECT last_name FROM student WHERE zip = p_zip;
  zip_info_rec zip_info_type;
  v_zip     VARCHAR2(5) := '&sv_zip';
  v_counter INTEGER     := 0;
BEGIN
  zip_info_rec.zip := v_zip;
  DBMS_OUTPUT.PUT_LINE ('Zip: '||zip_info_rec.zip);
  FOR name_rec IN name_cur (v_zip)
  LOOP
    v_counter                             := v_counter + 1;
    zip_info_rec.last_name_tab(v_counter) := name_rec.last_name;
    DBMS_OUTPUT.PUT_LINE ('Names('||v_counter||'): '|| zip_info_rec.last_name_tab(v_counter));
  END LOOP;
END;


/*
C) Modify the script created in the preceding exercise (ch16_3b.sql). Instead of providing a value for
a zip code at runtime, populate using the cursor FOR loop.The SELECT statement associated with
the new cursor should return zip codes that have more than one student in them.
*/


-- ch16_3c.sql, version 3.0
SET SERVEROUTPUT ON SIZE 20000
DECLARE
TYPE last_name_type
IS
  TABLE OF student.last_name%TYPE INDEX BY BINARY_INTEGER;
TYPE zip_info_type
IS
  RECORD
  (
    zip VARCHAR2(5),
    last_name_tab last_name_type);
  CURSOR zip_cur
  IS
    SELECT zip, COUNT(*) FROM student GROUP BY zip HAVING COUNT(*) > 1;
  CURSOR name_cur (p_zip VARCHAR2)
  IS
    SELECT last_name FROM student WHERE zip = p_zip;
  zip_info_rec zip_info_type;
  v_counter INTEGER;
BEGIN
  FOR zip_rec IN zip_cur
  LOOP
    zip_info_rec.zip := zip_rec.zip;
    DBMS_OUTPUT.PUT_LINE ('Zip: '||zip_info_rec.zip);
    v_counter := 0;
    FOR name_rec IN name_cur (zip_info_rec.zip)
    LOOP
      v_counter                             := v_counter + 1;
      zip_info_rec.last_name_tab(v_counter) := name_rec.last_name;
      DBMS_OUTPUT.PUT_LINE ('Names('||v_counter||'): '|| zip_info_rec.last_name_tab(v_counter));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('----------');
  END LOOP;
END;

---------------------------------------------------------------------------------------------------


--Collections of Records


DECLARE
  CURSOR name_cur
  IS
    SELECT first_name, last_name FROM student WHERE ROWNUM <= 4;
TYPE name_type
IS
  TABLE OF name_cur%ROWTYPE INDEX BY BINARY_INTEGER;
  name_tab name_type;
  v_counter INTEGER := 0;
BEGIN
  FOR name_rec IN name_cur
  LOOP
    v_counter                      := v_counter + 1;
    name_tab(v_counter).first_name := name_rec.first_name;
    name_tab(v_counter).last_name  := name_rec.last_name;
    DBMS_OUTPUT.PUT_LINE('First Name('||v_counter||'): '|| name_tab(v_counter).first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name('||v_counter||'): '|| name_tab(v_counter).last_name);
  END LOOP;
END;


--16.3.1 Use Collections of Records

/*
A) Modify the script used earlier in this lab. Instead of using an associative array, use a nested table.
*/

-- ch16_4a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  CURSOR name_cur
  IS
    SELECT first_name, last_name FROM student WHERE ROWNUM <= 4;
TYPE name_type
IS
  TABLE OF name_cur%ROWTYPE;
  name_tab name_type := name_type();
  v_counter INTEGER  := 0;
BEGIN
  FOR name_rec IN name_cur
  LOOP
    v_counter := v_counter + 1;
    name_tab.EXTEND;
    name_tab(v_counter).first_name := name_rec.first_name;
    name_tab(v_counter).last_name  := name_rec.last_name;
    DBMS_OUTPUT.PUT_LINE('First Name('||v_counter||'): '|| name_tab(v_counter).first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name('||v_counter||'): '|| name_tab(v_counter).last_name);
  END LOOP;
END;


/*
B) Modify the script used earlier in this lab. Instead of using an associative array, use a varray.
*/


-- ch16_4b.sql, version 2.0
SET SERVEROUTPUT ON
DECLARE
  CURSOR name_cur
  IS
    SELECT first_name, last_name FROM student WHERE ROWNUM <= 4;
TYPE name_type IS VARRAY(4) OF name_cur%ROWTYPE;
name_tab name_type := name_type();
v_counter INTEGER  := 0;
BEGIN
  FOR name_rec IN name_cur
  LOOP
    v_counter := v_counter + 1;
    name_tab.EXTEND;
    name_tab(v_counter).first_name := name_rec.first_name;
    name_tab(v_counter).last_name  := name_rec.last_name;
    DBMS_OUTPUT.PUT_LINE('First Name('||v_counter||'): '|| name_tab(v_counter).first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name('||v_counter||'): '|| name_tab(v_counter).last_name);
  END LOOP;
END;


/*
C) Modify the script used at the beginning of this lab. Instead of using a cursor-based record, use a
user-defined record.The new record should have three fields: first_name, last_name, and
enrollments.The last field will contain the total number of courses in which a student is
currently enrolled.
*/


-- ch16_4c.sql, version 3.0
SET SERVEROUTPUT ON
DECLARE
  CURSOR name_cur
  IS
    SELECT first_name,
      last_name,
      COUNT(*) total
    FROM student
    JOIN enrollment USING (student_id)
    GROUP BY first_name,
      last_name;
TYPE student_rec_type
IS
  RECORD
  (
    first_name  VARCHAR2(15),
    last_name   VARCHAR2(30),
    enrollments INTEGER);
TYPE name_type
IS
  TABLE OF student_rec_type INDEX BY BINARY_INTEGER;
  name_tab name_type;
  v_counter INTEGER := 0;
BEGIN
  FOR name_rec IN name_cur
  LOOP
    v_counter                       := v_counter + 1;
    name_tab(v_counter).first_name  := name_rec.first_name;
    name_tab(v_counter).last_name   := name_rec.last_name;
    name_tab(v_counter).enrollments := name_rec.total;
    IF v_counter                    <= 4 THEN
      DBMS_OUTPUT.PUT_LINE('First Name('||v_counter||'): '|| name_tab(v_counter).first_name);
      DBMS_OUTPUT.PUT_LINE('Last Name('||v_counter||'): '|| name_tab(v_counter).last_name);
      DBMS_OUTPUT.PUT_LINE('Enrollments('||v_counter||'): '|| name_tab(v_counter).enrollments);
      DBMS_OUTPUT.PUT_LINE ('--------------------');
    END IF;
  END LOOP;
END;





