# set up workspace
maindir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(maindir)

# import functions

install.packages("here")
library(here)
source(here("Common_functions","readSQL.R"))
source(here("Common_functions","common_functions.R"))
source(here("Common_functions","config.R"))

# import packages
packages <- c("RODBC","tidyverse","openxlsx","hash","plyr","devtools", "data.table")
pkgTest(packages)

# initialize start time
sleep_for_a_minute <- function() { Sys.sleep(60) }
start_time <- Sys.time()

#Import Database Data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=socioec_data_stage; trusted_connection=true')
sql_query <- getSQL("../Queries/import_lodes74_rac.sql")
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)
gc() #release memory

###Import Source Data###
setwd("R:/DPOE/LEHD LODES/7.4/Source/RAC")
file_names <- dir(path = ".", pattern = ".csv")
s <- lapply(file_names, fread) #append each csv into a list

#and fliter it by h_geocode = "6073"
new_s = list()
k = 1
for (i in s){
  i$h_geocode <- as.character(i$h_geocode)
  p = substr(i$h_geocode,1,4) == "6073"
  i <- i[p,]
  new_s[[k]] = i
  k = k + 1
}

# #drop s and release memory
# s <- NULL
# gc()


#Flip a list
fS <- ldply(new_s, data.frame)

fS = as.data.frame(do.call(rbind, new_s))

str(database_data)
str(fS)


# TEST <- as.data.frame(s[1])
# TEST$h_geocode <- as.character(TEST$h_geocode)



# # Unique Value Check on geoid
# uniq <- unique(fS$h_geocode)
# uniq <- sort(uniq, decreasing = FALSE)
# uniq <- as.character(uniq)
# 
# 
# uniq_d <- unique(database_data$h_geoid)
# uniq_d <- sort(uniq_d, decreasing = FALSE)
# uniq_d <- as.character(uniq_d)
# 
# identical(uniq, uniq_d)
# 
# min(uniq)
# min(uniq_d)
# max(uniq)
# max(uniq_d)


#Remove unnecessary columns from databased_data and source_data
database_data$type <- NULL
database_data$segment <- NULL
database_data$yr <- NULL
fS$createdate <- NULL











#Initialize source_data as data.table structure based on the first csv file
#and fliter it by h_geocode = "6073"
ss <- s[1]
for (i in ss){
    p = substr(i$h_geocode,1,4) == "6073"
    source_data <- subset(i, p)
}

#Fliter the rest of csv files and combine them into source_data
tt <- s[2:length(s)]
for (k in tt){
  p = substr(i$h_geocode,1,4) == "6073"
  temp.data <- subset(k, p)
  source_data<-data.table(rbind(source_data,temp.data))
}



a = substr(subset2$w_geocode,1,4) == "6073"
subset2 <- subset2[a,]
gc()













-------------------------------------------------------------------

#########Clean Data#########
#Remove unnecessary columns from databased_data and source_data
database_data$type <- NULL
database_data$segment <- NULL
database_data$yr <- NULL
source_data$createdate <- NULL

#Rename the header of source_data based on database_data
all.equal(colnames(source_data), colnames(database_data)) #check all the inconsistencies of columnnames
names(source_data) <- colnames(database_data)

#Convert source_data$w_geoid to character
source_data$h_geoid <- sapply(source_data$h_geoid,as.numeric)

#
source_data <- as.data.frame(source_data)


database_data <- database_data[
  with(database_data, order(h_geoid, C000, CA01, CA02, CA03, CE01, CE02, CE03, CNS01, CNS02, CNS03, CNS04, CNS05,
                            CNS06, CNS07, CNS08, CNS09, CNS10, CNS11, CNS12, CNS13, CNS14, CNS15, CNS16, CNS17,
                            CNS18, CNS19, CNS20, CR01, CR02, CR03, CR04, CR05, CR07, CT01, CT02, CD01, CD02, CD03,
                            CD04, CS01, CS02)),
  ]

source_data <- source_data[
  with(source_data, order(h_geoid, C000, CA01, CA02, CA03, CE01, CE02, CE03, CNS01, CNS02, CNS03, CNS04, CNS05,
                            CNS06, CNS07, CNS08, CNS09, CNS10, CNS11, CNS12, CNS13, CNS14, CNS15, CNS16, CNS17,
                            CNS18, CNS19, CNS20, CR01, CR02, CR03, CR04, CR05, CR07, CT01, CT02, CD01, CD02, CD03,
                            CD04, CS01, CS02)),
  ]
gc() #release memory

#Remove rownames (This works, but looking for other solutions to fix inconconsistency of rownames types)
rownames(source_data) <-NULL
rownames(database_data) <-NULL

#
all.equal(source_data[2:ncol(source_data)], database_data[2:ncol(database_data)])

source_data[,1]
# #
# all.equal(unique(source_data$h_geoid),unique(database_data$h_geoid))
# 
# sss <- unique(source_data$h_geoid)
# ddd <- unique(database_data$h_geoid)




































-----------------------------------------------------------------------

####Check Data Types and Values####
#Check data types
str(source_data)
str(database_data)


# compare files 
all(source_data == database_data) #chekc cell values only
all.equal(source_data, database_data) #chekc cell values and data types and will return the conflicted cells
identical(source_data, database_data) #chekc cell values and data types

# display running time of R code
sleep_for_a_minute()
end_time <- Sys.time()
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
