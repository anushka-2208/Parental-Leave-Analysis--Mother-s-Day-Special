-- Parental Leave Analysis

CREATE DATABASE Parental_Leave;
USE Parental_Leave;

-- Data Exploration:
-- Retrieving the total number of companies in the dataset.
SELECT COUNT(company) AS total_companies 
FROM parental_leave;

-- Listing all unique industries and their respective sub-industries.
SELECT DISTINCT Industry FROM parental_leave;

-- Calculating the average, minimum, and maximum number of weeks of paid maternity leave across all companies.
SELECT AVG(paid_maternity_leave) AS avg_maternity_leave,
MIN(Paid_Paternity_Leave) AS min_maternity_leave,
MAX(Paid_Paternity_Leave) AS max_maternity_leave
FROM Parental_leave;

-- Displaying the distribution of companies across different industries.
SELECT industry, COUNT(*) AS num_companies
FROM parental_leave
GROUP BY industry
ORDER BY num_companies DESC;

-- Retrieving the list of companies that offer the highest number of paid maternity leave weeks, symbolizing their support for new mothers.
SELECT company
FROM parental_leave
ORDER BY paid_maternity_leave DESC;

-- Celebrating Motherhood:
-- Identifying industries where the average number of weeks of unpaid maternity leave is lower than the average, showcasing companies that prioritize supporting new mothers financially.
WITH industry_averages AS (
  SELECT industry, AVG(paid_maternity_leave) AS avg_paid_maternity, 
  AVG(unpaid_maternity_leave) AS avg_unpaid_maternity
  FROM parental_leave
  GROUP BY industry
)
SELECT ia.industry
FROM industry_averages ia
WHERE ia.avg_unpaid_maternity < (
  SELECT AVG(unpaid_maternity_leave) AS overall_avg_unpaid
  FROM parental_leave
);

-- Empowering Mothers in the Workplace:
-- Calculate the total number of weeks of paid and unpaid maternity leave offered across all companies, reflecting the collective effort to support working mothers.
SELECT 
  SUM(paid_maternity_leave) AS total_paid_maternity,
  SUM(unpaid_maternity_leave) AS total_unpaid_maternity
FROM parental_leave;

-- Determine the industries with the highest ratio of paid to unpaid maternity leave, highlighting sectors that value providing financial support to new mothers.
WITH industry_averages AS (
  SELECT industry, AVG(paid_maternity_leave) AS avg_paid_maternity, AVG(unpaid_maternity_leave) AS avg_unpaid_maternity
  FROM parental_leave
  GROUP BY industry
)
SELECT ia.industry, ia.avg_paid_maternity / ia.avg_unpaid_maternity AS paid_to_unpaid_ratio
FROM industry_averages ia
ORDER BY paid_to_unpaid_ratio DESC;

-- Honoring Companies' Commitment to Mothers:
-- Display a ranking of companies based on their total maternity leave (paid + unpaid), acknowledging their dedication to supporting working mothers.
SELECT company,
       paid_maternity_leave + unpaid_maternity_leave AS total_maternity_leave,
       RANK() OVER (ORDER BY paid_maternity_leave + unpaid_maternity_leave DESC) AS Company_rank
FROM parental_leave
ORDER BY Company_rank;

-- Identify companies that offer more weeks of paid maternity leave than unpaid, recognizing their efforts to alleviate financial burdens for new mothers.
SELECT company
FROM parental_leave
WHERE paid_maternity_leave > unpaid_maternity_leave;

-- Promoting Gender Equality:
-- Compare industries based on their average number of weeks of paid paternity leave, emphasizing sectors that support fathers in taking an active role in childcare.
SELECT industry, AVG(paid_paternity_leave) AS avg_paternity_leave
FROM parental_leave
GROUP BY industry
ORDER BY avg_paternity_leave DESC;

-- Inspiring Change:
-- Calculate the percentage of companies in each industry that offer paid maternity leave, encouraging industries with lower percentages to prioritize supporting working mothers.
WITH industry_counts AS (
  SELECT industry,
         COUNT(CASE WHEN paid_maternity_leave > 0 THEN 1 END) AS companies_with_paid_maternity_leave,
         COUNT(*) AS total_companies
  FROM parental_leave
  GROUP BY industry
)
SELECT ic.industry,
       (companies_with_paid_maternity_leave / total_companies) * 100 AS percentage_with_paid_maternity_leave
FROM industry_counts ic
ORDER BY percentage_with_paid_maternity_leave ASC;

SELECT * FROM Parental_Leave
LIMIT 5;