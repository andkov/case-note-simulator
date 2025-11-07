# User Prompt for Card 30: Unified Case Note Generator

## Objective
Create a comprehensive, user-friendly synthetic case note generator that synthesizes the best features from Cards 31, 32, and 33 into a single, parameterizable R script. This unified approach should prioritize human readability, easy parameter adjustment, and maintainability while producing the same high-quality 500-case synthetic dataset.

## Context & Background
The existing 3-lane architecture (Cards 31-33) successfully generates 500 synthetic case notes across three distinct modes:
- **Lane 1** (Card 31): 300 standard cases with consistent professional documentation
- **Lane 2** (Card 32): 125 varied cases with realistic stylistic inconsistencies  
- **Lane 3** (Card 33): 75 scenario-embedded cases with specific testing patterns

This unified approach should maintain the same output quality and distribution while providing a single, intuitive interface for parameter adjustment.

## Technical Requirements

### Core Architecture
- **Total Cases**: 500 synthetic cases (matching existing output)
- **ID Range**: SYN_00001 to SYN_00500 (sequential, no gaps)
- **Random Seed**: Configurable base seed with consistent lane coordination
- **Output Schema**: Identical to existing: `person_oid,first_name,last_name,gender,age,complexity_level,archetype_id,writer_style,embedded_scenarios,case_note`

### Three-Mode Integration
The script should seamlessly blend three generation modes within a single execution:

#### Mode 1: Standard Cases (60% = 300 cases)  
- **Focus**: Consistent, professional baseline documentation
- **Writer Style**: Single standard professional style
- **Embedded Scenarios**: "none" (baseline cases)
- **Complexity Distribution**: Proportional across all levels

#### Mode 2: Variation Cases (25% = 125 cases)
- **Focus**: Realistic human documentation inconsistencies
- **Writer Styles**: Experience-based variation (new: 30%, experienced: 50%, senior: 20%)
- **Quality Levels**: High (70%), standard (25%), concerning (5%)
- **Embedded Scenarios**: "none" (focus on style variation)

#### Mode 3: Scenario Cases (15% = 75 cases)
- **Focus**: Embedded algorithm testing scenarios
- **Scenario Types**: Housing crisis, mental health deterioration, successful service connections
- **Language Patterns**: Specific embedded terminology for algorithm validation
- **Writer Styles**: Scenario-appropriate documentation

### User-Friendly Parameter Control

Create clearly documented parameter sections that allow easy adjustment:

```r
# ============================================================================
# USER CONFIGURATION PARAMETERS - EASY TO ADJUST
# ============================================================================

# Dataset Size Configuration
TOTAL_CASES <- 500
MODE1_PERCENTAGE <- 0.60  # Standard cases (60%)
MODE2_PERCENTAGE <- 0.25  # Variation cases (25%) 
MODE3_PERCENTAGE <- 0.15  # Scenario cases (15%)

# Random Seed Management
BASE_SEED <- 20241106     # Change this for different random generations
MODE1_SEED_OFFSET <- 100  # Standard cases seed modifier
MODE2_SEED_OFFSET <- 200  # Variation cases seed modifier
MODE3_SEED_OFFSET <- 300  # Scenario cases seed modifier

# Writer Style Distribution (Mode 2 only)
NEW_CASEWORKER_RATIO <- 0.30      # 30% new workers
EXPERIENCED_WORKER_RATIO <- 0.50   # 50% experienced workers  
SENIOR_WORKER_RATIO <- 0.20        # 20% senior workers

# Quality Level Distribution (Mode 2 only)
HIGH_QUALITY_RATIO <- 0.70      # 70% high quality notes
STANDARD_QUALITY_RATIO <- 0.25   # 25% standard quality notes
CONCERNING_QUALITY_RATIO <- 0.05 # 5% concerning quality notes

# Scenario Distribution Targets (Mode 3 only)
HOUSING_CRISIS_TARGET <- 22       # Cases with housing crisis scenarios
MENTAL_HEALTH_TARGET <- 17        # Cases with mental health deterioration
SUCCESS_CONNECTION_TARGET <- 36    # Cases with successful service connections

# Complexity Level Distribution (All Modes)
LEVEL1_STABLE_RATIO <- 0.25      # 25% stable complexity
LEVEL2_MODERATE_RATIO <- 0.45     # 45% moderate complexity  
LEVEL3_HIGH_RATIO <- 0.25         # 25% high complexity
LEVEL4_CRISIS_RATIO <- 0.05       # 5% crisis complexity

# Output Configuration
OUTPUT_PATH <- "./analysis/take-4-vscode/workflow/card30/"
OUTPUT_FILENAME <- "unified_synthetic_cases.csv"
```

### Key Design Principles

1. **Maintainability**: Single script eliminates coordination complexity between multiple files
2. **Readability**: Clear section headers, extensive comments, logical flow
3. **Parameterization**: All key settings adjustable in clearly marked configuration section
4. **Validation**: Built-in checks to ensure target distributions are met
5. **Reproducibility**: Deterministic outputs with configurable random seed management
6. **Quality Assurance**: Same validation checks as original three scripts

### Archetype System
- **10 Client Archetypes** (A1-A10): Maintain exact specifications from existing cards
- **4 Complexity Levels**: Stable, Moderate, High, Crisis with realistic distributions
- **Proportional Distribution**: Ensure each mode maintains appropriate complexity balance

### Case Note Quality Standards
- **Realistic Length**: Appropriate character counts based on complexity and writer style
- **Authentic Language**: Social services terminology and caseworker observations
- **Scenario Integration**: Natural embedding of testing scenarios without artificial patterns
- **Human Variation**: Realistic inconsistencies in documentation practices

## Implementation Specifications

### Script Structure
```r
# 1. Configuration Parameters (User-friendly adjustment section)
# 2. Package Loading and Setup
# 3. Helper Functions (Name generation, archetype definitions, etc.)
# 4. Mode 1: Standard Case Generation (300 cases)
# 5. Mode 2: Variation Case Generation (125 cases)  
# 6. Mode 3: Scenario Case Generation (75 cases)
# 7. Dataset Integration and Validation
# 8. Export and Summary Reporting
```

### Output Requirements
- **Single CSV File**: `unified_synthetic_cases.csv` with all 500 cases
- **Validation Report**: Console output showing distribution verification
- **Generation Summary**: Statistics on archetypes, complexity, scenarios, and quality metrics

### Cross-Validation
Ensure the unified script produces statistically equivalent results to the combined output of Cards 31, 32, and 33 while offering superior maintainability and user experience.

## Expected Deliverables

1. **R Script**: `./analysis/take-4-vscode/workflow/card30/output30-01-unified-case-generator.R`
2. **Generated Data**: `./analysis/take-4-vscode/workflow/card30/unified_synthetic_cases.csv`
3. **Human-Friendly Design**: Clear parameter sections, extensive documentation, intuitive structure

The goal is to create a synthesis that is greater than the sum of its parts - maintaining all the technical capabilities of the three-lane approach while dramatically improving usability and maintainability for human users.

## Success Criteria
- ✅ Generates exactly 500 cases with proper ID sequencing
- ✅ Maintains identical schema and data quality standards
- ✅ Parameters are easily adjustable by human users
- ✅ Single file eliminates coordination complexity
- ✅ Produces equivalent statistical distributions to combined Cards 31-33
- ✅ Clear documentation and intuitive structure throughout