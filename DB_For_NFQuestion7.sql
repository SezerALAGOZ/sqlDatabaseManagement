CREATE DATABASE DB_QUESTION7_SEZER_ALAGOZ

GO

USE DB_QUESTION7_SEZER_ALAGOZ

--CREATING TABLES FOR DATABASE
CREATE TABLE Movies
(
	MovieID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	MovieName NVARCHAR(50),
	MovieDescription NTEXT,
	MovieDuration INT
)


CREATE TABLE DisplaySchedule
(
	ScheduleID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	DisplayTime NVARCHAR(20)
)

CREATE TABLE Categories
(
	CategoryID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	CategoryName NVARCHAR(50),
)

CREATE TABLE Saloons
(
	SaloonID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	SaloonName NVARCHAR(20),
	SaloonCapacity INT
)

CREATE TABLE DisplayWeeks
(
	DisplayWeeksID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	WeekFirstDay DATE,
	WeekLastDay DATE,
	WeekName NVARCHAR(20)
)

CREATE TABLE MovieDetails
(
	MovieDetailID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	MovieID INT NOT NULL,
	CategoryID INT NOT NULL,
)

CREATE TABLE MovieDisplayDetails
(
	MovieDisplayDetailID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ScheduleID INT,
	DisplayWeeksID INT,
	SaloonID INT
)

CREATE TABLE MoviesVisionTable
(
	VisionID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	MovieDetailID INT NOT NULL,
	MovieDisplayDetailID INT NOT NULL
)

CREATE TABLE MovieDatabaseLogs
(
	LogID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	MovieID INT,
	ActivityType NVARCHAR(30),
	ActivityDate DATETIME
)
--CREATING TABLES FOR DATABASE
GO

--ADDING NECESSARY FOREIGN KEYS
ALTER TABLE MovieDetails
ADD FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
ALTER TABLE MovieDetails
ADD FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)


ALTER TABLE MovieDisplayDetails
ADD FOREIGN KEY (ScheduleID) REFERENCES DisplaySchedule(ScheduleID)
ALTER TABLE MovieDisplayDetails
ADD FOREIGN KEY (DisplayWeeksID) REFERENCES DisplayWeeks(DisplayWeeksID)
ALTER TABLE MovieDisplayDetails
ADD FOREIGN KEY (SaloonID) REFERENCES Saloons(SaloonID)


ALTER TABLE MoviesVisionTable
ADD FOREIGN KEY (MovieDetailID) REFERENCES MovieDetails(MovieDetailID)
ALTER TABLE MoviesVisionTable
ADD FOREIGN KEY (MovieDisplayDetailID) REFERENCES MovieDisplayDetails(MovieDisplayDetailID)
--ADDING NECESSARY FOREIGN KEYS


--CREATING TRIGGERS ON MOVIES TO INSERT, UPDATE, DELETE AND SELECT MOVIES
CREATE TRIGGER [Trigger_InsertsMovie] ON Movies AFTER INSERT
AS 
BEGIN 
	DECLARE @movieID INT;
	SELECT @movieID = MovieID FROM INSERTED;

	INSERT INTO MovieDatabaseLogs (MovieID, ActivityType, ActivityDate)
	VALUES
	(@movieID, 'INSERTED', GETDATE());
END

CREATE TRIGGER [Trigger_DeletesMovie] ON Movies AFTER DELETE
AS 
BEGIN 
	DECLARE @movieID INT;
	SELECT @movieID = MovieID FROM DELETED;

	INSERT INTO MovieDatabaseLogs (MovieID, ActivityType, ActivityDate)
	VALUES
	(@movieID, 'DELETED', GETDATE());
END

CREATE TRIGGER [Trigger_UpdatesMovie] ON Movies AFTER UPDATE
AS 
BEGIN 
	DECLARE @movieID INT;
	SELECT @movieID = MovieID FROM INSERTED;

	INSERT INTO MovieDatabaseLogs (MovieID, ActivityType, ActivityDate)
	VALUES
	(@movieID, 'UPDATED', GETDATE());
END
--CREATING TRIGGERS ON MOVIES TO INSERT, UPDATE, DELETE AND SELECT MOVIES



--Procedures for Movies Table
CREATE PROCEDURE [SP_AddsMovie] (@movieName NVARCHAR(50), @movieDescription NTEXT, @movieDuration INT)
AS
BEGIN 
	INSERT INTO Movies (MovieName, MovieDescription, MovieDuration) 
	VALUES
	(@movieName, @movieDescription, @movieDuration)
END

CREATE PROCEDURE [SP_DeletesMovie] (@movieID INT)
AS
BEGIN 
	DELETE FROM Movies WHERE MovieID = @movieID
