-- Create and select database
CREATE DATABASE IF NOT EXISTS water_analysis;
USE water_analysis;

DROP TABLE IF EXISTS water_consumption;

-- Create main table
CREATE TABLE water_consumption (
    postal_code INT,
    area VARCHAR(100),
    consumption_class VARCHAR(20),
    total_consumption FLOAT,
    consumption_days INT,
    avg_daily_consumption FLOAT,
    connections INT,
    month_str VARCHAR(10),
    date DATE,
    year INT,
    month INT,
    consumption_per_connection_day FLOAT,
    is_anomaly BOOLEAN
);