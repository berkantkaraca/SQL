--MODULE 15 TRY IT YOURSELF
----------------------------



--Chapter 15,“Collections”

/*
1) Create the following script: Create an associative array (index-by table), and populate it with the
instructor’s full name. In other words, each row of the associative array should contain the first
name, middle initial, and last name. Display this information on the screen.

ANSWER: The script should look similar to the following:
*/

SET SERVEROUTPUT ON
DECLARE
  CURSOR name_cur
  IS
    SELECT first_name||' '||last_name name FROM instructor;
TYPE name_type
IS
  TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
  name_tab name_type;
  v_counter INTEGER := 0;
BEGIN
  FOR name_rec IN name_cur
  LOOP
    v_counter           := v_counter + 1;
    name_tab(v_counter) := name_rec.name;
    DBMS_OUTPUT.PUT_LINE ('name('||v_counter||'): '|| name_tab(v_counter));
  END LOOP;
END;


/*
In the preceding example, the associative array name_tab is populated with instructors’ full
names.Notice that the variable v_counter is used as a subscript to reference individual array
elements.This example produces the following output:
name(1): Fernand Hanks
name(2): Tom Wojick
name(3): Nina Schorin
name(4): Gary Pertez
name(5): Anita Morris
name(6): Todd Smythe
name(7): Marilyn Frantzen
name(8): Charles Lowry
name(9): Rick Chow
PL/SQL procedure successfully completed.



2) Modify the script you just created. Instead of using an associative array, use a varray.

ANSWER: The script should look similar to the following. Changes are shown in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  CURSOR name_cur
  IS
    SELECT first_name||' '||last_name name FROM instructor;
TYPE name_type IS VARRAY(15) OF VARCHAR2(50);
name_varray name_type := name_type();
v_counter INTEGER     := 0;
BEGIN
  FOR name_rec IN name_cur
  LOOP
    v_counter := v_counter + 1;
    name_varray.EXTEND;
    name_varray(v_counter) := name_rec.name;
    DBMS_OUTPUT.PUT_LINE ('name('||v_counter||'): '|| name_varray(v_counter));
  END LOOP;
END;


/*
In this version of the script, you define a varray of 15 elements. It is important to remember to
initialize the array before referencing its individual elements. In addition, the array must be
extended before new elements are added to it.



3) Modify the script you just created. Create an additional varray, and populate it with unique course
numbers for the courses that each instructor teaches.Display the instructor’s name and the list of
courses he or she teaches.

ANSWER: The script should look similar to the following:
*/


SET SERVEROUTPUT ON
DECLARE
  CURSOR instructor_cur
  IS
    SELECT instructor_id, first_name||' '||last_name name FROM instructor;
  CURSOR course_cur (p_instructor_id NUMBER)
  IS
    SELECT UNIQUE course_no course
    FROM section
    WHERE instructor_id = p_instructor_id;
TYPE name_type IS VARRAY(15) OF VARCHAR2(50);
name_varray name_type := name_type();
TYPE course_type IS VARRAY(10) OF NUMBER;
course_varray course_type;
v_counter1 INTEGER := 0;
v_counter2 INTEGER;
BEGIN
  FOR instructor_rec IN instructor_cur
  LOOP
    v_counter1 := v_counter1 + 1;
    name_varray.EXTEND;
    name_varray(v_counter1) := instructor_rec.name;
    DBMS_OUTPUT.PUT_LINE ('name('||v_counter1||'): '|| name_varray(v_counter1));
    -- Initialize and populate course_varray
    v_counter2    := 0;
    course_varray := course_type();
    FOR course_rec IN course_cur (instructor_rec.instructor_id)
    LOOP
      v_counter2 := v_counter2 + 1;
      course_varray.EXTEND;
      course_varray(v_counter2) := course_rec.course;
      DBMS_OUTPUT.PUT_LINE ('course('||v_counter2||'): '|| course_varray(v_counter2));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('===========================');
  END LOOP;
