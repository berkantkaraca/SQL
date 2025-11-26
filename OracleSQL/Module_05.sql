--MODULE 5
-----------

--Conditional Control: CASE Statements
--------------------------------------


--CASE Statements


--Tek �ift CASE ile yaz?m?
SET SERVEROUTPUT ON
DECLARE
  v_num      NUMBER := &sv_user_num;
  v_num_flag NUMBER;
BEGIN
  v_num_flag := MOD(v_num,2);
  -- test if the number provided by the user is even
  CASE v_num_flag
  WHEN 0 THEN
    DBMS_OUTPUT.PUT_LINE (V_NUM||'  IS even number');
  ELSE
    DBMS_OUTPUT.PUT_LINE (v_num||'  IS odd number');
  END CASE;
  DBMS_OUTPUT.PUT_LINE ('Done');
END;



--Searched CASE

--Tek �ift searched CASE

DECLARE
  v_num NUMBER := &sv_user_num;
BEGIN
  -- test if the number provided by the user is even
  CASE
  WHEN MOD(v_num,2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE (v_num||' is even number');
  ELSE
    DBMS_OUTPUT.PUT_LINE (v_num||' is odd number');
  END CASE;
  DBMS_OUTPUT.PUT_LINE ('Done');
END;


--Hatal? DataType Kullan?m ve Do?rusu

DECLARE
  V_NUM      NUMBER := &SV_NUM;
  v_num_flag NUMBER ;              --BOOLEAN   --TRUE
BEGIN
  CASE v_num_flag
  WHEN MOD(v_num,2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE (v_num||' is even number');
  ELSE
    DBMS_OUTPUT.PUT_LINE (v_num||' is odd number');
  END CASE;
  DBMS_OUTPUT.PUT_LINE ('Done');
END;



--5.1.1 Use the CASE Statement

--G�n numaras?na g�re g�n�n ad? g�steriliyor
-- ch05_1a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_date DATE := TO_DATE('&sv_user_date', 'DD-MON-YYYY');
  v_day  VARCHAR2(1);
BEGIN
  v_day := TO_CHAR(v_date, 'D');
  CASE v_day
  WHEN '1' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Sunday');
  WHEN '2' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Monday');
  WHEN '3' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Tuesday');
  WHEN '4' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Wednesday');
  WHEN '5' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Thursday');
  WHEN '6' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Friday');
  WHEN '7' THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Saturday');
  END CASE;
END;


/*
A) If the value of v_date is 15-JAN-2008, what output is printed on the screen?


B) How many times is the CASE selector v_day evaluated?

ANSWER: The CASE selector v_day is evaluated only once. However, the WHEN clauses are
checked sequentially.When the value of the expression in the WHEN clause equals the value of
the selector, the statements associated with the WHEN clause are executed.


C) Rewrite this script using the ELSE clause in the CASE statement.

ELSE
DBMS_OUTPUT.PUT_LINE (�Today is Saturday');

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
D) Rewrite this script using the searched CASE statement.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/
SET SERVEROUTPUT ON
DECLARE
  v_date DATE := TO_DATE('&sv_user_date', 'DD-MM-YYYY');
  v_day  VARCHAR2(1);
BEGIN
    

  CASE 
  WHEN '1' = TO_CHAR(v_date, 'D') THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Sunday');
  WHEN '2' = TO_CHAR(v_date, 'D') THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Monday');
  WHEN '3' = TO_CHAR(v_date, 'D') THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Tuesday');
  WHEN '4' = TO_CHAR(v_date, 'D') THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Wednesday');
  WHEN '5' = TO_CHAR(v_date, 'D') THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Thursday');
  WHEN '6' = TO_CHAR(v_date, 'D') THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Friday');
  WHEN '7' = TO_CHAR(v_date, 'D') THEN
    DBMS_OUTPUT.PUT_LINE ('Today is Saturday');
  END CASE;
END;





--5.1.2 Use the Searched CASE Statement


-- 102 nolu �?rencinin 89 nolu section'da ald??? final notunun CASE kullan?larak harf not kar??l???
-- ch05_2a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_student_id   NUMBER := 102;
  v_section_id   NUMBER := 89;
  v_final_grade  NUMBER;
  v_letter_grade CHAR(1);
BEGIN
  SELECT final_grade
  INTO v_final_grade
  FROM enrollment
  WHERE student_id = v_student_id
  AND section_id   = v_section_id;
  CASE
  WHEN v_final_grade >= 90 THEN
    v_letter_grade   := 'A';
  WHEN v_final_grade >= 80 THEN
    v_letter_grade   := 'B';
  WHEN v_final_grade >= 70 THEN
    v_letter_grade   := 'C';
  WHEN v_final_grade >= 60 THEN
    v_letter_grade   := 'D';
  ELSE
    v_letter_grade := 'F';
  END CASE;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Letter grade is: '||V_LETTER_GRADE);
END;


/*
A) What letter grade is displayed on the screen:
I) if the value of v_final_grade is equal to 60?                              D
II) if the value of v_final_grade is greater than 60 and less than 70?        D
III) if the value of v_final_grade is NULL?                                   F


B) How would you change this script so that the message There is no final grade is
displayed if v_final_grade is null? In addition, make sure that the message Letter
grade is: is not displayed on the screen.
*/

SET SERVEROUTPUT ON
DECLARE
  v_student_id   NUMBER := &sv_student_id;
  v_section_id   NUMBER := 89;
  v_final_grade  NUMBER;
  v_letter_grade CHAR(1);
BEGIN
  SELECT final_grade
  INTO v_final_grade
  FROM enrollment
  WHERE student_id = v_student_id
  AND section_id   = v_section_id;
  CASE -- outer CASE
  WHEN v_final_grade IS NULL THEN
    DBMS_OUTPUT.PUT_LINE ('There is no final grade.');
  ELSE
    CASE -- inner CASE
    WHEN v_final_grade >= 90 THEN
      v_letter_grade   := 'A';
    WHEN v_final_grade >= 80 THEN
      v_letter_grade   := 'B';
    WHEN v_final_grade >= 70 THEN
      v_letter_grade   := 'C';
    WHEN v_final_grade >= 60 THEN
      v_letter_grade   := 'D';
    ELSE
      v_letter_grade := 'F';
    END CASE;
    -- control resumes here after inner CASE terminates
    DBMS_OUTPUT.PUT_LINE ('Letter grade is: '||v_letter_grade);
  END CASE;
  -- control resumes here after outer CASE terminates
END;



/*
C) Rewrite this script, changing the order of the searched conditions as shown here. Execute the
script and explain the output produced.
CASE
WHEN v_final_grade >= 60 THEN v_letter_grade := 'D';
WHEN v_final_grade >= 70 THEN v_letter_grade := 'C';
WHEN v_final_grade >= 80 THEN ...
WHEN v_final_grade >= 90 THEN ...
ELSE ...
*/

------------------------------------------------------------------------------------------------------

--CASE Expressions


--Tek �ift CASE Expression ile yaz?m?

DECLARE
  v_num      NUMBER := &sv_user_num;
  v_num_flag NUMBER;
  v_result   VARCHAR2(30);
BEGIN
  v_num_flag := MOD(v_num,2);
  v_result   :=
  CASE v_num_flag
  WHEN 0 THEN
    v_num||' is even number'
  ELSE
    v_num||' is odd number'
  END;
  DBMS_OUTPUT.PUT_LINE (v_result);
  DBMS_OUTPUT.PUT_LINE ('Done');
END;



-- 20 nolu kursun prerequisite si CASE ile kontrol ediliyor, SELECT INTO ile atan?yor
DECLARE
  v_course_no   NUMBER;
  v_description VARCHAR2(50);
  v_prereq      VARCHAR2(35);
BEGIN
  SELECT course_no,
    description,
    CASE
      WHEN prerequisite IS NULL
      THEN 'No prerequisite course required'
      ELSE TO_CHAR(prerequisite)
    END prerequisite
  INTO v_course_no,
    v_description,
    v_prereq
  FROM course
  WHERE course_no = 20;
  DBMS_OUTPUT.PUT_LINE ('Course: '||v_course_no);
  DBMS_OUTPUT.PUT_LINE ('Description: '||v_description);
  DBMS_OUTPUT.PUT_LINE ('Prerequisite: '||V_PREREQ);
END;



--5.2.1 Use the CASE Expression

/*
A) Modify the script ch05_2a.sql. Substitute the searched CASE expression for the CASE statement,
and assign the value returned by the expression to the variable v_letter_grade.
*/

SET SERVEROUTPUT ON
DECLARE
  v_student_id   NUMBER := 102;
  v_section_id   NUMBER := 89;
  v_final_grade  NUMBER;
  v_letter_grade CHAR(1);
BEGIN
  SELECT final_grade
  INTO v_final_grade
  FROM enrollment
  WHERE student_id = v_student_id
  AND SECTION_ID   = V_SECTION_ID;
  
  v_letter_grade  :=
  CASE
  WHEN V_FINAL_GRADE >= 90 THEN 'A'
  WHEN v_final_grade >= 80 THEN 'B'
  WHEN v_final_grade >= 70 THEN 'C'
  WHEN v_final_grade >= 60 THEN 'D'
  ELSE 'F'
  END;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Letter grade is: '||V_LETTER_GRADE);
END;


/*
C) Rewrite the script you created in part A) so that the result of the CASE expression is assigned to
the v_letter_grade variable via a SELECT INTO statement.
*/

-- ch05_3b.sql, version 2.0
SET SERVEROUTPUT ON
DECLARE
  v_student_id   NUMBER := 102;
  v_section_id   NUMBER := 89;
  v_letter_grade CHAR(1);
BEGIN
  SELECT
    CASE
      WHEN final_grade >= 90
      THEN 'A'
      WHEN final_grade >= 80
      THEN 'B'
      WHEN final_grade >= 70
      THEN 'C'
      WHEN final_grade >= 60
      THEN 'D'
      ELSE 'F'
    END
  INTO v_letter_grade
  FROM enrollment
  WHERE student_id = v_student_id
  AND section_id   = v_section_id;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Letter grade is: '||V_LETTER_GRADE);
END;


----------------------------------------------------------------------------------

--NULLIF and COALESCE Functions

--�ift say? ise NULL d�ner
DECLARE
  v_num       NUMBER := &sv_user_num;
  v_remainder NUMBER;
BEGIN
  -- calculate the remainder and if it is zero return NULL
  v_remainder := NULLIF(MOD(v_num,2),0);
  DBMS_OUTPUT.PUT_LINE ('v_remainder: '||V_REMAINDER);
END;


--COLAESCE
SELECT e.student_id,
  e.section_id,
  e.final_grade,
  g.numeric_grade,
  COALESCE(e.final_grade, g.numeric_grade, 0) grade
FROM enrollment e,
  grade g
WHERE e.student_id    = g.student_id
AND e.section_id      = g.section_id
AND E.STUDENT_ID      = 102
AND g.grade_type_code = 'FI';



--5.3.1 The NULLIF Function

-- CASE hali
-- ch05_4a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_final_grade NUMBER;
BEGIN
  SELECT
    CASE
      WHEN e.final_grade = g.numeric_grade
      THEN NULL
      ELSE g.numeric_grade
    END
  INTO v_final_grade
  FROM enrollment e
  JOIN grade g
  ON (e.student_id      = g.student_id
  AND e.section_id      = g.section_id)
  WHERE e.student_id    = 102
  AND e.section_id      = 86
  AND g.grade_type_code = 'FI';
  DBMS_OUTPUT.PUT_LINE ('Final grade: '||V_FINAL_GRADE);
END;


--NULLIF hali
/*A) Modify script ch05_4a.sql. Substitute the NULLIF function for the CASE expression.
*/
SET SERVEROUTPUT ON
DECLARE
  v_final_grade NUMBER;
BEGIN
  SELECT NULLIF(g.numeric_grade, e.final_grade)
  INTO v_final_grade
  FROM enrollment e
  JOIN grade g
  ON (e.student_id      = g.student_id
  AND e.section_id      = g.section_id)
  WHERE e.student_id    = 102
  AND e.section_id      = 86
  AND g.grade_type_code = 'FI';
  DBMS_OUTPUT.PUT_LINE ('Final grade: '||v_final_grade);
END;



/*C) Change the order of columns in the NULLIF function. Run the modified version of the script, and
explain the output produced.
*/


--5.3.2 Use the COALESCE Function

--Searched CASE halini COALESCE ile de?i?tirilecek
-- ch05_5a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_num1   NUMBER := &sv_num1;
  v_num2   NUMBER := &sv_num2;
  v_num3   NUMBER := &sv_num3;
  v_result NUMBER;
BEGIN
  v_result :=
  CASE
  WHEN v_num1 IS NOT NULL THEN
    v_num1
  ELSE
    CASE
    WHEN v_num2 IS NOT NULL THEN
      v_num2
    ELSE
      v_num3
    END
  END;
  DBMS_OUTPUT.PUT_LINE ('Result: '||V_RESULT);
END;


/*A) Modify script ch05_5a.sql. Substitute the COALESCE function for the CASE expression.
*/
--COALESCE hali

-- ch05_5b.sql, version 2.0
SET SERVEROUTPUT ON
DECLARE
  v_num1   NUMBER := &sv_num1;
  v_num2   NUMBER := &sv_num2;
  v_num3   NUMBER := &sv_num3;
  v_result NUMBER;
BEGIN
  v_result := COALESCE(v_num1, v_num2, v_num3);
  DBMS_OUTPUT.PUT_LINE ('Result: '||v_result);
END;


/*C) What output is produced by the modified version of the script if NULL is provided for all three
numbers? Try to explain your answer before you run the script.
*/












