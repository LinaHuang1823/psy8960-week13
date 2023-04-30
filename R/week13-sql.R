# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(RMariaDB)
library(tidyverse)
library(sqldf)

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

# Fetch the data from a table named 'my_table'
week13_tbl <- dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_8960_table;")
# Read data from the data folder
week13<-read_csv("../data/week13.csv", show_col_types = FALSE)

#Analysis
#Display the total number of managers
query1 <- "SELECT COUNT(*) AS total_managers FROM week13"
manger_num <- sqldf(query1)
manger_num 

#Display the total number of unique managers
query2 <- "SELECT COUNT(DISTINCT employee_id) AS unique_managers FROM week13"
uni_manger_num <- sqldf(query2)
uni_manger_num

#Display a summary of the number of managers split by location
query3 <- "SELECT city, COUNT(*) AS num_managers FROM week13 
WHERE manager_hire = 'N' GROUP BY city"
manger_num_loc <- sqldf(query3)
manger_num_loc

#Display the average and standard deviation of number of years of employment
query4 <- "SELECT performance_group, AVG(yrs_employed) AS avg_years, 
stdev(yrs_employed) AS std_dev_years FROM week13 GROUP BY performance_group"
employment_num <- sqldf(query4)
employment_num

#Display the location and ID numbers of the top 3 managers from each location
query5 <- "SELECT city, employee_id, test_score
FROM (
  SELECT city, employee_id, test_score,
  DENSE_RANK() OVER (PARTITION BY city ORDER BY test_score DESC) AS rank
  FROM week13
) AS ranked_managers
WHERE rank <= 3
ORDER BY city ASC, test_score DESC"
top_3_managers  <- sqldf(query5)
top_3_managers 
