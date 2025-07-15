CREATE VIEW [dbo].[vw_monthly_sales_trend_by_category]
AS
SELECT TOP (100) PERCENT FORMAT(d.Order_date, 'yyyy-MM') AS MonthYear, c.category_name, SUM(s.total_sales) AS TotalSales
FROM     dbo.fact_sales AS s INNER JOIN
                  dbo.dim_product AS p ON s.product_id = p.id INNER JOIN
                  dbo.dim_category AS c ON p.category_id = c.category_id INNER JOIN
                  dbo.dim_date AS d ON d.date_id = s.date_id
GROUP BY FORMAT(d.Order_date, 'yyyy-MM'), c.category_name
ORDER BY MonthYear, TotalSales DESC


CREATE VIEW vw_Customer_Lifetime_Value AS
SELECT 
    cu.customer_id,
    COUNT(DISTINCT s.order_id) AS TotalOrders,
    SUM(s.total_sales) AS LifetimeSales
FROM fact_sales s
INNER JOIN dim_customer cu ON s.customer_id = cu.id
GROUP BY cu.customer_id

create VIEW vw_High_Discount_Orders AS
SELECT 
    s.order_id,
    cu.customer_id,
    AVG(s.Discount) AS AvgDiscount,
    SUM(s.total_sales) AS TotalSales
FROM fact_sales s
JOIN dim_customer cu ON s.customer_id = cu.id
GROUP BY s.order_id, cu.customer_id
HAVING AVG(s.Discount) > 0.15; 

CREATE VIEW vw_Customer_Churn_Flag AS
SELECT 
    cu.customer_id,
    MAX(s.order_id) AS LastOrderDate,
    CASE 
        WHEN MAX(d.Order_date) < DATEADD(MONTH, -6, GETDATE()) THEN 'Churned'
        ELSE 'Active'
    END AS ChurnStatus
FROM fact_sales s
INNER JOIN dim_customer cu ON s.customer_id = cu.id
INNER JOIN dim_date d ON d.date_id=s.date_id
GROUP BY cu.customer_id

CREATE VIEW vw_Weekly_Sales_Trend AS
SELECT 
    DATEPART(YEAR, d.Order_date) AS SalesYear,
    DATEPART(WEEK, d.Order_date) AS WeekNumber,
    SUM(s.total_sales) AS TotalSales,
    SUM(s.profit) AS TotalProfit
FROM fact_sales s
inner join dim_date as d on d.date_id=s.date_id
GROUP BY 
    DATEPART(YEAR, d.Order_date), 
    DATEPART(WEEK, d.Order_date);
