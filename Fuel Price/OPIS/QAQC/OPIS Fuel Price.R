# File Comparison between source data and raw database data

#function to load packages
pkgTest <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dep = TRUE)
  sapply(pkg, require, character.only = TRUE)
  
  
}

#identify packages to be loaded
packages <- c("data.table", "sqldf", "rstudioapi", "RODBC", "dplyr", "reshape2", 
              "stringr", "tidyverse", "readxl")
#confirm packages are read in
pkgTest(packages)

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("../QAQC/readSQL.R")

getwd()

#turn off strings reading in as factors
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')

#read in SQL data
sql_query <- 'SELECT * FROM [dpoe_stage].[dbo].[opis_fuel_price_0105_1213]'
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)

sql_query1 <- 'SELECT * FROM [dpoe_stage].[dbo].[opis_fuel_price_0114_1217]'
database_data1 <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)

sql_query2 <- 'SELECT * FROM [dpoe_stage].[dbo].[opis_fuel_price_0118_0519]'
database_data2 <- sqlQuery(channel,sql_query2,stringsAsFactors = FALSE)

#Read in excel data
#Dataset #1 - January 2005 to December 2013 OPIS Fuel Price Data
Source_data <- read_excel("R:\\DPOE\\OPIS Fuel Price\\SourceData\\OPIS_FUEL_010105to123113.xlsx")
#Dataset #2 - January 2014 to December 2017 OPIS Fuel Price Data
Source_data1 <- read_excel("R:\\DPOE\\OPIS Fuel Price\\SourceData\\SDAG_OPIS retail margin history_020618.xlsx")
#Dataset #3-  January 2018 to May 2019 OPIS Fuel Price Data
Source_data2 <- read_excel("R:\\DPOE\\OPIS Fuel Price\\SourceData\\San Diego County Monthly Jan 2018-May 2019.xlsx")

#View column names in source data
head(Source_data)
head(Source_data1)
head(Source_data2)

#Rename source data. Make sure order is the same as in the database.
Source_data <- plyr::rename(Source_data, c("Region Name"="region", "Product"="product", "Start Date"="start_date", 
               "Station Count"="station_count","Retail Average"="retail_avg"))

Source_data1 <- plyr::rename(Source_data1, c("Region Name"="region", "RP Name"="product", "Start Date"="start_date", "Retail Average"="retail_avg", "Wholesale Average"="wholesale_avg",
                                             "Tax Average"="tax_avg", "Freight Average"="freight_avg", "Margin Average"="margin_avg", "Net Average"="net_avg"))

Source_data2 <- plyr::rename(Source_data2, c("Region Name"="region", "Product"="product", "Start Date"="start_date", "Retail Average"="retail_avg", "Wholesale Average"="wholesale_avg",
                                             "Tax Average"="tax_avg", "Freight Average"="freight_avg", "Margin Average"="margin_avg", "Net Average"="net_avg"))

#Convert field Start Date to a Date field
Source_data$start_date <- as.Date((Source_data$start_date), format = "%Y-%m-%d")
database_data$start_date <- as.Date((database_data$start_date), format = "%Y-%m-%d")

Source_data1$start_date <- as.Date((Source_data1$start_date), format = "%Y-%m-%d")
database_data1$start_date <- as.Date((database_data1$start_date), format = "%Y-%m-%d")

Source_data2$start_date <- as.Date((Source_data2$start_date), format = "%Y-%m-%d")
database_data2$start_date <- as.Date((database_data2$start_date), format = "%Y-%m-%d")

#Check data types
sapply(Source_data, class)
sapply(database_data, class)
sapply(Source_data1, class)
sapply(database_data1, class)
sapply(Source_data2, class)
sapply(database_data2, class)

#trim whitespace from product column values
Source_data1$product <- trimws(Source_data1$product)
Source_data2$product <- trimws(Source_data2$product)
database_data1$product <- trimws(database_data1$product)
database_data2$product <- trimws(database_data2$product)

#check values for the product field
table(database_data$product)
table(database_data1$product)
table(database_data2$product)
table(Source_data$product)
table(Source_data1$product)
table(Source_data2$product)


#Order data frames for comparison
Source_data <- Source_data[order(Source_data$region, Source_data$product, Source_data$start_date, Source_data$station_count, Source_data$retail_avg),]
database_data <- database_data[order(database_data$region, database_data$product, database_data$start_date, database_data$station_count, database_data$retail_avg),]

Source_data1 <- Source_data1[order(Source_data1$region, Source_data1$product, Source_data1$start_date, Source_data1$retail_avg, Source_data1$wholesale_avg, Source_data1$tax_avg, 
                                   Source_data1$freight_avg),]
database_data1 <- database_data1[order(database_data1$region, database_data1$product, database_data1$start_date, database_data1$retail_avg, database_data1$wholesale_avg, 
                                       database_data1$tax_avg, database_data1$freight_avg, database_data1$margin_avg, database_data1$net_avg),]

Source_data2 <- Source_data2[order(Source_data2$region, Source_data2$product, Source_data2$start_date, Source_data2$retail_avg, Source_data2$wholesale_avg, Source_data2$tax_avg, 
                                   Source_data2$freight_avg),]
database_data2 <- database_data2[order(database_data2$region, database_data2$product, database_data2$start_date, database_data2$retail_avg, database_data2$wholesale_avg, 
                                       database_data2$tax_avg, database_data2$freight_avg, database_data2$margin_avg, database_data2$net_avg),]

