SELECT region, dim.opis_date.date_code, product, station_count, retail_avg, wholesale_avg, tax_avg, freight_avg, margin_avg, net_avg
FROM fact.opis_fuel_price
inner join dim.opis_date
ON opis_date.date_id = opis_fuel_price.date_id