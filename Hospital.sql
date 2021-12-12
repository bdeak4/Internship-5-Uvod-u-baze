CREATE DATABASE Hospital

USE Hospital

-- schema -------------------------------------------------------------

CREATE TABLE Rooms (
	Id nvarchar(4) PRIMARY KEY
)

CREATE TABLE OperatingRooms (
	Id nvarchar(4) PRIMARY KEY
)

CREATE TABLE Patients (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	HomeAddress nvarchar(50) NOT NULL,
	OIB nvarchar(11) UNIQUE NOT NULL,
	RoomId nvarchar(4) FOREIGN KEY REFERENCES Rooms(Id) NOT NULL
)

CREATE TABLE Nurses (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	OIB nvarchar(11) UNIQUE NOT NULL,
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	HomeAddress nvarchar(50) NOT NULL,
	EmailAddress nvarchar(50) UNIQUE NOT NULL,
	PhoneNumber nvarchar(50) UNIQUE NOT NULL,
	RoomId nvarchar(4) FOREIGN KEY REFERENCES Rooms(Id),
	OperatingRoomId nvarchar(4) FOREIGN KEY REFERENCES OperatingRooms(Id)
)

CREATE TABLE SurgeonSpecialties (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	Title nvarchar(150) NOT NULL
)

CREATE TABLE Places (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	Title nvarchar(150) NOT NULL
)

CREATE TABLE Surgeons (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	OIB nvarchar(11) UNIQUE NOT NULL,
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	HomeAddress nvarchar(50) NOT NULL,
	EmailAddress nvarchar(50) UNIQUE NOT NULL,
	PhoneNumber nvarchar(50) UNIQUE NOT NULL,
	SurgeonSpecialtyId int FOREIGN KEY REFERENCES SurgeonSpecialties(Id) NOT NULL,
	PlaceOfBirth int FOREIGN KEY REFERENCES Places(Id) NOT NULL
)

CREATE TABLE OperationTypes (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	Description nvarchar(150) NOT NULL
)

CREATE TABLE Operations (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	OperatingRoomId nvarchar(4) FOREIGN KEY REFERENCES OperatingRooms(Id) NOT NULL,
	OperationTypeId int FOREIGN KEY REFERENCES OperationTypes(Id) NOT NULL,
	PatientId int FOREIGN KEY REFERENCES Patients(Id) NOT NULL,
	SurgeonId int FOREIGN KEY REFERENCES Surgeons(Id) NOT NULL,
	DateAndTime datetime2 DEFAULT GETDATE(),
	PlaceId int FOREIGN KEY REFERENCES Places(Id) NOT NULL
)

-- seed ---------------------------------------------------------------

INSERT INTO Rooms (Id) VALUES
('A100'),
('A102'),
('C502')

INSERT INTO OperatingRooms (Id) VALUES
('O104'),
('O301'),
('O402')

INSERT INTO Patients (FirstName, LastName, HomeAddress, OIB, RoomId) VALUES
('Ante',   'Antic',  'Ante Starcevica 12',  '59922301982', 'A100'),
('Ana',    'Anic',   'Marka Marulica 102',  '15945174455', 'A100'),
('Marko',  'Markic', 'Stjepana Radica 49',  '38267061609', 'A100'),
('Marica', 'Maric',  'Ivana Mazuranica 28', '31963106797', 'C502')

INSERT INTO Nurses (FirstName, LastName, HomeAddress, OIB, EmailAddress, PhoneNumber, RoomId, OperatingRoomId) VALUES
('Ivana',  'Ivancic', 'Ante Starcevica 61',  '08879487241', 'iivancic@gmail.com', '0991234567', 'A100', NULL),
('Sanja',  'Sanjic',  'Marka Marulica 2',    '26203621754', 'ssanjic@gmail.com',  '0981234562', NULL,   'O104'),
('Marica', 'Maric',   'Ivana Mazuranica 28', '30926315347', 'mmaric@gmail.com',   '0951234561', 'C502', 'O402')

INSERT INTO SurgeonSpecialties (Title) VALUES
('Traumatologija'),
('Neurokirurgija')

INSERT INTO Places (Title) VALUES
('Split'),
('Zagreb')

INSERT INTO Surgeons (FirstName, LastName, HomeAddress, OIB, EmailAddress, PhoneNumber, SurgeonSpecialtyId, PlaceOfBirth) VALUES
('Ivan', 'Ivancic', 'Ante Starcevica 82', '93549648445', 'iivancic02@gmail.com', '0991234565', 1, 1),
('Mate', 'Matic',   'Marka Marulica 29',  '49240059499', 'mmatic@gmail.com',     '0981234564', 2, 2),
('Ante', 'Antic',   'Stjepana Radica 90', '01372373813', 'aantic@gmail.com',     '0981234566', 2, 1)

INSERT INTO OperationTypes (Description) VALUES
('Operacija popravka koljena'),
('Operacija popravka lakta'),
('Operacija popravka mozga')

INSERT INTO Operations (OperatingRoomId, OperationTypeId, PatientId, SurgeonId, DateAndTime, PlaceId) VALUES
('O301', 3, 1, 2, '2021-12-11 17:00:00', 2),
('O104', 1, 2, 1, '2021-12-11 18:00:00', 1),
('O402', 3, 3, 3, '2021-12-12 17:00:00', 1),
('O301', 2, 4, 1, '2021-12-12 18:00:00', 1),
('O301', 1, 2, 1, '2021-12-13 09:00:00', 1)

-- queries -------------------------------------------------------------

SELECT *
FROM Operations
WHERE DateAndTime LIKE '2021-12-12%'
ORDER BY DateAndTime

SELECT FirstName, LastName
FROM Surgeons
WHERE PlaceOfBirth IN (
	SELECT Id
	FROM Places
	WHERE Title != 'Split'
)

-- soba 4 = C502
--SELECT * FROM Nurses WHERE RoomId IN ('C502', 'A102')
UPDATE Nurses
SET RoomId = 'A102'
WHERE RoomId = 'C502'
--SELECT * FROM Nurses WHERE RoomId IN ('C502', 'A102')

-- soba 7 = A100
SELECT Id, OIB, FirstName, LastName
FROM Patients
WHERE RoomId = 'A100'
ORDER BY LastName DESC

SELECT *
FROM Operations
WHERE DateAndTime LIKE (CAST(CAST(GETDATE() AS date) AS varchar) + '%')