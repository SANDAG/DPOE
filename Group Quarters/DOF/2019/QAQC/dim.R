# file comparison code between a xls source file and raw upload SQL Table

#Reading in packages
pkgTest <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dep = TRUE)
  sapply(pkg, require, character.only = TRUE)
 }
packages <- c("data.table", "ggplot2", "scales", "sqldf", "rstudioapi", "RODBC", "reshape2", 
              "stringr","tidyverse", "plyr", "readxl", "readr", "reshape")
pkgTest(packages)

####Obtain Source Data####
# Source data, make sure to use double backslashes for the file path
file <- "R:\\DPOE\\DOF Group Quarters\\2019\\QAQC\\Raw\\dim.xlsx"
#Source_data <- read.xlsx(file, sheetIndex = 1, header = TRUE) #header doesn't work
Source_data <- read_excel(file, sheet = 1)

#Check data type
str(Source_data)

#Convert to data frame
Source_data <- data.frame(Source_data)

#To see column names in source data
colnames(Source_data)

#Rename source data. Make sure order is the same as in the database.
names(Source_data) <- c("facility_name","facility_type",
                        "facility_owner","jurisdiction","placecode")

####Obtain SQL Database Data####
# SQL data
source("R:/DPOE/DOF Group Quarters/2019/QAQC/readSQL.R")
sql_query = getSQL("R:/DPOE/DOF Group Quarters/2019/QAQC/SQL Query/dim.sql")
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#Check data types
str(database_data)
str(Source_data)

# convert first two columns format in database_data from numeric to integer
Source_data[,5:5] <- sapply(Source_data[,5:5],as.integer)

# replace cell value ("Balance of County")in Source_data to "Unincorporated"
index <- Source_data$"jurisdiction" == "Balance of County"
Source_data$"jurisdiction"[index] <- "Unincorporated"

# remove certain string in cell value (" city") in Source_data to ""
Source_data$"jurisdiction" <- gsub(" city","",Source_data$"jurisdiction")

# compare files 
all(Source_data == database_data) #check cell values only
all.equal(Source_data,database_data) #check cell values and data types and will return the conflicted cells
identical(Source_data,database_data) #check cell values and data types
