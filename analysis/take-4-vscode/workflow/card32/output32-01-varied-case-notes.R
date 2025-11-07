#' ---
#' title: "Variation Case Note Writer - Synthetic Stylistic Variation Generator"
#' author: "Card 32 Implementation"
#' date: "Last Updated: `r Sys.Date()`"
#' description: "Generate synthetic case notes with realistic stylistic variation and human inconsistencies in documentation practices"
#' ---
#+ echo=F

# Variation Case Note Writer - Synthetic Stylistic Variation Generator
# Lane 2 of 3-Lane Architecture: Stylistic Variation Generation (25% of total dataset)
#
# This script generates 125 synthetic case notes demonstrating realistic stylistic
# variation and human inconsistencies in documentation practices to test AI algorithms'
# ability to handle inconsistent human documentation styles.
#
# Key Features:
# 1. Experience-based writer styles: New (30%), Experienced (50%), Senior (20%)
# 2. Quality variations: High (70%), Standard (25%), Concerning (5%)
# 3. Documentation inconsistencies with terminology and structural variations
# 4. Deterministic random seed management for reproducible outputs (coordinated)
# 5. Complexity-appropriate note variations with realistic human errors
# 6. ID range: SYN_00301 to SYN_00425 (Lane 2 allocation)
#
# Output: CSV with columns: person_oid,first_name,last_name,gender,age,case_note,
#         complexity_level,archetype_id,writer_style,embedded_scenarios

rm(list = ls(all.names = TRUE)) # Clear memory
cat("\014") # Clear console

cat("🎨 Variation Case Note Writer - Synthetic Stylistic Variation Generator\n")
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
GENERATION_SEED <- 20241306  # Base seed + 200 for Lane 2 coordination
set.seed(GENERATION_SEED)

# Lane 2 cohort size (25% of 500 total cases)
LANE2_COHORT_SIZE <- 125

# ID range for Lane 2 coordination
LANE2_ID_START <- 301
LANE2_ID_END <- 425

# Output configuration
OUTPUT_PATH <- "./analysis/take-4-vscode/workflow/card32/"
OUTPUT_FILENAME <- "varied_cases.csv"

# ---- experience-based-writer-styles ------------------------------------------
cat("👥 Defining experience-based writer styles and quality variations...\n")

# Experience-Based Writer Styles Distribution
EXPERIENCE_STYLES <- list(
  new_caseworker = list(
    quota = 0.30,
    avg_words = c(180, 220, 280, 350),  # Detailed documentation
    characteristics = c("detailed", "formal", "policy_referencing", "uncertain_language"),
    quality_bias = c("high" = 0.5, "standard" = 0.4, "concerning" = 0.1),  # New workers often over-document
    terminology_style = "formal_policy_heavy",
    structure_preference = "chronological_detailed"
  ),
  
  experienced_worker = list(
    quota = 0.50,
    avg_words = c(120, 150, 200, 260),  # Efficient documentation
    characteristics = c("efficient", "solution_oriented", "professional_tone", "confident"),
    quality_bias = c("high" = 0.8, "standard" = 0.2, "concerning" = 0.0),  # Most consistent quality
    terminology_style = "professional_consistent",
    structure_preference = "problem_solution_focused"  
  ),
  
  senior_worker = list(
    quota = 0.20,
    avg_words = c(100, 130, 170, 220),  # Concise documentation
    characteristics = c("concise", "systems_thinking", "advocacy_language", "big_picture"),
    quality_bias = c("high" = 0.9, "standard" = 0.1, "concerning" = 0.0),  # Highest quality
    terminology_style = "systems_advocacy_focused",
    structure_preference = "strategic_systemic"
  )
)

# Quality Variation Specifications
QUALITY_LEVELS <- list(
  high = list(
    quota = 0.70,
    characteristics = c("clear", "objective", "appropriate_detail", "professional"),
    clarity_score = 0.9,
    completeness_score = 0.95
  ),
  
  standard = list(
    quota = 0.25,
    characteristics = c("generally_clear", "minor_inconsistencies", "adequate_detail"),
    clarity_score = 0.7,
    completeness_score = 0.8
  ),
  
  concerning = list(
    quota = 0.05,
    characteristics = c("unclear_language", "missing_information", "subjective_judgments"),
    clarity_score = 0.4,
    completeness_score = 0.6
  )
)

# Validate quotas sum to 1.0
experience_quota_sum <- sum(sapply(EXPERIENCE_STYLES, function(x) x$quota))
quality_quota_sum <- sum(sapply(QUALITY_LEVELS, function(x) x$quota))

