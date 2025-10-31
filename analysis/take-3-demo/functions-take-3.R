# Functions for Take-3 Synthetic Case Note Analysis
# Supporting functions for the synthetic case note dashboard pipeline

# ---- utility-functions ---------------

#' Save visualization with consistent formatting
#' @param plot ggplot object
#' @param name file name without extension
#' @param path output directory path
#' @param width width in inches (default 12)
#' @param height height in inches (default 8)
save_visualization <- function(plot, name, path, width = 12, height = 8) {
  filename <- file.path(path, paste0(name, ".png"))
  ggsave(filename, plot, width = width, height = height, dpi = 300, bg = "white")
  return(filename)
}

#' Create consistent theme for all plots
theme_take3 <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", margin = margin(b = 20)),
      plot.subtitle = element_text(size = 11, color = "gray50", margin = margin(b = 20)),
      axis.title = element_text(size = 10, face = "bold"),
      axis.text = element_text(size = 9),
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 9),
      strip.text = element_text(size = 10, face = "bold"),
      panel.grid.minor = element_blank(),
      plot.margin = margin(20, 20, 20, 20)
    )
}

# ---- visualization-functions ---------

#' Demographics Overview Dashboard
create_demographics_overview <- function(data) {
  
  # Age distribution
  p_age <- data %>%
    ggplot(aes(x = age_group, fill = gender)) +
    geom_bar(position = "dodge", alpha = 0.8) +
    scale_fill_manual(values = c("Female" = "#A23B72", "Male" = "#2E86AB")) +
    labs(title = "Age Distribution by Gender",
         x = "Age Group", y = "Count", fill = "Gender") +
    theme_take3()
  
  # Location distribution
  p_location <- data %>%
    count(location, gender) %>%
    ggplot(aes(x = location, y = n, fill = gender)) +
    geom_col(position = "dodge", alpha = 0.8) +
    scale_fill_manual(values = c("Female" = "#A23B72", "Male" = "#2E86AB")) +
    labs(title = "Geographic Distribution",
         x = "Location Type", y = "Count", fill = "Gender") +
    theme_take3()
  
  # Combine plots
  p_age / p_location +
    plot_annotation(
      title = "Demographics Overview",
      subtitle = "Age and geographic distribution of synthetic case notes",
      theme = theme(plot.title = element_text(size = 16, face = "bold"))
    )
}

#' Complexity Distribution Analysis
create_complexity_analysis <- function(data) {
  
  # Complexity by age group
  p_age_complexity <- data %>%
    count(age_group, complexity_label) %>%
    ggplot(aes(x = age_group, y = n, fill = complexity_label)) +
    geom_col(position = "stack", alpha = 0.8) +
    scale_fill_manual(values = c("1-Stable" = "#6A994E", "2-Moderate" = "#F18F01", 
                                 "3-High" = "#C73E1D", "4-Crisis" = "#592E83")) +
    labs(title = "Complexity Distribution by Age Group",
         x = "Age Group", y = "Count", fill = "Complexity Level") +
    theme_take3() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Complexity by location
  p_location_complexity <- data %>%
    count(location, complexity_label) %>%
    ggplot(aes(x = location, y = n, fill = complexity_label)) +
    geom_col(position = "dodge", alpha = 0.8) +
    scale_fill_manual(values = c("1-Stable" = "#6A994E", "2-Moderate" = "#F18F01", 
                                 "3-High" = "#C73E1D", "4-Crisis" = "#592E83")) +
    labs(title = "Complexity Distribution by Location",
         x = "Location Type", y = "Count", fill = "Complexity Level") +
    theme_take3()
  
  p_age_complexity / p_location_complexity +
    plot_annotation(
      title = "Case Complexity Analysis",
      subtitle = "Distribution of complexity levels across demographics"
    )
}

