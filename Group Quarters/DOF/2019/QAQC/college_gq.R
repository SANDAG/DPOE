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
file <- "R:\\DPOE\\DOF Group Quarters\\2019\\QAQC\\Raw\\SanDiegoGQ2019.xls"
#Source_data <- read.xlsx(file, sheetIndex = 5, header = TRUE) #header doesn't work
Source_data <- read_excel(file, sheet = 5)

#Check data type
str(Source_data)

#Convert to data frame
Source_data <- data.frame(Source_data)

#To see column names in source data
colnames(Source_data)

#Rename source data. Make sure order is the same as in the database.
names(Source_data) <- c("College Dorms - City","College Dorm - Facility",
                        "F3","F4","F5","F6","F7","F8","F9","F10","F11","F12")

####Obtain SQL Database Data####
# SQL data
source("R:/DPOE/DOF Group Quarters/2019/QAQC/readSQL.R")
sql_query = getSQL("R:/DPOE/DOF Group Quarters/2019/QAQC/SQL Query/staging_college_gq.sql")
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

####Check Data Types and Values####
#Check data types
str(Source_data)
str(database_data)

#compare files 
all(Source_data == database_data) #check cell values only
all.equal(Source_data,database_data) #check cell values and data types and will return the conflicted cells
identical(Source_data,database_data) #check cell values and data types


##############################################################################################################################################################################################

#file comparison code between a source file and fact table
####Obtain SQL Database Data####
# SQL data
source("R:/DPOE/DOF Group Quarters/2019/QAQC/readSQL.R")
sql_query = getSQL("R:/DPOE/DOF Group Quarters/2019/QAQC/SQL Query/College Dorm - Facility.sql")
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
fact <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

####Clean Source Data####
# rename first two columns in Source_data
names(Source_data) <- c("jurisdiction","facility_name",
                        "2010","2011","2012","2013","2014","2015","2016","2017","2018","2019")

#Check data types
str(fact)
str(Source_data)

# convert columns 3-12 from numeric to integer
Source_data[,3:12] <- sapply(Source_data[,3:12],as.integer)

# remove certain string in cell value (" city") in Source_data to ""
Source_data$jurisdiction <- gsub(" city","",Source_data$jurisdiction)

#compare files 
all(Source_data == fact) #check cell values only
all.equal(Source_data,fact) #check cell values and data types and will return the conflicted cells
identical(Source_data,fact) #check cell values and data types

