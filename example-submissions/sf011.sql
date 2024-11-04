SELECT g."BlockGroupID", g."StateCountyTractID", g."TractCode", v."CensusValue" AS Population
FROM "CENSUS_GALAXY__ZIP_CODE_TO_BLOCK_GROUP_SAMPLE"."PUBLIC"."Dim_CensusGeography" g
JOIN "CENSUS_GALAXY__ZIP_CODE_TO_BLOCK_GROUP_SAMPLE"."PUBLIC"."Fact_CensusValues_ACS2021" v
ON g."BlockGroupID" = v."BlockGroupID"
WHERE g."StateFIPS" = '36'
LIMIT 10;