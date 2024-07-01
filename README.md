# CSCI-226 Advanced Database Systems
## Final Project (Fall 2023)

## Contributors:
- Kranti Walke
- Raksha Jagadish 
- Vaideki Muralitharan




## Table of Contents:
1. [Introduction](#1_Introduction) </br>
   - [1.1 Methodology](#1_._1_Methodology) </br>
   - [1.2 Domain Description](#1_._2_Domain_Description) </br>
     
2. [Dataset Details](#2_._Dataset_Details) </br>
   - [2.1 Sources for original dataset](#2_._1_Sources_for_original_dataset)	
   - [2.2 IMDb Dataset Files](#2_._2_IMDb_Dataset_Files)
     
3. [Database Design](#3_Database_Design)
   - [3.1 Entity-Relationship (ER) Diagram](#3_._1_Entity_Relationship_ER_Diagram)
     
4. [Prepare the IMDb Data to Build the Database](#4_Prepare_the_IMDb_Data_to_Build_the_Database)
   
5. [Database Schema](#5_Database_Schema)
   - [5.1 Build MySQL Database](#5_._1_Build_MySQL_Database)
   - [5.2 Final Created Tables in Our Database](#5_._2_Final_Created_Tables_in_Our_Database)
   - [5.3 Table Includes Required Columns, Indexes, Foreign Keys, Triggers, Views](#5_._3_Table_Includes_Required_Columns_Indexes_Foreign_Keys_Triggers_Views)
   - [5.4 All the Stored Procedures Created](#5_._4_All_the_Stored_Procedures_Created)
   - [5.5 All the Views Created](#5_._5_All_the_Views_Created)

6. [Logical Schema](#6_Logical_Schema)

7. [SQL Queries](#7_SQL_Queries)

8. [Normal Forms](#8_Normal_Forms)
   - [8.1 Functional Dependencies](#8_._1_Functional_Dependencies)
   - [8.2 Multivalued Dependencies (MVDs)](#8_._2_Multivalued_Dependencies_(MVDs))
   - [8.3 Normal Form Analysis](#8_._3_Normal_Form_Analysis)

9. [Visualizations](#9_Visualizations)
   - [9.1 Visualization Using Python](#9_._1_Visualization_Using_Python)
   - [9.2 Tableau Visualizations](#9_._2_Tableau_Visualizations)

11. [Analytics/Analysis](#10_Analytics_Analysis)

12. [Summary](#11_Summary)

13. [All Dataset Links](#12_All_Dataset_Links)

14.  [Tools Used](#13_Tools_Used)


## <a name="1_Introduction"></a> 1 Introduction

In this project, we embark on a journey to construct a MySQL database leveraging the Internet Movie Database (IMDb) dataset. Comprising seven compressed tab-separated-value (*.tsv) files, this dataset is regularly updated, though our project utilizes the snapshot from October 14, 2023. The project aims to:

1. Acquire proficiency in MySQL, a prominent database management system.
2. Understand fundamental database design principles, including Entity-Relationship diagrams, logical schema creation, and the concept of database normalization.
3. Develop skills in database querying, both through direct MySQL use and indirectly via Python.
4. Employ Python for the visualization of IMDb data.

## <a name="1_._1_Methodology"></a> 1.1 Methodology

- Analyzing the IMDb dataset to grasp its structure and content.
- Designing a relational database to effectively store the IMDb data.
- Developing an Entity-Relationship (ER) diagram to model our database.
- Applying feature engineering techniques and restructuring the IMDb data using Python.
- Establishing the MySQL database.
- Populating the database with the dataset.
- Implementing SQL schema including:
   - Tables creation           
   - Key Definitions per tables
   - Referential Integrity Constraints per table
   - Triggers for each table
   - Stored Procedures for each table
   - Loading the dataset into tables
- Includes the Functional Dependencies and any Multi-Valued Dependencies for your database and state whether they are free from violations for:
   - 3rd Normal form 
   - Boyce-Codd Normal Form 
   - 4th Normal Form.
- Engaging in various SQL queries, from basic to complex, to interrogate the IMDb data.
- Creating Views for certain Queries
- Conducting in-depth data exploration and visualization using Python.
- Interesting insights within data using supporting queries.

Throughout this project, we adhere to established SQL style conventions as outlined in the SQL Style Guide, favoring underscores in attribute names over camel case, aligning with the naming conventions in the IMDb data files.


## <a name="1_._2_Domain_Description"></a> 1.2 Domain Description

The domain for the IMDb Non-Commercial Datasets is the entertainment industry, specifically the world of movies and television. IMDb (Internet Movie Database) is a widely recognized online database of films, television series, and the people involved in creating and starring in them. It serves as a comprehensive resource for information about movies, TV shows, cast and crew, user ratings, and more.

- Serves as an online repository that compiles information pertaining to the entertainment industry.
- We can find information about movies, TV shows, actors, user ratings, and other aspects of the film and television industry.
- The IMDb Non-Commercial Datasets offer a well-organized collection of data that are available for public use without commercial purposes.
- Have a wide range of details about movies and TV shows, making it a one-stop hub for all things related to the big and small screen.

IMDb's data is derived from:

-movie studios, production companies, user contributions, official press releases, and publicly available information.

## <a name="2_._Dataset_Details"></a> 2 Dataset Details	

## <a name="2_._1_Sources_for_original_dataset"></a> 2.1 Sources for Original Dataset

IMDb Non-Commercial Datasets: https://developer.imdb.com/non-commercial-datasets/

Data Location: https://datasets.imdbws.com/

## <a name="2_._2_IMDb_Dataset_Files"></a> 2.2 IMDb Dataset Files

IMDb data files :
- title.akas.tsv.gz:  (8 x 37476209)  Contains alternative titles, regions, languages, and attributes for IMDb titles.
- title.basics.tsv.gz: (9 x 10234938)  Provides fundamental details about IMDb titles, including type, primary title, and genres.
- title.crew.tsv.gz:  (3 x 10234938) Includes director and writer information for IMDb titles.
- title.episode.tsv.gz:  (4 x 7800118) Contains data about TV series episodes, including season and episode numbers.
- title.principals.tsv.gz: (6 x 58593659) Offers information about people involved in titles, their roles, and characters played.
- title.ratings.tsv.gz: (3 x 1359060) Provides user ratings and vote counts for IMDb titles.
- name.basics.tsv.gz:  (6 x 12923131) Contains details about individuals in the entertainment industry, including their 

Attributes  :

**title.akas.tsv.gz - Contains the following information for titles:**
- titleId (string) - a tconst, an alphanumeric unique identifier of the title
- ordering (integer) – a number to uniquely identify rows for a given title Id
- title (string) – the localized title
- region (string) - the region for this version of the title
- language (string) - the language of the title
- types (array) - Enumerated set of attributes for this alternative title. One or more of the following: "alternative", "dvd", "festival", "tv", "video", "working", "original", "imdbDisplay". New values may be added in the future without warning
- attributes (array) - Additional terms to describe this alternative title, not enumerated
- isOriginalTitle (boolean) – 0: not original title; 1: original title

**title.basics.tsv.gz - Contains the following information for titles:**
- tconst (string) - alphanumeric unique identifier of the title
- titleType (string) – the type / format of the title (e.g. movie, short, tvseries, tvepisode, video, etc)
- primaryTitle (string) – the more popular title / the title used by the filmmakers on promotional materials at the point of release
- originalTitle (string) - original title, in the original language
- isAdult (boolean) - 0: non-adult title; 1: adult title
- startYear (YYYY) – represents the release year of a title. In the case of TV Series, it is the series start year
- endYear (YYYY) – TV Series end year. " \N" for all other title types
- runtimeMinutes – primary runtime of the title, in minutes
- genres (string array) – includes up to three genres associated with the title

**title.crew.tsv.gz – Contains the director and writer information for all the titles in IMDb. Fields include:**
- tconst (string) - alphanumeric unique identifier of the title
- directors (array of nconsts) - director(s) of the given title
- writers (array of nconsts) – writer(s) of the given title 

**title.episode.tsv.gz – Contains the tv episode information. Fields include:**
- tconst (string) - alphanumeric identifier of episode
- parentTconst (string) - alphanumeric identifier of the parent TV Series
- seasonNumber (integer) – season number the episode belongs to
- episodeNumber (integer) – episode number of the tconst in the TV series

**title.principals.tsv.gz – Contains the principal cast/crew for titles.:**
- tconst (string) - alphanumeric unique identifier of the title
- ordering (integer) – a number to uniquely identify rows for given titleId
- nconst (string) - alphanumeric unique identifier of the name/person
- category (string) - the category of job that person was in
- job (string) - the specific job title if applicable, else '\N'
- characters (string) - the name of the character played if applicable, else '\N'

**title.ratings.tsv.gz – Contains the IMDB rating and votes information for titles**
- tconst (string) - alphanumeric unique identifier of the title
- averageRating – weighted average of all the individual user ratings
- numVotes - number of votes the title has received

**name.basics.tsv.gz – Contains the following information for names:**
- nconst (string) - alphanumeric unique identifier of the name of person
- primaryName (string) – name by which the person is most often credited
- birthYear – in YYYY format
- deathYear – in YYYY format if applicable, else '\N'
- primaryProfession (array of strings) – the top-3 professions of the person
- knownForTitles (array of tconsts) – titles for a person

## <a name="3_Database_Design"></a> 3 Database Design

## <a name="3_._1_Entity_Relationship_ER_Diagram"></a> 3.1 Entity-Relationship (ER) Diagram

The provided IMDb data is currently unnormalized. To address this, we have developed an entity-relationship diagram for our IMDb relational database, which is depicted in the following illustration.

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/62072bb2-b05a-455f-b162-674861d68ddb)




## <a name="4_Prepare_the_IMDb_Data_to_Build_the_Database"></a> 4 Prepare the IMDb Data to Build the Database

Feature Pre-processing:

The Feature Pre-processing of IMDB data is done using python. The IMDB_Feature_Pre-processing.py reads in the 7 data files and does the feature preprocessing of the IMDb data. After which, the desired set of tables are output as tab-separate-value (tsv) files.

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/4fd437e7-a881-4843-a26c-885be90c572f)

We have added all the comments in the IMDB_Feature_Pre-processing.py required to understand how we have done the feature preprocessing.

## <a name="5_Database_Schema"></a> 5 Database Schema
## <a name="5_._1_Build_MySQL_Database"></a> 5.1 Build MySQL Database
To build the IMDB MySQL database we followed the below steps:

### 5.1.1	Install MySQL workbench: 
https://dev.mysql.com/doc/workbench/en/wb-installing-windows.html

### 5.1.2	Creating a new MySQL connection: 
https://dev.mysql.com/doc/workbench/en/wb-getting-started-tutorial-create-connection.html

### 5.1.3	Create IMDb database in MySQL
a)	Create a schema and set INFILE ACCESS:

- Using imdb_TableCreation.sql
  
 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/db1417fb-73c3-41b0-9414-0f919f55362e)

b)	Use the schema to create a table in the database: 

- Using imdb_TableCreation.sql
- Includes:
   - Key Definitions
   - Referential Integrity Constraints
  
- Example: Movie dataset
  
 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/d8c5e9d0-4c2f-49cc-8495-b2687ee2f097)

c)	Create a trigger for each table operation: 

- Using imdb_TriggereCreation.sql

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/ee378623-de6c-4fd1-b8b0-a67d6ec8f250)

d)	Load the dataset in table: 

- Using imdb_LoadDataset.sql
  
 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/05668bd4-c7cc-4d8b-949b-94e88390a37a)


e)	Create Stored Procedures for certain operations like Add New Movie or Get Movie Details: 

- Using imdb_StoredProceduresCreation.sql
  
 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/830fbeff-8db4-4e8f-8bf9-1836d82c13c7)

f)	Create Views for certain Queries like movire_of_brigitte_bardot or movie_directed_by_genre: 

- Using imdb_viewCreation.sql

  ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/577ba694-581e-4880-98e6-4ef19de556de)

## <a name="5_._2_Final_Created_Tables_in_Our_Database"></a> 5.2 Final Created Tables in Our Database

- Using imdb_TableCreation.sql
  
![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/6cb1eb3c-7c53-4792-9332-cdccd528b850)

## <a name="5_._3_Table_Includes_Required_Columns_Indexes_Foreign_Keys_Triggers_Views"></a> 5.3 Table Includes Required Columns, Indexes, Foreign Keys, Triggers, Views

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/da38c3b1-b0e1-4b41-9da7-883d6e3e1ca1)

## <a name="5_._4_All_the_Stored_Procedures_Created"></a> 5.4 All the Stored Procedures Created

- Using imdb_StoredProceduresCreation.sql
  
![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/b2786f12-9e77-4581-a185-981cff9b4e28)

## <a name="5_._5_All_the_Views_Created"></a> 5.5 All the Views Created

- All the views for SQL queries created using imdb_ViewsCreation.sql

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/9f511c01-7b01-403e-ae34-9f0f35e1360d)

## <a name="6_Logical_Schema"></a> 6 Logical Schema

After creating a new schema and loading all the new datasets we have obtain the logical schema illustrated below

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/9847d097-cbfc-4390-b31b-e09e4c184e66)
![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/ca8342d7-2618-405e-a066-b834321a333c)

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/5816fc25-72f7-40c8-84b1-5b8132767d25)
![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/bf061524-7419-4a2a-a03a-4ab03d64f6b0)

## <a name="7_SQL_Queries"></a> 7 SQL Queries

After creating and loading data into the database, we can now pose queries to it. In the file imdb_sqlQueries.sql we consider more than 40 questions and answer them by querying the IMDb database. 

Some Good queries from imdb_sqlQueries.sql :

[1]	How many movies are made in each genre each year?

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/e8cae552-e270-496c-81d1-526f577a12df)

[2]	What genres are there? How many movies are there in each genre?

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/a563cf26-567f-441b-a7db-e92cb2571d0f)

[3]	What is a typical runtime for movies in each genre?

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/ce214eaf-9eb3-4e0b-8366-ba15c9260ac1)

[4]	No. of movies directed by the director and in which genre alphabetically by name and highest count as per genre?

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/d6546bab-03e3-42ef-8915-b7d816191b1f)

[5]	Top 10 movies on basis of region

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/ec1d34c8-1678-4b44-8313-f6a545bda35a)

[6]	First 50 entries WriterName according to their series and their genres.

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/182e8deb-19fb-468b-b1ce-484e48c64c55)
 
[7]	Count of movies in each genre, according to the highest first HAVING movies greater than 20000.

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/2fa02319-fe55-469c-832e-197c99434cb7)

[8]	Series with More Episodes Than the Average Number of Episodes Per Series:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/3a372064-d65c-4930-810c-12f6e05c82ac)

[9]	Writers with More than Average Number of Votes for Their Movies:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/59b541ae-56c8-41d5-965c-a1950fe913b0)

[10]	Directors Who Have Worked in Both Movies and Series:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/3537f742-7f71-4f27-9aa4-cc47134498c5)

