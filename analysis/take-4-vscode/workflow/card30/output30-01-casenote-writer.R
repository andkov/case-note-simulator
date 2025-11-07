#' ---
#' title: "Three-Mode Synthetic Case Note Generator"  
#' author: "Card 30 Implementation - Overlapping Noise Source Methodology"
#' date: "Last Updated: `r Sys.Date()`"
#' description: "Comprehensive synthetic case note generator using three overlapping noise sources: writer styles and embedded scenarios"
#' ---
#+ echo=F

# Three-Mode Synthetic Case Note Generator
# Overlapping noise source methodology for realistic case note variation
#
# This script implements three types of noise sources that can be combined:
# 1. Writer Style Variation (default vs variety writers)
# 2. Scenario Embedding (crisis patterns applied to any writer style)  
# 3. Quality Variation (within variety writers)
# Optimized for algorithm validation and testing workflows.

rm(list = ls(all.names = TRUE)) # Clear memory
cat("\014") # Clear console

cat("🎯 Three-Mode Synthetic Case Note Generator\n")
cat("Working directory: ", getwd(), "\n")

# ============================================================================
# USER CONFIGURATION PARAMETERS - EASY TO ADJUST
# ============================================================================

# Dataset Size Configuration
TOTAL_CASES <- 500

# Writer Style Distribution (must add to 100%)
# Note: Following userPrompt30.md percentages but with overlapping interpretation
DEFAULT_WRITER_PERCENTAGE <- 0.75   # Default professional writer (75% = 60% + 15% remaining)
VARIETY_WRITER_PERCENTAGE <- 0.25   # Variety writers (25%)

# Validate writer style percentages add up to 100%
if(abs((DEFAULT_WRITER_PERCENTAGE + VARIETY_WRITER_PERCENTAGE) - 1.0) > 0.001) {
  stop("ERROR: Writer style percentages must add up to 1.0 (100%)")
}

# Calculate writer style case counts  
DEFAULT_WRITER_CASES <- as.integer(TOTAL_CASES * DEFAULT_WRITER_PERCENTAGE)      # 375
VARIETY_WRITER_CASES <- TOTAL_CASES - DEFAULT_WRITER_CASES                       # 125

# Scenario Embedding (overlay on writer styles)
SCENARIO_EMBEDDING_PERCENTAGE <- 0.15   # 15% of total cases get embedded scenarios
SCENARIO_EMBEDDING_CASES <- as.integer(TOTAL_CASES * SCENARIO_EMBEDDING_PERCENTAGE)  # 75

# Random Seed Management
BASE_SEED <- 20241106     # Change this for different random generations
WRITER_SEED_OFFSET <- 100  # Writer style assignment seed
SCENARIO_SEED_OFFSET <- 200  # Scenario embedding seed

# Variety Writer Style Parameters (applied to VARIETY_WRITER_CASES)
NEW_CASEWORKER_RATIO <- 0.30      # 30% new worker patterns
EXPERIENCED_WORKER_RATIO <- 0.50   # 50% experienced worker patterns  
SENIOR_WORKER_RATIO <- 0.20        # 20% senior worker patterns

# Validate variety writer ratios add up to 100%
if(abs((NEW_CASEWORKER_RATIO + EXPERIENCED_WORKER_RATIO + SENIOR_WORKER_RATIO) - 1.0) > 0.001) {
  stop("ERROR: Variety writer ratios must add up to 1.0 (100%)")
}

# Quality Variation Parameters (applied to variety writers only)
HIGH_QUALITY_RATIO <- 0.70      # 70% high quality documentation
STANDARD_QUALITY_RATIO <- 0.25   # 25% standard quality documentation
CONCERNING_QUALITY_RATIO <- 0.05 # 5% concerning quality documentation

# Validate quality ratios add up to 100%
if(abs((HIGH_QUALITY_RATIO + STANDARD_QUALITY_RATIO + CONCERNING_QUALITY_RATIO) - 1.0) > 0.001) {
  stop("ERROR: Quality variation ratios must add up to 1.0 (100%)")
}

# Scenario Embedding Distribution (percentages of scenario cases, must add to 100%)
HOUSING_CRISIS_RATIO <- 0.30      # 30% of scenario cases have housing crisis
MENTAL_HEALTH_RATIO <- 0.25       # 25% of scenario cases have mental health deterioration  
SUCCESS_CONNECTION_RATIO <- 0.45   # 45% of scenario cases have successful service connections

