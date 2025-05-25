--Scenario: Retail sales analytics
create schema if not exists kimball;
--dimensions
create table kimball.dim_customers (
	customer_key serial primary key,
	full_name text,
	email text,
	signup_date date 
);

create table kimball.dim_products(
	product_key serial primary key,
	name text,
	category text,
	price numeric
);

create table kimball.dim_date(
	date_key date primary key,
	day int,
	month int,
	year int,
	weekday text	
);
--facts
create table kimball.fact_sales (
	sales_id serial primary key,
	customer_key int references kimball.dim_customers(customer_key),
	product_key int references kimball.dim_products(product_key),
	date_key date references kimball.dim_date(date_key),
	quantity int,
	total_amount numeric
);

INSERT INTO kimball.dim_customers (full_name, email, signup_date) VALUES
('Alice Brown', 'alice@gmail.com', '2023-01-01'),
('David Green', 'david@gmail.com', '2023-02-01');

INSERT INTO kimball.dim_products (name, category, price) VALUES
('Headphones', 'Electronics', 100.00),
('Backpack', 'Accessories', 60.00);

INSERT INTO kimball.dim_date (date_key, day, month, year, weekday) VALUES
('2023-03-01', 1, 3, 2023, 'Wednesday'),
('2023-03-02', 2, 3, 2023, 'Thursday');

INSERT INTO kimball.fact_sales (customer_key, product_key, date_key, quantity, total_amount) VALUES
(1, 1, '2023-03-01', 1, 100.00),
(2, 2, '2023-03-02', 2, 120.00);


--question - what are the total sales for each product
select dp.name as product_name,
	sum(f.total_amount) as total_revenue
from kimball.fact_sales f
join kimball.dim_products dp on f.product_key = dp.product_key
group by dp.name

--question - show daily sales trend for March 2023
select 
	d.date_key,
	d.weekday,
	sum(f.total_amount) as daily_sales
from kimball.fact_sales f
join kimball.dim_date d on f.date_key = d.date_key
where d.year=2023 and d.month=3
group by d.date_key, d.weekday
order by d.weekday

--question - which transaction might be suspicios due to high total amount
select f.sales_id, c.full_name, p.name as product_name, f.total_amount
from kimball.fact_sales f
join kimball.dim_customers c on f.customer_key =c.customer_key
join kimball.dim_products p on f.product_key =p.product_key
where f.total_amount >10000;

--question - what is the monthly revenue per product category
select
	d.year,
	d.month,
	p.category,
	sum(f.total_amount) as monthly_rvenue
from kimball.fact_sales f 
join kimball.dim_date d on f.date_key =d.date_key
join kimball.dim_products p on f.product_key =p.product_key
group by d.year,d.month,p.category
order by d.year,d.month,p.category



