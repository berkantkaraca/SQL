
--MODULE 2
-----------


--General Programming Language Fundamentals
-------------------------------------------


--LAB 2.1


--2.1.1 Make Use of PL/SQL Language Components


/*A) Why does PL/SQL have so many different types of characters? What are they used for?

ANSWER: The PL/SQL engine recognizes different characters as having different meanings and
therefore processes them differently. PL/SQL is neither a pure mathematical language nor a
spoken language, yet it contains elements of both. Letters form various lexical units such as identifiers
or keywords.Mathematic symbols form lexical units called delimiters that perform an operation.
Other symbols, such as /*, indicate comments that are ignored by the PL/SQL engine.
*/



/*B) What are the PL/SQL equivalents of a verb and a noun in English? Do you speak PL/SQL?

ANSWER: A noun is similar to the lexical unit called an identifier. A verb is similar to the lexical
unit called a delimiter.Delimiters can simply be quotation marks, but others perform a function
such as multiplication (*).You do �speak PL/SQL� to the Oracle server.
*/



--Make Use of PL/SQL Variables


/*FOR EXAMPLE
v_student_id
v_last_name
V_LAST_NAME
apt_#

Note that the identifiers v_last_name and V_LAST_NAME are considered identical because
PL/SQL is not case-sensitive.
Next, consider an example of illegal identifiers:

FOR EXAMPLE
X+Y
1st_year
student ID

Identifier X+Y is illegal because it contains a + sign.This sign is reserved by PL/SQL to denote an addition
OPERATION; IT IS CALLED A MATHEMATICAL SYMBOL. IDENTIFIER 1st_yEAR IS ILLEGAL BECAUSE IT STARTS WITH A
number. Finally, identifier student ID is illegal because it contains a space.
*/


--Hatalı identifier yazımı. & kullanılmamalı. Aynı değer de aynı girilmeli!!!
SET SERVEROUTPUT ON;
DECLARE
first&last_names VARCHAR2(30);
BEGIN
first&last_names := 'TEST NAME';
DBMS_OUTPUT.PUT_LINE(FIRST&LAST_NAMES);
END;




-- ch02_1a.sql
SET SERVEROUTPUT ON
DECLARE
  v_name       VARCHAR2(30);
  v_dob        DATE;
  v_us_citizen BOOLEAN;
BEGIN
  DBMS_OUTPUT.PUT_LINE(V_NAME||'born on'||V_DOB);
END;

/*A) If you ran this example in a SQL*Plus or Oracle SQL Developer, what would be the result?

ANSWER: Assuming that SET SERVEROUTPUT ON had been issued, you would get only born
on.The reason is that the variables v_name and v_dob have no values.
*/



/*B) Run the example and see what happens. Explain what is happening as the focus moves from one
line to the next.

ANSWER: Three variables are declared.When each one is declared, its initial value is null.
v_name is set as a VARCHAR2 with a length of 30, v_dob is set as a character type date, and
v_us_citizen is set to BOOLEAN.When the executable section begins, the variables have no
values.Therefore, when DBMS_OUTPUT is told to print their values, it prints nothing.
You can see this if you replace the variables as follows: Instead of v_name, use
COALESCE(v_name, 'No Name'), and instead of v_dob, use COALESCE(v_dob,
'01-Jan-1999').
The COALESCE function compares each expression to NULL from the list of expressions and
returns the value of the first non-null expression. In this case, it compares the v_name variable
and �No Name� string to NULL and returns the value of �No Name�.This is because the v_name
variable has not been initialized and as such is NULL.The COALESCE function is covered in
Chapter 5,�Conditional Control: CASE Statements.�
Then run the same block, and you get the following:
No Name born on 01-Jan-1999
To make use of a variable, you must declare it in the declaration section of the PL/SQL block.You
have to give it a name and state its datatype.You also have the option to give your variable an
initial value. Note that if you do not assign a variable an initial value, it is NULL. It is also possible to
constrain the declaration to �not null,� in which case you must assign an initial value.Variables
MUST FIRST BE DECLARED, AND THEN THEY CAN BE REFERENCED. PL/SQL DOES NOT ALLOW FORWARD REFERENCES.
You can set the variable to be a constant, which means that it cannot change.
*/



--2.1.3 Handle PL/SQL Reserved Words


SET SERVEROUTPUT ON;
DECLARE
  exception VARCHAR2(15);
BEGIN
  EXCEPTION := 'This is a test';
  DBMS_OUTPUT.PUT_LINE(EXCEPTION);
END;


/*A) What would happen if you ran this PL/SQL block? Would you receive an error message? If so, what
would it say?

ANSWER: In this example, you declare a variable called exception.Next, you initialize this
variable and display its value on the screen.
This example illustrates an invalid use of reserved words.To the PL/SQL compiler,�exception� is a
reserved word that denotes the beginning of the exception-handling section. As a result, it cannot
be used to name a variable. Consider the huge error message that this tiny example produces:
*/



--2.1.4 Make Use of Identifiers in PL/SQL

SET SERVEROUTPUT ON;
DECLARE
  v_var1 VARCHAR2(20);
  v_var2 VARCHAR2(6);
  v_var3 NUMBER(5,3);
