WITH Traffic_CTE AS ( SELECT DATE, ASIN, GLANCE_VIEWS FROM AMAZON_VENDOR_ANALYTICS__SAMPLE_DATASET.PUBLIC.RETAIL_ANALYTICS_TRAFFIC WHERE DISTRIBUTOR_VIEW = 'Manufacturing' AND DATE BETWEEN '2022-01-07' AND '2022-02-06' ), Sales_CTE AS ( SELECT DATE, ASIN, ORDERED_UNITS AS SALES_UNITS, SHIPPED_UNITS, SHIPPED_REVENUE FROM AMAZON_VENDOR_ANALYTICS__SAMPLE_DATASET.PUBLIC.RETAIL_ANALYTICS_SALES WHERE DISTRIBUTOR_VIEW = 'Manufacturing' AND DATE BETWEEN '2022-01-07' AND '2022-02-06' ), Inventory_CTE AS ( SELECT DATE, ASIN, SELLABLE_ON_HAND_INVENTORY FROM AMAZON_VENDOR_ANALYTICS__SAMPLE_DATASET.PUBLIC.RETAIL_ANALYTICS_INVENTORY WHERE DATE BETWEEN '2022-01-07' AND '2022-02-06' ), NetPPM_CTE AS ( SELECT DATE, ASIN, NET_PPM FROM AMAZON_VENDOR_ANALYTICS__SAMPLE_DATASET.PUBLIC.RETAIL_ANALYTICS_NET_PPM WHERE DATE BETWEEN '2022-01-07' AND '2022-02-06' ) SELECT t.DATE, t.ASIN, t.GLANCE_VIEWS, IFNULL(s.SALES_UNITS, 0) AS SALES_UNITS, IFNULL(s.SHIPPED_UNITS, 0) AS SHIPPED_UNITS, IFNULL(s.SHIPPED_REVENUE, 0) AS SHIPPED_REVENUE, ROUND(IFNULL(s.SALES_UNITS, 0) / NULLIF(t.GLANCE_VIEWS, 0), 4) AS CONVERSION_RATE, CASE WHEN s.SHIPPED_UNITS > 0 THEN ROUND(IFNULL(s.SHIPPED_REVENUE, 0) / s.SHIPPED_UNITS, 2) ELSE NULL END AS ASP, i.SELLABLE_ON_HAND_INVENTORY, n.NET_PPM FROM Traffic_CTE t LEFT JOIN Sales_CTE s ON t.ASIN = s.ASIN AND t.DATE = s.DATE LEFT JOIN Inventory_CTE i ON t.ASIN = i.ASIN AND t.DATE = i.DATE LEFT JOIN NetPPM_CTE n ON t.ASIN = n.ASIN AND t.DATE = n.DATE ORDER BY t.DATE, t.ASIN;