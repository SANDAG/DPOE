#CTPP 2012-2016 QAQC

#file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Load source data
file <- "R:/DPOE/CTPP/2012-2016/Documentation/2012-2016 CTPP Requirements.xlsx"
source1 <- read_excel(file, sheet = 'Part1Tables')
source2 <- read_excel(file, sheet = 'Part2Tables')
source3 <- read_excel(file, sheet = 'Part3Tables')

#Load database data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- 'SELECT * FROM dpoe_stage.dbo.ctpp_subj_1'
db1 <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
sql_query2 <- 'SELECT * FROM dpoe_stage.dbo.ctpp_subj_2'
db2 <- sqlQuery(channel,sql_query2,stringsAsFactors = FALSE)
sql_query3 <- 'SELECT * FROM dpoe_stage.dbo.ctpp_subj_3'
db3 <- sqlQuery(channel,sql_query3,stringsAsFactors = FALSE)
odbcClose(channel)

#To see column names in source data
# colnames(source1)
# colnames(db1)
# colnames(source2)
# colnames(db2)
# colnames(source3)
# colnames(db3)

#Rename files
source1 <- plyr::rename(source1, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2016 -- Part 1, Residence-Based Tables"="universe_num1","...2"="universe_num2","...3"="table_num","...4"="content","...5"="universe_desc","...6"="num_cells","...7"="geos","...8"="notes"))
source2 <- plyr::rename(source2, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2016 -- Part 2, Workplace-Based Tables"="universe_num1","...2"="universe_num2","...3"="table_num","...4"="content","...5"="universe_desc","...6"="num_cells","...7"="geos","...8"="notes"))
source3 <- plyr::rename(source3, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2016 -- Part 3, Worker Home-to-Work Flow Tables"="universe_num1","...2"="universe_num2","...3"="table_num","...4"="content","...5"="universe_desc","...6"="num_cells","...7"="geos","...8"="notes"))
db1 <- plyr::rename(db1, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2"="universe_num1", "F2"="universe_num2","F3"="table_num","F4"="content","F5"="universe_desc","F6"="num_cells","F7"="geos","F8"="notes"))
db2 <- plyr::rename(db2, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2"="universe_num1", "F2"="universe_num2","F3"="table_num","F4"="content","F5"="universe_desc","F6"="num_cells","F7"="geos","F8"="notes"))
db3 <- plyr::rename(db3, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2"="universe_num1", "F2"="universe_num2","F3"="table_num","F4"="content","F5"="universe_desc","F6"="num_cells","F7"="geos","F8"="notes"))

#Delete Notes Column
source1 <- select(source1, -"notes") 
source2 <- select(source2, -"notes")
source3 <- select(source3, -"notes")
db1 <- select(db1, -"notes") 
db2 <- select(db2, -"notes")
db3 <- select(db3, -"notes")

#Remove unneccessary rows from source_data
source1 <- source1[grep("Univ #",source1$universe_num1, invert=TRUE),]
source2 <- source2[grep("Univ #",source2$universe_num1, invert=TRUE),]
source3 <- source3[grep("Univ #",source3$universe_num1, invert=TRUE),]
source1 <- source1[grep("NOTE: Tables with an 'A' prefix are derived from standard ACS data, and 'B' tables are derived from privacy protected ACS data.",source1$universe_num1, invert=TRUE),]
source1 <- source1[-c(103,104,105),]
source2 <- source2[-c(48,49),]
source3 <- source3[-c(25,26),]

#Check data types
# str(source1)
# str(db1)
# str(source2)
# str(db2)
str(source3)
str(db3)

#Convert to data frame
source1 <- as.data.frame(source1)
source2 <- as.data.frame(source2)
source3 <- as.data.frame(source3)

#Convert data types
source1$universe_num1 <- as.integer(source1$universe_num1)
source2$universe_num1 <- as.integer(source2$universe_num1)
source3$universe_num1 <- as.integer(source3$universe_num1)
source1$universe_num2 <- as.integer(source1$universe_num2)
source2$universe_num2 <- as.integer(source2$universe_num2)
source3$universe_num2 <- as.numeric(source3$universe_num2)
source1$num_cells <- as.integer(source1$num_cells)
source2$num_cells <- as.integer(source2$num_cells)
source3$num_cells <- as.numeric(source3$num_cells)

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
db1$content <- trimws(db1$content)
db1$universe_desc <- trimws(db1$universe_desc)
db2$content <- trimws(db2$content)
db2$universe_desc <- trimws(db2$universe_desc)
db3$content <- trimws(db3$content)

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

####################################################################################################################################################################

#file comparison code between source file and final SQL Table

#Load database data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- 'SELECT * FROM dpoe_stage.dim.ctpp_subject_table where yr = 2016'
final <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
odbcClose(channel)

#Merge source files into one
source <- do.call("rbind", list(source1, source2, source3))

#Drop unneccessary columns
final<- final[,-c(1:3)]
source <- source[,-c(1:2,6:7)]

#Rename files
source <- plyr::rename(source, c("table_num"="tbl_name","content"="tbl_desc","universe_desc"="universe"))

#Check data types
# str(source)
# str(final)

#Trim whitespace
final$tbl_name <- trimws(final$tbl_name)
final$tbl_desc <- trimws(final$tbl_desc)
final$universe <- trimws(final$universe)

#Order table
source <- source[order(source$"tbl_name",source$"tbl_desc",source$"universe"),]
final <- final[order(final$"tbl_name",final$"tbl_desc",final$"universe"),]

#delete rownames for checking files match (R assigns arbitrary IDs)
rownames(source) <- NULL
rownames(final) <- NULL

#Compare files 
all(source == final) #check cell values only
all.equal(source,final) #check cell values and data types and will return the conflicted cells
identical(source,final) #check cell values and data types
which(source!=final, arr.ind = TRUE) #which command shows exactly which columns are incorrect

source[17,1]
final[17,1]