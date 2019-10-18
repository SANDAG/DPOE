#Passenger Counting Program

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Read in source files
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

#Load database data
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT * FROM dpoe_stage.staging.passenger_counting_program'
db <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#Check data types
# str(source02)
# str(source03)
# str(source04)
# str(source05)
# str(source06)
# str(source07)
# str(source08)
# str(source09)
# str(source10)
# str(source11)
# str(source12)
# str(source13)
# str(source14)
# str(source15)
# str(source16)
# str(source17)
# str(source18)
# str(source19)

#Convert to data frame
source02 <- as.data.frame(source02)
source03 <- as.data.frame(source03)
source04 <- as.data.frame(source04)
source05 <- as.data.frame(source05)
source06 <- as.data.frame(source06)
source07 <- as.data.frame(source07)
source08 <- as.data.frame(source08)
source09 <- as.data.frame(source09)
source10 <- as.data.frame(source10)
source11 <- as.data.frame(source11)
source12 <- as.data.frame(source12)
source13 <- as.data.frame(source13)
source14 <- as.data.frame(source14)
source15 <- as.data.frame(source15)
source16 <- as.data.frame(source16)
source17 <- as.data.frame(source17)
source18 <- as.data.frame(source18)
source19 <- as.data.frame(source19)

#Convert to numeric
source02$...7 <- as.numeric(source02$...7)
source02$...13 <- as.numeric(source02$...13)
source03$...7 <- as.numeric(source03$...7)
source03$"PASS MI...13" <- as.numeric(source03$"PASS MI...13")
source04$"Passenger\r\nMiles" <- as.numeric(source04$"Passenger\r\nMiles")
source04$"Passenger\r\nMiles Per\r\nSeat Mile" <- as.numeric(source04$"Passenger\r\nMiles Per\r\nSeat Mile")
source05$"Passenger\r\nMiles" <- as.numeric(source05$"Passenger\r\nMiles")
source05$"Passenger\r\nMiles Per\r\nSeat Mile" <- as.numeric(source05$"Passenger\r\nMiles Per\r\nSeat Mile")
source06$"Passenger\r\nMiles" <- as.numeric(source06$"Passenger\r\nMiles")
source06$"Passenger\r\nMiles Per\r\nSeat Mile" <- as.numeric(source06$"Passenger\r\nMiles Per\r\nSeat Mile")

#Rename columns
source03 <- plyr::rename(source03, c("PASS MI...13"="pass_mi_1", "PASS MI...14"="pass_mi_2", "AVERAGE...6"="average_1", "AVERAGE...10"="average_2"))
source04 <- plyr::rename(source04, c("Passenger\r\nMiles"="passenger_miles", "Passenger\r\nMiles Per\r\nSeat Mile"="PASSENGER_MILES_PER_SEAT_MILE"))
source05 <- plyr::rename(source05, c("Passenger\r\nMiles"="passenger_miles", "Passenger\r\nMiles Per\r\nSeat Mile"="PASSENGER_MILES_PER_SEAT_MILE"))
source06 <- plyr::rename(source06, c("Passenger\r\nMiles"="passenger_miles", "Passenger\r\nMiles Per\r\nSeat Mile"="PASSENGER_MILES_PER_SEAT_MILE"))

#Add new columns to individual source tables
#Year
source02$YR <- "2002"
source03$YR <- "2003"
source04$YR <- "2004"
source05$YR <- "2005"
source06$YR <- "2006"
source07$YR <- "2007"
source08$YR <- "2008"
source09$YR <- "2009"
source10$YR <- "2010"
source11$YR <- "2011"
source12$YR <- "2012"
source13$YR <- "2013"
source14$YR <- "2014"
source15$YR <- "2015"
source16$YR <- "2016"
source17$YR <- "2017"
source18$YR <- "2018"
source19$YR <- "2019"

#Date counted
source08$DATE_COUNTED <- NA
source09$DATE_COUNTED <- NA
source10$DATE_COUNTED <- NA
source11$DATE_COUNTED <- NA
source12$DATE_COUNTED <- NA
source13$DATE_COUNTED <- NA
source14$DATE_COUNTED <- NA
source15$DATE_COUNTED <- NA
source16$DATE_COUNTED <- NA
source17$DATE_COUNTED <- NA
source18$DATE_COUNTED <- NA
source19$DATE_COUNTED <- NA

#ROUTE_NAME
source02$ROUTE_NAME <- NA
source03$ROUTE_NAME <- NA
source04$ROUTE_NAME <- NA
source05$ROUTE_NAME <- NA
source06$ROUTE_NAME <- NA
source07$ROUTE_NAME <- NA

#Service code
source02$SERVICE_CODE <- NA
source03$SERVICE_CODE <- NA
source04$SERVICE_CODE <- NA
source05$SERVICE_CODE <- NA
source06$SERVICE_CODE <- NA
source07$SERVICE_CODE <- NA
  
#Service type
source02$SERVICE_TYPE <- NA
source03$SERVICE_TYPE <- NA
source04$SERVICE_TYPE <- NA
source05$SERVICE_TYPE <- NA
source06$SERVICE_TYPE <- NA
source07$SERVICE_TYPE <- NA

#Service mode
source02$SERVICE_MODE <- NA
source03$SERVICE_MODE <- NA
source04$SERVICE_MODE <- NA
source05$SERVICE_MODE <- NA
source06$SERVICE_MODE <- NA
source07$SERVICE_MODE <- NA

#Service class
source02$SERVICE_CLASS <- NA
source03$SERVICE_CLASS <- NA
source04$SERVICE_CLASS <- NA
source05$SERVICE_CLASS <- NA
source06$SERVICE_CLASS <- NA
source07$SERVICE_CLASS <- NA

#Trips Gross
source02$TRIPS_GROSS <- NA
source03$TRIPS_GROSS <- NA
source04$TRIPS_GROSS <- NA
source05$TRIPS_GROSS <- NA
source06$TRIPS_GROSS <- NA
source07$TRIPS_GROSS <- NA

#SUM_FON
source02$SUM_FON <- NA
source03$SUM_FON <- NA
source04$SUM_FON <- NA
source05$SUM_FON <- NA
source06$SUM_FON <- NA
source07$SUM_FON <- NA
source08$SUM_FON <- NA
source09$SUM_FON <- NA
source10$SUM_FON <- NA
source11$SUM_FON <- NA
source12$SUM_FON <- NA
source13$SUM_FON <- NA
source14$SUM_FON <- NA
source15$SUM_FON <- NA

#SUM_RON
source02$SUM_RON <- NA
source03$SUM_RON <- NA
source04$SUM_RON <- NA
source05$SUM_RON <- NA
source06$SUM_RON <- NA
source07$SUM_RON <- NA
source08$SUM_RON <- NA
source09$SUM_RON <- NA
source10$SUM_RON <- NA
source11$SUM_RON <- NA
source12$SUM_RON <- NA
source13$SUM_RON <- NA
source14$SUM_RON <- NA
source15$SUM_RON <- NA

#SUM_PASSENGERS_OFF
source02$SUM_PASSENGERS_OFF <- NA
source03$SUM_PASSENGERS_OFF <- NA
source04$SUM_PASSENGERS_OFF <- NA
source05$SUM_PASSENGERS_OFF <- NA
source06$SUM_PASSENGERS_OFF <- NA
source07$SUM_PASSENGERS_OFF <- NA

#SUM_FOFF
source02$SUM_FOFF <- NA
source03$SUM_FOFF <- NA
source04$SUM_FOFF <- NA
source05$SUM_FOFF <- NA
source06$SUM_FOFF <- NA
source07$SUM_FOFF <- NA
source08$SUM_FOFF <- NA
source09$SUM_FOFF <- NA
source10$SUM_FOFF <- NA
source11$SUM_FOFF <- NA
source12$SUM_FOFF <- NA
source13$SUM_FOFF <- NA
source14$SUM_FOFF <- NA
source15$SUM_FOFF <- NA

#SUM_ROFF
source02$SUM_ROFF <- NA
source03$SUM_ROFF <- NA
source04$SUM_ROFF <- NA
source05$SUM_ROFF <- NA
source06$SUM_ROFF <- NA
source07$SUM_ROFF <- NA
source08$SUM_ROFF <- NA
source09$SUM_ROFF <- NA
source10$SUM_ROFF <- NA
source11$SUM_ROFF <- NA
source12$SUM_ROFF <- NA
source13$SUM_ROFF <- NA
source14$SUM_ROFF <- NA
source15$SUM_ROFF <- NA

