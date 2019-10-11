#Passenger Counting Program

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
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
sql_query <- 'SELECT * FROM dpoe_stage.staging.passenger_counting_program'
db <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#View column names in source data
colnames(source02)
colnames(db)
colnames(source19)

#Add new columns to individual source tables
#Year
source02$yr <- "2002"
source03$yr <- "2003"
source04$yr <- "2004"
source05$yr <- "2005"
source06$yr <- "2006"
source07$yr <- "2007"
source08$yr <- "2008"
source09$yr <- "2009"
source10$yr <- "2010"
source11$yr <- "2011"
source12$yr <- "2012"
source13$yr <- "2013"
source14$yr <- "2014"
source15$yr <- "2015"
source16$yr <- "2016"
source17$yr <- "2017"
source18$yr <- "2018"
source19$yr <- "2019"

#Date counted
source08$date_counted <- NA
source09$date_counted <- NA
source10$date_counted <- NA
source11$date_counted <- NA
source12$date_counted <- NA
source13$date_counted <- NA
source14$date_counted <- NA
source15$date_counted <- NA
source16$date_counted <- NA
source17$date_counted <- NA
source18$date_counted <- NA
source19$date_counted <- NA

#Route name
source03$route_name <- NA
source04$route_name <- NA
source05$route_name <- NA
source06$route_name <- NA
source07$route_name <- NA

#Service code
source02$service_code <- NA
source03$service_code <- NA
source04$service_code <- NA
source05$service_code <- NA
source06$service_code <- NA
source07$service_code <- 
  
#Service type
source02$service_type <- NA
source03$service_type <- NA
source04$service_type <- NA
source05$service_type <- NA
source06$service_type <- NA
source07$service_type <- NA

#Service mode
source02$service_mode <- NA
source03$service_mode <- NA
source04$service_mode <- NA
source05$service_mode <- NA
source06$service_mode <- NA
source07$service_mode <- NA

#Service class
source02$service_class <- NA
source03$service_class <- NA
source04$service_class <- NA
source05$service_class <- NA
source06$service_class <- NA
source07$service_class <- NA

#Trips Gross
source02$trips_gross <- NA
source03$trips_gross <- NA
source04$trips_gross <- NA
source05$trips_gross <- NA
source06$trips_gross <- NA
source07$trips_gross <- NA

#sum_fon
source02$sum_fon <- NA
source03$sum_fon <- NA
source04$sum_fon <- NA
source05$sum_fon <- NA
source06$sum_fon <- NA
source07$sum_fon <- NA
source08$sum_fon <- NA
source09$sum_fon <- NA
source10$sum_fon <- NA
source11$sum_fon <- NA
source12$sum_fon <- NA
source13$sum_fon <- NA
source14$sum_fon <- NA
source15$sum_fon <- NA

#sum_ron
source02$sum_ron <- NA
source03$sum_ron <- NA
source04$sum_ron <- NA
source05$sum_ron <- NA
source06$sum_ron <- NA
source07$sum_ron <- NA
source08$sum_ron <- NA
source09$sum_ron <- NA
source10$sum_ron <- NA
source11$sum_ron <- NA
source12$sum_ron <- NA
source13$sum_ron <- NA
source14$sum_ron <- NA
source15$sum_ron <- NA

#sum_passengers_off
source02$sum_passengers_off <- NA
source03$sum_passengers_off <- NA
source04$sum_passengers_off <- NA
source05$sum_passengers_off <- NA
source06$sum_passengers_off <- NA
source07$sum_passengers_off <- NA

#sum_foff
source02$sum_foff <- NA
source03$sum_foff <- NA
source04$sum_foff <- NA
source05$sum_foff <- NA
source06$sum_foff <- NA
source07$sum_foff <- NA
source08$sum_foff <- NA
source09$sum_foff <- NA
source10$sum_foff <- NA
source11$sum_foff <- NA
source12$sum_foff <- NA
source13$sum_foff <- NA
source14$sum_foff <- NA
source15$sum_foff <- NA

#sum_roff
source02$sum_roff <- NA
source03$sum_roff <- NA
source04$sum_roff <- NA
source05$sum_roff <- NA
source06$sum_roff <- NA
source07$sum_roff <- NA
source08$sum_roff <- NA
source09$sum_roff <- NA
source10$sum_roff <- NA
source11$sum_roff <- NA
source12$sum_roff <- NA
source13$sum_roff <- NA
source14$sum_roff <- NA
source15$sum_roff <- NA

#sum_wheelchairs
source02$sum_wheelchairs <- NA
source03$sum_wheelchairs <- NA
source04$sum_wheelchairs <- NA
source05$sum_wheelchairs <- NA
source06$sum_wheelchairs <- NA
source07$sum_wheelchairs <- NA
source08$sum_wheelchairs <- NA
source09$sum_wheelchairs <- NA

#sum_bicycles
source02$sum_bicycles <- NA
source03$sum_bicycles <- NA
source04$sum_bicycles <- NA
source05$sum_bicycles <- NA
source06$sum_bicycles <- NA
source07$sum_bicycles <- NA
source08$sum_bicycles <- NA
source09$sum_bicycles <- NA
source10$sum_bicycles <- NA
source11$sum_bicycles <- NA
source12$sum_bicycles <- NA
source13$sum_bicycles <- NA
source14$sum_bicycles <- NA
source15$sum_bicycles <- NA
source18$sum_bicycles <- NA

#sum_kneels
source02$sum_kneels <- NA
source03$sum_kneels <- NA
source04$sum_kneels <- NA
source05$sum_kneels <- NA
source06$sum_kneels <- NA
source07$sum_kneels <- NA
source08$sum_kneels <- NA
source09$sum_kneels <- NA
source10$sum_kneels <- NA
source11$sum_kneels <- NA
source12$sum_kneels <- NA
source13$sum_kneels <- NA
source14$sum_kneels <- NA
source15$sum_kneels <- NA
source16$sum_kneels <- NA
source17$sum_kneels <- NA
source18$sum_kneels <- NA
source19$sum_kneels <- NA

















#Add new columns to source data table
source$vintage_yr <- "2019"

#Drop columns from source
source <- select(source, -17:-42)

#Rename source data. Make sure order is the same as in the database.
source <- plyr::rename(source02, c("F2"="date_counted", "[2002]"="route_num", "V3"="district", "V4"="route", "V5"="direction", "V6"="type", "V7"="seg_length", "V8"="samples", "V9"="observed", "V10"="total_flow", "V11"="delay35", "V12"="delay40", "V13"="delay45", "V14"="delay50", "V15"="delay55", "V16"="delay60"))

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