[11]	Movies with Most Diverse Genres:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/8f627ace-ffed-4c56-b802-94201f8e1827)

[12]	Writers Who Have Worked in Both Highest and Lowest Rated Movies:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/c33945bf-a4c1-440d-a208-925c542d9866)

[13]	Find the average runtime of movies for each genre:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/2c0e177d-3d54-48a3-9d2a-906c2e8ca6c3)

[14]	Find directors who have directed more than 5 movies:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/b9cbebe0-ca5a-43d9-bab4-a0b56d5733b6)

[15]	Find actors who have acted in both movies and series:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/c9a50b14-6bc2-4719-a4b2-fd48ca0f0e82)

[16]	Determine the average number of votes for movies by release year:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/5a34ef67-699b-447c-b16a-f7b9f38804cf)

[17]	List series with a higher average rating than the average rating of all series:

 ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/ae59dac5-2274-4d36-9652-dc6164bfc5bf)

 
## <a name="8_Normal_Forms"></a> 8 Normal Forms

## <a name="8_._1_Functional_Dependencies"></a> 8.1 Functional Dependencies

A functional dependency defines how the values in one set of attributes uniquely determine the values in another set of attributes. Below are some functional dependencies defined:

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/a81ce38d-13b7-4321-b8e4-4d3a37cffb65)

