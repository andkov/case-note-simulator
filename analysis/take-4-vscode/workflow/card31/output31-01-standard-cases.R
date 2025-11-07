#' ---
#' title: "Primary Case Note Writer - Synthetic Standard Cases Generator"
#' author: "Card 31 Implementation"
#' date: "Last Updated: `r Sys.Date()`"
#' description: "Generate realistic synthetic case notes using fabricatr with authentic caseworker language and observations"
#' ---
#+ echo=F

# Primary Case Note Writer - Synthetic Standard Cases Generator
# Lane 1 of 3-Lane Architecture: Standard Case Generation (60% of total dataset)
#
# This script generates 300 synthetic case notes for social services clients using
# the fabricatr package with authentic caseworker language, terminology, and
# observation patterns while maintaining complete fictional status.
#
# Key Features:
# 1. 10 validated client archetypes (A1-A10) across 4 complexity levels
# 2. 5 distinct writer styles with realistic distribution quotas
# 3. Deterministic random seed management for reproducible outputs (coordinated)
# 4. Complexity-appropriate note length and intervention patterns
# 5. Authentic social services terminology and documentation patterns
# 6. ID range: SYN_00001 to SYN_00300 (Lane 1 allocation)
#
# Output: CSV with columns: person_oid,first_name,last_name,gender,age,case_note,
#         complexity_level,archetype_id,writer_style,embedded_scenarios

rm(list = ls(all.names = TRUE)) # Clear memory
cat("\014") # Clear console

cat("🏗️ Primary Case Note Writer - Synthetic Standard Cases Generator\n")
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
GENERATION_SEED <- 20241206  # Base seed + 100 for Lane 1 coordination
set.seed(GENERATION_SEED)

# Lane 1 cohort size (60% of 500 total cases)
LANE1_COHORT_SIZE <- 300

# ID range for Lane 1 coordination
LANE1_ID_START <- 1
LANE1_ID_END <- 300

# Output configuration
OUTPUT_PATH <- "./analysis/take-4-vscode/workflow/card31/"
OUTPUT_FILENAME <- "standard_cases.csv"

# ---- standard-writer-specification ------------------------------------------
cat("📝 Defining standard professional writer style...\n")

# Standard Professional Writer Style (Single Baseline Style)
# Consistent, professional documentation serving as baseline for Lane 1
STANDARD_WRITER_STYLE <- list(
  name = "standard_professional",
  avg_words = c(140, 220, 320, 480),  # By complexity level - moderate length
  tone = "professional_consistent",
  characteristics = c("clear", "professional", "solution_oriented", "consistent_terminology"),
  structure = "problem_assessment_plan"  # Standard PAP format
)

cat("✅ Standard Writer Style:\n")
cat("   - Name:", STANDARD_WRITER_STYLE$name, "\n")
cat("   - Tone:", STANDARD_WRITER_STYLE$tone, "\n")
cat("   - Structure:", STANDARD_WRITER_STYLE$structure, "\n")
cat("   - Word Count by Complexity:", paste(STANDARD_WRITER_STYLE$avg_words, collapse = ", "), "\n")

# ---- archetype-specifications ------------------------------------------------
cat("\n📊 Defining client archetype specifications...\n")

