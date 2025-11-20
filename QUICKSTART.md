# 🎯 Quick Start Guide

Welcome to the Coinflip Randomness vs. Cognitive Reflection Test project!

---

## ⚡ Super Quick Start (5 Minutes)

### 1. Install Required Packages

```r
# Install once
install.packages(c("tidyverse", "readxl", "janitor", "broom"))
```

### 2. Run the Analysis

```r
# Run complete analysis pipeline
source("main_analysis.R")
```

**That's it!** Check the `output/` folder for results.

---

## 📂 What's Where?

```
📁 coinflip_randomness_vs_CRT/
│
├── 🔧 R/                          # Analysis code modules
│   ├── 01_data_loading.R          # Load & clean data
│   ├── 02_crt_scoring.R           # Score CRT test
│   ├── 03_randomness_metrics.R    # Calculate randomness
│   ├── 04_visualization.R         # Create plots
│   └── 05_statistical_analysis.R  # Run statistics
│
├── 📊 data/                       # Data files
│   └── final_data_ready.csv       # Clean dataset
│
├── 📈 output/                     # Generated results
│   ├── fig1_crt_vs_randomness.png
│   ├── fig2_randomness_by_grade.png
│   └── statistical_results.csv
│
├── 📚 docs/                       # Documentation
│   ├── METHODOLOGY.md             # How study was conducted
│   ├── FUTURE_WORK.md             # Research extensions
│   ├── REFERENCES.md              # Bibliography
│   └── RESEARCH_SUGGESTIONS.md    # Ideas from literature
│
├── 🚀 main_analysis.R             # ⭐ RUN THIS FILE
├── 📖 README.md                   # Project overview
├── 🤝 CONTRIBUTING.md             # How to contribute
└── 📄 LICENSE                     # MIT License
```

---

## 🎓 Understanding the Project

### Research Question
**"Does cognitive ability predict randomness generation quality?"**

### What We Measured

1. **Cognitive Reflection Test (CRT-7)**
   - 7 questions measuring analytical thinking
   - Score: 0-7 (higher = more reflective)

2. **Randomness Generation**
   - Participants imagined 12 coinflips
   - We scored how "random" their sequences were

3. **Randomness Score** (0-1 scale)
   - Based on alternation rate, streak length, head/tail balance
   - Higher = better simulation of randomness

### Main Finding
**r = -0.18, p = 0.09** (not significant)

→ No strong relationship between CRT and randomness quality  
→ Slight trend: higher CRT → slightly worse randomness (possibly overthinking)

---

## 🔍 Key Functions

### Load Data
```r
source("R/01_data_loading.R")
df <- load_survey_data("your_file.xlsx")
```

### Score CRT
```r
source("R/02_crt_scoring.R")
df <- score_crt_items(df)
df <- calculate_total_crt(df)
```

### Calculate Randomness
```r
source("R/03_randomness_metrics.R")
df <- add_randomness_metrics(df)
```

### Visualize
```r
source("R/04_visualization.R")
plots <- create_all_plots(df)
plots$main_scatter  # View scatterplot
```

### Analyze
```r
source("R/05_statistical_analysis.R")
stats <- generate_statistical_report(df)
print_statistical_report(stats)
```

---

## 📊 Example Output

### Statistical Report
```
================================================================================
STATISTICAL ANALYSIS REPORT
================================================================================

DESCRIPTIVE STATISTICS
----------------------------------------------------------------------
  n  crt_mean  crt_sd  randomness_mean  randomness_sd
  83  2.8      2.1     0.81             0.12

PRIMARY RESEARCH QUESTION: CRT-Randomness Correlation
----------------------------------------------------------------------
Pearson correlation: r = -0.180, p = 0.089, 95% CI [-0.383, 0.030]
Significance: NOT SIGNIFICANT (α = 0.05)
Sample size: n = 83
```

### Main Scatterplot
![Example plot structure]
- X-axis: CRT Score (0-7)
- Y-axis: Randomness Score (0-1)
- Blue line: Regression fit with confidence band
- Points: Individual participants (jittered)

---

## 🛠️ Customization

### Use Individual Functions

```r
# Calculate just one metric
sequence <- "HTHHTTHTHTHT"
calc_alternation_rate(sequence)  # Returns: 0.636
calc_max_run(sequence)            # Returns: 2
calc_head_deviation(sequence)     # Returns: 1
```

