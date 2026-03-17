-- Sales Order Data (DUMMY DATA - icebase.dealers_360)
-- Sales order information from Syspro
-- Primary Key: order_number

SELECT 
    -- Primary Key
    NULLIF(TRIM(s.sales_order), '') AS order_number,
    
    -- Order Line Info
    CAST(s.sales_order_line AS INTEGER) AS order_line,
    CAST(s.next_detail_line AS INTEGER) AS next_detail_line,
    
    -- Order Status & Type
    s.order_status AS order_status_code,
    CASE 
        WHEN s.order_status = 1 THEN 'Open Order'
        WHEN s.order_status = 2 THEN 'Open Back Order'
        WHEN s.order_status = 3 THEN 'Released Back Order'
        WHEN s.order_status = 4 THEN 'In Warehouse'
        WHEN s.order_status = 8 THEN 'Ready to Invoice'
        WHEN s.order_status = 9 THEN 'Invoiced'
        WHEN s.order_status IS NULL THEN 'In Progress'
        ELSE 'Unknown'
    END AS order_status,
    NULLIF(TRIM(s.order_type), '') AS order_type,
    
    -- Invoice Reference
    NULLIF(TRIM(s.last_invoice), '') AS last_invoice,
    
    -- Flags
    NULLIF(TRIM(s.active_flag), '') AS active_flag,
    NULLIF(TRIM(s.cancelled_flag), '') AS cancelled_flag,
    
    -- Order Date
    s.order_date AS order_date,
    
    -- Order Date Components (for Dashboard 1 monthly charts)
    EXTRACT(YEAR FROM s.order_date) AS order_year,
    EXTRACT(MONTH FROM s.order_date) AS order_month,
    CASE EXTRACT(MONTH FROM s.order_date)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
        ELSE 'Unknown'
    END AS order_month_name,
    
    -- Customer Info
    CAST(s.customer AS BIGINT) AS customer_id,
    NULLIF(TRIM(s.customer_po_number), '') AS customer_po_number,
    
    -- Branch & Location
    NULLIF(TRIM(s.branch), '') AS branch,
    NULLIF(TRIM(s.area), '') AS area,
    NULLIF(TRIM(s.m_warehouse), '') AS warehouse,
    
    -- Shipping Address
    NULLIF(TRIM(s.ship_address_1), '') AS ship_address_1,
    NULLIF(TRIM(s.ship_address_2), '') AS ship_address_2,
    NULLIF(TRIM(s.ship_address_3), '') AS ship_address_3,
    NULLIF(TRIM(s.ship_address_3_loc), '') AS ship_address_3_loc,
    NULLIF(TRIM(s.ship_address_4), '') AS ship_address_4,
    NULLIF(TRIM(s.ship_address_5), '') AS ship_address_5,
    CAST(s.ship_postal_code AS VARCHAR) AS ship_postal_code,
    
    -- Freight
    CASE 
        WHEN s.free_freight IS NULL OR TRIM(s.free_freight) = '' OR UPPER(TRIM(s.free_freight)) = 'N' THEN 'No'
        WHEN UPPER(TRIM(s.free_freight)) = 'Y' THEN 'Yes'
        ELSE TRIM(s.free_freight)
    END AS free_freight,
    
    -- Product Info (from sales order)
    NULLIF(TRIM(s.m_product_class), '') AS product_class,
    CASE 
        WHEN s.m_stock_code IS NULL OR TRIM(s.m_stock_code) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(s.m_stock_code) 
    END AS stock_code,
    CASE 
        WHEN s.m_stock_des IS NULL OR TRIM(s.m_stock_des) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(s.m_stock_des) 
    END AS product_name,
    
    -- Product Info (denormalized from inventory/products)
    COALESCE(NULLIF(TRIM(p.product_category), ''), 'Undefined') AS product_category,
    COALESCE(NULLIF(TRIM(p.product_family), ''), 'Undefined') AS product_family,
    COALESCE(NULLIF(TRIM(p.product_model), ''), 'Undefined') AS product_model,
    COALESCE(NULLIF(TRIM(p.product_unit_type), ''), 'Undefined') AS product_unit_type,
    COALESCE(NULLIF(TRIM(p.product_branch), ''), 'Undefined') AS product_branch,
    
    -- Pricing
    CAST(s.m_price AS DOUBLE) AS unit_price,
    CAST(s.m_unit_cost AS DOUBLE) AS unit_cost,
    
    -- Calculated Margin
    CAST(s.m_price AS DOUBLE) - CAST(s.m_unit_cost AS DOUBLE) AS line_margin,
    CASE 
        WHEN CAST(s.m_price AS DOUBLE) > 0 
        THEN ROUND((CAST(s.m_price AS DOUBLE) - CAST(s.m_unit_cost AS DOUBLE)) / CAST(s.m_price AS DOUBLE) * 100, 2)
        ELSE 0 
    END AS margin_pct

FROM "icebase"."dealers_360".sales_info s
LEFT JOIN "icebase"."dealers_360".inventory_info p
    ON TRIM(s.m_stock_code) = TRIM(CAST(p.stock_code AS VARCHAR))
WHERE s.sales_order IS NOT NULL AND TRIM(s.sales_order) <> ''