## <a name="8_._2_Multivalued_Dependencies_(MVDs)"></a> 8.2 Multivalued Dependencies (MVDs)
![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/22f92f0f-5fd1-4aa8-9733-4249578f2e41)

## <a name="8_._3_Normal_Form_Analysis"></a> 8.3 Normal Form Analysis

Normal forms are a set of rules or guidelines that define the structure of a relational database. These rules are 
designed to ensure that a database is well-organized, efficient, and avoids certain types of data anomalies. The 
normalization process involves breaking down large tables into smaller, related tables, and establishing 
relationships between them.

Normal forms analysis for our database is as follows:

- movie, series, episode, actor, director, writer:
   - 1NF (First Normal Form): All attributes are atomic. Each table has its primary key as the sole determinant for other attributes satisfying the 1NF requirement.
   - 2NF (Second Normal Form): The tables are in 1NF and have composite keys, and the non-key attributes are fully functionally dependent on the primary keys. There are no partial dependencies. Therefore, the tables satisfy the 2NF requirement.
   - 3NF (Third Normal Form): The tables are in 3NF as it is already in 2NF and all the columns in the tables are functionally dependent only on the primary key. No transitive dependencies are present, where a non-key attribute depends on another non-key attribute.
   - BCNF (Boyce-Codd Normal Form): As no non-trivial dependencies are present on any candidate key, the tables are present in BCNF.
   - 4NF (Fourth Normal Form): The tables are in BCNF and there are no non-trivial multivalued dependencies.
      
