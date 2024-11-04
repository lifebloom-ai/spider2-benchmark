WITH home_depot AS (
    SELECT poi.POI_ID as HD_POI_ID, poi.POI_NAME as HD_POI_NAME, LATITUDE, LONGITUDE
    FROM US_ADDRESSES__POI.CYBERSYN.POINT_OF_INTEREST_INDEX poi
    JOIN US_ADDRESSES__POI.CYBERSYN.POINT_OF_INTEREST_ADDRESSES_RELATIONSHIPS rel ON poi.POI_ID = rel.POI_ID
    JOIN US_ADDRESSES__POI.CYBERSYN.US_ADDRESSES usa ON rel.ADDRESS_ID = usa.ADDRESS_ID
    WHERE POI_NAME = 'The Home Depot'
),
lowes AS (
    SELECT poi.POI_ID as LW_POI_ID, poi.POI_NAME as LW_POI_NAME, LATITUDE, LONGITUDE
    FROM US_ADDRESSES__POI.CYBERSYN.POINT_OF_INTEREST_INDEX poi
    JOIN US_ADDRESSES__POI.CYBERSYN.POINT_OF_INTEREST_ADDRESSES_RELATIONSHIPS rel ON poi.POI_ID = rel.POI_ID
    JOIN US_ADDRESSES__POI.CYBERSYN.US_ADDRESSES usa ON rel.ADDRESS_ID = usa.ADDRESS_ID
    WHERE POI_NAME = 'Lowe''s Home Improvement'
)
SELECT 
    hd.HD_POI_ID as Home_Depot_POI_ID,
    hd.HD_POI_NAME as Home_Depot_Name,
    lw.LW_POI_ID as Lowe_POI_ID,
    lw.LW_POI_NAME as Lowe_Name,
    3959 * acos(
        cos(radians(hd.LATITUDE)) 
        * cos(radians(lw.LATITUDE)) 
        * cos(radians(lw.LONGITUDE) - radians(hd.LONGITUDE)) 
        + sin(radians(hd.LATITUDE)) 
        * sin(radians(lw.LATITUDE))
    ) AS distance_miles
FROM home_depot hd
CROSS JOIN lowes lw
QUALIFY ROW_NUMBER() OVER (PARTITION BY hd.HD_POI_ID ORDER BY distance_miles ASC) = 1
ORDER BY hd.HD_POI_ID, distance_miles ASC;