Question 1 
CREATE DATABASE employee_db;
USE employee_db;

CREATE TABLE EMPLOYEE (
    emp_id INT,
    emp_name VARCHAR(30),
    department VARCHAR(20),
    salary INT,
    PRIMARY KEY (emp_id, salary)
)
PARTITION BY RANGE (salary) (
    PARTITION p_low VALUES LESS THAN (30000),
    PARTITION p_mid VALUES LESS THAN (60000),
    PARTITION p_high VALUES LESS THAN (MAXVALUE)
);

INSERT INTO EMPLOYEE VALUES
(101, 'Aarav', 'IT', 25000),
(102, 'Priya', 'HR', 45000),
(103, 'Rahul', 'Sales', 75000),
(104, 'Sneha', 'IT', 28000),
(105, 'Kabir', 'Finance', 55000),
(106, 'Meera', 'HR', 90000),
(107, 'Rohan', 'Sales', 35000),
(108, 'Ananya', 'IT', 65000);

SELECT * FROM EMPLOYEE;

UPDATE EMPLOYEE
SET salary = 80000
WHERE emp_id = 101 AND salary = 25000;

UPDATE EMPLOYEE
SET salary = 20000
WHERE emp_id = 105 AND salary = 55000;

DELETE FROM EMPLOYEE
WHERE emp_id = 104 AND salary = 28000;

SELECT * FROM EMPLOYEE PARTITION (p_low);

SELECT * FROM EMPLOYEE PARTITION (p_mid);

SELECT * FROM EMPLOYEE PARTITION (p_high);

SELECT PARTITION_NAME, PARTITION_DESCRIPTION
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'employee_db'
AND TABLE_NAME = 'employee';
Range partitioning divides a table into multiple partitions based on a specified range of values. In this practical, we partitioned the Employee table according to salary. Employees earning below ₹30,000 are stored in p_low, employees earning between ₹30,000 and ₹60,000 are stored in p_mid, and employees earning ₹60,000 or more are stored in p_high. When we perform INSERT, UPDATE, or DELETE operations, MySQL automatically manages the partitions. This improves data organization and can improve query performance when queries filter by salary.

Question 2 Rollback 

CREATE DATABASE ticket_booking;
USE ticket_booking;

CREATE TABLE seats (
    seat_no VARCHAR(10) PRIMARY KEY,
    status VARCHAR(20)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    seat_no VARCHAR(10),
    amount INT,
    payment_status VARCHAR(20)
);

INSERT INTO seats VALUES
('A1', 'AVAILABLE'),
('A2', 'AVAILABLE'),
('A3', 'AVAILABLE'),
('A4', 'AVAILABLE');

SELECT * FROM seats;
SELECT * FROM bookings;

-- SUCCESSFUL BOOKING USING COMMIT

START TRANSACTION;

UPDATE seats
SET status = 'BOOKED'
WHERE seat_no = 'A1';

INSERT INTO bookings VALUES
(101, 'Aarav', 'A1', 250, 'PAID');

COMMIT;

SELECT * FROM seats;
SELECT * FROM bookings;

-- FAILED BOOKING USING ROLLBACK

START TRANSACTION;

UPDATE seats
SET status = 'BOOKED'
WHERE seat_no = 'A2';

INSERT INTO bookings VALUES
(102, 'Priya', 'A2', 250, 'PAID');

ROLLBACK;

SELECT * FROM seats;
SELECT * FROM bookings;

Question 3 

use library

db.structured_books.drop()
db.unstructured_books.drop()

db.createCollection("structured_books")
db.createCollection("unstructured_books")

