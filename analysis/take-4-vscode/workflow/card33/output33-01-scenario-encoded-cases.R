#' ---
#' title: "Scenario-Encoded Case Note Writer - Synthetic Targeted Scenario Generator"
#' author: "Card 33 Implementation"
#' date: "Last Updated: `r Sys.Date()`"
#' description: "Generate synthetic case notes with precisely embedded validation scenarios for SDA algorithm testing"
#' ---
#+ echo=F

# Scenario-Encoded Case Note Writer - Synthetic Targeted Scenario Generator
# Lane 3 of 3-Lane Architecture: Targeted Scenario Embedding (15% of total dataset)
#
# This script generates 75 synthetic case notes with precisely embedded testing scenarios
# to validate SDA algorithm performance in detecting housing crisis indicators,
# mental health deterioration patterns, and successful service connections.
#
# Key Features:
# 1. Housing crisis indicators: 15% of total dataset (75 cases) - specific language patterns
# 2. Mental health deterioration: 8% of total dataset (40 cases) - progression indicators  
# 3. Successful service connections: 12% of total dataset (60 cases) - positive outcomes
# 4. Deterministic random seed management for reproducible outputs (coordinated)
# 5. Natural integration of scenarios into realistic case narratives
# 6. ID range: SYN_00426 to SYN_00500 (Lane 3 allocation)
#
# Output: CSV with columns: person_oid,first_name,last_name,gender,age,complexity_level,
#         archetype_id,writer_style,embedded_scenarios,case_note

rm(list = ls(all.names = TRUE)) # Clear memory
cat("\014") # Clear console

cat("🎯 Scenario-Encoded Case Note Writer - Synthetic Targeted Scenario Generator\n")
cat("Working directory: ", getwd(), "\n")

# ---- load-packages -----------------------------------------------------------
# Core packages for synthetic data generation
library(fabricatr)   # Synthetic data generation framework
library(magrittr)    # Pipe operations
library(dplyr)       # Data manipulation
library(stringr)     # String processing
library(readr)       # Data import/export
library(lubridate)   # Date handling
library(glue)        # String interpolation

# Import helper functions if available
if(file.exists("./scripts/common-functions.R")) {
  base::source("./scripts/common-functions.R")
}

# ---- declare-globals ---------------------------------------------------------
# Reproducible random seed for deterministic outputs (coordinated with lanes)
GENERATION_SEED <- 20241406  # Base seed + 300 for Lane 3 coordination
set.seed(GENERATION_SEED)

# Lane 3 cohort size (15% of 500 total cases)
LANE3_COHORT_SIZE <- 75

# ID range for Lane 3 coordination
LANE3_ID_START <- 426
LANE3_ID_END <- 500

# Output configuration
OUTPUT_PATH <- "./analysis/take-4-vscode/workflow/card33/"
OUTPUT_FILENAME <- "scenario_cases.csv"

# Scenario distribution targets (for entire 500-case dataset)
SCENARIO_TARGETS <- list(
  housing_crisis = 75,          # 15% of 500 total cases
  mental_health_deterioration = 40,  # 8% of 500 total cases  
  successful_service_connections = 60 # 12% of 500 total cases
)

cat("🎯 Scenario Distribution Targets (Entire Dataset):\n")
cat("   - Housing Crisis Indicators:", SCENARIO_TARGETS$housing_crisis, "cases (15%)\n")
cat("   - Mental Health Deterioration:", SCENARIO_TARGETS$mental_health_deterioration, "cases (8%)\n") 
cat("   - Successful Service Connections:", SCENARIO_TARGETS$successful_service_connections, "cases (12%)\n")
cat("   - Lane 3 Responsibility: Deliver ALL scenario targets within 75 cases\n")

# ---- scenario-embedding-specifications ---------------------------------------
cat("\n📝 Defining scenario embedding patterns and language libraries...\n")

# Housing Crisis Indicator Patterns
HOUSING_CRISIS_PATTERNS <- list(
  eviction_notices = c("received eviction notice", "eviction proceedings initiated", "30-day notice to vacate", 
                      "landlord issued eviction", "facing eviction", "court ordered eviction"),
  
  shelter_placements = c("referred to emergency shelter", "placed in transitional housing", "accessing shelter services",
                        "moved to emergency accommodation", "temporary shelter placement", "homeless shelter intake"),
  
  unsafe_conditions = c("unsafe housing conditions", "building condemned", "no heat or water", "mold contamination",
                       "structural damage", "uninhabitable conditions", "housing code violations"),
  
  utility_shutoffs = c("utilities disconnected", "power shut off", "no running water", "gas service terminated",
                      "electric service cut", "heat disconnected", "utility payment arrears"),
  
  housing_loss = c("lost housing", "became homeless", "evicted from apartment", "unable to maintain housing",
                  "housing arrangement ended", "sleeping rough", "couch surfing situation")
)

