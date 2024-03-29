#PeMS Highway Counts 11/2018-08/2019 Station Day

# display more digits
options(digits=15)

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\..\\Common_functions\\readSQL.R")
getwd()

# File Comparison between source data and database data #

#Read in text files
source1 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2018_11.txt", header=FALSE, sep=",")
source2 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2018_12.txt", header=FALSE, sep=",")
source3 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2019_01.txt", header=FALSE, sep=",")
source4 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2019_02.txt", header=FALSE, sep=",")
source5 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2019_03.txt", header=FALSE, sep=",")
source6 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2019_04.txt", header=FALSE, sep=",")
source7 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2019_05.txt", header=FALSE, sep=",")
source8 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2019_06.txt", header=FALSE, sep=",")
source9 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2019_07.txt", header=FALSE, sep=",")
source10 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station day\\Source\\d11_text_station_day_2019_08.txt", header=FALSE, sep=",")

#Merge source files into one file
source <- do.call("rbind", list(source1, source2, source3, source4, source5, source6, source7, source8, source9, source10))
#rm(source)

#Remove other source files
rm(source1,source2,source3,source4,source5,source6,source7,source8,source9,source10)

#Load database data
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT * FROM dpoe_stage.staging.pems_day'
db <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#View column names in source data
#colnames(source)
#colnames(db)

#Rename source data. Make sure order is the same as in the database.
source <- plyr::rename(source, c("V1"="timestamp", "V2"="station", "V3"="district", "V4"="route", "V5"="direction", "V6"="type", "V7"="seg_length", "V8"="samples", "V9"="observed", "V10"="total_flow", "V11"="delay35", "V12"="delay40", "V13"="delay45", "V14"="delay50", "V15"="delay55", "V16"="delay60"))

#Check data types
#str(source)
#str(db)

#Convert data types
source$timestamp <- format(as.Date(source$timestamp, format = "%m/%d/%Y"), "%Y-%m-%d")
db$timestamp <- format(as.Date(db$timestamp, format = "%Y-%m-%d"), "%Y-%m-%d")

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

######################################################################################################################################################

#PeMS Highway Counts 11/2018-08/2019 Station Hour

#Read in text files
source1 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2018_11.txt", header=FALSE, sep=",")
source2 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2018_12.txt", header=FALSE, sep=",")
source3 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2019_01.txt", header=FALSE, sep=",")
source4 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2019_02.txt", header=FALSE, sep=",")
source5 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2019_03.txt", header=FALSE, sep=",")
source6 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2019_04.txt", header=FALSE, sep=",")
source7 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2019_05.txt", header=FALSE, sep=",")
source8 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2019_06.txt", header=FALSE, sep=",")
source9 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2019_07.txt", header=FALSE, sep=",")
source10 <- read.delim("R:\\DPOE\\Highway Counts\\Caltrans Performance Measurement System (PeMS)\\2019\\Station hour\\Source\\d11_text_station_hour_2019_08.txt", header=FALSE, sep=",")

#Merge source files into one file
source <- do.call("rbind", list(source1, source2, source3, source4, source5, source6, source7, source8, source9, source10))

#Remove other source files
rm(source1,source2,source3,source4,source5,source6,source7,source8,source9,source10)

#Load database data
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT * FROM dpoe_stage.staging.pems_hour'
db <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#View column names in source data
#colnames(source)
#colnames(db)

#Rename source data. Make sure order is the same as in the database.
source <- plyr::rename(source, c("V1"="timestamp","V2"="station","V3"="district","V4"="route","V5"="direction","V6"="type","V7"="seg_length","V8"="samples","V9"="observed","V10"="total_flow","V11"="avg_occ","V12"="avg_speed","V13"="delay35","V14"="delay40","V15"="delay45","V16"="delay50","V17"="delay55","V18"="delay60","V19"="l1_flow","V20"="l1_occ","V21"="l1_speed","V22"="l2_flow","V23"="l2_occ","V24"="l2_speed","V25"="l3_flow","V26"="l3_occ","V27"="l3_speed","V28"="l4_flow","V29"="l4_occ","V30"="l4_speed","V31"="l5_flow","V32"="l5_occ","V33"="l5_speed","V34"="l6_flow","V35"="l6_occ","V36"="l6_speed","V37"="l7_flow","V38"="l7_occ","V39"="l7_speed","V40"="l8_flow","V41"="l8_occ","V42"="l8_speed"))

#Check data types
# str(source)
# str(db)

#Convert data types
source$direction <- as.character(source$direction)
source$type <- as.character(source$type)

#Convert timestamp column to character
source$timestamp <- as.character(source$timestamp)
db$timestamp <- format(as.POSIXct(db$timestamp, format = "%Y-%m-%d %H:%M:%S"), "%m/%d/%Y %H:%M:%S")

