# Bikeshare Trips Data Analysis

### Table of Contents

1. [Overview](#overview)
2. [Data Sources](#data-sources)
3. [Tools Used](#tools-used)
4. [Data Cleaning and Preperation](#data-cleaning-and-preparation)
5. [Exploratory Data Analysis](#exploratory-data-analysis)
6. [Data Analysis](#data-analysis)
7. [Findings](#findings)
8. [Recommendations](#recommendations)
9. [Limitations](#limitations)

---

### Overview

#### Objective

Identifying the differences in bike usage behavior of annual member riders and casual riders through analysis of trips data from 2022 to inform targeted media campaigns aimed at increasing annual member conversions among casual riders.

#### Dataset Preview

The dataset comprised of various recorded variables for individual bike-share trips. To streamline the analysis, irrelevant columns were removed, excluding data that wasn't pertinent to the study. Each trip is uniquely identified by a 'ride_id,' and essential trip details include bike type, start and end station names, station IDs, longitude and latitude coordinates, ride duration, and timestamps. Additional columns were created to facilitate analytical insights.

#### Findings

1. Member riders prefer shorter rides over long rides while casual riders prefer long rides over short rides

2. Rider count peaks in the summer months and is lowest in the winter months with member riders predominant in these winter months

3. Casual riders dominate bike usage on weekend days while member riders dominate bike usage in the week days

4. Docked bikes are only used by by casual riders

#### Techniques Employed

1. Data Acquisition
2. Data Cleaning
3. Data Organization
4. Data Transformation
5. Data Exploration
6. Data Analysis
7. Data Visualization

#### Analysis Challenge

The `ride_length` column was unexpectedly found to contain negative values. To address this issue, the `filter` function was employed to examine the rows with inaccurate data. Through this investigation, a data entry error was identified as the source of the problem. Subsequently, the affected rows were removed to ensure the integrity of the dataset.

---

### Data Sources

The dataset used in this project was sourced through Coursera and made available by Motivate International Inc from Lyft Bikes and Scooters, LLC. The data is subject to the following [License Agreement](https://divvybikes.com/data-license-agreement).

The data is hosted in an Amazon S3 bucket named 'divvy-tripdata,' and the data files can be accessed through the following link: [divvy-tripdata Bucket](https://divvy-tripdata.s3.amazonaws.com/index.html).

The bucket consists of bike trip data through different years and I selected data for the year 2022 for my analysis. 

This data is organized into 12 files, with each file corresponding to the trips that occurred in a specific month of the year. The files are named in a way that indicates the month covered (e.g., `202201-divvy-tripdata.zip` for January 2022, `202204-divvy-tripdata.zip` for April 2022, etc).

The provided links lead to the index of the 'divvy-tripdata' bucket, where you can explore and download the individual data files. Please adhere to the [Data License Agreement](https://divvybikes.com/data-license-agreement) when using the dataset.

---

### Tools Used

* `Google sheets` to preview one of the datasets to get familiar with the data
  
*  `SQL` for data integration, transformation, exploration, and preparation for visualization with functions including combining datasets, creating a table with extracted date/time components, filtering, sorting, aggregation, utilizing CTEs. Review the [SQL Script](https://github.com/Lamerck/Bike-Share-Project/blob/main/sqlscript-for-bikes.sql)

* `R` for data importing, binding cleaning, and manipulation, involving the addition and removal of columns, calculating various statistics e.g., average ride length, exploring patterns (e.g., popular routes, days, hours), and finally, creating insightful visualizations. Take a look at the [R Script](https://github.com/Lamerck/Bike-Share-Project/blob/main/rscript-for-bikes.R)

* `Tableau` for visualization of statistics, trends, and relationships in the data. Check out the vizzes and an interactive dashboard in my [workbook](https://public.tableau.com/app/profile/lamerck.kavuma/viz/Book1_17042325813910/Dashboard1)
---
### Data Cleaning and Preparation

* **Importing Data:**

Data sets from individual months were imported into R using the `read.csv` function.

* **Combining Data Sets Vertically:**

In SQL, 3 individual data sets were combined using the `UNION ALL` operation

In R, 12 individual monthly data sets were combined into one comprehensive data set using `rbind`

* **Saving Data:**

In SQL, the combined data set was saved automatically with the use of the `CREATE TABLE` statement as (tripdataq001)

The combined data set in R was saved with the `saveRDS` as an RDS file (tripdatav1.rds)

* **Adding New Columns:**

Using the `CREATE TABLE` statement and the `EXTRACT` in SQL to create a new table (tripdataq002) with new columns having extracted data date _(start_date)_, time _(start_time)_, and day of the week _(weekday)_ components from the _started_at_ column.

Also, created a `Common Table Expression` (CTE) named (SplitDateTime) to store the split date and time components temporarily

In R, Using the `mutate` function, seven new columns were added to the data set, including _ride_length_, _ride_length_group_, _starting_month_, _starting_date_, _starting_hour_, _day_of_week_, and _route_. These columns were added to add more meaningful information for the analysis

* **Removing Redundant Columns:**

In R, the `select` function was used to remove redundant columns from the combined data set like _start_station_name_, _end_station_name_, _start_station_id_, _end_station_id_, _start_lat_, _start_lng_, _end_lat_, and _end_lng_.

* **Handling Negative Ride Lengths:**

Used the `CTAS` statement and the `Filter` function to Create a Table with only rows having a ride length that is greater than or equal to zero

In R, rows with negative ride lengths were identified using `arrange` and `filter` functions, and the data set was subset to have only rows with ride lengths above or equal to zero.

* **Saving Cleaned Data:**

The cleaned data set (tripdatav3) was saved with the `saveRDS` as an RDS file (tripdatav3.rds)

Review the code for [SQL](https://github.com/Lamerck/Bike-Share-Project/blob/main/sqlscript-for-bikes.sql) and [R](https://github.com/Lamerck/Bike-Share-Project/blob/main/rscript-for-bikes.R)

---

### Exploratory Data Analysis

SQL was used at first to study and understand the statistics, patterns, relationships, and trends in the data at a smaller scale to inform hypotheses. The following are some of the tasks that were examined;

1. Examining central tendencies _(Mean, Mode)_ and identifying outliers
   
2. Exploring the distribution of ride lengths and investigating patterns like ride count across the days of the week
   
3. Aggregating statistics to key summary statistics like average ride length and road use percentage
   
4. Generating additional metrics that could provide more context into the data set like day of the week and starting hour

6. Comparing the differences in variable patterns between Casual and Member riders like the most popular time of the day to catch a ride for member riders and then casual riders

**Take a look at the [SQL Script](https://github.com/Lamerck/Bike-Share-Project/blob/main/sqlscript-for-bikes.sql) for the EDA task**

With R, several exploratory data analysis tasks were performed and on a much larger dat set with data for a full year including;

1. Calculating and analyzing ride counts in general and then for each rider type

2. Analyzing ride lengths by calculating the average ride length and analyzing average ride lengths for member and casual riders
  
3. Exploring popular routes and identifying the the most popular route overall and then for each rider type

4. Analyzing usage by time like peak hours, popular days of the week, popular months for overall rides and then for each rider type

5. Exploring bike type popularity among each rider type

6. Investigating unique routes that were used only once

**Take a look at this [R Script](https://github.com/Lamerck/Bike-Share-Project/blob/main/rscript-for-bikes.R) for EDA tasks**

---

### Data Analysis

For our primary objective mentioned [here](#objective) above, these are some of the diagonistic SQL queries and R Code that informed our research task.

* **SQL**

Calculating the total number of rides and then the total for each rider type seperately
```SQL
SELECT COUNT(*)
FROM `case-studies-01.tripdata.tripdataq001`
```
```SQL
SELECT
  COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS total_member,
  COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS total_casual
FROM `case-studies-01.tripdata.tripdataq001`
```

Calculating average ride length for all rides, and then for each rider type seperately
```SQL
SELECT AVG(ride_length) AS overall_avg_length
FROM `case-studies-01.tripdata.tripdataq001`
```
```SQL
SELECT member_casual, AVG(ride_length) AS member_avg_length
FROM `case-studies-01.tripdata.tripdataq001`
GROUP BY member_casual
```

Rider type that is more common in the long rides that is, above average ride lengths
```SQL
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
```

The bicycle type that is most commonly used and rider preference
```SQL
SELECT rideable_type, COUNT(*) AS frequency_of_use
FROM `case-studies-01.tripdata.tripdataq001`
WHERE rideable_type IS NOT NULL
GROUP BY rideable_type
```

**Note:** *eb* for *Electric Bikes*, *cb* for *Classic Bikes*, and *db* for *Docked Bikes*

```SQL
SELECT member_casual, COUNT(*) AS eb_frequency_of_use
FROM `case-studies-01.tripdata.tripdataq001`
WHERE rideable_type = 'electric_bike'
GROUP BY member_casual
```
```SQL
SELECT member_casual, COUNT(*) AS cb_frequency_of_use
FROM `case-studies-01.tripdata.tripdataq001`
WHERE rideable_type = 'classic_bike'
GROUP BY member_casual
```
```SQL
SELECT member_casual, COUNT(*) AS db_frequency_of_use
FROM `case-studies-01.tripdata.tripdataq001`
WHERE rideable_type = 'docked_bike'
GROUP BY member_casual
```

Creating a new table with new columns having the starting date, starting time, and day of the week
```SQL
CREATE TABLE tripdata.tripdataq002 AS
SELECT *, DATE(started_at) AS start_date, TIME(started_at) AS start_time, FORMAT_DATE('%A', started_at) AS weekday
FROM tripdata.tripdataq001
```

Most popular days of the week
```SQL
SELECT weekday, COUNT(*) rides_per_day
FROM `case-studies-01.tripdata.tripdataq002`
GROUP BY weekday
ORDER BY rides_per_day DESC
```
```SQL
SELECT weekday, COUNT(*) rides_per_day
FROM `case-studies-01.tripdata.tripdataq002`
WHERE member_casual = 'member'
GROUP BY weekday
ORDER BY rides_per_day DESC
```
```SQL
SELECT weekday, COUNT(*) rides_per_day
FROM `case-studies-01.tripdata.tripdataq002`
WHERE member_casual = 'casual'
GROUP BY weekday
ORDER BY rides_per_day DESC
```

* **R**

Adding seven new columns
```r
tripdatav2 <- tripdatav1 %>% 
  mutate(
    ride_length = as.numeric(difftime(ended_at, started_at, units = "secs")), ##ride_length will be in seconds
    ride_length_group = ntile(ride_length, 20),
    starting_date = as.Date(started_at),
    starting_month = month(started_at, label = TRUE),
    day_of_week = wday(started_at, label = TRUE),
    starting_hour = hour(started_at),
    route = paste(substr(start_station_name, 1, 3), substr(end_station_name, 1, 3), sep = "")
  )
```

Calculating the total number of rides in 2022 followed by total number rides per rider type
```r
nrow(tripdatav3)
```
```r
member_rides <- filter(tripdatav3, member_casual == 'member')
nrow(member_rides) 
```
```r
casual_rides <- filter(tripdatav3, member_casual == 'casual')
nrow(casual_rides)
```

Calculating the overall average ride length and then for each rider type
```r
total_length <- sum(tripdatav3$ride_length)
avg_ride_length <- total_length/total_rides
```
```r
rides_by_members <- nrow(member_rides)
member_total_length <- sum(filter(tripdatav3, member_casual == 'member')$ride_length)
avg_member_length <- member_total_length/rides_by_members
```
```r
rides_by_casuals <- nrow(casual_rides)
casual_total_length <- sum(filter(tripdatav3, member_casual == 'casual')$ride_length)
avg_casual_length <- casual_total_length/rides_by_casuals
```
Visualizing the relationship between rider count per rider type with increasing riding distance
```r
ggplot(tripdatav3, aes(x = as.factor(ride_length_group), fill = member_casual)) +
  geom_bar(position = "dodge") +
  labs(x = "Ride Length Sets", y = "Rider Count") +
  ggtitle("Rider Counts in Percentile Groups of Ride Lengths") +
  scale_fill_manual(values = c("royalblue", "limegreen"), labels = c("Casual Riders", "Member Riders")) +
  theme_minimal()
```

![Rider Count with increasing Ridle Length](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/cacfac1a-67dc-459b-bd50-a48b1df627be)

Most popular day of the week overall, then for each rider type
```r
popular_days <- sort(-table(tripdatav3$day_of_week))
head(popular_days)
```
```r
members_popular_days <- sort(-table(filter(tripdatav3, member_casual == 'member')$day_of_week))
tibble(members_popular_days)
```
```r
casuals_popular_days <- sort(-table(filter(tripdatav3, member_casual == 'casual')$day_of_week))
tibble(casuals_popular_days)
```

Visualizing the trend in Rider Count per Rider Type throghout the week

```r
ggplot(tripdatav3, aes(x = day_of_week, group = member_casual, color = member_casual)) +
  geom_line(stat = "count") +
  labs(x = "Day of the Week", y = "Total User Count",
       title = "Trend in Rider Type Count Throughout the Week") +
  scale_x_discrete(labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")) +
  scale_color_manual(values = c("royalblue", "limegreen"), labels = c("Casual Riders", "Member Riders")) +
  theme_minimal()
```
 ![Bike usage throughout the week](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/b8700be1-b108-4583-ae1f-29801680612e)

Most popular hour of the day in general, then for each rider type
```r
popular_hours <- sort(-table(tripdatav3$starting_hour))
head(popular_hours)
```
```r
members_popular_hours <- sort(-table(filter(tripdatav3, member_casual == 'member')$starting_hour))
head(members_popular_hours)
```
```r
casuals_popular_hours <- sort(-table(filter(tripdatav3, member_casual == 'casual')$starting_hour))
head(casuals_popular_hours)
```

Most popular month in general, then for each rider type
```r
popular_months <- sort(-table(tripdatav3$starting_month))
head(popular_months)
```
```r
members_popular_months <- sort(-table(filter(tripdatav3, member_casual == 'member')$starting_month))
head(members_popular_months)
```
Visualizing the trend in daily member rides throughout the year

```r
ggplot(subset(tripdatav3, member_casual == "member"), aes(x = starting_date)) +
  geom_bar(position = "dodge", fill = "limegreen") +
  labs(x = "Date", y = "Member Rider Count", title = "Daily Count of Member Riders") +
  theme_minimal()
```
![Member count throughout 2022](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/66e7749b-0bff-4515-9b8c-fa73fd49d2f7)

```r
casuals_popular_months <- sort(-table(filter(tripdatav3, member_casual == 'casual')$starting_month))
head(casuals_popular_months)
```

Visuaiizing the trend in casual memebr rides throughout the year

```r
ggplot(subset(tripdatav3, member_casual == "casual"), aes(x = starting_date)) +
  geom_bar(position = "dodge", fill = "royalblue") +
  labs(x = "Date", y = "Casual Rider Count", title = "Daily Count of Casual Riders") +
  theme_minimal()
```

![Casual rider count throughout 2022](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/a2ec2203-a104-446b-98bf-93dcb56ad57a)

Bike type popularity
```r
bicycle_type_freq <- sort(-table(tripdatav3$rideable_type))
head(bicycle_type_freq)
```

Bike usage among member riders

**Note:** *eb* for *Electric Bikes*, *cb* for *Classic Bikes*, and *db* for *Docked Bikes*

```r
members_eb_freq <- filter(filter(tripdatav3, rideable_type == 'electric_bike'), member_casual == 'member')
nrow(members_eb_freq)
```
```r
members_cb_freq <- filter(filter(tripdatav3, rideable_type == 'classic_bike'), member_casual == 'member')
nrow(members_cb_freq)
```
```r
members_db_freq <- filter(filter(tripdatav3, rideable_type == 'docked_bike'), member_casual == 'member')
nrow(members_db_freq)
```

Then for casual riders
```r
casuals_eb_freq <- filter(filter(tripdatav3, rideable_type == 'electric_bike'), member_casual == 'casual')
nrow(casuals_eb_freq)
```
```r
casuals_cb_freq <- filter(filter(tripdatav3, rideable_type == 'classic_bike'), member_casual == 'casual')
nrow(casuals_cb_freq)
```
```r
casuals_db_freq <- filter(filter(tripdatav3, rideable_type == 'docked_bike'), member_casual == 'casual')
nrow(casuals_db_freq)
```

Visualizing the count of riders of every bike type for each rider type
```r
ggplot(tripdatav3, aes(x = rideable_type)) +
  geom_bar() +
  labs(x = "Rideable Type", y = "Total User Count",
       title = "Total User Count by Rideable Type for Members and Casual Riders") +
  facet_wrap(~member_casual, scales = "free_y", ncol = 1) +
  theme_minimal()
```

![User count in every rideable type](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/496c5659-d41f-4f70-abe1-6de324f96c7d)


For more R code exploring and analysing this data, check out this rmd [file](https://github.com/Lamerck/Bike-Share-Project/blob/main/Bikeshare_trips_project.pdf) 

---

### Findings

The following are the top 3 differences in usage of bikes by annual member riders and casual memebr riders;

* Member riders prefer shorter rides over long rides while casual riders prefer long rides over short rides

![Ride Length Vs Rider Count](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/00f241e2-51bd-4308-b2dd-c939ed0f306c)

* Casual riders dominate bike usage on weekend days while member riders dominate bike usage in the week days

![Week Days Popularity (1)](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/7978e2a3-51c9-43de-82db-644ced36017d)

* Docked bikes are only used by by casual riders

![Bike Type Usage (4)](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/6da0e344-d024-4987-8271-83b04dd9b958)

It is also important to note that;

* Rider count peaks in the summer months and is lowest in the winter months with member riders predominant in these winter months as shown below

![Monthly Usage (3)](https://github.com/Lamerck/Bike-Share-Project/assets/155752655/d5a7cf46-4d1b-49cb-8283-4e2b4852b798)


**These visualizations were built with [Tableau](https://public.tableau.com/app/profile/lamerck.kavuma/viz/Book1_17042325813910/Dashboard1)**

---

### Recommendations

Based on the analysis and findings, to increase the conversion rates of casual riders into memebr riders,

1. Double down on marketing campaigns in the peak months of May,  June, July, August, and September
2. Incentivize long weekend rides with offers becasue casual riders are more active on weekends and they refer long rides
3. Introduce weekday promotional offers for casual riders to increase their bike hire in the non-peak days
4. Extend exclusive membership offers to docked bike users who are casual riders

View this [report](https://github.com/Lamerck/Bike-Share-Project/blob/main/BIKESHARE%20TRIPS'%20FINDINGS%20PRESENTATION.pdf) for more information about the recommendations

---

### Limitations

* The dataset provides information about bike rides, but additional context about the locations, weather conditions, marketing data, or specific events could enhance the analysis and interpretation.

* The analysis is based on data from the year 2022. Trends observed might be influenced by external factors, and the findings might not be applicable to different timeframes.

* There's need for use of more in-depth statistical tests and machine learning techniques for in-depth insights because most of the analysis focused on descriptive, diagonistic, and exploratory aspects.