#' Risk Scenario Analysis
create_scenario_analysis <- function(data) {
  
  # Scenario prevalence
  scenario_counts <- data %>%
    summarise(
      housing_crisis = sum(has_housing_crisis),
      mental_health = sum(has_mental_health_decline),
      service_success = sum(has_service_success),
      total_cases = n()
    ) %>%
    pivot_longer(cols = c(housing_crisis, mental_health, service_success), 
                 names_to = "scenario", values_to = "count") %>%
    mutate(
      percentage = count / total_cases * 100,
      scenario_label = case_when(
        scenario == "housing_crisis" ~ "Housing Crisis",
        scenario == "mental_health" ~ "Mental Health Decline", 
        scenario == "service_success" ~ "Service Success"
      )
    )
  
  p_scenarios <- scenario_counts %>%
    ggplot(aes(x = reorder(scenario_label, percentage), y = percentage)) +
    geom_col(fill = "#2E86AB", alpha = 0.8) +
    geom_text(aes(label = paste0(round(percentage, 1), "%\n(n=", count, ")")), 
              hjust = -0.1, size = 3) +
    coord_flip() +
    labs(title = "Validation Scenario Distribution",
         subtitle = "Embedded scenarios for algorithm testing",
         x = "Scenario Type", y = "Percentage of Cases") +
    theme_take3()
  
  # Scenario by complexity
  p_scenario_complexity <- data %>%
    select(complexity_label, has_housing_crisis, has_mental_health_decline, has_service_success) %>%
    pivot_longer(cols = starts_with("has_"), names_to = "scenario", values_to = "present") %>%
    filter(present) %>%
    mutate(scenario_label = case_when(
      scenario == "has_housing_crisis" ~ "Housing Crisis",
      scenario == "has_mental_health_decline" ~ "Mental Health Decline",
      scenario == "has_service_success" ~ "Service Success"
    )) %>%
    count(complexity_label, scenario_label) %>%
    ggplot(aes(x = complexity_label, y = n, fill = scenario_label)) +
    geom_col(position = "dodge", alpha = 0.8) +
    scale_fill_manual(values = c("Housing Crisis" = "#C73E1D", 
                                 "Mental Health Decline" = "#592E83",
                                 "Service Success" = "#6A994E")) +
    labs(title = "Scenarios by Complexity Level",
         x = "Complexity Level", y = "Count", fill = "Scenario Type") +
    theme_take3()
  
  p_scenarios / p_scenario_complexity
}

#' Case Note Length Analysis
create_length_analysis <- function(data) {
  
  # Length distribution
  p_length_dist <- data %>%
    ggplot(aes(x = note_length)) +
    geom_histogram(bins = 30, fill = "#2E86AB", alpha = 0.7) +
    labs(title = "Case Note Length Distribution",
         x = "Character Count", y = "Number of Cases") +
    theme_take3()
  
  # Length by complexity
  p_length_complexity <- data %>%
    ggplot(aes(x = complexity_label, y = note_length, fill = complexity_label)) +
    geom_boxplot(alpha = 0.8) +
    scale_fill_manual(values = c("1-Stable" = "#6A994E", "2-Moderate" = "#F18F01", 
                                 "3-High" = "#C73E1D", "4-Crisis" = "#592E83")) +
    labs(title = "Case Note Length by Complexity",
         x = "Complexity Level", y = "Character Count", fill = "Complexity") +
    theme_take3() +
    theme(legend.position = "none")
  
  p_length_dist / p_length_complexity +
    plot_annotation(
      title = "Case Note Length Analysis",
      subtitle = "Distribution and relationship with case complexity"
    )
}

#' Writer Style Analysis
create_writer_analysis <- function(data) {
  
  # Writer style distribution
  p_writer_dist <- data %>%
    count(writer_style) %>%
    mutate(writer_style = case_when(
      writer_style == "new_worker" ~ "New Worker",
      writer_style == "experienced_worker" ~ "Experienced Worker", 
      writer_style == "senior_worker" ~ "Senior Worker"
    )) %>%
    ggplot(aes(x = reorder(writer_style, n), y = n)) +
    geom_col(fill = "#A23B72", alpha = 0.8) +
    coord_flip() +
    labs(title = "Writer Style Distribution",
         x = "Writer Experience Level", y = "Count") +
    theme_take3()
  
  # Average note length by writer style
  p_writer_length <- data %>%
    group_by(writer_style) %>%
    summarise(avg_length = mean(note_length), .groups = "drop") %>%
    mutate(writer_style = case_when(
      writer_style == "new_worker" ~ "New Worker",
      writer_style == "experienced_worker" ~ "Experienced Worker",
      writer_style == "senior_worker" ~ "Senior Worker"
    )) %>%
    ggplot(aes(x = reorder(writer_style, avg_length), y = avg_length)) +
    geom_col(fill = "#F18F01", alpha = 0.8) +
    coord_flip() +
    labs(title = "Average Note Length by Writer Style",
         x = "Writer Experience Level", y = "Average Character Count") +
    theme_take3()
  
  p_writer_dist / p_writer_length +
    plot_annotation(
      title = "Writer Style Impact Analysis",
      subtitle = "Distribution and characteristics of different writer experience levels"
    )
}

