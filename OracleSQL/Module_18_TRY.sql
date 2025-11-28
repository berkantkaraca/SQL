--MODULE 18 TRY IT YOURSELF
----------------------------


--Chapter 18,“Bulk SQL”

/*
Before beginning these exercises, create the MY_SECTION table based on the SECTION table.This table
should be created empty.
The MY_SECTION table can be created as follows:
*/

CREATE TABLE my_section AS
SELECT *
FROM section
WHERE 1 = 2;

/*
1) Create the following script: Populate the MY_SECTION table using the FORALL statement with the
SAVE EXCEPTIONS clause. After MY_SECTION is populated, display how many records were
inserted.

ANSWER: The script should look similar to the following:
*/

SET SERVEROUTPUT ON
DECLARE
  -- Declare collection types
TYPE number_type
IS
  TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE string_type
IS
  TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
TYPE date_type
IS
  TABLE OF DATE INDEX BY PLS_INTEGER;
  -- Declare collection variables to be used by the FORALL statement
  section_id_tab number_type;
  course_no_tab number_type;
  section_no_tab number_type;
  start_date_time_tab date_type;
  location_tab string_type;
  instructor_id_tab number_type;
  capacity_tab number_type;
  cr_by_tab string_type;
  cr_date_tab date_type;
  mod_by_tab string_type;
  mod_date_tab date_type;
  v_counter PLS_INTEGER := 0;
  v_total INTEGER       := 0;
  -- Define user-defined exception and associated Oracle
  -- error number with it
  errors EXCEPTION;
  PRAGMA EXCEPTION_INIT(errors, -24381);
BEGIN
  -- Populate individual collections
  FOR rec IN
  (SELECT * FROM section
  )
  LOOP
    v_counter                      := v_counter + 1;
    section_id_tab(v_counter)      := rec.section_id;
    course_no_tab(v_counter)       := rec.course_no;
    section_no_tab(v_counter)      := rec.section_no;
    start_date_time_tab(v_counter) := rec.start_date_time;
    location_tab(v_counter)        := rec.location;
    instructor_id_tab(v_counter)   := rec.instructor_id;
    capacity_tab(v_counter)        := rec.capacity;
    cr_by_tab(v_counter)           := rec.created_by;
    cr_date_tab(v_counter)         := rec.created_date;
    mod_by_tab(v_counter)          := rec.modified_by;
    mod_date_tab(v_counter)        := rec.modified_date;
  END LOOP;
  -- Populate MY_SECTION table
  FORALL i IN 1..section_id_tab.COUNT SAVE EXCEPTIONS
  INSERT
  INTO my_section
    (
      section_id,
      course_no,
      section_no,
      start_date_time,
      location,
      instructor_id,
      capacity,
      created_by,
      created_date,
      modified_by,
      modified_date
    )
    VALUES
    (
      section_id_tab(i),
      course_no_tab(i),
      section_no_tab(i),
      start_date_time_tab(i),
      location_tab(i),
      instructor_id_tab(i),
      capacity_tab(i),
      cr_by_tab(i),
      cr_date_tab(i),
      mod_by_tab(i),
      mod_date_tab(i)
    );
  COMMIT;
  -- Check how many records were added to MY_SECTION table
  SELECT COUNT(*)
  INTO v_total
  FROM my_section;
  DBMS_OUTPUT.PUT_LINE (v_total||' records were added to MY_SECTION table');
