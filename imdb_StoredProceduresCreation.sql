use imdb226_1;
show variables like 'local_infile';
SET GLOBAL local_infile = 1;

/*------------------- Stored Procedures---------------------------*/

SELECT 
  ROUTINE_SCHEMA,
  ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE';
 
/*--Get Movie Details: This procedure retrieves the details of a specific movie.-------*/
DELIMITER $$
CREATE PROCEDURE GetMovieDetails(
    IN _movieID VARCHAR(10)
)
BEGIN
    SELECT * FROM movie WHERE movieID = _movieID;
END$$
DELIMITER ;

-- CALL GetMovieDetails('tt0000005');

/*--Add New Movie: This procedure allows you to insert a new movie record into the movie table.-------*/
DELIMITER $$
CREATE PROCEDURE AddNewMovie(
    IN _movieID VARCHAR(10),
    IN _primaryTitle VARCHAR(50),
    IN _originalTitle VARCHAR(50),
    IN _isAdult BOOLEAN,
    IN _releaseYear INT,
    IN _runtimeMinutes INT,
    IN _averageRating FLOAT,
    IN _numVotes INT
)
BEGIN
    INSERT INTO movie (movieID, primaryTitle, originalTitle, isAdult, releaseYear, runtimeMinutes, averageRating, numVotes)
    VALUES (_movieID, _primaryTitle, _originalTitle, _isAdult, _releaseYear, _runtimeMinutes, _averageRating, _numVotes);
END$$
DELIMITER ;

-- CALL AddNewMovie('M001', 'Inception', 'Inception', FALSE, 2010, 148, 8.8, 2000000);

/*------------Procedure to Update Series Details: Allows for updating an existing series record.---------------------------*/
DELIMITER $$
CREATE PROCEDURE UpdateSeries(
    IN _seriesID VARCHAR(10),
    IN _primaryTitle VARCHAR(50),
    IN _originalTitle VARCHAR(50),
    IN _startYear INT,
    IN _averageRating FLOAT,
    IN _numVotes INT
)
BEGIN
    UPDATE series
    SET primaryTitle = _primaryTitle, originalTitle = _originalTitle, startYear = _startYear, 
        averageRating = _averageRating, numVotes = _numVotes
    WHERE seriesID = _seriesID;
END$$
DELIMITER ;

/*------------Procedure to Delete a Series: Facilitates the deletion of a series record.---------------------------*/
DELIMITER $$
CREATE PROCEDURE DeleteSeries(
    IN _seriesID VARCHAR(10)
)
BEGIN
    DELETE FROM series WHERE seriesID = _seriesID;
END$$
DELIMITER ;

/*---Total Number of Series Episodes:Purpose: Calculates the total number of episodes in a given series, which is useful for analytics or display on a user interface.  ---*/

DELIMITER $$
CREATE PROCEDURE TotalEpisodesInSeries(
    IN _seriesID VARCHAR(10)
)
BEGIN
    SELECT COUNT(*)
    FROM episode
    WHERE seriesID = _seriesID;
END $$
DELIMITER ;

-- CALL TotalEpisodesInSeries('tt0039122');

/*-------Retrieve Episodes for a Series: This procedure will take a seriesID as input and return a list of all episodes associated with that series.---------------------------*/
DELIMITER $$
CREATE PROCEDURE GetEpisodesBySeries(
    IN _seriesID VARCHAR(10)
)
BEGIN
    SELECT episodeID, seasonNumber, episodeNumber, primaryTitle, originalTitle, isAdult, startYear
    FROM episode
    WHERE seriesID = _seriesID
    ORDER BY seasonNumber, episodeNumber;
END$$
DELIMITER ;

-- CALL GetEpisodesBySeries('tt0041030');

