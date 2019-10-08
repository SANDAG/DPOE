USE [socioec_data_stage]
--GO

--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

----Declare year variables
--DECLARE @END_YEAR smallint = 2017, @START_YEAR smallint = 2002;

------Drop table names
--DROP TABLE IF EXISTS #NAMES_1
--DROP TABLE IF EXISTS #NAMES_2
--DROP TABLE IF EXISTS #NAMES_3

----Create temp name tables
--CREATE TABLE #NAMES_1(NAME_1 varchar(4))
--CREATE TABLE #NAMES_2(NAME_2 varchar(4))

----Load table #NAMES_1
--INSERT INTO #NAMES_1 VALUES('JT00');
--INSERT INTO #NAMES_1 VALUES('JT01');
--INSERT INTO #NAMES_1 VALUES('JT02');
--INSERT INTO #NAMES_1 VALUES('JT03');
--INSERT INTO #NAMES_1 VALUES('JT04');
--INSERT INTO #NAMES_1 VALUES('JT05');

----Load table #NAMES_2
--INSERT INTO #NAMES_2 VALUES('S000');
--INSERT INTO #NAMES_2 VALUES('SA01');
--INSERT INTO #NAMES_2 VALUES('SA02');
--INSERT INTO #NAMES_2 VALUES('SA03');
--INSERT INTO #NAMES_2 VALUES('SE01');
--INSERT INTO #NAMES_2 VALUES('SE02');
--INSERT INTO #NAMES_2 VALUES('SE03');
--INSERT INTO #NAMES_2 VALUES('SI01');
--INSERT INTO #NAMES_2 VALUES('SI02');
--INSERT INTO #NAMES_2 VALUES('SI03');

----Combine name tables into a #NAMES_3 table
--select a.NAME_1
--,b.NAME_2 
--into #NAMES_3 
--from #NAMES_1 as a 
--CROSS JOIN #NAMES_2 as b
--order by NAME_1
--,NAME_2
----SELECT * FROM #NAMES_3

----Drop tables if they exist
--IF OBJECT_ID('socioec_data_stage.lehd_lodes.wac', 'U') IS NOT NULL 
--DROP TABLE socioec_data_stage.lehd_lodes.wac;

--IF OBJECT_ID('socioec_data_stage.lehd_lodes.temp_wac_0', 'U') IS NOT NULL 
--DROP TABLE socioec_data_stage.lehd_lodes.temp_wac_0;

--IF OBJECT_ID('socioec_data_stage.lehd_lodes.temp_wac_1', 'U') IS NOT NULL 
--DROP TABLE socioec_data_stage.lehd_lodes.temp_wac_1;

----Create first temp table
--CREATE TABLE socioec_data_stage.lehd_lodes.temp_wac_0(
--w_geoid varchar(15),
--C000 int,
--CA01 int,
--CA02 int,
--CA03 int,
--CE01 int,
--CE02 int,
--CE03 int,
--CNS01 int,
--CNS02 int,
--CNS03 int,
--CNS04 int,
--CNS05 int,
--CNS06 int,
--CNS07 int,
--CNS08 int,
--CNS09 int,
--CNS10 int,
--CNS11 int,
--CNS12 int,
--CNS13 int,
--CNS14 int,
--CNS15 int,
--CNS16 int,
--CNS17 int,
--CNS18 int,
--CNS19 int,
--CNS20 int,
--CR01 int,
--CR02 int,
--CR03 int,
--CR04 int,
--CR05 int,
--CR07 int,
--CT01 int,
--CT02 int,
--CD01 int,
--CD02 int,
--CD03 int,
--CD04 int,
--CS01 int,
--CS02 int,
--CFA01 int,
--CFA02 int,
--CFA03 int,
--CFA04 int,
--CFA05 int,
--CFS01 int,
--CFS02 int,
--CFS03 int,
--CFS04 int,
--CFS05 int,
--createdate int
--)

