# Population Characteristics Analysis
# Intergenerational Income Support Research
#
# This script generates descriptive statistics for the study population,
# including demographic characteristics, exposure patterns, and outcome distributions.

# Load required libraries
library(dplyr)
library(ggplot2)
library(gt)
library(config)

# Load configuration
config <- config::get()

# Load data (assumes data manipulation pipeline has been run)
if (!exists("cohort_data")) {
  if (file.exists(file.path(config$directory_data_private, "derived", "cohort_data.rds"))) {
    cohort_data <- readRDS(file.path(config$directory_data_private, "derived", "cohort_data.rds"))
  } else {
    stop("Cohort data not found. Please run data manipulation pipeline first.")
  }
}

cat("Generating population characteristics...\n")

# ---- Overall Sample Characteristics ----

# Total sample size
total_n <- nrow(cohort_data)
cat("Total sample size:", total_n, "\n")

# Sample characteristics by exposure status
sample_summary <- cohort_data %>%
  group_by(exposure_group) %>%
  summarise(
    n = n(),
    pct = round(100 * n() / total_n, 1),
    mean_birth_year = round(mean(birth_year, na.rm = TRUE), 1),
    female_pct = round(100 * mean(sex == "Female", na.rm = TRUE), 1),
    .groups = "drop"
  )

print(sample_summary)

# ---- Demographic Characteristics Table ----

# Create comprehensive demographic table
demo_table <- cohort_data %>%
  select(exposure_group, birth_year, sex, geographic_region, family_size_baseline) %>%
  tbl_summary(
    by = exposure_group,
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    missing = "no"
  ) %>%
  add_overall() %>%
  add_p() %>%
  modify_header(label ~ "**Characteristic**")

# Display table
demo_table

# ---- Exposure Characteristics (for exposed group only) ----

if ("exposed" %in% unique(cohort_data$exposure_group)) {
  
  exposure_summary <- cohort_data %>%
    filter(exposure_group == "exposed") %>%
    summarise(
      n = n(),
      mean_exposure_duration = round(mean(parental_is_duration_months, na.rm = TRUE), 1),
      median_exposure_duration = round(median(parental_is_duration_months, na.rm = TRUE), 1),
      mean_age_first_exposure = round(mean(age_first_exposure, na.rm = TRUE), 1),
      chronic_exposure_pct = round(100 * mean(chronic_exposure, na.rm = TRUE), 1),
      .groups = "drop"
    )
  
  cat("\nExposure Characteristics (Exposed Group Only):\n")
  print(exposure_summary)
  
  # Exposure duration distribution
  exposure_plot <- cohort_data %>%
    filter(exposure_group == "exposed") %>%
    ggplot(aes(x = parental_is_duration_months)) +
    geom_histogram(bins = 30, fill = "steelblue", alpha = 0.7) +
    labs(
      title = "Distribution of Parental Income Support Duration",
      subtitle = "Among children with IS exposure",
      x = "Duration (months)",
      y = "Count"
    ) +
    theme_minimal()
  
  ggsave(
    filename = file.path(config$directory_output, "exposure_duration_distribution.png"),
    plot = exposure_plot,
    width = config$figure_width,
    height = config$figure_height,
    dpi = config$figure_dpi
  )
}

# ---- Geographic Distribution ----

geo_summary <- cohort_data %>%
  count(geographic_region, exposure_group) %>%
  group_by(geographic_region) %>%
  mutate(
    total_region = sum(n),
    pct_exposed = round(100 * n[exposure_group == "exposed"] / total_region, 1)
  ) %>%
  ungroup() %>%
  filter(exposure_group == "exposed") %>%
  select(geographic_region, total_region, n_exposed = n, pct_exposed)

cat("\nGeographic Distribution:\n")
print(geo_summary)

# ---- Temporal Patterns ----

# Birth cohort distribution
birth_cohort_plot <- cohort_data %>%
  count(birth_year, exposure_group) %>%
  ggplot(aes(x = birth_year, y = n, fill = exposure_group)) +
  geom_col(position = "stack") +
  labs(
    title = "Sample Distribution by Birth Year",
    subtitle = "Exposed vs. comparison groups",
    x = "Birth Year",
    y = "Count",
    fill = "Exposure Group"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("exposed" = "coral", "comparison" = "lightblue"))

ggsave(
  filename = file.path(config$directory_output, "birth_cohort_distribution.png"),
  plot = birth_cohort_plot,
  width = config$figure_width,
  height = config$figure_height,
  dpi = config$figure_dpi
)

# ---- Family Structure Characteristics ----

family_structure_summary <- cohort_data %>%
  group_by(exposure_group, family_structure_baseline) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(exposure_group) %>%
  mutate(pct = round(100 * n / sum(n), 1)) %>%
  ungroup()

cat("\nFamily Structure Distribution:\n")
print(family_structure_summary)

# ---- Outcome Prevalence ----

if ("adult_is_receipt" %in% names(cohort_data)) {
  outcome_summary <- cohort_data %>%
    group_by(exposure_group) %>%
    summarise(
      n = n(),
      outcome_n = sum(adult_is_receipt, na.rm = TRUE),
      outcome_pct = round(100 * mean(adult_is_receipt, na.rm = TRUE), 1),
      .groups = "drop"
    )
  
  cat("\nOutcome Prevalence:\n")
  print(outcome_summary)
}

# ---- Missing Data Assessment ----

missing_summary <- cohort_data %>%
  summarise(across(everything(), ~ sum(is.na(.x)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "missing_n") %>%
  mutate(
    missing_pct = round(100 * missing_n / total_n, 1)
  ) %>%
  filter(missing_n > 0) %>%
  arrange(desc(missing_pct))

if (nrow(missing_summary) > 0) {
  cat("\nMissing Data Summary:\n")
  print(missing_summary)
} else {
  cat("\nNo missing data detected.\n")
}

# ---- Save Results ----

# Save summary statistics
write_csv(sample_summary, file.path(config$directory_output, "sample_summary.csv"))
write_csv(geo_summary, file.path(config$directory_output, "geographic_summary.csv"))

if (exists("exposure_summary")) {
  write_csv(exposure_summary, file.path(config$directory_output, "exposure_summary.csv"))
}

if (exists("outcome_summary")) {
  write_csv(outcome_summary, file.path(config$directory_output, "outcome_summary.csv"))
}

cat("\nPopulation characteristics analysis complete.\n")
cat("Results saved to:", config$directory_output, "\n")