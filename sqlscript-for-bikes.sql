--United data from the first three months into one table called tripdataq1 to explore the data
--Eliminating the empty rows in the ride_id column
SELECT * 
FROM `case-studies-01.tripdata.tripdataq1`
WHERE ride_id IS NOT NULL

--Sorting the data based on date
SELECT *
FROM `case-studies-01.tripdata.tripdataq1`
WHERE ride_id IS NOT NULL AND started_at IS NOT NULL
ORDER BY started_at

--Testing out adding 2 new columns to the table
CREATE TABLE tripdata.tripdataq01 AS
SELECT *, 0 AS ride_length, 1 AS route
FROM tripdata.tripdataq1

--Reviewing results
SELECT * FROM `case-studies-01.tripdata.tripdataq01` LIMIT 1000

--Dropping table tridataq01 to replace it with a more refined one
DROP TABLE tripdata.tripdataq01

--Creating a new permanent table with two new columns for ride_length and route from data that has been cleaned and sorted
CREATE TABLE tripdata.tripdataq01 AS
SELECT *, 
TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS ride_length, 
CONCAT(SUBSTR(start_station_name, 1, 3), SUBSTR(end_station_name, 1, 3)) AS route
FROM (
  SELECT *
FROM `case-studies-01.tripdata.tripdataq1`
WHERE ride_id IS NOT NULL AND started_at IS NOT NULL
ORDER BY started_at
)

--Reviewing results
SELECT *
FROM `case-studies-01.tripdata.tripdataq01`
ORDER BY started_at

--Exploring summary statistics
SELECT *
FROM `case-studies-01.tripdata.tripdataq01`
WHERE ride_length IS NULL
--All rows have ride length implying that for all rides, start time and end time were recorded

--Calculating the total number of rides and then the total for each ride type seperately.
SELECT COUNT(member_casual)
FROM `case-studies-01.tripdata.tripdataq01`
--OR
SELECT COUNT(*)
FROM `case-studies-01.tripdata.tripdataq01`
--The total number of rides in this data set is 503421

SELECT
  COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS total_member,
  COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS total_casual
FROM `case-studies-01.tripdata.tripdataq01`
--The total number of rides by members is 373603 and total number of rides by the casual 129818


--Calculating for the total length of the rides and then total length of rides for each ride type
SELECT SUM(ride_length) AS overall_ride_length
FROM `case-studies-01.tripdata.tripdataq01`
--Total length of the rides is 509059094seconds

SELECT member_casual, SUM(ride_length) AS member_type_ride_length
FROM `case-studies-01.tripdata.tripdataq01`
GROUP BY member_casual
--In total, casual rides took 244004661seconds while member rides took 265054433seconds



--Let's check out average ride_length. First for all rides, then the casual rides and the member rides seperately.
SELECT AVG(ride_length) AS overall_avg_length
FROM `case-studies-01.tripdata.tripdataq01`
--Overall average length is 1011.2seconds (16.85minutes)

SELECT member_casual, AVG(ride_length) AS member_avg_length
FROM `case-studies-01.tripdata.tripdataq01`
GROUP BY member_casual
--On average, casual rides take 1879.6seconds (31.33minutes) while member rides take 709.45seconds (11.8minutes)


--Checking the data for duplicates and outliers
SELECT DISTINCT(ride_id)
FROM `case-studies-01.tripdata.tripdataq01`
--There are no buplicates

SELECT MAX(ride_length) AS highest_ride_length, MIN(ride_length) AS shortest_ride_length
FROM `case-studies-01.tripdata.tripdataq01`
--Oops just detected a negative ride_length which is an outlier. It could indicate that the formula for calculating for the ride duration was the wrong, or, time at some points was not entered correctly. Let's review the data by sorting it based on ride_length

SELECT *
FROM `case-studies-01.tripdata.tripdataq01`
ORDER BY ride_length
--There are two ride_length durations in negatives and for both cases, ended_at time is abnormally earlier than started_at time. This could be a data entry error. This validates the formula.