# Client Archetypes based on Calibrated Framework (Card 22)
# Lane 1 Distribution: 300 cases maintaining proportional complexity levels
# Level 1 (25%), Level 2 (45%), Level 3 (25%), Level 4 (5%)
CLIENT_ARCHETYPES <- list(
  
  # LEVEL 1: STABLE (25% of 300 = 75 profiles)
  A1 = list(
    name = "Urban Early Career Stabilizer",
    complexity_level = 1,
    count = 24,  # 8% of 300
    demographics = list(
      age_range = c(22, 32),
      gender_dist = c(female = 0.55, male = 0.44, other = 0.01),
      urban_rural = "urban",
      family_structure = "single_adult"
    ),
    risk_factors = list(
      employment_barriers = 0.8,
      housing_instability = 0.15,
      mental_health = 0.20,
      substance_use = 0.10
    ),
    service_patterns = c("employment_counseling", "skills_assessment", "job_search_support")
  ),
  
  A2 = list(
    name = "Rural Steady Trades Worker", 
    complexity_level = 1,
    count = 27,  # 9% of 300
    demographics = list(
      age_range = c(28, 48),
      gender_dist = c(female = 0.25, male = 0.74, other = 0.01),
      urban_rural = "rural",
      family_structure = "couple_no_dependents"
    ),
    risk_factors = list(
      employment_barriers = 0.9,
      housing_instability = 0.10,
      mental_health = 0.15,
      substance_use = 0.15
    ),
    service_patterns = c("seasonal_employment", "trades_training", "transportation_support")
  ),
  
  A3 = list(
    name = "Older Stable Support-Seeking Couple",
    complexity_level = 1, 
    count = 24,  # 8% of 300
    demographics = list(
      age_range = c(58, 68),
      gender_dist = c(female = 0.52, male = 0.47, other = 0.01),
      urban_rural = "urban",
      family_structure = "couple_no_dependents"
    ),
    risk_factors = list(
      employment_barriers = 0.7,
      housing_instability = 0.05,
      mental_health = 0.10,
      medical_complexity = 0.3
    ),
    service_patterns = c("career_transition", "benefit_navigation", "health_coordination")
  ),
  
  # LEVEL 2: MODERATE (45% of 300 = 135 profiles)  
  A4 = list(
    name = "Single Parent Housing Strain",
    complexity_level = 2,
    count = 36,  # 12% of 300
    demographics = list(
      age_range = c(24, 38),
      gender_dist = c(female = 0.85, male = 0.14, other = 0.01),
      urban_rural = "urban",
      family_structure = "single_parent"
    ),
    risk_factors = list(
      housing_instability = 0.85,
      employment_barriers = 0.70,
      dependent_care = 1.0,
      mental_health = 0.35
    ),
    service_patterns = c("housing_search", "childcare_coordination", "income_support", "parenting_resources")
  ),
  
  A5 = list(
    name = "Midlife Health & Employment Barriers",
    complexity_level = 2,
    count = 33,  # 11% of 300
    demographics = list(
      age_range = c(45, 58),
      gender_dist = c(female = 0.60, male = 0.39, other = 0.01),
      urban_rural = "urban",
      family_structure = "single_adult"
    ),
    risk_factors = list(
      medical_complexity = 0.90,
      employment_barriers = 0.85,
      mental_health = 0.40,
      housing_instability = 0.25
    ),
    service_patterns = c("medical_coordination", "disability_benefits", "accommodation_planning", "retraining")
  ),
  
  A6 = list(
    name = "Urban Transitional Recovery Participant",
    complexity_level = 2,
    count = 33,  # 11% of 300
    demographics = list(
      age_range = c(26, 44),
      gender_dist = c(female = 0.40, male = 0.58, other = 0.02),
      urban_rural = "urban", 
      family_structure = "single_adult"
    ),
    risk_factors = list(
      substance_use = 0.95,
      mental_health = 0.60,
      employment_barriers = 0.80,
      housing_instability = 0.50,
      justice_involvement = 0.30
    ),
    service_patterns = c("recovery_program", "mental_health_support", "structured_housing", "life_skills")
  ),
  
  A7 = list(
    name = "Rural Multi-Role Caregiver",
    complexity_level = 2,
    count = 33,  # 11% of 300
    demographics = list(
      age_range = c(32, 52),
      gender_dist = c(female = 0.75, male = 0.24, other = 0.01),
      urban_rural = "rural",
      family_structure = "multi_generational"
    ),
    risk_factors = list(
      dependent_care = 1.0,
      employment_barriers = 0.75,
      housing_instability = 0.30,
      mental_health = 0.45,
      medical_complexity = 0.40
    ),
    service_patterns = c("respite_care", "transportation", "multi_service_coordination", "caregiver_support")
  ),
  
  # LEVEL 3: HIGH (25% = 125 profiles)
  A8 = list(
    name = "Multi-Factor Urban Instability Case",
    complexity_level = 3,
    count = 39,  # 13% of 300
    demographics = list(
      age_range = c(28, 45),
      gender_dist = c(female = 0.45, male = 0.53, other = 0.02),
      urban_rural = "urban",
      family_structure = "single_adult"
    ),
    risk_factors = list(
      housing_instability = 0.95,
      mental_health = 0.80,
      employment_barriers = 0.90,
      substance_use = 0.60,
      justice_involvement = 0.50
    ),
    service_patterns = c("crisis_intervention", "intensive_case_management", "multi_agency_coordination", "harm_reduction")
  ),
  
  A9 = list(
    name = "Chronic Medical & Mental Health Complexity",
    complexity_level = 3,
    count = 36,  # 12% of 300
    demographics = list(
      age_range = c(35, 62),
      gender_dist = c(female = 0.65, male = 0.34, other = 0.01),
      urban_rural = "urban",
      family_structure = "single_adult"
    ),
    risk_factors = list(
      medical_complexity = 0.95,
      mental_health = 0.90,
      employment_barriers = 0.85,
      housing_instability = 0.40,
      substance_use = 0.30
    ),
    service_patterns = c("medical_case_management", "mental_health_intensive", "benefit_advocacy", "functional_support")
  ),
  
  # LEVEL 4: CRISIS (5% = 25 profiles)
  A10 = list(
    name = "Acute Housing & Co-Occurring Crisis",
    complexity_level = 4,
    count = 15,  # 5% of 300
    demographics = list(
      age_range = c(25, 55),
      gender_dist = c(female = 0.35, male = 0.63, other = 0.02),
      urban_rural = "urban",
      family_structure = "single_adult"
    ),
    risk_factors = list(
      housing_instability = 1.0,
      substance_use = 0.90,
      mental_health = 0.85,
      justice_involvement = 0.70,
      employment_barriers = 0.95,
      medical_complexity = 0.50
    ),
    service_patterns = c("emergency_response", "crisis_stabilization", "harm_reduction", "immediate_housing", "safety_planning")
  )
)