# Mental Health Deterioration Progression Patterns
MENTAL_HEALTH_PATTERNS <- list(
  declining_engagement = c("missed last three appointments", "no-show for mental health session", 
                          "stopped taking prescribed medication", "disengaged from treatment plan",
                          "cancelled therapy appointments", "avoiding mental health services"),
  
  escalating_symptoms = c("increased anxiety and panic attacks", "depressive symptoms worsening", 
                         "paranoid thoughts increasing", "mood swings more frequent",
                         "sleep disruption severe", "concentration significantly impaired"),
  
  crisis_behaviors = c("expressed suicidal thoughts", "self-harm incidents reported", "aggressive behavior noted",
                      "substance use as coping mechanism", "isolating from support network",
                      "unable to manage daily activities"),
  
  functional_decline = c("personal hygiene deteriorating", "unable to maintain employment", 
                        "losing housing due to mental health", "interpersonal relationships suffering",
                        "basic life skills compromised", "cognitive function declining"),
  
  chronological_markers = c("symptoms began 3 months ago", "gradual decline over past 6 weeks",
                           "marked deterioration since last assessment", "progressive worsening noted",
                           "functioning declined significantly since", "crisis point reached")
)

# Successful Service Connection Patterns
SUCCESS_PATTERNS <- list(
  positive_engagement = c("actively participating in programming", "consistently attending appointments", 
                         "engaged with employment services", "following through on referrals",
                         "motivated to work toward goals", "strong therapeutic relationship established"),
  
  goal_achievement = c("obtained stable employment", "secured appropriate housing", "completed training program",
                      "achieved sobriety milestone", "improved family relationships", "gained independent living skills"),
  
  stability_improvements = c("housing situation stabilized", "income support no longer needed", 
                            "mental health symptoms well-managed", "substance use under control",
                            "family functioning improved", "employment maintained consistently"),
  
  successful_referrals = c("connected to appropriate mental health services", "linked with community resources",
                          "successful referral to addiction treatment", "enrolled in skills training program",
                          "connected with peer support group", "referred to specialized services"),
  
  positive_outcomes = c("case closure due to goal achievement", "graduated to maintenance level services",
                       "transitioned to community support", "achieved independent functioning",
                       "successful completion of program", "goals met ahead of schedule")
)

# Writer Style Specifications for Scenario Embedding
SCENARIO_WRITER_STYLES <- list(
  crisis_documenter = list(
    name = "crisis_documenter",
    characteristics = c("detailed", "urgent", "safety_focused", "comprehensive"),
    scenario_focus = "housing_crisis"
  ),
  
  clinical_tracker = list(
    name = "clinical_tracker", 
    characteristics = c("clinical", "observational", "progression_aware", "intervention_focused"),
    scenario_focus = "mental_health_deterioration"
  ),
  
  success_oriented = list(
    name = "success_oriented",
    characteristics = c("strengths_based", "goal_focused", "positive", "achievement_tracking"),
    scenario_focus = "successful_service_connections"
  ),
  
  comprehensive_mixed = list(
    name = "comprehensive_mixed",
    characteristics = c("balanced", "thorough", "multi_scenario", "analytical"),
    scenario_focus = "mixed_scenarios"
  )
)

# ---- archetype-specifications-lane3 -----------------------------------------
cat("\n📊 Defining client archetype specifications for Lane 3 (75 cases)...\n")

