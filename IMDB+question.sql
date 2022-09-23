USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



SELECT table_name,
       table_rows AS number_of_rows
FROM   information_schema.tables
WHERE  table_schema = 'imdb';  
	
-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    COUNT(*) - COUNT(id) AS nullcount_id,
    COUNT(*) - COUNT(title) AS nullcount_title,
    COUNT(*) - COUNT(year) AS nullcount_year,
    COUNT(*) - COUNT(date_published) AS nullcount_date_published,
    COUNT(*) - COUNT(duration) AS nullcount_duration,
    COUNT(*) - COUNT(country) AS nullcount_country,
    COUNT(*) - COUNT(worlwide_gross_income) AS nullcount_worlwide_gross_income,
    COUNT(*) - COUNT(languages) AS nullcount_languages,
    COUNT(*) - COUNT(production_company) AS nullcount_production_company
FROM
    movie;

-- country,worlwide_gross_income,languages and production_company columns have null values

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


 SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year;  

-- The number of movies released in each year has reduced over time

 SELECT Month(date_published) AS month_num,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num;  

-- Most movies were released in the month of March and least in December.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(id) AS movie2019_count_USAorIndia
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%India%' )
       AND year = 2019;  
-- 1059 movies were produced in the USA or India in the year 2019
	

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre AS unique_genres
FROM   genre; 

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- genre with the highest number of movies produced overall
SELECT genre,
       COUNT(movie_id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY movie_count DESC
LIMIT  1; 
#genre 'Drama' had the highest number of movies produced overall




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

 WITH movies_with_1genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(genre) = 1)
SELECT Count(movie_id) AS number_of_movies
FROM   movies_with_1genre;   

#3289 movies belong to only one genre.



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)genre


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY avg_duration DESC;    
-- Action genre has relatively longer average duration(112.88) followed by romance and crime.
-- Drama has an average duration of 106.77 




