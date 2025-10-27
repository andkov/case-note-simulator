# ==============================================================================
# STATIC DASHBOARD: Case Note Population Overview
# ==============================================================================
# Purpose: Single-page print dashboard for social services team meetings
# Dimensions: 11" x 8.5" landscape orientation
# Target Audience: Case workers, supervisors, program managers
# Data Source: Synthetic case notes from case-note-simulator project
# ==============================================================================

rm(list = ls(all.names = TRUE)) # Clear environment
cat("\014") # Clear console

# ---- load-packages -----------------------------------------------------------
library(magrittr)     # piping
library(ggplot2)      # plotting
library(dplyr)        # data manipulation
library(tidyr)        # data reshaping
library(stringr)      # string operations
library(scales)       # formatting
library(patchwork)    # multi-panel layouts
library(forcats)      # factor manipulation
library(lubridate)    # date handling
library(ggtext)       # enhanced text rendering

# ---- declare-globals ---------------------------------------------------------
# File paths
input_file <- "./abc/take-2/output/synthetic-case-notes-for-input.csv"
output_dir <- "./analysis/eda-2-casenote/prints/"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# Dashboard specifications
dashboard_width <- 11   # inches
dashboard_height <- 8.5 # inches
dpi_setting <- 300      # print quality
base_font_size <- 10    # minimum readable size

# Professional color palette (colorblind-friendly and print-optimized)
colors_demographic <- c(
  "18-24" = "#2c7fb8",    # Blue
  "25-34" = "#41b6c4",    # Teal  
  "35-44" = "#7fcdbb",    # Light teal
  "45-54" = "#c7e9b4",    # Light green
  "55-64" = "#fec44f",    # Orange
  "65+"   = "#d95f0e"     # Dark orange
)

colors_risk <- c(
  "Crisis" = "#d73027",      # Red
  "Housing" = "#f46d43",     # Orange-red
  "Substance" = "#fdae61",   # Orange
  "Mental Health" = "#fee08b", # Yellow
  "Employment" = "#d9ef8b",   # Light green
  "Family" = "#a6d96a"       # Green
)

colors_gender <- c("Male" = "#4575b4", "Female" = "#d73027", "Other" = "#762a83")
colors_location <- c("#8dd3c7", "#ffffb3", "#bebada", "#fb8072", "#80b1d3", 
                    "#fdb462", "#b3de69", "#fccde5", "#bc80bd", "#ccebc5")

# ---- load-and-prepare-data ---------------------------------------------------
cat("Loading synthetic case notes dataset...\n")

