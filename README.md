# E-commerce-sales-performance-analysis


## Project overview

This project analyzes sales performance to understand how revenue has been generated across different business dimension, including product categories, customer segmentation and sales volatility over time
The goal is to produce deeper insight about sales being generated, then actions would be maximized in order to gain desired sales number.

The object is to uncover key insights with sales trends, customer contribution and category performance.
This insight would help to identify new opportunities to improve revenue performance and strengthen business decision making.


## Business questions

- How has total revenue and order volume evolved over time (monthly)?
- Which product categories contribute the most to total revenue?
- Who are the top customers by total revenue contribution?
- How concentrated is revenue among customers (e.g., top 10% vs the rest)?
- Which sellers generate the highest revenue?
- Which products drive the highest sales volume and revenue?
- Are sales driven more by repeat customers or one-time customers?
- Which categories or sellers show volatile or declining performance over time?


## Dataset description


In this analysis utilize 6 tables

1. Orders
Contain of this following columns :
  - Order_id
  - User_id
  - Order_date
  - Payment_method
  - total_amount

2. Order_items
Contain of this following columns :
  - Order_item_id
  - Order_id
  - Product_id
  - Quantity
  - item_price

3. Products
Contain of this following columns :
  - Product_id
  - Category
  - Subcategory
  - Price
  - Seller_id

4. Reviews
Contain of this following columns :
  - Review_id
  - Order_item_id
  - Rating
  - Review_text
  - Review_date


5. Sellers
Contain of this following columns :
  - Seller_id
  - Seller_name
  - Country
  - Rating

6. Users
Contain of this following columns :
  - User_id
  - Join_date
  - Location
  - Age
  - Gender


## Analytical approach 

Data preparation
  - Joins table depends on the questions, different questions need different kinds of tables.
    
SQL analysis
  - Aggregation (SUM,COUNT)
  - window functions
  - Case statement
  - Grouping with GROUP BY
  - growth rate calculation
  - volatility measurement (STDDEV)


Visualization
  -The results were visualized by using Tableau.  Charts were highlighting monthly revenue / order value,revenue distribution, category segmentation and volatility / risk.


## Key insights

- Revenue shows an overall upward trend but drops in the final month due to incomplete data.
- The top 10% of customers contribute ~27% of total revenue.
- Toys category shows the highest revenue volatility
- October 2023 shows the  highest growth rate and February 2024 shows the lowest growth rate (most likely due to the incomplete data not because the business impact)
- Toys category generated the highest revenue


## Tools used

- SQL (MySQL)
- Tableau