/*------------------- Procedure to Update Episode Alias: Allows updating details of an existing episode alias.---------------------------*/
DELIMITER $$
CREATE PROCEDURE UpdateEpisodeAlias(
    IN _episodeID VARCHAR(10),
    IN _ordering INT,
    IN _newTitle VARCHAR(50),
    IN _newRegion VARCHAR(10),
    IN _newIsOriginalTitle VARCHAR(50)
)
BEGIN
    UPDATE episode_alias
    SET title = _newTitle, region = _newRegion, isOriginalTitle = _newIsOriginalTitle
    WHERE episodeID = _episodeID AND ordering = _ordering;
END$$
DELIMITER ;

/*------------------- Procedure to Retrieve All Aliases for a Specific Episode : This procedure will fetch all aliases for a given episode.---------------------------*/
DELIMITER $$
CREATE PROCEDURE GetAllAliasesForEpisode(
    IN _episodeID VARCHAR(10)
)
BEGIN
    SELECT * FROM episode_alias
    WHERE episodeID = _episodeID;
END$$
DELIMITER ;

/*------------------- Procedure to Update IsOriginalTitle for an Episode Alias: This procedure allows you to update the isOriginalTitle field for a specific alias of an episode.---------------------------*/
DELIMITER $$
CREATE PROCEDURE UpdateIsOriginalTitle(
    IN _episodeID VARCHAR(10),
    IN _ordering INT,
    IN _isOriginalTitle VARCHAR(50)
)
BEGIN
    UPDATE episode_alias
    SET isOriginalTitle = _isOriginalTitle
    WHERE episodeID = _episodeID AND ordering = _ordering;
END$$
DELIMITER ;

/*------------------- Procedure to Add New Episode Alias: Simplifies the process of adding a new alias for an episode.--------------------------*/
DELIMITER $$
CREATE PROCEDURE AddEpisodeAlias(
    IN _episodeID VARCHAR(10),
    IN _ordering INT,
    IN _title VARCHAR(50),
    IN _region VARCHAR(10),
    IN _isOriginalTitle VARCHAR(50)
)
BEGIN
    INSERT INTO episode_alias (episodeID, ordering, title, region, isOriginalTitle)
    VALUES (_episodeID, _ordering, _title, _region, _isOriginalTitle);
END$$
DELIMITER ;


/*------------------- Procedure to Add Movie Alias: This procedure simplifies the process of adding a new alias to a movie. ---------------------------*/
DELIMITER $$
CREATE PROCEDURE AddMovieAlias(
    IN _movieID VARCHAR(10),
    IN _ordering INT,
    IN _title VARCHAR(50),
    IN _region VARCHAR(10),
    IN _isOriginalTitle VARCHAR(50)
)
BEGIN
    INSERT INTO movie_alias (movieID, ordering, title, region, isOriginalTitle)
    VALUES (_movieID, _ordering, _title, _region, _isOriginalTitle);
END$$
DELIMITER ;

/*-------------------Procedure to Delete Movie Alias: This procedure allows for the deletion of a movie alias.---------------------------*/
DELIMITER $$
CREATE PROCEDURE DeleteMovieAlias(
    IN _movieID VARCHAR(10),
    IN _ordering INT
)
BEGIN
    DELETE FROM movie_alias WHERE movieID = _movieID AND ordering = _ordering;
END$$
DELIMITER ;

/*-------------------Procedure to Add Series Alias: Simplifies the process of adding a new series alias.-------------------------*/
DELIMITER $$
CREATE PROCEDURE AddSeriesAlias(
    IN _seriesID VARCHAR(10),
    IN _ordering INT,
    IN _title VARCHAR(50),
    IN _region VARCHAR(10),
    IN _isOriginalTitle VARCHAR(50)
)
BEGIN
    INSERT INTO series_alias (seriesID, ordering, title, region, isOriginalTitle)
    VALUES (_seriesID, _ordering, _title, _region, _isOriginalTitle);
END$$
DELIMITER ;

/*-------------------Procedure to Delete Series Alias:For removing a series alias.--------------------------*/
DELIMITER $$
CREATE PROCEDURE DeleteSeriesAlias(
    IN _seriesID VARCHAR(10),
    IN _ordering INT
)
BEGIN
    DELETE FROM series_alias WHERE seriesID = _seriesID AND ordering = _ordering;