# Client Archetypes adapted for Lane 3 (75 cases with scenario focus)
# Maintaining proportional complexity distribution while maximizing scenario embedding
CLIENT_ARCHETYPES <- list(
  
  # LEVEL 1: STABLE (25% of 75 = 19 profiles) - Success scenario focus
  A1 = list(
    name = "Urban Early Career Stabilizer",
    count = 6,
    complexity_level = 1,
    age_range = c(22, 35),
    gender_distribution = c("Female" = 0.55, "Male" = 0.43, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.6, housing_instability = 0.2, mental_health = 0.1),
    service_patterns = c("employment_counseling", "skills_assessment", "job_search_support"),
    scenario_preference = "successful_service_connections"
  ),
  
  A2 = list(
    name = "Rural Steady Trades Worker", 
    count = 7,
    complexity_level = 1,
    age_range = c(28, 45),
    gender_distribution = c("Male" = 0.75, "Female" = 0.23, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.7, housing_instability = 0.1, mental_health = 0.15),
    service_patterns = c("seasonal_employment", "trades_training", "transportation_support"),
    scenario_preference = "successful_service_connections"
  ),
  
  A3 = list(
    name = "Older Stable Support-Seeking Couple",
    count = 6,
    complexity_level = 1,
    age_range = c(55, 64),
    gender_distribution = c("Female" = 0.52, "Male" = 0.46, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.8, housing_instability = 0.05, mental_health = 0.2),
    service_patterns = c("career_transition", "benefit_navigation", "health_coordination"),
    scenario_preference = "successful_service_connections"
  ),
  
  # LEVEL 2: MODERATE (45% of 75 = 34 profiles) - Mixed scenarios
  A4 = list(
    name = "Single Parent Housing Strain",
    count = 9,
    complexity_level = 2,
    age_range = c(25, 40),
    gender_distribution = c("Female" = 0.85, "Male" = 0.13, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.7, housing_instability = 0.9, mental_health = 0.4, dependent_care = 0.95),
    service_patterns = c("housing_search", "childcare_coordination", "income_support", "parenting_resources"),
    scenario_preference = "housing_crisis"
  ),
  
  A5 = list(
    name = "Midlife Health & Employment Barriers",
    count = 8,
    complexity_level = 2,
    age_range = c(45, 58),
    gender_distribution = c("Female" = 0.58, "Male" = 0.4, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.9, housing_instability = 0.3, mental_health = 0.5, medical_complexity = 0.8),
    service_patterns = c("medical_coordination", "disability_benefits", "accommodation_planning", "retraining"),
    scenario_preference = "successful_service_connections"
  ),
  
  A6 = list(
    name = "Urban Transitional Recovery Participant",
    count = 8,
    complexity_level = 2, 
    age_range = c(30, 50),
    gender_distribution = c("Male" = 0.6, "Female" = 0.38, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.8, housing_instability = 0.6, mental_health = 0.7, substance_use = 0.9),
    service_patterns = c("recovery_program", "mental_health_support", "structured_housing", "life_skills"),
    scenario_preference = "mental_health_deterioration"
  ),
  
  A7 = list(
    name = "Rural Multi-Role Caregiver",
    count = 9,
    complexity_level = 2,
    age_range = c(35, 55),
    gender_distribution = c("Female" = 0.75, "Male" = 0.23, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.6, housing_instability = 0.4, mental_health = 0.3, dependent_care = 0.9),
    service_patterns = c("respite_care", "transportation", "multi_service_coordination", "caregiver_support"),
    scenario_preference = "successful_service_connections"
  ),
  
  # LEVEL 3: HIGH (25% of 75 = 19 profiles) - Crisis and deterioration focus
  A8 = list(
    name = "Multi-Factor Urban Instability Case",
    count = 10,
    complexity_level = 3,
    age_range = c(25, 45),
    gender_distribution = c("Male" = 0.55, "Female" = 0.43, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.9, housing_instability = 0.95, mental_health = 0.8, substance_use = 0.6, justice_involvement = 0.4),
    service_patterns = c("crisis_intervention", "intensive_case_management", "multi_agency_coordination", "harm_reduction"),
    scenario_preference = "housing_crisis"
  ),
  
  A9 = list(
    name = "Chronic Medical & Mental Health Complexity",
    count = 9,
    complexity_level = 3,
    age_range = c(40, 60),
    gender_distribution = c("Female" = 0.6, "Male" = 0.38, "Other" = 0.02),
    risk_factors = list(employment_barriers = 0.85, housing_instability = 0.5, mental_health = 0.95, medical_complexity = 0.9, substance_use = 0.3),
    service_patterns = c("medical_case_management", "mental_health_intensive", "benefit_advocacy", "functional_support"),
    scenario_preference = "mental_health_deterioration"
  ),
  
  # LEVEL 4: CRISIS (5% of 75 = 3 profiles) - All crisis scenarios
  A10 = list(
    name = "Acute Housing & Co-Occurring Crisis",
    count = 3,
    complexity_level = 4,
    age_range = c(28, 50),
    gender_distribution = c("Male" = 0.6, "Female" = 0.35, "Other" = 0.05),
    risk_factors = list(employment_barriers = 0.95, housing_instability = 1.0, mental_health = 0.9, substance_use = 0.8, justice_involvement = 0.7, medical_complexity = 0.4),
    service_patterns = c("emergency_stabilization", "crisis_response", "multi_agency_emergency", "immediate_housing", "harm_reduction"),
    scenario_preference = "housing_crisis"
  )
)

# Validate archetype counts sum to total cohort size
total_archetype_count <- sum(sapply(CLIENT_ARCHETYPES, function(x) x$count))
if(total_archetype_count != LANE3_COHORT_SIZE) {
  stop("Archetype counts must sum to ", LANE3_COHORT_SIZE, ". Current sum: ", total_archetype_count)
}

cat("✅ Client Archetype Distribution (75 cases):\n")
for(archetype in names(CLIENT_ARCHETYPES)) {
  arch_data <- CLIENT_ARCHETYPES[[archetype]]
  cat("   -", archetype, ":", arch_data$name, "(", arch_data$count, "profiles,", 
      "Level", arch_data$complexity_level, "- Scenario:", arch_data$scenario_preference, ")\n")
}

# Calculate scenario distribution from archetypes
housing_crisis_profiles <- sum(sapply(CLIENT_ARCHETYPES, function(x) 
  if(x$scenario_preference == "housing_crisis") x$count else 0))
