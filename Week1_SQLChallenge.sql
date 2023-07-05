-- task1 Create a database to store and manage sales records. 
create schema stylexcarz_db;

-- task 2 - Create three tables to store the details of salespersons, customers, and car sales orders
use stylexcarz_db;

create table salesperson(
salespersonid int, 
salesperson_name varchar(40),
salesperson_city varchar(40),
commission_rate int,
primary key (salespersonid)
);
ALTER TABLE salesperson
 modify COLUMN salesperson_name varchar(40) NOT NULL,
 modify COLUMN salesperson_city varchar(40) NOT NULL,
 modify COLUMN commission_rate int NOT NULL;
 

create table customer(
customerid int, 
c_firstname varchar(20) not null, 
c_lastname varchar(20) not null, 
c_city varchar(40) not null, 
c_rating int not null,
constraint rating check (c_rating between 1 and 5),
primary key (customerid)
);
alter table customer 
drop constraint rating;

alter table customer 
add constraint rating check (c_rating between 1 and 10);

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where constraint_type= 'CHECK';



create table orders(
orderid int not null, 
amount int not null, 
orderdate date not null, 
salespersonid int not null, 
customerid int not null,
primary key (orderid),
foreign key (customerid) references customer(customerid),
foreign key (salespersonid) references salesperson(salespersonid)
);

-- task3 insert the data in the salespersons, customers, and orders tables
insert into salesperson (salespersonid, salesperson_name,salesperson_city, commission_rate)
 values
(1001, 'William', 'New York', 12),
(1002, 'Liam', 'New Jersey', 13),
(1003, 'Axelrod', 'San Jose', 10), 
(1004, 'James', 'San Diego', 11),
(1005, 'Fran', 'Austin', 26),
(1007, 'Oliver', 'New York', 15),
(1008, 'John', 'Atlanta', 2),
(1009, 'Charles', 'New Jersey', 2);

select *
from salesperson;

insert into customer (customerid, c_lastname, c_firstname, c_city, c_rating)
values 
(2001, 'Hoffman', 'Anny', 'New York', 1),
(2002, 'Giovanni', 'Jenny', 'New Jersey', 2),
(2003, 'Liu', 'Williams', 'San Jose', 3),
(2004, 'Grass', 'Harry', 'San Diego', 3),
(2005, 'Clemens', 'John', 'Austin', 4),
(2006, 'Cisneros', 'Fanny', 'New York', 4),
(2007, 'Pereira', 'Jonathan', 'Atlanta', 3);

select *
from customer;

insert into orders (orderid, amount, orderdate, salespersonid, customerid)
values
(3001,23,"2020-02-01​",1009,2007),
(3002,20,"2021-02-23​",1007,2007),
(3003,89,'2021-03-06​',1002,2002),
(3004,67,'2021-04-02​',1004,2002),
(3005,30,'2021-07-30​',1001,2007),
(3006,35,'2021-09-18​',1001,2004),
(3007,19,'2021-10-02​',1001,2001),
(3008,21,'2021-10-09​',1003,2003),
(3009,45,'2021-10-10',1009,2005);

delete from orders 
where orderid= 3001;

SELECT @@GLOBAL.sql_mode global, @@SESSION.sql_mode SESSION;
SET GLOBAL sql_mode = '';

select *
from orders;

-- task4 company wants to increase the commission to 15% for all those whose commission is below 15%
select *
from salesperson
where commission_rate <15;


/* Error Code: 1175. You are using safe update mode and you tried 
to update a table without a WHERE that uses a KEY column.  
To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect. */



update salesperson
set commission_rate = 15
where salespersonid in (1001,1002,1003,1004,1008,1009);

-- task 5 To prevent any loss of data, create a backup of the orders table.

create schema backup;

use backup;

create table orders_bkp
like stylexcarz_db.orders;

describe orders_bkp;

insert into 
select *
from stylexcarz_db.orders;

select *
from orders_bkp;


-- #6 Increase the rating by three points for the customers who have placed an order more than once.
-- Note:Inspect the data manually to find the customers who have made multiple orders.

select customer.customerid, count(orders.orderid)
from customer
join orders
on orders.customerid=customer.customerid
group by customer.customerid;

update customer 
set c_rating = c_rating+3
where c_rating>1;

update customer 
set c_rating = c_rating + 3
where customerid in (2002,2007);

select *
from customer;

