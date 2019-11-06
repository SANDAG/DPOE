#DMV Vehicle Registration Data QA/QC

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Check source file to raw database upload
#Read in source files
source2010 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2010.csv",sep=',', header = TRUE)
source2011 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2011.csv",sep=',', header = TRUE)
source2012 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2012.csv",sep=',', header = TRUE)
source2013 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2013.csv",sep=',', header = TRUE)
source2014 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2014.csv",sep=',', header = TRUE)
source2015 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2015.csv",sep=',', header = TRUE)
source2016 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2016.csv",sep=',', header = TRUE)
source2017 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2017.csv",sep=',', header = TRUE)
source2018 <- read.csv("R:\\DPOE\\DMV Data\\2019\\Source\\Vehicle Registration\\SANDAG2018.csv",sep=',', header = TRUE)

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
str(source)
str(db)

#Convert data types
source$ADDRESS <- as.character(source$ADDRESS)
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

source[9194888,4]
db[9194888,4]