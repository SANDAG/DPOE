#OPIS Fuel Price

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

# File Comparison between source data and raw database data

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

odbcClose(channel)

#Read in excel data
#Dataset #1 - January 2005 to December 2013 OPIS Fuel Price Data
source_data <- read_excel("R:\\DPOE\\Fuel Price\\OPIS\\2019\\Source\\OPIS_FUEL_010105to123113.xlsx")
#Dataset #2 - January 2014 to December 2017 OPIS Fuel Price Data
source_data1 <- read_excel("R:\\DPOE\\Fuel Price\\OPIS\\2019\\Source\\SDAG_OPIS retail margin history_020618.xlsx")
#Dataset #3-  January 2018 to May 2019 OPIS Fuel Price Data
source_data2 <- read_excel("R:\\DPOE\\Fuel Price\\OPIS\\2019\\Source\\San Diego County Monthly Jan 2018-May 2019.xlsx")

#View column names in source data
# head(source_data)
# head(source_data1)
# head(source_data2)

#Rename source data. Make sure order is the same as in the database.
source_data <- plyr::rename(source_data, c("Region Name"="region", "Product"="product", "Start Date"="start_date", "Station Count"="station_count","Retail Average"="retail_avg"))
source_data1 <- plyr::rename(source_data1, c("Region Name"="region", "RP Name"="product", "Start Date"="start_date", "Retail Average"="retail_avg", "Wholesale Average"="wholesale_avg", "Tax Average"="tax_avg", "Freight Average"="freight_avg", "Margin Average"="margin_avg", "Net Average"="net_avg"))
source_data2 <- plyr::rename(source_data2, c("Region Name"="region", "Product"="product", "Start Date"="start_date", "Retail Average"="retail_avg", "Wholesale Average"="wholesale_avg","Tax Average"="tax_avg", "Freight Average"="freight_avg", "Margin Average"="margin_avg", "Net Average"="net_avg"))

#Check data types
# sapply(source_data, class)
# sapply(database_data, class)
# sapply(source_data1, class)
# sapply(database_data1, class)
# sapply(source_data2, class)
# sapply(database_data2, class)

#Convert field Start Date to a Date field
source_data$start_date <- as.Date((source_data$start_date), format = "%Y-%m-%d")
database_data$start_date <- as.Date((database_data$start_date), format = "%Y-%m-%d")

source_data1$start_date <- as.Date((source_data1$start_date), format = "%Y-%m-%d")
database_data1$start_date <- as.Date((database_data1$start_date), format = "%Y-%m-%d")

source_data2$start_date <- as.Date((source_data2$start_date), format = "%Y-%m-%d")
database_data2$start_date <- as.Date((database_data2$start_date), format = "%Y-%m-%d")

#Convert source files to a data frame
source_data <- data.frame(source_data)
source_data1 <- data.frame(source_data1)
source_data2 <- data.frame(source_data2)

#trim whitespace from product column values
source_data1$product <- trimws(source_data1$product)
source_data2$product <- trimws(source_data2$product)
database_data1$product <- trimws(database_data1$product)
database_data2$product <- trimws(database_data2$product)

#check values for the product field
# table(database_data$product)
# table(database_data1$product)
# table(database_data2$product)
# table(source_data$product)
# table(source_data1$product)
# table(source_data2$product)

#Order data frames for comparison
source_data <- source_data[order(source_data$region, source_data$product, source_data$start_date, source_data$station_count, source_data$retail_avg),]
database_data <- database_data[order(database_data$region, database_data$product, database_data$start_date, database_data$station_count, database_data$retail_avg),]

source_data1 <- source_data1[order(source_data1$region, source_data1$product, source_data1$start_date, source_data1$retail_avg, source_data1$wholesale_avg, source_data1$tax_avg, source_data1$freight_avg),]
database_data1 <- database_data1[order(database_data1$region, database_data1$product, database_data1$start_date, database_data1$retail_avg, database_data1$wholesale_avg, database_data1$tax_avg, database_data1$freight_avg, database_data1$margin_avg, database_data1$net_avg),]

source_data2 <- source_data2[order(source_data2$region, source_data2$product, source_data2$start_date, source_data2$retail_avg, source_data2$wholesale_avg, source_data2$tax_avg, source_data2$freight_avg),]
database_data2 <- database_data2[order(database_data2$region, database_data2$product, database_data2$start_date, database_data2$retail_avg, database_data2$wholesale_avg, database_data2$tax_avg, database_data2$freight_avg, database_data2$margin_avg, database_data2$net_avg),]

