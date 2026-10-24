-- =========================================================
-- HEALTHCARE SQL ANALYSIS PORTFOLIO
-- Synthetic Healthcare Dataset
-- MySQL
-- =========================================================

-- DISCLAIMER:
-- This project uses a completely synthetic healthcare dataset
-- created solely for educational and portfolio purposes.
-- No real patient or organisational data is used.

USE vitalink_healthcare_portfolio;


-- =========================================================
-- SECTION 1: DATABASE SETUP AND INITIAL VALIDATION
-- =========================================================

-- Confirm that each raw table was imported successfully
-- and contains the expected number of records.

SELECT 'patients_raw' AS table_name, COUNT(*) AS row_count
FROM patients_raw

UNION ALL

SELECT 'facilities_raw', COUNT(*)
FROM facilities_raw

UNION ALL

SELECT 'disease_cases_raw', COUNT(*)
FROM disease_cases_raw

UNION ALL

SELECT 'visits_raw', COUNT(*)
FROM visits_raw;


-- Review table structures and imported data types.

DESCRIBE patients_raw;
DESCRIBE facilities_raw;
DESCRIBE disease_cases_raw;
DESCRIBE visits_raw;


-- Preview sample records from each raw table.

SELECT * FROM patients_raw LIMIT 5;
SELECT * FROM facilities_raw LIMIT 5;
SELECT * FROM disease_cases_raw LIMIT 5;
SELECT * FROM visits_raw LIMIT 5;

-- INITIAL VALIDATION SUMMARY:
-- All four raw datasets were imported successfully.
-- Row counts were validated against the source data.
-- Table structures and sample records were reviewed
-- before beginning data-quality checks.


-- =========================================================
-- SECTION 2: MISSING VALUES ASSESSMENT
-- =========================================================

-- Check all columns in visits_raw for SQL NULLs
-- and blank text values.

SELECT
    SUM(visit_id IS NULL) AS missing_visit_id,
    SUM(patient_id IS NULL) AS missing_patient_id,
    SUM(facility_id IS NULL) AS missing_facility_id,
    SUM(visit_date IS NULL OR TRIM(visit_date) = '') AS missing_visit_date,
    SUM(visit_type IS NULL OR TRIM(visit_type) = '') AS missing_visit_type,
    SUM(wait_time_minutes IS NULL) AS missing_wait_time,
    SUM(consultation_minutes IS NULL) AS missing_consultation_time,
    SUM(outcome IS NULL OR TRIM(outcome) = '') AS missing_outcome,
    SUM(satisfaction_score IS NULL OR TRIM(satisfaction_score) = '')
        AS missing_satisfaction_score
FROM visits_raw;

SELECT *
FROM visits_raw
WHERE satisfaction_score IS NULL
   OR TRIM(satisfaction_score) = '';
   
   
   
-- Check all columns in patients_raw.

SELECT
    SUM(patient_id IS NULL) AS missing_patient_id,
    SUM(first_name IS NULL OR TRIM(first_name) = '') AS missing_first_name,
    SUM(last_name IS NULL OR TRIM(last_name) = '') AS missing_last_name,
    SUM(gender IS NULL OR TRIM(gender) = '') AS missing_gender,
    SUM(date_of_birth IS NULL OR TRIM(date_of_birth) = '') AS missing_date_of_birth,
    SUM(city IS NULL OR TRIM(city) = '') AS missing_city,
    SUM(insurance_status IS NULL OR TRIM(insurance_status) = '')
        AS missing_insurance_status
FROM patients_raw;

SELECT *
FROM patients_raw
WHERE insurance_status IS NULL
   OR TRIM(insurance_status) = '';
   
   
-- Check all columns in facilities_raw.

SELECT
    SUM(facility_id IS NULL) AS missing_facility_id,
    SUM(facility_name IS NULL OR TRIM(facility_name) = '')
        AS missing_facility_name,
    SUM(city IS NULL OR TRIM(city) = '') AS missing_city,
    SUM(facility_type IS NULL OR TRIM(facility_type) = '')
        AS missing_facility_type,
    SUM(bed_capacity IS NULL) AS missing_bed_capacity
FROM facilities_raw;

-- Check all columns in disease_cases_raw.

SELECT
    SUM(case_id IS NULL) AS missing_case_id,
    SUM(patient_id IS NULL) AS missing_patient_id,
    SUM(facility_id IS NULL) AS missing_facility_id,
    SUM(diagnosis_date IS NULL) AS missing_diagnosis_date,
    SUM(disease IS NULL OR TRIM(disease) = '') AS missing_disease,
    SUM(severity IS NULL OR TRIM(severity) = '') AS missing_severity,
    SUM(status IS NULL OR TRIM(status) = '') AS missing_status
