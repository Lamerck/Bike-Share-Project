# Used for the large data set where data of all 12 months is joined 
# Preparing my R environment
library(tidyverse)
library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)


# Importing the Data
tripdata01 <- read.csv("~/Cycling trip datasets/tripdata01.csv")
tripdata02 <- read.csv("~/Cycling trip datasets/tripdata02.csv")
tripdata03 <- read.csv("~/Cycling trip datasets/tripdata03.csv")
tripdata04 <- read.csv("~/Cycling trip datasets/tripdata04.csv")
tripdata05 <- read.csv("~/Cycling trip datasets/tripdata05.csv")
tripdata06 <- read.csv("~/Cycling trip datasets/tripdata06.csv")
tripdata07 <- read.csv("~/Cycling trip datasets/tripdata07.csv")
tripdata08 <- read.csv("~/Cycling trip datasets/tripdata08.csv")
tripdata09 <- read.csv("~/Cycling trip datasets/tripdata09.csv")
tripdata10 <- read.csv("~/Cycling trip datasets/tripdata10.csv")
tripdata11 <- read.csv("~/Cycling trip datasets/tripdata11.csv")
tripdata12 <- read.csv("~/Cycling trip datasets/tripdata12.csv")

# Combining the data sets
tripdatav1 <- rbind(tripdata01, tripdata02, tripdata03, tripdata04, tripdata05,
                    tripdata06, tripdata07, tripdata08, tripdata09, tripdata10,
                    tripdata11, tripdata12)

# Saving the tripdatav1 data set in R
saveRDS(tripdatav1, file = "tripdatav1.rds")
str(tripdatav1)

## Data Manipulation and Cleaning

# Adding seven new columns and removing eight redundant columns
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

str(tripdatav2)
View(tripdatav2)

tripdatav2_clean <-tripdatav2 %>% 
  select(ride_id, rideable_type, started_at, ended_at, member_casual, ride_length,
         ride_length_group, starting_month, starting_date, starting_hour, 
         day_of_week, route)
summary(tripdatav2_clean)

tripdatav2_sort <- arrange(tripdatav2_clean, ride_length)
View(tripdatav2_sort)
negative_ride_lengths <- filter(tripdatav2_sort, ride_length < 0)
nrow(negative_ride_lengths) # 100 rows
View(negative_ride_lengths) # start date is greater than end date

# Removing rows with negative ride lengths
tripdatav3 <- tripdatav2_clean[tripdatav2_clean$ride_length >= 0, ]

# Saving the cleaned data set
saveRDS(tripdatav3, file = "tripdatav3.rds")

# Loading the clean data set
tripdatav3 <- readRDS("tripdatav3.rds")
View(tripdatav3)


## Data Exploration

# Total number of rides in 2022
total_rides <- nrow(tripdatav3)

# Total number of rides by members and casuals
member_rides <- filter(tripdatav3, member_casual == 'member')
rides_by_members <- nrow(member_rides) 

casual_rides <- filter(tripdatav3, member_casual == 'casual')
rides_by_casuals <- nrow(casual_rides)

# Average rides per day for the entire year
total_days <- n_distinct(tripdatav3$starting_date) 
average_daily_rides <- total_rides/total_days # = 15527.72

# Average ride length in general, then for the members and then the casuals
total_length <- sum(tripdatav3$ride_length)
avg_ride_length <- total_length/total_rides
View(avg_ride_length) # = 1166.8seconds

# For members
member_total_length <- sum(filter(tripdatav3, member_casual == 'member')$ride_length)
avg_member_length <- member_total_length/rides_by_members
View(avg_member_length) # = 762.8 seconds for member rides


# For casuals
casual_total_length <- sum(filter(tripdatav3, member_casual == 'casual')$ride_length)
avg_casual_length <- casual_total_length/rides_by_casuals
View(avg_casual_length) # = 1748.7 seconds for casual rides


# Most popular ride length in general, then for the members and then the casuals
mode_ride_length <- sort(-table(tripdatav3$ride_length))
View(mode_ride_length) # = 323 seconds, is the most popular ride_length appearing 6360 times

# For members
mode_ride_length_members <- sort(-table(tripdatav3$ride_length[tripdatav3$member_casual == 'member']))
View(mode_ride_length_members) # = 274 seconds is the most popular ride_length among members appearing 4568 times

# For casuals
mode_ride_length_casuals <- sort(-table(tripdatav3$ride_length[tripdatav3$member_casual == 'casual']))
View(mode_ride_length_casuals) # = 431 seconds is the most popular ride length among casuals appearing 2100 times


