rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run
cat("\014") # Clear the console
# verify root location
cat("Working directory: ", getwd()) # Must be set to Project Directory

# Case Note Analysis - Exploratory Data Analysis  
# Three-layer analytical framework for synthetic case notes

# ---- load-packages ---------------
# Choose to be greedy: load only what's needed
library(magrittr)
library(ggplot2)   # graphs
library(forcats)   # factors
library(stringr)   # strings, text processing
library(lubridate) # dates
library(labelled)  # labels
library(dplyr)     # data wrangling
library(tidyr)     # data wrangling
library(scales)    # format
library(readr)     # reading data
library(DT)        # interactive tables
library(plotly)    # interactive plots
library(patchwork) # combining plots
library(fs)        # file system operations

# ---- load-sources ---------------
# Load project-level functions if available
tryCatch({
  base::source("./scripts/common-functions.R") # project-level
}, error = function(e) {
  cat("Note: common-functions.R not found, proceeding without\n")
})

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

# Color palettes for consistent visualization
age_colors <- c("#2E8B57", "#4682B4", "#CD853F", "#DC143C", "#9370DB")
risk_colors <- c("Crisis" = "#DC143C", "Housing" = "#FF6347", 
                "Substance" = "#8B4513", "Mental Health" = "#4169E1")

# Local paths for outputs
local_root <- "./analysis/eda-2-casenote/"
local_data <- paste0(local_root, "temp/")
if (!fs::dir_exists(local_data)) {fs::dir_create(local_data)}

prints_folder <- paste0(local_root, "output/")
if (!fs::dir_exists(prints_folder)) {fs::dir_create(prints_folder)}

# ---- declare-functions -----------

# Helper function for neat display (if not in common-functions.R)
neat <- function(x, ...) {
  # Simple fallback neat function for formatted output
  if (is.data.frame(x)) {
    print(x, ...)
  } else {
    print(x, ...)
  }
}

# ---- load-data ------------------
# Load synthetic case notes dataset
load_synthetic_data <- function(path = "./abc/take-2/output/") {
  csv_path <- file.path(path, "synthetic-case-notes-for-input.csv")
  
  if (file.exists(csv_path)) {
    df_raw <- read_csv(csv_path, show_col_types = FALSE)
    cat("Loaded", nrow(df_raw), "synthetic case records from CSV\n")
    cat("Available columns:", paste(names(df_raw), collapse = ", "), "\n")
    return(df_raw)
  } else {
    stop("Synthetic data file not found at: ", csv_path)
  }
}

# Load the data
df_raw <- load_synthetic_data()
df_raw %>% glimpse()
# ---- inspect-data ---------------
# Display data structure and basic info
cat("\n=== RAW DATA INSPECTION ===\n")
df_raw %>% glimpse()

# Show sample of case notes for context
cat("\n=== SAMPLE CASE NOTES ===\n")
df_raw %>% 
  select(person_oid, age, gender, location, case_note) %>%
  head(3) %>%
  mutate(case_note = str_trunc(case_note, 100)) %>%
  print()

# Check for missing values
missing_summary <- df_raw %>%
  summarise(across(everything(), ~sum(is.na(.x)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "missing_count") %>%
  arrange(desc(missing_count))

cat("\n=== MISSING VALUES SUMMARY ===\n")
print(missing_summary)

# ===================================================================
# LAYER 1: INPUT DATA DESCRIPTION & BASIC DEMOGRAPHICS
# ===================================================================

# ---- layer-1-data-preparation ---
# Prepare the dataset for analysis with consistent variable naming
df_input <- df_raw %>%
  # Create standardized columns following production patterns
  select(
    person_oid, age, gender, location, case_note,
    # Include any additional columns that exist
    any_of(c("first_name", "last_name", "complexity_level", "archetype_id"))
  ) %>%
  # Create age groups for analysis
  mutate(
    age_group = case_when(
      age < 25 ~ "Young Adult (18-24)",
      age < 35 ~ "Young Adult (25-34)", 
      age < 50 ~ "Middle Age (35-49)",
      age < 65 ~ "Older Adult (50-64)",
      TRUE ~ "Senior (65+)"
    ),
    age_group = factor(age_group, levels = c(
      "Young Adult (18-24)", "Young Adult (25-34)", 
      "Middle Age (35-49)", "Older Adult (50-64)", "Senior (65+)"
    )),
    # Basic note characteristics
    note_length = nchar(case_note),
    note_word_count = str_count(case_note, "\\S+")
  )

cat("\n=== LAYER 1: INPUT DATA OVERVIEW ===\n")
cat("Dataset dimensions:", nrow(df_input), "rows x", ncol(df_input), "columns\n")

# ---- layer-1-univariate-age -----
# Age distribution analysis
age_summary <- df_input %>%
  summarise(
    n = n(),
    mean_age = mean(age, na.rm = TRUE),
    median_age = median(age, na.rm = TRUE),
    min_age = min(age, na.rm = TRUE),
    max_age = max(age, na.rm = TRUE),
    sd_age = sd(age, na.rm = TRUE)
  )

cat("\n=== AGE DISTRIBUTION SUMMARY ===\n")
neat(age_summary)

# Age histogram
g1_age_histogram <- df_input %>%
  ggplot(aes(x = age)) +
  geom_histogram(bins = 20, fill = "#4682B4", alpha = 0.7, color = "white") +
  geom_vline(aes(xintercept = mean(age, na.rm = TRUE)), 
             color = "#DC143C", linetype = "dashed", linewidth = 1) +
  labs(
    title = "Age Distribution of Case Note Population",
    subtitle = paste("Mean age:", round(age_summary$mean_age, 1), "years"),
    x = "Age (years)", y = "Count"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 14, face = "bold"))

print(g1_age_histogram)
ggsave(g1_age_histogram, filename = paste0(prints_folder, "g01-age-distribution.png"),
       width = 8, height = 5, dpi = 300)

# Age group distribution
age_group_summary <- df_input %>%
  count(age_group) %>%
  mutate(percentage = n / sum(n) * 100)

cat("\n=== AGE GROUP DISTRIBUTION ===\n")
neat(age_group_summary)

g2_age_groups <- df_input %>%
  count(age_group) %>%
  mutate(percentage = n / sum(n)) %>%
  ggplot(aes(x = age_group, y = n, fill = age_group)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = paste0(n, "\n(", scales::percent(percentage, accuracy = 0.1), ")")),
            vjust = -0.5, fontface = "bold") +
  scale_fill_manual(values = age_colors) +
  labs(
    title = "Distribution by Age Groups",
    x = "Age Group", y = "Count",
    fill = "Age Group"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold")
  )

