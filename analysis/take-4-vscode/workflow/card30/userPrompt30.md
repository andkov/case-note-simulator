# User Prompt for Card 30: Three-Lane Noise Injection Case Note Generator

# Sytem Prompt

You are an experienced R developer specializing in synthetic data generation for social services research. Create a deterministic R script using the `fabricatr` package to generate realistic case notes that 1) reflect authentic caseworker language, concerns, and observations while maintaining complete fictional status, 2) demonstrate realistic stylistic variation and human inconsistencies in documentation practices, and 3) embed specific testing scenarios and patterns.

# User Prompt

## Objective
Create a comprehensive synthetic case note generator using a three mode noise injection methodology. This approach systematically introduces different types of realistic variation into synthetic case notes through controlled noise injection. 

## Three-Lane Noise Injection Methodology
This approach introduces controlled variation through three specialized generation lanes, each targeting different aspects of realistic case note variation:

### Lane 1: Professional Baseline Noise (60% = 300 cases)
- **Purpose**: Establish consistent professional documentation standards as baseline
- **Noise Type**: Minimal variation, standardized professional language patterns
- **Target**: Clean baseline cases for algorithm calibration and control groups
- **Documentation Style**: Single standard professional caseworker voice

### Lane 2: Writer Style Noise (25% = 125 cases)  
- **Purpose**: Inject realistic human inconsistencies in documentation practices
- **Noise Type**: Experience-based writing variation, quality fluctuations, stylistic differences
- **Target**: Test algorithm robustness against real-world documentation variability
- **Documentation Styles**: New caseworker (30%), experienced (50%), senior (20%) with quality variation

### Lane 3: Scenario Embedding Noise (15% = 75 cases)
- **Purpose**: Embed specific algorithmic testing scenarios and patterns
- **Noise Type**: Targeted terminology, crisis patterns, service connection indicators
- **Target**: Validate specific algorithm detection capabilities
- **Documentation Focus**: Housing crises, mental health deterioration, successful service connections

*Note: An alternative implementation using separate scripts for each lane (Cards 31-33) exists as a parallel workflow branch, but this unified approach provides superior maintainability and parameter control.*

## Technical Requirements

### Core Architecture
- **Total Cases**: 500 synthetic cases (matching existing output)
- **ID Range**: SYN_00001 to SYN_00500 (sequential, no gaps)
- **Random Seed**: Configurable base seed with consistent lane coordination
- **Output Schema**: Identical to existing: `person_oid,first_name,last_name,gender,age,complexity_level,archetype_id, writer_style,embedded_scenarios,case_note`

### Lane Integration Architecture
The script executes three noise injection lanes within a single unified process:

#### Lane 1: Professional Baseline (60% = 300 cases)  
- **Noise Injection**: Minimal - standardized professional documentation patterns
- **Writer Profile**: Consistent experienced caseworker voice
- **Scenario Embedding**: None (pure baseline for algorithm calibration)
- **Quality Control**: Uniform high professional standards
- **Complexity Distribution**: Proportional across all complexity levels

#### Lane 2: Writer Style Variation (25% = 125 cases)
- **Noise Injection**: Human inconsistency patterns in documentation practices
- **Writer Profiles**: Experience-based variation (new: 30%, experienced: 50%, senior: 20%)
- **Quality Variation**: High quality (70%), standard (25%), concerning (5%)
- **Scenario Embedding**: None (focus purely on stylistic noise injection)
- **Documentation Patterns**: Realistic human variation in thoroughness, terminology, structure

#### Lane 3: Scenario Embedding (15% = 75 cases)
- **Noise Injection**: Targeted algorithmic testing patterns and terminology
- **Scenario Types**: Housing crisis (22 cases), mental health deterioration (17 cases), successful service connections (36 cases)
- **Language Patterns**: Embedded keywords and phrases for algorithm validation
- **Writer Adaptation**: Scenario-appropriate documentation responses
- **Testing Focus**: Specific pattern detection and classification algorithms

### User-Friendly Parameter Control

Create clearly documented parameter sections that allow easy adjustment:

