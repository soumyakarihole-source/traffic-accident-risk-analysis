create database Traffic_Project;
use Traffic_Project;
drop table traffic_dataset;

CREATE TABLE traffic_dataset (
location_id VARCHAR(50),
timestamp VARCHAR(50),
state VARCHAR(50),
road_type VARCHAR(50),
lane_count VARCHAR(20),
speed_limit_kmph VARCHAR(20),
has_signal VARCHAR(20),
enforcement_level VARCHAR(50),
blackspot_score VARCHAR(20),
latitude VARCHAR(30),
longitude VARCHAR(30),
season VARCHAR(20),
day_of_week VARCHAR(10),
hour_of_day VARCHAR(10),
lighting VARCHAR(30),
weather VARCHAR(30),
is_peak VARCHAR(10),
vehicle_count_per_hr VARCHAR(20),
avg_speed_kmph VARCHAR(20),
peak VARCHAR(10),
traffic_data_quality_flag VARCHAR(30),
signal_status VARCHAR(30),
green_duration_s VARCHAR(20),
red_duration_s VARCHAR(20),
yellow_duration_s VARCHAR(20),
cycle_time_s VARCHAR(20),
violations_count VARCHAR(20),
signal_data_quality_flag VARCHAR(30),
accident_occurred VARCHAR(10),
severity VARCHAR(20),
vehicles_involved VARCHAR(20),
cause VARCHAR(50),
veh_count_at_accident VARCHAR(20)
);

desc traffic_dataset;
SELECT * FROM traffic_dataset LIMIT 20;
SELECT count(*) FROM traffic_dataset;

/* ===== Data Quality / Missing Value Analysis    ===== */
SELECT
COUNT(*) total_rows,
SUM(lane_count='' OR lane_count IS NULL) blank_lane,
SUM(speed_limit_kmph='' OR speed_limit_kmph IS NULL) blank_speed,
SUM(vehicle_count_per_hr='' OR vehicle_count_per_hr IS NULL) blank_vehicle,
SUM(avg_speed_kmph='' OR avg_speed_kmph IS NULL) blank_avg_speed
FROM traffic_dataset;


/* ===== Categorical EDA    ===== */
SELECT road_type, COUNT(*) 
FROM traffic_dataset
GROUP BY road_type
ORDER BY COUNT(*) DESC;

SELECT weather, COUNT(*) 
FROM traffic_dataset
GROUP BY weather;

SELECT accident_occurred, COUNT(*) 
FROM traffic_dataset
GROUP BY accident_occurred;

SELECT is_peak, COUNT(*) 
FROM traffic_dataset
GROUP BY is_peak;

/* ===== LANE_COUNT ===== */