EXCEPTION
WHEN errors THEN
  -- Display total number of exceptions encountered
  DBMS_OUTPUT.PUT_LINE ('There were '||SQL%BULK_EXCEPTIONS.COUNT||' exceptions');
  -- Display detailed exception information
  FOR i IN 1.. SQL%BULK_EXCEPTIONS.COUNT
  LOOP
    DBMS_OUTPUT.PUT_LINE ('Record '|| SQL%BULK_EXCEPTIONS(i).error_index||' caused error '||i|| ': '||SQL%BULK_EXCEPTIONS(i).ERROR_CODE||' '|| SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
  END LOOP;
  -- Commit records if any that were inserted successfully
  COMMIT;
END;


/*
This script populates the MY_SECTION table with records selected from the SECTION table.To
enable use of the FORALL statement, it employs 11 collections.Note that only three collection
types are associated with these collections.This is because the individual collections store only
three datatypes—NUMBER,VARCHAR2, and DATE.
The script uses a cursor FOR loop to populate the individual collections and then uses them with
the FORALL statement with the SAVE EXCEPTIONS option to populate the MY_SECTION table.To
enable the SAVE EXCEPTIONS options, this script declares a user-defined exception and associates
an Oracle error number with it.This script also contains an exception-handling section where a
user-defined exception is processed.This section displays how many exceptions were encountered
in the FORALL statement as well as detailed exception information. Note the COMMIT statement
in the exception-handling section.This statement is added so that records that are inserted
successfully by the FORALL statement are committed when control of the execution is passed to
the exception-handling section of the block.
When run, this script produces the following output:
78 records were added to MY_SECTION table
PL/SQL procedure successfully completed.




2) Modify the script you just created. In addition to displaying the total number of records inserted
in the MY_SECTION table, display how many records were inserted for each course.Use the BULK
COLLECT statement to accomplish this step.Note that you should delete all the rows from the
MY_SECTION table before executing this version of the script.

ANSWER: The new version of the script should look similar to the following. Changes are shown
in bold.
*/


SET SERVEROUTPUT ON
DECLARE
  -- Declare collection types
TYPE number_type
IS
  TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE string_type
IS
  TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
TYPE date_type
IS
  TABLE OF DATE INDEX BY PLS_INTEGER;
  -- Declare collection variables to be used by the FORALL statement
  section_id_tab number_type;
  course_no_tab number_type;
  section_no_tab number_type;
  start_date_time_tab date_type;
  location_tab string_type;
  instructor_id_tab number_type;
  capacity_tab number_type;
  cr_by_tab string_type;
  cr_date_tab date_type;
  mod_by_tab string_type;
  mod_date_tab date_type;
  total_recs_tab number_type;
  v_counter PLS_INTEGER := 0;
  v_total INTEGER       := 0;
  -- Define user-defined exception and associated Oracle
  -- error number with it
  errors EXCEPTION;
  PRAGMA EXCEPTION_INIT(errors, -24381);
BEGIN
  -- Populate individual collections
  FOR rec IN
  (SELECT * FROM section
  )
  LOOP
    v_counter                      := v_counter + 1;
    section_id_tab(v_counter)      := rec.section_id;
    course_no_tab(v_counter)       := rec.course_no;
    section_no_tab(v_counter)      := rec.section_no;
    start_date_time_tab(v_counter) := rec.start_date_time;
    location_tab(v_counter)        := rec.location;
    instructor_id_tab(v_counter)   := rec.instructor_id;
    capacity_tab(v_counter)        := rec.capacity;
    cr_by_tab(v_counter)           := rec.created_by;
    cr_date_tab(v_counter)         := rec.created_date;
    mod_by_tab(v_counter)          := rec.modified_by;
    mod_date_tab(v_counter)        := rec.modified_date;
  END LOOP;
  -- Populate MY_SECTION table
  FORALL i IN 1..section_id_tab.COUNT SAVE EXCEPTIONS
  INSERT
  INTO my_section
    (
      section_id,
      course_no,
      section_no,
      start_date_time,
      location,
      instructor_id,
      capacity,
      created_by,
      created_date,
      modified_by,
      modified_date
    )
    VALUES
    (
      section_id_tab(i),
      course_no_tab(i),
      section_no_tab(i),
      start_date_time_tab(i),
      location_tab(i),
      instructor_id_tab(i),
      capacity_tab(i),
      cr_by_tab(i),
      cr_date_tab(i),
      mod_by_tab(i),
      mod_date_tab(i)
    );
  COMMIT;
  -- Check how many records were added to MY_SECTION table
  SELECT COUNT(*)
  INTO v_total
  FROM my_section;
  DBMS_OUTPUT.PUT_LINE (v_total||' records were added to MY_SECTION table');
  -- Check how many records were inserted for each course
  -- and display this information
  -- Fetch data from MY_SECTION table via BULK COLLECT clause
  SELECT course_no,
    COUNT(*) BULK COLLECT
  INTO course_no_tab,
    total_recs_tab
  FROM my_section
  GROUP BY course_no;
  IF course_no_tab.COUNT > 0 THEN
    FOR i IN course_no_tab.FIRST..course_no_tab.LAST
    LOOP
      DBMS_OUTPUT.PUT_LINE ('course_no: '||course_no_tab(i)|| ', total sections: '||total_recs_tab(i));
    END LOOP;
  END IF;
EXCEPTION
WHEN errors THEN
  -- Display total number of exceptions encountered
  DBMS_OUTPUT.PUT_LINE ('There were '||SQL%BULK_EXCEPTIONS.COUNT||' exceptions');
  -- Display detailed exception information
  FOR i IN 1.. SQL%BULK_EXCEPTIONS.COUNT
  LOOP
    DBMS_OUTPUT.PUT_LINE ('Record '|| SQL%BULK_EXCEPTIONS(i).error_index||' caused error '||i|| ': '||SQL%BULK_EXCEPTIONS(i).ERROR_CODE||' '|| SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
  END LOOP;
  -- Commit records if any that were inserted successfully
  COMMIT;
END;


/*
In this version of the script, you define one more collection, total_recs_tab, in the declaration
portion of the PL/SQL block.This collection is used to store the total number of sections for
each course. In the executable portion of the PL/SQL block, you add a SELECT statement with a
BULK COLLECT clause that repopulates course_no_tab and initializes total_recs_tab.
Next, if the course_no_tab collection contains data, you display course numbers and the
total number of sections for each course on the screen.
When run, this version of the script produces the following output:
78 records were added to MY_SECTION table
course_no: 10, total sections: 1
course_no: 20, total sections: 4
course_no: 25, total sections: 9
course_no: 100, total sections: 5
course_no: 120, total sections: 6
course_no: 122, total sections: 5
course_no: 124, total sections: 4
course_no: 125, total sections: 5
course_no: 130, total sections: 4
course_no: 132, total sections: 2
course_no: 134, total sections: 3
course_no: 135, total sections: 4
course_no: 140, total sections: 3
course_no: 142, total sections: 3
course_no: 144, total sections: 1
course_no: 145, total sections: 2
course_no: 146, total sections: 2
course_no: 147, total sections: 1
course_no: 204, total sections: 1
course_no: 210, total sections: 1
course_no: 220, total sections: 1
course_no: 230, total sections: 2
course_no: 240, total sections: 2
course_no: 310, total sections: 1
course_no: 330, total sections: 1
course_no: 350, total sections: 3
course_no: 420, total sections: 1
course_no: 450, total sections: 1
PL/SQL procedure successfully completed.




3) Create the following script:Delete all the records from the MY_SECTION table, and display how
many records were deleted for each course as well as individual section IDs deleted for each
course.Use BULK COLLECT with the RETURNING option.

ANSWER: This script should look similar to the following:
*/


SET SERVEROUTPUT ON;
DECLARE
  -- Define collection types and variables to be used by the
  -- BULK COLLECT clause
TYPE section_id_type
IS
  TABLE OF my_section.section_id%TYPE;
  section_id_tab section_id_type;
BEGIN
  FOR rec IN
  (SELECT UNIQUE course_no FROM my_section
  )
  LOOP
    DELETE
    FROM MY_SECTION
    WHERE course_no = rec.course_no RETURNING section_id BULK COLLECT
    INTO section_id_tab;
    DBMS_OUTPUT.PUT_LINE ('Deleted '||SQL%ROWCOUNT|| ' rows for course '||rec.course_no);
    IF section_id_tab.COUNT > 0 THEN
      FOR i IN section_id_tab.FIRST..section_id_tab.LAST
      LOOP
        DBMS_OUTPUT.PUT_LINE ('section_id: '||section_id_tab(i));
      END LOOP;
      DBMS_OUTPUT.PUT_LINE ('===============================');
    END IF;
    COMMIT;
  END LOOP;
END;


/*
In this script you declare a single collection, section_id_tab.Note that there is no need to
declare a collection to store course numbers.This is because the records from the MY_SECTION
table are deleted for each course number instead of all at once.To accomplish this, you introduce
a cursor FOR loop that selects unique course numbers from the MY_SECTION table. Next, for each
course number, you DELETE records from the MY_SECTION table, returning the corresponding
section IDs and collecting them in section_id_tab.Next, you display how many records
were deleted for a given course number, along with individual section IDs for this course.
Note that even though the collection section_id_tab is repopulated for each iteration of
the cursor loop, there is no need to reinitialize it (in other words, empty it).This is because the
DELETE statement does this implicitly.
Consider the partial output produced by this script:
Deleted 1 rows for course 10
section_id: 80
===============================
Deleted 4 rows for course 20
section_id: 81
section_id: 82
section_id: 83
section_id: 84
===============================
Deleted 9 rows for course 25
section_id: 85
section_id: 86
section_id: 87
section_id: 88
section_id: 89
section_id: 90
section_id: 91
section_id: 92
section_id: 93
===============================
Deleted 5 rows for course 100
section_id: 141
section_id: 142
section_id: 143
section_id: 144
section_id: 145
===============================
Deleted 6 rows for course 120
section_id: 146
section_id: 147
section_id: 148
section_id: 149
section_id: 150
section_id: 151
===============================
Deleted 5 rows for course 122
section_id: 152
section_id: 153
section_id: 154
section_id: 155
section_id: 156
===============================
...
PL/SQL PROCEDURE SUCCESSFULLY COMPLETED.
*/