print(g2_age_groups)
ggsave(g2_age_groups, filename = paste0(prints_folder, "g02-age-groups.png"),
       width = 8, height = 5, dpi = 300)

# ---- layer-1-univariate-gender --
# Gender distribution
gender_summary <- df_input %>%
  count(gender, sort = TRUE) %>%
  mutate(percentage = n / sum(n) * 100)

cat("\n=== GENDER DISTRIBUTION ===\n")
neat(gender_summary)

g3_gender <- df_input %>%
  count(gender) %>%
  mutate(percentage = n / sum(n)) %>%
  ggplot(aes(x = reorder(gender, n), y = n, fill = gender)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = paste0(n, "\n(", scales::percent(percentage, accuracy = 0.1), ")")),
            hjust = -0.1, fontface = "bold") +
  coord_flip() +
  labs(
    title = "Distribution by Gender",
    x = "Gender", y = "Count",
    fill = "Gender"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold")
  )

print(g3_gender)
ggsave(g3_gender, filename = paste0(prints_folder, "g03-gender-distribution.png"),
       width = 8, height = 5, dpi = 300)

# ---- layer-1-univariate-location ----
# Location distribution
location_summary <- df_input %>%
  count(location, sort = TRUE) %>%
  mutate(percentage = n / sum(n) * 100)

cat("\n=== LOCATION DISTRIBUTION ===\n")
neat(location_summary)

g4_location <- df_input %>%
  count(location) %>%
  mutate(percentage = n / sum(n)) %>%
  ggplot(aes(x = reorder(location, n), y = n, fill = location)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = paste0(n, "\n(", scales::percent(percentage, accuracy = 0.1), ")")),
            hjust = -0.1, fontface = "bold") +
  coord_flip() +
  labs(
    title = "Distribution by Location",
    x = "Location", y = "Count",
    fill = "Location"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold")
  )

print(g4_location)
ggsave(g4_location, filename = paste0(prints_folder, "g04-location-distribution.png"),
       width = 8, height = 5, dpi = 300)

# ---- layer-1-univariate-notes ---
# Note characteristics
note_summary <- df_input %>%
  summarise(
    n_notes = n(),
    mean_length = mean(note_length, na.rm = TRUE),
    median_length = median(note_length, na.rm = TRUE),
    min_length = min(note_length, na.rm = TRUE),
    max_length = max(note_length, na.rm = TRUE),
    mean_words = mean(note_word_count, na.rm = TRUE),
    median_words = median(note_word_count, na.rm = TRUE)
  )

cat("\n=== CASE NOTE CHARACTERISTICS ===\n")
neat(note_summary)

g5_note_length <- df_input %>%
  ggplot(aes(x = note_length)) +
  geom_histogram(bins = 30, fill = "#2E8B57", alpha = 0.7, color = "white") +
  geom_vline(aes(xintercept = mean(note_length, na.rm = TRUE)), 
             color = "#DC143C", linetype = "dashed", linewidth = 1) +
  labs(
    title = "Distribution of Case Note Length",
    subtitle = paste("Mean length:", round(note_summary$mean_length, 0), "characters"),
    x = "Note Length (characters)", y = "Count"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 14, face = "bold"))

print(g5_note_length)
ggsave(g5_note_length, filename = paste0(prints_folder, "g05-note-length.png"),
       width = 8, height = 5, dpi = 300)

