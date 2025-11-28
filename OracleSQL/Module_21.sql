--MODULE 21
-----------



--Packages
-----------


--The Benefits of Using Packages


--21.1.1 Create Package Specifications

-- ch21_1a.sql

CREATE OR REPLACE
PACKAGE manage_students
AS
  PROCEDURE find_sname(
      i_student_id IN student.student_id%TYPE,
      o_first_name OUT student.first_name%TYPE,
      o_last_name OUT student.last_name%TYPE );
  FUNCTION id_is_good(
      i_student_id IN student.student_id%TYPE)
    RETURN BOOLEAN;
END MANAGE_STUDENTS;


/*
A) Type the preceding code into a text file and run the script in a SQL*Plus session. Explain what
happens.

ANSWER: The specification for the package manage_students is compiled into the database.
The specification for the package indicates that there is one procedure and one function.
The procedure, find_sname, requires one IN parameter—the student ID—and it returns two
OUT parameters—the student’s first and last names.The function, id_is_good, takes in a
single parameter of a student ID and returns a Boolean (true or false). Although the body has not
yet been entered into the database, the package is still available for other applications. For
example, if you included a call to one of these procedures in another stored procedure, that
procedure would compile (but would not execute).



B) If the following script were run from a SQL*Plus session, what would be the result, and why?
*/
--body olmad???ndan çal??maz
-- ch21_2a.sql
SET SERVEROUTPUT ON
DECLARE
  v_first_name student.first_name%TYPE;
  v_last_name student.last_name%TYPE;
BEGIN
  manage_students.find_sname (125, v_first_name, v_last_name);
  DBMS_OUTPUT.PUT_LINE(V_FIRST_NAME||' '||V_LAST_NAME);
END;


/*
C) Create a package specification for a package named school_api.The package contains the
PROCEDURE DISCOUNT FROM CHAPTER 19 AND THE FUNCTION NEW_INSTRUCTOR_ID FROM
Chapter 20.
*/

-- ch21_3a.sql
CREATE OR REPLACE
PACKAGE school_api
AS
  PROCEDURE discount;
  FUNCTION new_instructor_id
    RETURN INSTRUCTOR.INSTRUCTOR_ID%TYPE;
END school_api;



--21.1.2 Create Package Bodies


-- ch21_4a.sql
CREATE OR REPLACE
PACKAGE BODY manage_students
AS
PROCEDURE find_sname(
    i_student_id IN student.student_id%TYPE,
    o_first_name OUT student.first_name%TYPE,
    o_last_name OUT student.last_name%TYPE )
IS
  v_student_id student.student_id%TYPE;
BEGIN
  SELECT first_name,
    last_name
  INTO o_first_name,
    o_last_name
  FROM student
  WHERE student_id = i_student_id;
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE ('Error in finding student_id: '||v_student_id);
END find_sname;
FUNCTION id_is_good(
    i_student_id IN student.student_id%TYPE)
  RETURN BOOLEAN
IS
  v_id_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_id_cnt FROM student WHERE student_id = i_student_id;
  RETURN 1 = v_id_cnt;
EXCEPTION
WHEN OTHERS THEN
  RETURN FALSE;
END ID_IS_GOOD;
END manage_students;


/*
B) Create a package body for the package named school_api that you created in the previous
exercise.This will contain the procedure discount from Chapter 19 and the function
new_instructor_id from Chapter 20.
*/

-- ch21_5a.sql
CREATE OR REPLACE
PACKAGE BODY school_api
AS
PROCEDURE discount
IS
  CURSOR c_group_discount
  IS
    SELECT DISTINCT s.course_no,
      c.description
    FROM section s,
      enrollment e,
      course c
    WHERE s.section_id = e.section_id
    GROUP BY s.course_no,
      c.description,
      e.section_id,
      s.section_id
    HAVING COUNT(*) >=8;
BEGIN
  FOR r_group_discount IN c_group_discount
  LOOP
    UPDATE course
    SET cost        = cost * .95
    WHERE course_no = r_group_discount.course_no;
    DBMS_OUTPUT.PUT_LINE ('A 5% discount has been given to' ||r_group_discount.course_no||' '||r_group_discount.description);
  END LOOP;
END discount;
FUNCTION new_instructor_id
  RETURN instructor.instructor_id%TYPE
IS
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
END NEW_INSTRUCTOR_ID;
END school_api;



--21.1.3 Call Stored Packages


-- ch21_6a.sql
SET SERVEROUTPUT ON
DECLARE
  v_first_name student.first_name%TYPE;
  v_last_name student.last_name%TYPE;
BEGIN
  IF manage_students.id_is_good(&&v_id) THEN
    manage_students.find_sname(&&v_id, v_first_name, v_last_name);
    DBMS_OUTPUT.PUT_LINE('Student No. '||&&v_id||' is ' ||v_last_name||', '||v_first_name);
  ELSE
    DBMS_OUTPUT.PUT_LINE ('Student ID: '||&&v_id||' is not in the database.');
  END IF;
END;



/*
A) This example displays how a procedure within a package is executed.What results would you
expect to see if you ran this PL/SQL block?

ANSWER: This is a correct PL/SQL block for running the function and the procedure in the
package manage_students. If an existing student_id is entered, the student’s name is
displayed. If the ID is not valid, an error message is displayed.
*/


/*
C) Create a script that tests the school_api package.
*/


-- ch21_7a.sql
SET SERVEROUTPUT ON
DECLARE
  V_instructor_id instructor.instructor_id%TYPE;
