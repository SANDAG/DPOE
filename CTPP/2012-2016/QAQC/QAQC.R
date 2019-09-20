#CTPP 2012-2016 QAQC

#file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()



####Obtain Source Data####
# Source data, make sure to use double backslashes for the file path
file <- "R:/DPOE/DOF Group Quarters/2019/QAQC/Raw/dim.xlsx"
Source_data <- read.xlsx(file, sheetIndex = 1, header = TRUE) #header doesn't work

#To see column names in source data
colnames(Source_data)

#Rename source data. Make sure order is the same as in the database.
names(Source_data) <- c("facility_name","type",
                        "owner","jurisdiction","placecode")

####Obtain SQL Database Data####
# SQL data
library(RODBC)

#Make sure to change year in the from clause to match the year above
source("C:/Users/ban/Downloads/readSQL.R")
sql_query1 = getSQL("C:/Users/ban/Documents/R/Workspace/SQLQuery1.sql")
sql_query2 = getSQL("C:/Users/ban/Documents/R/Workspace/SQLQuery2.sql")
sql_query3 = getSQL("C:/Users/ban/Documents/R/Workspace/SQLQuery3.sql")
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
                  
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)

odbcClose(channel)


####Clean Source Data####
# rename first two columns in database_data
names(database_data) <- c("facility_name","type",
                          "owner","jurisdiction","placecode")

# convert first two columns format in database_data from character to factor
Source_data[,1:4] <- sapply(Source_data[,1:4],as.character)
Source_data[,5:5] <- sapply(Source_data[,5:5],as.integer)

# replace cell value ("Balance of County")in Source_data to "Unincorporated"
index <- Source_data$"jurisdiction" == "Balance of County"
Source_data$"jurisdiction"[index] <- "Unincorporated"

# remove certain string in cell value (" city") in Source_data to ""
Source_data$"jurisdiction" <- gsub(" city","",Source_data$"jurisdiction")


####Check Data Types and Values####
#Check data types
str(Source_data)
str(database_data)

# compare files 
all(Source_data == database_data) #chekc cell values only
all.equal(Source_data,database_data) #chekc cell values and data types and will return the conflicted cells
identical(Source_data,database_data) #chekc cell values and data types