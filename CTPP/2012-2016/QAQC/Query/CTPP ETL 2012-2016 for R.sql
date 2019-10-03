----CTPP 2012-2016 ETL

----Raw data upload
----SELECT TOP 100* FROM [dpoe_stage].[staging].[ctpp_2016]

----Remove source column
--ALTER TABLE [dpoe_stage].[staging].[ctpp_2016]
--DROP COLUMN SOURCE;

----Load into a new table
--IF OBJECT_ID('staging.ctpp_2012_2016', 'u') IS NULL
----DROP TABLE staging.ctpp_2012_2016
--CREATE TABLE staging.ctpp_2012_2016
--(
--ctpp_id int identity (1,1) primary key not null
----,yr smallint not null
----,release_type_id nvarchar(3) not null
--,geo_id nvarchar(255) not null
--,table_id nvarchar(15) not null
--,line_number int not null
--,estimate float null
--,moe float null
--)
----select * from staging.ctpp_2012_2016

----Load staging table
----Remove quotes and commas from the data
--INSERT INTO staging.ctpp_2012_2016 (geo_id, table_id, line_number, estimate, moe)
----Optimized code
--SELECT REPLACE(GEOID,'"','') as geo_id
--	,REPLACE(TBLID,'"','') as TBLID
--	,[LINENO]
--	,CASE
--		WHEN est LIKE '%^%' THEN REPLACE (est,'^',null)
--		--WHEN est LIKE '%+%' THEN REPLACE (est,'+','')
--		--WHEN est LIKE '%-%' THEN REPLACE (est,'-','')
--		ELSE REPLACE(REPLACE(REPLACE(REPLACE(est,'"',''), ',', ''), '+',''),'-','')
--	END as est
--	,CASE 
--		WHEN moe LIKE '%**%' THEN REPLACE (moe,'**',null)
--		WHEN moe LIKE '%***%' THEN REPLACE (moe,'***',null)
--		WHEN moe LIKE '%*****%' THEN REPLACE (moe,'*****',null)
--		ELSE REPLACE(REPLACE(REPLACE(moe,'"',''),'+/-',''),',','')
--	END as moe
--FROM dpoe_stage.staging.ctpp_2016


----------------------------------------------------------------------------------------------------------------------------------------------------------

----Create dim tables

----Subject Table
----Clean up tables
----Remove empty columns
--ALTER TABLE dpoe_stage.dbo.ctpp_subj_1
--DROP COLUMN F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52
----SELECT * FROM dbo.ctpp_subj_1

--ALTER TABLE dpoe_stage.dbo.ctpp_subj_2
--DROP COLUMN F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52,F53
----SELECT * FROM dbo.ctpp_subj_2

--ALTER TABLE dpoe_stage.dbo.ctpp_subj_3
--DROP COLUMN F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52
----SELECT * FROM dbo.ctpp_subj_3

----Delete unneccessary rows
--DELETE FROM dpoe_stage.dbo.ctpp_subj_1 WHERE [Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2] IS NULL
--DELETE FROM dpoe_stage.dbo.ctpp_subj_2 WHERE [Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2] IS NULL
--DELETE FROM dpoe_stage.dbo.ctpp_subj_3 WHERE [Census Transportation Planning Products (CTPP) 5-Year ACS 2012-2] IS NULL
--DELETE FROM dpoe_stage.dbo.ctpp_subj_1 WHERE F3 IS NULL
--DELETE FROM dpoe_stage.dbo.ctpp_subj_2 WHERE F3 IS NULL
--DELETE FROM dpoe_stage.dbo.ctpp_subj_3 WHERE F3 IS NULL
--DELETE FROM dpoe_stage.dbo.ctpp_subj_1 WHERE F4 = 'content'
--DELETE FROM dpoe_stage.dbo.ctpp_subj_2 WHERE F4 = 'content'
--DELETE FROM dpoe_stage.dbo.ctpp_subj_3 WHERE F4 = 'content'

