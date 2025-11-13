# Quick Start Guide

## Installation

```bash
git clone https://github.com/lavaket/diabetes-rwe-study.git
cd diabetes-rwe-study
```

## Install R Dependencies

```r
source("install_packages.R")
```

## Run Analysis

```r
source("main_analysis.R")
source("subgroup_analysis.R")
```

**Total runtime:** ~75 seconds

## Output Files

Check the `output/` directory for:
- `matched_cohort.csv`
- `results_summary.csv`
- `love_plot.png`
- `km_curve.png`
- `forest_plot_subgroups.png`

## Questions?

Contact: tlavake27@gmail.com