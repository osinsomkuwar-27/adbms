Question 1 Range Partitioning in MySQL
CREATE DATABASE college;
USE college;

CREATE TABLE STUDENT (
    roll_no INT,
    name VARCHAR(30),
    department VARCHAR(20),
    marks INT
)
PARTITION BY RANGE (marks) (
    PARTITION p_low VALUES LESS THAN (40),
    PARTITION p_mid VALUES LESS THAN (75),
    PARTITION p_high VALUES LESS THAN (101)
);

INSERT INTO STUDENT VALUES
(1, 'Aarav', 'IT', 35),
(2, 'Priya', 'CS', 56),
(3, 'Rahul', 'ENTC', 82),
(4, 'Sneha', 'IT', 91),
(5, 'Kabir', 'CS', 72),
(6, 'Ananya', 'IT', 28),
(7, 'Rohan', 'ENTC', 67),
(8, 'Meera', 'CS', 88);

SELECT * FROM STUDENT;

UPDATE STUDENT
SET marks = 80
WHERE roll_no = 1;

SELECT * FROM STUDENT;

DELETE FROM STUDENT
WHERE roll_no = 6;

SELECT * FROM STUDENT;

SELECT * FROM STUDENT PARTITION (p_low);
SELECT * FROM STUDENT PARTITION (p_mid);
SELECT * FROM STUDENT PARTITION (p_high);

SELECT
    PARTITION_NAME,
    PARTITION_EXPRESSION,
    PARTITION_DESCRIPTION
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'college'
AND TABLE_NAME = 'student';

Question 2 Commit and Rollback in MySQL
CREATE DATABASE bank;
USE bank;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    account_name VARCHAR(30),
    balance INT
);

INSERT INTO accounts VALUES
(101, 'Rahul', 5000),
(102, 'Priya', 2000);

SELECT * FROM accounts;

START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 101;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 102;

COMMIT;

SELECT * FROM accounts;

START TRANSACTION;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 101;

UPDATE accounts
SET balance = balance + 500
WHERE account_id = 102;

ROLLBACK;

SELECT * FROM accounts;
-- we created a bank database with two accounts, Rahul and Priya. We performed a money transfer of ₹1,000 from Rahul's account to Priya's account using a transaction. First, we deducted ₹1,000 from Rahul and added ₹1,000 to Priya. We used COMMIT to permanently save the transaction. We also performed another transfer and used ROLLBACK to cancel it, which restored the original balances. This demonstrates how transactions ensure that money is transferred correctly and how transaction recovery helps protect data if a system crashes or a transaction fails midway.

Question 3 MongoDB

use college;
db.createCollection("students");
db.students.insertMany([
  {
    roll_no: 1,
    name: "Aarav",
    department: "IT",
    marks: 85,
    address: {
      city: "Pune",
      state: "Maharashtra"
    }
  },
  {
    roll_no: 2,
    name: "Priya",
    department: "CS",
    marks: 92,
    address: {
      city: "Mumbai",
      state: "Maharashtra"
    }
  },
  {
    roll_no: 3,
    name: "Rahul",
    department: "ENTC",
    marks: 76,
    address: {
      city: "Nagpur",
      state: "Maharashtra"
    }
  }
])
db.students.find()
db.createCollection("student_extra")
db.student_extra.insertMany([
  {
    roll_no: 1,
    name: "Aarav",
    hobbies: ["Cricket", "Coding"],
    skills: {
      programming: ["Java", "Python"],
      web: ["HTML", "CSS"]
    }
  },
  {
    roll_no: 2,
    name: "Priya",
    internship: "Web Development",
    certificates: ["Python", "MongoDB"],
    placement: {
      interested: true,
      package_expected: 600000
    }
  },
  {
    roll_no: 3,
    name: "Rahul",
    projects: [
      "Smart Irrigation",
      "Student Management System"
    ],
    achievements: "Winner of college hackathon"
  }
])
db.student_extra.find()
We created a MongoDB database called college and stored student information in two collections. In the first collection, all students have similar fields such as roll number, name, department, marks and address. In the second collection, we stored different information like hobbies, skills, internships and projects, where every student can have different fields. This demonstrates that MongoDB stores data in JSON-like documents and supports flexible structures without requiring every document to have the same fields.