if(abs(experience_quota_sum - 1.0) > 0.001) {
  stop("Experience style quotas must sum to 1.0. Current sum: ", experience_quota_sum)
}
if(abs(quality_quota_sum - 1.0) > 0.001) {
  stop("Quality level quotas must sum to 1.0. Current sum: ", quality_quota_sum)
}

cat("✅ Experience-Based Writer Style Distribution:\n")
for(style in names(EXPERIENCE_STYLES)) {
  cat("   -", style, ":", scales::percent(EXPERIENCE_STYLES[[style]]$quota), "\n")
}

cat("✅ Quality Level Distribution:\n")
for(quality in names(QUALITY_LEVELS)) {
  cat("   -", quality, ":", scales::percent(QUALITY_LEVELS[[quality]]$quota), "\n")
}

# ---- terminology-variations --------------------------------------------------
cat("\n📝 Setting up terminology variation patterns...\n")

# Documentation Inconsistency Patterns
TERMINOLOGY_VARIATIONS <- list(
  # Housing-related terms
  housing = list(
    formal = c("residential accommodation", "housing stability", "accommodation needs"),
    standard = c("housing situation", "living arrangements", "housing status"), 
    casual = c("housing challenges", "place to stay", "housing issues"),
    concerning = c("housing stuff", "living situation problems", "place issues")
  ),
  
  # Employment-related terms  
  employment = list(
    formal = c("employment barriers", "vocational rehabilitation", "career development"),
    standard = c("job search support", "employment assistance", "work readiness"),
    casual = c("finding work", "job help", "getting back to work"),
    concerning = c("work stuff", "job problems", "employment issues")
  ),
  
  # Mental health terms
  mental_health = list(
    formal = c("psychological wellbeing", "mental health considerations", "cognitive functioning"),
    standard = c("mental health support", "emotional wellbeing", "mental health needs"),
    casual = c("feeling better", "mental health help", "emotional support"),
    concerning = c("mental health stuff", "feeling issues", "head space problems")
  ),
  
  # Substance use terms
  substance_use = list(
    formal = c("substance use considerations", "addiction recovery support", "substance use disorder"),
    standard = c("substance use issues", "addiction support", "recovery assistance"),
    casual = c("getting clean", "staying sober", "addiction help"),
    concerning = c("drinking problems", "drug stuff", "substance issues")
  )
)

# Structural variation patterns
STRUCTURE_PATTERNS <- list(
  chronological_detailed = function(concerns, activities, observations, next_steps, client_name, date) {
    paste0("Date: ", date, "\n",
           "Client: ", client_name, "\n",
           "Session Summary:\n",
           "1. Presenting concerns: ", concerns, "\n",
           "2. Services provided: ", activities, "\n", 
           "3. Worker observations: ", observations, "\n",
           "4. Next steps planned: ", next_steps)
  },
  
  problem_solution_focused = function(concerns, activities, observations, next_steps, client_name, date) {
    paste0(date, " - ", client_name, " session. ",
           "Key issues: ", concerns, ". ",
           "Interventions: ", activities, ". ",
           "Assessment: ", observations, ". ",
           "Action plan: ", next_steps, ".")
  },
  
  strategic_systemic = function(concerns, activities, observations, next_steps, client_name, date) {
    paste0(client_name, " (", date, "): Systems review indicates ", concerns, 
           ". Coordinated ", activities, ". ",
           "Systemic factors: ", observations, ". ",
           "Strategic next steps: ", next_steps, ".")
  }
)

# ---- archetype-specifications-adapted ---------------------------------------
cat("\n📊 Adapting client archetype specifications for 125-case cohort...\n")