----Create dim table
--IF OBJECT_ID('dim.ctpp_subject_table', 'u') IS NULL
----DROP TABLE dim.ctpp_subject_table
--CREATE TABLE dim.ctpp_subject_table
--(
--subj_tbl_id int identity (1,1) -- primary key not null
--,yr smallint not null
--,release_type_id nvarchar(2) not null
--,tbl_name nvarchar(10) not null
--,tbl_desc nvarchar(255) not null
--,universe nvarchar(255) null
--)
----CONSTRAINT ncix_subj_tbl_id UNIQUE (subj_tbl_id)) ON [PRIMARY]
--GO
----select * from dim.ctpp_subject_table

----Load table
--INSERT INTO dim.ctpp_subject_table (yr, release_type_id, tbl_name, tbl_desc, universe)
--SELECT '2016', '5Y', F3, F4, F5
--FROM dbo.ctpp_subj_1 --102

--INSERT INTO dim.ctpp_subject_table (yr, release_type_id, tbl_name, tbl_desc, universe)
--SELECT '2016', '5Y', F3, F4, F5
--FROM dbo.ctpp_subj_2 --47

--INSERT INTO dim.ctpp_subject_table (yr, release_type_id, tbl_name, tbl_desc, universe)
--SELECT '2016', '5Y', F3, F4, F5
--FROM dbo.ctpp_subj_3 --24

----SELECT * from dim.ctpp_subject_table --173


----Create line number table
--SELECT *
--FROM [dpoe_stage].[dbo].[ctpp_line]
----INNER JOIN dim.ctpp_subject_table
----ON ctpp_subject_table.tbl_name = ctpp_line.[Table ID]

----Clean up table
----Remove unneeded columns
--ALTER TABLE [dpoe_stage].[dbo].[ctpp_line]
--DROP COLUMN wave, [type], indent, [1 Year Sourcing], [3 Year Sourcing], [5 Year Sourcing], [sub range]

----Delete unneccessary rows
--DELETE FROM [dpoe_stage].[dbo].[ctpp_line] WHERE [Table ID] IS NULL
--DELETE FROM [dpoe_stage].[dbo].[ctpp_line] WHERE [Line Number] IS NULL

----Create table
--IF OBJECT_ID('dim.ctpp_line', 'u') IS NULL
----DROP TABLE dim.ctpp_line
--CREATE TABLE dim.ctpp_line
--(
--line_id int identity (1,1) --primary key not null
--,yr smallint not null
--,release_type_id nvarchar(2) not null
--,subject_table_id nvarchar(10) not null
--,line_number smallint not null
--,line_desc nvarchar(4000) not null
--)
----CONSTRAINT ncix_ctpp_line_id UNIQUE (line_id)) ON [PRIMARY]
----GO
----select * from dim.ctpp_line

----Load table
--INSERT INTO dim.ctpp_line (yr, release_type_id, subject_table_id, line_number, line_desc)
--SELECT DISTINCT '2016', '5Y', [table id], [line number], [stub]
--FROM [dpoe_stage].[dbo].[ctpp_line]
--ORDER BY [table id]
--,[line number]
----select * from dim.ctpp_line  --9842


----Create geo table
----Raw data upload
--SELECT * FROM [dpoe_stage].[dbo].[Geoids$]

----Clean up table
----Delete unneccessary rows
--DELETE FROM [dpoe_stage].[dbo].[Geoids$] WHERE F1 IS NULL
--DELETE FROM [dpoe_stage].[dbo].[Geoids$] WHERE F2 IS NULL
--DELETE FROM [dpoe_stage].[dbo].[Geoids$] WHERE F1 = '1.  "nn"  is geo-component number, as defined in the CTPP spec (see codes below).  For many summary levels (for example, C03), we do not produce components, so a "00" is always placed there.'
--DELETE FROM [dpoe_stage].[dbo].[Geoids$] WHERE F1 = '2.  The various letters in the "Format" column refer to each type of geography.  For example, for summary level C03, after the "US", the next two characters show the state and the next three show the county. The letters are the same for both residence and'
--DELETE FROM [dpoe_stage].[dbo].[Geoids$] WHERE F1 IN ('Summary Level','00','01','43','a0','g0','c0','c1','c2','h0','e0','e1','e2','Geo-Component #','Geographic Components','Explanation:','Format of Summary Levels for the CTPP 2012-2016 5-Year Special Tab')