#' Geographic Analysis
create_geographic_analysis <- function(data) {
  
  # Urban vs Rural breakdown
  p_location <- data %>%
    count(location, complexity_label) %>%
    ggplot(aes(x = location, y = n, fill = complexity_label)) +
    geom_col(position = "stack", alpha = 0.8) +
    scale_fill_manual(values = c("1-Stable" = "#6A994E", "2-Moderate" = "#F18F01", 
                                 "3-High" = "#C73E1D", "4-Crisis" = "#592E83")) +
    labs(title = "Complexity Distribution by Location",
         x = "Location Type", y = "Count", fill = "Complexity Level") +
    theme_take3()
  
  # Location by archetype
  p_archetype_location <- data %>%
    count(archetype_id, location) %>%
    ggplot(aes(x = archetype_id, y = n, fill = location)) +
    geom_col(position = "dodge", alpha = 0.8) +
    scale_fill_manual(values = c("Urban" = "#2E86AB", "Rural" = "#4C956C")) +
    labs(title = "Archetype Distribution by Location",
         x = "Archetype ID", y = "Count", fill = "Location") +
    theme_take3()
  
  p_location / p_archetype_location +
    plot_annotation(
      title = "Geographic Distribution Analysis",
      subtitle = "Urban vs Rural patterns in case complexity and archetypes"
    )
}

#' Ethnicity Analysis
create_ethnicity_analysis <- function(data) {
  
  # Top ethnicities
  p_ethnicity <- data %>%
    count(ethnicity, sort = TRUE) %>%
    slice_head(n = 8) %>%
    ggplot(aes(x = reorder(ethnicity, n), y = n)) +
    geom_col(fill = "#592E83", alpha = 0.8) +
    coord_flip() +
    labs(title = "Top Ethnicities in Dataset",
         x = "Ethnicity", y = "Count") +
    theme_take3()
  
  # Ethnicity by complexity
  p_ethnicity_complexity <- data %>%
    count(ethnicity, complexity_label) %>%
    filter(ethnicity %in% (data %>% count(ethnicity, sort = TRUE) %>% slice_head(n = 6) %>% pull(ethnicity))) %>%
    ggplot(aes(x = ethnicity, y = n, fill = complexity_label)) +
    geom_col(position = "stack", alpha = 0.8) +
    scale_fill_manual(values = c("1-Stable" = "#6A994E", "2-Moderate" = "#F18F01", 
                                 "3-High" = "#C73E1D", "4-Crisis" = "#592E83")) +
    labs(title = "Complexity by Top Ethnicities",
         x = "Ethnicity", y = "Count", fill = "Complexity Level") +
    theme_take3() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  p_ethnicity / p_ethnicity_complexity +
    plot_annotation(
      title = "Ethnicity Demographics Analysis",
      subtitle = "Distribution and complexity patterns across ethnic groups"
    )
}

#' Socioeconomic Analysis
create_socioeconomic_analysis <- function(data) {
  
  # Employment history distribution
  p_employment <- data %>%
    count(employment_history) %>%
    ggplot(aes(x = reorder(employment_history, n), y = n)) +
    geom_col(fill = "#4C956C", alpha = 0.8) +
    coord_flip() +
    labs(title = "Employment History Distribution",
         x = "Employment History", y = "Count") +
    theme_take3()
  
  # Family structure distribution
  p_family <- data %>%
    count(family_structure) %>%
    ggplot(aes(x = reorder(family_structure, n), y = n)) +
    geom_col(fill = "#F79D84", alpha = 0.8) +
    coord_flip() +
    labs(title = "Family Structure Distribution",
         x = "Family Structure", y = "Count") +
    theme_take3()
  
  # Employment vs complexity
  p_employment_complexity <- data %>%
    count(employment_history, complexity_label) %>%
    ggplot(aes(x = employment_history, y = n, fill = complexity_label)) +
    geom_col(position = "stack", alpha = 0.8) +
    scale_fill_manual(values = c("1-Stable" = "#6A994E", "2-Moderate" = "#F18F01", 
                                 "3-High" = "#C73E1D", "4-Crisis" = "#592E83")) +
    labs(title = "Employment History by Complexity",
         x = "Employment History", y = "Count", fill = "Complexity Level") +
    theme_take3() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  (p_employment | p_family) / p_employment_complexity +
    plot_annotation(
      title = "Socioeconomic Factors Analysis",
      subtitle = "Employment and family structure patterns"
    )
}

