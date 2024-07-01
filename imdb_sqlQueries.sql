use imdb226_1;
show variables like 'local_infile';
SET GLOBAL local_infile = 1;

-- 1) All details for the movie for the particular actor which is also known for other titles:
SELECT * FROM movie
WHERE movieID IN (
SELECT knownForTitles FROM actor_known_for_titles WHERE actorID = (
SELECT actorID FROM actor WHERE primaryName = 'Brigitte Bardot'));

-- 2) No. of movies directed by the director and in which genre alphabetically by name and highest count as per genre? 
SELECT distinct d.primaryName, mg.genres, count(m.movieID)
FROM movie m, director d, movie_director_relation md, movie_genre mg
WHERE md.movieID = m.movieID
AND mg.movieID = m.movieID
AND md.directorID = d.directorID
GROUP BY d.primaryName,mg.genres
ORDER BY d.primaryName, count(m.movieID) DESC
LIMIT 200;

-- 3) Top Ten rated movies:
SELECT * FROM(
SELECT m.primaryTitle, m.averageRating FROM movie AS m
UNION
SELECT s.primaryTitle, s.averageRating FROM series AS s ) AS tt
ORDER BY tt.averageRating DESC LIMIT 10;


-- 4) Top ten rated movies and their actor, writer and director.
Select m.primaryTitle, m.averageRating, a.primaryName ,
ma.characters, d.primaryName
from movie m, actor a, movie_actor_relation ma,
movie_director_relation md, director d
where m.movieID = ma.movieID
and a.actorID = ma.actorID
and d.directorID = md.directorID
and md.movieID = m.movieID
order by averageRating DESC limit 10;

-- 5) Top Movie Actors and their character name.
Select m.primaryTitle, m.averageRating, a.primaryName , ma.Characters
from movie m
INNER JOIN movie_actor_relation ma ON m.movieID = ma.movieID
INNER JOIN actor a ON a.actorID = ma.actorID
ORDER BY m.averageRating
LIMIT 10;

-- 6) Top 10 movies on basis of region
Select m.primaryTitle, ma.region, ma.title,m.averageRating
FROM movie m
INNER JOIN movie_alias ma ON m.movieID = ma.movieID
AND ma.region != 'NULL'
ORDER BY m.averageRating DESC
LIMIT 10;

-- 7) First 50 entries WriterName according to their series and their genres.
SELECT distinct w.primaryName as WriterName, s.primaryTitle, sg.genres
FROM writer w, series_writer_relation sw, series s, series_genre sg
WHERE w.writerID = sw.writerID
AND s.seriesID = sw.seriesID
AND s.seriesID = sg.seriesID
AND w.writerID NOT IN
(
SELECT w1.writerID
FROM writer w1, movie_writer_relation mw
WHERE w1.writerID = mw.writerID)
LIMIT 50;

-- 8) Count of movies in each genre, according to the highest first HAVING movies greater than 20000.
SELECT distinct genres, count(movieID)
FROM movie_genre
GROUP BY genres
HAVING count(movieID) > 20000;

-- 9) Series name and the actor name where its actor also acted in a movie:
Select a.primaryName as ActorName, s.primaryTitle as SeriesName
from Series s, actor a, series_actor_relation sa
where s.seriesID = sa.seriesID
and a.actorID = sa.actorID
and a.actorID in (Select distinct a.actorID
from movie m1, actor a1, movie_actor_relation ma
where m1.movieID = ma.movieID
and a1.actorID = ma.actorID) LIMIT 10;


-- 10.List all movies with their average ratings and number of votes:
SELECT primaryTitle, averageRating, numVotes FROM movie;

-- 11. Find all series that started in a specific year (e.g., 2020):
SELECT primaryTitle FROM series WHERE startYear = 2020;

-- 12.Retrieve all episodes of a particular series (replace 'tt0989125' with the series ID):
SELECT primaryTitle FROM episode WHERE seriesID = 'tt0989125';

-- 13. List all actors along with the titles they are known for:
SELECT a.primaryName, m.primaryTitle
FROM actor a
JOIN actor_known_for_titles akt ON a.actorID = akt.actorID
JOIN movie m ON akt.knownForTitles = m.movieID;

-- 14.Find the total number of movies released each year:
SELECT releaseYear, COUNT(*) as totalMovies
FROM movie
GROUP BY releaseYear;