FROM disease_cases_raw;

-- MISSING VALUES SUMMARY:
-- visits_raw contains 18 missing satisfaction_score values.
-- patients_raw contains 7 missing insurance_status values.
-- facilities_raw contains no missing values.
-- disease_cases_raw contains no missing values.
-- Missing satisfaction and insurance values were retained as genuinely
-- unknown rather than being replaced with unsupported assumptions.


-- =========================================================
-- SECTION 3: DUPLICATE RECORD ASSESSMENT
-- =========================================================

-- Compare total rows with distinct primary IDs in visits_raw.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT visit_id) AS unique_visit_ids
FROM visits_raw;

SELECT
    visit_id,
    COUNT(*) AS duplicate_count
FROM visits_raw
GROUP BY visit_id
HAVING COUNT(*) > 1;

SELECT *
FROM visits_raw
WHERE visit_id IN (50114, 50409, 50460, 50705)
ORDER BY visit_id;

-- Check patients_raw.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT patient_id) AS unique_patient_ids
FROM patients_raw;


-- Check facilities_raw.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT facility_id) AS unique_facility_ids
FROM facilities_raw;


-- Check disease_cases_raw.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT case_id) AS unique_case_ids
FROM disease_cases_raw;

-- DUPLICATE ASSESSMENT SUMMARY:
-- visits_raw contains 724 rows but only 720 unique visit IDs.
-- Four visit IDs were duplicated, and inspection confirmed
-- that each duplicate pair contains identical records.
--
-- patients_raw, facilities_raw and disease_cases_raw
-- contain unique primary identifiers with no duplicate records.
--
-- The four exact duplicate visit records will be removed
-- when creating visits_clean.


-- =========================================================
-- SECTION 4: INVALID AND INCONSISTENT VALUES REVIEW
-- =========================================================

-- Review visit_type values for inconsistent categories,
-- spacing issues, or unexpected entries.

SELECT DISTINCT visit_type
FROM visits_raw
ORDER BY visit_type;

-- Compare original values with trimmed values to identify
-- hidden leading or trailing spaces.

SELECT
    visit_type,
    TRIM(visit_type) AS cleaned_visit_type,
    COUNT(*) AS record_count
FROM visits_raw
GROUP BY visit_type, TRIM(visit_type)
ORDER BY cleaned_visit_type;

SELECT DISTINCT outcome
FROM visits_raw
ORDER BY outcome;

-- Review numeric ranges for potentially invalid or unusual values.

SELECT
    MIN(wait_time_minutes) AS minimum_wait_time,
    MAX(wait_time_minutes) AS maximum_wait_time,
    MIN(consultation_minutes) AS minimum_consultation_time,
    MAX(consultation_minutes) AS maximum_consultation_time
FROM visits_raw;

SELECT *
FROM visits_raw
WHERE wait_time_minutes >= 180
ORDER BY wait_time_minutes DESC;

SELECT
    MIN(CAST(satisfaction_score AS DECIMAL(2,1))) AS minimum_satisfaction,
    MAX(CAST(satisfaction_score AS DECIMAL(2,1))) AS maximum_satisfaction
FROM visits_raw
WHERE satisfaction_score IS NOT NULL
  AND TRIM(satisfaction_score) <> '';
  
-- Review patient categorical values.

SELECT DISTINCT gender
FROM patients_raw
ORDER BY gender;

SELECT DISTINCT city
FROM patients_raw
ORDER BY city;

SELECT DISTINCT insurance_status
FROM patients_raw
ORDER BY insurance_status;

-- Review facility categories and bed-capacity range.

SELECT DISTINCT facility_type
FROM facilities_raw
ORDER BY facility_type;

SELECT DISTINCT city
FROM facilities_raw
ORDER BY city;

SELECT
    MIN(bed_capacity) AS minimum_bed_capacity,
    MAX(bed_capacity) AS maximum_bed_capacity
FROM facilities_raw;

-- Review disease-case categorical values.

SELECT DISTINCT disease
FROM disease_cases_raw
ORDER BY disease;

SELECT DISTINCT severity
FROM disease_cases_raw
ORDER BY severity;

SELECT DISTINCT status
FROM disease_cases_raw
ORDER BY status;