db.structured_books.insertMany([
    {
        book_id: 101,
        title: "DBMS",
        author: "Raghu Ramakrishnan",
        category: "Database",
        price: 550,
        publisher: {
            name: "McGraw Hill",
            year: 2022
        }
    },
    {
        book_id: 102,
        title: "Operating System Concepts",
        author: "Abraham Silberschatz",
        category: "Operating System",
        price: 700,
        publisher: {
            name: "Wiley",
            year: 2021
        }
    },
    {
        book_id: 103,
        title: "Computer Networks",
        author: "Andrew Tanenbaum",
        category: "Networking",
        price: 650,
        publisher: {
            name: "Pearson",
            year: 2020
        }
    }
])

db.unstructured_books.insertMany([
    {
        book_id: 201,
        title: "Artificial Intelligence",
        author: "Stuart Russell",
        category: "AI",
        price: 800,
        publisher: "Pearson",
        reviews: ["Excellent book", "Very informative"],
        edition: 3,
        available: true
    },
    {
        book_id: 202,
        title: "Python Programming",
        author: "Guido van Rossum",
        category: "Programming",
        price: 450,
        publisher: {
            name: "O'Reilly",
            location: "USA"
        },
        tags: ["Python", "Coding", "Beginner"],
        discount: 10
    },
    {
        book_id: 203,
        title: "Machine Learning",
        author: "Tom Mitchell",
        category: "ML",
        price: 900,
        publisher: "McGraw Hill",
        course: "Data Science",
        rating: 4.8,
        notes: "Recommended for advanced students"
    }
])

db.structured_books.find()

db.unstructured_books.find()

Question 4
use library

db.books.drop()

db.books.insertMany([
    {book_id: 1, title: "DBMS", category: "Database"},
    {book_id: 2, title: "SQL", category: "Database"},
    {book_id: 3, title: "Python", category: "Programming"},
    {book_id: 4, title: "Java", category: "Programming"},
    {book_id: 5, title: "AI", category: "Artificial Intelligence"},
    {book_id: 6, title: "ML", category: "Artificial Intelligence"},
    {book_id: 7, title: "OS", category: "Operating System"}
])

var mapFunction = function() {
    emit(this.category, 1);
};

var reduceFunction = function(key, values) {
    return Array.sum(values);
};

db.books.mapReduce(
    mapFunction,
    reduceFunction,
    {out: "book_category_count"}
)

db.book_category_count.find()
MapReduce is a data-processing model that works in two main steps: Map and Reduce. The Map function generates key-value pairs from input data, and the Reduce function combines values having the same key to produce the final result. For example, in a library database, MapReduce can count books category-wise. Apache Cassandra is a distributed NoSQL wide-column database known for scalability, high availability, fault tolerance, replication and fast data handling. It can be used in IoT applications to store large amounts of real-time sensor data across multiple servers.

Question 5 
-- ==============================
-- STAR SCHEMA
-- ==============================

CREATE DATABASE star_schema_db;
USE star_schema_db;

CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30)
);

CREATE TABLE customer_dim (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(30)
);

CREATE TABLE time_dim (
    time_id INT PRIMARY KEY,
    sale_date DATE,
    month_name VARCHAR(20),
    year INT
);

CREATE TABLE sales_fact (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    time_id INT,
    quantity INT,
    sales_amount DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (customer_id) REFERENCES customer_dim(customer_id),
    FOREIGN KEY (time_id) REFERENCES time_dim(time_id)
);

INSERT INTO product_dim VALUES
(1, 'Rice', 'Grocery'),
(2, 'Milk', 'Dairy'),
(3, 'Soap', 'Personal Care');

INSERT INTO customer_dim VALUES
(101, 'Aarav', 'Pune'),
(102, 'Priya', 'Mumbai'),
(103, 'Rahul', 'Nagpur');

INSERT INTO time_dim VALUES
(1, '2026-11-18', 'November', 2026),
(2, '2026-11-19', 'November', 2026),
(3, '2026-11-20', 'November', 2026);

INSERT INTO sales_fact VALUES
(1, 1, 101, 1, 2, 1200),
(2, 2, 102, 2, 3, 180),
(3, 3, 103, 2, 4, 240),
(4, 1, 102, 3, 1, 600),
(5, 2, 101, 3, 2, 120);

