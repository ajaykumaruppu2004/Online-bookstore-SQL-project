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

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'D:\Online book store data\Books.csv' 
CSV HEADER;

COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\Online book store data\Customers.csv' 
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'D:\Online book store data\Orders.csv' 
CSV HEADER;

--1 Retrieve all the Books in Mystery Genre
SELECT * FROM Books 
WHERE Genre = 'Mystery';

--2 Retrieve all the Books that are published after 1975
SELECT * FROM Books 
WHERE Published_year > 1975;

--3 Retrieve all the Orders placed in December 2023
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-12-01' AND '2023-12-31';

--4 Retrieve Total Stocks of Books Available
SELECT SUM(stock) AS total_stock
FROM Books;

--5 Find all the details of the Most Expensive Book 
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

--6 Find the Book with Lowest Stock
SELECT * FROM Books ORDER BY price ASC LIMIT 1;

--7 Retrieve the customers who ordered more than 5 books
SELECT * FROM Orders 
WHERE quantity > 5; 

--8 Total No.of Books Sold for each Genre 
SELECT B.genre,SUM(O.quantity) AS Total_books
FROM Orders O
JOIN Books B
ON O.Book_id = B.Book_id
GROUP BY B.Genre;

--9 Find the Average price of Books in Romance Genre
SELECT AVG(price) AS average_price
FROM Books
WHERE Genre = 'Romance';

--10 LIST the customers who placed at least 6 orders
SELECT O.Customer_id, C.name, COUNT(O.Order_id) AS Order_count
FROM orders O
JOIN Customers C ON O.customer_id = C.customer_id
GROUP BY O.customer_id,C.name
HAVING COUNT(Order_id)>=6;

--11 Find the most frequently ordered book
SELECT O.Book_id,B.title, COUNT (O.Order_id) AS Order_count
FROM Orders O
JOIN Books B
ON O.Book_id = B.Book_id
GROUP BY B.title,O.book_id
ORDER BY Order_count DESC LIMIT 1;

--12 Find TOP 5 most expensive Books in Science Fiction Genre
SELECT * FROM Books
WHERE Genre  = 'Science Fiction'
ORDER BY price DESC LIMIT 5;

--13 Retrieve the total Quantity of books sold by each author

SELECT B.author, SUM(O.quantity) AS Books_sold_by_each_author
FROM ORDERS O
JOIN Books B 
ON O.Book_id = B.Book_id 
GROUP BY B.author;

--14 List the cities Where customers spent more than or equal to $70
SELECT DISTINCT C.city,Total_amount
FROM orders O
JOIN customers C 
ON O.customer_id = C.customer_id
WHERE O.total_amount > 70;

--15 Find the customer who spent most on orders
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM 
orders o
JOIN 
customers c
ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;

--16 Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;


