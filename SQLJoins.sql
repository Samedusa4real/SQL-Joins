CREATE DATABASE AcademyTask

USE AcademyTask

CREATE TABLE Groups
(
	Id INT PRIMARY KEY IDENTITY,
	No NVARCHAR NOT NULL
)

ALTER TABLE Groups
ALTER COLUMN No NVARCHAR(25)


CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY,
	FullName NVARCHAR NOT NULL,
	Point INT NOT NULL,
	GroupId INT FOREIGN KEY REFERENCES Groups(Id)
)

ALTER TABLE Students
ALTER COLUMN FullName NVARCHAR(25)

ALTER TABLE Students
ADD CONSTRAINT Point CHECK(Point<=100)

CREATE TABLE Exams
(
	Id INT PRIMARY KEY IDENTITY,
	SubjectName NVARCHAR NOT NULL,
	StartDate DATETIME2 NOT NULL,
	EndDate DATETIME2 NOT NULL
)

ALTER TABLE Exams
ALTER COLUMN SubjectName NVARCHAR(25)

CREATE TABLE StudentExams
(
	StudentId INT FOREIGN KEY REFERENCES Students(Id),
	ExamId INT FOREIGN KEY REFERENCES Exams(Id),
	ResultPoint INT NOT NULL
)

ALTER TABLE StudentExams
ADD CONSTRAINT ResultPoint CHECK(ResultPoint <= 100)

INSERT INTO Groups(No)
VALUES
('P328'),
('D201'),
('P313'),
('M505'),
('D120'),
('U018')

DBCC CHECKIDENT('Groups', RESEED, 0)

DELETE FROM Groups

INSERT INTO Students(FullName,Point,GroupId)
VALUES
('Samedusa', 20, 1),
('Elfru', 31, 3),
('Rahid Mirkazim', 65, 2),
('Rza Mirze', 95, 5),
('Hikmet Rza', 70, 4),
('Semed Vurgun', 72, 1),
('Rovsen Lenkeran', 69, 6),
('Quli Ceqa', 29, 2),
('Abbassehhet Resad', 19, 1),
('Pasyolka Samir', 100, 3)

DBCC CHECKIDENT('Students', RESEED, 0)

INSERT INTO Exams(SubjectName,StartDate,EndDate)
VALUES
('Optimallasdirma','2023-06-23','2023-07-01'),
('Mulki Mudafie','2023-06-08', '2023-07-10'),
('Suni Intellekt','2023-06-19', '2023-07-10'),
('Riyazi Modellesdirme','2023-06-14', '2023-07-01'),
('Qerar qebul etme usullari','2023-06-02', '2023-07-01')


INSERT INTO StudentExams
VALUES
(1,1,74),
(1,2,82),
(1,5,90),
(2,1,94),
(2,2,61),
(3,4,62),
(3,3,67),
(4,1,45),
(5,1,87),
(5,2,78),
(5,5,45),
(6,2,96),
(6,4,62),
(6,5,65),
(7,2,34),
(7,3,65),
(8,1,45),
(9,5,23),
(10,2,84),
(10,3,74),
(10,4,72)

SELECT * FROM Students AS S
JOIN Groups AS G ON S.GroupId = G.Id



SELECT *, (SELECT COUNT(StudentId) FROM StudentExams WHERE S.Id = SE.StudentId) AS 'ExamCount' FROM Students AS S
JOIN StudentExams AS SE ON S.Id = SE.StudentId

SELECT S.Id, S.FullName, COUNT(SE.ExamId) AS 'ExamCount'
FROM Students AS S
JOIN StudentExams AS SE ON S.Id = SE.StudentId
GROUP BY S.Id, S.FullName



SELECT SubjectName FROM Exams AS E
LEFT JOIN StudentExams AS SE ON E.Id = SE.ExamId
WHERE COUNT(SE.ExamId) = 0

SELECT SubjectName FROM Exams AS E
LEFT JOIN StudentExams AS SE ON E.Id = SE.ExamId
WHERE SE.ExamId IS NULL



SELECT SubjectName, StartDate, COUNT(S.Id) AS 'NumberOfStudents'
FROM Exams AS E
JOIN StudentExams AS SE ON E.Id = SE.ExamId
JOIN Students AS S ON SE.StudentId = S.Id
WHERE StartDate = DATEADD(day, -1, GETDATE())
GROUP BY E.SubjectName, E.StartDate



SELECT SE.*, S.FullName, G.No FROM StudentExams AS SE
JOIN Students AS S ON S.Id = SE.StudentId
JOIN Groups AS G ON G.Id = S.GroupId


SELECT FullName, AVG(ResultPoint) AS 'AvaragePoint' FROM Students AS S
JOIN StudentExams AS SE ON SE.StudentId = S.Id
GROUP BY FullName

SELECT FullName, 
    (SELECT AVG(ResultPoint)
     FROM StudentExams
     WHERE StudentExams.StudentId = Students.Id) AS 'AvaragePoint'
FROM Students