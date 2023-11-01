CREATE DATABASE MusicTask
USE MusicTask


CREATE TABLE Users(
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    [Surname] VARCHAR(50) DEFAULT 'XXX',
    [Username] VARCHAR(50) NOT NULL,
    [Password] VARCHAR(128) NOT NULL,
    [Gender] VARCHAR(6) DEFAULT 'XXX'
)

CREATE TABLE Artists(
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    [Surname] VARCHAR(50) DEFAULT 'XXX',
    [Birthday] DATE NOT NULL,
    [Gender] VARCHAR(6) DEFAULT 'XXX'
)

CREATE TABLE Categories(
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE Musics(
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    [Duration] INT CHECK(Duration>0),
    [CategoryId] INT FOREIGN KEY REFERENCES Categories(Id)
)

CREATE TABLE Playlist(
    [MusicId] INT FOREIGN KEY REFERENCES Musics(Id),
    [UserId] INT FOREIGN KEY REFERENCES Users(Id) 
)

CREATE TABLE ArtistMusic(                --Bir mahni bir nece artistin ola biler hemcinin bir artistinde bir nece mahnisi olur
    [MusicId] INT FOREIGN KEY REFERENCES Musics(Id),
    [ArtistId] INT FOREIGN KEY REFERENCES Artists(Id) 
)


INSERT INTO Users VALUES 
('Shamama', 'Guliyeva', 'khuliieva', 'Samama2004', 'Female'),
('Zuzu', 'Gurbanova', 'zuzuwu', 'Zuzu123', 'Female'),
('Nigar', 'Glm', 'nigarglm', 'NigarThik', 'Female'),
('Asiman', 'Qasimzade', 'asman18', 'CodeCodeCode123', 'Male'),
('Sabuhi', 'Camalzade', 'sebiwka', 'Sabuhi1907', 'Male')


INSERT INTO Artists VALUES 
('Rovsen', 'Bineqedili', '01.01.1980','Male'),
('Nihat', 'Rehimzade', '01.01.2004', 'Male'),
('Shamama', 'Guliyeva', '07.09.2004','Female')

INSERT INTO Categories VALUES
('Azeri bass'),
('Rock'),
('Pop')

INSERT INTO Musics VALUES
('Zelzele', 120, 1),
('Agario', 180, 3),
('Cepis', 200, 2)

INSERT INTO Playlist VALUES
(1,1),
(3,1),
(2,2),
(1,3),
(3,4),
(2,5)

INSERT INTO ArtistMusic VALUES
(1,1),
(2,2),
(3,3)

CREATE VIEW MusicView
AS
SELECT m.Name AS [Mahni adi], m.Duration AS [Muddet(Saniye ile)], c.Name AS [Kateqoriya], CONCAT(a.Name,' ',a.Surname) AS Mugenni
FROM Musics AS m 
JOIN Categories AS c ON m.CategoryId = c.Id
JOIN ArtistMusic AS ma ON m.Id = ma.MusicId
JOIN Artists AS a ON ma.ArtistId = a.Id

Select * from MusicView

--PROCEDURE, FUNCTION TASK

CREATE PROCEDURE usp_CreateMusic @name VARCHAR(50), @duration INT, @catid INT
AS
BEGIN
INSERT INTO Musics (Name,Duration,CategoryId) VALUES(
    @name,@duration,@catid
)
END

EXEC usp_CreateMusic 'Sinanay',270,3

---------------------------------------------------------------

CREATE PROCEDURE usp_CreateUser @name VARCHAR(50), @surname VARCHAR(50)='XXX', @username VARCHAR(50), @password VARCHAR(128), @gender VARCHAR(6)
AS
BEGIN
INSERT INTO Users (Name,Surname,Username, [Password],Gender) VALUES(
@name, @surname , @username , @password , @gender)
END

EXEC usp_CreateUser 'Adil', 'Nasirli','adilnasirli','adil2004', 'male'

---------------------------------------------------------------

CREATE PROCEDURE usp_CreateCategory @name VARCHAR(50)
AS
BEGIN
INSERT INTO Categories (Name) VALUES(
    @name
)
END

EXEC usp_CreateCategory 'Jazz'

---------------------------------------------------------------

ALTER TABLE Musics ADD IsDeleted BIT DEFAULT 0

CREATE TRIGGER DeleteMusic
ON Musics
INSTEAD OF DELETE 
AS
DECLARE @result BIT
DECLARE @id INT
SELECT @result=IsDeleted, @id=deleted.Id FROM deleted
IF(@result=0)
    BEGIN
     UPDATE Musics SET IsDeleted=1 WHERE Id=@id
    END
ELSE
    BEGIN
     DELETE FROM Musics WHERE Id=@id
    END


DELETE FROM Musics WHERE Id=1

---------------------------------------------------------------

CREATE VIEW ShowUser
AS
SELECT u.Id, u.Username,m.Name AS [Mahni adi],a.Name AS [Mugenni] FROM Playlist p
JOIN Users u ON p.UserId=u.Id
JOIN Musics m ON p.MusicId=m.Id
JOIN ArtistMusic ma ON ma.MusicId=m.Id
JOIN Artists a ON ma.ArtistId=a.Id


CREATE FUNCTION GetArtistByUser(@userid INT)
RETURNS INT
    BEGIN
     DECLARE @artistcount INT;
     SELECT @artistcount=COUNT(Mugenni) FROM ShowUser
     WHERE @userid=Id
     RETURN @artistcount
    END

SELECT dbo.GetArtistByUser(1)

