# Objective

The main purpose of this project is weather to recommend or not to Eniac, an online marketplace specializing in Apple-compatible accessories, as an intermediate step for an expansion to the Brazilian market to sign a deal with Magist, a Brazilian Software as a Service company that offers a centralized order management system to connect small and medium-sized stores with the biggest Brazilian marketplaces.

# Main concerns

Eniac’s catalog is 100% tech products, and heavily based on Apple-compatible accessories. It is not clear that the marketplaces Magist works with are a good place for these high-end tech products.

Among Eniac’s efforts to have happy customers, fast deliveries are key. The delivery fees resulting from Magist’s deal with the public Post Office might be cheap, but at what cost? Are deliveries fast enough?

Thankfully, Magist has allowed Eniac to access a snapshot of their database. The data might have the answer to these concerns.

**I answer these concerns by exploring the data using SQL and visualize it using Tableau.**

<div class='tableauPlaceholder' id='viz1664201998084' style='position: relative'><noscript><a href='#'><img alt=' ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Ma&#47;MagistProjectBusinessAnalysis&#47;ProductsDashboard&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='site_root' value='' /><param name='name' value='MagistProjectBusinessAnalysis&#47;ProductsDashboard' /><param name='tabs' value='yes' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Ma&#47;MagistProjectBusinessAnalysis&#47;ProductsDashboard&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='language' value='en-US' /><param name='filter' value='publish=yes' /></object></div>                <script type='text/javascript'>                    var divElement = document.getElementById('viz1664201998084');                    var vizElement = divElement.getElementsByTagName('object')[0];                    if ( divElement.offsetWidth > 800 ) { vizElement.style.minWidth='420px';vizElement.style.maxWidth='100%';vizElement.style.minHeight='610px';vizElement.style.maxHeight=(divElement.offsetWidth*0.75)+'px';} else if ( divElement.offsetWidth > 500 ) { vizElement.style.width='100%';vizElement.style.height=(divElement.offsetWidth*0.75)+'px';} else { vizElement.style.width='100%';vizElement.style.minHeight='1200px';vizElement.style.maxHeight=(divElement.offsetWidth*1.77)+'px';}                     var scriptElement = document.createElement('script');                    scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    vizElement.parentNode.insertBefore(scriptElement, vizElement);                </script>

# Some information about Eniac

Here are some numbers that will help you understand Eniac’s scope (data from April 2017 – March 2018):

* Revenue: 40,044,542 €
* Avg monthly revenue: 1,011,256 €
* Avg order price: 710 €
* Avg item price: 540 €

# Understand the schema

Here the schema of the database.

![Magist database schema](magist_database_schema.png)

## Tables that are just collections of items, independent of any transaction

* products. contains a row for each product available for sale.
* product_category_name_translation. contains a relation of product categories in its original language, Portuguese, and English.
* sellers. contains a row for each one of the sellers registered in Magist’s marketplace.
* customers. contains a row for each customer that has made a purchase.
* geo. contains a relation between zip codes, coordinates, and states, to obtain more precise information about sellers and customers.

Unless a new customer makes a purchase, a new product is released, or a new seller is registered, these tables remain unchanged during a transaction.

## Tables responsible for capturing a purchase

* orders. every time that an order is placed, a row is inserted in this table. Even if the order contains multiple products, here it will be reflected as a single row with an order_id that uniquely identifies it.
* order_items. this table contains one row for each distinct product of an order.

## Tables storing information regarding payment and reviews

* order_payments. customers can pay an order with different methods of payment.  Every time a payment is made, a row is inserted here. An order can be paid in installments, which means that a single order can have many separate payments.
* order_reviews. customers can leave multiple reviews corresponding to the order they placed.