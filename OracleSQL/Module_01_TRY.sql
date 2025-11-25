-- MODULE 1 TRY IT YOURSELF
---------------------------

/*Chapter 1,“PL/SQL Concepts”

1) To calculate the area of a circle, you must square the circle’s radius and then
multiply it by ?.Write a program that calculates the area of a circle.The value for
the radius should be provided with the help of a substitution variable.Use 3.14
for the value of ?. After the area of the circle is calculated, display it on the screen.


ANSWER: The script should look similar to the following:
*/

SET SERVEROUTPUT ON
DECLARE
  v_radius NUMBER := &sv_radius;
  v_area   NUMBER;
BEGIN
  v_area := POWER(v_radius, 2) * 3.14;
  DBMS_OUTPUT.PUT_LINE ('The area of the circle is: '||v_area);
END;


/*In this exercise, you declare two variables, v_radius and v_area, to store the
values for the radius of the circle and its area, respectively.Next, you compute the
value for the variable v_area with the help of the built-in function POWER and
the value of the v_radius. Finally, you display the value of v_area on the
screen.
Assume that the number 5 has been entered for the value of the variable
v_radius.The script produces the following output:
Enter value for sv_radius: 5
old 2: v_radius NUMBER := &sv_radius;
new 2: v_radius NUMBER := 5;
The area of the circle is: 78.5
PLSQL procedure successfully completed.



2) Rewrite the script ch01_2b.sql, version 2.0. In the output produced by the script,
extra spaces appear after the day of the week.The new script should remove
these extra spaces.
Here’s the current output:
Today is Sunday , 20:39
The new output should have this format:
Today is Sunday, 20:39

ANSWER: The new version of the script should look similar to the following. Changes are shown
in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  v_day VARCHAR2(20);
BEGIN
  v_day := TO_CHAR(SYSDATE, 'fmDay, HH24:MI');
  DBMS_OUTPUT.PUT_LINE ('Today is '|| v_day);
END;

/*
In this script, you modify the format in which you would like to display the date. Notice that the
word Day is now prefixed by the letters fm.These letters guarantee that extra spaces will be
removed from the name of the day. When run, this exercise produces the following output:
TODAY IS TUESDAY, 18:54
PLSQL procedure successfully completed.
*/