/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

 WITH genre_summary
     AS (SELECT genre,
                Count(movie_id) AS movie_count,
                RANK()OVER(
						ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_summary
WHERE  genre = 'Thriller';   


#Thriller has a rank of 3 among all the genres in terms of number of movies produced.



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings; 

    
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

 WITH top_movies
     AS (SELECT title,
                avg_rating,
                RANK()OVER(
						ORDER BY avg_rating DESC) AS movie_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id)
SELECT *
FROM   top_movies
WHERE  movie_rank <= 10;   
-- not using limit 10 here as there are 5 movies at rank 10 with same average_rating
 


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

 SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating;   
-- Number of movies with a median rating of 7 is higher compared to other values

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_rank
     AS (SELECT production_company,
                Count(movie_id) AS movie_count,
                DENSE_RANK()OVER(
								ORDER BY Count(movie_id) DESC) AS prod_company_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   prod_rank
WHERE  prod_company_rank = 1;   
#Dream Warrior Pictures and National Theatre Live have produced most number (3) of hit movies

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
       Count(g.movie_id) AS movie_count
FROM   genre AS g
       INNER JOIN ratings AS r
               ON g.movie_id = r.movie_id
       INNER JOIN movie AS m
               ON g.movie_id = m.id
WHERE  Month(date_published) = 3
       AND year = 2017
       AND m.country = 'USA'
       AND total_votes > 1000
GROUP  BY g.genre
ORDER  BY movie_count DESC;    

-- Drama has most number of movies with all the given conditions, and it is much higher than the movie count of any other genre.


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   genre AS g
       INNER JOIN ratings AS r
               ON g.movie_id = r.movie_id
       INNER JOIN movie AS m
               ON g.movie_id = m.id
WHERE  m.title REGEXP '^The'
       AND r.avg_rating > 8
GROUP  BY title
ORDER  BY avg_rating DESC;   
-- The Brighton Miracle has the highest average rating (Among movies which starts with the word
--  'The' and has avg_rating abobe 8)


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

 SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01';  
-- 361 movies were given median rating of 8 during '2018-04-01' - '2019-04-01'


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

 ( WITH german_movies_summary
     AS (SELECT languages,
                SUM(total_votes) AS Total_votes
         FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%German%'
         GROUP  BY languages) 
         
SELECT 'German'  AS LANGUAGE,
		SUM(total_votes) AS Total_votes
FROM   german_movies_summary)
UNION                                       -- Combining german and italian movies with their votes into a table.
(
WITH italian_movies_summary
     AS (SELECT languages,
                SUM(total_votes) AS Total_votes
         FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%Italian%'
         GROUP  BY languages)
         
SELECT 'Italian'   AS LANGUAGE,
       SUM(total_votes) AS Total_votes
FROM   italian_movies_summary);  
-- Answer is Yes, German movies get more votes than Italian movies

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    COUNT(*) - COUNT(name) AS name_nulls,
    COUNT(*) - COUNT(height) AS height_nulls,
    COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
    COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM
    names;  

# Except name column, all the other three columns have null values


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

 WITH top_3_genre
AS
  (
             SELECT     genre,
                        count(movie_id) AS movie_count,
                        avg_rating
             FROM       genre
							INNER JOIN ratings
								USING      (movie_id)
             WHERE      avg_rating>8
             GROUP BY   genre
             ORDER BY   count(movie_id) DESC
             LIMIT      3),
  director_summary
AS
  (
             SELECT     n.name AS director_name,
                        count(g.movie_id) AS movie_count,
                        g.genre,
                        rank()over(ORDER BY count(g.movie_id) DESC) AS director_rank
             FROM       names AS n
							INNER JOIN director_mapping  AS d
								ON n.id=d.name_id
									INNER JOIN genre AS g
										USING  (movie_id)
											INNER JOIN ratings AS r
												ON  r.movie_id=g.movie_id,
												top_3_genre
             WHERE      g.genre IN (top_3_genre.genre)
             AND        r.avg_rating>8
             GROUP BY   director_name
             ORDER BY   count(movie_id) DESC)
  SELECT director_name,
         movie_count
  FROM   director_summary
  WHERE  director_rank<=3; 
-- James Mangold, Soubin Shahir ,Joe Russo and Anthony Russo are the top directors 
-- in the top three genres whose movies have an average rating > 8


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

 SELECT name AS actor_name,
       COUNT(movie_id) AS movie_count
FROM   names AS n
       INNER JOIN role_mapping AS rm
               ON n.id = rm.name_id
       INNER JOIN ratings AS r 
				USING(movie_id)
WHERE  median_rating >= 8
       AND category = 'actor'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2;  

# Mammootty and Mohanlal are the top two actors whose movies have a median rating >= 8


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


 SELECT     production_company,
           SUM(total_votes) AS vote_count,
           RANK()over(ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM       movie  AS m
				INNER JOIN ratings  AS r
					ON m.id=r.movie_id
GROUP BY   production_company
ORDER BY   vote_count DESC
LIMIT      3; 


-- Marvel studios tops among production_companies with the highest total vote count, followed by Twentieth century fox and Warner Bros.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

 SELECT n.NAME AS actor_name,
       Sum(total_votes) AS total_votes,
       Count(r.movie_id)  AS
       movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
       actor_avg_rating,
       RANK()OVER(
				ORDER BY Round(Sum(total_votes * avg_rating)/Sum(total_votes), 2)
						DESC, Sum(total_votes) DESC) AS actor_rank
FROM   names AS n
       INNER JOIN role_mapping AS rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON m.id = rm.movie_id
       INNER JOIN ratings r
               ON rm.movie_id = r.movie_id
WHERE  country = 'India'
       AND category = 'actor'
GROUP  BY actor_name
HAVING movie_count >= 5;   

# Actor Vijay Sethupathi is at the top

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


 WITH indian_actress
     AS (SELECT n.NAME AS actress_name,
                Sum(total_votes) AS total_votes,
                Count(r.movie_id)  AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating,
                RANK()OVER(
							ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes),2)DESC,
					        Sum(total_votes) DESC) AS actress_rank
         FROM   names AS n
                INNER JOIN role_mapping AS rm
                        ON n.id = rm.name_id
                INNER JOIN movie m
                        ON m.id = rm.movie_id
                INNER JOIN ratings r
                        ON rm.movie_id = r.movie_id
         WHERE  country = 'India'
                AND category = 'actress'
                AND languages LIKE 'Hindi'
         GROUP  BY actress_name
         HAVING movie_count >= 3)
SELECT*
FROM   indian_actress
WHERE  actress_rank <= 5;  
/* There are only four actresses with the given conditions
Actress Taapsee Pannu tops the list*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title,
       avg_rating,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movie'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movie'
         ELSE 'Flop movie'
       end AS movie_rating_category
FROM   genre AS g
       INNER JOIN ratings AS r
               ON g.movie_id = r.movie_id
       INNER JOIN movie AS m
               ON g.movie_id = m.id
WHERE  g.genre = 'Thriller';  

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

 SELECT     genre,
           ROUND(AVG(duration),2) AS avg_duration,
           round(SUM(AVG(duration)) over w1, 2) AS running_total_duration,
           round(avg(avg(duration)) over w2, 2) AS moving_avg_duration
FROM       genre g
			INNER JOIN movie m
				ON g.movie_id = m.id
GROUP BY   genre 
window w1 AS (ORDER BY genre rows unbounded preceding),
		w2  AS (ORDER BY genre rows 4 preceding); 



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:




/* In the question  Q19 We have considered the top three genres as the categories with most number of movies and having average
 rating > 8 but in this question top three genres are considered only on the basis of number of movies*/
 
/* In the worlwide_gross_income column the values are not of same unit,
There are few entries with dollar symbols and some other entries in Indian rupee .
So we need to convert values into a common unit (dollar).
Using conversion values of may 27th 2022, ie 1 dollar=77.58 INR
Also the data type of the column is varchar (from information panel) which needs to be changed into decimal
- So final code will be*/
with  top_3_genre
AS
  (
		 SELECT     genre,                               #identifying top 3 Genres based on most number of movies

					count(movie_id) AS movie_count
		 FROM       genre AS g
						INNER JOIN movie AS m
							ON  g.movie_id = m.id
		 GROUP BY   genre
		 ORDER BY   count(movie_id) DESC
		 LIMIT      3 ),
  income_per_movie                                      #Gross_income of movies in  top 3 genre
AS
  (
		 SELECT     g.genre,
					year,
					title AS movie_name,
					CASE
					   WHEN worlwide_gross_income LIKE 'INR%' THEN cast(REPLACE(worlwide_gross_income, 'INR', '') AS DECIMAL(12)) / 77.58
					   WHEN worlwide_gross_income LIKE '$%' THEN cast(REPLACE(worlwide_gross_income, '$', '') AS     DECIMAL(12))
					   ELSE cast(worlwide_gross_income AS                                                            DECIMAL(12))
					end worldwide_gross_income
		 FROM       genre AS g
						INNER JOIN movie AS m
							ON  g.movie_id = m.id
		 WHERE      g.genre IN (SELECT genre
							   FROM   top_3_genre)
		 GROUP BY   movie_name
		 ORDER BY   year ),
  top_movies                                   #Ranking movies within each year based on worldwide_gross_income
AS
  (
	   SELECT   *,
				dense_rank() over(partition BY year ORDER BY worldwide_gross_income DESC) AS movie_rank
	   FROM     income_per_movie) 
select *                               # five highest-grossing movies of each year from top 3 genre
FROM   top_movies
WHERE  movie_rank <= 5;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT     production_company,
		   COUNT(movie_id) AS movie_count,
           RANK()over(ORDER BY count(movie_id) DESC) AS prod_comp_rank
FROM       movie AS m
               INNER JOIN ratings AS r
                          ON  m.id=r.movie_id
WHERE      median_rating>=8
		   AND production_company IS NOT NULL
           AND        position(',' IN languages)>0
GROUP BY   production_company
LIMIT      2; 

-- Star Cinema and Twentieth Century Fox production companies have produced highest number of mulitlingual hit movies.



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

 WITH top_actresses
     AS (SELECT NAME AS
                actress_name,
                Sum(total_votes) AS
                   total_votes,
                Count(r.movie_id)  AS
                   movie_count,
                Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS
                   actor_avg_rating,
                RANK()
                  OVER(
                    ORDER BY Count(r.movie_id) DESC) AS
                     actress_rank
         FROM   movie AS m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN role_mapping AS rm
                        ON m.id = rm.movie_id
                INNER JOIN names AS n
                        ON rm.name_id = n.id
                INNER JOIN genre AS g
                        ON m.id = g.movie_id
         WHERE  rm.category = 'actress'
                AND r.avg_rating > 8
                AND g.genre = 'Drama'
         GROUP  BY actress_name)
SELECT *
FROM   top_actresses
WHERE  actress_rank <= 3;  
/* Top actresses based on number of hit movies in drama genre:
Parvathy Thiruvothu,Susan Brown,Amanda Lawrence and Denise Gough
Not using limit here as Susan Brown,Amanda Lawrence and Denise Gough have similar values under each parameter we requested.
*/




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

                                           -- top 9 direcors
  WITH top_9_dir
AS
  (
             SELECT     name_id AS director_id,
                        name  AS director_name,
                        count(dm.movie_id) AS number_of_movies
             FROM       director_mapping   AS dm
						INNER JOIN names  AS n
								ON  dm.name_id=n.id
             GROUP BY   director_id
             ORDER BY   number_of_movies DESC
             LIMIT 9),
  movie_dates
AS
  (
             SELECT     d.name_id AS director_id,
                        n.name AS director_name,
                        d.movie_id,
                        m.date_published,
                        lead(date_published,1) over( 
									partition BY d.name_id ORDER BY date_published,d.movie_id) 
												AS next_publishing_date
             FROM       director_mapping d
						INNER JOIN movie AS m
								ON d.movie_id=m.id
									INNER JOIN names n
                                          ON  d.name_id=n.id
             WHERE      d.name_id IN
                              (SELECT director_id
						       FROM   top_9_dir) ),
  date_difference
AS
  (
         SELECT *,
                datediff(next_publishing_date,date_published) AS date_diff
         FROM   movie_dates) ,
  avg_inter_mov_days
AS
  (
           SELECT   director_id,
                    director_name,
                    round(avg(date_diff)) AS avg_inter_movie_days
           FROM     date_difference
           GROUP BY director_id)
  SELECT     dd.director_id,
             dd.director_name,
             count(dd.movie_id) AS number_of_movies,
             avg_inter_movie_days,
             round(sum(avg_rating*total_votes)/sum(total_votes), 2) AS avg_rating,
             sum(total_votes)  AS total_votes,
             round(min(avg_rating), 1) AS min_rating,
             round(max(avg_rating), 1)  AS max_rating,
             sum(duration)  AS total_duration
  FROM       date_difference dd
				INNER JOIN avg_inter_mov_days AS a
					ON a.director_id=dd.director_id
						INNER JOIN ratings AS r
							ON dd.movie_id=r.movie_id
								INNER JOIN movie AS m
										ON  dd.movie_id=m.id
  GROUP BY   director_id
  ORDER BY   number_of_movies DESC; 
  
  