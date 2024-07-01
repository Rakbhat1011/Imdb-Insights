use imdb226_1;
show variables like 'local_infile';
SET GLOBAL local_infile = 1;

/*------------------- Triggers ---------------------------*/

/*---- general syntax to drop a trigger: ---*/
-- DROP TRIGGER [IF EXISTS] database_name.trigger_name;
-- Example:
-- DROP TRIGGER IF EXISTS LimitEpisodeCountBeforeInserting;


/*---Trigger to Validate releaseYearThis trigger ensures that the release year of a movie is not set in the future.-----------*/
DELIMITER $$
CREATE TRIGGER ValidateReleaseYearBeforeInsertOrUpdate
BEFORE INSERT ON movie
FOR EACH ROW
BEGIN
    IF NEW.releaseYear > YEAR(CURRENT_DATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Release year cannot be in the future.';
    END IF;
END$$
DELIMITER ;

/*---If you have a log table, you can use this trigger to log every deletion from the movie table.----------*/
DELIMITER $$
CREATE TRIGGER LogMovieDeletion
AFTER DELETE ON movie
FOR EACH ROW
BEGIN
    INSERT INTO deletion_log (table_name, deleted_id, deletion_time)
    VALUES ('movie', OLD.movieID, NOW());
END$$
DELIMITER ;

/*-------Trigger to Check Start Year: Ensures the start year of a series is not set in the future.-----------------------------------------------------------*/
DELIMITER $$
CREATE TRIGGER CheckStartYearBeforeInsertOrUpdate
BEFORE INSERT ON series
FOR EACH ROW
BEGIN
    IF NEW.startYear > YEAR(CURRENT_DATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Start year cannot be in the future.';
    END IF;
END$$
DELIMITER ;
/*------------------- Trigger to Limit the Number of Episodes in a Series ---------------------------*/
DELIMITER $$
CREATE TRIGGER LimitEpisodeCountBeforeInserting
BEFORE INSERT ON episode
FOR EACH ROW
BEGIN
    DECLARE episodeCount INT;
    -- Calculate the current number of episodes in the series
    SELECT COUNT(*) INTO episodeCount
    FROM episode
    WHERE seriesID = NEW.seriesID;
    -- Check if the limit is reached
    IF episodeCount >= 10000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Episode limit reached for this series.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger to Prevent Duplicate Alias for an Episode: ---------------------------*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateEpisodeAlias
BEFORE INSERT ON episode_alias
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM episode_alias
        WHERE episodeID = NEW.episodeID AND title = NEW.title AND region = NEW.region
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate episode alias for the same region is not allowed.';
    END IF;
END$$
DELIMITER ;

/*------------------- This trigger ensures that the ordering number is positive. ---------------------------*/
DELIMITER $$
CREATE TRIGGER ValidateEpisodeAliasOrdering
BEFORE INSERT ON episode_alias
FOR EACH ROW
BEGIN
    IF NEW.ordering < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ordering must be a positive integer.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger to Check if Movie Exists: This trigger ensures that an alias can only be added for movies that exist in the movie table. ---------------------------*/
DELIMITER $$
CREATE TRIGGER CheckMovieExistsBeforeInsertMovieAlias
BEFORE INSERT ON movie_alias
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM movie WHERE movieID = NEW.movieID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add alias for non-existent movie.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger to Prevent Duplicate Alias:Ensures that each alias for a series is unique. ---------------------------*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateSeriesAlias
BEFORE INSERT ON series_alias
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM series_alias
        WHERE seriesID = NEW.seriesID AND title = NEW.title AND region = NEW.region
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate series alias is not allowed.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger to Validate ordering:Ensures the ordering field is positive. ---------------------------*/
DELIMITER $$
CREATE TRIGGER ValidateSeriesAliasOrdering
BEFORE INSERT ON series_alias
FOR EACH ROW
BEGIN
    IF NEW.ordering < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ordering must be a positive integer.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger to Validate Actor's Age: Ensures that the actor's birth year is reasonable (e.g., not in the future or too far in the past). ---------------------------*/
DELIMITER $$
CREATE TRIGGER ValidateActorBirthYear
BEFORE INSERT ON actor
FOR EACH ROW
BEGIN
    IF NEW.birthYear > YEAR(CURRENT_DATE()) OR NEW.birthYear < YEAR(CURRENT_DATE()) - 120 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid birth year for actor.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger to Ensure Consistency in Death Year:Checks that the death year is not before the birth year and not in the future. ---------------------------*/
DELIMITER $$
CREATE TRIGGER ValidateActorDeathYear
BEFORE INSERT ON actor
FOR EACH ROW
BEGIN
    IF NEW.deathYear IS NOT NULL AND (NEW.deathYear < NEW.birthYear OR NEW.deathYear > YEAR(CURRENT_DATE())) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid death year for actor.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger to Validate Director's Birth Year:This trigger ensures that the director's birth year is realistic (not in the future or excessively old).-------------------------*/
DELIMITER $$
CREATE TRIGGER ValidateDirectorBirthYear
BEFORE INSERT ON director
FOR EACH ROW
BEGIN
    IF NEW.birthYear > YEAR(CURRENT_DATE()) OR NEW.birthYear < YEAR(CURRENT_DATE()) - 120 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid birth year for director.';
    END IF;
END$$
DELIMITER ;

/*-------------------Trigger to Validate Writer's Birth Year: This trigger makes sure that the birth year of a writer is realistic.------------------------*/
DELIMITER $$
CREATE TRIGGER ValidateWriterBirthYear
BEFORE INSERT ON writer
FOR EACH ROW
BEGIN
    IF NEW.birthYear > YEAR(CURRENT_DATE()) OR NEW.birthYear < YEAR(CURRENT_DATE()) - 120 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid birth year for writer.';
    END IF;
END$$
DELIMITER ;

/*------------------Trigger to Ensure Valid Death Year: Checks the death year to ensure it's not before the birth year and not in the future.-------------------------*/
DELIMITER $$
CREATE TRIGGER ValidateWriterDeathYear
BEFORE INSERT ON writer
FOR EACH ROW
BEGIN
    IF NEW.deathYear IS NOT NULL AND (NEW.deathYear < NEW.birthYear OR NEW.deathYear > YEAR(CURRENT_DATE())) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid death year for writer.';
    END IF;
END$$
DELIMITER ;

/*------------------Trigger to Prevent Duplicate Titles for the Same Actor: This trigger will make sure that the same title is not added more than once for the same actor.--------------------------*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateTitlesForActor
BEFORE INSERT ON actor_known_for_titles
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM actor_known_for_titles
        WHERE actorID = NEW.actorID AND knownForTitles = NEW.knownForTitles
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate titles for the same actor are not allowed.';
    END IF;
END$$
DELIMITER ;

/*-----------------Trigger to Ensure knownForTitles is Not Already Linked to the Same writerID: This trigger prevents the insertion of duplicate knownForTitles for the same writerID, which is especially useful if the primary key constraint is somehow bypassed or when bulk inserts are performed.-------------------------*/
DELIMITER $$
CREATE TRIGGER BeforeInsertWriterKnownForTitles
BEFORE INSERT ON writer_known_for_titles
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * FROM writer_known_for_titles
        WHERE writerID = NEW.writerID AND knownForTitles = NEW.knownForTitles
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This title is already linked to the writer.';
    END IF;
END$$
DELIMITER ;

/*------------------Trigger to Automatically Remove Data from writer_known_for_titles When a writer is Deleted: If a writer is removed from the writer table, this trigger ensures that all their associated knownForTitles are also removed, maintaining referential integrity. ---------------------------*/
DELIMITER $$
CREATE TRIGGER AfterDeleteWriter
AFTER DELETE ON writer
FOR EACH ROW
BEGIN
    DELETE FROM writer_known_for_titles WHERE writerID = OLD.writerID;
END$$
DELIMITER ;
/*----------------Trigger to Prevent Duplicate Entries: This trigger can prevent the insertion of duplicate directorID and knownForTitles combinations.---------------------------*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateDirectorTitles
BEFORE INSERT ON director_known_for_titles
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM director_known_for_titles 
               WHERE directorID = NEW.directorID AND knownForTitles = NEW.knownForTitles) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate entry for director and title not allowed.';
    END IF;
END$$
DELIMITER ;

/*--------------- Trigger to Prevent Adding Non-existent Movie or Director: This trigger ensures that both the movie and director exist before allowing a relation to be added.-----------------------*/
DELIMITER $$
CREATE TRIGGER CheckMovieDirectorExistenceBeforeInsert
BEFORE INSERT ON movie_director_relation
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM movie WHERE movieID = NEW.movieID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Movie does not exist.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM director WHERE directorID = NEW.directorID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Director does not exist.';
    END IF;
END$$
DELIMITER ;

/*-----------------Trigger to Prevent Duplicate Entries:This trigger stops the insertion of duplicate relationships.------------------------*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateMovieDirector
BEFORE INSERT ON movie_director_relation
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM movie_director_relation 
               WHERE movieID = NEW.movieID AND directorID = NEW.directorID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate movie-director relation not allowed.';
    END IF;
END$$
DELIMITER ;

/*-----------------Trigger to Prevent Duplicate Entries: Ensures that the same writer is not added more than once for the same movie and ordering.--------------------------*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateMovieWriter
BEFORE INSERT ON movie_writer_relation
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM movie_writer_relation 
               WHERE movieID = NEW.movieID AND ordering = NEW.ordering AND writerID = NEW.writerID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate movie-writer relation not allowed.';
    END IF;
END$$
DELIMITER ;

/*------------------Trigger to Check for Valid Movie and Writer IDs: Validates that the movie and writer IDs exist in their respective tables before insertion. --------------------------*/
DELIMITER $$
CREATE TRIGGER ValidateMovieWriterIDs
BEFORE INSERT ON movie_writer_relation
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT * FROM movie WHERE movieID = NEW.movieID) OR
       NOT EXISTS (SELECT * FROM writer WHERE writerID = NEW.writerID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid movieID or writerID.';
    END IF;
END$$
DELIMITER ;

/*-----------------Trigger to Prevent Adding Non-Existing Movies or Actors:This trigger ensures that the movie and actor IDs being added exist in their respective tables.--------------------*/
DELIMITER $$
CREATE TRIGGER CheckMovieActorExistence
BEFORE INSERT ON movie_actor_relation
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT * FROM movie WHERE movieID = NEW.movieID) OR
       NOT EXISTS (SELECT * FROM actor WHERE actorID = NEW.actorID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Either movie or actor does not exist.';
    END IF;
END$$
DELIMITER ;

/*-----------------Trigger to Automatically Update Ordering: This trigger can be used to automatically assign an ordering value if it is not provided.-------------------------------*/
DELIMITER $$
CREATE TRIGGER AutoAssignOrdering
BEFORE INSERT ON movie_actor_relation
FOR EACH ROW
BEGIN
    IF NEW.ordering IS NULL THEN
        SET NEW.ordering = (SELECT COALESCE(MAX(ordering), 0) + 1 
                            FROM movie_actor_relation 
                            WHERE movieID = NEW.movieID);
    END IF;
END$$
DELIMITER ;

/*--Get Actor Filmography: Purpose: Retrieves a list of movies in which a given actor has appeared, along with the release years of those movies.-------*/
DELIMITER $$
CREATE PROCEDURE GetActorFilmography(
    IN _actorID VARCHAR(10)
)
BEGIN
    SELECT m.primaryTitle, m.releaseYear
    FROM movie m
    JOIN movie_actor_relation mar ON m.movieID = mar.movieID
    WHERE mar.actorID = _actorID;
END$$
DELIMITER ;

-- CALL GetActorFilmography('nm0480138');

/*-----------------Prevent Duplicate Entries: This trigger ensures that the same director is not added multiple times for the same series with the same ordering.------------------------*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateSeriesDirector
BEFORE INSERT ON series_director_relation
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM series_director_relation
               WHERE seriesID = NEW.seriesID AND ordering = NEW.ordering AND directorID = NEW.directorID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate entry for series, ordering, and director not allowed.';
    END IF;
END$$
DELIMITER ;


/*----------------Trigger for Automatic Ordering: If you want to automatically manage the ordering field, you can use a trigger to set the ordering based on the existing entries.-------------------------*/
DELIMITER $$
CREATE TRIGGER AutoSetOrdering
BEFORE INSERT ON series_director_relation
FOR EACH ROW
BEGIN
    SET NEW.ordering = (SELECT IFNULL(MAX(ordering), 0) + 1 FROM series_director_relation WHERE seriesID = NEW.seriesID);
END$$
DELIMITER ;

/*-----------------Prevent Duplicate Entries: Ensures that the same writer is not added to the same series with the same ordering more than once.-------------------------*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateSeriesWriter
BEFORE INSERT ON series_writer_relation
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM series_writer_relation 
               WHERE seriesID = NEW.seriesID AND ordering = NEW.ordering AND writerID = NEW.writerID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate entry for series, ordering, and writer not allowed.';
    END IF;
END$$
DELIMITER ;

/*-----------------Check Writer Existence:Verifies that the writer exists in the writer table before adding them to a series.---------------------------*/
DELIMITER $$
CREATE TRIGGER CheckWriterExistsBeforeInsert
BEFORE INSERT ON series_writer_relation
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT * FROM writer WHERE writerID = NEW.writerID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Writer does not exist.';
    END IF;
END$$
DELIMITER ;

/*----------------Before Insert Trigger - Check for Valid Series and Actor IDs: Ensures that the series and actor IDs exist in their respective tables before inserting a new record.------------------------*/
DELIMITER $$
CREATE TRIGGER CheckValidSeriesAndActorBeforeInsert
BEFORE INSERT ON series_actor_relation
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT * FROM series WHERE seriesID = NEW.seriesID) OR
       NOT EXISTS (SELECT * FROM actor WHERE actorID = NEW.actorID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid seriesID or actorID.';
    END IF;
END$$
DELIMITER ;

-- DROP TRIGGER IF EXISTS CheckValidSeriesAndActorBeforeInsert;
-- DROP TRIGGER IF EXISTS PreventSeriesActorIDChangeOnUpdate;
-- DROP TRIGGER IF EXISTS PreventDuplicateActorEntry;

/*---------------Before Update Trigger - Prevent Series or Actor ID Change: Prevents changes to the seriesID and actorID in existing records.----------------------*/
DELIMITER $$
CREATE TRIGGER PreventSeriesActorIDChangeOnUpdate
BEFORE UPDATE ON series_actor_relation
FOR EACH ROW
BEGIN
    IF OLD.seriesID <> NEW.seriesID OR OLD.actorID <> NEW.actorID THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot change seriesID or actorID.';
    END IF;
END$$
DELIMITER ;

/*-----Trigger to Prevent Duplicate Entries:
This trigger ensures that the same actor is not added more than once for the same series and ordering.----*/
DELIMITER $$
CREATE TRIGGER PreventDuplicateActorEntry
BEFORE INSERT ON series_actor_relation
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM series_actor_relation
        WHERE seriesID = NEW.seriesID AND ordering = NEW.ordering AND actorID = NEW.actorID
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate actor entry for series and ordering is not allowed.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger for Ensuring Genre Consistency ---------------------------*/
DELIMITER $$
CREATE TRIGGER CheckGenreBeforeInsert
BEFORE INSERT ON movie_genre
FOR EACH ROW
BEGIN
    DECLARE genreExists BOOLEAN;
    SET genreExists = (SELECT CASE WHEN NEW.genres IN ('Drama', 'Comedy', 'Action', 'Documentary', 'Animation', 'Horror') THEN TRUE ELSE FALSE END);
    IF NOT genreExists THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid genre specified.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger: Prevent Adding Non-Existent Series ---------------------------*/
DELIMITER $$
CREATE TRIGGER CheckSeriesExistsBeforeInsert
BEFORE INSERT ON series_genre
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT * FROM series WHERE seriesID = NEW.seriesID) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add genre for a non-existent series.';
    END IF;
END$$
DELIMITER ;

/*------------------- Trigger ---------------------------*/