----Create the cumulative table, drop createdate, include type, segment, and yr 
--CREATE TABLE socioec_data_stage.lehd_lodes.wac(
--w_geoid varchar(15),
--C000 int,
--CA01 int,
--CA02 int,
--CA03 int,
--CE01 int,
--CE02 int,
--CE03 int,
--CNS01 int,
--CNS02 int,
--CNS03 int,
--CNS04 int,
--CNS05 int,
--CNS06 int,
--CNS07 int,
--CNS08 int,
--CNS09 int,
--CNS10 int,
--CNS11 int,
--CNS12 int,
--CNS13 int,
--CNS14 int,
--CNS15 int,
--CNS16 int,
--CNS17 int,
--CNS18 int,
--CNS19 int,
--CNS20 int,
--CR01 int,
--CR02 int,
--CR03 int,
--CR04 int,
--CR05 int,
--CR07 int,
--CT01 int,
--CT02 int,
--CD01 int,
--CD02 int,
--CD03 int,
--CD04 int,
--CS01 int,
--CS02 int,
--CFA01 int,
--CFA02 int,
--CFA03 int,
--CFA04 int,
--CFA05 int,
--CFS01 int,
--CFS02 int,
--CFS03 int,
--CFS04 int,
--CFS05 int,
--type varchar(4),
--segment varchar(4),
--yr smallint
--) WITH (DATA_COMPRESSION = PAGE)

----Declare variables
--DECLARE @filename_1 varchar(4), @filename_2 varchar(4),
-- @IMP varchar(500), @i SMALLINT = @START_YEAR, @MAX_VAL SMALLINT = @END_YEAR, @FIN varchar(500);


--declare c1 cursor for SELECT NAME_1, NAME_2 FROM #NAMES_3
--open c1
--fetch next from c1 into @filename_1, @filename_2

----first (outer) loop iterating over names
--WHILE @@fetch_status <> -1
--BEGIN

----second (inner) loop iterating over years
--WHILE @i <= @MAX_VAL
--BEGIN

----LOAD DATA FROM SOURCE INTO TEMP TABLE
--SET @IMP = 'BULK INSERT SOCIOEC_DATA_STAGE.LEHD_LODES.TEMP_WAC_0 FROM ''\\SANDAG.ORG\\DATASOLUTIONS\\DPOE\\LEHD LODES\\7.4\\SOURCE\\WAC\\CA_WAC_'
--+ @FILENAME_2 + '_' + @FILENAME_1 + '_' + CAST(@I AS VARCHAR(4)) + '.CSV'' WITH(TABLOCK, BATCHSIZE=100000, FIRSTROW = 2,FIELDTERMINATOR = '','',ROWTERMINATOR = ''0X0A'')';
--PRINT @IMP

--EXEC(@IMP)

----Add type, segment, and yr to table and load into a second temp table
--select *
--,cast(@filename_1 as varchar(4)) as type
--,cast(@filename_2 as varchar(4)) as segment
--,cast(@i as smallint) as yr 
--into socioec_data_stage.lehd_lodes.temp_wac_1 
--from socioec_data_stage.lehd_lodes.temp_wac_0
--where left(w_geoid,5) = '06073'

----Drop column createdate from second temp table, delete first temp table
--alter table socioec_data_stage.lehd_lodes.temp_wac_1 drop column createdate
--delete from socioec_data_stage.lehd_lodes.temp_wac_0

----Append to the final table, delete second temp table
--insert into socioec_data_stage.lehd_lodes.wac 
--WITH (TABLOCK)
--select *
--from socioec_data_stage.lehd_lodes.temp_wac_1

--drop table socioec_data_stage.lehd_lodes.temp_wac_1

--SET @i = @i + 1;

--print CURRENT_TIMESTAMP
--print @filename_1
--print @filename_2
--print @i
--END;

----resetting the counter
--set @i=@START_YEAR
--print @i

--fetch next from c1 into @filename_1,@filename_2
--END;

----Delete first temp table
--drop table socioec_data_stage.lehd_lodes.temp_wac_0

--close c1
--deallocate c1

----Delete names temp tables
--drop table #NAMES_1,#NAMES_2,#NAMES_3

-- SELECT count(*) FROM socioec_data_stage.lehd_lodes.wac
SELECT * FROM socioec_data_stage.lehd_lodes.wac