## PART 1: ROW DATA

use cyclistic;

-- Check the raw master table

SELECT COUNT(*) AS total_rows
FROM cyclistic_trips_raw;


-- Check the structure
DESCRIBE cyclistic_trips_raw;



## PART 2: DATA VALIDATION


--  check the membership categories:
SELECT
    member_casual,
    COUNT(*) AS rides
FROM cyclistic_trips_raw
GROUP BY member_casual;


-- check the bike types

SELECT rideable_type, 
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


## PART 3: CHECK RIDE DURATIONS

-- Check invalid rides
SELECT COUNT(*) AS invalid_duration_rows
FROM cyclistic_trips_raw
WHERE STR_TO_DATE(started_at, '%Y-%m-%d %H:%i:%s.%f')
    >= STR_TO_DATE(ended_at, '%Y-%m-%d %H:%i:%s.%f');


-- Find minimum and maximum duration

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


## PART 4: CREATE CLEAN DATA

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


-- Verify cleaned data

SELECT COUNT(*) AS clean_rows
FROM cyclistic_trips_clean;

-- Verify no invalid durations remain

SELECT
    SUM(ride_length_minutes < 1) AS under_1_minute,
    SUM(ride_length_minutes > 1440) AS over_24_hours
FROM cyclistic_trips_clean;


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

## PART 5: MAIN ANALYSIS

-- How does annual riding behavior differ between Cyclistic members and casual riders?


SELECT
    member_casual,
    COUNT(*) AS total_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes,
    ROUND(MIN(ride_length_minutes), 2) AS min_ride_minutes,
    ROUND(MAX(ride_length_minutes), 2) AS max_ride_minutes
FROM cyclistic_trips_clean
GROUP BY member_casual;

-- Casual riders have much longer rides.
-- Member average: 12.13 minutes
-- Casual average: 19.88 minutes
-- Casual riders use the service less frequently, but their individual rides tend to be substantially longer. That suggests casual riders may represent an opportunity for membership conversion.


## PART 6: WEEKDAY ANALYSIS

-- which days casual and member riders use the bikes most.

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

-- Members tend to ride more frequently during weekdays, while casual riders are much more active on weekends and take longer rides.

-- Casual riders may be more likely to consider membership if marketing targets their weekend riding habits. 
##  For example, Cyclistic could test:
-- Weekend membership promotions
-- "Ride more, save more" membership campaigns
-- Offers shown after several weekend rides
-- Membership messaging on Friday–Sunday
-- Campaigns emphasizing the benefits of unlimited/regular riding



## PART 7: HOURLY ANALYSIS

SELECT
    member_casual,
    hour,
    COUNT(*) AS total_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM cyclistic_trips_clean
GROUP BY member_casual, hour
ORDER BY member_casual, hour;

-- Members appear to use Cyclistic more frequently during weekday/commuting-oriented periods, while casual riders show stronger leisure-oriented usage, particularly later in the day and on weekends.


## PART 8: MONTHLY ANALYSIS
-- Are casual riders more active during particular months/seasons than members?

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

-- Casual riders show a much stronger seasonal pattern, with their usage increasing dramatically during spring and summer.
-- This suggests casual riders may be using Cyclistic more for leisure/recreational trips, whereas members appear to use the service more regularly throughout the year.


## PART 9: BIKE TYPE ANALYSIS

SELECT
    member_casual,
    rideable_type,
    COUNT(*) AS total_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM cyclistic_trips_clean
GROUP BY member_casual, rideable_type
ORDER BY member_casual, total_rides DESC;


