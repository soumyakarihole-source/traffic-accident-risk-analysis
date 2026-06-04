/* ======== Create Clean Working Table  ========= */
CREATE TABLE traffic_clean AS
SELECT * FROM traffic_dataset;


/* ======== Convert Timestamp to Proper Datetime  ========= */
ALTER TABLE traffic_clean ADD COLUMN ts DATETIME;

SET SQL_SAFE_UPDATES=0;
UPDATE traffic_clean
SET ts = STR_TO_DATE(timestamp,'%d-%m-%Y %H:%i');

/* ======== Convert Numeric Columns  ========= */
ALTER TABLE traffic_clean
ADD lane_count_num INT,
ADD speed_limit_num INT,
ADD vehicle_count_num DOUBLE,
ADD avg_speed_num DOUBLE,
ADD cycle_time_num DOUBLE,
ADD violations_num DOUBLE;

ALTER TABLE traffic_clean
ADD blackspot_score_num DOUBLE,
ADD green_duration_num DOUBLE,
ADD red_duration_num DOUBLE,
ADD yellow_duration_num DOUBLE,
ADD vehicles_involved_num DOUBLE,
ADD veh_count_accident_num DOUBLE;

UPDATE traffic_clean
SET lane_count_num =
CASE
WHEN lane_count REGEXP '^[0-9.]+$' THEN CAST(lane_count AS UNSIGNED)
ELSE NULL
END;


UPDATE traffic_clean
SET speed_limit_num =
CASE
WHEN speed_limit_kmph REGEXP '^[0-9.]+$'
THEN CAST(speed_limit_kmph AS UNSIGNED)
ELSE NULL
END;


UPDATE traffic_clean
SET blackspot_score_num =
CASE
WHEN blackspot_score REGEXP '^[0-9.]+$'
THEN CAST(blackspot_score AS DECIMAL(10,5))
ELSE NULL
END;


UPDATE traffic_clean
SET vehicle_count_num =
CASE
WHEN vehicle_count_per_hr REGEXP '^[0-9.]+$'
THEN CAST(vehicle_count_per_hr AS DECIMAL(12,2))
ELSE NULL
END;


UPDATE traffic_clean
SET avg_speed_num =
CASE
WHEN avg_speed_kmph REGEXP '^[0-9.]+$'
THEN CAST(avg_speed_kmph AS DECIMAL(10,2))
ELSE NULL
END;


UPDATE traffic_clean
SET green_duration_num =
CASE
WHEN green_duration_s REGEXP '^[0-9.]+$'
THEN CAST(green_duration_s AS DECIMAL(10,2))
ELSE NULL
END;


UPDATE traffic_clean
SET red_duration_num =
CASE
WHEN red_duration_s REGEXP '^[0-9.]+$'
THEN CAST(red_duration_s AS DECIMAL(10,2))
ELSE NULL
END;


UPDATE traffic_clean
SET yellow_duration_num =
CASE
WHEN yellow_duration_s REGEXP '^[0-9.]+$'
THEN CAST(yellow_duration_s AS DECIMAL(10,2))
ELSE NULL
END;


UPDATE traffic_clean
SET cycle_time_num =
CASE
WHEN cycle_time_s REGEXP '^[0-9.]+$'
THEN CAST(cycle_time_s AS DECIMAL(10,2))
ELSE NULL
END;


UPDATE traffic_clean
SET violations_num =
CASE
WHEN violations_count REGEXP '^[0-9.]+$'
THEN CAST(violations_count AS DECIMAL(10,2))
ELSE NULL
END;


UPDATE traffic_clean
SET vehicles_involved_num =
CASE
WHEN vehicles_involved REGEXP '^[0-9.]+$'
THEN CAST(vehicles_involved AS DECIMAL(10,2))
ELSE NULL
END;


UPDATE traffic_clean
SET veh_count_accident_num =
CASE
WHEN veh_count_at_accident REGEXP '^[0-9.]+$'
THEN CAST(veh_count_at_accident AS DECIMAL(12,2))
ELSE NULL
END;

# validation check  
SELECT
COUNT(*) total_rows,
SUM(lane_count_num IS NULL) null_lane,
SUM(speed_limit_num IS NULL) null_speed,
SUM(vehicle_count_num IS NULL) null_vehicle,
SUM(avg_speed_num IS NULL) null_avg_speed,
SUM(cycle_time_num IS NULL) null_cycle,
SUM(violations_num IS NULL) null_violations,
SUM(blackspot_score_num IS NULL) null_blackspot,
SUM(green_duration_num IS NULL) null_green,
SUM(red_duration_num IS NULL) null_red,
SUM(yellow_duration_num IS NULL) null_yellow,
SUM(vehicles_involved_num IS NULL) null_veh_involved,
SUM(veh_count_accident_num IS NULL) null_accident_veh
FROM traffic_clean;


