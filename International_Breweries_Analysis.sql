
--@block
USE International_Breweries

--@block
CREATE DATABASE International_Breweries;

--@block
CREATE TABLE tab_1(
    Sales_id INT PRIMARY KEY,
    Sales_rep VARCHAR(255),
    Emails VARCHAR(255),
    Brands VARCHAR(255),
    Plant_cost INT,
    Unit_price INT,
    Quantity INT,
    Cost INT,
    Profit INT,
    Countries TEXT,
    Region TEXT,
    Months ENUM ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
    Years YEAR
);


--@block
SHOW VARIABLES LIKE 'secure_file_priv';

--@block
--IMPORT DATA INTO TABLE
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/International_Breweries.csv'
INTO TABLE tab_1
FIELDS TERMINATED BY ','
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


--@block --SECTION A: QUESTION 1
SELECT SUM(Profit) AS Total_Profits
FROM tab_1;


--@block --FIRST PART QUESTION 2
--@block
ALTER TABLE tab_1
ADD COLUMN Territory TEXT AFTER Countries
AS(
    CASE
    WHEN Countries IN ("Ghana", "Nigeria") THEN "anglophone"
    ELSE "francophone"
    END
)STORED;


--@block --FIRST PART QUESTION 2

--@block
SELECT SUM(Profit) AS Grand_Profit, Territory
FROM tab_1
GROUP BY Territory
ORDER BY Grand_Profit DESC;



--@Block --SECTION A: QUESTION 3
SELECT SUM(Profit) AS Profits, Countries, Years
FROM(
    SELECT * FROM tab_1
    WHERE Years = "2019"
) AS subquery
GROUP BY Countries 
ORDER BY Profits DESC;


--@Block --SECTION A: QUESTION 4
SELECT SUM(Profit) AS Maximum_Profits, Years 
FROM tab_1
GROUP BY Years;


--@Block --SECTION A: QUESTION 5
SELECT  MIN(Profit) AS Profits, Months, Years
FROM tab_1
GROUP BY Months, Years
ORDER BY Profits ASC
LIMIT 1;


--@Block --SECTION A: QUESTION 6
SELECT MIN(Profit) AS Profits
FROM tab_1
WHERE Months = "December" AND Years = 2018;

--@block --SECTION A: QUESTION 7
SELECT 
    IFNULL(Months, 'TOTAL') AS Months,
    SUM(Profit) AS total_profit,
    (SUM(Profit) / (SELECT SUM(Profit) FROM tab_1 WHERE Years = 2019)) * 100 AS profit_percentage
FROM 
    tab_1
WHERE 
    Years = 2019
GROUP BY 
    Months
WITH ROLLUP;


--@Block --SECTION A: QUESTION 8
SELECT SUM(Profit) AS Total_Profits, Brands
FROM (
    SELECT * FROM tab_1
    WHERE Countries = "Senegal"
) AS subquery
GROUP BY Brands
ORDER BY Total_Profits DESC;

--@block
SELECT SUM(Profit) AS Total_Profits, Brands
FROM tab_1
GROUP BY Brands
ORDER BY Total_Profits DESC;


--@block --SECTION B: QUESTION 1
SELECT SUM(Quantity) AS Total_Consumption, Brands, Territory
FROM(
    SELECT * FROM tab_1
    WHERE Territory = "francophone"
) As subquery
GROUP BY Brands
ORDER BY Total_Consumption DESC
LIMIT 3;


--@block --SECTION B: QUESTION 2
SELECT SUM(Quantity) AS Total_Consumption, Brands, Countries
FROM(
    SELECT * FROM tab_1
    WHERE Countries = "Ghana"
) As subquery
GROUP BY Brands
ORDER BY Total_Consumption DESC
LIMIT 2;


