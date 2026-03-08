# E-commerce-sales-performance-analysis


## Project Overview

This project analyzes e-commerce sales performance to understand how revenue is generated across different business dimensions, including product categories, customer segments, and sales volatility over time.

The objective is to uncover key insights about sales trends, customer contribution, and category performance. These insights can help identify opportunities to improve revenue performance and support better data-driven business decisions.


## Business Questions

- How have total revenue and order volume evolved over time (monthly)?
- Which product categories contribute the most to total revenue?
- Who are the top customers by total revenue contribution?
- How concentrated is revenue among customers (e.g., top 10% vs the rest)?
- Which sellers generate the highest revenue?
- Which products drive the highest sales volume and revenue?
- Are sales driven more by repeat customers or one-time customers?
- Which categories show the highest revenue volatility over time?


## Dataset Description

The analysis uses six tables representing different aspects of the e-commerce platform.

### Orders
- order_id
- user_id
- order_date
- payment_method
- total_amount

### Order Items
- order_item_id
- order_id
- product_id
- quantity
- item_price

### Products
- product_id
- category
- subcategory
- price
- seller_id

### Reviews
- review_id
- order_item_id
- rating
- review_text
- review_date

### Sellers
- seller_id
- seller_name
- country
- rating

### Users
- user_id
- join_date
- location
- age
- gender



## Analytical Approach

### Data Preparation
Tables were joined depending on the analytical question being addressed. Different business questions required combining different datasets.

### SQL Analysis
The analysis was performed using SQL techniques including:

- Aggregations (SUM, COUNT)
- Window functions
- CASE statements
- Grouping with GROUP BY
- Growth rate calculation
- Revenue volatility measurement using STDDEV

### Visualization
The results were visualized using Tableau to highlight:

- Monthly revenue and order volume trends
- Revenue contribution distribution
- Category performance
- Revenue volatility and risk patterns


## Key Insights

- Revenue shows an overall upward trend but drops in the final month due to incomplete data.
- The top 10% of customers generate approximately **27% of total revenue**.
- The **Toys category** exhibits the highest revenue volatility.
- **October 2023** shows the strongest revenue growth.
- **February 2024** shows the lowest growth rate, likely due to incomplete data rather than a real business decline.
- The **Toys category generates the highest total revenue** among all categories.


## Tools Used

- **SQL (MySQL)** – data analysis and querying  
- **Tableau** – data visualization and dashboard creation