#delete rownames for checking files match
rownames(Source_data) <- NULL
rownames(database_data) <- NULL

rownames(Source_data1) <- NULL
rownames(database_data1) <- NULL

rownames(Source_data2) <- NULL
rownames(database_data2) <- NULL

#make source data files data.frame class 
Source_data <- data.frame(Source_data)
Source_data1 <- data.frame(Source_data1)
Source_data2 <- data.frame(Source_data2)


# compare source and to raw database files to ensure they match
all(Source_data == database_data)
identical(Source_data,database_data)
which(Source_data!=database_data, arr.ind=TRUE)

all(Source_data1 == database_data1)
identical(Source_data1,database_data1)
which(Source_data1!=database_data1, arr.ind = TRUE)

all(Source_data2 == database_data2)
identical(Source_data2,database_data2)
which(Source_data2!=database_data2, arr.ind = TRUE)

######################################################################################################################################################
#File comparison between source file to fact table

#Read in sql queries

#2005-2013
sql_query4 = getSQL("../QAQC/Fact Table 2005-2013_1.sql")
db_2005<-sqlQuery(channel,sql_query4)

#2014-2017
sql_query5 = getSQL("../QAQC/Fact Table 2014-2017_1.sql")
db_2014<-sqlQuery(channel,sql_query5)

#2018-2019
sql_query6 = getSQL("../QAQC/Fact Table 2018-2019_1.sql")
db_2018<-sqlQuery(channel,sql_query6)

odbcClose(channel)

#Replace region name to match fact table
Source_data$region[Source_data$region == "County - CA, San Diego"] <- "San Diego County"
Source_data1$region[Source_data1$region == "County - CA, San Diego"] <- "San Diego County"
Source_data2$region[Source_data2$region == "County - CA, San Diego"] <- "San Diego County"

#Replace product types in source data to match db data

#Find unique column values
unique(db_2005$product)
unique(Source_data$product)
unique(db_2014$product)
unique(Source_data1$product)
unique(db_2018$product)
unique(Source_data2$product)

#Unleaded
Source_data$product[Source_data$product == "UNL"] <- "Unleaded Gas"

#Diesel
Source_data$product[Source_data$product == "DSL"] <- "Diesel"

#Midgrade
Source_data$product[Source_data$product == "MID"] <- "Midgrade Gas"
Source_data1$product[Source_data1$product == "Mid"] <- "Midgrade Gas"

#Premium
Source_data$product[Source_data$product == "PRE"] <- "Premium Gas"
Source_data1$product[Source_data1$product == "Pre"] <- "Premium Gas"

#Regular
Source_data1$product[Source_data1$product == "Reg"] <- "Regular Gas"

#Check data types
sapply(Source_data, class)
sapply(db_2005, class)
sapply(Source_data1, class)
sapply(db_2014, class)
sapply(Source_data2, class)
sapply(db_2018, class)

#Convert field Start Date to a Date field
db_2005$start_date <- as.Date((db_2005$start_date), format = "%Y-%m-%d")
db_2014$start_date <- as.Date((db_2014$start_date), format = "%Y-%m-%d")
db_2018$start_date <- as.Date((db_2018$start_date), format = "%Y-%m-%d")

#Convert field station_count to a numeric
db_2005$station_count <- as.numeric(db_2005$station_count)

#Order data frames for comparison
Source_data <- Source_data[order(Source_data$region, Source_data$product, Source_data$start_date, Source_data$station_count, Source_data$retail_avg),]
db_2005 <- db_2005[order(db_2005$region, db_2005$product, db_2005$start_date, db_2005$station_count, db_2005$retail_avg),]

Source_data1 <- Source_data1[order(Source_data1$region, Source_data1$product, Source_data1$start_date, Source_data1$retail_avg, Source_data1$wholesale_avg, Source_data1$tax_avg, 
                                   Source_data1$freight_avg),]
db_2014 <- db_2014[order(db_2014$region, db_2014$product, db_2014$start_date, db_2014$retail_avg, db_2014$wholesale_avg, 
                                       db_2014$tax_avg, db_2014$freight_avg, db_2014$margin_avg, db_2014$net_avg),]

Source_data2 <- Source_data2[order(Source_data2$region, Source_data2$product, Source_data2$start_date, Source_data2$retail_avg, Source_data2$wholesale_avg, Source_data2$tax_avg, 
                                   Source_data2$freight_avg),]
db_2018 <- db_2018[order(db_2018$region, db_2018$product, db_2018$start_date, db_2018$retail_avg, db_2018$wholesale_avg, 
                                       db_2018$tax_avg, db_2018$freight_avg, db_2018$margin_avg, db_2018$net_avg),]

#delete rownames for checking files match
rownames(db_2005) <- NULL
rownames(db_2014) <- NULL
rownames(db_2018) <- NULL

#make source data files data.frame class 
db_2005 <- data.frame(db_2005)
db_2014 <- data.frame(db_2014)
db_2018 <- data.frame(db_2018)

# compare source to fact table (broken out from 2005-2013, 2014-2017, and 2018-2019) to ensure they match
all(Source_data == db_2005)
identical(Source_data,db_2005)
which(Source_data!=db_2005, arr.ind=TRUE)

all(Source_data1 == db_2014)
identical(Source_data1,db_2014)
which(Source_data1!=db_2014, arr.ind = TRUE)

all(Source_data2 == db_2018)
identical(Source_data2,db_2018)
which(Source_data2!=db_2018, arr.ind = TRUE)
