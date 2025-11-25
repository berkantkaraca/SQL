--MODULE 1--
------------
--PL/SQL CONCEPTS

--PL/SQL IN CLIENT/SERVER Architecture

SET SERVEROUTPUT ON --DBMS_OUTPUT.PUT_LINE çıktısını göstermek için kullanılır
DECLARE
  v_first_name VARCHAR2(35);
  v_last_name  VARCHAR2(35);
BEGIN
  SELECT first_name,
    last_name
  INTO v_first_name,
    v_last_name
  FROM student
  WHERE student_id = 123;
  DBMS_OUTPUT.PUT_LINE ('Student name: '||v_first_name||' '|| v_last_name);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no student with '|| 'student id 123');
END;

--------------------------------------------------------------------------------

-- LAB 1.1
--1.1.1 Use PL/SQL Anonymous Blocks

/*A) Why it is more efficient to combine SQL statements into PL/SQL blocks?

ANSWER: It is more efficient to use SQL statements within PL/SQL blocks because network
traffic can be decreased significantly, and an application becomes more efficient as well.
When a SQL statement is issued on the client computer, the request is made to the database on
the server, and the result set is sent back to the client. As a result, a single SQL statement causes
two trips on the network. If multiple SELECT statements are issued, the network traffic can quickly
increase significantly. For example, four SELECT statements cause eight network trips. If these
STATEMENTS ARE PART OF THE PL/SQL BLOCK, STILL ONLY TWO NETWORK TRIPS ARE MADE, AS IN THE CASE OF A
single SELECT statement.
*/

/*B) What are the differences between named and anonymous PL/SQL blocks?

ANSWER: Named PL/SQL blocks can be stored in the database and referenced later by their
names. Because anonymous PL/SQL blocks do not have names, they cannot be stored in the database
and referenced later.
For the next two questions, consider the following code:
*/

DECLARE
  v_name  VARCHAR2(50);
  v_total NUMBER;
BEGIN
  SELECT i.first_name
    ||' '
    ||i.last_name,
    COUNT(*)
  INTO v_name,
    v_total
  FROM instructor i,
    section s
  WHERE i.instructor_id = s.instructor_id
  AND i.instructor_id   = 102
  GROUP BY i.first_name
    ||' '
    ||i.last_name;
  DBMS_OUTPUT.PUT_LINE ('Instructor '||v_name||' teaches '||v_total||' courses');
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no such instructor');
END;


/*C) Based on the code example provided, describe the structure of a PL/SQL block.

ANSWER: PL/SQL blocks contain three sections: the declaration section, the executable section,
and the exception-handling section.The executable section is the only mandatory section of the
PL/SQL block.
*/

/*D) What happens when the runtime error NO_DATA_FOUND occurs in the PL/SQL block just shown?

ANSWER: When a runtime error occurs in the PL/SQL block, control is passed to the exceptionhandling
section of the block.The exception NO_DATA_FOUND is evaluated then with the help of
the WHEN clause.
*/


--1.1.2 Understand How PL/SQL Gets Executed

/*A) What happens when an anonymous PL/SQL block is executed?

ANSWER: When an anonymous PL/SQL block is executed, the code is sent to the PL/SQL engine
on the server, where it is compiled.
*/

/*B) What steps are included in the compilation process of a PL/SQL block?

ANSWER: The compilation process includes syntax checking, binding, and p-code generation.
Syntax checking involves checking PL/SQL code for compilation errors. After syntax errors have
been corrected, a storage address is assigned to the variables that are used to hold data for
Oracle.This process is called binding.Next, p-code is generated for the PL/SQL block. P-code is a
LIST OF INSTRUCTIONS TO THE PL/SQL ENGINE. FOR NAMED BLOCKS, P-CODE IS STORED IN THE DATABASE, AND IT
is used the next time the program is executed.
*/



/*C) What is a syntax error?

ANSWER: A syntax error occurs when a statement does not correspond to the syntax rules of the
programming language. An undefined variable and a misplaced keyword are examples of syntax
errors.
*/



/*D) How does a syntax error differ from a runtime error?

ANSWER: A syntax error can be detected by the PL/SQL compiler. A runtime error occurs while
the program is running and cannot be detected by the PL/SQL compiler.
A misspelled keyword is an example of a syntax error. For example, this script:
BEIN
DBMS_OUTPUT.PUT_LINE ('This is a test');
END;
contains a syntax error.Try to find it.
A SELECT INTO statement returning no rows is an example of a runtime error.This error can be
handled with the help of the exception-handling section of the PL/SQL block.
*/

-----------------------------------------------------------------------------------------------

--LAB 1.2


--PL/SQL in SQL*Plus


-- Substitution variable

--SET VERIFY OFF
DECLARE
  v_student_id NUMBER := &sv_student_id;
  v_first_name VARCHAR2(35);
  v_last_name  VARCHAR2(35);
BEGIN
  SELECT first_name,
    last_name
  INTO v_first_name,
    v_last_name
  FROM student
  WHERE student_id = v_student_id;
  DBMS_OUTPUT.PUT_LINE ('Student name: '||v_first_name||' '|| v_last_name);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE ('There is no such student');
END;


-- & ile kullanımı
-- Her karşılaşıldığında tekrar değer girmeni ister
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Today is '||'&sv_day');
  DBMS_OUTPUT.PUT_LINE ('Tomorrow will be '||'&sv_day');
END;



-- && ile kullanımı
-- İlk karşılaşıldığında değer girmeni ister, sonra devamlı girilen değeri kullanır birdaha sormaz.
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Today is '||'&&sv_day');
  DBMS_OUTPUT.PUT_LINE ('Tomorrow will be '||'&sv_day');
END;

--GIRILEN SAYININ KARESINI ALMA
DECLARE
  v_number NUMBER := &sv_number1;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Karesi: ' || power(v_number));
END;


SET SERVEROUTPUT ON
DECLARE
  v_num NUMBER := &sv_num;
  v_result   NUMBER;
BEGIN
  v_result := POWER(v_num, 2);
  DBMS_OUTPUT.PUT_LINE ('Kare: '||v_result);
END;

--BUGUNUN GUN, AY, YIL, SAAT, DAKIKA, SANIYE, HAFTANIN GUNU, AY ISMI YAZDIRMA
BEGIN
  DBMS_OUTPUT.PUT_LINE('Tarih: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY'));
  DBMS_OUTPUT.PUT_LINE('Saat: ' || TO_CHAR(SYSDATE, 'HH24:MI:SS'));
  DBMS_OUTPUT.PUT_LINE('Gün: ' || TO_CHAR(SYSDATE, 'Day')); 
  DBMS_OUTPUT.PUT_LINE('Ay: ' || TO_CHAR(SYSDATE, 'Month'));       
END;