BEGIN
  School_api.Discount;
  v_instructor_id := school_api.new_instructor_id;
  DBMS_OUTPUT.PUT_LINE ('The new id is: '||V_INSTRUCTOR_ID);
END;



--21.1.4 Create Private Objects



/*
A) Replace the last lines of the manage_students package specification in ch21_1a.sql with the
following, and recompile the package specification:
*/

--specification sonuna ekle
PROCEDURE DISPLAY_STUDENT_COUNT;
 END manage_students;


/*
Replace the end of the body with the following, and recompile the package body. Lines 1 through
36 are unchanged from lines 1 through 36 of ch21_4a.sql.
*/

--body sonuna ekle
FUNCTION student_count_priv
  RETURN NUMBER
IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM student;
  RETURN v_count;
EXCEPTION
WHEN OTHERS THEN
  RETURN(0);
END student_count_priv;
PROCEDURE display_student_count
IS
  v_count NUMBER;
BEGIN
  v_count := student_count_priv;
  DBMS_OUTPUT.PUT_LINE ('There are '||v_count||' students.');
END DISPLAY_STUDENT_COUNT;
END manage_students;



/*
B) If you run the following from your SQL*Plus session, what are the results?
*/

--private oldu?undan çal??maz
DECLARE
  V_count NUMBER;
BEGIN
  V_count := Manage_students.student_count_priv;
  DBMS_OUTPUT.PUT_LINE(V_COUNT);
END;


/*
ANSWER: If you have decided that a function is to be private, this means that you don’t want it
to be called as a stand alone function. It should only be called from another function or procedure
within the same package. Because the private function, student_count_priv, cannot be
called from outside the package, you receive the following error message:
*/


/*
C) If you were to run the following, what would you expect to see?
*/

SET SERVEROUTPUT ON
Execute manage_students.display_student_count;


/*
D) Add a private function to the school_api called get_course_descript_private. It
accepts a course.course_no%TYPE and returns a course.description%TYPE. It
searches for and returns the course description for the course number passed to it. If the course
does not exist or if an error occurs, it returns a NULL.
*/

--body sonuna ekle
FUNCTION get_course_descript_private(
    i_course_no course.course_no%TYPE)
  RETURN course.description%TYPE
IS
  v_course_descript course.description%TYPE;
BEGIN
  SELECT description
  INTO v_course_descript
  FROM course
  WHERE course_no = i_course_no;
  RETURN v_course_descript;
EXCEPTION
WHEN OTHERS THEN
  RETURN NULL;
END GET_COURSE_DESCRIPT_PRIVATE;
END manage_students;



--21.1.5 Create Package Variables and Cursors


/*
A) Add a package global variable called v_current_date to student_api.
*/

-- ch21_8a.sql
CREATE OR REPLACE
PACKAGE school_api
AS
  v_current_date DATE;
  PROCEDURE Discount_Cost;
  FUNCTION new_instructor_id
    RETURN INSTRUCTOR.INSTRUCTOR_ID%TYPE;
END school_api;


/*
B) Add an initialization section that assigns the current sysdate to the variable v_current_date.
This variable can then be used in any procedure in the package that needs to make use of the
current date.
*/

-- ch21_8b.sql
CREATE OR REPLACE
PACKAGE BODY school_api
AS
PROCEDURE discount_cost
IS
  CURSOR c_group_discount
  IS
    SELECT DISTINCT s.course_no,
      c.description
    FROM section s,
      enrollment e,
      course c
    WHERE s.section_id = e.section_id
    GROUP BY s.course_no,
      c.description,
      e.section_id,
      s.section_id
    HAVING COUNT(*) >=8;