# Validate scenario percentages add up to 100%
if(abs((HOUSING_CRISIS_RATIO + MENTAL_HEALTH_RATIO + SUCCESS_CONNECTION_RATIO) - 1.0) > 0.001) {
  stop("ERROR: Scenario embedding ratios must add up to 1.0 (100%)")
}

# Calculate actual case targets from percentages
HOUSING_CRISIS_TARGET <- round(SCENARIO_EMBEDDING_CASES * HOUSING_CRISIS_RATIO)       # ~23 cases
MENTAL_HEALTH_TARGET <- round(SCENARIO_EMBEDDING_CASES * MENTAL_HEALTH_RATIO)         # ~19 cases  
SUCCESS_CONNECTION_TARGET <- SCENARIO_EMBEDDING_CASES - HOUSING_CRISIS_TARGET - MENTAL_HEALTH_TARGET  # ~33 cases

# Complexity Level Distribution (All Lanes)
LEVEL1_STABLE_RATIO <- 0.25      # 25% stable complexity
LEVEL2_MODERATE_RATIO <- 0.45     # 45% moderate complexity  
LEVEL3_HIGH_RATIO <- 0.25         # 25% high complexity
LEVEL4_CRISIS_RATIO <- 0.05       # 5% crisis complexity

# Output Configuration
OUTPUT_PATH <- "./analysis/take-4-vscode/workflow/card30/"
OUTPUT_FILENAME <- "synthetic_cases.csv"

# Display configuration
cat("\n📋 THREE-MODE CONFIGURATION:\n")
cat("   Total Cases:", TOTAL_CASES, "\n")
cat("   Writer Style Distribution:\n")
cat("     - Default Writer:", DEFAULT_WRITER_CASES, "cases (", round(DEFAULT_WRITER_PERCENTAGE*100), "%)\n")
cat("     - Variety Writers:", VARIETY_WRITER_CASES, "cases (", round(VARIETY_WRITER_PERCENTAGE*100), "%)\n") 
cat("   Scenario Embedding (overlay):", SCENARIO_EMBEDDING_CASES, "cases (", round(SCENARIO_EMBEDDING_PERCENTAGE*100), "%)\n")
cat("     - Housing Crisis:", HOUSING_CRISIS_TARGET, "cases (", round(HOUSING_CRISIS_RATIO*100), "% of scenarios)\n")
cat("     - Mental Health:", MENTAL_HEALTH_TARGET, "cases (", round(MENTAL_HEALTH_RATIO*100), "% of scenarios)\n")
cat("     - Success Connections:", SUCCESS_CONNECTION_TARGET, "cases (", round(SUCCESS_CONNECTION_RATIO*100), "% of scenarios)\n")
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

calculate_archetype_distribution <- function(lane_cases) {
  level1_target <- round(lane_cases * LEVEL1_STABLE_RATIO)
  level2_target <- round(lane_cases * LEVEL2_MODERATE_RATIO)
  level3_target <- round(lane_cases * LEVEL3_HIGH_RATIO)
  level4_target <- lane_cases - level1_target - level2_target - level3_target
  
  list(
    A1 = ceiling(level1_target / 3), A2 = ceiling(level1_target / 3), A3 = level1_target - 2*ceiling(level1_target / 3),
    A4 = ceiling(level2_target / 4), A5 = ceiling(level2_target / 4), A6 = ceiling(level2_target / 4), A7 = level2_target - 3*ceiling(level2_target / 4),
    A8 = ceiling(level3_target / 2), A9 = level3_target - ceiling(level3_target / 2),
    A10 = level4_target
  )
}

