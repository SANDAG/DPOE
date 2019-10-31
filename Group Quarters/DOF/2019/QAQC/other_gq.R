# file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

####Obtain Source Data####
#Source data, make sure to use double backslashes for the file path
file <- "R:\\DPOE\\DOF Group Quarters\\2019\\QAQC\\Raw\\SanDiegoGQ2019.xls"
Source_data <- read_excel(file, sheet = 8)

#Check data type
str(Source_data)

#Convert to data frame
Source_data <- data.frame(Source_data)

#To see column names in source data
colnames(Source_data)

#Rename source data. Make sure order is the same as in the database.
names(Source_data) <- c("Other GQ - County","Other GQ - Facility N/A",
                        "F3","F4","F5","F6","F7","F8","F9","F10","F11","F12")

####Obtain SQL Database Data####
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT [Other GQ - County]
      ,[Other GQ - Facility N/A]
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
  FROM [dpoe_stage].[staging].[other_gq]'
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

# replace cell value ("Balance of County")in Source_data to "Unincorporated"
index <- Source_data$"Other GQ - Facility N/A" == "San Diego"
Source_data$"Other GQ - Facility N/A"[index] <- "Various Locations"

####Check Data Types and Values####
#Check data types
str(Source_data)
str(database_data)

#compare files 
all(Source_data == database_data) #check cell values only
all.equal(Source_data,database_data) #check cell values and data types and will return the conflicted cells
identical(Source_data,database_data) #check cell values and data types

##############################################################################################################################################################

#file comparison code between a source file and fact table
####Obtain SQL Database Data####
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query = getSQL("R:/DPOE/DOF Group Quarters/2019/QAQC/SQL Query/Other GQ - Facility NA.sql")
fact <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#compare files 
all(Source_data == fact) #check cell values only
all.equal(Source_data,fact) #check cell values and data types and will return the conflicted cells
identical(Source_data,fact) #check cell values and data types
