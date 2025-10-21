# Case Note Analysis - Exploratory Data Analysis
# Three-layer analytical framework for synthetic case notes

# ---- environment ---------------
library(tidyverse)
library(readr)
library(DT)
library(scales)
library(plotly)

# ---- declare-globals ------------
# Define analytical layers
ANALYSIS_LAYERS <- list(
  demographics = "Population demographic profiling and risk stratification",
  individual = "Individual case note analysis and risk flagging", 
  contextual = "Contextual interpretation within reference groups"
)

# Define risk flags for individual analysis
RISK_FLAGS <- c(
  "substance_use", "homelessness", "mental_health_crisis",
  "housing_instability", "employment_loss", "family_separation"
)

# ---- load-data ------------------
load_synthetic_data <- function(path = "../../abc/take-2/output/") {
  # Load synthetic case notes dataset
  csv_path <- file.path(path, "synthetic-case-notes.csv")
  json_path <- file.path(path, "synthetic-case-notes.json")
  
  if (file.exists(csv_path)) {
    df_raw <- read_csv(csv_path, show_col_types = FALSE)
    
    # PRODUCTION READY: Keep only variables available in real production
    production_columns <- c("person_oid", "first_name", "last_name", 
                           "gender", "age", "location", "case_note")
    
    df <- df_raw %>% 
      select(all_of(production_columns))
    
    message("Loaded ", nrow(df), " synthetic case records from CSV")
    message("Using production-ready columns only: ", paste(production_columns, collapse = ", "))
    return(df)
  } else {
    stop("Synthetic data file not found at: ", csv_path)
  }
}

# ---- inspect-data ---------------
inspect_data_structure <- function(df) {
  cat("\n=== Data Structure Overview ===\n")
  str(df)
  
  cat("\n=== Sample Records ===\n")
  print(head(df, 3))
  
  cat("\n=== Missing Values ===\n")
  missing_summary <- df %>%
    summarise(across(everything(), ~sum(is.na(.x)))) %>%
    pivot_longer(everything(), names_to = "variable", values_to = "missing_count") %>%
    filter(missing_count > 0)
  print(missing_summary)
}

