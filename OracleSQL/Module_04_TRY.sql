--MODULE 4 TRY IT YOURSELF
---------------------------

--Chapter 4,“Conditional Control: IF Statements”

/*
1) Rewrite ch04_1a.sql. Instead of getting information from the user for the variable v_date, define
its value with the help of the function SYSDATE. After it has been determined that a certain day
falls on the weekend, check to see if the time is before or after noon. Display the time of day
together with the day.

ANSWER: The script should look similar to the following. Changes are shown in bold.
*/

SET SERVEROUTPUT ON
DECLARE
  v_day  VARCHAR2(15);
  v_time VARCHAR(8);
BEGIN
  v_day  := TO_CHAR(SYSDATE, 'fmDAY');
  v_time := TO_CHAR(SYSDATE, 'HH24:MI');
  IF v_day IN ('SATURDAY', 'SUNDAY') THEN
    DBMS_OUTPUT.PUT_LINE (v_day||', '||v_time);
    IF v_time BETWEEN '12:01' AND '24:00' THEN
      DBMS_OUTPUT.PUT_LINE ('It''s afternoon');
    ELSE
      DBMS_OUTPUT.PUT_LINE ('It''s morning');
    END IF;
  END IF;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE('Done...');
END;


/*
In this exercise, you remove the variable v_date that was used to store the date provided by the
user.You add the variable v_time to store the time of the day.You also modify the statement
v_day := TO_CHAR(SYSDATE, 'fmDAY');
so that DAY is prefixed by the letters fm.This guarantees that extra spaces will be removed from
the name of the day.Then you add another statement that determines the current time of day
and stores it in the variable v_time. Finally, you add an IF-THEN-ELSE statement that checks the
time of day and displays the appropriate message.
Notice that two consecutive single quotes are used in the second and third
DBMS_OUTPUT.PUT_LINE statements.This allows you to use an apostrophe in your message.
When run, this exercise produces the following output:
SUNDAY, 16:19
It's afternoon
Done...
PLSQL procedure successfully completed.



2) Create a new script. For a given instructor, determine how many sections he or she is teaching. If
the number is greater than or equal to 3, display a message saying that the instructor needs a
vacation.Otherwise, display a message saying how many sections this instructor is teaching.

ANSWER: The script should look similar to the following:
*/

SET SERVEROUTPUT ON
DECLARE
  v_instructor_id NUMBER := &sv_instructor_id;
  v_total         NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM section
  WHERE instructor_id = v_instructor_id;
  -- check if instructor teaches 3 or more sections
  IF v_total >= 3 THEN
    DBMS_OUTPUT.PUT_LINE ('This instructor needs '|| 'a vacation');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('This instructor teaches '|| v_total||' sections');
  END IF;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;


/*
This script accepts a value for the instructor’s ID from a user.Next, it checks the number of
sections taught by the given instructor.This is accomplished with the help of the SELECT INTO
statement. Next, it determines what message should be displayed on the screen with the help of
the IF-THEN-ELSE statement. If a particular instructor teaches three or more sections, the condition
of the IF-THEN-ELSE statement evaluates to TRUE, and the message This instructor
needs a vacation is displayed to the user. In the opposite case, the message stating how
many sections an instructor is teaching is displayed. Assume that value 101 was provided at
runtime.Then the script produces the following output:
Enter value for sv_instructor_id: 101
old 2: v_instructor_id NUMBER := &sv_instructor_id;
new 2: v_instructor_id NUMBER := 101;
This instructor needs a vacation
PLSQL procedure successfully completed.



3) Execute the following two PL/SQL blocks, and explain why they produce different output for the
same value of the variable v_num. Remember to issue the SET SERVEROUTPUT ON command
before running this script.
*/


-- Block 1
DECLARE
  v_num NUMBER := NULL;
BEGIN
  IF v_num > 0 THEN
    DBMS_OUTPUT.PUT_LINE ('v_num is greater than 0');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('v_num is not greater than 0');
  END IF;
END;


-- Block 2
DECLARE
  v_num NUMBER := NULL;
BEGIN
  IF v_num > 0 THEN
    DBMS_OUTPUT.PUT_LINE ('v_num is greater than 0');
  END IF;
  IF NOT (v_num > 0) THEN
    DBMS_OUTPUT.PUT_LINE ('v_num is not greater than 0');
  END IF;
END;


/*ANSWER: Consider the output produced by the preceding scripts:
-- Block1
v_num is not greater than 0
PLSQL procedure successfully completed.
-- Block 2
PLSQL procedure successfully completed.
The output produced by Block 1 and Block 2 is different, even though in both examples variable
v_num is defined as NULL.
First, take a closer look at the IF-THEN-ELSE statement used in Block 1:
IF v_num > 0 THEN
DBMS_OUTPUT.PUT_LINE ('v_num is greater than 0');
ELSE
DBMS_OUTPUT.PUT_LINE ('v_num is not greater than 0');
END IF;
The condition v_num > 0 evaluates to FALSE because NULL has been assigned to the variable
v_num. As a result, control is transferred to the ELSE part of the IF-THEN-ELSE statement. So the
message v_num is not greater than 0 is displayed on the screen.
Second, take a closer look at the IF-THEN statements used in Block 2:
IF v_num > 0 THEN
DBMS_OUTPUT.PUT_LINE ('v_num is greater than 0');
END IF;
IF NOT (v_num > 0) THEN
DBMS_OUTPUT.PUT_LINE ('v_num is not greater than 0');
END IF;
The conditions of both IF-THEN statements evaluate to FALSE. As a result, neither message is
displayed on the screen.
*/