#delete rownames for checking files match
rownames(source_data) <- NULL
rownames(database_data) <- NULL
rownames(source_data1) <- NULL
rownames(database_data1) <- NULL
rownames(source_data2) <- NULL
rownames(database_data2) <- NULL

#compare source and to raw database files to ensure they match
all(source_data == database_data)
identical(source_data,database_data)
which(source_data!=database_data, arr.ind=TRUE)

all(source_data1 == database_data1)
identical(source_data1,database_data1)
which(source_data1!=database_data1, arr.ind = TRUE)

all(source_data2 == database_data2)
identical(source_data2,database_data2)
which(source_data2!=database_data2, arr.ind = TRUE)

rm(database_data, database_data1,database_data2)

######################################################################################################################################################
#File comparison between source file to fact table

#Read in sql queries

#turn off strings reading in as factors
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')

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
source_data$region[source_data$region == "County - CA, San Diego"] <- "San Diego County"
source_data1$region[source_data1$region == "County - CA, San Diego"] <- "San Diego County"
source_data2$region[source_data2$region == "County - CA, San Diego"] <- "San Diego County"


#Find unique column values
# unique(db_2005$product)
# unique(source_data$product)
# unique(db_2014$product)
# unique(source_data1$product)
# unique(db_2018$product)
# unique(source_data2$product)

#Replace product types in source data to match db data
#Unleaded
source_data$product[source_data$product == "UNL"] <- "Unleaded Gas"
source_data1$product[source_data1$product == "Reg"] <- "Unleaded Gas"

#Diesel
source_data$product[source_data$product == "DSL"] <- "Diesel"

#Midgrade
source_data$product[source_data$product == "MID"] <- "Midgrade Gas"
source_data1$product[source_data1$product == "Mid"] <- "Midgrade Gas"

#Premium
source_data$product[source_data$product == "PRE"] <- "Premium Gas"
source_data1$product[source_data1$product == "Pre"] <- "Premium Gas"


#Check data types
# sapply(source_data, class)
# sapply(db_2005, class)
# sapply(source_data1, class)
# sapply(db_2014, class)
# sapply(source_data2, class)
# sapply(db_2018, class)

#Convert data types
db_2005$station_count <- as.numeric(db_2005$station_count)
db_2005$start_date <- as.Date((db_2005$start_date), format = "%Y-%m-%d")
db_2014$start_date <- as.Date((db_2014$start_date), format = "%Y-%m-%d")
db_2018$start_date <- as.Date((db_2018$start_date), format = "%Y-%m-%d")

#Convert to data frame
db_2005 <- data.frame(db_2005)
db_2014 <- data.frame(db_2014)
db_2018 <- data.frame(db_2018)

#Order data frames for comparison
source_data <- source_data[order(source_data$region, source_data$product, source_data$start_date, source_data$station_count, source_data$retail_avg),]
db_2005 <- db_2005[order(db_2005$region, db_2005$product, db_2005$start_date, db_2005$station_count, db_2005$retail_avg),]

source_data1 <- source_data1[order(source_data1$region, source_data1$product, source_data1$start_date, source_data1$retail_avg, source_data1$wholesale_avg, source_data1$tax_avg, source_data1$freight_avg),]
db_2014 <- db_2014[order(db_2014$region, db_2014$product, db_2014$start_date, db_2014$retail_avg, db_2014$wholesale_avg, db_2014$tax_avg, db_2014$freight_avg, db_2014$margin_avg, db_2014$net_avg),]

source_data2 <- source_data2[order(source_data2$region, source_data2$product, source_data2$start_date, source_data2$retail_avg, source_data2$wholesale_avg, source_data2$tax_avg, source_data2$freight_avg),]
db_2018 <- db_2018[order(db_2018$region, db_2018$product, db_2018$start_date, db_2018$retail_avg, db_2018$wholesale_avg, db_2018$tax_avg, db_2018$freight_avg, db_2018$margin_avg, db_2018$net_avg),]

#delete rownames for checking files match
rownames(db_2005) <- NULL
rownames(db_2014) <- NULL
rownames(db_2018) <- NULL

#compare source to fact table (broken out from 2005-2013, 2014-2017, and 2018-2019) to ensure they match
all(source_data == db_2005)
identical(source_data,db_2005)
which(source_data!=db_2005, arr.ind=TRUE)

all(source_data1 == db_2014)
identical(source_data1,db_2014)
which(source_data1!=db_2014, arr.ind = TRUE)

all(source_data2 == db_2018)
identical(source_data2,db_2018)
which(source_data2!=db_2018, arr.ind = TRUE)