# Most popular route in general then for members and then for casuals
mode_route <- sort(-table(tripdatav3$route))
View(mode_route) # = No route (427441), ClaCla (68866), Cla (67235), are the most popular routes

# For members
mode_route_members <- sort(-table(filter(tripdatav3, member_casual == 'member')$route))
View(mode_route_members) # = No route (234991), ClaCla (39883), Cla (39855) are the most popular route for member rides

# For casuals
mode_route_casuals <- sort(-table(filter(tripdatav3, member_casual == 'casual')$route))
View(mode_route_casuals) # = No route (192450), ClaCla (28983), Cla (27380) are the most popular route for casual rides


# Most popular day of the week in general then for members and then for casuals
popular_days <- sort(-table(tripdatav3$day_of_week))
View(popular_days) # = Sat (916459), Thu (841582), Fri (801781) are the most popular days generally

# For members
members_popular_days <- sort(-table(filter(tripdatav3, member_casual == 'member')$day_of_week))
View(members_popular_days) # = Thu (532255), Wed (523867), Tue (518618) are the most popular days for member rides

# For casuals
casuals_popular_days <- sort(-table(filter(tripdatav3, member_casual == 'casual')$day_of_week))
View(casuals_popular_days) # = Sat (473185), Sun (389011), Fri(334698) are the most popular days for casual rides


# Most popular hour of the day in general then for members and then for casuals
popular_hours <- sort(-table(tripdatav3$starting_hour))
View(popular_hours) # = 17 (569587), 16 (489489), 18 (582170) are the most popular hours generally

# For members
members_popular_hours <- sort(-table(filter(tripdatav3, member_casual == 'member')$starting_hour))
View(members_popular_hours) # = 17 (349432), 16 (291777), 18 (284618) are the most popular hours for member rides

# For casuals
casuals_popular_hours <- sort(-table(filter(tripdatav3, member_casual == 'casual')$starting_hour))
View(casuals_popular_hours) # = 17 (220155), 16 (197712), 18 (197552) are the most popular hours for casual rides


# Most popular month in general then for members and then for casuals
popular_months <- sort(-table(tripdatav3$starting_month))
View(popular_months) # = Jul (823472), Aug (785917), Jun (769192) are the most popular months generally

# For members
members_popular_months <- sort(-table(filter(tripdatav3, member_casual == 'member')$starting_month))
View(members_popular_months) # = Aug (427000), Jul (417426), Sept (404636) are the most popular months for member rides

# For casuals
casuals_popular_months <- sort(-table(filter(tripdatav3, member_casual == 'casual')$starting_month))
View(casuals_popular_months) # = Jul (406046), Jun (369044), Aug (358917) are the most popular months for casual rides


# Which bicycle type is most commonly used and by which ride, member or casual?
bicycle_type_freq <- sort(-table(tripdatav3$rideable_type))
View(bicycle_type_freq) # = electric_bike (2888957), classic_bike (2601186), and docked_bike (177474)


# How many members use these different bikes?
# Electric bikes
members_eb_freq <- filter(filter(tripdatav3, rideable_type == 'electric_bike'), member_casual == 'member')
members_eb_frequency <- nrow(members_eb_freq)
View(members_eb_frequency) # = 1635897 electric bike member rides

# Classic bikes
members_cb_freq <- filter(filter(tripdatav3, rideable_type == 'classic_bike'), member_casual == 'member')
members_cb_frequency <- nrow(members_cb_freq)
View(members_cb_frequency) # = 1709743 classic bike member rides

# Docked bikes
members_db_freq <- filter(filter(tripdatav3, rideable_type == 'docked_bike'), member_casual == 'member')
members_db_frequency <- nrow(members_db_freq)
View(members_db_frequency) # =  0 docked bike member rides


# How many casuals use these different bikes?
# Electric bikes
casuals_eb_freq <- filter(filter(tripdatav3, rideable_type == 'electric_bike'), member_casual == 'casual')
casuals_eb_frequency <- nrow(casuals_eb_freq)
View(casuals_eb_frequency) # = 1253060 electric bike casual rides

# Classic_bikes
casuals_cb_freq <- filter(filter(tripdatav3, rideable_type == 'classic_bike'), member_casual == 'casual')
casuals_cb_frequency <- nrow(casuals_cb_freq)
View(casuals_cb_frequency) # = 891443 classic bike casual rides

# Docked_bikes
casuals_db_freq <- filter(filter(tripdatav3, rideable_type == 'docked_bike'), member_casual == 'casual')
casuals_db_frequency <- nrow(casuals_db_freq)
View(casuals_db_frequency) # =  177474 docked bike casual rides


