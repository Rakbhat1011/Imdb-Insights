use imdb226_1;
show variables like 'local_infile';
SET GLOBAL local_infile = 1;

/*-------------------------------------------MOVIE DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/Movie.tsv'
INTO TABLE
movie IGNORE 1 ROWS;

select count(*) from movie;
select * from movie;

/*-------------------------------------------SERIES DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/Series.tsv'
INTO TABLE
series IGNORE 1 ROWS;

select count(*) from series;
select * from series;

/*-------------------------------------------EPISODE DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/Episode.tsv' 
INTO TABLE episode 
IGNORE 1 ROWS;

select count(*) from episode;
select * from episode; 

/*-------------------------------------------EPISODE_ALIAS DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/episode_alias.tsv' 
INTO TABLE episode_alias 
IGNORE 1 ROWS;

select count(*) from episode_alias;
select * from episode_alias;

/*-------------------------------------------MOVIE_ALIAS DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/movie_alias.tsv' 
INTO TABLE movie_alias 
IGNORE 1 ROWS;

select count(*) from movie_alias;
select * from movie_alias;

/*-------------------------------------------SERIES_ALIAS DATASET-------------------------------------------------------*/
/* ---Truncate the table to delete all data instantly 
TRUNCATE TABLE series_alias;
---*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/series_alias.tsv' 
INTO TABLE series_alias 
IGNORE 1 ROWS;

select count(*) from series_alias;
select * from series_alias;

/*-------------------------------------------ACTOR DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/actor.tsv' 
INTO TABLE actor 
IGNORE 1 ROWS;

select count(*) from actor;
select * from actor;

/*-------------------------------------------DIRECTOR DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/director.tsv' 
INTO TABLE director 
IGNORE 1 ROWS;

select count(*) from director;
select * from director;

/*-------------------------------------------WRITER DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/writer.tsv' 
INTO TABLE writer 
IGNORE 1 ROWS;

select count(*) from writer;
select * from writer;

/*-------------------------------------------ACTOR_KNOWN_FOR_TITLES DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/actorknownfortitles.tsv'
INTO TABLE actor_known_for_titles 
IGNORE 1 ROWS;

select count(*) from actor_known_for_titles;
select * from actor_known_for_titles;

/*-------------------------------------------WRITER_KNOWN_FOR_TITLES DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/writerknownfortitles.tsv'
INTO TABLE writer_known_for_titles 
IGNORE 1 ROWS;

select count(*) from writer_known_for_titles;
select * from writer_known_for_titles;

/*-------------------------------------------DIRECTOR_KNOWN_FOR_TITLES DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/directorknownfortitles.tsv'
INTO TABLE director_known_for_titles 
IGNORE 1 ROWS;

select count(*) from director_known_for_titles;
select * from director_known_for_titles;

/*-------------------------------------------MOVIE_DIRECTOR_RELATION DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/movie_director_relation.tsv'
INTO TABLE movie_director_relation 
IGNORE 1 ROWS;

select count(*) from movie_director_relation;
select * from movie_director_relation;

/*-------------------------------------------MOVIE_WRITER_RELATION DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/movie_writer_relation.tsv'
INTO TABLE movie_writer_relation 
IGNORE 1 ROWS;

select count(*) from movie_writer_relation;
select * from movie_writer_relation;

/*-------------------------------------------MOVIE_ACTOR_RELATION DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/movie_actor_relation.tsv'
INTO TABLE movie_actor_relation 
IGNORE 1 ROWS;

select count(*) from movie_actor_relation;
select * from movie_actor_relation;

/*-------------------------------------------SERIES_DIRECTOR_RELATION DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/series_director_relation.tsv'
INTO TABLE series_director_relation 
IGNORE 1 ROWS;

/*---OR 
INSERT the data using series_director_relation.sql  
---*/

/* ---Truncate the table to delete all data instantly 
TRUNCATE TABLE series_director_relation;
---*/
/* --- diable before inserting ---*/
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE series_director_relation DISABLE KEYS;

/* --- enable after inserting ---*/
ALTER TABLE your_table ENABLE KEYS;
SET FOREIGN_KEY_CHECKS=1;

select count(*) from series_director_relation;
select * from series_director_relation;

/*-------------------------------------------SERIES_WRITER_RELATION DATASET-------------------------------------------------------*/
/* ---Truncate the table to delete all data instantly ---*/
TRUNCATE TABLE series_writer_relation;

LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/CSV/series_writer_relation.csv'
INTO TABLE series_writer_relation 
IGNORE 1 ROWS;

/*---OR 
INSERT the data using series_writer_relation.sql  
---*/

select count(*) from series_writer_relation;
select * from series_writer_relation;

/*-------------------------------------------SERIES_ACTOR_RELATION DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/series_actor_relation.tsv'
INTO TABLE series_actor_relation 
IGNORE 1 ROWS;

/*---OR 
INSERT the data using series_actor_relation.sql  
---*/
select count(*) from series_actor_relation;
select * from series_actor_relation;

/*-------------------------------------------movie_genre DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/movie_genre.tsv'
INTO TABLE movie_genre 
IGNORE 1 ROWS;

select count(*) from movie_genre;
select * from movie_genre;

/*------------------------------------------- series_genre DATASET-------------------------------------------------------*/
LOAD DATA LOCAL INFILE '/Users/walke/PycharmProjects/CSCI_226_Project/final_dataset/series_genre.tsv'
INTO TABLE series_genre 
IGNORE 1 ROWS;

select count(*) from series_genre;
select * from series_genre;
