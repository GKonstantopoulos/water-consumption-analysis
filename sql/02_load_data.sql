USE water_analysis;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/temp/clean_water_data.csv'
INTO TABLE water_consumption
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Validate imported rows
SELECT COUNT(*) AS total_rows
FROM water_consumption;