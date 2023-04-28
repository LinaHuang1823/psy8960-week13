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

# Fetch the data from a table named 'my_table'
week13_tbl <- dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_8960_table;")
# save data to the data folder
write_csv(week13_tbl, "../data/week13_tbl.csv")


