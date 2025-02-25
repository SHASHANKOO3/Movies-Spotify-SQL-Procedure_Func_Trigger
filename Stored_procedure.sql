-- PROCEDURE TO GET MOVIE OR SERIES BY YEAR AND GENRE

CREATE OR REPLACE PROCEDURE movie_guide (
    p_type VARCHAR2,
    p_year NUMBER,
    p_genre VARCHAR2
) AS
    CURSOR c1 IS
        SELECT title, genres, release_year 
        FROM movies
        WHERE type = p_type AND release_year = p_year 
        AND genres LIKE '%' || p_genre || '%';
    v_title movies.title%TYPE;
    v_genres movies.genres%TYPE;
    v_release_year movies.release_year%TYPE;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v_title, v_genres, v_release_year;
        EXIT WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Title: ' || v_title);
        DBMS_OUTPUT.PUT_LINE('Genres: ' || v_genres);
        DBMS_OUTPUT.PUT_LINE('Release Year: ' || v_release_year);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    CLOSE c1;
END movie_guide;
/

-- EXECUTE movie_guide('Show', 2021, 'horror');

-- PROCEDURE TO DISPLAY MOVIE, ROLE PLAYED, IMDB, YEAR OF MOVIE BY ACTOR NAME

CREATE OR REPLACE PROCEDURE Actor_Movie (p_name VARCHAR2) AS
    CURSOR c1 IS
        SELECT title, name, character, imdb_score, release_year 
        FROM box 
        WHERE name LIKE '%' || p_name || '%';
    v_title box.title%TYPE;
    v_name box.name%TYPE;
    v_character box.character%TYPE;
    v_imdb_score box.imdb_score%TYPE;
    v_release_year box.release_year%TYPE;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v_title, v_name, v_character, v_imdb_score, v_release_year;
        EXIT WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Movie: ' || v_title || ' || Actor: ' || v_name || ' || Role: ' || v_character || ' || IMDB: ' || v_imdb_score || ' || Year: ' || v_release_year);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    CLOSE c1;
END Actor_Movie;
/

-- EXEC Actor_Movie('Tom Cruise');

-- FUNCTION TO COUNT TOTAL SONGS BY ARTIST

CREATE OR REPLACE FUNCTION Total_Songs (p_artist VARCHAR2) RETURN NUMBER AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(DISTINCT Title) INTO v_count 
    FROM Spotify 
    WHERE Artist LIKE '%' || p_artist || '%';
    RETURN v_count;
END Total_Songs;
/

-- SELECT Total_Songs('Taylor') FROM DUAL;

-- FUNCTION TO COUNT TOTAL MOVIES BY ACTOR

CREATE OR REPLACE FUNCTION Total_Movies (p_actor VARCHAR2) RETURN NUMBER AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(DISTINCT title) INTO v_count 
    FROM box 
    WHERE name LIKE '%' || p_actor || '%';
    RETURN v_count;
END Total_Movies;
/

-- SELECT Total_Movies('Tom Cruise') FROM DUAL;

-- TRIGGER FOR BACKUP OLD DATA FROM SPOTIFY TABLE

CREATE TABLE Spotify_Backup AS SELECT * FROM Spotify WHERE 1=2;

CREATE OR REPLACE TRIGGER BackupOldData
BEFORE UPDATE OR INSERT OR DELETE ON Spotify
FOR EACH ROW
BEGIN
    IF INSERTING OR UPDATING THEN
        INSERT INTO Spotify_Backup VALUES :OLD.*;
    ELSIF DELETING THEN
        INSERT INTO Spotify_Backup VALUES :OLD.*;
    END IF;
END;
/

-- TRIGGER FOR BACKUP OLD DATA FROM MOVIES TABLE

CREATE TABLE Movie_Backup AS SELECT * FROM movies WHERE 1=2;

CREATE OR REPLACE TRIGGER Backup_Movies_Data
BEFORE UPDATE OR INSERT OR DELETE ON movies
FOR EACH ROW
BEGIN
    IF INSERTING OR UPDATING THEN
        INSERT INTO Movie_Backup VALUES :OLD.*;
    ELSIF DELETING THEN
        INSERT INTO Movie_Backup VALUES :OLD.*;
    END IF;
END;
/
