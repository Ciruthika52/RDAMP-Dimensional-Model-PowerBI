

--Order Mode Table Creation
CREATE TABLE dim_order_mode (
    order_mode_id INT IDENTITY PRIMARY KEY,
    order_mode_name VARCHAR(50)
);


--Date table creation
CREATE TABLE dim_date (
    date_id INT IDENTITY PRIMARY KEY,           
    Order_date DATE,
    month INT,
    month_name VARCHAR(20),
    quarter VARCHAR(5),
    year INT,
    month_year VARCHAR(20)
);

-- category table creation
CREATE TABLE dim_category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE dim_subcategory (
    subcategory_id INT IDENTITY(1,1) PRIMARY KEY,
    subcategory_name VARCHAR(100)
);


--segment table creation
CREATE TABLE dim_segment (
    segment_id INT IDENTITY(1,1) PRIMARY KEY,
    segment_name VARCHAR(100)
);

--product table creation
CREATE TABLE dim_product (
	id int IDENTITY(1,1) PRIMARY KEY,
    product_id VARCHAR(50),
    product_name VARCHAR(200),
	category_id int,
	segment_id int,
	subcategory_id int,

	FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
	FOREIGN KEY (subcategory_id) REFERENCES dim_subcategory(subcategory_id),
    FOREIGN KEY (segment_id) REFERENCES dim_segment(segment_id)
);



CREATE TABLE productstaging (
    id int identity primary key,
    product_id VARCHAR(50),
	product_name VARCHAR(200),
    category varchar(50),
	segment varchar(50),
	subcategory varchar(100)
);

--customer table creation
CREATE TABLE dim_customer (
	id int identity primary key,
    customer_id VARCHAR(50),
	customer_name varchar(200)
	
);


--location table creation
CREATE TABLE dim_location (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    region VARCHAR(100)
);

--sales table creation
CREATE TABLE fact_sales (
    sales_id INT IDENTITY PRIMARY KEY,
    order_id VARCHAR(50),
    product_id int,
    customer_id int,
	location_id int,
    date_id INT,
    order_mode_id INT,
    sales_price DECIMAL(18,2),
    cost_price DECIMAL(18,2),
    quantity INT,
    discount DECIMAL(18,2),
	total_revenue DECIMAL(18,2),
	total_sales DECIMAL(18,2),
	total_cost DECIMAL(18,2),
	profit DECIMAL(18,2),

    FOREIGN KEY (product_id) REFERENCES dim_product(id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (order_mode_id) REFERENCES dim_order_mode(order_mode_id),
	FOREIGN KEY (location_id) REFERENCES dim_location(location_id)
);

CREATE TABLE salesstaging (
    sales_id INT IDENTITY PRIMARY KEY,
    order_id VARCHAR(50),
	order_date date,
	order_mode varchar(10),
	customer_id VARCHAR(50),
	postal_code VARCHAR(10),
    product_id VARCHAR(50),
    sales_price DECIMAL(18,2),
    cost_price DECIMAL(18,2),
    quantity INT,
    discount DECIMAL(18,2),
	total_revenue DECIMAL(18,2),
	total_cost DECIMAL(18,2),
	profit DECIMAL(18,2),
	total_sales DECIMAL(18,2)
	
	
);