# Load the input dataset (same as used in eda-2-casenote analysis)
ds_input <- read.csv(input_file, stringsAsFactors = FALSE) %>%
  mutate(
    # Standardize age groups (matching eda-2-casenote analysis)
    age_group = case_when(
      age >= 18 & age <= 24 ~ "18-24",
      age >= 25 & age <= 34 ~ "25-34", 
      age >= 35 & age <= 44 ~ "35-44",
      age >= 45 & age <= 54 ~ "45-54",
      age >= 55 & age <= 64 ~ "55-64",
      age >= 65 ~ "65+",
      TRUE ~ "Unknown"
    ) %>% factor(levels = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")),
    
    # Standardize gender 
    gender = factor(gender, levels = c("Male", "Female", "Other")),
    
    # Calculate note characteristics
    note_length = nchar(case_note),
    word_count = str_count(case_note, "\\S+"),
    
    # Create risk flags (matching eda-2-casenote methodology)
    crisis_flag = str_detect(case_note, regex(
      "crisis|emergency|urgent|suicide|self.harm|immediate|911", 
      ignore_case = TRUE
    )),
    
    housing_flag = str_detect(case_note, regex(
      "homeless|evict|housing|shelter|rent|utilities", 
      ignore_case = TRUE
    )),
    
    substance_flag = str_detect(case_note, regex(
      "alcohol|drug|addiction|substance|rehab|detox|sobriety", 
      ignore_case = TRUE  
    )),
    
    mental_health_flag = str_detect(case_note, regex(
      "depression|anxiety|mental|psychiatric|therapy|counseling|medication", 
      ignore_case = TRUE
    )),
    
    employment_flag = str_detect(case_note, regex(
      "job|work|employ|unemployment|income|financial", 
      ignore_case = TRUE
    )),
    
    family_flag = str_detect(case_note, regex(
      "family|child|custody|domestic|relationship|spouse", 
      ignore_case = TRUE
    )),
    
    # Calculate composite risk score (0-1 scale)
    risk_score = (crisis_flag + housing_flag + substance_flag + 
                 mental_health_flag + employment_flag + family_flag) / 6,
    
    # Risk tier classification
    risk_tier = case_when(
      risk_score == 0 ~ "No Risk",
      risk_score <= 0.17 ~ "Low Risk", 
      risk_score <= 0.33 ~ "Moderate Risk",
      risk_score <= 0.67 ~ "High Risk",
      risk_score > 0.67 ~ "Critical Risk"
    ) %>% factor(levels = c("No Risk", "Low Risk", "Moderate Risk", "High Risk", "Critical Risk"))
  )

cat("Dataset loaded:", nrow(ds_input), "case notes\n")
cat("Data source: Synthetic case notes for analysis\n")

# ---- calculate-summary-statistics --------------------------------------------
# Key metrics for dashboard header
total_cases <- nrow(ds_input)
avg_age <- round(mean(ds_input$age, na.rm = TRUE), 1)
gender_breakdown <- ds_input %>% count(gender) %>% 
  mutate(pct = round(n/sum(n)*100, 1)) %>%
  arrange(desc(n))

risk_prevalence <- ds_input %>%
  summarise(
    crisis = mean(crisis_flag) * 100,
    housing = mean(housing_flag) * 100,
    substance = mean(substance_flag) * 100,
    mental_health = mean(mental_health_flag) * 100,
    employment = mean(employment_flag) * 100,
    family = mean(family_flag) * 100
  ) %>%
  round(1)

high_risk_cases <- sum(ds_input$risk_tier %in% c("High Risk", "Critical Risk"))
high_risk_pct <- round(high_risk_cases / total_cases * 100, 1)

# ---- create-dashboard-panels -------------------------------------------------

# Panel 1: Population Demographics Overview 
p1_demographics <- ds_input %>%
  count(age_group, gender) %>%
  ggplot(aes(x = age_group, y = n, fill = gender)) +
  geom_col(position = "stack", alpha = 0.8, color = "black") +
  scale_fill_manual(values = colors_gender) +
  labs(
    title = "Population Demographics",
    subtitle = paste("Total Cases:", format(total_cases, big.mark = ","), 
                    "• Avg Age:", avg_age, "years"),
    x = "Age Group", 
    y = "Number of Cases",
    fill = "Gender"
  ) +
  theme_minimal(base_size = base_font_size) +
  theme(
    legend.position = "right",
    plot.title = element_text(face = "bold", size = base_font_size + 2),
    axis.text.x = element_text(hjust = 0.5)
  )

# Panel 2: Risk Factor Prevalence
p2_risk_flags <- ds_input %>%
  summarise(
    Crisis = mean(crisis_flag) * 100,
    Housing = mean(housing_flag) * 100, 
    Substance = mean(substance_flag) * 100,
    `Mental Health` = mean(mental_health_flag) * 100,
    Employment = mean(employment_flag) * 100,
    Family = mean(family_flag) * 100
  ) %>%
  pivot_longer(everything(), names_to = "risk_type", values_to = "prevalence") %>%
  mutate(risk_type = fct_reorder(risk_type, prevalence)) %>%
  ggplot(aes(x = prevalence, y = risk_type, fill = risk_type)) +
  geom_col(alpha = 0.8, color = "black") +
  scale_fill_manual(values = colors_risk) +
  scale_x_continuous(labels = function(x) paste0(x, "%"), limits = c(0, 100)) +
  labs(
    title = "Risk Factor Prevalence",
    subtitle = paste("High-Risk Cases:", high_risk_cases, "(", high_risk_pct, "%)"),
    x = "Prevalence (%)",
    y = NULL
  ) +
  theme_minimal(base_size = base_font_size) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = base_font_size + 2)
  )

