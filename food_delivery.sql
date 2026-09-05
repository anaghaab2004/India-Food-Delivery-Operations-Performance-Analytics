
/* ============================================================================
   FOOD DELIVERY OPERATIONS & PERFORMANCE ANALYTICS
   SQL Queries — built for the table as imported into MySQL Workbench
   Table: delivery_data
   Author: ANAGHA A B

   Columns used (from Excel pre-processing):
   ID, Delivery_person_ID, Delivery_person_Age, Delivery_person_Ratings,
   Restaurant_latitude, Restaurant_longitude, Delivery_location_latitude,
   Delivery_location_longitude, Order_Date, Time_Orderd, Time_Order_picked,
   Weatherconditions, Road_traffic_density, Vehicle_condition, Type_of_order,
   Type_of_vehicle, multiple_deliveries, Festival, City, `Time_taken(min)`,
   order_Hour, Day_of_week, Month, week, Day_Type (Weekday/Weekend),
   delivery_category (Excellent / Average / Poor rating bucket)
   ============================================================================ */
create database food_delivery;
use food_delivery;

/* ============================================================================
   SECTION 0: SANITY CHECK
   ============================================================================ */

DESCRIBE delivery_data;

SELECT COUNT(*) AS total_rows FROM delivery_data;

SELECT * FROM delivery_data LIMIT 10;


/* ============================================================================
   SECTION 1: HEADLINE KPIs
   ============================================================================ */

-- 1.1 Average delivery time (minutes)
SELECT ROUND(AVG(`Time_taken(min)`), 2) 
AS avg_delivery_time_min
FROM delivery_data;

-- 1.2 Total orders analyzed
SELECT COUNT(*) 
AS total_orders
FROM delivery_data;

-- 1.3 SLA breach rate (threshold: 35 minutes)
SELECT ROUND(100.0 * SUM(CASE WHEN `Time_taken(min)` > 35 THEN 1 ELSE 0 END) / COUNT(*), 2) 
AS sla_breach_percent
FROM delivery_data;

-- 1.4 Average delivery partner rating
SELECT ROUND(AVG(Delivery_person_Ratings), 2) AS avg_partner_rating
FROM delivery_data;

-- 1.5 Rating category distribution (Excellent / Average / Poor)
SELECT delivery_category, COUNT(*)                             
AS order_count,
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)  
AS percent_of_orders
FROM delivery_data
GROUP BY delivery_category
ORDER BY order_count DESC;


/* ============================================================================
   SECTION 2: TRAFFIC & WEATHER IMPACT
   ============================================================================ */

-- 2.1 Average delivery time by traffic density
SELECT Road_traffic_density,
COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min,
ROUND(STDDEV(`Time_taken(min)`), 2) AS stddev_delivery_time
FROM delivery_data
GROUP BY Road_traffic_density
ORDER BY avg_delivery_time_min DESC;

-- 2.2 Average delivery time by weather condition
SELECT Weatherconditions,
COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY Weatherconditions
ORDER BY avg_delivery_time_min DESC;

-- 2.3 Rating category breakdown by traffic density(does traffic affect the rating?)
SELECT Road_traffic_density,
delivery_category,
COUNT(*) AS order_count
FROM delivery_data
GROUP BY Road_traffic_density, delivery_category
ORDER BY Road_traffic_density, delivery_category;


/* ============================================================================
   SECTION 3: DEMAND PATTERNS
   ============================================================================ */

-- 3.1 Order volume by hour of day
SELECT order_Hour,
COUNT(*) AS order_count
FROM delivery_data
GROUP BY order_Hour
ORDER BY order_Hour;

-- 3.2 Order volume and avg delivery time by day of week
SELECT Day_of_week,
COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time
FROM delivery_data
GROUP BY Day_of_week
ORDER BY FIELD(Day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- 3.3 Weekday vs Weekend comparison
SELECT 'weekend/weekday',
COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time,
ROUND(AVG(Delivery_person_Ratings), 2) AS avg_rating
FROM delivery_data
GROUP BY 'weekend/weekday';

-- 3.4 Monthly order trend
SELECT Month,
COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time
FROM delivery_data
GROUP BY Month
ORDER BY FIELD(Month, 'January','February','March','April','May','June','July','August','September','October','November','December');

-- 3.5 Weekly order trend
SELECT week, COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY week
ORDER BY week;

-- 3.6 Festival vs non-festival: volume and speed impact
SELECT Festival,COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY Festival;

/* ============================================================================
   SECTION 4: CITY / GEOGRAPHY ANALYSIS
   ============================================================================ */

SELECT City,
COUNT(*)  AS order_count,
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)  AS pct_of_total_orders,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY City
ORDER BY avg_delivery_time_min DESC;


/* ============================================================================
   SECTION 5: DELIVERY PARTNER PERFORMANCE
   Combines speed, rating, and the pre-built rating category.
   ============================================================================ */

-- 5.1 Top 5 delivery partners by average rating (min 10 orders)
SELECT Delivery_person_ID,
COUNT(*) AS orders_handled,
ROUND(AVG(Delivery_person_Ratings), 2) AS avg_rating,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time
FROM delivery_data
GROUP BY Delivery_person_ID
HAVING COUNT(*) >= 10
ORDER BY avg_rating DESC
LIMIT 5;

