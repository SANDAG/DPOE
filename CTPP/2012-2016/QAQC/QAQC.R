#CTPP 2012-2016 QAQC

#file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
install.packages("here")
library(here)
source(here("Common_functions","readSQL.R"))
source(here("Common_functions","Loading_in_packages.R"))

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
colnames(source1)
colnames(db1)
colnames(source2)
colnames(db2)
colnames(source3)
colnames(db3)

#Rename files
source1 <- plyr::rename(source1, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2016 -- Part 1, Residence-Based Tables"="universe_num1","...2"="universe_num2","...3"="table_num","...4"="content","...5"="universe_desc","...6"="num_cells","...7"="geos","...8"="notes"))
source2 <- plyr::rename(source2, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2016 -- Part 2, Workplace-Based Tables"="universe_num1","...2"="universe_num2","...3"="table_num","...4"="content","...5"="universe_desc","...6"="num_cells","...7"="geos","...8"="notes"))
source3 <- plyr::rename(source3, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2016 -- Part 3, Worker Home-to-Work Flow Tables"="universe_num1","...2"="universe_num2","...3"="table_num","...4"="content","...5"="universe_desc","...6"="num_cells","...7"="geos","...8"="notes"))
db1 <- plyr::rename(db1, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2"="universe_num1", "F2"="universe_num2","F3"="table_num","F4"="content","F5"="universe_desc","F6"="num_cells","F7"="geos","F8"="notes"))
db2 <- plyr::rename(db2, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2"="universe_num1", "F2"="universe_num2","F3"="table_num","F4"="content","F5"="universe_desc","F6"="num_cells","F7"="geos","F8"="notes"))
db3 <- plyr::rename(db3, c("Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2"="universe_num1", "F2"="universe_num2","F3"="table_num","F4"="content","F5"="universe_desc","F6"="num_cells","F7"="geos","F8"="notes"))

#Remove unneccessary rows from source_data
source1 <- source1[grep("Univ #",source1$universe_num1, invert=TRUE),]
source2 <- source1[grep("Univ #",source2$universe_num1, invert=TRUE),]
source3 <- source1[grep("Univ #",source3$universe_num1, invert=TRUE),]
#Need to also remove the bottom rows

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

#Convert data types
source1$universe_num1 <- as.integer(source1$universe_num1)
source2$universe_num1 <- as.integer(source2$universe_num1)
source3$universe_num1 <- as.integer(source3$universe_num1)
source1$universe_num2 <- as.numeric(source1$universe_num2)
source2$universe_num2 <- as.numeric(source2$universe_num2)
source3$universe_num2 <- as.numeric(source3$universe_num2)
#keep going

#Order database and source data

#delete rownames for checking files match
rownames(source1) <- NULL
rownames(db1) <- NULL
rownames(source2) <- NULL
rownames(db2) <- NULL
rownames(source3) <- NULL
rownames(db3) <- NULL

#Compare files 
all(source1 == db1) #check cell values only
all.equal(source1,db1) #check cell values and data types and will return the conflicted cells
identical(source1,db1) #check cell values and data types
which(source1!=db1, arr.ind = TRUE)

all(source2 == db2) #check cell values only
all.equal(source2,db2) #check cell values and data types and will return the conflicted cells
identical(source2,db2) #check cell values and data types
which(source2!=db2, arr.ind = TRUE)

all(source3 == db3) #check cell values only
all.equal(source3,db3) #check cell values and data types and will return the conflicted cells
identical(source3,db3) #check cell values and data types
which(source3!=db3, arr.ind = TRUE)