Question 4
use college;

db.students.insertMany([
  { roll_no: 1, name: "Aarav", department: "IT", marks: 85 },
  { roll_no: 2, name: "Priya", department: "CS", marks: 92 },
  { roll_no: 3, name: "Rahul", department: "IT", marks: 76 },
  { roll_no: 4, name: "Sneha", department: "CS", marks: 88 },
  { roll_no: 5, name: "Kabir", department: "IT", marks: 79 },
  { roll_no: 6, name: "Meera", department: "ENTC", marks: 81 }
])

var mapFunction = function() {
    emit(this.department, 1);
};

var reduceFunction = function(key, values) {
    return Array.sum(values);
};

db.students.mapReduce(
    mapFunction,
    reduceFunction,
    {
        out: "department_count"
    }
)

db.department_count.find()
We implemented MapReduce in MongoDB to count students department-wise. In the Map function, we used emit() to generate the department as a key and 1 as a value for each student. In the Reduce function, we added all the values belonging to the same department using Array.sum(). Finally, we stored the result in a new collection called department_count, which shows the total number of students in each department.

Question 5 Star and Snowflake Schema in MySQL
CREATE DATABASE star_college;
USE star_college;

CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30)
);

CREATE TABLE student_dim (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    department VARCHAR(20)
);

CREATE TABLE date_dim (
    date_id INT PRIMARY KEY,
    sale_date DATE,
    month_name VARCHAR(20),
    year INT
);

CREATE TABLE sales_fact (
    sale_id INT PRIMARY KEY,
    product_id INT,
    student_id INT,
    date_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),

    FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (student_id) REFERENCES student_dim(student_id),
    FOREIGN KEY (date_id) REFERENCES date_dim(date_id)
);

INSERT INTO product_dim VALUES
(1, 'Sandwich', 'Food'),
(2, 'Coffee', 'Beverage'),
(3, 'Pizza', 'Food');

INSERT INTO student_dim VALUES
(101, 'Aarav', 'IT'),
(102, 'Priya', 'CS');

INSERT INTO date_dim VALUES
(1, '2026-11-19', 'November', 2026);

INSERT INTO sales_fact VALUES
(1, 1, 101, 1, 2, 100),
(2, 2, 102, 1, 1, 40),
(3, 3, 101, 1, 1, 150);

SELECT
    p.product_name,
    s.student_name,
    f.quantity,
    f.total_amount
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
JOIN student_dim s ON f.student_id = s.student_id;

CREATE DATABASE snow_college;
USE snow_college;

CREATE TABLE category_dim (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(30)
);

CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category_id INT,
    FOREIGN KEY (category_id)
        REFERENCES category_dim(category_id)
);

CREATE TABLE student_dim (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    department VARCHAR(20)
);

CREATE TABLE student_dim (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    department VARCHAR(20)
);

CREATE TABLE date_dim (
    date_id INT PRIMARY KEY,
    sale_date DATE,
    month_name VARCHAR(20),
    year INT
);

CREATE TABLE sales_fact (
    sale_id INT PRIMARY KEY,
    product_id INT,
    student_id INT,
    date_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),

    FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (student_id) REFERENCES student_dim(student_id),
    FOREIGN KEY (date_id) REFERENCES date_dim(date_id)
);

INSERT INTO category_dim VALUES
(1, 'Food'),
(2, 'Beverage');

INSERT INTO product_dim VALUES
(1, 'Sandwich', 1),
(2, 'Coffee', 2),
(3, 'Pizza', 1);

INSERT INTO student_dim VALUES
(101, 'Aarav', 'IT'),
(102, 'Priya', 'CS');

INSERT INTO date_dim VALUES
(1, '2026-11-19', 'November', 2026);

INSERT INTO sales_fact VALUES
(1, 1, 101, 1, 2, 100),
(2, 2, 102, 1, 1, 40),
(3, 3, 101, 1, 1, 150);

