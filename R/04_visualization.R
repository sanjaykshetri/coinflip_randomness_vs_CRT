# ==============================================================================
# Visualization Functions
# ==============================================================================
# This script contains publication-quality plotting functions
# ==============================================================================

library(tidyverse)
library(ggplot2)

#' Create CRT vs Randomness Scatterplot
#'
#' @param df Data frame with crt_score and randomness_score columns
#' @param add_regression Logical, whether to add regression line
#' @return ggplot object
#' @export
plot_crt_vs_randomness <- function(df, add_regression = TRUE) {
  p <- ggplot(df, aes(x = crt_score, y = randomness_score)) +
    geom_jitter(width = 0.15, height = 0.01, alpha = 0.6, size = 2.5) +
    labs(
      title = "Cognitive Reflection vs. Randomness Intuition",
      subtitle = "Are better analytical thinkers better at simulating randomness?",
      x = "CRT Score (0-7)",
      y = "Randomness Score (0-1)",
      caption = "Note: Each point represents one participant. Points are jittered to reduce overlap."
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      plot.subtitle = element_text(color = "gray40"),
      panel.grid.minor = element_blank()
    ) +
    scale_x_continuous(breaks = 0:7) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2))
  
  if (add_regression) {
    p <- p + geom_smooth(method = "lm", se = TRUE, color = "steelblue", 
                         fill = "lightblue", alpha = 0.2)
  }
  
  return(p)
}

#' Create Randomness Score Distribution by Grade
#'
#' @param df Data frame with grade and randomness_score columns
#' @return ggplot object
#' @export
plot_randomness_by_grade <- function(df) {
  # Order grade levels properly
  df <- df %>%
    mutate(grade = factor(grade, levels = c("Freshman", "Sophomore", "Junior", "Senior")))
  
  ggplot(df, aes(x = grade, y = randomness_score, fill = grade)) +
    geom_boxplot(alpha = 0.7, outlier.shape = 21) +
    geom_jitter(width = 0.2, alpha = 0.3, size = 1.5) +
    labs(
      title = "Randomness Intuition Across Grade Levels",
      x = "Academic Year",
      y = "Randomness Score (0-1)",
      caption = "Box shows median and interquartile range; points show individual observations."
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      legend.position = "none",
      panel.grid.minor = element_blank()
    ) +
    scale_fill_brewer(palette = "Set2") +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2))
}

#' Create CRT Score Distribution
#'
#' @param df Data frame with crt_score column
#' @return ggplot object
#' @export
plot_crt_distribution <- function(df) {
  ggplot(df, aes(x = crt_score)) +
    geom_bar(fill = "steelblue", alpha = 0.8) +
    labs(
      title = "Distribution of CRT-7 Scores",
      x = "CRT Score (0-7)",
      y = "Number of Participants",
      caption = "CRT-7: Cognitive Reflection Test with 7 items"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      panel.grid.minor = element_blank()
    ) +
    scale_x_continuous(breaks = 0:7)
}

#' Create Combined Visualization Panel
#'
#' @param df Analysis-ready data frame
#' @return List of ggplot objects
#' @export
create_all_plots <- function(df) {
  list(
    main_scatter = plot_crt_vs_randomness(df),
    grade_boxplot = plot_randomness_by_grade(df),
    crt_distribution = plot_crt_distribution(df)
  )
}