-- 15. Get all movies directed by a specific director (replace 'Director_Name' with the actual name):
SELECT m.primaryTitle
FROM movie m
JOIN movie_director_relation mdr ON m.movieID = mdr.movieID
JOIN director d ON mdr.directorID = d.directorID
WHERE d.primaryName = 'John Gielgud';


-- 16.Find all writers who have worked on more than 5 movies:
SELECT w.primaryName, COUNT(*) as totalMovies
FROM writer w
JOIN movie_writer_relation mwr ON w.writerID = mwr.writerID
GROUP BY w.primaryName
HAVING COUNT(*) > 5;


-- 17. List series along with their genres:
SELECT s.primaryTitle, sg.genres
FROM series s
JOIN series_genre sg ON s.seriesID = sg.seriesID;

-- 18.Get all episodes in a particular season of a series (replace 'Series_ID' and 'Season_Number' with actual values):
SELECT primaryTitle
FROM episode
WHERE seriesID = 'tt0041038' AND seasonNumber = 1;


-- 19.Find all movies and series where a specific actor has acted (replace 'Actor_Name' with the actual name):
SELECT m.primaryTitle AS MovieTitle, s.primaryTitle AS SeriesTitle
FROM actor a
LEFT JOIN movie m ON a.actorID = m.movieID
LEFT JOIN series s ON a.actorID = s.seriesID
WHERE a.primaryName = 'Sebi John';

-- 20.List movies and their corresponding genres:
SELECT m.primaryTitle, mg.genres
FROM movie m
JOIN movie_genre mg ON m.movieID = mg.movieID;

-- 21.Retrieve all movies released in a particular year with a rating above a certain threshold (e.g., 8.0):
SELECT primaryTitle, averageRating
FROM movie
WHERE releaseYear = 2020 AND averageRating > 8.0;

-- 22. Find all series and the number of episodes in each:
SELECT s.primaryTitle, COUNT(e.episodeID) as NumberOfEpisodes
FROM series s
JOIN episode e ON s.seriesID = e.seriesID
GROUP BY s.seriesID;

-- 23.Get the primary and original titles of all episodes for a specific series (replace 'Series_ID' with actual value):
SELECT primaryTitle, originalTitle
FROM episode
WHERE seriesID = 'tt0041038';

-- 24.List all movies along with their directors:
SELECT m.primaryTitle, d.primaryName
FROM movie m
JOIN movie_director_relation mdr ON m.movieID = mdr.movieID
JOIN director d ON mdr.directorID = d.directorID;


-- 25.Retrieve all actors who have appeared in a specific movie (replace 'Movie_Title' with actual title):
SELECT a.primaryName
FROM actor a
JOIN actor_known_for_titles akt ON a.actorID = akt.actorID
JOIN movie m ON akt.knownForTitles = m.movieID
WHERE m.primaryTitle = 'Movie_Title';


-- 26.Find series that have an average rating higher than a specified value (e.g., 7.0):
SELECT primaryTitle, averageRating
FROM series
WHERE averageRating > 7.0;


-- 27.List all writers for a particular series (replace 'Series_Title' with actual title):
SELECT w.primaryName
FROM writer w
JOIN series_writer_relation swr ON w.writerID = swr.writerID
JOIN series s ON swr.seriesID = s.seriesID
WHERE s.primaryTitle = 'Birthday Party';


-- 28.Find all actors who were born in a specific year (e.g., 1980):
SELECT primaryName
FROM actor
WHERE birthYear = 1980;

-- 29.List all actors who have a birth year but no death year (i.e., potentially still alive):
SELECT primaryName
FROM actor
WHERE birthYear IS NOT NULL AND deathYear IS NULL;

-- 30.What is a typical runtime for movies in each genre?
SELECT G.genres, T.runtimeMinutes 
FROM movie AS T, movie_genre AS G 
WHERE T.runtimeMinutes IS NOT NULL
AND T.movieID = G.movieID;

-- 31. What genres are there? How many movies are there in each genre?
SELECT G.genres, COUNT(G.genres) AS Count
FROM movie_genre AS G, movie AS T
WHERE T.movieID = G.movieID
GROUP BY genres
ORDER BY Count DESC;

