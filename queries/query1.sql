
SELECT 
    strftime('%H', trip_pickup_datetime) AS pickup_hour, 
    COUNT(*) AS trip_count
FROM 
    taxi_trips
GROUP BY 
    pickup_hour
ORDER BY 
    trip_count DESC

