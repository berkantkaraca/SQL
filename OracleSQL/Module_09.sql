--MODULE 9 
-----------


--Exceptions
-------------


--Exception Scope

--Girilen ö?renci no varsa kaç kursa kay?t oldu?u yaz?ls?n

DECLARE
  v_student_id NUMBER := &sv_student_id;
  v_name       VARCHAR2(30);
  v_total      NUMBER(1);
  -- outer block
BEGIN
  SELECT RTRIM(first_name)
    ||' '
    ||RTRIM(last_name)
  INTO v_name
  FROM student
  WHERE student_id = v_student_id;
  DBMS_OUTPUT.PUT_LINE ('Student name is '||v_name);
  -- inner block
  BEGIN
    SELECT COUNT(*) INTO v_total FROM enrollment WHERE student_id = v_student_id;
    DBMS_OUTPUT.PUT_LINE ('Student is registered for '|| v_total||' course(s)');
  EXCEPTION
  WHEN VALUE_ERROR OR INVALID_NUMBER THEN
    DBMS_OUTPUT.PUT_LINE ('An error has occurred');
  END;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no such student');
END;



--Girilen ö?renci no varsa ve herhangi bir kursa kay?tl? ise yaz?ls?n     284 için dene
--Ancak no data found ile yanl?? ele al?nm?? olur. ö?renci var ancak kay?tl? de?il hatas? al?nmal?d?r

DECLARE
  v_student_id NUMBER := &sv_student_id;
  v_name       VARCHAR2(30);
  v_registered CHAR;
  -- outer block
BEGIN
  SELECT RTRIM(first_name)
    ||' '
    ||RTRIM(last_name)
  INTO v_name
  FROM student
  WHERE student_id = v_student_id;
  DBMS_OUTPUT.PUT_LINE ('Student name is '||v_name);
  -- inner block
  BEGIN
    SELECT 'Y' INTO v_registered FROM enrollment WHERE student_id = v_student_id;
    DBMS_OUTPUT.PUT_LINE ('Student is registered');
  EXCEPTION
  WHEN VALUE_ERROR OR INVALID_NUMBER THEN
    DBMS_OUTPUT.PUT_LINE ('An error has occurred');
  END;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no such student');
END;



--9.1.1 Understand the Scope of an Exception


--Girilen zip kodunda kaç ö?renci oturuyor?       07024 için dene
--Ard?ndan exception section ekle
-- ch9_1a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_zip   VARCHAR2(5) := '&sv_zip';
  v_total NUMBER(1);
  -- outer block
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Check if provided zipcode is valid');
  SELECT zip INTO v_zip FROM zipcode WHERE zip = v_zip;
  -- inner block
  BEGIN
    SELECT COUNT(*) INTO v_total FROM student WHERE zip = v_zip;
    DBMS_OUTPUT.PUT_LINE ('There are '||v_total|| ' students for zipcode '||v_zip);
  END;
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;

/*
B) The first run of this example succeeds.The output produced by the example shows that there are
nine students for zip code 07024. What happens if there are ten students with the zip code 07024?
What output is produced? To answer this question, you need to add a record to the STUDENT
table:
*/

INSERT
INTO student
  (
    student_id,
    salutation,
    first_name,
    last_name,
    street_address,
    zip,
    phone,
    employer,
    registration_date,
    created_by,
    created_date,
    modified_by,
    modified_date
  )
  VALUES
  (
    STUDENT_ID_SEQ.NEXTVAL,
    'Mr.',
    'John',
    'Smith',
    '100 Main St.',
    '07024',
    '718-555-5555',
    'ABC Co.',
    SYSDATE,
    USER,
    SYSDATE,
    USER,
    SYSDATE
  );
COMMIT;


/*
C) Based on the error message produced by the example in the preceding question, what exception
handler must be added to the script?

Inner blok ve outer blok için ayr? ayr? denenecek
*/

EXCEPTION
WHEN VALUE_ERROR OR INVALID_NUMBER THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred');


/*
D) Explain the difference in the outputs produced by versions 2 and 3 of the script.

ANSWER: Version 2 of the script has an exception-handling section in the inner block, where the
exception actually occurs.When the exception is encountered, control of the execution is passed
to this exception-handling section, and the message An error has occurred is displayed on
the screen. Because the exception was handled successfully, control of the execution is then
passed to the outer block, and Done... is displayed on the screen.Version 3 of the script has an
exception-handling section in the outer block. In this case, when the exception occurs in the inner
block, control of the execution is passed to the exception-handling section of the outer block,
because the inner block does not have its own exception-handling section. As a result, the
message Done... is not displayed on the screen. As mentioned earlier, this behavior is called
exception propagation, and it is discussed in detail in Lab 9.3.
*/

------------------------------------------------------------------------------------------------

--User-Defined Exceptions

--Negatif ö?renci no girilemez