END;


/*
Consider the script you just created. First, you declare two cursors, INSTRUCTOR_CUR and
COURSE_CUR. COURSE_CUR accepts a parameter because it returns a list of courses taught by a
particular instructor. Notice that the SELECT statement uses the function UNIQUE to retrieve
distinct course numbers. Second, you declare two varray types and variables,name_varray
and course_varray.Notice that you do not initialize the second varray at the time of declaration.
Next, you declare two counters and initialize the first counter only.
In the body of the block, you open INSTRUCTOR_CUR and populate name_varray with its first
element. Next, you initialize the second counter and course_varray.This step is necessary
because you need to repopulate course_varray for the next instructor. Next, you open
COURSE_CUR to retrieve corresponding courses and display them on the screen.
When run, the script produces the following output:
name(1): Fernand Hanks
course(1): 25
course(2): 120
course(3): 122
course(4): 125
course(5): 134
course(6): 140
course(7): 146
course(8): 240
course(9): 450
===========================
name(2): Tom Wojick
course(1): 10
course(2): 25
course(3): 100
course(4): 120
course(5): 124
course(6): 125
course(7): 134
course(8): 140
course(9): 146
course(10): 240
===========================
name(3): Nina Schorin
course(1): 20
course(2): 25
course(3): 100
course(4): 120
course(5): 124
course(6): 130
course(7): 134
course(8): 142
course(9): 147
course(10): 310
===========================
name(4): Gary Pertez
course(1): 20
course(2): 25
course(3): 100
course(4): 120
course(5): 124
course(6): 130
course(7): 135
course(8): 142
course(9): 204
course(10): 330
===========================
name(5): Anita Morris
course(1): 20
course(2): 25
course(3): 100
course(4): 122
course(5): 124
course(6): 130
course(7): 135
course(8): 142
course(9): 210
course(10): 350
===========================
name(6): Todd Smythe
course(1): 20
course(2): 25
course(3): 100
course(4): 122
course(5): 125
course(6): 130
course(7): 135
course(8): 144
course(9): 220
course(10): 350
===========================
name(7): Marilyn Frantzen
course(1): 25
course(2): 120
course(3): 122
course(4): 125
course(5): 132
course(6): 135
course(7): 145
course(8): 230
course(9): 350
===========================
name(8): Charles Lowry
course(1): 25
course(2): 120
course(3): 122
course(4): 125
course(5): 132
course(6): 140
course(7): 145
course(8): 230
course(9): 420
===========================
name(9): Rick Chow
===========================
name(10): Irene Willig
===========================
PL/SQL procedure successfully completed.

As mentioned, it is important to reinitialize the variable v_counter2 that is used to reference
individual elements of course_varray.When this step is omitted and the variable is initialized
only once, at the time of declaration, the script generates the following runtime error:
name(1): Fernand Hanks
course(1): 25
course(2): 120
course(3): 122
course(4): 125
course(5): 134
course(6): 140
course(7): 146
course(8): 240
course(9): 450
name(2): Tom Wojick
DECLARE
*
ERROR at line 1:
ORA-06533: Subscript beyond count
ORA-06512: at line 33
Why do you think this error occurs?



4) Find and explain the errors in the following script:
*/


DECLARE
TYPE varray_type1 IS VARRAY(7) OF INTEGER;
TYPE table_type2
IS
  TABLE OF varray_type1 INDEX BY BINARY_INTEGER;
  varray1 varray_type1 := varray_type1(1, 2, 3);
  table2 table_type2   := table_type2(varray1, varray_type1(8, 9, 0));
BEGIN
  DBMS_OUTPUT.PUT_LINE ('table2(1)(2): '||table2(1)(2));
  FOR i IN 1..10
  LOOP
    varray1.EXTEND;
    varray1(i) := i;
    DBMS_OUTPUT.PUT_LINE ('varray1('||i||'): '||varray1(i));
  END LOOP;
