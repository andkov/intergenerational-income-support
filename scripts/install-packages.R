# Package Installation Script for Intergenerational Income Support Research
# 
# This script installs all required R packages for the analysis pipeline

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    }
  }
}

# Core packages for data manipulation and analysis
core_packages <- c(
  "here",           # Project-relative paths
  "config",         # Configuration management
  "dplyr",          # Data manipulation
  "tidyr",          # Data tidying
  "readr",          # Data import
  "data.table",     # Fast data operations
  "lubridate",      # Date/time handling
  "stringr"         # String manipulation
)

# Statistical analysis packages
stats_packages <- c(
  "survival",       # Survival analysis
  "survminer",      # Survival plots
  "lme4",           # Mixed-effects models
  "broom",          # Model tidying
  "broom.mixed",    # Mixed model tidying
  "mgcv",           # GAM models
  "mice",           # Multiple imputation
  "VIM"             # Visualization of missing data
)

# Visualization packages
viz_packages <- c(
  "ggplot2",        # Grammar of graphics
  "plotly",         # Interactive plots
  "DT",             # Interactive tables
  "scales",         # Scale functions
  "RColorBrewer",   # Color palettes
  "viridis",        # Color scales
  "patchwork"       # Combine plots
)

# Reporting packages
report_packages <- c(
  "rmarkdown",      # Dynamic documents
  "knitr",          # Literate programming
  "gt",             # Grammar of tables
  "flextable",      # Flexible tables
  "officer",        # Office documents
  "htmlwidgets"     # HTML widgets
)

# Utility packages
utility_packages <- c(
  "fs",             # File system operations
  "glue",           # String interpolation
  "janitor",        # Data cleaning
  "skimr",          # Data summaries
  "parallel",       # Parallel processing
  "future",         # Future evaluation
  "progressr"       # Progress reporting
)

# Government-specific packages (if available)
gov_packages <- c(
  "cancensus",      # Canadian census data
  "cansim"          # Statistics Canada data
)

# Install all packages
cat("Installing core packages...\n")
install_if_missing(core_packages)

cat("Installing statistical analysis packages...\n")
install_if_missing(stats_packages)

cat("Installing visualization packages...\n")
install_if_missing(viz_packages)

cat("Installing reporting packages...\n")
install_if_missing(report_packages)

cat("Installing utility packages...\n")
install_if_missing(utility_packages)

cat("Installing government-specific packages...\n")
tryCatch({
  install_if_missing(gov_packages)
}, error = function(e) {
  cat("Some government packages may not be available from CRAN\n")
})

# Verify installation
all_packages <- c(core_packages, stats_packages, viz_packages, 
                  report_packages, utility_packages)

cat("\nVerifying package installation...\n")
missing_packages <- character(0)

for (pkg in all_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    missing_packages <- c(missing_packages, pkg)
  }
}

if (length(missing_packages) == 0) {
  cat("✓ All required packages installed successfully!\n")
} else {
  cat("✗ The following packages failed to install:\n")
  cat(paste(missing_packages, collapse = ", "), "\n")
  cat("Please install these manually using install.packages()\n")
}

# Display R version info
cat("\nR Version Information:\n")
print(R.version.string)
cat("Platform:", R.version$platform, "\n")

# Display key package versions
cat("\nKey Package Versions:\n")
key_packages <- c("dplyr", "ggplot2", "survival", "lme4", "rmarkdown")
for (pkg in key_packages) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(pkg, ":", as.character(packageVersion(pkg)), "\n")
  }
}

cat("\nPackage installation complete!\n")
cat("You can now run the main analysis pipeline with source('flow.R')\n")