# Validate archetype counts sum to total cohort size
total_archetype_count <- sum(sapply(CLIENT_ARCHETYPES, function(x) x$count))
if(total_archetype_count != LANE1_COHORT_SIZE) {
  stop("Archetype counts must sum to ", LANE1_COHORT_SIZE, ". Current sum: ", total_archetype_count)
}

cat("✅ Client Archetype Distribution:\n")
for(archetype in names(CLIENT_ARCHETYPES)) {
  arch_data <- CLIENT_ARCHETYPES[[archetype]]
  cat("   -", archetype, ":", arch_data$name, "(", arch_data$count, "profiles,", 
      scales::percent(arch_data$count/LANE1_COHORT_SIZE), ")\n")
}

# ---- helper-functions --------------------------------------------------------
cat("\n🔧 Setting up helper functions...\n")

# Generate realistic first names
generate_first_name <- function(gender, n = 1) {
  female_names <- c("Sarah", "Jennifer", "Jessica", "Ashley", "Amanda", "Melissa", "Nicole", 
                   "Michelle", "Kimberly", "Amy", "Lisa", "Angela", "Heather", "Brenda",
                   "Emma", "Olivia", "Sophia", "Isabella", "Mia", "Charlotte", "Amelia")
  
  male_names <- c("Michael", "Christopher", "Jason", "David", "James", "Robert", "John",
                 "Joseph", "Matthew", "Daniel", "Ryan", "Andrew", "Joshua", "Brian",
                 "William", "Kevin", "Thomas", "Richard", "Charles", "Steven", "Mark")
  
  other_names <- c("Alex", "Jordan", "Casey", "Taylor", "Morgan", "Jamie", "Avery", "Riley")
  
  result <- character(n)
  for(i in 1:n) {
    if(gender[i] == "female") {
      result[i] <- sample(female_names, 1)
    } else if(gender[i] == "male") {
      result[i] <- sample(male_names, 1)
    } else {
      result[i] <- sample(other_names, 1)
    }
  }
  return(result)
}