--Ascertaining the number of members whose ended_at time is the same as started_at time
SELECT *
FROM `case-studies-01.tripdata.tripdataq01`
WHERE ride_length = 0
--There are 26 rides with a ride duration of 0

SELECT member_casual, COUNT(ride_length) AS zero_ride_length
FROM `case-studies-01.tripdata.tripdataq01`
WHERE ride_length = 0
GROUP BY member_casual
--15 member rides were cancelled while 11 casual rides were cancelled

--Deleting the two rows with negative duration of the ride
--This is achieved through creating a new table with the two rows excluded.
CREATE TABLE tripdata.tripdataq001 AS
SELECT *
FROM `case-studies-01.tripdata.tripdataq01`
WHERE ride_length >=0


--Repeating the exploration for summary statistics but on the new table (tripdataq001)
--Calculating the total number of rides and then the total for each ride type seperately.
SELECT COUNT(*)
FROM `case-studies-01.tripdata.tripdataq001`


SELECT DISTINCT(ride_id)
FROM `case-studies-01.tripdata.tripdataq001`


--The total number of rides in this data set is 503419

SELECT
  COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS total_member,
  COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS total_casual
FROM `case-studies-01.tripdata.tripdataq001`
--The total number of rides by members is 373603 and total number of rides by the casual 129816(Which is two rides less and so, the two removed rows were for casual rides)
--Member rides are 2.9 times more than the casual rides.

--Calculating for the total length of the rides and then total length of rides for each ride type
SELECT SUM(ride_length) AS overall_ride_length
FROM `case-studies-01.tripdata.tripdataq001`
--Total length of the rides is 509059457 seconds

SELECT member_casual, SUM(ride_length) AS member_type_ride_length
FROM `case-studies-01.tripdata.tripdataq001`
GROUP BY member_casual
--In total, casual rides took 244005024 seconds while member rides took 265054433 seconds


--Calculating average ride_length for all rides, and then the casual rides and the member rides seperately.
SELECT AVG(ride_length) AS overall_avg_length
FROM `case-studies-01.tripdata.tripdataq001`
--Overall average length is 1011.2seconds (16.85minutes-Which is the same as the original value)

SELECT member_casual, AVG(ride_length) AS member_avg_length
FROM `case-studies-01.tripdata.tripdataq001`
GROUP BY member_casual
--On average, casual rides take 1879.6seconds (31.33minutes) while member rides take 709.45seconds (11.8minutes)


--Checking the data for outliers
SELECT MAX(ride_length) AS highest_ride_length, MIN(ride_length) AS shortest_ride_length
FROM `case-studies-01.tripdata.tripdataq001`
--Shortest ride_length is 0 seconds while longest ride_length is 2061244 seconds

SELECT *
FROM `case-studies-01.tripdata.tripdataq001`
WHERE ride_length > 1011
--There are 114983 rides with above average duration of the ride (22.8%) of the rides.

--Which ride type is most common in the above average ride durations? Let's use a CTE
WITH above_avg_rides AS (
  SELECT
    member_casual,
    COUNT(*) AS above_threshold_count
  FROM 
    `case-studies-01.tripdata.tripdataq001`
  WHERE 
    ride_length > 1011
  GROUP BY
    member_casual
),
total_rides AS (
  SELECT
    member_casual,
    COUNT(*) AS total_count
  FROM 
    `case-studies-01.tripdata.tripdataq001`
  GROUP BY
    member_casual
)
SELECT
  a.member_casual,
  a.above_threshold_count,
  t.total_count,
  ROUND(a.above_threshold_count / t.total_count * 100, 2) AS percentage_above_threshold
FROM 
  above_avg_rides a
LEFT JOIN 
  total_rides t
ON 
  a.member_casual = t.member_casual
--Casual riders are two times (38.66%) more likely to take longer rides than the member riders(17.34%).

