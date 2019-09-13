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
#Source_data <- read.xlsx(file, sheetIndex = 4, header = TRUE) #header doesn't work
Source_data <- read_excel(file, sheet = 4)

#Check data type
str(Source_data)

#Convert to data frame
Source_data <- data.frame(Source_data)

#To see column names in source data
colnames(Source_data)

#Rename source data. Make sure order is the same as in the database.
names(Source_data) <- c("Fed/State - City","Fed/State - Facility",
                        "4/1/2010","1/1/2011","1/1/2012","1/1/2013","1/1/2014","1/1/2015","1/1/2016","1/1/2017","1/1/2018","1/1/2019")

####Obtain SQL Database Data####
# SQL data
source("R:/DPOE/DOF Group Quarters/2019/QAQC/readSQL.R")
sql_query = getSQL("R:/DPOE/DOF Group Quarters/2019/QAQC/SQL Query/staging_fed_gq.sql")
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
sql_query = getSQL("R:/DPOE/DOF Group Quarters/2019/QAQC/SQL Query/Fed_State - City.sql")
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
fact <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

####Clean Source Data####
# rename first two columns in Source_data
names(Source_data) <- c("jurisdiction","facility_name",
                          "2010","2011","2012","2013","2014","2015","2016","2017","2018","2019")

#Check data types
str(Source_data)
str(fact)

# convert first two columns format in database_data from character to factor
Source_data[,3:12] <- sapply(Source_data[,3:12],as.integer)

# replace cell value ("Balance of County")in Source_data to "Unincorporated"
index <- Source_data$jurisdiction == "Balance of County"
Source_data$jurisdiction[index] <- "Unincorporated"

#compare files 
all(Source_data == fact) #check cell values only
all.equal(Source_data,fact) #check cell values and data types and will return the conflicted cells
identical(Source_data,fact) #check cell values and data types

