--MODULE 6 TRY IT YOURSELF
--------------------------


--Chapter 6,“Iterative Control: Part I”

/*
1) Rewrite script ch06_1a.sql using a WHILE loop instead of a simple loop.Make sure that the output
produced by this script does not differ from the output produced by the script ch06_1a.sql.

ANSWER: Consider script ch06_1a.sql:
*/

SET SERVEROUTPUT ON
DECLARE
  v_counter BINARY_INTEGER := 0;
BEGIN
  LOOP
    -- increment loop counter by one
    v_counter := v_counter + 1;
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    -- if EXIT condition yields TRUE exit the loop
    IF v_counter = 5 THEN
      EXIT;
    END IF;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;


/*
Next, consider a new version of the script that uses a WHILE loop. Changes are shown in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  v_counter BINARY_INTEGER := 0;
BEGIN
  WHILE v_counter < 5
  LOOP
    -- increment loop counter by one
    v_counter := v_counter + 1;
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE('Done...');
END;


/*
In this version of the script, you replace a simple loop with a WHILE loop. It is important to remember
that a simple loop executes at least once because the EXIT condition is placed in the body of
the loop. On the other hand, a WHILE loop may not execute at all, because a condition is tested
outside the body of the loop. So, to achieve the same results using the WHILE loop, the EXIT
condition
v_counter = 5
used in the original version is replaced by the test condition
v_counter < 5
When run, this example produces the following output:
v_counter = 1
v_counter = 2
v_counter = 3
v_counter = 4
v_counter = 5
Done...
PL/SQL procedure successfully completed.
*/


/*
2) Rewrite script ch06_3a.sql using a numeric FOR loop instead of a WHILE loop.Make sure that
the output produced by this script does not differ from the output produced by the script
ch06_3a.sql.

ANSWER: Consider script ch06_3a.sql:
*/


SET SERVEROUTPUT ON
DECLARE
  v_counter BINARY_INTEGER := 1;
  v_sum NUMBER             := 0;
BEGIN
  WHILE v_counter <= 10
  LOOP
    v_sum := v_sum + v_counter;
    DBMS_OUTPUT.PUT_LINE ('Current sum is: '||v_sum);
    -- increment loop counter by one
    v_counter := v_counter + 1;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('The sum of integers between 1 '|| 'and 10 is: '||v_sum);
END;

/*
Next, consider a new version of the script that uses a WHILE loop. Changes are shown in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  v_sum NUMBER := 0;
BEGIN
  FOR v_counter IN 1..10
  LOOP
    v_sum := v_sum + v_counter;
    DBMS_OUTPUT.PUT_LINE ('Current sum is: '||v_sum);
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('The sum of integers between 1 '|| 'and 10 is: '||v_sum);
END;

/*
In this version of the script, you replace a WHILE loop with a numeric FOR loop. As a result, there is
no need to declare the variable v_counter and increment it by 1, because the loop itself
handles these steps implicitly.
When run, this version of the script produces output identical to the output produced by the
original version:
Current sum is: 1
Current sum is: 3
Current sum is: 6
Current sum is: 10
Current sum is: 15
Current sum is: 21
Current sum is: 28
Current sum is: 36
Current sum is: 45
Current sum is: 55
The sum of integers between 1 and 10 is: 55
PL/SQL procedure successfully completed.
*/

/*
3) Rewrite script ch06_4a.sql using a simple loop instead of a numeric FOR loop.Make sure that the
output produced by this script does not differ from the output produced by the script
ch06_4a.sql.

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
Next, consider a new version of the script that uses a simple loop. Changes are shown in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  v_counter   NUMBER := 1;
  v_factorial NUMBER := 1;
BEGIN
  LOOP
    v_factorial := v_factorial * v_counter;
    v_counter   := v_counter   + 1;
    EXIT
  WHEN v_counter = 10;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Factorial of ten is: '||v_factorial);
END;


/*
In this version of the script, you replace a numeric FOR loop with a simple loop. As a result, you
should make three important changes. First, you need to declare and initialize the loop counter,
v_counter.This counter is implicitly defined and initialized by the FOR loop. Second, you need
to increment the value of the loop counter.This is very important, because if you forget to include
the statement
v_counter := v_counter + 1;
in the body of the simple loop, you end up with an infinite loop.This step is not necessary when
you use a numeric FOR loop, because it is done by the loop itself.
Third, you need to specify the EXIT condition for the simple loop. Because you are computing a
factorial of 10, the following EXIT condition is specified:
EXIT WHEN v_counter = 10;
You could specify this EXIT condition using an IF-THEN statement as well:
IF v_counter = 10 THEN
EXIT;
END IF;
When run, this example shows the following output:
FACTORIAL OF TEN IS: 362880
PL/SQL procedure successfully completed.
*/