-- INVALID / INCONSISTENT VALUES SUMMARY:
-- A trailing-space inconsistency was identified in visit_type,
-- where some Emergency values contained extra whitespace.
--
-- Waiting times ranged from 3 to 360 minutes.
-- High waiting times were reviewed but retained because unusual
-- values are not automatically invalid without evidence.
--
-- Consultation times ranged from 5 to 69 minutes.
-- Satisfaction scores remained within the expected 1-to-5 range.
-- Facility bed capacity ranged from 55 to 180.
--
-- Remaining categorical values were reviewed and found to be
-- consistent enough for cleaning and analysis.


-- =========================================================
-- SECTION 5: REFERENTIAL INTEGRITY CHECKS
-- =========================================================

-- Check whether any visits reference a patient
-- that does not exist in patients_raw.

SELECT COUNT(*) AS unmatched_visit_patients
FROM visits_raw v
LEFT JOIN patients_raw p
    ON v.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- Check whether any visits reference a facility
-- that does not exist in facilities_raw.

SELECT COUNT(*) AS unmatched_visit_facilities
FROM visits_raw v
LEFT JOIN facilities_raw f
    ON v.facility_id = f.facility_id
WHERE f.facility_id IS NULL;

-- Check whether any disease cases reference a patient
-- that does not exist in patients_raw.

SELECT COUNT(*) AS unmatched_case_patients
FROM disease_cases_raw d
LEFT JOIN patients_raw p
    ON d.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- Check whether any disease cases reference a facility
-- that does not exist in facilities_raw.

SELECT COUNT(*) AS unmatched_case_facilities
FROM disease_cases_raw d
LEFT JOIN facilities_raw f
    ON d.facility_id = f.facility_id
WHERE f.facility_id IS NULL;

-- REFERENTIAL INTEGRITY SUMMARY:
-- All four relationship checks returned zero unmatched records.
--
-- Every visit references an existing patient and facility.
-- Every disease case also references an existing patient and facility.
--
-- This confirms that the raw dataset contains valid relationships
-- between the transactional and reference tables before clean-table
-- constraints are implemented.


-- =========================================================
-- SECTION 6: CLEAN TABLE CREATION AND TRANSFORMATION
-- =========================================================

-- The raw source tables are preserved unchanged.
-- Separate clean tables are created for analysis.

-- Drop clean tables in dependency-safe order if recreating
-- the project from the beginning.

DROP TABLE IF EXISTS visits_clean;
DROP TABLE IF EXISTS disease_cases_clean;
DROP TABLE IF EXISTS facilitis_clean;
DROP TABLE IF EXISTS patients_clean;

CREATE TABLE patients_clean (
    patient_id INT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    city VARCHAR(20) NOT NULL,
    insurance_status VARCHAR(20),
    PRIMARY KEY (patient_id)
);

INSERT INTO patients_clean (
    patient_id,
    first_name,
    last_name,
    gender,
    date_of_birth,
    city,
    insurance_status
)
SELECT
    patient_id,
    TRIM(first_name),
    TRIM(last_name),
    TRIM(gender),
    STR_TO_DATE(date_of_birth, '%c/%e/%Y'),
    TRIM(city),
    NULLIF(TRIM(insurance_status), '')
FROM patients_raw;

CREATE TABLE facilitis_clean (
    facility_id INT NOT NULL,
    facility_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    facility_type VARCHAR(50) NOT NULL,
    bed_capacity INT NOT NULL,
    PRIMARY KEY (facility_id)
);

INSERT INTO facilitis_clean (
    facility_id,
    facility_name,
    city,
    facility_type,
    bed_capacity
)
SELECT
    facility_id,
    TRIM(facility_name),
    TRIM(city),
    TRIM(facility_type),
    bed_capacity
FROM facilities_raw;

CREATE TABLE disease_cases_clean (
    case_id INT NOT NULL,
    patient_id INT NOT NULL,
    facility_id INT NOT NULL,
    diagnosis_date DATE NOT NULL,
    disease VARCHAR(50) NOT NULL,
    severity VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    PRIMARY KEY (case_id)
);

INSERT INTO disease_cases_clean (
    case_id,
    patient_id,
    facility_id,
    diagnosis_date,
    disease,
    severity,
    status
)
SELECT
    case_id,
    patient_id,
    facility_id,
    diagnosis_date,
    TRIM(disease),
    TRIM(severity),
    TRIM(status)
FROM disease_cases_raw;