# What ride (member or casual) is more likely to use one off route
# Calculate the count of unique routes for each ride type
unique_routes_per_type <- tripdatav3 %>%
  group_by(member_casual) %>%
  summarise(unique_routes = n_distinct(route))
View(unique_routes_per_type)

# Calculate the total number of rides for each ride type
total_rides_per_type <- tripdatav3 %>%
  count(member_casual)
View(total_rides_per_type)

# Joining the counts to get the proportions
unique_route_proportion <- unique_routes_per_type %>%
  inner_join(total_rides_per_type, by = "member_casual") %>%
  mutate(proportion_one_off = (unique_routes / n) * 100)
View(unique_route_proportion) ## = 0.9% of casual rides and 0.6% of member rides


# On which day of the week are casual riders most likely to use a certain rideable type?
rideable_type_per_day <- tripdatav3 %>% 
  filter(member_casual == 'casual') %>% 
  group_by (rideable_type, day_of_week) %>%
  summarise(day_count = n())
View(rideable_type_per_day)


# Trends in day count for docked bikes
db_count_per_day <- rideable_type_per_day %>%
  filter(rideable_type == 'docked_bike') %>% 
  arrange(desc(day_count))
View(db_count_per_day)


# Trends in day count for docked bikes
eb_count_per_day <- rideable_type_per_day %>%
  filter(rideable_type == 'electric_bike') %>% 
  arrange(desc(day_count))
View(eb_count_per_day)


# Trends in day count for docked bikes
cb_count_per_day <- rideable_type_per_day %>%
  filter(rideable_type == 'classic_bike') %>% 
  arrange(desc(day_count))
View(cb_count_per_day)


# During which hour are casual riders most likely to use a certain rideable type?
rideable_type_per_hour <- tripdatav3 %>% 
  filter(member_casual == 'casual') %>% 
  group_by (rideable_type, starting_hour) %>%
  summarise(hour_count = n())
View(rideable_type_per_hour)


# Trend in hour count for docked bikes
db_count_per_hour <- rideable_type_per_hour %>% 
  filter(rideable_type == 'docked_bike') %>% 
  arrange(desc(hour_count))
View(db_count_per_hour) # Peaks at 15HRS, 16HRS and 14Hrs


# Trend in hour count for electric bikes
eb_count_per_hour <- rideable_type_per_hour %>% 
  filter(rideable_type == 'electric_bike') %>% 
  arrange(desc(hour_count))
View(eb_count_per_hour) 


# Trend in hour count for classic bikes
cb_count_per_hour <- rideable_type_per_hour %>% 
  filter(rideable_type == 'classic_bike') %>% 
  arrange(desc(hour_count))
View(cb_count_per_hour)


# Relationship between casual rider frequency with increasing ride length(Using the bins-ride_length_group)
# Plotting the relationship between grouped ride lengths and rider counts using a bar graph
ggplot(tripdatav3, aes(x = as.factor(ride_length_group), fill = member_casual)) +
  geom_bar(position = "dodge") +
  labs(x = "Ride Length Sets", y = "Rider Count") +
  ggtitle("Rider Counts in Percentile Groups of Ride Lengths") +
  scale_fill_manual(values = c("royalblue", "limegreen"), labels = c("Casual Riders", "Member Riders")) +
  theme_minimal()


# Visualizing the trend in total rider count per type throughout the week by plotting a line graph total users per day of the week against day of the week
ggplot(tripdatav3, aes(x = day_of_week, group = member_casual, color = member_casual)) +
  geom_line(stat = "count") +
  labs(x = "Day of the Week", y = "Total User Count",
       title = "Trend in Rider Type Count Throughout the Week") +
  scale_x_discrete(labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")) +
  scale_color_manual(values = c("royalblue", "limegreen"), labels = c("Casual Riders", "Member Riders")) +
  theme_minimal()


# Visualizing the count of riders of every bike type for each rider type by plotting a bar graph of rider count against rideable type by members and casuals.
ggplot(tripdatav3, aes(x = rideable_type)) +
  geom_bar() +
  labs(x = "Rideable Type", y = "Total User Count",
       title = "Total User Count by Rideable Type for Members and Casual Riders") +
  facet_wrap(~member_casual, scales = "free_y", ncol = 1) +
  theme_minimal()

# Exporting the modified data set as a CSV file to use in Tableau
write.csv(tripdatav3, file = "C:/Users/Lamarck/Documents/tripdatav3.csv", row.names = FALSE)
