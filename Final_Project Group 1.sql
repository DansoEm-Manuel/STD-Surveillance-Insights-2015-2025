-- =====================================
-- CREATING A DATABASE
-- =====================================

CREATE DATABASE IF NOT EXISTS Ghana_STD_Info;
USE Ghana_STD_Info;

-- =====================================
-- CREATING A DATABASE
-- =====================================
DROP TABLE IF EXISTS Health_Dataset;

CREATE TABLE Health_Dataset(
    Year INT NOT NULL,
    Country VARCHAR(100) NOT NULL,
    Region VARCHAR(200) NOT NULL,
    Disease VARCHAR(200) NOT NULL,
    Age_Group VARCHAR(20) NOT NULL,
    Gender VARCHAR(100) NOT NULL,
    Population INT NOT NULL,
    Total_Cases INT NOT NULL,
    New_Cases INT NOT NULL,
    Deaths INT NOT NULL,
    Prevalence_Rate DECIMAL(10,2) NOT NULL,
    Incidence_Rate DECIMAL(10,2) NOT NULL,
    Tested_Population INT NOT NULL,
    Vaccinated_Population INT NOT NULL,
    Treatment_Coverage DECIMAL(10,2) NOT NULL
);

-- =====================================
-- LOADING CSV DATA FROM LOCAL PC TO SQL 
-- =====================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Health Dataset.csv'
INTO TABLE Health_Dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS

(@Year,
 @Country,
 @Region,
 @Disease,
 @Age_Group,
 @Gender,
 @Population,
 @Total_Cases,
 @New_Cases,
 @Deaths,
 @Prevalence_Rate,
 @Incidence_Rate,
 @Tested_Population,
 @Vaccinated_Population,
 @Treatment_Coverage)

SET
Year = @Year,
Country = @Country,
Region = @Region,
Disease = @Disease,
Age_Group = @Age_Group,
Gender = @Gender,
Population = @Population,
Total_Cases = @Total_Cases,
New_Cases = @New_Cases,
Deaths = @Deaths,

-- Clean percentage fields
Prevalence_Rate = REPLACE(@Prevalence_Rate, '%', ''),
Treatment_Coverage = REPLACE(@Treatment_Coverage, '%', ''),

Incidence_Rate = @Incidence_Rate,
Tested_Population = @Tested_Population,
Vaccinated_Population = @Vaccinated_Population;

-- =====================================
-- QUERRYING THE DATASET
-- =====================================

-- 1. Displaying the entire dataset  

SELECT * FROM Health_Dataset;

-- 2. Which country in Africa recorded the highest Cases of STD in a single year?

SELECT *
FROM Health_Dataset
WHERE Region = 'Africa'
AND Total_Cases = (
    SELECT MAX(Total_Cases)
    FROM Health_Dataset
    WHERE Region = 'Africa'
    );

-- 3. What are the Top 5 countries with the highest prevalence rate 

SELECT Country, SUM(Prevalence_Rate) AS Total_Prevalence_Rate
FROM Health_Dataset
WHERE Region = 'Africa'
GROUP BY Country
ORDER BY Total_Prevalence_Rate DESC
LIMIT 5;

-- 4. What are the top 5 counties in Africa with the highest total cases of STD within the last decade 

SELECT Country, SUM(Total_Cases) AS Total_Cases
FROM Health_Dataset
WHERE Region = 'Africa'
GROUP BY Country
ORDER BY Total_Cases DESC
LIMIT 5;