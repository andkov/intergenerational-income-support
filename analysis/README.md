# Analysis Directory

This directory contains the core analytical scripts for the intergenerational Income Support research.

## Directory Structure

```
analysis/
├── 1-descriptive/         # Descriptive analysis scripts
│   ├── population-characteristics.R
│   ├── exposure-patterns.R
│   └── outcome-patterns.R
├── 2-models/             # Primary statistical modeling
│   ├── survival-analysis.R
│   ├── mixed-effects-models.R
│   └── risk-stratification.R
├── 3-sensitivity/        # Sensitivity and robustness analysis
│   ├── alternative-cohorts.R
│   ├── missing-data-analysis.R
│   └── temporal-robustness.R
└── final-report.Rmd      # Main research report
```

## Analysis Stages

### Stage 1: Descriptive Analysis
- **population-characteristics.R**: Demographic and baseline characteristics
- **exposure-patterns.R**: Income Support exposure patterns across families
- **outcome-patterns.R**: Adult child outcomes and dependency patterns

### Stage 2: Primary Modeling
- **survival-analysis.R**: Time-to-event analysis for IS onset
- **mixed-effects-models.R**: Longitudinal models accounting for family clustering
- **risk-stratification.R**: Identification of high-risk groups

### Stage 3: Sensitivity Analysis
- **alternative-cohorts.R**: Robustness to different cohort definitions
- **missing-data-analysis.R**: Impact of missing data patterns
- **temporal-robustness.R**: Stability across different time periods

## Key Analytical Considerations

### Family Clustering
All analyses must account for within-family correlation using:
- Mixed-effects models for continuous outcomes
- Frailty models for survival analysis
- Robust standard errors for other analyses

### Temporal Dynamics
Consider:
- Policy changes over the 30-year study period
- Economic cycles and their impact on IS patterns
- Cohort effects for different birth years

### Privacy Protection
All outputs must:
- Suppress cells with <5 observations
- Use aggregated geographic regions
- Report confidence intervals rather than exact point estimates

## Output Standards

### Tables
- Include confidence intervals for all estimates
- Show sample sizes and missing data patterns
- Use consistent formatting across all analyses

### Figures
- High-resolution PNG format (300 DPI)
- Consistent color schemes and styling
- Clear titles and axis labels
- Include uncertainty visualization where appropriate

### Models
- Report model diagnostics and assumptions
- Include sensitivity analyses for key findings
- Document all modeling decisions in AI logbook

## Dependencies

Scripts depend on:
- Successful completion of data manipulation pipeline
- Required packages installed via `scripts/install-packages.R`
- Configuration settings in `config.yml`

## Usage

Run individual scripts after data preparation:
```r
source("analysis/1-descriptive/population-characteristics.R")
```

Or run complete pipeline:
```r
source("flow.R")
```