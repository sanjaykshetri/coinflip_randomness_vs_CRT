# ==============================================================================
# Statistical Analysis Functions
# ==============================================================================
# This script contains functions for conducting statistical tests and
# generating summary reports
# ==============================================================================

library(tidyverse)
library(broom)

#' Perform Correlation Analysis
#'
#' Tests the relationship between CRT score and randomness score
#'
#' @param df Data frame with crt_score and randomness_score
#' @param method Correlation method: "pearson", "spearman", or "kendall"
#' @return List containing correlation test results and interpretation
#' @export
analyze_correlation <- function(df, method = "pearson") {
  # Remove missing values
  df_clean <- df %>%
    filter(!is.na(crt_score) & !is.na(randomness_score))
  
  # Perform correlation test
  cor_test <- cor.test(df_clean$crt_score, df_clean$randomness_score, 
                       method = method)
  
  # Extract key statistics
  results <- list(
    correlation = cor_test$estimate,
    p_value = cor_test$p.value,
    ci_lower = cor_test$conf.int[1],
    ci_upper = cor_test$conf.int[2],
    n = nrow(df_clean),
    method = method,
    significant = cor_test$p.value < 0.05
  )
  
  return(results)
}

#' Generate Descriptive Statistics
#'
#' @param df Data frame with analysis variables
#' @return Tibble of summary statistics
#' @export
generate_descriptive_stats <- function(df) {
  df %>%
    summarize(
      n = n(),
      crt_mean = mean(crt_score, na.rm = TRUE),
      crt_sd = sd(crt_score, na.rm = TRUE),
      crt_median = median(crt_score, na.rm = TRUE),
      randomness_mean = mean(randomness_score, na.rm = TRUE),
      randomness_sd = sd(randomness_score, na.rm = TRUE),
      randomness_median = median(randomness_score, na.rm = TRUE)
    )
}

#' Perform Grade-Level ANOVA
#'
#' Tests whether randomness scores differ by academic grade
#'
#' @param df Data frame with grade and randomness_score
#' @return ANOVA results as tidy tibble
#' @export
analyze_grade_differences <- function(df) {
  model <- aov(randomness_score ~ grade, data = df)
  tidy(model)
}

#' Generate Complete Statistical Report
#'
#' @param df Analysis-ready data frame
#' @return List containing all statistical analyses
#' @export
generate_statistical_report <- function(df) {
  list(
    descriptive_stats = generate_descriptive_stats(df),
    correlation_pearson = analyze_correlation(df, method = "pearson"),
    correlation_spearman = analyze_correlation(df, method = "spearman"),
    grade_anova = analyze_grade_differences(df)
  )
}

#' Print Formatted Statistical Report
#'
#' @param stats_list Output from generate_statistical_report()
#' @export
print_statistical_report <- function(stats_list) {
  cat("=" %R% 70 %R% "\n")
  cat("STATISTICAL ANALYSIS REPORT\n")
  cat("=" %R% 70 %R% "\n\n")
  
  cat("DESCRIPTIVE STATISTICS\n")
  cat("-" %R% 70 %R% "\n")
  print(stats_list$descriptive_stats)
  cat("\n")
  
  cat("PRIMARY RESEARCH QUESTION: CRT-Randomness Correlation\n")
  cat("-" %R% 70 %R% "\n")
  cor_result <- stats_list$correlation_pearson
  cat(sprintf("Pearson correlation: r = %.3f, p = %.3f, 95%% CI [%.3f, %.3f]\n",
              cor_result$correlation, cor_result$p_value,
              cor_result$ci_lower, cor_result$ci_upper))
  cat(sprintf("Significance: %s (α = 0.05)\n", 
              ifelse(cor_result$significant, "SIGNIFICANT", "NOT SIGNIFICANT")))
  cat(sprintf("Sample size: n = %d\n\n", cor_result$n))
  
  cat("ROBUSTNESS CHECK: Spearman Rank Correlation\n")
  cat("-" %R% 70 %R% "\n")
  spear_result <- stats_list$correlation_spearman
  cat(sprintf("Spearman rho = %.3f, p = %.3f\n\n", 
              spear_result$correlation, spear_result$p_value))
}

# Custom operator for string repetition (for formatting)
`%R%` <- function(x, n) paste(rep(x, n), collapse = "")
