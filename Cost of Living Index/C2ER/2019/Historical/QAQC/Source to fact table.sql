SELECT yr, qtr, urban_area_name, state_code, cbsa_code, city_code, state_name, metro_micro_name, item, indx
FROM fact.coli
INNER JOIN dim.coli_geo 
ON coli_geo.coli_geo_id = coli.geo_id
