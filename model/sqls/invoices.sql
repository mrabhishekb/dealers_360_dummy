-- Invoice Header Data (DUMMY DATA - icebase.dealers_360_3)
-- Invoice summary information from Syspro AR
-- Primary Key: invoice_number

SELECT 
    -- Primary Key
    NULLIF(TRIM(invoice), '') AS invoice_number,
    
    -- Customer Info
    CAST(customer AS BIGINT) AS customer_id,
    NULLIF(TRIM(customerponumber), '') AS customer_po_number,
    
    -- Invoice Date & Period
    invoicedate AS invoice_date,
    CAST(invoiceyear AS INTEGER) AS invoice_year,
    CAST(invoicemonth AS INTEGER) AS invoice_month,
    CASE CAST(invoicemonth AS INTEGER)
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
    END AS invoice_month_name,
    
    -- Order Reference
    NULLIF(TRIM(salesorder), '') AS order_number,
    
    -- Branch & Location
    NULLIF(TRIM(branch), '') AS branch,
    NULLIF(TRIM(area), '') AS area,
    
    -- Invoice Balances
    CAST(invoicebal1 AS DOUBLE) AS total_invoice_balance,
    
    -- Payment Info
    CAST(nextpaymentry AS INTEGER) AS next_payment_entry,
    
    -- Quantity Invoiced (aggregated from artrandetail)
    COALESCE(qty_agg.qty_invoiced, 0) AS qty_invoiced,
    
    -- System Reference
    timestamp AS record_timestamp

FROM "icebase"."dealers_360_3".invoices_info i
LEFT JOIN (
    SELECT 
        TRIM(invoice) AS invoice_number,
        SUM(CAST(qtyinvoiced AS INTEGER)) AS qty_invoiced
    FROM "icebase"."dealers_360_3".artrandetail_info
    WHERE invoice IS NOT NULL AND TRIM(invoice) <> ''
    GROUP BY TRIM(invoice)
) qty_agg ON TRIM(i.invoice) = qty_agg.invoice_number
WHERE i.invoice IS NOT NULL AND TRIM(i.invoice) <> ''
