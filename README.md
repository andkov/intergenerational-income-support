# Intergenerational Income Support Dependency Research

> Investigating patterns of Income Support dependency transmission across generations within Alberta families.

This research project examines how dependency on Income Support (IS) within families may contribute to subsequent IS dependency among their children and other family members. Using longitudinal administrative data, we aim to understand the mechanisms, risk factors, and policy implications of intergenerational welfare dependency in Alberta.

## Research Objectives

### Primary Research Questions

1. **Transmission Patterns**: What are the rates and patterns of intergenerational Income Support dependency in Alberta families?

2. **Risk Factors**: What family, individual, and contextual factors increase the likelihood of intergenerational IS transmission?

3. **Duration and Timing**: How do duration of parental IS dependency and timing of child exposure affect subsequent dependency risks?

4. **Breaking Cycles**: What interventions or circumstances are associated with breaking intergenerational dependency cycles?

### Secondary Questions

- How do intergenerational patterns vary by geographic region, family structure, and demographic characteristics?
- What role do education, employment programs, and other social services play in reducing transmission risk?
- How do policy changes over time affect intergenerational dependency patterns?

## Methodology

### Study Design
- **Type**: Retrospective cohort study using administrative data
- **Population**: Alberta families with Income Support history (1995-2024)
- **Unit of Analysis**: Family units and individual family members
- **Follow-up**: Minimum 18-year follow-up for children reaching adulthood

### Data Sources
- Alberta Income Support administrative records
- Linked demographic and family composition data
- Geographic and temporal identifiers
- Educational and employment program participation records

### Key Variables

**Exposure Variables:**
- Parental IS dependency (duration, timing, recurrence)
- Family structure and composition
- Geographic location and mobility

**Outcome Variables:**
- Adult child IS dependency (onset, duration, recurrence)
- Employment and education outcomes
- Family formation patterns

**Confounders/Mediators:**
- Socioeconomic indicators
- Health and disability status
- Education and training participation
- Geographic and economic context

## Project Structure

This project follows the [GovAlta Quick Start Template](https://github.com/GovAlta/quick-start-template) analytical framework for reproducible research.

### Directory Organization

```
├── ai/                     # AI collaboration infrastructure
├── analysis/               # Primary analytical scripts and reports
├── data-private/           # Confidential administrative data
├── data-public/            # Non-sensitive reference data
├── manipulation/           # Data processing and cleaning scripts
├── scripts/                # Utility and automation scripts
├── philosophy/             # Research methodology and documentation
├── libs/                   # Custom functions and utilities
├── utility/                # Helper functions and tools
├── config.yml              # Project configuration
└── flow.R                  # Main analytical pipeline
```

## Getting Started

### Prerequisites

1. **R Environment**: R 4.0+ with RStudio
2. **Required Packages**: 
   - Data manipulation: `dplyr`, `tidyr`, `data.table`
   - Analysis: `survival`, `lme4`, `broom`
   - Visualization: `ggplot2`, `plotly`, `DT`
   - Reporting: `rmarkdown`, `knitr`

3. **Data Access**: Approved access to Alberta Income Support administrative data

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/andkov/intergenerational-income-support.git
   cd intergenerational-income-support
   ```

2. Open the project in RStudio:
   ```r
   # Double-click intergenerational-income-support.Rproj
   ```

3. Install required packages:
   ```r
   source("scripts/install-packages.R")
   ```

4. Configure data paths in `config.yml`

5. Run initial data validation:
   ```r
   source("flow.R")
   ```

## Analytical Pipeline

The analytical workflow follows these key stages:

1. **Data Import and Validation** (`manipulation/0-import/`)
   - Import administrative data
   - Validate data quality and completeness
   - Create analysis-ready datasets

2. **Family Linkage** (`manipulation/1-linkage/`)
   - Identify family relationships
   - Create intergenerational linkages
   - Validate family structures

3. **Cohort Definition** (`manipulation/2-cohorts/`)
   - Define exposure and comparison cohorts
   - Apply inclusion/exclusion criteria
   - Create follow-up windows

4. **Primary Analysis** (`analysis/1-descriptive/`, `analysis/2-models/`)
   - Descriptive analysis of IS patterns
   - Survival analysis for dependency onset
   - Mixed-effects models for repeated measures

5. **Sensitivity Analysis** (`analysis/3-sensitivity/`)
   - Alternative cohort definitions
   - Missing data assessments
   - Robustness checks

## Ethical Considerations

- **Data Privacy**: All analyses use de-identified administrative data
- **Ethics Approval**: Research Ethics Board approval obtained
- **Data Security**: Secure data handling protocols followed
- **Reporting**: Results reported in aggregate to protect privacy

## Contributing

This project uses the AI-enhanced research framework described in `./ai/README.md`. All analytical decisions and model iterations are logged in `./ai/logbook.md`.

### Team Collaboration
- Research decisions documented in `./ai/mission.md`
- Domain terminology defined in `./ai/glossary.md`
- AI assistance protocols in `./ai/onboarding-ai.md`

## License

This research is conducted under the appropriate data sharing agreements with Alberta government departments. Analysis code is available under MIT License.

## Contact

**Principal Investigator**: [Name]  
**Institution**: [Institution]  
**Email**: [Email]

## Funding

This research is supported by [Funding Agency/Grant Number].

---

*Last updated: [Date]*
