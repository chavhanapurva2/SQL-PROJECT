-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\admin\Documents\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Users\admin\Documents\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\admin\Documents\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
Select * from Books
WHERE genre = 'Fiction';


-- 2) Find books published after the year 1950:
Select * from Books
WHERE Published_year>1950;


-- 3) List all customers from the Canada:
SELECT * from Customers
WHERE Country ='Canada';


-- 4) Show orders placed in November 2023:
Select * from Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books available:
SELECT SUM(Stock) AS Total_stocks
FROM Books;


-- 6) Find the details of the most expensive book:
SELECT * FROM Books
ORDER BY PRICE DESC
LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE Quantity >1;


-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE TOTAL_AMOUNT >20;


-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;


-- 10) Find the book with the lowest stock:
SELECT * FROM Books
ORDER BY stock
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS Revenue
FROM Orders




--ADVANCE QUESTIONS--

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre, sum(o.quantity) AS Total_book_Sold
FROM Orders o
JOIN Books b on o.book_id = b.book_id
GROUP BY b.genre;


-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_price
FROM Books
WHERE genre='Fantasy';


-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id,c.name, count(o.order_id) AS Order_count
FROM Orders o
Join customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT (order_id)>=2;


-- 4) Find the most frequently ordered book:
SELECT o.book_id,b.title, COUNT(o.order_id) AS Order_count
from orders o
JOIN Books b on o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY Order_count DESC 
LIMIT 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC 
LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(quantity) AS Total_book_Sold
FROM orders o
JOIN books b on o.book_id=b.book_id
GROUP BY b.author;


-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c on o.customer_id=c.customer_id
WHERE o.total_amount >30;


-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id,c.name, SUM(total_amount) AS Total_Spent
FROM orders o
JOIN customers c on o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spent DESC
LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_Quantity,
   b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o on b.book_id=o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;
   





















