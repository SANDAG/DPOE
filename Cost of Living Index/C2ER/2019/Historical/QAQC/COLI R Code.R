#COLI Data

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\..\\..\\Common_functions\\readSQL.R")
getwd()

# file comparison code between a CSV source file and raw upload SQL Table

#Read in source and database files
source_data <- read_excel("R:\\DPOE\\Cost of Living Index\\C2ER\\2019\\Historical\\Source\\COLI Historical Data - 1990 Q1 - 2019 Q1.xlsx",guess_max = 40000)

#Read in SQL data 
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT * FROM [dpoe_stage].[dbo].[coli_historical]'
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#To see column names in data
colnames(source_data)
colnames(database_data)

#Rename columns
source_data <- plyr::rename(source_data, c("PRESCRIPTION DRUG"="PRESCRIPTION_DRUG", "COOKING OIL"="COOKING_OIL"))
database_data <- plyr::rename(database_data, c("PRESCRIPTION DRUG"="PRESCRIPTION_DRUG", "COOKING OIL"="COOKING_OIL","EGGS "="EGGS"))

#Verify that this worked
all(colnames(source_data) == colnames(database_data))

#trim whitespace from metro_micro_name column values
source_data$METRO_MICRO_NAME <- trimws(source_data$METRO_MICRO_NAME)
database_data$METRO_MICRO_NAME <- trimws(database_data$METRO_MICRO_NAME)

#Check data types
str(source_data)
str(database_data)
all(str(source_data) == str(database_data))

#Convert source data to a data frame
source_data <- data.frame(source_data)
class(source_data)
all(class(source_data) == class(database_data))

#Order source data table
source_data <- source_data[order(source_data$YEAR, source_data$QUARTER, source_data$URBAN_AREA_NAME, source_data$STATE_CODE, source_data$CBSA_CODE, source_data$CITY_CODE, source_data$STATE_NAME,
                                 source_data$METRO_MICRO_NAME, source_data$COMPOSITE_INDEX, source_data$GROCERY_ITEMS, source_data$HOUSING, source_data$UTILITIES, source_data$TRANSPORTATION, source_data$HEALTH_CARE, 
                                 source_data$MISC_GOODS_SERVICES, source_data$STEAK, source_data$GROUNDBEEF, source_data$BACON, source_data$FRYINGCHICKEN, source_data$CHUNKLIGHTTUNA, source_data$WHOLEMILK, source_data$EGGS ,
                                 source_data$MARGARINE, source_data$PARMESANCHEESE, source_data$POTATOES, source_data$BANANAS, source_data$LETTUCE, source_data$BREAD, source_data$CIGARETTES,
                                 source_data$COFFEE, source_data$SUGAR, source_data$CORNFLAKES, source_data$SWEETPEAS, source_data$TOMATOES, source_data$PEACHES, source_data$FACIALTISSUES, source_data$DETERGENT,
                                 source_data$COOKING_OIL, source_data$FROZENORANGEJUICE, source_data$FROZENCORN, source_data$BABYFOOD, source_data$SOFTDRINK, source_data$APARTMENTRENT, source_data$HOMEPRICE, source_data$MORTGAGERATE,
                                 source_data$MONTHLYPAYMENT, source_data$ALLELECTRIC, source_data$PARTELECTRIC, source_data$OTHERENERGY, source_data$TOTENERGY, source_data$PHONE, source_data$COMMUTERFARE, source_data$TIREBALANCE,
                                 source_data$GASOLINE, source_data$HOSPITALROOM, source_data$DOCTORVISIT, source_data$DENTISTVISIT, source_data$ASPIRIN, source_data$HAMBURGER, source_data$PIZZA, source_data$FRIEDCHICKEN,
                                 source_data$HAIRCUT, source_data$BEAUTYSALON, source_data$TOOTHPASTE, source_data$SHAMPOO, source_data$DRYCLEANING, source_data$MANDRESSSHIRT, source_data$BOYUNDERWEAR, source_data$MANDENIMJEANS,
                                 source_data$WASHERREPAIR, source_data$NEWSPAPER, source_data$MOVIE, source_data$BOWLING, source_data$TENNISBALLS, source_data$BOARDGAME, source_data$LIQUOR, source_data$BEER,
                                 source_data$WINE, source_data$FROZENMEAL, source_data$POTATOCHIPS, source_data$VETERINARYSERVICES, source_data$PRESCRIPTION_DRUG, source_data$BOYJEANS, source_data$SAUSAGE, source_data$IBUPROFEN,
                                 source_data$POLYSPORIN, source_data$MENSLACKS, source_data$WOMENSLACKS, source_data$OPTOMETRISTVISIT, source_data$FRESHORANGEJUICE, source_data$YOGA),]  