CREATE TABLE visits_clean (
    visit_id INT NOT NULL,
    patient_id INT NOT NULL,
    facility_id INT NOT NULL,
    visit_date DATE NOT NULL,
    visit_type VARCHAR(30) NOT NULL,
    wait_time_minutes INT NOT NULL,
    consultation_minutes INT NOT NULL,
    outcome VARCHAR(30) NOT NULL,
    satisfaction_score DECIMAL(2,1),
    PRIMARY KEY (visit_id)
);

INSERT INTO visits_clean (
    visit_id,
    patient_id,
    facility_id,
    visit_date,
    visit_type,
    wait_time_minutes,
    consultation_minutes,
    outcome,
    satisfaction_score
)
SELECT DISTINCT
    visit_id,
    patient_id,
    facility_id,
    STR_TO_DATE(visit_date, '%c/%e/%Y'),
    TRIM(visit_type),
    wait_time_minutes,
    consultation_minutes,
    TRIM(outcome),
    CAST(
        NULLIF(TRIM(satisfaction_score), '')
        AS DECIMAL(2,1)
    )
FROM visits_raw;

-- Validate clean-table row counts.

SELECT COUNT(*) AS patient_rows
FROM patients_clean;

SELECT COUNT(*) AS facility_rows
FROM facilitis_clean;

SELECT COUNT(*) AS disease_case_rows
FROM disease_cases_clean;

SELECT COUNT(*) AS visit_rows
FROM visits_clean;


-- Confirm missing values were converted to SQL NULL.

SELECT COUNT(*) AS missing_insurance_status
FROM patients_clean
WHERE insurance_status IS NULL;

SELECT COUNT(*) AS missing_satisfaction_scores
FROM visits_clean
WHERE satisfaction_score IS NULL;

-- CLEAN TABLE SUMMARY:
-- Raw source tables were retained unchanged for traceability.
--
-- Clean tables were created with explicit data types,
-- primary keys and appropriate NULL handling.
--
-- Text values were standardised using TRIM().
-- Blank unknown values were converted to SQL NULL.
-- Raw visit and patient date strings were converted to DATE.
-- The four confirmed duplicate visit records were removed.
--
-- Final clean row counts:
-- patients_clean:       250
-- facilitis_clean:       6
-- disease_cases_clean:  220
-- visits_clean:         720


-- =========================================================
-- SECTION 7: FOREIGN KEY CONSTRAINTS AND VALIDATION
-- =========================================================

-- Enforce the validated relationships in visits_clean.

ALTER TABLE visits_clean
ADD CONSTRAINT fk_visits_patient
FOREIGN KEY (patient_id)
REFERENCES patients_clean(patient_id);

ALTER TABLE visits_clean
ADD CONSTRAINT fk_visits_facility
FOREIGN KEY (facility_id)
REFERENCES facilitis_clean(facility_id);


-- Enforce the validated relationships in disease_cases_clean.

ALTER TABLE disease_cases_clean
ADD CONSTRAINT fk_disease_cases_patient
FOREIGN KEY (patient_id)
REFERENCES patients_clean(patient_id);

ALTER TABLE disease_cases_clean
ADD CONSTRAINT fk_disease_cases_facility
FOREIGN KEY (facility_id)
REFERENCES facilitis_clean(facility_id);

-- Confirm that the expected foreign-key constraints exist.

SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'vitalink_healthcare_portfolio'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

-- FOREIGN KEY SUMMARY:
-- Foreign-key constraints were added after the raw-data
-- relationship checks confirmed zero unmatched records.
--
-- visits_clean now enforces valid patient and facility references.
-- disease_cases_clean also enforces valid patient and facility references.
--
-- This helps prevent invalid future records from referencing
-- patients or facilitis that do not exist in the clean database.

-- =========================================================
-- SECTION 8: FINAL CLEAN DATASET VALIDATION
-- =========================================================

-- Confirm final row counts across all cleaned tables.

SELECT 'patients_clean' AS table_name, COUNT(*) AS row_count
FROM patients_clean

UNION ALL

SELECT 'facilitis_clean', COUNT(*)
FROM facilitis_clean

UNION ALL

SELECT 'disease_cases_clean', COUNT(*)
FROM disease_cases_clean

UNION ALL

SELECT 'visits_clean', COUNT(*)
FROM visits_clean;

-- Confirm that duplicate visit IDs no longer exist.

SELECT COUNT(*) AS duplicate_visit_ids
FROM (
    SELECT visit_id
    FROM visits_clean
    GROUP BY visit_id
    HAVING COUNT(*) > 1
) AS duplicates;


-- Confirm the remaining intentionally missing values.