--@block --SECTION B: QUESTION 3 PART 1
ALTER TABLE tab_1
ADD COLUMN brand_type TEXT AFTER Brands
AS(
    CASE
    WHEN Brands IN ("beta malt", "grand malt") THEN "malt"
    ELSE "beer"
    END
)STORED;


--@block --SECTION B: QUESTION 3 PART 2
SELECT * 
FROM tab_1
WHERE brand_type = "beer" AND Countries = "Nigeria"
ORDER BY Years;



--@block --SECTION B: QUESTION 4
SELECT SUM(Quantity) 
AS Total, Brands, brand_type, Territory
FROM(
    SELECT * FROM  tab_1
    WHERE (brand_type = "malt" AND Territory = "anglophone")
    AND (Years BETWEEN "2018" AND "2019")
    ) AS subquery
GROUP BY Brands
ORDER BY Total DESC
LIMIT 1;


--@block --SECTION B: QUESTION 5
SELECT SUM(Quantity) AS Best_Sellling, Brands,  Years
FROM(
    SELECT * FROM tab_1
    WHERE Countries = "Nigeria" AND Years = "2019"
    ) AS subquery
GROUP BY Brands
ORDER BY Best_Sellling
LIMIT 1;



--@block --SECTION B: QUESTION 5
SELECT SUM(Quantity) AS Best_Sellling, Brands,  Years
FROM(
    SELECT * FROM tab_1
    WHERE Countries = "Nigeria" AND Years = "2019"
    ) AS subquery
GROUP BY Brands
ORDER BY Best_Sellling
LIMIT 1;



--@block --SECTION B: QUESTION 6
SELECT SUM(Quantity) AS fave_brand, Brands, Region
FROM(
    SELECT * FROM tab_1
    WHERE Countries = "Nigeria" AND Region = "southsouth"
    ) AS subquery
GROUP BY Brands
ORDER BY fave_brand
LIMIT 1;



--@block --SECTION B: QUESTION 7
SELECT SUM(Quantity) AS Total_Consumption, brand_type, Countries
FROM(
    SELECT * FROM tab_1
    WHERE Countries = "Nigeria" AND brand_type = "beer"
    ) AS subquery
GROUP BY brand_type
ORDER BY Total_Consumption
LIMIT 1;



--@block --SECTION B: QUESTION 8
SELECT SUM(Quantity) AS Total_Consumption, Brands, Region, Countries
FROM(
    SELECT * FROM tab_1
    WHERE Countries = "Nigeria" AND Brands = "Budweiser"
    ) AS subquery
GROUP BY Region
ORDER BY Total_Consumption DESC;



--@block --SECTION B: QUESTION 9
SELECT SUM(Quantity) AS Total_Consumption, Brands, Region, Countries, Years
FROM(
    SELECT * FROM tab_1
    WHERE Countries = "Nigeria" AND Brands = "Budweiser" AND Years = "2019"
    ) AS subquery
GROUP BY Region
ORDER BY Total_Consumption DESC;


--@block --SECTION C: QUESTION 1
SELECT SUM(Quantity) AS Total_Consumption, Countries
FROM(
    SELECT * FROM tab_1
    WHERE brand_type = "beer"
    ) AS subquery
GROUP BY Countries
ORDER BY Total_Consumption DESC
LIMIT 1;


--@block --SECTION C: QUESTION 2
SELECT Sales_id, Sales_rep, SUM(Profit) AS Tot_Profits, Countries
FROM(
    SELECT * FROM tab_1
    WHERE Countries = "Senegal"
    ) AS subquery
GROUP BY Sales_id
ORDER BY Tot_Profits DESC;


--@block --SECTION C: QUESTION 3
SELECT SUM(Profit) AS Total_Profits_By_Quarter, Countries
FROM(
    SELECT * FROM tab_1
    WHERE (Years = "2019") AND (Months BETWEEN 9 AND 12)
    ) AS subquery
GROUP BY Countries
ORDER BY Total_Profits_By_Quarter DESC;



--@block
SELECT * FROM tab_1;