SELECT AVG(val) AS mean_lane,
STDDEV_SAMP(val) AS std_lane,
VAR_SAMP(val) AS var_lane,
MAX(val)-MIN(val) AS range_lane
FROM (
SELECT CAST(lane_count AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE lane_count REGEXP '^[0-9.]+$'
) t;


/* ===== SPEED_LIMIT ===== */

SELECT AVG(val) mean_speed,
STDDEV_SAMP(val) std_speed,
VAR_SAMP(val) var_speed,
MAX(val)-MIN(val) range_speed
FROM (
SELECT CAST(speed_limit_kmph AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE speed_limit_kmph REGEXP '^[0-9.]+$'
) t;


/* ===== BLACKSPOT ===== */

SELECT AVG(val) mean_blackspot,
STDDEV_SAMP(val) std_blackspot,
VAR_SAMP(val) var_blackspot,
MAX(val)-MIN(val) range_blackspot
FROM (
SELECT CAST(blackspot_score AS DECIMAL(10,5)) val
FROM traffic_dataset
WHERE blackspot_score REGEXP '^[0-9.]+$'
) t;


/* ===== VEHICLE COUNT ===== */

SELECT AVG(val) mean_vehicle,
STDDEV_SAMP(val) std_vehicle,
VAR_SAMP(val) var_vehicle,
MAX(val)-MIN(val) range_vehicle
FROM (
SELECT CAST(vehicle_count_per_hr AS DECIMAL(12,3)) val
FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$'
) t;


/* ===== AVG SPEED ===== */

SELECT AVG(val) mean_avgspeed,
STDDEV_SAMP(val) std_avgspeed,
VAR_SAMP(val) var_avgspeed,
MAX(val)-MIN(val) range_avgspeed
FROM (
SELECT CAST(avg_speed_kmph AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE avg_speed_kmph REGEXP '^[0-9.]+$'
) t;


/* ===== green_duration_s ===== */

SELECT AVG(val) mean_green,
STDDEV_SAMP(val) std_green,
VAR_SAMP(val) var_green,
MAX(val)-MIN(val) range_green
FROM (
SELECT CAST(green_duration_s AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE green_duration_s REGEXP '^[0-9.]+$'
) t;


/* ===== RED ===== */

SELECT AVG(val) mean_red,
STDDEV_SAMP(val) std_red,
VAR_SAMP(val) var_red,
MAX(val)-MIN(val) range_red
FROM (
SELECT CAST(red_duration_s AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE red_duration_s REGEXP '^[0-9.]+$'
) t;


/* ===== YELLOW ===== */

SELECT AVG(val) mean_yellow,
STDDEV_SAMP(val) std_yellow,
VAR_SAMP(val) var_yellow,
MAX(val)-MIN(val) range_yellow
FROM (
SELECT CAST(yellow_duration_s AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE yellow_duration_s REGEXP '^[0-9.]+$'
) t;


/* ===== CYCLE ===== */

SELECT AVG(val) mean_cycle,
STDDEV_SAMP(val) std_cycle,
VAR_SAMP(val) var_cycle,
MAX(val)-MIN(val) range_cycle
FROM (
SELECT CAST(cycle_time_s AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE cycle_time_s REGEXP '^[0-9.]+$'
) t;


/* ===== VIOLATIONS ===== */

SELECT AVG(val) mean_violation,
STDDEV_SAMP(val) std_violation,
VAR_SAMP(val) var_violation,
MAX(val)-MIN(val) range_violation
FROM (
SELECT CAST(violations_count AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE violations_count REGEXP '^[0-9.]+$'
) t;


/* ===== VEHICLES INVOLVED ===== */

SELECT AVG(val) mean_involved,
STDDEV_SAMP(val) std_involved,
VAR_SAMP(val) var_involved,
MAX(val)-MIN(val) range_involved
FROM (
SELECT CAST(vehicles_involved AS DECIMAL(10,3)) val
FROM traffic_dataset
WHERE vehicles_involved REGEXP '^[0-9.]+$'
) t;


/* ===== VEH COUNT ACCIDENT ===== */

SELECT AVG(val) mean_accidentveh,
STDDEV_SAMP(val) std_accidentveh,
VAR_SAMP(val) var_accidentveh,
MAX(val)-MIN(val) range_accidentveh
FROM (
SELECT CAST(veh_count_at_accident AS DECIMAL(12,3)) val
FROM traffic_dataset
WHERE veh_count_at_accident REGEXP '^[0-9.]+$'
) t;



/* ===================== MEDIAN ===================== */

WITH clean AS (

SELECT 
CAST(lane_count AS DECIMAL(10,3)) lane_count,
CAST(speed_limit_kmph AS DECIMAL(10,3)) speed_limit_kmph,
CAST(blackspot_score AS DECIMAL(10,5)) blackspot_score,
CAST(vehicle_count_per_hr AS DECIMAL(12,3)) vehicle_count_per_hr,
CAST(avg_speed_kmph AS DECIMAL(10,3)) avg_speed_kmph,
CAST(green_duration_s AS DECIMAL(10,3)) green_duration_s,
CAST(red_duration_s AS DECIMAL(10,3)) red_duration_s,
CAST(yellow_duration_s AS DECIMAL(10,3)) yellow_duration_s,
CAST(cycle_time_s AS DECIMAL(10,3)) cycle_time_s,
CAST(violations_count AS DECIMAL(10,3)) violations_count,
CAST(vehicles_involved AS DECIMAL(10,3)) vehicles_involved,
CAST(veh_count_at_accident AS DECIMAL(12,3)) veh_count_at_accident

FROM traffic_dataset

WHERE lane_count REGEXP '^[0-9.]+$'
AND speed_limit_kmph REGEXP '^[0-9.]+$'
AND blackspot_score REGEXP '^[0-9.]+$'
AND vehicle_count_per_hr REGEXP '^[0-9.]+$'
AND avg_speed_kmph REGEXP '^[0-9.]+$'
AND green_duration_s REGEXP '^[0-9.]+$'
AND red_duration_s REGEXP '^[0-9.]+$'
AND yellow_duration_s REGEXP '^[0-9.]+$'
AND cycle_time_s REGEXP '^[0-9.]+$'
AND violations_count REGEXP '^[0-9.]+$'
AND vehicles_involved REGEXP '^[0-9.]+$'
AND veh_count_at_accident REGEXP '^[0-9.]+$'
),

ordered AS (

SELECT *,
ROW_NUMBER() OVER (ORDER BY lane_count) rn_lane,
ROW_NUMBER() OVER (ORDER BY speed_limit_kmph) rn_speed,
ROW_NUMBER() OVER (ORDER BY blackspot_score) rn_black,
ROW_NUMBER() OVER (ORDER BY vehicle_count_per_hr) rn_vehicle,
ROW_NUMBER() OVER (ORDER BY avg_speed_kmph) rn_avg,
ROW_NUMBER() OVER (ORDER BY green_duration_s) rn_green,
ROW_NUMBER() OVER (ORDER BY red_duration_s) rn_red,
ROW_NUMBER() OVER (ORDER BY yellow_duration_s) rn_yellow,
ROW_NUMBER() OVER (ORDER BY cycle_time_s) rn_cycle,
ROW_NUMBER() OVER (ORDER BY violations_count) rn_violation,
ROW_NUMBER() OVER (ORDER BY vehicles_involved) rn_involved,
ROW_NUMBER() OVER (ORDER BY veh_count_at_accident) rn_accident,

COUNT(*) OVER() n

FROM clean
)

SELECT
AVG(CASE WHEN rn_lane IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN lane_count END) median_lane,
AVG(CASE WHEN rn_speed IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN speed_limit_kmph END) median_speed,
AVG(CASE WHEN rn_black IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN blackspot_score END) median_blackspot,
AVG(CASE WHEN rn_vehicle IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN vehicle_count_per_hr END) median_vehicle,
AVG(CASE WHEN rn_avg IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN avg_speed_kmph END) median_avgspeed,
AVG(CASE WHEN rn_green IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN green_duration_s END) median_green,
AVG(CASE WHEN rn_red IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN red_duration_s END) median_red,
AVG(CASE WHEN rn_yellow IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN yellow_duration_s END) median_yellow,
AVG(CASE WHEN rn_cycle IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN cycle_time_s END) median_cycle,
AVG(CASE WHEN rn_violation IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN violations_count END) median_violation,
AVG(CASE WHEN rn_involved IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN vehicles_involved END) median_involved,
AVG(CASE WHEN rn_accident IN (FLOOR((n+1)/2), FLOOR((n+2)/2)) THEN veh_count_at_accident END) median_accident
FROM ordered;


/* ===================== MODE ===================== */

SELECT 'lane_count', lane_count FROM traffic_dataset
WHERE lane_count REGEXP '^[0-9.]+$'
GROUP BY lane_count ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'speed_limit', speed_limit_kmph FROM traffic_dataset
WHERE speed_limit_kmph REGEXP '^[0-9.]+$'
GROUP BY speed_limit_kmph ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'blackspot', blackspot_score FROM traffic_dataset
WHERE blackspot_score REGEXP '^[0-9.]+$'
GROUP BY blackspot_score ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'vehicle_count_hr', vehicle_count_per_hr FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$'
GROUP BY vehicle_count_per_hr ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'avg_speed_kmph', avg_speed_kmph FROM traffic_dataset
WHERE avg_speed_kmph REGEXP '^[0-9.]+$'
GROUP BY avg_speed_kmph ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'green_duration_s', green_duration_s FROM traffic_dataset
WHERE green_duration_s REGEXP '^[0-9.]+$'
GROUP BY green_duration_s ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'red_duration_s', red_duration_s FROM traffic_dataset
WHERE red_duration_s REGEXP '^[0-9.]+$'
GROUP BY red_duration_s ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'yellow_duration', yellow_duration_s FROM traffic_dataset
WHERE yellow_duration_s REGEXP '^[0-9.]+$'
GROUP BY yellow_duration_s ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'cycle_time', cycle_time_s FROM traffic_dataset
WHERE cycle_time_s REGEXP '^[0-9.]+$'
GROUP BY cycle_time_s ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'violations_count', violations_count FROM traffic_dataset
WHERE violations_count REGEXP '^[0-9.]+$'
GROUP BY violations_count ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'vehicles_involved', vehicles_involved FROM traffic_dataset
WHERE vehicles_involved REGEXP '^[0-9.]+$'
GROUP BY vehicles_involved ORDER BY COUNT(*) DESC LIMIT 1;

SELECT 'veh_count_at_accident', veh_count_at_accident FROM traffic_dataset
WHERE veh_count_at_accident REGEXP '^[0-9.]+$'
GROUP BY veh_count_at_accident ORDER BY COUNT(*) DESC LIMIT 1;





/* ===================== SKEWNESS & KURTOSIS ===================== */
/* ====== lane_count ====== */
SELECT 
AVG(CAST(lane_count AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(lane_count AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE lane_count REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(lane_count AS DECIMAL(10,3)) - 3 , 3))
/
(2016 * POWER(1.7799 , 3)) AS skew_lane
FROM traffic_dataset
WHERE lane_count REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(lane_count AS DECIMAL(10,3)) - 3, 4))
/
(2016 * POWER(1.7799 , 4))
- 3 AS kurt_lane
FROM traffic_dataset
WHERE lane_count REGEXP '^[0-9.]+$';


/* ====== speed_limit_kmph ====== */
SELECT 
AVG(CAST(speed_limit_kmph AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(speed_limit_kmph AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE speed_limit_kmph REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(speed_limit_kmph AS DECIMAL(10,3)) - 62.6666 , 3))
/
(2016 * POWER(23.4981 , 3)) AS skew_speed
FROM traffic_dataset
WHERE speed_limit_kmph REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(speed_limit_kmph AS DECIMAL(10,3)) - 62.6666 , 4))
/
(2016 * POWER(23.4981 , 4))
- 3 AS kurt_speed
FROM traffic_dataset
WHERE speed_limit_kmph REGEXP '^[0-9.]+$';


/* ====== blackspot_score ====== */
SELECT 
AVG(CAST(blackspot_score AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(blackspot_score AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE blackspot_score REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(blackspot_score AS DECIMAL(10,3)) - 0.2162 , 3))
/
(2016 * POWER(0.1481 , 3)) AS skew_blackspot
FROM traffic_dataset
WHERE blackspot_score REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(blackspot_score AS DECIMAL(10,3)) - 0.2162 , 4))
/
(2016 * POWER(0.1481 , 4))
- 3 AS kurt_blackspot
FROM traffic_dataset
WHERE blackspot_score REGEXP '^[0-9.]+$';


/* ====== vehicle_count_per_hr ====== */
SELECT 
AVG(CAST(vehicle_count_per_hr AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(vehicle_count_per_hr AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(vehicle_count_per_hr AS DECIMAL(10,3)) - 1043.48 , 3))
/
(2014 * POWER(1203.81 , 3)) AS skew_vehicle_count_per_hr
FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(vehicle_count_per_hr AS DECIMAL(10,3)) - 1043.48 , 4))
/
(2014 * POWER(1203.81 , 4))
- 3 AS kurt_vehicle_count_per_hr
FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$';


/* ====== avg_speed_kmph ====== */
SELECT 
AVG(CAST(avg_speed_kmph AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(avg_speed_kmph AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE avg_speed_kmph REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(avg_speed_kmph AS DECIMAL(10,3)) - 31.0121 , 3))
/
(1887 * POWER(24.9565 , 3)) AS skew_avg_speed_kmph
FROM traffic_dataset
WHERE avg_speed_kmph REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(avg_speed_kmph AS DECIMAL(10,3)) - 31.0121 , 4))
/
(1887 * POWER(24.9565 , 4))
- 3 AS kurt_avg_speed_kmph
FROM traffic_dataset
WHERE avg_speed_kmph REGEXP '^[0-9.]+$';


/* ====== green_duration_s ====== */
SELECT 
AVG(CAST(green_duration_s AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(green_duration_s AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE green_duration_s REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(green_duration_s AS DECIMAL(10,3)) - 59.7937 , 3))
/
(1183 * POWER(21.1923 , 3)) AS skew_green
FROM traffic_dataset
WHERE green_duration_s REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(green_duration_s AS DECIMAL(10,3)) - 59.7937, 4))
/
(1183 * POWER(21.1923 , 4))
- 3 AS kurt_green
FROM traffic_dataset
WHERE green_duration_s REGEXP '^[0-9.]+$';


/* ====== red_duration_s ====== */
SELECT 
AVG(CAST(red_duration_s AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(red_duration_s AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE red_duration_s REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(red_duration_s AS DECIMAL(10,3)) - 76.0685 , 3))
/
(1182 * POWER(26.5739 , 3)) AS skew_red
FROM traffic_dataset
WHERE red_duration_s REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(red_duration_s AS DECIMAL(10,3)) - 76.0685, 4))
/
(1182 * POWER(26.5739 , 4))
- 3 AS kurt_red
FROM traffic_dataset
WHERE red_duration_s REGEXP '^[0-9.]+$';


/* ====== yellow_duration_s ====== */
SELECT 
AVG(CAST(yellow_duration_s AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(yellow_duration_s AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE yellow_duration_s REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(yellow_duration_s AS DECIMAL(10,3)) - 6.0717 , 3))
/
(1184 * POWER(5.2395 , 3)) AS skew_yellow
FROM traffic_dataset
WHERE yellow_duration_s REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(yellow_duration_s AS DECIMAL(10,3)) - 6.0717, 4))
/
(1184 * POWER(5.2395 , 4))
- 3 AS kurt_yellow
FROM traffic_dataset
WHERE yellow_duration_s REGEXP '^[0-9.]+$';


