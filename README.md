# India Food Delivery Operations & Performance Analytics

##  Project Overview

This project analyzes food delivery operations using a real-world food delivery dataset containing thousands of order records.

The objective is to explore operational patterns and identify factors associated with food delivery performance, including order volume, customer ratings, traffic conditions, weather, city, vehicle type, and order characteristics.

The project follows an end-to-end data analytics workflow using **Excel, MySQL, and Power BI**, covering data cleaning, SQL-based analysis, and interactive dashboard development.

---

##  Business Objectives

The main objectives of this project are to:

- Analyze overall food delivery order volume.
- Understand delivery operations across different cities.
- Analyze customer delivery ratings.
- Examine the impact of traffic conditions on operations.
- Analyze order patterns under different weather conditions.
- Compare different vehicle types used for deliveries.
- Identify operational trends and patterns from the dataset.
- Build an interactive dashboard to support data-driven decision-making.

---

##  Tools & Technologies

- **Microsoft Excel** – Data cleaning and preprocessing
- **MySQL** – Data storage and SQL analysis
- **Power BI** – Data visualization and interactive dashboard
- **Power Query** – Data transformation and preparation
- **DAX** – Measures and calculations in Power BI

---

##  Project Workflow

### 1. Data Collection
The food delivery dataset was obtained from a public dataset source and imported for analysis.

### 2. Data Cleaning – Excel & Power Query

The dataset was prepared for analysis by:

- Checking column names and data types
- Handling missing values
- Removing unnecessary blank records
- Checking for data errors
- Cleaning text fields
- Preparing the dataset for analysis

### 3. SQL Analysis – MySQL

The cleaned dataset was imported into MySQL for structured analysis.

SQL was used to:

- Count total orders
- Analyze orders by city
- Analyze orders by traffic condition
- Analyze orders by weather condition
- Analyze vehicle usage
- Analyze customer ratings
- Identify operational patterns

### 4. Power BI Dashboard

The processed data was connected to Power BI to create an interactive dashboard.

The dashboard includes visual analysis of:

- Total Orders
- Average Delivery Rating
- Orders by City
- Orders by Traffic Density
- Orders by Weather Condition
- Orders by Vehicle Type
- Order trends over time
- Customer rating patterns

Interactive slicers allow users to filter the analysis based on relevant categories.

---

##  Dashboard

### Food Delivery Operations & Performance Dashboard

The Power BI dashboard provides a consolidated view of food delivery operations and helps users explore important business patterns through interactive visualizations.

**Key areas covered:**

-  Order Volume
-  Customer Ratings
-  City-wise Analysis
-  Traffic Analysis
-  Weather Analysis
-  Vehicle Type Analysis
-  Order Trends

---

##  Key Insights

The analysis is designed to answer questions such as:

1. Which cities generate the highest number of orders?
2. How are customer ratings distributed?
3. Which traffic conditions are associated with higher order volumes?
4. How does weather vary across food delivery operations?
5. Which vehicle types are most commonly used?
6. What are the major patterns in food delivery orders?
7. Which operational factors should businesses monitor closely?

---

##  Project Structure

```text
India-Food-Delivery-Operations-Analytics/
│
├── Dataset/
│   └── food_delivery_dataset.xlsx
│
├── Excel/
│   └── cleaned_food_delivery_data.xlsx
│
├── SQL/
│   └── food_delivery_analysis.sql
│
├── PowerBI/
│   └── food_delivery_dashboard.pbix
│
├── Images/
│   └── dashboard_screenshot.png
│
└── README.md
