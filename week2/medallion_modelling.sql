--Scenario -- you're building a pipeline that flows raw trip logs to business dashboards for pathao

--bronze layer is the raw trip logs - unfiltered, unvalidated
create schema if not exists bronze;

create table bronze.raw_rides(
	ride_id serial primary key,
	user_id int,
	driver_id int,
	pickup_time timestamp,
	dropoff_time timestamp,
	pickup_location text,
	dropoff_location text,
	fare numeric,
	rating int
);
INSERT INTO bronze.raw_rides (user_id, driver_id, pickup_time, dropoff_time, pickup_location, dropoff_location, fare, rating) VALUES
(1, 101, '2023-05-01 08:00', '2023-05-01 08:30', 'Swayambhu', 'Airport', 300, 5), 
(2, 102, '2023-05-01 09:00', '2023-05-01 09:10', 'Baneshwor', 'Kalanki', 250, 3), 
(1, 101, '2023-05-01 10:00', '2023-05-01 10:45', 'Lubhu', 'Baneshwor', 250, 1),
(1, 101, '2023-05-01 10:00', '2023-05-01 10:45', 'Maitighar', 'Baneshwor', 1000, 1);


--silver lyaer is cleaned and strictured date
create schema if not exists silver;

create table silver.cleaned_rides as
select
	ride_id,
	user_id,
	driver_id,
	pickup_time,
	dropoff_time,
	trim(lower(pickup_location)) as pickup_location,
	trim(lower(dropoff_location)) as dropoff_location,
	fare,
	rating,
	extract(EPOCH from (dropoff_time-pickup_time))/60 as rider_duration_min,
	date(pickup_time) as rider_date,
	case
		when extract(hour from pickup_time) between 6 and 11 then 'Morning'
		when extract(hour from pickup_time) between 12 and 17 then 'Afternoon'
		when extract(hour from pickup_time) between 18 and 23 then 'Evening'
		else 'Night'
	end as ride_time_bucket,
	case when extract(epoch from(dropoff_time-pickup_time))/60 <10 then 'Short Trip' else 'Standard' end as trip_type,
	case when rating < 2 then true else false end as poor_experience_flag
from bronze.raw_rides
	
--gold layer is business-ready dashboards, reports, and KPIs
create schema if not exists gold;
--gold layer 1- how much revenue we are generating per day, and how many rider are completed?
create table gold.daily_ride_summary as
select rider_date,
count(*) as total_rides,
sum(fare) as total_revenue,
avg(fare) as abg_fare,
from silver.cleaned_rides
where fare<=100
group by rider_date
order by rider_date;

--gold layer 2- what is our ride distribution across time buckets?
create table gold.ride_volume_by_time_bucket as
select ride_time_bucket,
count(*) as total_rides,
avg(rider_duration_min) as avg_duration,
avg(fare) as avg_fare
from silver.cleaned_rides
group by rider_time_bucket
order by total_rides;

--gold layer 3- where do most rides begin?

--gold layer 4 - where are the most low-rated rides happening?

--gold layer 5 - how many short trups do we have daily?