--Calculating the most common ride length and route
SELECT ride_length AS mode_value, COUNT(*) AS frequency
FROM `case-studies-01.tripdata.tripdataq001`
GROUP BY ride_length
ORDER BY COUNT(*) DESC
LIMIT 5;
--The most common duration of the ride is 260 seconds at 766 times 

SELECT route AS mode_value, COUNT(*) AS frequency
FROM `case-studies-01.tripdata.tripdataq001`
GROUP BY route
ORDER BY COUNT(*) DESC
LIMIT 5;
--The most common route at 118132 has no start and end point followed by ClaCla at 5687 times 

--Which ride type is more common in the mode values above?
SELECT member_casual AS ride_type, COUNT(*) AS frequency
FROM `case-studies-01.tripdata.tripdataq001`
WHERE ride_length = 260
GROUP BY member_casual
--The most common ride type around the modal mark is the member ride

SELECT member_casual, COUNT(*) AS frequency
FROM `case-studies-01.tripdata.tripdataq001`
WHERE route IS NULL
GROUP BY member_casual
--Member rides are 2.4 times more likely to not record a starting and end point than the casual rides. 


--Which ride is more common on the 4 most used and named routes?
SELECT member_casual, COUNT(*) AS times_on_route
FROM `case-studies-01.tripdata.tripdataq001`
WHERE route = 'EllEll' OR route = 'ClaCla' OR route = 'SheShe' OR route = 'WelWel'
GROUP BY member_casual
ORDER BY COUNT(*) DESC
--Member rides are 3.4 times more common on the most used routes


--Which route is most used by casual rides?
SELECT route, COUNT(*) AS casual_most_used_route
FROM `case-studies-01.tripdata.tripdataq001`
WHERE member_casual = 'casual' AND route IS NOT NULL
GROUP BY route
ORDER BY COUNT(*) DESC
--ClaCla, MicMic, DuSDuS, SheShe and WelWel are the most used routes by casual rides



--Which route has the highest percentage of casual rides?
WITH casual_rides AS (
  SELECT route, COUNT(*) AS casual_users
  FROM `case-studies-01.tripdata.tripdataq001`
  WHERE member_casual = 'casual' AND route IS NOT NULL
  GROUP BY route
  ORDER BY COUNT(*) DESC
),
total_rides AS (
  SELECT route, COUNT(*) AS route_users
  FROM `case-studies-01.tripdata.tripdataq001`
  GROUP BY route
  ORDER BY COUNT(*) DESC
)
SELECT c.route, c.casual_users, t.route_users, ROUND(c.casual_users/t.route_users * 100, 2) AS percentage_casual_users
FROM casual_rides c
LEFT JOIN total_rides t 
ON c.route = t.route
WHERE t.route_users > 270
--For routes that had an average of 3 rides per day; StrStr, DuSStr, StrDuS, MilMil, and DuSDuS had the higher percentage (62.8%+) of casual rides


--Which route has the highest percentage of member rides?
WITH member_rides AS (
  SELECT route, COUNT(*) AS member_users
  FROM `case-studies-01.tripdata.tripdataq001`
  WHERE member_casual = 'member' AND route IS NOT NULL
  GROUP BY route
  ORDER BY COUNT(*) DESC
),
total_rides AS (
  SELECT route, COUNT(*) AS route_users
  FROM `case-studies-01.tripdata.tripdataq001`
  GROUP BY route
  ORDER BY COUNT(*) DESC
)
SELECT m.route, m.member_users, t.route_users, ROUND(m.member_users/t.route_users * 100, 2) AS percentage_member_users
FROM member_rides AS m
LEFT JOIN total_rides AS t 
ON m.route = t.route
WHERE t.route_users > 270
--For routes that had an average of 3 rides per day; WolLoo, MayHai, LarKin, LooHai, and HaiLoo had the higher percentage (94.7%+) of member rides


--How many routes where used once? And by which ride, mostly?
SELECT COUNT(*)
FROM (
SELECT route, COUNT(*) route_count
FROM `case-studies-01.tripdata.tripdataq001`
WHERE route IS NOT NULL
GROUP BY route
HAVING COUNT(*) = 1
)
--There were 2746 routes that were used once

