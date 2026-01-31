-- basic data clean 

CREATE TABLE online_retail_clean AS
WITH

-- step 1: delete duplicated transactions
dedup1 AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY InvoiceNo, StockCode, Description, Quantity, 
                            InvoiceDate, UnitPrice, CustomerID, Country
			   ORDER BY InvoiceDate
		   ) AS rn
	FROM online_retail
),
dedup2 AS (
    SELECT InvoiceNo, StockCode, Description, Quantity, 
		   InvoiceDate, UnitPrice, CustomerID, Country
    FROM dedup1
    WHERE rn = 1
),

-- step 2: flag quantity/unit price/cancelled transactions
flag AS (
    SELECT *,
           (CASE 
			  WHEN Quantity < 0 AND InvoiceNo LIKE 'C%' THEN 'cancelled'
			  WHEN Quantity > 0 THEN 'normal'
              ELSE 'other' 
			END) AS quan_cancel_flag,
		   (CASE 
              WHEN UnitPrice < 0 THEN 'negative'
              WHEN UnitPrice = 0 THEN 'zero'
              ELSE 'normal'
			END) AS uniprice_flag
	FROM dedup2
),

-- step 3: flag customer identification
customers AS (
    SELECT *,
           (CASE 
              WHEN CustomerID = '' THEN 'anonymous'
              ELSE 'identified'
			END) AS customer_flag
	FROM flag
),

-- step 4: time consistency
dates AS (
    SELECT *,
           STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i') AS invoice_date
	FROM customers
)

SELECT InvoiceNo, StockCode, Description, invoice_date,
       Quantity, quan_cancel_flag, 
       UnitPrice, uniprice_flag,
       CustomerID, Country, customer_flag
FROM dates;

