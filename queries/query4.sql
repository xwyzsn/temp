

WITH all_trips AS (
    SELECT 
        strftime('%Y-%m-%d', trip_pickup_datetime) AS trip_date,
        trip_miles AS trip_distance
    FROM 
        taxi_trips
    WHERE 
        strftime('%Y', trip_pickup_datetime) = '2023'

    UNION ALL

    SELECT 
        strftime('%Y-%m-%d', trip_pickup_datetime) AS trip_date,
        trip_distance AS trip_distance
    FROM 
        uber_trips
    WHERE 
        strftime('%Y', trip_pickup_datetime) = '2023'
),
daily_rides AS (
    SELECT 
        trip_date,
        COUNT(*) AS total_rides,
        AVG(trip_distance) AS avg_trip_distance
    FROM 
        all_trips
    GROUP BY 
        trip_date
),
top_days AS (
    SELECT 
        trip_date,
        total_rides,
        avg_trip_distance
    FROM 
        daily_rides
    ORDER BY 
        total_rides DESC
    LIMIT 10
)
SELECT 
    t.trip_date,
    t.total_rides,
    t.avg_trip_distance,
    d.DailyPrecipitation AS avg_daily_precipitation,
    d.DailyAverageWindSpeed AS avg_daily_wind_speed
FROM 
    top_days t
LEFT JOIN 
    daily_weather d
ON 
    t.trip_date = d.DATE_day
ORDER BY 
    t.total_rides DESC;

