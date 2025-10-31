rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run
cat("\014") # Clear the console
# verify root location
cat("Working directory: ", getwd()) # Must be set to Project Directory

# Synthetic Case Note Analysis - Take 3 Demo
# Analysis pipeline for synthetic case notes generated from ABC workflow

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
library(jsonlite)  # JSON handling
library(purrr)     # functional programming

# ---- load-sources ---------------
# Load project-level functions if available
tryCatch({
  base::source("./scripts/common-functions.R") # project-level
}, error = function(e) {
  cat("Note: common-functions.R not found, proceeding without\n")
})

# Local functions for this analysis
source("./analysis/take-3-demo/functions-take-3.R")

# ---- declare-globals --------------
# Declare global constants and paths
path_input_csv <- "./analysis/take-3-demo/output/synthetic-case-notes.csv"
path_input_json <- "./analysis/take-3-demo/output/synthetic-case-notes.json"
path_output_reports <- "./analysis/take-3-demo/reports/"
path_output_prints <- "./analysis/take-3-demo/prints/"
path_output_figures <- "./analysis/take-3-demo/figure-png-iso/"

# Create output directories if they don't exist
fs::dir_create(path_output_reports)
fs::dir_create(path_output_prints)
fs::dir_create(path_output_figures)

# Color palette for visualizations
color_palette <- c(
  "#2E86AB", "#A23B72", "#F18F01", "#C73E1D",
  "#592E83", "#F79D84", "#6A994E", "#4C956C"
)

# ---- load-data ---------------------
cat("Loading synthetic case notes data...\n")

# Load the CSV data
if (file.exists(path_input_csv)) {
  case_notes <- readr::read_csv(path_input_csv, show_col_types = FALSE)
  cat("✅ Loaded", nrow(case_notes), "case notes from CSV\n")
} else {
  stop("❌ Synthetic case notes CSV not found. Please run the Python generator first.")
}

# Load metadata from JSON
if (file.exists(path_input_json)) {
  json_data <- jsonlite::fromJSON(path_input_json)
  metadata <- json_data$metadata
  cat("✅ Loaded metadata from JSON\n")
} else {
  warning("⚠️  JSON metadata not found, proceeding without")
  metadata <- list()
}

# ---- inspect-data ------------------
cat("\n=== DATA INSPECTION ===\n")
cat("Dataset dimensions:", nrow(case_notes), "rows ×", ncol(case_notes), "columns\n")
cat("Data generation date:", ifelse(is.null(metadata$generation_date), "Unknown", metadata$generation_date), "\n")

# Display column structure
cat("\nColumn structure:\n")
str(case_notes)

# Display first few rows
cat("\nFirst 5 rows:\n")
print(head(case_notes, 5))

# ---- prepare-data ------------------
cat("\n=== DATA PREPARATION ===\n")

# Prepare embedded scenarios as proper lists
case_notes <- case_notes %>%
  mutate(
    # Parse embedded scenarios from comma-separated string
    embedded_scenarios_list = map(embedded_scenarios, ~{
      if(is.na(.x) || .x == "") return(character(0))
      str_split(.x, ",")[[1]] %>% str_trim()
    }),
    
    # Create indicator columns for key scenarios
    has_housing_crisis = map_lgl(embedded_scenarios_list, ~"housing_crisis" %in% .x),
    has_mental_health_decline = map_lgl(embedded_scenarios_list, ~"mental_health_deterioration" %in% .x),
    has_service_success = map_lgl(embedded_scenarios_list, ~"successful_service_connection" %in% .x),
    
    # Create age groups
    age_group = case_when(
      age >= 18 & age <= 24 ~ "18-24",
      age >= 25 & age <= 34 ~ "25-34", 
      age >= 35 & age <= 44 ~ "35-44",
      age >= 45 & age <= 54 ~ "45-54",
      age >= 55 & age <= 64 ~ "55-64",
      TRUE ~ "Other"
    ),
    
    # Create complexity labels
    complexity_label = case_when(
      complexity_level == 1 ~ "1-Stable",
      complexity_level == 2 ~ "2-Moderate", 
      complexity_level == 3 ~ "3-High",
      complexity_level == 4 ~ "4-Crisis",
      TRUE ~ "Unknown"
    ),
    
    # Calculate case note length
    note_length = nchar(case_note),
    note_length_category = case_when(
      note_length <= 150 ~ "Brief (≤150)",
      note_length <= 400 ~ "Standard (151-400)",
      note_length > 400 ~ "Comprehensive (>400)",
      TRUE ~ "Unknown"
    )
  )

cat("✅ Data preparation completed\n")
cat("Added scenario indicators and derived variables\n")

# ---- generate-visualizations --------
cat("\n=== GENERATING VISUALIZATIONS ===\n")