END;

/*
ANSWER: This script generates the following errors:
table2 table_type2 := table_type2(varray1, varray_type1(8, 9, 0));
*
ERROR at line 6:
ORA-06550: line 6, column 26:
PLS-00222: no function with name 'TABLE_TYPE2' exists in this scope
ORA-06550: line 6, column 11:
PL/SQL: Item ignored
ORA-06550: line 9, column 44:
PLS-00320: the declaration of the type of this expression is
incomplete or malformed
ORA-06550: line 9, column 4:
PL/SQL: Statement ignored
Notice that this error refers to the initialization of table2, which has been declared as an associative
array of varrays. Recall that associative arrays are not initialized prior to their use. As a
result, the declaration of table2 must be modified. Furthermore, an additional assignment
statement must be added to the executable portion of the block:
*/


DECLARE
TYPE varray_type1 IS VARRAY(7) OF INTEGER;
TYPE table_type2
IS
  TABLE OF varray_type1 INDEX BY BINARY_INTEGER;
  varray1 varray_type1 := varray_type1(1, 2, 3);
  table2 table_type2;
BEGIN
  -- These statements populate associative array
  table2(1) := varray1;
  table2(2) := varray_type1(8, 9, 0);
  DBMS_OUTPUT.PUT_LINE ('table2(1)(2): '||table2(1)(2));
  FOR i IN 1..10
  LOOP
    varray1.EXTEND;
    varray1(i) := i;
    DBMS_OUTPUT.PUT_LINE ('varray1('||i||'): '||varray1(i));
  END LOOP;
END;


/*
When run, this version produces a different error:
table2(1)(2): 2
varray1(1): 1
varray1(2): 2
varray1(3): 3
varray1(4): 4
DECLARE
*
ERROR at line 1:
ORA-06532: Subscript outside of limit
ORA-06512: at line 15
Notice that this is a runtime error that refers to varray1.This error occurs because you are
trying to extend the varray beyond its limit.varray1 can contain up to seven integers. After
initialization, it contains three integers. As a result, it can be populated with no more than four
additional integers. So the fifth iteration of the loop tries to extend the varray to eight elements,
which in turn causes a Subscript outside of limit error.
It is important to note that there is no correlation between the loop counter and the EXTEND
method. Every time the EXTEND method is called, it increases the size of the varray by one
element. Because the varray has been initialized to three elements, the EXTEND method adds a
fourth element to the array for the first iteration of the loop. At the same time, the first element of
the varray is assigned a value of 1 through the loop counter. For the second iteration of the loop,
the EXTEND method adds a fifth element to the varray while the second element is assigned a
value of 2, and so forth.
Finally, consider the error-free version of the script:
DECLARE
TYPE varray_type1 IS VARRAY(7) OF INTEGER;
TYPE table_type2 IS TABLE OF varray_type1 INDEX BY
BINARY_INTEGER;
varray1 varray_type1 := varray_type1(1, 2, 3);
table2 table_type2;
BEGIN
-- These statements populate associative array
table2(1) := varray1;
table2(2) := varray_type1(8, 9, 0);
DBMS_OUTPUT.PUT_LINE ('table2(1)(2): '||table2(1)(2));
658 APPENDIX D: Answers to the Try it Yourself Sections
FOR i IN 4..7 LOOP
varray1.EXTEND;
varray1(i) := i;
END LOOP;
-- Display elements of the varray
FOR i IN 1..7 LOOP
DBMS_OUTPUT.PUT_LINE ('varray1('||i||'): '||varray1(i));
END LOOP;
END;
The output is as follows:
table2(1)(2): 2
varray1(1): 1
varray1(2): 2
varray1(3): 3
varray1(4): 4
varray1(5): 5
varray1(6): 6
VARRAY1(7): 7
PL/SQL procedure successfully completed.
*/