# Client Archetypes adapted for Lane 2 (125 cases)
# Maintaining proportional complexity distribution
CLIENT_ARCHETYPES <- list(
  
  # LEVEL 1: STABLE (25% of 125 = 31 profiles)
  A1 = list(
    name = "Employment Ready Adults",
    complexity_level = 1,
    count = 10,  # Reduced from 25 for smaller cohort
    demographics = list(age_range = c(25, 45), gender_dist = c("M" = 0.6, "F" = 0.4)),
    risk_factors = list(
      employment_barriers = 0.3,
      housing_instability = 0.1,
      mental_health = 0.2,
      substance_use = 0.1,
      medical_complexity = 0.1,
      dependent_care = 0.2
    ),
    service_patterns = c("employment_counseling", "skills_assessment", "job_search_support")
  ),
  
  A2 = list(
    name = "Seasonal Workers",
    complexity_level = 1,
    count = 11,
    demographics = list(age_range = c(20, 50), gender_dist = c("M" = 0.75, "F" = 0.25)),
    risk_factors = list(
      employment_barriers = 0.4,
      housing_instability = 0.2,
      mental_health = 0.1,
      substance_use = 0.2,
      medical_complexity = 0.1,
      dependent_care = 0.3
    ),
    service_patterns = c("seasonal_employment", "trades_training", "transportation_support")
  ),
  
  A3 = list(
    name = "Mid-Career Transitions",
    complexity_level = 1,
    count = 10,
    demographics = list(age_range = c(35, 55), gender_dist = c("M" = 0.5, "F" = 0.5)),
    risk_factors = list(
      employment_barriers = 0.5,
      housing_instability = 0.1,
      mental_health = 0.3,
      substance_use = 0.1,
      medical_complexity = 0.2,
      dependent_care = 0.4
    ),
    service_patterns = c("career_transition", "benefit_navigation", "health_coordination")
  ),
  
  # LEVEL 2: MODERATE (45% of 125 = 56 profiles)
  A4 = list(
    name = "Single Parents",
    complexity_level = 2,
    count = 18,  # Largest group in moderate complexity
    demographics = list(age_range = c(22, 40), gender_dist = c("M" = 0.15, "F" = 0.85)),
    risk_factors = list(
      employment_barriers = 0.6,
      housing_instability = 0.4,
      mental_health = 0.4,
      substance_use = 0.2,
      medical_complexity = 0.2,
      dependent_care = 0.9
    ),
    service_patterns = c("housing_search", "childcare_coordination", "income_support", "parenting_resources")
  ),
  
  A5 = list(
    name = "Health-Related Barriers",
    complexity_level = 2,
    count = 14,
    demographics = list(age_range = c(30, 60), gender_dist = c("M" = 0.45, "F" = 0.55)),
    risk_factors = list(
      employment_barriers = 0.7,
      housing_instability = 0.3,
      mental_health = 0.5,
      substance_use = 0.2,
      medical_complexity = 0.8,
      dependent_care = 0.3
    ),
    service_patterns = c("medical_coordination", "disability_benefits", "accommodation_planning", "retraining")
  ),
  
  A6 = list(
    name = "Recovery and Reintegration",
    complexity_level = 2,
    count = 12,
    demographics = list(age_range = c(25, 50), gender_dist = c("M" = 0.65, "F" = 0.35)),
    risk_factors = list(
      employment_barriers = 0.8,
      housing_instability = 0.6,
      mental_health = 0.7,
      substance_use = 0.9,
      medical_complexity = 0.4,
      dependent_care = 0.2
    ),
    service_patterns = c("recovery_program", "mental_health_support", "structured_housing", "life_skills")
  ),
  
  A7 = list(
    name = "Family Caregivers",
    complexity_level = 2,
    count = 12,
    demographics = list(age_range = c(40, 65), gender_dist = c("M" = 0.3, "F" = 0.7)),
    risk_factors = list(
      employment_barriers = 0.5,
      housing_instability = 0.2,
      mental_health = 0.6,
      substance_use = 0.1,
      medical_complexity = 0.3,
      dependent_care = 0.8
    ),
    service_patterns = c("respite_care", "transportation", "multi_service_coordination", "caregiver_support")
  ),
  
  # LEVEL 3: HIGH (25% of 125 = 31 profiles)
  A8 = list(
    name = "Multi-Barrier Complex",
    complexity_level = 3,
    count = 16,
    demographics = list(age_range = c(25, 55), gender_dist = c("M" = 0.6, "F" = 0.4)),
    risk_factors = list(
      employment_barriers = 0.9,
      housing_instability = 0.8,
      mental_health = 0.8,
      substance_use = 0.7,
      medical_complexity = 0.5,
      dependent_care = 0.4
    ),
    service_patterns = c("crisis_intervention", "intensive_case_management", "multi_agency_coordination", "harm_reduction")
  ),
  
  A9 = list(
    name = "Complex Medical and Social",
    complexity_level = 3,
    count = 15,
    demographics = list(age_range = c(35, 70), gender_dist = c("M" = 0.5, "F" = 0.5)),
    risk_factors = list(
      employment_barriers = 0.8,
      housing_instability = 0.6,
      mental_health = 0.9,
      substance_use = 0.4,
      medical_complexity = 0.9,
      dependent_care = 0.5
    ),
    service_patterns = c("medical_case_management", "mental_health_intensive", "benefit_advocacy", "functional_support")
  ),
  
  # LEVEL 4: CRISIS (5% of 125 = 6 profiles)
  A10 = list(
    name = "Crisis Multi-System",
    complexity_level = 4,
    count = 7,  # Rounded up to ensure total = 125
    demographics = list(age_range = c(20, 60), gender_dist = c("M" = 0.6, "F" = 0.4)),
    risk_factors = list(
      employment_barriers = 0.95,
      housing_instability = 0.9,
      mental_health = 0.9,
      substance_use = 0.8,
      medical_complexity = 0.7,
      dependent_care = 0.3,
      criminal_history = 0.6
    ),
    service_patterns = c("crisis_stabilization", "multi_system_coordination", "intensive_supervision", "emergency_supports")
  )
)

