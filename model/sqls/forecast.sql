-- Sales Forecast Data (DUMMY DATA - icebase.dealers_360)
-- SalesQty1-12 from InvWarehouse = Forecast values for Jan-Dec
-- Filtered to ProductUnitType = 'Whole Good' only
-- Aggregated by Product Category, Model, Family from Inventory Info

WITH sku_forecast AS (
    -- Aggregate forecast at SKU level
    SELECT 
        TRIM(CAST(stockcode AS VARCHAR)) AS stock_code,
        
        -- Monthly forecast values
        COALESCE(salesqty1, 0) AS forecast_jan,
        COALESCE(salesqty2, 0) AS forecast_feb,
        COALESCE(salesqty3, 0) AS forecast_mar,
        COALESCE(salesqty4, 0) AS forecast_apr,
        COALESCE(salesqty5, 0) AS forecast_may,
        COALESCE(salesqty6, 0) AS forecast_jun,
        COALESCE(salesqty7, 0) AS forecast_jul,
        COALESCE(salesqty8, 0) AS forecast_aug,
        COALESCE(salesqty9, 0) AS forecast_sep,
        COALESCE(salesqty10, 0) AS forecast_oct,
        COALESCE(salesqty11, 0) AS forecast_nov,
        COALESCE(salesqty12, 0) AS forecast_dec,
        
        -- Total annual forecast
        COALESCE(salesqty1, 0) + COALESCE(salesqty2, 0) + COALESCE(salesqty3, 0) +
        COALESCE(salesqty4, 0) + COALESCE(salesqty5, 0) + COALESCE(salesqty6, 0) +
        COALESCE(salesqty7, 0) + COALESCE(salesqty8, 0) + COALESCE(salesqty9, 0) +
        COALESCE(salesqty10, 0) + COALESCE(salesqty11, 0) + COALESCE(salesqty12, 0) AS forecast_total
        
    FROM "icebase"."dealers_360_1".inv_warehouse
    WHERE stockcode IS NOT NULL AND TRIM(CAST(stockcode AS VARCHAR)) <> ''
),

sku_with_category AS (
    -- Map SKU to Category, Model, Family (only Whole Good products)
    SELECT 
        s.stock_code,
        CASE 
            WHEN p.product_category IS NULL OR TRIM(CAST(p.product_category AS VARCHAR)) = '' 
            THEN 'Undefined/Blank' 
            ELSE TRIM(CAST(p.product_category AS VARCHAR)) 
        END AS product_category,
        CASE 
            WHEN p.product_model IS NULL OR TRIM(CAST(p.product_model AS VARCHAR)) = '' 
            THEN 'Undefined/Blank' 
            ELSE TRIM(CAST(p.product_model AS VARCHAR)) 
        END AS product_model,
        CASE 
            WHEN p.product_family IS NULL OR TRIM(CAST(p.product_family AS VARCHAR)) = '' 
            THEN 'Undefined/Blank' 
            ELSE TRIM(CAST(p.product_family AS VARCHAR)) 
        END AS product_family,
        
        s.forecast_jan, s.forecast_feb, s.forecast_mar, s.forecast_apr,
        s.forecast_may, s.forecast_jun, s.forecast_jul, s.forecast_aug,
        s.forecast_sep, s.forecast_oct, s.forecast_nov, s.forecast_dec,
        s.forecast_total
        
    FROM sku_forecast s
    INNER JOIN "icebase"."dealers_360_1".inventory_info p
        ON s.stock_code = TRIM(CAST(p.stock_code AS VARCHAR))
    WHERE TRIM(CAST(p.product_unit_type AS VARCHAR)) = 'Whole Good'
)

-- Aggregate forecast by Category, Model, Family
SELECT 
    -- Primary Key
    CONCAT(
        COALESCE(product_category, 'Undefined'), '-',
        COALESCE(product_model, 'Undefined'), '-',
        COALESCE(product_family, 'Undefined')
    ) AS forecast_id,
    
    -- Dimensions
    product_category,
    product_model,
    product_family,
    
    -- SKU Count
    COUNT(DISTINCT stock_code) AS sku_count,
    
    -- Monthly Forecast (aggregated)
    ROUND(SUM(forecast_jan), 2) AS forecast_jan,
    ROUND(SUM(forecast_feb), 2) AS forecast_feb,
    ROUND(SUM(forecast_mar), 2) AS forecast_mar,
    ROUND(SUM(forecast_apr), 2) AS forecast_apr,
    ROUND(SUM(forecast_may), 2) AS forecast_may,
    ROUND(SUM(forecast_jun), 2) AS forecast_jun,
    ROUND(SUM(forecast_jul), 2) AS forecast_jul,
    ROUND(SUM(forecast_aug), 2) AS forecast_aug,
    ROUND(SUM(forecast_sep), 2) AS forecast_sep,
    ROUND(SUM(forecast_oct), 2) AS forecast_oct,
    ROUND(SUM(forecast_nov), 2) AS forecast_nov,
    ROUND(SUM(forecast_dec), 2) AS forecast_dec,
    
    -- Quarterly Forecast
    ROUND(SUM(forecast_jan + forecast_feb + forecast_mar), 2) AS forecast_q1,
    ROUND(SUM(forecast_apr + forecast_may + forecast_jun), 2) AS forecast_q2,
    ROUND(SUM(forecast_jul + forecast_aug + forecast_sep), 2) AS forecast_q3,
    ROUND(SUM(forecast_oct + forecast_nov + forecast_dec), 2) AS forecast_q4,
    
    -- Annual Forecast
    ROUND(SUM(forecast_total), 2) AS forecast_annual,
    
    -- Average Monthly Forecast
    ROUND(SUM(forecast_total) / 12.0, 2) AS forecast_avg_monthly

FROM sku_with_category
GROUP BY product_category, product_model, product_family
ORDER BY product_category, product_model, product_family