/* ====== cycle_time_s ====== */
SELECT 
AVG(CAST(cycle_time_s AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(cycle_time_s AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE cycle_time_s REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(cycle_time_s AS DECIMAL(10,3)) - 141.943 , 3))
/
(1182 * POWER(33.6946 , 3)) AS skew_cycle
FROM traffic_dataset
WHERE cycle_time_s REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(cycle_time_s AS DECIMAL(10,3)) - 141.943 , 4))
/
(1182 * POWER(33.6946 , 4))
- 3 AS kurt_cycle
FROM traffic_dataset
WHERE cycle_time_s REGEXP '^[0-9.]+$';



/* ====== violations_count ====== */
SELECT 
AVG(CAST(violations_count AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(violations_count AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE violations_count REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(violations_count AS DECIMAL(10,3)) - 0.8756 , 3))
/
(1182 * POWER(0.9784 , 3)) AS skew_violations_count
FROM traffic_dataset
WHERE violations_count REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(violations_count AS DECIMAL(10,3)) - 0.8756, 4))
/
(1182 * POWER(0.9784 , 4))
- 3 AS kurt_violations_count
FROM traffic_dataset
WHERE violations_count REGEXP '^[0-9.]+$';


/* ====== vehicles_involved ====== */
SELECT 
AVG(CAST(vehicles_involved AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(vehicles_involved AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE vehicles_involved REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(vehicles_involved AS DECIMAL(10,3)) - 3.1827 , 3))
/
(93 * POWER(1.9888 , 3)) AS skew_vehicles_involved
FROM traffic_dataset
WHERE vehicles_involved REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(vehicles_involved AS DECIMAL(10,3)) - 3.1827, 4))
/
(93 * POWER(1.9888 , 4))
- 3 AS kurt_vehicles_involved
FROM traffic_dataset
WHERE vehicles_involved REGEXP '^[0-9.]+$';