g6_word_count <- df_input %>%
  ggplot(aes(x = note_word_count)) +
  geom_histogram(bins = 30, fill = "#8B4513", alpha = 0.7, color = "white") +
  geom_vline(aes(xintercept = mean(note_word_count, na.rm = TRUE)), 
             color = "#DC143C", linetype = "dashed", linewidth = 1) +
  labs(
    title = "Distribution of Case Note Word Count",
    subtitle = paste("Mean words:", round(note_summary$mean_words, 0), "words"),
    x = "Word Count", y = "Count"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 14, face = "bold"))

print(g6_word_count)
ggsave(g6_word_count, filename = paste0(prints_folder, "g06-word-count.png"),
       width = 8, height = 5, dpi = 300)

# ---- layer-1-bivariate-demographics ----
# Cross-tabulations and relationships between variables
cat("\n=== DEMOGRAPHIC CROSS-TABULATIONS ===\n")

# Age by location
age_location_crosstab <- df_input %>%
  group_by(age_group, location) %>%
  summarise(n = n(), .groups = "drop") %>%
  pivot_wider(names_from = location, values_from = n, values_fill = 0)

cat("Age Group by Location:\n")
neat(age_location_crosstab)

# Gender by location  
gender_location_crosstab <- df_input %>%
  group_by(gender, location) %>%
  summarise(n = n(), .groups = "drop") %>%
  pivot_wider(names_from = location, values_from = n, values_fill = 0)

cat("\nGender by Location:\n")
neat(gender_location_crosstab)

# Combined demographic visualization
g7_demographics_combined <- df_input %>%
  count(age_group, location) %>%
  ggplot(aes(x = age_group, y = n, fill = location)) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(
    title = "Case Distribution: Age Groups by Location",
    x = "Age Group", y = "Count",
    fill = "Location"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(size = 14, face = "bold")
  )

print(g7_demographics_combined)
ggsave(g7_demographics_combined, 
       filename = paste0(prints_folder, "g07-demographics-combined.png"),
       width = 10, height = 6, dpi = 300)

# ---- layer-1-summary --------
cat("\n=== LAYER 1 SUMMARY: INPUT DATA DESCRIBED ===\n")
cat("✓ Dataset loaded:", nrow(df_input), "case notes\n")
cat("✓ Age distribution: Mean =", round(age_summary$mean_age, 1), "years\n")
cat("✓ Gender breakdown:", paste(gender_summary$gender, "=", gender_summary$n, collapse = ", "), "\n")
cat("✓ Location coverage:", nrow(location_summary), "locations\n") 
cat("✓ Note characteristics: Mean length =", round(note_summary$mean_length, 0), "chars\n")
cat("✓ Visualizations created and saved to:", prints_folder, "\n")

# Save Layer 1 dataset for Layer 2
write_csv(df_input, paste0(local_data, "layer1_input_data.csv"))
cat("✓ Layer 1 data saved for Layer 2 processing\n")

# ===================================================================
# LAYER 2: ADDING ANALYTICAL VARIABLES & TRANSFORMATIONS  
# ===================================================================

# ---- layer-2-risk-flags ---------
# Add risk flag variables based on case note content analysis
cat("\n=== LAYER 2: ANALYTICAL TRANSFORMATIONS ===\n")

df_layer2 <- df_input %>%
  mutate(
    # Basic keyword detection for risk flags
    flag_crisis = str_detect(tolower(case_note), 
                            "crisis|urgent|emergency|immediate|critical"),
    flag_housing = str_detect(tolower(case_note), 
                             "hous|evict|homeless|shelter|rent"),
    flag_substance = str_detect(tolower(case_note), 
                               "substance|alcohol|drug|addiction|intoxicat"),
    flag_mental_health = str_detect(tolower(case_note), 
                                   "mental|depress|anxiety|suicidal|psychiatric"),
    flag_employment = str_detect(tolower(case_note), 
                                "job|work|employ|unemploy|fired|laid off"),
    flag_family = str_detect(tolower(case_note), 
                            "family|child|custody|domestic|separation"),
    
    # Writer style indicators
    uses_abbreviations = str_detect(case_note, "\\b[A-Z]{2,}\\b"),
    formal_tone = str_detect(case_note, "Client|Reports|Assessment|Reviewed"),
    informal_tone = str_detect(case_note, "\\bshe\\b|\\bhe\\b|gonna|kinda"),
    
    # Note complexity indicators
    has_multiple_issues = (flag_crisis + flag_housing + flag_substance + 
                          flag_mental_health + flag_employment + flag_family) >= 2,
    
    # Risk composite score (0-1 scale)
    risk_score = (flag_crisis + flag_housing + flag_substance + 
                 flag_mental_health + flag_employment + flag_family) / 6
  )

cat("Added", ncol(df_layer2) - ncol(df_input), "new analytical variables\n")

# ---- layer-2-risk-flag-analysis ----
# Analyze prevalence of risk flags
risk_flag_summary <- df_layer2 %>%
  summarise(
    n_cases = n(),
    crisis_rate = mean(flag_crisis) * 100,
    housing_rate = mean(flag_housing) * 100,
    substance_rate = mean(flag_substance) * 100,
    mental_health_rate = mean(flag_mental_health) * 100,
    employment_rate = mean(flag_employment) * 100,
    family_rate = mean(flag_family) * 100,
    multiple_issues_rate = mean(has_multiple_issues) * 100,
    mean_risk_score = mean(risk_score)
  )