#SUM_WHEELCHAIRS
source02$SUM_WHEELCHAIRS <- NA
source03$SUM_WHEELCHAIRS <- NA
source04$SUM_WHEELCHAIRS <- NA
source05$SUM_WHEELCHAIRS <- NA
source06$SUM_WHEELCHAIRS <- NA
source07$SUM_WHEELCHAIRS <- NA
source08$SUM_WHEELCHAIRS <- NA
source09$SUM_WHEELCHAIRS <- NA

#SUM_BICYCLES
source02$SUM_BICYCLES <- NA
source03$SUM_BICYCLES <- NA
source04$SUM_BICYCLES <- NA
source05$SUM_BICYCLES <- NA
source06$SUM_BICYCLES <- NA
source07$SUM_BICYCLES <- NA
source08$SUM_BICYCLES <- NA
source09$SUM_BICYCLES <- NA
source10$SUM_BICYCLES <- NA
source11$SUM_BICYCLES <- NA
source12$SUM_BICYCLES <- NA
source13$SUM_BICYCLES <- NA
source14$SUM_BICYCLES <- NA
source15$SUM_BICYCLES <- NA

#SUM_KNEELS
source02$SUM_KNEELS <- NA
source03$SUM_KNEELS <- NA
source04$SUM_KNEELS <- NA
source05$SUM_KNEELS <- NA
source06$SUM_KNEELS <- NA
source07$SUM_KNEELS <- NA
source08$SUM_KNEELS <- NA
source09$SUM_KNEELS <- NA
source10$SUM_KNEELS <- NA
source11$SUM_KNEELS <- NA
source12$SUM_KNEELS <- NA
source13$SUM_KNEELS <- NA
source14$SUM_KNEELS <- NA
source15$SUM_KNEELS <- NA

#MAX_LOAD
source02$MAX_LOAD <- NA
source03$MAX_LOAD <- NA
source04$MAX_LOAD <- NA
source05$MAX_LOAD <- NA
source06$MAX_LOAD <- NA
source07$MAX_LOAD <- NA

#MAX_LOAD_P
source02$MAX_LOAD_P <- NA
source03$MAX_LOAD_P <- NA
source04$MAX_LOAD_P <- NA
source05$MAX_LOAD_P <- NA
source06$MAX_LOAD_P <- NA
source07$MAX_LOAD_P <- NA
source08$MAX_LOAD_P <- NA
source09$MAX_LOAD_P <- NA
source10$MAX_LOAD_P <- NA
source11$MAX_LOAD_P <- NA
source12$MAX_LOAD_P <- NA
source13$MAX_LOAD_P <- NA
source14$MAX_LOAD_P <- NA
source15$MAX_LOAD_P <- NA

#AVG_MAX_LOAD
source02$AVG_MAX_LOAD <- NA
source03$AVG_MAX_LOAD <- NA
source04$AVG_MAX_LOAD <- NA
source05$AVG_MAX_LOAD <- NA
source06$AVG_MAX_LOAD <- NA
source07$AVG_MAX_LOAD <- NA

#SUM_TP_EARLY
source02$SUM_TP_EARLY <- NA
source03$SUM_TP_EARLY <- NA
source04$SUM_TP_EARLY <- NA
source05$SUM_TP_EARLY <- NA
source06$SUM_TP_EARLY <- NA
source07$SUM_TP_EARLY <- NA

#SUM_TP_ONTIME
source02$SUM_TP_ONTIME <- NA
source03$SUM_TP_ONTIME <- NA
source04$SUM_TP_ONTIME <- NA
source05$SUM_TP_ONTIME <- NA
source06$SUM_TP_ONTIME <- NA
source07$SUM_TP_ONTIME <- NA

#SUM_TP_LATE
source02$SUM_TP_LATE <- NA
source03$SUM_TP_LATE <- NA
source04$SUM_TP_LATE <- NA
source05$SUM_TP_LATE <- NA
source06$SUM_TP_LATE <- NA
source07$SUM_TP_LATE <- NA

#ONTIME
source02$ONTIME <- NA
source03$ONTIME <- NA
source04$ONTIME <- NA
source05$ONTIME <- NA
source06$ONTIME <- NA
source07$ONTIME <- NA

#AVG_PASSENGERS_ON
source02$AVG_PASSENGERS_ON <- NA
source03$AVG_PASSENGERS_ON <- NA
source04$AVG_PASSENGERS_ON <- NA
source05$AVG_PASSENGERS_ON <- NA
source06$AVG_PASSENGERS_ON <- NA
source07$AVG_PASSENGERS_ON <- NA

#AVG_PASSENGERS_OFF
source02$AVG_PASSENGERS_OFF <- NA
source03$AVG_PASSENGERS_OFF <- NA
source04$AVG_PASSENGERS_OFF <- NA
source05$AVG_PASSENGERS_OFF <- NA
source06$AVG_PASSENGERS_OFF <- NA
source07$AVG_PASSENGERS_OFF <- NA

#AVG_REVENUE_MILES
source02$AVG_REVENUE_MILES <- NA
source03$AVG_REVENUE_MILES <- NA
source04$AVG_REVENUE_MILES <- NA
source05$AVG_REVENUE_MILES <- NA
source06$AVG_REVENUE_MILES <- NA
source07$AVG_REVENUE_MILES <- NA

#AVG_REVENUE_HOURS
source02$AVG_REVENUE_HOURS <- NA
source03$AVG_REVENUE_HOURS <- NA
source04$AVG_REVENUE_HOURS <- NA
source05$AVG_REVENUE_HOURS <- NA
source06$AVG_REVENUE_HOURS <- NA
source07$AVG_REVENUE_HOURS <- NA

#AVG_PASSENGER_MILES
source02$AVG_PASSENGER_MILES <- NA
source03$AVG_PASSENGER_MILES <- NA
source04$AVG_PASSENGER_MILES <- NA
source05$AVG_PASSENGER_MILES <- NA
source06$AVG_PASSENGER_MILES <- NA
source07$AVG_PASSENGER_MILES <- NA

#sum_seat_miles
source02 <- transform(source02, SUM_SEAT_MILES = ...7/...13)
source03 <- transform(source03, SUM_SEAT_MILES = ...7/pass_mi_1)
source04 <- transform(source04, SUM_SEAT_MILES = passenger_miles/PASSENGER_MILES_PER_SEAT_MILE)
source05 <- transform(source05, SUM_SEAT_MILES = passenger_miles/PASSENGER_MILES_PER_SEAT_MILE)
source06 <- transform(source06, SUM_SEAT_MILES = passenger_miles/PASSENGER_MILES_PER_SEAT_MILE)
source08$SUM_SEAT_MILES <- NA

#AVG_SEAT_MILES
source02$AVG_SEAT_MILES <- NA
source03$AVG_SEAT_MILES <- NA
source04$AVG_SEAT_MILES <- NA
source05$AVG_SEAT_MILES <- NA
source06$AVG_SEAT_MILES <- NA
source07$AVG_SEAT_MILES <- NA
source08$AVG_SEAT_MILES <- NA

#AVG_TRIP_LENGTH_MILES
source08$AVG_TRIP_LENGTH_MILES <- NA

