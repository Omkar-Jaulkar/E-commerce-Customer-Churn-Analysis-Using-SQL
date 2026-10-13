--                            		***** E-commerce Customers Churn Analysis *****

-- DATA CLEANING --

-- 1] FIND THE TOTAL NUMBER OF CUSTOMER ?

SELECT DISTINCT
    COUNT(*) AS TOTAL_CUSTOMERS
FROM ecommerce_churn;

-- ANS := 5630

-- 2] CHECK IS THERE ANY DUPLICATE ROWS

SELECT 
	CUSTOMERID,
    COUNT(*) AS COUNT
FROM ecommerce_churn
GROUP BY CUSTOMERID
HAVING COUNT > 1;

-- ANS := THERE ARE NO DUPLICATE ROWS

-- 3] Check for null values count for columns with null values

SELECT 'Tenure' AS COLUMN_NAME, COUNT(*) AS NULL_VALUE_COUNT 
FROM ecommerce_churn WHERE Tenure IS NULL
UNION
SELECT 'WarehouseToHome' AS COLUMN_NAME , COUNT(*) AS NULL_VALUE_COUNT 
FROM ecommerce_churn WHERE WarehouseToHome IS NULL
UNION
SELECT 'HourSpendOnApp' AS COLUMN_NAME ,COUNT(*) AS NULL_VALUE_COUNT 
FROM ecommerce_churn WHERE HourSpendOnApp IS NULL
UNION
SELECT 'OrderAmountHikeFromlastYear' AS COLUMN_NAME , COUNT(*) AS NULL_VALUE_COUNT 
FROM ecommerce_churn WHERE OrderAmountHikeFromlastYear IS NULL
UNION
SELECT 'CouponUsed' AS COLUMN_NAME , COUNT(*) AS NULL_VALUE_COUNT 
FROM ecommerce_churn WHERE CouponUsed IS NULL
UNION
SELECT 'OrderCount' AS COLUMN_NAME , COUNT(*) AS NULL_VALUE_COUNT 
FROM ecommerce_churn WHERE OrderCount IS NULL
UNION
SELECT 'DaySinceLastOrder' AS COLUMN_NAME , COUNT(*) AS NULL_VALUE_COUNT 
FROM ecommerce_churn WHERE DaySinceLastOrder IS NULL;

-- 4} HANDLING NULL VALUES
-- REPLACING NULL VALUES WITH MEAN OF THE COLUMN

CREATE TABLE ecommerce_churn_2 
LIKE ecommerce_churn;

INSERT ecommerce_churn_2
SELECT * FROM ecommerce_churn;


SET SQL_SAFE_UPDATES = 0;


UPDATE ecommerce_churn
SET Tenure = (SELECT ROUND(AVG(Tenure)) FROM ecommerce_churn_2)
WHERE Tenure IS NULL;

UPDATE ecommerce_churn
SET WarehouseToHome = (SELECT ROUND(AVG(WarehouseToHome)) FROM ecommerce_churn_2)
WHERE WarehouseToHome IS NULL;

UPDATE ecommerce_churn
SET HourSpendOnApp = (SELECT ROUND(AVG(HourSpendOnApp)) FROM ecommerce_churn_2)
WHERE HourSpendOnApp IS NULL;

UPDATE ecommerce_churn
SET OrderAmountHikeFromlastYear = (SELECT ROUND(AVG(OrderAmountHikeFromlastYear)) FROM ecommerce_churn_2)
WHERE OrderAmountHikeFromlastYear IS NULL;

UPDATE ecommerce_churn
SET CouponUsed = (SELECT ROUND(AVG(CouponUsed)) FROM ecommerce_churn_2)
WHERE CouponUsed IS NULL;

UPDATE ecommerce_churn
SET OrderCount = (SELECT ROUND(AVG(OrderCount)) FROM ecommerce_churn_2)
WHERE OrderCount IS NULL;

UPDATE ecommerce_churn
SET DaySinceLastOrder = (SELECT ROUND(AVG(DaySinceLastOrder)) FROM ecommerce_churn_2)
WHERE DaySinceLastOrder IS NULL;


-- 5] CREATE A NEW COLUMN BASED ON THE VALUES OF CHURN COLUMN
-- THERE ARE 2 VALUES IN THE CHURN COLUMN 0 AND 1 WHERE 0 MEANS STAYED AND 1 MEANS CHURNED.
-- CREATING A COLUMN 'customer_status' THAT SHOWS STAYED AND CHURNED INSTEAD OF 0 AND 1

ALTER TABLE ecommerce_churn
ADD CustomerStatus VARCHAR(20);

UPDATE ecommerce_churn
SET CustomerStatus =
	CASE WHEN Churn = 0 THEN 'Stayed'
		 WHEN Churn = 1 THEN 'Churned'
	END;
    
    
