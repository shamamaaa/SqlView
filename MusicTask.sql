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


