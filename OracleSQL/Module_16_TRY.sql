--MODULE 16 TRY IT YOURSELF
-----------------------------


--Chapter 16,“Records”

/*
1) Create an associative array with the element type of a user-defined record.This record should
contain the first name, last name, and total number of courses that a particular instructor teaches.
Display the records of the associative array on the screen.

ANSWER: The script should look similar to the following:
*/


SET SERVEROUTPUT ON
DECLARE
  CURSOR instructor_cur
  IS
    SELECT first_name,
      last_name,
      COUNT(UNIQUE s.course_no) courses
    FROM instructor i
    LEFT OUTER JOIN section s
    ON (s.instructor_id = i.instructor_id)
    GROUP BY first_name,
      last_name;
TYPE rec_type
IS
  RECORD
  (
    first_name instructor.first_name%type,
    last_name instructor.last_name%type,
    courses_taught NUMBER);
TYPE instructor_type
IS
  TABLE OF REC_TYPE INDEX BY BINARY_INTEGER;
  instructor_tab instructor_type;
  v_counter INTEGER := 0;
BEGIN
  FOR instructor_rec IN instructor_cur
  LOOP
    v_counter := v_counter + 1;
    -- Populate associative array of records
    instructor_tab(v_counter).first_name     := instructor_rec.first_name;
    instructor_tab(v_counter).last_name      := instructor_rec.last_name;
    instructor_tab(v_counter).courses_taught := instructor_rec.courses;
    DBMS_OUTPUT.PUT_LINE ('Instructor, '|| instructor_tab(v_counter).first_name||' '|| instructor_tab(v_counter).last_name||', teaches '|| instructor_tab(v_counter).courses_taught||' courses.');
  END LOOP;
END;

/*
Consider the SELECT statement used in this script. It returns the instructor’s name and the total
number of courses he or she teaches.The statement uses an outer join so that if a particular
instructor is not teaching any courses, he or she will be included in the results of the SELECT statement.
Note that the SELECT statement uses the ANSI 1999 SQL standard.
BY THE WAY
You will find detailed explanations and examples of the statements using the new ANSI 1999 SQL
standard in Appendix C and in the Oracle help. Throughout this book we have tried to provide
examples illustrating both standards; however, our main focus is on PL/SQL features rather than SQL.
In this script, you define a cursor against the INSTRUCTOR and SECTION tables that is used to
populate the associative array of records, instructor_tab. Each row of this table is a userdefined
record of three elements.You populate the associative array using the cursor FOR loop.
Consider the notation used to reference each record element of the associative array:
instructor_tab(v_counter).first_name
instructor_tab(v_counter).last_name
instructor_tab(v_counter).courses_taught
To reference each row of the associative array, you use the counter variable.However, because
each row of this table is a record, you must also reference individual fields of the underlying
record.When run, this script produces the following output:
Instructor, Anita Morris, teaches 10 courses.
Instructor, Charles Lowry, teaches 9 courses.
Instructor, Fernand Hanks, teaches 9 courses.
Instructor, Gary Pertez, teaches 10 courses.
Instructor, Marilyn Frantzen, teaches 9 courses.
Instructor, Nina Schorin, teaches 10 courses.
Instructor, Rick Chow, teaches 1 courses.
Instructor, Todd Smythe, teaches 10 courses.
Instructor, Tom Wojick, teaches 9 courses.
PL/SQL procedure successfully completed.



2) Modify the script you just created. Instead of using an associative array, use a nested table.

ANSWER: The script should look similar to the following. Changes are shown in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  CURSOR instructor_cur
  IS
    SELECT first_name,
      last_name,
      COUNT(UNIQUE s.course_no) courses
    FROM instructor i
    LEFT OUTER JOIN section s
    ON (s.instructor_id = i.instructor_id)
    GROUP BY first_name,
      last_name;
TYPE rec_type
IS
  RECORD
  (
    first_name instructor.first_name%type,
    last_name instructor.last_name%type,
    courses_taught NUMBER);
TYPE instructor_type
IS
  TABLE OF REC_TYPE;
  instructor_tab instructor_type := instructor_type();
  v_counter INTEGER              := 0;
BEGIN
  FOR instructor_rec IN instructor_cur
  LOOP
    v_counter := v_counter + 1;
    instructor_tab.EXTEND;
    -- Populate associative array of records
    instructor_tab(v_counter).first_name     := instructor_rec.first_name;
    instructor_tab(v_counter).last_name      := instructor_rec.last_name;
    instructor_tab(v_counter).courses_taught := instructor_rec.courses;
    DBMS_OUTPUT.PUT_LINE ('Instructor, '|| instructor_tab(v_counter).first_name||' '|| instructor_tab(v_counter).last_name||', teaches '|| instructor_tab(v_counter).courses_taught||' courses.');
  END LOOP;
END;

/*
Notice that the instructor_tab must be initialized and extended before its individual
elements can be referenced.



3) Modify the script you just created. Instead of using a nested table, use a varray.

ANSWER: The script should look similar to the following:
*/


SET SERVEROUTPUT ON
DECLARE
  CURSOR instructor_cur
  IS
    SELECT first_name,
      last_name,
      COUNT(UNIQUE s.course_no) courses
    FROM instructor i
    LEFT OUTER JOIN section s
    ON (s.instructor_id = i.instructor_id)
    GROUP BY first_name,
      last_name;
TYPE rec_type
IS
  RECORD
  (
    first_name instructor.first_name%type,
    last_name instructor.last_name%type,
    courses_taught NUMBER);
