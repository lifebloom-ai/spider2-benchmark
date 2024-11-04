WITH Active_Branches_Pre_March_2020 AS (
    SELECT 
        STATE_ABBREVIATION, 
        COUNT(*) AS Active_Branches_Before_March_2020
    FROM 
        FINANCE__ECONOMICS.CYBERSYN.FINANCIAL_BRANCH_ENTITIES
    WHERE 
        IS_ACTIVE = TRUE
        AND START_DATE < '2020-03-01'
        AND (END_DATE IS NULL OR END_DATE >= '2020-03-01')
        AND STATE_ABBREVIATION IS NOT NULL
    GROUP BY 
        STATE_ABBREVIATION
),
Active_Branches_End_2021 AS (
    SELECT 
        STATE_ABBREVIATION, 
        COUNT(*) AS Active_Branches_End_Of_2021
    FROM 
        FINANCE__ECONOMICS.CYBERSYN.FINANCIAL_BRANCH_ENTITIES
    WHERE 
        IS_ACTIVE = TRUE
        AND START_DATE <= '2021-12-31'
        AND (END_DATE IS NULL OR END_DATE >= '2021-12-31')
        AND STATE_ABBREVIATION IS NOT NULL
    GROUP BY 
        STATE_ABBREVIATION
)
SELECT 
    COALESCE(p.STATE_ABBREVIATION, e.STATE_ABBREVIATION) AS STATE_ABBREVIATION,
    COALESCE(p.Active_Branches_Before_March_2020, 0) AS Active_Branches_Before_March_2020, 
    COALESCE(e.Active_Branches_End_Of_2021, 0) AS Active_Branches_End_Of_2021,
    CASE 
        WHEN COALESCE(p.Active_Branches_Before_March_2020, 0) = 0 THEN NULL
        ELSE ((COALESCE(e.Active_Branches_End_Of_2021, 0) - COALESCE(p.Active_Branches_Before_March_2020, 0)) / NULLIF(COALESCE(p.Active_Branches_Before_March_2020, 0), 0) * 100) 
    END AS Change_Ratio
FROM 
    Active_Branches_Pre_March_2020 p
FULL OUTER JOIN 
    Active_Branches_End_2021 e
ON 
    p.STATE_ABBREVIATION = e.STATE_ABBREVIATION
ORDER BY 
    STATE_ABBREVIATION;