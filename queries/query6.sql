
WITH RECURSIVE hours AS (
    -- Generate all hours between 2023-09-25 00:00 and 2023-10-03 23:59
    SELECT datetime('2023-09-25 00:00') AS DATE_hour
    UNION ALL
    SELECT datetime(DATE_hour, '+1 hour')
    FROM hours
    WHERE DATE_hour < '2023-10-03 23:00:00' -- Stop at the last hour
),
hours_format AS (

    SELECT 
        strftime('%Y-%m-%d-%H', DATE_hour) as DATE_hour
    FROM hours as h 
),
rides AS (
    -- Aggregate rides by hour
    SELECT 
        strftime('%Y-%m-%d-%H', trip_pickup_datetime) AS DATE_hour,
        COUNT(*) AS num_rides
    FROM (
        SELECT trip_pickup_datetime FROM taxi_trips
        UNION ALL
        SELECT trip_pickup_datetime FROM uber_trips
    )
    GROUP BY DATE_hour
)
SELECT 
    h.DATE_hour,
    COALESCE(r.num_rides, 0) AS num_rides,
    COALESCE(w.HourlyPrecipitation, 0.0) AS hourly_precipitation,
    COALESCE(w.HourlyWindSpeed, 0.0) AS hourly_wind_speed
FROM 
    hours_format h
LEFT JOIN 
    rides r ON h.DATE_hour = r.DATE_hour
LEFT JOIN 
    hourly_weather w ON h.DATE_hour = w.DATE_hour
ORDER BY 
    h.DATE_hour;
