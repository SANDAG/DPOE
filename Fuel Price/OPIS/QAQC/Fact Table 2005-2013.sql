/****** Script for SelectTopNRows command from SSMS  ******/
SELECT region, start_date, product, station_count, retail_avg
  FROM [dpoe_stage].[staging].[opis_fuel_price]
  where start_date < '2013-12-01'