generate_case_note <- function(archetype_id, complexity_level, writer_style, age, gender, first_name, scenario = "none", quality_level = "high") {
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
  
  # Apply quality variation for variety writers
  if(writer_style %in% c("new_caseworker", "experienced_worker", "senior_worker")) {
    # Variety writer quality variation
    if(quality_level == "concerning") {
      observations <- sample(c(
        "client seemed distracted. brief session.", 
        "Limited engagement noted during session.",
        "Short meeting due to scheduling issues."
      ), 1)
    } else if(quality_level == "standard") {
      observations <- sample(c(
        "Client participated in discussion.",
        "Individual engaged during session.",
        "Person attended scheduled appointment."
      ), 1)
    }
  } else {
    # Default writer - consistent professional standard
    observations <- "Client engaged appropriately during the session and demonstrated understanding of discussed options."
  }
  
  # Apply scenario embedding (can be applied to any writer style)
  if(scenario == "housing_crisis") {
    concerns <- c(concerns, "HOUSING CRISIS: Client facing eviction. Immediate housing intervention required.")
    observations <- "Urgent housing situation requires immediate attention. Client expressed significant stress regarding housing stability."
  } else if(scenario == "mental_health_deterioration") {
    concerns <- c(concerns, "Mental health concerns: missed last three appointments. symptoms began 3 months ago. Clinical review scheduled.")
    observations <- "Notable change in client's mental health presentation. Increased support coordination recommended."
  } else if(scenario == "successful_service_connections") {
    concerns <- c(concerns, "Positive progress: Client actively participating in programming. obtained stable employment. Continuing supportive services.")
    observations <- "Excellent progress demonstrated. Client has successfully engaged with multiple service providers and achieved employment goals."
  }
  
  # Format based on writer style with noise injection patterns
  if(writer_style == "new_caseworker") {
    # New caseworker pattern - detailed but sometimes over-structured
    note <- glue('Date: {current_date}
Client: {first_name}
Session Summary:
1. Presenting concerns: {paste(concerns, collapse=", ")}
2. Services provided: {paste(activities, collapse=", ")}
3. Worker observations: {observations}
4. Next steps planned: {next_steps}')
  } else if(writer_style == "experienced_worker") {
    # Experienced worker pattern - efficient but complete
    note <- glue('{current_date} - {first_name} session. Key issues: {paste(concerns, collapse=", ")}. Interventions: {paste(activities, collapse=", ")}. Assessment: {observations} Action plan: {next_steps}')
  } else if(writer_style == "senior_worker") {
    # Senior worker pattern - concise and strategic
    note <- glue('{current_date}: {first_name}. Issues: {paste(concerns, collapse=", ")}. Interventions: {paste(activities, collapse=", ")}. Notes: {observations} Next: {next_steps}')
  } else {
    # Standard professional baseline pattern
    note <- glue('Date: {current_date} - {first_name} session. Client concerns: {paste(concerns, collapse=", ")}. Services provided: {paste(activities, collapse=", ")}. Assessment: {observations} Plan: {next_steps}')
  }
  
  return(note)
}

cat("✅ Helper functions configured\n")

# ---- three-mode-generation ---------------------------------------------------
cat("\n🎯 Generating three-mode synthetic dataset...\n")

# Set master seed for reproducibility
set.seed(BASE_SEED)

# Calculate overall archetype distribution for all cases
total_distribution <- calculate_archetype_distribution(TOTAL_CASES)

# Generate synthetic dataset with overlapping noise sources
synthetic_dataset <- fabricate(
  N = TOTAL_CASES,
  
  # Generate person identifiers
  person_oid = sprintf("SYN_%05d", 1:N),
  
  # Assign archetypes using overall distribution
  archetype_id = c(
    rep("A1", total_distribution$A1), rep("A2", total_distribution$A2), rep("A3", total_distribution$A3),
    rep("A4", total_distribution$A4), rep("A5", total_distribution$A5), rep("A6", total_distribution$A6),
    rep("A7", total_distribution$A7), rep("A8", total_distribution$A8), rep("A9", total_distribution$A9),
    rep("A10", total_distribution$A10)
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
  last_name = generate_last_name(N)
)

# Apply writer style distribution (overlapping with scenarios)
set.seed(BASE_SEED + WRITER_SEED_OFFSET)

# Create writer style assignments  
writer_styles <- c(
  rep("standard_professional", DEFAULT_WRITER_CASES),  # 375 cases use default writer
  sample(c(rep("new_caseworker", round(VARIETY_WRITER_CASES * NEW_CASEWORKER_RATIO)),
          rep("experienced_worker", round(VARIETY_WRITER_CASES * EXPERIENCED_WORKER_RATIO)),
          rep("senior_worker", VARIETY_WRITER_CASES - round(VARIETY_WRITER_CASES * NEW_CASEWORKER_RATIO) - 
              round(VARIETY_WRITER_CASES * EXPERIENCED_WORKER_RATIO))))  # 125 cases use variety writers
)

# Assign writer styles to dataset
synthetic_dataset$writer_style <- writer_styles

# Create quality levels (only for variety writers)
quality_levels <- rep("high", TOTAL_CASES)  # Default all to high
variety_indices <- which(synthetic_dataset$writer_style %in% c("new_caseworker", "experienced_worker", "senior_worker"))
quality_levels[variety_indices] <- sample(c(rep("high", round(length(variety_indices) * HIGH_QUALITY_RATIO)),
                                           rep("standard", round(length(variety_indices) * STANDARD_QUALITY_RATIO)),
                                           rep("concerning", length(variety_indices) - 
                                               round(length(variety_indices) * HIGH_QUALITY_RATIO) - 
                                               round(length(variety_indices) * STANDARD_QUALITY_RATIO))))

synthetic_dataset$quality_level <- quality_levels

# Apply scenario embedding (overlay on any writer style)
set.seed(BASE_SEED + SCENARIO_SEED_OFFSET)

# Initialize all as no scenario
embedded_scenarios <- rep("none", TOTAL_CASES)

# Randomly select cases for scenario embedding
scenario_indices <- sample(1:TOTAL_CASES, SCENARIO_EMBEDDING_CASES)
scenario_types <- c(rep("housing_crisis", HOUSING_CRISIS_TARGET),
                   rep("mental_health_deterioration", MENTAL_HEALTH_TARGET),
                   rep("successful_service_connections", SUCCESS_CONNECTION_TARGET))
embedded_scenarios[scenario_indices] <- scenario_types

synthetic_dataset$embedded_scenarios <- embedded_scenarios

# Generate case notes using overlapping noise sources
synthetic_dataset$case_note <- mapply(generate_case_note, 
                                    synthetic_dataset$archetype_id, 
                                    synthetic_dataset$complexity_level, 
                                    synthetic_dataset$writer_style,
                                    synthetic_dataset$age, 
                                    synthetic_dataset$gender, 
                                    synthetic_dataset$first_name, 
                                    synthetic_dataset$embedded_scenarios, 
                                    synthetic_dataset$quality_level, 
                                    SIMPLIFY = TRUE)

cat("✅ Three-mode synthetic dataset generated:", nrow(synthetic_dataset), "cases\n")

# ---- validation-and-export ---------------------------------------------------
cat("\n🔍 Performing validation and export...\n")

# Validation checks for overlapping noise sources
complexity_dist <- table(synthetic_dataset$complexity_level)
scenario_dist <- table(synthetic_dataset$embedded_scenarios)
writer_dist <- table(synthetic_dataset$writer_style)
quality_dist <- table(synthetic_dataset$quality_level)

cat("📊 THREE-MODE VALIDATION RESULTS:\n")
cat("   Total cases:", nrow(synthetic_dataset), "(Target:", TOTAL_CASES, ")", ifelse(nrow(synthetic_dataset) == TOTAL_CASES, "✅", "❌"), "\n\n")

cat("   Writer Style Distribution:\n")
for(style in names(writer_dist)) {
  count <- as.numeric(writer_dist[style])
  cat("     -", style, ":", count, "cases (", round(count/TOTAL_CASES*100, 1), "%)\n")
}

cat("\n   Complexity Level Distribution:\n")
for(level in 1:4) {
  count <- as.numeric(complexity_dist[as.character(level)])
  cat("     - Level", level, ":", count, "cases (", round(count/TOTAL_CASES*100, 1), "%)\n")
}

cat("\n   Quality Variation Distribution:\n")
for(quality in names(quality_dist)) {
  count <- as.numeric(quality_dist[quality])
  cat("     -", quality, ":", count, "cases (", round(count/TOTAL_CASES*100, 1), "%)\n")
}

cat("\n   Scenario Embedding Distribution:\n")
for(scenario in names(scenario_dist)) {
  count <- as.numeric(scenario_dist[scenario])
  cat("     -", scenario, ":", count, "cases (", round(count/TOTAL_CASES*100, 1), "%)\n")
}

# Calculate and display overlapping combinations
default_with_scenarios <- sum(synthetic_dataset$writer_style == "standard_professional" & synthetic_dataset$embedded_scenarios != "none")
variety_with_scenarios <- sum(synthetic_dataset$writer_style %in% c("new_caseworker", "experienced_worker", "senior_worker") & synthetic_dataset$embedded_scenarios != "none")

cat("\n   Overlapping Noise Combinations:\n")
cat("     - Default writer + Scenarios:", default_with_scenarios, "cases\n")
cat("     - Variety writer + Scenarios:", variety_with_scenarios, "cases\n")

# Export results
if(!dir.exists(OUTPUT_PATH)) {
  dir.create(OUTPUT_PATH, recursive = TRUE)
}

output_file <- file.path(OUTPUT_PATH, OUTPUT_FILENAME)
readr::write_csv(synthetic_dataset, output_file)

cat("\n✅ THREE-MODE SYNTHETIC CASE NOTE GENERATION COMPLETED SUCCESSFULLY!\n")
cat("📁 Output file:", output_file, "\n")
cat("🎯 Dataset with overlapping noise sources for algorithm validation\n")
cat("🔧 Writer styles, scenario embedding, and quality variation combined\n")

print(sessionInfo())