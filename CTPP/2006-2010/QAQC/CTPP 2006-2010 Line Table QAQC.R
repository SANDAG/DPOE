#CTPP 2012-2016 QAQC CTPP Line Dimension Table

#file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Load source data
file <- "R:/DPOE/CTPP/2006-2010/Documentation/acs_2006thru2010_ctpp_table_shell.txt"
source1 <- read.delim(file, header=TRUE, sep="|")

#Load database data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- 'SELECT * FROM dpoe_stage.dbo.ctpp_2010_line'
db1 <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
odbcClose(channel)

#Delete unneccessary columns
source1 <- select(source1, -"LINDENT")

#Rename source data
source1 <- plyr::rename(source1, c("TBLID"="tblid","LINENO"="lineno","LDESC"="ldesc"))

#Check data types
str(source1)
str(db1)

#Convert data types
source1$tblid <- as.character(source1$tblid)
source1$ldesc <- as.character(source1$ldesc)

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
sql_query1 <- 'SELECT * FROM dpoe_stage.dim.ctpp_line where yr = 2010'
final <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
odbcClose(channel)

#Delete unneccessary columns
final<- final[,-c(1:3)]

#Rename source data
source1 <- plyr::rename(source1, c("tblid"="subject_table_id","lineno"="line_number","ldesc"="line_desc"))

#Check data types
str(source1)
str(final)

#delete rownames for checking files match (R assigns arbitrary IDs)
rownames(source1) <- NULL
rownames(final) <- NULL

#Compare files 
all(source1 == final) #check cell values only
all.equal(source1,final) #check cell values and data types and will return the conflicted cells
identical(source1,final) #check cell values and data types
which(source1!=final, arr.ind = TRUE) #which command shows exactly which columns are incorrect

