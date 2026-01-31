-- create database 
CREATE DATABASE retail_db;
USE retail_db;

-- DROP TABLE IF EXISTS online_retail;

-- import dataset into table online_retail
CREATE TABLE online_retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate VARCHAR(50),
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(50)
);
SET GLOBAL local_infile = 1;
-- import data from XLSX files

-- clear table
-- TRUNCATE TABLE online_retail;

LOAD DATA LOCAL INFILE 'C:/Users/shi.LAPTOP-HKEK6JTA/OneDrive/Desktop/CaseStudy_OnlineRetail/dataset/OnlineRetail.csv'
INTO TABLE online_retail
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, 
 InvoiceDate, UnitPrice, CustomerID, Country);