SELECT COUNT(*)
FROM (
SELECT route, member_casual, COUNT(*) route_count
FROM `case-studies-01.tripdata.tripdataq001`
WHERE route IS NOT NULL AND (member_casual = 'member' OR member_casual = 'casual') 
AND NOT (member_casual = 'member' AND member_casual = 'casual')
GROUP BY route, member_casual
HAVING COUNT(*) = 1
)
WHERE member_casual = 'member'
--Query doesn't work

--Which ride is most likely to use a route once?
SELECT ROUND(COUNT(*)/373603*100,2) AS percentage_member_single_rides
FROM (
SELECT route, COUNT(*) route_count
FROM `case-studies-01.tripdata.tripdataq001`
WHERE route IS NOT NULL AND member_casual = 'member'
GROUP BY route
HAVING COUNT(*) = 1
)
--There were 2485 member rides that used a route once (0.67%)

SELECT ROUND(COUNT(*)/129816*100,2) AS percentage_member_single_rides
FROM (
SELECT route, COUNT(*) route_count
FROM `case-studies-01.tripdata.tripdataq001`
WHERE route IS NOT NULL AND member_casual = 'casual'
GROUP BY route
HAVING COUNT(*) = 1
)
--There were 2503 casual rides that used a route once (1,93%)


--What is the number of average users per day?
WITH SplitDateTime AS (
  SELECT
    started_at,
    DATE(started_at) AS start_date,
    TIME(started_at) AS start_time
  FROM
    `case-studies-01.tripdata.tripdataq001`
)
--SELECT COUNT(*)
--FROM (
--SELECT DISTINCT(start_date)
--FROM SplitDateTime
--)--The data was recorded for a period of 90 days (503419/90=5594)
--SELECT MAX(rides_per_day), MIN(rides_per_day)
--FROM (
--SELECT start_date, COUNT(*) AS rides_per_day
--FROM SplitDateTime
--GROUP BY start_date
--ORDER BY start_date
--)--Highest number of rides for a day were 19374 and the lowest were 703
SELECT start_date, rides_per_day
FROM(
SELECT start_date, COUNT(*) AS rides_per_day
FROM SplitDateTime
GROUP BY start_date
ORDER BY start_date
)
WHERE rides_per_day = 19374 OR rides_per_day = 703
--Feb 02nd, 2022 had the fewest number of rides while March 21st, 2022 had the highest number of rides

--What ride dominated on 2022-02-02 and 2022-03-21?
WITH SplitDateTime AS (
  SELECT
    started_at,
    member_casual,
    DATE(started_at) AS start_date,
    TIME(started_at) AS start_time
  FROM
    `case-studies-01.tripdata.tripdataq001`
)
--SELECT member_casual, COUNT(*)
--FROM SplitDateTime
--WHERE start_date = '2022-02-02'
--GROUP BY member_casual
--Casual rides were 127, member rides were 576
SELECT member_casual, COUNT(*)
FROM SplitDateTime
WHERE start_date = '2022-03-21'
GROUP BY member_casual
--Casual rides were 8177 while member rides were 11197



--Which bicycle type is most commonly used and by which ride?
SELECT rideable_type, COUNT(*) AS frequency_of_use
FROM `case-studies-01.tripdata.tripdataq001`
WHERE rideable_type IS NOT NULL
GROUP BY rideable_type
--There are three rideable_types; electric bikes were used 243820 times, classic bikes were used 248919 times, and docked bikes were used 10680 times.


SELECT member_casual, COUNT(*) AS eb_frequency_of_use
FROM `case-studies-01.tripdata.tripdataq001`
WHERE rideable_type = 'electric_bike'
GROUP BY member_casual
--Casual rides used electric bikes 68669 times while member rides used electric bikes 175151 times


