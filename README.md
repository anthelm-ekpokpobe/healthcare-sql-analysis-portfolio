# Healthcare SQL Analysis Portfolio

## Project Overview

This project demonstrates an end-to-end healthcare data analysis workflow using **MySQL**. It covers data validation, data cleaning, database structure, referential integrity, and business analysis using a synthetic healthcare dataset.

The objective was to transform raw healthcare data into a clean, structured dataset and use SQL to answer practical questions related to healthcare facility performance, disease surveillance, and patient access.

> **Disclaimer:** This project uses a completely synthetic dataset created solely for educational and portfolio purposes. No real patient, healthcare facility, employee, or confidential organisational data was used. This project is not affiliated with, sponsored by, or endorsed by any real organisation named Vitalink. Any similarity to real organisations, facilities, individuals, or operational data is coincidental.

## Watch the Project Summary

For a quick overview of the complete SQL project, watch the 3-minute summary video below:

[Watch the Healthcare SQL Analysis Project Summary](https://youtu.be/aEnB5xBdeqc)

The video summarises the full workflow, including data validation, cleaning, database design, and the key business findings.

## Tools Used

- MySQL
- MySQL Workbench
- SQL
- OBS Studio
- Canva

## Dataset

The project contains four synthetic healthcare datasets:

- Patients
- Healthcare facilities
- Patient visits
- Disease cases

The raw datasets were preserved separately from the cleaned tables to maintain data traceability.

## Project Workflow

1. Data import and initial validation
2. Missing-value assessment
3. Duplicate-record assessment
4. Invalid and inconsistent value checks
5. Referential-integrity validation
6. Clean-table creation and transformation
7. Foreign-key implementation
8. Final cleaned-dataset validation
9. Healthcare business analysis
10. Project findings and recommendations

## Business Questions

### 1. Facility Demand and Performance

Which healthcare facilities experience the highest patient demand, and how do they compare in terms of patient volume, average waiting time, average consultation time, and patient satisfaction?

### 2. Disease Surveillance and Severity

Which diseases are most frequently recorded, how are cases distributed across healthcare facilities and cities, and which diseases have the highest proportion of severe cases?

### 3. Insurance Status and Healthcare Access

Compare insured and uninsured patients to identify differences in healthcare utilisation, emergency service use, waiting times, and patient satisfaction, and identify any potential access or service gaps.

## Key Findings

- Vitalink Central Hospital recorded the highest patient volume with 183 visits.
- Higher patient volume did not consistently correspond to longer waiting times or lower patient satisfaction.
- Malaria was the most frequently recorded disease.
- Lagos recorded the highest overall disease-case volume.
- Hypertension had the highest proportion of severe cases.
- Uninsured patients showed slightly higher average healthcare utilisation than insured patients.
- Emergency-service use was almost identical between insured and uninsured patients.
- Differences in waiting time and satisfaction between insurance groups were relatively small.

## Analysis Results

### Final Clean Dataset Validation

The cleaned relational dataset contains 250 patients, 6 healthcare facilities, 220 disease-case records, and 720 unique patient visits.

![Final Clean Dataset Validation](screenshots/01-final-clean-dataset-validation.png)

### Facility Demand and Performance

Vitalink Central Hospital recorded the highest patient volume with 183 visits. Facility volume did not consistently correspond to longer waiting times or lower patient satisfaction.

![Facility Demand and Performance](screenshots/02-facility-demand-and-performance.png)

### Disease Severity Analysis

Hypertension recorded the highest proportion of severe cases at 18.4%, while malaria had the highest absolute number of severe cases.

![Disease Severity Analysis](screenshots/03-disease-severity-analysis.png)

### Insurance Status and Service Experience

Insured and uninsured patients showed relatively small differences in average waiting time and satisfaction, with no strong evidence of a major service-access gap based on insurance status alone.

![Insurance Service Experience](screenshots/04-insurance-service-experience.png)

## Portfolio Walkthrough

Detailed video walkthroughs covering the complete SQL workflow will be added to this repository, including data cleaning, validation, database design, and business analysis.

## Project Status

**Completed — SQL data cleaning, database validation, and healthcare analysis.**