----Remove column F5
--ALTER TABLE [dpoe_stage].[dbo].[Geoids$]
--DROP COLUMN F5;

----Rename columns
--SP_RENAME '[dpoe_stage].[dbo].[Geoids$].F1', 'summary_level', 'COLUMN'
--SP_RENAME '[dpoe_stage].[dbo].[Geoids$].F2', 'summary_level_desc', 'COLUMN'
--SP_RENAME '[dpoe_stage].[dbo].[Geoids$].F3', 'geo_id_variables', 'COLUMN'
--SP_RENAME '[dpoe_stage].[dbo].[Geoids$].F4', 'format', 'COLUMN'
----SELECT * FROM [dpoe_stage].[dbo].[Geoids$]

----Create table
--IF OBJECT_ID('dim.ctpp_geo', 'u') IS NULL
----DROP TABLE dim.ctpp_geo
--CREATE TABLE dim.ctpp_geo
--(
--geo_id int identity (1,1) --primary key not null
--,yr smallint not null
--,release_type_id nvarchar(2) not null
--,summary_level nvarchar(3) not null
--,summary_level_desc nvarchar(100) not null
--,geoid_variables nvarchar(50) null
--,geoid_format nvarchar(50) not null
--)
----CONSTRAINT ncix_ctpp_geo_id UNIQUE (geo_id)) ON [PRIMARY]
----GO
----select * from dim.ctpp_geo

----Load table
--INSERT INTO dim.ctpp_geo (yr, release_type_id, summary_level, summary_level_desc, geoid_variables, geoid_format)
--SELECT '2016', '5Y', summary_level, summary_level_desc, geo_id_variables, [format]
--FROM dbo.Geoids$
----select * from dim.ctpp_geo --39

---------------------------------------------------------------------------------------------------------------------------------------------

----Create fact table
--IF OBJECT_ID('fact.ctpp_2016', 'u') IS NULL
----DROP TABLE fact.ctpp_2016
--CREATE TABLE fact.ctpp_2016
--(
--ctpp_id int identity (1,1) --primary key not null
--,geo_id nvarchar(255) not null
--,tbl_id nvarchar(15) not null
--,line_num int not null
--,est float null
--,moe float null
--)
----CONSTRAINT ncix_ctpp_id_2016 UNIQUE (ctpp_id)) ON [PRIMARY]
----GO

----Load data
--INSERT INTO fact.ctpp_2016 (geo_id, tbl_id, line_num, est, moe)
--SELECT geo_id, table_id, line_number, estimate, moe
--FROM staging.ctpp_2012_2016
----SELECT * FROM fact.ctpp_2016
----SELECT COUNT(*) FROM fact.ctpp_2016 --247,552,783
SELECT * FROM fact.ctpp_2016
---------------------------------------------------------------------------------------------------------------------------------------------

--Queries for QA    
--SELECT * FROM fact.ctpp_2016
--WHERE geo_id = 'C6000US06115000014790686972' AND tbl_id = 'B306201'
--Order by line_num

--SELECT * FROM staging.ctpp_2016
--WHERE GEOID = '"C6000US06115000014790686972"' AND TBLID = '"B306201"'

--SELECT * FROM staging.ctpp_2012_2016
--WHERE geo_id = 'C6000US06115000014790686972' AND table_id = 'B306201'


----Create indexes

----Clustered Columnstore Index (CCIX)
----Subject Table
--USE [dpoe_stage]
--GO
--DROP INDEX [ccix_ctpp_subject_table] ON [dim].[ctpp_subject_table]
--GO
--CREATE CLUSTERED COLUMNSTORE INDEX [ccix_ctpp_subject_table] ON [dim].[ctpp_subject_table] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
--GO