END

CREATE PROCEDURE [SP_UpdatesMovie] (@movieName NVARCHAR(50), @movieDescription NTEXT, @movieDuration INT, @movieID INT)
AS
BEGIN 
	UPDATE Movies SET
	MovieName = @movieName, MovieDescription = @movieDescription, MovieDuration = @movieDuration WHERE MovieID = @movieID
END

CREATE PROCEDURE [SP_SelectsMovie] (@movieID INT)
AS
BEGIN 
	SELECT * FROM Movies AS [Movies] WHERE MovieID = @movieID
END
--Procedures for Movies Table


--Procedures for DisplaySchedule Table
CREATE PROCEDURE [SP_InsertsDisplaySchedule] (@displayTime NVARCHAR(20))
AS 
BEGIN
	INSERT INTO DisplaySchedule (DisplayTime) VALUES (@displayTime)
END

CREATE PROCEDURE [SP_DeletesDisplaySchedule] (@scheduleID INT) 
AS 
BEGIN
	DELETE FROM DisplaySchedule WHERE ScheduleID = @scheduleID
END

CREATE PROCEDURE [SP_UpdatesDisplaySchedule] (@displayTime NVARCHAR(20), @scheduleID INT)
AS
BEGIN
	UPDATE DisplaySchedule SET
	DisplayTime = @displayTime WHERE ScheduleID = @scheduleID
END

CREATE PROCEDURE [SP_SelectsDisplaySchedule] (@scheduleID INT)
AS
BEGIN
	SELECT * FROM DisplaySchedule AS [Schedule] WHERE ScheduleID = @scheduleID
END
--Procedures for DisplaySchedule Table


--Procedures for Categories Table
CREATE PROCEDURE [SP_InsertsCategory] (@categoryName NVARCHAR(50))
AS
BEGIN
	INSERT INTO Categories (CategoryName) VALUES (@categoryName)
END

CREATE PROCEDURE [SP_DeletesCategory] (@categoryID INT)
AS
BEGIN
	DELETE FROM Categories WHERE CategoryID = @categoryID
END

CREATE PROCEDURE [SP_UpdatesCategory] (@categoryName NVARCHAR(50), @categoryID INT)
AS
BEGIN
	UPDATE Categories SET CategoryName = @categoryName 
	WHERE CategoryID = @categoryID
END

CREATE PROCEDURE [SP_SelectsCategory] (@categoryID INT)
AS
BEGIN
	SELECT * FROM Categories AS [Categories] WHERE CategoryID = @categoryID
END
--Procedures for Categories Table


--Procedures for Saloons Table
CREATE PROCEDURE [SP_InsertsSaloons] (@saloonName NVARCHAR(20), @saloonCapacity INT)
AS
BEGIN
	INSERT INTO Saloons (SaloonName, SaloonCapacity) 
	VALUES
	(@saloonName, @saloonCapacity)
END

CREATE PROCEDURE [SP_DeletesSaloons] (@saloonID INT)
AS
BEGIN
	DELETE FROM Saloons WHERE SaloonID = @saloonID
END

CREATE PROCEDURE [SP_UpdatesSaloons] (@saloonName NVARCHAR(20), @saloonCapacity INT, @saloonID INT)
AS
BEGIN
	UPDATE Saloons SET
	SaloonName = @saloonName, SaloonCapacity = @saloonCapacity WHERE SaloonID = @saloonID
END

CREATE PROCEDURE [SP_SelectsSaloons] (@saloonID INT)
AS
BEGIN
	SELECT * FROM Saloons AS [Saloon] WHERE SaloonID = @saloonID
END
--Procedures for Saloons Table

--Procedures for DisplayWeeks Table
CREATE PROCEDURE [SP_InsertsDisplayWeek] (@weekName NVARCHAR(20), @weekFirstDay DATE, @weekLastDay DATE)
AS
BEGIN
	INSERT INTO DisplayWeeks (WeekName, WeekFirstDay, WeekLastDay) VALUES 
	(@weekName, @weekFirstDay, @weekLastDay)
END

CREATE PROCEDURE [SP_DeletesDisplayWeek] (@displayWeeksID INT)
AS
BEGIN
	DELETE FROM DisplayWeeks WHERE DisplayWeeksID = @displayWeeksID
END

CREATE PROCEDURE [SP_UpdatesDisplayWeek] (@weekName NVARCHAR(20), @weekFirstDay DATE, @weekLastDay DATE, @displayWeeksID INT)
AS
BEGIN
	UPDATE DisplayWeeks SET
	WeekName = @weekName, WeekFirstDay = @weekFirstDay, WeekLastDay = @weekLastDay WHERE DisplayWeeksID = @displayWeeksID
