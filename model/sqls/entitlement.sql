WITH product_policies AS (
    -- Get all product-policy combinations
    SELECT 
        epr.productid AS entitlement_product_id,
        ep.id AS policy_id,
        TRIM(ep.name) AS policy_name,
        TRIM(ep.description) AS policy_description,
        CAST(ep.canviewproduct AS VARCHAR) AS can_view_product,
        CAST(ep.canviewprice AS VARCHAR) AS can_view_price,
        CAST(ep.isactive AS VARCHAR) AS is_active,
        p.productcode AS product_code,
        p.productclass AS product_class,
        p.product_id__c AS product_id
    FROM "icebase"."dealers_360_1".entitlement_product epr
    LEFT JOIN "icebase"."dealers_360_1".entitlement_policy ep
        ON epr.policyid = ep.id
    LEFT JOIN "icebase"."dealers_360_1".product p
        ON SUBSTR(epr.productid, 1, 15) = SUBSTR(p.product_id__c, 1, 15)
    WHERE epr.policyid IS NOT NULL
),

products_with_all_access AS (
    -- Find products that have "All Access for Harmar"
    SELECT DISTINCT entitlement_product_id
    FROM product_policies
    WHERE policy_name = 'All Access for Harmar'
),

final_entitlements AS (
    -- Apply priority logic
    SELECT 
        pp.*,
        CASE 
            WHEN pwa.entitlement_product_id IS NOT NULL THEN 1  -- Has All Access
            ELSE 0
        END AS has_all_access
    FROM product_policies pp
    LEFT JOIN products_with_all_access pwa
        ON pp.entitlement_product_id = pwa.entitlement_product_id
)

SELECT 
    -- Primary Key
    CONCAT(COALESCE(policy_id, ''), '-', COALESCE(product_id, '')) AS entitlement_id,
    
    -- Policy Info
    policy_id,
    policy_name AS entitlement_policy_name,
    policy_description AS entitlement_policy_description,
    can_view_product,
    can_view_price,
    is_active,
    
    -- Product Info
    NULLIF(TRIM(product_code), '') AS product_code,
    NULLIF(TRIM(product_class), '') AS product_class,
    product_id,
    
    -- Access Description (Priority Logic)
    CASE 
        WHEN has_all_access = 1 AND policy_name = 'All Access for Harmar' THEN 'Accessible to All'
        WHEN has_all_access = 1 AND policy_name != 'All Access for Harmar' THEN NULL  -- Will be filtered out
        WHEN policy_name = 'Lifeway' THEN 'Accessible to Lifeway'
        WHEN policy_name = 'Ameriglide' THEN 'Accessible to Ameriglide'
        WHEN policy_name = 'Leaf Home Safety Solutions' THEN 'Accessible to Leaf Home Safety Solutions'
        WHEN policy_name = 'Pollock Elevators Access' THEN 'Accessible to Pollock Elevators'
        WHEN policy_name = 'UP Access' THEN 'Accessible to UP'
        WHEN policy_name = 'Dev Access for Harmar' THEN 'Accessible to Dev (Harmar)'
        WHEN policy_name = 'All Access for Harmar TEST' THEN 'Accessible to All (Test)'
        ELSE CONCAT('Accessible to ', COALESCE(policy_name, 'Unknown'))
    END AS access_description

FROM final_entitlements
WHERE NOT (has_all_access = 1 AND policy_name != 'All Access for Harmar')  -- Filter out other policies if has All Access
