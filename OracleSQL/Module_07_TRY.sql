--MODULE 7 TRY IT YOURSELF
----------------------------


--Chapter 7,“Iterative Control: Part II”

/*
1) Rewrite script ch06_4a.sql to calculate the factorial of even integers only between 1 and 10.The
script should use a CONTINUE or CONTINUE WHEN statement.

ANSWER: Recall script ch06_4a.sql:
*/

SET SERVEROUTPUT ON
DECLARE
  v_factorial NUMBER := 1;
BEGIN
  FOR v_counter IN 1..10
  LOOP
    v_factorial := v_factorial * v_counter;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Factorial of ten is: '||v_factorial);
END;


/*
Next, consider a new version of the script that uses a CONTINUE WHEN statement. Changes are
shown in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  v_factorial NUMBER := 1;
BEGIN
  FOR v_counter IN 1..10
  LOOP
    CONTINUE WHEN MOD(v_counter, 2) != 0;
    v_factorial          := v_factorial * v_counter;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Factorial of even numbers between 1 and 10 is: '|| v_factorial);
END;


/*
In this version of the script, you add a CONTINUE WHEN statement that passes control to the top
of the loop if the current value of v_counter is not an even number.The rest of the script
remains unchanged.Note that you could specify the CONTINUE condition using an IF-THEN statement
as well:
IF MOD(v_counter, 2) != 0 THEN
CONTINUE;
END IF;
When run, this example shows the following output:
Factorial of even numbers between 1 and 10 is: 3840
PL/SQL procedure successfully completed.



2) Rewrite script ch07_3a.sql using a simple loop instead of the outer FOR loop, and a WHILE loop for
the inner FOR loop.Make sure that the output produced by this script does not differ from the
output produced by the original script.

ANSWER: Consider the original version of the script:
*/


SET SERVEROUTPUT ON
DECLARE
  v_test NUMBER := 0;
BEGIN
  <<outer_loop>>
  FOR i IN 1..3
  LOOP
    DBMS_OUTPUT.PUT_LINE('Outer Loop');
    DBMS_OUTPUT.PUT_LINE('i = '||i);
    DBMS_OUTPUT.PUT_LINE('v_test = '||v_test);
    v_test := v_test + 1;
    <<inner_loop>>
    FOR j IN 1..2
    LOOP
      DBMS_OUTPUT.PUT_LINE('Inner Loop');
      DBMS_OUTPUT.PUT_LINE('j = '||j);
      DBMS_OUTPUT.PUT_LINE('i = '||i);
      DBMS_OUTPUT.PUT_LINE('v_test = '||v_test);
    END LOOP inner_loop;
  END LOOP outer_loop;
END;


/*
Next, consider a modified version of the script that uses simple and WHILE loops. Changes are
shown in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  i      INTEGER := 1;
  j      INTEGER := 1;
  v_test NUMBER  := 0;
BEGIN
  <<outer_loop>>
  LOOP
    DBMS_OUTPUT.PUT_LINE ('Outer Loop');
    DBMS_OUTPUT.PUT_LINE ('i = '||i);
    DBMS_OUTPUT.PUT_LINE ('v_test = '||v_test);
    v_test := v_test + 1;
    -- reset inner loop counter
    j := 1;
    <<inner_loop>>
    WHILE j <= 2
    LOOP
      DBMS_OUTPUT.PUT_LINE ('Inner Loop');
      DBMS_OUTPUT.PUT_LINE ('j = '||j);
      DBMS_OUTPUT.PUT_LINE ('i = '||i);
      DBMS_OUTPUT.PUT_LINE ('v_test = '||v_test);
      j := j + 1;
    END LOOP inner_loop;
    i := i + 1;
    -- EXIT condition of the outer loop
    EXIT WHEN i > 3;
  END LOOP outer_loop;
END;


/*
Note that this version of the script contains changes that are important due to the nature of the
loops that are used.
First, both counters, for outer and inner loops, must be declared and initialized.Moreover, the
counter for the inner loop must be initialized to 1 before the inner loop is executed, not in the
declaration section of this script. In other words, the inner loop executes three times. It is important
not to confuse the phrase execution of the loop with the term iteration. Each execution of the
WHILE loop causes the statements inside this loop to iterate twice. Before each execution, the loop
counter j must be reset to 1 again.This step is necessary because the WHILE loop does not initialize
its counter implicitly like a numeric FOR loop. As a result, after the first execution of the WHILE
loop is complete, the value of counter j is equal to 3. If this value is not reset to 1 again, the loop
does not execute a second time.
Second, both loop counters must be incremented.Third, the EXIT condition must be specified for
the outer loop, and the test condition must be specified for the inner loop.
When run, the exercise produces the following output:
Outer Loop
i = 1
v_test = 0
Inner Loop
j = 1
i = 1
v_test = 1
Inner Loop
j = 2
i = 1
v_test = 1
Outer Loop
i = 2
v_test = 1
Inner Loop
j = 1
i = 2
v_test = 2
Inner Loop
j = 2
i = 2
v_test = 2
Outer Loop
i = 3
v_test = 2
Inner Loop
j = 1
i = 3
v_test = 3
Inner Loop
j = 2
i = 3
V_TEST = 3
PL/SQL procedure successfully completed.

*/