DECLARE
  v_student_id student.student_id%type := &sv_student_id;
  v_total_courses NUMBER;
  e_invalid_id    EXCEPTION;
BEGIN
  IF v_student_id < 0 THEN
    RAISE e_invalid_id;
  ELSE
    SELECT COUNT(*)
    INTO v_total_courses
    FROM enrollment
    WHERE student_id = v_student_id;
    DBMS_OUTPUT.PUT_LINE ('The student is registered for '|| v_total_courses||' courses');
  END IF;
  DBMS_OUTPUT.PUT_LINE ('No exception has been raised');
EXCEPTION
WHEN e_invalid_id THEN
  DBMS_OUTPUT.PUT_LINE ('An id cannot be negative');
END;


--Inner blokta tan?mlanan hata outer da f?rlat?lmaya çal???l?rsa syntax hatas? al?n?r

-- outer block
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Outer block');
  -- inner block
  DECLARE
    e_my_exception EXCEPTION;
  BEGIN
    DBMS_OUTPUT.PUT_LINE ('Inner block');
  EXCEPTION
  WHEN e_my_exception THEN
    DBMS_OUTPUT.PUT_LINE ('An error has occurred');
  END;
  IF 10 > &sv_number THEN
    RAISE e_my_exception;
  END IF;
END;



--9.2.1 Use User-Defined Exceptions


--Instructor 10 veya daha fazla section'da çal???yorsa hata verilsin
-- ch9_2a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_instructor_id     NUMBER := &sv_instructor_id;
  v_tot_sections      NUMBER;
  v_name              VARCHAR2(30);
  e_too_many_sections EXCEPTION;
BEGIN
  SELECT COUNT(*)
  INTO v_tot_sections
  FROM section
  WHERE instructor_id = v_instructor_id;
  IF v_tot_sections  >= 10 THEN
    RAISE e_too_many_sections;
  ELSE
    SELECT RTRIM(first_name)
      ||' '
      ||RTRIM(last_name)
    INTO v_name
    FROM instructor
    WHERE instructor_id = v_instructor_id;
    DBMS_OUTPUT.PUT_LINE ('Instructor, '||v_name||', teaches '|| v_tot_sections||' sections');
  END IF;
EXCEPTION
WHEN e_too_many_sections THEN
  DBMS_OUTPUT.PUT_LINE ('This instructor teaches too much');
END;


/*
A) What output is printed on the screen? Explain the difference in the outputs produced.

101 ve 102 için dene


B) What condition causes the user-defined exception to be raised?


C) How would you change the script to display an instructor’s name in the error message as well?

Instructor ad?n? getiren SQL cümlesi ELSE içinden al?n?p yukar?ya ta??nmal?d?r
*/

-----------------------------------------------------------------------------------------------------


--Exception Propagation

--Declaration section'da hata olu?ursa program exception handling section'a girmez ve hatal? sonlan?r

DECLARE
  v_test_var CHAR(3):= 'ABCDE';
BEGIN
  DBMS_OUTPUT.PUT_LINE ('This is a test');
EXCEPTION
WHEN INVALID_NUMBER OR VALUE_ERROR THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;


--Nested block ile declare hatas? outer da yakalan?r

--outer block
BEGIN
  -- inner block
  DECLARE
    v_test_var CHAR(3):= 'ABCDE';
  BEGIN
    DBMS_OUTPUT.PUT_LINE ('This is a test');
  EXCEPTION
  WHEN INVALID_NUMBER OR VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE ('An error has occurred in '|| 'the inner block');
  END;
EXCEPTION
WHEN INVALID_NUMBER OR VALUE_ERROR THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred in the '|| 'program');
END;


--exception handling de hata olu?ursa program hatal? sonuçlan?r

DECLARE
  v_test_var CHAR(3) := 'ABC';
BEGIN
  v_test_var := '1234';
  DBMS_OUTPUT.PUT_LINE ('v_test_var: '||v_test_var);
EXCEPTION
WHEN INVALID_NUMBER OR VALUE_ERROR THEN
  v_test_var := 'ABCD';
  DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;


--exception section'da olu?an hata outer blokta yakalan?r

--outer block
BEGIN
  -- inner block
  DECLARE
    v_test_var CHAR(3) := 'ABC';
  BEGIN
    v_test_var := '1234';
    DBMS_OUTPUT.PUT_LINE ('v_test_var: '||v_test_var);
  EXCEPTION
  WHEN INVALID_NUMBER OR VALUE_ERROR THEN
    v_test_var := 'ABCD';
    DBMS_OUTPUT.PUT_LINE ('An error has occurred in '|| 'the inner block');
  END;
EXCEPTION
WHEN INVALID_NUMBER OR VALUE_ERROR THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred in the '|| 'program');
END;



--Ayn? exception section'da sadece tek bir hata yakalanabilir

--outer block
DECLARE
  e_exception1 EXCEPTION;
  e_exception2 EXCEPTION;