### Create Custom Plots

```r
library(ggplot2)

# Your own visualization
ggplot(df, aes(x = crt_score, y = alternation_rate)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "CRT vs. Alternation Rate Only")
```

### Export Data

```r
# Save specific subsets
df %>%
  filter(grade == "Senior") %>%
  select(crt_score, randomness_score) %>%
  write_csv("seniors_only.csv")
```

---

## 🚨 Troubleshooting

### Error: "File not found"
**Solution**: Check that raw data file exists
```r
# Update path in main_analysis.R line 16
INPUT_FILE <- "your_actual_filename.xlsx"
```

### Error: Package not installed
**Solution**: Install missing packages
```r
install.packages("tidyverse")  # or readxl, janitor, etc.
```

### Plots not displaying
**Solution**: 
```r
# Explicitly view plot
plots <- create_all_plots(df)
print(plots$main_scatter)
```

### Output folder missing
**Solution**: Script auto-creates it, but you can also:
```r
dir.create("output", showWarnings = FALSE)
```

---

## 📚 Learning Resources

### Want to understand the code?
1. Start with `R/01_data_loading.R` (simplest)
2. Read function documentation (comments with `#'`)
3. Check `docs/METHODOLOGY.md` for statistical details

### Want to extend the project?
1. Read `docs/FUTURE_WORK.md` for ideas
2. See `docs/RESEARCH_SUGGESTIONS.md` for literature-based extensions
3. Review `CONTRIBUTING.md` for how to add code

### Want to cite this work?
See README.md "Citation" section for BibTeX format

---

## 🎯 Common Use Cases

### 1. Replicate Analysis
```r
source("main_analysis.R")
```

### 2. Analyze New Data
```r
# Replace data file, then run
INPUT_FILE <- "my_new_survey.xlsx"
source("main_analysis.R")
```

### 3. Extract Specific Results
```r
source("main_analysis.R")

# Get correlation coefficient
cor(df_final$crt_score, df_final$randomness_score)

# Get descriptive stats
summary(df_final)
```

### 4. Create Custom Report
```r
# Load modules
source("R/05_statistical_analysis.R")

# Generate stats
stats <- generate_statistical_report(df_final)

# Print formatted
print_statistical_report(stats)
```

---

## 💡 Pro Tips

### Tip 1: Run Step-by-Step
Instead of `source("main_analysis.R")`, run each section manually to understand the pipeline:

```r
# Load all modules
source("R/01_data_loading.R")
source("R/02_crt_scoring.R")
source("R/03_randomness_metrics.R")
source("R/04_visualization.R")
source("R/05_statistical_analysis.R")

# Step through analysis
df_raw <- load_survey_data("data.xlsx")
df_clean <- standardize_coinflips(df_raw)
# ... etc
```

### Tip 2: Check Intermediate Results
```r
# After each step, inspect data
head(df_clean)
summary(df_clean)
View(df_clean)  # Open in RStudio viewer
```

### Tip 3: Save Workspace
```r
# Save all objects for later
save.image("my_analysis.RData")

# Load later
load("my_analysis.RData")
```

---

## 🔗 Important Links

- **Full Documentation**: `README.md`
- **Methodology Details**: `docs/METHODOLOGY.md`
- **Research Ideas**: `docs/FUTURE_WORK.md`
- **References**: `docs/REFERENCES.md`
- **How to Contribute**: `CONTRIBUTING.md`

---

## 📞 Getting Help

**Have questions?**
1. Check documentation in `docs/` folder
2. Review code comments in `R/` modules
3. Open an issue on GitHub
4. Email project maintainer (see README.md)

---

## ✅ Quick Checklist

Before running analysis:
- [ ] R installed (version 4.0+)
- [ ] Required packages installed (`tidyverse`, `readxl`, `janitor`, `broom`)
- [ ] Raw data file present
- [ ] RStudio project opened (`.Rproj` file)

After running:
- [ ] Check console for errors
- [ ] Verify `output/` folder has 3 PNG files
- [ ] Review `statistical_results.csv`
- [ ] Examine plots for data quality issues

---

**Ready to go? Run this command:**

```r
source("main_analysis.R")
```

🎉 **Happy analyzing!**

---

*Last Updated: November 2025*  
*For detailed information, see README.md*
