# Social Services Synthetic Data Glossary

## Client Classification Terms

- **Client Archetype**: A template defining demographic characteristics, risk factor probabilities, and typical service engagement patterns for synthetic client generation.
- **Case Complexity Level**: A systematic classification (low/moderate/high) controlling the intensity of interventions, frequency of contact, and crisis event probability in synthetic cases.
- **Risk Factor**: Observable characteristics or life circumstances that influence service needs and outcomes (e.g., housing instability, substance use, criminal history).

## Synthetic Data Generation Terms

- **Expert Specification**: YAML-formatted files authored by domain experts that define the parameters and constraints for synthetic data generation.
- **Generation Engine**: The collection of R scripts that read expert specifications and produce synthetic client profiles and case notes.
- **Quality Validation**: Systematic checks ensuring synthetic data exhibits realistic patterns while maintaining complete fictional status.
- **Export Compatibility**: Formatting synthetic data to match the expected structure and encoding used by sda-casenote-reader analytical workflows.

## Social Services Domain Terms

- **Case Note**: Text documentation of client interactions, service delivery, and assessment observations written by caseworkers.
- **Caseworker Persona**: A synthetic writing style template representing different documentation approaches (formal, efficient, conversational).
- **Service Engagement Period**: The duration of time a client receives support services, from initial intake through case closure.
- **Crisis Event**: Significant life disruptions requiring intensive intervention (e.g., hospitalization, housing loss, legal issues).
- **Intervention Intensity**: The frequency and depth of support services provided, correlated with case complexity levels.

## Risk Factors and Client Characteristics

- **Housing Instability**: Challenges maintaining stable, appropriate housing including homelessness, overcrowding, or frequent moves.
- **Substance Use Patterns**: History or current challenges with alcohol, drugs, or other substances affecting service engagement.
- **Mental Health Challenges**: Diagnosed or observable mental health conditions requiring consideration in service planning.
- **Criminal History**: Previous involvement with the justice system that may affect employment, housing, or service eligibility.
- **Hospital Stays**: Recent or frequent medical interventions indicating health complexity requiring case management coordination.
- **Dependents**: Children or other family members relying on the client for support, affecting service planning and resource needs.
- **Employment Barriers**: Factors limiting employment access including skills gaps, transportation, health issues, or criminal history.

## Technical Implementation Terms

- **YAML Specification**: Human-readable configuration files allowing domain experts to define synthetic data parameters without programming knowledge.
- **Seed Management**: Controlled random number generation ensuring reproducible synthetic datasets for testing purposes.
- **Validation Metrics**: Quantitative measures assessing the realism and quality of generated synthetic data including distribution checks and pattern validation.
- **SDA Integration**: Technical processes ensuring synthetic data seamlessly integrates with Strategic Data Analytics unit workflows and analytical tools.
