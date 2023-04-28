# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(RMariaDB)
library(tidyverse)

#Data Import and Cleaning
conn <- dbConnect(MariaDB(),
                  user="huan2384",
                  password=key_get("latis-mysql","huan2384"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = 'mysql_hotel_umn_20220728_interm.cer'
)
# Get the list of tables in the cla_tntlab database
databases_df <- dbGetQuery(conn, "SHOW DATABASES;")
dbExecute(conn, "USE cla_tntlab;") 

# Fetch the data from mySQL
week13_tbl <- dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_8960_table;")
# save data to the data folder
write_csv(week13_tbl, "../data/week13.csv")
# Read data from the data folder
week13<-read_csv("../data/week13.csv", show_col_types = FALSE)


# Display the total number of managers
n_managers <- sum(week13$manager_hire == "Y")
cat("Total number of managers:", n_managers, "\n")

# Display the total number of unique managers
n_unique_managers <- length(unique(week13$employee_id[week13$manager_hire == "Y"]))
cat("Total number of unique managers:", n_unique_managers, "\n")

# Display a summary of the number of managers split by location, but only include those who were not originally hired as managers
non_managers <- week13 %>% 
  filter(manager_hire == "N") %>% 
  group_by(city) %>% 
  summarize(n_non_managers = n())
non_managers

# Display the average and standard deviation of number of years of employment split by performance level 
years_by_performance <- week13 %>% 
  group_by(performance_group) %>% 
  summarize(avg_years = mean(yrs_employed), sd_years = sd(yrs_employed))
years_by_performance

# Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.
top_managers <- week13 %>% 
  filter(manager_hire == "Y") %>%
  arrange(city, desc(test_score)) %>%
  group_by(city) %>%
  mutate(rank = dense_rank(desc(test_score))) %>%
  filter(rank <= 3) %>%
  arrange(city, desc(test_score))
top_managers[, c("city", "employee_id", "test_score")]