----Line
--USE [dpoe_stage]
--GO
--DROP INDEX [ccix_ctpp_line] ON [dim].[ctpp_line]
--GO
--CREATE CLUSTERED COLUMNSTORE INDEX [ccix_ctpp_line] ON [dim].[ctpp_line] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
--GO

----Geo
--USE [dpoe_stage]
--GO
--DROP INDEX [ccix_ctpp_geo] ON [dim].[ctpp_geo]
--GO
--CREATE CLUSTERED COLUMNSTORE INDEX [ccix_ctpp_geo] ON [dim].[ctpp_geo] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
--GO

----Fact table
--USE [dpoe_stage]
--GO
--DROP INDEX [ccix_ctpp_2016] ON [fact].[ctpp_2016]
--GO
--CREATE CLUSTERED COLUMNSTORE INDEX [ccix_ctpp_2016] ON [fact].[ctpp_2016] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
--GO

----Unique Constraint (UNQX, no need for primary key with this)
----Subject Table
--ALTER TABLE [dim].[ctpp_subject_table] DROP CONSTRAINT [unqx_subj_tbl_id]
--GO
--ALTER TABLE [dim].[ctpp_subject_table]
--ADD CONSTRAINT unqx_subj_tbl_id UNIQUE (subj_tbl_id);   
--GO

----Line
--ALTER TABLE [dim].[ctpp_line] DROP CONSTRAINT [unqx_line_id]
--GO
--ALTER TABLE [dim].[ctpp_line]
--ADD CONSTRAINT unqx_line_id UNIQUE (line_id);   
--GO

----Geo
--ALTER TABLE [dim].[ctpp_geo] DROP CONSTRAINT [unqx_geo_id]
--GO
--ALTER TABLE [dim].[ctpp_geo]
--ADD CONSTRAINT unqx_geo_id UNIQUE (geo_id);   
--GO

----Fact table
--ALTER TABLE [fact].[ctpp_2016] DROP CONSTRAINT [unqx_ctpp_2016_id]
--GO
--ALTER TABLE [fact].[ctpp_2016]
--ADD CONSTRAINT unqx_ctpp_2016_id UNIQUE (ctpp_id);   
--GO



---------------------------------------------------------------------------------------------------------------------------------------------
----OLD
----Slower code
----SELECT '2016' as yr
----	,'5Y' as release_type_id
----	,x.geo_id
----	,x.TBLID
----	,x.line_number
----	,CAST(CASE 
----		WHEN x.estimate = '-' THEN REPLACE (x.estimate,'-',null)
----		WHEN x.estimate = '^' THEN REPLACE (x.estimate,'^',null)
----		WHEN x.estimate LIKE '%+%' THEN REPLACE (x.estimate,'+','')
----		WHEN x.estimate LIKE '%-%' THEN REPLACE (x.estimate,'-','')
----		ELSE x.estimate
----	END as float) as estimate
----	,CAST(CASE 
----		WHEN x.moe = '**' THEN REPLACE (x.moe,'**',null)
----		WHEN x.moe = '***' THEN REPLACE (x.moe,'***',null)
----		WHEN x.moe = '*****' THEN REPLACE (x.moe,'*****',null)
----		ELSE x.moe 
----	END as float) as moe
----FROM
----(
----	SELECT REPLACE(GEOID,'"','') as geo_id
----		,REPLACE(TBLID,'"','') as TBLID, [LINENO] as line_number
----		,REPLACE(REPLACE(EST,'"',''), ',', '') as estimate
----		,REPLACE(REPLACE(REPLACE([MOE],'"',''),'+/-',''),',','') as moe
----	FROM dpoe_stage.staging.ctpp_2016
----) as x
------ORDER BY x.geo_id, x.TBLID, x.line_number

----select count(*) from staging.ctpp_2012_2016