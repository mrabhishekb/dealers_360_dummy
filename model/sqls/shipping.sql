-- Shipping / Order Tracking Data (DUMMY DATA - icebase.dealers_360)
-- Shipment tracking information from Harmar Order Tracking
-- Primary Key: shipping_id (InternalID)

SELECT 
    -- Primary Key (InternalID)
    CASE 
        WHEN internalid IS NULL OR TRIM(internalid) = '' THEN 'Undefined/Blank'
        ELSE TRIM(internalid)
    END AS shipping_id,
    
    -- System ID
    CAST(id AS BIGINT) AS system_id,
    
    -- Order Reference
    NULLIF(TRIM(ordernumber), '') AS order_number,
    
    -- Tracking Information
    CASE 
        WHEN mastertrackingid IS NULL OR TRIM(mastertrackingid) = '' THEN 'Undefined/Blank'
        ELSE TRIM(mastertrackingid)
    END AS master_tracking_id,
    NULLIF(TRIM(mastertrackinglink), '') AS tracking_link,
    
    -- Carrier Information
    NULLIF(TRIM(carriername), '') AS carrier_name,
    
    -- Serial Number
    NULLIF(TRIM(serialnumber), '') AS serial_number,
    
    -- Salesforce Reference
    NULLIF(TRIM(sourcesfOpp), '') AS source_sf_opp,
    NULLIF(TRIM(salesforceobjectty), '') AS salesforce_object_type,
    
    -- Processing Status
    CASE 
        WHEN processed IS NULL OR TRIM(processed) = '' THEN 'Unknown'
        WHEN processed IN ('Yes', 'No', 'Failed') THEN processed
        ELSE 'Unknown'
    END AS processed_status,
    
    -- Shipping Status
    CASE 
        WHEN shippingstatus IS NULL OR TRIM(shippingstatus) = '' THEN 'Unknown'
        ELSE TRIM(shippingstatus)
    END AS shipping_status,
    
    -- Process Date/Time
    processdatetime AS process_date_time

FROM "icebase"."dealers_360_2".harmar_order_tracking
WHERE internalid IS NOT NULL AND TRIM(internalid) <> ''