# 1. Demographics Overview Dashboard
p1_demographics <- create_demographics_overview(case_notes)
save_visualization(p1_demographics, "01-demographics-overview", path_output_figures)
cat("✅ 1. Demographics overview\n")

# 2. Complexity Distribution Analysis  
p2_complexity <- create_complexity_analysis(case_notes)
save_visualization(p2_complexity, "02-complexity-distribution", path_output_figures)
cat("✅ 2. Complexity distribution\n")

# 3. Risk Scenario Distribution
p3_scenarios <- create_scenario_analysis(case_notes)
save_visualization(p3_scenarios, "03-risk-scenarios", path_output_figures)
cat("✅ 3. Risk scenarios\n")

# 4. Case Note Length Analysis
p4_length <- create_length_analysis(case_notes)
save_visualization(p4_length, "04-case-note-length", path_output_figures)
cat("✅ 4. Case note length\n")

# 5. Writer Style Impact
p5_writer <- create_writer_analysis(case_notes)
save_visualization(p5_writer, "05-writer-style-impact", path_output_figures)
cat("✅ 5. Writer style analysis\n")

# 6. Geographic Distribution
p6_geography <- create_geographic_analysis(case_notes)
save_visualization(p6_geography, "06-geographic-distribution", path_output_figures)
cat("✅ 6. Geographic analysis\n")

# 7. Ethnicity and Demographics Cross-Analysis
p7_ethnicity <- create_ethnicity_analysis(case_notes)
save_visualization(p7_ethnicity, "07-ethnicity-demographics", path_output_figures)
cat("✅ 7. Ethnicity analysis\n")

# 8. Employment and Family Structure
p8_socioeconomic <- create_socioeconomic_analysis(case_notes)
save_visualization(p8_socioeconomic, "08-socioeconomic-factors", path_output_figures)
cat("✅ 8. Socioeconomic analysis\n")

# 9. Archetype Performance Analysis  
p9_archetypes <- create_archetype_analysis(case_notes)
save_visualization(p9_archetypes, "09-archetype-performance", path_output_figures)
cat("✅ 9. Archetype analysis\n")

# 10. Quality Validation Dashboard
p10_quality <- create_quality_validation(case_notes, metadata)
save_visualization(p10_quality, "10-quality-validation", path_output_figures)
cat("✅ 10. Quality validation\n")

# ---- generate-summary-stats ----------
cat("\n=== GENERATING SUMMARY STATISTICS ===\n")

summary_stats <- generate_summary_statistics(case_notes, metadata)
write_lines(summary_stats, file.path(path_output_reports, "summary-statistics.txt"))
cat("✅ Summary statistics exported\n")

# ---- generate-validation-results -----
cat("\n=== VALIDATION ANALYSIS ===\n")

validation_results <- perform_validation_analysis(case_notes, metadata)
write_csv(validation_results, file.path(path_output_reports, "validation-results.csv"))
cat("✅ Validation results exported\n")

# ---- create-dashboard ----------------
cat("\n=== CREATING DASHBOARD ===\n")

# Create comprehensive dashboard combining key visualizations
dashboard <- create_comprehensive_dashboard(
  case_notes, 
  list(p1_demographics, p2_complexity, p3_scenarios, p4_length, 
       p5_writer, p6_geography, p7_ethnicity, p8_socioeconomic, 
       p9_archetypes, p10_quality)
)

save_visualization(dashboard, "00-comprehensive-dashboard", path_output_figures, width = 16, height = 20)
cat("✅ Comprehensive dashboard created\n")

# ---- export-final-report -------------
cat("\n=== FINALIZING OUTPUTS ===\n")

# Export processed dataset
write_csv(case_notes, file.path(path_output_reports, "processed-case-notes.csv"))
cat("✅ Processed dataset exported\n")

# Create executive summary
exec_summary <- create_executive_summary(case_notes, metadata, validation_results)
write_lines(exec_summary, file.path(path_output_reports, "executive-summary.md"))
cat("✅ Executive summary created\n")

# Performance metrics
end_time <- Sys.time()
processing_time <- as.numeric(difftime(end_time, Sys.time(), units = "secs"))

cat("\n", paste(rep("=", 50), collapse=""), "\n")  
cat("✅ ANALYSIS COMPLETE!\n")
cat("📊 Generated", nrow(case_notes), "case note analyses\n")
cat("📈 Created 10 visualization sets + comprehensive dashboard\n")
cat("📋 Exported validation results and summary statistics\n")
cat("📁 All outputs saved to:", path_output_reports, "\n")
cat("🖼️  Figures saved to:", path_output_figures, "\n")
cat(paste(rep("=", 50), collapse=""), "\n")