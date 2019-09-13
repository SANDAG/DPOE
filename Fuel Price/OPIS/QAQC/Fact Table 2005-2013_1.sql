SELECT region, product, dim.opis_date.date_code as start_date, station_count, retail_avg
FROM fact.opis_fuel_price
inner join dim.opis_date
ON opis_date.date_id = opis_fuel_price.date_id
  where date_code < '2014-01-01'
