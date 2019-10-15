### initialize the work environment ###
#set up workspace
maindir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(maindir)

# #import functions
# source("../../../../config.R")
# source("../readSQL.R")
# source("../common_functions.R")

#import packages
install.packages("here")
library(here)
source(here("Common_functions","readSQL.R"))
source(here("Common_functions","common_functions.R"))
source(here("Common_functions","config.R"))
packages <- c("RODBC","tidyverse","openxlsx","hash","plyr", "data.table", "here")
pkgTest(packages)

#initialize start time
sleep_for_a_minute <- function() { Sys.sleep(60) }
start_time <- Sys.time()
end_time <- Sys.time()



### loading data ###
#import database_data (2006-2010, LINENO = 1, #: 103856843)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- getSQL("C:/Users/jyen/Documents/DPOE/CTPP/2006-2010/QAQC/Query/CTPP ETL 2006-2010-1.sql")
sql_query2 <- getSQL("C:/Users/jyen/Documents/DPOE/CTPP/2006-2010/QAQC/Query/CTPP ETL 2006-2010-2.sql")
database_data1 <- sqlQuery1(channel,sql_query1,stringsAsFactors = FALSE)
database_data2 <- sqlQuery1(channel,sql_query2,stringsAsFactors = FALSE)
odbcClose(channel)


#import source_data (2006-2010)
setwd("R:/DPOE/CTPP/2006-2010/Source/Data/")
file_names <- dir(path = ".", pattern = ".csv") #where you have your files
source_data <- do.call(rbind,lapply(file_names,fread)) #use data.table to batching reading large number of csv files
source_data <- as.data.frame(source_data)
gc() #release memory



### data cleaning ###
#remove columns from dataframes
database_data$SOURCE <- NULL
database_data$TBLID <- NULL
source_data$SOURCE <- NULL

#rename dataframes headers
names(source_data) <- colnames(database_data)

#clean up est and num
source_data$SE <- gsub("[ ,/,',',*,+,-]","", source_data$SE)
source_data$EST <- gsub("[ ,/,',',*,+,-]","", source_data$EST)

#
save.image("G:/CTPP/2006-2010/bef_data_type_conversion.RData")




#convert est and moe in source_data to numeric
database_data[,4] <- sapply(database_data[,4],as.double)
source_data[,3:4] <- sapply(source_data[,3:4],as.numeric)
# gc() #release memory

#sort soruce_data and database_data
database_data <- database_data[order(database_data$geo_id, database_data$tbl_id, database_data$line_num, database_data$est, database_data$moe),]
source_data <- source_data[order(source_data$geo_id, source_data$tbl_id, source_data$line_num, source_data$est, source_data$moe),]
gc() #release memory

#remove rownames (This works, but looking for other solutions to fix inconconsistency of rownames typNULLes)
rownames(database_data) <-NULL
rownames(source_data) <- NULL



### Check Data Types and Values ###
#Check data types
str(source_data)
str(database_data)

# compare files
all(source_data == database_data) #chekc cell values only
all.equal(source_data, database_data) #chekc cell values and data types and will return the conflicted cells
identical(source_data, database_data) #chekc cell values and data types
which(source_data!=database_data, arr.ind = TRUE) #which command shows exactly which columns are incorrect


### display running time of R code ###
end_time - start_time



### code for troubleshooting and testing ###
## check original values in est subset
# head(source_data, 1)
# head(database_data, 1)
# s <- tail(source_data, 100000)
# d <- tail(database_data, 100000)
# all.equal(s$est, d$est)
# all.equal(source_data[4], database_data[4])
# file = "R:/DPOE/CTPP/2012-2016/Source/Data/CA_2012thru2016_B306201.csv"
# B306201 <- do.call(rbind,lapply(file,fread))
# B306201 <- as.data.frame(B306201)
# B306201$SOURCE <- NULL
# sub306201 <- subset(B306201, GEOID == 'C6000US06115000014790686972')
# sub306201_2 <- subset(B306201, GEOID == 'C6000US06115000014850604576')

# #TEST Code for small subset
# setwd("G:/New folder/SourceFiles/subset2")
# file_names <- dir("G:/New folder/SourceFiles/subset2") #where you have your files
# subset2 <- do.call(rbind,lapply(file_names,read.csv))
# a = substr(subset2$w_geocode,1,4) == "6073"
# subset2 <- subset2[a,]
# gc()

# #test code for string cleaning
# c <-  "******ce,7382+/-  "
# c <- "NA666"
# c <- ""
# gsub("","999", c)
# gsub("[NA, ,/,',',*,+,-]","", c)

# #count number of rows through a series of csv files
# setwd("G:/New folder/SourceFiles/All")
# filelist = list.files()
# total_nrows = 0
# for (f in filelist){
#   # file_names <- dir("G:/New folder/SourceFiles/All") #where you have your files
#   nrows = length(count.fields(f, skip = 1)) #skip header
#   total_nrows = total_nrows + nrows
# }
