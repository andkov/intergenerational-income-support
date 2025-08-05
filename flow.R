# Intergenerational Income Support Research - Main Analysis Flow
# 
# This file orchestrates the complete analytical pipeline for studying
# intergenerational transmission of Income Support dependency in Alberta.
# 
# The pipeline follows these stages:
# 1. Environment setup and configuration
# 2. Data import and validation
# 3. Family linkage and cohort creation
# 4. Descriptive analysis
# 5. Survival and longitudinal modeling
# 6. Sensitivity analysis and validation
# 7. Report generation

# Clear environment and load necessary libraries
rm(list = ls(all.names = TRUE))

# Load required packages
source("./scripts/install-packages.R")
library(here)
library(config)
library(dplyr)
library(readr)
library(ggplot2)
library(survival)
library(lme4)
library(knitr)
library(rmarkdown)
library(lubridate)

# Set up logging
source("./utility/logging.R")
start_logging()

# Load configuration
config <- config::get()
cat("Project:", config$project_name, "\n")
cat("Study period:", config$study_start_year, "-", config$study_end_year, "\n")

# Load custom functions
source("./libs/data-processing.R")
source("./libs/survival-analysis.R")
source("./libs/visualization.R")
source("./utility/validation.R")

# Create output directories
dir.create(config$directory_output, recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(config$path_log_flow), recursive = TRUE, showWarnings = FALSE)

cat("\n=== INTERGENERATIONAL INCOME SUPPORT ANALYSIS PIPELINE ===\n")
cat("Start time:", as.character(Sys.time()), "\n\n")

# ---- Stage 1: Data Import and Validation ----
cat("Stage 1: Data Import and Validation\n")
cat("====================================\n")

if (file.exists("./data-private/raw/income_support_records.csv")) {
  cat("Loading Income Support administrative data...\n")
  source("./manipulation/0-import/import-is-data.R")
  
  cat("Validating data quality...\n")
  source("./manipulation/0-import/validate-data.R")
  
} else {
  cat("Administrative data files not found.\n")
  cat("Please ensure data files are available in ./data-private/raw/\n")
  cat("See README for data requirements and access procedures.\n")
  stop("Required data files not available")
}

# ---- Stage 2: Family Linkage ----
cat("\nStage 2: Family Linkage and Relationship Identification\n")
cat("======================================================\n")

cat("Creating family linkages...\n")
source("./manipulation/1-linkage/create-family-links.R")

cat("Validating family structures...\n")
source("./manipulation/1-linkage/validate-families.R")

# ---- Stage 3: Cohort Definition ----
cat("\nStage 3: Cohort Definition and Sample Creation\n")
cat("=============================================\n")

cat("Defining exposure cohorts...\n")
source("./manipulation/2-cohorts/define-exposure-cohorts.R")

cat("Creating comparison groups...\n")
source("./manipulation/2-cohorts/create-comparison-cohorts.R")

cat("Applying inclusion/exclusion criteria...\n")
source("./manipulation/2-cohorts/apply-criteria.R")

# ---- Stage 4: Descriptive Analysis ----
cat("\nStage 4: Descriptive Analysis\n")
cat("============================\n")

cat("Generating population characteristics...\n")
source("./analysis/1-descriptive/population-characteristics.R")

cat("Analyzing exposure patterns...\n")
source("./analysis/1-descriptive/exposure-patterns.R")

cat("Examining outcome distributions...\n")
source("./analysis/1-descriptive/outcome-patterns.R")

# ---- Stage 5: Primary Modeling ----
cat("\nStage 5: Primary Statistical Modeling\n")
cat("====================================\n")

cat("Fitting survival models...\n")
source("./analysis/2-models/survival-analysis.R")

cat("Mixed-effects modeling...\n")
source("./analysis/2-models/mixed-effects-models.R")

cat("Risk stratification analysis...\n")
source("./analysis/2-models/risk-stratification.R")

# ---- Stage 6: Sensitivity Analysis ----
cat("\nStage 6: Sensitivity Analysis and Validation\n")
cat("==========================================\n")

cat("Alternative cohort definitions...\n")
source("./analysis/3-sensitivity/alternative-cohorts.R")

cat("Missing data sensitivity...\n")
source("./analysis/3-sensitivity/missing-data-analysis.R")

cat("Temporal robustness checks...\n")
source("./analysis/3-sensitivity/temporal-robustness.R")

# ---- Stage 7: Report Generation ----
cat("\nStage 7: Report Generation\n")
cat("=========================\n")

cat("Generating summary statistics...\n")
source("./scripts/generate-summary.R")

cat("Creating visualizations...\n")
source("./scripts/create-figures.R")

cat("Compiling final report...\n")
if (file.exists("./analysis/final-report.Rmd")) {
  rmarkdown::render("./analysis/final-report.Rmd",
                   output_dir = config$directory_output,
                   output_file = paste0("intergenerational-is-report-", Sys.Date(), ".html"))
}

# ---- Pipeline Completion ----
cat("\n=== PIPELINE COMPLETED ===\n")
cat("End time:", as.character(Sys.time()), "\n")
cat("Output directory:", config$directory_output, "\n")

# Log completion
log_info("Analysis pipeline completed successfully")
stop_logging()

# Display key results summary
if (exists("final_results")) {
  cat("\nKey Findings Summary:\n")
  print(final_results)
}

cat("\nNext steps:\n")
cat("1. Review output files in:", config$directory_output, "\n")
cat("2. Examine detailed results in analysis subdirectories\n")
cat("3. Review AI collaboration log in ./ai/logbook.md\n")
cat("4. Prepare stakeholder presentations and policy briefs\n")

# Clean up temporary objects
rm(list = ls(pattern = "temp_"))
gc()

cat("\nAnalysis complete. See README for interpretation guidelines.\n")