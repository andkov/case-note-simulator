# Synthetic Data Generation Methods

## Data Sources

**Expert Specifications**: All synthetic data generation is controlled by domain expert-authored YAML specifications located in `./input-specifications/`:

- **Client Archetypes** (`client-profiles.yml`): Demographic patterns, risk factor combinations, and realistic co-occurrence rates
- **Case Complexity Levels** (`case-complexity-levels.yml`): Severity gradients based on support needs and intervention intensity
- **Writing Style Variations** (`writing-style-guides.yml`): Caseworker persona templates with realistic inconsistencies and error patterns
- **Project Scenarios** (`project-scenarios/`): Specific configurations for targeted SDA workflow testing

**Reference Patterns**: Alberta-like demographic distributions and social services terminology to ensure realistic but fictional outputs.

## Analytical Approach

**Expert-Driven Specification System**: Following a **specification-first** methodology where domain experts define exact parameters for synthetic data generation rather than algorithmic assumptions.

**Generation Pipeline**:
1. **Profile Assembly**: Combine demographic characteristics with controlled risk factors based on expert-defined archetypes
2. **Complexity Assignment**: Apply project-specific complexity levels to control case severity and intervention patterns
3. **Note Synthesis**: Generate case notes using appropriate writing styles, terminology, and realistic human inconsistencies
4. **Quality Validation**: Ensure realistic distributions while eliminating any patterns that could identify real individuals

**Multi-Modal Output**: 
- **Tabular**: Client demographic profiles with risk factor encoding
- **Textual**: Case note narratives with appropriate style variations
- **Temporal**: Realistic case progression patterns over time
- **Relational**: Family structures and dependency relationships

## Reproducibility Standards

**Specification Versioning**: All expert-authored YAML specifications are version-controlled, allowing reproducible generation of identical synthetic datasets.

**Seed Management**: Controlled random number generation with documented seeds for reproducible synthetic client populations.

**Generation Audit Trail**: 
- Complete logging of generation parameters
- Validation metrics for each synthetic dataset
- Quality assurance reports documenting realism checks

**Export Standards**: Generated data formatted for seamless integration with sda-casenote-reader:
- Standardized client ID systems compatible with SDA workflows
- Temporal patterns matching expected case progression timelines  
- Risk factor encoding preserving analytical target variables
- Text formatting consistent with real caseworker note structures

**Validation Framework**: Multi-level quality assurance addressing:
- **Linguistic Authenticity**: Verify appropriate social services terminology and writing patterns
- **Demographic Realism**: Ensure population distributions reflect Alberta-like characteristics
- **Risk Factor Prevalence**: Match realistic co-occurrence patterns of client challenges
- **Complexity Gradients**: Validate that case severity levels produce expected note patterns and intervention frequencies

**Privacy Protection**: Systematic approaches ensuring complete fictional status:
- Fictional name generation with no real-world correspondence
- Geographic obfuscation using realistic but fictional locations
- Temporal displacement preventing correlation with actual service periods
- Demographic noise injection maintaining statistical realism while eliminating identifiability
