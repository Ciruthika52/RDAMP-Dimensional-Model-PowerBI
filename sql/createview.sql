

CREATE VIEW [dbo].[vw_channel_margin_report]
AS
SELECT o.order_mode_name, COUNT(*) AS Num_Orders, SUM(s.total_sales) AS Total_Sales, SUM(s.profit) AS Total_Profit, AVG(s.profit / NULLIF (s.total_sales, 0)) * 100 AS Avg_Margin_Percent, o.order_mode_id, SUM(s.total_sales) 
                  / COUNT(s.order_id) AS average_order_value, dbo.dim_segment.segment_name
FROM     dbo.fact_sales AS s INNER JOIN
                  dbo.dim_order_mode AS o ON o.order_mode_id = s.order_mode_id INNER JOIN
                  dbo.dim_product ON s.product_id = dbo.dim_product.id INNER JOIN
                  dbo.dim_segment ON dbo.dim_product.segment_id = dbo.dim_segment.segment_id
GROUP BY o.order_mode_name, o.order_mode_id, dbo.dim_segment.segment_name



CREATE VIEW [dbo].[vw_customer_order_patterns]
AS
SELECT c.customer_id, COUNT(DISTINCT s.order_id) AS Order_Frequency, AVG(s.total_sales) AS Avg_Order_Value, SUM(s.profit) AS Total_Profit_Per_Customer
FROM     dbo.fact_sales AS s INNER JOIN
                  dbo.dim_customer AS c ON s.customer_id = c.id
GROUP BY c.customer_id


CREATE VIEW [dbo].[vw_discount_impact_analysis]
AS
SELECT s.order_id, p.product_name, s.discount, s.profit, p.id
FROM     dbo.fact_sales AS s INNER JOIN
                  dbo.dim_product AS p ON p.id = s.product_id
WHERE  (s.discount > 0)


CREATE VIEW [dbo].[vw_product_seasonality]
AS
SELECT TOP (100) PERCENT p.product_id, p.product_name, d.month_year, SUM(s.total_sales) AS total_sales, SUM(s.quantity) AS Units_Sold, SUM(s.profit) AS profit, p.id, d.year * 100 + d.month AS so
FROM     dbo.fact_sales AS s INNER JOIN
                  dbo.dim_product AS p ON s.product_id = p.id INNER JOIN
                  dbo.dim_date AS d ON d.date_id = s.date_id
GROUP BY p.product_id, p.product_name, d.month_year, p.id, d.year * 100 + d.month


CREATE VIEW [dbo].[vw_region_category_rankings]
AS
SELECT 
    l.Region,
    c.category_name,
    SUM(s.total_sales) AS Total_Sales,
    SUM(s.profit) AS Profit,
    RANK() OVER (PARTITION BY l.Region ORDER BY 
        SUM(s.profit) DESC) AS Profit_Rank
FROM 
    fact_sales s
inner join 
    dim_product p ON s.Product_ID = p.id
inner join 
    dim_location l ON s.location_id = l.location_id
inner join 
	dim_category c ON c.category_id=p.category_id
GROUP BY 
    l.Region, c.category_name