--MODULE 8
----------


--Error Handling and Built-in Exceptions
----------------------------------------


--Handling Errors

--Compile error
DECLARE
  v_num1   INTEGER := &sv_num1;
  v_num2   INTEGER := &sv_num2;
  v_result NUMBER;
BEGIN
  V_RESULT = V_NUM1 / V_NUM2;
  DBMS_OUTPUT.PUT_LINE ('v_result: '|| V_RESULT);
END;


-- ard?ndan s?f?ra bölünme hatas? al, runtime error


DECLARE
  v_num1   INTEGER := &sv_num1;
  v_num2   INTEGER := &sv_num2;
  v_result NUMBER;
BEGIN
  v_result := v_num1 / v_num2;
  DBMS_OUTPUT.PUT_LINE ('v_result: '||v_result);
EXCEPTION
WHEN ZERO_DIVIDE THEN
  DBMS_OUTPUT.PUT_LINE ('A number cannot be divided by zero.');
END;


--8.1.1 Understand the Importance of Error Handling

--Karekök hesaplama
-- ch08_1a.sql, version 1.0
SET SERVEROUTPUT ON;
DECLARE
  v_num NUMBER := &sv_num;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Square root of '||v_num|| ' is '||SQRT(v_num));
EXCEPTION
WHEN VALUE_ERROR THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;


/*
A) What output is printed on the screen (for both runs)?      4 ve -4 için


B) Why do you think an error message was generated when the script was run a second time?

ANSWER: The error message An error has occurred is generated for the second run of
the example because a runtime error occurred.The built-in function SQRT is unable to accept a
negative number as its argument.Therefore, the exception VALUE_ERROR was raised, and the error
message was displayed.


C) Assume that you are unfamiliar with the exception VALUE_ERROR. How would you change this
script to avoid this runtime error?
*/

SET SERVEROUTPUT ON;
DECLARE
  v_num NUMBER := &sv_num;
BEGIN
  IF v_num >= 0 THEN
    DBMS_OUTPUT.PUT_LINE ('Square root of '||v_num|| ' is '||SQRT(v_num));
  ELSE
    DBMS_OUTPUT.PUT_LINE ('A number cannot be negative');
  END IF;
END;

------------------------------------------------------------------------------------------------

--Built-in Exceptions


--Blok exception blo?undan sonra tamamlan?r, tekrar executable section'a dönülmez
DECLARE
  v_student_name VARCHAR2(50);
BEGIN
  SELECT first_name
    ||' '
    ||last_name
  INTO v_student_name
  FROM student
  WHERE student_id = 101;
  DBMS_OUTPUT.PUT_LINE ('Student name is '||v_student_name);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no such student');
END;


--?ki ayr? hata

DECLARE
  v_student_id NUMBER      := &sv_student_id;
  v_enrolled   VARCHAR2(3) := 'NO';
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Check if the student is enrolled');
  SELECT 'YES' INTO v_enrolled FROM enrollment WHERE student_id = v_student_id;
  DBMS_OUTPUT.PUT_LINE ('The student is enrolled into one course');
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('The student is not enrolled');
WHEN TOO_MANY_ROWS THEN
  DBMS_OUTPUT.PUT_LINE ('The student is enrolled in too many courses');
END;



--OTHERS kullan?m?

DECLARE
  v_instructor_id   NUMBER := &sv_instructor_id;
  v_instructor_name VARCHAR2(50);
BEGIN
  SELECT first_name
    ||' '
    ||last_name
  INTO v_instructor_name
  FROM instructor
  WHERE instructor_id = v_instructor_id;
  DBMS_OUTPUT.PUT_LINE ('Instructor name is '||v_instructor_name);
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;


--8.2.1 Use Built-in Exceptions

-- ch08_2a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_exists         NUMBER(1);
  v_total_students NUMBER(1);
  v_zip            CHAR(5):= '&sv_zip';
BEGIN
  SELECT COUNT(*) INTO v_exists FROM zipcode WHERE zip = v_zip;
  IF v_exists != 0 THEN
    SELECT COUNT(*) INTO v_total_students FROM student WHERE zip = v_zip;
    DBMS_OUTPUT.PUT_LINE ('There are '||v_total_students||' students');
  ELSE
    DBMS_OUTPUT.PUT_LINE (v_zip||' is not a valid zip');
  END IF;
EXCEPTION
WHEN VALUE_ERROR OR INVALID_NUMBER THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;

/*
07024, 00914, 12345 için dene

B) Explain why no exception was raised for these values of the variable v_zip.

ANSWER: The exceptions VALUE_ERROR and INVALID_NUMBER were not raised because no
conversion or type mismatch error occurred. Both variables, v_exists and
v_total_students,were defined as NUMBER(1).
The group function COUNT used in the SELECT INTO statement returns a NUMBER datatype.
Moreover, on both occasions, the COUNT function returns a single-digit number. As a result,
neither exception was raised.


C) Insert a record into the STUDENT table with a zip having the value of 07024.

*/

INSERT
INTO student
  (
    student_id,
    salutation,
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
    STUDENT_ID_SEQ.NEXTVAL,
    'Mr.',
    'John',
    'Smith',
    '07024',
    SYSDATE,
    'STUDENT',
    SYSDATE,
    'STUDENT',
    SYSDATE
  );
COMMIT;

/*
Run the script again for the same value of zip (07024). What output is printed on the screen? Why?


D) How would you change the script to display a student’s first name and last name instead of
displaying the total number of students for any given value of a zip? Remember, the SELECT INTO
statement can return only one record.

*/

SET SERVEROUTPUT ON
DECLARE
  v_exists       NUMBER(1);
  v_student_name VARCHAR2(30);
  v_zip          CHAR(5):= '&sv_zip';
BEGIN
  SELECT COUNT(*) INTO v_exists FROM zipcode WHERE zip = v_zip;
  IF V_EXISTS != 0 THEN
    SELECT first_name || ' ' || last_name
    INTO v_student_name
    FROM STUDENT
    WHERE zip  = v_zip
    AND rownum = 1;
    DBMS_OUTPUT.PUT_LINE ('Student name is '||v_student_name);
  ELSE
    DBMS_OUTPUT.PUT_LINE (v_zip||' is not a valid zip');
  END IF;
EXCEPTION
WHEN VALUE_ERROR OR INVALID_NUMBER THEN
  DBMS_OUTPUT.PUT_LINE ('An error has occurred');
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There are no students for this value of zip code');
END;











