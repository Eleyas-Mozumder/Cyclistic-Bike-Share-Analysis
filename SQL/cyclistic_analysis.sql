-- =====================================================
-- CYCLISTIC BIKE-SHARE USER BEHAVIOR ANALYSIS
-- Data period: January–December 2025
-- Tool: MySQL
-- =====================================================


-- =====================================================
-- 1. DATA PREPARATION
-- =====================================================

USE cyclistic;

-- Check the raw master table
SELECT COUNT(*) AS total_rows
FROM cyclistic_trips_raw;

-- Check the structure of the raw table
DESCRIBE cyclistic_trips_raw;


-- =====================================================
-- 2. DATA CLEANING
-- =====================================================

-- Check membership categories
SELECT
    member_casual,
    COUNT(*) AS rides
FROM cyclistic_trips_raw
GROUP BY member_casual;

-- Check bike types
SELECT
    rideable_type,
    COUNT(*) AS rides
FROM cyclistic_trips_raw
GROUP BY rideable_type;

-- Check missing values
SELECT
    SUM(ride_id IS NULL OR ride_id = '') AS missing_ride_id,
    SUM(rideable_type IS NULL OR rideable_type = '') AS missing_rideable_type,
    SUM(started_at IS NULL OR started_at = '') AS missing_started_at,
    SUM(ended_at IS NULL OR ended_at = '') AS missing_ended_at,
    SUM(start_station_name IS NULL OR start_station_name = '') AS missing_start_station,
    SUM(end_station_name IS NULL OR end_station_name = '') AS missing_end_station,
    SUM(member_casual IS NULL OR member_casual = '') AS missing_member_casual
FROM cyclistic_trips_raw;

-- Check invalid ride durations
SELECT COUNT(*) AS invalid_duration_rows
FROM cyclistic_trips_raw
WHERE STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s.%f')
    >= STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s.%f');

-- Find minimum and maximum ride duration
SELECT
    MIN(
        TIMESTAMPDIFF(
            SECOND,
            STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s.%f'),
            STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s.%f')
        )
    ) AS min_seconds,

    MAX(
        TIMESTAMPDIFF(
            SECOND,
            STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s.%f'),
            STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s.%f')
        )
    ) AS max_seconds
FROM cyclistic_trips_raw;

-- Check rides under 1 minute and over 24 hours
SELECT
    SUM(
        TIMESTAMPDIFF(
            SECOND,
            STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s.%f'),
            STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s.%f')
        ) < 60
    ) AS under_1_minute,

    SUM(
        TIMESTAMPDIFF(
            SECOND,
            STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s.%f'),
            STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s.%f')
        ) > 86400
    ) AS over_24_hours
FROM cyclistic_trips_raw;


-- =====================================================
-- 3. DATA TRANSFORMATION
-- =====================================================

DROP TABLE IF EXISTS cyclistic_trips_clean;

CREATE TABLE cyclistic_trips_clean AS
SELECT
    ride_id,
    rideable_type,

    STR_TO_DATE(
        started_at,
        '%Y-%m-%d %H:%i:%s.%f'
    ) AS started_at,

    STR_TO_DATE(
        ended_at,
        '%Y-%m-%d %H:%i:%s.%f'
    ) AS ended_at,

    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,

    start_lat,
    start_lng,
    end_lat,
    end_lng,

    member_casual,

    -- Ride duration in minutes
    TIMESTAMPDIFF(
        SECOND,
        STR_TO_DATE(
            started_at,
            '%Y-%m-%d %H:%i:%s.%f'
        ),
        STR_TO_DATE(
            ended_at,
            '%Y-%m-%d %H:%i:%s.%f'
        )
    ) / 60.0 AS ride_length_minutes,

    -- Date and time dimensions
    DATE(
        STR_TO_DATE(
            started_at,
            '%Y-%m-%d %H:%i:%s.%f'
        )
    ) AS ride_date,

    MONTHNAME(
        STR_TO_DATE(
            started_at,
            '%Y-%m-%d %H:%i:%s.%f'
        )
    ) AS month,

    DAYNAME(
        STR_TO_DATE(
            started_at,
            '%Y-%m-%d %H:%i:%s.%f'
        )
    ) AS weekday,

    HOUR(
        STR_TO_DATE(
            started_at,
            '%Y-%m-%d %H:%i:%s.%f'
        )
    ) AS hour

FROM cyclistic_trips_raw

-- Keep rides between 1 minute and 24 hours
WHERE TIMESTAMPDIFF(
        SECOND,
        STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s.%f'),
        STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s.%f')
      ) >= 60

  AND TIMESTAMPDIFF(
        SECOND,
        STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s.%f'),
        STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s.%f')
      ) <= 86400;


-- Verify cleaned data
SELECT COUNT(*) AS clean_rows
FROM cyclistic_trips_clean;

-- Verify no invalid durations remain
SELECT
    SUM(ride_length_minutes < 1) AS under_1_minute,
    SUM(ride_length_minutes > 1440) AS over_24_hours
FROM cyclistic_trips_clean;


-- =====================================================
-- 4. MEMBER VS. CASUAL ANALYSIS
-- =====================================================

-- Compare overall riding behavior
SELECT
    member_casual,
    COUNT(*) AS total_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes,
    ROUND(MIN(ride_length_minutes), 2) AS min_ride_minutes,
    ROUND(MAX(ride_length_minutes), 2) AS max_ride_minutes
FROM cyclistic_trips_clean
GROUP BY member_casual;


-- =====================================================
-- 5. MONTHLY ANALYSIS
-- =====================================================

-- Compare riding patterns by month
SELECT
    member_casual,
    month,
    COUNT(*) AS total_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM cyclistic_trips_clean
GROUP BY member_casual, month
ORDER BY
    member_casual,
    FIELD(
        month,
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
    );


-- =====================================================
-- 6. WEEKDAY ANALYSIS
-- =====================================================

-- Compare riding patterns by day of week
SELECT
    member_casual,
    weekday,
    COUNT(*) AS total_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM cyclistic_trips_clean
GROUP BY member_casual, weekday
ORDER BY
    member_casual,
    FIELD(
        weekday,
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
    );


-- =====================================================
-- 7. HOURLY ANALYSIS
-- =====================================================

-- Compare riding patterns by hour
SELECT
    member_casual,
    hour,
    COUNT(*) AS total_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM cyclistic_trips_clean
GROUP BY member_casual, hour
ORDER BY member_casual, hour;


-- =====================================================
-- 8. BIKE TYPE ANALYSIS
-- =====================================================

-- Compare bike type usage by rider type
SELECT
    member_casual,
    rideable_type,
    COUNT(*) AS total_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM cyclistic_trips_clean
GROUP BY member_casual, rideable_type
ORDER BY member_casual, total_rides DESC;

-- ====================================================
