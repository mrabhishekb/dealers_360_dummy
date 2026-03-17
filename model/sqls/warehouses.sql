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
    qtyonhand AS quantity_available,
    qtyallocated AS quantity_allocated,
    qtyonorder AS quantity_on_order,
    qtyonbackorder AS quantity_on_backorder,
    
    -- Stock Limits
    minimumqty AS minimum_qty,
    maximumqty AS maximum_qty,
    openingbalance AS opening_balance,
    
    -- Month-to-Date Movement
    mtdqtyreceived AS mtd_qty_received,
    mtdqtyadjusted AS mtd_qty_adjusted,
    mtdqtytrf AS mtd_qty_transferred,
    mtdqtyissued AS mtd_qty_issued,
    mtdqtysold AS mtd_qty_sold,
    
    -- Year-to-Date Movement
    ytdqtysold AS ytd_qty_sold,
    ytdqtyissued AS ytd_qty_issued,
    prevyearqtysold AS prev_year_qty_sold,
    
    -- Costing & Sales Value
    unitcost AS unit_cost,
    mtdsalesvalue AS mtd_sales_value,
    ytdsalesvalue AS ytd_sales_value,
    
    -- Monthly Sales Quantities (12 months)
    salesqty1 AS sales_qty_month_1,
    salesqty2 AS sales_qty_month_2,
    salesqty3 AS sales_qty_month_3,
    salesqty4 AS sales_qty_month_4,
    salesqty5 AS sales_qty_month_5,
    salesqty6 AS sales_qty_month_6,
    salesqty7 AS sales_qty_month_7,
    salesqty8 AS sales_qty_month_8,
    salesqty9 AS sales_qty_month_9,
    salesqty10 AS sales_qty_month_10,
    salesqty11 AS sales_qty_month_11,
    salesqty12 AS sales_qty_month_12

FROM "icebase"."dealers_360".inv_warehouse
WHERE stockcode IS NOT NULL AND TRIM(stockcode) <> ''
