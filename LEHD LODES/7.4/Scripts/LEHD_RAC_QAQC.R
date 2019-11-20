#Set up workspace
maindir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(maindir)

#Import functions
install.packages("here")
library(here)
source(here("Common_functions","readSQL.R"))
source(here("Common_functions","common_functions.R"))
source(here("Common_functions","config.R"))

#Import packages
packages <- c("RODBC","tidyverse","openxlsx","hash","plyr","devtools", "data.table")
pkgTest(packages)

#Initialize start time
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
dat_csv <- lapply(file_names, fread) #append each csv into a list

#and fliter it by h_geocode = "6073"
new_dat = list()
k = 1
for (i in dat_csv){
  i$h_geocode <- as.character(i$h_geocode)
  p = substr(i$h_geocode,1,4) == "6073"
  i <- i[p,]
  new_dat[[k]] = i
  k = k + 1
}
gc()

#drop dat_csv and release memory
dat_csv <- NULL
i <- NULL
gc()

#Flip a list to a single dataframe
source_data = ldply(new_dat, data.frame)
gc()

#Check dataframe structure
str(database_data)
str(source_data)

#-----------------------------------------------------------------------#
#########Clean Data#########
#Remove unnecessary columns from databased_data and source_data
database_data$type <- NULL
database_data$segment <- NULL
database_data$yr <- NULL
source_data$createdate <- NULL

#Rename the header of source_data based on database_data
all.equal(colnames(source_data), colnames(database_data)) #check all the inconsistencies of columnnames
names(source_data) <- colnames(database_data)
all.equal(colnames(source_data), colnames(database_data)) # should return TRUE

#Convert source_data$h_geoid to character
source_data$h_geoid <- sapply(source_data$h_geoid,as.numeric)
gc() #release memory

#Sorting Data Frame
database_data <- database_data[
  with(database_data, order(h_geoid, C000, CA01, CA02, CA03, CE01, CE02, CE03, CNS01, CNS02, CNS03, CNS04, CNS05,
                            CNS06, CNS07, CNS08, CNS09, CNS10, CNS11, CNS12, CNS13, CNS14, CNS15, CNS16, CNS17,
                            CNS18, CNS19, CNS20, CR01, CR02, CR03, CR04, CR05, CR07, CT01, CT02, CD01, CD02, CD03,
                            CD04, CS01, CS02)),
  ]
gc() #release memory

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

#-----------------------------------------------------------------------#
####Check Data Types and Values####
#Check data types
str(database_data)
str(source_data)

# compare files 
all(source_data == database_data) #chekc cell values only
all.equal(source_data, database_data) #chekc cell values and data types and will return the conflicted cells
identical(source_data, database_data) #chekc cell values and data types
which(source_data!=database_data, arr.ind = TRUE) #which command shows exactly which columns are incorrect

# display running time of R code
end_time <- Sys.time()
end_time - start_time