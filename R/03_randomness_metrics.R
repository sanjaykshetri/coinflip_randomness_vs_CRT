# ==============================================================================
# Randomness Scoring Functions
# ==============================================================================
# This script implements metrics for quantifying the "randomness" of coinflip
# sequences based on psychological and statistical literature
# References:
#   - Falk & Konold (1997): The Psychology of Learning Probability
#   - Gilovich et al. (1985): The Hot Hand in Basketball
# ==============================================================================

library(tidyverse)

#' Calculate Alternation Rate
#'
#' Measures how frequently consecutive flips alternate (H->T or T->H)
#' Expected value for truly random sequence ≈ 0.5
#'
#' @param seq Character string of flip sequence (e.g., "HTHHTHT")
#' @return Numeric value between 0 and 1
#' @export
calc_alternation_rate <- function(seq) {
  if (is.na(seq) || nchar(seq) < 2) return(NA_real_)
  
  flips <- unlist(strsplit(seq, ""))
  alternations <- sum(head(flips, -1) != tail(flips, -1))
  alternations / (length(flips) - 1)
}

#' Calculate Maximum Run Length
#'
#' Finds the longest consecutive streak of H or T
#' For 12 flips, expected max run ≈ 3-4
#'
#' @param seq Character string of flip sequence
#' @return Integer value of longest run
#' @export
calc_max_run <- function(seq) {
  if (is.na(seq) || nchar(seq) == 0) return(NA_integer_)
  
  flips <- unlist(strsplit(seq, ""))
  max(rle(flips)$lengths)
}

#' Calculate Head Deviation
#'
#' Measures deviation from expected 50/50 split of heads and tails
#' For 12 flips, ideal is 6 heads
#'
#' @param seq Character string of flip sequence
#' @return Numeric value of absolute deviation from 6 heads
#' @export
calc_head_deviation <- function(seq) {
  if (is.na(seq)) return(NA_real_)
  abs(str_count(seq, "H") - 6)
}

#' Calculate Composite Randomness Score
#'
#' Combines multiple randomness metrics into a single score (0-1 scale)
#' Higher scores indicate better simulation of randomness
#'
#' @param df Data frame with coinflips column
#' @return Data frame with randomness metrics and composite score
#' @export
calculate_randomness_score <- function(df) {
  df %>%
    mutate(
      alternation_rate = map_dbl(coinflips, calc_alternation_rate),
      max_run = map_int(coinflips, calc_max_run),
      head_deviation = map_dbl(coinflips, calc_head_deviation)
    ) %>%
    mutate(
      # Penalty terms: deviation from ideal values
      alt_penalty = abs(alternation_rate - 0.5),
      run_penalty = abs(max_run - 3.5) / 3.5,
      head_penalty = head_deviation / 6
    ) %>%
    mutate(
      # Composite score: 1 - average penalty
      randomness_score = 1 - (alt_penalty + run_penalty + head_penalty) / 3
    ) %>%
    # Keep key metrics but remove intermediate penalty columns
    select(-ends_with("_penalty"))
}

#' Apply All Randomness Metrics
#'
#' Convenience wrapper function to apply all randomness calculations
#'
#' @param df Data frame containing coinflips column
#' @return Data frame with all randomness metrics
#' @export
add_randomness_metrics <- function(df) {
  calculate_randomness_score(df)
}