```r
# ============================================================================
# USER CONFIGURATION PARAMETERS - EASY TO ADJUST
# ============================================================================

# Dataset Size and Lane Distribution
TOTAL_CASES <- 500
LANE1_PERCENTAGE <- 0.60  # Professional baseline (60%)
LANE2_PERCENTAGE <- 0.25  # Writer style variation (25%) 
LANE3_PERCENTAGE <- 0.15  # Scenario embedding (15%)

# Random Seed Management for Reproducible Noise Injection
BASE_SEED <- 20241106     # Change this for different random generations
LANE1_SEED_OFFSET <- 100  # Professional baseline seed modifier
LANE2_SEED_OFFSET <- 200  # Writer style variation seed modifier
LANE3_SEED_OFFSET <- 300  # Scenario embedding seed modifier

# Lane 2: Writer Style Noise Parameters
NEW_CASEWORKER_RATIO <- 0.30      # 30% new worker documentation patterns
EXPERIENCED_WORKER_RATIO <- 0.50   # 50% experienced worker patterns  
SENIOR_WORKER_RATIO <- 0.20        # 20% senior worker patterns

# Lane 2: Quality Variation Noise Parameters
HIGH_QUALITY_RATIO <- 0.70      # 70% high quality documentation
STANDARD_QUALITY_RATIO <- 0.25   # 25% standard quality documentation
CONCERNING_QUALITY_RATIO <- 0.05 # 5% concerning quality documentation

# Lane 3: Scenario Embedding Targets
HOUSING_CRISIS_TARGET <- 22       # Cases with embedded housing crisis patterns
MENTAL_HEALTH_TARGET <- 17        # Cases with mental health deterioration patterns
SUCCESS_CONNECTION_TARGET <- 36    # Cases with successful service connection patterns

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

1. **Controlled Noise Injection**: Systematic introduction of three distinct types of realistic variation
2. **Unified Architecture**: Single script manages all three lanes with coordinated parameter control
3. **Parameterization**: All noise injection parameters adjustable in clearly marked configuration sections
4. **Reproducibility**: Deterministic noise patterns with configurable random seed management
5. **Validation**: Built-in distribution checks ensuring target noise levels are achieved
6. **Algorithm Readiness**: Output optimized for downstream algorithm validation and testing

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

### Script Architecture
```r
# 1. Noise Injection Configuration (User-friendly parameter control)
# 2. Package Loading and Setup Functions
# 3. Core Helper Functions (Name generation, archetype definitions, noise patterns)
# 4. Lane 1: Professional Baseline Generation (300 cases)
# 5. Lane 2: Writer Style Noise Injection (125 cases)  
# 6. Lane 3: Scenario Embedding Noise Injection (75 cases)
# 7. Three-Lane Integration and Distribution Validation
# 8. Export and Noise Injection Summary Reporting
```

### Output Requirements
- **Single CSV File**: `unified_synthetic_cases.csv` with all 500 cases
- **Validation Report**: Console output showing distribution verification
- **Generation Summary**: Statistics on archetypes, complexity, scenarios, and quality metrics

### Noise Injection Validation
Implement comprehensive validation to ensure each lane achieves its intended noise injection targets:
- Lane 1: Verify consistent professional baseline patterns
- Lane 2: Confirm appropriate writer style and quality variation distributions  
- Lane 3: Validate successful scenario embedding with target terminology patterns

## Expected Deliverables

1. **R Script**: `./analysis/take-4-vscode/workflow/card30/output30-01-casenote-writer.R`
2. **Generated Dataset**: `./analysis/take-4-vscode/workflow/card30/three_lane_synthetic_cases.csv` (to be generated by the R script)
3. **Noise Injection Report**: Console validation showing achieved noise distribution across all three lanes
4. **Parameter Documentation**: Clear configuration sections enabling easy noise pattern adjustment

The goal is to provide a robust, reproducible methodology for controlled noise injection in synthetic case note generation, optimized for algorithm validation and testing workflows.

## Success Criteria
- ✅ Generates exactly 500 cases with proper sequential ID management
- ✅ Successfully injects three distinct types of realistic noise variation
- ✅ Achieves target distributions across all three lanes
- ✅ Provides easily adjustable noise injection parameters
- ✅ Includes comprehensive validation reporting for noise patterns
- ✅ Delivers algorithm-ready synthetic dataset with controlled variation characteristics