-- 6] CREATE A NEW COLUMN BASED ON THE VALUES OF THE COMPLAIN COLUMN
-- AGAIN THRE ARE 2 VALUES IN THE COMPLAIN COLUMN 0 AND 1 WHERE 0 MEANS NO AND 1 MEANS YES
-- CREATING A COLUMN 'ComplaintReceived' THAT SHOES YES AND NO INSTEAD OF 0 AND 1

ALTER TABLE ecommerce_churn
ADD ComplaintReceived VARCHAR(10);

UPDATE ecommerce_churn
SET ComplaintReceived =
	CASE WHEN Complain = 1 THEN 'Yes'
		 WHEN Complain = 0 THEN 'No'
	END;


-- 7] CHECKING VALUES FROM EACH COLUMN FOR CORRECTNESS AND ACCURACY

-- a) CHECK DISTINCT VALUES IN THE PreferredLoginDevice COLUMN

SELECT DISTINCT PreferredLoginDevice FROM ecommerce_churn;

-- "Mobile Phone" AND "Phone" ARE THE SAME THING SO I WILL REPLACE 'MOBILE PHONE' WITH 'PHONE' 

UPDATE ecommerce_churn
SET PreferredLoginDevice = 'Phone'
WHERE PreferredLoginDevice = 'Mobile Phone';

-- b)  CHECK DISTINCT VALUES IN THE PreferedOrderCat COLUMN

SELECT DISTINCT PreferredPaymentMode FROM ecommerce_churn;

-- "Cash on Delivery" AND "COD" ARE THE SAME THING SO I WILL REPLACE 'COD' WITH 'Cash on Delivery'

UPDATE ecommerce_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

-- c) CHECK DISTINCT VALUES IN THE PreferedOrderCat COLUMN

SELECT DISTINCT PreferedOrderCat FROM ecommerce_churn;

-- "Mobile Phone" AND "Phone" ARE THE SAME THING SO I WILL REPLACE 'MOBILE PHONE' WITH 'PHONE' 

UPDATE ecommerce_churn
SET PreferedOrderCat = 'Mobile'
WHERE PreferedOrderCat =  'Mobile Phone';

-- d) CHECK DISTINCT VALUES IN THE WarehouseToHome COLUMN

SELECT DISTINCT WarehouseToHome FROM ecommerce_churn ORDER BY WarehouseToHome;

-- THER ARE 2 VALUES '126' AND '127' THAT COULD BE OUTLIERS BECAUSE OF DATA ENTRY ERROR.
-- SO I WILL CORRECT IT WITH '26' AND '27' RESPECTIVELY

UPDATE ecommerce_churn
SET WarehouseToHome = 26
WHERE WarehouseToHome = 126;

UPDATE ecommerce_churn
SET WarehouseToHome = 27
WHERE WarehouseToHome = 127;

-- ********************************************************************************

-- DATA EXPLORATION AND ANSWERING BUSINESS QUESTIONS --

-- Q.1] What is the overall customer churn rate?

SELECT 
	TotalNumberofCustomers, 
	TotalNumberofChurnedCustomers,
	CAST((TotalNumberofChurnedCustomers * 1.0 / TotalNumberofCustomers * 1.0)*100 AS DECIMAL(10,2)) AS Churnrate
FROM
(SELECT COUNT(*) AS TotalNumberofCustomers
FROM ecommerce_churn) AS Total,
(SELECT COUNT(*) AS TotalNumberofChurnedCustomers
FROM ecommerce_churn
WHERE CustomerStatus = 'churned') AS Churned;

-- Ans :- Churn rate is 16.84%.


-- Q.2] How does the churn rate vary based on the preferred login device?

SELECT
	PreferredLoginDevice,
	ROUND((SUM(Churn) / COUNT(*))*100,2) AS churnrate
FROM ecommerce_churn
GROUP BY PreferredLoginDevice
ORDER BY Churnrate DESC;

-- Ans :- Computers account for the highest churn rate with 19.83% and then phones with 15.62%.


-- Q.3]  What is the distribution of customers across different city tiers?

SELECT 
	citytier, 
	COUNT(*) AS TotalCustomer, 
	SUM(Churn) AS ChurnedCustomers, 
	ROUND(SUM(churn) / COUNT(*) * 100 , 2) AS ChurnRate
FROM ecommerce_churn
GROUP BY citytier
ORDER BY churnrate DESC;

-- Ans :- City tier 3 has the highest churn rate with 21.37% , followed by city tier 2 and then city tier 1 has the least churn rate.


-- Q.4]  Is there any correlation between the warehouse-to-home distance and customer churn?

ALTER TABLE ecommerce_churn
ADD warehousetohome_range VARCHAR(50);

UPDATE ecommerce_churn
SET warehousetohome_range =
CASE 
    WHEN warehousetohome <= 10 THEN 'Very close distance'
    WHEN warehousetohome > 10 AND warehousetohome <= 20 THEN 'Close distance'
    WHEN warehousetohome > 20 AND warehousetohome <= 30 THEN 'Moderate distance'
    WHEN warehousetohome > 30 THEN 'Far distance'
END;

