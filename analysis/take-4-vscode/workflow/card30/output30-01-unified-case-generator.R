#' ---
#' title: "Unified Synthetic Case Note Generator - Three-Mode Integration"
#' author: "Card 30 Implementation - Synthesis of Cards 31, 32, 33"
#' date: "Last Updated: `r Sys.Date()`"
#' description: "User-friendly unified generator combining standard, variation, and scenario modes in a parameterizable single script"
#' ---
#+ echo=F

# Unified Synthetic Case Note Generator
# Synthesis of Cards 31, 32, and 33 into a Single User-Friendly Script
#
# This script combines the three-lane architecture (standard, variation, scenario) 
# into a unified, parameterizable system that maintains all quality and distribution
# targets while providing superior maintainability and user experience.

rm(list = ls(all.names = TRUE)) # Clear memory
cat("\014") # Clear console

cat("🔧 Unified Synthetic Case Note Generator - Three-Mode Integration\n")
cat("Working directory: ", getwd(), "\n")

# ============================================================================
# USER CONFIGURATION PARAMETERS - EASY TO ADJUST
# ============================================================================

# Dataset Size Configuration
TOTAL_CASES <- 500
MODE1_PERCENTAGE <- 0.60  # Standard cases (60%)
MODE2_PERCENTAGE <- 0.25  # Variation cases (25%) 
MODE3_PERCENTAGE <- 0.15  # Scenario cases (15%)

# Calculate actual case counts
MODE1_CASES <- as.integer(TOTAL_CASES * MODE1_PERCENTAGE)  # 300
MODE2_CASES <- as.integer(TOTAL_CASES * MODE2_PERCENTAGE)  # 125
MODE3_CASES <- TOTAL_CASES - MODE1_CASES - MODE2_CASES     # 75

# Random Seed Management
BASE_SEED <- 20241106     # Change this for different random generations
MODE1_SEED_OFFSET <- 100  # Standard cases seed modifier
MODE2_SEED_OFFSET <- 200  # Variation cases seed modifier
MODE3_SEED_OFFSET <- 300  # Scenario cases seed modifier

# Writer Style Distribution (Mode 2 only)
NEW_CASEWORKER_RATIO <- 0.30      # 30% new workers
EXPERIENCED_WORKER_RATIO <- 0.50   # 50% experienced workers  
SENIOR_WORKER_RATIO <- 0.20        # 20% senior workers

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

# Display configuration
cat("\n📋 CONFIGURATION SUMMARY:\n")
cat("   Total Cases:", TOTAL_CASES, "\n")
cat("   Mode 1 (Standard):", MODE1_CASES, "cases (", round(MODE1_PERCENTAGE*100), "%)\n")
cat("   Mode 2 (Variation):", MODE2_CASES, "cases (", round(MODE2_PERCENTAGE*100), "%)\n")
cat("   Mode 3 (Scenario):", MODE3_CASES, "cases (", round(MODE3_PERCENTAGE*100), "%)\n")
cat("   Base Random Seed:", BASE_SEED, "\n")

# ---- load-packages -----------------------------------------------------------
cat("\n📦 Loading required packages...\n")

library(fabricatr)   # Synthetic data generation framework
library(magrittr)    # Pipe operations
library(dplyr)       # Data manipulation
library(stringr)     # String processing
library(readr)       # Data import/export
library(lubridate)   # Date handling
library(glue)        # String interpolation

if(file.exists("./scripts/common-functions.R")) {
  base::source("./scripts/common-functions.R")
}

cat("✅ Packages loaded successfully\n")

# ---- archetype-definitions ---------------------------------------------------
cat("\n👥 Defining client archetype system...\n")

