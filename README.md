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

## 📊 **Key Directories**

- **`simulation/`** - Synthetic data generation engine
  - `input-specifications/` - YAML configuration files  
  - `generation-engine/` - R scripts for data generation
  - `output-datasets/` - Generated synthetic datasets
- **`analysis/`** - Analysis and reporting workflows
- **`ai/`** - AI assistant configuration and memory
- **`data-public/`** - Public datasets and metadata
- **`data-private/`** - Private/derived datasets

## 📝 **Basic Workflow**

1. **Start session**: `show_context_status()`
2. **Load context**: Choose appropriate persona or add specific files
3. **Generate data**: Work with simulation specifications  
4. **Analyze results**: Use analysis workflows
5. **Log changes**: `log_change('file.R', 'description')`

## 🔧 **Common Tasks**

### Generate Synthetic Data
```r
# Configure specifications in simulation/input-specifications/
# Run generation engine scripts in simulation/generation-engine/
source('simulation/generation-engine/client-generator.R')
```

### Run Analysis
```r
# Execute analysis workflows
source('analysis/eda-1/eda-1.R')
```

### Create Reports
```bash
# Render Quarto reports
quarto render analysis/eda-1/eda-1.qmd --to html
```

## 🏗️ **Architecture**

### Expert-Driven Specification System
Domain experts define synthetic data parameters through human-readable YAML files:

```
simulation/input-specifications/
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
simulation/generation-engine/
├── client-generator.R          # ✅ Demographic profile generation with risk factors
├── note-generator.R           # 🚧 Case note text synthesis (planned)
├── complexity-controller.R    # 🚧 Case complexity orchestration (planned)
└── validation-framework.R     # 🚧 Quality assurance workflows (planned)
```

### Output Datasets
Generated synthetic data organized for easy access and validation:

```
simulation/output-datasets/
├── client-profiles/           # Generated demographic data
├── case-notes/               # Generated case note text
└── validation-reports/       # Quality metrics and authenticity checks
```

## 🤖 **AI Assistant System**

This project includes a dynamic AI assistant with specialized personas for different types of work:

### 🎭 **Available Personas**
- **Default** - General assistance with minimal context (activated by default)
- **Developer** - Technical implementation focus with minimal context
- **Project Manager** - Strategic oversight with full project context
- **Case Note Analyst** - Domain expertise with specialized social services context

### 🔄 **Persona Management**
```r
# Switch between personas
activate_default()              # General assistance
activate_developer()            # Technical focus
activate_project_manager()      # Strategic oversight
activate_casenote_analyst()     # Domain expertise

# Check current status
show_context_status()
```

The AI assistant automatically loads with the **Default persona** when you open the project in VS Code, providing helpful general assistance while keeping specialized context available on demand.

## 🚀 **Quick Start**

### Prerequisites
- **R** (4.0+)
- **RStudio** (recommended)
- **Git** (for version control)
- **Quarto CLI** (for reports)

### 1. Clone Repository
```bash
git clone https://github.com/andkov/case-note-simulator.git
cd case-note-simulator
```

### 2. Install R Packages
```r
# Run the package installer
source('utility/install-packages.R')
```

### 3. Verify Setup
```r
# Check project setup
source('scripts/check-setup.R')
```

### 4. Activate AI Assistant
```r
# Load the AI context system
source('ai/scripts/ai-context-management.R')

# Start with full project context
activate_project_manager()

# Check status
show_context_status()
```

### 5. Generate Your First Synthetic Population
```r
# Load the client generator
source("./simulation/generation-engine/client-generator.R")

# Generate a test population
test_clients <- generate_client_population(n_clients = 50)

# Review the results
head(test_clients)
validation <- validate_client_population(test_clients)
print(validation)
```

### 6. Export for Analysis
```r
# Export to CSV for use in analytical workflows
export_client_population(
  test_clients, 
  "./simulation/output-datasets/client-profiles/test_population.csv"
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

See [`risk-assessment-validation.yml`](simulation/input-specifications/project-scenarios/risk-assessment-validation.yml) for complete example.

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
  scenario_file = "./simulation/input-specifications/project-scenarios/risk-assessment-validation.yml"
)

# Export in SDA-compatible format
export_client_population(
  scenario_clients,
  "./simulation/testing-harness/sda_test_data.csv"
)
```

## 📚 **Documentation**

### 🤖 AI System Documentation
- **[Commands Reference](ai/docs/commands.md)** - Essential AI system commands
- **[Context System](ai/docs/context-system.md)** - AI context management and persona system
- **[MCP Setup](ai/docs/mcp-setup/)** - Model Context Protocol setup instructions

### 🎯 Simulation System Documentation  
- **[Implementation Guide](simulation/implementation.md)** - Comprehensive architecture and workflow documentation
- **[Simulation Overview](simulation/README.md)** - Synthetic data generation system overview

### 📋 Project Context
- **[Project Mission](ai/project/mission.md)** - Project purpose and epistemic goals
- **[Project Method](ai/project/method.md)** - Synthetic data generation methodology
- **[Glossary](ai/project/glossary.md)** - Social services and technical terminology

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
1. Review and customize YAML specifications in `simulation/input-specifications/`
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

## 💡 **Tips**

- Use **Project Manager persona** for strategic work and planning
- Use **Developer persona** for focused coding work  
- Use **Case Note Analyst persona** for domain expertise work
- Project memory system tracks decisions and intentions automatically
- All synthetic data is completely fictional - no real client information
- Check AI system status with `show_context_status()`
- Log important changes with `log_change('file.R', 'description')`

## 🏛️ **Government of Alberta Context**

This public repository supports the private [`sda-casenote-reader`](https://github.com/GovAlta-EMU/sda-casenote-reader) project while serving as a reusable framework for other public service organizations requiring synthetic social services data for analytical workflow development and validation.