END$$
DELIMITER ;

/*-------------------  Procedure to Get Series Alias by Series ID: This procedure fetches all aliases for a given series.--------------------------*/
DELIMITER $$
CREATE PROCEDURE GetSeriesAliasBySeriesID(
    IN _seriesID VARCHAR(10)
)
BEGIN
    SELECT * FROM series_alias
    WHERE seriesID = _seriesID;
END$$
DELIMITER ;

-- CALL GetSeriesAliasBySeriesID('S12345');

/*------------------- Add New Actor: Adds a new actor to the database.--------------------------*/
DELIMITER $$
CREATE PROCEDURE AddNewActor(
    IN _actorID VARCHAR(10),
    IN _primaryName VARCHAR(50),
    IN _birthYear INT,
    IN _deathYear INT,
    IN _gender VARCHAR(10)
)
BEGIN
    INSERT INTO actor (actorID, primaryName, birthYear, deathYear, gender)
    VALUES (_actorID, _primaryName, _birthYear, _deathYear, _gender);
END$$
DELIMITER ;

/*-------------------  Procedure to List Actors Born in a Specific Year: This procedure retrieves all actors born in a given year.--------------------------*/
DELIMITER $$
CREATE PROCEDURE CountActorsByGender()
BEGIN
    SELECT gender, COUNT(*) as total
    FROM actor
    GROUP BY gender;
END$$
DELIMITER ;

/*-------------------  Procedure to Retrieve Deceased Actors: This procedure lists actors who have a recorded death year.---------------------------*/
DELIMITER $$
CREATE PROCEDURE GetDeceasedActors()
BEGIN
    SELECT * FROM actor WHERE deathYear IS NOT NULL;
END$$
DELIMITER ;

/*------------------- Add New Director: Procedure to add a new director to the database.--------------------------*/
DELIMITER $$
CREATE PROCEDURE AddNewDirector(
    IN _directorID VARCHAR(10),
    IN _primaryName VARCHAR(50),
    IN _birthYear INT,
    IN _deathYear INT
)
BEGIN
    INSERT INTO director (directorID, primaryName, birthYear, deathYear)
    VALUES (_directorID, _primaryName, _birthYear, _deathYear);
END$$
DELIMITER ;

/*------------------Update Director Details: Procedure to update an existing director's details.--------------------------*/
DELIMITER $$
CREATE PROCEDURE UpdateDirector(
    IN _directorID VARCHAR(10),
    IN _primaryName VARCHAR(50),
    IN _birthYear INT,
    IN _deathYear INT
)
BEGIN
    UPDATE director
    SET primaryName = _primaryName, birthYear = _birthYear, deathYear = _deathYear
    WHERE directorID = _directorID;
END$$
DELIMITER ;

/*------------------Get Director Details: Procedure to retrieve details of a specific director.---------------------------*/
DELIMITER $$
CREATE PROCEDURE GetDirectorDetails(
    IN _directorID VARCHAR(10)
)
BEGIN
    SELECT * FROM director WHERE directorID = _directorID;
END$$
DELIMITER ;

/*------------------Add New Writer: Procedure to insert a new writer into the database.--------------------------*/
DELIMITER $$
CREATE PROCEDURE AddNewWriter(
    IN _writerID VARCHAR(10),
    IN _primaryName VARCHAR(50),
    IN _birthYear INT,
    IN _deathYear INT
)
BEGIN
    INSERT INTO writer (writerID, primaryName, birthYear, deathYear)
    VALUES (_writerID, _primaryName, _birthYear, _deathYear);
END$$
DELIMITER ;

/*-----------------Get Writer Details: Procedure to fetch the details of a particular writer.--------------------------*/
DELIMITER $$
CREATE PROCEDURE GetWriterDetails(
    IN _writerID VARCHAR(10)
)
BEGIN
    SELECT * FROM writer WHERE writerID = _writerID;
END$$
DELIMITER ;