CLIENT_ARCHETYPES <- list(
  A1 = list(name = "Urban Early Career Stabilizer", complexity_level = 1, age_range = c(22, 35),
           gender_distribution = c("female" = 0.55, "male" = 0.40, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.6, housing_instability = 0.2, mental_health = 0.3)),
  A2 = list(name = "Rural Steady Trades Worker", complexity_level = 1, age_range = c(25, 55),
           gender_distribution = c("female" = 0.25, "male" = 0.70, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.7, housing_instability = 0.2, mental_health = 0.2)),
  A3 = list(name = "Older Stable Support-Seeking Couple", complexity_level = 1, age_range = c(55, 70),
           gender_distribution = c("female" = 0.50, "male" = 0.45, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.5, housing_instability = 0.1, mental_health = 0.3)),
  A4 = list(name = "Single Parent Housing Strain", complexity_level = 2, age_range = c(25, 45),
           gender_distribution = c("female" = 0.80, "male" = 0.15, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.7, housing_instability = 0.8, mental_health = 0.6)),
  A5 = list(name = "Midlife Health & Employment Barriers", complexity_level = 2, age_range = c(40, 60),
           gender_distribution = c("female" = 0.60, "male" = 0.35, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.8, housing_instability = 0.4, mental_health = 0.7)),
  A6 = list(name = "Urban Transitional Recovery Participant", complexity_level = 2, age_range = c(28, 50),
           gender_distribution = c("female" = 0.45, "male" = 0.50, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.8, housing_instability = 0.7, mental_health = 0.8)),
  A7 = list(name = "Rural Multi-Role Caregiver", complexity_level = 2, age_range = c(35, 55),
           gender_distribution = c("female" = 0.75, "male" = 0.20, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.6, housing_instability = 0.3, mental_health = 0.7)),
  A8 = list(name = "Multi-Factor Urban Instability Case", complexity_level = 3, age_range = c(25, 45),
           gender_distribution = c("female" = 0.50, "male" = 0.45, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.9, housing_instability = 0.9, mental_health = 0.8)),
  A9 = list(name = "Chronic Medical & Mental Health Complexity", complexity_level = 3, age_range = c(35, 65),
           gender_distribution = c("female" = 0.60, "male" = 0.35, "other" = 0.05),
           risk_factors = list(employment_barriers = 0.9, housing_instability = 0.6, mental_health = 0.9)),
  A10 = list(name = "Acute Housing & Co-Occurring Crisis", complexity_level = 4, age_range = c(22, 55),
            gender_distribution = c("female" = 0.45, "male" = 0.50, "other" = 0.05),
            risk_factors = list(employment_barriers = 0.9, housing_instability = 1.0, mental_health = 0.9))
)

cat("✅ Defined", length(CLIENT_ARCHETYPES), "client archetypes\n")

# ---- helper-functions --------------------------------------------------------
cat("\n🔧 Setting up helper functions...\n")