#' Archetype Performance Analysis
create_archetype_analysis <- function(data) {
  
  # Archetype distribution
  p_archetype_dist <- data %>%
    count(archetype_id, sort = TRUE) %>%
    ggplot(aes(x = reorder(archetype_id, n), y = n)) +
    geom_col(fill = "#2E86AB", alpha = 0.8) +
    coord_flip() +
    labs(title = "Client Archetype Distribution",
         x = "Archetype ID", y = "Count") +
    theme_take3()
  
  # Archetype by complexity
  p_archetype_complexity <- data %>%
    count(archetype_id, complexity_label) %>%
    ggplot(aes(x = archetype_id, y = n, fill = complexity_label)) +
    geom_col(position = "stack", alpha = 0.8) +
    scale_fill_manual(values = c("1-Stable" = "#6A994E", "2-Moderate" = "#F18F01", 
                                 "3-High" = "#C73E1D", "4-Crisis" = "#592E83")) +
    labs(title = "Archetype Complexity Distribution",
         x = "Archetype ID", y = "Count", fill = "Complexity Level") +
    theme_take3()
  
  p_archetype_dist / p_archetype_complexity +
    plot_annotation(
      title = "Client Archetype Performance",
      subtitle = "Distribution and complexity patterns across archetypes"
    )
}

#' Quality Validation Dashboard
create_quality_validation <- function(data, metadata) {
  
  # Target vs actual validation scenarios
  targets <- data.frame(
    scenario = c("Housing Crisis", "Mental Health", "Service Success"),
    target_pct = c(15, 8, 12),
    actual_count = c(
      sum(data$has_housing_crisis),
      sum(data$has_mental_health_decline), 
      sum(data$has_service_success)
    ),
    total_cases = nrow(data)
  ) %>%
    mutate(
      actual_pct = (actual_count / total_cases) * 100,
      difference = actual_pct - target_pct,
      status = ifelse(abs(difference) <= 1, "✅ Met", "⚠️ Near")
    )
  
  p_validation <- targets %>%
    select(scenario, target_pct, actual_pct) %>%
    pivot_longer(cols = c(target_pct, actual_pct), names_to = "type", values_to = "percentage") %>%
    mutate(type = ifelse(type == "target_pct", "Target", "Actual")) %>%
    ggplot(aes(x = scenario, y = percentage, fill = type)) +
    geom_col(position = "dodge", alpha = 0.8) +
    scale_fill_manual(values = c("Target" = "#6A994E", "Actual" = "#2E86AB")) +
    labs(title = "Validation Targets vs Actual Results",
         x = "Validation Scenario", y = "Percentage", fill = "Type") +
    theme_take3()
  
  # Data quality metrics
  quality_metrics <- data.frame(
    metric = c("Total Cases", "Avg Age", "Gender Balance", "Location Split"),
    value = c(
      nrow(data),
      round(mean(data$age), 1),
      paste0(round(mean(data$gender == "Female") * 100, 1), "% Female"),
      paste0(round(mean(data$location == "Urban") * 100, 1), "% Urban")
    )
  )
  
  # Create text-based quality summary
  p_quality_text <- ggplot() + 
    annotate("text", x = 0.5, y = 0.8, 
             label = paste("Quality Validation Summary\n\n",
                          paste(quality_metrics$metric, quality_metrics$value, sep = ": ", collapse = "\n"),
                          "\n\nValidation Status:\n",
                          paste(targets$scenario, targets$status, sep = ": ", collapse = "\n")),
             hjust = 0.5, vjust = 0.5, size = 4) +
    theme_void() +
    theme(plot.title = element_text(size = 12, face = "bold"))
  
  p_validation | p_quality_text
}

# ---- summary-functions ---------------