SELECT * FROM product_dim;
SELECT * FROM customer_dim;
SELECT * FROM time_dim;
SELECT * FROM sales_fact;

SELECT 
    p.product_name,
    p.category,
    c.customer_name,
    c.city,
    t.sale_date,
    f.quantity,
    f.sales_amount
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
JOIN customer_dim c ON f.customer_id = c.customer_id
JOIN time_dim t ON f.time_id = t.time_id;

SELECT SUM(sales_amount) AS total_sales
FROM sales_fact;

SELECT p.category, SUM(f.sales_amount) AS category_sales
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
GROUP BY p.category;


-- ==============================
-- SNOWFLAKE SCHEMA
-- ==============================

CREATE DATABASE snowflake_schema_db;
USE snowflake_schema_db;

CREATE TABLE category_dim (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(30)
);

CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category_dim(category_id)
);

CREATE TABLE city_dim (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(30)
);

CREATE TABLE customer_dim (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES city_dim(city_id)
);

CREATE TABLE time_dim (
    time_id INT PRIMARY KEY,
    sale_date DATE,
    month_name VARCHAR(20),
    year INT
);

CREATE TABLE sales_fact (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    time_id INT,
    quantity INT,
    sales_amount DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (customer_id) REFERENCES customer_dim(customer_id),
    FOREIGN KEY (time_id) REFERENCES time_dim(time_id)
);

INSERT INTO category_dim VALUES
(1, 'Grocery'),
(2, 'Dairy'),
(3, 'Personal Care');

INSERT INTO product_dim VALUES
(1, 'Rice', 1),
(2, 'Milk', 2),
(3, 'Soap', 3);

INSERT INTO city_dim VALUES
(1, 'Pune'),
(2, 'Mumbai'),
(3, 'Nagpur');

INSERT INTO customer_dim VALUES
(101, 'Aarav', 1),
(102, 'Priya', 2),
(103, 'Rahul', 3);

INSERT INTO time_dim VALUES
(1, '2026-11-18', 'November', 2026),
(2, '2026-11-19', 'November', 2026),
(3, '2026-11-20', 'November', 2026);

INSERT INTO sales_fact VALUES
(1, 1, 101, 1, 2, 1200),
(2, 2, 102, 2, 3, 180),
(3, 3, 103, 2, 4, 240),
(4, 1, 102, 3, 1, 600),
(5, 2, 101, 3, 2, 120);

SELECT * FROM category_dim;
SELECT * FROM product_dim;
SELECT * FROM city_dim;
SELECT * FROM customer_dim;
SELECT * FROM time_dim;
SELECT * FROM sales_fact;

SELECT 
    p.product_name,
    cat.category_name,
    c.customer_name,
    ci.city_name,
    t.sale_date,
    f.quantity,
    f.sales_amount
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
JOIN category_dim cat ON p.category_id = cat.category_id
JOIN customer_dim c ON f.customer_id = c.customer_id
JOIN city_dim ci ON c.city_id = ci.city_id
JOIN time_dim t ON f.time_id = t.time_id;

SELECT SUM(sales_amount) AS total_sales
FROM sales_fact;

SELECT cat.category_name, SUM(f.sales_amount) AS category_sales
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
JOIN category_dim cat ON p.category_id = cat.category_id
GROUP BY cat.category_name;
Star Schema consists of one central fact table directly connected to dimension tables, giving it a star-like structure. Snowflake Schema is an extension of Star Schema in which dimension tables are further divided into smaller normalized tables. Star Schema has fewer joins, is simpler and offers faster query performance, while Snowflake Schema reduces redundancy and improves data organization but requires more joins.

Question 6
CREATE DATABASE shop;
USE shop;

CREATE TABLE ORDERS (
    Order_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50),
    Customer_Name VARCHAR(50),
    Quantity INT,
    Total_Amount DECIMAL(10,2)
);

