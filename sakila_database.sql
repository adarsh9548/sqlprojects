select * from actor;
select count(*) from  actor;

select * from film;
select count(*) from film;

 -- validating the film actor
select * from film_actor;
select count(distinct actor_id) from film_actor;
select count(distinct film_id) from film_actor;


select * from category;
select count(*) from category;

select * from film_category;
select count(distinct film_id), count(distinct category_id) from film_category;

select * from language;
select count(*) from language;

select * from film_text; 

-- how many film are released in diffrent language
-- validaation connection
select count(distinct film_id)
from language as lang
inner join film as f
on lang.language_id = f.language_id;

SELECT lang.name, count(distinct film_id) 
FROM language as lang inner join film as f on lang.language_id = f.language_id
GROUP BY 1;

-- how many films are released in diffrent category 
select * from category;
select * from film_category;

select  category.name, count(distinct film_category.film_id) 
from  category 
inner join 
film_category 
on category.category_id = film_category.category_id
group by 1;

-- table  related to rental
select * from inventory;
select count(*) from inventory;

select * from rental;
select count(*) from  rental;

select * from customer;
select count(*) from customer; 

select * from payment;
select count(*) from payment;

-- 67k total revenu
select sum(amount) from  payment;

select year(payment_date), month(payment_date), sum(amount)
from payment
group by 1, 2
order by 1, 2;


-- table related to the store -- 

-- store, address, country, staff, city
-- 2 store
select * from store;
select count(*) from store;

-- 109 countries
select * from country;
select count(*) from country;

-- 2 staff
select * from staff;
select count(*) from staff;

-- 600 cities
select * from city;
select count(*) from city;

--  SLIDE: 3 Profitable Titles --

SELECT f.title, sum(amount) as revenue FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1 ORDER BY 2 DESC limit 10;


-- SLIDE: 1 Revenue distribution by title

SELECT 
	CASE 
		WHEN rev < 25 THEN "1. 0 to 25"
        WHEN rev < 50 THEN "2. 25 to 50"
        WHEN rev < 75 THEN "3. 50 to 75"
        WHEN rev < 100 THEN "4. 75 to 100"
        WHEN rev < 125 THEN "5. 100 to 125"
        WHEN rev < 150 THEN "6. 125 to 150"
        WHEN rev < 175 THEN "7. 150 to 175"
        WHEN rev < 200 THEN "8. 175 to 200"
	ELSE "9. > 200"
    END as spread_flag, count(title)
FROM (
	SELECT f.title, sum(amount) as rev FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1
) as temp GROUP BY 1 ORDER BY 1;


-- AVERAGE REVENUE BY FILMS
SELECT AVG(revenue) from (
SELECT f.title, sum(amount) as revenue FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1) as temp;

-- Films earning less than $100
SELECT count(distinct title) from (
SELECT f.title, sum(amount) as revenue FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1) as temp WHERE revenue <=100;


-- SLIDE: 2 RENTAL Rate & Revenue


SELECT * FROM film;
SELECT f.title, rental_rate,sum(amount) as revenue FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1,2;

-- RENTAL Rate & Revenue MODIFIED
SELECT row_number_, 
	max(CASE 
		WHEN rental_rate = .99 THEN revenue
	ELSE null
    END) as ".99",
    max(CASE 
		WHEN rental_rate = 2.99 THEN revenue
	ELSE null
    END) as "2.99",
    max(CASE 
		WHEN rental_rate = 4.99 THEN revenue
	ELSE null
    END) as "4.99"
 FROM (
SELECT rental_rate, revenue, ROW_NUMBER() OVER (PARTITION BY rental_rate ORDER BY revenue) AS row_number_ FROM (
SELECT f.title, rental_rate,sum(amount) as revenue FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1,2) AS rate_revenue) AS pivoted_data group by 1;



-- SLIDE 3: Length & Revenue --

 
SELECT * FROM film;
SELECT f.title, length,sum(amount) as revenue FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1,2;


-- SLIDE 4: Rating & Revenue --

SELECT * FROM film;
SELECT rating ,sum(amount) as revenue FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1 order by 2;


-- SLIDE 5: Store level analysis

-- Stock by Store
SELECT store_id, count(*) as inventory FROM inventory GROUP BY 1;

-- Revenue by Store
SELECT store_id ,sum(amount) as revenue FROM
film as f 
INNER JOIN
inventory as i on f.film_id = i.film_id
INNER JOIN rental as r on r.inventory_id = i.inventory_id
INNER JOIN payment as p on r.rental_id = p.rental_id GROUP BY 1 order by 2;


-- SLIDE 6: Country & Revenue -- 

SELECT con.country, sum(amount) as rev FROM 
payment AS p
INNER JOIN 
customer as cu on p.customer_id = cu.customer_id
INNER JOIN 
address as a on a.address_id = cu.address_id
INNER JOIN 
city as c on a.city_id = c.city_id
INNER JOIN 
country as con on con.country_id = c.country_id group by 1 order by 2;
