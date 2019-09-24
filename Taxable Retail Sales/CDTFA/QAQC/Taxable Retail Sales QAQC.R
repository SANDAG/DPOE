#Taxable Retail Sales QAQC

#file comparison code between a xls source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Load source data
source <- read_excel("R:/DPOE/Taxable Sales by City/Source/TaxSalesCRCityCounty_edit.xlsx", sheet = 'Sheet1')

#Load database data
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query1 <- 'SELECT * FROM [dpoe_stage].[dbo].[cdtfa_taxable_sales]'
db <- sqlQuery(channel,sql_query1,stringsAsFactors = FALSE)
sql_query2 <- 'SELECT * FROM [dpoe_stage].[staging].[cdtfa_taxable_sales]'
db2 <- sqlQuery(channel,sql_query2,stringsAsFactors = FALSE)
odbcClose(channel)

#To see column names in source data
colnames(source)
colnames(db)

#Rename files
source <- plyr::rename(source, c("Taxable Sales, by City"="yr","...2"="qtr","...3"="month_from","...4"="month_to","...5"="county","...6"="city","...7"="retail_and_food_services","...8"="total","...9"="disclosure"))
db <- plyr::rename(db, c("Taxable Sales, by City"="yr","F2"="qtr","F3"="month_from","F4"="month_to","F5"="county","F6"="city","F7"="retail_and_food_services","F8"="total","F9"="disclosure"))

#Remove unneccessary rows from source_data
source <- source[grep("Calendar Year",source$yr, invert=TRUE),]

#Check data types
str(source)
str(db)

#Convert to data frame
source <- as.data.frame(source)

#Convert data types
source$yr <- as.numeric(source$yr)
source$month_from <- as.numeric(source$month_from)
source$month_to <- as.numeric(source$month_to)
source$retail_and_food_services <- as.numeric(source$retail_and_food_services)
source$total <- as.numeric(source$total)

#delete rownames for checking files match
rownames(source) <- NULL
rownames(db) <- NULL

#Compare files 
all(source == db) #check cell values only
all.equal(source,db) #check cell values and data types and will return the conflicted cells
identical(source,db) #check cell values and data types
which(source!=db, arr.ind = TRUE)

##########################################################################################################################

#file comparison code between a xls source file and final SQL Table

#To see column names in source data
colnames(source)
colnames(db2)

#Drop columns from source_data
source2 <- select(source, -c("month_from", "month_to", "disclosure"))

#Check data types
str(source2)
str(db2)

#Convert data types
source2$yr <- as.integer(source2$yr)

#Replace values in qtr column for consistency
source2$qtr[source2$qtr == "1"] <- "Q1"
source2$qtr[source2$qtr == "2"] <- "Q2"
source2$qtr[source2$qtr == "3"] <- "Q3"
source2$qtr[source2$qtr == "4"] <- "Q4"

#delete rownames for checking files match
rownames(source2) <- NULL
rownames(db2) <- NULL

#Compare files 
all(source2 == db2) #check cell values only
all.equal(source2,db2) #check cell values and data types and will return the conflicted cells
identical(source2,db2) #check cell values and data types
which(source2!=db2, arr.ind = TRUE)
