SELECT [vintage_yr]
      ,[yr]
	  ,[date_counted]
      ,[route_num]
      ,[route_name]
      ,[service_code]
      ,[service_type]
      ,[service_class]
      ,[service_mode]
      ,[trips]
      ,[trips_gross]
      ,[sum_passengers_on]
      ,[sum_fon]
      ,[sum_ron]
      ,[sum_passengers_off]
      ,[sum_foff]
      ,[sum_roff]
      ,[sum_wheelchairs]
      ,[sum_bicycles]
      ,[sum_kneels]
      ,[max_load]
      ,[max_load_p]
      ,[avg_max_load]
      ,[sum_tp_early]
      ,[sum_tp_ontime]
      ,[sum_tp_late]
      ,[ontime]
      ,[sum_revenue_miles]
      ,[sum_revenue_hours]
      ,[avg_passengers_on]
      ,[avg_passengers_off]
      ,[avg_revenue_miles]
      ,[avg_revenue_hours]
      ,[sum_passenger_miles]
      ,[avg_passenger_miles]
      ,[sum_seat_miles]
      ,[avg_pass_per_mile]
      ,[avg_pass_per_hour]
      ,[avg_seat_miles]
      ,[avg_trip_length_miles]
      ,[passenger_miles_per_seat_mile]
      ,[vehicle_speed_mph]
      ,[passenger_hours]
      ,[avg_trip_length_minutes]
      ,[passenger_miles_per_gallon_fuel]
FROM fact.passenger_counting_program as a
	INNER JOIN dim.route_num as b
	ON a.route_id = b.route_id