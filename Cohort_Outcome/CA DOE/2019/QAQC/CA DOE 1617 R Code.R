#CA DOE Cohort Outcome 1617 Data

# file comparison code between a CSV source file and raw upload SQL Table

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\..\\Common_functions\\readSQL.R")
getwd()

#Read in source and database files
source_data <- read.delim("R:\\DPOE\\CALPADS\\Source\\cohort1617.txt")

#Read in SQL data 
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT * FROM [dpoe_stage].[dbo].[cohort1617]'
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#To see column names in data
# colnames(source_data)
# colnames(database_data)

#Rename columns
source_data <- plyr::rename(source_data, c("�..AcademicYear"="AcademicYear", "Regular.HS.Diploma.Graduates..Count."="Regular HS Diploma Graduates (Count)",
                                           "Met.UC.CSU.Grad.Req.s..Rate."="Met UC CSU Grad Req's (Rate)", "Golden.State.Seal.Merit.Diploma..Count."= "Golden State Seal Merit Diploma (Count)",
                                           "CHSPE.Completer..Rate."="CHSPE Completer (Rate)", "SPED.Certificate..Count."="SPED Certificate (Count)",
                                           "GED.Completer..Rate."="GED Completer (Rate)", "Dropout..Count."="Dropout (Count)", "Still.Enrolled..Rate."="Still Enrolled (Rate)",
                                           "Regular.HS.Diploma.Graduates..Rate."="Regular HS Diploma Graduates (Rate)", "Seal.of.Biliteracy..Count."="Seal of Biliteracy (Count)",
                                           "Golden.State.Seal.Merit.Diploma..Rate"="Golden State Seal Merit Diploma (Rate", "Adult.Ed..HS.Diploma..Count."="Adult Ed  HS Diploma (Count)",
                                           "SPED.Certificate..Rate."="SPED Certificate (Rate)", "Other.Transfer..Count."="Other Transfer (Count)", "Dropout..Rate."="Dropout (Rate)",
                                           "Met.UC.CSU.Grad.Req.s..Count."="Met UC CSU Grad Req's (Count)", "Seal.of.Biliteracy..Rate."="Seal of Biliteracy (Rate)", 
                                           "CHSPE.Completer..Count."="CHSPE Completer (Count)", "Adult.Ed..HS.Diploma..Rate."="Adult Ed  HS Diploma (Rate)", "GED.Completer..Count."="GED Completer (Count)", 
                                           "Other.Transfer..Rate."="Other Transfer (Rate)", "Still.Enrolled..Count."="Still Enrolled (Count)"))

#Verify that this worked
# all(colnames(source_data) == colnames(database_data))

#Check data types
# str(source_data)
# str(database_data)
# all(str(source_data) == str(database_data))

#Create column name list
# source_names <- colnames(source_data)
# source_names <- source_names[- c(3:5)]

