-- VIP Tier Configuration (DUMMY DATA - icebase.dealers_360)
-- Use Case 1: VIP Spending & Performance Tracking
-- Defines tier thresholds for dealer classification
-- 4 Tiers: Bronze ($0-$50K), Silver ($50K-$100K), Gold ($100K-$200K), Platinum ($200K+)

SELECT 
    customer_buying_group,
    tier,
    range AS tier_range,
    CAST(min AS DOUBLE) AS min_threshold,
    CAST(max AS DOUBLE) AS max_threshold,
    CASE 
        WHEN tier = 'Platinum' THEN 4
        WHEN tier = 'Gold' THEN 3
        WHEN tier = 'Silver' THEN 2
        WHEN tier = 'Bronze' THEN 1
        ELSE 0
    END AS tier_rank,
    CASE 
        WHEN tier = 'Platinum' THEN 'Highest tier with maximum benefits ($200,000+)'
        WHEN tier = 'Gold' THEN 'Premium tier with significant benefits ($100,001-$200,000)'
        WHEN tier = 'Silver' THEN 'Mid-tier with good benefits ($50,001-$100,000)'
        WHEN tier = 'Bronze' THEN 'Entry-level tier ($0-$50,000)'
        ELSE 'Unknown'
    END AS tier_description,
    CASE 
        WHEN tier = 'Platinum' THEN 'Gold'
        WHEN tier = 'Gold' THEN 'Silver'
        WHEN tier = 'Silver' THEN 'Bronze'
        ELSE 'None'
    END AS previous_tier,
    CASE 
        WHEN tier = 'Bronze' THEN 'Silver'
        WHEN tier = 'Silver' THEN 'Gold'
        WHEN tier = 'Gold' THEN 'Platinum'
        ELSE 'Platinum (Max)'
    END AS next_tier,
    true AS is_active
FROM "icebase"."dealers_360".vip_tier_config