SELECT
    p.product_name,
    c.category_name,
    s.student_name,
    f.total_amount
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
JOIN category_dim c ON p.category_id = c.category_id
JOIN student_dim s ON f.student_id = s.student_id;
In Star Schema, we have one central Fact Table connected directly to Dimension Tables. For example, in a college canteen database, the sales table is connected directly to product, student and date tables. In Snowflake Schema, we further divide the dimension tables. For example, we separate the product category from the product table into another table. Star Schema is simpler and requires fewer joins, while Snowflake Schema reduces data redundancy but requires more joins.

Question 6 OLAP Architecture in MySQL

CREATE DATABASE shop;
USE shop;

CREATE TABLE SALES (
    Sale_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50),
    Quantity INT,
    Amount DECIMAL(10,2)
);

INSERT INTO SALES VALUES
(1, 'Laptop', 2, 100000),
(2, 'Mobile', 5, 75000),
(3, 'Laptop', 1, 50000),
(4, 'Headphones', 4, 8000),
(5, 'Mobile', 2, 30000),
(6, 'Headphones', 3, 6000);

SELECT * FROM SALES;

SELECT SUM(Amount) AS Total_Sales
FROM SALES;

SELECT
    Product_Name,
    SUM(Amount) AS Total_Product_Sales
FROM SALES
GROUP BY Product_Name;

OLAP is used to analyze sales data from different perspectives. It helps us calculate total sales, compare products, identify best-selling products and make better business decisions. In our example, we used SQL aggregate functions like SUM and GROUP BY to perform basic sales analysis, which is similar to the type of analysis done in OLAP systems.

Question 7 Star Schema in MySQL

-- Create database
CREATE DATABASE supermarket;
USE supermarket;

-- 1. Product Dimension Table
CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30)
);

-- 2. Customer Dimension Table
CREATE TABLE customer_dim (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(30)
);

-- 3. Time Dimension Table
CREATE TABLE time_dim (
    time_id INT PRIMARY KEY,
    sale_date DATE,
    month_name VARCHAR(20),
    year INT
);

-- 4. Fact Table
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

-- Insert Product Details
INSERT INTO product_dim VALUES
(1, 'Rice', 'Grocery'),
(2, 'Milk', 'Dairy'),
(3, 'Soap', 'Personal Care');

-- Insert Customer Details
INSERT INTO customer_dim VALUES
(101, 'Aarav', 'Pune'),
(102, 'Priya', 'Mumbai'),
(103, 'Rahul', 'Nagpur');

-- Insert Time Details
INSERT INTO time_dim VALUES
(1, '2026-11-18', 'November', 2026),
(2, '2026-11-19', 'November', 2026),
(3, '2026-11-20', 'November', 2026);

-- Insert Sales Data into Fact Table
INSERT INTO sales_fact VALUES
(1, 1, 101, 1, 2, 1200),
(2, 2, 102, 2, 3, 180),
(3, 3, 103, 2, 4, 240),
(4, 1, 102, 3, 1, 600),
(5, 2, 101, 3, 2, 120);

-- Display all tables
SELECT * FROM product_dim;
SELECT * FROM customer_dim;
SELECT * FROM time_dim;
SELECT * FROM sales_fact;

-- Analyze sales using Star Schema
SELECT
    p.product_name,
    c.customer_name,
    t.sale_date,
    f.quantity,
    f.sales_amount
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
JOIN customer_dim c ON f.customer_id = c.customer_id
JOIN time_dim t ON f.time_id = t.time_id;

-- Total Sales
SELECT SUM(sales_amount) AS total_sales
FROM sales_fact;

-- Product-wise Sales
SELECT
    p.product_name,
    SUM(f.sales_amount) AS product_total_sales
FROM sales_fact f
JOIN product_dim p ON f.product_id = p.product_id
GROUP BY p.product_name;

A Star Schema is a data warehouse model in which one central fact table is connected directly to multiple dimension tables. In our supermarket example, the sales_fact table is the fact table because it stores numerical information such as quantity and sales amount. The product_dim, customer_dim and time_dim tables are dimension tables that store descriptive information about products, customers and dates. We use joins to combine these tables and analyze sales, such as finding total sales or product-wise sales. It is useful for reporting and decision-making because the structure is simple and queries are easier to perform.

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