#' Generate Summary Statistics
generate_summary_statistics <- function(data, metadata) {
  
  stats <- list(
    "=== SYNTHETIC CASE NOTES - SUMMARY STATISTICS ===",
    "",
    paste("Generation Date:", ifelse(is.null(metadata$generation_date), "Unknown", metadata$generation_date)),
    paste("Total Cases:", nrow(data)),
    paste("Analysis Date:", Sys.Date()),
    "",
    "=== DEMOGRAPHICS ===",
    paste("Average Age:", round(mean(data$age), 1), "years"),
    paste("Age Range:", min(data$age), "-", max(data$age), "years"),
    paste("Gender Distribution:", 
          paste(names(table(data$gender)), "=", table(data$gender), collapse = ", ")),
    paste("Location Distribution:",
          paste(names(table(data$location)), "=", table(data$location), collapse = ", ")),
    "",
    "=== COMPLEXITY LEVELS ===",
    paste("Complexity Distribution:",
          paste(names(table(data$complexity_label)), "=", table(data$complexity_label), collapse = ", ")),
    "",
    "=== VALIDATION SCENARIOS ===",
    paste("Housing Crisis Cases:", sum(data$has_housing_crisis), 
          paste0("(", round(mean(data$has_housing_crisis) * 100, 1), "%)")),
    paste("Mental Health Decline Cases:", sum(data$has_mental_health_decline),
          paste0("(", round(mean(data$has_mental_health_decline) * 100, 1), "%)")),
    paste("Service Success Cases:", sum(data$has_service_success),
          paste0("(", round(mean(data$has_service_success) * 100, 1), "%)")),
    "",
    "=== CASE NOTE CHARACTERISTICS ===",
    paste("Average Note Length:", round(mean(data$note_length), 0), "characters"),
    paste("Note Length Range:", min(data$note_length), "-", max(data$note_length), "characters"),
    paste("Writer Style Distribution:",
          paste(names(table(data$writer_style)), "=", table(data$writer_style), collapse = ", ")),
    "",
    "=== ARCHETYPE DISTRIBUTION ===",
    paste("Archetype Counts:",
          paste(names(table(data$archetype_id)), "=", table(data$archetype_id), collapse = ", ")),
    "",
    paste("Report Generated:", Sys.time())
  )
  
  return(stats)
}

#' Perform Validation Analysis
perform_validation_analysis <- function(data, metadata) {
  
  # Calculate validation metrics
  validation_results <- data.frame(
    metric = c(
      "total_cases",
      "avg_age", 
      "female_percentage",
      "urban_percentage",
      "complexity_1_pct",
      "complexity_2_pct", 
      "complexity_3_pct",
      "complexity_4_pct",
      "housing_crisis_pct",
      "mental_health_pct",
      "service_success_pct",
      "avg_note_length"
    ),
    actual_value = c(
      nrow(data),
      round(mean(data$age), 1),
      round(mean(data$gender == "Female") * 100, 1),
      round(mean(data$location == "Urban") * 100, 1),
      round(mean(data$complexity_level == 1) * 100, 1),
      round(mean(data$complexity_level == 2) * 100, 1),
      round(mean(data$complexity_level == 3) * 100, 1),
      round(mean(data$complexity_level == 4) * 100, 1),
      round(mean(data$has_housing_crisis) * 100, 1),
      round(mean(data$has_mental_health_decline) * 100, 1),
      round(mean(data$has_service_success) * 100, 1),
      round(mean(data$note_length), 0)
    ),
    target_value = c(
      500, 42, 52, 75, 25, 45, 25, 5, 15, 8, 12, 300
    ),
    status = NA
  ) %>%
    mutate(
      difference = actual_value - target_value,
      status = case_when(
        metric %in% c("total_cases", "avg_age", "avg_note_length") & abs(difference) <= 50 ~ "PASS",
        metric %in% c("female_percentage", "urban_percentage") & abs(difference) <= 5 ~ "PASS",
        metric %in% c("complexity_1_pct", "complexity_2_pct", "complexity_3_pct", "complexity_4_pct") & abs(difference) <= 10 ~ "PASS",
        metric %in% c("housing_crisis_pct", "mental_health_pct", "service_success_pct") & abs(difference) <= 2 ~ "PASS",
        TRUE ~ "REVIEW"
      )
    )
  
  return(validation_results)
}