#Order database data table
database_data <- database_data[order(database_data$YEAR, database_data$QUARTER, database_data$URBAN_AREA_NAME, database_data$STATE_CODE, database_data$CBSA_CODE, database_data$CITY_CODE, database_data$STATE_NAME,
                                     database_data$METRO_MICRO_NAME, database_data$COMPOSITE_INDEX, database_data$GROCERY_ITEMS, database_data$HOUSING, database_data$UTILITIES, database_data$TRANSPORTATION, database_data$HEALTH_CARE, 
                                     database_data$MISC_GOODS_SERVICES, database_data$STEAK, database_data$GROUNDBEEF, database_data$BACON, database_data$FRYINGCHICKEN, database_data$CHUNKLIGHTTUNA, database_data$WHOLEMILK, database_data$EGGS ,
                                     database_data$MARGARINE, database_data$PARMESANCHEESE, database_data$POTATOES, database_data$BANANAS, database_data$LETTUCE, database_data$BREAD, database_data$CIGARETTES,
                                     database_data$COFFEE, database_data$SUGAR, database_data$CORNFLAKES, database_data$SWEETPEAS, database_data$TOMATOES, database_data$PEACHES, database_data$FACIALTISSUES, database_data$DETERGENT,
                                     database_data$COOKING_OIL, database_data$FROZENORANGEJUICE, database_data$FROZENCORN, database_data$BABYFOOD, database_data$SOFTDRINK, database_data$APARTMENTRENT, database_data$HOMEPRICE, database_data$MORTGAGERATE,
                                     database_data$MONTHLYPAYMENT, database_data$ALLELECTRIC, database_data$PARTELECTRIC, database_data$OTHERENERGY, database_data$TOTENERGY, database_data$PHONE, database_data$COMMUTERFARE, database_data$TIREBALANCE,
                                     database_data$GASOLINE, database_data$HOSPITALROOM, database_data$DOCTORVISIT, database_data$DENTISTVISIT, database_data$ASPIRIN, database_data$HAMBURGER, database_data$PIZZA, database_data$FRIEDCHICKEN,
                                     database_data$HAIRCUT, database_data$BEAUTYSALON, database_data$TOOTHPASTE, database_data$SHAMPOO, database_data$DRYCLEANING, database_data$MANDRESSSHIRT, database_data$BOYUNDERWEAR, database_data$MANDENIMJEANS,
                                     database_data$WASHERREPAIR, database_data$NEWSPAPER, database_data$MOVIE, database_data$BOWLING, database_data$TENNISBALLS, database_data$BOARDGAME, database_data$LIQUOR, database_data$BEER,
                                     database_data$WINE, database_data$FROZENMEAL, database_data$POTATOCHIPS, database_data$VETERINARYSERVICES, database_data$PRESCRIPTION_DRUG, database_data$BOYJEANS, database_data$SAUSAGE, database_data$IBUPROFEN,
                                     database_data$POLYSPORIN, database_data$MENSLACKS, database_data$WOMENSLACKS, database_data$OPTOMETRISTVISIT, database_data$FRESHORANGEJUICE, database_data$YOGA),]  

#Delete unique key assigned by R so that identical function will work
rownames(source_data) <- NULL
rownames(database_data) <- NULL

#Verify that this worked
all(rownames(source_data) == rownames(database_data))

#compare files 
all(source_data == database_data) #check cell values only
all.equal(source_data,database_data) #check cell values and data types and will return the conflicted cells
identical(source_data,database_data) #check cell values and data types
which(source_data!=database_data,arr.ind=TRUE)


#If it doesn't return true, use these to find problems
#Find unique column values
#unique(source_data$ALLELECTRIC)
#unique(database_data$ALLELECTRIC)

