-- Warehouse Inventory Data (DUMMY DATA - icebase.dealers_360)
-- Stock levels and movement by product and warehouse
-- Primary Key: stock_code + warehouse (composite)

SELECT 
    -- Primary Key (composite)
    CONCAT(COALESCE(TRIM(stockcode), ''), '-', COALESCE(TRIM(warehouse), '')) AS warehouse_inventory_id,
    
    -- Product & Warehouse Identification
    CASE 
        WHEN stockcode IS NULL OR TRIM(stockcode) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(stockcode) 
    END AS stock_code,
    CASE 
        WHEN warehouse IS NULL OR TRIM(warehouse) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(warehouse) 
    END AS warehouse,
    
    -- Current Stock Levels
    CAST(qtyonhand AS DOUBLE) AS quantity_available,
    CAST(qtyallocated AS DOUBLE) AS quantity_allocated,
    CAST(qtyonorder AS DOUBLE) AS quantity_on_order,
    CAST(qtyonbackorder AS DOUBLE) AS quantity_on_backorder,
    
    -- Stock Limits
    CAST(minimumqty AS DOUBLE) AS minimum_qty,
    CAST(maximumqty AS DOUBLE) AS maximum_qty,
    CAST(openingbalance AS DOUBLE) AS opening_balance,
    
    -- Month-to-Date Movement
    CAST(mtdqtyreceived AS DOUBLE) AS mtd_qty_received,
    CAST(mtdqtyadjusted AS DOUBLE) AS mtd_qty_adjusted,
    CAST(mtdqtytrf AS DOUBLE) AS mtd_qty_transferred,
    CAST(mtdqtyissued AS DOUBLE) AS mtd_qty_issued,
    CAST(mtdqtysold AS DOUBLE) AS mtd_qty_sold,
    
    -- Year-to-Date Movement
    CAST(ytdqtysold AS DOUBLE) AS ytd_qty_sold,
    CAST(ytdqtyissued AS DOUBLE) AS ytd_qty_issued,
    CAST(prevyearqtysold AS DOUBLE) AS prev_year_qty_sold,
    
    -- Costing & Sales Value
    CAST(unitcost AS DOUBLE) AS unit_cost,
    CAST(mtdsalesvalue AS DOUBLE) AS mtd_sales_value,
    CAST(ytdsalesvalue AS DOUBLE) AS ytd_sales_value,
    
    -- Monthly Sales Quantities (12 months)
    CAST(salesqty1 AS DOUBLE) AS sales_qty_month_1,
    CAST(salesqty2 AS DOUBLE) AS sales_qty_month_2,
    CAST(salesqty3 AS DOUBLE) AS sales_qty_month_3,
    CAST(salesqty4 AS DOUBLE) AS sales_qty_month_4,
    CAST(salesqty5 AS DOUBLE) AS sales_qty_month_5,
    CAST(salesqty6 AS DOUBLE) AS sales_qty_month_6,
    CAST(salesqty7 AS DOUBLE) AS sales_qty_month_7,
    CAST(salesqty8 AS DOUBLE) AS sales_qty_month_8,
    CAST(salesqty9 AS DOUBLE) AS sales_qty_month_9,
    CAST(salesqty10 AS DOUBLE) AS sales_qty_month_10,
    CAST(salesqty11 AS DOUBLE) AS sales_qty_month_11,
    CAST(salesqty12 AS DOUBLE) AS sales_qty_month_12

FROM "icebase"."dealers_360".inv_warehouse
WHERE stockcode IS NOT NULL AND TRIM(stockcode) <> ''
