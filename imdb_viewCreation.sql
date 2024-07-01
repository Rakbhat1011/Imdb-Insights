use imdb226_1;
show variables like 'local_infile';
SET GLOBAL local_infile = 1;

-- 1. View for Movies of a Specific Actor (Brigitte Bardot):
CREATE VIEW movies_of_brigitte_bardot AS
SELECT * FROM movie
WHERE movieID IN (
SELECT knownForTitles FROM actor_known_for_titles WHERE actorID = (
SELECT actorID FROM actor WHERE primaryName = 'Brigitte Bardot'));

-- 2.View for Movies Directed by Each Director Sorted by Genre:
CREATE VIEW movies_directed_by_genre AS
SELECT distinct d.primaryName, mg.genres, count(m.movieID)
FROM movie m, director d, movie_director_relation md, movie_genre mg
WHERE md.movieID = m.movieID
AND mg.movieID = m.movieID
AND md.directorID = d.directorID
GROUP BY d.primaryName,mg.genres
ORDER BY d.primaryName, count(m.movieID) DESC
LIMIT 200;

-- 3.View for Top Ten Rated Movies:
CREATE VIEW top_ten_rated_movies AS
SELECT * FROM(
SELECT m.primaryTitle, m.averageRating FROM movie AS m
UNION
SELECT s.primaryTitle, s.averageRating FROM series AS s ) AS tt
ORDER BY tt.averageRating DESC LIMIT 10;

-- 4.Top Ten Rated Movies with Actors, Writers, and Directors:
CREATE VIEW view_top_ten_movies_actors_writers_directors AS
SELECT m.primaryTitle, m.averageRating, a.primaryName, ma.characters, d.primaryName
FROM movie m, actor a, movie_actor_relation ma, movie_director_relation md, director d
WHERE m.movieID = ma.movieID
AND a.actorID = ma.actorID
AND d.directorID = md.directorID
AND md.movieID = m.movieID
ORDER BY m.averageRating DESC LIMIT 10;

-- 5.Top Movie Actors and Characters:
CREATE VIEW view_top_movie_actors_characters AS
SELECT m.primaryTitle, m.averageRating, a.primaryName, ma.Characters
FROM movie m
INNER JOIN movie_actor_relation ma ON m.movieID = ma.movieID
INNER JOIN actor a ON a.actorID = ma.actorID
ORDER BY m.averageRating DESC LIMIT 10;

-- 6. Top 10 Movies by Region:
CREATE VIEW view_top_10_movies_by_region AS
SELECT m.primaryTitle, ma.region, ma.title, m.averageRating
FROM movie m
INNER JOIN movie_alias ma ON m.movieID = ma.movieID
WHERE ma.region IS NOT NULL
ORDER BY m.averageRating DESC LIMIT 10;

-- 7.First 50 Series Writers and Genres:
CREATE VIEW view_first_50_series_writers_genres AS
SELECT DISTINCT w.primaryName AS WriterName, s.primaryTitle, sg.genres
FROM writer w, series_writer_relation sw, series s, series_genre sg
WHERE w.writerID = sw.writerID
AND s.seriesID = sw.seriesID
AND s.seriesID = sg.seriesID
AND w.writerID NOT IN (
SELECT w1.writerID
FROM writer w1, movie_writer_relation mw
WHERE w1.writerID = mw.writerID)
LIMIT 50;

-- 8.Count of Movies in Each Genre Over 20000:
CREATE VIEW view_count_movies_each_genre_over_20000 AS
SELECT DISTINCT genres, COUNT(movieID)
FROM movie_genre
GROUP BY genres
HAVING COUNT(movieID) > 20000;

-- 9.Series and Actor Names Where Actors Acted in a Movie:
CREATE VIEW view_series_actor_names_acted_in_movie AS
SELECT a.primaryName AS ActorName, s.primaryTitle AS SeriesName
FROM series s, actor a, series_actor_relation sa
WHERE s.seriesID = sa.seriesID
AND a.actorID = sa.actorID
AND a.actorID IN (
SELECT DISTINCT a.actorID
FROM movie m1, actor a1, movie_actor_relation ma
WHERE m1.movieID = ma.movieID
AND a1.actorID = ma.actorID) LIMIT 10;

-- 10. Movies with Ratings and Votes:
CREATE VIEW view_movies_ratings_votes AS
SELECT primaryTitle, averageRating, numVotes FROM movie;

-- 11. Series Started in Specific Year (e.g., 2020):
CREATE VIEW view_series_started_2020 AS
SELECT primaryTitle FROM series WHERE startYear = 2020;

-- 12.Episodes of a Particular Series:
CREATE VIEW view_episodes_of_series AS
SELECT primaryTitle FROM episode WHERE seriesID = 'tt0989125';

-- 13.Actors with Known Titles:
CREATE VIEW view_actors_known_titles AS
SELECT a.primaryName, m.primaryTitle
FROM actor a
JOIN actor_known_for_titles akt ON a.actorID = akt.actorID
JOIN movie m ON akt.knownForTitles = m.movieID;

-- 14. Total Number of Movies Released Each Year:
CREATE VIEW view_movies_released_each_year AS
SELECT releaseYear, COUNT(*) as totalMovies
FROM movie
GROUP BY releaseYear;

-- 15.Movies by Specific Director:
CREATE VIEW view_movies_by_director AS
    SELECT 
        m.primaryTitle
    FROM
        movie m
            JOIN
        movie_director_relation mdr ON m.movieID = mdr.movieID
            JOIN
        director d ON mdr.directorID = d.directorID
    WHERE
        d.primaryName = 'John Gielgud';

-- 16.Writers with More Than 5 Movies:
CREATE VIEW view_writers_more_than_5_movies AS
SELECT w.primaryName, COUNT(*) as totalMovies
FROM writer w
JOIN movie_writer_relation mwr ON w.writerID = mwr.writerID
GROUP BY w.primaryName
HAVING COUNT(*) > 5;

-- 17.Series and Their Genres:
CREATE VIEW view_series_genres AS
    SELECT 
        s.primaryTitle, sg.genres
    FROM
        series s
            JOIN
        series_genre sg ON s.seriesID = sg.seriesID;

-- 18. Episodes in a Particular Season of a Series:
CREATE VIEW view_episodes_in_season AS
SELECT primaryTitle
FROM episode
WHERE seriesID = 'tt0041038' AND seasonNumber = 1;

-- 19. Movies and Series with a Specific Actor:
CREATE VIEW view_movies_series_specific_actor AS
SELECT m.primaryTitle AS MovieTitle, s.primaryTitle AS SeriesTitle
FROM actor a
LEFT JOIN movie m ON a.actorID = m.movieID
LEFT JOIN series s ON a.actorID = s.seriesID
WHERE a.primaryName = 'Sebi John';