# Validate archetype counts sum to total cohort size
total_archetype_count <- sum(sapply(CLIENT_ARCHETYPES, function(x) x$count))
if(total_archetype_count != LANE2_COHORT_SIZE) {
  stop("Archetype counts must sum to ", LANE2_COHORT_SIZE, ". Current sum: ", total_archetype_count)
}

cat("✅ Client Archetype Distribution (125 cases):\n")
for(archetype in names(CLIENT_ARCHETYPES)) {
  arch_data <- CLIENT_ARCHETYPES[[archetype]]
  cat("   -", archetype, ":", arch_data$name, "(", arch_data$count, "profiles,", 
      "Level", arch_data$complexity_level, ")\n")
}

# ---- helper-functions --------------------------------------------------------
cat("\n🔧 Setting up variation-focused helper functions...\n")

# Generate realistic first names (same as Card 31)
generate_first_name <- function(gender, n = 1) {
  female_names <- c("Sarah", "Jennifer", "Jessica", "Ashley", "Amanda", "Melissa", "Nicole", 
                   "Michelle", "Kimberly", "Lisa", "Angela", "Heather", "Stephanie", "Marie")
  
  male_names <- c("Michael", "Christopher", "Jason", "David", "James", "Robert", "John",
                 "Matthew", "Daniel", "Mark", "Kevin", "Brian", "Kenneth", "Anthony")
  
  other_names <- c("Alex", "Jordan", "Casey", "Taylor", "Morgan", "Jamie", "Avery", "Riley")
  
  result <- character(n)
  for(i in 1:n) {
    if(gender[i] == "F") {
      result[i] <- sample(female_names, 1)
    } else if(gender[i] == "M") {
      result[i] <- sample(male_names, 1)
    } else {
      result[i] <- sample(other_names, 1)
    }
  }
  return(result)
}

# Generate realistic last names (same as Card 31)
generate_last_name <- function(n = 1) {
  surnames <- c("Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis",
               "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson",
               "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White")
  
  return(sample(surnames, n, replace = TRUE))
}

# Assign experience-based writer style
assign_experience_style <- function(n) {
  styles <- names(EXPERIENCE_STYLES)
  probabilities <- sapply(EXPERIENCE_STYLES, function(x) x$quota)
  return(sample(styles, n, replace = TRUE, prob = probabilities))
}

# Assign quality level based on experience style
assign_quality_level <- function(experience_styles) {
  quality_levels <- character(length(experience_styles))
  
  for(i in 1:length(experience_styles)) {
    style <- experience_styles[i]
    quality_probs <- EXPERIENCE_STYLES[[style]]$quality_bias
    quality_levels[i] <- sample(names(quality_probs), 1, prob = quality_probs)
  }
  
  return(quality_levels)
}

# Get terminology based on experience and quality
get_terminology <- function(concept, experience_style, quality_level) {
  if(!concept %in% names(TERMINOLOGY_VARIATIONS)) {
    return("standard terminology")
  }
  
  variations <- TERMINOLOGY_VARIATIONS[[concept]]
  
  # Map experience and quality to terminology style
  if(experience_style == "new_caseworker") {
    if(quality_level == "high") {
      terms <- variations$formal
    } else if(quality_level == "standard") {
      terms <- variations$standard  
    } else {
      terms <- variations$concerning
    }
  } else if(experience_style == "experienced_worker") {
    terms <- variations$standard
  } else { # senior_worker
    if(quality_level == "concerning") {
      terms <- variations$casual  # Even seniors can be casual
    } else {
      terms <- variations$formal
    }
  }
  
  return(sample(terms, 1))
}

