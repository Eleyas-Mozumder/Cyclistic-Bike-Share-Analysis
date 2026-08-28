-- ============================================================
-- CYCLISTIC BIKE-SHARE USER BEHAVIOR ANALYSIS
-- ============================================================
-- Data Period: January - December 2025
-- Tool: MySQL
-- Purpose: Analyze differences between annual members
--          and casual riders and identify usage patterns.
-- ============================================================


-- ============================================================
-- 1. DATA PREPARATION
-- ============================================================

USE cyclistic;

-- Check total number of records in the raw dataset
SELECT COUNT(*) AS total_rows
FROM cyclistic_trips_raw;

-- Review the structure of the raw dataset
DESCRIBE cyclistic_trips_raw;


-- ============================================================
-- 2. DATA VALIDATION & CLEANING
-- ============================================================

-- Check rider categories
SELECT
    member_casual,
    COUNT(*) AS total_rides
FROM cyclistic_trips_raw
GROUP BY member_casual;

-- Check available bike types
SELECT
    rideable_type,
    COUNT(*) AS total_rides
FROM cyclistic_trips_raw
GROUP BY rideable_type;

-- Check important fields for missing values
SELECT
    SUM(ride_id IS NULL OR ride_id = '') AS missing_ride_id,
    SUM(rideable_type IS NULL OR rideable_type = '') AS missing_rideable_type,
    SUM(started_at IS NULL OR started_at = '') AS missing_started_at,
    SUM(ended_at IS NULL OR ended_at = '') AS missing_ended_at,
    SUM(start_station_name IS NULL OR start_station_name = '') 
        AS missing_start_station,
    SUM(end_station_name IS NULL OR end_station_name = '') 
        AS missing_end_station,
    SUM(member_casual IS NULL OR member_casual = '') 
        AS missing_member_casual
FROM cyclistic_trips_raw;

-- Identify records where the end time is not after the start time
SELECT
    COUNT(*) AS invalid_duration_rows
FROM cyclistic_trips_raw
WHERE STR_TO_DATE(
          started_at,
          '%Y-%m-%d %H:%i:%s.%f'
      )
      >=
      STR_TO_DATE(
          ended_at,
          '%Y-%m-%d %H:%i:%s.%f'
      );

-- Check minimum and maximum ride duration
SELECT
    MIN(
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
        )
    ) AS min_seconds,

    MAX(
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
        )
    ) AS max_seconds

FROM cyclistic_trips_raw;

-- Identify extremely short and unusually long rides
SELECT
    SUM(
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
        ) < 60
    ) AS under_1_minute,

    SUM(
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
        ) > 86400
    ) AS over_24_hours

FROM cyclistic_trips_raw;


-- ============================================================
-- 3. DATA TRANSFORMATION
-- ============================================================

-- Recreate the cleaned analytical table
DROP TABLE IF EXISTS cyclistic_trips_clean;

CREATE TABLE cyclistic_trips_clean AS

SELECT
    ride_id,
    rideable_type,

    -- Convert timestamps from text to DATETIME
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

    -- Calculate ride duration in minutes
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

    -- Create analytical date/time fields
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
          STR_TO_DATE(
              started_at,
              '%Y-%m-%d %H:%i:%s.%f'
          ),
          STR_TO_DATE(
              ended_at,
              '%Y-%m-%d %H:%i:%s.%f'
          )
      ) >= 60

  AND TIMESTAMPDIFF(
          SECOND,
          STR_TO_DATE(
              started_at,
              '%Y-%m-%d %H:%i:%s.%f'
          ),
          STR_TO_DATE(
              ended_at,
              '%Y-%m-%d %H:%i:%s.%f'
          )
      ) <= 86400;


-- ============================================================
-- 4. DATA QUALITY CHECKS
-- ============================================================

-- Verify number of records after cleaning
SELECT
    COUNT(*) AS clean_rows
FROM cyclistic_trips_clean;

-- Verify that invalid ride durations were removed
SELECT
    SUM(ride_length_minutes < 1) AS under_1_minute,
    SUM(ride_length_minutes > 1440) AS over_24_hours
FROM cyclistic_trips_clean;


-- ============================================================
-- 5. MEMBER VS. CASUAL ANALYSIS
-- ============================================================
-- Business Question:
-- How does annual riding behavior differ between
-- members and casual riders?
-- ============================================================

SELECT
    member_casual,
    COUNT(*) AS total_rides,
    ROUND(
        AVG(ride_length_minutes),
        2
    ) AS avg_ride_minutes,
    ROUND(
        MIN(ride_length_minutes),
        2
    ) AS min_ride_minutes,
    ROUND(
        MAX(ride_length_minutes),
        2
    ) AS max_ride_minutes

FROM cyclistic_trips_clean

GROUP BY member_casual;


-- ============================================================
-- 6. MONTHLY ANALYSIS
-- ============================================================
-- Business Question:
-- Are casual riders more active during particular
-- months or seasons?
-- ============================================================

SELECT
    member_casual,
    month,
    COUNT(*) AS total_rides,
    ROUND(
        AVG(ride_length_minutes),
        2
    ) AS avg_ride_minutes

FROM cyclistic_trips_clean

GROUP BY
    member_casual,
    month

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


-- ============================================================
-- 7. WEEKDAY ANALYSIS
-- ============================================================
-- Business Question:
-- Which days of the week are most popular for
-- members and casual riders?
-- ============================================================

SELECT
    member_casual,
    weekday,
    COUNT(*) AS total_rides,
    ROUND(
        AVG(ride_length_minutes),
        2
    ) AS avg_ride_minutes

FROM cyclistic_trips_clean

GROUP BY
    member_casual,
    weekday

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


-- ============================================================
-- 8. HOURLY ANALYSIS
-- ============================================================
-- Business Question:
-- When during the day are bikes used most frequently?
-- ============================================================

SELECT
    member_casual,
    hour,
    COUNT(*) AS total_rides,
    ROUND(
        AVG(ride_length_minutes),
        2
    ) AS avg_ride_minutes

FROM cyclistic_trips_clean

GROUP BY
    member_casual,
    hour

ORDER BY
    member_casual,
    hour;


-- ============================================================
-- 9. BIKE TYPE ANALYSIS
-- ============================================================
-- Business Question:
-- Which bike types are most popular among each
-- rider group?
-- ============================================================

SELECT
    member_casual,
    rideable_type,
    COUNT(*) AS total_rides,
    ROUND(
        AVG(ride_length_minutes),
        2
    ) AS avg_ride_minutes

FROM cyclistic_trips_clean

GROUP BY
    member_casual,
    rideable_type

ORDER BY
    member_casual,
    total_rides DESC;


-- ============================================================
-- END OF ANALYSIS
-- ============================================================