#passenger_miles_per_seat_mile
source08$PASSENGER_MILES_PER_SEAT_MILE <- NA
source09 <- transform(source09, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source10 <- transform(source10, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source11 <- transform(source11, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source12 <- transform(source12, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source13 <- transform(source13, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source14 <- transform(source14, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source15 <- transform(source15, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source16 <- transform(source16, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source17 <- transform(source17, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source18 <- transform(source18, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)
source19 <- transform(source19, PASSENGER_MILES_PER_SEAT_MILE = SUM_PASSENGER_MILES/SUM_SEAT_MILES)

#VEHICLE_SPEED_MPH
source08 <- transform(source08, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source10 <- transform(source10, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source11 <- transform(source11, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source12 <- transform(source12, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source13 <- transform(source13, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source14 <- transform(source14, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source15 <- transform(source15, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source16 <- transform(source16, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source17 <- transform(source17, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source18 <- transform(source18, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)
source19 <- transform(source19, VEHICLE_SPEED_MPH = SUM_REVENUE_MILES/SUM_REVENUE_HOURS)

#PASSENGER_HOURS
source08$PASSENGER_HOURS <- NA
source09$PASSENGER_HOURS <- NA
source10$PASSENGER_HOURS <- NA
source11$PASSENGER_HOURS <- NA
source12$PASSENGER_HOURS <- NA
source13$PASSENGER_HOURS <- NA
source14$PASSENGER_HOURS <- NA
source15$PASSENGER_HOURS <- NA
source16$PASSENGER_HOURS <- NA
source17$PASSENGER_HOURS <- NA
source18$PASSENGER_HOURS <- NA
source19$PASSENGER_HOURS <- NA

#AVG_TRIP_LENGTH_MINUTES
source08$AVG_TRIP_LENGTH_MINUTES <- NA
source09$AVG_TRIP_LENGTH_MINUTES <- NA
source10$AVG_TRIP_LENGTH_MINUTES <- NA
source11$AVG_TRIP_LENGTH_MINUTES <- NA
source12$AVG_TRIP_LENGTH_MINUTES <- NA
source13$AVG_TRIP_LENGTH_MINUTES <- NA
source14$AVG_TRIP_LENGTH_MINUTES <- NA
source15$AVG_TRIP_LENGTH_MINUTES <- NA
source16$AVG_TRIP_LENGTH_MINUTES <- NA
source17$AVG_TRIP_LENGTH_MINUTES <- NA
source18$AVG_TRIP_LENGTH_MINUTES <- NA
source19$AVG_TRIP_LENGTH_MINUTES <- NA

#PASSENGER_MILES_PER_GALLON_FUEL
source08$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source09$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source10$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source11$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source12$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source13$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source14$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source15$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source16$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source17$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source18$PASSENGER_MILES_PER_GALLON_FUEL <- NA
source19$PASSENGER_MILES_PER_GALLON_FUEL <- NA

#View column names
# colnames(db)
# colnames(source02)

#Drop columns from source
source07 <- select(source07, -17:-28)
source11 <- select(source11, -33)
source12 <- select(source12, -33:-38)
source13 <- select(source13, -33:-36)
source14 <- select(source14, -33)

#Drop rows from source
source02 <- source02[-1:-3,]
source03 <- source03[-1:-3,]
source02 <- source02[!is.na(source02$"...2"), ]
source03 <- source03[!is.na(source03$"...1"), ]
source03 <- source03[!is.na(source03$"...2"), ]
source04 <- source04[!is.na(source04$"Month..Counted"), ]
source05 <- source05[!is.na(source05$"Month..Counted"), ]
source06 <- source06[!is.na(source06$"Month..Counted"), ]
source07 <- source07[!is.na(source07$"Month\r\nCounted"), ]
source08 <- source08[!is.na(source08$"ROUTE_NAME"), ]
source09 <- source09[!is.na(source09$"ROUTE_NAME"), ]
source10 <- source10[!is.na(source10$"ROUTE_NAME"), ]
source11 <- source11[!is.na(source11$"ROUTE_NAME"), ]
source15 <- source15[!is.na(source15$"ROUTE_NAME"), ]
source16 <- source16[!is.na(source16$"ROUTE_NAME"), ]
source17 <- source17[!is.na(source17$"ROUTE_NAME"), ]
source18 <- source18[!is.na(source18$"ROUTE_NAME"), ]
source19 <- source19[!is.na(source19$"ROUTE_NAME"), ]

#Rename files
source02 <- plyr::rename(source02, c("X2002"="ROUTE_NUM", "...2"="DATE_COUNTED", "...3"="TRIPS", "...4"="SUM_PASSENGERS_ON", "...5"="SUM_REVENUE_MILES", "...6"="AVG_PASS_PER_MILE", "...7"="SUM_PASSENGER_MILES", "...8"="AVG_TRIP_LENGTH_MILES", "...9"="SUM_REVENUE_HOURS", "...10"="AVG_PASS_PER_HOUR", "...11"="PASSENGER_HOURS", "...12"="AVG_TRIP_LENGTH_MINUTES", "...13"="PASSENGER_MILES_PER_SEAT_MILE", "...14"="PASSENGER_MILES_PER_GALLON_FUEL", "...15"="VEHICLE_SPEED_MPH"))
source03 <- plyr::rename(source03, c("...1"="ROUTE_NUM", "...2"="DATE_COUNTED", "...3"="TRIPS", "...4"="SUM_PASSENGERS_ON", "...5"="SUM_REVENUE_MILES", "average_1"="AVG_PASS_PER_MILE", "...7"="SUM_PASSENGER_MILES", "...8"="AVG_TRIP_LENGTH_MILES", "...9"="SUM_REVENUE_HOURS", "average_2"="AVG_PASS_PER_HOUR", "...11"="PASSENGER_HOURS", "...12"="AVG_TRIP_LENGTH_MINUTES", "pass_mi_1"="PASSENGER_MILES_PER_SEAT_MILE", "pass_mi_2"="PASSENGER_MILES_PER_GALLON_FUEL", "...15"="VEHICLE_SPEED_MPH"))
source04 <- plyr::rename(source04, c("Route"="ROUTE_NUM", "Month..Counted"="DATE_COUNTED", "X..Of..Trips"="TRIPS", "X..Of..Passengers"="SUM_PASSENGERS_ON", "Revenue..Miles"="SUM_REVENUE_MILES", "Passengers..Per.Mile"="AVG_PASS_PER_MILE", "passenger_miles"="SUM_PASSENGER_MILES", "Ave..Trip..Length...Miles."="AVG_TRIP_LENGTH_MILES", "Revenue..Hours"="SUM_REVENUE_HOURS", "Passengers..Per.Hour"="AVG_PASS_PER_HOUR", "Passenger..Hours"="PASSENGER_HOURS", "Ave..Trip..Length...Minutes."="AVG_TRIP_LENGTH_MINUTES", "Passenger..Miles.Per..Gal.Fuel"="PASSENGER_MILES_PER_GALLON_FUEL", "Vehicle..Speed"="VEHICLE_SPEED_MPH"))
source05 <- plyr::rename(source05, c("Route"="ROUTE_NUM", "Month..Counted"="DATE_COUNTED", "X..Of..Trips"="TRIPS", "X..Of..Passengers"="SUM_PASSENGERS_ON", "Revenue..Miles"="SUM_REVENUE_MILES", "Passengers..Per.Mile"="AVG_PASS_PER_MILE", "passenger_miles"="SUM_PASSENGER_MILES", "Avg..Trip..Length...Miles."="AVG_TRIP_LENGTH_MILES", "Revenue..Hours"="SUM_REVENUE_HOURS", "Passengers..Per.Hour"="AVG_PASS_PER_HOUR", "Passenger..Hours"="PASSENGER_HOURS", "Avg..Trip..Length...Minutes."="AVG_TRIP_LENGTH_MINUTES", "Passenger..Miles.Per..Gal...Fuel"="PASSENGER_MILES_PER_GALLON_FUEL", "Vehicle..Speed..MPH."="VEHICLE_SPEED_MPH"))
source06 <- plyr::rename(source06, c("Route"="ROUTE_NUM", "Month..Counted"="DATE_COUNTED", "X..Of..Trips"="TRIPS", "X..Of..Passengers"="SUM_PASSENGERS_ON", "Revenue..Miles"="SUM_REVENUE_MILES", "Passengers..Per.Mile"="AVG_PASS_PER_MILE", "passenger_miles"="SUM_PASSENGER_MILES", "Avg..Trip..Length...Miles."="AVG_TRIP_LENGTH_MILES", "Revenue..Hours"="SUM_REVENUE_HOURS", "Passengers..Per.Hour"="AVG_PASS_PER_HOUR", "Passenger..Hours"="PASSENGER_HOURS", "Avg..Trip..Length...Minutes."="AVG_TRIP_LENGTH_MINUTES", "Passenger..Miles.Per..Gal...Fuel"="PASSENGER_MILES_PER_GALLON_FUEL", "Vehicle..Speed..MPH."="VEHICLE_SPEED_MPH"))
source07 <- plyr::rename(source07, c("Route"="ROUTE_NUM", "Month\r\nCounted"="DATE_COUNTED", "# Of\r\nTrips"="TRIPS", "# Of\r\nPassengers"="SUM_PASSENGERS_ON", "Revenue\r\nMiles"="SUM_REVENUE_MILES", "Passengers\r\nPer Mile"="AVG_PASS_PER_MILE", "Passenger\r\nMiles"="SUM_PASSENGER_MILES", "Avg. Trip\r\nLength\r\n(Miles)"="AVG_TRIP_LENGTH_MILES", "Revenue\r\nHours"="SUM_REVENUE_HOURS", "Passengers\r\nPer Hour"="AVG_PASS_PER_HOUR", "Passenger\r\nHours"="PASSENGER_HOURS", "Avg. Trip\r\nLength\r\n(Minutes)"="AVG_TRIP_LENGTH_MINUTES", "Passenger\r\nMiles Per\r\nSeat Mile"="PASSENGER_MILES_PER_SEAT_MILE", "Passenger\r\nMiles Per\r\nGal., Fuel"="PASSENGER_MILES_PER_GALLON_FUEL", "Vehicle\r\nSpeed (MPH)"="VEHICLE_SPEED_MPH", "Seat miles"="SUM_SEAT_MILES"))
source08 <- plyr::rename(source08, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "TRIPS_COUNT"="TRIPS_GROSS"))
source09 <- plyr::rename(source09, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "TRIPS_COUNT"="TRIPS_GROSS","ATL"="AVG_TRIP_LENGTH_MILES","SPEED"="VEHICLE_SPEED_MPH"))
source10 <- plyr::rename(source10, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "TRIPS_COUNT"="TRIPS_GROSS", "Average.Trip.Length"="AVG_TRIP_LENGTH_MILES"))
source11 <- plyr::rename(source11, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVERAGE_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES"))
source12 <- plyr::rename(source12, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVG_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES"))
source13 <- plyr::rename(source13, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVG_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES"))
source14 <- plyr::rename(source14, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVG_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES"))
source15 <- plyr::rename(source15, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVG_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES"))
source16 <- plyr::rename(source16, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVG_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES", "MAX_MAX_LOAD_P"="MAX_LOAD_P"))
source17 <- plyr::rename(source17, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVG_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES", "MAX_MAX_LOAD_P"="MAX_LOAD_P"))
source18 <- plyr::rename(source18, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVG_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES", "MAX_MAX_LOAD_P"="MAX_LOAD_P"))
source19 <- plyr::rename(source19, c("ROUTE_NUMBER"="ROUTE_NUM", "MAX_MAX_LOAD"="MAX_LOAD", "AVG_TRIP_LENGTH"="AVG_TRIP_LENGTH_MILES", "MAX_MAX_LOAD_P"="MAX_LOAD_P"))

#Order data frames for comparison
source02 <- source02[order(source02$YR,source02$DATE_COUNTED,source02$ROUTE_NUM,source02$ROUTE_NAME,source02$SERVICE_CODE,source02$SERVICE_TYPE,source02$SERVICE_CLASS,source02$SERVICE_MODE,source02$TRIPS,source02$TRIPS_GROSS,source02$SUM_PASSENGERS_ON,source02$SUM_FON,source02$SUM_RON,source02$SUM_PASSENGERS_OFF,source02$SUM_FOFF,source02$SUM_ROFF,source02$SUM_WHEELCHAIRS,source02$SUM_BICYCLES,source02$SUM_KNEELS,source02$MAX_LOAD,source02$MAX_LOAD_P,source02$AVG_MAX_LOAD,source02$SUM_TP_EARLY,source02$SUM_TP_ONTIME,source02$SUM_TP_LATE,source02$ONTIME,source02$SUM_REVENUE_MILES,source02$SUM_REVENUE_HOURS,source02$AVG_PASSENGERS_ON,source02$AVG_PASSENGERS_OFF,source02$AVG_REVENUE_MILES,source02$AVG_REVENUE_HOURS,source02$SUM_PASSENGER_MILES,source02$AVG_PASSENGER_MILES,source02$SUM_SEAT_MILES,source02$AVG_PASS_PER_MILE,source02$AVG_PASS_PER_HOUR,source02$AVG_SEAT_MILES,source02$AVG_TRIP_LENGTH_MILES,source02$PASSENGER_MILES_PER_SEAT_MILE,source02$VEHICLE_SPEED_MPH,source02$PASSENGER_HOURS,source02$AVG_TRIP_LENGTH_MINUTES,source02$PASSENGER_MILES_PER_GALLON_FUEL),]
source03 <- source03[order(source03$YR,source03$DATE_COUNTED,source03$ROUTE_NUM,source03$ROUTE_NAME,source03$SERVICE_CODE,source03$SERVICE_TYPE,source03$SERVICE_CLASS,source03$SERVICE_MODE,source03$TRIPS,source03$TRIPS_GROSS,source03$SUM_PASSENGERS_ON,source03$SUM_FON,source03$SUM_RON,source03$SUM_PASSENGERS_OFF,source03$SUM_FOFF,source03$SUM_ROFF,source03$SUM_WHEELCHAIRS,source03$SUM_BICYCLES,source03$SUM_KNEELS,source03$MAX_LOAD,source03$MAX_LOAD_P,source03$AVG_MAX_LOAD,source03$SUM_TP_EARLY,source03$SUM_TP_ONTIME,source03$SUM_TP_LATE,source03$ONTIME,source03$SUM_REVENUE_MILES,source03$SUM_REVENUE_HOURS,source03$AVG_PASSENGERS_ON,source03$AVG_PASSENGERS_OFF,source03$AVG_REVENUE_MILES,source03$AVG_REVENUE_HOURS,source03$SUM_PASSENGER_MILES,source03$AVG_PASSENGER_MILES,source03$SUM_SEAT_MILES,source03$AVG_PASS_PER_MILE,source03$AVG_PASS_PER_HOUR,source03$AVG_SEAT_MILES,source03$AVG_TRIP_LENGTH_MILES,source03$PASSENGER_MILES_PER_SEAT_MILE,source03$VEHICLE_SPEED_MPH,source03$PASSENGER_HOURS,source03$AVG_TRIP_LENGTH_MINUTES,source03$PASSENGER_MILES_PER_GALLON_FUEL),]
source04 <- source04[order(source04$YR,source04$DATE_COUNTED,source04$ROUTE_NUM,source04$ROUTE_NAME,source04$SERVICE_CODE,source04$SERVICE_TYPE,source04$SERVICE_CLASS,source04$SERVICE_MODE,source04$TRIPS,source04$TRIPS_GROSS,source04$SUM_PASSENGERS_ON,source04$SUM_FON,source04$SUM_RON,source04$SUM_PASSENGERS_OFF,source04$SUM_FOFF,source04$SUM_ROFF,source04$SUM_WHEELCHAIRS,source04$SUM_BICYCLES,source04$SUM_KNEELS,source04$MAX_LOAD,source04$MAX_LOAD_P,source04$AVG_MAX_LOAD,source04$SUM_TP_EARLY,source04$SUM_TP_ONTIME,source04$SUM_TP_LATE,source04$ONTIME,source04$SUM_REVENUE_MILES,source04$SUM_REVENUE_HOURS,source04$AVG_PASSENGERS_ON,source04$AVG_PASSENGERS_OFF,source04$AVG_REVENUE_MILES,source04$AVG_REVENUE_HOURS,source04$SUM_PASSENGER_MILES,source04$AVG_PASSENGER_MILES,source04$SUM_SEAT_MILES,source04$AVG_PASS_PER_MILE,source04$AVG_PASS_PER_HOUR,source04$AVG_SEAT_MILES,source04$AVG_TRIP_LENGTH_MILES,source04$PASSENGER_MILES_PER_SEAT_MILE,source04$VEHICLE_SPEED_MPH,source04$PASSENGER_HOURS,source04$AVG_TRIP_LENGTH_MINUTES,source04$PASSENGER_MILES_PER_GALLON_FUEL),]
source05 <- source05[order(source05$YR,source05$DATE_COUNTED,source05$ROUTE_NUM,source05$ROUTE_NAME,source05$SERVICE_CODE,source05$SERVICE_TYPE,source05$SERVICE_CLASS,source05$SERVICE_MODE,source05$TRIPS,source05$TRIPS_GROSS,source05$SUM_PASSENGERS_ON,source05$SUM_FON,source05$SUM_RON,source05$SUM_PASSENGERS_OFF,source05$SUM_FOFF,source05$SUM_ROFF,source05$SUM_WHEELCHAIRS,source05$SUM_BICYCLES,source05$SUM_KNEELS,source05$MAX_LOAD,source05$MAX_LOAD_P,source05$AVG_MAX_LOAD,source05$SUM_TP_EARLY,source05$SUM_TP_ONTIME,source05$SUM_TP_LATE,source05$ONTIME,source05$SUM_REVENUE_MILES,source05$SUM_REVENUE_HOURS,source05$AVG_PASSENGERS_ON,source05$AVG_PASSENGERS_OFF,source05$AVG_REVENUE_MILES,source05$AVG_REVENUE_HOURS,source05$SUM_PASSENGER_MILES,source05$AVG_PASSENGER_MILES,source05$SUM_SEAT_MILES,source05$AVG_PASS_PER_MILE,source05$AVG_PASS_PER_HOUR,source05$AVG_SEAT_MILES,source05$AVG_TRIP_LENGTH_MILES,source05$PASSENGER_MILES_PER_SEAT_MILE,source05$VEHICLE_SPEED_MPH,source05$PASSENGER_HOURS,source05$AVG_TRIP_LENGTH_MINUTES,source05$PASSENGER_MILES_PER_GALLON_FUEL),]
source06 <- source06[order(source06$YR,source06$DATE_COUNTED,source06$ROUTE_NUM,source06$ROUTE_NAME,source06$SERVICE_CODE,source06$SERVICE_TYPE,source06$SERVICE_CLASS,source06$SERVICE_MODE,source06$TRIPS,source06$TRIPS_GROSS,source06$SUM_PASSENGERS_ON,source06$SUM_FON,source06$SUM_RON,source06$SUM_PASSENGERS_OFF,source06$SUM_FOFF,source06$SUM_ROFF,source06$SUM_WHEELCHAIRS,source06$SUM_BICYCLES,source06$SUM_KNEELS,source06$MAX_LOAD,source06$MAX_LOAD_P,source06$AVG_MAX_LOAD,source06$SUM_TP_EARLY,source06$SUM_TP_ONTIME,source06$SUM_TP_LATE,source06$ONTIME,source06$SUM_REVENUE_MILES,source06$SUM_REVENUE_HOURS,source06$AVG_PASSENGERS_ON,source06$AVG_PASSENGERS_OFF,source06$AVG_REVENUE_MILES,source06$AVG_REVENUE_HOURS,source06$SUM_PASSENGER_MILES,source06$AVG_PASSENGER_MILES,source06$SUM_SEAT_MILES,source06$AVG_PASS_PER_MILE,source06$AVG_PASS_PER_HOUR,source06$AVG_SEAT_MILES,source06$AVG_TRIP_LENGTH_MILES,source06$PASSENGER_MILES_PER_SEAT_MILE,source06$VEHICLE_SPEED_MPH,source06$PASSENGER_HOURS,source06$AVG_TRIP_LENGTH_MINUTES,source06$PASSENGER_MILES_PER_GALLON_FUEL),]
source07 <- source07[order(source07$YR,source07$DATE_COUNTED,source07$ROUTE_NUM,source07$ROUTE_NAME,source07$SERVICE_CODE,source07$SERVICE_TYPE,source07$SERVICE_CLASS,source07$SERVICE_MODE,source07$TRIPS,source07$TRIPS_GROSS,source07$SUM_PASSENGERS_ON,source07$SUM_FON,source07$SUM_RON,source07$SUM_PASSENGERS_OFF,source07$SUM_FOFF,source07$SUM_ROFF,source07$SUM_WHEELCHAIRS,source07$SUM_BICYCLES,source07$SUM_KNEELS,source07$MAX_LOAD,source07$MAX_LOAD_P,source07$AVG_MAX_LOAD,source07$SUM_TP_EARLY,source07$SUM_TP_ONTIME,source07$SUM_TP_LATE,source07$ONTIME,source07$SUM_REVENUE_MILES,source07$SUM_REVENUE_HOURS,source07$AVG_PASSENGERS_ON,source07$AVG_PASSENGERS_OFF,source07$AVG_REVENUE_MILES,source07$AVG_REVENUE_HOURS,source07$SUM_PASSENGER_MILES,source07$AVG_PASSENGER_MILES,source07$SUM_SEAT_MILES,source07$AVG_PASS_PER_MILE,source07$AVG_PASS_PER_HOUR,source07$AVG_SEAT_MILES,source07$AVG_TRIP_LENGTH_MILES,source07$PASSENGER_MILES_PER_SEAT_MILE,source07$VEHICLE_SPEED_MPH,source07$PASSENGER_HOURS,source07$AVG_TRIP_LENGTH_MINUTES,source07$PASSENGER_MILES_PER_GALLON_FUEL),]
source08 <- source08[order(source08$YR,source08$DATE_COUNTED,source08$ROUTE_NUM,source08$ROUTE_NAME,source08$SERVICE_CODE,source08$SERVICE_TYPE,source08$SERVICE_CLASS,source08$SERVICE_MODE,source08$TRIPS,source08$TRIPS_GROSS,source08$SUM_PASSENGERS_ON,source08$SUM_FON,source08$SUM_RON,source08$SUM_PASSENGERS_OFF,source08$SUM_FOFF,source08$SUM_ROFF,source08$SUM_WHEELCHAIRS,source08$SUM_BICYCLES,source08$SUM_KNEELS,source08$MAX_LOAD,source08$MAX_LOAD_P,source08$AVG_MAX_LOAD,source08$SUM_TP_EARLY,source08$SUM_TP_ONTIME,source08$SUM_TP_LATE,source08$ONTIME,source08$SUM_REVENUE_MILES,source08$SUM_REVENUE_HOURS,source08$AVG_PASSENGERS_ON,source08$AVG_PASSENGERS_OFF,source08$AVG_REVENUE_MILES,source08$AVG_REVENUE_HOURS,source08$SUM_PASSENGER_MILES,source08$AVG_PASSENGER_MILES,source08$SUM_SEAT_MILES,source08$AVG_PASS_PER_MILE,source08$AVG_PASS_PER_HOUR,source08$AVG_SEAT_MILES,source08$AVG_TRIP_LENGTH_MILES,source08$PASSENGER_MILES_PER_SEAT_MILE,source08$VEHICLE_SPEED_MPH,source08$PASSENGER_HOURS,source08$AVG_TRIP_LENGTH_MINUTES,source08$PASSENGER_MILES_PER_GALLON_FUEL),]
source09 <- source09[order(source09$YR,source09$DATE_COUNTED,source09$ROUTE_NUM,source09$ROUTE_NAME,source09$SERVICE_CODE,source09$SERVICE_TYPE,source09$SERVICE_CLASS,source09$SERVICE_MODE,source09$TRIPS,source09$TRIPS_GROSS,source09$SUM_PASSENGERS_ON,source09$SUM_FON,source09$SUM_RON,source09$SUM_PASSENGERS_OFF,source09$SUM_FOFF,source09$SUM_ROFF,source09$SUM_WHEELCHAIRS,source09$SUM_BICYCLES,source09$SUM_KNEELS,source09$MAX_LOAD,source09$MAX_LOAD_P,source09$AVG_MAX_LOAD,source09$SUM_TP_EARLY,source09$SUM_TP_ONTIME,source09$SUM_TP_LATE,source09$ONTIME,source09$SUM_REVENUE_MILES,source09$SUM_REVENUE_HOURS,source09$AVG_PASSENGERS_ON,source09$AVG_PASSENGERS_OFF,source09$AVG_REVENUE_MILES,source09$AVG_REVENUE_HOURS,source09$SUM_PASSENGER_MILES,source09$AVG_PASSENGER_MILES,source09$SUM_SEAT_MILES,source09$AVG_PASS_PER_MILE,source09$AVG_PASS_PER_HOUR,source09$AVG_SEAT_MILES,source09$AVG_TRIP_LENGTH_MILES,source09$PASSENGER_MILES_PER_SEAT_MILE,source09$VEHICLE_SPEED_MPH,source09$PASSENGER_HOURS,source09$AVG_TRIP_LENGTH_MINUTES,source09$PASSENGER_MILES_PER_GALLON_FUEL),]
source10 <- source10[order(source10$YR,source10$DATE_COUNTED,source10$ROUTE_NUM,source10$ROUTE_NAME,source10$SERVICE_CODE,source10$SERVICE_TYPE,source10$SERVICE_CLASS,source10$SERVICE_MODE,source10$TRIPS,source10$TRIPS_GROSS,source10$SUM_PASSENGERS_ON,source10$SUM_FON,source10$SUM_RON,source10$SUM_PASSENGERS_OFF,source10$SUM_FOFF,source10$SUM_ROFF,source10$SUM_WHEELCHAIRS,source10$SUM_BICYCLES,source10$SUM_KNEELS,source10$MAX_LOAD,source10$MAX_LOAD_P,source10$AVG_MAX_LOAD,source10$SUM_TP_EARLY,source10$SUM_TP_ONTIME,source10$SUM_TP_LATE,source10$ONTIME,source10$SUM_REVENUE_MILES,source10$SUM_REVENUE_HOURS,source10$AVG_PASSENGERS_ON,source10$AVG_PASSENGERS_OFF,source10$AVG_REVENUE_MILES,source10$AVG_REVENUE_HOURS,source10$SUM_PASSENGER_MILES,source10$AVG_PASSENGER_MILES,source10$SUM_SEAT_MILES,source10$AVG_PASS_PER_MILE,source10$AVG_PASS_PER_HOUR,source10$AVG_SEAT_MILES,source10$AVG_TRIP_LENGTH_MILES,source10$PASSENGER_MILES_PER_SEAT_MILE,source10$VEHICLE_SPEED_MPH,source10$PASSENGER_HOURS,source10$AVG_TRIP_LENGTH_MINUTES,source10$PASSENGER_MILES_PER_GALLON_FUEL),]
source11 <- source11[order(source11$YR,source11$DATE_COUNTED,source11$ROUTE_NUM,source11$ROUTE_NAME,source11$SERVICE_CODE,source11$SERVICE_TYPE,source11$SERVICE_CLASS,source11$SERVICE_MODE,source11$TRIPS_GROSS,source11$TRIPS_GROSS,source11$SUM_PASSENGERS_ON,source11$SUM_FON,source11$SUM_RON,source11$SUM_PASSENGERS_OFF,source11$SUM_FOFF,source11$SUM_ROFF,source11$SUM_WHEELCHAIRS,source11$SUM_BICYCLES,source11$SUM_KNEELS,source11$MAX_LOAD,source11$MAX_LOAD_P,source11$AVG_MAX_LOAD,source11$SUM_TP_EARLY,source11$SUM_TP_ONTIME,source11$SUM_TP_LATE,source11$ONTIME,source11$SUM_REVENUE_MILES,source11$SUM_REVENUE_HOURS,source11$AVG_PASSENGERS_ON,source11$AVG_PASSENGERS_OFF,source11$AVG_REVENUE_MILES,source11$AVG_REVENUE_HOURS,source11$SUM_PASSENGER_MILES,source11$AVG_PASSENGER_MILES,source11$SUM_SEAT_MILES,source11$AVG_PASS_PER_MILE,source11$AVG_PASS_PER_HOUR,source11$AVG_SEAT_MILES,source11$AVG_TRIP_LENGTH_MILES,source11$PASSENGER_MILES_PER_SEAT_MILE,source11$VEHICLE_SPEED_MPH,source11$PASSENGER_HOURS,source11$AVG_TRIP_LENGTH_MINUTES,source11$PASSENGER_MILES_PER_GALLON_FUEL),]
source12 <- source12[order(source12$YR,source12$DATE_COUNTED,source12$ROUTE_NUM,source12$ROUTE_NAME,source12$SERVICE_CODE,source12$SERVICE_TYPE,source12$SERVICE_CLASS,source12$SERVICE_MODE,source12$SUM_PASSENGERS_ON,source12$SUM_PASSENGERS_ON,source12$SUM_PASSENGERS_ON,source12$SUM_FON,source12$SUM_RON,source12$SUM_PASSENGERS_OFF,source12$SUM_FOFF,source12$SUM_ROFF,source12$SUM_WHEELCHAIRS,source12$SUM_BICYCLES,source12$SUM_KNEELS,source12$MAX_LOAD,source12$MAX_LOAD_P,source12$AVG_MAX_LOAD,source12$SUM_TP_EARLY,source12$SUM_TP_ONTIME,source12$SUM_TP_LATE,source12$ONTIME,source12$SUM_REVENUE_MILES,source12$SUM_REVENUE_HOURS,source12$AVG_PASSENGERS_ON,source12$AVG_PASSENGERS_OFF,source12$AVG_REVENUE_MILES,source12$AVG_REVENUE_HOURS,source12$SUM_PASSENGER_MILES,source12$AVG_PASSENGER_MILES,source12$SUM_SEAT_MILES,source12$AVG_PASS_PER_MILE,source12$AVG_PASS_PER_HOUR,source12$AVG_SEAT_MILES,source12$AVG_TRIP_LENGTH_MILES,source12$PASSENGER_MILES_PER_SEAT_MILE,source12$VEHICLE_SPEED_MPH,source12$PASSENGER_HOURS,source12$AVG_TRIP_LENGTH_MINUTES,source12$PASSENGER_MILES_PER_GALLON_FUEL),]
source13 <- source13[order(source13$YR,source13$DATE_COUNTED,source13$ROUTE_NUM,source13$ROUTE_NAME,source13$SERVICE_CODE,source13$SERVICE_TYPE,source13$SERVICE_CLASS,source13$SERVICE_MODE,source13$SUM_FON,source13$SUM_FON,source13$SUM_FON,source13$SUM_FON,source13$SUM_RON,source13$SUM_PASSENGERS_OFF,source13$SUM_FOFF,source13$SUM_ROFF,source13$SUM_WHEELCHAIRS,source13$SUM_BICYCLES,source13$SUM_KNEELS,source13$MAX_LOAD,source13$MAX_LOAD_P,source13$AVG_MAX_LOAD,source13$SUM_TP_EARLY,source13$SUM_TP_ONTIME,source13$SUM_TP_LATE,source13$ONTIME,source13$SUM_REVENUE_MILES,source13$SUM_REVENUE_HOURS,source13$AVG_PASSENGERS_ON,source13$AVG_PASSENGERS_OFF,source13$AVG_REVENUE_MILES,source13$AVG_REVENUE_HOURS,source13$SUM_PASSENGER_MILES,source13$AVG_PASSENGER_MILES,source13$SUM_SEAT_MILES,source13$AVG_PASS_PER_MILE,source13$AVG_PASS_PER_HOUR,source13$AVG_SEAT_MILES,source13$AVG_TRIP_LENGTH_MILES,source13$PASSENGER_MILES_PER_SEAT_MILE,source13$VEHICLE_SPEED_MPH,source13$PASSENGER_HOURS,source13$AVG_TRIP_LENGTH_MINUTES,source13$PASSENGER_MILES_PER_GALLON_FUEL),]
source14 <- source14[order(source14$YR,source14$DATE_COUNTED,source14$ROUTE_NUM,source14$ROUTE_NAME,source14$SERVICE_CODE,source14$SERVICE_TYPE,source14$SERVICE_CLASS,source14$SERVICE_MODE,source14$SUM_RON,source14$SUM_RON,source14$SUM_RON,source14$SUM_RON,source14$SUM_RON,source14$SUM_PASSENGERS_OFF,source14$SUM_FOFF,source14$SUM_ROFF,source14$SUM_WHEELCHAIRS,source14$SUM_BICYCLES,source14$SUM_KNEELS,source14$MAX_LOAD,source14$MAX_LOAD_P,source14$AVG_MAX_LOAD,source14$SUM_TP_EARLY,source14$SUM_TP_ONTIME,source14$SUM_TP_LATE,source14$ONTIME,source14$SUM_REVENUE_MILES,source14$SUM_REVENUE_HOURS,source14$AVG_PASSENGERS_ON,source14$AVG_PASSENGERS_OFF,source14$AVG_REVENUE_MILES,source14$AVG_REVENUE_HOURS,source14$SUM_PASSENGER_MILES,source14$AVG_PASSENGER_MILES,source14$SUM_SEAT_MILES,source14$AVG_PASS_PER_MILE,source14$AVG_PASS_PER_HOUR,source14$AVG_SEAT_MILES,source14$AVG_TRIP_LENGTH_MILES,source14$PASSENGER_MILES_PER_SEAT_MILE,source14$VEHICLE_SPEED_MPH,source14$PASSENGER_HOURS,source14$AVG_TRIP_LENGTH_MINUTES,source14$PASSENGER_MILES_PER_GALLON_FUEL),]
source15 <- source15[order(source15$YR,source15$DATE_COUNTED,source15$ROUTE_NUM,source15$ROUTE_NAME,source15$SERVICE_CODE,source15$SERVICE_TYPE,source15$SERVICE_CLASS,source15$SERVICE_MODE,source15$SUM_PASSENGERS_OFF,source15$SUM_PASSENGERS_OFF,source15$SUM_PASSENGERS_OFF,source15$SUM_PASSENGERS_OFF,source15$SUM_PASSENGERS_OFF,source15$SUM_PASSENGERS_OFF,source15$SUM_FOFF,source15$SUM_ROFF,source15$SUM_WHEELCHAIRS,source15$SUM_BICYCLES,source15$SUM_KNEELS,source15$MAX_LOAD,source15$MAX_LOAD_P,source15$AVG_MAX_LOAD,source15$SUM_TP_EARLY,source15$SUM_TP_ONTIME,source15$SUM_TP_LATE,source15$ONTIME,source15$SUM_REVENUE_MILES,source15$SUM_REVENUE_HOURS,source15$AVG_PASSENGERS_ON,source15$AVG_PASSENGERS_OFF,source15$AVG_REVENUE_MILES,source15$AVG_REVENUE_HOURS,source15$SUM_PASSENGER_MILES,source15$AVG_PASSENGER_MILES,source15$SUM_SEAT_MILES,source15$AVG_PASS_PER_MILE,source15$AVG_PASS_PER_HOUR,source15$AVG_SEAT_MILES,source15$AVG_TRIP_LENGTH_MILES,source15$PASSENGER_MILES_PER_SEAT_MILE,source15$VEHICLE_SPEED_MPH,source15$PASSENGER_HOURS,source15$AVG_TRIP_LENGTH_MINUTES,source15$PASSENGER_MILES_PER_GALLON_FUEL),]
source16 <- source16[order(source16$YR,source16$DATE_COUNTED,source16$ROUTE_NUM,source16$ROUTE_NAME,source16$SERVICE_CODE,source16$SERVICE_TYPE,source16$SERVICE_CLASS,source16$SERVICE_MODE,source16$SUM_FOFF,source16$SUM_FOFF,source16$SUM_FOFF,source16$SUM_FOFF,source16$SUM_FOFF,source16$SUM_FOFF,source16$SUM_FOFF,source16$SUM_ROFF,source16$SUM_WHEELCHAIRS,source16$SUM_BICYCLES,source16$SUM_KNEELS,source16$MAX_LOAD,source16$MAX_LOAD_P,source16$AVG_MAX_LOAD,source16$SUM_TP_EARLY,source16$SUM_TP_ONTIME,source16$SUM_TP_LATE,source16$ONTIME,source16$SUM_REVENUE_MILES,source16$SUM_REVENUE_HOURS,source16$AVG_PASSENGERS_ON,source16$AVG_PASSENGERS_OFF,source16$AVG_REVENUE_MILES,source16$AVG_REVENUE_HOURS,source16$SUM_PASSENGER_MILES,source16$AVG_PASSENGER_MILES,source16$SUM_SEAT_MILES,source16$AVG_PASS_PER_MILE,source16$AVG_PASS_PER_HOUR,source16$AVG_SEAT_MILES,source16$AVG_TRIP_LENGTH_MILES,source16$PASSENGER_MILES_PER_SEAT_MILE,source16$VEHICLE_SPEED_MPH,source16$PASSENGER_HOURS,source16$AVG_TRIP_LENGTH_MINUTES,source16$PASSENGER_MILES_PER_GALLON_FUEL),]
source17 <- source17[order(source17$YR,source17$DATE_COUNTED,source17$ROUTE_NUM,source17$ROUTE_NAME,source17$SERVICE_CODE,source17$SERVICE_TYPE,source17$SERVICE_CLASS,source17$SERVICE_MODE,source17$SUM_ROFF,source17$SUM_ROFF,source17$SUM_ROFF,source17$SUM_ROFF,source17$SUM_ROFF,source17$SUM_ROFF,source17$SUM_ROFF,source17$SUM_ROFF,source17$SUM_WHEELCHAIRS,source17$SUM_BICYCLES,source17$SUM_KNEELS,source17$MAX_LOAD,source17$MAX_LOAD_P,source17$AVG_MAX_LOAD,source17$SUM_TP_EARLY,source17$SUM_TP_ONTIME,source17$SUM_TP_LATE,source17$ONTIME,source17$SUM_REVENUE_MILES,source17$SUM_REVENUE_HOURS,source17$AVG_PASSENGERS_ON,source17$AVG_PASSENGERS_OFF,source17$AVG_REVENUE_MILES,source17$AVG_REVENUE_HOURS,source17$SUM_PASSENGER_MILES,source17$AVG_PASSENGER_MILES,source17$SUM_SEAT_MILES,source17$AVG_PASS_PER_MILE,source17$AVG_PASS_PER_HOUR,source17$AVG_SEAT_MILES,source17$AVG_TRIP_LENGTH_MILES,source17$PASSENGER_MILES_PER_SEAT_MILE,source17$VEHICLE_SPEED_MPH,source17$PASSENGER_HOURS,source17$AVG_TRIP_LENGTH_MINUTES,source17$PASSENGER_MILES_PER_GALLON_FUEL),]
source18 <- source18[order(source18$YR,source18$DATE_COUNTED,source18$ROUTE_NUM,source18$ROUTE_NAME,source18$SERVICE_CODE,source18$SERVICE_TYPE,source18$SERVICE_CLASS,source18$SERVICE_MODE,source18$SUM_WHEELCHAIRS,source18$SUM_WHEELCHAIRS,source18$SUM_WHEELCHAIRS,source18$SUM_WHEELCHAIRS,source18$SUM_WHEELCHAIRS,source18$SUM_WHEELCHAIRS,source18$SUM_WHEELCHAIRS,source18$SUM_WHEELCHAIRS,source18$SUM_WHEELCHAIRS,source18$SUM_BICYCLES,source18$SUM_KNEELS,source18$MAX_LOAD,source18$MAX_LOAD_P,source18$AVG_MAX_LOAD,source18$SUM_TP_EARLY,source18$SUM_TP_ONTIME,source18$SUM_TP_LATE,source18$ONTIME,source18$SUM_REVENUE_MILES,source18$SUM_REVENUE_HOURS,source18$AVG_PASSENGERS_ON,source18$AVG_PASSENGERS_OFF,source18$AVG_REVENUE_MILES,source18$AVG_REVENUE_HOURS,source18$SUM_PASSENGER_MILES,source18$AVG_PASSENGER_MILES,source18$SUM_SEAT_MILES,source18$AVG_PASS_PER_MILE,source18$AVG_PASS_PER_HOUR,source18$AVG_SEAT_MILES,source18$AVG_TRIP_LENGTH_MILES,source18$PASSENGER_MILES_PER_SEAT_MILE,source18$VEHICLE_SPEED_MPH,source18$PASSENGER_HOURS,source18$AVG_TRIP_LENGTH_MINUTES,source18$PASSENGER_MILES_PER_GALLON_FUEL),]
source19 <- source19[order(source19$YR,source19$DATE_COUNTED,source19$ROUTE_NUM,source19$ROUTE_NAME,source19$SERVICE_CODE,source19$SERVICE_TYPE,source19$SERVICE_CLASS,source19$SERVICE_MODE,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_BICYCLES,source19$SUM_KNEELS,source19$MAX_LOAD,source19$MAX_LOAD_P,source19$AVG_MAX_LOAD,source19$SUM_TP_EARLY,source19$SUM_TP_ONTIME,source19$SUM_TP_LATE,source19$ONTIME,source19$SUM_REVENUE_MILES,source19$SUM_REVENUE_HOURS,source19$AVG_PASSENGERS_ON,source19$AVG_PASSENGERS_OFF,source19$AVG_REVENUE_MILES,source19$AVG_REVENUE_HOURS,source19$SUM_PASSENGER_MILES,source19$AVG_PASSENGER_MILES,source19$SUM_SEAT_MILES,source19$AVG_PASS_PER_MILE,source19$AVG_PASS_PER_HOUR,source19$AVG_SEAT_MILES,source19$AVG_TRIP_LENGTH_MILES,source19$PASSENGER_MILES_PER_SEAT_MILE,source19$VEHICLE_SPEED_MPH,source19$PASSENGER_HOURS,source19$AVG_TRIP_LENGTH_MINUTES,source19$PASSENGER_MILES_PER_GALLON_FUEL),]

#Merge source files into one file
source <- do.call("rbind", list(source02,source03,source04,source05,source06,source07,source08,source09,source10,source11,source12,source13,source14,source15,source16,source17,source18,source19))
#rm(source)

#Remove other source files
rm(source02,source03,source04,source05,source06,source07,source08,source09,source10,source11,source12,source13,source14,source15,source16,source17,source18,source19)

#Add new columns to source data table
source$VINTAGE_YR <- "2019"

#Rename files
db <- plyr::rename(db, c("vintage_yr"="VINTAGE_YR","yr"="YR","date_counted"="DATE_COUNTED","route_num"="ROUTE_NUM","route_name"="ROUTE_NAME","service_code"="SERVICE_CODE","service_type"="SERVICE_TYPE","service_class"="SERVICE_CLASS","service_mode"="SERVICE_MODE","trips"="TRIPS","trips_gross"="TRIPS_GROSS","sum_passengers_on"="SUM_PASSENGERS_ON","sum_fon"="SUM_FON","sum_ron"="SUM_RON","sum_passengers_off"="SUM_PASSENGERS_OFF","sum_foff"="SUM_FOFF","sum_roff"="SUM_ROFF","sum_wheelchairs"="SUM_WHEELCHAIRS","sum_bicycles"="SUM_BICYCLES","sum_kneels"="SUM_KNEELS","max_load"="MAX_LOAD","max_load_p"="MAX_LOAD_P","avg_max_load"="AVG_MAX_LOAD","sum_tp_early"="SUM_TP_EARLY","sum_tp_ontime"="SUM_TP_ONTIME","sum_tp_late"="SUM_TP_LATE","ontime"="ONTIME","sum_revenue_miles"="SUM_REVENUE_MILES","sum_revenue_hours"="SUM_REVENUE_HOURS","avg_passengers_on"="AVG_PASSENGERS_ON","avg_passengers_off"="AVG_PASSENGERS_OFF","avg_revenue_miles"="AVG_REVENUE_MILES","avg_revenue_hours"="AVG_REVENUE_HOURS","sum_passenger_miles"="SUM_PASSENGER_MILES","avg_passenger_miles"="AVG_PASSENGER_MILES","sum_seat_miles"="SUM_SEAT_MILES","avg_pass_per_mile"="AVG_PASS_PER_MILE","avg_pass_per_hour"="AVG_PASS_PER_HOUR","avg_seat_miles"="AVG_SEAT_MILES","avg_trip_length_miles"="AVG_TRIP_LENGTH_MILES","passenger_miles_per_seat_mile"="PASSENGER_MILES_PER_SEAT_MILE","vehicle_speed_mph"="VEHICLE_SPEED_MPH","passenger_hours"="PASSENGER_HOURS","avg_trip_length_minutes"="AVG_TRIP_LENGTH_MINUTES","passenger_miles_per_gallon_fuel"="PASSENGER_MILES_PER_GALLON_FUEL"))

#Order files
source <- source[,c("VINTAGE_YR","YR","DATE_COUNTED","ROUTE_NUM","ROUTE_NAME","SERVICE_CODE","SERVICE_TYPE","SERVICE_CLASS","SERVICE_MODE","TRIPS","TRIPS_GROSS","SUM_PASSENGERS_ON","SUM_FON","SUM_RON","SUM_PASSENGERS_OFF","SUM_FOFF","SUM_ROFF","SUM_WHEELCHAIRS","SUM_BICYCLES","SUM_KNEELS","MAX_LOAD","MAX_LOAD_P","AVG_MAX_LOAD","SUM_TP_EARLY","SUM_TP_ONTIME","SUM_TP_LATE","ONTIME","SUM_REVENUE_MILES","SUM_REVENUE_HOURS","AVG_PASSENGERS_ON","AVG_PASSENGERS_OFF","AVG_REVENUE_MILES","AVG_REVENUE_HOURS","SUM_PASSENGER_MILES","AVG_PASSENGER_MILES","SUM_SEAT_MILES","AVG_PASS_PER_MILE","AVG_PASS_PER_HOUR","AVG_SEAT_MILES","AVG_TRIP_LENGTH_MILES","PASSENGER_MILES_PER_SEAT_MILE","VEHICLE_SPEED_MPH","PASSENGER_HOURS","AVG_TRIP_LENGTH_MINUTES","PASSENGER_MILES_PER_GALLON_FUEL")]
source <- source[order(source$VINTAGE_YR,source$YR,source$DATE_COUNTED,source$ROUTE_NUM,source$ROUTE_NAME,source$SERVICE_CODE,source$SERVICE_TYPE,source$SERVICE_CLASS,source$SERVICE_MODE,source$TRIPS,source$TRIPS_GROSS,source$SUM_PASSENGERS_ON,source$SUM_FON,source$SUM_RON,source$SUM_PASSENGERS_OFF,source$SUM_FOFF,source$SUM_ROFF,source$SUM_WHEELCHAIRS,source$SUM_BICYCLES,source$SUM_KNEELS,source$MAX_LOAD,source$MAX_LOAD_P,source$AVG_MAX_LOAD,source$SUM_TP_EARLY,source$SUM_TP_ONTIME,source$SUM_TP_LATE,source$ONTIME,source$SUM_REVENUE_MILES,source$SUM_REVENUE_HOURS,source$AVG_PASSENGERS_ON,source$AVG_PASSENGERS_OFF,source$AVG_REVENUE_MILES,source$AVG_REVENUE_HOURS,source$SUM_PASSENGER_MILES,source$AVG_PASSENGER_MILES,source$SUM_SEAT_MILES,source$AVG_PASS_PER_MILE,source$AVG_PASS_PER_HOUR,source$AVG_SEAT_MILES,source$AVG_TRIP_LENGTH_MILES,source$PASSENGER_MILES_PER_SEAT_MILE,source$VEHICLE_SPEED_MPH,source$PASSENGER_HOURS,source$AVG_TRIP_LENGTH_MINUTES,source$PASSENGER_MILES_PER_GALLON_FUEL),]
db <- db[order(db$VINTAGE_YR,db$YR,db$DATE_COUNTED,db$ROUTE_NUM,db$ROUTE_NAME,db$SERVICE_CODE,db$SERVICE_TYPE,db$SERVICE_CLASS,db$SERVICE_MODE,db$TRIPS,db$TRIPS_GROSS,db$SUM_PASSENGERS_ON,db$SUM_FON,db$SUM_RON,db$SUM_PASSENGERS_OFF,db$SUM_FOFF,db$SUM_ROFF,db$SUM_WHEELCHAIRS,db$SUM_BICYCLES,db$SUM_KNEELS,db$MAX_LOAD,db$MAX_LOAD_P,db$AVG_MAX_LOAD,db$SUM_TP_EARLY,db$SUM_TP_ONTIME,db$SUM_TP_LATE,db$ONTIME,db$SUM_REVENUE_MILES,db$SUM_REVENUE_HOURS,db$AVG_PASSENGERS_ON,db$AVG_PASSENGERS_OFF,db$AVG_REVENUE_MILES,db$AVG_REVENUE_HOURS,db$SUM_PASSENGER_MILES,db$AVG_PASSENGER_MILES,db$SUM_SEAT_MILES,db$AVG_PASS_PER_MILE,db$AVG_PASS_PER_HOUR,db$AVG_SEAT_MILES,db$AVG_TRIP_LENGTH_MILES,db$PASSENGER_MILES_PER_SEAT_MILE,db$VEHICLE_SPEED_MPH,db$PASSENGER_HOURS,db$AVG_TRIP_LENGTH_MINUTES,db$PASSENGER_MILES_PER_GALLON_FUEL),]

#Check data types
str(source)
str(db)
all.equal(str(source),str(db))

#Convert data types
source$VINTAGE_YR <- as.integer(source$VINTAGE_YR)
source$YR <- as.integer(source$YR)
source$DATE_COUNTED_test <- as.Date(as.numeric(as.character(source$DATE_COUNTED)), origin = "1899-12-30", format = "%Y-%m-%d")
source$ROUTE_NUM <- as.numeric(source$ROUTE_NUM)
source$TRIPS <- as.integer(source$TRIPS)
source$TRIPS_GROSS <- as.integer(source$TRIPS_GROSS)
source$SUM_PASSENGERS_ON <- as.numeric(source$SUM_PASSENGERS_ON)
source$SUM_FON <- as.integer(source$SUM_FON)
source$SUM_RON <- as.integer(source$SUM_RON)
source$SUM_FOFF <- as.integer(source$SUM_FOFF)
source$SUM_ROFF <- as.integer(source$SUM_ROFF)
source$SUM_WHEELCHAIRS <- as.integer(source$SUM_WHEELCHAIRS)
source$SUM_BICYCLES <- as.integer(source$SUM_BICYCLES)
source$SUM_KNEELS <- as.integer(source$SUM_KNEELS)
source$SUM_REVENUE_MILES <- as.numeric(source$SUM_REVENUE_MILES)
source$SUM_REVENUE_HOURS <- as.numeric(source$SUM_REVENUE_HOURS)
source$AVG_PASS_PER_MILE <- as.numeric(source$AVG_PASS_PER_MILE)
source$AVG_PASS_PER_HOUR <- as.numeric(source$AVG_PASS_PER_HOUR)
source$AVG_TRIP_LENGTH_MILES <- as.numeric(source$AVG_TRIP_LENGTH_MILES)
source$VEHICLE_SPEED_MPH <- as.numeric(source$VEHICLE_SPEED_MPH)
source$PASSENGER_HOURS <- as.numeric(source$PASSENGER_HOURS)
source$AVG_TRIP_LENGTH_MINUTES <- as.numeric(source$AVG_TRIP_LENGTH_MINUTES)
source$PASSENGER_MILES_PER_GALLON_FUEL <- as.numeric(source$PASSENGER_MILES_PER_GALLON_FUEL)

#delete rownames for checking files match
rownames(source) <- NULL
rownames(db) <- NULL

# compare source and to database files to ensure they match
all(source == db)
all.equal(source,db)
identical(source,db)
which(source!=db, arr.ind=TRUE)

# db[183,1:4]
# source[183,1:4]

