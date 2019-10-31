# file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

####Obtain Source Data####
# Source data, make sure to use double backslashes for the file path
file <- "R:\\DPOE\\DOF Group Quarters\\2019\\QAQC\\Raw\\SanDiegoGQ2019.xls"
Source_data <- read_excel(file, sheet = 9)

#Check data type
str(Source_data)

#Convert to data frame
Source_data <- data.frame(Source_data)

#To see column names in source data
colnames(Source_data)

#Rename source data. Make sure order is the same as in the database.
names(Source_data) <- c("Military Family HH Population - City","Military Family HH Population - Facility N/A",
                        "F3","F4","F5","F6","F7","F8","F9","F10","F11","F12")

####Obtain SQL Database Data####
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT [Military Family HH Population - City]
      ,[Military Family HH Population - Facility N/A]
      ,[F3]
      ,[F4]
      ,[F5]
      ,[F6]
      ,[F7]
      ,[F8]
      ,[F9]
      ,[F10]
      ,[F11]
      ,[F12]
  FROM [dpoe_stage].[staging].[mil_fam_pop]'
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

####Clean Source Data####
# rename first two columns in database_data
names(database_data) <- c("Military Family HH Population","Military Family HH Population - Facility N/A",
                          "F3","F4","F5","F6","F7","F8","F9","F10","F11","F12")

####Check Data Types and Values####
#Check data types
str(Source_data)
str(database_data)

#compare files 
all(Source_data == database_data) #check cell values only
all.equal(Source_data,database_data) #check cell values and data types and will return the conflicted cells
identical(Source_data,database_data) #check cell values and data types

###############################################################################################################################################################

#file comparison code between a source file and fact table
####Obtain SQL Database Data####
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query = getSQL("R:/DPOE/DOF Group Quarters/2019/QAQC/SQL Query/Military Family HH Population.sql")
fact <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

####Clean Source Data####
# rename first two columns in Source_data
# names(Source_data) <- c("jurisdiction","facility_name",
#                         "2010","2011","2012","2013","2014","2015","2016","2017","2018","2019")
#Check data types
str(Source_data)
str(fact)

# convert first two columns format in database_data from character to factor
Source_data[,3:12] <- sapply(Source_data[,3:12],as.numeric)

# replace cell value ("Balance of County")in Source_data to "Unincorporated"
# index <- Source_data$jurisdiction == "Balance of County"
# Source_data$jurisdiction[index] <- "Unincorporated"

#compare files 
all(Source_data == fact) #check cell values only
all.equal(Source_data,fact) #check cell values and data types and will return the conflicted cells
identical(Source_data,fact) #check cell values and data types
which(Source_data!=fact, arr.ind=TRUE)