- episode_alias, movie_alias, series_alias:
   - 1NF: All Attributes are atomic, and each table has its primary key (e.g., (episodeID, ordering)) as the sole determinant, meeting the 1NF requirement.
   - 2NF: The tables are in 1NF and no partial dependencies are present satisfying 2NF.
   - 3NF: The tables are in 2NF and no transitive dependencies are present satisfying the 3NF requirement.
   - BCNF: No non-trivial dependencies are present on any candidate key, ensuring a higher level of normalization.
   - 4NF: The tables are in BCNF and have no non-trivial multivalued dependencies satisfying the requirements of 4NF.

- movie_director_relation, movie_writer_relation, movie_actor_relation, series_director_relation,series_writer_relation, series_actor_relation:
   - 1NF: These tables also use composite keys and are designed to represent many-to-many relationships.Functional dependencies are directly on the composite keys.
   - 2NF: The tables are in 1NF and no partial dependencies are present satisfying 2NF.
   - 3NF: The tables are in 2NF and no transitive dependencies are present satisfying the 3NF requirement.
   -  BCNF: No non-trivial dependencies are present on any candidate key, ensuring a higher level of normalization.
   - 4NF: They are in 4NF since multivalued dependencies follow the candidate keys.

- known_for_titles Tables (actor_known_for_titles, writer_known_for_titles, director_known_for_titles,) and genre Tables ( movie_genre, series_genre):
   -  The tables are in 1NF, 2NF, 3NF and BCNF as all attributes are atomic.
   -  No partial dependencies are present.
   -  No transitive dependencies are present.
   -  No non-trivial dependencies are present on any candidate key. 
   -  There are multivalued dependencies present. 
   -  However, they exhibit multivalued dependencies based on their primary keys and no non-trivial multivalued dependencies are present. Hence, the tables are in 4NF.

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/90c6068e-06fd-4cab-8e76-6ac79efb7844)