/* ====== veh_count_at_accident ====== */
SELECT 
AVG(CAST(veh_count_at_accident AS DECIMAL(10,3))) AS mean_val,
STDDEV_SAMP(CAST(veh_count_at_accident AS DECIMAL(10,3))) AS std_val,
COUNT(*) AS n
FROM traffic_dataset
WHERE veh_count_at_accident REGEXP '^[0-9.]+$';

# Skewness
SELECT 
SUM(POWER(CAST(veh_count_at_accident AS DECIMAL(10,3)) - 1043.56 , 3))
/
(2016 * POWER(1203.55 , 3)) AS skew_veh_count_at_accident
FROM traffic_dataset
WHERE veh_count_at_accident REGEXP '^[0-9.]+$';

# Kurtosis
SELECT 
SUM(POWER(CAST(veh_count_at_accident AS DECIMAL(10,3)) - 1043.56, 4))
/
(2016 * POWER(1203.55 , 4))
- 3 AS kurt_veh_count_at_accident
FROM traffic_dataset
WHERE veh_count_at_accident REGEXP '^[0-9.]+$';

/* ===== Outlier Detection    ===== */
SELECT *
FROM (
SELECT 
CAST(vehicle_count_per_hr AS DECIMAL(10,2)) AS v,
AVG(CAST(vehicle_count_per_hr AS DECIMAL(10,2))) OVER() AS mean_val,
STDDEV_SAMP(CAST(vehicle_count_per_hr AS DECIMAL(10,2))) OVER() AS std_val
FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$'
) AS t
WHERE v > mean_val + 3 * std_val;



