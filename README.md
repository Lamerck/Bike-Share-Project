# Bikeshare Trips Data Analysis

### Table of Contents

### Project Overview

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
2. Data Organization
3. Data Cleaning
4. Data Transformation
5. Data Exploration
6. Data Analysis
7. Data Visualization

#### Challenge

The `ride_length` column was unexpectedly found to contain negative values. To address this issue, the `filter` function was employed to examine the rows with inaccurate data. Through this investigation, a data entry error was identified as the source of the problem. Subsequently, the affected rows were removed to ensure the integrity of the dataset.

### Data Sources

The dataset used in this project was sourced through Coursera and made available by Motivate International Inc from Lyft Bikes and Scooters, LLC. The data is subject to the following [License Agreement](https://divvybikes.com/data-license-agreement).

The data is hosted in an Amazon S3 bucket named 'divvy-tripdata,' and the data files can be accessed through the following link: [divvy-tripdata Bucket](https://divvy-tripdata.s3.amazonaws.com/index.html).

The bucket consists of bike trip data through different years and I selected data for the year 2022 for my analysis. 

This data is organized into 12 files, with each file corresponding to the trips that occurred in a specific month of the year. The files are named in a way that indicates the month covered (e.g., `202201-divvy-tripdata.zip` for January 2022, `202204-divvy-tripdata.zip` for April 2022, etc).

The provided links lead to the index of the 'divvy-tripdata' bucket, where you can explore and download the individual data files. Please adhere to the [Data License Agreement](https://divvybikes.com/data-license-agreement) when using the dataset.

### Tools Used

* `Google sheets` to preview one of the datasets to get familiar with the data
  
*  `SQL` for data integration, transformation, exploration, and preparation for visualization with functions including `combining datasets`, `creating a table` with extracted date/time components, `filtering`, `sorting`, `aggregation`, utilizing `CTEs`. Review the [SQL Script](https://github.com/Lamerck/Bike-Share-Project/blob/main/sqlscript-for-bikes.sql)

* `R` for data `importing`, `binding` cleaning, and manipulation, involving the addition and removal of columns, calculating various statistics e.g., average ride length, exploring patterns (e.g., popular routes, days, hours), and finally, creating insightful visualizations. Take a look at the [R Script](https://github.com/Lamerck/Bike-Share-Project/blob/main/rscript-for-bikes.R)

* Tableau for visualization of statistics, trends, and relationships in the data. Check out the vizzes and an interactive dashboard in my [workbook](https://public.tableau.com/app/profile/lamerck.kavuma/viz/Book1_17042325813910/Dashboard1)

### Data Preparation



### Data Cleaning and Manipulation

### Exploratory Data Analysis

### Data Analysis

### Findings

### Recommendations

### Limitations

### References
