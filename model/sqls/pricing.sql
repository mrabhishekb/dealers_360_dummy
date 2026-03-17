-- Pricing Data (DUMMY DATA - icebase.dealers_360)
-- stockcode from sor_contract_price (priority) + inv_price (if not in sor_contract_price)
-- customerbuygroup and fixedprice from sor_contract_price
-- sellingprice from inv_price for stockcodes not in sor_contract_price

SELECT 
    TRIM(CAST(stockcode AS VARCHAR)) AS stock_code,
    TRIM(CAST(customerbuygrp AS VARCHAR)) AS customer_buy_group,
    ROUND(COALESCE(fixedprice, 0), 2) AS price
FROM "icebase"."dealers_360_1".sor_contract_price
WHERE stockcode IS NOT NULL AND TRIM(CAST(stockcode AS VARCHAR)) <> ''

UNION ALL

SELECT 
    TRIM(CAST(stockcode AS VARCHAR)) AS stock_code,
    'NONE' AS customer_buy_group,
    ROUND(COALESCE(sellingprice, 0), 2) AS price
FROM "icebase"."dealers_360_1".inv_price
WHERE stockcode IS NOT NULL 
  AND TRIM(CAST(stockcode AS VARCHAR)) <> ''
  AND TRIM(CAST(stockcode AS VARCHAR)) NOT IN (
      SELECT DISTINCT TRIM(CAST(stockcode AS VARCHAR)) 
      FROM "icebase"."dealers_360_1".sor_contract_price 
      WHERE stockcode IS NOT NULL AND TRIM(CAST(stockcode AS VARCHAR)) <> ''
  )