# Panel 3: Geographic Distribution  
p3_location <- ds_input %>%
  count(location) %>%
  mutate(
    location = fct_reorder(location, n),
    pct = n / sum(n) * 100
  ) %>%
  ggplot(aes(x = n, y = location, fill = location)) +
  geom_col(alpha = 0.8, color = "black") +
  scale_fill_manual(values = colors_location[1:length(unique(ds_input$location))]) +
  geom_text(aes(label = paste0(n, " (", round(pct, 1), "%)")), 
           hjust = -0.1, size = base_font_size * 0.8 / .pt) +
  labs(
    title = "Geographic Distribution",
    subtitle = paste("Locations:", length(unique(ds_input$location))),
    x = "Number of Cases",
    y = NULL
  ) +
  theme_minimal(base_size = base_font_size) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = base_font_size + 2),
    panel.grid.major.y = element_blank()
  ) +
  expand_limits(x = max(ds_input %>% count(location) %>% pull(n)) * 1.3)

# Panel 4: Risk by Age Group (Heatmap)
p4_risk_age <- ds_input %>%
  group_by(age_group) %>%
  summarise(
    Crisis = mean(crisis_flag) * 100,
    Housing = mean(housing_flag) * 100,
    Substance = mean(substance_flag) * 100,
    `Mental Health` = mean(mental_health_flag) * 100,
    Employment = mean(employment_flag) * 100,
    Family = mean(family_flag) * 100,
    .groups = "drop"
  ) %>%
  pivot_longer(-age_group, names_to = "risk_type", values_to = "prevalence") %>%
  ggplot(aes(x = age_group, y = risk_type, fill = prevalence)) +
  geom_tile(color = "white", size = 0.5) +
  scale_fill_gradient2(
    low = "#f7f7f7", mid = "#fed976", high = "#d73027",
    midpoint = 50, name = "Prevalence\n(%)",
    labels = function(x) paste0(x, "%")
  ) +
  geom_text(aes(label = round(prevalence, 0)), 
           color = "black", size = base_font_size * 0.7 / .pt) +
  labs(
    title = "Risk Patterns by Age Group",
    subtitle = "Prevalence rates shown as percentages",
    x = "Age Group",
    y = NULL
  ) +
  theme_minimal(base_size = base_font_size) +
  theme(
    plot.title = element_text(face = "bold", size = base_font_size + 2),
    axis.text.x = element_text(hjust = 0.5),
    panel.grid = element_blank()
  )

# Panel 5: Case Complexity Distribution
p5_complexity <- ds_input %>%
  ggplot(aes(x = risk_tier, fill = risk_tier)) +
  geom_bar(alpha = 0.8, color = "black") +
  scale_fill_manual(
    values = c("No Risk" = "#2c7bb6", "Low Risk" = "#abd9e9", 
              "Moderate Risk" = "#ffffbf", "High Risk" = "#fd8d3c", 
              "Critical Risk" = "#d7191c")
  ) +
  geom_text(
    stat = "count",
    aes(label = after_stat(count)), 
    vjust = -0.5, 
    size = base_font_size * 0.8 / .pt
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Case Complexity Distribution", 
    subtitle = paste("Risk Score Range: 0-1 scale based on", length(colors_risk), "risk factors"),
    x = "Risk Tier",
    y = "Number of Cases"
  ) +
  theme_minimal(base_size = base_font_size) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = base_font_size + 2),
    axis.text.x = element_text(hjust = 0.5)
  )

# Panel 6: Case Note Characteristics
p6_notes <- ds_input %>%
  select(word_count, risk_score) %>%
  ggplot(aes(x = word_count, y = risk_score)) +
  geom_point(alpha = 0.6, color = "#2c7fb8") +
  geom_smooth(method = "lm", se = FALSE, color = "#d73027", size = 1) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Case Note Complexity vs Risk",
    subtitle = paste("Avg Words:", round(mean(ds_input$word_count), 0), 
                    "• Correlation:", round(cor(ds_input$word_count, ds_input$risk_score), 2)),
    x = "Word Count",
    y = "Risk Score"
  ) +
  theme_minimal(base_size = base_font_size) +
  theme(
    plot.title = element_text(face = "bold", size = base_font_size + 2)
  )

