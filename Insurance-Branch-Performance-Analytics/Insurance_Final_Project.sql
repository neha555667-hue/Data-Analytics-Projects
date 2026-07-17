select * from additional_field;

Use insurance;
# Total Policy Count
SELECT COUNT(DISTINCT `Policy ID`) AS totalPolicy
FROM policy_data;
-- 5000

# Total Revenue
SELECT SUM(`Amount`) AS totalRevenue
FROM invoice;
-- 12.26 million

# Total Claim Amount
SELECT 
    SUM(IFNULL(`Claim Amount`, 0)) AS totalClaimAmount
FROM claims;
-- 251.38 million.

# Total Customers
SELECT COUNT(DISTINCT `Customer ID`) AS totalCustomer
FROM customer_information;
-- 5000

# Age Bucket Wise Policy
SELECT 
    CASE 
        WHEN c.Age < 25 THEN 'Under 25'
        WHEN c.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN c.Age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS ageBucket,
    COUNT(DISTINCT p.`Policy ID`) AS policyCount
FROM policy_data p
JOIN customer_information c
ON p.`Customer ID` = c.`Customer ID`
GROUP BY ageBucket;
-- The 60+ age group has the highest number of policies at 1807
-- Followed by 41–60 with 1461
-- Then 25–40 with 1260
-- And Under 25 with 472

# Gender Wise Policy Count
SELECT 
    c.Gender,
    COUNT(DISTINCT p.`Policy ID`) AS policyCount
FROM policy_data p
JOIN customer_information c
ON p.`Customer ID` = c.`Customer ID`
GROUP BY c.Gender;
-- Male: 1677
-- Female: 1624
-- Other: 1699

# Policy Type Wise Policy Count
SELECT 
    `Policy Type`,
    COUNT(DISTINCT `Policy ID`) AS policyCount
FROM policy_data
GROUP BY `Policy Type`;
-- Health policies lead with 1316
-- Followed by Property, Life, and Auto, all with similar counts

# Policies Expiring This Year
SELECT 
    COUNT(DISTINCT `Policy ID`) AS expiringPolicies
FROM policy_data
WHERE YEAR(`Policy End Date`) = YEAR(CURDATE());
-- 453 policies expiring this year

# Premium Growth Rate
# Year-wise Premium
SELECT 
    YEAR(`Policy Start Date`) AS year,
    SUM(`Premium Amount`) AS totalPremium
FROM policy_data
GROUP BY YEAR(`Policy Start Date`)
ORDER BY year;

# Growth Rate Calculation
SELECT 
    year,
    totalPremium,
    LAG(totalPremium) OVER (ORDER BY year) AS previousYearPremium,
    ROUND(
        ((totalPremium - LAG(totalPremium) OVER (ORDER BY year)) / 
        LAG(totalPremium) OVER (ORDER BY year)) * 100, 2
    ) AS growthRatePercent
FROM (
    SELECT 
        YEAR(`Policy Start Date`) AS year,
        SUM(`Premium Amount`) AS totalPremium
    FROM policy_data
    GROUP BY year
) t;

# Claim Status Wise Policy Count
SELECT 
    `Claim Status`,
    COUNT(DISTINCT `Policy ID`) AS policyCount
FROM claims
GROUP BY `Claim Status`;
-- Approved: 1459
-- Pending: 1405
-- Denied: 1391

# Payment Status Wise Policy Count
SELECT 
    `Payment Status`,
    COUNT(DISTINCT `Policy ID`) AS policyCount
FROM payment_history
GROUP BY `Payment Status`;
-- Failed payments: 1978
-- Successful payments: 1952
