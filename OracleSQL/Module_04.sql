--MODULE 4
----------


--Conditional Control: IF Statements
-------------------------------------


--IF Statements


--Küçük olan v_num1 büyük olan v_num2
DECLARE
  v_num1 NUMBER := 5;
  v_num2 NUMBER := 3;
  v_temp NUMBER;
BEGIN
  -- if v_num1 is greater than v_num2 rearrange their values
  IF v_num1 > v_num2 THEN
    v_temp := v_num1;
    v_num1 := v_num2;
    v_num2 := v_temp;
  END IF;
  -- display the values of v_num1 and v_num2
  DBMS_OUTPUT.PUT_LINE ('v_num1 = '||v_num1);
  DBMS_OUTPUT.PUT_LINE ('v_num2 = '||V_NUM2);
END;




--Tek veya �ift Say? Ornegi
DECLARE
  v_num NUMBER := &sv_user_num;
BEGIN
  -- test if the number provided by the user is even
  IF MOD(v_num,2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE (v_num|| ' is even number');
  ELSE
    DBMS_OUTPUT.PUT_LINE (v_num||' is odd number');
  END IF;
  DBMS_OUTPUT.PUT_LINE ('Done');
END;



--NULL ile kar??la?t?rma
DECLARE
  v_num1 NUMBER := 0;
  v_num2 NUMBER;
BEGIN
  IF v_num1 = v_num2 THEN
    DBMS_OUTPUT.PUT_LINE ('v_num1 = v_num2');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('v_num1 != v_num2');
  END IF;
END;



--4.1.1 Use the IF-THEN Statement






/*A) What output is printed on the screen (for both dates)?
*/



/*
Remove the RTRIM function from the assignment statement for v_day as follows:
v_day := TO_CHAR(v_date, 'DAY');
Run the script again, entering 13-JAN-2008 for v_date.
C) What output is printed on the screen? Why?

In the original example, the variable v_day is calculated with the help of the statement
RTRIM(TO_CHAR(v_date, 'DAY')). First, the function TO_CHAR returns the day of the
week, padded with blanks.The size of the value retrieved by the function TO_CHAR is always 9
bytes. Next, the RTRIM function removes trailing spaces.
*/



/*D) Rewrite this script using the LIKE operator instead of the IN operator so that it produces the same
results for the dates specified earlier.

IF v_day LIKE 'S%' THEN
*/



/*E) Rewrite this script using the IF-THEN-ELSE construct. If the date specified does not fall on the
weekend, display a message to the user saying so.

ELSE
DBMS_OUTPUT.PUT_LINE
(v_date||' does not fall on the weekend');
*/



--4.1.2 Use the IF-THEN-ELSE Statement


-- 25 numaral? kursun 1 numaral? section? i�in kay?tl? �?renci say?s? 15 den fazla ise FULL de?ilse FULL de?il yaz?ls?n

-- ch04_2a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_total NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM enrollment e
  JOIN section s USING (section_id)
  WHERE s.course_no = 25
  AND s.section_no  = 1;
  -- check if section 1 of course 25 is full
  IF v_total >= 15 THEN
    DBMS_OUTPUT.PUT_LINE ('Section 1 of course 25 is full');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('Section 1 of course 25 is not full');
  END IF;
  -- control resumes here
END;



/*
A) What DBMS_OUTPUT.PUT_LINE statement is displayed if 15 students are enrolled in section 1 of
course number 25?

B) What DBMS_OUTPUT.PUT_LINE statement is displayed if three students are enrolled in section 1
of course number 25?

C) What DBMS_OUTPUT.PUT_LINE statement is displayed if there is no section 1 for course
number 25?

ANSWER: If there is no section 1 for course number 25, the ELSE part of the IF-THEN-ELSE statement
is executed. So the second DBMS_OUTPUT.PUT_LINE statement is displayed on the screen.

D) How would you change this script so that the user provides both course and section numbers?

ANSWER: Two additional variables must be declared and initialized with the help of the substitution
variables as follows.

E) How would you change this script so that if fewer than 15 students are enrolled in section 1 of
course number 25, a message appears indicating how many students can still enroll?

ANSWER: The script should look similar to the following. Changes are shown in bold.
*/
-- ch04_2c.sql, version 3.0
SET SERVEROUTPUT ON
DECLARE
  v_total    NUMBER;
  v_students NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM enrollment e
  JOIN section s USING (section_id)
  WHERE s.course_no = 25
  AND s.section_no  = 1;
  -- check if section 1 of course 25 is full
  IF v_total >= 15 THEN
    DBMS_OUTPUT.PUT_LINE ('Section 1 of course 25 is full');
  ELSE
    v_students := 15 - v_total;
    DBMS_OUTPUT.PUT_LINE (v_students|| ' students can still enroll into section 1'|| ' of course 25');
  END IF;
  -- control resumes here
END;


------------------------------------------------------------------------------------------------

--ELSIF Statements




--4.2.1 Use the ELSIF Statement

-- 102 nolu �?renci 89 nolu section'da final notunun harf olarak kar??l???n? bulunuz
-- ch04_3a.sql, version 1.0
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
  IF v_final_grade BETWEEN 90 AND 100 THEN
    v_letter_grade := 'A';
  ELSIF v_final_grade BETWEEN 80 AND 89 THEN
    v_letter_grade := 'B';
  ELSIF v_final_grade BETWEEN 70 AND 79 THEN
    v_letter_grade := 'C';
  ELSIF v_final_grade BETWEEN 60 AND 69 THEN
    v_letter_grade := 'D';
  ELSE
    v_letter_grade := 'F';
  END IF;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Letter grade is: '|| v_letter_grade);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;


/*
A) What letter grade is displayed on the screen:
i) if the value of v_final_grade is equal to 85?          B
ii) if the value of v_final_grade is NULL?                F
iii) if the value of v_final_grade is greater than 100?   F


B) How would you change this script so that the message v_final_grade is null is
displayed on the screen if v_final_grade is NULL?

IF v_final_grade IS NULL THEN
DBMS_OUTPUT.PUT_LINE('v_final_grade is null');
ELSIF v_final_grade BETWEEN 90 AND 100 THEN...


C) How would you change this script so that the user provides the student ID and section ID?


D) How would you change the script to define a letter grade without specifying the upper limit of
the final grade? In the statement v_final_grade BETWEEN 90 and 100, number 100 is
the upper limit.

IF v_final_grade >= 90 THEN
v_letter_grade := 'A';
ELSIF v_final_grade >= 80 THEN
v_letter_grade := 'B';
ELSIF v_final_grade >= 70 THEN
v_letter_grade := 'C';
ELSIF v_final_grade >= 60 THEN
v_letter_grade := 'D';
ELSE
v_letter_grade := 'F';
END IF;
*/
----------------------------------------------------------------------------------------------------

--Nested IF Statements



DECLARE
  v_num1  NUMBER := &sv_num1;
  v_num2  NUMBER := &sv_num2;
  v_total NUMBER;
BEGIN
  IF v_num1 > v_num2 THEN
    DBMS_OUTPUT.PUT_LINE ('IF part of the outer IF');
    v_total := v_num1 - v_num2;
  ELSE
    DBMS_OUTPUT.PUT_LINE ('ELSE part of the outer IF');
    v_total   := v_num1 + v_num2;
    IF v_total < 0 THEN
      DBMS_OUTPUT.PUT_LINE ('Inner IF');
      v_total := v_total * (-1);
    END IF;
  END IF;
  DBMS_OUTPUT.PUT_LINE ('v_total = '||v_total);
END;



--LOGICAL OPERATORS with IF

--Harf ve Rakam kontrol� yap?l?r
DECLARE
  v_letter CHAR(1) := '&sv_letter';
BEGIN
  IF (v_letter >= 'A' AND v_letter <= 'Z') OR (v_letter >= 'a' AND v_letter <= 'z') THEN
    DBMS_OUTPUT.PUT_LINE ('This is a letter');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('This is not a letter');
    IF v_letter BETWEEN '0' AND '9' THEN
      DBMS_OUTPUT.PUT_LINE ('This is a number');
    ELSE
      DBMS_OUTPUT.PUT_LINE ('This is not a number');
    END IF;
  END IF;
END;



--4.3.1 Use Nested IF Statements

--Celcius vs Fahreneit D�n�?�m�
-- ch04_4a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_temp_in   NUMBER := &sv_temp_in;
  v_scale_in  CHAR   := '&sv_scale_in';
  v_temp_out  NUMBER;
  v_scale_out CHAR;
BEGIN
  IF v_scale_in != 'C' AND v_scale_in != 'F' THEN
    DBMS_OUTPUT.PUT_LINE ('This is not a valid scale');
  ELSE
    IF v_scale_in  = 'C' THEN
      v_temp_out  := ( (9 * v_temp_in) / 5 ) + 32;
      v_scale_out := 'F';
    ELSE
      v_temp_out  := ( (v_temp_in - 32) * 5 ) / 9;
      v_scale_out := 'C';
    END IF;
    DBMS_OUTPUT.PUT_LINE ('New scale is: '||v_scale_out);
    DBMS_OUTPUT.PUT_LINE ('New temperature is: '||v_temp_out);
  END IF;
END;


/*
A) What output is printed on the screen if the value of 100 is entered for the temperature, and the
letter �C� is entered for the scale?


B) Try to run this script without providing a value for the temperature. What message is displayed on
the screen? Why?

ANSWER: If the value for the temperature is not entered, the script does not compile.
The compiler tries to assign a value to v_temp_in with the help of the substitution variable.
Because the value for v_temp_in has not been entered, the assignment statement fails, and
the following error message is displayed:


C) Try to run this script providing an invalid letter for the temperature scale, such as �V.�What
message is displayed on the screen, and why?


D) Rewrite this script so that if an invalid letter is entered for the scale, v_temp_out is initialized to
0 and v_scale_out is initialized to C.
*/
-- ch04_4b.sql, version 2.0
DECLARE
  v_temp_in   NUMBER := &sv_temp_in;
  v_scale_in  CHAR   := '&sv_scale_in';
  v_temp_out  NUMBER;
  v_scale_out CHAR;
BEGIN
  IF v_scale_in != 'C' AND v_scale_in != 'F' THEN
    DBMS_OUTPUT.PUT_LINE ('This is not a valid scale');
    v_temp_out  := 0;
    v_scale_out := 'C';
  ELSE
    IF v_scale_in  = 'C' THEN
      v_temp_out  := ( (9 * v_temp_in) / 5 ) + 32;
      v_scale_out := 'F';
    ELSE
      v_temp_out  := ( (v_temp_in - 32) * 5 ) / 9;
      v_scale_out := 'C';
    END IF;
  END IF;
  DBMS_OUTPUT.PUT_LINE ('New scale is: '||v_scale_out);
  DBMS_OUTPUT.PUT_LINE ('New temperature is: '||v_temp_out);
END;



-- GIRILEN TARIHIN HAFTAICI VEYA HAFTASONU OLDUGUNU YAZDIRIN
DECLARE
  v_date DATE := TO_DATE('&sv_date', 'DD/MM/YYYY');
  v_day VARCHAR2(10); 
BEGIN
  v_day := TO_CHAR(v_date, 'FMDay');

  IF v_day IN ('SUNDAY', 'SATURDAY') THEN
    DBMS_OUTPUT.PUT_LINE('Gün: ' || v_day || ' - Hafta Sonu');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Gün: ' || v_day || ' - Hafta İçi');
  END IF;
END;

-- GIRILEN SAYI POZITIF MI NEGATIF MI, SIFIR MI
DECLARE
  v_num1  NUMBER := &sv_num1;
BEGIN
  IF v_num1 > 0 THEN
    DBMS_OUTPUT.PUT_LINE ('Pozitif');
  ELSIF v_num1 < 0 THEN
    DBMS_OUTPUT.PUT_LINE ('Negatif');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('Sıfır');
  END IF;
END;

-- 
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
    WHEN v_final_grade BETWEEN 90 AND 100 THEN v_letter_grade :=  'A'
    WHEN v_final_grade BETWEEN 80 AND 89 THEN v_letter_grade :=  'B'
    WHEN v_final_grade BETWEEN 70 AND 79 THEN v_letter_grade :=  'C'
    WHEN v_final_grade BETWEEN 60 AND 69 THEN v_letter_grade :=  'D'
    ELSE 'F'
  END;

  v_letter_grade := CASE
                      WHEN v_final_grade BETWEEN 90 AND 100 THEN 'A'
                      WHEN v_final_grade BETWEEN 80 AND 89 THEN 'B'
                      WHEN v_final_grade BETWEEN 70 AND 79 THEN 'C'
                      WHEN v_final_grade BETWEEN 60 AND 69 THEN 'D'
                      ELSE 'F'
                    END;
                    
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Letter grade is: '|| v_letter_grade);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;



