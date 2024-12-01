
WITH snowiest_days AS (
    SELECT 
        DATE_day AS snow_date,
        DailySnowfall
    FROM 
        daily_weather
    WHERE 
        DATE_day BETWEEN '2020-01-01' AND '2024-08-31'
        AND DailySnowfall IS NOT NULL
    ORDER BY 
        DailySnowfall DESC
    LIMIT 10
),
all_trips AS (
    SELECT 
        strftime('%Y-%m-%d', trip_pickup_datetime) AS trip_date
    FROM 
        taxi_trips
    WHERE 
        strftime('%Y-%m-%d', trip_pickup_datetime) BETWEEN '2020-01-01' AND '2024-08-31'

    UNION ALL

    SELECT 
        strftime('%Y-%m-%d', trip_pickup_datetime) AS trip_date
    FROM 
        uber_trips
    WHERE 
        strftime('%Y-%m-%d', trip_pickup_datetime) BETWEEN '2020-01-01' AND '2024-08-31'
),
snow_day_rides AS (
    SELECT 
        s.snow_date,
        s.DailySnowfall,
        COUNT(a.trip_date) AS total_rides
    FROM 
        snowiest_days s
    LEFT JOIN 
        all_trips a
    ON 
        s.snow_date = a.trip_date
    GROUP BY 
        s.snow_date, s.DailySnowfall
    ORDER BY 
        s.DailySnowfall DESC
)
SELECT 
    snow_date,
    DailySnowfall,
    total_rides
FROM 
    snow_day_rides
ORDER BY 
    DailySnowfall DESC;
