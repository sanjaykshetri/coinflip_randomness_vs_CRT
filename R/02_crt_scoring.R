# ==============================================================================
# Cognitive Reflection Test (CRT) Scoring Functions
# ==============================================================================
# This script contains functions for scoring the CRT-7 test
# Reference: Toplak, M. E., West, R. F., & Stanovich, K. E. (2014)
# ==============================================================================

library(tidyverse)

#' CRT-7 Correct Answers Reference
#'
#' @return Named vector of correct answers for all 7 CRT questions
#' @export
get_crt_answers <- function() {
  c(
    crt_q1 = "5 cents",
    crt_q2 = "5 minutes",
    crt_q3 = "47 days",
    crt_q4 = "4 days",
    crt_q5 = "29 students",
    crt_q6 = "20",
    crt_q7 = "simon has lost money."
  )
}

#' Score Individual CRT Items
#'
#' Compares participant responses to correct answers and assigns binary scores
#'
#' @param df Data frame containing CRT response columns
#' @return Data frame with scored CRT items (1 = correct, 0 = incorrect)
#' @export
score_crt_items <- function(df) {
  correct_answers <- get_crt_answers()
  
  df %>%
    mutate(across(
      .cols = names(correct_answers),
      .fns = ~ as.integer(tolower(str_trim(.x)) == tolower(correct_answers[cur_column()])),
      .names = "{.col}_score"
    ))
}

#' Calculate Total CRT Score
#'
#' Aggregates individual item scores into a total CRT performance score
#'
#' @param df Data frame with scored CRT items
#' @return Data frame with total_crt_score column
#' @export
calculate_total_crt <- function(df) {
  df %>%
    mutate(total_crt_score = rowSums(select(., ends_with("_score")), na.rm = TRUE)) %>%
    select(-ends_with("_score"))
}
