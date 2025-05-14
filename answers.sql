-- Create normalized 1NF table
CREATE TABLE OrderProducts_1NF AS
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product
FROM 
    ProductDetail
JOIN 
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) numbers
    ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1
ORDER BY 
    OrderID, Product;

-- Create Customers table to remove partial dependency
CREATE TABLE Customers AS
SELECT DISTINCT 
    OrderID, 
    CustomerName
FROM 
    OrderDetails;

-- Create OrderItems table with complete dependency on composite key
CREATE TABLE OrderItems AS
SELECT 
    OrderID,
    Product,
    Quantity
FROM 
    OrderDetails;

-- Add primary keys (would normally do this when creating tables)
ALTER TABLE Customers ADD PRIMARY KEY (OrderID);
ALTER TABLE OrderItems ADD PRIMARY KEY (OrderID, Product);

-- Add foreign key relationship
ALTER TABLE OrderItems ADD CONSTRAINT fk_order
FOREIGN KEY (OrderID) REFERENCES Customers(OrderID);
