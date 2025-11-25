-- MODULE 6
-----------


--Iterative Control: Part I
----------------------------


--Simple Loops

--EXIT yerine RETURN ile blok sonland?r?l?r. Exit döngüye özgü.
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Line 1');
  RETURN;
  DBMS_OUTPUT.PUT_LINE ('Line 2');
END;


--Condition olmadan loop sonland?r?l?rsa
DECLARE
  v_counter NUMBER := 0;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    EXIT;
  END LOOP;
END;



--6.1.1 Use Simple Loops with EXIT Conditions

-- ch06_1a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_counter BINARY_INTEGER := 0;
BEGIN
  LOOP
    -- increment loop counter by one
    v_counter := v_counter + 1;
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    -- if EXIT condition yields TRUE exit the loop
    
    EXIT WHEN v_counter = 5;
    
    IF v_counter = 5 THEN
      EXIT;
    END IF;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;



/*
B) How many times did the loop execute?

ANSWER: The loop executed five times.


C) What is the EXIT condition for this loop?

ANSWER: The EXIT condition for this loop is v_counter = 5.


D) How many times is the value of the variable v_counter displayed if the
DBMS_OUTPUT.PUT_LINE statement is used after the END IF statement?

ANSWER: The value of v_counter is displayed four times.


F) Rewrite this script using the EXIT WHEN condition instead of the EXIT condition so that it
produces the same result.
*/

-- ch06_1b.sql, version 2.0
SET SERVEROUTPUT ON
DECLARE
  v_counter BINARY_INTEGER := 0;
BEGIN
  LOOP
    -- increment loop counter by one
    v_counter := v_counter + 1;
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    -- if EXIT WHEN condition yields TRUE exit the loop
    EXIT WHEN v_counter = 5;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;


--6.1.2 Use Simple Loops with EXIT WHEN Conditions


--430 nolu kursa 102 nolu e?itmen i�in 4 tane yeni section a�?l?yor
-- ch06_2a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_course course.course_no%type                := 430;
  v_instructor_id instructor.instructor_id%type := 102;
  v_sec_num section.section_no%type             := 0;
BEGIN
  LOOP
    -- increment section number by one
    v_sec_num := v_sec_num + 1;
    INSERT
    INTO section
      (
        section_id,
        course_no,
        section_no,
        instructor_id,
        created_date,
        created_by,
        modified_date,
        modified_by
      )
      VALUES
      (
        section_id_seq.nextval,
        v_course,
        v_sec_num,
        v_instructor_id,
        SYSDATE,
        USER,
        SYSDATE,
        USER
      );
    -- if number of sections added is four exit the loop
    EXIT WHEN v_sec_num = 4;
  END LOOP;
  -- control resumes here
 -- COMMIT;
END;

select * from section order by section_id desc;

/*
A) How many sections will be added for the specified course number?

ANSWER: Four sections will be added for the given course number.


B) How many times will the loop be executed if the course number is invalid?

ANSWER: The loop will be partially executed once.


C) How would you change this script to add ten sections for the specified course number?

EXIT WHEN v_sec_num = 10;

ONCE ESK? KAYITLAR S?L?NMEL?D?R!!!!!!!!!

DELETE FROM section
WHERE course_no = 430
AND section_no <= 4;
COMMIT;


D) How would you change the script to add only even-numbered sections (the maximum section
number is 10) for the specified course number?

v_sec_num := v_sec_num + 2;


E) How many times does the loop execute in this case?

ANSWER: The loop executes five times when even-numbered sections are added for the given
course number.
*/


----------------------------------------------------------------------------------------------


--WHILE Loops


--D�ng� i�ine girilmiyor
DECLARE
  v_counter NUMBER := 5;
BEGIN
  WHILE v_counter < 5
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    -- decrement the value of v_counter by one
    v_counter := v_counter - 1;
  END LOOP;
END;


--Hatal? hali, sonsuz d�ng�....
DECLARE
  v_counter NUMBER := 1;
BEGIN
  WHILE v_counter < 5
  LOOP
    DBMS_OUTPUT.PUT_LINE('v_counter = '||v_counter);
    -- decrement the value of v_counter by one
    v_counter := v_counter - 1;
  END LOOP;
END;



--Premature termination
DECLARE
  v_counter NUMBER := 1;
BEGIN
  WHILE v_counter <= 5
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    IF v_counter = 2 THEN
      EXIT;
    END IF;
    v_counter := v_counter + 1;
  END LOOP;
END;



--Normal termination
DECLARE
  v_counter NUMBER := 1;
BEGIN
  WHILE v_counter <= 2
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    v_counter   := v_counter + 1;
    IF v_counter = 5 THEN
      EXIT;
    END IF;
  END LOOP;
END;



--6.2.1 Use WHILE Loops

/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- 1 ile 10 aras?ndaki say?lar?n toplam?
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/
DECLARE
  v_counter NUMBER := 1;
  v_toplam NUMBER := 0;
BEGIN
  WHILE v_counter <= 10
  LOOP
    v_toplam   := v_counter + v_toplam;
    v_counter := v_counter + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('v_toplam = '||v_toplam);
END;

DECLARE
  v_toplam NUMBER := 0;
BEGIN
  FOR v_counter IN 1..10
  LOOP
    v_toplam   := v_counter + v_toplam;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('v_toplam = '||v_toplam);
END;






---------------------------------------------------------------------------------------------


--Numeric FOR Loops

BEGIN
  FOR v_counter IN 1..5
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
  END LOOP;
END;



--D�ng� de?i?keni tan?mlan?rsa hata olu?ur
BEGIN
  FOR v_counter IN 1..5
  LOOP
    v_counter := v_counter + 1;
    DBMS_OUTPUT.PUT_LINE ('v_counter = '|| v_counter);
  END LOOP;
END;


--D�ng� d???nda d�ng� de?i?keni kullan?lamaz
BEGIN
  FOR v_counter IN 1..5
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('Counter outside the loop is '||V_COUNTER);
END;



--IN REVERSE kullan?m?
BEGIN
  FOR v_counter IN REVERSE 1..5
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
  END LOOP;
END;



--Premature termination FOR
BEGIN
  FOR v_counter IN 1..5
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    EXIT WHEN v_counter = 3;
  END LOOP;
END;


--6.3.1 Use Numeric FOR Loops with the IN Option

/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--10 say?s?n?n fakt�riyeli
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


*/
DECLARE
  v_sonuc NUMBER := 1;
BEGIN
  FOR v_counter IN 1..10
  LOOP
    v_sonuc   := v_counter * v_sonuc;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('v_sonuc = '||v_sonuc);
END;


--6.3.2 Use Numeric FOR Loops with the REVERSE Option

--10 dan geriye �ift say?lar?n yaz?lmas?
-- ch06_5a.sql, version 1.0
SET SERVEROUTPUT ON
BEGIN
  FOR v_counter IN REVERSE 0..10
  LOOP
    -- if v_counter is even, display its value on the
    -- screen
    IF MOD(v_counter, 2) = 0 THEN
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    END IF;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;



/*
B) How many times does the body of the loop execute?    11


C) How many times is the value of v_counter displayed on the screen?    6


D) How would you change this script to start the list from 0 and go up to 10?

FOR v_counter IN 0..10 LOOP


E) How would you change the script to display only odd numbers on the screen?

IF MOD(v_counter, 2) != 0 THEN


F) How many times does the loop execute in this case?     11

*/