SELECT COUNT(*) AS missing_satisfaction_scores
FROM visits_clean
WHERE satisfaction_score IS NULL;

SELECT COUNT(*) AS missing_insurance_status
FROM patients_clean
WHERE insurance_status IS NULL;

-- FINAL VALIDATION SUMMARY:
-- All clean tables contain the expected number of records.
-- Duplicate visit IDs have been removed.
--
-- The 18 unknown satisfaction scores and 7 unknown insurance
-- values remain as SQL NULL because no evidence was available
-- to justify replacing them.
--
-- The cleaned relational dataset is now ready for analysis.


-- =========================================================
-- SECTION 9: BUSINESS QUESTION 1
-- FACILITY DEMAND AND PERFORMANCE
-- =========================================================

-- Which healthcare facilities experience the highest patient demand,
-- and how do they compare in terms of patient volume,
-- average waiting time, average consultation time,
-- and patient satisfaction?

SELECT
    f.facility_name,
    COUNT(v.visit_id) AS patient_volume,
    ROUND(AVG(v.wait_time_minutes), 1) AS avg_wait_time_minutes,
    ROUND(AVG(v.consultation_minutes), 1) AS avg_consultation_time_minutes,
    ROUND(AVG(v.satisfaction_score), 1) AS avg_satisfaction_score
FROM visits_clean v
JOIN facilitis_clean f
    ON v.facility_id = f.facility_id
GROUP BY
    f.facility_id,
    f.facility_name
ORDER BY patient_volume DESC;

-- KEY FINDINGS:
-- Vitalink Central Hospital recorded the highest patient volume
-- with 183 visits.
--
-- Vitalink Port Harcourt Clinic had the longest average
-- waiting time at approximately 50.0 minutes.
--
-- Vitalink Lekki Medical Centre had the longest average
-- consultation time at approximately 29.4 minutes.
--
-- Average satisfaction was 3.8 across five facilities,
-- while Vitalink Benin Medical Centre recorded 3.6.
--
-- Higher patient volume did not consistently correspond
-- to longer waiting times or lower patient satisfaction.


-- =========================================================
-- SECTION 10: BUSINESS QUESTION 2
-- DISEASE SURVEILLANCE AND SEVERITY
-- =========================================================

-- Which diseases are most frequently recorded?

SELECT
    disease,
    COUNT(*) AS total_cases
FROM disease_cases_clean
GROUP BY disease
ORDER BY total_cases DESC;

-- How are disease cases distributed across healthcare facilities?

SELECT
    f.facility_name,
    COUNT(d.case_id) AS total_cases
FROM disease_cases_clean d
JOIN facilitis_clean f
    ON d.facility_id = f.facility_id
GROUP BY
    f.facility_id,
    f.facility_name
ORDER BY total_cases DESC;

-- How are disease cases distributed across cities?

SELECT
    f.city,
    COUNT(d.case_id) AS total_cases
FROM disease_cases_clean d
JOIN facilitis_clean f
    ON d.facility_id = f.facility_id
GROUP BY f.city
ORDER BY total_cases DESC;

-- Which diseases have the highest proportion of severe cases?

SELECT
    disease,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN severity = 'Severe' THEN 1 ELSE 0 END) AS severe_cases,
    ROUND(
        100.0 * SUM(CASE WHEN severity = 'Severe' THEN 1 ELSE 0 END)
        / COUNT(*),
        1
    ) AS severe_case_percentage
FROM disease_cases_clean
GROUP BY disease
ORDER BY severe_case_percentage DESC;

-- KEY FINDINGS:
-- Malaria was the most frequently recorded disease with 72 cases.
--
-- Lagos recorded the highest overall disease-case volume with 113 cases.
--
-- Vitalink Lekki Medical Centre and Vitalink Benin Medical Centre
-- each recorded 44 disease cases, the highest facility-level totals.
--
-- Hypertension had the highest proportion of severe cases
-- at approximately 18.4%.
--
-- Malaria had the highest absolute number of severe cases,
-- but hypertension had the highest severe-case percentage.
--
-- Comparing proportions provides a fairer severity comparison
-- across diseases with different overall case volumes.


-- =========================================================
-- SECTION 11: BUSINESS QUESTION 3
-- INSURANCE STATUS AND HEALTHCARE ACCESS
-- =========================================================

-- Review the number of patients in each known insurance group.
-- Patients with unknown insurance status are excluded from
-- the insured-versus-uninsured comparison.

SELECT
    insurance_status,
    COUNT(*) AS patient_count
