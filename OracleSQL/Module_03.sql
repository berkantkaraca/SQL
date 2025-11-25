
--MODULE 3
------------


--SQL in PL/SQL
---------------------------


--VARIABLE INITIALIZATION WITH SELECT INTO

-- ch03_1a.sql
SET SERVEROUTPUT ON
DECLARE
  v_average_cost VARCHAR2(10);
BEGIN
  SELECT TO_CHAR(AVG(cost), '$9,999.99') INTO v_average_cost FROM course;
  DBMS_OUTPUT.PUT_LINE('The average cost of a course in the CTA program is '|| V_AVERAGE_COST);
END;



--LAB 3.1

--3.1.1 Use the Select INTO Syntax for Variable Initialization

/*A) Execute the script ch03_1a.sql. What is displayed on the SQL*Plus screen? Explain the results.
*/



/*B) Take the same PL/SQL block, and place the line with the DBMS_OUTPUT before the SELECT INTO
statement. What is displayed on the SQL*Plus screen? Explain what the value of the variable is at
each point in the PL/SQL block.

ANSWER: You see the following result:
The average cost of a course in the CTA program is
PL/SQL procedure successfully completed.
The variable v_average_cost is set to NULL when it is first declared. Because the
DBMS_OUTPUT is placed before the variable is given a value, the output for the variable is NULL.
After the SELECT INTO, the variable is given the same value as in the original block described in
question A, but it is not displayed because there is no other DBMS_OUTPUT line in the PL/SQL
block.
Data Definition Language (DDL) is not valid in a simple PL/SQL block. (More-advanced techniques
such as procedures in the DBMS_SQL package enable you to make use of DDL.) However, DML is
easily achieved either by use of variables or by simply putting a DML statement into a PL/SQL
block. Here is an example of a PL/SQL block that UPDATEs an existing entry in the zip code table:
*/



--UPDATE in PL/SQL
-- ch03_2a.sql
DECLARE
  v_city zipcode.city%TYPE;
BEGIN
  SELECT 'COLUMBUS' INTO v_city FROM dual;
  UPDATE zipcode SET city = v_city WHERE ZIP = 43224;
END;



--INSERT in PL/SQL
-- ch03_3a.sql
DECLARE
  v_zip zipcode.zip%TYPE;
  v_user zipcode.created_by%TYPE;
  v_date zipcode.created_date%TYPE;
BEGIN
  SELECT 43438, USER, SYSDATE INTO v_zip, v_user, v_date FROM dual;
  INSERT
  INTO zipcode
    (
      ZIP,
      CREATED_BY ,
      CREATED_DATE,
      MODIFIED_BY,
      MODIFIED_DATE
    )
    VALUES
    (
      V_ZIP,
      V_USER,
      V_DATE,
      V_USER,
      V_DATE
    );
END;



--INSERT Ornek
-- ch03_4a.sql
DECLARE 
  v_max_id NUMBER;
BEGIN
  SELECT MAX(student_id) INTO v_max_id FROM student;
  INSERT
  INTO student
    (
      student_id,
      last_name,
      zip,
      created_by,
      created_date,
      modified_by,
      modified_date,
      registration_date
    )
    VALUES
    (
      V_MAX_ID + 1,
      'altintas',
      11238,
      'STUDENT',
      TO_DATE('20130101','YYYYMMDD'),
      'STUDENT',
      '01-JAN-13',
      '01-JAN-13'
    );
END;



--USING AN ORACLE SEQUENCE
-- ch03_3a.sql
CREATE TABLE test01
  (col1 NUMBER
  );
  
CREATE SEQUENCE test_seq INCREMENT BY 5;
  
  BEGIN
    INSERT INTO test01 VALUES
      (test_seq.NEXTVAL
      );
  END;
  /
  
  SELECT * FROM test01;



--3.1.3 Make Use of a Sequence in a PL/SQL Block



-- ch03_5a.sql
DECLARE
  v_user student.created_by%TYPE;
  v_date student.created_date%TYPE;