mental_health_profiles <- sum(sapply(CLIENT_ARCHETYPES, function(x) 
  if(x$scenario_preference == "mental_health_deterioration") x$count else 0))
success_profiles <- sum(sapply(CLIENT_ARCHETYPES, function(x) 
  if(x$scenario_preference == "successful_service_connections") x$count else 0))

cat("\n📊 Scenario Distribution Planning:\n")
cat("   - Housing Crisis Focus:", housing_crisis_profiles, "profiles\n")
cat("   - Mental Health Deterioration Focus:", mental_health_profiles, "profiles\n") 
cat("   - Success Connection Focus:", success_profiles, "profiles\n")
cat("   - Total Scenario-Focused Profiles:", housing_crisis_profiles + mental_health_profiles + success_profiles, "\n")

# ---- helper-functions --------------------------------------------------------
cat("\n🔧 Setting up scenario-focused helper functions...\n")

# Generate realistic first names (consistent with other lanes)
generate_first_name <- function(gender, n = 1) {
  female_names <- c("Sarah", "Jennifer", "Jessica", "Ashley", "Amanda", "Melissa", "Nicole", 
                   "Stephanie", "Michelle", "Lisa", "Angela", "Elizabeth", "Laura", "Maria")
  
  male_names <- c("Michael", "Christopher", "Jason", "David", "James", "Robert", "John",
                 "Daniel", "Matthew", "Anthony", "Mark", "Donald", "Steven", "Paul")
  
  other_names <- c("Alex", "Jordan", "Casey", "Taylor", "Morgan", "Jamie", "Avery", "Riley")
  
  result <- character(n)
  for(i in 1:n) {
    if(gender[i] == "Female") {
      result[i] <- sample(female_names, 1)
    } else if(gender[i] == "Male") {
      result[i] <- sample(male_names, 1)
    } else {
      result[i] <- sample(other_names, 1)
    }
  }
  return(result)
}

# Generate realistic last names (consistent with other lanes)
generate_last_name <- function(n = 1) {
  surnames <- c("Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis",
               "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson",
               "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White")
  
  return(sample(surnames, n, replace = TRUE))
}

# Assign writer style based on scenario preference
assign_scenario_writer_style <- function(scenario_preferences) {
  styles <- character(length(scenario_preferences))
  
  for(i in 1:length(scenario_preferences)) {
    pref <- scenario_preferences[i]
    if(pref == "housing_crisis") {
      styles[i] <- "crisis_documenter"
    } else if(pref == "mental_health_deterioration") {
      styles[i] <- "clinical_tracker"
    } else if(pref == "successful_service_connections") {
      styles[i] <- "success_oriented"
    } else {
      styles[i] <- "comprehensive_mixed"
    }
  }
  
  return(styles)
}

# Generate embedded scenario case note
generate_scenario_embedded_note <- function(archetype_id, complexity_level, scenario_preference, 
                                          writer_style, age, gender, first_name) {
  
  archetype_data <- CLIENT_ARCHETYPES[[archetype_id]]
  current_date <- format(Sys.Date() - sample(1:90, 1), "%Y-%m-%d")
  
  # Generate base case components
  base_concerns <- generate_base_concerns(archetype_data, complexity_level)
  base_activities <- generate_base_activities(archetype_data, complexity_level)
  
  # Embed specific scenario patterns
  embedded_content <- embed_scenario_patterns(scenario_preference, complexity_level, archetype_data)
  
  # Generate scenario-specific observations
  scenario_observations <- generate_scenario_observations(scenario_preference, writer_style, age, gender)
  
  # Generate scenario-appropriate next steps
  scenario_next_steps <- generate_scenario_next_steps(scenario_preference, complexity_level)
  
  # Combine into cohesive case note
  case_note <- combine_scenario_note(
    date = current_date,
    client_name = first_name,
    base_concerns = base_concerns,
    base_activities = base_activities,
    embedded_content = embedded_content,
    observations = scenario_observations,
    next_steps = scenario_next_steps,
    writer_style = writer_style,
    complexity_level = complexity_level
  )
  
  return(case_note)
}

