





-- populate date data to dim_date table
BULK INSERT dbo.dim_date
FROM 'C:\Data\date.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);


--populate order mode data to dim_order_mode table
INSERT INTO dim_order_mode(order_mode_name)
VALUES('Online')

INSERT INTO dim_order_mode(order_mode_name)
VALUES('In-Store')


-- populate category data to dim_category table
BULK INSERT dbo.dim_category
FROM 'C:\Data\category.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- populate subcategory data to dim_subcategory table
BULK INSERT dbo.dim_category
FROM 'C:\Data\category.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);


BULK INSERT dbo.dim_subcategory
FROM 'C:\Data\subcategory.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);



-- populate customer data to dim_customer table
BULK INSERT dbo.dim_customer
FROM 'C:\Data\customer.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);

--populate location data to dim_location table

BULK INSERT dbo.dim_location
FROM 'C:\Data\dim_location.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);


---- populate segment data to dim_segment
BULK INSERT dbo.dim_segment
FROM 'C:\Data\segment.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);

---- populate product data to productstaging
BULK INSERT dbo.productstaging
FROM 'C:\Data\productcat.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);


Insert into dim_product(product_id,product_name,category_id,segment_id,subcategory_id)
Select product_id,product_name,dim_category.category_id,dim_segment.segment_id,dim_subcategory.subcategory_id from productstaging
inner join dim_category on productstaging.category=dim_category.category_name
inner join dim_segment on productstaging.segment=dim_segment.segment_name
inner join dim_subcategory on productstaging.subcategory=dim_subcategory.subcategory_name

--populate sales data 
BULK INSERT dbo.salesstaging
FROM 'C:\Data\sales.csv'
WITH (
    DATAFILETYPE = 'char',         -- SQL Server 2022+
    FIRSTROW = 2,           -- Skip header row
    FIELDTERMINATOR = ',',  -- Comma-delimited
    ROWTERMINATOR = '\n',
    TABLOCK
);

INSERT INTO fact_sales
                  (order_id, product_id,customer_id, location_id,date_id,  order_mode_id, sales_price, cost_price, quantity, discount, total_revenue, total_cost, profit, total_sales)
SELECT salesstaging.order_id, dim_product.id,dim_customer.id,dim_location.location_id,dim_date.date_id,dim_order_mode.order_mode_id, 
                  salesstaging.sales_price, salesstaging.cost_price, salesstaging.quantity, salesstaging.discount, salesstaging.total_revenue, salesstaging.total_cost, salesstaging.profit, salesstaging.total_sales
FROM     dim_date RIGHT OUTER JOIN
                  dim_product LEFT OUTER JOIN
                  salesstaging LEFT OUTER JOIN
                  dim_order_mode ON salesstaging.order_mode = dim_order_mode.order_mode_name LEFT OUTER JOIN
                  dim_customer ON salesstaging.customer_id = dim_customer.customer_id ON dim_product.product_id = salesstaging.product_id LEFT OUTER JOIN
                  dim_location ON salesstaging.postal_code = dim_location.postal_code ON dim_date.Order_date = salesstaging.order_date