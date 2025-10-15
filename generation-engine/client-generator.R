# Synthetic Client Profile Generator
# ===============================================================================
# Core R script for generating realistic but fictional social services client
# profiles based on expert-authored YAML specifications
# 
# Author: GitHub Copilot (with SDA domain expert guidance)
# Created: 2025-10-15
# Purpose: Generate diverse client demographics and risk factor profiles for
#          synthetic case note testing and SDA algorithm validation
# ===============================================================================

library(yaml)
library(dplyr)
library(purrr)
library(lubridate)
library(stringr)

# ===============================================================================
# CONFIGURATION LOADING FUNCTIONS
# ===============================================================================

#' Load Client Profile Specifications
#' @param spec_file Path to YAML specification file
#' @return List containing client archetype specifications
load_client_specifications <- function(spec_file = "./input-specifications/client-profiles.yml") {
  if (!file.exists(spec_file)) {
    stop("Client profile specifications not found: ", spec_file)
  }
  yaml::read_yaml(spec_file)
}

#' Load Project Scenario Requirements
#' @param scenario_file Path to project scenario YAML file
#' @return List containing project-specific requirements
load_scenario_requirements <- function(scenario_file) {
  if (!file.exists(scenario_file)) {
    stop("Scenario file not found: ", scenario_file)
  }
  yaml::read_yaml(scenario_file)
}

# ===============================================================================
# CLIENT PROFILE GENERATION FUNCTIONS
# ===============================================================================

#' Generate Synthetic Client Population
#' @param n_clients Number of clients to generate
#' @param spec_file Path to client specifications YAML
#' @param scenario_file Optional path to project scenario file
#' @param seed Random seed for reproducibility
#' @return Data frame of synthetic client profiles
generate_client_population <- function(
  n_clients = 100,
  spec_file = "./input-specifications/client-profiles.yml", 
  scenario_file = NULL,
  seed = 12345
) {
  set.seed(seed)
  
  # Load specifications
  specs <- load_client_specifications(spec_file)
  
  # Load scenario requirements if provided
  scenario <- NULL
  if (!is.null(scenario_file)) {
    scenario <- load_scenario_requirements(scenario_file)
  }
  
  # Determine archetype distribution
  distribution <- specs$population_distribution
  if (!is.null(scenario$population_parameters$archetype_override)) {
    distribution <- scenario$population_parameters$archetype_override
  }
  
  # Generate archetype assignments
  archetype_names <- names(distribution)
  archetype_probs <- unlist(distribution)
  client_archetypes <- sample(
    archetype_names, 
    n_clients, 
    replace = TRUE, 
    prob = archetype_probs
  )
  
  # Generate individual client profiles
  clients <- map_dfr(1:n_clients, ~{
    generate_single_client(
      client_id = .x,
      archetype = client_archetypes[.x],
      specs = specs,
      scenario = scenario
    )
  })
  
  return(clients)
}

#' Generate Single Client Profile
#' @param client_id Unique identifier for client
#' @param archetype Client archetype name
#' @param specs Loaded client specifications
#' @param scenario Optional scenario requirements
#' @return Single-row data frame with client profile
generate_single_client <- function(client_id, archetype, specs, scenario = NULL) {
  
  archetype_spec <- specs$client_archetypes[[archetype]]
  
  # Generate basic demographics
  demographics <- generate_demographics(archetype_spec$demographics)
  
  # Generate risk factors
  risk_factors <- generate_risk_factors(archetype_spec$risk_factors)
  
  # Generate service characteristics
  service_info <- generate_service_characteristics(archetype_spec$service_characteristics)
  
  # Combine all information
  client_profile <- data.frame(
    client_id = sprintf("SYNTH_%05d", client_id),
    archetype = archetype,
    stringsAsFactors = FALSE
  ) %>%
    bind_cols(demographics) %>%
    bind_cols(risk_factors) %>%
    bind_cols(service_info)
  
  return(client_profile)
}