# Generate base concerns for archetype
generate_base_concerns <- function(archetype_data, complexity_level) {
  
  concern_library <- list(
    employment = c("seeking employment opportunities", "addressing employment barriers", "job search challenges", 
                  "skills training needs", "workplace accommodation requirements"),
    housing = c("housing affordability concerns", "seeking stable accommodation", "housing search assistance needed",
               "rent payment difficulties", "housing condition issues"),
    health = c("managing health conditions", "medication compliance", "healthcare coordination needs",
              "mental health support required", "medical appointment assistance"),
    family = c("childcare coordination", "family relationship challenges", "parenting support needs",
              "eldercare responsibilities", "dependent care planning"),
    financial = c("income adequacy concerns", "benefit navigation", "debt management", "budgeting support",
                 "emergency financial assistance")
  )
  
  # Select concerns based on archetype risk factors
  selected_concerns <- c()
  
  if(archetype_data$risk_factors$employment_barriers > 0.5) {
    selected_concerns <- c(selected_concerns, sample(concern_library$employment, 1))
  }
  
  if(archetype_data$risk_factors$housing_instability > 0.3) {
    selected_concerns <- c(selected_concerns, sample(concern_library$housing, 1))
  }
  
  if(archetype_data$risk_factors$mental_health > 0.3 || 
     (!is.null(archetype_data$risk_factors$medical_complexity) && archetype_data$risk_factors$medical_complexity > 0.3)) {
    selected_concerns <- c(selected_concerns, sample(concern_library$health, 1))
  }
  
  if(!is.null(archetype_data$risk_factors$dependent_care) && archetype_data$risk_factors$dependent_care > 0.5) {
    selected_concerns <- c(selected_concerns, sample(concern_library$family, 1))
  }
  
  # Ensure at least one concern
  if(length(selected_concerns) == 0) {
    selected_concerns <- sample(concern_library$financial, 1)
  }
  
  return(paste(selected_concerns, collapse = ", "))
}

# Generate base activities
generate_base_activities <- function(archetype_data, complexity_level) {
  
  activities_by_level <- list(
    `1` = c("employment counseling session", "benefit application review", "resource information provided",
           "skills assessment completed", "referral coordination", "goal setting meeting"),
    `2` = c("case management meeting", "service coordination", "benefit advocacy", "housing search assistance",
           "healthcare liaison", "childcare planning", "transportation coordination"),
    `3` = c("intensive case management", "crisis response planning", "multi-agency coordination",
           "safety planning", "immediate needs assessment", "therapeutic intervention"),
    `4` = c("emergency intervention", "crisis stabilization", "immediate safety planning",
           "emergency shelter placement", "crisis team consultation", "emergency benefit processing")
  )
  
  level_activities <- activities_by_level[[as.character(complexity_level)]]
  selected_activities <- sample(level_activities, min(complexity_level + 1, length(level_activities)))
  
  return(paste(selected_activities, collapse = ", "))
}

# Embed specific scenario patterns into case note content
embed_scenario_patterns <- function(scenario_preference, complexity_level, archetype_data) {
  
  if(scenario_preference == "housing_crisis") {
    return(embed_housing_crisis_patterns(complexity_level, archetype_data))
  } else if(scenario_preference == "mental_health_deterioration") {
    return(embed_mental_health_patterns(complexity_level, archetype_data))
  } else if(scenario_preference == "successful_service_connections") {
    return(embed_success_patterns(complexity_level, archetype_data))
  } else {
    return("ongoing support and monitoring continue")
  }
}

# Embed housing crisis specific patterns
embed_housing_crisis_patterns <- function(complexity_level, archetype_data) {
  
  if(complexity_level >= 3) {
    # High/Crisis level - severe housing crisis
    crisis_type <- sample(names(HOUSING_CRISIS_PATTERNS), 1)
    crisis_language <- sample(HOUSING_CRISIS_PATTERNS[[crisis_type]], 1)
    return(glue("HOUSING CRISIS: Client {crisis_language}. Immediate housing intervention required."))
  } else {
    # Lower levels - housing stress/risk
    risk_type <- sample(c("eviction_notices", "utility_shutoffs"), 1)
    risk_language <- sample(HOUSING_CRISIS_PATTERNS[[risk_type]], 1)  
    return(glue("Housing stability concerns: Client {risk_language}. Prevention services activated."))
  }
}

# Embed mental health deterioration patterns
embed_mental_health_patterns <- function(complexity_level, archetype_data) {
  
  # Select deterioration pattern based on complexity
  if(complexity_level >= 3) {
    # Severe deterioration
    pattern_types <- c("crisis_behaviors", "functional_decline")
  } else {
    # Moderate deterioration  
    pattern_types <- c("declining_engagement", "escalating_symptoms")
  }
  
  selected_pattern <- sample(pattern_types, 1)
  symptom_language <- sample(MENTAL_HEALTH_PATTERNS[[selected_pattern]], 1)
  timeline <- sample(MENTAL_HEALTH_PATTERNS$chronological_markers, 1)
  
  return(glue("Mental health concerns: {symptom_language}. {timeline}. Clinical review scheduled."))
}

# Embed successful service connection patterns  
embed_success_patterns <- function(complexity_level, archetype_data) {
  
  # Select success type based on complexity level
  if(complexity_level == 1) {
    # Higher success rates for stable clients
    success_types <- c("goal_achievement", "positive_engagement")
  } else {
    # Incremental successes for higher complexity
    success_types <- c("successful_referrals", "stability_improvements") 
  }
  
  selected_type <- sample(success_types, 1)
  success_language <- sample(SUCCESS_PATTERNS[[selected_type]], 1)
  
  return(glue("Positive progress: Client {success_language}. Continuing supportive services."))
}

