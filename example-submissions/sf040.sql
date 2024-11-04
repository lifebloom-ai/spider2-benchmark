SELECT "LATITUDE", "NUMBER", "STREET", COALESCE("STREET_TYPE", 'N/A') AS "STREET_TYPE"
FROM US_REAL_ESTATE.CYBERSYN.US_ADDRESSES
WHERE "ZIP" = '33852'
ORDER BY "LATITUDE" DESC
LIMIT 10;