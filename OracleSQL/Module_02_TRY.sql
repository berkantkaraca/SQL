--MODULE 2 TRY IT YOURSELF
--------------------------


--Chapter 2,“General Programming Language Fundamentals”


/*

1) Write a PL/SQL block
A) That includes declarations for the following variables:
I) A VARCHAR2 datatype that can contain the string ‘Introduction to Oracle PL/SQL’
II) A NUMBER that can be assigned 987654.55, but not 987654.567 or 9876543.55
III) A CONSTANT (you choose the correct datatype) that is autoinitialized to the value
‘603D’
IV) A BOOLEAN
V) A DATE datatype autoinitialized to one week from today
B) In the body of the PL/SQL block, put a DBMS_OUTPUT.PUT_LINE message for each of the
variables that received an auto initialization value.
C) In a comment at the bottom of the PL/SQL block, state the value of your number datatype.
ANSWER: The answer should look similar to the following:
*/

SET SERVEROUTPUT ON
DECLARE
  V_DESCRIPT     VARCHAR2(35);
  v_number_test  NUMBER(8,2);
  v_location     CONSTANT VARCHAR2(4) := '603D';
  v_boolean_test BOOLEAN;
  v_start_date   DATE := TRUNC(SYSDATE) + 7;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('The location is: '||v_location||'.');
  DBMS_OUTPUT.PUT_LINE ('The starting date is: '||v_start_date||'.');
END;

/*
2) Alter the PL/SQL block you just created to conform to the following specifications.
A) Remove the DBMS_OUTPUT.PUT_LINE messages.
B) In the body of the PL/SQL block, write a selection test (IF) that does the following (use a
nested if statement where appropriate):
I) Checks whether the VARCHAR2 you created contains the course named “Introduction
to Underwater Basketweaving.”
II) If it does, put a DBMS_OUTPUT.PUT_LINE message on the screen that says so.
III) If it does not, test to see if the CONSTANT you created contains the room number 603D.
IV) If it does, put a DBMS_OUTPUT.PUT_LINE message on the screen that states the course
name and the room number that you’ve reached in this logic.
V) If it does not, put a DBMS_OUTPUT.PUT_LINE message on the screen that states that
the course and location could not be determined.
C) Add a WHEN OTHERS EXCEPTION that puts a DBMS_OUTPUT.PUT_LINE message on the
screen that says that an error occurred.
ANSWER: The answer should look similar to the following:
*/

SET SERVEROUTPUT ON
DECLARE
  v_descript     VARCHAR2(35);
  v_number_test  NUMBER(8,2);
  v_location     CONSTANT VARCHAR2(4) := '603D';
  v_boolean_test BOOLEAN;
  v_start_date   DATE := TRUNC(SYSDATE) + 7;
BEGIN
  IF v_descript = 'Introduction to Underwater Basketweaving' THEN
    DBMS_OUTPUT.PUT_LINE ('This course is '||v_descript||'.');
  ELSIF v_location = '603D' THEN
    IF v_descript IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE ('The course is '||v_descript ||'.'||' The location is '||v_location||'.');
    ELSE
      DBMS_OUTPUT.PUT_LINE ('The course is unknown.'|| ' The location is '||v_location||'.');
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE ('The course and location '|| 'could not be determined.');
  END IF;
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE ('An error occurred.');
END;






