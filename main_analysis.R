################################################################################
# Real-World Effectiveness Study: Target Trial Emulation
# Comparative Effectiveness of Empagliflozin vs Sitagliptin in Type 2 Diabetes
# 
# Author: Tim LaVake
# Institution: Rutgers School of Public Health
# Program: MS Pharmacoepidemiology
# Contact: tlavake27@gmail.com
# GitHub: github.com/lavaket
# Date: November 2025
# 
# Study Design: New-user cohort design with propensity score matching
# Primary Outcome: Major adverse cardiovascular events (MACE)
# Secondary Outcomes: All-cause mortality, hospitalization
#
# Note: This analysis uses synthetic data to demonstrate methodology.
# Framework is designed for real-world claims databases (MarketScan, Optum).
################################################################################

# Load required packages
required_packages <- c(
  "tidyverse", "survival", "MatchIt", "tableone",
  "survminer", "cobalt", "broom", "scales", "patchwork"
)

new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)
lapply(required_packages, library, character.only = TRUE)

# Simulation of Realsitic claims Data

set.seed(42)

simulate_rwe_data <- function(n = 5000) {
  data <- tibble(
    patient_id = 1:n,
    age = rnorm(n, mean = 65, sd = 10),
    female = rbinom(n, 1, 0.48),
    race_white = rbinom(n, 1, 0.75),
    hypertension = rbinom(n, 1, 0.68),
    hyperlipidemia = rbinom(n, 1, 0.72),
    ckd = rbinom(n, 1, 0.25),
    prior_mi = rbinom(n, 1, 0.12),
    prior_stroke = rbinom(n, 1, 0.08),
    heart_failure = rbinom(n, 1, 0.15),
    prior_hosp = rpois(n, 0.5),
    n_medications = rpois(n, 5) + 3,
    hba1c = rnorm(n, mean = 8.2, sd = 1.5),
    egfr = rnorm(n, mean = 75, sd = 20)
  ) %>%
    mutate(
      age = pmax(40, pmin(age, 95)),
      egfr = pmax(15, pmin(egfr, 120)),
      hba1c = pmax(5.5, pmin(hba1c, 14))
    )
  
  # Treatment assignment - sicker patients more likely to get empagliflozin
  data <- data %>%
    mutate(
      propensity_true = plogis(
        -2.5 + 0.03 * age + 0.3 * female + 0.4 * hypertension +
        0.3 * hyperlipidemia + 0.6 * ckd + 0.8 * prior_mi +
        0.7 * heart_failure + 0.1 * n_medications + 0.2 * hba1c
      ),
      treatment = rbinom(n, 1, propensity_true),
      treatment_name = ifelse(treatment == 1, "Empagliflozin", "Sitagliptin")
    )
  
  # Outcomes (true HR = 0.75 for empagliflozin)
  data <- data %>%
    mutate(
      baseline_risk = exp(
        -3.5 + 0.04 * age + 0.3 * female + 0.5 * prior_mi +
        0.6 * heart_failure + 0.4 * ckd + 0.02 * hba1c + 0.1 * prior_hosp
      ),
      hazard = baseline_risk * ifelse(treatment == 1, 0.75, 1.0),
      time_to_event = rexp(n, rate = hazard),
      time_to_censor = pmin(365 * 3, rexp(n, rate = 0.15)),
      follow_up_days = pmin(time_to_event, time_to_censor),
      event = as.integer(time_to_event <= time_to_censor),
      follow_up_years = follow_up_days / 365.25
    )
  
  return(data)
}

cohort_data <- simulate_rwe_data(n = 5000)

cat("Study Cohort Generated:\n")
cat("- Total patients:", nrow(cohort_data), "\n")
cat("- Empagliflozin:", sum(cohort_data$treatment == 1), "\n")
cat("- Sitagliptin:", sum(cohort_data$treatment == 0), "\n")
cat("- Events:", sum(cohort_data$event), "\n")
cat("- Median follow-up:", round(median(cohort_data$follow_up_years), 2), "years\n\n")

# Baseline Characteristics Table


baseline_vars <- c(
  "age", "female", "race_white", "hypertension", "hyperlipidemia", "ckd",
  "prior_mi", "prior_stroke", "heart_failure", "prior_hosp", 
  "n_medications", "hba1c", "egfr"
)