# Generate varied case note with inconsistencies
generate_varied_case_note <- function(archetype_id, complexity_level, experience_style, quality_level, 
                                    age, gender, first_name) {
  
  archetype_data <- CLIENT_ARCHETYPES[[archetype_id]]
  style_data <- EXPERIENCE_STYLES[[experience_style]]
  quality_data <- QUALITY_LEVELS[[quality_level]]
  
  # Get target word count adjusted for experience and quality
  base_words <- style_data$avg_words[complexity_level]
  quality_modifier <- quality_data$completeness_score
  target_words <- round(base_words * quality_modifier)
  
  # Generate base components with terminology variations
  client_concerns <- generate_varied_concerns(archetype_data, complexity_level, experience_style, quality_level)
  service_activities <- generate_varied_activities(archetype_data, complexity_level, experience_style, quality_level)
  caseworker_observations <- generate_varied_observations(archetype_data, experience_style, quality_level, age, gender)
  next_steps <- generate_varied_next_steps(archetype_data, complexity_level, experience_style, quality_level)
  
  # Apply structural variation based on experience style
  current_date <- format(Sys.Date() - sample(1:90, 1), "%Y-%m-%d")
  structure_func <- STRUCTURE_PATTERNS[[style_data$structure_preference]]
  
  case_note <- structure_func(client_concerns, service_activities, caseworker_observations, 
                             next_steps, first_name, current_date)
  
  # Apply quality-based modifications
  case_note <- apply_quality_variations(case_note, quality_level, experience_style)
  
  return(case_note)
}

# Generate concerns with terminology variations
generate_varied_concerns <- function(archetype_data, complexity_level, experience_style, quality_level) {
  
  base_concerns <- c()
  
  # Employment concerns with variation
  if(archetype_data$risk_factors$employment_barriers > 0.5) {
    employment_term <- get_terminology("employment", experience_style, quality_level)
    base_concerns <- c(base_concerns, paste("Reports", employment_term))
  }
  
  # Housing concerns with variation  
  if(archetype_data$risk_factors$housing_instability > 0.3) {
    housing_term <- get_terminology("housing", experience_style, quality_level)
    base_concerns <- c(base_concerns, paste("Experiencing", housing_term))
  }
  
  # Mental health concerns with variation
  if(archetype_data$risk_factors$mental_health > 0.3) {
    mh_term <- get_terminology("mental_health", experience_style, quality_level)
    base_concerns <- c(base_concerns, paste("Indicates need for", mh_term))
  }
  
  # Substance use concerns with variation
  if(!is.null(archetype_data$risk_factors$substance_use) && archetype_data$risk_factors$substance_use > 0.3) {
    substance_term <- get_terminology("substance_use", experience_style, quality_level)
    base_concerns <- c(base_concerns, paste("Addressing", substance_term))
  }
  
  # Ensure at least one concern
  if(length(base_concerns) == 0) {
    base_concerns <- c("General support needs identified")
  }
  
  return(paste(base_concerns, collapse = "; "))
}

# Generate activities with experience-based variations
generate_varied_activities <- function(archetype_data, complexity_level, experience_style, quality_level) {
  
  activities_by_experience <- list(
    new_caseworker = list(
      `1` = c("completed comprehensive intake assessment", "reviewed eligibility criteria thoroughly", 
              "documented all presenting concerns in detail", "consulted with supervisor regarding case plan"),
      `2` = c("coordinated multi-service referrals as per policy guidelines", "conducted thorough risk assessment",
              "documented safety planning protocol", "scheduled follow-up appointments per case management standards"),
      `3` = c("implemented intensive case management protocol", "completed comprehensive psychosocial assessment",
              "coordinated crisis intervention services", "documented all interventions per agency policy"),
      `4` = c("activated emergency response protocol", "completed mandatory risk assessment documentation",
              "coordinated immediate safety interventions", "consulted with crisis team per emergency procedures")
    ),
    
    experienced_worker = list(
      `1` = c("assessed service needs", "connected to employment supports", "reviewed benefit options", "set action goals"),
      `2` = c("coordinated housing search", "arranged childcare support", "connected to mental health services", "updated service plan"),
      `3` = c("intensive case coordination", "crisis intervention support", "multi-agency planning", "harm reduction strategies"),
      `4` = c("emergency stabilization", "crisis team coordination", "immediate safety planning", "intensive monitoring")
    ),
    
    senior_worker = list(
      `1` = c("systems navigation support", "advocacy for service access", "strengths-based planning", "resource coordination"),
      `2` = c("multi-system advocacy", "barrier removal strategies", "service integration", "systems coordination"),
      `3` = c("complex systems coordination", "multi-agency advocacy", "systemic barrier analysis", "integrated service planning"),
      `4` = c("systems crisis response", "multi-level advocacy", "emergency systems coordination", "crisis systems integration")
    )
  )
  
  level_activities <- activities_by_experience[[experience_style]][[as.character(complexity_level)]]
  selected_activities <- sample(level_activities, min(complexity_level + 1, length(level_activities)))
  
  return(paste(selected_activities, collapse = "; "))
}

