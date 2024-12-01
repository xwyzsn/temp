
WITH combined_trips AS (
    SELECT 
        trip_miles AS trip_distance,
        trip_pickup_datetime
    FROM 
        taxi_trips
    WHERE 
        strftime('%Y-%m', trip_pickup_datetime) = '2024-01'
    
    UNION ALL
    
    SELECT 
        trip_distance AS trip_distance,
        trip_pickup_datetime
    FROM 
        uber_trips
    WHERE 
        strftime('%Y-%m', trip_pickup_datetime) = '2024-01'
),
sorted_trips AS (
    SELECT 
        trip_distance,
        ROW_NUMBER() OVER (ORDER BY trip_distance) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM 
        combined_trips
),
percentile_row AS (
    SELECT 
        trip_distance
    FROM 
        sorted_trips
    WHERE 
        row_num = CAST(0.95 * total_rows AS INTEGER)
)
SELECT 
    trip_distance AS percentile_95
FROM 
    percentile_row;