cat("\n=== RISK FLAG PREVALENCE (Overall Population) ===\n")
neat(risk_flag_summary)

# Risk flags by age group
risk_by_age <- df_layer2 %>%
  group_by(age_group) %>%
  summarise(
    n = n(),
    crisis_rate = mean(flag_crisis) * 100,
    housing_rate = mean(flag_housing) * 100,
    substance_rate = mean(flag_substance) * 100,
    mental_health_rate = mean(flag_mental_health) * 100,
    employment_rate = mean(flag_employment) * 100,
    family_rate = mean(flag_family) * 100,
    multiple_issues_rate = mean(has_multiple_issues) * 100,
    mean_risk_score = mean(risk_score),
    .groups = "drop"
  )

cat("\n=== RISK FLAG PREVALENCE BY AGE GROUP ===\n")
neat(risk_by_age)

# ---- layer-2-visualizations ----
# Risk flag prevalence visualization
risk_flags_long <- df_layer2 %>%
  summarise(
    Crisis = mean(flag_crisis),
    Housing = mean(flag_housing),
    Substance = mean(flag_substance),
    "Mental Health" = mean(flag_mental_health),
    Employment = mean(flag_employment),
    Family = mean(flag_family)
  ) %>%
  pivot_longer(everything(), names_to = "risk_type", values_to = "prevalence")

g8_risk_flags <- risk_flags_long %>%
  ggplot(aes(x = reorder(risk_type, prevalence), y = prevalence)) +
  geom_col(aes(fill = risk_type), alpha = 0.8) +
  geom_text(aes(label = scales::percent(prevalence, accuracy = 0.1)),
            hjust = -0.1, fontface = "bold") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent, limits = c(0, max(risk_flags_long$prevalence) * 1.1)) +
  labs(
    title = "Risk Flag Prevalence Across All Cases",
    x = "Risk Type", y = "Prevalence Rate",
    fill = "Risk Type"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold")
  )

print(g8_risk_flags)
ggsave(g8_risk_flags, filename = paste0(prints_folder, "g08-risk-flag-prevalence.png"),
       width = 8, height = 6, dpi = 300)

# Risk flags by age group visualization
risk_by_age_long <- risk_by_age %>%
  select(age_group, crisis_rate, housing_rate, substance_rate, 
         mental_health_rate, employment_rate, family_rate) %>%
  pivot_longer(-age_group, names_to = "risk_type", values_to = "rate") %>%
  mutate(
    risk_type = str_remove(risk_type, "_rate"),
    risk_type = str_replace_all(risk_type, "_", " "),
    risk_type = str_to_title(risk_type)
  )

g9_risk_by_age <- risk_by_age_long %>%
  ggplot(aes(x = age_group, y = rate/100, fill = risk_type)) +
  geom_col(position = "dodge", alpha = 0.8) +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Risk Flag Prevalence by Age Group",
    x = "Age Group", y = "Prevalence Rate",
    fill = "Risk Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(size = 14, face = "bold")
  )

print(g9_risk_by_age)
ggsave(g9_risk_by_age, filename = paste0(prints_folder, "g09-risk-by-age.png"),
       width = 12, height = 6, dpi = 300)

# ---- layer-2-risk-score-analysis ----
# Risk score distribution
risk_score_summary <- df_layer2 %>%
  summarise(
    n = n(),
    mean_risk = mean(risk_score),
    median_risk = median(risk_score),
    min_risk = min(risk_score),
    max_risk = max(risk_score),
    sd_risk = sd(risk_score)
  )

cat("\n=== RISK SCORE DISTRIBUTION ===\n")
neat(risk_score_summary)

g10_risk_score <- df_layer2 %>%
  ggplot(aes(x = risk_score)) +
  geom_histogram(bins = 20, fill = "#DC143C", alpha = 0.7, color = "white") +
  geom_vline(aes(xintercept = mean(risk_score)), 
             color = "#2E8B57", linetype = "dashed", linewidth = 1) +
  labs(
    title = "Distribution of Composite Risk Scores",
    subtitle = paste("Mean risk score:", round(risk_score_summary$mean_risk, 3)),
    x = "Risk Score (0-1 scale)", y = "Count"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 14, face = "bold"))

print(g10_risk_score)
ggsave(g10_risk_score, filename = paste0(prints_folder, "g10-risk-score-distribution.png"),
       width = 8, height = 5, dpi = 300)

# Risk score by demographics
risk_score_by_demo <- df_layer2 %>%
  group_by(age_group, gender, location) %>%
  summarise(
    n = n(),
    mean_risk = mean(risk_score),
    .groups = "drop"
  ) %>%
  filter(n >= 5) # Only show groups with sufficient sample size

cat("\n=== RISK SCORE BY DEMOGRAPHICS (n>=5) ===\n")
neat(risk_score_by_demo)

# ---- layer-2-note-complexity ----
# Analyze note writing patterns and complexity
writing_style_summary <- df_layer2 %>%
  summarise(
    uses_abbrev_rate = mean(uses_abbreviations) * 100,
    formal_tone_rate = mean(formal_tone) * 100,
    informal_tone_rate = mean(informal_tone) * 100
  )