# Generate observations with experience and quality variations
generate_varied_observations <- function(archetype_data, experience_style, quality_level, age, gender) {
  
  observation_patterns <- list(
    new_caseworker = list(
      high = c("Client demonstrates strong engagement in the service planning process",
               "Presenting concerns appear to be multifaceted and will require comprehensive intervention",
               "Client exhibits resilience factors that can be leveraged in service delivery"),
      standard = c("Client seems motivated to engage with services", 
                   "Some barriers to service engagement were noted",
                   "Client appears to have some strengths to build upon"),
      concerning = c("Client was cooperative during the meeting",
                     "Some issues were discussed",
                     "Will continue to monitor situation")
    ),
    
    experienced_worker = list(
      high = c("Strong therapeutic rapport established; client ready for goal-directed work",
               "Multiple stressors present but client shows good insight and problem-solving capacity",
               "Effective use of community resources; good prognosis for goal achievement"),
      standard = c("Client engaged well in session; some ambivalence about change noted",
                   "Barriers present but client shows motivation to address them",
                   "Good working relationship developing; continued support needed"),
      concerning = c("Client engagement varies; will continue building rapport",
                     "Some challenges noted; ongoing assessment needed",
                     "Progress slow but client continues to attend appointments")
    ),
    
    senior_worker = list(
      high = c("Systemic barriers significantly impact this family's stability; advocacy priorities identified",
               "Client demonstrates remarkable resilience despite complex structural challenges",
               "Service gaps in community resources creating unnecessary hardship; systems advocacy required"),
      standard = c("Complex case requiring systems coordination; client strengths evident",
                   "Multiple system involvement; client navigating well given circumstances",
                   "Systemic issues present; client advocacy needs identified"),
      concerning = c("Complex case; ongoing systems work needed",
                     "Multiple issues present; continued support required",
                     "Systems involvement continues; monitoring progress")
    )
  )
  
  observations <- observation_patterns[[experience_style]][[quality_level]]
  return(sample(observations, 1))
}

# Generate next steps with experience variations
generate_varied_next_steps <- function(archetype_data, complexity_level, experience_style, quality_level) {
  
  next_steps_by_experience <- list(
    new_caseworker = list(
      `1` = c("Schedule follow-up appointment within two weeks as per case management protocol",
              "Complete referral documentation for employment services per agency guidelines",
              "Review case with supervisor at next scheduled supervision meeting"),
      `2` = c("Coordinate service plan meeting with all involved agencies within 30 days",
              "Complete comprehensive assessment documentation per policy requirements", 
              "Schedule crisis safety plan review appointment within one week"),
      `3` = c("Implement intensive case management protocol with weekly contact schedule",
              "Complete crisis intervention documentation and submit to supervisor for review",
              "Coordinate multi-disciplinary team meeting within 48 hours per policy"),
      `4` = c("Activate emergency response protocol and notify supervisor immediately",
              "Complete mandatory safety assessment documentation within 24 hours",
              "Schedule emergency multi-disciplinary team meeting per crisis protocols")
    ),
    
    experienced_worker = list(
      `1` = c("Follow up in 2 weeks to review progress on employment goals",
              "Connect to community resources for ongoing support",
              "Review and adjust service plan as needed"),
      `2` = c("Weekly check-ins for next month to monitor housing search progress",
              "Coordinate with mental health services for integrated support",
              "Update safety plan as circumstances change"),
      `3` = c("Intensive weekly contact for crisis stabilization",
              "Multi-agency case conference within one week",
              "Daily check-ins during acute phase of intervention"),
      `4` = c("Immediate crisis team activation and daily contact",
              "Emergency service coordination meeting tomorrow",
              "24-hour safety monitoring until stabilized")
    ),
    
    senior_worker = list(
      `1` = c("Systems advocacy to address service barriers",
              "Collaborate with community partners for resource development",
              "Monthly progress review with focus on systems navigation"),
      `2` = c("Multi-system advocacy meeting to address service gaps",
              "Coordinate with policy team regarding systemic barriers",
              "Bi-weekly systems coordination check-ins"),
      `3` = c("Intensive systems advocacy to address multiple service gaps",
              "Emergency multi-agency coordination to prevent crisis escalation",
              "Weekly high-level systems meetings until stabilized"),
      `4` = c("Immediate systems crisis response with senior management involvement",
              "Emergency multi-level advocacy to address systemic failures",
              "Daily high-level coordination until crisis resolved")
    )
  )
  
  level_steps <- next_steps_by_experience[[experience_style]][[as.character(complexity_level)]]
  selected_step <- sample(level_steps, 1)
  
  return(selected_step)
}

