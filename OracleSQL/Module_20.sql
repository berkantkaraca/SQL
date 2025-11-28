--MODULE 20
-----------



--Functions
------------


--Creating and Using Functions


-- ch20_01a.sql ver 1.0
CREATE OR REPLACE
  FUNCTION show_description(
      i_course_no course.course_no%TYPE)
    RETURN VARCHAR2
  AS
    v_description VARCHAR2(50);
  BEGIN
    SELECT description
    INTO v_description
    FROM course
    WHERE course_no = i_course_no;
    RETURN v_description;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN('The Course IS NOT IN the DATABASE');
  WHEN OTHERS THEN
    RETURN('Error in running show_description');
  END;


--test et
DECLARE
  v_desc VARCHAR2(100);
BEGIN
  V_DESC := SHOW_DESCRIPTION(100);
  DBMS_OUTPUT.PUT_LINE(v_desc);

END;



--20.1.1 Create Stored Functions


/*
B) Create another function using the following script. Explain what is happening in this function. Pay
close attention to the method of creating the Boolean return.
*/

-- ch20_01b.sql, version 1.0
CREATE OR REPLACE
  FUNCTION id_is_good(
      i_student_id IN NUMBER)
    RETURN BOOLEAN
  AS
    v_id_cnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_id_cnt FROM student WHERE student_id = i_student_id;
    RETURN 1 = v_id_cnt;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
  END id_is_good;



/*
ANSWER: The function id_is_good is a check to see if the student ID passed in exists in the
database.The function takes in a NUMBER datatype (which is assumed to be a student ID) and
returns a BOOLEAN value.The function uses the variable v_id_cnt as a means to process the
data.The SELECT INTO statement determines a total number of students with the ID that was
passed in. If the student with such ID is already in the database, the value of v_id_cnt is 1.This
is because the student_id column is the primary key and as such enforces uniqueness on the
values stored in it. If the student with provided ID is not in the database, the value of v_id_cnt
is 0. Note that the SELECT INTO statement does not cause a NO_DATA_FOUND exception as the
COUNT(*) function returns 0 for non-existent student ID.Next, the RETURN clause returns TRUE if
the value of the v_id_cnt is 1 because the expression 1 = v_id_cnt evaluates to TRUE,
and FALSE if the value of the v_id_cnt is 0 because the expression 1 = v_id_cnt evaluates
to FALSE.The function will also return FALSE when it encounters an exception.
*/

--test et
DECLARE
  v_id boolean;
BEGIN
  V_ID := ID_IS_GOOD(102);
  IF V_ID = TRUE THEN
  DBMS_OUTPUT.PUT_LINE('Do?ru');
  ELSE
  DBMS_OUTPUT.PUT_LINE('Yanl??');
  END IF;
END;


--20.1.2 Make Use of Functions


/*
A) Use the following anonymous block to run the function.When prompted, enter 350.Then try
other numbers.What is produced?
*/

SET SERVEROUTPUT ON
DECLARE
  v_description VARCHAR2(50);
BEGIN
  v_description := show_description(&sv_cnumber);
  DBMS_OUTPUT.PUT_LINE(V_DESCRIPTION);
END;


/*
B) Create a similar anonymous block to make use of the function id_is_good.Try running it for a
number of different IDs.
*/

DECLARE
  v_id NUMBER;
BEGIN
  v_id := &id;
  IF id_is_good(v_id) THEN
    DBMS_OUTPUT.PUT_LINE ('Student ID: '||v_id||' is a valid.');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('Student ID: '||v_id||' is not valid.');
  END IF;
END;



--20.1.3 Invoke Functions in SQL Statements

/*
A) Now you will try another method of using a stored function. Before you type the following SELECT
STATEMENT, THINK ABOUT WHAT THE FUNCTION SHOW_DESCRIPTION IS DOING.WILL THIS STATEMENT
produce an error? If not, what will be displayed?
*/


SELECT COURSE_NO, SHOW_DESCRIPTION(COURSE_NO)
FROM course;


--20.1.4 Write Complex Functions

/*
A) Create the function using the following script. Before you execute the function, analyze this script
and explain line by line what the function does.When could you use this function? Hint:You will
use it in the package for the next chapter.
*/

-- ch20_01c.sql, version 1.0
CREATE OR REPLACE
  FUNCTION new_instructor_id
    RETURN instructor.instructor_id%TYPE
  AS
    v_new_instid instructor.instructor_id%TYPE;
  BEGIN
    SELECT INSTRUCTOR_ID_SEQ.NEXTVAL INTO v_new_instid FROM dual;
    RETURN v_new_instid;
  EXCEPTION
  WHEN OTHERS THEN
    DECLARE
      v_sqlerrm VARCHAR2(250) := SUBSTR(SQLERRM,1,250);
    BEGIN
      RAISE_APPLICATION_ERROR(-20003, 'Error in instructor_id: '||v_sqlerrm);
    END;
  END new_instructor_id;










