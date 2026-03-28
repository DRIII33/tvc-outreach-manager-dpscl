/* 
  SCRIPT: BigQuery_Intelligence_Scripts.sql
  PURPOSE: Segment unreached high-priority cohorts for the TVO-MI initiative.
  AUTHOR: Communications & Outreach Manager (Manager II)
*/

-- 1. IDENTIFY THE "CRITICAL AWARENESS GAP" COHORT
-- Targets: Female, Rural, Engagement > 1 Year, PACT Act Eligible.
CREATE OR REPLACE TABLE `driiiportfolio.outreach_intel.target_rural_females` AS
SELECT 
    veteran_id,
    era_of_service,
    disability_rating,
    engaged_program,
    last_engagement_days_ago
FROM 
    `driiiportfolio.outreach_intel.veteran_master_list`
WHERE 
    gender = 'Female' 
    AND county_type = 'Rural'
    AND last_engagement_days_ago > 365
    AND is_pact_act_eligible = TRUE
ORDER BY 
    disability_rating DESC;

-- 2. GULF WAR ERA II DISABILITY AUDIT
-- Justification: GWII veterans (33.9% of pop) often have ratings > 70%.
-- This query provides the data for the "Executive Briefing" on resource allocation.
SELECT 
    era_of_service,
    COUNT(veteran_id) AS cohort_count,
    ROUND(AVG(disability_rating), 2) AS avg_disability_rating,
    ROUND(AVG(last_engagement_days_ago), 0) AS avg_days_since_contact
FROM 
    `driiiportfolio.outreach_intel.veteran_master_list`
GROUP BY 
    era_of_service
ORDER BY 
    avg_disability_rating DESC;

-- 3. OUTREACH CHANNEL OPTIMIZATION (ROI PREP)
-- Identifies which programs are successfully engaging veterans vs. which are siloed.
SELECT 
    engaged_program,
    COUNT(veteran_id) AS engagement_volume,
    ROUND(AVG(outreach_clicks), 2) AS digital_responsiveness
FROM 
    `driiiportfolio.outreach_intel.veteran_master_list`
WHERE 
    county_type = 'Rural'
GROUP BY 
    engaged_program
HAVING 
    engagement_volume > 0
ORDER BY 
    digital_responsiveness ASC;
