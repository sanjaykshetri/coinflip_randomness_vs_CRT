# ==============================================================================
# MAIN ANALYSIS SCRIPT
# Coinflip Randomness vs. Cognitive Reflection Test Study
# ==============================================================================
# This script orchestrates the complete data analysis pipeline
# Author: Sanjay K Shetri
# Repository: github.com/sanjaykshetri/coinflip_randomness_vs_CRT
# ==============================================================================

# Load required packages
library(tidyverse)
library(readxl)
library(janitor)

# Source all analysis modules
source("R/01_data_loading.R")
source("R/02_crt_scoring.R")
source("R/03_randomness_metrics.R")
source("R/04_visualization.R")
source("R/05_statistical_analysis.R")

# ==============================================================================
# CONFIGURATION
# ==============================================================================

INPUT_FILE <- "coinflip_crt_survey_data_edited.xlsx"  # Update path if needed
OUTPUT_DIR <- "output"
DATA_DIR <- "data"

# Create output directory if it doesn't exist
if (!dir.exists(OUTPUT_DIR)) {
  dir.create(OUTPUT_DIR, recursive = TRUE)
}

# ==============================================================================
# DATA PROCESSING PIPELINE
# ==============================================================================

cat("\n")
cat("=" %R% 80 %R% "\n")
cat("COINFLIP RANDOMNESS vs. COGNITIVE REFLECTION TEST ANALYSIS\n")
cat("=" %R% 80 %R% "\n\n")

# Step 1: Load raw data
cat("STEP 1: Loading raw survey data...\n")
df_raw <- load_survey_data(INPUT_FILE)
cat("✓ Data loaded successfully\n\n")

# Step 2: Standardize coinflip notation
cat("STEP 2: Standardizing coinflip notation (HEAD/TAIL -> H/T)...\n")
df_standardized <- standardize_coinflips(df_raw)
cat("✓ Coinflips standardized\n\n")

# Step 3: Consolidate flip columns
cat("STEP 3: Consolidating flip columns into sequences...\n")
df_consolidated <- consolidate_flips(df_standardized)
cat("✓ Sequences created\n\n")

# Step 4: Score CRT items
cat("STEP 4: Scoring Cognitive Reflection Test (CRT-7)...\n")
df_scored <- score_crt_items(df_consolidated)
df_crt <- calculate_total_crt(df_scored)
cat("✓ CRT scores calculated\n\n")

# Step 5: Calculate randomness metrics
cat("STEP 5: Computing randomness metrics...\n")
df_randomness <- add_randomness_metrics(df_crt)
cat("✓ Randomness scores computed\n\n")

# Step 6: Create final clean dataset
cat("STEP 6: Preparing final analysis dataset...\n")
df_final <- df_randomness %>%
  drop_na(coinflips, randomness_score, total_crt_score) %>%
  select(
    crt_score = total_crt_score,
    randomness_score,
    alternation_rate,
    max_run,
    head_deviation,
    grade,
    sleep_hrs,
    coinflips
  )

cat(sprintf("✓ Final dataset: %d participants (removed %d with missing data)\n\n",
            nrow(df_final), nrow(df_randomness) - nrow(df_final)))

# ==============================================================================
# STATISTICAL ANALYSIS
# ==============================================================================

cat("\nConducting statistical analyses...\n")
stats_report <- generate_statistical_report(df_final)
cat("\n")
print_statistical_report(stats_report)

# ==============================================================================
# VISUALIZATION
# ==============================================================================

cat("\nGenerating visualizations...\n")
plots <- create_all_plots(df_final)

# Save plots
ggsave(file.path(OUTPUT_DIR, "fig1_crt_vs_randomness.png"), 
       plots$main_scatter, width = 8, height = 6, dpi = 300)
ggsave(file.path(OUTPUT_DIR, "fig2_randomness_by_grade.png"), 
       plots$grade_boxplot, width = 8, height = 6, dpi = 300)
ggsave(file.path(OUTPUT_DIR, "fig3_crt_distribution.png"), 
       plots$crt_distribution, width = 8, height = 6, dpi = 300)

cat("✓ Figures saved to output/ directory\n\n")

# ==============================================================================
# EXPORT RESULTS
# ==============================================================================

cat("Exporting results...\n")

# Save cleaned data
write_csv(df_final, file.path(DATA_DIR, "final_data_ready.csv"))
cat("✓ Clean data saved to data/final_data_ready.csv\n")

# Save statistical results
stats_summary <- tibble(
  analysis = c("Correlation (Pearson)", "Correlation (Spearman)"),
  statistic = c(stats_report$correlation_pearson$correlation,
                stats_report$correlation_spearman$correlation),
  p_value = c(stats_report$correlation_pearson$p_value,
              stats_report$correlation_spearman$p_value),
  n = c(stats_report$correlation_pearson$n,
        stats_report$correlation_spearman$n)
)
write_csv(stats_summary, file.path(OUTPUT_DIR, "statistical_results.csv"))
cat("✓ Statistical results saved to output/statistical_results.csv\n")

# ==============================================================================
# INTERPRETATION
# ==============================================================================

cat("\n")
cat("=" %R% 80 %R% "\n")
cat("KEY FINDINGS\n")
cat("=" %R% 80 %R% "\n\n")

cor_val <- stats_report$correlation_pearson$correlation
p_val <- stats_report$correlation_pearson$p_value

if (p_val < 0.05) {
  cat("→ SIGNIFICANT relationship found between CRT and randomness intuition\n")
  if (cor_val > 0) {
    cat("  Higher CRT scores associated with BETTER randomness simulation\n")
  } else {
    cat("  Higher CRT scores associated with WORSE randomness simulation\n")
    cat("  (Possible over-correction or 'trying too hard to be random')\n")
  }
} else {
  cat("→ NO significant relationship found between CRT and randomness intuition\n")
  cat("  Cognitive reflection ability does not predict randomness generation performance\n")
  if (abs(cor_val) > 0.15) {
    cat(sprintf("  (Weak trend observed: r = %.3f, but not statistically reliable)\n", cor_val))
  }
}

cat("\nAnalysis complete! Check the output/ directory for figures and results.\n\n")

# Custom operator for string repetition
`%R%` <- function(x, n) paste(rep(x, n), collapse = "")
