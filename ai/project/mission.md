# Synthetic Case Note Generation Mission

This file serves as a compass for AI collaborators, articulating the synthetic data generation project's purpose, epistemic stance, and analytic goals. It ensures that all AI agents operate within a shared framework of understanding, aligned with the domain expert's specifications.

In a human–AI creative symbiosis, the human serves not merely as an operator, but as a **domain expert–scientist**—the conductor of realistic data synthesis. Their role is to define the specifications and constraints within which the AI can generate authentic, but completely fictional, social services data.

### Epistemic Aims
(what do we want to learn through synthetic data?)

Generate realistic but completely fictional social services case data to support the development and validation of analytical workflows in the Strategic Data Analytics (SDA) unit.

**Primary Objectives:**
1. **Validation Support**: Create synthetic datasets that mirror real-world complexity to test risk flagging, sentiment analysis, and pattern detection algorithms
2. **Workflow Testing**: Provide controlled synthetic data with known characteristics to benchmark AI agent performance in sda-casenote-reader
3. **Training Data**: Generate diverse client scenarios for algorithm training and refinement

**Target Population:**
- **Primary**: Adult clients (18-64) accessing income support and employment services
- **Secondary**: Elderly clients (65-80) with support needs
- **Geographic Context**: Fictional Alberta-like province with realistic demographic patterns

**Risk Factors of Interest:**
- Hospital stays and medical complexity
- History of incarceration  
- Mental health challenges
- Substance use patterns
- Housing instability
- Presence and number of dependents
- Employment gaps and barriers

### Technical Aims
(what deliverables do we want to produce?)

A collection of expert-specified synthetic data generation workflows that produce:

1. **Expert-Driven Specification System**: YAML-based templates allowing domain experts to define client archetypes, case complexity levels, and writing style variations
2. **Automated Generation Engine**: R-based workflows producing diverse client scenarios with controlled characteristics
3. **Quality Validation Framework**: Ensuring realistic distributions while maintaining complete fictional status
4. **Testing Harness**: Export-ready datasets formatted for seamless integration with sda-casenote-reader analytical pipelines

**Output Requirements:**
- Completely fictional data that cannot be traced to real individuals
- Realistic variation in writing styles, case complexity, and demographic patterns
- Configurable scenario parameters for specific SDA project needs
- Export compatibility with sda-casenote-reader analytical pipelines