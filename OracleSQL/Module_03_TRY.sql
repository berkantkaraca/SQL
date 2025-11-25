--MODULE 3 TRY IT YOURSELF
---------------------------


--Chapter 3,“SQL in PL/SQL”

/*1) Create a table called CHAP4 with two columns; one is ID (a number) and the other is NAME, which
is a VARCHAR2(20).

ANSWER: The answer should look similar to the following:
PROMPT Creating Table 'CHAP4'
*/
CREATE TABLE chap4
(id NUMBER,
name VARCHAR2(20));


/*2) Create a sequence called CHAP4_SEQ that increments by units of 5.

ANSWER: The answer should look similar to the following:
PROMPT Creating Sequence 'CHAP4_SEQ'
*/
CREATE SEQUENCE chap4_seq
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


/*3) Write a PL/SQL block that does the following, in this order:
A) Declares two variables: one for the v_name and one for v_id.The v_name variable can
be used throughout the block to hold the name that will be inserted. Realize that the value
will change in the course of the block.
B) The block inserts into the table the name of the student who is enrolled in the most classes
and uses a sequence for the ID. Afterward there is SAVEPOINT A.
C) The student with the fewest classes is inserted. Afterward there is SAVEPOINT B.
D) The instructor who is teaching the most courses is inserted in the same way. Afterward
there is SAVEPOINT C.
E) Using a SELECT INTO statement, hold the value of the instructor in the variable v_id.
F) Undo the instructor insertion by using rollback.
G) Insert the instructor teaching the fewest courses, but do not use the sequence to generate
the ID. Instead, use the value from the first instructor, whom you have since undone.
H) Insert the instructor teaching the most courses, and use the sequence to populate his or
her ID.
Add DBMS_OUTPUT throughout the block to display the values of the variables as they change.
(This is a good practice for debugging.)


ANSWER: The script should look similar to the following:
*/
DECLARE
  v_name student.last_name%TYPE;
  v_id student.student_id%TYPE;
BEGIN
  BEGIN
    -- A second block is used to capture the possibility of
    -- multiple students meeting this requirement.
    -- The exception section handles this situation.
    SELECT s.last_name
    INTO v_name
    FROM student s,
      enrollment e
    WHERE s.student_id = e.student_id
    HAVING COUNT(       *)    =
      (SELECT MAX(COUNT(*))
      FROM student s,
        enrollment e
      WHERE s.student_id = e.student_id
      GROUP BY s.student_id
      )
    GROUP BY s.last_name;
  EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    v_name := 'Multiple Names';
  END;
  INSERT INTO CHAP4 VALUES
    (CHAP4_SEQ.NEXTVAL, v_name
    );
  SAVEPOINT A;
  BEGIN
    SELECT s.last_name
    INTO v_name
    FROM student s,
      enrollment e
    WHERE s.student_id = e.student_id
    HAVING COUNT(       *)    =
      (SELECT MIN(COUNT(*))
      FROM student s,
        enrollment e
      WHERE s.student_id = e.student_id
      GROUP BY s.student_id
      )
    GROUP BY s.last_name;
  EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    v_name := 'Multiple Names';
  END;
  INSERT INTO CHAP4 VALUES
    (CHAP4_SEQ.NEXTVAL, v_name
    );
  SAVEPOINT B;
  BEGIN
    SELECT i.last_name
    INTO v_name
    FROM instructor i,
      section s
    WHERE s.instructor_id = i.instructor_id
    HAVING COUNT(       *)       =
      (SELECT MAX(COUNT(*))
      FROM instructor i,
        section s
      WHERE s.instructor_id = i.instructor_id
      GROUP BY i.instructor_id
      )
    GROUP BY i.last_name;
  EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    v_name := 'Multiple Names';
  END;
  SAVEPOINT C;
  BEGIN
    SELECT instructor_id INTO v_id FROM instructor WHERE last_name = v_name;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    v_id := 999;
  END;
  INSERT INTO CHAP4 VALUES
    (v_id, v_name
    );
  ROLLBACK TO SAVEPOINT B;
  BEGIN
    SELECT i.last_name
    INTO v_name
    FROM instructor i,
      section s
    WHERE s.instructor_id = i.instructor_id
    HAVING COUNT(       *)       =
      (SELECT MIN(COUNT(*))
      FROM instructor i,
        section s
      WHERE s.instructor_id = i.instructor_id
      GROUP BY i.instructor_id
      )
    GROUP BY i.last_name;
  EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    v_name := 'Multiple Names';
  END;
  INSERT INTO CHAP4 VALUES
    (v_id, v_name
    );
  BEGIN
    SELECT i.last_name
    INTO v_name
    FROM instructor i,
      section s
    WHERE s.instructor_id = i.instructor_id
    HAVING COUNT(       *)       =
      (SELECT MAX(COUNT(*))
      FROM instructor i,
        section s
      WHERE s.instructor_id = i.instructor_id
      GROUP BY i.instructor_id
      )
    GROUP BY i.last_name;
  EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    v_name := 'Multiple Names';
  END;
  INSERT INTO CHAP4 VALUES
    (CHAP4_SEQ.NEXTVAL, V_NAME
    );
END;








