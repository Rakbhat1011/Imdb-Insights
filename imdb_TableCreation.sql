create schema imdb226_1;
use imdb226_1;
show variables like 'local_infile';
SET GLOBAL local_infile = 1;

/*-------------------------------------------MOVIE DATASET-------------------------------------------------------*/
CREATE TABLE movie
(
	movieID VARCHAR(10),
	primaryTitle VARCHAR(50),
	originalTitle VARCHAR(50),
	isAdult BOOLEAN,
	releaseYear INT(4),
	runtimeMinutes INT,
	averageRating FLOAT,
	numVotes INT,
	PRIMARY KEY(movieID)
);

/*-------------------------------------------SERIES DATASET-------------------------------------------------------*/
CREATE TABLE series
(
	seriesID VARCHAR(10),
	primaryTitle VARCHAR(50),
	originalTitle VARCHAR(50),
	isAdult BOOLEAN,
	startYear INT,
	averageRating FLOAT,
	numVotes INT,
	PRIMARY KEY(seriesID)
);

/*-------------------------------------------EPISODE DATASET-------------------------------------------------------*/
CREATE TABLE episode
(
	episodeID VARCHAR(10),
	seriesID VARCHAR(10),
	seasonNumber INT(4),
	episodeNumber INT(4),
	primaryTitle VARCHAR(50),
	originalTitle VARCHAR(50),
	isAdult BOOLEAN,
	startYear INT(4),
	PRIMARY KEY(episodeID),
	FOREIGN KEY (seriesID) REFERENCES series(seriesID)
);

/*-------------------------------------------EPISODE_ALIAS DATASET-------------------------------------------------------*/
CREATE TABLE episode_alias
(
	episodeID VARCHAR(10),
	ordering INT,
	title VARCHAR(50),
	region VARCHAR(10),
	isOriginalTitle VARCHAR(50),
	PRIMARY KEY(episodeID,ordering),
	FOREIGN KEY (episodeID) REFERENCES episode(episodeID)
);

/*-------------------------------------------MOVIE_ALIAS DATASET-------------------------------------------------------*/
CREATE TABLE movie_alias
(
	movieID VARCHAR(10),
	ordering INT,
	title VARCHAR(50),
	region VARCHAR(10),
	isOriginalTitle VARCHAR(50),
	PRIMARY KEY (movieID, ordering),
	FOREIGN KEY (movieID) REFERENCES movie(movieID)
);

/*-------------------------------------------SERIES_ALIAS DATASET-------------------------------------------------------*/
CREATE TABLE series_alias
(
	seriesID VARCHAR(10),
	ordering INT,
	title VARCHAR(50),
	region VARCHAR(10),
	isOriginalTitle VARCHAR(50),
	PRIMARY KEY (seriesID, ordering),
	FOREIGN KEY (seriesID) REFERENCES series(seriesID)
);

/*-------------------------------------------ACTOR DATASET-------------------------------------------------------*/
CREATE TABLE actor
(
	actorID VARCHAR(10),
	primaryName VARCHAR(50),
	birthYear INT(4),
	deathYear INT(4),
	gender VARCHAR(10),
	PRIMARY KEY (actorID)
);

/*-------------------------------------------DIRECTOR DATASET-------------------------------------------------------*/
CREATE TABLE director
(
	directorID VARCHAR(10),
	primaryName VARCHAR(50),
	birthYear INT(4),
	deathYear INT(4),
	PRIMARY KEY (directorID)
);

/*-------------------------------------------WRITER DATASET-------------------------------------------------------*/
CREATE TABLE writer
(
	writerID VARCHAR(10),
	primaryName VARCHAR(50),
	birthYear INT(4),
	deathYear INT(4),
	PRIMARY KEY (writerID)
);

/*-------------------------------------------ACTOR_KNOWN_FOR_TITLES DATASET-------------------------------------------------------*/
CREATE TABLE actor_known_for_titles
(
	actorID VARCHAR(10),
	knownForTitles VARCHAR(10),
	PRIMARY KEY (actorID, knownForTitles),
	FOREIGN KEY (actorID) REFERENCES actor(actorID)
);

