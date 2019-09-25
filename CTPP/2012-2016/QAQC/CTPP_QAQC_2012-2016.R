#set up workspace
maindir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(maindir)

#import functions
source("config.R")
source("../readSQL.R")
source("common_functions.R")

#import packages
packages <- c("RODBC","tidyverse","openxlsx","hash","plyr", "data.table")
pkgTest(packages)


#initialize start time
sleep_for_a_minute <- function() { Sys.sleep(60) }
start_time <- Sys.time()
end_time <- Sys.time()


#import database_data (2012-2016)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- getSQL("G:/CTPP/QAQC/Query/CTPP ETL 2012-2016 for R.sql")
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)
gc() #release memory


#import source_data (2012-2016)
setwd("R:/DPOE/CTPP/2012-2016/Source/Data")
file_names <- dir(path = ".", pattern = ".csv") #where you have your files
source_data <- do.call(rbind,lapply(file_names,fread))
source_data <- as.data.frame(source_data)
gc() #release memory


#remove columns from dataframes
database_data$ctpp_id <- NULL
source_data$SOURCE <- NULL
gc() #release memory

#rename dataframes headers
names(source_data) <- colnames(database_data)
gc() #release memory

#clean up est and num
source_data$moe <- gsub("[ ,/,',',*,+,-]","", source_data$moe)
source_data$est <- gsub("[ ,/,',',*,+,-]","", source_data$est)
database_data$moe <- gsub("[NA]","", database_data$moe)
gc() #release memory

# #test code
# c <-  "******ce,7382+/-  "
# c <- "NA666"
# c <- ""
# gsub("","999", c)
# gsub("[NA, ,/,',',*,+,-]","", c)

#convert est in source_data to num
source_data[,-2] <- sapply(source_data[,-2],as.numeric)
gc() #release memory


#sort soruce_data and database_data
database_data <- database_data[
  with(database_data, order(geoid, tbl_id, line_num, est, moe)),
  ]
gc() #release memory

source_data <- source_data[
  with(source_data, order(geoid, tbl_id, line_num, est, moe)),
  ]
gc() #release memory

# #select first n rows from dataframe (slicing)
# source_data[-1:-4,] #df[row.index, column.index]

# # convert w_geoid of database_data to character type
# database_data[,1] <- sapply(database_data[,1],as.character)
# gc() #release memory

# # remove rownames (This works, but looking for other solutions to fix inconconsistency of rownames typNULLes)
# rownames(source_data) <-
# rownames(database_data) <-NULL

-----------------------------------------------------------------------
  
  ####Check Data Types and Values####
#Check data types
str(source_data)
str(database_data)

# mode(attr(source_data, "row.names")) #chr
# storage.mode(attr(source_data, "row.names")) #chr
# mode(attr(database_data, "row.names")) #num
# storage.mode(attr(database_data, "row.names")) #int

# compare files 
all(source_data == database_data) #chekc cell values only
all.equal(source_data, database_data) #chekc cell values and data types and will return the conflicted cells
identical(source_data, database_data) #chekc cell values and data types

# display running time of R code
end_time - start_time

# # TEST Code for small subset
# setwd("G:/New folder/SourceFiles/subset2")
# file_names <- dir("G:/New folder/SourceFiles/subset2") #where you have your files
# subset2 <- do.call(rbind,lapply(file_names,read.csv))
# a = substr(subset2$w_geocode,1,4) == "6073"
# subset2 <- subset2[a,]
# gc()

# # count number of rows through a series of csv files
# setwd("G:/New folder/SourceFiles/All")
# filelist = list.files()
# total_nrows = 0
# for (f in filelist){
#   # file_names <- dir("G:/New folder/SourceFiles/All") #where you have your files
#   nrows = length(count.fields(f, skip = 1)) #skip header
#   total_nrows = total_nrows + nrows
# }
