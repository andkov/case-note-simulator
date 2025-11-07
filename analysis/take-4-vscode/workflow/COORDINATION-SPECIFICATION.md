# 3-Lane Architecture Coordination Specification

## Overview
This document specifies the coordination requirements for the three-lane synthetic case note generation architecture to ensure compatible outputs that can be seamlessly combined into a single dataset.

## Lane Distribution & ID Management

### Lane 1: Primary Case Note Writer (Card 31)
- **Percentage**: 60% of total dataset
- **Case Count**: 300 cases
- **ID Range**: SYN_00001 to SYN_00300
- **Random Seed**: 20241206 (base + 100)
- **Focus**: Standard case patterns, typical service delivery
- **Output File**: `standard_cases.csv`

### Lane 2: Variation Case Note Writer (Card 32)
- **Percentage**: 25% of total dataset
- **Case Count**: 125 cases
- **ID Range**: SYN_00301 to SYN_00425
- **Random Seed**: 20241306 (base + 200)
- **Focus**: Stylistic variation, experience-based differences
- **Output File**: `varied_cases.csv`

### Lane 3: Scenario-Encoded Case Note Writer (Card 33)
- **Percentage**: 15% of total dataset
- **Case Count**: 75 cases
- **ID Range**: SYN_00426 to SYN_00500
- **Random Seed**: 20241406 (base + 300)
- **Focus**: Embedded testing scenarios for SDA validation
- **Output File**: `scenario_cases.csv`

**Total**: 300 + 125 + 75 = 500 cases (100%) ✅

## Consistent Output Schema

All three lanes must output CSV files with identical column structure:

```
person_oid,first_name,last_name,gender,age,case_note,complexity_level,archetype_id,writer_style,embedded_scenarios
```

### Column Specifications:
- **person_oid**: String, format "SYN_XXXXX" (5-digit zero-padded)
- **first_name**: String, realistic first names
- **last_name**: String, realistic surnames
- **gender**: String, values: "female", "male", "other"
- **age**: Integer, range 18-80 based on archetype
- **case_note**: String, realistic case documentation
- **complexity_level**: Integer, values: 1, 2, 3, 4
- **archetype_id**: String, values: A1, A2, A3, A4, A5, A6, A7, A8, A9, A10
- **writer_style**: String, lane-specific style categories
- **embedded_scenarios**: String, scenario type or "none"

## Archetype Distribution Coordination

Each lane must maintain proportional archetype distribution:

### Target Distribution (from Card 22):
- **Level 1 (Stable)**: 25% → A1(8%), A2(9%), A3(8%)
- **Level 2 (Moderate)**: 45% → A4(12%), A5(11%), A6(11%), A7(11%)
- **Level 3 (High)**: 25% → A8(13%), A9(12%)
- **Level 4 (Crisis)**: 5% → A10(5%)

### Per-Lane Targets:
**Lane 1 (300 cases)**:
- Level 1: 75 cases (A1:24, A2:27, A3:24)
- Level 2: 135 cases (A4:36, A5:33, A6:33, A7:33)
- Level 3: 75 cases (A8:39, A9:36)
- Level 4: 15 cases (A10:15)

**Lane 2 (125 cases)**:
- Level 1: 31 cases (A1:10, A2:11, A3:10)
- Level 2: 56 cases (A4:15, A5:14, A6:14, A7:14)
- Level 3: 31 cases (A8:16, A9:15)
- Level 4: 6 cases (A10:6)

**Lane 3 (75 cases)**:
- Level 1: 19 cases (A1:6, A2:7, A3:6)
- Level 2: 34 cases (A4:9, A5:8, A6:8, A7:9)
- Level 3: 19 cases (A8:10, A9:9)
- Level 4: 4 cases (A10:4)

## Scenario Target Distribution

**CRITICAL**: Lane 3 is responsible for meeting ALL scenario targets across the entire 500-case dataset:

### Required Scenario Counts:
- **Housing Crisis**: 15% of 500 = 75 cases → **All 75 cases in Lane 3**
- **Mental Health Deterioration**: 8% of 500 = 40 cases → **40 of Lane 3's 75 cases**
- **Service Connection Success**: 12% of 500 = 60 cases → **60 of Lane 3's 75 cases**

**Note**: Some cases in Lane 3 will have multiple scenario types embedded.

### Scenario Distribution by Lane:
- **Lane 1**: 95% "none", 5% minimal scenarios for variation
- **Lane 2**: 98% "none", 2% minimal scenarios for variation
- **Lane 3**: Concentrated scenario embedding to meet targets

## Writer Style Coordination

### Lane 1: Professional Styles
- formal_documentation (30%)
- efficient_practitioner (35%)
- detailed_observer (20%)
- crisis_focused (10%)
- collaborative (5%)

### Lane 2: Experience-Based Styles
- new_caseworker (30%)
- experienced_worker (50%)
- senior_worker (20%)

### Lane 3: Scenario-Appropriate Styles
- Mix of appropriate styles based on scenario embedding needs
- Crisis scenarios → crisis_focused style
- Success scenarios → collaborative/detailed_observer styles

## Quality Control Requirements

### Data Validation Checks (All Lanes):
1. **ID Uniqueness**: No duplicate person_oid across lanes
2. **ID Range Compliance**: IDs within specified ranges
3. **Column Completeness**: No missing values in required columns
4. **Archetype Distribution**: Within 5% tolerance of targets
5. **Case Note Quality**: Minimum 50 characters, maximum 1000 characters

### Cross-Lane Validation:
1. **Combined Dataset**: 500 total cases
2. **Scenario Targets**: 15% housing, 8% mental health, 12% success
3. **Complexity Distribution**: 25%/45%/25%/5% overall
4. **Schema Consistency**: Identical column structures

## Implementation Sequence

1. **Lane 1**: Generate standard cases (300) - establishes baseline patterns
2. **Lane 2**: Generate variation cases (125) - adds stylistic diversity
3. **Lane 3**: Generate scenario cases (75) - embeds testing targets
4. **Integration**: Combine all three CSV files with validation
5. **Final Validation**: Verify all targets met in combined dataset

## Master Integration Script Template

```r
# Load individual lane outputs
standard_cases <- readr::read_csv("card31/standard_cases.csv")
varied_cases <- readr::read_csv("card32/varied_cases.csv") 
scenario_cases <- readr::read_csv("card33/scenario_cases.csv")

# Combine datasets
combined_dataset <- rbind(standard_cases, varied_cases, scenario_cases)

# Validate distributions and targets
validate_combined_dataset(combined_dataset)

# Export final dataset
readr::write_csv(combined_dataset, "synthetic_casenotes_complete.csv")
```

## Success Criteria

✅ **500 total cases** with unique IDs across specified ranges  
✅ **Identical CSV schema** across all three lanes  
✅ **Proportional archetype distribution** maintained in each lane  
✅ **Scenario targets met** through Lane 3 concentration  
✅ **Compatible data types** for seamless integration  
✅ **Quality validation** passes for all individual and combined datasets

This specification ensures the three-lane architecture produces compatible outputs that can be seamlessly integrated for SDA algorithm validation.