generate_first_name <- function(gender, n = 1) {
  female_names <- c("Sarah", "Jennifer", "Jessica", "Ashley", "Amanda", "Melissa", "Nicole", "Amy", "Angela", "Michelle")
  male_names <- c("Michael", "Christopher", "Jason", "David", "James", "Robert", "John", "Matthew", "Daniel", "Anthony")
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

generate_last_name <- function(n = 1) {
  surnames <- c("Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis",
               "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson")
  return(sample(surnames, n, replace = TRUE))
}

calculate_archetype_distribution <- function(mode_cases) {
  level1_target <- round(mode_cases * LEVEL1_STABLE_RATIO)
  level2_target <- round(mode_cases * LEVEL2_MODERATE_RATIO)
  level3_target <- round(mode_cases * LEVEL3_HIGH_RATIO)
  level4_target <- mode_cases - level1_target - level2_target - level3_target
  
  list(
    A1 = ceiling(level1_target / 3), A2 = ceiling(level1_target / 3), A3 = level1_target - 2*ceiling(level1_target / 3),
    A4 = ceiling(level2_target / 4), A5 = ceiling(level2_target / 4), A6 = ceiling(level2_target / 4), A7 = level2_target - 3*ceiling(level2_target / 4),
    A8 = ceiling(level3_target / 2), A9 = level3_target - ceiling(level3_target / 2),
    A10 = level4_target
  )
}

generate_case_note <- function(mode, archetype_id, complexity_level, writer_style, age, gender, first_name, scenario = "none") {
  current_date <- format(Sys.Date() - sample(1:90, 1), "%Y-%m-%d")
  archetype_data <- CLIENT_ARCHETYPES[[archetype_id]]
  
  # Generate concerns based on risk factors
  concerns <- c()
  if(archetype_data$risk_factors$employment_barriers > 0.5) {
    concerns <- c(concerns, sample(c("seeking employment opportunities", "lacking recent work experience", "requires job search support"), 1))
  }
  if(archetype_data$risk_factors$housing_instability > 0.3) {
    concerns <- c(concerns, sample(c("experiencing housing instability", "at risk of eviction", "seeking stable accommodation"), 1))
  }
  if(archetype_data$risk_factors$mental_health > 0.3) {
    concerns <- c(concerns, sample(c("requiring mental health support", "having difficulty coping with stress", "reporting increased anxiety"), 1))
  }
  if(length(concerns) == 0) concerns <- c("general support needs")
  
  # Generate activities
  activities_by_level <- list(
    `1` = c("employment counseling session", "benefit application review", "skills assessment completed"),
    `2` = c("case management meeting", "service coordination", "housing search assistance"),
    `3` = c("intensive case management", "crisis response planning", "multi-agency coordination"),
    `4` = c("emergency intervention", "crisis stabilization", "immediate safety planning")
  )
  activities <- sample(activities_by_level[[as.character(complexity_level)]], min(2, length(activities_by_level[[as.character(complexity_level)]])))
  
  # Generate observations
  observations <- sample(c(
    "Individual demonstrated appropriate engagement and expressed commitment to the service plan.",
    "Client engaged appropriately during the session and demonstrated understanding of discussed options.",
    "Person engaged constructively in problem-solving and indicated readiness for recommended actions."
  ), 1)
  
  # Generate next steps
  next_steps_by_level <- list(
    `1` = "Follow up in two weeks to review progress.",
    `2` = "Weekly check-ins scheduled for ongoing support.",
    `3` = "Daily contact scheduled for remainder of week.",
    `4` = "Immediate crisis intervention services activated."
  )
  next_steps <- next_steps_by_level[[as.character(complexity_level)]]
  
  # Apply mode-specific modifications
  if(mode == "scenario" && scenario != "none") {
    if(scenario == "housing_crisis") {
      concerns <- c(concerns, "HOUSING CRISIS: Client facing eviction. Immediate housing intervention required.")
    } else if(scenario == "mental_health_deterioration") {
      concerns <- c(concerns, "Mental health concerns: missed last three appointments. symptoms began 3 months ago. Clinical review scheduled.")
    } else if(scenario == "successful_service_connections") {
      concerns <- c(concerns, "Positive progress: Client actively participating in programming. obtained stable employment. Continuing supportive services.")
    }
  }
  
  # Format based on writer style
  if(writer_style == "new_caseworker") {
    note <- glue('Date: {current_date}
Client: {first_name}
Session Summary:
1. Presenting concerns: {paste(concerns, collapse=", ")}
2. Services provided: {paste(activities, collapse=", ")}
3. Worker observations: {observations}
4. Next steps planned: {next_steps}')
  } else if(writer_style == "experienced_worker") {
    note <- glue('{current_date} - {first_name} session. Key issues: {paste(concerns, collapse=", ")}. Interventions: {paste(activities, collapse=", ")}. Assessment: {observations} Action plan: {next_steps}')
  } else {
    note <- glue('Date: {current_date} - {first_name} session. Client concerns: {paste(concerns, collapse=", ")}. Services provided: {paste(activities, collapse=", ")}. Assessment: {observations} Plan: {next_steps}')
  }
  
  return(note)
}

cat("✅ Helper functions configured\n")

# ---- unified-generation -------------------------------------------------------
cat("\n🎯 Generating unified synthetic dataset...\n")

# Set master seed
set.seed(BASE_SEED)

# Calculate distributions
mode1_distribution <- calculate_archetype_distribution(MODE1_CASES)
mode2_distribution <- calculate_archetype_distribution(MODE2_CASES)
mode3_distribution <- calculate_archetype_distribution(MODE3_CASES)

# Generate complete unified dataset
unified_dataset <- fabricate(
  N = TOTAL_CASES,
  
  # Determine mode based on position
  mode = c(rep("standard", MODE1_CASES), rep("variation", MODE2_CASES), rep("scenario", MODE3_CASES)),
  
  # Generate person identifiers
  person_oid = sprintf("SYN_%05d", 1:N),
  
  # Assign archetypes based on mode
  archetype_id = c(
    # Mode 1 distribution
    rep("A1", mode1_distribution$A1), rep("A2", mode1_distribution$A2), rep("A3", mode1_distribution$A3),
    rep("A4", mode1_distribution$A4), rep("A5", mode1_distribution$A5), rep("A6", mode1_distribution$A6),
    rep("A7", mode1_distribution$A7), rep("A8", mode1_distribution$A8), rep("A9", mode1_distribution$A9),
    rep("A10", mode1_distribution$A10),
    # Mode 2 distribution  
    rep("A1", mode2_distribution$A1), rep("A2", mode2_distribution$A2), rep("A3", mode2_distribution$A3),
    rep("A4", mode2_distribution$A4), rep("A5", mode2_distribution$A5), rep("A6", mode2_distribution$A6),
    rep("A7", mode2_distribution$A7), rep("A8", mode2_distribution$A8), rep("A9", mode2_distribution$A9),
    rep("A10", mode2_distribution$A10),
    # Mode 3 distribution
    rep("A1", mode3_distribution$A1), rep("A2", mode3_distribution$A2), rep("A3", mode3_distribution$A3),
    rep("A4", mode3_distribution$A4), rep("A5", mode3_distribution$A5), rep("A6", mode3_distribution$A6),
    rep("A7", mode3_distribution$A7), rep("A8", mode3_distribution$A8), rep("A9", mode3_distribution$A9),
    rep("A10", mode3_distribution$A10)
  ),
  
  # Derive complexity level from archetype
  complexity_level = sapply(archetype_id, function(x) CLIENT_ARCHETYPES[[x]]$complexity_level),
  
  # Generate demographics
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
  
  # Assign writer styles based on mode
  writer_style = c(
    rep("standard_professional", MODE1_CASES),
    sample(c(rep("new_caseworker", round(MODE2_CASES * NEW_CASEWORKER_RATIO)),
            rep("experienced_worker", round(MODE2_CASES * EXPERIENCED_WORKER_RATIO)),
            rep("senior_worker", MODE2_CASES - round(MODE2_CASES * NEW_CASEWORKER_RATIO) - round(MODE2_CASES * EXPERIENCED_WORKER_RATIO)))),
    rep("standard_professional", MODE3_CASES)
  ),
  
  # Assign embedded scenarios
  embedded_scenarios = c(
    rep("none", MODE1_CASES + MODE2_CASES),
    c(rep("housing_crisis", HOUSING_CRISIS_TARGET),
      rep("mental_health_deterioration", MENTAL_HEALTH_TARGET),
      rep("successful_service_connections", SUCCESS_CONNECTION_TARGET))
  ),
  
  # Generate case notes
  case_note = mapply(generate_case_note, mode, archetype_id, complexity_level, writer_style, 
                    age, gender, first_name, embedded_scenarios, SIMPLIFY = TRUE)
)

cat("✅ Unified dataset generated:", nrow(unified_dataset), "cases\n")

# ---- validation-and-export ---------------------------------------------------
cat("\n🔍 Performing validation and export...\n")

# Validation checks
complexity_dist <- table(unified_dataset$complexity_level)
scenario_dist <- table(unified_dataset$embedded_scenarios)
writer_dist <- table(unified_dataset$writer_style)

cat("📊 VALIDATION RESULTS:\n")
cat("   Total cases:", nrow(unified_dataset), "(Target:", TOTAL_CASES, ")", ifelse(nrow(unified_dataset) == TOTAL_CASES, "✅", "❌"), "\n")
for(level in 1:4) {
  count <- as.numeric(complexity_dist[as.character(level)])
  cat("   Level", level, ":", count, "cases (", round(count/TOTAL_CASES*100, 1), "%)\n")
}

cat("   Scenario distribution:\n")
for(scenario in names(scenario_dist)) {
  count <- as.numeric(scenario_dist[scenario])
  cat("     -", scenario, ":", count, "cases\n")
}

# Export results
if(!dir.exists(OUTPUT_PATH)) {
  dir.create(OUTPUT_PATH, recursive = TRUE)
}

output_file <- file.path(OUTPUT_PATH, OUTPUT_FILENAME)
readr::write_csv(unified_dataset, output_file)

cat("\n✅ UNIFIED GENERATION COMPLETED SUCCESSFULLY!\n")
cat("📁 Output file:", output_file, "\n")
cat("🎯 Dataset ready for Strategic Data Analytics workflows\n")
cat("🔧 Single script replaces three-file coordination complexity\n")

print(sessionInfo())