-- 32. How many movies are made in each genre each year?
SELECT T.releaseYear, G.genres, COUNT(DISTINCT T.movieID) AS Number_of_movies
FROM movie AS T, movie_genre AS G
WHERE T.movieID = G.movieID
AND T.releaseYear <= 2019
GROUP BY T.releaseYear, G.genres
ORDER BY T.releaseYear DESC, G.genres ASC;


-- 33. Series with More Episodes Than the Average Number of Episodes Per Series:
SELECT s.primaryTitle, COUNT(*) as EpisodeCount
FROM series s
JOIN episode e ON s.seriesID = e.seriesID
GROUP BY s.seriesID
HAVING COUNT(*) > (SELECT AVG(EpisodeCount) FROM (SELECT COUNT(*) as EpisodeCount FROM episode GROUP BY seriesID) as subQuery);
 
-- 34. Writers with More than Average Number of Votes for Their Movies:
SELECT w.primaryName, AVG(m.numVotes) as AverageVotes
FROM writer w
JOIN movie_writer_relation mwr ON w.writerID = mwr.writerID
JOIN movie m ON mwr.movieID = m.movieID
GROUP BY w.writerID
HAVING AverageVotes > (SELECT AVG(numVotes) FROM movie);

-- 35. Actors Who Starred in Both Highest and Lowest Rated Movies:
SELECT DISTINCT a.primaryName
FROM actor a
JOIN actor_known_for_titles akft ON a.actorID = akft.actorID
JOIN (
    SELECT movieID 
    FROM movie
    WHERE averageRating = (SELECT MAX(averageRating) FROM movie)
) AS HighestRatedMovie ON akft.knownForTitles = HighestRatedMovie.movieID
JOIN (
    SELECT movieID 
    FROM movie
    WHERE averageRating = (SELECT MIN(averageRating) FROM movie)
) AS LowestRatedMovie ON akft.knownForTitles = LowestRatedMovie.movieID;


-- 36. List actors who have acted in more than 5 movies:
SELECT a.primaryName
FROM actor a
WHERE a.actorID IN (
    SELECT ak.actorID
    FROM actor_known_for_titles ak
    GROUP BY ak.actorID
    HAVING COUNT(ak.knownForTitles) > 5
);

-- 37. Find Movies with Higher Ratings than Average of their Genre:
SELECT m.primaryTitle, m.averageRating
FROM movie m
WHERE m.averageRating > (
    SELECT AVG(m2.averageRating)
    FROM movie m2
    INNER JOIN movie_genre mg ON m2.movieID = mg.movieID
    WHERE mg.genres IN (
        SELECT genres
        FROM movie_genre
        WHERE movieID = m.movieID
    )
);

-- 38. Series with Most Episodes in a Given Year:
SELECT s.primaryTitle, COUNT(e.episodeID) AS episodeCount
FROM series s
JOIN episode e ON s.seriesID = e.seriesID
WHERE e.startYear = (
    SELECT MAX(startYear)
    FROM episode
)
GROUP BY s.seriesID
HAVING COUNT(e.episodeID) = (
    SELECT MAX(episodeCount)
    FROM (
        SELECT COUNT(e2.episodeID) AS episodeCount
        FROM episode e2
        GROUP BY e2.seriesID
    ) AS maxCount
);


-- 39. Directors Who Have Worked in Both Movies and Series:
SELECT d.primaryName
FROM director d
WHERE EXISTS (
    SELECT 1
    FROM movie_director_relation mdr
    WHERE mdr.directorID = d.directorID
) AND EXISTS (
    SELECT 1
    FROM series_director_relation sdr
    WHERE sdr.directorID = d.directorID
);


-- 40. Actors with Highest Average Rating Across Their Movies:
SELECT a.primaryName, AVG(m.averageRating) AS avgRating
FROM actor a
JOIN actor_known_for_titles akft ON a.actorID = akft.actorID
JOIN movie m ON akft.knownForTitles = m.movieID
GROUP BY a.actorID
HAVING avgRating = (
    SELECT MAX(avgRating)
    FROM (
        SELECT AVG(m.averageRating) AS avgRating
        FROM actor a
        JOIN actor_known_for_titles akft ON a.actorID = akft.actorID
        JOIN movie m ON akft.knownForTitles = m.movieID
        GROUP BY a.actorID
    ) AS subquery
)
ORDER BY avgRating DESC;