table1_pre <- CreateTableOne(
  vars = baseline_vars,
  strata = "treatment_name",
  data = cohort_data,
  test = TRUE
)

cat("=== BASELINE CHARACTERISTICS (Pre-Matching) ===\n")
print(table1_pre, smd = TRUE, showAllLevels = FALSE)

# Propensity Score Matching

cat("\n\n=== PROPENSITY SCORE MATCHING ===\n")

ps_formula <- as.formula(paste("treatment ~", paste(baseline_vars, collapse = " + ")))

matched_data <- matchit(
  ps_formula,
  data = cohort_data,
  method = "nearest",
  distance = "glm",
  ratio = 1,
  caliper = 0.2,
  replace = FALSE
)

cat("\nMatching Summary:\n")
print(summary(matched_data))

matched_cohort <- match.data(matched_data)

cat("\n- Matched pairs:", nrow(matched_cohort) / 2, "\n")
cat("- Empagliflozin (matched):", sum(matched_cohort$treatment == 1), "\n")
cat("- Sitagliptin (matched):", sum(matched_cohort$treatment == 0), "\n")


# Balance Diagnostics


cat("\n\n=== COVARIATE BALANCE ASSESSMENT ===\n")

balance_stats <- bal.tab(matched_data, un = TRUE, thresholds = c(m = 0.1))
print(balance_stats)

love_plot <- love.plot(
  matched_data,
  thresholds = c(m = 0.1),
  abs = TRUE,
  var.order = "unadjusted",
  title = "Covariate Balance: Empagliflozin vs Sitagliptin",
  colors = c("#d62728", "#2ca02c"),
  shapes = c("circle", "triangle"),
  size = 3
) + theme_minimal()

print(love_plot)


# Primary Outcomes Analysis

cat("\n\n=== PRIMARY OUTCOME ANALYSIS ===\n")

cox_model <- coxph(Surv(follow_up_years, event) ~ treatment, data = matched_cohort)

cox_summary <- summary(cox_model)
hr <- cox_summary$conf.int[1, 1]
hr_lower <- cox_summary$conf.int[1, 3]
hr_upper <- cox_summary$conf.int[1, 4]
p_value <- cox_summary$coefficients[1, 5]

cat("Cox Proportional Hazards Model Results:\n")
cat(sprintf("- Hazard Ratio: %.3f (95%% CI: %.3f - %.3f)\n", hr, hr_lower, hr_upper))
cat(sprintf("- P-value: %.4f\n", p_value))
cat(sprintf("- Risk reduction: %.1f%%\n\n", (1 - hr) * 100))

km_fit <- survfit(Surv(follow_up_years, event) ~ treatment_name, data = matched_cohort)

km_plot <- ggsurvplot(
  km_fit,
  data = matched_cohort,
  risk.table = TRUE,
  pval = TRUE,
  conf.int = TRUE,
  palette = c("#1f77b4", "#ff7f0e"),
  xlab = "Time (Years)",
  ylab = "Freedom from MACE",
  title = "Kaplan-Meier Survival Curves: Empagliflozin vs Sitagliptin",
  legend.title = "Treatment",
  legend.labs = c("Empagliflozin", "Sitagliptin"),
  risk.table.height = 0.25,
  ggtheme = theme_minimal()
)

print(km_plot)


# Resutls

dir.create("output", showWarnings = FALSE)

ggsave("output/love_plot.png", love_plot, width = 10, height = 8, dpi = 300)
ggsave("output/km_curve.png", km_plot$plot, width = 10, height = 8, dpi = 300)
write_csv(matched_cohort, "output/matched_cohort.csv")

results_summary <- tibble(
  analysis = "Primary Analysis",
  hr = hr,
  ci_lower = hr_lower,
  ci_upper = hr_upper,
  p_value = p_value
)
write_csv(results_summary, "output/results_summary.csv")

cat("\n✓ ANALYSIS COMPLETE\n")
cat("\nKey Finding: Empagliflozin associated with", round((1-hr)*100, 1), 
    "% reduction in MACE vs Sitagliptin (HR:", round(hr, 3), 
    ", 95% CI:", round(hr_lower, 3), "-", round(hr_upper, 3), ")\n")
