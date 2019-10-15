----CTPP 2006-2010 ETL

----Raw data upload
----SELECT TOP 100* FROM [dpoe_stage].[staging].[ctpp_2010]

----Create nonclustered index
--CREATE NONCLUSTERED INDEX ix_staging_ctpp_2010_est
--ON dpoe_stage.staging.ctpp_2010 (est)

--CREATE NONCLUSTERED INDEX ix_staging_ctpp_2010_se
--ON dpoe_stage.staging.ctpp_2010 (se)

----------------------------------------------------------------------------------------------------------------------------------------------------------

----Load dim tables

----Subject Table
----Clean up tables, remove empty columns
--ALTER TABLE dpoe_stage.dbo.ctpp_2010_subj1
--DROP COLUMN F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52,F53,F54,F55,F56
----SELECT * FROM dbo.ctpp_2010_subj1

--ALTER TABLE dpoe_stage.dbo.ctpp_2010_subj2
--DROP COLUMN F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52,F53,F54,F55,F56,F57,F58,F59,F60,F61,F62,F63,F64,F65
----SELECT * FROM dbo.ctpp_2010_subj2

--ALTER TABLE dpoe_stage.dbo.ctpp_2010_subj3
--DROP COLUMN F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41
----SELECT * FROM dbo.ctpp_2010_subj3

----Delete unneccessary rows
--DELETE FROM dpoe_stage.dbo.ctpp_2010_subj1 WHERE [Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2] IS NULL
--DELETE FROM dpoe_stage.dbo.ctpp_2010_subj2 WHERE [Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2] IS NULL
--DELETE FROM dpoe_stage.dbo.ctpp_2010_subj2 WHERE [Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2] = 'Univ #'
--DELETE FROM dpoe_stage.dbo.ctpp_2010_subj3 WHERE [Census Transportation Planning Products (CTPP) 5-Year ACS 2006-2] IS NULL

----Load dim table
--INSERT INTO dim.ctpp_subject_table (yr, release_type_id, tbl_name, tbl_desc, universe)
--SELECT '2010', '5Y', F9, F10, F11
--FROM dbo.ctpp_2010_subj1 --188

--INSERT INTO dim.ctpp_subject_table (yr, release_type_id, tbl_name, tbl_desc, universe)
--SELECT '2010', '5Y', F9, F10, F11
--FROM dbo.ctpp_2010_subj2 --116

--INSERT INTO dim.ctpp_subject_table (yr, release_type_id, tbl_name, tbl_desc, universe)
--SELECT '2010', '5Y', F9, F10, F11
--FROM dbo.ctpp_2010_subj3 --40

----SELECT * from dim.ctpp_subject_table --517



----Line
----Create line number table
--IF OBJECT_ID('dbo.ctpp_2010_line', 'u') IS NULL
----DROP TABLE dbo.ctpp_2010_line
--CREATE TABLE dbo.ctpp_2010_line
--(
--tblid nvarchar(15) not null
--,[lineno] int not null
--,lindent int not null
--,ldesc nvarchar(4000) 
--)
----select * from dbo.ctpp_2010_line

----Load table
--BULK INSERT dbo.ctpp_2010_line
--FROM '\\sandag.org\datasolutions\DPOE\CTPP\Documentation\2006-2010\acs_2006thru2010_ctpp_table_shell.txt' 
--WITH (
--FIRSTROW = 2
--,FIELDTERMINATOR = '|'
--)

----Clean up table
----Remove unneeded columns
--ALTER TABLE [dpoe_stage].[dbo].[ctpp_2010_line]
--DROP COLUMN lindent

----Load dim table
--INSERT INTO dim.ctpp_line (yr, release_type_id, subject_table_id, line_number, line_desc)
--SELECT DISTINCT '2010', '5Y', [tblid], [lineno], [ldesc]
--FROM [dpoe_stage].[dbo].[ctpp_2010_line]
--ORDER BY [tblid]
--,[lineno]
----select * from dim.ctpp_line  --26,980



----Geo
----Clean up table
----Drop unneccessary columns
--ALTER TABLE [dpoe_stage].[dbo].[ctpp_2010_geoids]
--DROP COLUMN F5

----Delete unneccessary rows
--DELETE FROM [dpoe_stage].[dbo].[ctpp_2010_geoids] WHERE [Format of Summary Levels for the CTPP 2006-2010 5-Year Special T] IS NULL
--DELETE FROM [dpoe_stage].[dbo].[ctpp_2010_geoids] WHERE F4 IS NULL
--DELETE FROM [dpoe_stage].[dbo].[ctpp_2010_geoids] WHERE F4 = 'format'