-- 41. Movies with Most Diverse Genres:
SELECT m.primaryTitle, COUNT(DISTINCT mg.genres) AS genreCount
FROM movie m
JOIN movie_genre mg ON m.movieID = mg.movieID
GROUP BY m.movieID
HAVING COUNT(DISTINCT mg.genres) = (
    SELECT MAX(genreCount)
    FROM (
        SELECT COUNT(DISTINCT mg2.genres) AS genreCount
        FROM movie_genre mg2
        GROUP BY mg2.movieID
    ) AS genreCounts
);


-- 42. Series with Increasing Popularity Over Years:
SELECT s.primaryTitle
FROM series s
WHERE s.averageRating > (
    SELECT AVG(averageRating)
    FROM series
    WHERE startYear < s.startYear
);


-- 43. Actors Who Have Acted in Movies with Above Average Runtime:
SELECT DISTINCT a.primaryName
FROM actor a
JOIN actor_known_for_titles akft ON a.actorID = akft.actorID
JOIN movie m ON akft.knownForTitles = m.movieID
WHERE m.runtimeMinutes > (
    SELECT AVG(runtimeMinutes)
    FROM movie
);


-- 44. Most Common Genre Among Top Rated Movies:
SELECT mg.genres
FROM movie_genre mg
JOIN movie m ON mg.movieID = m.movieID
WHERE m.averageRating >= ALL (
    SELECT averageRating
    FROM movie
)
GROUP BY mg.genres
ORDER BY COUNT(*) DESC
LIMIT 1;


-- 45. Writers Who Have Worked in Both Highest and Lowest Rated Movies:
SELECT w.primaryName
FROM writer w
WHERE EXISTS (
    SELECT 1
    FROM movie_writer_relation mwr
    JOIN movie m ON mwr.movieID = m.movieID
    WHERE mwr.writerID = w.writerID AND m.averageRating = (
        SELECT MAX(averageRating)
        FROM movie
    )
) AND EXISTS (
    SELECT 1
    FROM movie_writer_relation mwr
    JOIN movie m ON mwr.movieID = m.movieID
    WHERE mwr.writerID = w.writerID AND m.averageRating = (
        SELECT MIN(averageRating)
        FROM movie
    )
);

-- 46.Find the average runtime of movies for each genre:
SELECT mg.genres, AVG(m.runtimeMinutes) as averageRuntime
FROM movie_genre mg
JOIN movie m ON mg.movieID = m.movieID
GROUP BY mg.genres;

-- 47. List actors who have only acted in movies with ratings above 7:
SELECT a.actorID, a.primaryName
FROM actor a
WHERE NOT EXISTS (
    SELECT 1
    FROM movie m
    JOIN actor_known_for_titles akt ON m.movieID = akt.knownForTitles
    WHERE akt.actorID = a.actorID AND m.averageRating <= 7
);

-- 48. Find directors who have directed more than 5 movies:
SELECT d.primaryName, COUNT(*) as movieCount
FROM director d
JOIN movie_director_relation mdr ON d.directorID = mdr.directorID
GROUP BY d.directorID
HAVING COUNT(*) > 5;

-- 49. Find series with more episodes than the average number of episodes per series: (same as 1)
SELECT s.seriesID, s.primaryTitle, COUNT(e.episodeID) as episodeCount
FROM series s
JOIN episode e ON s.seriesID = e.seriesID
GROUP BY s.seriesID
HAVING COUNT(e.episodeID) > (
    SELECT AVG(episodeCount) FROM (
        SELECT COUNT(episodeID) as episodeCount
        FROM episode
        GROUP BY seriesID
    ) as averageEpisodes
);

-- 50. Find actors who have acted in both movies and series: 
SELECT a.actorID, a.primaryName
FROM actor a
WHERE EXISTS (
    SELECT * FROM actor_known_for_titles akt
    JOIN movie m ON akt.knownForTitles = m.movieID
    WHERE akt.actorID = a.actorID
)
AND EXISTS (
    SELECT * FROM actor_known_for_titles akt
    JOIN series s ON akt.knownForTitles = s.seriesID
    WHERE akt.actorID = a.actorID
);

-- 51. Determine the average number of votes for movies by release year:
SELECT releaseYear, AVG(numVotes) as averageVotes
FROM movie
GROUP BY releaseYear;

-- 52. List series with a higher average rating than the average rating of all series:
SELECT s.seriesID, s.primaryTitle, s.averageRating
FROM series s
WHERE s.averageRating > (
    SELECT AVG(averageRating) FROM series
);