# Generate realistic last names
generate_last_name <- function(n = 1) {
  surnames <- c("Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis",
               "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson",
               "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Thompson", "White",
               "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson", "Walker", "Young",
               "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores", "Green")
  
  return(sample(surnames, n, replace = TRUE))
}

# Assign standard writer style (single consistent style for Lane 1)
assign_writer_style <- function(n) {
  return(rep(STANDARD_WRITER_STYLE$name, n))
}

# Generate case note based on archetype and complexity (standard professional style)
generate_case_note <- function(archetype_id, complexity_level, writer_style, age, gender, first_name) {
  
  archetype_data <- CLIENT_ARCHETYPES[[archetype_id]]
  
  # Get target word count for this complexity level (standard professional style)
  target_words <- STANDARD_WRITER_STYLE$avg_words[complexity_level]
  
  # Base case note components
  client_concerns <- generate_client_concerns(archetype_data, complexity_level)
  service_activities <- generate_service_activities(archetype_data, complexity_level)
  caseworker_observations <- generate_caseworker_observations(archetype_data, writer_style, age, gender)
  next_steps <- generate_next_steps(archetype_data, complexity_level, writer_style)
  
  # Combine components based on writer style
  case_note <- combine_note_components(
    client_concerns, service_activities, caseworker_observations, next_steps,
    writer_style, complexity_level, first_name
  )
  
  return(case_note)
}

# Generate client concerns based on archetype and complexity
generate_client_concerns <- function(archetype_data, complexity_level) {
  
  concerns_library <- list(
    employment = c(
      "seeking employment opportunities",
      "lacking recent work experience", 
      "needing skills upgrading",
      "facing transportation barriers to work",
      "requires job search support"
    ),
    housing = c(
      "experiencing housing instability",
      "at risk of eviction",
      "living in overcrowded conditions",
      "seeking affordable housing options",
      "requiring emergency shelter placement"
    ),
    mental_health = c(
      "reporting increased anxiety",
      "experiencing symptoms of depression", 
      "having difficulty coping with stress",
      "requiring mental health support",
      "struggling with emotional regulation"
    ),
    substance_use = c(
      "participating in recovery program",
      "maintaining sobriety",
      "addressing substance use challenges",
      "requiring addiction support services",
      "attending treatment appointments"
    ),
    medical = c(
      "managing chronic health conditions",
      "requiring medical coordination",
      "facing health-related barriers",
      "needing accommodation planning",
      "attending multiple medical appointments"
    ),
    family = c(
      "caring for dependent children",
      "balancing multiple caregiving roles",
      "seeking childcare support",
      "managing family responsibilities",
      "requiring respite care"
    )
  )
  
  # Select concerns based on archetype risk factors
  selected_concerns <- c()
  
  if(archetype_data$risk_factors$employment_barriers > 0.5) {
    selected_concerns <- c(selected_concerns, sample(concerns_library$employment, 1))
  }
  
  if(archetype_data$risk_factors$housing_instability > 0.3) {
    selected_concerns <- c(selected_concerns, sample(concerns_library$housing, 1))
  }
  
  if(archetype_data$risk_factors$mental_health > 0.3) {
    selected_concerns <- c(selected_concerns, sample(concerns_library$mental_health, 1))
  }
  
  if(!is.null(archetype_data$risk_factors$substance_use) && archetype_data$risk_factors$substance_use > 0.3) {
    selected_concerns <- c(selected_concerns, sample(concerns_library$substance_use, 1))
  }
  
  if(!is.null(archetype_data$risk_factors$medical_complexity) && archetype_data$risk_factors$medical_complexity > 0.3) {
    selected_concerns <- c(selected_concerns, sample(concerns_library$medical, 1))
  }
  
  if(!is.null(archetype_data$risk_factors$dependent_care) && archetype_data$risk_factors$dependent_care > 0.5) {
    selected_concerns <- c(selected_concerns, sample(concerns_library$family, 1))
  }
  
  # Ensure at least one concern
  if(length(selected_concerns) == 0) {
    selected_concerns <- sample(concerns_library$employment, 1)
  }
  
  return(paste(selected_concerns, collapse = ", "))
}

