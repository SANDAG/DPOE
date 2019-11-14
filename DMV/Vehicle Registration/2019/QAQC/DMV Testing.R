#DMV Vehicle Registration Data QA/QC

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Check source file to raw database upload
#Read in source files
source2010 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2010.csv",sep=',', header = TRUE)
source2011 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2011.csv",sep=',', header = TRUE)
source2012 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2012.csv",sep=',', header = TRUE)
source2013 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2013.csv",sep=',', header = TRUE)
source2014 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2014.csv",sep=',', header = TRUE)
source2015 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2015.csv",sep=',', header = TRUE)
source2016 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2016.csv",sep=',', header = TRUE)
source2017 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2017.csv",sep=',', header = TRUE)
source2018 <- read.csv("R:\\DPOE\\Vehicle Registration\\DMV\\2019\\Source\\SANDAG2018.csv",sep=',', header = TRUE)

#Merge source files into one file
source <- do.call("rbind", list(source2010,source2011,source2012,source2013,source2014,source2015,source2016,source2017,source2018))

#Read in SQL files
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql2010 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2010]'          
db2010 <- sqlQuery(channel,sql2010,stringsAsFactors = FALSE)

sql2011 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2011]'          
db2011 <- sqlQuery(channel,sql2011,stringsAsFactors = FALSE)

sql2012 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2012]'          
db2012 <- sqlQuery(channel,sql2012,stringsAsFactors = FALSE)

sql2013 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2013]'          
db2013 <- sqlQuery(channel,sql2013,stringsAsFactors = FALSE)

sql2014 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2014]'          
db2014 <- sqlQuery(channel,sql2014,stringsAsFactors = FALSE)

sql2015 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2015]'          
db2015 <- sqlQuery(channel,sql2015,stringsAsFactors = FALSE)

sql2016 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2016]'          
db2016 <- sqlQuery(channel,sql2016,stringsAsFactors = FALSE)

sql2017 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2017]'          
db2017 <- sqlQuery(channel,sql2017,stringsAsFactors = FALSE)

sql2018 <- 'SELECT * FROM [dpoe_stage].[dbo].[SANDAG2018]'          
db2018 <- sqlQuery(channel,sql2018,stringsAsFactors = FALSE)
odbcClose(channel)

#Merge db files into one file
db <- do.call("rbind", list(db2010,db2011,db2012,db2013,db2014,db2015,db2016,db2017,db2018))

#Check data types
# str(source)
# str(db)

#Convert data types
source$ADDRESS <- as.character(source$ADDRESS)
source$MAKE <- as.character(source$MAKE)
source$SERIES <- as.character(source$SERIES)
source$MODEL <- as.character(source$MODEL)
source$FUEL <- as.character(source$FUEL)
source$LOCSOLD <- as.character(source$LOCSOLD)
source$OWNERSHIP <- as.character(source$OWNERSHIP)

#Order files
source <- source[order(source$YEAR,source$ADDRESS,source$ZIP,source$MAKE,source$SERIES,source$MODEL,source$MODEL_YEAR,source$OWN_DATE,source$REG_DATE,source$FUEL,source$LOCSOLD,source$OWNERSHIP),]
db <- db[order(db$YEAR,db$ADDRESS,db$ZIP,db$MAKE,db$SERIES,db$MODEL,db$MODEL_YEAR,db$OWN_DATE,db$REG_DATE,db$FUEL,db$LOCSOLD,db$OWNERSHIP),]

#delete rownames for checking files match
rownames(source) <- NULL
rownames(db) <- NULL

#Compare files 
all(source == db) #check cell values only
all.equal(source,db) #check cell values and data types and will return the conflicted cells
identical(source,db) #check cell values and data types
which(source!=db, arr.ind = TRUE)

#Delete individual data frames
# rm(db2010,db2011,db2012,db2013,db2014,db2015,db2016,db2017,db2018)
# rm(source2010,source2011,source2012,source2013,source2014,source2015,source2016,source2017,source2018)

# source[9194888,4]
# db[9194888,4]

########################################################################################################################################################

#Check source file to final database upload

#Load fact table
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT * FROM [dpoe_stage].[fact].[dmv_vehicle_reg]'          
fact <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#Drop ID column from fact table
fact <- fact[-1]

#Rename columns in source file
source <- plyr::rename(source, c("YEAR"="yr", "ADDRESS"="address", "ZIP"="zip", "MAKE"="make", "SERIES"="series", "MODEL"="model", "MODEL_YEAR"="model_yr", "OWN_DATE"="own_date", "REG_DATE"="reg_date", "FUEL"="fuel_type", "LOCSOLD"="loc_sold", "OWNERSHIP"="own"))

#Check data types
# str(source)
# str(fact)

#Change data types
fact$reg_date <- as.Date(fact$reg_date)
fact$own_date <- as.Date(fact$own_date)
source$own_date <- formatC(source$own_date, width = 6, format = "d", flag = "0")
source$reg_date <- formatC(source$reg_date, width = 6, format = "d", flag = "0")
source$own_date <- as.Date(as.character(source$own_date), format='%y%m%d')
source$reg_date <- as.Date(as.character(source$reg_date), format='%y%m%d')

#Replace blanks and 00000's with NA's
source$zip[source$zip == 00000] <- NA
source$own_date[source$own_date == 000000] <- NA
source$reg_date[source$reg_date == 000000] <- NA
source$zip[source$zip == ""] <- NA
source$model[source$model == ""] <- NA
source$model_yr[source$model_yr == ""] <- NA
source$make[source$make == ""] <- NA
source$series[source$series == ""] <- NA
source$fuel_type[source$fuel_type == ""] <- NA

#Overwrite incorrect 20XX values with 19XX values
source[2643179,9] <- "1965-09-15"
source[3937875,9] <- "1968-05-16"
source[402207,9] <- "1965-09-15"
source[1678011,9] <- "1968-05-16"
source[2643179,9] <- "1965-09-15"
source[3937875,9] <- "1968-05-16"
source[4919394,9] <- "1965-09-15"
source[6241464,9] <- "1968-05-16"
source[7243594,9] <- "1965-09-15"
source[8597050,9] <- "1968-05-16"
source[9623017,9] <- "1965-09-15"
source[11016554,9] <- "1968-05-16"
source[12071424,9] <- "1965-09-15"
source[13516930,9] <- "1968-05-16"
source[14600697,9] <- "1965-09-15"
source[16071419,9] <- "1968-05-16"
source[17170819,9] <- "1965-09-15"
source[18653902,9] <- "1968-05-16"
source[19779097,9] <- "1965-09-15"
source[21327362,9] <- "1968-05-16"

#Order data
source <- source[order(source$yr,source$address,source$zip,source$make,source$series,source$model,source$model_yr,source$own_date,source$reg_date,source$fuel_type,source$loc_sold,source$own),]
fact <- fact[order(fact$yr,fact$address,fact$zip,fact$make,fact$series,fact$model,fact$model_yr,fact$own_date,fact$reg_date,fact$fuel_type,fact$loc_sold,fact$own),]

#delete rownames for checking files match
rownames(source) <- NULL
rownames(fact) <- NULL

#Compare files 
all(source == fact) #check cell values only
all.equal(source,fact) #check cell values and data types and will return the conflicted cells
identical(source,fact) #check cell values and data types
which(source!=fact, arr.ind = TRUE)

source[3937875,9]
fact[7243594,9]
