-- Practice Joins --------------------------------------------------------------------------------------------

-- 1
SELECT * FROM invoice i
JOIN invoice_line il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > .99;

-- 2
SELECT i.invoice_date, c.first_name, c.last_name, i.total FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;

-- 3
SELECT c.first_name, c.last_name, e.first_name, e.last_name FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;

-- 4
SELECT al.title, ar.name FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id;

-- 5
SELECT pt.track_id FROM playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';

-- 6
SELECT t.name FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;

-- 7
SELECT t.name, p.name FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.track_id = p.playlist_id;

-- 8
SELECT t.name, a.title FROM track t 
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';

-- BD
SELECT t.name, g.name, al.title, ar.name FROM track t
JOIN genre g ON t.genre_id = g.genre_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON ar.artist_id = al.artist_id
JOIN playlist_track pt ON pt.track_id = t.track_id
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';

-- Practice Nested Queries -----------------------------------------------------------------------------------

-- 1
SELECT * FROM invoice
WHERE invoice_id IN 
(SELECT invoice_id FROM invoice_line WHERE unit_price > .99);

-- 2
SELECT * FROM playlist_track
WHERE playlist_id IN 
(SELECT playlist_id FROM playlist WHERE name = 'Music');

-- 3
SELECT name FROM track
WHERE track_id IN 
(SELECT track_id FROM playlist_track WHERE playlist_id = 5);

-- 4
SELECT * FROM track
WHERE genre_id IN
(SELECT genre_id FROM genre WHERE name = 'Comedy');

-- 5
SELECT * FROM track
WHERE album_id IN
(SELECT album_id FROM album WHERE title = 'Fireball');

-- 6
SELECT * FROM track
WHERE album_id IN
(SELECT album_id FROM album WHERE artist_id IN
(SELECT artist_id FROM artist WHERE name = 'Queen'));


-- Practice Updating Rows ------------------------------------------------------------------------------------

-- 1
UPDATE customer
SET fax = NULL
WHERE fax IS NOT NULL;

-- 2
UPDATE customer
SET company = 'Self'
WHERE company IS NULL;

-- 3
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

-- 4
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

-- 5
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = (SELECT genre_id FROM genre WHERE name = 'Metal') 
AND composer IS NULL;


-- Group By --------------------------------------------------------------------------------------------------

-- 1
SELECT g.name, COUNT(*) FROM track t
JOIN genre g ON (t.genre_id = g.genre_id)
GROUP BY g.name;

-- 2
SELECT g.name, COUNT(*) FROM track t
JOIN genre g ON (g.genre_id = t.genre_id)
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

-- 3
SELECT ar.name, COUNT(*) FROM album al
JOIN artist ar ON (ar.artist_id = al.artist_id)
GROUP BY ar.name;


-- Use Distinct ----------------------------------------------------------------------------------------------

-- 1
SELECT DISTINCT composer
FROM track;

-- 2
SELECT DISTINCT billing_postal_code
FROM invoice;

-- 3
SELECT DISTINCT company
FROM customer;

-- Delete Rows -----------------------------------------------------------------------------------------------

-- 1
DELETE FROM practice_delete
WHERE type = 'bronze';
SELECT * FROM practice_delete;

-- 2
DELETE FROM practice_delete
WHERE type = 'silver';
SELECT * FROM practice_delete;

-- 3
DELETE FROM practice_delete
WHERE value = 150;
SELECT * FROM practice_delete;


-- eCommerce Simulation --------------------------------------------------------------------------------------

-- 1
CREATE TABLE users
(
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(64) NOT NULL,
    user_email VARCHAR(64) NOT NULL
);

CREATE TABLE product
(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(64) NOT NULL,
    product_price INTEGER NOT NULL
);

CREATE TABLE orders
(
    order_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES product(product_id)
);

-- 2
INSERT INTO users (user_name, user_email)
VALUES
('bananas-r-yellow', 'monkey@gmail.com'),
('i_like_turtles', 'boy@carnival.net'),
('somebody1toldme', 'getout@myswamp.org');
SELECT * FROM users;

INSERT INTO product (product_name, product_price)
VALUES
('Bananas', 2),
('Turtle Shirt', 7),
('Shrek on Ice', 5),
('Pants', 20),
('Hat', 10);
SELECT * FROM product;

INSERT INTO orders (product_id)
VALUES
(1),
(2),
(4),
(3),
(1),
(5),
(4),
(2);
SELECT * FROM orders;

-- 3
SELECT * FROM product
WHERE product_id IN
(SELECT product_id FROM orders WHERE order_id = 1);

SELECT * FROM orders;

SELECT SUM(product_price) FROM product
WHERE product_id IN
(SELECT product_id FROM orders WHERE order_id = 3);

-- 4
ALTER TABLE orders ADD COLUMN user_id 
INTEGER REFERENCES users(user_id);
SELECT * FROM orders;

-- 5
UPDATE orders
SET user_id = whatever
WHERE order_id = whatever;
SELECT * FROM orders;

-- 6
SELECT order_id FROM users
WHERE user_id = 1;

SELECT COUNT(*) FROM orders
WHERE user_id = 1;

-- BD
SELECT users.user_name, COUNT(*) FROM users
JOIN orders ON (users.user_id = orders.user_id)
GROUP BY users.user_id;