#Convert data types
source_data$AcademicYear <- as.vector(source_data$AcademicYear)
source_data$AggregateLevel <- as.vector(source_data$AggregateLevel)
source_data$CountyName <- as.vector(source_data$CountyName)
source_data$DistrictName <- as.vector(source_data$DistrictName)
source_data$SchoolName <- as.vector(source_data$SchoolName)
source_data$CharterSchool <- as.vector(source_data$CharterSchool)
source_data$DASS <- as.vector(source_data$DASS)
source_data$ReportingCategory <- as.vector(source_data$ReportingCategory)
source_data$CohortStudents <- as.vector(source_data$CohortStudents)
source_data$"Regular HS Diploma Graduates (Count)" <- as.vector(source_data$"Regular HS Diploma Graduates (Count)")
source_data$"Regular HS Diploma Graduates (Rate)" <- as.vector(source_data$"Regular HS Diploma Graduates (Rate)")
source_data$"Met UC CSU Grad Req's (Count)" <- as.vector(source_data$"Met UC CSU Grad Req's (Count)")
source_data$"Met UC CSU Grad Req's (Rate)" <- as.vector(source_data$"Met UC CSU Grad Req's (Rate)")
source_data$"Seal of Biliteracy (Count)" <- as.vector(source_data$"Seal of Biliteracy (Count)")
source_data$"Seal of Biliteracy (Rate)" <- as.vector(source_data$"Seal of Biliteracy (Rate)")
source_data$"Golden State Seal Merit Diploma (Count)" <- as.vector(source_data$"Golden State Seal Merit Diploma (Count)")
source_data$"Golden State Seal Merit Diploma (Rate" <- as.vector(source_data$"Golden State Seal Merit Diploma (Rate")
source_data$"CHSPE Completer (Count)" <- as.vector(source_data$"CHSPE Completer (Count)")
source_data$"CHSPE Completer (Rate)" <- as.vector(source_data$"CHSPE Completer (Rate)")
source_data$"Adult Ed  HS Diploma (Count)" <- as.vector(source_data$"Adult Ed  HS Diploma (Count)")
source_data$"Adult Ed  HS Diploma (Rate)" <- as.vector(source_data$"Adult Ed  HS Diploma (Rate)")
source_data$"SPED Certificate (Count)" <- as.vector(source_data$"SPED Certificate (Count)")
source_data$"SPED Certificate (Rate)" <- as.vector(source_data$"SPED Certificate (Rate)")
source_data$"GED Completer (Count)" <- as.vector(source_data$"GED Completer (Count)")
source_data$"GED Completer (Rate)" <- as.vector(source_data$"GED Completer (Rate)")
source_data$"Other Transfer (Count)" <- as.vector(source_data$"Other Transfer (Count)")
source_data$"Other Transfer (Rate)" <- as.vector(source_data$"Other Transfer (Rate)")
source_data$"Dropout (Count)" <- as.vector(source_data$"Dropout (Count)")
source_data$"Dropout (Rate)" <- as.vector(source_data$"Dropout (Rate)")
source_data$"Still Enrolled (Count)" <- as.vector(source_data$"Still Enrolled (Count)")
source_data$"Still Enrolled (Rate)" <- as.vector(source_data$"Still Enrolled (Rate)")
source_data$CountyCode <- as.vector(source_data$CountyCode)
source_data$DistrictCode <- as.vector(source_data$DistrictCode)
source_data$SchoolCode <- as.vector(source_data$SchoolCode)


#Order source data table
source_data <- source_data[order(source_data$"AcademicYear",source_data$"AggregateLevel",source_data$"CountyCode",source_data$"DistrictCode",source_data$"SchoolCode",source_data$"CountyName",source_data$"DistrictName",source_data$"SchoolName",source_data$"CharterSchool",
                                 source_data$"DASS",source_data$"ReportingCategory",source_data$"CohortStudents",source_data$"Regular HS Diploma Graduates (Count)",source_data$"Regular HS Diploma Graduates (Rate)",source_data$"Met UC CSU Grad Req's (Count)",
                                 source_data$"Met UC CSU Grad Req's (Rate)",source_data$"Seal of Biliteracy (Count)",source_data$"Seal of Biliteracy (Rate)",source_data$"Golden State Seal Merit Diploma (Count)",source_data$"Golden State Seal Merit Diploma (Rate",
                                 source_data$"CHSPE Completer (Count)",source_data$"CHSPE Completer (Rate)",source_data$"Adult Ed  HS Diploma (Count)",source_data$"Adult Ed  HS Diploma (Rate)",source_data$"SPED Certificate (Count)",source_data$"SPED Certificate (Rate)",
                                 source_data$"GED Completer (Count)",source_data$"GED Completer (Rate)",source_data$"Other Transfer (Count)",source_data$"Other Transfer (Rate)",source_data$"Dropout (Count)",source_data$"Dropout (Rate)",source_data$"Still Enrolled (Count)",
                                 source_data$"Still Enrolled (Rate)"),]  

