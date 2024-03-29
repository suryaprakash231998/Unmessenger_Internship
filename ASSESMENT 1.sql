CREATE DATABASE ORG;
USE ORG;
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
Name VARCHAR(255),
Email VARCHAR(255),
JoinDate DATE
);
CREATE TABLE Products (
ProductID INT PRIMARY KEY,
Name VARCHAR(255),
Category VARCHAR(255),
Price DECIMAL(10, 2)
);
CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
TotalAmount DECIMAL(10, 2),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails (
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
PricePerUnit DECIMAL(10, 2),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES
(101, 'Ellie Goulding', 'elliegouldingsinger@gmail.com', '2023-09-01'),
(102, 'Dwayne Johnson', 'dwaynejohnson@gmail.com', '2023-09-02'),
(103, 'ED Sheeran', 'edsheeransinger@gmail.com', '2023-09-03'),
(104, 'Virat Kohli', 'viratkohli@gmail.com', '2023-09-05'),
(105, 'Rahul Chettri', 'rahulchettri@gmail.com', '2023-09-10'),
(106, 'Johny Deep', 'johnydeepactor@gmail.com', '2023-09-13'),
(107, 'Vin Diesel', 'vindieselactor@gmail.com', '2023-09-15'),
(108, 'John Cena', 'johncenasuperstar@gmail.com', '2023-09-18'),
(109, 'Dua Lipa', 'dualipasinger@gmail.com', '2023-09-20'),
(110, 'Jubin Nautiyal', 'jubinnautiyal@gmail.com', '2023-09-21');

INSERT INTO Products (ProductID, Name, Category, Price) VALUES
(11, 'Laptop', 'Electronics', 9999.99),
(12, 'Smartphone', 'Electronics', 10999.99),
(13, 'Washing Machine', 'Electronics', 8999.99),
(14, 'Backpack', 'Accessories', 1999.99),
(15, 'MAC Lipstick', 'Cosmetics', 5999.99),
(16, 'Handbag', 'Accessories', 9599.99),
(17, 'Sneakers', 'Footwear', 7999.99),
(18, 'Kurta Pyjama', 'Clothing', 5499.99),
(19, 'Sofa', 'Furniture', 19999.99),  
(20, 'Wall Painting', 'Home Decor', 5499.99);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1, 103, '2023-10-15', 21999.98),
(2, 102, '2023-10-17', 3999.98),
(3, 105, '2023-10-20', 17999.97), 
(4, 101, '2023-10-22', 21999.96),
(5, 104, '2023-10-23', 19199.98),
(6, 107, '2023-10-26', 19999.99),
(7, 106, '2023-11-10', 27499.95),
(8, 105, '2023-11-19', 31999.96), 
(9, 103, '2023-11-23', 29999.97),
(10, 108, '2023-11-21', 8999.99);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity,
PricePerUnit) VALUES
(1, 1, 12, 2, 10999.99),
(2, 2, 14, 2, 3999.99),
(3, 3, 15, 1, 5999.99),
(4, 4, 18, 4, 5499.99),
(5, 5, 16, 2, 9599.99),
(6, 6, 19, 1, 19999.99),
(7, 7, 20, 5, 5499.99),
(8, 8, 17, 4, 7999.99),
(9, 9, 11, 3, 9999.99),
(10, 10, 13, 1, 8999.99);

-- After Executing the above query, Answer the following questions with
-- writing the appropriate queries.
-- 1. Basic Queries:
-- 1.1. List all customers.
select * from customers;

-- 1.2. Show all products in the 'Electronics' category.
select * from products where category = 'Electronics';

-- 1.3. Find the total number of orders placed.
select count(*) as total_orders_placed from orders;

-- 1.4. Display the details of the most recent order.
select OrderDate from orders order by OrderDate desc limit 1;

-- 2. Joins and Relationships:
-- 2.1. List all products along with the names of the customers who ordered them.
SELECT Products.Name, Customers.Name FROM Products INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
     
-- 2.2. Show orders that include more than one product.
SELECT Orders.OrderID, COUNT(OrderDetails.OrderDetailID) AS num_products FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID GROUP BY Orders.OrderID HAVING COUNT(OrderDetails.OrderDetailID) > 1;

-- 2.3. Find the total sales amount for each customer.
SELECT Customers.CustomerID, Customers.Name, SUM(Orders.TotalAmount) AS total_sales_amount
FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.Name;

-- 3. Aggregation and Grouping:
-- 3.1. Calculate the total revenue generated by each product category.
SELECT Category, SUM(Price) AS total_revenue
FROM Products
GROUP BY Category;

-- 3.2. Determine the average order value.
SELECT AVG(TotalAmount) AS average_order_value
FROM Orders;

-- 3.3. Find the month with the highest number of orders.

SELECT MONTH(OrderDate) AS month, COUNT(*) AS order_count FROM Orders GROUP BY month ORDER BY order_count DESC LIMIT 1;

-- 4. Subqueries and Nested Queries:

-- 4.1. Identify customers who have not placed any orders.
SELECT * FROM Customers WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

-- 4.2. Find products that have never been ordered.
SELECT * FROM Products WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails);

-- 4.3. Show the top 3 best-selling products.
SELECT  Products.Name,SUM(OrderDetails.Quantity) AS total_quantity_sold FROM  Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID GROUP BY  Products.Name ORDER BY  total_quantity_sold DESC LIMIT  3;

-- 5. Date and Time Functions:

-- 5.1. List orders placed in the last month.
SELECT * FROM Orders WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 5.2. Determine the oldest customer in terms of membership duration.
SELECT * FROM Customers ORDER BY JoinDate LIMIT 1;

-- 6. Advanced Queries:

-- 6.1. Rank customers based on their total spending.
SELECT CustomerID, Name, SUM(TotalAmount) AS total_spending FROM Orders JOIN Customers USING (CustomerID) GROUP BY CustomerID, Name ORDER BY total_spending DESC;

-- 6.2. Identify the most popular product category.
SELECT Category, COUNT(*) AS total_products FROM Products GROUP BY  Category ORDER BY  total_products DESC
LIMIT 1;

-- 6.3. Calculate the month-over-month growth rate in sales.
SELECT MONTH(OrderDate) AS month, SUM(TotalAmount) AS total_sales FROM Orders GROUP BY month ORDER BY month;

-- 7. Data Manipulation and Updates:


-- 7.1. Add a new customer to the Customers table.
INSERT INTO
  Customers (CustomerID, Name, Email, JoinDate)
VALUES
  (111,'Taylor Swift','taylorswift@gmail.com','2023-09-25');
-- 7.2. Update the price of a specific product.
UPDATE Products
SET
  Price = 7999.99
WHERE
  ProductID = 11;
