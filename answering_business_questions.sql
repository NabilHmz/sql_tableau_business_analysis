USE magist;

# In relation to the products:

## What categories of tech products does Magist have?

/***
Categories we considered as "tech" are:
("audio", "computers", "computers_accessories", "electronics", "signaling_and_security", "tablets_printing_image", 
"telephony", "watches_gifts")
***/


## How many products of these tech categories have been sold (within the time window of the database snapshot)?

SELECT 
    COUNT(oi.product_id) products_sold
FROM
    order_items oi
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
WHERE
    pcnt.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts');
-- 21979

### Qantity sold for each category belonging to tech.

SELECT 
    pcnt.product_category_name_english,
    COUNT(oi.product_id) products_sold
FROM
    order_items oi
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
WHERE
    pcnt.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts')
GROUP BY pcnt.product_category_name_english;

### Quantity of tech products sold vs. non tech.

SELECT 
    CASE
        WHEN
            pcnt.product_category_name_english IN ('audio' , 'computers',
                'computers_accessories',
                'electronics',
                'signaling_and_security',
                'tablets_printing_image',
                'telephony',
                'watches_gifts')
        THEN
            'tech_products'
        ELSE 'non_tech_products'
    END tech_non_tech_cat,
    COUNT(oi.product_id) products_sold
FROM
    order_items oi
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
GROUP BY 1;
-- tech_products: 21979
-- non_tech_products: 90671


## What percentage does that represent from the overall number of products sold?

SELECT 
    CASE
        WHEN
            pcnt.product_category_name_english IN ('audio' , 'computers',
                'computers_accessories',
                'electronics',
                'signaling_and_security',
                'tablets_printing_image',
                'telephony',
                'watches_gifts')
        THEN
            'tech_products'
        ELSE 'non_tech_products'
    END tech_non_tech_cat,
    COUNT(oi.product_id) products_sold,
    ROUND(COUNT(oi.product_id) / (SELECT 
                    COUNT(*)
                FROM
                    order_items) * 100,
            2) pct
FROM
    order_items oi
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
GROUP BY 1;
-- tech_products: 19.51 %
-- non_tech_products: 80.49 %


## What’s the average price of the products being sold?

SELECT 
    ROUND(AVG(price), 2) all_items_avg_price
FROM
    order_items;
-- all_items_avg_price is 120.65


### What’s the average price of the tech products being sold?

SELECT 
    ROUND(AVG(price), 2) tech_items_avg_price
FROM
    order_items
        JOIN
    products USING (product_id)
        JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts');
-- tech_items_avg_price is 132.11

### What is the average price of Eniac's items vs. Magist all items and its tech items?

SELECT 
    ROUND(AVG(price), 2) all_items_avg_price,
    (SELECT 
            ROUND(AVG(oi.price), 2) tech_items_avg_price
        FROM
            order_items oi
                JOIN
            products p USING (product_id)
                JOIN
            product_category_name_translation pcnt USING (product_category_name)
        WHERE
            product_category_name_english IN ('audio' , 'computers',
                'computers_accessories',
                'electronics',
                'signaling_and_security',
                'tablets_printing_image',
                'telephony',
                'watches_gifts')) tech_items_avg_price,
    540 AS eniac_items_avg_price
FROM
    order_items;
-- all_items_avg_price: 120.65
-- tech_items_avg_price: 132.11
-- eniac_items_avg_proce: 540

## Are expensive tech products popular?

SELECT 
    CASE
        WHEN
            oi.price <= (SELECT 
                    ROUND(AVG(oi.price), 2) tech_items_avg_price
                FROM
                    order_items oi
                        JOIN
                    products p USING (product_id)
                        JOIN
                    product_category_name_translation pcnt USING (product_category_name)
                WHERE
                    product_category_name_english IN ('audio' , 'computers',
                        'computers_accessories',
                        'electronics',
                        'signaling_and_security',
                        'tablets_printing_image',
                        'telephony',
                        'watches_gifts'))
        THEN
            'cheap'
        ELSE 'expensive'
    END 'price_category',
    COUNT(oi.product_id) n_sold,
    round(sum(oi.price), 2) revenue
FROM
    order_items oi
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts')
GROUP BY 1;

### Evolution of tech products orders.

SELECT year(o.order_purchase_timestamp) year, month(o.order_purchase_timestamp) month,
CASE
        WHEN
            pcnt.product_category_name_english IN ('audio' , 'computers',
                'computers_accessories',
                'electronics',
                'signaling_and_security',
                'tablets_printing_image',
                'telephony',
                'watches_gifts')
        THEN
            'tech_products'
        ELSE 'non_tech_products'
    END tech_non_tech_cat,
count(distinct(o.order_id)) n_orders
FROM
	orders o
		JOIN
    order_items oi USING (order_id)
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
group by 1, 2, 3
order by 1, 2, 3;


# In relation to the sellers:

## How many months of data are included in the magist database?

with n_months_year as (
select year(order_purchase_timestamp) year, count(distinct(month(order_purchase_timestamp))) n_months
from orders group by 1
)
select sum(n_months) n_months
from n_months_year;
-- 25 months.