/* ======== NULL Treatment  ========= */
UPDATE traffic_clean
SET lane_count_num =
(
SELECT avg_lane FROM
(SELECT AVG(lane_count_num) avg_lane FROM traffic_clean) t
)
WHERE lane_count_num IS NULL;


UPDATE traffic_clean
SET speed_limit_num =
(
SELECT avg_speedlimit FROM
(SELECT AVG(speed_limit_num) avg_speedlimit FROM traffic_clean) t
)
WHERE speed_limit_num IS NULL;

UPDATE traffic_clean
SET vehicle_count_num =
(
SELECT avg_vehicle FROM
(SELECT AVG(vehicle_count_num) avg_vehicle FROM traffic_clean) t
)
WHERE vehicle_count_num IS NULL;


UPDATE traffic_clean
SET vehicle_count_num =
(
SELECT avg_vehicle FROM
(SELECT AVG(vehicle_count_num) avg_vehicle FROM traffic_clean) t
)
WHERE vehicle_count_num IS NULL;


UPDATE traffic_clean
SET avg_speed_num =
(
SELECT avg_avgspeed FROM
(SELECT AVG(avg_speed_num) avg_avgspeed FROM traffic_clean) t
)
WHERE avg_speed_num IS NULL;


UPDATE traffic_clean
SET cycle_time_num =
(
SELECT avg_cycle FROM
(SELECT AVG(cycle_time_num) avg_cycle FROM traffic_clean) t
)
WHERE cycle_time_num IS NULL;


UPDATE traffic_clean
SET violations_num =
(
SELECT avg_violation FROM
(SELECT AVG(violations_num) avg_violation FROM traffic_clean) t
)
WHERE violations_num IS NULL;


UPDATE traffic_clean
SET blackspot_score_num =
(
SELECT avg_black FROM
(SELECT AVG(blackspot_score_num) avg_black FROM traffic_clean) t
)
WHERE blackspot_score_num IS NULL;


UPDATE traffic_clean
SET green_duration_num =
(
SELECT avg_green FROM
(SELECT AVG(green_duration_num) avg_green FROM traffic_clean) t
)
WHERE green_duration_num IS NULL;


UPDATE traffic_clean
SET red_duration_num =
(
SELECT avg_red FROM
(SELECT AVG(red_duration_num) avg_red FROM traffic_clean) t
)
WHERE red_duration_num IS NULL;


UPDATE traffic_clean
SET yellow_duration_num =
(
SELECT avg_yellow FROM
(SELECT AVG(yellow_duration_num) avg_yellow FROM traffic_clean) t
)
WHERE yellow_duration_num IS NULL;


UPDATE traffic_clean
SET vehicles_involved_num =
(
SELECT avg_inv FROM
(SELECT AVG(vehicles_involved_num) avg_inv FROM traffic_clean) t
)
WHERE vehicles_involved_num IS NULL;


UPDATE traffic_clean
SET veh_count_accident_num =
(
SELECT avg_acc FROM
(SELECT AVG(veh_count_accident_num) avg_acc FROM traffic_clean) t
)
WHERE veh_count_accident_num IS NULL;

############  Re-Validation  ##########
SELECT
SUM(lane_count_num IS NULL),
SUM(speed_limit_num IS NULL),
SUM(vehicle_count_num IS NULL),
SUM(avg_speed_num IS NULL)
FROM traffic_clean;


/* ======== Outlier Treatment (Capping)  ========= */
#======== Vehicle Count Outlier Treatment  ========= 
UPDATE traffic_clean t
JOIN
(
SELECT AVG(vehicle_count_num) mean_val,
STDDEV(vehicle_count_num) std_val
FROM traffic_clean
) s
SET vehicle_count_num =
CASE
WHEN vehicle_count_num > mean_val + 3*std_val THEN mean_val + 3*std_val
WHEN vehicle_count_num < mean_val - 3*std_val THEN mean_val - 3*std_val
ELSE vehicle_count_num
END;