BEGIN
  v_var1 := 'string literal';
  v_var2 := '12.345';
  v_var3 := 12.345;
  DBMS_OUTPUT.PUT_LINE('v_var1: '||v_var1);
  DBMS_OUTPUT.PUT_LINE('v_var2: '||v_var2);
  DBMS_OUTPUT.PUT_LINE('v_var3: '||V_VAR3);
END;


--HATALI KULLANIM
SET SERVEROUTPUT ON;
DECLARE
  v_var1 NUMBER(2)   := 123;
  v_var2 NUMBER(3)   := 123;
  v_var3 NUMBER(5,3) := 123456.123;
BEGIN
  DBMS_OUTPUT.PUT_LINE('v_var1: '||v_var1);
  DBMS_OUTPUT.PUT_LINE('v_var2: '||v_var2);
  DBMS_OUTPUT.PUT_LINE('v_var3: '||V_VAR3);
END;


/*A) What would happen if you ran this PL/SQL block?

ANSWER: In this example, you declare and initialize three numeric variables.The first declaration
and initialization (v_var1 NUMBER(2) := 123) causes an error because the value 123
exceeds the specified precision.The second variable declaration and initialization (v_var2
NUMBER(3) := 123) does not cause any errors because the value 123 corresponds to the
specified precision.The last declaration and initialization (v_var3 NUMBER(5,3) :=
123456.123) CAUSES AN ERROR BECAUSE THE VALUE 123456.123 EXCEEDS THE SPECIFIED PRECISION.
As a result, this example produces the following output:
*/




--2.1.5 Make Use of Anchored Datatypes


-- ch02_2a.sql
SET SERVEROUTPUT ON
DECLARE
  v_name student.first_name%TYPE;
  v_grade grade.numeric_grade%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(NVL(v_name, 'No Name ')|| ' has grade of '||NVL(V_GRADE, 0));
END;


/*A) In this example, what is declared? State the datatype and value.

ANSWER: The variable v_name is declared with the identical datatype as the column
first_name from the database table STUDENT. In other words, the v_name variable is
defined as VARCHAR2(25). Additionally, the variable v_grade is declared with the identical
datatype as the column grade_numeric from the database table GRADE .That is to say, the
v_grade_numeric variable is defined as NUMBER(3). Each variable has a value of NULL.
*/



--2.1.6 Declare and Initialize Variables


-- ch02_3a.sql
SET SERVEROUTPUT ON
DECLARE
  v_cookies_amt         NUMBER          := 2;
  v_calories_per_cookie CONSTANT NUMBER := 300;
BEGIN
  DBMS_OUTPUT.PUT_LINE('I ate ' || v_cookies_amt || ' cookies with ' || v_cookies_amt * v_calories_per_cookie || ' calories.');
  v_cookies_amt := 3;
  DBMS_OUTPUT.PUT_LINE('I really ate ' || v_cookies_amt || ' cookies with ' || v_cookies_amt * v_calories_per_cookie || ' calories.');
  v_cookies_amt := v_cookies_amt + 5;
  DBMS_OUTPUT.PUT_LINE('The truth is, I actually ate ' || v_cookies_amt || ' cookies with ' || v_cookies_amt * v_calories_per_cookie || ' calories.');
END;


/*A) WHAT WILL THE OUTPUT BE FOR THIS SCRIPT? EXPLAIN WHAT IS BEING DECLARED AND WHAT THE VALUE OF THE
variable is throughout the scope of the block.
*/

SET SERVEROUTPUT ON
DECLARE
  v_lname   VARCHAR2(30);
  v_regdate DATE;
  v_pctincr CONSTANT NUMBER(4,2) := 1.50;
  v_counter NUMBER               := 0;
  v_new_cost course.cost%TYPE;
  v_YorN BOOLEAN := TRUE;
BEGIN
  v_counter  := NVL(v_counter, 0) + 1;
  v_new_cost := 800               * v_pctincr;
  DBMS_OUTPUT.PUT_LINE(v_counter);
  DBMS_OUTPUT.PUT_LINE(v_new_cost);
  v_counter  := ((v_counter + 5)*2) / 2;
  v_new_cost := (v_new_cost * v_counter)/4;
  DBMS_OUTPUT.PUT_LINE(v_counter);
  DBMS_OUTPUT.PUT_LINE(V_NEW_COST);
END;

/*C) What will the values of the variables be at the end of the script?
*/


--2.1.7 Understand the Scope of a Block, Nested Blocks, and Labels


-- ch02_4b.sql
SET SERVEROUTPUT ON 
<< outer_block >>
DECLARE
  v_test NUMBER := 123;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Outer Block, v_test: '||v_test);
  << inner_block >>
  DECLARE
    v_test NUMBER := 456;
  BEGIN
    DBMS_OUTPUT.PUT_LINE ('Inner Block, v_test: '||v_test);
    DBMS_OUTPUT.PUT_LINE ('Inner Block, outer_block.v_test: '|| Outer_block.v_test);
  END INNER_BLOCK;
END outer_block;