BEGIN
  FOR r_group_discount IN c_group_discount
  LOOP
    UPDATE course
    SET cost        = cost * .95
    WHERE course_no = r_group_discount.course_no;
    DBMS_OUTPUT.PUT_LINE ('A 5% discount has been given to' ||r_group_discount.course_no||' 
'||r_group_discount.description);
  END LOOP;
END discount_cost;
FUNCTION new_instructor_id
  RETURN instructor.instructor_id%TYPE
IS
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
BEGIN
  SELECT TRUNC(sysdate, 'DD') INTO v_current_date FROM DUAL;
END school_api;


---------------------------------------------------------------------------------------

--Cursor Variables


--package içinde cursor variable (REF CURSOR) kullan?m?
-- ch21_9a.sql
CREATE OR REPLACE
PACKAGE course_pkg
AS
TYPE course_rec_typ
IS
  RECORD
  (
    first_name student.first_name%TYPE,
    last_name student.last_name%TYPE,
    course_no course.course_no%TYPE,
    description course.description%TYPE,
    section_no section.section_no%TYPE );
TYPE course_cur
IS
  REF
  CURSOR
    RETURN course_rec_typ;
    PROCEDURE get_course_list(
        p_student_id    NUMBER ,
        p_instructor_id NUMBER ,
        course_list_cv IN OUT course_cur);
  END course_pkg;
  /
  
  
  
CREATE OR REPLACE
PACKAGE BODY course_pkg
AS
PROCEDURE get_course_list(
    p_student_id    NUMBER ,
    p_instructor_id NUMBER ,
    course_list_cv IN OUT course_cur)
IS
BEGIN
  IF p_student_id IS NULL AND p_instructor_id IS NULL THEN
    OPEN COURSE_LIST_CV FOR SELECT 'Please choose a student-' FIRST_NAME, 'instructor combination' LAST_NAME, NULL COURSE_NO, NULL DESCRIPTION, NULL SECTION_NO 
                            FROM dual;
  ELSIF p_student_id  IS NULL THEN
    OPEN course_list_cv FOR SELECT s.first_name first_name, s.last_name last_name, c.course_no course_no, c.description description, se.section_no section_no
                            FROM INSTRUCTOR I, STUDENT S, SECTION SE, COURSE C, ENROLLMENT E 
                            WHERE i.instructor_id = p_instructor_id AND i.instructor_id = se.instructor_id AND se.course_no = c.course_no AND e.student_id = s.student_id AND e.section_id = se.section_id
                            ORDER BY c.course_no, se.section_no;
  ELSIF p_instructor_id  IS NULL THEN
    OPEN COURSE_LIST_CV FOR SELECT I.FIRST_NAME FIRST_NAME, I.LAST_NAME LAST_NAME, C.COURSE_NO COURSE_NO, C.DESCRIPTION DESCRIPTION, SE.SECTION_NO SECTION_NO 
                            FROM INSTRUCTOR I, STUDENT S, SECTION SE, COURSE C, ENROLLMENT E 
                            WHERE s.student_id    = p_student_id AND i.instructor_id = se.instructor_id AND se.course_no = c.course_no AND e.student_id = s.student_id AND e.section_id = se.section_id
                            ORDER BY c.course_no, se.section_no;
  END IF;
END GET_COURSE_LIST;
END course_pkg;



--21.2.1 Make Use of Cursor Variables



/*
A) Take a look at the preceding example, script ch21_9a.sql, and explain why the package has two
DIFFERENT TYPE DECLARATIONS. ALSO EXPLAIN HOW THE PROCEDURE GET_COURSE_LIST USES THE
cursor variable.
*/


/*
B) Create a SQL*Plus variable that is a cursor variable type.
*/
--SQL*PLUS ile çal??t?r?lacak

VARIABLE course_cv REFCURSOR


/*
C) Execute the procedure course_pkg.get_course_list, with three different types of variable
combinations to show the three possible result sets. After you execute the procedure, display
the values of the SQL*Plus variable you declared in question A).

ANSWER: There are three ways to execute this procedure.The first way is to pass a student ID
but not an instructor ID:
*/

EXEC COURSE_PKG.GET_COURSE_LIST(102, NULL, :COURSE_CV);


PRINT COURSE_CV

/*
FIRST_NAME LAST_NAME COURSE_NO DESCRIPTION SECTION_NO
---------- ---------- ---------- ---------------------- ----------
Charles Lowry 25 Intro to Programming 2
Nina Schorin 25 Intro to Programming 5


The next method is to pass an instructor ID but not a student ID:
*/

exec course_pkg.get_course_list(NULL, 102, :course_cv);

PRINT COURSE_CV

/*
FIRST_NAME LAST_NAME COURSE_NO DESCRIPTION SECTION_NO
----------- ----------- --------- ------------------------ ----------
Jeff Runyan 10 Technology Concepts 2
Dawn Dennis 25 Intro to Programming 4
May Jodoin 25 Intro to Programming 4
Jim Joas 25 Intro to Programming 4
Arun Griffen 25 Intro to Programming 4
Alfred Hutheesing 25 Intro to Programming 4
Lula Oates 100 Hands-On Windows 1
Regina Bose 100 Hands-On Windows 1
Jenny Goldsmith 100 Hands-On Windows 1
Roger Snow 100 Hands-On Windows 1
Rommel Frost 100 Hands-On Windows 1
Debra Boyce 100 Hands-On Windows 1
Janet Jung 120 Intro to Java Programming 4
John Smith 124 Advanced Java Programming 1
Charles Caro 124 Advanced Java Programming 1
Sharon Thompson 124 Advanced Java Programming 1
Evan Fielding 124 Advanced Java Programming 1
Ronald Tangaribuan 124 Advanced Java Programming 1
N Kuehn 146 Java for C/C++ Programmers 2
Derrick Baltazar 146 Java for C/C++ Programmers 2
Angela Torres 240 Intro to the Basic Language 2



The last method is to pass neither the student ID nor the instructor ID:
*/
exec course_pkg.get_course_list(NULL, NULL, :course_cv);



PRINT COURSE_CV

/*
FIRST_NAME LAST_NAME C DESCRIPTION S
----------------------- ------------------------- - ---------------
Please choose a student-instructor combination
*/



/*
D) Create another package called student_info_pkg that has a single procedure called
get_student_info.The get_student_info package will have three parameters.The
first is student_id, the second is a number called p_choice, and the last is a weak cursor
variable.p_choice indicates what information about the student will be delivered. If it is 1,
return the information about the student from the STUDENT table. If it is 2, list all the courses the
student is enrolled in, with the names of the students who are enrolled in the same section as the
student with the student_id that was passed in. If it is 3, return the instructor name for that
student, with the information about the courses the student is enrolled in.
*/

-- ch21_10a.sql
CREATE OR REPLACE
PACKAGE student_info_pkg
AS
TYPE student_details
IS
  REF
  CURSOR;
    PROCEDURE get_student_info(
        p_student_id NUMBER ,
        p_choice     NUMBER ,
        details_cv IN OUT student_details);
  END student_info_pkg;
  /
  
  
  
  
  
CREATE OR REPLACE
PACKAGE BODY student_info_pkg
AS
PROCEDURE get_student_info(
    p_student_id NUMBER ,
    p_choice     NUMBER ,
    details_cv IN OUT student_details)
IS
BEGIN
  IF p_choice = 1 THEN
    OPEN DETAILS_CV FOR SELECT S.FIRST_NAME FIRST_NAME, S.LAST_NAME LAST_NAME, S.STREET_ADDRESS ADDRESS, Z.CITY CITY, Z.STATE STATE, Z.ZIP ZIP 
                        FROM STUDENT S, ZIPCODE Z 
                        WHERE s.student_id = p_student_id AND z.zip = s.zip;
  ELSIF p_choice = 2 THEN
    OPEN details_cv FOR SELECT c.course_no course_no, c.description description, se.section_no section_no, s.first_name first_name, s.last_name last_name
                        FROM STUDENT S, SECTION SE, COURSE C, ENROLLMENT E 
                        WHERE se.course_no = c.course_no AND e.student_id = s.student_id AND e.section_id = se.section_id AND se.section_id IN
    (SELECT e.section_id
    FROM student s,
      enrollment e
    WHERE s.student_id = p_student_id
    AND s.student_id   = e.student_id
    ) ORDER BY c.course_no;
  ELSIF p_choice = 3 THEN
    OPEN details_cv FOR SELECT i.first_name first_name, i.last_name last_name, c.course_no course_no, c.description description, se.section_no section_no
                        FROM INSTRUCTOR I, STUDENT S, SECTION SE, COURSE C, ENROLLMENT E 
                        WHERE S.STUDENT_ID = P_STUDENT_ID AND I.INSTRUCTOR_ID = SE.INSTRUCTOR_ID AND SE.COURSE_NO = C.COURSE_NO AND E.STUDENT_ID = S.STUDENT_ID AND E.SECTION_ID = SE.SECTION_ID 
                        ORDER BY c.course_no, se.section_no;
  END IF;
END GET_STUDENT_INFO;
END student_info_pkg;


/*
E) Run the get_student_info procedure in SQL*Plus, and display the results.
*/


VARIABLE student_cv REFCURSOR
execute student_info_pkg.GET_STUDENT_INFO(102, 1, :student_cv);

PRINT STUDENT_CV

/*
FIRST_ LAST_NAM ADDRESS CITY ST ZIP
------ -------- ------------------ --------------- -- -----
Fred Crocitto 101-09 120th St. Richmond Hill NY 11419
*/


execute student_info_pkg.GET_STUDENT_INFO(102, 2, :student_cv);

PRINT STUDENT_CV

/*
COURSE_NO DESCRIPTION SECTION_NO FIRST_NAME LAST_NAME
---------- ------------------ ---------- ---------- -----------
25 Intro to Programming 2 Fred Crocitto
25 Intro to Programming 2 Judy Sethi
25 Intro to Programming 2 Jenny Goldsmith
25 Intro to Programming 2 Barbara Robichaud
25 Intro to Programming 2 Jeffrey Citron
25 Intro to Programming 2 George Kocka
25 Intro to Programming 5 Fred Crocitto
25 Intro to Programming 5 Hazel Lasseter
25 Intro to Programming 5 James Miller
25 Intro to Programming 5 Regina Gates
25 Intro to Programming 5 Arlyne Sheppard
25 Intro to Programming 5 Thomas Edwards
25 Intro to Programming 5 Sylvia Perrin
25 Intro to Programming 5 M. Diokno
25 Intro to Programming 5 Edgar Moffat
25 Intro to Programming 5 Bessie Heedles
25 Intro to Programming 5 Walter Boremmann
25 Intro to Programming 5 Lorrane Velasco
*/

execute student_info_pkg.GET_STUDENT_INFO(214, 3, :student_cv);

PRINT STUDENT_CV
/*
FIRST_NAME LAST_NAME COURSE_NO DESCRIPTION SECTION_NO
---------- ----------- ---------- --------------------------
Marilyn Frantzen 120 Intro to Java Programming 1
Fernand Hanks 122 Intermediate Java Programming 5
GARY PERTEZ 130 INTRO TO UNIX 2
Marilyn Frantzen 145 Internet Protocols 1
*/

---------------------------------------------------------------------------------------


--Extending the Package


--21.3.1 Extend the Package

/*
A) Create a new package specification called manage_grades.This package will perform a
number of calculations on grades and will need two package level cursors.The first one is for
grade types and will be called c_grade_type. It will have an IN parameter of a section ID. It
will list all the grade types (such as quiz or homework) for a given section that are needed to
calculate a student’s grade in that section.The return items from the cursor will be the grade type
code, the number of that grade type for this section, the percentage of the final grade, and the
drop-lowest indicator. First,write a SELECT statement to make sure that you have the correct
items, and then write this as a cursor in the package.
*/

-- ch21_11a.sql
CREATE OR REPLACE
PACKAGE MANAGE_GRADES
AS
  -- Cursor to loop through all grade types for a given section.
  CURSOR c_grade_type (pc_section_id section.section_id%TYPE, PC_student_ID student.student_id%TYPE)
  IS
    SELECT GRADE_TYPE_CODE,
      NUMBER_PER_SECTION,
      PERCENT_OF_FINAL_GRADE,
      DROP_LOWEST
    FROM grade_Type_weight
    WHERE section_id = pc_section_id
    AND section_id  IN
      (SELECT section_id FROM grade WHERE STUDENT_ID = PC_STUDENT_ID
      );
END MANAGE_GRADES;



/*
B) Add a second package cursor to the package Manage_Grades called c_grades.This cursor
will take a grade type code, student ID, and section ID and return all the grades for that student
for that section of that grade type. For example, if Alice were registered in “Intro to Java
Programming,” this cursor could be used to gather all her quiz grades.
*/


-- ch21_11b.sql
CREATE OR REPLACE
PACKAGE MANAGE_GRADES
AS
  -- Cursor to loop through all grade types for a given section.
  CURSOR c_grade_type (pc_section_id section.section_id%TYPE, PC_student_ID student.student_id%TYPE)
  IS
    SELECT GRADE_TYPE_CODE,
      NUMBER_PER_SECTION,
      PERCENT_OF_FINAL_GRADE,
      DROP_LOWEST
    FROM grade_Type_weight
    WHERE section_id = pc_section_id
    AND section_id  IN
      (SELECT section_id FROM grade WHERE student_id = pc_student_id
      );
  -- Cursor to loop through all grades for a given student
  -- in a given section.
  CURSOR c_grades (p_grade_type_code grade_Type_weight.grade_type_code%TYPE, pc_student_id student.student_id%TYPE, pc_section_id section.section_id%TYPE)
  IS
    SELECT grade_type_code,
      grade_code_occurrence,
      numeric_grade
    FROM grade
    WHERE student_id    = pc_student_id
    AND section_id      = pc_section_id
    AND GRADE_TYPE_CODE = P_GRADE_TYPE_CODE;
END MANAGE_GRADES;



/*
C) Add a procedure to this package specification called final_grade.This function will have
parameters of student ID and section ID. It will return a number that is that student’s final grade in
that section, as well as an exit code.You are adding an exit code instead of raising exceptions
because this makes the procedure more flexible and allows the calling program to choose how to
proceed depending on what the error code is.
*/


-- ch21_11c.sql
CREATE OR REPLACE
PACKAGE MANAGE_GRADES
AS
  -- Cursor to loop through all grade types for a given section.
  CURSOR c_grade_type (pc_section_id section.section_id%TYPE, PC_student_ID student.student_id%TYPE)
  IS
    SELECT GRADE_TYPE_CODE,
      NUMBER_PER_SECTION,
      PERCENT_OF_FINAL_GRADE,
      DROP_LOWEST
    FROM grade_Type_weight
    WHERE section_id = pc_section_id
    AND section_id  IN
      (SELECT section_id FROM grade WHERE student_id = pc_student_id
      );
  -- Cursor to loop through all grades for a given student
  -- in a given section.
  CURSOR c_grades (p_grade_type_code grade_Type_weight.grade_type_code%TYPE, pc_student_id student.student_id%TYPE, pc_section_id section.section_id%TYPE)
  IS
    SELECT grade_type_code,
      grade_code_occurrence,
      numeric_grade
    FROM grade
    WHERE student_id    = pc_student_id
    AND section_id      = pc_section_id
    AND grade_type_code = p_grade_type_code;
  -- Function to calcuate a student's final grade
  -- in one section
  PROCEDURE final_grade(
      P_student_id IN student.student_id%type,
      P_section_id IN section.section_id%TYPE,
      P_Final_grade OUT enrollment.final_grade%TYPE,
      P_EXIT_CODE OUT CHAR);
END MANAGE_GRADES;


/*
D) Add the function to the package body.To perform this calculation, you need a number of variables
to hold values as the calculation is performed.
This exercise is also a very good review of data relationships among the student tables. Before you
begin this exercise, review Appendix B,“Student Database Schema,” which lists the student
schema and describes the tables and their columns.When calculating the final grade, keep in
mind the following:
. Each student is enrolled in a course, and this information is captured in the enrollment
table.
. The enrollment table holds the final grade only for each student enrollment in one section.
. Each section has its own set of elements that are evaluated to come up with the final
grade.
. All grades for these elements (which have been entered, meaning that there is no NULL
value in the database) are in the Grade table.
. Every grade has a grade type code.These codes represent the grade type. For example, the
grade type QZ stands for quiz.The descriptions of each GRADE_TYPE come from the
GRADE_TYPE table.
. The GRADE_TYPE_WEIGHT table holds key information for this calculation. It has one entry
for each grade type that is used in a given section (not all grade types exist for each
section).
. In the GRADE_TYPE_WEIGHT table, the NUMBER_PER_SECTION column lists how many
times a grade type should be entered to compute the final grade for a particular student in
a particular section of a particular course.This helps you determine if all grades for a given
grade type have been entered, or even if too many grades for a given grade type have been
entered.
. You also must consider the DROP_LOWEST flag. It can hold a value of Y (yes) or N (no). If the
DROP_LOWEST flag is Y, you must drop the lowest grade from the grade type when calculating
the final grade.The PERCENT_OF_FINAL_GRADE column refers to all the grades for a
given grade type. For example, if homework is 20% of the final grade, and there are five
homeworks and a DROP_LOWEST flag, each remaining homework is worth 5%.When
calculating the final grade, you should divide the PERCENT_OF_FINAL_GRADE by the
NUMBER_PER_SECTION. (That would be NUMBER_PER_SECTION – 1 if DROP_LOWEST = Y.)
Exit codes should be defined as follows:
. S: Success.The final grade has been computed. If the grade cannot be computed, the
final grade is NULL, and the exit code will be one of the following:
. I: Incomplete. Not all the required grades have been entered for this student in this
section.
. T: Too many grades exist for this student. For example, there should be only four homework
grades, but instead there are six.
. N: No grades have been entered for this student in this section.
. E: A general computation error occurred (exception when_others). Having this type
of exit code allows the procedure to compute final grades when it can. If an Oracle error
is somehow raised by some of the grades, the calling program can still proceed with the
grades that have been computed.
To process the calcuation, you need a number of variables to hold temporary values during the
calculation. Create all the variables for the procedure final_grade. Leave the main block with the
statement NULL; doing so allows you to compile the procedure to check all the syntax for the variable
declaration. Explain how each variable will be used.


ANSWER: The student_id, section_id, and grade_type_code are values carried from one part of
the program to another.That is why a variable is created for each of them. Each instance of a
grade is computed to find out what its percentage of the final grade is. A counter is needed while
processing each grade to ensure that enough grades exist for the given grade count. A lowestgrade
variable helps hold each grade to see if it is the lowest. When the lowest grade for a given
grade type is known, it can be removed from the final grade. Additionally, two variables are used
as row counters to ensure that the cursor was opened.
*/


-- ch21_11d.sql
CREATE OR REPLACE
PACKAGE BODY MANAGE_GRADES
AS
PROCEDURE final_grade(
    P_student_id IN student.student_id%type,
    P_section_id IN section.section_id%TYPE,
    P_Final_grade OUT enrollment.final_grade%TYPE,
    P_Exit_Code OUT CHAR)
IS
  v_student_id student.student_id%TYPE;
  v_section_id section.section_id%TYPE;
  v_grade_type_code grade_type_weight.grade_type_code%TYPE;
  v_grade_percent NUMBER;
  v_final_grade   NUMBER;
  v_grade_count   NUMBER;
  v_lowest_grade  NUMBER;
  v_exit_code     CHAR(1) := 'S';
  v_no_rows1      CHAR(1) := 'N';
  v_no_rows2      CHAR(1) := 'N';
  e_no_grade      EXCEPTION;
BEGIN
  NULL;
END;
END MANAGE_GRADES;



/*
E) Complete the procedure final_grade. Comment each section to explain what is being
processed in each part of the code.
*/


-- ch21_11e.sql
CREATE OR REPLACE
PACKAGE BODY MANAGE_GRADES
AS
PROCEDURE final_grade(
    P_student_id IN student.student_id%type,
    P_section_id IN section.section_id%TYPE,
    P_Final_grade OUT enrollment.final_grade%TYPE,
    P_Exit_Code OUT CHAR)
IS
  v_student_id student.student_id%TYPE;
  v_section_id section.section_id%TYPE;
  v_grade_type_code grade_type_weight.grade_type_code%TYPE;
  v_grade_percent NUMBER;
  v_final_grade   NUMBER;
  v_grade_count   NUMBER;
  v_lowest_grade  NUMBER;
  v_exit_code     CHAR(1) := 'S';
  v_no_rows1      CHAR(1) := 'N';
  v_no_rows2      CHAR(1) := 'N';
  e_no_grade      EXCEPTION;
BEGIN
  v_section_id := p_section_id;
  v_student_id := p_student_id;
  -- Start loop of grade types for the section.
  FOR r_grade IN c_grade_type(v_section_id, v_student_id)
  LOOP
    -- Since cursor is open it has a result
    -- set; change indicator.
    v_no_rows1 := 'Y';
    -- To hold the number of grades per section,
    -- reset to 0 before detailed cursor loops
    v_grade_count     := 0;
    v_grade_type_code := r_grade.GRADE_TYPE_CODE;
    -- Variable to hold the lowest grade.
    -- 500 will not be the lowest grade.
    v_lowest_grade := 500;
    -- Determine what to multiply a grade by to
    -- compute final grade. Must take into consideration
    -- if the drop lowest grade indicator is Y.
    SELECT (r_grade.percent_of_final_grade / DECODE(r_grade.drop_lowest, 'Y', (r_grade.number_per_section - 1), r_grade.number_per_section ))* 0.01
    INTO v_grade_percent
    FROM dual;
    -- Open cursor of detailed grade for a student in a
    -- given section.
    FOR r_detail IN c_grades(v_grade_type_code, v_student_id, v_section_id)
    LOOP
      -- Since cursor is open it has a result
      -- set; change indicator.
      v_no_rows2    := 'Y';
      v_grade_count := v_grade_count + 1;
      -- Handle the situation where there are more
      -- entries for grades of a given grade type
      -- than there should be for that section.
      IF v_grade_count > r_grade.number_per_section THEN
        v_exit_code   := 'T';
        raise e_no_grade;
      END IF;
      -- If drop lowest flag is Y, determine which is lowest
      -- grade to drop
      IF r_grade.drop_lowest       = 'Y' THEN
        IF NVL(v_lowest_grade, 0) >= r_detail.numeric_grade THEN
          v_lowest_grade          := r_detail.numeric_grade;
        END IF;
      END IF;
      -- Increment the final grade with percentage of current
      -- grade in the detail loop.
      v_final_grade := NVL(v_final_grade, 0) + (r_detail.numeric_grade * v_grade_percent);
    END LOOP;
    -- Once detailed loop is finished, if the number of grades
    -- for a given student for a given grade type and section
    -- is less than the required amount, raise an exception.
    IF v_grade_count < r_grade.NUMBER_PER_SECTION THEN
      v_exit_code   := 'I';
      raise e_no_grade;
    END IF;
    -- If the drop lowest flag was Y, you need to take
    -- the lowest grade out of the final grade. It was not
    -- known when it was added which was the lowest grade
    -- to drop until all grades were examined.
    IF r_grade.drop_lowest = 'Y' THEN
      v_final_grade       := NVL(v_final_grade, 0) -
      (v_lowest_grade                              * v_grade_percent);
    END IF;
  END LOOP;
  -- If either cursor had no rows, there is an error.
  IF v_no_rows1  = 'N' OR v_no_rows2 = 'N' THEN
    v_exit_code := 'N';
    raise e_no_grade;
  END IF;
  P_final_grade := v_final_grade;
  P_exit_code   := v_exit_code;
EXCEPTION
WHEN e_no_grade THEN
  P_final_grade := NULL;
  P_exit_code   := v_exit_code;
WHEN OTHERS THEN
  P_final_grade := NULL;
  P_exit_code   := 'E';
END FINAL_GRADE;
END MANAGE_GRADES;



/*
F) Write an anonymous block to test your final_grade procedure.The block should ask for a
student_id and a section_id and return the final grade and an exit code.

ANSWER: It is often a good idea to run a describe command on a procedure to make sure that
all the parameters are in the correct order:
*/


DESC MANAGE_GRADES

/*
PROCEDURE FINAL_GRADE
Argument Name Type In/Out Default?
------------------------------ --------------------- ------ --------
P_STUDENT_ID NUMBER(8) IN
P_SECTION_ID NUMBER(8) IN
P_FINAL_GRADE NUMBER(3) OUT
P_EXIT_CODE CHAR OUT
Now that you have the parameters, the procedure can be called:
*/


-- ch21_11f.sql
SET SERVEROUTPUT ON
DECLARE
  v_student_id student.student_id%TYPE := &sv_student_id;
  v_section_id section.section_id%TYPE := &sv_section_id;
  v_final_grade enrollment.final_grade%TYPE;
  v_exit_code CHAR;
BEGIN
  manage_grades.final_grade(v_student_id, v_section_id, v_final_grade, v_exit_code);
  DBMS_OUTPUT.PUT_LINE('The Final Grade is '||v_final_grade);
  DBMS_OUTPUT.PUT_LINE('The Exit Code is '||V_EXIT_CODE);
END;


/*
G) Add a function to the manage_grades package specification called median_grade that
takes in a course number (p_course_number), a section number (p_section_number),
and a grade type (p_grade_type) and returns a work_grade.grade%TYPE. Create any
cursors or types that the function requires.
*/


-- ch21_11g.sql
CREATE OR REPLACE
PACKAGE MANAGE_GRADES
AS
  -- Cursor to loop through all grade types for a given section.
  CURSOR c_grade_type (pc_section_id section.section_id%TYPE, PC_student_ID student.student_id%TYPE)
  IS
    SELECT GRADE_TYPE_CODE,
      NUMBER_PER_SECTION,
      PERCENT_OF_FINAL_GRADE,
      DROP_LOWEST
    FROM grade_Type_weight
    WHERE section_id = pc_section_id
    AND section_id  IN
      (SELECT section_id FROM grade WHERE student_id = pc_student_id
      );
  -- Cursor to loop through all grades for a given student
  -- in a given section.
  CURSOR c_grades (p_grade_type_code grade_Type_weight.grade_type_code%TYPE, pc_student_id student.student_id%TYPE, pc_section_id section.section_id%TYPE)
  IS
    SELECT grade_type_code,
      grade_code_occurrence,
      numeric_grade
    FROM grade
    WHERE student_id    = pc_student_id
    AND section_id      = pc_section_id
    AND grade_type_code = p_grade_type_code;
  -- Function to calcuate a student's final grade
  -- in one section
  PROCEDURE final_grade(
      P_student_id IN student.student_id%type,
      P_section_id IN section.section_id%TYPE,
      P_Final_grade OUT enrollment.final_grade%TYPE,
      P_Exit_Code OUT CHAR);
  -- ---------------------------------------------------------
  -- Function to calculate the median grade
  FUNCTION median_grade(
      p_course_number section.course_no%TYPE,
      p_section_number section.section_no%TYPE,
      p_grade_type grade.grade_type_code%TYPE)
    RETURN grade.numeric_grade%TYPE;
  CURSOR c_work_grade (p_course_no section.course_no%TYPE, p_section_no section.section_no%TYPE, p_grade_type_code grade.grade_type_code%TYPE )
  IS
    SELECT DISTINCT numeric_grade
    FROM grade
    WHERE section_id =
      (SELECT section_id
      FROM section
      WHERE course_no= p_course_no
      AND section_no = p_section_no
      )
  AND grade_type_code = p_grade_type_code
  ORDER BY numeric_grade;
TYPE t_grade_type
IS
  TABLE OF c_work_grade%ROWTYPE INDEX BY BINARY_INTEGER;
  T_GRADE T_GRADE_TYPE;
END MANAGE_GRADES;



/*
H) Add a function to the manage_grades package specification called median_grade that
takes in a course number (p_cnumber), a section number (p_snumber), and a grade type
(p_grade_type).The function should return the median grade (work_grade.
grade%TYPE datatype) based on those three components. For example, you might use this
function to answer the question,“What is the median grade of homework assignments in ‘Intro to
Java Programming’ section 2?” A true median can contain two values. Because this function can
return only one value, if the median is made up of two values, return the average of the two.
*/


-- ch21_11h.sql
CREATE OR REPLACE
PACKAGE BODY MANAGE_GRADES
AS
PROCEDURE final_grade(
    P_student_id IN student.student_id%type,
    P_section_id IN section.section_id%TYPE,
    P_Final_grade OUT enrollment.final_grade%TYPE,
    P_Exit_Code OUT CHAR)
IS
  v_student_id student.student_id%TYPE;
  v_section_id section.section_id%TYPE;
  v_grade_type_code grade_type_weight.grade_type_code%TYPE;
  v_grade_percent NUMBER;
  v_final_grade   NUMBER;
  v_grade_count   NUMBER;
  v_lowest_grade  NUMBER;
  v_exit_code     CHAR(1) := 'S';
  -- Next two variables are used to calculate whether a cursor
  -- has no result set.
  v_no_rows1 CHAR(1) := 'N';
  v_no_rows2 CHAR(1) := 'N';
  e_no_grade EXCEPTION;
BEGIN
  v_section_id := p_section_id;
  v_student_id := p_student_id;
  -- Start loop of grade types for the section.
  FOR r_grade IN c_grade_type(v_section_id, v_student_id)
  LOOP
    -- Since cursor is open it has a result
    -- set; change indicator.
    v_no_rows1 := 'Y';
    -- To hold the number of grades per section,
    -- reset to 0 before detailed cursor loops
    v_grade_count     := 0;
    v_grade_type_code := r_grade.GRADE_TYPE_CODE;
    -- Variable to hold the lowest grade.
    -- 500 will not be the lowest grade.
    v_lowest_grade := 500;
    -- Determine what to multiply a grade by to
    -- compute final grade. Must take into consideration
    -- if the drop lowest grade indicator is Y.
    SELECT (r_grade.percent_of_final_grade / DECODE(r_grade.drop_lowest, 'Y', (r_grade.number_per_section - 1), r_grade.number_per_section ))* 0.01
    INTO v_grade_percent
    FROM dual;
    -- Open cursor of detailed grade for a student in a
    -- given section.
    FOR r_detail IN c_grades(v_grade_type_code, v_student_id, v_section_id)
    LOOP
      -- Since cursor is open it has a result
      -- set; change indicator.
      v_no_rows2    := 'Y';
      v_grade_count := v_grade_count + 1;
      -- Handle the situation where there are more
      -- entries for grades of a given grade type
      -- than there should be for that section.
      IF v_grade_count > r_grade.number_per_section THEN
        v_exit_code   := 'T';
        raise e_no_grade;
      END IF;
      -- If drop lowest flag is Y determine which is lowest
      -- grade to drop
      IF r_grade.drop_lowest       = 'Y' THEN
        IF NVL(v_lowest_grade, 0) >= r_detail.numeric_grade THEN
          v_lowest_grade          := r_detail.numeric_grade;
        END IF;
      END IF;
      -- Increment the final grade with percentage of current
      -- grade in the detail loop.
      v_final_grade := NVL(v_final_grade, 0) + (r_detail.numeric_grade * v_grade_percent);
    END LOOP;
    -- Once detailed loop is finished, if the number of grades
    -- for a given student for a given grade type and section
    -- is less than the required amount, raise an exception.
    IF v_grade_count < r_grade.NUMBER_PER_SECTION THEN
      v_exit_code   := 'I';
      raise e_no_grade;
    END IF;
    -- If the drop lowest flag was Y, you need to take
    -- the lowest grade out of the final grade. It was not
    -- known when it was added which was the lowest grade
    -- to drop until all grades were examined.
    IF r_grade.drop_lowest = 'Y' THEN
      v_final_grade       := NVL(v_final_grade, 0) -
      (v_lowest_grade                              * v_grade_percent);
    END IF;
  END LOOP;
  -- If either cursor had no rows then there is an error.
  IF v_no_rows1  = 'N' OR v_no_rows2 = 'N' THEN
    v_exit_code := 'N';
    raise e_no_grade;
  END IF;
  P_final_grade := v_final_grade;
  P_exit_code   := v_exit_code;
EXCEPTION
WHEN e_no_grade THEN
  P_final_grade := NULL;
  P_exit_code   := v_exit_code;
WHEN OTHERS THEN
  P_final_grade := NULL;
  P_exit_code   := 'E';
END final_grade;
FUNCTION median_grade(
    p_course_number section.course_no%TYPE,
    p_section_number section.section_no%TYPE,
    p_grade_type grade.grade_type_code%TYPE)
  RETURN grade.numeric_grade%TYPE
IS
BEGIN
  FOR r_work_grade IN c_work_grade(p_course_number, p_section_number, p_grade_type)
  LOOP
    t_grade(NVL(t_grade.COUNT,0) + 1).numeric_grade := r_work_grade.numeric_grade;
  END LOOP;
  IF t_grade.COUNT = 0 THEN
    RETURN NULL;
  ELSE
    IF MOD(t_grade.COUNT, 2) = 0 THEN
      -- There is an even number of work grades. Find the middle
      -- two and average them.
      RETURN (t_grade(t_grade.COUNT / 2).numeric_grade + t_grade((t_grade.COUNT / 2) + 1).numeric_grade ) / 2;
    ELSE
      -- There is an odd number of grades. Return the one in
      -- the middle.
      RETURN t_grade(TRUNC(t_grade.COUNT / 2, 0) + 1).numeric_grade;
    END IF;
  END IF;
EXCEPTION
WHEN OTHERS THEN
  RETURN NULL;
END MEDIAN_GRADE;
END MANAGE_GRADES;



/*
I) Write a SELECT statement that uses the function median_grade and shows the median grade
for all grade types in sections 1 and 2 of course 25.
*/


-- ch21_11i.sql
SELECT COURSE_NO,
  COURSE_NAME,
  SECTION_NO,
  GRADE_TYPE,
  manage_grades.median_grade (COURSE_NO, SECTION_NO, GRADE_TYPE) median_grade
FROM
  (SELECT DISTINCT C.COURSE_NO COURSE_NO,
    C.DESCRIPTION COURSE_NAME,
    S.SECTION_NO SECTION_NO,
    G.GRADE_TYPE_CODE GRADE_TYPE
  FROM SECTION S,
    COURSE C,
    ENROLLMENT E,
    GRADE G
  WHERE C.course_no = s.course_no
  AND s.section_id  = e.section_id
  AND e.student_id  = g.student_id
  AND c.course_no   = 25
  AND S.SECTION_NO BETWEEN 1 AND 2
  ORDER BY 1,
    4,
    3
  ) grade_source





