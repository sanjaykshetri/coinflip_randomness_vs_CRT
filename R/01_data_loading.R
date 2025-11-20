# ==============================================================================
# Data Loading and Initial Cleaning
# ==============================================================================
# This script loads the raw survey data and performs initial cleaning operations
# Author: Sanjay K Shetri
# Date: 2025-11-20
# ==============================================================================

library(readxl)
library(tidyverse)
library(janitor)

#' Load and Clean Raw Survey Data
#'
#' @param file_path Character string of path to the Excel file
#' @return A cleaned tibble with standardized column names
#' @export
load_survey_data <- function(file_path) {
  if (!file.exists(file_path)) {
    stop("File not found: ", file_path)
  }
  
  df <- read_excel(file_path) %>%
    clean_names()
  
  message("Data loaded successfully: ", nrow(df), " rows, ", ncol(df), " columns")
  return(df)
}

#' Standardize Coinflip Notation
#'
#' Converts HEAD/TAIL to H/T notation
#'
#' @param df Data frame containing flip columns
#' @return Data frame with standardized flip notation
#' @export
standardize_coinflips <- function(df) {
  df %>%
    mutate(across(
      starts_with("flip_"),
      ~ case_when(
        .x == "HEAD" ~ "H",
        .x == "TAIL" ~ "T",
        TRUE ~ NA_character_
      )
    ))
}

#' Consolidate Flip Columns into Single Sequence
#'
#' Combines individual flip columns into one string (e.g., "HTHHTHT...")
#'
#' @param df Data frame with individual flip columns
#' @return Data frame with consolidated coinflips column
#' @export
consolidate_flips <- function(df) {
  df %>%
    mutate(coinflips = pmap_chr(select(., starts_with("flip_")), str_c)) %>%
    select(-starts_with("flip_"), -timestamp)
}
