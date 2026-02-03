use hotel;
show tables;
desc hotels;
desc reviews;
desc users;

-- changing the datatype of reviewdate from text to  date

SET SQL_SAFE_UPDATES = 0;

update reviews
set review_date = str_to_date(review_date,'%d-%m-%Y');

alter table reviews
modify review_date date;

-- changing joining date from text to date data type

update users
set join_date = str_to_date(join_date,'%d-%m-%Y');

alter table users
modify join_date date;

-- assigning primary key and foreign key

alter table hotels
add primary key (hotel_id);
alter table users
add primary key (user_id);
alter table reviews
add primary key (review_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_hotel
FOREIGN KEY (hotel_id)
REFERENCES hotels(hotel_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_hotels
FOREIGN KEY (user_id)
REFERENCES users(user_id);

-- exploring tables

select * from hotels;
select * from reviews;
select * from users;

-- PRIMARY EDA

-- total number of hotels
select count(*) as hotel_count
from hotels;

-- citys where our hotels are working
select distinct city as city
from hotels;
select count(distinct city) as city
from hotels;

-- country where our hotels are working
select distinct country as country
from hotels;
select count( distinct country) as country
from hotels;

-- how many years reviews have
select year(review_date) as years
from reviews
group by years
order by years;

-- genders of users
select user_gender 
from users
group by user_gender;

-- traveller type of users
select traveller_type
from users
group by traveller_type;

-- age groups of users
select age_group 
from users
group by age_group;

-- AGGREGATE

-- total count of reviews
select count(review_id) as total_review
from reviews;

-- total count of users 
select count(distinct user_id) as total_users
from users;

-- gender wise count of users
select 
user_gender,count(*) as total_users
from users
group by user_gender;

-- traveller type wise count of users
select 
traveller_type,count(*) as total_users
from users
group by traveller_type;

-- comparision (DATE)

-- review count as per years
select year(review_date) as years,
count(review_id) as reviews
from reviews
group by years
order by years;

-- count of reviews based on month
SELECT
    MONTH(review_date) AS months,
    MONTHNAME(review_date) AS monthnames,
    COUNT(user_id) AS reviews
FROM reviews
GROUP BY months, monthnames
ORDER BY months, monthnames;

-- year wise join of users

SELECT
	YEAR(join_date) AS years,
	count(user_id) AS users
FROM users
GROUP BY years
ORDER BY years;

-- count of users based on months
SELECT
    MONTH(join_date) AS months,
    MONTHNAME(join_date) AS monthnames,
    COUNT(user_id) AS users
FROM users
GROUP BY months, monthnames
ORDER BY months, monthnames;

SELECT
    YEAR(join_date) AS years,
    MONTH(join_date) AS months,
    MONTHNAME(join_date) AS monthnames,
    COUNT(user_id) AS users
FROM users
GROUP BY years, months, monthnames
ORDER BY years, months;

select * from reviews;

-- yoy user growth rate

WITH yoy AS (
    SELECT
        YEAR(join_date) AS years,
        COUNT(user_id) AS users
    FROM users
    GROUP BY years
)
SELECT
    years,
    users,
    LAG(users, 1) OVER (ORDER BY years) AS previous_year_users,
    users - LAG(users, 1) OVER (ORDER BY years) AS user_change,
    ((users - LAG(users, 1) OVER (ORDER BY years)) / 
      LAG(users, 1) OVER (ORDER BY years)) * 100 AS yoy_growth_pct
FROM yoy
ORDER BY years;

SELECT * FROM reviews;

-- CITY WISE COMPARISION
SELECT
h.city,
round(avg(r.score_overalL),2) AS avg_overall_score 
FROM hotels h
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY h.city
ORDER BY avg_overall_score desc;

-- top 5 citys having high rating

WITH citys AS (
SELECT
h.city as city,
round(avg(r.score_overalL),2) AS avg_overall_score 
FROM hotels h
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY h.city
ORDER BY avg_overall_score desc)

SELECT
city,
avg_overall_score,
dense_rank() OVER (ORDER BY avg_overall_score desc ) AS top_ranks
FROM citys
LIMIT 5;

-- low performing 5 hostels in citys 

WITH citys AS (
SELECT
h.city as city,
round(avg(r.score_overalL),2) AS avg_overall_score 
FROM hotels h
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY h.city
ORDER BY avg_overall_score desc)

SELECT
city,
avg_overall_score,
dense_rank() OVER (ORDER BY avg_overall_score asc) AS top_ranks
FROM citys
LIMIT 5;

-- top 5 performing hotels

SELECT
h.hotel_name,
round(avg(r.score_overall),2) as avg_score_overall
FROM hotels h
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY h.hotel_name
ORDER BY avg_score_overall desc
LIMIT 5;

-- low performing hotels

SELECT
h.hotel_name,
round(avg(r.score_overall),2) as avg_score_overall
FROM hotels h
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY h.hotel_name
ORDER BY avg_score_overall asc
LIMIT 5;

-- hotels scores

SELECT
	h.hotel_id,
	h.hotel_name,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM hotels h
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY h.hotel_name,h.hotel_id
ORDER BY avg_score desc;

-- city wise

SELECT
	h.city,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM hotels h
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY h.city
ORDER BY avg_score desc;

-- gender wise
SELECT
	user_gender,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM users u
LEFT JOIN reviews r
ON (u.user_id=r.user_id)
GROUP BY user_gender
ORDER BY avg_score desc;

-- traveller type
SELECT
	u.traveller_type,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM users u
LEFT JOIN reviews r
ON (u.user_id=r.user_id)
GROUP BY u.traveller_type
ORDER BY avg_score desc;

-- hotels having high reviews but low rating (risky hotels)

WITH risky AS
(
SELECT
	h.hotel_id AS hotel_Id,
	h.hotel_name AS hotel_name,
    count(r.review_id) AS total_reviews,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM hotels h
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY h.hotel_name,h.hotel_id
ORDER BY total_reviews desc)

SELECT
	hotel_id,
    hotel_name,
	total_reviews,
	avg_score,
	avg_cleanliness,
	avg_comfort,
	avg_staff,
	avg_location,
	avg_valuefor_money
FROM risky
WHERE total_reviews>2000
AND avg_score <9;

select * from reviews;

-- finding main years of user count and review count
SELECT
YEAR(u.join_date) AS years,
count(distinct r.review_id) AS Review_count,
count(distinct u.user_id) AS User_count
FROM users u
LEFT JOIN reviews r
ON (u.user_id=r.user_id)
GROUP BY years
ORDER BY years;

-- years wise reviews scores

WITH keyyears AS
(
SELECT
	YEAR(r.review_date) AS years,
	count(r.review_id) AS total_reviews,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM reviews r
GROUP BY years
ORDER BY years)
    
SELECT
	years,
	total_reviews,
	avg_score,
	avg_cleanliness,
	avg_comfort,
    avg_facilites,
	avg_staff,
	avg_location,
	avg_valuefor_money
FROM keyyears
GROUP BY years
ORDER BY years;


-- 2023 and 2024 reviews (key years)
WITH keyyears AS
(
SELECT
	YEAR(r.review_date) AS years,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM  reviews r
GROUP BY years
ORDER BY years)
   
SELECT
	years,
	avg_score,
	avg_cleanliness,
	avg_comfort,
    avg_facilites,
	avg_staff,
	avg_location,
	avg_valuefor_money
FROM keyyears
WHERE years IN ('2023','2024')
GROUP BY years
ORDER BY years;



WITH keyyears AS
(
SELECT
	YEAR(review_date) AS years,
	h.hotel_name AS hotel_name,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM hotels h 
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY years,hotel_name
ORDER BY years
)

SELECT
	years,
	hotel_name,
	avg_score,
	avg_cleanliness,
	avg_comfort,
    avg_facilites,
	avg_staff,
	avg_location,
	avg_valuefor_money
FROM keyyears
WHERE years IN ('2023','2024','2025')
GROUP BY hotel_name,years
ORDER BY years, avg_score desc;

-- FINAL REPORT OF HOTELS WITH AVERAGE RATING ON ALL SEGMENT FOR THE 6 YEARS PERFORMANCE

WITH keyyears AS
(
SELECT
	h.hotel_name AS hotel_name,
	round(avg(r.score_overall),2) AS avg_score,
	round(avg(r.score_cleanliness),2) AS avg_cleanliness,
	round(avg(r.score_comfort),2) AS avg_comfort,
	round(avg(r.score_facilities),2) AS avg_facilites,
	round(avg(r.score_location),2) AS avg_location,
	round(avg(r.score_staff),2) AS  avg_staff,
	round(avg(r.score_value_for_money),2) AS avg_valuefor_money
FROM hotels h 
LEFT JOIN reviews r
ON (h.hotel_id=r.hotel_id)
GROUP BY hotel_name
)

SELECT
	hotel_name,
	avg_score,
	avg_cleanliness,
	avg_comfort,
    avg_facilites,
	avg_staff,
	avg_location,
	avg_valuefor_money
FROM keyyears
GROUP BY hotel_name
ORDER BY  avg_score desc;