TYPE instructor_type IS VARRAY(10) OF REC_TYPE;
instructor_tab instructor_type := instructor_type();
v_counter INTEGER              := 0;
BEGIN
  FOR instructor_rec IN instructor_cur
  LOOP
    v_counter := v_counter + 1;
    instructor_tab.EXTEND;
    -- Populate associative array of records
    instructor_tab(v_counter).first_name     := instructor_rec.first_name;
    instructor_tab(v_counter).last_name      := instructor_rec.last_name;
    instructor_tab(v_counter).courses_taught := instructor_rec.courses;
    DBMS_OUTPUT.PUT_LINE ('Instructor, '|| instructor_tab(v_counter).first_name||' '|| instructor_tab(v_counter).last_name||', teaches '|| instructor_tab(v_counter).courses_taught||' courses.');
  END LOOP;
END;

/*
This version of the script is almost identical to the previous version. Instead of using a nested
table, you are using a varray of 15 elements.



4) Create a user-defined record with four fields: course_no, description, cost, and
prerequisite_rec.The last field, prerequisite_rec, should be a user-defined record
with three fields: prereq_no, prereq_desc, and prereq_cost. For any ten courses that
have a prerequisite course, populate the user-defined record with all the corresponding data, and
display its information on the screen.

ANSWER: The script should look similar to the following:
*/


SET SERVEROUTPUT ON
DECLARE
  CURSOR c_cur
  IS
    SELECT course_no,
      description,
      cost,
      prerequisite
    FROM course
    WHERE prerequisite IS NOT NULL
    AND rownum         <= 10;
TYPE prerequisite_type
IS
  RECORD
  (
    prereq_no   NUMBER,
    prereq_desc VARCHAR(50),
    prereq_cost NUMBER);
TYPE course_type
IS
  RECORD
  (
    course_no   NUMBER,
    description VARCHAR2(50),
    cost        NUMBER,
    prerequisite_rec PREREQUISITE_TYPE);
  course_rec COURSE_TYPE;
BEGIN
  FOR c_rec IN c_cur
  LOOP
    course_rec.course_no   := c_rec.course_no;
    course_rec.description := c_rec.description;
    course_rec.cost        := c_rec.cost;
    SELECT course_no,
      description,
      cost
    INTO course_rec.prerequisite_rec.prereq_no,
      course_rec.prerequisite_rec.prereq_desc,
      course_rec.prerequisite_rec.prereq_cost
    FROM course
    WHERE course_no = c_rec.prerequisite;
    DBMS_OUTPUT.PUT_LINE ('Course: '|| course_rec.course_no||' - '|| course_rec.description);
    DBMS_OUTPUT.PUT_LINE ('Cost: '|| course_rec.cost);
    DBMS_OUTPUT.PUT_LINE ('Prerequisite: '|| course_rec.prerequisite_rec. prereq_no||' - '|| course_rec.prerequisite_rec.prereq_desc);
    DBMS_OUTPUT.PUT_LINE ('Prerequisite Cost: '|| course_rec.prerequisite_rec.prereq_cost);
    DBMS_OUTPUT.PUT_LINE ('========================================');
  END LOOP;
END;


/*
In the declaration portion of the script, you define a cursor against the COURSE table; two userdefined
record types, prerequisite_type and course_type; and user-defined record,
course_rec. It is important to note the order in which the record types are declared.The
prerequsite_type must be declared first because one of the course_type elements is
of the prerequisite_type.
In the executable portion of the script, you populate course_rec using the cursor FOR loop.
First, you assign values to course_rec.course_no, course_rec.description, and
course_rec.cost.Next, you populate the nested record, prerequsite_rec, using the
SELECT INTO statement against the COURSE table. Consider the notation used to reference individual
elements of the nested record:
course_rec.prerequisite_rec.prereq_no,
course_rec.prerequisite_rec.prereq_desc,
course_rec.prerequisite_rec.prereq_cost
You specify the name of the outer record followed by the name of the inner (nested) record,
followed by the name of the element. Finally, you display record information on the screen.
Note that this script does not contain a NO_DATA_FOUND exception handler even though there
is a SELECT INTO statement.Why do you think this is the case?
When run, the script produces the following output:
Course: 230 - Intro to the Internet
Cost: 1095
Prerequisite: 10 - Technology Concepts
Prerequisite Cost: 1195
========================================
Course: 100 - Hands-On Windows
Cost: 1195
Prerequisite: 20 - Intro to Information Systems
Prerequisite Cost: 1195
========================================
Course: 140 - Systems Analysis
Cost: 1195
Prerequisite: 20 - Intro to Information Systems
Prerequisite Cost: 1195
========================================
Course: 142 - Project Management
Cost: 1195
Prerequisite: 20 - Intro to Information Systems
Prerequisite Cost: 1195
========================================
Course: 147 - GUI Design Lab
Cost: 1195
Prerequisite: 20 - Intro to Information Systems
Prerequisite Cost: 1195
========================================
Course: 204 - Intro to SQL
Cost: 1195
Prerequisite: 20 - Intro to Information Systems
Prerequisite Cost: 1195
========================================
Course: 240 - Intro to the BASIC Language
Cost: 1095
Prerequisite: 25 - Intro to Programming
Prerequisite Cost: 1195
========================================
Course: 420 - Database System Principles
Cost: 1195
Prerequisite: 25 - Intro to Programming
Prerequisite Cost: 1195
========================================
Course: 120 - Intro to Java Programming
Cost: 1195
Prerequisite: 80 - Programming Techniques
Prerequisite Cost: 1595
========================================
Course: 220 - PL/SQL Programming
Cost: 1195
Prerequisite: 80 - Programming Techniques
Prerequisite Cost: 1595
========================================
PL/SQL procedure successfully completed.

*/