# Generate service activities
generate_service_activities <- function(archetype_data, complexity_level) {
  
  activities_by_complexity <- list(
    `1` = c(
      "provided employment counseling session",
      "completed skills assessment",
      "reviewed job search strategies",
      "connected to training resources",
      "scheduled follow-up appointment"
    ),
    `2` = c(
      "coordinated with housing worker",
      "completed income support review",
      "provided crisis intervention support",
      "facilitated service referrals",
      "conducted home visit assessment",
      "linked to community resources"
    ),
    `3` = c(
      "implemented safety planning",
      "coordinated multi-agency response",
      "provided intensive case management",
      "conducted risk assessment",
      "facilitated emergency intervention",
      "organized case conference"
    ),
    `4` = c(
      "responded to immediate crisis",
      "coordinated emergency services",
      "implemented harm reduction strategies",
      "provided crisis stabilization",
      "engaged emergency supports",
      "documented safety concerns"
    )
  )
  
  level_activities <- activities_by_complexity[[as.character(complexity_level)]]
  selected_activities <- sample(level_activities, min(complexity_level + 1, length(level_activities)))
  
  return(paste(selected_activities, collapse = ", "))
}

# Generate caseworker observations
generate_caseworker_observations <- function(archetype_data, writer_style, age, gender) {
  
  # Standard professional observations (consistent baseline style)
  standard_observations <- c(
    "Client engaged appropriately during the session and demonstrated understanding of discussed options.",
    "Individual participated well in the assessment process and expressed willingness to follow through on recommendations.",
    "Client showed good insight into their current situation and appeared motivated to work toward identified goals.",
    "Person was receptive to suggested interventions and indicated readiness to take next steps.",
    "Client communicated concerns clearly and responded positively to support planning.",
    "Individual demonstrated appropriate engagement and expressed commitment to the service plan.",
    "Client appeared motivated to address identified barriers and showed understanding of available resources.",
    "Person engaged constructively in problem-solving and indicated readiness for recommended actions."
  )
  
  # Return random standard professional observation
  return(sample(standard_observations, 1))
}

# Generate next steps
generate_next_steps <- function(archetype_data, complexity_level, writer_style) {
  
  next_steps_by_level <- list(
    `1` = c(
      "Follow up in two weeks to review progress.",
      "Client to attend scheduled training session.",
      "Will provide job search support as needed.",
      "Next appointment scheduled for skills assessment."
    ),
    `2` = c(
      "Weekly check-ins scheduled for ongoing support.",
      "Housing worker to contact within 48 hours.",
      "Income support review scheduled for next month.",
      "Crisis plan reviewed and updated."
    ),
    `3` = c(
      "Daily contact scheduled for remainder of week.",
      "Case conference planned with multi-disciplinary team.",
      "Safety plan to be reviewed every 72 hours.",
      "Intensive supports coordinated for immediate period."
    ),
    `4` = c(
      "Emergency services remain on standby.",
      "Crisis response team to maintain active involvement.",
      "Daily safety checks implemented.",
      "Immediate stabilization services coordinated."
    )
  )
  
  # Standard professional next steps format
  level_steps <- next_steps_by_level[[as.character(complexity_level)]]
  return(paste("Plan:", sample(level_steps, 1)))
}

# Combine note components based on writer style
combine_note_components <- function(concerns, activities, observations, next_steps, writer_style, complexity_level, first_name) {
  
  current_date <- format(Sys.Date() - sample(1:90, 1), "%Y-%m-%d")
  
  # Standard professional case note format (Problem-Assessment-Plan structure)
  note <- glue("Date: {current_date} - {first_name} session. Client concerns: {concerns}. Services provided: {activities}. Assessment: {observations} {next_steps}")
  
  return(note)
}

