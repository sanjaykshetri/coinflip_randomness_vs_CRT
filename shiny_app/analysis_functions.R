# ==============================================================================
# Analysis Functions for Shiny App
# ==============================================================================
# These functions calculate randomness metrics and CRT scores
# ==============================================================================

library(tidyverse)

# ==============================================================================
# RANDOMNESS METRICS
# ==============================================================================

#' Calculate Alternation Rate
#'
#' Measures how frequently consecutive flips alternate
#'
#' @param seq Character string of coinflip sequence
#' @return Numeric value between 0 and 1
calc_alternation_rate <- function(seq) {
  if (is.na(seq) || nchar(seq) < 2) return(NA_real_)
  
  flips <- unlist(strsplit(toupper(seq), ""))
  alternations <- sum(head(flips, -1) != tail(flips, -1))
  alternations / (length(flips) - 1)
}

#' Calculate Maximum Run Length
#'
#' Finds the longest consecutive streak of H or T
#'
#' @param seq Character string of coinflip sequence
#' @return Integer value of longest run
calc_max_run <- function(seq) {
  if (is.na(seq) || nchar(seq) == 0) return(NA_integer_)
  
  flips <- unlist(strsplit(toupper(seq), ""))
  max(rle(flips)$lengths)
}

#' Calculate Head Deviation
#'
#' Measures deviation from 50/50 split (10 heads in 20 flips)
#'
#' @param seq Character string of coinflip sequence
#' @return Numeric value of absolute deviation from 10 heads
calc_head_deviation <- function(seq) {
  if (is.na(seq)) return(NA_real_)
  abs(str_count(toupper(seq), "H") - 10)
}

#' Calculate Composite Randomness Score
#'
#' Combines multiple metrics into single score (0-1 scale)
#' Higher scores indicate better simulation of randomness
#'
#' @param seq Character string of coinflip sequence
#' @return Numeric value between 0 and 1
calculate_randomness_score <- function(seq) {
  if (is.na(seq) || nchar(seq) != 20) return(NA_real_)
  
  # Calculate individual metrics
  alt_rate <- calc_alternation_rate(seq)
  max_run <- calc_max_run(seq)
  head_dev <- calc_head_deviation(seq)
  
  # Check for NA values
  if (is.na(alt_rate) || is.na(max_run) || is.na(head_dev)) {
    return(NA_real_)
  }
  
  # Calculate penalties (deviations from ideal values)
  # For 20 flips:
  # - Ideal alternation rate: 0.5
  # - Ideal max run: 4-5
  # - Ideal head deviation: 0 (exactly 10 heads)
  
  alt_penalty <- abs(alt_rate - 0.5)
  run_penalty <- abs(max_run - 4.5) / 4.5
  head_penalty <- head_dev / 10
  
  # Composite score: 1 - average penalty
  score <- 1 - (alt_penalty + run_penalty + head_penalty) / 3
  
  return(max(0, min(1, score)))  # Bound between 0 and 1
}

# ==============================================================================
# CRT SCORING
# ==============================================================================

#' Score Cognitive Reflection Test
#'
#' Scores all 7 CRT questions and returns total score
#'
#' @param data Data frame with CRT response columns
#' @return Vector of CRT scores (0-7)
score_crt <- function(data) {
  
  # Define correct answers (case-insensitive, flexible matching)
  correct_answers <- list(
    crt1 = c("5 cents", "0.05", "5c", "5", "five cents", "$0.05", ".05"),
    crt2 = c("5 minutes", "5 mins", "5 min", "5", "five minutes"),
    crt3 = c("47 days", "47", "forty seven days", "forty-seven days"),
    crt4 = c("second place", "2nd place", "second", "2nd", "2"),
    crt5 = c("8 sheep", "8", "eight", "eight sheep"),
    crt6 = c("emily", "emily's"),
    crt7 = c("0 cubic feet", "0", "zero", "none", "no dirt", "0 cubic ft")
  )
  
  # Function to check if answer is correct
  check_answer <- function(response, correct_list) {
    if (is.na(response) || response == "") return(0)
    
    # Clean response
    clean_response <- tolower(str_trim(response))
    clean_response <- gsub("[^a-z0-9 .]", "", clean_response)
    
    # Check if matches any correct answer
    any(sapply(correct_list, function(correct) {
      clean_correct <- tolower(str_trim(correct))
      clean_correct <- gsub("[^a-z0-9 .]", "", clean_correct)
      grepl(clean_correct, clean_response, fixed = TRUE) || 
        grepl(clean_response, clean_correct, fixed = TRUE)
    }))
  }
  
  # Score each question
  scores <- sapply(1:nrow(data), function(i) {
    score <- 0
    score <- score + check_answer(data$crt1[i], correct_answers$crt1)
    score <- score + check_answer(data$crt2[i], correct_answers$crt2)
    score <- score + check_answer(data$crt3[i], correct_answers$crt3)
    score <- score + check_answer(data$crt4[i], correct_answers$crt4)
    score <- score + check_answer(data$crt5[i], correct_answers$crt5)
    score <- score + check_answer(data$crt6[i], correct_answers$crt6)
    score <- score + check_answer(data$crt7[i], correct_answers$crt7)
    return(as.integer(score))
  })
  
  return(scores)
}

#' Calculate Summary Statistics
#'
#' Generates descriptive statistics for dashboard
#'
#' @param data Data frame with scored responses
#' @return List of summary statistics
calculate_summary_stats <- function(data) {
  if (is.null(data) || nrow(data) == 0) {
    return(list(
      n = 0,
      crt_mean = NA,
      crt_sd = NA,
      randomness_mean = NA,
      randomness_sd = NA,
      correlation = NA
    ))
  }
  
  list(
    n = nrow(data),
    crt_mean = mean(data$crt_score, na.rm = TRUE),
    crt_sd = sd(data$crt_score, na.rm = TRUE),
    crt_median = median(data$crt_score, na.rm = TRUE),
    randomness_mean = mean(data$randomness_score, na.rm = TRUE),
    randomness_sd = sd(data$randomness_score, na.rm = TRUE),
    randomness_median = median(data$randomness_score, na.rm = TRUE),
    correlation = cor(data$crt_score, data$randomness_score, use = "complete.obs")
  )
}