/*-----------------Add Title for Actor: Procedure to add a known title for an actor.------------------------*/
DELIMITER $$
CREATE PROCEDURE AddTitleForActor(
    IN _actorID VARCHAR(10),
    IN _knownForTitles VARCHAR(10)
)
BEGIN
    INSERT INTO actor_known_for_titles (actorID, knownForTitles)
    VALUES (_actorID, _knownForTitles);
END$$
DELIMITER ;

/*-------------------Get Titles for Actor: Procedure to retrieve all known titles for a specific actor.--------------------------*/
DELIMITER $$
CREATE PROCEDURE GetTitlesForActor(
    IN _actorID VARCHAR(10)
)
BEGIN
    SELECT knownForTitles FROM actor_known_for_titles
    WHERE actorID = _actorID;
END$$
DELIMITER ;

/*------------------Procedure to Add a New Title for a Writer: This procedure simplifies the process of linking a new title to a writer.-------------------------*/
DELIMITER $$
CREATE PROCEDURE AddKnownTitleToWriter(
    IN _writerID VARCHAR(10),
    IN _knownForTitle VARCHAR(10)
)
BEGIN
    INSERT INTO writer_known_for_titles (writerID, knownForTitles)
    VALUES (_writerID, _knownForTitle);
END$$
DELIMITER ;

/*----------------Procedure to Retrieve All Titles Known for a Specific Writer: This procedure can be used to fetch all the titles a particular writer is known for.------------------------*/
DELIMITER $$
CREATE PROCEDURE GetTitlesForWriter(
    IN _writerID VARCHAR(10)
)
BEGIN
    SELECT knownForTitles
    FROM writer_known_for_titles
    WHERE writerID = _writerID;
END$$
DELIMITER ;

/*-----------------Stored Procedure to Add a Known Title for a Director: This stored procedure simplifies the process of adding a known title for a director.-------------------------*/
DELIMITER $$
CREATE PROCEDURE AddDirectorKnownForTitle(
    IN _directorID VARCHAR(10),
    IN _knownForTitle VARCHAR(10)
)
BEGIN
    INSERT INTO director_known_for_titles(directorID, knownForTitles)
    VALUES (_directorID, _knownForTitle);
END$$
DELIMITER ;

-- CALL AddDirectorKnownForTitle('D123', 'T456');

/*-----------------Procedure to Add a Movie-Director Relation: This procedure adds a new relation between a movie and a director.------------------------*/
DELIMITER $$
CREATE PROCEDURE AddMovieDirectorRelation(
    IN _movieID VARCHAR(10),
    IN _ordering INT,
    IN _directorID VARCHAR(10)
)
BEGIN
    INSERT INTO movie_director_relation(movieID, ordering, directorID)
    VALUES (_movieID, _ordering, _directorID);
END$$
DELIMITER ;

/*------------------Procedure to Remove a Movie-Director Relation: This procedure removes an existing relation.-------------------------*/
DELIMITER $$
CREATE PROCEDURE RemoveMovieDirectorRelation(
    IN _movieID VARCHAR(10),
    IN _directorID VARCHAR(10)
)
BEGIN
    DELETE FROM movie_director_relation
    WHERE movieID = _movieID AND directorID = _directorID;
END$$
DELIMITER ;

/*------------------Procedure to Add a Writer to a Movie ; Adds a new writer relationship to a movie.-------------------------*/
DELIMITER $$
CREATE PROCEDURE AddMovieWriter(
    IN _movieID VARCHAR(10),
    IN _ordering INT,
    IN _writerID VARCHAR(10)
)
BEGIN
    INSERT INTO movie_writer_relation(movieID, ordering, writerID)
    VALUES (_movieID, _ordering, _writerID);
END$$
DELIMITER ;

/*-----------------Procedure to Remove a Writer from a Movie : Removes a writer relationship from a movie.--------------------------*/
DELIMITER $$
CREATE PROCEDURE RemoveMovieWriter(
    IN _movieID VARCHAR(10),
    IN _ordering INT,
    IN _writerID VARCHAR(10)
)
BEGIN
    DELETE FROM movie_writer_relation
    WHERE movieID = _movieID AND ordering = _ordering AND writerID = _writerID;