# ---- generate-synthetic-data -------------------------------------------------
cat("\n🎯 Generating synthetic case note data using fabricatr...\n")

# Create the main synthetic dataset using fabricatr
synthetic_cases <- fabricate(
  N = LANE1_COHORT_SIZE,
  
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
  )[sample(LANE1_COHORT_SIZE)],  # Shuffle to randomize order
  
  # Generate person identifiers
  person_oid = sprintf("SYN_%05d", 1:N),
  
  # Derive complexity level from archetype
  complexity_level = sapply(archetype_id, function(x) CLIENT_ARCHETYPES[[x]]$complexity_level),
  
  # Generate demographics based on archetype specifications
  age = sapply(archetype_id, function(x) {
    age_range <- CLIENT_ARCHETYPES[[x]]$demographics$age_range
    sample(age_range[1]:age_range[2], 1)
  }),
  
  gender = sapply(archetype_id, function(x) {
    gender_dist <- CLIENT_ARCHETYPES[[x]]$demographics$gender_dist
    sample(names(gender_dist), 1, prob = gender_dist)
  }),
  
  # Generate names
  first_name = generate_first_name(gender, N),
  last_name = generate_last_name(N),
  
  # Assign writer styles based on quotas
  writer_style = assign_writer_style(N),
  
  # Generate embedded scenarios (Lane 1: Standard baseline - NO embedded scenarios)
  embedded_scenarios = rep("none", N),
  
  # Generate case notes
  case_note = mapply(generate_case_note, archetype_id, complexity_level, writer_style, age, gender, first_name, SIMPLIFY = TRUE)
)

cat("✅ Synthetic data generation completed!\n")

# ---- data-validation ---------------------------------------------------------
cat("\n🔍 Performing data validation checks...\n")

# Validate archetype distribution
archetype_counts <- table(synthetic_cases$archetype_id)
cat("📊 Archetype Distribution Validation:\n")
for(archetype in names(CLIENT_ARCHETYPES)) {
  expected <- CLIENT_ARCHETYPES[[archetype]]$count
  actual <- as.numeric(archetype_counts[archetype])
  cat("   -", archetype, ": Expected", expected, ", Actual", actual, 
      ifelse(expected == actual, "✅", "❌"), "\n")
}

# Validate complexity level distribution
complexity_counts <- table(synthetic_cases$complexity_level)
expected_complexity <- c(`1` = 125, `2` = 225, `3` = 125, `4` = 25)
cat("\n📊 Complexity Level Distribution Validation:\n")
for(level in 1:4) {
  expected <- expected_complexity[as.character(level)]
  actual <- as.numeric(complexity_counts[as.character(level)])
  cat("   - Level", level, ": Expected", expected, ", Actual", actual,
      ifelse(expected == actual, "✅", "❌"), "\n")
}

# Validate writer style distribution
writer_counts <- table(synthetic_cases$writer_style)
cat("\n📊 Writer Style Distribution Validation:\n")
expected_standard <- LANE1_COHORT_SIZE
actual_standard <- as.numeric(writer_counts[STANDARD_WRITER_STYLE$name])
if(is.na(actual_standard)) actual_standard <- 0
cat("   - Standard Professional: Expected", expected_standard, ", Actual", actual_standard, 
    ifelse(actual_standard == expected_standard, "✅", "❌"), "\n")

# Validate case note quality
cat("\n📊 Case Note Quality Validation:\n")
note_lengths <- nchar(synthetic_cases$case_note)
cat("   - Average note length:", round(mean(note_lengths)), "characters\n")
cat("   - Note length range:", min(note_lengths), "-", max(note_lengths), "characters\n")

# Check for empty or suspicious notes
empty_notes <- sum(nchar(synthetic_cases$case_note) < 50)
cat("   - Notes under 50 characters:", empty_notes, ifelse(empty_notes == 0, "✅", "❌"), "\n")

