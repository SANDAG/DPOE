#Passenger Counting Program

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\..\\Common_functions\\readSQL.R")
getwd()


# File Comparison between source data and database data

#Read in source file
source02 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2002")
source03 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2003")
source04 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2004")
source05 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2005")
source06 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2006")
source07 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2007")
source08 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2008")
source09 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2009")
source10 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2010")
source11 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2011")
source12 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2012")
source13 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2013")
source14 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2014")
source15 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2015")
source16 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2016")
source17 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2017")
source18 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2018")
source19 <- read_excel("R:\\DPOE\\Passenger Counting Program\\2019\\Source\\FY2002 - 2019 Weekday Ridership by Route rev. 9.20.19.xlsx", sheet = "2019")

#Merge source files into one file
#source <- do.call("rbind", list(source02,source03,source04,source05,source06,source07,source08,source09,source10,source11,source12,source13,source14,source15,source16,source17,source18,source19))
#rm(source)

#Remove other source files
#rm(source02,source03,source04,source05,source06,source07,source08,source09,source10,source11,source12,source13,source14,source15,source16,source17,source18,source19)

#Load database data
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT * FROM dpoe_stage.XXXX'
db <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#View column names in source data
colnames(source)
colnames(db)
colnames(source19)

#Drop columns from source
source <- select(source, -17:-42)

#Rename source data. Make sure order is the same as in the database.
source <- plyr::rename(source, c("V1"="timestamp", "V2"="station", "V3"="district", "V4"="route", "V5"="direction", "V6"="type", "V7"="seg_length", "V8"="samples", "V9"="observed", "V10"="total_flow", "V11"="delay35", "V12"="delay40", "V13"="delay45", "V14"="delay50", "V15"="delay55", "V16"="delay60"))

# "ROUTE_NUMBER", "ROUTE_NAME", "SERVICE_CODE", "SERVICE_TYPE", "SERVICE_CLASS", "SERVICE_MODE", "TRIPS", "TRIPS_GROSS", "SUM_PASSENGERS_ON", "SUM_FON", "SUM_RON", "SUM_PASSENGERS_OFF", "SUM_FOFF", "SUM_ROFF",           
# "SUM_WHEELCHAIRS", "SUM_BICYCLES", "SUM_KNEELS", "MAX_MAX_LOAD", "MAX_MAX_LOAD_P", "AVG_MAX_LOAD", "SUM_TP_EARLY", "SUM_TP_ONTIME", "SUM_TP_LATE", "ONTIME", "SUM_REVENUE_MILES", "SUM_REVENUE_HOURS", "AVG_PASSENGERS_ON", "AVG_PASSENGERS_OFF", 
# "AVG_REVENUE_MILES", "AVG_REVENUE_HOURS", "SUM_PASSENGER_MILES", "AVG_PASSENGER_MILES", "SUM_SEAT_MILES",      "AVG_PASS_PER_MILE",   "AVG_PASS_PER_HOUR",  
# "AVG_SEAT_MILES", "AVG_TRIP_LENGTH"    

#Check data types
str(source)
str(db)

#Convert data types
source$timestamp <- format(as.Date(source$timestamp, format = "%m/%d/%Y"), "%Y-%m-%d")
db$timestamp <- format(as.Date(db$timestamp, format = "%Y-%m-%d"), "%Y-%m-%d")

#Round seg_length
db$seg_length <- round(db$seg_length,digits=3)
db$delay35 <- round(db$delay35,digits=3)
db$delay40 <- round(db$delay40,digits=3)
db$delay45 <- round(db$delay45,digits=3)
db$delay50 <- round(db$delay50,digits=3)
db$delay55 <- round(db$delay55,digits=3)
db$delay60 <- round(db$delay60,digits=3)

#Order data frames for comparison
source <- source[order(source$timestamp, source$station, source$district, source$route, source$direction, source$type, source$seg_length, source$samples, source$observed, source$total_flow, source$delay35, source$delay40, source$delay45, source$delay50, source$delay55, source$delay60),]
db <- db[order(db$timestamp, db$station, db$district, db$route, db$direction, db$type, db$seg_length, db$samples, db$observed, db$total_flow, db$delay35, db$delay40, db$delay45, db$delay50, db$delay55, db$delay60),]

#delete rownames for checking files match
rownames(source) <- NULL
rownames(db) <- NULL

# compare source and to database files to ensure they match
all(source == db)
all.equal(source,db)
identical(source,db)
which(source!=db, arr.ind=TRUE)

