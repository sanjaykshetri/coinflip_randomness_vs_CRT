# ==============================================================================
# Utility Functions for Shiny App
# ==============================================================================

library(tidyverse)

#' Validate Coinflip Input
#'
#' Checks if the input is exactly 20 characters and contains only H and T
#'
#' @param input Character string from user
#' @return Logical TRUE if valid, FALSE otherwise
validate_coinflip <- function(input) {
  if (is.null(input) || input == "") return(FALSE)
  
  # Check length
  if (nchar(input) != 20) return(FALSE)
  
  # Check characters (case-insensitive)
  clean_input <- toupper(input)
  valid_chars <- all(str_split(clean_input, "")[[1]] %in% c("H", "T"))
  
  return(valid_chars)
}

#' Validate CRT Responses
#'
#' Checks if all CRT questions have been answered
#'
#' @param input Shiny input object
#' @return Logical TRUE if all answered, FALSE otherwise
validate_crt_responses <- function(input) {
  all(
    nchar(input$crt1) > 0,
    nchar(input$crt2) > 0,
    nchar(input$crt3) > 0,
    nchar(input$crt4) > 0,
    nchar(input$crt5) > 0,
    nchar(input$crt6) > 0,
    nchar(input$crt7) > 0
  )
}

#' Generate Unique Submission ID
#'
#' Creates a unique identifier for each submission
#'
#' @return Character string with timestamp-based ID
generate_submission_id <- function() {
  paste0("SUB_", format(Sys.time(), "%Y%m%d_%H%M%S"), "_", 
         sample(1000:9999, 1))
}

#' Save Response Data to CSV
#'
#' Appends new response to the data file
#'
#' @param response_data List containing all response fields
#' @return Submission ID
save_response_data <- function(response_data) {
  
  # Generate submission ID
  submission_id <- generate_submission_id()
  
  # Create data directory if it doesn't exist
  data_dir <- "data"
  if (!dir.exists(data_dir)) {
    dir.create(data_dir, recursive = TRUE)
  }
  
  # File path
  data_file <- file.path(data_dir, "survey_responses.csv")
  
  # Convert list to data frame
  df <- data.frame(
    submission_id = submission_id,
    timestamp = as.character(response_data$timestamp),
    coinflip_sequence = response_data$coinflip_sequence,
    crt1 = response_data$crt1,
    crt2 = response_data$crt2,
    crt3 = response_data$crt3,
    crt4 = response_data$crt4,
    crt5 = response_data$crt5,
    crt6 = response_data$crt6,
    crt7 = response_data$crt7,
    age = response_data$age,
    gender = response_data$gender,
    education = response_data$education,
    academic_year = response_data$academic_year,
    major = ifelse(is.null(response_data$major) || response_data$major == "", 
                   NA, response_data$major),
    stats_courses = response_data$stats_courses,
    stringsAsFactors = FALSE
  )
  
  # Append to file (create if doesn't exist)
  if (file.exists(data_file)) {
    existing_data <- read.csv(data_file, stringsAsFactors = FALSE)
    combined_data <- rbind(existing_data, df)
    write.csv(combined_data, data_file, row.names = FALSE)
  } else {
    write.csv(df, data_file, row.names = FALSE)
  }
  
  return(submission_id)
}

#' Load All Survey Responses
#'
#' Reads all responses from CSV and calculates scores
#'
#' @return Data frame with all responses and calculated metrics
load_all_responses <- function() {
  
  data_file <- "data/survey_responses.csv"
  
  # Check if file exists
  if (!file.exists(data_file)) {
    return(NULL)
  }
  
  # Read data
  data <- read.csv(data_file, stringsAsFactors = FALSE)
  
  # Check if empty
  if (nrow(data) == 0) {
    return(NULL)
  }
  
  # Calculate CRT scores
  data$crt_score <- score_crt(data)
  
  # Calculate randomness metrics
  data$randomness_score <- sapply(data$coinflip_sequence, calculate_randomness_score)
  data$alternation_rate <- sapply(data$coinflip_sequence, calc_alternation_rate)
  data$max_run <- sapply(data$coinflip_sequence, calc_max_run)
  data$head_count <- sapply(data$coinflip_sequence, function(x) str_count(x, "H"))
  
  return(data)
}

#' Clean Input Text
#'
#' Removes extra whitespace and standardizes text
#'
#' @param text Character string
#' @return Cleaned text
clean_text <- function(text) {
  if (is.null(text) || is.na(text)) return("")
  tolower(str_trim(text))
}