# or 

SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp)) AS n_months
FROM
    orders;
    

## How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?

SELECT (SELECT COUNT(seller_id) n_sellers FROM sellers) n_total_sellers, count(distinct(s.seller_id)) n_tech_sellers, 
round(count(distinct(s.seller_id)) / (SELECT COUNT(seller_id) n_sellers FROM sellers) * 100, 2) pct
FROM sellers s
		JOIN
	order_items oi using (seller_id)
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
WHERE
    pcnt.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts');
-- n_total_sellers: 3095
-- n_tech_sellers: 549
-- percentage: 17.74 %

## What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
SELECT 
    ROUND(SUM(oi.price), 2) tech_revenue,
    (SELECT 
            ROUND(SUM(price), 2)
        FROM
            order_items oi
                JOIN
            orders o USING (order_id)
        WHERE
            o.order_status NOT IN ('unavailable' , 'canceled')) total_revenue
FROM
    orders o
        JOIN
    order_items oi USING (order_id)
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
WHERE
    pcnt.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts')
        AND o.order_status NOT IN ('unavailable' , 'canceled');
-- tech_revenue: 2884598.77
-- total_revenue: 13494400.74

### Tech Products Total Revenue VS Non Tech
SELECT 
    CASE
        WHEN
            pcnt.product_category_name_english IN ('audio' , 'computers',
                'computers_accessories',
                'electronics',
                'signaling_and_security',
                'tablets_printing_image',
                'telephony',
                'watches_gifts')
        THEN
            'tech_products'
        ELSE 'non_tech_products'
    END tech_non_tech_cat,
    ROUND(SUM(oi.price), 2) revenue
FROM
    orders o
		JOIN
    order_items oi
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled')
GROUP BY 1;


### Evolution of tech products revenue over time vs non tech.
SELECT 
    YEAR(o.order_purchase_timestamp) year,
    MONTH(o.order_purchase_timestamp) month,
    CASE
        WHEN
            pcnt.product_category_name_english IN ('audio' , 'computers',
                'computers_accessories',
                'electronics',
                'signaling_and_security',
                'tablets_printing_image',
                'telephony',
                'watches_gifts')
        THEN
            'tech_products'
        ELSE 'non_tech_products'
    END tech_non_tech_cat,
    ROUND(SUM(oi.price), 2) revenue
FROM
    orders o
        JOIN
    order_items oi USING (order_id)
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled')
GROUP BY 1 , 2 , 3
ORDER BY 1 , 2 , 3;

## Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?

SELECT 
    round(SUM(oi.price) / TIMESTAMPDIFF(MONTH, MIN(o.order_purchase_timestamp), MAX(o.order_purchase_timestamp)), 2) 
    tech_sellers_avg_monthly_revenue,
    round((SELECT 
            SUM(price)
        FROM
            order_items oi
                JOIN
            orders o USING (order_id)
        WHERE
            o.order_status NOT IN ('unavailable' , 'canceled')) / TIMESTAMPDIFF(MONTH, MIN(o.order_purchase_timestamp), MAX(o.order_purchase_timestamp)), 2)
    all_sellers_avg_monthly_revenue, 
    1011256 eniac_avg_monthly_revenue
FROM
    orders o
        JOIN
    order_items oi USING (order_id)
        JOIN
    products p USING (product_id)
        JOIN
    product_category_name_translation pcnt USING (product_category_name)
WHERE
    pcnt.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts')
        AND o.order_status NOT IN ('unavailable' , 'canceled');
-- tech_sellers_avg_monthly_revenue: 131118.13
-- all_sellers_avg_monthly_revenue: 613381.85
-- eniac_avg_monthly_revenue: 1011256

# In relation to the delivery time:

## What’s the average time between the order being placed and the product being delivered?

SELECT 
    AVG(TIMESTAMPDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)) avg_delivery_days
FROM
    orders;

-- or

SELECT 
    AVG(DATEDIFF(order_delivered_customer_date,
            order_purchase_timestamp)) AS average_delivery_duration_days
FROM
    orders;


## How many orders are delivered on time vs orders delivered with a delay?

SELECT 
    CASE
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) <= 0
        THEN
            'on_time'
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) > 0
        THEN
            'delayed'
    END on_time_or_delayed,
    COUNT(*) count
FROM
    orders
WHERE
    orders.order_status = 'delivered'
GROUP BY 1;
-- on_time: 89805
-- delayed: 6665


## Is there any pattern for delayed orders, e.g. big products being delayed more often?

SELECT 
    CASE
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) <= 0
        THEN
            'on_time'
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) > 0
        THEN
            'delayed'
    END on_time_or_delayed,
    COUNT(*) count,
    AVG(p.product_weight_g) avg_weight,
    AVG(p.product_length_cm) avg_length,
    AVG(p.product_height_cm) avg_height,
    AVG(p.product_width_cm) avg_width
FROM
    orders o
        JOIN
    order_items oi USING (order_id)
        JOIN
    products p USING (product_id)
WHERE
    o.order_status = 'delivered'
group by 1;
-- In average the size of products delayed is bigger than the size of products delivered on time.