#======== Average Speed Outlier Treatment  ========= 
UPDATE traffic_clean t
JOIN
(
SELECT AVG(avg_speed_num) mean_val,
STDDEV(avg_speed_num) std_val
FROM traffic_clean
) s
SET avg_speed_num =
CASE
WHEN avg_speed_num > mean_val + 3*std_val THEN mean_val + 3*std_val
WHEN avg_speed_num < mean_val - 3*std_val THEN mean_val - 3*std_val
ELSE avg_speed_num
END;


#======== Violations Count Treatment  ========= 
UPDATE traffic_clean t
JOIN
(
SELECT AVG(violations_num) mean_val,
STDDEV(violations_num) std_val
FROM traffic_clean
) s
SET violations_num =
CASE
WHEN violations_num > mean_val + 3*std_val THEN mean_val + 3*std_val
WHEN violations_num < mean_val - 3*std_val THEN mean_val - 3*std_val
ELSE violations_num
END;


#======== Cycle Time Treatment  ========= 
UPDATE traffic_clean t
JOIN
(
SELECT AVG(cycle_time_num) mean_val,
STDDEV(cycle_time_num) std_val
FROM traffic_clean
) s
SET cycle_time_num =
CASE
WHEN cycle_time_num > mean_val + 3*std_val THEN mean_val + 3*std_val
WHEN cycle_time_num < mean_val - 3*std_val THEN mean_val - 3*std_val
ELSE cycle_time_num
END;


#======== Blackspot Score Treatment  ========= 
UPDATE traffic_clean t
JOIN
(
SELECT AVG(blackspot_score_num) mean_val,
STDDEV(blackspot_score_num) std_val
FROM traffic_clean
) s
SET blackspot_score_num =
CASE
WHEN blackspot_score_num > mean_val + 3*std_val THEN mean_val + 3*std_val
WHEN blackspot_score_num < mean_val - 3*std_val THEN mean_val - 3*std_val
ELSE blackspot_score_num
END;


#======== Vehicles Involved Treatment  ========= 
UPDATE traffic_clean t
JOIN
(
SELECT AVG(vehicles_involved_num) mean_val,
STDDEV(vehicles_involved_num) std_val
FROM traffic_clean
) s
SET vehicles_involved_num =
CASE
WHEN vehicles_involved_num > mean_val + 3*std_val THEN mean_val + 3*std_val
WHEN vehicles_involved_num < mean_val - 3*std_val THEN mean_val - 3*std_val
ELSE vehicles_involved_num
END;


#======== Validation step  ========= 
SELECT
MIN(vehicle_count_num),
MAX(vehicle_count_num),
MIN(avg_speed_num),
MAX(avg_speed_num)
FROM traffic_clean;


/* ======== Feature Engineering  ========= */
#### Extract Hour  ####
ALTER TABLE traffic_clean ADD hour INT;

UPDATE traffic_clean
SET hour = HOUR(ts);

#### Create Traffic Level Feature  ####
ALTER TABLE traffic_clean ADD traffic_level VARCHAR(20);

UPDATE traffic_clean
SET traffic_level =
CASE
WHEN vehicle_count_num < 500 THEN 'Low'
WHEN vehicle_count_num < 1500 THEN 'Medium'
ELSE 'High'
END;


#### create Speed Violation Flag ####
ALTER TABLE traffic_clean ADD overspeed_flag INT;

UPDATE traffic_clean
SET overspeed_flag =
CASE
WHEN avg_speed_num > speed_limit_num THEN 1
ELSE 0
END;


/* ======== Final Table  ========= */
CREATE TABLE traffic_final_dataset AS
SELECT
location_id,
ts,
hour,

state,
road_type,

lane_count_num,
speed_limit_num,
vehicle_count_num,
avg_speed_num,

cycle_time_num,
green_duration_num,
red_duration_num,
yellow_duration_num,

violations_num,
overspeed_flag,

traffic_level,

blackspot_score_num,
vehicles_involved_num,
veh_count_accident_num,
accident_occurred

FROM traffic_clean;


#======== basic EDA validation after table all steps  =========
########    Traffic Level Distribution     ###########
SELECT traffic_level, COUNT(*) 
FROM traffic_final_dataset
GROUP BY traffic_level;

########    Peak Hour Traffic     ###########
SELECT hour, AVG(vehicle_count_num) avg_traffic
FROM traffic_final_dataset
GROUP BY hour
ORDER BY avg_traffic DESC;

########   Overspeed percentage    ###########
SELECT 
ROUND(SUM(overspeed_flag)/COUNT(*)*100,2) overspeed_percent
FROM traffic_final_dataset;

SELECT * FROM traffic_final_dataset;