/*-------------------------------------------WRITER_KNOWN_FOR_TITLES DATASET-------------------------------------------------------*/
CREATE TABLE writer_known_for_titles
(
	writerID VARCHAR(10),
	knownForTitles VARCHAR(10),
	PRIMARY KEY (writerID, knownForTitles),
	FOREIGN KEY (writerID) REFERENCES writer(writerID)
);

/*-------------------------------------------DIRECTOR_KNOWN_FOR_TITLES DATASET-------------------------------------------------------*/
CREATE TABLE director_known_for_titles
(
	directorID VARCHAR(10),
	knownForTitles VARCHAR(10),
	PRIMARY KEY (directorID, knownForTitles),
	FOREIGN KEY (directorID) REFERENCES director(directorID)
);

/*-------------------------------------------MOVIE_DIRECTOR_RELATION DATASET-------------------------------------------------------*/
CREATE TABLE movie_director_relation
(
	movieID VARCHAR(10),
	ordering INT,
	directorID VARCHAR(10),
	PRIMARY KEY (movieID, ordering, directorID),
	FOREIGN KEY (movieID) REFERENCES movie(movieID),
	FOREIGN KEY (directorID) REFERENCES director(directorID)
);

/*-------------------------------------------MOVIE_WRITER_RELATION DATASET-------------------------------------------------------*/
CREATE TABLE movie_writer_relation
(
	movieID VARCHAR(10),
	ordering INT,
	writerID VARCHAR(10),
	PRIMARY KEY (movieID, ordering, writerID),
	FOREIGN KEY (movieID) REFERENCES movie(movieID),
	FOREIGN KEY (writerID) REFERENCES writer(writerID)
);

/*-------------------------------------------MOVIE_ACTOR_RELATION DATASET-------------------------------------------------------*/
CREATE TABLE movie_actor_relation
(
	movieID VARCHAR(10),
	ordering INT,
	actorID VARCHAR(10),
	Characters VARCHAR(100),
	PRIMARY KEY (movieID, ordering, actorID),
	FOREIGN KEY (movieID) REFERENCES movie(movieID),
	FOREIGN KEY (actorID) REFERENCES actor(actorID)
);

/*-------------------------------------------SERIES_DIRECTOR_RELATION DATASET-------------------------------------------------------*/
CREATE TABLE series_director_relation
(
seriesID VARCHAR(10),
ordering INT,
directorID VARCHAR(10),
PRIMARY KEY (seriesID, ordering, directorID),
FOREIGN KEY (seriesID) REFERENCES series(seriesID),
FOREIGN KEY (directorID) REFERENCES director(directorID)
);

/*-------------------------------------------SERIES_WRITER_RELATION DATASET-------------------------------------------------------*/
CREATE TABLE series_writer_relation
(
	seriesID VARCHAR(10),
	ordering INT,
	writerID VARCHAR(10),
	PRIMARY KEY (seriesID, ordering, writerID),
	FOREIGN KEY (seriesID) REFERENCES series(seriesID),
	FOREIGN KEY (writerID) REFERENCES writer(writerID)
);

/*-------------------------------------------SERIES_ACTOR_RELATION DATASET-------------------------------------------------------*/
CREATE TABLE series_actor_relation
(
	seriesID VARCHAR(10),
	ordering INT,
	actorID VARCHAR(10),
	characters VARCHAR(10),
	PRIMARY KEY (seriesID, ordering, actorID),
	FOREIGN KEY (seriesID) REFERENCES series(seriesID),
	FOREIGN KEY (actorID ) REFERENCES actor(actorID)
);

/*-------------------------------------------movie_genre DATASET-------------------------------------------------------*/
CREATE TABLE movie_genre
(
	movieID VARCHAR(10),
	genres VARCHAR(10),
	PRIMARY KEY (movieID, genres),
	FOREIGN KEY (movieID) REFERENCES movie(movieID)
);

/*------------------------------------------- series_genre DATASET-------------------------------------------------------*/
CREATE TABLE series_genre
(
	seriesID VARCHAR(10),
	genres VARCHAR(10),
	PRIMARY KEY (seriesID, genres),
	FOREIGN KEY (seriesID) REFERENCES series(seriesID)
);