cat("\n=== WRITING STYLE PATTERNS ===\n")
neat(writing_style_summary)

# Multiple issues analysis  
multiple_issues_by_demo <- df_layer2 %>%
  group_by(age_group) %>%
  summarise(
    n = n(),
    multiple_issues_rate = mean(has_multiple_issues) * 100,
    mean_risk_score = mean(risk_score),
    .groups = "drop"
  )

cat("\n=== MULTIPLE ISSUES BY AGE GROUP ===\n")
neat(multiple_issues_by_demo)

# ---- layer-2-summary --------
cat("\n=== LAYER 2 SUMMARY: ANALYTICAL VARIABLES ADDED ===\n")
cat("✓ Risk flags created: Crisis, Housing, Substance, Mental Health, Employment, Family\n")
cat("✓ Writing style indicators: Abbreviations, Formal/Informal tone\n")
cat("✓ Composite measures: Multiple issues flag, Risk score (0-1)\n")
cat("✓ Overall risk prevalence: Crisis =", round(risk_flag_summary$crisis_rate, 1), "%, Housing =", round(risk_flag_summary$housing_rate, 1), "%\n")
cat("✓ Mean risk score:", round(risk_flag_summary$mean_risk_score, 3), "\n")
cat("✓ Multiple issues rate:", round(risk_flag_summary$multiple_issues_rate, 1), "%\n")

# Save Layer 2 dataset for Layer 3
write_csv(df_layer2, paste0(local_data, "layer2_analytical_data.csv"))
cat("✓ Layer 2 data saved for Layer 3 processing\n")

# ===================================================================
# LAYER 3: CONTEXTUAL INTERPRETATION & REFERENCE GROUPS
# ===================================================================

# ---- layer-3-baseline-establishment ----
# Establish population baselines for contextual comparison
cat("\n=== LAYER 3: CONTEXTUAL INTERPRETATION ===\n")

overall_baseline <- df_layer2 %>%
  summarise(
    total_cases = n(),
    baseline_crisis = mean(flag_crisis) * 100,
    baseline_housing = mean(flag_housing) * 100,
    baseline_substance = mean(flag_substance) * 100,
    baseline_mental_health = mean(flag_mental_health) * 100,
    baseline_employment = mean(flag_employment) * 100,
    baseline_family = mean(flag_family) * 100,
    baseline_risk_score = mean(risk_score),
    baseline_note_length = mean(note_length)
  )

cat("\n=== POPULATION BASELINE RATES ===\n")
neat(overall_baseline)

# ---- layer-3-age-group-context ----
# Compare each age group to overall baseline
age_group_context <- df_layer2 %>%
  group_by(age_group) %>%
  summarise(
    group_size = n(),
    avg_age = mean(age),
    crisis_rate = mean(flag_crisis) * 100,
    housing_rate = mean(flag_housing) * 100,
    substance_rate = mean(flag_substance) * 100,
    mental_health_rate = mean(flag_mental_health) * 100,
    employment_rate = mean(flag_employment) * 100,
    family_rate = mean(flag_family) * 100,
    avg_risk_score = mean(risk_score),
    avg_note_length = mean(note_length),
    .groups = "drop"
  ) %>%
  mutate(
    # Calculate ratios vs baseline (>1 = above baseline, <1 = below baseline)
    crisis_vs_baseline = crisis_rate / overall_baseline$baseline_crisis,
    housing_vs_baseline = housing_rate / overall_baseline$baseline_housing,
    substance_vs_baseline = substance_rate / overall_baseline$baseline_substance,
    mental_health_vs_baseline = mental_health_rate / overall_baseline$baseline_mental_health,
    employment_vs_baseline = employment_rate / overall_baseline$baseline_employment,
    family_vs_baseline = family_rate / overall_baseline$baseline_family,
    risk_score_vs_baseline = avg_risk_score / overall_baseline$baseline_risk_score
  )

cat("\n=== AGE GROUP CONTEXT (vs Population Baseline) ===\n")
neat(age_group_context)

# ---- layer-3-geographic-context ----
# Geographic variation analysis
geographic_context <- df_layer2 %>%
  group_by(location) %>%
  summarise(
    group_size = n(),
    avg_age = mean(age),
    crisis_rate = mean(flag_crisis) * 100,
    housing_rate = mean(flag_housing) * 100,
    substance_rate = mean(flag_substance) * 100,
    mental_health_rate = mean(flag_mental_health) * 100,
    employment_rate = mean(flag_employment) * 100,
    family_rate = mean(flag_family) * 100,
    avg_risk_score = mean(risk_score),
    .groups = "drop"
  ) %>%
  mutate(
    # Geographic risk profile relative to baseline
    crisis_vs_baseline = crisis_rate / overall_baseline$baseline_crisis,
    housing_vs_baseline = housing_rate / overall_baseline$baseline_housing,
    substance_vs_baseline = substance_rate / overall_baseline$baseline_substance,
    mental_health_vs_baseline = mental_health_rate / overall_baseline$baseline_mental_health,
    risk_score_vs_baseline = avg_risk_score / overall_baseline$baseline_risk_score
  )