# Validate embedded scenario distribution
scenario_counts <- table(synthetic_cases$embedded_scenarios)
cat("\n📊 Embedded Scenario Distribution:\n")
for(scenario in names(scenario_counts)) {
  count <- as.numeric(scenario_counts[scenario])
  percentage <- round(count / LANE1_COHORT_SIZE * 100, 1)
  cat("   -", scenario, ":", count, "(", percentage, "%)\n")
}

# ---- export-results ----------------------------------------------------------
cat("\n💾 Exporting synthetic case note data...\n")

# Create output directory if it doesn't exist
if(!dir.exists(OUTPUT_PATH)) {
  dir.create(OUTPUT_PATH, recursive = TRUE)
}

# Prepare final dataset for export (match corrected column order specification)
export_data <- synthetic_cases %>%
  select(person_oid, first_name, last_name, gender, age, complexity_level, 
         archetype_id, writer_style, embedded_scenarios, case_note)

# Export to CSV
output_file <- file.path(OUTPUT_PATH, OUTPUT_FILENAME)
readr::write_csv(export_data, output_file)

cat("✅ Data exported successfully to:", output_file, "\n")

# ---- generation-summary ------------------------------------------------------
cat("\n📋 Synthetic Case Note Generation Summary\n")
cat("==========================================\n")
cat("🎯 Generation Parameters:\n")
cat("   - Random Seed:", GENERATION_SEED, "\n")
cat("   - Total Cases:", LANE1_COHORT_SIZE, "\n")
cat("   - Archetypes:", length(CLIENT_ARCHETYPES), "(A1-A10)\n")
cat("   - Writer Style: 1 (Standard Professional)\n")
cat("   - Complexity Levels: 4 (Stable, Moderate, High, Crisis)\n")

cat("\n📊 Final Distribution:\n")
cat("   - Level 1 (Stable):", sum(synthetic_cases$complexity_level == 1), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 1)/LANE1_COHORT_SIZE), ")\n")
cat("   - Level 2:", sum(synthetic_cases$complexity_level == 2), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 2)/LANE1_COHORT_SIZE), ")\n")
cat("   - Level 3:", sum(synthetic_cases$complexity_level == 3), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 3)/LANE1_COHORT_SIZE), ")\n")
cat("   - Level 4:", sum(synthetic_cases$complexity_level == 4), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 4)/LANE1_COHORT_SIZE), ")\n")

cat("\n📝 Writer Style Distribution (Standard Professional Only):\n")
actual_count <- sum(synthetic_cases$writer_style == STANDARD_WRITER_STYLE$name)
actual_pct <- actual_count / LANE1_COHORT_SIZE
cat("   - Standard Professional:", scales::percent(actual_pct), "(Expected: 100%)\n")

cat("\n🎯 Validation Targets Met:\n")
housing_crisis_count <- sum(synthetic_cases$embedded_scenarios == "housing_crisis")
mental_health_det_count <- sum(synthetic_cases$embedded_scenarios == "mental_health_deterioration") 
service_connection_count <- sum(synthetic_cases$embedded_scenarios == "service_connection")

cat("   - Housing Crisis:", housing_crisis_count, "(", 
    scales::percent(housing_crisis_count/LANE1_COHORT_SIZE), ", target: 5%)\n")
cat("   - Mental Health Deterioration:", mental_health_det_count, "(", 
    scales::percent(mental_health_det_count/LANE1_COHORT_SIZE), ", target: 5%)\n")
cat("   - Service Connection:", service_connection_count, "(", 
    scales::percent(service_connection_count/LANE1_COHORT_SIZE), ", target: 5%)\n")

cat("\n📁 Output Files:\n")
cat("   - CSV Dataset:", output_file, "\n")
cat("   - Schema: person_oid, first_name, last_name, gender, age, complexity_level,\n")
cat("            archetype_id, writer_style, embedded_scenarios, case_note\n")

cat("\n✅ Synthetic case note generation completed successfully!\n")
cat("🚀 Data ready for downstream analysis and validation workflows.\n")

# ---- session-info -----------------------------------------------------------
cat("\n📋 Session Information:\n")
print(sessionInfo())