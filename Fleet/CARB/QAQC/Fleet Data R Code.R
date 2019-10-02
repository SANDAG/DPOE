#CARB Fleet Data

#set working directory and access code to read in SQL queries
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("..\\..\\..\\..\\..\\Common_functions\\Loading_in_packages.R")
source("..\\..\\..\\..\\..\\Common_functions\\readSQL.R")
getwd()

# file comparison code between a CSV source file and raw upload SQL Table

#Set the year parameter. Can change this to compare other years.
year=2017

#Read in source data
source_data <- read.csv(paste("R:\\DPOE\\Fleet Data\\CARB\\",year,"\\QAQC\\FleetDB-County-SANDIEGO-",year,"-Clean_concatenated.csv",sep=''), stringsAsFactors = FALSE)

#To see column names in source data
# colnames(source_data)

#Rename source and database data
source_data <- plyr::rename(source_data, c("Vehicle.Category"="vehicle", "GVWR.Class"="gvwr", "Fuel.Type"="fuel_type", "Model.Year"="model","Fuel.Technology"="fuel_tech", "Electric.Mile.Range"="electric_mile_range", "Number.of.Vehicles.Registered.at.the.Same.Address"="vpa", "County"="county", "MPO"="mpo", "Sub.Area"="subarea", "Census.Block.Group.Code"="blk_grp", "ZIP.Code"="zip", "Vehicle.Population"="vehicle_pop"))
source_data <- source_data[order(source_data$vehicle, source_data$gvwr, source_data$fuel_type, source_data$model, source_data$fuel_tech, source_data$electric_mile_range, source_data$vpa, source_data$county, source_data$mpo, source_data$subarea, source_data$blk_grp, source_data$zip, source_data$vehicle_pop),]


#Read in sQL query. Make sure to change year in the from clause to match the year above                      
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
sql_query <- 'EXEC [dbo].[fleet_data_yr] 2017'          
database_data <- sqlQuery(channel,sql_query,stringsAsFactors = FALSE)
odbcClose(channel)

#Order table
database_data <- database_data[order(database_data$vehicle, database_data$gvwr, database_data$fuel_type, database_data$model, database_data$fuel_tech, database_data$electric_mile_range, database_data$vpa, database_data$county, database_data$mpo, database_data$subarea, database_data$blk_grp, database_data$zip, database_data$vehicle_pop),]

#Check data types
# str(source_data)
# str(database_data)

#Delete unique key assigned by R so that identical function will work
rownames(source_data) <- NULL
rownames(database_data) <- NULL

# compare files 
all(source_data == database_data) #check cell values only
all.equal(source_data,database_data) #check cell values and data types and will return the conflicted cells
identical(source_data,database_data) #check cell values and data types


#####################################################################################################################################################################

#Compare source data to fact table

#Read in the SQL query, change year in file path name
channel <- odbcDriverConnect('driver={SQL Server}; server=socioeca8; database=dpoe_stage; trusted_connection=true')
fleet_sql = getSQL("../QAQC/source to Fact Table QAQC 2017.sql")
fleet_sql <- gsub("year",year,fleet_sql)
fleet<-sqlQuery(channel,fleet_sql)
odbcClose(channel)

#To see column names in fleet data
# colnames(fleet)
# colnames(source_data)

#Rename fleet data to match source. Make sure order is the same in both datasets.
fleet <- plyr::rename(fleet, c("vehicle_category_code"="vehicle", "gvwr_class"="gvwr", "fuel_type_code"="fuel_type", "model_yr_code"="model","fuel_tech_code"="fuel_tech", "electric_mile_range_code"="electric_mile_range", "vpa_code"="vpa", "fleet_data_county"="county", "fleet_data_mpo"="mpo", "fleet_data_subarea"="subarea", "fleet_data_blk_grp"="blk_grp", "fleet_data_zip"="zip", "vehicle_pop"="vehicle_pop"))

#Find unique column values
# unique(fleet$vehicle)
# unique(source_data$vehicle)
# all(unique(fleet$model) == unique(source_data$model))

#Convert source data column vehicle to uppercase p
source_data$vehicle <-as.character(source_data$vehicle)
source_data$vehicle[source_data$vehicle == "p"] <- "P"

#Check data types
# str(source_data)
# str(fleet)
# all(str(fleet) == str(source_data))

#Change fleet data types from Factor to Chr
i <- sapply(fleet, is.factor)
fleet[i] <- lapply(fleet[i], as.character)

#Remove values from source table that are not in SD County
##Remove where left 5 values of block group don't equal 06073 and where zip code is not between 91901 and 92672##
source_data_2 <- sqldf("SELECT * FROM source_data WHERE (substr(blk_grp, 1, 5) = '06073' OR blk_grp IN ('Scrubbed', 'Unknown')) AND (zip BETWEEN '91901' AND '92672' OR zip IN ('Scrubbed', 'Unknown'))")

#Order table
fleet <- fleet[order(fleet$vehicle, fleet$gvwr, fleet$fuel_type, fleet$model, fleet$fuel_tech, fleet$electric_mile_range, fleet$vpa, fleet$county, fleet$mpo, fleet$subarea, fleet$blk_grp, fleet$zip, fleet$vehicle_pop),]
source_data_2 <- source_data_2[order(source_data_2$vehicle, source_data_2$gvwr, source_data_2$fuel_type, source_data_2$model, source_data_2$fuel_tech, source_data_2$electric_mile_range, source_data_2$vpa, source_data_2$county, source_data_2$mpo, source_data_2$subarea, source_data_2$blk_grp, source_data_2$zip, source_data_2$vehicle_pop),]

#Delete unique key assigned by R so that identical function will work
rownames(source_data_2) <- NULL
rownames(fleet) <- NULL

# compare files 
all(source_data_2 == fleet) #check cell values only
all.equal(source_data_2,fleet) #check cell values and data types and will return the conflicted cells
identical(source_data_2,fleet) #check cell values and data types

#Create a csv from the output
#write.csv(fleet, paste("R:\\DPOE\\CARB Fleet Data\\CARB\\",year,"\\OutputData\\fleet",year,".csv",sep = ''),row.names = FALSE)

