# E-commerce-Customer-Churn-Analysis-Using-SQL

🛒 E-Commerce Customer Churn Analysis

An end-to-end project leveraging MySQL and Power BI to explore customer retention patterns, pinpoint retention drivers, and propose intervention recommendations.

📌 Table of Contents

Project Overview

Dataset Summary
Business Questions Answered
Data Cleaning & Preparation (SQL)
Key Insights & Exploratory Findings
Power BI Dashboard

🔍 Project Overview

Customer retention is a critical success factor for the growth of any e-commerce venture. This project aims to uncover retention patterns, analyze the drivers influencing customer attrition, and identify levers to increase retention through a comprehensive analysis of customer demographics, order behavior, login activity, and service interactions.

Core Objectives:

Data cleaning and transformation of raw customer data using MySQL.
Calculation of essential retention metrics (churn rate, customer lifetime patterns, etc.).
Correlation analysis of churn drivers (warehouse distance, complaints, tenure, payment method, etc.).
Creation of an intuitive Power BI dashboard for business intelligence.

📊 Dataset Summary

Total Records: 5,630 Customers
Overall Churn Rate: 16.84% (948 Churned Customers)

Key Attributes: Customer ID, Tenure, Preferred Login Device, City Tier, Warehouse to Home Distance, Preferred Payment Mode, Gender, Satisfaction Score, Number of Address, Complaints, Coupon Usage, Order Category.

🛠️ Data Cleaning & Preparation (SQL)

Raw data underwent extensive cleaning and transformation using MySQL:
CustomerID uniqueness check: Verified the uniqueness of the CustomerID column (no duplicates found).

Missing value treatment:
Null values in the Tenure, WarehouseToHome, HourSpendOnApp, OrderAmountHikeFromlastYear, CouponUsed, OrderCount, DaySinceLastOrder columns were replaced with the corresponding mean values using a secondary temporary table.

Standardization:
Converted categorical values to standardized equivalents (Mobile Phone -> Phone, COD -> Cash on Delivery).

Binary categorization: Set values for Churn and Complain to intuitive True/False values (CustomerStatus: Stayed/Churned, ComplaintReceived: Yes/No).

Outlier handling: Corrected inconsistencies in the distance field (corrected values 126 and 127 to 26 and 27 respectively).

Feature engineering / Binned columns:
Added warehousetohome_range (Very close, Close, Moderate, Far).
Added tenure_range: (6 Months, 1 Year, 2 Years, 2+ Years).


💡 Key Insights & Exploratory Findings

Tenure & Churn: Over 30% of customers churn in the first 6 months. Churn rate declines markedly after a year of being a customer.

Customer Complaints & Churn: 53.59% of customers who churned had at least one complaint. Addressing customer dissatisfactions directly can greatly improve retention.

Delivery Range & Churn: Churn probability increases with the distance of the customer from the nearest warehouse. The further a customer's delivery range, the higher the probability of churn.

Preferred Payment Mode & Churn: Customers who chose Cash on Delivery (COD) as their preferred mode of payment recorded the highest churn rate (24.9%), followed by E-Wallet users.

Device Registration & Churn: Customers who registered 6 devices reported an exponentially higher churn rate as compared to other categories.

Gender & Churn: Male gender had a higher probability of churning than (63.29% of the churned population was Male).

Age & Churn: Unmarried / Single customers had a higher likelihood of churning.

Customer Lifetime Value: The median value of customer lifetime spans between 9 and 12 months.


🖥️ Power BI Dashboard

KPI Summary Cards: Total Customers (5.63K), Churn Rate (16.84%), Avg Addresses (4.47), Avg. Days Since Last Order (3.34), Avg. Cashback ($160).

Proportional Measures (Left Panel): Proportionate distribution of churned features (63.29% Male, 50.63% Single, 60.13% Mobile Phone buyers, 53.59% Complaints).

Comparative Bar Charts: In-depth comparison of Churn Rates by City Tier, Warehouse Distance, Tenure, Preferred Payment, and Device Count.