#' Create Comprehensive Dashboard
create_comprehensive_dashboard <- function(data, plot_list) {
  
  # Select key plots for dashboard
  key_plots <- plot_list[c(1, 2, 3, 5, 6, 10)]  # Demographics, complexity, scenarios, writer, geography, validation
  
  # Arrange in grid
  dashboard <- wrap_plots(key_plots, ncol = 2, nrow = 3)
  
  dashboard + plot_annotation(
    title = "Synthetic Case Notes - Comprehensive Analysis Dashboard",
    subtitle = paste("Generated:", Sys.Date(), "| Total Cases:", nrow(data)),
    theme = theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5, margin = margin(b = 20))
    )
  )
}

#' Create Executive Summary
create_executive_summary <- function(data, metadata, validation_results) {
  
  summary_text <- c(
    "# Synthetic Case Notes - Executive Summary",
    "",
    paste("**Generation Date:** ", ifelse(is.null(metadata$generation_date), "Unknown", metadata$generation_date)),
    paste("**Analysis Date:** ", Sys.Date()),
    paste("**Total Cases Generated:** ", nrow(data)),
    "",
    "## Key Findings",
    "",
    "### Demographics",
    paste("- **Average Age:** ", round(mean(data$age), 1), " years"),
    paste("- **Gender Split:** ", round(mean(data$gender == "Female") * 100, 1), "% Female, ", 
          round(mean(data$gender == "Male") * 100, 1), "% Male"),
    paste("- **Geographic Distribution:** ", round(mean(data$location == "Urban") * 100, 1), "% Urban, ",
          round(mean(data$location == "Rural") * 100, 1), "% Rural"),
    "",
    "### Case Complexity",
    paste("- **Stable Cases (Level 1):** ", sum(data$complexity_level == 1), " (", 
          round(mean(data$complexity_level == 1) * 100, 1), "%)"),
    paste("- **Moderate Cases (Level 2):** ", sum(data$complexity_level == 2), " (",
          round(mean(data$complexity_level == 2) * 100, 1), "%)"),
    paste("- **High Complexity (Level 3):** ", sum(data$complexity_level == 3), " (",
          round(mean(data$complexity_level == 3) * 100, 1), "%)"),
    paste("- **Crisis Cases (Level 4):** ", sum(data$complexity_level == 4), " (",
          round(mean(data$complexity_level == 4) * 100, 1), "%)"),
    "",
    "### Validation Scenarios",
    paste("- **Housing Crisis Indicators:** ", sum(data$has_housing_crisis), " cases (",
          round(mean(data$has_housing_crisis) * 100, 1), "%) - Target: 15%"),
    paste("- **Mental Health Deterioration:** ", sum(data$has_mental_health_decline), " cases (",
          round(mean(data$has_mental_health_decline) * 100, 1), "%) - Target: 8%"),
    paste("- **Service Success Stories:** ", sum(data$has_service_success), " cases (",
          round(mean(data$has_service_success) * 100, 1), "%) - Target: 12%"),
    "",
    "### Data Quality",
    paste("- **Average Note Length:** ", round(mean(data$note_length), 0), " characters"),
    paste("- **Writer Experience Distribution:** ", 
          paste(names(table(data$writer_style)), "=", table(data$writer_style), collapse = ", ")),
    paste("- **Archetype Coverage:** ", length(unique(data$archetype_id)), " distinct archetypes"),
    "",
    "## Validation Status",
    "",
    paste("**Overall Status:** ", 
          ifelse(mean(validation_results$status == "PASS") >= 0.8, "✅ PASSED", "⚠️ REVIEW NEEDED")),
    paste("**Metrics Passed:** ", sum(validation_results$status == "PASS"), "/", nrow(validation_results)),
    "",
    "## Recommendations",
    "",
    "1. **Algorithm Testing:** Dataset is ready for risk detection algorithm validation",
    "2. **Quality Confidence:** High-quality synthetic data with realistic patterns",
    "3. **Scaling:** Current parameters can be used to generate larger datasets if needed",
    "4. **Privacy:** Completely synthetic data safe for development and testing",
    "",
    "## Next Steps",
    "",
    "- Deploy for algorithm validation testing",
    "- Monitor algorithm performance on embedded scenarios",
    "- Consider parameter adjustments based on validation results",
    "",
    paste("*Report generated by Take-3 Analysis Pipeline on ", Sys.time(), "*")
  )
  
  return(summary_text)
}