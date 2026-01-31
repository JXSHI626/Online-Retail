-- basic quality check

-- step 1: check data completeness
-- total row count
SELECT COUNT(*) AS cnt_total 
FROM online_retail;
-- unique transaction count
WITH unique_count AS (
    SELECT *, 
           COUNT(*) OVER (
               PARTITION BY InvoiceNo, StockCode, Description, Quantity, 
                            InvoiceDate, UnitPrice, CustomerID, Country
		   ) AS cnt
    FROM online_retail
)
SELECT SUM(CASE WHEN cnt = 1 THEN 1 ELSE 0 END) AS unique_trans
FROM unique_count;
-- duplicate transaction count
WITH duplicate_count AS (
    SELECT 1 
    FROM online_retail
    GROUP BY InvoiceNo, StockCode, Description, Quantity,
             InvoiceDate, UnitPrice, CustomerID, Country
	HAVING COUNT(*) > 1
)
SELECT COUNT(*) AS duplicate_trans
FROM duplicate_count;
-- missing CustomerID
SELECT COUNT(*) AS missing_customer_cnt
FROM online_retail
WHERE CustomerID IS NULL;
SELECT COUNT(*) AS anonymous_cnt
FROM online_retail
WHERE CustomerID = '';

-- step 2: check data type
-- invalid datetamp count
SELECT COUNT(*) AS invalid_date_cnt
FROM online_retail
WHERE STR_TO_DATE(
        InvoiceDate,
        '%m/%d/%Y %H:%i'
	  ) IS NULL;
-- abnormal date
SELECT MIN(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS min_date,
       MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS max_date
FROM online_retail;

-- step 3: check range of quantitative features
-- negative Quantity and UnitPrice count
SELECT SUM(CASE WHEN Quantity = 0 THEN 1 ELSE 0 END) AS non_quan_cnt,
       SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) AS neg_quan_cnt
FROM online_retail; -- quantity <= 0
SELECT SUM(CASE WHEN UnitPrice = 0 THEN 1 ELSE 0 END) AS non_uniprice_cnt,
       SUM(CASE WHEN UnitPrice < 0 THEN 1 ELSE 0 END) AS neg_uniprice_cnt
FROM online_retail; -- unit price <= 0
SELECT COUNT(*) AS invalid_trans_cnt
FROM online_retail
WHERE Quantity <= 0 AND UnitPrice <= 0; -- intersection

-- step 4: check business semantics
-- cancelled transactions count
SELECT COUNT(*) AS cancel_trans_cnt
FROM online_retail
WHERE InvoiceNo LIKE 'C%';
-- cancelled transactions with negative quantity
SELECT COUNT(*) AS intersected_trans
FROM online_retail
WHERE InvoiceNo LIKE 'C%' 
AND Quantity < 0;
-- each invoice with several products
SELECT COUNT(DISTINCT InvoiceNo) AS invoice_cnt
FROM online_retail;

-- step 5: check text quality
-- each product with different descriptions
WITH tmp AS (
    SELECT StockCode
    FROM online_retail
    GROUP BY StockCode
    HAVING COUNT(DISTINCT Description) > 1
)
SELECT COUNT(*) AS inconsistent_product_cnt
FROM tmp;
-- manual check
SELECT DISTINCT StockCode, Description
FROM online_retail
WHERE StockCode IN (
    SELECT StockCode
    FROM online_retail
    GROUP BY StockCode
    HAVING COUNT(DISTINCT Description) > 1
)
ORDER BY StockCode, Description
LIMIT 20;
-- empty descriptions or blank
SELECT SUM(Description IS NULL) AS null_des_cnt,
       SUM(Description = '') AS empty_des_cnt,
       SUM(TRIM(Description) = '') AS blank_like_des_cnt
FROM online_retail;

-- step 6: check Country
-- check Country classification
SELECT DISTINCT Country
FROM online_retail
ORDER BY Country ASC;
-- unspecified transactions and percentage in total transactions
SELECT COUNT(*) AS unspecified_cnt,
	   COUNT(*) * 1.0 / (SELECT COUNT(*) FROM online_retail) AS unspecified_ratio
FROM online_retail
WHERE Country = 'Unspecified';
-- country distribution
SELECT Country, COUNT(*) AS country_cnt
FROM online_retail
GROUP BY Country
ORDER BY country_cnt DESC;