#Order database data table
database_data <- database_data[order(database_data$"AcademicYear",database_data$"AggregateLevel",database_data$"CountyCode",database_data$"DistrictCode",database_data$"SchoolCode",database_data$"CountyName",database_data$"DistrictName",database_data$"SchoolName",
                                     database_data$"CharterSchool",database_data$"DASS",database_data$"ReportingCategory",database_data$"CohortStudents",database_data$"Regular HS Diploma Graduates (Count)",database_data$"Regular HS Diploma Graduates (Rate)",
                                     database_data$"Met UC CSU Grad Req's (Count)",database_data$"Met UC CSU Grad Req's (Rate)",database_data$"Seal of Biliteracy (Count)",database_data$"Seal of Biliteracy (Rate)",database_data$"Golden State Seal Merit Diploma (Count)",
                                     database_data$"Golden State Seal Merit Diploma (Rate",database_data$"CHSPE Completer (Count)",database_data$"CHSPE Completer (Rate)",database_data$"Adult Ed  HS Diploma (Count)",database_data$"Adult Ed  HS Diploma (Rate)",
                                     database_data$"SPED Certificate (Count)",database_data$"SPED Certificate (Rate)",database_data$"GED Completer (Count)",database_data$"GED Completer (Rate)",database_data$"Other Transfer (Count)",database_data$"Other Transfer (Rate)",
                                     database_data$"Dropout (Count)",database_data$"Dropout (Rate)",database_data$"Still Enrolled (Count)",database_data$"Still Enrolled (Rate)"),]  

#Delete unique key assigned by R so that identical function will work
rownames(source_data) <- NULL
rownames(database_data) <- NULL

#compare files 
all(source_data == database_data) #check cell values only
all.equal(source_data,database_data) #check cell values and data types and will return the conflicted cells
identical(source_data,database_data) #check cell values and data types
which(source_data!=database_data,arr.ind=TRUE)


#####################################################################################################################################################################

#Compare source data to fact table

#Read in sql query
options(stringsAsFactors=FALSE)
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'SELECT * FROM [dpoe_stage].[staging].[cohort_outcome]'
cohort<-sqlQuery(channel,sql_query)
odbcClose(channel)

#To see column names in cohort data
# colnames(cohort)
# colnames(source_data)

#Rename source data to match fact table. Make sure order is the same in both datasets.
source_data <- plyr::rename(source_data, c("Golden State Seal Merit Diploma (Rate"="Golden State Seal Merit Diploma (Rate)"))

#Check data types
# str(source_data)
# str(cohort)

#Convert data types
source_data$CohortStudents <- as.integer(source_data$CohortStudents)
source_data$"Regular HS Diploma Graduates (Count)" <- as.integer(source_data$"Regular HS Diploma Graduates (Count)")
source_data$"Regular HS Diploma Graduates (Rate)" <- as.numeric(source_data$"Regular HS Diploma Graduates (Rate)")
source_data$"Met UC CSU Grad Req's (Count)" <- as.integer(source_data$"Met UC CSU Grad Req's (Count)")
source_data$"Met UC CSU Grad Req's (Rate)" <- as.numeric(source_data$"Met UC CSU Grad Req's (Rate)")
source_data$"Seal of Biliteracy (Count)" <- as.integer(source_data$"Seal of Biliteracy (Count)")
source_data$"Seal of Biliteracy (Rate)" <- as.numeric(source_data$"Seal of Biliteracy (Rate)")
source_data$"Golden State Seal Merit Diploma (Count)" <- as.integer(source_data$"Golden State Seal Merit Diploma (Count)")
source_data$"Golden State Seal Merit Diploma (Rate)" <- as.numeric(source_data$"Golden State Seal Merit Diploma (Rate)")
source_data$"CHSPE Completer (Count)" <- as.integer(source_data$"CHSPE Completer (Count)")
source_data$"CHSPE Completer (Rate)" <- as.numeric(source_data$"CHSPE Completer (Rate)")
source_data$"Adult Ed  HS Diploma (Count)" <- as.integer(source_data$"Adult Ed  HS Diploma (Count)")
source_data$"Adult Ed  HS Diploma (Rate)" <- as.numeric(source_data$"Adult Ed  HS Diploma (Rate)")
source_data$"SPED Certificate (Count)" <- as.integer(source_data$"SPED Certificate (Count)")
source_data$"SPED Certificate (Rate)" <- as.numeric(source_data$"SPED Certificate (Rate)")
source_data$"GED Completer (Count)" <- as.integer(source_data$"GED Completer (Count)")
source_data$"GED Completer (Rate)" <- as.numeric(source_data$"GED Completer (Rate)")
source_data$"Other Transfer (Count)" <- as.integer(source_data$"Other Transfer (Count)")
source_data$"Other Transfer (Rate)" <- as.numeric(source_data$"Other Transfer (Rate)")
source_data$"Dropout (Count)" <- as.integer(source_data$"Dropout (Count)")
source_data$"Dropout (Rate)" <- as.numeric(source_data$"Dropout (Rate)")
source_data$"Still Enrolled (Count)" <- as.integer(source_data$"Still Enrolled (Count)")
source_data$"Still Enrolled (Rate)" <- as.numeric(source_data$"Still Enrolled (Rate)")

