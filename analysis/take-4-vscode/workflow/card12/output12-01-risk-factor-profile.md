# Synthetic Risk Factor Profile Summary (Alberta-like)

## Overview
This profile defines realistic risk factor prevalence and co-occurrence patterns for synthetic adult income support clients (18-64) in Alberta-like social services. Rates are based on published research, Alberta Social Statistics, and scenario targets for algorithm validation.

---

## 1. Mental Health Challenge Prevalence
- **Any mental health challenge:** ~38% of clients
- **Severe/persistent mental illness:** ~12%
- **Co-occurrence:**
  - 65% of those with mental health challenges also have at least one other risk factor (substance use, housing instability, or employment barrier)
  - 8% of all clients show mental health deterioration patterns (scenario target)

## 2. Substance Use Patterns and Co-occurrence
- **Any substance use challenge:** ~22% of clients
- **Severe substance use disorder:** ~7%
- **Co-occurrence:**
  - 55% of those with substance use challenges also have mental health challenges
  - 40% also experience housing instability
  - 18% of all clients have both mental health and substance use challenges

## 3. Housing Instability Factors
- **Precarious housing (risk of loss, overcrowded, couch surfing):** ~25%
- **Homeless/shelter use:** ~10%
- **Transitional/supportive housing:** ~5%
- **Co-occurrence:**
  - 60% of those with housing instability also have employment barriers
  - 35% also have mental health or substance use challenges
  - 15% of all clients show housing crisis indicators (scenario target)

## 4. Medical Complexity and Hospital Utilization
- **Chronic medical conditions (2+):** ~18% of clients
- **Recent hospital stay (past 12 months):** ~9%
- **Co-occurrence:**
  - 50% of those with medical complexity also have mental health or substance use challenges
  - 30% also have dependent care responsibilities

## 5. Justice System Involvement Patterns
- **Any justice system involvement (arrest, probation, incarceration):** ~8% of clients
- **Recent incarceration (past 24 months):** ~3%
- **Co-occurrence:**
  - 70% of those with justice involvement also have employment barriers
  - 45% also have substance use or mental health challenges

## 6. Dependent Care Responsibilities
- **Any dependent care (children, elders, disabled family):** ~32% of clients
- **Single parent with dependents:** ~18%
- **Co-occurrence:**
  - 40% of those with dependent care also have employment barriers
  - 25% also experience housing instability

## 7. Employment Barriers and Gaps
- **Any employment barrier (skills, health, justice, caregiving):** ~38% of clients
- **Long-term unemployment (>12 months):** ~16%
- **Co-occurrence:**
  - 60% of those with employment barriers also have at least one other risk factor
  - 30% also have mental health or substance use challenges

---

## Co-Occurrence Matrix (Summary)
| Risk Factor         | Mental Health | Substance Use | Housing Instability | Medical Complexity | Justice Involvement | Dependent Care | Employment Barriers |
|--------------------|:-------------:|:-------------:|:-------------------:|:------------------:|:-------------------:|:--------------:|:-------------------:|
| Mental Health      |      —        |     55%       |        35%          |       50%          |        45%          |     18%        |        60%          |
| Substance Use      |     55%       |      —        |        40%          |       50%          |        45%          |     12%        |        60%          |
| Housing Instability|     35%       |     40%       |         —           |       30%          |        25%          |     25%        |        60%          |
| Medical Complexity |     50%       |     50%       |        30%          |        —           |        20%          |     30%        |        45%          |
| Justice Involvement|     45%       |     45%       |        25%          |       20%          |         —           |     10%        |        70%          |
| Dependent Care     |     18%       |     12%       |        25%          |       30%          |        10%          |      —         |        40%          |
| Employment Barriers|     60%       |     60%       |        60%          |       45%          |        70%          |     40%        |         —           |

---

## Notes for Synthetic Data Generation
- Assign risk factors probabilistically based on these rates and co-occurrence patterns
- Ensure scenario targets (e.g., 15% housing crisis, 8% mental health deterioration) are met
- Adjust for demographic context (age, gender, family structure, urban/rural)
- All values are fictionalized and should be tuned for specific validation needs

---

**Sources:**
- Alberta Social Statistics (2024/2025)
- Statistics Canada (2024/2025)
- Peer-reviewed social services research (2019-2025)
- Project scenario requirements
