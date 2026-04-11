create  DATABASE churn_analysis;
USE churn_analysis;

RENAME TABLE `wa_fn-usec_-telco-customer-churn` TO churn_data;
DESCRIBE churn_data;
SELECT 
    *
FROM
    churn_data
WHERE
    customerID IS NULL OR gender IS NULL
        OR tenure IS NULL;
SELECT 
    COUNT(*)
FROM
    churn_data;
SELECT 
    Churn, COUNT(*) AS total_customers
FROM
    churn_data
GROUP BY Churn;
SELECT 
    Churn,
    COUNT(*) * 100.0 / (SELECT 
            COUNT(*)
        FROM
            churn_data) AS churn_percentage
FROM
    churn_data
GROUP BY Churn;
SELECT 
    gender, Churn, COUNT(*) AS total
FROM
    churn_data
GROUP BY gender , Churn;
SELECT 
    Contract, Churn, COUNT(*) AS total
FROM
    churn_data
GROUP BY Contract , Churn;
SELECT 
    InternetService, Churn, COUNT(*) AS total
FROM
    churn_data
GROUP BY InternetService , Churn;
SELECT 
    Churn,
    AVG(MonthlyCharges) AS avg_monthly,
    AVG(TotalCharges) AS avg_total
FROM
    churn_data
GROUP BY Churn;
SELECT 
    customerID, MonthlyCharges, tenure
FROM
    churn_data
WHERE
    Churn = 'Yes'
ORDER BY MonthlyCharges DESC
LIMIT 10;
SELECT 
    CASE
        WHEN tenure < 12 THEN 'New'
        WHEN tenure BETWEEN 12 AND 24 THEN 'Mid'
        ELSE 'Loyal'
    END AS customer_segment,
    Churn,
    COUNT(*) AS total
FROM
    churn_data
GROUP BY customer_segment , Churn;

WITH ranked_customers AS (
    SELECT customerID,
           MonthlyCharges,
           RANK() OVER (ORDER BY MonthlyCharges DESC) AS rnk
    FROM churn_data
)
SELECT *
FROM ranked_customers
WHERE rnk <= 5;

CREATE VIEW churn_summary AS
    SELECT 
        Churn, COUNT(*) AS total_customers
    FROM
        churn_data
    GROUP BY Churn;

USE churn_analysis;

DROP VIEW IF EXISTS churn_summary;

CREATE VIEW churn_summary AS
    SELECT 
        Churn, COUNT(*) AS total_customers
    FROM
        churn_data
    GROUP BY Churn;

SELECT 
    *
FROM
    churn_summary;
    
    
# 1. Month-to-month contract customers have highest churn.
2. Customers with higher monthly charges are more likely to churn.
3. New customers (low tenure) show higher churn rate.
4. Internet service type impacts churn behavior.
5. A small segment of customers contributes to high revenue but also churn risk.
