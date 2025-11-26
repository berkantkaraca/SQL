--MODULE 7
----------


--Iterative Control: Part II
-----------------------------


--The CONTINUE Statement

--Şart olmadan CONTINUE kullanıldığından EXIT çalışmaz
DECLARE
  v_counter NUMBER := 0;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
    CONTINUE;
    v_counter := v_counter + 1;
    EXIT
  WHEN v_counter = 5;
  END LOOP;
END;



--7.1.1 Use the CONTINUE Statement

-- ch07_1a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_counter BINARY_INTEGER := 0;
BEGIN
  LOOP
    -- increment loop counter by one
    v_counter := v_counter + 1;
    DBMS_OUTPUT.PUT_LINE ('before continue condition, v_counter = '|| v_counter);
    -- if CONTINUE condition yields TRUE pass control to the
    -- first executable statement of the loop
    IF v_counter < 3 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE ('after continue condition, v_counter = '|| v_counter);
    -- if EXIT condition yields TRUE exit the loop
    IF v_counter = 5 THEN
      EXIT;
    END IF;
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;



/*
B) Explain the output produced by the script.


C) How many times does the loop execute?      5


D) Explain how each iteration of the loop is affected if the CONTINUE condition is changed to
I) v_counter = 3
II) v_counter > 3.     Sonsuz d�ng�


E) How would you modify the script so that the CONTINUE condition v_counter > 3 does not
cause an infinite loop?
*/


-- ch07_1c.sql, version 3.0
SET SERVEROUTPUT ON
DECLARE
  v_counter BINARY_INTEGER := 0;
BEGIN
  LOOP
    -- increment loop counter by one
    v_counter := v_counter + 1;
    DBMS_OUTPUT.PUT_LINE ('before continue condition, v_counter = '|| v_counter);
    -- if EXIT condition yields TRUE exit the loop
    IF v_counter = 5 THEN
      EXIT;
    END IF;
    -- if CONTINUE condition yields TRUE pass control to the
    -- first executable statement of the loop
    IF v_counter > 3 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE ('after continue condition, v_counter = '|| v_counter);
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Done...');
END;


/*
F) Rewrite the first version of the script using the CONTINUE WHEN condition instead of the
CONTINUE condition so that it produces the same result.

CONTINUE WHEN v_counter < 3;

*/



--7.1.2 Use the CONTINUE WHEN Condition

--1 ile 10 aras?ndaki �ift say?lar?n toplam?n? CONTINUE WHEN ile bulun

-- ch07_2a.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
  v_sum NUMBER := 0;
BEGIN
  FOR v_counter IN 1..10
  LOOP
    -- if v_counter is odd, pass control to the top of the loop
    CONTINUE WHEN mod(v_counter, 2) != 0;
    v_sum                := v_sum + v_counter;
    DBMS_OUTPUT.PUT_LINE ('Current sum is: '||v_sum);
  END LOOP;
  -- control resumes here
  DBMS_OUTPUT.PUT_LINE ('Final sum is: '||V_SUM);
END;



/*
B) How many times did the loop execute?       10


C) How many iterations of the loop were partial iterations?       5


D) How would you change the script to calculate the sum of odd integers between 1 and 10?

CONTINUE WHEN mod(v_counter, 2) = 0;
*/

----------------------------------------------------------------------------------------------


--Nested Loops

--Simple loop ve WHILE loop i� i�e kullan?m?
DECLARE
  v_counter1 INTEGER := 0;
  v_counter2 INTEGER;
BEGIN
  WHILE v_counter1 < 3
  LOOP
    DBMS_OUTPUT.PUT_LINE ('v_counter1: '||v_counter1);
    v_counter2 := 0;
    LOOP
      DBMS_OUTPUT.PUT_LINE ('v_counter2: '||v_counter2);
      V_COUNTER2 := V_COUNTER2 + 1;
      EXIT WHEN v_counter2 >= 2;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('--------------------');
    v_counter1 := v_counter1 + 1;
  END LOOP;
END;

-- 1den 100e kadar çift sayı toplamını yap
DECLARE
  v_toplam NUMBER := 0;
BEGIN
  FOR v_counter IN 1..100
  LOOP
    if MOD(v_counter, 2) <> 0 then
     continue; 
    end if;
     v_toplam   := v_counter + v_toplam;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE ('v_toplam = '||v_toplam);
END;


--LOOP LABELS

BEGIN
  <<outer_loop>>
  FOR i IN 1..3
  LOOP
    DBMS_OUTPUT.PUT_LINE ('i = '||i);
    <<inner_loop>>
    FOR j IN 1..2
    LOOP
      DBMS_OUTPUT.PUT_LINE ('j = '||j);
    END LOOP inner_loop;
  END LOOP OUTER_LOOP;
END;

--label

BEGIN
  <<OUTER>>
  FOR v_counter IN 1..3
  LOOP
    <<INNER>>
    FOR v_counter IN 1..2
    LOOP
      DBMS_OUTPUT.PUT_LINE ('outer.v_counter '||outer.v_counter);
      DBMS_OUTPUT.PUT_LINE ('inner.v_counter '||inner.v_counter);
    END LOOP INNER;
  END LOOP OUTER;
END;



--7.2.1 Use Nested Loops

--FOR i�inde FOR
-- ch07_3a.sql, version 1.0
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
  END LOOP OUTER_LOOP;
END;



/*
B) How many times did the outer loop execute?     3


C) How many times did the inner loop execute?     6


D) What are the values of the loop counters, i and j, after both loops terminate?

ANSWER: After both loops terminate, both loop counters are undefined again and can hold no
values. As mentioned earlier, the loop counter ceases to exist as soon as the numeric FOR loop is
terminated.


E) Rewrite this script using the REVERSE option for both loops.How many times is each loop
executed in this case?

Inner 6 kez outer 3 kez
*/