In conclusion, all tables in our database schema are structured to meet the requirements of 3NF, BCNF, and 4NF. They are designed to minimize redundancy and ensure data integrity, particularly in handling many-to-many relationships and multivalued dependencies. This design is crucial for maintaining a normalized and efficient database.



## <a name="9_Visualizations"></a> 9 Visualizations

## <a name="9_._1_Visualization_Using_Python"></a> 9.1 Visualization Using Python

We have saved some of the queries in CSV files in a folder named QueryResultedCSV

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/6d733ac6-26ee-49f1-85c2-1df11ce7cc23)

We read these csv files using pandas library in python. 

In the notebook Visualizations.ipynb we used the query results from the IMDb database to explore and visualize the IMDb dataset using pandas and matplotlib. 

This notebook is by no means a thorough exploration of the IMDb dataset. Its purpose is to visualize the retrieved data with the pandas package. 

1)	No. of movies directed by the director and in which genre alphabetically by name and highest count as per genre?

   - (Query No. 4 From Section 7)

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/3830e950-c2e0-45fb-9519-89ed2cd0fd5b)

2)	Top 10 movies on basis of region

   - (Query No. 5 From Section 7)

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/12979753-8fc7-4d6c-af70-0f30c5ed2388)

3)	First 50 entries WriterName according to their series and their genres.

   - (Query No. 6 From Section 7)

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/8d80d586-f617-4a7b-b886-ed67b248360b) ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/c7015e71-1671-44a2-adf2-69bc888fa5ba)


