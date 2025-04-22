SELECT * FROM ORDERS

-----------------------------BASIC SQL QUESTIONS--------------------------------

--1- write a sql to get all the orders where customers name has "a" as 
--second character and "d" as fourth character (58 rows)

select *
from orders
where customer_name like '_a_d%'


--2- write a sql to get all the orders placed in the month of dec 2020 (352 rows)

select *
from orders
where order_date between '2020-12-01' and '2020-12-31'

--3- write a query to get all the orders where ship_mode is neither in 
--'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)

select *
from orders
where ship_mode not in ('Standard Class','First Class') 
and ship_date > '2020-11-30'


--4- write a query to get all the orders where customer name neither start 
--with "A" and nor ends with "n" (9815 rows)

select *
from orders
where customer_name not like 'A%n'

--5- write a query to get all the orders where profit is negative (1871 rows)

select *
from orders
where profit < 0


--6- write a query to get all the orders where either quantity is less than 3 
--or profit is 0 (3348)

select *
from orders
where quantity < 3 or profit = 0

--7- your manager handles the sales for South region and he wants you to 
--create a report of all the orders in his region where some discount is 
--provided to the customers (815 rows)

select *
from orders
where region = 'South' and discount > 0


--8- write a query to find top 5 orders with highest sales in furniture category 

select top 5 *
from orders
where category = 'Furniture'
order by sales desc

--9- write a query to find all the records in technology and furniture category 
--for the orders placed in the year 2020 only (1021 rows)

select *
from orders
where category in ('Furniture', 'Technology') and 
order_date between '2020-01-01' and '2020-12-31'

--10-write a query to find all the orders where order date is in year 2020 
--but ship date is in 2021 (33 rows)

select * 
from orders
where order_date between '2020-01-01' and '2020-12-31'
and ship_date between '2021-01-01' and '2021-12-31'

----------------------AGGREGATION FUNCTIONS----------------------------------

--2- write a query to find orders where city is null (2 rows)

select *
from orders
where city is null

--3- write a query to get total profit, first order date and latest order date 
--for each category

select  category, SUM(profit) as total_profit, MIN(order_date) as first_order_date, MAX(order_date) as latest_order
from orders
group by category

--4- write a query to find sub-categories where average profit is more than 
--the half of the max profit in that sub-category

select sub_category,AVG(profit) as average_profit, MAX(profit) as max_profit
from orders
group by sub_category
having AVG(profit) > 0.5 * MAX(profit)

select sub_category
from orders
group by sub_category
having avg(profit) > max(profit)/2


--write a query to find students who have got same marks in Physics and Chemistry.

select student_id,marks,subject
from exams
where subject in ('Physics', 'Chemistry')
group by student_id,marks,subject
having COUNT(1) = 2


--6- write a query to find total number of products in each category.

select * from orders
select category, COUNT(distinct product_id ) as total_number_of_products
from orders
group by category


--7- write a query to find top 5 sub categories in west region by 
--total quantity sold

select top 5 sub_category, SUM(quantity) as total_quantity
from orders
where region = 'West'
group by sub_category
order by total_quantity desc

--8- write a query to find total sales for each region and ship mode 
--combination for orders in year 2020


select region, ship_mode, SUM(sales) as total_sales
from orders
where order_date between '2020-01-01' and '2020-12-31'
group by region, ship_mode



-------------------------------- JOINS---------------------------------

--1- write a query to get region wise count of return orders

select region, COUNT(distinct o.order_id) as count_of_returned_orders
from orders o
left join returns$ r on o.order_id = r.Order_Id
where r.Return_Reason is not null
group by region

--2- write a query to get category wise sales of orders that were not returned

select category, round(SUM(sales),4) as total_sales_of_non_returned_items
from orders o
left join returns$ r on o.order_id = r.Order_Id
where r.Return_Reason is null
group by category

--5- write a query to print sub categories where we have all 3 kinds of
--returns (others,bad quality,wrong items)

select  sub_category
from orders o
left join returns$ r on o.order_id = r.Order_Id
group by o.sub_category
having COUNT(distinct r.Return_Reason) = 3


--6- write a query to find cities where not even a single order was returned.

select city
from orders o 
left join returns$ r on o.order_id = r.Return_Reason
group by city
having COUNT(r.order_id) = 0

--7- write a query to find top 3 subcategories by sales of returned orders 
--in east region