# Apply quality-based modifications to final note
apply_quality_variations <- function(case_note, quality_level, experience_style) {
  
  if(quality_level == "concerning") {
    # Add concerning quality issues
    modifications <- c(
      # Remove some detail
      function(note) gsub("comprehensive|thorough|detailed", "", note),
      # Add vague language
      function(note) gsub("will|plan to", "might|could", note),
      # Add typos or informal language
      function(note) gsub("coordination", "coordiation", note),
      function(note) gsub("assessment", "assesment", note)
    )
    
    # Apply 1-2 random modifications
    selected_mods <- sample(modifications, sample(1:2, 1))
    for(mod in selected_mods) {
      case_note <- mod(case_note)
    }
  } else if(quality_level == "standard") {
    # Add minor inconsistencies
    if(runif(1) < 0.3) {
      case_note <- gsub("\\.", ". ", case_note)  # Inconsistent spacing
    }
    if(runif(1) < 0.2) {
      case_note <- gsub("Client", "client", case_note)  # Inconsistent capitalization
    }
  }
  
  return(case_note)
}

# ---- generate-synthetic-data -------------------------------------------------
cat("\n🎯 Generating synthetic variation-focused case note data using fabricatr...\n")

# Create the main synthetic dataset using fabricatr
synthetic_cases <- fabricate(
  N = LANE2_COHORT_SIZE,
  
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
  )[sample(LANE2_COHORT_SIZE)],  # Shuffle to randomize order
  
  # Generate person identifiers for Lane 2 range
  person_oid = sprintf("SYN_%05d", (LANE2_ID_START:LANE2_ID_END)),
  
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
  
  # Assign experience-based writer styles and quality levels
  writer_style = assign_experience_style(N),
  quality_level = assign_quality_level(writer_style),
  
  # Generate embedded scenarios (Lane 2: Stylistic variation only - NO embedded scenarios)
  embedded_scenarios = rep("none", LANE2_COHORT_SIZE),
  
  # Generate varied case notes with realistic inconsistencies
  case_note = mapply(generate_varied_case_note, archetype_id, complexity_level, writer_style, 
                    quality_level, age, gender, first_name, SIMPLIFY = TRUE)
)

cat("✅ Synthetic variation data generation completed!\n")

# ---- data-validation ---------------------------------------------------------
cat("\n🔍 Performing data validation checks...\n")

# Validate archetype distribution
archetype_counts <- table(synthetic_cases$archetype_id)
cat("📊 Archetype Distribution Validation:\n")
for(archetype in names(CLIENT_ARCHETYPES)) {
  expected <- CLIENT_ARCHETYPES[[archetype]]$count
  actual <- as.numeric(archetype_counts[archetype])
  if(is.na(actual)) actual <- 0
  cat("   -", archetype, ": Expected", expected, ", Actual", actual, 
      ifelse(actual == expected, "✅", "❌"), "\n")
}

# Validate experience style distribution
experience_counts <- table(synthetic_cases$writer_style)
cat("\n📊 Experience Style Distribution Validation:\n")
for(style in names(EXPERIENCE_STYLES)) {
  expected <- round(EXPERIENCE_STYLES[[style]]$quota * LANE2_COHORT_SIZE)
  actual <- as.numeric(experience_counts[style])
  if(is.na(actual)) actual <- 0
  tolerance <- abs(actual - expected) <= 2  # Allow small deviation due to randomization
  cat("   -", style, ": Expected ~", expected, ", Actual", actual, 
      ifelse(tolerance, "✅", "❌"), "\n")
}

# Validate quality level distribution
quality_counts <- table(synthetic_cases$quality_level)
cat("\n📊 Quality Level Distribution Validation:\n")
for(quality in names(QUALITY_LEVELS)) {
  expected <- round(QUALITY_LEVELS[[quality]]$quota * LANE2_COHORT_SIZE)
  actual <- as.numeric(quality_counts[quality])
  if(is.na(actual)) actual <- 0  
  tolerance <- abs(actual - expected) <= 3
  cat("   -", quality, ": Expected ~", expected, ", Actual", actual,
      ifelse(tolerance, "✅", "❌"), "\n")
}

# Validate complexity level distribution
complexity_counts <- table(synthetic_cases$complexity_level)
expected_complexity <- c(`1` = 31, `2` = 56, `3` = 31, `4` = 7)
cat("\n📊 Complexity Level Distribution Validation:\n")
for(level in 1:4) {
  expected <- expected_complexity[as.character(level)]
  actual <- as.numeric(complexity_counts[as.character(level)])
  if(is.na(actual)) actual <- 0
  tolerance <- abs(actual - expected) <= 2
  cat("   - Level", level, ": Expected ~", expected, ", Actual", actual,
      ifelse(tolerance, "✅", "❌"), "\n")
}

# Validate case note quality
cat("\n📊 Case Note Quality Validation:\n")
note_lengths <- nchar(synthetic_cases$case_note)
cat("   - Average note length:", round(mean(note_lengths)), "characters\n")
cat("   - Note length range:", min(note_lengths), "-", max(note_lengths), "characters\n")

