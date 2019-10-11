# set up workspace
maindir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(maindir)

# import functions
source("config.R")
source("../readSQL.R")
source("common_functions.R")

# import packages
packages <- c("RODBC","tidyverse","openxlsx","hash","plyr")
pkgTest(packages)

# initialize start time
sleep_for_a_minute <- function() { Sys.sleep(60) }
start_time <- Sys.time()
sleep_for_a_minute()
end_time <- Sys.time()

# connect to database
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=socioec_data_stage; trusted_connection=true')
sql_query <- getSQL("G:/New folder/Queries/import_lodes74_wac.sql")
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)
gc() #release memory

#########Clean Database Data#########
# remove unnecessary columns from databased_data
database_data$createdate <- NULL
database_data$type <- NULL
database_data$segment <- NULL
database_data$yr <- NULL

# convert w_geoid of database_data to character type
database_data[,1] <- sapply(database_data[,1],as.character)
gc() #release memory

-----------------------------------------------------------------------

# batching importing and merge csv files into a dataframe
# four subsets were created by partitioning original 760 csv files based on size
# smallsize
setwd("G:/New folder/SourceFiles/SmallSize")
file_names <- dir("G:/New folder/SourceFiles/SmallSize") #where you have your files
small_data <- do.call(rbind,lapply(file_names,read.csv))
a = substr(small_data$w_geocode,1,4) == "6073"
small_data <- small_data[a,]
gc() #release memory

# mediumsize
setwd("G:/New folder/SourceFiles/MediumSize")
file_names <- dir("G:/New folder/SourceFiles/MediumSize") #where you have your files
medium_data <- do.call(rbind,lapply(file_names,read.csv))
a = substr(medium_data$w_geocode,1,4) == "6073"
medium_data <- medium_data[a,]
gc() #release memory

# sizeover20MB
setwd("G:/New folder/SourceFiles/SizeOver20")
file_names <- dir("G:/New folder/SourceFiles/SizeOver20") #where you have your files
sizeover20 <- do.call(rbind,lapply(file_names,read.csv))
a = substr(sizeover20$w_geocode,1,4) == "6073"
sizeover20 <- sizeover20[a,]
gc() #release memory

# sizeover30MB
setwd("G:/New folder/SourceFiles/SizeOver30")
file_names <- dir("G:/New folder/SourceFiles/SizeOver30") #where you have your files
sizeover30 <- do.call(rbind,lapply(file_names,read.csv))
a = substr(sizeover30$w_geocode,1,4) == "6073"
sizeover30 <- sizeover30[a,]
gc() #release memory

# merge all partitions
source_data <- rbind(small_data, medium_data, sizeover20, sizeover30)
gc() #release memory

#########Clean Source Data#########
# remove "createdate" from source_data
source_data$createdate <- NULL

# convert source_data$w_geoid to character
source_data[,1] <- sapply(source_data[,1],as.character)

# rename the header of source_data based on database_data
names(source_data) <- colnames(database_data)

# Sort soruce_data and database_data
database_data <- database_data[
  with(database_data, order(w_geoid, C000, CA01, CA02, CA03, CE01, CE02, CE03, CNS01, CNS02, CNS03, CNS04, CNS05, CNS06, 
                          CNS07, CNS08, CNS09, CNS10, CNS11, CNS12, CNS13, CNS14, CNS15, CNS16, CNS17, CNS18, CNS19,
                          CNS20, CR01, CR02, CR03, CR04, CR05, CR07, CT01, CT02, CD01, CD02, CD03, CD04, CS01, CS02,
                          CFA01, CFA02, CFA03, CFA04, CFA05, CFS01, CFS02,CFS03, CFS04, CFS05)),
  ]
gc() #release memory

source_data <- source_data[
  with(source_data, order(w_geoid, C000, CA01, CA02, CA03, CE01, CE02, CE03, CNS01, CNS02, CNS03, CNS04, CNS05, CNS06,
                          CNS07, CNS08, CNS09, CNS10, CNS11, CNS12, CNS13, CNS14, CNS15, CNS16, CNS17, CNS18, CNS19,
                          CNS20, CR01, CR02, CR03, CR04, CR05, CR07, CT01, CT02, CD01, CD02, CD03, CD04, CS01, CS02,
                          CFA01, CFA02, CFA03, CFA04, CFA05, CFS01, CFS02,CFS03, CFS04, CFS05)),
  ]
gc() #release memory

# remove rownames (This works, but looking for other solutions to fix inconconsistency of rownames types)
rownames(source_data) <-NULL
rownames(database_data) <-NULL

# load("G:/New folder/source_data_paritions3.RData")

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
