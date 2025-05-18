-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    signup_date DATE DEFAULT CURRENT_DATE
);

-- Create transactions table
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    amount NUMERIC(10, 2),
    status VARCHAR(20) CHECK (status IN ('success', 'failed', 'pending')),
    tx_date DATE DEFAULT CURRENT_DATE
);

-- Insert mock users
INSERT INTO users (full_name, email) VALUES
('Alice Sharma', 'alice@example.com'),
('Bob Lama', 'bob@gmail.com'),
('Charlie Rai', 'charlie@outlook.com');

-- Insert mock transactions
INSERT INTO transactions (user_id, amount, status) VALUES
(1, 120.50, 'success'),
(1, 80.00, 'failed'),
(2, 200.00, 'success'),
(3, 60.00, 'pending');


--select all users
select * from users;

--select specific columns
select id, full_name, email, signup_date from users;

-- where clause: filter by signup_date
select * from users where signup_date=current_date;

--join: list all transactions with user names
select u.full_name, t.amount
from users u
join transactions t on u.id=t.user_id
where t.status='success'

--group by: count number of transactions per user
select user_id, count(*) as total_transactions
from transactions
group by user_id;

--group by: with aggregations
select user_id, sum(amount) as total_transactions
from transactions
group by user_id;

--query users who spend more than 300
select user_id, sum(amount) as total_spent
from transactions
where status='success'
group by user_id
having sum(amount) > 300;

--query user names and their total spend
select u.full_name, count(*) as tx_count, sum(t.amount) as total_spent
from users u
join transactions t on u.id=t.user_id
where t.status='success'
group by u.full_name
having sum(t.amount) > 200

-- inner join (only matching rows)
-- fetch users who have transactions

select u.full_name, t.amount
from users u
join transactions t on u.id=t.user_id


-- left join (all users and matching transactions)
-- fetch all users, and their transactions if available

select u.full_name, t.amount
from users u
left join transactions t on u.id=t.user_id

-- right join (all transactions and the matching users)
-- fetch all transactions and their matching users if available

select u.full_name, t.amount
from transactions t
right join users u on u.id=t.user_id

-- full outer join (Everything)
-- show everything from both tables

select u.full_name, t.amount
from users u
full join transactions t on u.id=t.user_id
