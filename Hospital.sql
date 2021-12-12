CREATE DATABASE Hospital

USE Hospital

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

CREATE TABLE Surgeons (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	OIB nvarchar(11) UNIQUE NOT NULL,
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	HomeAddress nvarchar(50) NOT NULL,
	EmailAddress nvarchar(50) UNIQUE NOT NULL,
	PhoneNumber nvarchar(50) UNIQUE NOT NULL,
	SurgeonSpecialtyId int FOREIGN KEY REFERENCES SurgeonSpecialties(Id)
)

CREATE TABLE OperationTypes (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	Description nvarchar(150) NOT NULL
)

CREATE TABLE Places (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	Title nvarchar(150) NOT NULL
)

CREATE TABLE Operations (
	Id int IDENTITY(1, 1) PRIMARY KEY,
	OperatingRoomId nvarchar(4) FOREIGN KEY REFERENCES OperatingRooms(Id),
	OperationTypeId int FOREIGN KEY REFERENCES OperationTypes(Id),
	PatientId int FOREIGN KEY REFERENCES Patients(Id),
	SurgeonId int FOREIGN KEY REFERENCES Surgeons(Id),
	DateAndTime datetime2 DEFAULT GETDATE(),
	PlaceId int FOREIGN KEY REFERENCES Places(Id)
)
