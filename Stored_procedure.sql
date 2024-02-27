select * from box
select* from movies;
select * from Spotify

-- PROCEDURE TO GET MOVIE OR SERIES BY YEAR AND GENRE

ALTER PROCEDURE movie_guide
@type VARCHAR(10),
@year INT,
@genere varchar(10)
AS
BEGIN
DECLARE @title VARCHAR(100), @release int, @var varchar(20);

Declare Cursor
DECLARE c1 CURSOR FOR
SELECT title, genres, release_year 
FROM movies
WHERE type = @type AND release_year = @year and
genres LIKE '%' + @genere + '%';

OPEN c1;

Fetch Data
FETCH NEXT FROM c1 INTO @title, @var, @release;

Check if any rows were found
IF @@FETCH_STATUS = 0
BEGIN
PRINT 'Movie Information:';
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'Title: ' + @title;
PRINT 'Genres: ' + @var;
PRINT 'Release Year: ' + CAST(@release AS VARCHAR(10)); -- Convert to string for printing
PRINT '';
FETCH NEXT FROM c1 INTO @title, @var, @release;
END;
END
ELSE
BEGIN
PRINT 'No movies found for the given type and year.';
END

Close Cursor
CLOSE c1;
DEALLOCATE c1;
END

EXECUTE movie_guide @type = 'Show', @year = 2021, @genere='horror';

-- DISPLAY MOVIE, ROLE PLAYED, IMDB, YEAR OF MOVIE BY THE ACTOR NAME

Alter procedure Actor_Movie
(@name varchar(20))
as
begin

declare c1 cursor for select title, name, character, imdb_score, release_year from box 
where name like '%' + @name + '%' 

declare
@title2 varchar(20), @name2 varchar(20), @character2 varchar(20), @imdb_score2 int, @release_year2 int

open c1;
fetch next from c1 into @title2, @name2, @character2, @imdb_score2, @release_year2;

while @@FETCH_STATUS = 0
begin
print 'Movie: ' + @title2 + '|| Actor: ' + @name2 + '|| Role Played: ' + @character2 + 
'|| IMDB: ' + CAST(@imdb_score2 AS VARCHAR(10)) + '|| Year: ' + CAST(@release_year2 AS VARCHAR(10));
print '';
fetch next from c1 into @title2, @name2, @character2, @imdb_score2, @release_year2;
END;

CLOSE c1;
DEALLOCATE c1;
END;

EXEC Actor_Movie 'Tom Cruise';
EXEC Actor_Movie 'Will Smith';

-- Top N Movies/TV Series of year order by IMDb Score: 

ALTER procedure Top_Movies_shows 
@year INTEGER
as
begin

declare @title varchar(20), @type varchar(20), @genres varchar(100), @imdb_score INTEGER; 
declare c1 cursor for select title, type, genres, imdb_score from movies 
where release_year = @year order by type, imdb_score desc;

open c1

fetch next from c1 into @title , @type , @genres, @imdb_score;

while @@FETCH_STATUS = 0
begin
PRINT 'Movie: ' + @title; 
PRINT 'Type: ' + @type;
PRINT 'Genres: ' + @genres;
PRINT 'imdb_score: ' + CAST(@imdb_score as VARCHAR(10));
print '';
fetch next from c1 into @title , @type , @genres, @imdb_score;
end;
CLOSE C1;
DEALLOCATE C1;
END;

EXEC Top_Movies_shows 2011


-- 3 Songs with the Highest Popularity Score from each year: 

ALTER procedure Top_songs
@year integer,
@rnum integer
as
begin

declare @Title varchar(30), @Artist varchar(30), @genre varchar(30), @year1 integer;

declare c1 cursor for
select Title, Artist, genre, Year from
(select *, ROW_NUMBER() over(partition by year order by popularity desc) as rnum from Spotify) a
where Year = @year and rnum <= @rnum;

open c1
fetch next from c1 into @Title, @Artist, @genre, @year1

while @@FETCH_STATUS = 0
begin
PRINT 'Song: ' + @Title;
PRINT 'Singer: ' + @Artist;
PRINT 'Genre: ' + @genre;
PRINT 'Realesed on: ' + CAST(@year1 AS VARCHAR(10));
PRINT '';
fetch next from c1 into @Title, @Artist, @genre, @year1;
END;

CLOSE c1;
DEALLOCATE c1;
END;

EXEC Top_songs 2011, 5;

-- Random Song Recommendation by genre:



-- PROCEDURE TO GET SONGS BY SINGER AND TYPE

ALTER PROCEDURE playlist
@artist varchar(20), @genre varchar(20)
as
begin
declare @a varchar(20), @b varchar(20), @c varchar(20), @d varchar(20); 

declare c1 cursor for 
select Title, Artist, Genre ,Year from Spotify
where Artist like '%' + @artist + '%' and Genre like '%' + @genre + '%'
order by Popularity desc;

open c1
fetch next from c1 into @a, @b, @c, @d;
WHILE @@FETCH_STATUS = 0

begin
print 'Title: ' + @a + ' Artist: ' + @b + ' Genre: ' + @c + ' Year ' + @d;
print '';
fetch next from c1 into @a, @b, @c, @d;
end;

CLOSE c1;
DEALLOCATE c1;
END;

EXEC playlist 'Justin', 'pop'


select * from box
select* from movies;
select * from Spotify

-- function to count number
-- of songs by artist name

ALTER function Total_Songs 
(@artist varchar(20))
returns int as

begin

declare @count int;

select @count = count(distinct(Title)) from Spotify 
where Artist like '%' + @artist + '%';

return @count;

end;

SELECT dbo.Total_Songs('Taylor') AS TotalSongs;

-- function to count number
-- of movies of a actor

create function Total_Movies
(@actor varchar(20))
returns int as

begin

declare @count int;

select @count = count(distinct(title)) from box
where name like '%' + @actor + '%';

return @count;

end;

select dbo.Total_Movies('Tom Cruise') as Movie_Count

select dbo.Total_Movies('Robin Williams') as Movie_Count

-- Trigger for storing old data
-- if updated, deleted or inserted
-- new data in the table Spotify

Select * into Spotify_Backup from Spotify
where 1 = 2


CREATE TRIGGER BackupOldData
ON Spotify
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert old data into the backup table
    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO Spotify_Backup
        SELECT * FROM DELETED;
    END;

    -- For updates, also backup the old data from the INSERTED table
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        INSERT INTO Spotify_Backup
        SELECT * FROM INSERTED;
    END;
END;

select * from Spotify where Title = 'Eenie Meenie'

update Spotify
set Artist = 'Justin Beiber' where Title = 'Eenie Meenie'

select * from Spotify_Backup

-- Trigger for storing old data
-- if updated, deleted or inserted
-- new data in the table Movie


Select * into Movie_Backup from movies
where 1 = 2

CREATE TRIGGER Backup_Movies_Data
ON movies
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert old data into the backup table
    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO Movie_Backup
        SELECT * FROM DELETED;
    END;

    -- For updates, also backup the old data from the INSERTED table
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        INSERT INTO Movie_Backup
        SELECT * FROM INSERTED;
    END;
END;


