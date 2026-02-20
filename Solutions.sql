-- 10 Sample queries for SAKILA Database
# 1) All films with PG-13 films with rental rate of 2.99 or lower

SELECT 
    *
FROM
    film f
WHERE
    f.rental_rate <= 2.99
        AND f.rating = 'PG-13'
ORDER BY f.rental_rate DESC;


#2)	All films that have deleted scenes

SELECT 
    f.title, f.description, f.special_features
FROM
    film f
WHERE
    f.special_features LIKE '%deleted scenes%';
    
    
#3)	All active customers

SELECT 
    *
FROM
    customer
WHERE
    active = 1;
    
    
#4)	Names of customers who rented a movie on 26th July 2005

SELECT 
    r.rental_id,
    r.rental_date,
    r.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS 'full form'
FROM
    rental r
        JOIN
    customer c ON c.customer_id = r.customer_id
WHERE
    DATE(r.rental_date) = '2005-07-26';
    
    
# 5) Distinct names of customers who rented a movie on 26th July 2005

SELECT DISTINCT
    r.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS 'Full form'
FROM
    rental r
        JOIN
    customer c ON c.customer_id = r.customer_id
WHERE
    DATE(r.rental_date) = '2005-07-26';


# 6) How many rentals we do on each day?

SELECT 
    DATE(rental_date) Date, COUNT(*) Count
FROM
    rental
GROUP BY DATE(rental.rental_date);


# 7) All Sci-fi films in our catalogue
SELECT 
    film_category.film_id,
    film_category.category_id,
    category.name,
    film.title,
    film.release_year
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    film ON film.film_id = film_category.film_id
WHERE
    category.name = 'sci-fi';


# 8) Customers and how many movies they rented from us so far?

SELECT 
    r.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(*) 'count'
FROM
    rental r
        JOIN
    customer c ON r.customer_id = c.customer_id
GROUP BY r.customer_id
ORDER BY COUNT(*) DESC;


# 9) Which movies should we discontinue from our catalogue (less than 1 lifetime rentals)

SELECT 
    low.inventory_id, i.film_id, f.title
FROM
    (SELECT 
        inventory_id, COUNT(*)
    FROM
        rental r
    GROUP BY inventory_id
    HAVING COUNT(*) <= 1) AS low
        JOIN
    inventory i ON i.inventory_id = low.inventory_id
        JOIN
    film f ON f.film_id = i.film_id;


# 10) Which movies are not returned yet?

SELECT 
    r.rental_date, r.customer_id, i.film_id, f.title
FROM
    rental r
        JOIN
    inventory i ON i.inventory_id = r.inventory_id
        JOIN
    film f ON f.film_id = i.film_id
WHERE
    r.return_date IS NULL
ORDER BY f.title;


# 11) How many distinct last names we have in the data?

select count(distinct last_name) Count from customer;


# 12) How much money and rentals we make for Store 1 by day?

SELECT 
    DATE(p.payment_date), SUM(p.amount)
FROM
    payment p
        JOIN
    rental r ON r.rental_id = p.rental_id
        JOIN
    inventory i ON i.inventory_id = r.inventory_id
WHERE
    i.store_id = 1
GROUP BY DATE(p.payment_date)
ORDER BY DATE(p.payment_date);


#13) What are the three top earning days so far?

SELECT 
    DATE(p.payment_date), SUM(p.amount)
FROM
    payment p
        JOIN
    rental r ON r.rental_id = p.rental_id
        JOIN
    inventory i ON i.inventory_id = r.inventory_id
WHERE
    i.store_id = 1
GROUP BY DATE(p.payment_date)
ORDER BY SUM(p.amount) DESC
LIMIT 3