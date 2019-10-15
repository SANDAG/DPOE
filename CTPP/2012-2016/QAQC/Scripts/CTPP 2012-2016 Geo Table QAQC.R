#CTPP 2012-2016 QAQC CTPP Geo Dimension Table

#file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Load source data
file <- "R:/DPOE/CTPP/2012-2016/Documentation/2012-2016 CTPP Requirements.xlsx"
source1 <- read_excel(file, sheet = 'Geoids')

#Load database data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- 'SELECT * FROM dpoe_stage.dbo.[Geoids$]'
db1 <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
odbcClose(channel)

#Check column names
# colnames(source1)
# colnames(db1)

#Rename source data
source1 <- plyr::rename(source1, c("Format of Summary Levels for the CTPP 2012-2016 5-Year Special Tab"="summary_level","...2"="summary_level_desc","...3"="geoid_variables","...4"="geoid_format"))
db1 <- plyr::rename(db1, c("geo_id_variables"="geoid_variables","format"="geoid_format"))

#Remove nas from source_data
source1<- source1[-c(1:2,14,26,44:63),]

#Check data types
# str(source1)
# str(db1)

#Convert to data frame
source1 <- as.data.frame(source1)

#delete rownames for checking files match (R assigns arbitrary IDs)
rownames(source1) <- NULL
rownames(db1) <- NULL

#Compare files 
all(source1 == db1) #check cell values only
all.equal(source1,db1) #check cell values and data types and will return the conflicted cells
identical(source1,db1) #check cell values and data types
which(source1!=db1, arr.ind = TRUE) #which command shows exactly which columns are incorrect

####################################################################################################################################

#file comparison code between source file and final SQL Table

#Load database data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- 'SELECT * FROM dpoe_stage.dim.ctpp_geo where yr = 2016'
final <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
odbcClose(channel)

#Delete unneccessary columns
final<- final[,-c(1:3)]

#delete rownames for checking files match (R assigns arbitrary IDs)
rownames(source1) <- NULL
rownames(final) <- NULL

#Compare files 
all(source1 == final) #check cell values only
all.equal(source1,final) #check cell values and data types and will return the conflicted cells
identical(source1,final) #check cell values and data types
which(source1!=final, arr.ind = TRUE) #which command shows exactly which columns are incorrect