# Check for empty or suspicious notes
empty_notes <- sum(nchar(synthetic_cases$case_note) < 50)
cat("   - Notes under 50 characters:", empty_notes, ifelse(empty_notes == 0, "✅", "❌"), "\n")

# Validate ID range
id_range_check <- all(grepl("^SYN_00[3-4][0-9][0-9]$", synthetic_cases$person_oid))
cat("   - ID range (SYN_00301-SYN_00425):", ifelse(id_range_check, "✅", "❌"), "\n")

# ---- export-results ----------------------------------------------------------
cat("\n💾 Exporting synthetic variation case note data...\n")

# Create output directory if it doesn't exist
if(!dir.exists(OUTPUT_PATH)) {
  dir.create(OUTPUT_PATH, recursive = TRUE)
  cat("Created output directory:", OUTPUT_PATH, "\n")
}

# Prepare final dataset for export (remove quality_level as it's internal)
export_data <- synthetic_cases %>%
  select(person_oid, first_name, last_name, gender, age, complexity_level, 
         archetype_id, writer_style, embedded_scenarios, case_note)

# Export to CSV
output_file <- file.path(OUTPUT_PATH, OUTPUT_FILENAME)
readr::write_csv(export_data, output_file)

cat("✅ Data exported successfully to:", output_file, "\n")

# ---- generation-summary ------------------------------------------------------
cat("\n📋 Synthetic Variation Case Note Generation Summary\n")
cat("==================================================\n")
cat("🎯 Generation Parameters:\n")
cat("   - Random Seed:", GENERATION_SEED, "\n")
cat("   - Total Cases:", LANE2_COHORT_SIZE, "\n")
cat("   - ID Range: SYN_00301 to SYN_00425\n")
cat("   - Archetypes:", length(CLIENT_ARCHETYPES), "(A1-A10)\n")
cat("   - Experience Styles:", length(EXPERIENCE_STYLES), "\n")
cat("   - Quality Levels:", length(QUALITY_LEVELS), "\n")
cat("   - Complexity Levels: 4 (Stable, Moderate, High, Crisis)\n")

cat("\n📊 Final Experience Style Distribution:\n")
for(style in names(EXPERIENCE_STYLES)) {
  actual_count <- sum(synthetic_cases$writer_style == style)
  cat("   -", style, ":", actual_count, "(", 
      scales::percent(actual_count/LANE2_COHORT_SIZE), ")\n")
}

cat("\n📊 Final Quality Level Distribution:\n")
for(quality in names(QUALITY_LEVELS)) {
  actual_count <- sum(synthetic_cases$quality_level == quality)
  cat("   -", quality, ":", actual_count, "(", 
      scales::percent(actual_count/LANE2_COHORT_SIZE), ")\n")
}

cat("\n📊 Final Complexity Distribution:\n")
cat("   - Level 1 (Stable):", sum(synthetic_cases$complexity_level == 1), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 1)/LANE2_COHORT_SIZE), ")\n")
cat("   - Level 2 (Moderate):", sum(synthetic_cases$complexity_level == 2), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 2)/LANE2_COHORT_SIZE), ")\n")
cat("   - Level 3 (High):", sum(synthetic_cases$complexity_level == 3), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 3)/LANE2_COHORT_SIZE), ")\n")
cat("   - Level 4 (Crisis):", sum(synthetic_cases$complexity_level == 4), "(", 
    scales::percent(sum(synthetic_cases$complexity_level == 4)/LANE2_COHORT_SIZE), ")\n")

cat("\n🎯 Stylistic Variation Features:\n")
cat("   - Experience-based documentation styles with realistic inconsistencies\n")
cat("   - Quality variations reflecting real-world documentation challenges\n") 
cat("   - Terminology variations for same concepts across experience levels\n")
cat("   - Structural organization differences based on worker experience\n")
cat("   - Human error patterns and inconsistencies embedded\n")

cat("\n📁 Output Files:\n")
cat("   - CSV Dataset:", output_file, "\n")
cat("   - Schema: person_oid, first_name, last_name, gender, age, complexity_level,\n")
cat("            archetype_id, writer_style, embedded_scenarios, case_note\n")

cat("\n✅ Synthetic variation case note generation completed successfully!\n")
cat("🚀 Data ready for AI algorithm testing and validation workflows.\n")
cat("🎨 Focus: Realistic stylistic variation and human documentation inconsistencies.\n")

# ---- session-info -----------------------------------------------------------
cat("\n📋 Session Information:\n")
print(sessionInfo())