select top 3 o.sub_category, SUM(o.sales) as total_sales
from orders o 
left join returns$ r on o.order_id = r.Order_Id 
where r.Return_Reason is not null and o.region = 'East'
group by o.sub_category
order by  total_sales desc


select top 3 sub_category,sum(o.sales) as return_sales
from orders o
inner join returns$ r on o.order_id=r.order_id
where o.region='East'
group by sub_category
order by return_sales  desc


--3- write a query to print dep name and average salary of employees in that dep .

select *
from employee

select *
from dept

select e.dept_id, AVG(e.salary) as average_salary_of_each_department
from employee e 
inner join dept d on e.dept_id = d.dep_id
group by e.dept_id


select d.dep_name,avg(e.salary) as avg_sal
from employee e
left join dept d on e.dept_id=d.dep_id
group by d.dep_name


--4- write a query to print dep names where none of the emplyees have same salary.
select *
from employee

select *
from dept


select *
from employee e 
inner join dept d on e.dept_id = d.dep_id

select d.dep_name
from employee e 
inner join dept d on e.dept_id = d.dep_id
group by d.dep_name
having COUNT(distinct e.salary) = 1

--8- write a query to print dep name for which there is no employee

select *
from employee

select *
from dept

select d.dep_name
from employee e 
right join dept d on e.dept_id = d.dep_id
where e.emp_id is null

--9- write a query to print employees name for dep id is not avaiable 
--in dept table

select *
from employee

select *
from dept

select e.emp_name
from employee e
left join dept d on e.dept_id = d.dep_id
where d.dep_id is null


---------------------- FUNCTIONS------------------------------------

--1- write a query to print emp name , their manager name and diffrence in 
--their age (in days) for employees whose year of birth is before their managers 
--year of birth


select *
from employee e1
inner join employee e2 on e1.emp_id = e2.manager_id

select e1.emp_name as employee, e2.emp_name as manager,DATEDIFF(Day, e1.dob, e2.dob ) as difference_in_age
from employee e1
inner join employee e2 on e1.emp_id = e2.manager_id
where datepart(year,e1.dob) < datepart(year,e2.dob)

--2- write a query to find subcategories who never had any return orders in 
--the month of november (irrespective of years)

select sub_category
from orders o
left join returns$ r on o.order_id =  r.Order_Id
where DATEPART(month,o.order_date) = 11
group by sub_category
having count(r.Order_Id) = 0

--3- orders table can have multiple rows for a particular order_id when customers 
--buys more than 1 product in an order.write a query to find order ids where 
--there is only 1 product bought by the customer.

select order_id
from orders
group by order_id
having COUNT( product_id) = 1

select order_id
from orders 
group by order_id
having count(1)=1


--4- write a query to print manager names along with the comma 
--separated list(order by emp salary) of all employees directly reporting to him.

select *
from employee e1
inner join employee e2 on e1.manager_id= e2.emp_id

select e2.emp_name as manager, STRING_AGG(e1.emp_name, ',') within group (order by e1.salary desc) as list_employee
from employee e1
inner join employee e2 on e1.manager_id = e2.emp_id
group by e2.emp_name

--6- write a query to print 3 columns : category, total_sales and 
--(total sales of returned orders)

select category, SUM(sales) as total_sales,
SUM(case when r.Return_Reason is null then sales end) as total_sales_of_returned_orders
from orders o
left join returns$ r on o.order_id = r.Order_Id
group by category

--7- write a query to print below 3 columns category, 
--total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)

select category, SUM(case when datepart(year,order_date) = 2019 then sales end) as total_sales_2019,
SUM(case when datepart(year,order_date) = 2020 then sales end) as total_sales_2020
from orders 
group by category

--8- write a query print top 5 cities in west region by average no of days 
--between order date and ship date.

select * from orders

select top 5 city,AVG(datediff(day,order_date, ship_date)) as average_days
from orders
where region = 'West'
group by city
order by average_days desc

select top 5 city, avg(datediff(day,order_date,ship_date) ) as avg_days
from orders
where region='West'
group by city
order by avg_days desc

--9- write a query to print emp name, manager name and 
--senior manager name (senior manager is manager's manager)

select e3.emp_name as senior_manager, e2.emp_name as manager, e1.emp_name as employee
from employee e1
inner join employee e2 on e1.manager_id = e2.emp_id
inner join employee e3 on e2.manager_id = e3.emp_id