INSERT INTO ORDERS VALUES
(1, 'Laptop', 'Aarav', 2, 100000),
(2, 'Mobile', 'Priya', 3, 45000),
(3, 'Laptop', 'Rahul', 1, 50000),
(4, 'Headphones', 'Sneha', 4, 8000),
(5, 'Mobile', 'Kabir', 2, 30000),
(6, 'Headphones', 'Meera', 3, 6000);

-- (a) Display all order records
SELECT * FROM ORDERS;

-- (b) Calculate total order amount
SELECT SUM(Total_Amount) AS Total_Order_Amount
FROM ORDERS;

-- (c) Display total order amount product-wise
SELECT Product_Name, SUM(Total_Amount) AS Product_Total
FROM ORDERS
GROUP BY Product_Name;
OLAP is used to analyse large amounts of data for decision-making. It helps businesses view sales data product-wise, customer-wise, or time-wise, identify trends, compare performance, and make better business decisions.

Question 7
CREATE DATABASE library_star;
USE library_star;

CREATE TABLE Book_Dim (
    book_id INT PRIMARY KEY,
    book_name VARCHAR(50),
    author VARCHAR(50),
    category VARCHAR(30)
);

CREATE TABLE Member_Dim (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(50),
    department VARCHAR(30)
);

CREATE TABLE Date_Dim (
    date_id INT PRIMARY KEY,
    borrow_date DATE,
    month_name VARCHAR(20),
    year INT
);

CREATE TABLE Borrow_Fact (
    borrow_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    date_id INT,
    borrow_count INT,
    fine_amount DECIMAL(8,2),
    FOREIGN KEY (book_id) REFERENCES Book_Dim(book_id),
    FOREIGN KEY (member_id) REFERENCES Member_Dim(member_id),
    FOREIGN KEY (date_id) REFERENCES Date_Dim(date_id)
);

INSERT INTO Book_Dim VALUES
(1, 'DBMS', 'Korth', 'Database'),
(2, 'Operating System', 'Galvin', 'OS'),
(3, 'Computer Networks', 'Tanenbaum', 'Networking'),
(4, 'Python Programming', 'Guido', 'Programming');

INSERT INTO Member_Dim VALUES
(101, 'Aarav', 'IT'),
(102, 'Priya', 'CS'),
(103, 'Rahul', 'ENTC'),
(104, 'Sneha', 'IT');

INSERT INTO Date_Dim VALUES
(1, '2026-11-17', 'November', 2026),
(2, '2026-11-18', 'November', 2026),
(3, '2026-11-19', 'November', 2026),
(4, '2026-11-20', 'November', 2026);

INSERT INTO Borrow_Fact VALUES
(1, 1, 101, 1, 1, 0),
(2, 2, 102, 1, 1, 20),
(3, 3, 103, 2, 1, 0),
(4, 1, 104, 3, 1, 10),
(5, 4, 101, 4, 1, 0),
(6, 2, 103, 4, 1, 30);

SELECT * FROM Book_Dim;
SELECT * FROM Member_Dim;
SELECT * FROM Date_Dim;
SELECT * FROM Borrow_Fact;

SELECT 
    b.book_name,
    b.author,
    m.member_name,
    m.department,
    d.borrow_date,
    f.borrow_count,
    f.fine_amount
FROM Borrow_Fact f
JOIN Book_Dim b ON f.book_id = b.book_id
JOIN Member_Dim m ON f.member_id = m.member_id
JOIN Date_Dim d ON f.date_id = d.date_id;

SELECT b.book_name, SUM(f.borrow_count) AS total_borrowed
FROM Borrow_Fact f
JOIN Book_Dim b ON f.book_id = b.book_id
GROUP BY b.book_name;