cat("\n=== GEOGRAPHIC CONTEXT (vs Population Baseline) ===\n")
neat(geographic_context)

# ---- layer-3-gender-context ----
# Gender-based risk profile differences
gender_context <- df_layer2 %>%
  group_by(gender) %>%
  summarise(
    group_size = n(),
    avg_age = mean(age),
    crisis_rate = mean(flag_crisis) * 100,
    housing_rate = mean(flag_housing) * 100,
    substance_rate = mean(flag_substance) * 100,
    mental_health_rate = mean(flag_mental_health) * 100,
    employment_rate = mean(flag_employment) * 100,
    family_rate = mean(flag_family) * 100,
    avg_risk_score = mean(risk_score),
    .groups = "drop"
  ) %>%
  mutate(
    # Gender risk patterns relative to baseline
    crisis_vs_baseline = crisis_rate / overall_baseline$baseline_crisis,
    housing_vs_baseline = housing_rate / overall_baseline$baseline_housing,
    substance_vs_baseline = substance_rate / overall_baseline$baseline_substance,
    mental_health_vs_baseline = mental_health_rate / overall_baseline$baseline_mental_health,
    risk_score_vs_baseline = avg_risk_score / overall_baseline$baseline_risk_score
  )

cat("\n=== GENDER CONTEXT (vs Population Baseline) ===\n")
neat(gender_context)

# ---- layer-3-visualizations ----
# Baseline comparison visualizations

# Age group baseline comparison heatmap
age_baseline_long <- age_group_context %>%
  select(age_group, crisis_vs_baseline, housing_vs_baseline, substance_vs_baseline,
         mental_health_vs_baseline, employment_vs_baseline, family_vs_baseline) %>%
  pivot_longer(-age_group, names_to = "risk_type", values_to = "vs_baseline") %>%
  mutate(
    risk_type = str_remove(risk_type, "_vs_baseline"),
    risk_type = str_replace_all(risk_type, "_", " "),
    risk_type = str_to_title(risk_type),
    vs_baseline_category = case_when(
      vs_baseline < 0.8 ~ "Much Below (-20%+)",
      vs_baseline < 0.95 ~ "Below (-5 to -20%)",
      vs_baseline <= 1.05 ~ "At Baseline (±5%)",
      vs_baseline <= 1.2 ~ "Above (+5 to +20%)",
      TRUE ~ "Much Above (+20%+)"
    )
  )

g11_age_baseline <- age_baseline_long %>%
  ggplot(aes(x = risk_type, y = age_group, fill = vs_baseline)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = round(vs_baseline, 2)), fontface = "bold") +
  scale_fill_gradient2(
    low = "#2E8B57", mid = "white", high = "#DC143C",
    midpoint = 1, name = "vs Baseline"
  ) +
  labs(
    title = "Age Group Risk Patterns vs Population Baseline",
    subtitle = "Values >1 = Above baseline, <1 = Below baseline",
    x = "Risk Type", y = "Age Group"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(size = 14, face = "bold")
  )

print(g11_age_baseline)
ggsave(g11_age_baseline, filename = paste0(prints_folder, "g11-age-baseline-comparison.png"),
       width = 10, height = 6, dpi = 300)

# Geographic risk profile comparison
geo_baseline_long <- geographic_context %>%
  select(location, crisis_vs_baseline, housing_vs_baseline, substance_vs_baseline,
         mental_health_vs_baseline, risk_score_vs_baseline) %>%
  pivot_longer(-location, names_to = "metric", values_to = "vs_baseline") %>%
  mutate(
    metric = str_remove(metric, "_vs_baseline"),
    metric = str_replace_all(metric, "_", " "),
    metric = str_to_title(metric)
  )

g12_geo_baseline <- geo_baseline_long %>%
  ggplot(aes(x = location, y = vs_baseline, fill = metric)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "black") +
  labs(
    title = "Geographic Risk Patterns vs Population Baseline",
    subtitle = "Horizontal line = Population baseline (1.0)",
    x = "Location", y = "Rate vs Baseline",
    fill = "Risk Metric"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(size = 14, face = "bold")
  )

print(g12_geo_baseline)
ggsave(g12_geo_baseline, filename = paste0(prints_folder, "g12-geographic-baseline.png"),
       width = 10, height = 6, dpi = 300)

# ---- layer-3-risk-stratification ----
# Create risk stratification framework
df_layer3 <- df_layer2 %>%
  mutate(
    # Risk tier classification
    risk_tier = case_when(
      risk_score == 0 ~ "No Risk Flags",
      risk_score <= 0.17 ~ "Low Risk (1 flag)",
      risk_score <= 0.33 ~ "Moderate Risk (2 flags)",
      risk_score <= 0.50 ~ "High Risk (3 flags)",
      TRUE ~ "Very High Risk (4+ flags)"
    ),
    risk_tier = factor(risk_tier, levels = c(
      "No Risk Flags", "Low Risk (1 flag)", "Moderate Risk (2 flags)",
      "High Risk (3 flags)", "Very High Risk (4+ flags)"
    )),
    
    # Individual case positioning within age group
    age_group_percentile = ave(risk_score, age_group, 
                              FUN = function(x) rank(x) / length(x) * 100)
  )