END$$
DELIMITER ;

/*-----------------Procedure to Add Actor to Movie: This procedure simplifies the process of linking an actor to a movie.--------------------------*/
DELIMITER $$
CREATE PROCEDURE AddActorToMovie(
    IN _movieID VARCHAR(10),
    IN _actorID VARCHAR(10),
    IN _characters VARCHAR(100),
    IN _ordering INT
)
BEGIN
    INSERT INTO movie_actor_relation(movieID, actorID, Characters, ordering)
    VALUES (_movieID, _actorID, _characters, _ordering);
END$$
DELIMITER ;

-- CALL AddActorToMovie('M123', 'A456', 'John Doe', 1);

/*-----------------Add Director to Series: This procedure simplifies the process of linking a director to a series.-------------------------*/
DELIMITER $$
CREATE PROCEDURE AddDirectorToSeries(
    IN _seriesID VARCHAR(10),
    IN _ordering INT,
    IN _directorID VARCHAR(10)
)
BEGIN
    INSERT INTO series_director_relation(seriesID, ordering, directorID)
    VALUES (_seriesID, _ordering, _directorID);
END$$
DELIMITER ;

/*-----------------Add Writer to Series: Adds a writer to a specific series.--------------------------*/
DELIMITER $$
CREATE PROCEDURE AddWriterToSeries(
    IN _seriesID VARCHAR(10),
    IN _ordering INT,
    IN _writerID VARCHAR(10)
)
BEGIN
    INSERT INTO series_writer_relation(seriesID, ordering, writerID)
    VALUES (_seriesID, _ordering, _writerID);
END$$
DELIMITER ;

/*-----------------Remove Writer from Series: Removes a writer from a specific series.-------------------------*/
DELIMITER $$
CREATE PROCEDURE RemoveWriterFromSeries(
    IN _seriesID VARCHAR(10),
    IN _writerID VARCHAR(10)
)
BEGIN
    DELETE FROM series_writer_relation
    WHERE seriesID = _seriesID AND writerID = _writerID;
END$$
DELIMITER ;

/*------------------Add Actor to Series: Adds a new actor to a series with their character information.-------------------------*/
DELIMITER $$
CREATE PROCEDURE AddActorToSeries(
    IN _seriesID VARCHAR(10),
    IN _ordering INT,
    IN _actorID VARCHAR(10),
    IN _characters VARCHAR(10)
)
BEGIN
    INSERT INTO series_actor_relation(seriesID, ordering, actorID, characters)
    VALUES (_seriesID, _ordering, _actorID, _characters);
END$$
DELIMITER ;


/*-----------------Remove Actor from Series: Removes an actor from a series.-----------------------*/
DELIMITER $$
CREATE PROCEDURE RemoveActorFromSeries(
    IN _seriesID VARCHAR(10),
    IN _actorID VARCHAR(10)
)
BEGIN
    DELETE FROM series_actor_relation
    WHERE seriesID = _seriesID AND actorID = _actorID;
END$$
DELIMITER ;

/*-------------------Stored Procedure for Adding a Genre to a Movie---------------------------*/
DELIMITER $$
CREATE PROCEDURE AddGenreToMovie(
    IN _movieID VARCHAR(10),
    IN _genre VARCHAR(10)
)
BEGIN
    INSERT INTO movie_genre(movieID, genres) VALUES (_movieID, _genre);
END$$
DELIMITER ;

-- CALL AddGenreToMovie('mv001', 'Drama');

/*------------------- Stored Procedure: Add Genre to Series---------------------------*/
DELIMITER $$
CREATE PROCEDURE AddGenreToSeries(
    IN _seriesID VARCHAR(10),
    IN _genre VARCHAR(10)
)
BEGIN
    INSERT INTO series_genre(seriesID, genres)
    VALUES (_seriesID, _genre);
END$$
DELIMITER ;