SELECT m.member_name, SUM(f.fine_amount) AS total_fine
FROM Borrow_Fact f
JOIN Member_Dim m ON f.member_id = m.member_id
GROUP BY m.member_name;
Star Schema is a data warehouse design in which a central fact table is connected directly to dimension tables. In our library example, Borrow_Fact is the fact table that stores borrowing transactions, borrow count and fine amount. Book_Dim stores book details, Member_Dim stores member details, and Date_Dim stores date information. This structure resembles a star and is used for easy and faster data analysis, such as finding the most borrowed books or total fines collected.

Question 8
use college

db.students.drop()

db.students.insertMany([
  {roll_no:1,name:"Aarav",department:"IT",marks:85,age:20,city:"Pune",skills:["Java","MongoDB","Python"],address:{city:"Pune",state:"Maharashtra"}},
  {roll_no:2,name:"Priya",department:"CS",marks:92,age:21,city:"Mumbai",skills:["Python","AI","Java"],address:{city:"Mumbai",state:"Maharashtra"}},
  {roll_no:3,name:"Rahul",department:"ENTC",marks:67,age:20,city:"Nagpur",skills:["C","Embedded","IoT"],address:{city:"Nagpur",state:"Maharashtra"}},
  {roll_no:4,name:"Sneha",department:"IT",marks:78,age:21,city:"Pune",skills:["JavaScript","React","MongoDB"],address:{city:"Pune",state:"Maharashtra"}},
  {roll_no:5,name:"Kabir",department:"CS",marks:55,age:19,city:"Nashik",skills:["C++","Python"],address:{city:"Nashik",state:"Maharashtra"}},
  {roll_no:6,name:"Meera",department:"IT",marks:95,age:22,city:"Mumbai",skills:["Java","AI","Cloud"],address:{city:"Mumbai",state:"Maharashtra"}},
  {roll_no:7,name:"Rohan",department:"ENTC",marks:73,age:20,city:"Pune",skills:["IoT","Python","Arduino"],address:{city:"Pune",state:"Maharashtra"}},
  {roll_no:8,name:"Ananya",department:"CS",marks:88,age:21,city:"Nagpur",skills:["AI","Machine Learning","Python"],address:{city:"Nagpur",state:"Maharashtra"}},
  {roll_no:9,name:"Vikram",department:"IT",marks:42,age:19,city:"Nashik",skills:["HTML","CSS"],address:{city:"Nashik",state:"Maharashtra"}},
  {roll_no:10,name:"Isha",department:"CS",marks:81,age:20,city:"Pune",skills:["Java","SQL","Python"],address:{city:"Pune",state:"Maharashtra"}}
])

db.students.find()

db.students.find({marks:{$gt:80}})

db.students.find({marks:{$gte:60,$lte:90}})

db.students.find({department:{$in:["IT","CS"]}})

db.students.find({department:{$ne:"IT"}})

db.students.find({$and:[{department:"IT"},{marks:{$gt:75}}]})

db.students.find({$or:[{department:"CS"},{marks:{$gt:90}}]})

db.students.find({marks:{$not:{$lt:70}}})

db.students.find({name:{$regex:"^A",$options:"i"}})

db.students.find({skills:{$in:["Python"]}})

db.students.find({age:{$gt:20},city:"Pune"})

db.students.find({}, {name:1,department:1,marks:1,_id:0})

db.students.find().sort({marks:-1})

db.students.find().sort({marks:-1}).limit(3)

db.students.find({"address.city":"Pune"})

db.students.find({age:{$exists:true}})

db.students.find({marks:{$gt:75}}).sort({marks:-1})

db.students.countDocuments({department:"IT"})

db.students.aggregate([{$group:{_id:"$department",average_marks:{$avg:"$marks"}}}])

db.students.aggregate([{$group:{_id:"$department",highest_marks:{$max:"$marks"}}}])

We created a MongoDB database named college and inserted student documents containing details such as name, department, marks, age, skills and address. We performed complex queries using comparison operators, logical operators, array operators and pattern matching. We also used sorting, projection, limiting and aggregation to filter, organize and analyze student data.