----Load table
--INSERT INTO dim.ctpp_geo (yr, release_type_id, summary_level, summary_level_desc, geoid_variables, geoid_format)
--SELECT '2010', '5Y', [Format of Summary Levels for the CTPP 2006-2010 5-Year Special T], F2, F3, F4
--FROM [dbo].[ctpp_2010_geoids]
----select * from dim.ctpp_geo --79

---------------------------------------------------------------------------------------------------------------------------------------------

----Create fact table
--IF OBJECT_ID('fact.ctpp_2010', 'u') IS NULL
----DROP TABLE fact.ctpp_2010
--CREATE TABLE fact.ctpp_2010
--(
--ctpp_id int identity (1,1)
--,geo_id nvarchar(255) not null
--,tbl_id nvarchar(15) not null
--,line_num int not null
--,est float null
--,se float null
--)

----Load fact table
----Did not run this code on my local computer... used the SQL Server Agent Jobs window called "CTPP 2010" to execute the job on the server to not slow down my computer while I wait for it to load
--INSERT INTO fact.ctpp_2010 WITH (TABLOCK) (geo_id, tbl_id, line_num, est, se) 
--SELECT REPLACE(GEOID,'"','') as geo_id
--	,REPLACE(REPLACE(TBLID,'"',''), 'CA_2006thru2010_','') as TBLID
--	,[LINENO]
--	,CASE
--		WHEN est LIKE '%N%' THEN REPLACE(est,'N',null)
--		WHEN est = '"-"' THEN REPLACE(est,'"-"',null)
--		WHEN est LIKE '%-%' THEN REPLACE(REPLACE(REPLACE(est,'-',''),'"',''),',','')
--		ELSE REPLACE(REPLACE(REPLACE(est,'"',''), ',', ''), '+','')
--	END as est
--	,CASE 
--		WHEN se LIKE '%**%' THEN REPLACE(se,'**',null)
--		WHEN se LIKE '%***%' THEN REPLACE(se,'***',null)
--		WHEN se LIKE '%*****%' THEN REPLACE(se,'*****',null)
--		WHEN se LIKE '%N%' THEN REPLACE(se,'N',null)
--		WHEN se LIKE '%NA%' THEN REPLACE(se,'NA',null)
--		ELSE REPLACE(REPLACE(REPLACE(se,'"',''),'+/-',''),',','')
--	END as se
--FROM dpoe_stage.staging.ctpp_2010
----SELECT * FROM fact.ctpp_2010



-------------------------------------------------------------------------------------------------------------------------------------------

----Create indexes

----Clustered Columnstore Index (CCIX)
----Fact table
--USE [dpoe_stage]
--GO
--DROP INDEX [ccix_ctpp_2010] ON [fact].[ctpp_2010]
--GO
--CREATE CLUSTERED COLUMNSTORE INDEX [ccix_ctpp_2010] ON [fact].[ctpp_2010] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
--GO

----Unique Constraint (UNQX, no need for primary key with this)
----Fact table
--ALTER TABLE [fact].[ctpp_2010] 
--DROP CONSTRAINT [unqx_ctpp_2010_id]
--GO
--ALTER TABLE [fact].[ctpp_2010]
--ADD CONSTRAINT unqx_ctpp_2010_id UNIQUE (ctpp_id);
--GO


-------------------------------------------------------------------------------------------------------------------------------------------
----Troubleshooting
----SELECT DISTINCT CASE
----		WHEN est LIKE '%N%' THEN REPLACE (est,'N',null)
----		WHEN est = '"-"' THEN REPLACE (est,'"-"',null)
----		WHEN est LIKE '%-%' THEN REPLACE (est,'-', '')
----		ELSE REPLACE(REPLACE(REPLACE(est,'"',''), ',', ''), '+','')
----	END as est
----INTO #temp_2010
----FROM dpoe_stage.staging.ctpp_2010

----SELECT *
----FROM #temp_2010_2
----where est LIKE '%"%'


