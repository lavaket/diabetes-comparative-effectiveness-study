# Package Installation Script
# Author: Tim LaVake

required_packages <- c(
  "tidyverse", "survival", "MatchIt", "tableone",
  "survminer", "cobalt", "broom", "scales", "patchwork"
)

missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if(length(missing_packages) > 0) {
  cat("Installing", length(missing_packages), "missing packages...\n")
  for(pkg in missing_packages) {
    cat("Installing:", pkg, "...")
    install.packages(pkg, dependencies = TRUE)
    cat(" ✓\n")
  }
} else {
  cat("All packages already installed! ✓\n")
}

cat("\n✓ Ready to run analysis!\n")