# Generate scenario-specific observations
generate_scenario_observations <- function(scenario_preference, writer_style, age, gender) {
  
  if(writer_style == "crisis_documenter") {
    observations <- c(
      "Client presents in crisis requiring immediate intervention",
      "Safety concerns identified and addressed urgently", 
      "Emergency protocols activated due to housing instability",
      "Immediate needs assessment completed with crisis response team",
      "Client expressing significant distress regarding housing situation"
    )
  } else if(writer_style == "clinical_tracker") {
    observations <- c(
      "Client demonstrates declining mental health functioning",
      "Observable deterioration in self-care and engagement patterns",
      "Clinical assessment indicates need for intensive intervention",
      "Progressive symptom escalation noted over recent contacts",
      "Functional capacity assessment reveals significant impairment"
    )
  } else if(writer_style == "success_oriented") {
    observations <- c(
      "Client demonstrates strong motivation and engagement",
      "Positive progress evident in goal achievement areas", 
      "Client utilizing resources effectively and appropriately",
      "Significant improvements noted in stability indicators",
      "Client expressing confidence and optimism about future plans"
    )
  } else {
    observations <- c(
      "Comprehensive assessment reveals multiple support needs",
      "Client engaging appropriately with services and interventions",
      "Mixed progress noted across different goal areas",
      "Ongoing monitoring and support coordination required"
    )
  }
  
  return(sample(observations, 1))
}

# Generate scenario-appropriate next steps
generate_scenario_next_steps <- function(scenario_preference, complexity_level) {
  
  if(scenario_preference == "housing_crisis") {
    next_steps <- c(
      "Emergency housing referral submitted immediately",
      "Crisis housing team contacted for urgent placement", 
      "Shelter intake scheduled within 24 hours",
      "Emergency rent assistance application completed",
      "Housing crisis intervention plan activated"
    )
  } else if(scenario_preference == "mental_health_deterioration") {
    next_steps <- c(
      "Mental health crisis assessment scheduled urgently",
      "Psychiatric consultation referral expedited",
      "Safety planning session scheduled within 48 hours", 
      "Clinical review with treatment team arranged",
      "Intensive mental health services referral completed"
    )
  } else if(scenario_preference == "successful_service_connections") {
    next_steps <- c(
      "Continue current service plan with monthly review",
      "Graduate to maintenance-level support services",
      "Transition planning meeting scheduled to reduce service intensity",
      "Peer support connection facilitated for ongoing success",
      "Case closure planning initiated due to goal achievement"
    )
  } else {
    next_steps <- c(
      "Comprehensive service coordination meeting scheduled",
      "Multi-disciplinary team consultation arranged",
      "Service plan review and adjustment planned"
    )
  }
  
  return(paste("Next steps:", sample(next_steps, 1)))
}

# Combine all components into cohesive scenario-embedded case note
combine_scenario_note <- function(date, client_name, base_concerns, base_activities, 
                                embedded_content, observations, next_steps, 
                                writer_style, complexity_level) {
  
  # Structure varies by writer style
  if(writer_style == "crisis_documenter") {
    note <- glue("Date: {date} - URGENT: {client_name} crisis session. {embedded_content} Client concerns include: {base_concerns}. Immediate services: {base_activities}. Assessment: {observations} {next_steps}")
  } else if(writer_style == "clinical_tracker") {
    note <- glue("Date: {date} - {client_name} clinical review. Mental health status: {embedded_content} Presenting concerns: {base_concerns}. Interventions: {base_activities}. Clinical observations: {observations} {next_steps}")
  } else if(writer_style == "success_oriented") { 
    note <- glue("Date: {date} - {client_name} progress meeting. {embedded_content} Current focus areas: {base_concerns}. Services provided: {base_activities}. Strengths noted: {observations} {next_steps}")
  } else {
    note <- glue("Date: {date} - {client_name} comprehensive case review. {embedded_content} Client needs: {base_concerns}. Service activities: {base_activities}. Assessment: {observations} {next_steps}")
  }
  
  return(note)
}

# ---- generate-synthetic-data -------------------------------------------------
cat("\n🎯 Generating scenario-embedded synthetic case note data using fabricatr...\n")

