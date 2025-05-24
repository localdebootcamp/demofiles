-- example of sub-query
select *
from (
	select c.id as customer_id,
		c.name as customer_name,
		date_trun('month',o.ordered_at) as order_month,
		sum(i.sku) as monthly_total
	from raw_customers c
	join raw_orders o
		on c.id=o.customer
	join raw_items i
		on o.id = i.order_id
	group by c.id, customer_name, order_month
	) as monthly_revenue
order by order_month, monthly_total desc



--example of CTEs
with item_revenue as
(
select order_id, product_id, quantity, variant_price, quantity*variant_rpice as item_revenue from items i
join products p
on i.product_id = p.product_id
),

order_summary as
(
select o.id, o.customer_id, date_trunc('month', o.order_date) as ordermonth, sum(ir.item_revenue)
from orders o join item_revenue ir
on o.id=ir.order_id
group by o.id, o.customer_id, order_month
),

montly_growth as
(
order_summary
),

store_performance as (
montly_growth
),

ranked_stores as (
store_performance
)

selct mg.order_month,
	mg.monthly_revenue,
	mg.prev_month_revenue,
	mg.pct_grwoth,
	rs.store_name,
	rs.store_monthly_revenue
from monthly_growth mg
left join ranked_stores rs
on mg.order_month =rs.order_month
where rs.store_rank <=3
order by mg.order_month, rs.store_rank;


explain analyze
select * from raw_orders where order_total>100;
Seq Scan on raw_orders  (cost=0.00..2093.35 rows=61500 width=131) (actual time=0.024..35.363 rows=61465 loops=1)
  Filter: (order_total > 100)
  Rows Removed by Filter: 483
Planning Time: 0.106 ms
Execution Time: 44.155 ms


explain analyze
select id, ordered_at, order_total from raw_orders where order_total>100;
Seq Scan on raw_orders  (cost=0.00..2093.35 rows=61500 width=49) (actual time=0.032..15.018 rows=61465 loops=1)
  Filter: (order_total > 100)
  Rows Removed by Filter: 483
Planning Time: 0.069 ms
Execution Time: 17.613 ms

create index idx_high_value_order
on raw_orders(order_total)

explain analyze
select id, ordered_at, order_total from raw_orders where order_total>100;
Seq Scan on raw_orders  (cost=0.00..2093.35 rows=61492 width=49) (actual time=0.007..10.849 rows=61465 loops=1)
  Filter: (order_total > 100)
  Rows Removed by Filter: 483
Planning Time: 0.316 ms
Execution Time: 12.487 ms

\
drop index idx_high_value_order


create index idx_high_value_order
on raw_orders(order_total)
include(id, ordered_at)
where order_total>100;


explain analyze
select id, ordered_at, order_total from raw_orders where order_total>100;
Index Only Scan using idx_high_value_order on raw_orders  (cost=0.28..74.80 rows=1244 width=49) (actual time=0.022..0.282 rows=1216 loops=1)
  Heap Fetches: 0
Planning Time: 0.228 ms
Execution Time: 0.323 ms

select count(*) from raw_orders where order_total>5000



i have a table with 100 million records in cloud database
and i run select * from tablename;

select * from subquery(
select * from basetable where filter) as subquery
where filter


select c.relname, c.reltuples::BIGINT, c.relpages  from pg_class c
join pg_namespace n on n.oid=c.relnamespace
where c.relkind ='r' and n.nspname ='raw' and c.relname ='raw_orders'


vaccum analyze;

vaccum analyze raw_orders;


raw_orders
id	order_total
1	100
2	NULL
3	200



select * from raw_orders where null=null
-- return 0 rows

select * from raw_orders where order_total is NULL
-- return row with id =2


set enable_seqscan=off;
explain analyze
select id, ordered_at, order_total from raw_orders where order_total>100;

1. measure & profile
- log slow queries via postgresql's log_min_duration_statement
- use explain analyze to see actual i/o, cpu, whether your indexes are hit or not, seq scans are being done

2. schema & data modelling
- normalize but dont over normalize
- for ready heavy tables (books, members, bookings), consider normalizing or adding cached summary columns

3. smart indexing
- index foreign key columns
- covering indexes for frequent and same queries
- avoid indexing low-cardinality columns 

4. caching and materialzied views
- use application level caching using redis

5. partitioning and clustering and archiving

6. database configurations
- tune shared_buffers, work_mem, effective_cache_size to server's RAM
- adjust vaccum settings and checkpoint to avoid I/O spikes during peak hours

7. connection pooling/concurrency/read replicas/scaling

8 monitoring and feedback loop