BEGIN
  SELECT USER, sysdate INTO v_user, v_date FROM dual;
  INSERT
  INTO student
    (
      student_id,
      last_name,
      zip,
      created_by,
      created_date,
      modified_by,
      modified_date,
      registration_date
    )
    VALUES
    (
      student_id_seq.nextval,
      'Smith',
      11238,
      v_user,
      v_date,
      v_user,
      v_date,
      v_date
    );
END;


-----------------------------------------------------------------------------------


--Making Use of SAVEPOINT

--COMMIT yap?lmadan i?lemler
-- ch03_6a.sql
BEGIN
  -- STEP 1
  UPDATE course
  SET cost = cost - (cost * 0.10)
  WHERE prerequisite IS NULL;
  -- STEP 2
  UPDATE COURSE
  SET cost = cost + (cost * 0.10)
  WHERE PREREQUISITE IS NOT NULL;
END;



--COMMIT yap?lmadan INSERT
-- ch03_6a.sql
INSERT
INTO student
  (
    student_id,
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
    student_id_seq.nextval,
    'Tashi',
    10015,
    '01-JAN-99',
    'STUDENTA',
    '01-JAN-99',
    'STUDENTA',
    '01-JAN-99'
  );
  
  COMMIT;
  ROLLBACK;
  
  
  
  --3.2.1 Make Use of COMMIT, ROLLBACK, and SAVEPOINT in a PL/SQL Block
  
  -- ch03_7a.sql
BEGIN
INSERT INTO student
( student_id, Last_name, zip, registration_date,
created_by, created_date, modified_by,
modified_date
)
VALUES ( student_id_seq.nextval, 'Tashi', 10015,
'01-JAN-99', 'STUDENTA', '01-JAN-99',
'STUDENTA','01-JAN-99'
);
SAVEPOINT A;
INSERT INTO student
( student_id, Last_name, zip, registration_date,
created_by, created_date, modified_by,
modified_date
)
VALUES (student_id_seq.nextval, 'Sonam', 10015,
'01-JAN-99', 'STUDENTB','01-JAN-99',
'STUDENTB', '01-JAN-99'
);
SAVEPOINT B;
INSERT INTO student
( student_id, Last_name, zip, registration_date,
created_by, created_date, modified_by,
modified_date
)
VALUES (student_id_seq.nextval, 'Norbu', 10015,
'01-JAN-99', 'STUDENTB', '01-JAN-99',
'STUDENTB', '01-JAN-99'
);
SAVEPOINT C;
ROLLBACK TO B;
END;
 -- rolback yapınca norbu işleme alınmaz. tashi ve sonam eklenir ama commit bekler 
select * from student order by student_id;
  
/*A) If you tried to issue the following command, what would you expect to see, and why?

SELECT *
FROM student
WHERE last_name = 'Norbu';

ANSWER: You would not be able to see any data, because the ROLLBACK to (SAVEPOINT) B has
undone the last insert statement where the student �Norbu�was inserted.

B) Try issuing this command.What happens, and why?

ANSWER: When you issue this command, you get the message no rows selected.
Three students were inserted in this PL/SQL block: first,Tashi in SAVEPOINT A, and then Sonam in
SAVEPOINT B, and finally Norbu in SAVEPOINT C.Then, when the command ROLLBACK to B was
issued, the insertion of Norbu was undone.

C) Now issue the following command:
ROLLBACK to SAVEPOINT A;
What happens?

ANSWER: The insert in SAVEPOINT B is undone.This deletes the insert of Sonam, who was
inserted in SAVEPOINT B.

D) If you were to issue the following, what would you expect to see?
SELECT last_name
FROM student
WHERE last_name = 'Tashi';

ANSWER: You would see the data for Tashi.

E) Issue the command, and explain your findings.

ANSWER: You see one entry for Tashi, as follows:
LAST_NAME
-------------------------
Tashi
TASHI WAS THE ONLY STUDENT SUCCESSFULLY ENTERED INTO THE DATABASE.THE ROLLBACK TO SAVEPOINT A
undid the insert statement for Norbu and Sonam.
 */
 
 

  
  
  
  
  
  
  