4)	Count of movies in each genre, according to the highest first HAVING movies greater than 20000.

   - (Query No. 7 From Section 7)

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/b8d5f77c-3cff-48ca-971c-b5538c41d0d2)![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/2f6370bb-e7e4-4527-a1e5-3c7964c96f67)


5)	Count the occurrences of each genre per writer

   - (Query No. 7 From Section 7)

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/59bd5981-68d2-4d8b-80c5-ee6c0a14fec7)

6)	Find the total number of movies released each year:

   - Query : SELECT releaseYear, COUNT(*) as totalMovies FROM movie GROUP BY releaseYear;

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/f83245da-9ef4-4a92-89b8-473c9d300b12)


7)	List series along with their genres

   - Query: SELECT s.primaryTitle, sg.genres FROM series s JOIN series_genre sg ON s.seriesID = sg.seriesID;

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/3e0e9ca4-3a49-4901-b08b-5f234ca0ed14)![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/a89b303f-73e9-4f2d-85ac-6353df6a71fe)


8)	 Genre Distribution (series along with their genres)

   - Query: SELECT s.primaryTitle, sg.genres FROM series s JOIN series_genre sg ON s.seriesID = sg.seriesID;

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/514d9052-cfd2-45cf-8bc7-fde5db550c31)

9)	 What is a typical runtime for movies in each genre?

   - (Query No. 3 From Section 7)

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/f9812cc6-c597-47c1-afcf-0fc91717fc06)

10)	What genres are there? How many movies are there in each genre?

   - (Query No. 2 From Section 7)

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/4e3d0c49-8a19-45f4-94c2-e3e6de0688d1)

11)	How many movies are made in each genre each year?

   - (Query No. 1 From Section 7)

   ![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/69cbf519-1d3d-49bf-97ec-9e0e8af86cab)

## <a name="9_._2_Tableau_Visualizations"></a> 9.2 Tableau Visualizations

IMDB_Movie_Dataset_Insights:

https://public.tableau.com/views/IMDBINSIGHTS/IMDB_Movie_Dataset_Insights?:language=en-US&:display_count=n&:origin=viz_share_link 

![IMDB_Movie_Dataset_Insights](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/7aef8ec6-45a8-472e-87b9-17e92af6c297)

IMDB_Series_Dataset_Insights

https://public.tableau.com/views/IMDB_Series_Dataset_INsights/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link

![IMDB Series Dataset Insights](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/596814bb-5ac5-4d91-a056-ad5394df8ce4)

## <a name="10_Analytics_Analysis"></a> 10 Analytics/Analysis