#Find problems
#source_data$ALLELECTRIC <- as.numeric(source_data$ALLELECTRIC)
#problems1 <- subset(source_data,(is.na(source_data$ALLELECTRIC2) & !is.na(source_data$ALLELECTRIC)))
#problems1$ALLELECTRIC

#Compare columns
#identical(source_data$ALLELECTRIC,database_data$ALLELECTRIC)
#identical(source_data$GROCERY_ITEMS,database_data$GROCERY_ITEMS)
#identical(source_data$URBAN_AREA_NAME,database_data$URBAN_AREA_NAME)
#(source_data$METRO_MICRO_NAME,database_data$METRO_MICRO_NAME)
#identical(source_data$COMPOSITE_INDEX,database_data$COMPOSITE_INDEX)
#identical(source_data$EGGS,database_data$EGGS)


#####################################################################################################################################################################

#Compare source data to fact table

#turn off strings reading in as factors
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')

#Read in sql query
sql_query = getSQL("../QAQC/Source to fact table.sql")
coli<-sqlQuery(channel,sql_query)
odbcClose(channel)

#Unpivot source to match fact
require(reshape2)
source_piv <- melt(source_data, id.vars=c("YEAR", "QUARTER", "URBAN_AREA_NAME", "STATE_CODE", "CBSA_CODE", "CITY_CODE", "STATE_NAME", "METRO_MICRO_NAME"))
head(source_piv)

#Remove NAs in value column of source_piv table to be consistent with fact table
source_melt <- source_piv$value[!is.na(source_piv$value)]
source_melt <- subset(source_piv,!is.na(source_piv$value))

#To see column names in coli data
colnames(coli)
colnames(source_melt)

#Rename source data to match fact table. Make sure order is the same in both datasets.
source_melt <- plyr::rename(source_melt, c("YEAR"="yr", "QUARTER"="qtr", "URBAN_AREA_NAME"="urban_area_name", "STATE_CODE"="state_code","CBSA_CODE"="cbsa_code", 
                           "CITY_CODE"="city_code", "STATE_NAME"="state_name", "METRO_MICRO_NAME"="metro_micro_name", "variable"="item", "value"="indx"))

#trim whitespace from metro_micro_name column values
source_melt$metro_micro_name <- trimws(source_melt$metro_micro_name)
coli$metro_micro_name <- trimws(coli$metro_micro_name)
source_melt$item <- trimws(source_melt$item)
coli$item <- trimws(coli$item)

#Rename items
coli$item[coli$item == "COOKING OIL"] <- "COOKING_OIL"
coli$item[coli$item == "PRESCRIPTION DRUG"] <- "PRESCRIPTION_DRUG"

#Check that column names are the same
all(colnames(coli) == colnames(source_melt))

#Check data types
str(source_melt)
str(coli)
all(str(coli) == str(source_melt))

#Change coli data types from Factor to Chr
i <- sapply(source_melt, is.factor)
source_melt[i] <- lapply(source_melt[i], as.character)

#Convert coli$yr to numeric
coli$yr <- as.numeric(coli$yr)

#Order table coli
coli <- coli[order(coli$yr, coli$qtr, coli$urban_area_name, coli$state_code, coli$cbsa_code, coli$city_code, coli$state_name, coli$metro_micro_name, 
                     coli$item, coli$indx),]

#Order table source_melt
source_melt <- source_melt[order(source_melt$yr, source_melt$qtr, source_melt$urban_area_name, source_melt$state_code, source_melt$cbsa_code, source_melt$city_code, source_melt$state_name, source_melt$metro_micro_name, 
                               source_melt$item, source_melt$indx),]


#Delete unique key assigned by R so that identical function will work
rownames(source_melt) <- NULL
rownames(coli) <- NULL

#compare files 
all(source_melt == coli) #check cell values only
all.equal(source_melt,coli) #check cell values and data types and will return the conflicted cells
identical(source_melt,coli) #check cell values and data types
which(source_melt!=coli,arr.ind=TRUE)

#If it returns false, find unique values in item
#unique(source_melt$item)
#unique(coli$item)

#Create a csv from the output
#write.csv(coli, paste("R:\\DPOE\\C2ER Cost of Living Index\\2019\\Historical\\QAQC,".csv",sep = ''),row.names = FALSE)

