WITH ValidCommute AS (
    SELECT 
        VARIABLE, VARIABLE_NAME, SERIES_ID, MEASURE
    FROM 
        GLOBAL_GOVERNMENT.CYBERSYN.AMERICAN_COMMUNITY_SURVEY_ATTRIBUTES
    WHERE 
        VARIABLE_NAME ILIKE '%60 to 89 minutes%' AND
        MEASUREMENT_PERIOD = '1YR'
)
SELECT DISTINCT
    VC.VARIABLE, VC.VARIABLE_NAME, VC.MEASURE
FROM
    ValidCommute VC
LIMIT 10;