# ---- assemble-dashboard ------------------------------------------------------
# Create main title panel
title_panel <- ggplot() + 
  theme_void() +
  labs(
    title = "CASE NOTE POPULATION DASHBOARD",
    subtitle = paste(
      "Generated:", format(Sys.Date(), "%B %d, %Y"), 
      "• Source: Synthetic Case Notes for Research"
    )
  ) +
  theme(
    plot.title = element_text(
      hjust = 0.5, size = base_font_size + 6, 
      face = "bold", margin = margin(10, 0, 5, 0)
    ),
    plot.subtitle = element_text(
      hjust = 0.5, size = base_font_size + 2,
      margin = margin(0, 0, 10, 0)
    )
  )

# Assemble dashboard using patchwork
dashboard <- title_panel / 
  ((p1_demographics | p2_risk_flags) / 
   (p3_location | p4_risk_age) / 
   (p5_complexity | p6_notes)) +
  plot_layout(heights = c(0.15, 2.85))

# ---- export-dashboard --------------------------------------------------------
# Generate filename with timestamp
timestamp <- format(Sys.time(), "%Y%m%d_%H%M")
filename <- paste0("case-note-dashboard_", timestamp, ".png")
filepath <- file.path(output_dir, filename)

cat("Saving dashboard to:", filepath, "\n")

# Export at high resolution for print quality
ggsave(
  filename = filepath,
  plot = dashboard,
  width = dashboard_width,
  height = dashboard_height, 
  dpi = dpi_setting,
  bg = "white",
  device = "png"
)

# Also save as PDF for vector graphics
pdf_filepath <- file.path(output_dir, gsub("\\.png$", ".pdf", filename))
ggsave(
  filename = pdf_filepath,
  plot = dashboard,
  width = dashboard_width,
  height = dashboard_height,
  device = "pdf"
)

cat("Dashboard exported successfully!\n")
cat("PNG (raster):", filepath, "\n")
cat("PDF (vector):", pdf_filepath, "\n")

# ---- dashboard-interpretation ------------------------------------------------
cat("\n=== DASHBOARD INTERPRETATION GUIDE ===\n")
cat("Panel 1 - Population Demographics:\n")
cat("  Shows age and gender distribution of client population\n")
cat("  Key insight: Identifies primary demographic segments served\n\n")

cat("Panel 2 - Risk Factor Prevalence:\n") 
cat("  Displays prevalence rates for 6 key risk categories\n")
cat("  Key insight: Reveals most common intervention needs\n\n")

cat("Panel 3 - Geographic Distribution:\n")
cat("  Shows case distribution across service locations\n") 
cat("  Key insight: Identifies resource allocation and capacity needs\n\n")

cat("Panel 4 - Risk Patterns by Age Group:\n")
cat("  Heatmap showing risk prevalence within each age cohort\n")
cat("  Key insight: Reveals age-specific intervention priorities\n\n")

cat("Panel 5 - Case Complexity Distribution:\n")
cat("  Shows distribution of cases across risk tiers\n")
cat("  Key insight: Indicates overall population complexity and resource needs\n\n")

cat("Panel 6 - Case Note Complexity vs Risk:\n")
cat("  Correlation between documentation detail and assessed risk\n")
cat("  Key insight: Validates documentation practices and risk assessment\n\n")

cat("=== KEY METRICS SUMMARY ===\n")
cat("Total Cases:", format(total_cases, big.mark = ","), "\n")
cat("Average Age:", avg_age, "years\n")  
cat("High-Risk Cases:", high_risk_cases, "(", high_risk_pct, "%)\n")
cat("Top Risk Factor:", names(risk_prevalence)[which.max(risk_prevalence)], 
    "(", max(risk_prevalence), "%)\n")
cat("Most Common Gender:", gender_breakdown$gender[1], 
    "(", gender_breakdown$pct[1], "%)\n")

# ---- session-info ------------------------------------------------------------
cat("\n=== DASHBOARD GENERATION COMPLETE ===\n")
cat("System:", R.version.string, "\n")
cat("Packages: ggplot2", as.character(packageVersion("ggplot2")), 
    "• patchwork", as.character(packageVersion("patchwork")), "\n")
cat("Dashboard dimensions:", dashboard_width, "×", dashboard_height, "inches @", dpi_setting, "DPI\n")

# Clean up workspace (optional)
# rm(list = setdiff(ls(), c("ds_input", "dashboard", "filepath", "pdf_filepath")))

cat("Dashboard ready for printing and distribution!\n")