FROM patients_clean
WHERE insurance_status IN ('Insured', 'Uninsured')
GROUP BY insurance_status;

-- Compare average healthcare utilisation per patient.
-- LEFT JOIN retains patients even if they recorded zero visits.

SELECT
    p.insurance_status,
    COUNT(DISTINCT p.patient_id) AS total_patients,
    COUNT(v.visit_id) AS total_visits,
    ROUND(
        COUNT(v.visit_id) / COUNT(DISTINCT p.patient_id),
        2
    ) AS avg_visits_per_patient
FROM patients_clean p
LEFT JOIN visits_clean v
    ON p.patient_id = v.patient_id
WHERE p.insurance_status IN ('Insured', 'Uninsured')
GROUP BY p.insurance_status;

-- Compare the proportion of recorded visits that were emergencies.

SELECT
    p.insurance_status,
    COUNT(v.visit_id) AS total_visits,
    SUM(
        CASE
            WHEN v.visit_type = 'Emergency' THEN 1
            ELSE 0
        END
    ) AS emergency_visits,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN v.visit_type = 'Emergency' THEN 1
                ELSE 0
            END
        ) / COUNT(v.visit_id),
        2
    ) AS emergency_visit_percentage
FROM visits_clean v
JOIN patients_clean p
    ON v.patient_id = p.patient_id
WHERE p.insurance_status IN ('Insured', 'Uninsured')
GROUP BY p.insurance_status;

-- Compare service experience between insured and uninsured patients.

SELECT
    p.insurance_status,
    ROUND(AVG(v.wait_time_minutes), 2) AS avg_wait_time_minutes,
    ROUND(AVG(v.satisfaction_score), 2) AS avg_satisfaction_score
FROM visits_clean v
JOIN patients_clean p
    ON v.patient_id = p.patient_id
WHERE p.insurance_status IN ('Insured', 'Uninsured')
GROUP BY p.insurance_status;

-- KEY FINDINGS:
-- Uninsured patients recorded slightly higher average healthcare
-- utilisation at approximately 3.04 visits per patient compared
-- with 2.83 among insured patients.
--
-- Emergency-service use was almost identical:
-- approximately 17.43% for insured patients and
-- 17.48% for uninsured patients.
--
-- Uninsured patients had a slightly shorter average waiting time,
-- while insured patients recorded slightly higher satisfaction.
--
-- Overall differences between the two groups were relatively small.
-- Based on this dataset alone, there is no strong evidence of a
-- major healthcare access gap associated with insurance status.
--
-- These results show association only and should not be interpreted
-- as evidence that insurance status causes the observed differences.



-- =========================================================
-- SECTION 12: PROJECT SUMMARY
-- =========================================================

-- PROJECT SUMMARY:
--
-- This project demonstrated an end-to-end SQL healthcare
-- analytics workflow using a fully synthetic dataset.
--
-- The workflow included:
-- 1. Initial data validation
-- 2. Missing-value assessment
-- 3. Duplicate-record assessment
-- 4. Invalid and inconsistent value review
-- 5. Referential-integrity validation
-- 6. Clean-table creation and transformation
-- 7. Foreign-key implementation
-- 8. Final dataset validation
-- 9. Facility performance analysis
-- 10. Disease surveillance and severity analysis
-- 11. Insurance-status and healthcare-access analysis
--
-- DATA QUALITY OUTCOMES:
-- - 724 raw visit records were reduced to 720 unique visits
--   after removing four confirmed duplicate records.
-- - 18 unknown satisfaction scores were retained as SQL NULL.
-- - 7 unknown insurance-status values were retained as SQL NULL.
-- - Text inconsistencies such as trailing spaces were standardised.
-- - Raw date strings were converted to proper SQL DATE values.
-- - All patient and facility relationships were validated.
-- - Foreign-key constraints were implemented in the clean tables.
--
-- BUSINESS INSIGHTS:
-- - Vitalink Central Hospital recorded the highest patient volume.
-- - Higher patient volume did not consistently correspond to
--   longer waiting times or lower satisfaction.
-- - Malaria was the most frequently recorded disease.
-- - Hypertension had the highest proportion of severe cases.
-- - Insured and uninsured patients showed only small differences
--   in utilisation, emergency use, waiting time and satisfaction.
--
-- The final cleaned dataset was structured and validated for
-- reliable SQL analysis and business reporting.
--
-- DISCLAIMER:
-- This project uses completely synthetic healthcare data created
-- solely for educational and portfolio purposes.