SELECT member_casual, COUNT(*) AS cb_frequency_of_use
FROM `case-studies-01.tripdata.tripdataq001`
WHERE rideable_type = 'classic_bike'
GROUP BY member_casual
--Casual rides used electric bikes 50467 times while member rides used electric bikes 198452 times


SELECT member_casual, COUNT(*) AS db_frequency_of_use
FROM `case-studies-01.tripdata.tripdataq001`
WHERE rideable_type = 'docked_bike'
GROUP BY member_casual
--Casual rides used docked bikes 10680 times while member rides did not use them


--Let's create another permanent table but with the 3 new columns; one with start date, start time, and day of the week
CREATE TABLE tripdata.tripdataq002 AS
SELECT *, DATE(started_at) AS start_date, TIME(started_at) AS start_time, FORMAT_DATE('%A', started_at) AS weekday
FROM tripdata.tripdataq001


SELECT *
FROM `case-studies-01.tripdata.tripdataq002`


--What day of the week is most used? What day of the week is most used for each ride?
SELECT weekday, COUNT(*) rides_per_day
FROM `case-studies-01.tripdata.tripdataq002`
GROUP BY weekday
ORDER BY rides_per_day DESC
---Wednesday has the highest number of users


SELECT weekday, COUNT(*) rides_per_day
FROM `case-studies-01.tripdata.tripdataq002`
WHERE member_casual = 'member'
GROUP BY weekday
ORDER BY rides_per_day DESC
--Tuesday and Wednesday are the most popular days for member rides


SELECT weekday, COUNT(*) rides_per_day
FROM `case-studies-01.tripdata.tripdataq002`
WHERE member_casual = 'casual'
GROUP BY weekday
ORDER BY rides_per_day DESC
--Sunday and Saturday are the most popular days for casual rides


What is the most popular time of the day to catch a ride? for members and then casuals?
WITH timeofday AS (
  SELECT 
    *,
    EXTRACT(HOUR FROM started_at) starthour
  FROM
    `case-studies-01.tripdata.tripdataq002`
)
--SELECT starthour, COUNT(*) frequency_per_hour
--FROM timeofday
--GROUP BY starthour
--ORDER BY frequency_per_hour DESC
--17HOURS, 16HOURS, 18HOURS, 15HOURS, AND 14HOURS are the most popuular hours of the day
--3HORS, 4HOURS, 2HOURS, 1HOUR, AND 0HOURS are the least popular hours of the day.
--SELECT starthour, COUNT(*) frequency_per_hour
--FROM timeofday
--WHERE member_casual = 'member'
--GROUP BY starthour
--ORDER BY frequency_per_hour DESC
--17HOURS, 16HOURS, 18HOURS, 15HOURS, and 8HOURS are the most popular hours for member rides
--3HOURS, 4HOURS, 2HOURS, 1HOUR, AND 0HOURS are the least popular hours for casual rides
SELECT starthour, COUNT(*) frequency_per_hour
FROM timeofday
WHERE member_casual = 'casual'
GROUP BY starthour
ORDER BY frequency_per_hour DESC
--17HOURS, 16HOURS, 15HOURS, 14HOURS, and 18HOURS are the most popular hours for member rides
--4HOURS, 3HOURS, 5HOURS, 2HOUR, AND 1HOURS are the least popular hours for casual rides


--Let's add the start hour column to our table
DROP TABLE tripdata.tripdataq002
CREATE TABLE tripdata.tripdataq002 AS
SELECT 
    *,
    DATE(started_at) AS start_date,
    TIME(started_at) AS start_time,
    EXTRACT(HOUR FROM started_at) AS start_hour,
    FORMAT_DATE('%A', started_at) AS weekday
FROM tripdata.tripdataq001

--MORE INFO
--I need to export the most recent file (tripdataq002) to use it in Tableau to visualize the relationships and trends I have observed from the data that answer the business question. But, directly exporting a file (100MB+) out of BigQuery to be stored locally is not something supported and for my free version of BigQuery, I can't export it to my drive as well.

