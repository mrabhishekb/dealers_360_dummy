-- AR Transaction Detail Data (DUMMY DATA - icebase.dealers_360)
-- Invoice line item details from Accounts Receivable
-- Primary Key: invoice_number + detail_line

SELECT 
    -- Primary Key (composite: invoice_number + detail_line)
    CONCAT(TRIM(a.invoice), '-', CAST(a.detailline AS VARCHAR)) AS artrandetail_id,
    
    -- Time Period
    CAST(a.trnyear AS INTEGER) AS trn_year,
    CAST(a.trnmonth AS INTEGER) AS trn_month,
    CASE CAST(a.trnmonth AS INTEGER)
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
    END AS trn_month_name,
    
    -- Invoice Identification
    NULLIF(TRIM(a.invoice), '') AS invoice_number,
    CAST(a.detailline AS INTEGER) AS detail_line,
    
    -- Invoice Date
    a.invoicedate AS invoice_date,
    
    -- Branch & Location
    NULLIF(TRIM(a.branch), '') AS branch,
    NULLIF(TRIM(a.warehouse), '') AS warehouse,
    NULLIF(TRIM(a.area), '') AS area,
    
    -- Customer Info
    CAST(a.customer AS BIGINT) AS customer_id,
    NULLIF(TRIM(a.customerclass), '') AS customer_class,
    
    -- Order Info
    NULLIF(TRIM(a.ordertype), '') AS order_type,
    NULLIF(TRIM(a.salesorder), '') AS order_number,
    CAST(a.salesorderline AS INTEGER) AS order_line,
    
    -- Product Info
    CASE 
        WHEN a.stockcode IS NULL OR TRIM(a.stockcode) = '' 
        THEN 'Undefined/Blank' 
        ELSE TRIM(a.stockcode) 
    END AS stock_code,
    NULLIF(TRIM(a.productclass), '') AS product_class,
    
    -- Quantity & Amounts
    CAST(a.qtyinvoiced AS INTEGER) AS qty_invoiced,
    CAST(a.netsalesvalue AS DOUBLE) AS net_sales_value,
    CAST(a.costvalue AS DOUBLE) AS cost_value,
    
    -- Calculated Margin
    CAST(a.netsalesvalue AS DOUBLE) - CAST(a.costvalue AS DOUBLE) AS margin,
    CASE 
        WHEN CAST(a.netsalesvalue AS DOUBLE) > 0 
        THEN ROUND((CAST(a.netsalesvalue AS DOUBLE) - CAST(a.costvalue AS DOUBLE)) / CAST(a.netsalesvalue AS DOUBLE) * 100, 2)
        ELSE 0 
    END AS margin_pct,
    
    -- Discount
    CAST(a.lineinvoicedisc AS DOUBLE) AS line_invoice_disc,
    
    -- Invoice Status (denormalized from invoices)
    CASE 
        WHEN i.invoicebal1 IS NULL THEN 'Undefined/Null'
        WHEN CAST(i.invoicebal1 AS DOUBLE) > 0 THEN 'Payment Pending'
        ELSE 'Paid'
    END AS invoice_status,
    
    -- System Reference
    a.timestamp AS record_timestamp

FROM "icebase"."dealers_360_1".artrandetail_info a
LEFT JOIN "icebase"."dealers_360_1".invoices_info i
    ON TRIM(a.invoice) = TRIM(i.invoice)
WHERE a.invoice IS NOT NULL AND TRIM(a.invoice) <> ''
