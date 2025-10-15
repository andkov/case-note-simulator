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


------------------------------------
Substance specific terms and concepts
------------------------------------


# Abbreviations 

CEIS - Career and Employment Information Services
EA - Employability Assessment
ERA - Employment Readiness Assessment
FS - Financial Service
AISH - Assured Income for Severely Handicapped


# Foundational Concepts

- **assistance period** - A period of time during which a client receives financial support, training, or assessment services. It is typically defined by the start and end dates of the service episode. In episode-grain table usually represented by a `date_start` and `date_end` columns.

- **client type** - A classification of the program service client received that month. In any given month of receiving financial support, a client can be assigned one and only one client type. Recorded in the `client_type_code` field.

- **episode or service** - A distinct period of service use, which can be a SPELL or SPELL_BIT in the context of financial support. 


The history of relationships between people and programs is organized into *episodes of service.* Services can be of three broad types: financial assistance (FS), training (TR), and assessment (AS). 

## **Episodes of Financial Support**
Episodes of Financial Support have certain unique features:
-   The smallest unit of time is one month
-   A FS event begins on the first day of the month and ends on the last day of the month (as opposed to TR an AS events which can take place any day of the month).
-   Client can receive only one type of support (client_type_code) at any given month.
- Encoded as an integer in the field(client_type_code)
- mapped to a more coarse category in the program class taxonomy (program_class0123)

## Types of Financial Support

 We operationalize two types of  episodes of financial support:

-   **SPELL** – A non-interrupted period of service use, separated from other SPELLs by two or more consecutive months of non-use. Clients may change services during this time (i.e. change their client_type_code) or change their status in the household, but the SPELL remains continuous as long as there is no gap of two or more months in service use.

-   **SPELL_BIT** – A non-interrupted period of service use, separated from other SPELL_BITs by two or more consecutive months of non-use *or* by a change in client type or household role. In other words, a change in client type or household role terminates the SPELL_BIT

SPELL_BITs make up SPELLs. In many cases, a SPELL consists of a single SPELL_BIT.

# Big Picture of Data Universe

We study the history of relationship between people and service programs. Their interaction is stored as data tables of the Research Data Base (RDB). Currently hosted on CAO_UAT, RDB tables organize engagements with SCSS services as events in client's history of one of the three broad types: financial assistance, training, and assessment.

The table of **BENEFITS** contains one record per month in which a client received financial assistance of any kind. Only one type of assistance can be received in a month, but a set of benefits and amount may vary.

The table of **SPELLS** tracks contiguous intervals of assistance. A spell is defined as uninterrupted (2 months+ ) reception of benefits of any kind. Client type, benefit amount, and client’s role in the household may vary within a spell.

The table of **SPELL_BITS** breaks down spells into segments characterized by stable client type and household role. The change in either client type or household role marks the start of a new spell bit.

Financial assistance can come in three forms:

-   OTI - One Time Issues

-   IS - Income Support

-   AISH - Assured Income for Severely Handicapped


In addition to financial assistance, there is a wide range of training programs and employment services, interactions with which are captured in **ES_SERVICES** table.

To complete the context, table **EA_ASSESSMENTS** contains data from evaluation instruments engaged by clients to better guide them through the space of programs and services.

# Data Sources in our system

•	Financial Support – One Time Issues, Income Support, Assured Income for Severely Handicapped
•	Assessment – Employability (EA, ERA) or Specialized (SND, NI)
•	Training – Labour Market Transfer Agreement (CEIS, WF, TFW)

## Financial Support
Financial Support is captured in three tables:
-	[c-goa-sql-10477][CAO_PROD][TC2.BENEFITS]
-	[c-goa-sql-10477][CAO_PROD][TC2.SPELLS]
-	[c-goa-sql-10477][CAO_PROD][TC2.SPELL_BITS]
The table of BENEFITS contains one record per month in which a client received financial assistance of any kind. Only one type of assistance can be received in a month, but a set of benefits and amount may vary.  
The table of SPELLS tracks contiguous intervals of assistance. A gap in receiving benefits that is longer than 2 months marks the start of a new spell. Client type, benefit amount, and role in the household may vary within a spell. 
The table of SPELL BITS breaks spells into segments characterized by stable client type and household role. The change in either client type or household role marks the start of a new spell bit.

## Assessment
Assessments that clients undertake are organized into three related tables:
-	[c-goa-sql-10477][CAO_PROD][TC.EA_EVENTS]
-	[c-goa-sql-10477][CAO_PROD][TC.EA_BARRIERS]
-	[c-goa-sql-10477][CAO_PROD][TC.ERA_BARRIERS]
The table EA_EVENTS contains one records per event of assessment, which can be related to person’s employability (EA, ERA) or have specialization (SND, NI). Responses to questionnaires of EA and ERA instruments are isolated in respective tables EA_BARRIERS and ERA_BARRIERS and connected via edb_service_id. 

## Training
Training events are most varied in their taxonomy, but also most compact: 
-	[c-goa-sql-10477][CAO_PROD][TC.ES_SERVICES] 
The table ES_SERVICES contains one record per event of program engagement, such as workshops, seminars, courses, placements, etc. Services are described with program type, service category,  and service type ( more granular, training program type is typically omitted), but we imposed our own taxonomy (program_class0123), which accommodates taxonomies of Assessment and Financial Support (they are much simpler).  
Most of the training services fall under the umbrella of Career and Employment Information Services (CEIS), but not all. For example "Work Foundations", "Training for Work" are not CEIS services, but are captured in the ES_SERVICES table (see )


 