#' Generate Demographic Characteristics
#' @param demo_spec Demographic specifications from archetype
#' @return Data frame with demographic variables
generate_demographics <- function(demo_spec) {
  
  # Generate age
  age <- sample(demo_spec$age_range[1]:demo_spec$age_range[2], 1)
  
  # Generate education level
  education_options <- names(demo_spec$education_level)
  education_probs <- unlist(demo_spec$education_level)
  education <- sample(education_options, 1, prob = education_probs)
  
  # Generate family composition
  family_options <- names(demo_spec$family_composition)
  family_probs <- unlist(demo_spec$family_composition)
  family_composition <- sample(family_options, 1, prob = family_probs)
  
  # Generate geographic location
  geo_options <- names(demo_spec$geographic_distribution)
  geo_probs <- unlist(demo_spec$geographic_distribution)
  location_type <- sample(geo_options, 1, prob = geo_probs)
  
  # Generate specific location based on type
  location <- generate_fictional_location(location_type)
  
  # Generate fictional name
  name_info <- generate_fictional_name()
  
  return(data.frame(
    age = age,
    education_level = education,
    family_composition = family_composition,
    location_type = location_type,
    location = location,
    first_name = name_info$first_name,
    last_name = name_info$last_name,
    gender = name_info$gender,
    stringsAsFactors = FALSE
  ))
}

#' Generate Risk Factor Profile
#' @param risk_spec Risk factor specifications from archetype
#' @return Data frame with risk factor indicators
generate_risk_factors <- function(risk_spec) {
  
  risk_factors <- data.frame(
    housing_instability = rbinom(1, 1, risk_spec$housing_instability),
    substance_use = rbinom(1, 1, risk_spec$substance_use),
    mental_health_challenges = rbinom(1, 1, risk_spec$mental_health_challenges),
    criminal_history = rbinom(1, 1, risk_spec$criminal_history),
    recent_hospital_stays = rbinom(1, 1, risk_spec$recent_hospital_stays),
    has_dependents = rbinom(1, 1, risk_spec$has_dependents),
    transportation_barriers = rbinom(1, 1, risk_spec$transportation_barriers %||% 0),
    debt_or_financial_crisis = rbinom(1, 1, risk_spec$debt_or_financial_crisis %||% 0),
    domestic_violence_history = rbinom(1, 1, risk_spec$domestic_violence_history %||% 0),
    social_isolation = rbinom(1, 1, risk_spec$social_isolation %||% 0),
    health_deterioration = rbinom(1, 1, risk_spec$health_deterioration %||% 0),
    stringsAsFactors = FALSE
  )
  
  # Apply realistic co-occurrence patterns
  risk_factors <- apply_risk_cooccurrence(risk_factors)
  
  return(risk_factors)
}

#' Generate Service Characteristics
#' @param service_spec Service specifications from archetype
#' @return Data frame with service engagement information
generate_service_characteristics <- function(service_spec) {
  
  # Generate service duration
  duration_range <- service_spec$typical_duration_months
  service_duration <- sample(duration_range[1]:duration_range[2], 1)
  
  # Generate intake date (within realistic range)
  intake_date <- sample(
    seq(as.Date("2022-01-01"), as.Date("2024-06-01"), by = "day"), 
    1
  )
  
  # Calculate estimated closure date
  estimated_closure <- intake_date + months(service_duration)
  
  return(data.frame(
    case_complexity = service_spec$case_complexity,
    estimated_duration_months = service_duration,
    intake_date = intake_date,
    estimated_closure_date = estimated_closure,
    primary_services = paste(service_spec$primary_services, collapse = "; "),
    stringsAsFactors = FALSE
  ))
}

# ===============================================================================
# SUPPORTING GENERATION FUNCTIONS
# ===============================================================================

#' Generate Fictional Geographic Location
#' @param location_type "urban" or "rural"
#' @return Character string with fictional location
generate_fictional_location <- function(location_type) {
  
  urban_locations <- c(
    "Spruce Valley", "Maple Heights", "Pine Ridge", "Cedar Falls",
    "Birch Creek", "Aspen Hills", "Willow Park", "Oak Grove"
  )
  
  rural_locations <- c(
    "Northern Prairie", "Central Plains", "Southern Valley", "Eastside County",
    "Western Ridge", "Prairie View", "Mountain Shadow", "River Bend"
  )
  
  if (location_type == "urban") {
    return(sample(urban_locations, 1))
  } else {
    return(sample(rural_locations, 1))
  }
}