# ---- layer-1-demographics -------
analyze_population_demographics <- function(df) {
  cat("\n=== LAYER 1: DEMOGRAPHIC ANALYSIS ===\n")
  
  # Age distribution
  age_summary <- df %>%
    summarise(
      n = n(),
      mean_age = mean(age, na.rm = TRUE),
      median_age = median(age, na.rm = TRUE),
      min_age = min(age, na.rm = TRUE),
      max_age = max(age, na.rm = TRUE),
      .groups = "drop"
    )
  
  # Create age groups for stratification (since complexity_level not available)
  df_with_age_groups <- df %>%
    mutate(
      age_group = case_when(
        age < 25 ~ "Young Adult (18-24)",
        age < 35 ~ "Young Adult (25-34)", 
        age < 50 ~ "Middle Age (35-49)",
        age < 65 ~ "Older Adult (50-64)",
        TRUE ~ "Senior (65+)"
      )
    )
  
  # Gender distribution
  gender_dist <- df %>%
    count(gender, sort = TRUE) %>%
    mutate(percentage = scales::percent(n / sum(n), accuracy = 0.1))
  
  # Location distribution
  location_dist <- df %>%
    count(location, sort = TRUE) %>%
    mutate(percentage = scales::percent(n / sum(n), accuracy = 0.1))
  
  # Age group distribution (replacing complexity_level)
  age_group_dist <- df_with_age_groups %>%
    count(age_group, sort = TRUE) %>%
    mutate(percentage = scales::percent(n / sum(n), accuracy = 0.1))
  
  # Risk stratification by demographics (age groups + location)
  risk_profile <- df_with_age_groups %>%
    group_by(age_group, location) %>%
    summarise(
      n_cases = n(),
      mean_age = mean(age, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(age_group, location)
  
  return(list(
    age_summary = age_summary,
    gender_distribution = gender_dist,
    location_distribution = location_dist,
    age_group_distribution = age_group_dist,
    risk_stratification = risk_profile,
    data_with_age_groups = df_with_age_groups
  ))
}

# ---- layer-2-individual ---------
# Note: This will interface with Python NLP models
prepare_notes_for_nlp <- function(df) {
  # Prepare case notes for Python NLP processing - PRODUCTION READY
  notes_df <- df %>%
    select(person_oid, case_note, age, gender, location) %>%
    mutate(
      note_id = row_number(),
      note_length = nchar(case_note),
      note_word_count = str_count(case_note, "\\S+")
    )
  
  # Export for Python processing
  write_csv(notes_df, "./temp/notes_for_nlp.csv")
  
  return(notes_df)
}

# Basic text analysis in R (before NLP)
analyze_note_characteristics <- function(df, df_with_age_groups) {
  cat("\n=== LAYER 2: INDIVIDUAL NOTE ANALYSIS ===\n")
  
  # Merge with age groups for stratification
  notes_analysis <- df_with_age_groups %>%
    mutate(
      note_length = nchar(case_note),
      word_count = str_count(case_note, "\\S+"),
      # Basic keyword detection (will be enhanced by Python NLP)
      mentions_crisis = str_detect(tolower(case_note), "crisis|urgent|emergency"),
      mentions_housing = str_detect(tolower(case_note), "hous|evict|homeless"),
      mentions_substance = str_detect(tolower(case_note), "substance|alcohol|drug"),
      mentions_mental_health = str_detect(tolower(case_note), "mental|depress|anxiety|suicidal"),
      # Writer style indicators
      uses_abbreviations = str_detect(case_note, "\\b[A-Z]{2,}\\b"),
      formal_tone = str_detect(case_note, "Client|Reports|Assessment")
    )
  
  # Summary of note characteristics by age group (replacing complexity level)
  note_summary <- notes_analysis %>%
    group_by(age_group) %>%
    summarise(
      n_notes = n(),
      avg_length = mean(note_length),
      avg_words = mean(word_count),
      crisis_mentions = sum(mentions_crisis),
      housing_issues = sum(mentions_housing),
      substance_mentions = sum(mentions_substance),
      mental_health_mentions = sum(mentions_mental_health),
      .groups = "drop"
    )
  
  # Overall summary (across all cases)
  overall_summary <- notes_analysis %>%
    summarise(
      total_notes = n(),
      avg_length = mean(note_length),
      avg_words = mean(word_count),
      crisis_rate = mean(mentions_crisis),
      housing_rate = mean(mentions_housing),
      substance_rate = mean(mentions_substance),
      mental_health_rate = mean(mentions_mental_health)
    )
  
  return(list(
    notes_with_flags = notes_analysis,
    summary_by_age_group = note_summary,
    overall_summary = overall_summary
  ))
}

# ---- layer-3-contextual ---------
analyze_contextual_patterns <- function(df, notes_analysis) {
  cat("\n=== LAYER 3: CONTEXTUAL INTERPRETATION ===\n")
  
  # Reference group analysis - overall baseline
  overall_baseline <- notes_analysis %>%
    summarise(
      total_cases = n(),
      crisis_rate = mean(mentions_crisis),
      housing_risk_rate = mean(mentions_housing),
      substance_rate = mean(mentions_substance),
      mental_health_rate = mean(mentions_mental_health)
    )
  
  # Context by age groups (replacing complexity levels)
  age_group_context <- notes_analysis %>%
    group_by(age_group) %>%
    summarise(
      group_size = n(),
      crisis_rate = mean(mentions_crisis),
      housing_risk_rate = mean(mentions_housing),
      substance_rate = mean(mentions_substance),
      mental_health_rate = mean(mentions_mental_health),
      avg_note_length = mean(note_length),
      avg_age = mean(age),
      .groups = "drop"
    ) %>%
    mutate(
      # Compare to overall baseline
      crisis_vs_baseline = crisis_rate / overall_baseline$crisis_rate,
      housing_vs_baseline = housing_risk_rate / overall_baseline$housing_risk_rate,
      substance_vs_baseline = substance_rate / overall_baseline$substance_rate,
      mental_health_vs_baseline = mental_health_rate / overall_baseline$mental_health_rate
    )
  
  # Geographic context
  geographic_context <- notes_analysis %>%
    group_by(location) %>%
    summarise(
      group_size = n(),
      avg_age = mean(age),
      crisis_rate = mean(mentions_crisis),
      housing_risk_rate = mean(mentions_housing),
      substance_rate = mean(mentions_substance),
      mental_health_rate = mean(mentions_mental_health),
      .groups = "drop"
    )
  
  # Gender context
  gender_context <- notes_analysis %>%
    group_by(gender) %>%
    summarise(
      group_size = n(),
      avg_age = mean(age),
      crisis_rate = mean(mentions_crisis),
      housing_risk_rate = mean(mentions_housing),
      substance_rate = mean(mentions_substance),
      mental_health_rate = mean(mentions_mental_health),
      .groups = "drop"
    )
  
  return(list(
    overall_baseline = overall_baseline,
    age_group_context = age_group_context,
    geographic_context = geographic_context,
    gender_context = gender_context
  ))
}

# ---- visualization --------------
create_demographic_plots <- function(demographics, notes_with_flags) {
  # Age distribution by location (production ready)
  p1 <- notes_with_flags %>%
    ggplot(aes(x = age, fill = location)) +
    geom_histogram(bins = 15, alpha = 0.7, position = "identity") +
    facet_wrap(~location, scales = "free_y") +
    labs(
      title = "Age Distribution by Location",
      x = "Age", y = "Count",
      fill = "Location"
    ) +
    theme_minimal()
  
  # Age groups by location (replacing complexity levels)
  p2 <- demographics$risk_stratification %>%
    ggplot(aes(x = age_group, y = n_cases, fill = location)) +
    geom_col(position = "dodge") +
    labs(
      title = "Case Distribution: Age Groups by Location", 
      x = "Age Group", y = "Number of Cases",
      fill = "Location"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  return(list(age_plot = p1, age_group_plot = p2))
}

create_risk_flag_plots <- function(notes_analysis) {
  # Risk flag prevalence by age group (production ready)
  flag_summary <- notes_analysis %>%
    group_by(age_group) %>%
    summarise(
      Crisis = mean(mentions_crisis),
      Housing = mean(mentions_housing), 
      Substance = mean(mentions_substance),
      "Mental Health" = mean(mentions_mental_health),
      .groups = "drop"
    ) %>%
    pivot_longer(-age_group, names_to = "risk_type", values_to = "prevalence")
  
  p1 <- flag_summary %>%
    ggplot(aes(x = age_group, y = prevalence, fill = risk_type)) +
    geom_col(position = "dodge") +
    labs(
      title = "Risk Flag Prevalence by Age Group",
      x = "Age Group", y = "Prevalence Rate",
      fill = "Risk Type"
    ) +
    scale_y_continuous(labels = scales::percent) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  return(p1)
}

# ---- main-analysis --------------
run_complete_analysis <- function() {
  # Load data (production-ready columns only)
  df <- load_synthetic_data()
  
  # Inspect structure
  inspect_data_structure(df)
  
  # Layer 1: Demographics (creates age groups since complexity_level not available)
  demographics <- analyze_population_demographics(df)
  
  # Layer 2: Individual analysis (uses age groups instead of complexity levels)
  notes_prep <- prepare_notes_for_nlp(df)
  individual_analysis <- analyze_note_characteristics(df, demographics$data_with_age_groups)
  
  # Layer 3: Contextual patterns (age groups, location, gender contexts)
  contextual_analysis <- analyze_contextual_patterns(df, individual_analysis$notes_with_flags)
  
  # Visualizations (updated for production variables)
  demo_plots <- create_demographic_plots(demographics, individual_analysis$notes_with_flags)
  risk_plots <- create_risk_flag_plots(individual_analysis$notes_with_flags)
  
  # Return comprehensive results
  return(list(
    data = df,
    demographics = demographics,
    individual = individual_analysis,
    contextual = contextual_analysis,
    plots = list(
      demographics = demo_plots,
      risk_flags = risk_plots
    )
  ))
}

# ---- run-analysis ---------------
# Execute the three-layer analysis
results <- run_complete_analysis()