#Convert NA's to 0s
source_data$DistrictCode[is.na(source_data$DistrictCode)] <- 0
source_data$SchoolCode[is.na(source_data$SchoolCode)] <- 0

#Order table cohort
cohort <- cohort[order(cohort$"AcademicYear",cohort$"AggregateLevel",cohort$"CountyCode",cohort$"DistrictCode",cohort$"SchoolCode",cohort$"CountyName",cohort$"DistrictName",cohort$"SchoolName",cohort$"CharterSchool",cohort$"DASS",cohort$"ReportingCategory",cohort$"CohortStudents",
                       cohort$"Regular HS Diploma Graduates (Count)",cohort$"Regular HS Diploma Graduates (Rate)",cohort$"Met UC CSU Grad Req's (Count)",cohort$"Met UC CSU Grad Req's (Rate)",cohort$"Seal of Biliteracy (Count)",cohort$"Seal of Biliteracy (Rate)",
                       cohort$"Golden State Seal Merit Diploma (Count)",cohort$"Golden State Seal Merit Diploma (Rate)",cohort$"CHSPE Completer (Count)",cohort$"CHSPE Completer (Rate)",cohort$"Adult Ed  HS Diploma (Count)",cohort$"Adult Ed  HS Diploma (Rate)",
                       cohort$"SPED Certificate (Count)",cohort$"SPED Certificate (Rate)",cohort$"GED Completer (Count)",cohort$"GED Completer (Rate)",cohort$"Other Transfer (Count)",cohort$"Other Transfer (Rate)",cohort$"Dropout (Count)",cohort$"Dropout (Rate)",
                       cohort$"Still Enrolled (Count)",cohort$"Still Enrolled (Rate)"),]

#Order source data table
source_data <- source_data[order(source_data$"AcademicYear",source_data$"AggregateLevel",source_data$"CountyCode",source_data$"DistrictCode",source_data$"SchoolCode",source_data$"CountyName",source_data$"DistrictName",source_data$"SchoolName",source_data$"CharterSchool",
                                 source_data$"DASS",source_data$"ReportingCategory",source_data$"CohortStudents",source_data$"Regular HS Diploma Graduates (Count)",source_data$"Regular HS Diploma Graduates (Rate)",source_data$"Met UC CSU Grad Req's (Count)",
                                 source_data$"Met UC CSU Grad Req's (Rate)",source_data$"Seal of Biliteracy (Count)",source_data$"Seal of Biliteracy (Rate)",source_data$"Golden State Seal Merit Diploma (Count)",source_data$"Golden State Seal Merit Diploma (Rate)",
                                 source_data$"CHSPE Completer (Count)",source_data$"CHSPE Completer (Rate)",source_data$"Adult Ed  HS Diploma (Count)",source_data$"Adult Ed  HS Diploma (Rate)",source_data$"SPED Certificate (Count)",source_data$"SPED Certificate (Rate)",
                                 source_data$"GED Completer (Count)",source_data$"GED Completer (Rate)",source_data$"Other Transfer (Count)",source_data$"Other Transfer (Rate)",source_data$"Dropout (Count)",source_data$"Dropout (Rate)",source_data$"Still Enrolled (Count)",
                                 source_data$"Still Enrolled (Rate)"),]  


#Delete unique key assigned by R so that identical function will work
rownames(source_data) <- NULL
rownames(cohort) <- NULL

#compare files 
all(source_data == cohort) #check cell values only
all.equal(source_data,cohort) #check cell values and data types and will return the conflicted cells
identical(source_data$AcademicYear,cohort$AcademicYear) #check cell values and data types
which(source_data!=cohort,arr.ind=TRUE)

