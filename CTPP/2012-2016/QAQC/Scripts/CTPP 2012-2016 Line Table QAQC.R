#CTPP 2012-2016 QAQC CTPP Line Dimension Table

#file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Load source data
file <- "R:/DPOE/CTPP/2012-2016/Documentation/2012-2016 CTPP Final Table Specs.xlsx"
source1 <- read_excel(file, sheet = 'Table Specs')

#Load database data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- 'SELECT * FROM dpoe_stage.dbo.ctpp_line'
db1 <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
odbcClose(channel)

#Delete unneccessary columns
source1 <- select(source1, -c("Wave","Type","Indent","Sub Range","1 Year Sourcing","3 Year Sourcing","5 Year Sourcing"))

#Remove nas from source_data
source1 <- source1[complete.cases(source1), ]

#Check data types
str(source1)
str(db1)

#Convert to data frame
source1 <- as.data.frame(source1)

#Trim whitespace
db1$Stub <- trimws(db1$Stub)

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
sql_query1 <- 'SELECT * FROM dpoe_stage.dim.ctpp_line where yr = 2016'
final <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
odbcClose(channel)

#Delete unneccessary columns
final<- final[,-c(1:3)]

#Rename source data
source1 <- plyr::rename(source1, c("Table ID"="subject_table_id","Line Number"="line_number","Stub"="line_desc"))

#Check data types
str(source1)
str(final)

#Convert data types
source1$line_number <- as.integer(source1$line_number)

#Order table
source1 <- source1[order(source1$subject_table_id,source1$line_number,source1$line_desc),]
final <- final[order(final$subject_table_id,final$line_number,final$line_desc),]

#Trim whitespace
final$line_desc <- trimws(final$line_desc)

#delete rownames for checking files match (R assigns arbitrary IDs)
rownames(source1) <- NULL
rownames(final) <- NULL

#Compare files 
all(source1 == final) #check cell values only
all.equal(source1,final) #check cell values and data types and will return the conflicted cells
identical(source1,final) #check cell values and data types
which(source1!=final, arr.ind = TRUE) #which command shows exactly which columns are incorrect
