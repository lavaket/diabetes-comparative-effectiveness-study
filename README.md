# Real-World Effectiveness Study: Target Trial Emulation

## Comparative Effectiveness of Empagliflozin vs Sitagliptin in Type 2 Diabetes

[![R](https://img.shields.io/badge/R-4.3+-blue.svg)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Maintenance](https://img.shields.io/badge/Maintained-yes-green.svg)](https://github.com/lavaket/diabetes-rwe-study/graphs/commit-activity)

**Author:** Tim LaVake  
**Program:** MS Pharmacoepidemiology, Rutgers School of Public Health  
**Contact:** tlavake27@gmail.com | [GitHub](https://github.com/lavaket) | [LinkedIn](https://linkedin.com/in/tim-lavake)



## Project Overview

This repository demonstrates a **production-quality real-world effectiveness (RWE) study** comparing empagliflozin (SGLT2 inhibitor) versus sitagliptin (DPP-4 inhibitor) for cardiovascular outcomes in patients with type 2 diabetes. The analysis uses **target trial emulation methodology** to minimize biases inherent in observational research.

**Research Question:** Does empagliflozin reduce major adverse cardiovascular events (MACE) compared to sitagliptin in routine clinical practice?

**Key Features:**
- ✅ New-user cohort design (minimizes prevalent user bias)
- ✅ Propensity score matching with balance diagnostics
- ✅ Time-to-event survival analysis (Cox regression)
- ✅ Publication-ready visualizations (KM curves, forest plots, Love plots)
- ✅ Comprehensive sensitivity and subgroup analyses
- ✅ Regulatory-compliant documentation (STROBE guidelines)



## Project Motivation

### Why This Project?

During my internships at **Johnson & Johnson** and **Merck**, I supported laboratory operations, safety compliance, and cross-functional scientific teams. These experiences gave me insight into how pharmaceutical companies generate evidence to support regulatory submissions, market access, and formulary placement decisions.

I became particularly interested in **real-world evidence (RWE)** after seeing how post-market surveillance and comparative effectiveness studies directly inform:
- Regulatory decision-making (FDA, EMA)
- Payer coverage decisions
- Clinical practice guidelines  
- Drug safety monitoring

### Why Empagliflozin vs Sitagliptin?

This comparison represents a real-world clinical decision that's relevant today:

**Clinical Context:**
- Both are second-line diabetes medications
- EMPA-REG OUTCOME trial (2015) showed empagliflozin reduces CV events by 14%
- Sitagliptin is CV-neutral but more established and lower cost
- Creates classic confounding: sicker patients preferentially receive empagliflozin

**Regulatory Relevance:**
- Janssen (J&J division) used RWE studies to support empagliflozin's expanded label
- Comparative effectiveness drives formulary tier placement
- Perfect demonstration of target trial emulation methodology

### Technical Goals

As someone with experience in **data science** (Python, R, SQL) and **regulatory compliance** (GxP, OSHA), I wanted to build a reproducible pipeline that:
1. Demonstrates rigorous causal inference methods
2. Follows regulatory best practices (STROBE, RECORD guidelines)
3. Generates publication-quality outputs
4. Can scale to real claims databases

### Why Synthetic Data?

I'm using synthetic data to ensure complete **transparency and reproducibility**. Anyone can run this code and get identical results. The methods, however, are directly applicable to real-world databases I've worked with during my MS program:
- Medicare claims  
- MarketScan Commercial/Medicare
- Optum Clinformatics
- Electronic health records

**Next steps:** Seeking IRB approval to replicate this analysis with real claims data as part of my thesis work.



## About the Author

I'm Tim LaVake, a Master's student in Pharmacoepidemiology at Rutgers School of Public Health with a strong foundation in both pharmaceutical operations and data science.

**Relevant Experience:**
- **Johnson & Johnson (EH&S Intern):** Supported lab operations across 120+ research labs, developed biosecurity training for 4,500 employees
- **Merck (EHS Specialist & Global Safety Intern):** Led documentation consolidation for 3,000+ global safety documents, conducted industrial hygiene assessments
- **Data Science Skills:** Python, R, SAS, SQL, Tableau - applied to statistical modeling and data visualization

**Why Pharmacoepidemiology?**  
My experience at J&J and Merck showed me the critical role of evidence generation in pharmaceutical development. I'm passionate about using rigorous statistical methods to inform clinical practice, regulatory decisions, and patient safety monitoring.

**Career Goals:**  
Seeking full-time opportunities in HEOR, Real-World Evidence, or Regulatory Affairs at pharmaceutical/biotech companies where I can apply my unique combination of pharma operations experience and advanced quantitative skills.



## Quick Start

See [QUICKSTART.md](QUICKSTART.md) for detailed setup instructions.

```r
# Install dependencies
source("install_packages.R")

# Run analysis
source("main_analysis.R")
source("subgroup_analysis.R")
```

**Runtime:** ~75 seconds

---

## Key Results

### Primary Analysis (Matched Cohort)

| Analysis | Hazard Ratio | 95% CI | P-value | Interpretation |
|----------|--------------|--------|---------|----------------|
| Primary (Unadjusted) | 0.75 | 0.65-0.86 | <0.001 | 25% MACE reduction |
| Multivariable-Adjusted | 0.74 | 0.64-0.85 | <0.001 | Robust to adjustment |

**Clinical Impact:**
- **25% relative risk reduction** in MACE with empagliflozin
- **Number Needed to Treat (3 years):** ~42 patients
- **Consistent effects** across age, sex, kidney function, prior CVD subgroups



## Contact & Collaboration

**Tim LaVake**  
MS Pharmacoepidemiology Candidate  
Rutgers School of Public Health

tlavake27@gmail.com  
LinkedIn](https://linkedin.com/in/tim-lavake)  
[GitHub](https://github.com/lavaket)

**Open to:**
- Collaboration on pharmacoepidemiologic research
- Internship/full-time opportunities in HEOR, RWE, or regulatory affairs
- Technical discussions on causal inference methods



## License

MIT License - see [LICENSE](LICENSE) file for details.



**⭐ If you find this project useful, please star the repository!**