END

CREATE PROCEDURE [SP_SelectsDisplayWeek] (@displayWeeksID INT)
AS
BEGIN
	SELECT * FROM DisplayWeeks AS [Display Weeks] WHERE DisplayWeeksID = @displayWeeksID
END
--Procedures for DisplayWeeks Table

--Procedure for MovieDetails Table
CREATE PROC [SP_InsertsMovieDetail] (@movieID INT, @categoryID INT) 
AS
BEGIN
	INSERT INTO MovieDetails(MovieID, CategoryID) VALUES (@movieID,@categoryID)
END
--Procedure for MovieDetails Table

--Procedure for MovieDisplayDetails Table
CREATE PROCEDURE [S_InsertsMovieDisplayDetails] (@scheduleID INT, @displayWeeksID INT, @saloonID INT) 
AS
BEGIN
	INSERT INTO MovieDisplayDetails (ScheduleID, DisplayWeeksID, SaloonID) VALUES
	(@scheduleID, @displayWeeksID, @saloonID)
END
--Procedure for MovieDisplayDetails Table

--Procedure for MoviesVisionTable Table
CREATE PROCEDURE [S_InsertsMoviesVisionTable] (@movieDetailID INT, @movieDisplayDetailID INT) 
AS
BEGIN
	INSERT INTO MoviesVisionTable (MovieDetailID, MovieDisplayDetailID) VALUES
	(@movieDetailID, @movieDisplayDetailID)
END
--Procedure for MoviesVisionTable Table

--Execution of the SPs for Saloons
EXECUTE SP_InsertsSaloons @saloonName = 'A', @saloonCapacity = 40
EXECUTE SP_InsertsSaloons @saloonName = 'B', @saloonCapacity = 58
EXECUTE SP_InsertsSaloons @saloonName = 'C', @saloonCapacity = 94
EXECUTE SP_InsertsSaloons @saloonName = 'D', @saloonCapacity = 72
--Execution of the SPs for Saloons

--Execution of the SPs for Movies
EXECUTE SP_AddsMovie @movieName = 'The Shawshank Redemption' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'Back to the Future' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'Forrest Gump' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'Fight Club' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'The Lion King' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'Back to the Future 2' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'The Truman Show' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'Ice Age' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'The Green Mile' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'Back to the Future 3' , @movieDescription = '' , @movieDuration = ''
EXECUTE SP_AddsMovie @movieName = 'The Matrix' , @movieDescription = '' , @movieDuration = ''
--Execution of the SPs for Movies

--Execution of the SPs for DisplayWeeks
EXECUTE SP_InsertsDisplayWeek @weekName = 'W32', @weekFirstDay = '2016-08-08' , @weekLastDay = '2016-08-14'
EXECUTE SP_InsertsDisplayWeek @weekName = 'W33', @weekFirstDay = '2016-08-15' , @weekLastDay = '2016-08-21'
EXECUTE SP_InsertsDisplayWeek @weekName = 'W34', @weekFirstDay = '2016-08-22' , @weekLastDay = '2016-08-28'
--Execution of the SPs for DisplayWeeks

--Execution of the SPs for Categories
EXECUTE SP_InsertsCategory @categoryName = 'Crime'
EXECUTE SP_InsertsCategory @categoryName = 'Drama'
EXECUTE SP_InsertsCategory @categoryName = 'Adventure'
EXECUTE SP_InsertsCategory @categoryName = 'Comedy'
EXECUTE SP_InsertsCategory @categoryName = 'Sci-Fi'
EXECUTE SP_InsertsCategory @categoryName = 'Comedy'
EXECUTE SP_InsertsCategory @categoryName = 'Animation'
EXECUTE SP_InsertsCategory @categoryName = 'Fantasy'
EXECUTE SP_InsertsCategory @categoryName = 'Action'
--Execution of the SPs for Categories

--Execution of the SPs for DisplaySchedule
EXECUTE SP_InsertsDisplaySchedule @displayTime = '11:00'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '12:00'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '13:30'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '14:00'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '15:00'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '16:00'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '17:00'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '18:30'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '19:00'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '20:00'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '20:30'
EXECUTE SP_InsertsDisplaySchedule @displayTime = '21:30'
--Execution of the SPs for DisplaySchedule


SELECT * FROM Movies
SELECT * FROM Categories
SELECT * FROM Saloons
SELECT * FROM DisplaySchedule
SELECT * FROM MovieDatabaseLogs
SELECT * FROM DisplayWeeks
SELECT * FROM MovieDetails
SELECT * FROM MovieDisplayDetails
SELECT * FROM MoviesVisionTable

