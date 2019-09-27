#CTPP 2012-2016 QAQC Find Table Specs

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
sql_query1 <- getSQL("R:/DPOE/CTPP/2012-2016/QAQC/Query/Final Table Specs.sql")
db1 <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
odbcClose(channel)

#To see column names in source data
colnames(source1)
colnames(db1)

#Delete unneccessary columns
source1 <- select(source1, -c("Wave","Type","Indent","Sub Range","1 Year Sourcing","3 Year Sourcing","5 Year Sourcing"))

#Remove unneccessary rows from source_data
source1 <- source1[grep("Univ #",source1$universe_num1, invert=TRUE),]
source2 <- source2[grep("Univ #",source2$universe_num1, invert=TRUE),]
source3 <- source3[grep("Univ #",source3$universe_num1, invert=TRUE),]
source1 <- source1[grep("NOTE: Tables with an 'A' prefix are derived from standard ACS data, and 'B' tables are derived from privacy protected ACS data.",source1$universe_num1, invert=TRUE),]

source1 <- na.omit(source1)
source2 <- na.omit(source2)
source3 <- na.omit(source3)

# Before omitting notes in db, convert db to dataframe
db1 <- as.data.table(db1)
db1 <- select(db1, -"notes") 
db1 <- na.omit(db1)
db2 <- as.data.table(db2)
db2 <- select(db2, -"notes") 
db2 <- na.omit(db2)
db3 <- as.data.table(db3)
db3 <- select(db3, -"notes") 
db3 <- na.omit(db3)

#Use to copy frustrating text
unique(source1$universe_num1)

#Check data types
str(source1)
str(db1)
str(source2)
str(db2)
str(source3)
str(db3)

#Convert to data frame
source1 <- as.data.frame(source1)
source2 <- as.data.frame(source2)
source3 <- as.data.frame(source3)
db1 <- as.data.frame(db1)
db2 <- as.data.frame(db2)
db3 <- as.data.frame(db3)

#Convert data types
source1$universe_num1 <- as.integer(source1$universe_num1)
source2$universe_num1 <- as.integer(source2$universe_num1)
source3$universe_num1 <- as.integer(source3$universe_num1)
source1$universe_num2 <- as.integer(source1$universe_num2)
source2$universe_num2 <- as.integer(source2$universe_num2)
source3$universe_num2 <- as.integer(source3$universe_num2)
source1$num_cells <- as.integer(source1$num_cells)
source2$num_cells <- as.integer(source2$num_cells)
source3$num_cells <- as.integer(source3$num_cells)

#Order database and source data
source1 <- source1[order(source1$"universe_num1",source1$"universe_num2",source1$"universe_desc",source1$"content",source1$"num_cells",source1$"geos"),]
source2 <- source2[order(source2$"universe_num1",source2$"universe_num2",source2$"universe_desc",source2$"content",source2$"num_cells",source2$"geos"),]
source3 <- source3[order(source3$"universe_num1",source3$"universe_num2",source3$"universe_desc",source3$"content",source3$"num_cells",source3$"geos"),]
db1 <- db1[order(db1$"universe_num1",db1$"universe_num2",db1$"universe_desc",db1$"content",db1$"num_cells",db1$"geos"),]
db2 <- db2[order(db2$"universe_num1",db2$"universe_num2",db2$"universe_desc",db2$"content",db2$"num_cells",db2$"geos"),]
db3 <- db3[order(db3$"universe_num1",db3$"universe_num2",db3$"universe_desc",db3$"content",db3$"num_cells",db3$"geos"),]



#delete rownames for checking files match (R assigns arbitrary IDs)
rownames(source1) <- NULL
rownames(db1) <- NULL
rownames(source2) <- NULL
rownames(db2) <- NULL
rownames(source3) <- NULL
rownames(db3) <- NULL

# Delete white space
trimws(db1$"content")
trimws(db1$"universe_desc")
trimws(db2$"content")
trimws(db2$"universe_desc")
trimws(db3$"content")

#Compare files 
all(source1 == db1) #check cell values only
all.equal(source1,db1) #check cell values and data types and will return the conflicted cells
identical(source1,db1) #check cell values and data types
which(source1!=db1, arr.ind = TRUE) #which commend shows exactly which collumns are incorrect

all(source2 == db2) #check cell values only
all.equal(source2,db2) #check cell values and data types and will return the conflicted cells
identical(source2,db2) #check cell values and data types
which(source2!=db2, arr.ind = TRUE) #which commend shows exactly which collumns are incorrect

all(source3 == db3) #check cell values only
all.equal(source3,db3) #check cell values and data types and will return the conflicted cells
identical(source3,db3) #check cell values and data types
which(source3!=db3, arr.ind = TRUE) #which commend shows exactly which collumns are incorrect