-- 5.2 Bottom 5 delivery partners by average rating (min 10 orders)
SELECT Delivery_person_ID,
COUNT(*) AS orders_handled,
ROUND(AVG(Delivery_person_Ratings), 2) AS avg_rating,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY Delivery_person_ID
HAVING COUNT(*) >= 10
ORDER BY avg_rating ASC
LIMIT 5;

-- 5.3 Rank partners by speed vs rating simultaneously (window functions)
SELECT Delivery_person_ID,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min,
ROUND(AVG(Delivery_person_Ratings), 2) AS avg_rating,
RANK() OVER (ORDER BY AVG(`Time_taken(min)`) ASC)AS speed_rank,
RANK() OVER (ORDER BY AVG(Delivery_person_Ratings) DESC) AS rating_rank
FROM delivery_data
GROUP BY Delivery_person_ID
HAVING COUNT(*) >= 10
ORDER BY speed_rank
LIMIT 20;

-- 5.4 Performance quartiles by delivery speed
SELECT Delivery_person_ID,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min,
NTILE(4) OVER (ORDER BY AVG(`Time_taken(min)`)) AS performance_quartile
FROM delivery_data
GROUP BY Delivery_person_ID
HAVING COUNT(*) >= 10;

-- 5.5 Rating category distribution per delivery partner (min 10 orders)
SELECT Delivery_person_ID,
delivery_category,
COUNT(*) AS order_count
FROM delivery_data
GROUP BY Delivery_person_ID, delivery_category
HAVING COUNT(*) >= 3
ORDER BY Delivery_person_ID, delivery_category;

-- 5.6 Delivery partner age group vs performance
SELECT CASE
WHEN Delivery_person_Age BETWEEN 18 AND 25 THEN '18-25'
WHEN Delivery_person_Age BETWEEN 26 AND 33 THEN '26-33'
WHEN Delivery_person_Age BETWEEN 34 AND 41 THEN '34-41'
ELSE '42+' END  AS age_group,COUNT(*)  AS order_count,
ROUND(AVG(Delivery_person_Ratings), 2)  AS avg_rating,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY age_group
ORDER BY age_group;


/* ============================================================================
   SECTION 6: VEHICLE & ORDER TYPE ANALYSIS
   ============================================================================ */

-- 6.1 Average delivery time by vehicle type
SELECT Type_of_vehicle,COUNT(*)AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY Type_of_vehicle
ORDER BY avg_delivery_time_min;

-- 6.2 Vehicle condition vs delivery time and rating category
SELECT Vehicle_condition,
COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min,
SUM(CASE WHEN delivery_category = 'Poor' THEN 1 ELSE 0 END) AS poor_rated_orders
FROM delivery_data
GROUP BY Vehicle_condition
ORDER BY Vehicle_condition;

-- 6.3 Average delivery time by order type
SELECT Type_of_order,COUNT(*)  AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY Type_of_order
ORDER BY avg_delivery_time_min;

-- 6.4 Impact of order batching (multiple deliveries) on delivery time and rating
SELECT multiple_deliveries,COUNT(*) AS order_count,
ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min,
ROUND(AVG(Delivery_person_Ratings), 2) AS avg_rating
FROM delivery_data
GROUP BY multiple_deliveries
ORDER BY multiple_deliveries;


/* ============================================================================
   SECTION 7: ADVANCED / COMBINED INSIGHT QUERIES
   ============================================================================ */

-- 7.1 Worst-performing combination of city + traffic + weather
WITH condition_performance AS (
SELECT City,Road_traffic_density,Weatherconditions,
COUNT(*) AS order_count,ROUND(AVG(`Time_taken(min)`), 2) AS avg_delivery_time_min
FROM delivery_data
GROUP BY City, Road_traffic_density, Weatherconditions
HAVING COUNT(*) >= 20
)SELECT *FROM condition_performance
ORDER BY avg_delivery_time_min DESC
LIMIT 10;

-- 7.2 "Poor" rating rate across festival periods vs normal days, by city
WITH rating_flagged AS (SELECT City,Festival,CASE WHEN delivery_category = 'Poor' 
THEN 1 ELSE 0 END AS is_poorFROM delivery_data
)
SELECT
City,Festival,COUNT(*) AS order_count,
ROUND(100.0 * SUM(is_poor) / COUNT(*), 2)    
AS poor_rating_percent
FROM rating_flagged
GROUP BY City, Festival
ORDER BY City, Festival;

-- 7.3 Delivery partners performing above the overall average rating
SELECT Delivery_person_ID,
ROUND(AVG(Delivery_person_Ratings), 2) AS avg_rating
FROM delivery_data
GROUP BY Delivery_person_ID
HAVING AVG(Delivery_person_Ratings) > (
SELECT AVG(Delivery_person_Ratings) FROM delivery_data
)
ORDER BY avg_rating DESC;

-- 7.4 Does batching orders (multiple_deliveries) correlate with more "Poor" ratings?
SELECT multiple_deliveries,
delivery_category,
COUNT(*) AS order_count,
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY multiple_deliveries), 2) AS pct_within_batch_group
FROM delivery_data
GROUP BY multiple_deliveries, delivery_category
ORDER BY multiple_deliveries, delivery_category;