#' Generate Fictional Names
#' @return List with first_name, last_name, and gender
generate_fictional_name <- function() {
  
  first_names_male <- c(
    "James", "Michael", "David", "John", "Robert", "Mark", "Paul", "Daniel",
    "Christopher", "Matthew", "Anthony", "Kevin", "Brian", "Andrew", "Joshua"
  )
  
  first_names_female <- c(
    "Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Barbara", "Susan",
    "Jessica", "Sarah", "Karen", "Nancy", "Lisa", "Betty", "Helen", "Sandra"
  )
  
  last_names <- c(
    "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller",
    "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez",
    "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin"
  )
  
  gender <- sample(c("Male", "Female"), 1)
  
  if (gender == "Male") {
    first_name <- sample(first_names_male, 1)
  } else {
    first_name <- sample(first_names_female, 1)
  }
  
  last_name <- sample(last_names, 1)
  
  return(list(
    first_name = first_name,
    last_name = last_name,
    gender = gender
  ))
}

#' Apply Risk Factor Co-occurrence Patterns
#' @param risk_factors Data frame with individual risk factors
#' @return Modified data frame with realistic co-occurrence
apply_risk_cooccurrence <- function(risk_factors) {
  
  # If housing instability is present, increase substance use probability
  if (risk_factors$housing_instability == 1) {
    if (runif(1) < 0.35) {  # 35% chance of co-occurrence
      risk_factors$substance_use <- 1
    }
  }
  
  # If substance use is present, increase mental health challenges probability
  if (risk_factors$substance_use == 1) {
    if (runif(1) < 0.40) {  # 40% chance of co-occurrence
      risk_factors$mental_health_challenges <- 1
    }
  }
  
  # If criminal history is present, increase housing instability probability
  if (risk_factors$criminal_history == 1) {
    if (runif(1) < 0.45) {  # 45% chance of co-occurrence  
      risk_factors$housing_instability <- 1
    }
  }
  
  return(risk_factors)
}

# ===============================================================================
# VALIDATION AND QUALITY ASSURANCE FUNCTIONS
# ===============================================================================

#' Validate Generated Client Population
#' @param clients Data frame of generated clients
#' @return List with validation results
validate_client_population <- function(clients) {
  
  validation_results <- list(
    total_clients = nrow(clients),
    age_distribution = summary(clients$age),
    archetype_distribution = table(clients$archetype),
    risk_factor_prevalence = colMeans(clients[, grepl("housing_|substance_|mental_|criminal_", names(clients))]),
    location_distribution = table(clients$location_type),
    family_composition_distribution = table(clients$family_composition)
  )
  
  return(validation_results)
}

#' Export Client Population
#' @param clients Data frame of generated clients
#' @param output_path Path for output file
#' @param format Output format ("csv", "rds", "json")
export_client_population <- function(clients, output_path, format = "csv") {
  
  if (format == "csv") {
    write.csv(clients, output_path, row.names = FALSE)
  } else if (format == "rds") {
    saveRDS(clients, output_path)
  } else if (format == "json") {
    jsonlite::write_json(clients, output_path, pretty = TRUE)
  }
  
  message("Exported ", nrow(clients), " client profiles to: ", output_path)
}

# ===============================================================================
# UTILITY FUNCTIONS
# ===============================================================================

# Null coalescing operator
`%||%` <- function(x, y) if (is.null(x)) y else x

# ===============================================================================
# EXAMPLE USAGE
# ===============================================================================

if (FALSE) {  # Set to TRUE to run examples
  
  # Generate standard client population
  clients <- generate_client_population(n_clients = 500)
  
  # Validate the generated population
  validation <- validate_client_population(clients)
  print(validation)
  
  # Export to CSV
  export_client_population(
    clients, 
    "./output-datasets/client-profiles/synthetic_clients_2025-10-15.csv"
  )
  
  # Generate population for specific project scenario
  scenario_clients <- generate_client_population(
    n_clients = 500,
    scenario_file = "./input-specifications/project-scenarios/risk-assessment-validation.yml"
  )
  
  # Export scenario-specific population
  export_client_population(
    scenario_clients,
    "./output-datasets/client-profiles/risk_validation_clients_2025-10-15.csv"
  )
}

# ===============================================================================
# FUNCTION EXPORTS FOR SOURCING
# ===============================================================================

# Make key functions available when script is sourced
exported_functions <- c(
  "generate_client_population",
  "validate_client_population", 
  "export_client_population",
  "load_client_specifications"
)