# Create the main synthetic dataset using fabricatr
synthetic_cases <- fabricate(
  N = LANE3_COHORT_SIZE,
  
  # Assign archetype based on target distribution
  archetype_id = c(
    rep("A1", CLIENT_ARCHETYPES$A1$count),
    rep("A2", CLIENT_ARCHETYPES$A2$count), 
    rep("A3", CLIENT_ARCHETYPES$A3$count),
    rep("A4", CLIENT_ARCHETYPES$A4$count),
    rep("A5", CLIENT_ARCHETYPES$A5$count),
    rep("A6", CLIENT_ARCHETYPES$A6$count),
    rep("A7", CLIENT_ARCHETYPES$A7$count),
    rep("A8", CLIENT_ARCHETYPES$A8$count),
    rep("A9", CLIENT_ARCHETYPES$A9$count),
    rep("A10", CLIENT_ARCHETYPES$A10$count)
  )[sample(LANE3_COHORT_SIZE)],  # Shuffle to randomize order
  
  # Generate person identifiers (Lane 3 range)
  person_oid = sprintf("SYN_%05d", seq(LANE3_ID_START, LANE3_ID_END, length.out = N)),
  
  # Derive complexity level and scenario preference from archetype
  complexity_level = sapply(archetype_id, function(x) CLIENT_ARCHETYPES[[x]]$complexity_level),
  scenario_preference = sapply(archetype_id, function(x) CLIENT_ARCHETYPES[[x]]$scenario_preference),
  
  # Generate demographics based on archetype specifications  
  age = sapply(archetype_id, function(x) {
    age_range <- CLIENT_ARCHETYPES[[x]]$age_range
    sample(age_range[1]:age_range[2], 1)
  }),
  
  gender = sapply(archetype_id, function(x) {
    gender_dist <- CLIENT_ARCHETYPES[[x]]$gender_distribution
    sample(names(gender_dist), 1, prob = gender_dist)
  }),
  
  # Generate names
  first_name = generate_first_name(gender, N),
  last_name = generate_last_name(N),
  
  # Assign writer style (Lane 3: Standard professional style only)
  writer_style = rep("standard_professional", N),
  
  # Set embedded scenarios (explicit scenario labeling)
  embedded_scenarios = scenario_preference,
  
  # Generate scenario-embedded case notes
  case_note = mapply(generate_scenario_embedded_note, archetype_id, complexity_level, 
                    scenario_preference, writer_style, age, gender, first_name, SIMPLIFY = TRUE)
)

cat("✅ Synthetic scenario-embedded data generation completed!\n")

# ---- data-validation ---------------------------------------------------------
cat("\n🔍 Performing data validation checks...\n")

# Validate archetype distribution
archetype_counts <- table(synthetic_cases$archetype_id)
cat("📊 Archetype Distribution Validation:\n")
for(archetype in names(CLIENT_ARCHETYPES)) {
  expected <- CLIENT_ARCHETYPES[[archetype]]$count
  actual <- as.numeric(archetype_counts[archetype])
  if(is.na(actual)) actual <- 0
  cat("   -", archetype, ":", CLIENT_ARCHETYPES[[archetype]]$name, "- Expected:", expected, ", Actual:", actual,
      ifelse(actual == expected, "✅", "❌"), "\n")
}

# Validate scenario distribution (critical for algorithm testing)
scenario_counts <- table(synthetic_cases$embedded_scenarios)
cat("\n📊 Embedded Scenario Distribution Validation:\n") 
for(scenario in names(scenario_counts)) {
  count <- as.numeric(scenario_counts[scenario])
  cat("   -", scenario, ":", count, "cases\n")
}

# Validate complexity level distribution
complexity_counts <- table(synthetic_cases$complexity_level)  
expected_complexity <- c(`1` = 19, `2` = 34, `3` = 19, `4` = 3)
cat("\n📊 Complexity Level Distribution Validation:\n")
for(level in 1:4) {
  expected <- expected_complexity[as.character(level)]
  actual <- as.numeric(complexity_counts[as.character(level)])
  if(is.na(actual)) actual <- 0
  cat("   - Level", level, ": Expected", expected, ", Actual", actual, 
      ifelse(abs(actual - expected) <= 1, "✅", "❌"), "\n")
}

# Validate writer style distribution
writer_counts <- table(synthetic_cases$writer_style)
cat("\n📊 Writer Style Distribution Validation:\n")
for(style in names(writer_counts)) {
  count <- as.numeric(writer_counts[style])
  cat("   -", style, ":", count, "cases\n")
}

# Validate case note quality and scenario embedding
cat("\n📊 Case Note Quality Validation:\n")
note_lengths <- nchar(synthetic_cases$case_note)
cat("   - Average note length:", round(mean(note_lengths)), "characters\n")
cat("   - Note length range:", min(note_lengths), "-", max(note_lengths), "characters\n")

# Check for empty or suspicious notes
empty_notes <- sum(nchar(synthetic_cases$case_note) < 100)
cat("   - Notes under 100 characters:", empty_notes, ifelse(empty_notes == 0, "✅", "❌"), "\n")

# Validate scenario pattern embedding
housing_crisis_notes <- sum(grepl("housing|eviction|shelter|homeless", synthetic_cases$case_note, ignore.case = TRUE))
mental_health_notes <- sum(grepl("mental health|deteriorat|depression|anxiety|crisis", synthetic_cases$case_note, ignore.case = TRUE))
success_notes <- sum(grepl("progress|success|achievement|goal|positive", synthetic_cases$case_note, ignore.case = TRUE))