As we embark on a detailed analysis of the cinematic landscape, our objective is to unravel the intricate fabric that constitutes the genre distribution across films and series, informed by regional influences and temporal trends. A lot of our focus will be on the big players like the USA and the UK to see why they're making so many hits. But it's not just about them; we'll also explore what kinds of movies and shows certain writers like to create. With some basic number-crunching and easy-to-understand charts, we'll try to make sense of how the movie business has changed from way back when movies didn't even have sound to today's big-screen blockbusters and binge-worthy series. We'll see which types of stories are told most often, how movie-making has picked up speed over the years, and how different parts of the world make their mark on what we watch.


- Top 10 movies on basis of region 
   - (Query No. 5 From Section 7 and Fig.11 from Section.9)

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/9507503e-80fc-4328-b951-268dd3bfaf3a)

- Count the occurrences of each genre per writer 
   - (Query No. 6 From Section 7 and Fig.12,13 from Section.9)

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/b4903123-a8fd-4b58-b784-6ed84a68b398)
![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/bccf5b8e-d262-428a-ab1c-e050579b1f15)


- List series along with their genres 
   - ( Fig.19,20 from section 9)
   - Query: SELECT s.primaryTitle, sg.genres FROM series s JOIN series_genre sg ON s.seriesID = sg.seriesID;

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/0411ab7b-183f-4736-983b-e3688f2696d0)


- Genre Distribution (series along with their genres) 
   - ( Fig.21 from Section 9)
   - Query: SELECT s.primaryTitle, sg.genres FROM series s JOIN series_genre sg ON s.seriesID = sg.seriesID;

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/89fe4600-3c0f-4283-beea-5d1b75058f87)


- What is a typical runtime for movies in each genre? (only consider the top 6 genres)
   - (Query No. 3 From Section 7 and Fig.22 from Section 9)

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/80a844ab-3f9d-48c8-86a5-80fa64325170)

- What genres are there? How many movies are there in each genre?
   - (Query No. 2 From Section 7 and Fig.23 from Section 9)

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/1b52c4fc-8aa8-406e-8a93-cc9fca389275)


- How many movies are made in each genre each year? (only consider the top 6 genres)
   - (Query No. 1 From Section 7 and Fig.24 from section 9)

![image](https://github.com/KrantiWalke/CSCI-226-Advanced-Database-Systems/assets/72568005/b8efb126-78e2-45bb-98ff-7fee7d259a96)



## <a name="11_Summary"></a> 11 Summary

The IMDb Non-Commercial Datasets served as the backbone for our project, providing a comprehensive and regularly updated collection of information about movies, TV series, and the individuals involved in the industry. Leveraging subsets such as title.akas, title.basics, title.crew, title.episode, title.principals, title.ratings, and name.basics, we conducted in-depth analyses to extract meaningful insights. The datasets offered a rich array of attributes, including title details, genres, crew information, ratings, and individual profiles. Our exploration unveiled trends in movie preferences, regional variations, and the impact of genres on user ratings. We traced the careers of directors and writers, identified popular titles, and examined the dynamics of TV series episodes. The IMDb dataset's daily refresh ensured that our findings remained current. This project not only showcased the power of data-driven analysis in the entertainment domain but also highlighted the versatility and depth of the IMDb Non-Commercial Datasets as valuable resources for industry professionals and enthusiasts alike.

## <a name="12_All_Dataset_Links"></a> 12 All Dataset Links

https://drive.google.com/drive/folders/1enQdPtuilduCgRHh5nHBHcLGXgpNPEPL?usp=sharing


## <a name="13_Tools_Used"></a> 13 Tools Used

- For Datasets extraction (Extract, Transform, Load (ETL)): Python (Jupyter Notebook)
- For ER Diagram: http://Draw.io
- For Feature Preprocessing: Python (Jupyter Notebook)
- For SQL Schema and Queries (MySQL database modeling) : SQL (MySQL Workbench)
- For Logical Schema: MySQL Workbench
- For Visualization and analysis: Python (Jupyter Notebook) and Tableau Public
