WITH AddressInspection AS (
  SELECT 
    id,
    class,
    subclass,
    surface_area_sq_m,
    f.value::string AS addr_string_key
  FROM 
    NETHERLANDS_OPEN_MAP_DATA.NETHERLANDS.V_BUILDING,
    LATERAL FLATTEN(input => PARSE_JSON(contains_addresses)) AS f
),
CityCategorization AS (
  SELECT 
    id,
    class,
    subclass,
    surface_area_sq_m,
    addr_string_key,
    CASE 
      WHEN addr_string_key LIKE '%"addr:city":"Amsterdam"%' THEN 'Amsterdam'
      WHEN addr_string_key LIKE '%"addr:city":"Rotterdam"%' THEN 'Rotterdam'
      ELSE NULL
    END AS city
  FROM 
    AddressInspection
)
SELECT 
  city,
  class,
  subclass,
  COUNT(id) AS building_count,
  SUM(surface_area_sq_m) AS total_surface_area
FROM 
  CityCategorization
WHERE 
  city IS NOT NULL
GROUP BY 
  city, class, subclass
ORDER BY 
  city, class, subclass;