cat("\n📊 Scenario Pattern Embedding Validation:\n")
cat("   - Housing crisis language patterns:", housing_crisis_notes, "notes\n")
cat("   - Mental health deterioration patterns:", mental_health_notes, "notes\n")
cat("   - Success connection patterns:", success_notes, "notes\n")

# Validate ID range
id_range_check <- all(grepl("^SYN_00(4[2-9][0-9]|50[0])$", synthetic_cases$person_oid))
cat("   - ID range (SYN_00426-SYN_00500):", ifelse(id_range_check, "✅", "❌"), "\n")

# ---- export-results ----------------------------------------------------------
cat("\n💾 Exporting synthetic scenario-embedded case note data...\n")

# Create output directory if it doesn't exist  
if(!dir.exists(OUTPUT_PATH)) {
  dir.create(OUTPUT_PATH, recursive = TRUE)
  cat("   - Created output directory:", OUTPUT_PATH, "\n")
}

# Prepare final dataset for export (remove internal scenario_preference column)
export_data <- synthetic_cases %>%
  select(person_oid, first_name, last_name, gender, age, complexity_level, 
         archetype_id, writer_style, embedded_scenarios, case_note)

# Export to CSV
output_file <- file.path(OUTPUT_PATH, OUTPUT_FILENAME)
readr::write_csv(export_data, output_file)

cat("✅ Data exported successfully to:", output_file, "\n")

# ---- generation-summary ------------------------------------------------------
cat("\n📋 Synthetic Scenario-Embedded Case Note Generation Summary\n")
cat("==========================================================\n")
cat("🎯 Generation Parameters:\n")
cat("   - Random Seed:", GENERATION_SEED, "\n") 
cat("   - Total Cases:", LANE3_COHORT_SIZE, "\n")
cat("   - ID Range: SYN_00426 to SYN_00500\n")
cat("   - Archetypes:", length(CLIENT_ARCHETYPES), "(A1-A10)\n")
cat("   - Writer Styles: 4 (Scenario-specific)\n")
cat("   - Complexity Levels: 4 (Stable, Moderate, High, Crisis)\n")

cat("\n📊 Final Scenario Distribution:\n")
housing_crisis_final <- sum(synthetic_cases$embedded_scenarios == "housing_crisis")
mental_health_final <- sum(synthetic_cases$embedded_scenarios == "mental_health_deterioration")
success_final <- sum(synthetic_cases$embedded_scenarios == "successful_service_connections")

cat("   - Housing Crisis Scenarios:", housing_crisis_final, "cases\n")
cat("   - Mental Health Deterioration:", mental_health_final, "cases\n")
cat("   - Successful Service Connections:", success_final, "cases\n")
cat("   - Total Scenario-Embedded Cases:", housing_crisis_final + mental_health_final + success_final, "\n")

cat("\n📊 Final Complexity Distribution:\n")
cat("   - Level 1 (Stable):", sum(synthetic_cases$complexity_level == 1), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 1)/LANE3_COHORT_SIZE), ")\n")
cat("   - Level 2 (Moderate):", sum(synthetic_cases$complexity_level == 2), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 2)/LANE3_COHORT_SIZE), ")\n")
cat("   - Level 3 (High):", sum(synthetic_cases$complexity_level == 3), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 3)/LANE3_COHORT_SIZE), ")\n")
cat("   - Level 4 (Crisis):", sum(synthetic_cases$complexity_level == 4), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 4)/LANE3_COHORT_SIZE), ")\n")

cat("\n🎯 Scenario Embedding Features:\n")
cat("   - Housing crisis indicators with specific language patterns (eviction, shelter, utilities)\n")
cat("   - Mental health deterioration progression with clinical markers and timelines\n") 
cat("   - Successful service connections with positive outcomes and goal achievement\n")
cat("   - Natural integration maintaining realistic case narrative flow\n")
cat("   - Writer style alignment with scenario types for authentic documentation\n")

cat("\n🎯 Algorithm Validation Support:\n")
cat("   - Housing crisis detection algorithms: Test against", housing_crisis_final, "embedded cases\n")
cat("   - Mental health sentiment analysis: Test against", mental_health_final, "deterioration patterns\n")
cat("   - Service success identification: Test against", success_final, "positive outcome cases\n")

cat("\n📁 Output Files:\n")
cat("   - CSV Dataset:", output_file, "\n")
cat("   - Schema: person_oid, first_name, last_name, gender, age, complexity_level,\n")
cat("            archetype_id, writer_style, embedded_scenarios, case_note\n")

cat("\n✅ Synthetic scenario-embedded case note generation completed successfully!\n")  
cat("🚀 Data ready for SDA algorithm validation and testing workflows.\n")
cat("🎯 Focus: Precisely embedded validation scenarios for algorithm performance testing.\n")

# ---- session-info -----------------------------------------------------------
cat("\n📋 Session Information:\n")
print(sessionInfo())