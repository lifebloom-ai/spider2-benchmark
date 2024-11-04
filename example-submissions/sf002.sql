WITH asset_data AS (
    SELECT FDIC_INSTITUTION_ID, VALUE AS Total_Assets
    FROM FINANCE__ECONOMICS.CYBERSYN.FDIC_SUMMARY_OF_DEPOSITS_TIMESERIES
    WHERE VARIABLE = 'ASSET' AND DATE = '2022-06-30'
), deposit_data AS (
    SELECT FDIC_INSTITUTION_ID, VALUE AS Total_Deposits
    FROM FINANCE__ECONOMICS.CYBERSYN.FDIC_SUMMARY_OF_DEPOSITS_TIMESERIES
    WHERE VARIABLE = 'DEPSUM' AND DATE = '2022-06-30'
)
SELECT 
    a.FDIC_INSTITUTION_ID,
    a.Total_Assets,
    d.Total_Deposits,
    ((a.Total_Assets - d.Total_Deposits) / a.Total_Assets) * 100 AS Percentage_Uninsured
FROM asset_data a
JOIN deposit_data d ON a.FDIC_INSTITUTION_ID = d.FDIC_INSTITUTION_ID
WHERE a.Total_Assets > 10000000 -- adjusted threshold based on data range
ORDER BY Percentage_Uninsured DESC
LIMIT 10;