SELECT region, start_date, product, retail_avg, wholesale_avg, tax_avg, freight_avg, margin_avg, retail_avg
  FROM [dpoe_stage].[staging].[opis_fuel_price]
  where start_date > '2017-12-01'