/* ===== business Insights     ===== */
# Accident vs Traffic Load
SELECT accident_occurred,
AVG(CAST(vehicle_count_per_hr AS DECIMAL(10,2))) avg_vehicle
FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$'
GROUP BY accident_occurred;


# Speed vs Violations
SELECT 
AVG(CAST(avg_speed_kmph AS DECIMAL(10,2))) avg_speed,
AVG(CAST(violations_count AS DECIMAL(10,2))) avg_violation
FROM traffic_dataset
WHERE avg_speed_kmph REGEXP '^[0-9.]+$'
AND violations_count REGEXP '^[0-9.]+$';

# Peak vs Non-Peak Traffic Behaviour
SELECT is_peak,
AVG(CAST(vehicle_count_per_hr AS DECIMAL(10,2))) avg_vehicle,
AVG(CAST(avg_speed_kmph AS DECIMAL(10,2))) avg_speed
FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$'
AND avg_speed_kmph REGEXP '^[0-9.]+$'
GROUP BY is_peak;

# Signal Timing vs Traffic Volume
SELECT 
AVG(CAST(vehicle_count_per_hr AS DECIMAL(10,2))) avg_vehicle,
AVG(CAST(cycle_time_s AS DECIMAL(10,2))) avg_cycle
FROM traffic_dataset
WHERE vehicle_count_per_hr REGEXP '^[0-9.]+$'
AND cycle_time_s REGEXP '^[0-9.]+$';
