USE magist;

-- 1. How many orders are there in the dataset?

SELECT 
    COUNT(*) orders_count
FROM
    orders;
-- 99441

-- 2. Are orders actually delivered?

SELECT 
    order_status, COUNT(*) orders
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;
-- Mostly are delivered

-- 3. Is Magist having user growth?

SELECT 
    YEAR(order_purchase_timestamp) year_,
    MONTH(order_purchase_timestamp) month_,
    COUNT(*) n_orders
FROM
    orders
GROUP BY 1, 2
ORDER BY 1, 2;
-- It looks like Magist has a decline

-- 4. How many products are there in the products table?

SELECT 
    COUNT(DISTINCT product_id) products_count
FROM
    products;
-- There are 32951 products

-- 5. Which are the categories with most products?

SELECT 
    product_category_name,
    COUNT(DISTINCT product_id) n_products
FROM
    products
GROUP BY 1
ORDER BY 2 DESC;

-- 6. How many of those products were present in actual transactions?

SELECT 
    COUNT(DISTINCT product_id) n_products
FROM
    order_items;
-- 32951
    
-- 7. What’s the price for the most expensive and cheapest products?

SELECT 
    MIN(price) cheapest, 
    MAX(price) most_expensive
FROM
    order_items;
-- Cheapest: 0.85
-- Most expensive: 6735

-- 8. What are the highest and lowest payment values?

SELECT 
    MIN(payment_value) lowest,
    MAX(payment_value) highest
FROM
    order_payments;
-- Lowest: 0
-- Highest: 13664.1

