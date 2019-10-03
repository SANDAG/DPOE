#Teralytics 2018 Origin Destination

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

# file comparison code between a CSV source file and raw upload SQL Table

#Read in source data
source <- read.csv("R:/DPOE/Origin-Destination/Teralytics/Source/od_sandiegocounty_and_surroundings.csv",sep='|', stringsAsFactors = FALSE)

#Read in sQL query                      
channel <- odbcDriverConnect('driver={SQL Server}; server=sql2014a8; database=travel_data; trusted_connection=true')
sql_query <- 'SELECT * FROM [travel_data].[teralytics2018].[origin_destination]'          
db <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#To see column names in source data
colnames(source)
colnames(db)

#Check data types
str(source)
str(db)

#Change data types to date
#source$Month <- as.Date(source$Month, "%Y-%m")
db$Month <- format(as.Date(db$Month, format = "%Y-%m-%d"), "%Y-%m")
#db$Month <- as.Date(db$Month,  "%Y-%m")

#Order table
source <- source[order(source$StartId, source$EndId, source$Month, source$PartOfWeek, source$HourOfDay, source$TripPurpose, source$Count, source$InSanDiegoCounty),]
db <- db[order(db$StartId, db$EndId, db$Month, db$PartOfWeek, db$HourOfDay, db$TripPurpose, db$Count, db$InSanDiegoCounty),]

#Delete unique key assigned by R so that identical function will work
rownames(source) <- NULL
rownames(db) <- NULL

# compare files 
all(source == db) #check cell values only
all.equal(source,db) #check cell values and data types and will return the conflicted cells
identical(source,db) #check cell values and data types
which(source!=db, arr.ind = TRUE)

# source[1,3]
# db[1,3]