# Risk tier distribution
risk_tier_summary <- df_layer3 %>%
  count(risk_tier) %>%
  mutate(percentage = n / sum(n) * 100)

cat("\n=== RISK TIER DISTRIBUTION ===\n")
neat(risk_tier_summary)

g13_risk_tiers <- df_layer3 %>%
  count(risk_tier) %>%
  mutate(percentage = n / sum(n)) %>%
  ggplot(aes(x = risk_tier, y = n, fill = risk_tier)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = paste0(n, "\n(", scales::percent(percentage, accuracy = 0.1), ")")),
            vjust = -0.5, fontface = "bold") +
  labs(
    title = "Risk Tier Distribution Across Population",
    x = "Risk Tier", y = "Count",
    fill = "Risk Tier"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold")
  )

print(g13_risk_tiers)
ggsave(g13_risk_tiers, filename = paste0(prints_folder, "g13-risk-tier-distribution.png"),
       width = 10, height = 6, dpi = 300)

# ---- layer-3-individual-positioning ----
# Example: Position individuals within their reference groups
high_risk_cases <- df_layer3 %>%
  filter(risk_score >= 0.5) %>%
  select(person_oid, age, gender, location, age_group, risk_score, 
         age_group_percentile, risk_tier) %>%
  arrange(desc(risk_score))

cat("\n=== HIGH RISK CASES (Risk Score >= 0.5) ===\n")
cat("Showing top 10 highest risk cases with contextual positioning:\n")
neat(head(high_risk_cases, 10))

# ---- layer-3-summary --------
cat("\n=== LAYER 3 SUMMARY: CONTEXTUAL INTERPRETATION COMPLETE ===\n")
cat("✓ Population baseline established for all risk metrics\n")
cat("✓ Age group context: Relative risk patterns identified\n")
cat("✓ Geographic context: Location-based risk variations mapped\n")
cat("✓ Gender context: Gender-specific risk patterns analyzed\n")
cat("✓ Risk stratification: 5-tier classification system created\n")
cat("✓ Individual positioning: Percentile rankings within reference groups\n")
cat("✓ High risk cases identified:", nrow(high_risk_cases), "cases with risk score >= 0.5\n")

# Save final Layer 3 dataset
write_csv(df_layer3, paste0(local_data, "layer3_contextual_data.csv"))
cat("✓ Final Layer 3 data saved with all contextual variables\n")

# ===================================================================
# SUMMARY AND FINAL ANALYSIS
# ===================================================================

# ---- comprehensive-summary ----
cat("\n", paste(rep("=", 78), collapse = ""), "\n")
cat("COMPREHENSIVE THREE-LAYER ANALYSIS COMPLETE\n")
cat(paste(rep("=", 78), collapse = ""), "\n")

# Create comprehensive summary
final_summary <- data.frame(
  Metric = c(
    "Total Cases Analyzed",
    "Mean Age (years)",
    "Gender Distribution",
    "Location Count",
    "Mean Note Length (chars)",
    "Mean Word Count",
    "Overall Crisis Rate (%)",
    "Overall Housing Risk (%)",
    "Overall Substance Risk (%)",
    "Overall Mental Health Risk (%)",
    "Mean Risk Score (0-1)",
    "High Risk Cases (≥0.5)",
    "Multiple Issues Rate (%)"
  ),
  Value = c(
    nrow(df_layer3),
    round(mean(df_layer3$age, na.rm = TRUE), 1),
    paste(unique(df_layer3$gender), collapse = ", "),
    length(unique(df_layer3$location)),
    round(mean(df_layer3$note_length, na.rm = TRUE), 0),
    round(mean(df_layer3$note_word_count, na.rm = TRUE), 0),
    round(mean(df_layer3$flag_crisis) * 100, 1),
    round(mean(df_layer3$flag_housing) * 100, 1),
    round(mean(df_layer3$flag_substance) * 100, 1),
    round(mean(df_layer3$flag_mental_health) * 100, 1),
    round(mean(df_layer3$risk_score), 3),
    sum(df_layer3$risk_score >= 0.5),
    round(mean(df_layer3$has_multiple_issues) * 100, 1)
  )
)

neat(final_summary)

# ---- export-for-python-nlp ----
# Prepare data for Python NLP processing
nlp_export <- df_layer3 %>%
  select(person_oid, case_note, age, gender, location, age_group,
         note_length, note_word_count, risk_score, risk_tier) %>%
  mutate(note_id = row_number())

write_csv(nlp_export, paste0(local_data, "notes_for_nlp_processing.csv"))
cat("\n✓ Data prepared for Python NLP processing:", nrow(nlp_export), "cases\n")
cat("✓ Export saved to:", paste0(local_data, "notes_for_nlp_processing.csv"), "\n")

# ---- analysis-recommendations ----
cat("\n=== ANALYSIS RECOMMENDATIONS ===\n")
cat("Based on this three-layer analysis, consider:\n\n")