#Order data frames for comparison
source <- source[order(source$timestamp,source$station,source$district,source$route,source$direction,source$type,source$seg_length,source$samples,source$observed,source$total_flow,source$avg_occ,source$avg_speed,source$delay35,source$delay40,source$delay45,source$delay50,source$delay55,source$delay60,source$l1_flow,source$l1_occ,source$l1_speed,source$l2_flow,source$l2_occ,source$l2_speed,source$l3_flow,source$l3_occ,source$l3_speed,source$l4_flow,source$l4_occ,source$l4_speed,source$l5_flow,source$l5_occ,source$l5_speed,source$l6_flow,source$l6_occ,source$l6_speed,source$l7_flow,source$l7_occ,source$l7_speed,source$l8_flow,source$l8_occ,source$l8_speed),]
db <- db[order(db$timestamp,db$station,db$district,db$route,db$direction,db$type,db$seg_length,db$samples,db$observed,db$total_flow,db$avg_occ,db$avg_speed,db$delay35,db$delay40,db$delay45,db$delay50,db$delay55,db$delay60,db$l1_flow,db$l1_occ,db$l1_speed,db$l2_flow,db$l2_occ,db$l2_speed,db$l3_flow,db$l3_occ,db$l3_speed,db$l4_flow,db$l4_occ,db$l4_speed,db$l5_flow,db$l5_occ,db$l5_speed,db$l6_flow,db$l6_occ,db$l6_speed,db$l7_flow,db$l7_occ,db$l7_speed,db$l8_flow,db$l8_occ,db$l8_speed),]

#delete rownames for checking files match
rownames(source) <- NULL
rownames(db) <- NULL

# compare source and to database files to ensure they match
all(source == db)
all.equal(source,db)
identical(source,db)
which(source!=db, arr.ind=TRUE)

#########################################################################################################################
# #testing
# test_db<- db[,-1]
# test_source <- source[,-1]
# 
# #Order data frames for comparison
# test_source <- test_source[order(test_source$station,test_source$district,test_source$route,test_source$direction,test_source$type,test_source$seg_length,test_source$samples,test_source$observed,test_source$total_flow,test_source$avg_occ,test_source$avg_speed,test_source$delay35,test_source$delay40,test_source$delay45,test_source$delay50,test_source$delay55,test_source$delay60,test_source$l1_flow,test_source$l1_occ,test_source$l1_speed,test_source$l2_flow,test_source$l2_occ,test_source$l2_speed,test_source$l3_flow,test_source$l3_occ,test_source$l3_speed,test_source$l4_flow,test_source$l4_occ,test_source$l4_speed,test_source$l5_flow,test_source$l5_occ,test_source$l5_speed,test_source$l6_flow,test_source$l6_occ,test_source$l6_speed,test_source$l7_flow,test_source$l7_occ,test_source$l7_speed,test_source$l8_flow,test_source$l8_occ,test_source$l8_speed),]
# test_db <- test_db[order(test_db$station,test_db$district,test_db$route,test_db$direction,test_db$type,test_db$seg_length,test_db$samples,test_db$observed,test_db$total_flow,test_db$avg_occ,test_db$avg_speed,test_db$delay35,test_db$delay40,test_db$delay45,test_db$delay50,test_db$delay55,test_db$delay60,test_db$l1_flow,test_db$l1_occ,test_db$l1_speed,test_db$l2_flow,test_db$l2_occ,test_db$l2_speed,test_db$l3_flow,test_db$l3_occ,test_db$l3_speed,test_db$l4_flow,test_db$l4_occ,test_db$l4_speed,test_db$l5_flow,test_db$l5_occ,test_db$l5_speed,test_db$l6_flow,test_db$l6_occ,test_db$l6_speed,test_db$l7_flow,test_db$l7_occ,test_db$l7_speed,test_db$l8_flow,test_db$l8_occ,test_db$l8_speed),]
# 
# #delete rownames for checking files match
# rownames(test_source) <- NULL
# rownames(test_db) <- NULL
# 
# # compare source and to database files to ensure they match
# all(test_source == test_db)
# all.equal(test_source,test_db)
# identical(test_source,test_db)
# which(test_source!=test_db, arr.ind=TRUE)
# 
# test_db[18,1]
# test_source[18,1]

# #Get test data frame
# test_source <- tail(source)
# test_db <- tail(db)

# test_source$timestamp2 <- as.character(test_source$timestamp)
# test_source$timestamp3 <- strptime(test_source$timestamp2, format = "%m/%d/%Y %H:%M:%S")
# test_source$timestamp4 <- as.POSIXct(test_source$timestamp3)

# issue with timestamps
# d1727 <- subset(db,total_flow==1727 & station ==1126974)
# s1727 <- subset(source,total_flow==1727 & station ==1126974)
# all.equal(s1727,d1727)