----SELECT DISTINCT CASE
----		WHEN est LIKE '%N%' THEN REPLACE (est,'N',null)
----		WHEN est = '"-"' THEN REPLACE (est,'"-"',null)
----		WHEN est LIKE '%-%' THEN REPLACE (est,'-', '')
----		ELSE REPLACE(REPLACE(REPLACE(est,'"',''), ',', ''), '+','')
----	END as est
----FROM dpoe_stage.staging.ctpp_2010
----WHERE try_cast(est as float) is null

----SELECT DISTINCT CASE
----		WHEN est LIKE '%N%' THEN REPLACE(est,'N',null)
----		WHEN est = '"-"' THEN REPLACE(est,'"-"',null)
----		WHEN est LIKE '%-%' THEN REPLACE(REPLACE(est,'-',''),'"','')
----		ELSE REPLACE(REPLACE(REPLACE(est,'"',''), ',', ''), '+','')
----	END as est
----INTO #temp_2010_2
----FROM dpoe_stage.staging.ctpp_2010

SELECT * FROM dpoe_stage.staging.ctpp_2010

--Total # of records: 1094036414 (1.09 bilion)
--SELECT count(*) FROM dpoe_stage.staging.ctpp_2010 

--SELECT count(*) FROM dpoe_stage.staging.ctpp_2010 
--1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
-- 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35


--with s as(
--SELECT * FROM dpoe_stage.staging.ctpp_2010
--)

--select [LINENO], count(*) as total from s
--GROUP BY [LINENO]
--ORDER BY total



-------------------------------------------------------------------------------------------------------------------------
----Old
----SELECT '2010' as yr
----	,'5Y' as release_type_id
----	,x.geo_id
----	,x.TBLID
----	,x.line_number
----	,CASE 
----		WHEN x.estimate = '-' THEN REPLACE (x.estimate,'-',null)
----		WHEN x.estimate = 'N' THEN REPLACE (x.estimate,'N',null)
----		WHEN x.estimate LIKE '%+%' THEN REPLACE (x.estimate,'+','')
----		WHEN x.estimate LIKE '%-%' THEN REPLACE (x.estimate,'-','')
----		ELSE x.estimate
----		END as estimate
----	,CASE 
----		WHEN x.se = '**' THEN REPLACE (x.se,'**',null)
----		WHEN x.se = '***' THEN REPLACE (x.se,'***',null)
----		WHEN x.se = '*****' THEN REPLACE (x.se,'*****',null)
----		WHEN x.se = 'N' THEN REPLACE (x.se,'N',null)
----		WHEN x.se = 'NA' THEN REPLACE (x.se,'NA',null)
----		ELSE x.se 
----	END as se
----FROM
----(
----SELECT REPLACE(REPLACE(GEOID,LEFT(GEOID,8),''), '"', '') as geo_id
----	,REPLACE(REPLACE(TBLID,'"',''), 'CA_2006thru2010_','') as TBLID
----	,[LINENO] as line_number
----	,REPLACE(REPLACE(EST,'"',''),',','') as estimate
----	,REPLACE(REPLACE([SE],'"',''),',','') as se
----FROM dpoe_stage.staging.ctpp_2010
----) as x
----ORDER BY x.TBLID, x.line_number
------SELECT * FROM staging.ctpp_2006_2010 order by ctpp_id

----Has old tablock and old replace for -
------Load fact table
------Remove quotes and commas from the data
----INSERT INTO fact.ctpp_2010 (geo_id, tbl_id, line_num, est, se)
------Optimized code
----SELECT REPLACE(GEOID,'"','') as geo_id
----	,REPLACE(REPLACE(TBLID,'"',''), 'CA_2006thru2010_','') as TBLID
----	,[LINENO]
----	,CASE
----		WHEN est LIKE '%N%' THEN REPLACE (est,'N',null)
----		ELSE REPLACE(REPLACE(REPLACE(REPLACE(est,'"',''), ',', ''), '+',''),'-','')
----	END as est
----	,CASE 
----		WHEN se LIKE '%**%' THEN REPLACE (se,'**',null)
----		WHEN se LIKE '%***%' THEN REPLACE (se,'***',null)
----		WHEN se LIKE '%*****%' THEN REPLACE (se,'*****',null)
----		WHEN se LIKE '%N%' THEN REPLACE (se,'N',null)
----		WHEN se LIKE '%NA%' THEN REPLACE (se,'NA',null)
----		ELSE REPLACE(REPLACE(REPLACE(se,'"',''),'+/-',''),',','')
----	END as se
----FROM dpoe_stage.staging.ctpp_2010 (TABLOCK)