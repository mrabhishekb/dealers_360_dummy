-- Product Master Data (DUMMY DATA - icebase.dealers_360)
-- Product information from Syspro Inventory
-- Primary Key: stock_code

SELECT 
    -- Primary Key
    CASE 
        WHEN stock_code IS NULL OR TRIM(stock_code) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(stock_code) 
    END AS stock_code,
    
    -- Product Description
    NULLIF(TRIM(description), '') AS description,
    NULLIF(TRIM(long_desc), '') AS long_description,
    NULLIF(TRIM(alternate_key_1), '') AS alternate_key_1,
    NULLIF(TRIM(alternate_key_2), '') AS alternate_key_2,
    
    -- Product Classification & Hierarchy
    NULLIF(TRIM(product_class), '') AS product_class,
    NULLIF(TRIM(product_line), '') AS product_line,
    NULLIF(TRIM(product_line_fin), '') AS product_line_fin,
    CASE 
        WHEN product_unit_type IS NULL OR TRIM(product_unit_type) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(product_unit_type) 
    END AS product_unit_type,
    CASE 
        WHEN product_branch IS NULL OR TRIM(product_branch) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(product_branch) 
    END AS product_branch,
    CASE 
        WHEN product_category IS NULL OR TRIM(product_category) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(product_category) 
    END AS product_category,
    CASE 
        WHEN product_family IS NULL OR TRIM(product_family) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(product_family) 
    END AS product_family,
    CASE 
        WHEN product_model IS NULL OR TRIM(product_model) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(product_model) 
    END AS product_model,
    CASE 
        WHEN product_key_feature IS NULL OR TRIM(product_key_feature) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(product_key_feature) 
    END AS product_key_feature,
    NULLIF(TRIM(part_category), '') AS part_category,
    NULLIF(TRIM(abc_class), '') AS abc_class,
    
    -- Units of Measure
    NULLIF(TRIM(stock_uom), '') AS stock_uom,
    NULLIF(TRIM(alternate_uom), '') AS alternate_uom,
    NULLIF(TRIM(cost_uom), '') AS cost_uom,
    NULLIF(TRIM(manufacture_uom), '') AS manufacture_uom,
    
    -- Costing
    material_cost,
    labour_cost,
    fix_overhead AS fixed_overhead,
    variable_overhead,
    sub_contract_cost AS subcontract_cost,
    COALESCE(material_cost, 0) + COALESCE(labour_cost, 0) + COALESCE(fix_overhead, 0) + COALESCE(variable_overhead, 0) + COALESCE(sub_contract_cost, 0) AS total_unit_cost,
    
    -- Pricing
    NULLIF(TRIM(price_category), '') AS price_category,
    NULLIF(TRIM(price_method), '') AS price_method,
    
    -- Supply Chain & Planning
    NULLIF(TRIM(supplier), '') AS supplier,
    NULLIF(TRIM(buyer), '') AS buyer,
    NULLIF(TRIM(planner), '') AS planner,
    NULLIF(TRIM(warehouse_to_use), '') AS warehouse_to_use,
    shipping_lead_time as average_shipping_lead_time,
    NULLIF(TRIM(make_to_order_flag), '') AS make_to_order_flag,
    NULLIF(TRIM(buying_rule), '') AS buying_rule,
    
    -- Physical Attributes
    mass,
    volume,
    length,
    width,
    height,
    
    -- Control & Configuration
    NULLIF(TRIM(serial_method), '') AS serial_method,
    NULLIF(TRIM(kit_type), '') AS kit_type,
    component_count,
    NULLIF(TRIM(traceable_type), '') AS traceable_type,
    
    -- Status & Dates
    date_stk_added AS date_stock_added,
    NULLIF(TRIM(stock_on_hold), '') AS stock_on_hold,
    NULLIF(TRIM(stock_on_hold_reason), '') AS stock_on_hold_reason

FROM "icebase"."dealers_360".inventory_info
WHERE stock_code IS NOT NULL AND TRIM(stock_code) <> ''
