USE water_analysis;

-- Monthly average consumption
SELECT 
    year,
    month,
    ROUND(AVG(consumption_per_connection_day), 4) AS avg_consumption
FROM water_consumption
WHERE consumption_per_connection_day < 0.86
GROUP BY year, month
ORDER BY year, month;

-- Month-to-month change using LAG
SELECT 
    year,
    month,
    ROUND(avg_consumption, 4) AS avg_consumption,
    ROUND(
        avg_consumption - 
        LAG(avg_consumption) OVER (ORDER BY year, month),
        4
    ) AS change_from_prev_month
FROM (
    SELECT 
        year,
        month,
        AVG(consumption_per_connection_day) AS avg_consumption
    FROM water_consumption
    WHERE consumption_per_connection_day < 0.86
    GROUP BY year, month
) t
ORDER BY year, month;

-- Q1 comparison: 2024 vs 2025
SELECT 
    year,
    ROUND(AVG(consumption_per_connection_day), 4) AS avg_q1_consumption
FROM water_consumption
WHERE consumption_per_connection_day < 0.86
  AND month IN (1, 2, 3)
GROUP BY year
ORDER BY year;

-- Average consumption by class
SELECT 
    consumption_class,
    COUNT(*) AS rows_count,
    ROUND(AVG(consumption_per_connection_day), 4) AS avg_consumption
FROM water_consumption
WHERE consumption_per_connection_day < 0.86
GROUP BY consumption_class
ORDER BY avg_consumption DESC;

-- Top area and class combinations
SELECT 
    area,
    consumption_class,
    COUNT(*) AS rows_count,
    ROUND(AVG(consumption_per_connection_day), 4) AS avg_consumption
FROM water_consumption
WHERE consumption_per_connection_day < 0.86
GROUP BY area, consumption_class
HAVING COUNT(*) >= 20
ORDER BY avg_consumption DESC
LIMIT 10;

-- Monthly trend per class
SELECT 
    year,
    month,
    consumption_class,
    ROUND(AVG(consumption_per_connection_day), 4) AS avg_consumption
FROM water_consumption
WHERE consumption_per_connection_day < 0.86
GROUP BY year, month, consumption_class
ORDER BY year, month, consumption_class;