BEGIN
  -- inner block
  BEGIN
    RAISE e_exception1;
  EXCEPTION
  WHEN e_exception1 THEN
    RAISE e_exception2;
  WHEN e_exception2 THEN
    DBMS_OUTPUT.PUT_LINE ('An error has occurred in '|| 'the inner block');
  END;
EXCEPTION
WHEN e_exception2 THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred in '|| 'the program');
END;



--RAISE ile hatan?n tekrar f?rlat?lmas? (RERAISING ERROR)

-- outer block
DECLARE
  e_exception EXCEPTION;
BEGIN
  -- inner block
  BEGIN
    RAISE e_exception;
  EXCEPTION
  WHEN e_exception THEN
    RAISE;
  END;
EXCEPTION
WHEN e_exception THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;


--9.3.1 Understand How Exceptions Propagate

-- ch9_3a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_my_name VARCHAR2(15) := 'ELENA SILVESTROVA';
BEGIN
  DBMS_OUTPUT.PUT_LINE ('My name is '||v_my_name);
  DECLARE
    v_your_name VARCHAR2(15);
  BEGIN
    v_your_name := '&sv_your_name';
    DBMS_OUTPUT.PUT_LINE ('Your name is '||v_your_name);
  EXCEPTION
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE ('Error in the inner block');
    DBMS_OUTPUT.PUT_LINE ('This name is too long');
  END;
EXCEPTION
WHEN VALUE_ERROR THEN
  DBMS_OUTPUT.PUT_LINE ('Error in the outer block');
  DBMS_OUTPUT.PUT_LINE ('This name is too long');
END;


/*
A) What exception is raised by the assignment statement in the declaration section of the outer
block?

ANSWER: The exception VALUE_ERROR is raised by the assignment statement of the outer block.
The variable v_my_name is declared as VARCHAR2(15). However, the value that is assigned to
this variable contains 17 letters. As a result, the assignment statement causes a runtime error.


B) After this exception (based on the preceding question) is raised, will the program terminate
successfully? Explain why or why not.

ANSWER: When the exception VALUE_ERROR is raised, the script cannot complete successfully
because the error occurs in the declaration section of the outer block. Because the outer block is
not enclosed by any other block, control is transferred to the host environment. As a result, an
error message is generated when this example is run.


C) How would you change this script so that the exception can handle an error caused by the
assignment statement in the declaration section of the outer block?

ANSWER: For the exception to handle the error generated by the assignment statement in the
declaration section of the outer block, the assignment statement must be moved to the
executable section of this block. All changes are shown in bold.

DECLARE
v_my_name VARCHAR2(15);
BEGIN
v_my_name := 'ELENA SILVESTROVA';


D) Change the value of the variable from “Elena Silvestrova” to “Elena.”Then change the script so that
if the assignment statement of the inner block causes an error, it is handled by the exceptionhandling
section of the outer block.

DECLARE
v_your_name VARCHAR2(15) := '&sv_your_name';
BEGIN
*/



--9.3.2 Reraise Exceptions

--430 nolu kurs için section yoksa user defined error tan?mlans?n

-- ch9_4a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_course_no   NUMBER := 430;
  v_total       NUMBER;
  e_no_sections EXCEPTION;
BEGIN
  BEGIN
    SELECT COUNT(*) INTO v_total FROM section WHERE course_no = v_course_no;
    IF v_total = 0 THEN
      RAISE e_no_sections;
    ELSE
      DBMS_OUTPUT.PUT_LINE ('Course, '||v_course_no|| ' has '||v_total||' sections');
    END IF;
  EXCEPTION
  WHEN e_no_sections THEN
    DBMS_OUTPUT.PUT_LINE ('There are no sections for course '|| v_course_no);
  END;
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;


/*
A) What exception is raised if there are no sections for a given course number?

ANSWER: If there are no sections for a given course number, the exception e_no_sections
is raised.


B) If the exception e_no_sections is raised, how does the control of execution flow? Explain
your answer.


C) Change this script so that the exception e_no_sections is reraised in the outer block.
*/

SET SERVEROUTPUT ON
DECLARE
  v_course_no   NUMBER := 430;
  v_total       NUMBER;
  e_no_sections EXCEPTION;
BEGIN
  BEGIN
    SELECT COUNT(*) INTO v_total FROM section WHERE course_no = v_course_no;
    IF v_total = 0 THEN
      RAISE e_no_sections;
    ELSE
      DBMS_OUTPUT.PUT_LINE ('Course, '||v_course_no|| ' has '||v_total||' sections');
    END IF;
  EXCEPTION
  WHEN e_no_sections THEN
    RAISE;
  END;
  DBMS_OUTPUT.PUT_LINE ('Done...');
EXCEPTION
WHEN e_no_sections THEN
  DBMS_OUTPUT.PUT_LINE ('There are no sections for course '|| V_COURSE_NO);
END;