cat("1. HIGH PRIORITY CASES:\n")
cat("   -", sum(df_layer3$risk_score >= 0.5), "cases with risk score ≥ 0.5 need immediate attention\n")
cat("   -", sum(df_layer3$flag_crisis), "cases flagged for crisis intervention\n")
cat("   -", sum(df_layer3$has_multiple_issues), "cases with multiple concurrent issues\n\n")

cat("2. DEMOGRAPHIC PATTERNS:\n")
highest_risk_age <- age_group_context$age_group[which.max(age_group_context$avg_risk_score)]
cat("   - Highest risk age group:", highest_risk_age, "\n")
highest_risk_location <- geographic_context$location[which.max(geographic_context$avg_risk_score)]
cat("   - Highest risk location:", highest_risk_location, "\n\n")

cat("3. INTERVENTION FOCUS AREAS:\n")
top_risk_types <- c("Crisis", "Housing", "Substance", "Mental Health")
risk_rates <- c(
  mean(df_layer3$flag_crisis) * 100,
  mean(df_layer3$flag_housing) * 100,
  mean(df_layer3$flag_substance) * 100,
  mean(df_layer3$flag_mental_health) * 100
)
names(risk_rates) <- top_risk_types
sorted_risks <- sort(risk_rates, decreasing = TRUE)

for (i in 1:length(sorted_risks)) {
  cat("   -", names(sorted_risks)[i], "issues:", round(sorted_risks[i], 1), "% prevalence\n")
}

# ---- files-created-summary ----
cat("\n=== FILES CREATED ===\n")
cat("Visualizations saved to:", prints_folder, "\n")
created_plots <- c(
  "g01-age-distribution.png",
  "g02-age-groups.png", 
  "g03-gender-distribution.png",
  "g04-location-distribution.png",
  "g05-note-length.png",
  "g06-word-count.png",
  "g07-demographics-combined.png",
  "g08-risk-flag-prevalence.png",
  "g09-risk-by-age.png",
  "g10-risk-score-distribution.png",
  "g11-age-baseline-comparison.png",
  "g12-geographic-baseline.png",
  "g13-risk-tier-distribution.png"
)

for (plot in created_plots) {
  cat("  ✓", plot, "\n")
}

cat("\nData files saved to:", local_data, "\n")
created_data <- c(
  "layer1_input_data.csv",
  "layer2_analytical_data.csv", 
  "layer3_contextual_data.csv",
  "notes_for_nlp_processing.csv"
)

for (data_file in created_data) {
  cat("  ✓", data_file, "\n")
}

# ---- interactive-functions ----
# Helper functions for interactive exploration

view_high_risk_cases <- function(min_risk_score = 0.5, n_cases = 10) {
  df_layer3 %>%
    filter(risk_score >= min_risk_score) %>%
    select(person_oid, age, gender, location, risk_score, risk_tier, 
           flag_crisis, flag_housing, flag_substance, flag_mental_health) %>%
    arrange(desc(risk_score)) %>%
    head(n_cases) %>%
    neat()
}

analyze_subgroup <- function(filter_column, filter_value) {
  subgroup_data <- df_layer3 %>%
    filter(!!sym(filter_column) == filter_value)
  
  cat("=== SUBGROUP ANALYSIS:", filter_column, "=", filter_value, "===\n")
  cat("Sample size:", nrow(subgroup_data), "\n")
  cat("Mean risk score:", round(mean(subgroup_data$risk_score), 3), "\n")
  cat("Crisis rate:", round(mean(subgroup_data$flag_crisis) * 100, 1), "%\n")
  cat("Housing rate:", round(mean(subgroup_data$flag_housing) * 100, 1), "%\n")
  cat("Substance rate:", round(mean(subgroup_data$flag_substance) * 100, 1), "%\n")
  cat("Mental health rate:", round(mean(subgroup_data$flag_mental_health) * 100, 1), "%\n")
}

# Quick data access functions
get_layer1_data <- function() read_csv(paste0(local_data, "layer1_input_data.csv"), show_col_types = FALSE)
get_layer2_data <- function() read_csv(paste0(local_data, "layer2_analytical_data.csv"), show_col_types = FALSE)  
get_layer3_data <- function() read_csv(paste0(local_data, "layer3_contextual_data.csv"), show_col_types = FALSE)

cat("\n=== INTERACTIVE FUNCTIONS AVAILABLE ===\n")
cat("Use these functions to explore the data further:\n")
cat("  • view_high_risk_cases(min_risk_score = 0.5, n_cases = 10)\n")
cat("  • analyze_subgroup('age_group', 'Young Adult (18-24)')\n")
cat("  • get_layer1_data() # Access Layer 1 dataset\n")
cat("  • get_layer2_data() # Access Layer 2 dataset\n")
cat("  • get_layer3_data() # Access Layer 3 dataset\n")

cat("\n", paste(rep("=", 78), collapse = ""), "\n") 
cat("THREE-LAYER CASE NOTE ANALYSIS FRAMEWORK COMPLETE\n")
cat("Ready for Python NLP enhancement and reporting\n")
cat(paste(rep("=", 78), collapse = ""), "\n")