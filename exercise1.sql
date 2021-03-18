DROP TABLE professors;
DROP TABLE students;
DROP TABLE grades;
DROP TABLE courses; 

CREATE TABLE professors (
  id SERIAL PRIMARY KEY ,
  name TEXT NOT NULL
);

CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE courses (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  professorid INTEGER NOT NULL,
  CONSTRAINT fk_professor
      FOREIGN KEY(professorid) 
	  REFERENCES professors(id)
);

CREATE TABLE grades (
  studentid INTEGER NOT NULL,
  courseid INTEGER NOT NULL,
  grade INTEGER NOT NULL,
  CONSTRAINT fk_student
      FOREIGN KEY(studentid) 
	  REFERENCES students(id),
  CONSTRAINT fk_course
      FOREIGN KEY(courseid) 
	  REFERENCES courses(id)
);


INSERT INTO professors (name)
VALUES ('Professor 1');
INSERT INTO professors (name)
VALUES ('Professor 2');
INSERT INTO professors (name)
VALUES ('Professor 3');

SELECT * 
FROM professors;



INSERT INTO students (name)
VALUES ('Student 1');
INSERT INTO students (name)
VALUES ('Student 2');
INSERT INTO students (name)
VALUES ('Student 3');
INSERT INTO students (name)
VALUES ('Student 4');
INSERT INTO students (name)
VALUES ('Student 5');
INSERT INTO students (name)
VALUES ('Student 6');

SELECT * 
FROM students;



INSERT INTO courses (name, professorid)
VALUES ('Course 1',1);
INSERT INTO courses (name, professorid)
VALUES ('Course 2',3);
INSERT INTO courses (name, professorid)
VALUES ('Course 3',2);
INSERT INTO courses (name, professorid)
VALUES ('Course 4',1);

SELECT * 
FROM courses;



INSERT INTO grades (studentid,courseid,grade)
VALUES (1,1,5);
INSERT INTO grades (studentid,courseid,grade)
VALUES (1,4,4);
INSERT INTO grades (studentid,courseid,grade)
VALUES (2,1,5);
INSERT INTO grades (studentid,courseid,grade)
VALUES (6,1,3);
INSERT INTO grades (studentid,courseid,grade)
VALUES (4,2,1);
INSERT INTO grades (studentid,courseid,grade)
VALUES (5,3,2);
INSERT INTO grades (studentid,courseid,grade)
VALUES (2,3,4);
INSERT INTO grades (studentid,courseid,grade)
VALUES (6,4,1);
INSERT INTO grades (studentid,courseid,grade)
VALUES (4,4,5);
INSERT INTO grades (studentid,courseid,grade)
VALUES (3,1,4);
INSERT INTO grades (studentid,courseid,grade)
VALUES (2,4,3);
INSERT INTO grades (studentid,courseid,grade)
VALUES (3,2,5);
INSERT INTO grades (studentid,courseid,grade)
VALUES (5,1,4);
INSERT INTO grades (studentid,courseid,grade)
VALUES (1,3,5);

SELECT * 
FROM grades;


--average grade per course
SELECT courses.name AS "Course Name", AVG(grade) AS "Average Grade"
FROM grades INNER JOIN courses ON courses.id = grades.courseid
GROUP BY courses.name;


--highest grade and course for each student
SELECT students.name AS "Student Name", courses.name AS "Course Name", t.grade AS "Highest Grade"
FROM(SELECT studentid, MAX(grade) AS grade
	 FROM grades
	 GROUP BY studentid) t
INNER JOIN grades ON t.studentid = grades.studentid
					AND t.grade = grades.grade
INNER JOIN students ON students.id = t.studentid
INNER JOIN courses ON courses.id = grades.courseid
ORDER BY "Student Name", "Course Name";


--to 10 students which get the highest grade for each course
--I have selected course name and grade for testing and I have limited to 3 (not 10)
WITH onlyids AS(
SELECT studentid, courseid, grade, ROW_NUMBER () OVER ( 
										PARTITION BY courseid 
										ORDER BY grade DESC) AS ord
FROM grades
)

SELECT courses.name AS "Course Name", students.name AS "Student Name", grade AS "Highest Grade"
FROM onlyids 
INNER JOIN students ON students.id = onlyids.studentid
INNER JOIN courses ON courses.id = onlyids.courseid
WHERE ord < 4;