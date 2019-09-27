#CTPP 2006-2010 QAQC

#file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Load source data
file <- "R:/DPOE/CTPP/2006-2010/Documentation/2006-2010_CTPP_Documentation for AASHTO-4-24.xlsx"
source1 <- read_excel(file, sheet = 'Part1Tables')
source2 <- read_excel(file, sheet = 'Part2Tables')
source3 <- read_excel(file, sheet = 'Part3Tables')

#Load database data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- 'SELECT * FROM dpoe_stage.dbo.ctpp_2010_subj1'
db1 <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
sql_query2 <- 'SELECT * FROM dpoe_stage.dbo.ctpp_2010_subj2'
db2 <- sqlQuery(channel,sql_query2,stringsAsFactors = FALSE)
sql_query3 <- 'SELECT * FROM dpoe_stage.dbo.ctpp_2010_subj3'
db3 <- sqlQuery(channel,sql_query3,stringsAsFactors = FALSE)
odbcClose(channel)

# #To see column names in source data
# colnames(source1)
# colnames(db1)
# colnames(source2)
# colnames(db2)
# colnames(source3)
# colnames(db3)

#Rename files
source1 <- plyr::rename(source1, c("...1"="old_univ_num","...2"="old_unique_num","...3"="old_table_num","...4"="prefix_for_set","...5"="ctpp_part","...6"="univ_num","Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2010"="unique_num","...8"="collapse_suffix","...9"="table_num","...10"="content","...11"="universe","...12"="num_cells","...13"="uses_synth_data","...14"="variable_combo","...15"="notes","...16"="collapse_status","...17"="involves_mot"))
source2 <- plyr::rename(source2, c("...1"="old_univ_num","...2"="old_unique_num","...3"="old_table_num","...4"="prefix_for_set","...5"="ctpp_part","Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2010"="univ_num","...7"="unique_num","...8"="collapse_suffix","...9"="table_num","...10"="content","...11"="universe","...12"="num_cells","...13"="uses_synth_data","...14"="variable_combo","...15"="notes","...16"="collapse_status","...17"="involves_mot","...18"="source_table_internal"))
source3 <- plyr::rename(source3, c("...1"="old_univ_num","...2"="old_unique_num","...3"="old_table_num","...4"="prefix_for_set","...5"="ctpp_part","...6"="univ_num","Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2010"="unique_num","...8"="collapse_suffix","...9"="table_num","...10"="content","...11"="universe","...12"="num_cells","...13"="uses_synth_data","...14"="variable_combo","...15"="notes","...16"="collapse_status","...17"="involves_mot"))
db1 <- plyr::rename(db1, c("F1"="old_univ_num","F2"="old_unique_num","F3"="old_table_num","F4"="prefix_for_set","F5"="ctpp_part","F6"="univ_num","Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2"="unique_num","F8"="collapse_suffix","F9"="table_num","F10"="content","F11"="universe","F12"="num_cells","F13"="uses_synth_data","F14"="variable_combo","F15"="notes","F16"="collapse_status","F17"="involves_mot"))
db2 <- plyr::rename(db2, c("F1"="old_univ_num","F2"="old_unique_num","F3"="old_table_num","F4"="prefix_for_set","F5"="ctpp_part","Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2"="univ_num","F7"="unique_num","F8"="collapse_suffix","F9"="table_num","F10"="content","F11"="universe","F12"="num_cells","F13"="uses_synth_data","F14"="variable_combo","F15"="notes","F16"="collapse_status","F17"="involves_mot","F18"="source_table_internal"))
db3 <- plyr::rename(db3, c("F1"="old_univ_num","F2"="old_unique_num","F3"="old_table_num","F4"="prefix_for_set","F5"="ctpp_part","F6"="univ_num","Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2"="unique_num","F8"="collapse_suffix","F9"="table_num","F10"="content","F11"="universe","F12"="num_cells","F13"="uses_synth_data","F14"="variable_combo","F15"="notes","F16"="collapse_status","F17"="involves_mot"))

#Remove unneccessary rows from source_data
source1 <- source1[-c(1:2,191:195),]
source2 <- source2[-c(1:2,119:121),]
source3 <- source3[-c(1:2,43:44),]

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
source1$old_univ_num <- as.numeric(source1$old_univ_num)
source1$old_unique_num <- as.numeric(source1$old_unique_num)
source1$ctpp_part <- as.numeric(source1$ctpp_part)
source1$univ_num <- as.integer(source1$univ_num)
source1$unique_num <- as.numeric(source1$unique_num)
source1$num_cells <- as.numeric(source1$num_cells)

source2$old_univ_num <- as.numeric(source2$old_univ_num)
source2$old_unique_num <- as.numeric(source2$old_unique_num)
source2$old_table_num <- as.numeric(source2$old_table_num)
source2$ctpp_part <- as.numeric(source2$ctpp_part)
source2$univ_num <- as.integer(source2$univ_num)
source2$unique_num <- as.numeric(source2$unique_num)
source2$num_cells <- as.numeric(source2$num_cells)

source3$old_univ_num <- as.numeric(source3$old_univ_num)
source3$old_unique_num <- as.numeric(source3$old_unique_num)
source3$ctpp_part <- as.numeric(source3$ctpp_part)
source3$univ_num <- as.integer(source3$univ_num)
source3$unique_num <- as.numeric(source3$unique_num)
source3$num_cells <- as.numeric(source3$num_cells)


#delete rownames for checking files match (R assigns arbitrary IDs)
rownames(source1) <- NULL
rownames(db1) <- NULL
rownames(source2) <- NULL
rownames(db2) <- NULL
rownames(source3) <- NULL
rownames(db3) <- NULL

# Delete white space
db1$content <- trimws(db1$content)
db1$universe <- trimws(db1$universe)

db2$content <- trimws(db2$content)
db2$universe <- trimws(db2$universe)
db2$notes <- trimws(db2$notes)

db3$content <- trimws(db3$content)
db3$universe <- trimws(db3$universe)

#Compare files 
all(source1 == db1) #check cell values only
all.equal(source1,db1) #check cell values and data types and will return the conflicted cells
identical(source1,db1) #check cell values and data types
which(source1!=db1, arr.ind = TRUE) #which command shows exactly which columns are incorrect

all(source2 == db2) #check cell values only
all.equal(source2,db2) #check cell values and data types and will return the conflicted cells
identical(source2,db2) #check cell values and data types
which(source2!=db2, arr.ind = TRUE) #which command shows exactly which columns are incorrect

all(source3 == db3) #check cell values only
all.equal(source3,db3) #check cell values and data types and will return the conflicted cells
identical(source3,db3) #check cell values and data types
which(source3!=db3, arr.ind = TRUE) #which command shows exactly which columns are incorrect

#Missing values. Need to reload table into sql using openrowset
unique(source2$old_table_num)
unique(db2$old_table_num)

