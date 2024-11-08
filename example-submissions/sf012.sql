SELECT 
  EXTRACT(YEAR FROM DATE_OF_LOSS) AS year, 
  SUM(COALESCE(AMOUNT_PAID_ON_BUILDING_CLAIM, 0)) AS total_building_damage, 
  SUM(COALESCE(AMOUNT_PAID_ON_CONTENTS_CLAIM, 0)) AS total_contents_damage,
  SUM(COALESCE(AMOUNT_PAID_ON_BUILDING_CLAIM, 0) + COALESCE(AMOUNT_PAID_ON_CONTENTS_CLAIM, 0)) AS total_damage
FROM WEATHER__ENVIRONMENT.CYBERSYN.FEMA_NATIONAL_FLOOD_INSURANCE_PROGRAM_CLAIM_INDEX
WHERE NFIP_COMMUNITY_NAME = 'City Of New York'
  AND DATE_OF_LOSS BETWEEN '2010-01-01' AND '2019-12-31'
GROUP BY year
ORDER BY year;