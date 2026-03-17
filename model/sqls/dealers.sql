-- Dealers Master Data (DUMMY DATA - icebase.dealers_360)
-- Use Case 1: VIP Spending & Performance Tracking
-- Use Case 3: Regional Data Integration & Geo-Based Insights
-- Primary table for dealer identification, credit status, and regional analysis

SELECT 
    TRY_CAST(dealer_id AS BIGINT) AS customer_id,
    dealer_code ,
    dealer_name,
    dealer_class,
    dealer_class_description,
    branch_code,
    branch_description,
    
    -- Credit & Financial Status
    TRY_CAST(credit_limit AS DOUBLE) AS credit_limit,
    TRY_CAST(credit_status_code AS INTEGER) AS credit_status_code,
    credit_status_description,
    customer_on_hold,
    TRY_CAST(historical_highest_balance AS DOUBLE) AS historical_highest_balance,
    TRY_CAST(outstanding_order_value AS DOUBLE) AS outstanding_order_value,
    TRY_CAST(num_outstanding_orders AS INTEGER) AS num_outstanding_orders,
    
    -- Payment Terms
    TRY_CAST(terms_code AS INTEGER) AS terms_code,
    payment_terms,
    price_code,
    price_group,
    
    -- Sales Assignment
    primary_salesperson_code,
    secondary_salesperson_code,
    tertiary_salesperson_code,
    
    -- Buying Groups
    buying_group_1,
    buying_group_2,
    buying_group_3,
    buying_group_4,
    buying_group_5,
    
    -- Activity Dates
    TRY_CAST(dealer_since_date AS TIMESTAMP) AS dealer_since_date,
    TRY_CAST(last_order_date AS TIMESTAMP) AS last_order_date,
    TRY_CAST(last_payment_date AS TIMESTAMP) AS last_payment_date,
    TRY_CAST(dealer_tenure_days AS INTEGER) AS dealer_tenure_days,
    TRY_CAST(dealer_tenure_years AS INTEGER) AS dealer_tenure_years,
    
    -- Billing Address (Use Case 3: Regional Analysis)
    area_code,
    area_name,
    billing_street_1,
    billing_street_2,
    billing_city,
    billing_state_code,
    billing_state_name,
    billing_country,
    SPLIT_PART(CAST(billing_postal_code AS VARCHAR), '.', 1) AS billing_postal_code,
    SPLIT_PART(CAST(billing_zip5 AS VARCHAR), '.', 1) AS billing_zip5,
    SPLIT_PART(CAST(billing_zip3 AS VARCHAR), '.', 1) AS billing_zip3,
    billing_city_alt,
    billing_state_alt,
    billing_county,
    
    -- Shipping Address (Use Case 3: Regional Analysis)
    shipping_street_1,
    shipping_street_2,
    shipping_city,
    shipping_state_code,
    shipping_country,
    SPLIT_PART(CAST(shipping_postal_code AS VARCHAR), '.', 1) AS shipping_postal_code,
    SPLIT_PART(CAST(shipping_zip5 AS VARCHAR), '.', 1) AS shipping_zip5,
    
    -- GPS Coordinates
    TRY_CAST(billing_latitude AS DOUBLE) AS billing_latitude,
    TRY_CAST(billing_longitude AS DOUBLE) AS billing_longitude,
    TRY_CAST(shipping_latitude AS DOUBLE) AS shipping_latitude,
    TRY_CAST(shipping_longitude AS DOUBLE) AS shipping_longitude,
    
    -- Regional Classification (Use Case 3)
    sales_region,
    state_code_primary,
    
    -- Contact Information
    primary_contact_name,
    primary_phone,
    secondary_phone,
    phone_extension,
    fax_number,
    primary_email,
    shipping_notification_email,
    collections_email,
    
    -- Tax Information
    tax_exempt_status,
    tax_exempt_number,
    gst_exempt_flag,
    gst_exempt_number,
    company_tax_number,
    
    -- Operational Flags
    statement_required_flag,
    backorder_allowed_flag,
    credit_check_flag,
    po_required_flag,
    complete_shipment_required,
    
    -- Shipping Details
    shipping_instructions,
    shipping_method_code,
    special_instructions,
    shipping_location,
    default_warehouse,
    route_code,
    TRY_CAST(route_distance AS DOUBLE) AS route_distance,
    delivery_terms,
    
    -- Data Source
    data_source
    
FROM "icebase"."dealers_360_2".dealers_data
WHERE dealer_code IS NOT NULL