SELECT 
	warehousetohome_range,
	COUNT(*) AS TotalCustomer,
	SUM(Churn) AS CustomerChurn,
	ROUND(SUM(Churn) / COUNT(*) * 100 ,2) AS Churnrate
FROM ecommerce_churn
GROUP BY warehousetohome_range
ORDER BY Churnrate DESC;

-- Ans :- The churn rate is increasing as distance increases.


-- Q.5] Which is the most prefered payment mode among churned customers?

SELECT
	PreferredPaymentMode,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(Churn)/COUNT(*) * 100 , 2) AS Churnrate
FROM ecommerce_churn
GROUP BY PreferredPaymentMode
ORDER BY Churnrate DESC;

-- Ans :- The most prefered payment mode among churned customers is Cash on Delivery (24.90%).


-- Q.6] What is the typical tenure for churned customers?

ALTER TABLE ecommerce_churn
ADD tenure_range VARCHAR(50);

UPDATE ecommerce_churn
SET tenure_range = 
	CASE 
		WHEN tenure <= 6 THEN '6 Months'
		WHEN tenure > 6 AND tenure <= 12 THEN '1 Year'
		WHEN tenure > 12 AND tenure <= 24 THEN '2 Years'
		WHEN tenure > 24 THEN '2+ years'
	END;
    
SELECT
	tenure_range,
    COUNT(*) AS ToatlCustomers,
	ROUND(SUM(Churn) * 1.0/ COUNT(*) * 100 , 2) AS Churnrate
FROM ecommerce_churn
GROUP BY tenure_range
ORDER BY Churnrate DESC;

-- Ans :- Most customers churned within a 6 months tenure period


-- Q.7] Is there any difference in churn rate between male and female customers?

SELECT 
	Gender,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(Churn) / COUNT(*) * 100 , 2) AS Churnrate
FROM ecommerce_churn
GROUP BY Gender
ORDER BY Churnrate DESC;

-- Ans :- The churn rate is higher among men than among women.


-- Q.8] How does the average time spent on the app differ for churned and non-churned customers?

SELECT 
	CustomerStatus,
    ROUND(AVG(HourSpendOnApp) , 2) AS Avg_TimeSpent
FROM ecommerce_churn
GROUP BY CustomerStatus;

-- Ans :- There is no difference between the average time spent on the app for churned and non-churned customers.


-- Q.9] Does the number of registered devices impact the likelihood of churn?

SELECT 
	NumberOfDeviceRegistered,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(Churn) / COUNT(*) * 100 , 2) AS Churnrate
FROM ecommerce_churn
GROUP BY NumberOfDeviceRegistered
ORDER BY Churnrate DESC;

-- Ans :- As the number of registered devices increseas the churn rate increases. 


-- Q.10] Which order category is most prefered among churned customers?

SELECT 
	PreferedOrderCat,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(Churn) / COUNT(*) * 100 , 2 ) AS Churnrate
FROM ecommerce_churn
GROUP BY PreferedOrderCat
ORDER BY Churnrate DESC;

-- Ans :- Mobile phone category has the highest churn rate and grocery has the least churn rate


-- Q.11]  Is there any relationship between customer satisfaction scores and churn?

SELECT 
	SatisfactionScore,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(Churn) / COUNT(*) * 100 , 2) AS Churnrate
FROM ecommerce_churn
GROUP BY SatisfactionScore
ORDER BY Churnrate DESC;

-- Ans :- The highest churn rate occurred at a satisfaction score of 5, while the lowest was observed at a score of 1.


-- Q.12] Does the marital status of customers influence churn behavior?

SELECT 
	MaritalStatus,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(Churn) / COUNT(*) * 100 , 2) AS Churnrate 
FROM ecommerce_churn
GROUP BY MaritalStatus
ORDER BY Churnrate DESC;

-- Ans :- Single customers have the highest churn rate while married customers have the least churn rate.



-- Q.13] How many addresses do churned customers have on average?

SELECT 
	ROUND(AVG(NumberOfAddress)) AS Avg_NumberOfAddress
FROM ecommerce_churn
WHERE CustomerStatus = 'Churned';

-- Ans :-  On an average, churned customers have '4' addresses.


-- Q.14] Does customer complaints influence churned behavior?

SELECT 
	ComplaintReceived,
    COUNT(*) AS TotalCustomers,
    ROUND(SUM(Churn)  / COUNT(*) * 100 , 2) AS Churnrate
FROM ecommerce_churn
GROUP BY ComplaintReceived
ORDER BY Churnrate DESC;

-- Ans :- Customers with complaints have the highest churn rate.


-- Q.15]  How does the usage of coupons differ between churned and non-churned customers?

SELECT 
	CustomerStatus, 
    SUM(CouponUsed) AS TotalCouponUsed
FROM ecommerce_churn
GROUP BY CustomerStatus
ORDER BY TotalCouponUsed DESC;

SELECT * FROM ecommerce_churn;

-- Ans :- Churned customers used less coupons in comparison to non churned customers.


-- =============================================================================================================== --
