# Case Note Simulator

> **Realistic synthetic data generation for social services analytical workflows**

This repository generates completely fictional but realistic social services case data to support the development and validation of analytical workflows in the Strategic Data Analytics (SDA) unit. The synthetic data mirrors real-world complexity while maintaining complete privacy protection and supporting rigorous algorithm testing.

## 🎯 **Purpose**

**Primary Objectives:**
- **Validation Support**: Create synthetic datasets with known characteristics to test risk flagging, sentiment analysis, and pattern detection algorithms
- **Workflow Testing**: Provide controlled synthetic data to benchmark AI agent performance in [`sda-casenote-reader`](https://github.com/GovAlta-EMU/sda-casenote-reader)
- **Training Data**: Generate diverse client scenarios for algorithm training and refinement
- **Public Service Adaptability**: Provide a reusable framework for other government organizations

**Target Users:**
- Strategic Data Analytics (SDA) research staff (primary)
- Government researchers and academic partners (secondary)
- Other public service organizations requiring synthetic social services data

## 🏗️ **Architecture**

### Expert-Driven Specification System
Domain experts define synthetic data parameters through human-readable YAML files:

```
input-specifications/
├── client-profiles.yml          # Client demographic patterns & risk factors
├── case-complexity-levels.yml   # Service intensity & documentation patterns  
├── writing-style-guides.yml     # Caseworker writing style variations
└── project-scenarios/           # Project-specific testing configurations
    ├── risk-assessment-validation.yml
    └── template-scenario.yml
```

### Generation Engine
Modular R scripts handle different aspects of synthetic data generation:

```
generation-engine/
├── client-generator.R          # ✅ Demographic profile generation with risk factors
├── note-generator.R           # 🚧 Case note text synthesis (planned)
├── complexity-controller.R    # 🚧 Case complexity orchestration (planned)
└── validation-framework.R     # 🚧 Quality assurance workflows (planned)
```

### Output Datasets
Generated synthetic data organized for easy access and validation:

```
output-datasets/
├── client-profiles/           # Generated demographic data
├── case-notes/               # Generated case note text
└── validation-reports/       # Quality metrics and authenticity checks
```

## 🚀 **Quick Start**

### 1. Setup Environment
```r
# Install required packages
install.packages(c("yaml", "dplyr", "purrr", "lubridate", "stringr", "jsonlite"))
```

### 2. Generate Your First Synthetic Population
```r
# Load the client generator
source("./generation-engine/client-generator.R")

# Generate a test population
test_clients <- generate_client_population(n_clients = 50)

# Review the results
head(test_clients)
validation <- validate_client_population(test_clients)
print(validation)
```

### 3. Export for Analysis
```r
# Export to CSV for use in analytical workflows
export_client_population(
  test_clients, 
  "./output-datasets/client-profiles/test_population.csv"
)
```

## 📋 **Client Archetypes**

The system generates four primary client types reflecting real-world social services populations:

| Archetype | Description | Risk Profile | Typical Duration |
|-----------|-------------|--------------|------------------|
| **Stable Employment Seeker** | Low-barrier clients focused on employment services | Low complexity | 3-8 months |
| **Moderate Multi-Barrier** | Clients with 2-3 significant challenges | Moderate complexity | 8-18 months |
| **High Complexity Intensive** | Multiple severe barriers requiring intensive support | High complexity | 12-36 months |
| **Elderly Support Needs** | Older adults (65-80) with age-related requirements | Low-moderate complexity | 6-24 months |

## 🎯 **Risk Factors Modeled**

The system generates realistic patterns for key risk factors:

- **Housing Instability** - Homelessness, overcrowding, frequent moves
- **Substance Use** - Alcohol/drug challenges affecting service engagement  
- **Mental Health Challenges** - Conditions requiring service coordination
- **Criminal History** - Justice system involvement affecting opportunities
- **Hospital Stays** - Medical complexity requiring case management
- **Dependents** - Children/family affecting service planning
- **Employment Barriers** - Skills gaps, transportation, health limitations

## 📝 **Writing Style Variations**

Synthetic case notes reflect authentic caseworker documentation patterns:

- **Formal Detailed** (30%) - Comprehensive, policy-compliant documentation
- **Efficient Bullet** (35%) - Time-efficient bullet-point style  
- **Conversational Narrative** (25%) - Story-like, informal approach
- **Clinical Precise** (10%) - Medical/clinical background terminology

## 🔬 **Project Scenarios**

Create targeted synthetic datasets for specific analytical testing:

### Risk Assessment Validation
```yaml
scenario_name: "Risk Assessment Algorithm Validation"
total_clients: 500
validation_targets:
  housing_risk_detection: 0.95
  substance_use_flagging: 0.88  
  crisis_prediction: 0.85
```

See [`risk-assessment-validation.yml`](input-specifications/project-scenarios/risk-assessment-validation.yml) for complete example.

## 🔐 **Privacy Protection**

All synthetic data is completely fictional with systematic privacy safeguards:

- **Fictional Names**: No correspondence to real individuals
- **Geographic Obfuscation**: Realistic but fictional Alberta-like locations  
- **Temporal Displacement**: Dates preventing correlation with real service periods
- **Demographic Noise**: Statistical realism while eliminating identifiability

## 🧪 **SDA Integration** 

Designed for seamless integration with [`sda-casenote-reader`](https://github.com/GovAlta-EMU/sda-casenote-reader):

```r
# Generate data for specific SDA project
scenario_clients <- generate_client_population(
  n_clients = 500,
  scenario_file = "./input-specifications/project-scenarios/risk-assessment-validation.yml"
)

# Export in SDA-compatible format
export_client_population(
  scenario_clients,
  "./testing-harness/sda_test_data.csv"
)
```

## 📚 **Documentation**

- **[Implementation Guide](guides/implementation-guide.md)** - Comprehensive architecture and workflow documentation
- **[AI Mission](ai/mission.md)** - Project purpose and epistemic goals
- **[AI Method](ai/method.md)** - Synthetic data generation methodology
- **[Glossary](ai/glossary.md)** - Social services and technical terminology

## 🛠️ **Current Status**

| Component | Status | Description |
|-----------|---------|-------------|
| **Client Generator** | ✅ Complete | Demographic profiles with realistic risk factors |
| **Expert Specifications** | ✅ Complete | YAML templates for all major archetypes |
| **Project Scenarios** | ✅ Template Ready | Risk assessment validation example |
| **Note Generator** | 🚧 Planned | Case note text synthesis with writing variations |
| **Complexity Controller** | 🚧 Planned | Service intensity orchestration |
| **Validation Framework** | 🚧 Planned | Automated quality assurance |

## 🤝 **Contributing**

### For Domain Experts
1. Review and customize YAML specifications in `input-specifications/`
2. Create new project scenarios using `template-scenario.yml`
3. Validate generated synthetic data for realism and authenticity

### For Developers  
1. Extend generation engine with additional modules
2. Implement quality validation frameworks
3. Enhance SDA integration capabilities

## 📊 **Example Output**

Generated client profiles include comprehensive demographic and risk information:

```r
# Sample synthetic client profile
client_id: "SYNTH_00123"
archetype: "moderate_complexity_multi_barrier"
age: 34
education_level: "high_school"
family_composition: "single_parent"
location: "Spruce Valley"
housing_instability: 1
substance_use: 0
mental_health_challenges: 1
has_dependents: 1
case_complexity: "moderate"
estimated_duration_months: 14
intake_date: "2023-03-15"
```

## 🏛️ **Government of Alberta Context**

This public repository supports the private [`sda-casenote-reader`](https://github.com/GovAlta-EMU/sda-casenote-reader) project while serving as a reusable framework for other public service organizations requiring synthetic social services data for analytical workflow development and validation.
