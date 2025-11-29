# ==============================================================================
# User Dashboard: Coin Flip Randomness & CRT-7 Test
# ==============================================================================
# Interactive dashboard for users to test their randomness intuition and
# cognitive reflection, then see immediate personalized feedback
# ==============================================================================

library(shiny)
library(shinyjs)
library(dplyr)
library(stringr)
library(plotly)
library(scales)

# Source analysis functions
source("analysis_functions.R")

# ==============================================================================
# USER INTERFACE
# ==============================================================================

ui <- fluidPage(
  
  useShinyjs(),
  
  # Custom CSS
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap');
      
      body {
        font-family: 'Inter', sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        padding: 20px;
      }
      
      .main-container {
        background: white;
        border-radius: 15px;
        padding: 40px;
        margin: 0 auto;
        max-width: 1000px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.3);
      }
      
      .page-header {
        text-align: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 3px solid #667eea;
      }
      
      .page-header h1 {
        color: #2d3748;
        font-weight: 700;
        font-size: 2.5em;
        margin-bottom: 10px;
      }
      
      .page-header p {
        color: #718096;
        font-size: 1.2em;
      }
      
      .instruction-box {
        background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
        border-left: 5px solid #667eea;
        padding: 25px;
        margin: 25px 0;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      }
      
      .instruction-box h3 {
        color: #667eea;
        margin-top: 0;
      }
      
      .coinflip-input {
        font-family: 'Courier New', monospace;
        font-size: 1.5em;
        text-align: center;
        letter-spacing: 4px;
        padding: 20px;
        border: 3px solid #667eea;
        border-radius: 10px;
        background: #f7fafc;
        font-weight: 600;
      }
      
      .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        padding: 15px 40px;
        font-size: 1.2em;
        border-radius: 10px;
        font-weight: 600;
        color: white;
        transition: all 0.3s;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
      }
      
      .btn-primary:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
      }
      
      .crt-question {
        background: #f7fafc;
        padding: 25px;
        margin: 20px 0;
        border-radius: 10px;
        border: 2px solid #e2e8f0;
        transition: all 0.3s;
      }
      
      .crt-question:hover {
        border-color: #667eea;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.1);
      }
      
      .crt-question h4 {
        color: #2d3748;
        margin-bottom: 15px;
        font-size: 1.2em;
      }
      
      .crt-question input[type='text'] {
        font-size: 1.1em;
        padding: 12px;
        border: 2px solid #cbd5e0;
        border-radius: 8px;
      }
      
      .results-container {
        background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
        padding: 30px;
        border-radius: 15px;
        margin: 20px 0;
      }
      
      .metric-card {
        background: white;
        padding: 25px;
        border-radius: 12px;
        text-align: center;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        margin: 15px 0;
        transition: all 0.3s;
      }
      
      .metric-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
      }
      
      .metric-title {
        font-size: 1.1em;
        color: #718096;
        font-weight: 600;
        margin-bottom: 10px;
      }
      
      .metric-value {
        font-size: 3em;
        font-weight: 700;
        color: #667eea;
        margin: 15px 0;
      }
      
      .metric-interpretation {
        font-size: 1em;
        color: #4a5568;
        font-style: italic;
      }
      
      .alert-info {
        background: #bee3f8;
        color: #2c5282;
        border: 2px solid #90cdf4;
        padding: 20px;
        border-radius: 10px;
        margin: 20px 0;
      }
      
      .alert-success {
        background: #c6f6d5;
        color: #22543d;
        border: 2px solid #9ae6b4;
        padding: 20px;
        border-radius: 10px;
        margin: 20px 0;
      }
      
      .flip-counter {
        font-size: 1.5em;
        font-weight: 600;
        padding: 15px;
        border-radius: 8px;
        display: inline-block;
        margin: 10px 0;
      }
      
      .counter-incomplete {
        background: #fed7d7;
        color: #c53030;
      }
      
      .counter-complete {
        background: #c6f6d5;
        color: #22543d;
      }
      
      .sequence-analysis {
        background: white;
        padding: 25px;
        border-radius: 12px;
        margin: 20px 0;
        border: 2px solid #e2e8f0;
      }
      
      .radio-group label {
        font-size: 1.05em;
        padding: 8px;
      }
      
      .your-sequence {
        font-family: 'Courier New', monospace;
        font-size: 1.8em;
        letter-spacing: 3px;
        padding: 20px;
        background: #f7fafc;
        border-radius: 8px;
        text-align: center;
        font-weight: 600;
        color: #2d3748;
        margin: 20px 0;
      }
    "))
  ),
  
  # Main container
  div(class = "main-container",
    
    # Application title
    div(class = "page-header",
      h1("🪙 Randomness Intuition Test"),
      p("Test your ability to generate random sequences and measure your cognitive reflection")
    ),
    
    # Main content area - changes based on state
    uiOutput("main_content")
  )
)

# ==============================================================================
# SERVER
# ==============================================================================

server <- function(input, output, session) {
  
  # Reactive values to track state
  rv <- reactiveValues(
    stage = "welcome",  # welcome, coinflip, crt, results
    flip_count = NULL,
    coinflip_sequence = NULL,
    crt_responses = NULL,
    analysis_results = NULL
  )
  
  # ===========================================================================
  # MAIN CONTENT RENDERER
  # ===========================================================================
  
  output$main_content <- renderUI({
    
    if (rv$stage == "welcome") {
      return(render_welcome_stage())
    }
    
    if (rv$stage == "coinflip") {
      return(render_coinflip_stage())
    }
    
    if (rv$stage == "crt") {
      return(render_crt_stage())
    }
    
    if (rv$stage == "results") {
      return(render_results_stage())
    }
  })
  
  # ===========================================================================
  # WELCOME STAGE
  # ===========================================================================
  
  render_welcome_stage <- function() {
    tagList(
      div(class = "instruction-box",
        h3("Welcome! 👋"),
        p("This interactive test will measure two things:"),
        tags$ol(
          tags$li(strong("Your randomness intuition:"), " How well can you mentally simulate random coin flips?"),
          tags$li(strong("Your cognitive reflection:"), " How carefully do you think through problems?")
        ),
        p("The entire test takes about 5-8 minutes."),
        br(),
        p(strong("At the end, you'll receive:"), style = "color: #667eea; font-size: 1.1em;"),
        tags$ul(
          tags$li("Your personalized randomness score and detailed analysis"),
          tags$li("Your CRT-7 test results with explanations"),
          tags$li("Insights into your cognitive patterns")
        )
      ),
      
      div(class = "instruction-box",
        h3("Choose Your Test Length"),
        p("Select how many coin flips you'd like to imagine:"),
        br(),
        radioButtons("flip_count_choice",
          label = NULL,
          choices = c(
            "12 flips (Quick, ~3 minutes)" = "12",
            "20 flips (Standard, ~5 minutes)" = "20",
            "50 flips (Challenging, ~7 minutes)" = "50",
            "100 flips (Advanced, ~8 minutes)" = "100",
            "200 flips (Expert, ~10 minutes)" = "200"
          ),
          selected = "20"
        )
      ),
      
      br(),
      
      div(style = "text-align: center;",
        actionButton("btn_start",
          "Start Test →",
          class = "btn btn-primary btn-lg",
          style = "font-size: 1.3em; padding: 20px 50px;")
      )
    )
  }
  
  observeEvent(input$btn_start, {
    rv$flip_count <- as.numeric(input$flip_count_choice)
    rv$stage <- "coinflip"
  })
  
  # ===========================================================================
  # COINFLIP STAGE
  # ===========================================================================
  
  render_coinflip_stage <- function() {
    tagList(
      div(class = "instruction-box",
        h3(paste0("🪙 Mental Coin Flipping (", rv$flip_count, " flips)")),
        p(strong("Your Task:"), paste0(" Imagine flipping a fair coin ", rv$flip_count, " times. What sequence would come up?")),
        br(),
        tags$ul(
          tags$li("Type ", tags$strong("H"), " for Heads and ", tags$strong("T"), " for Tails"),
          tags$li(paste0("Enter exactly ", tags$strong(rv$flip_count), " characters")),
          tags$li("Try to make it as ", tags$em("realistic"), " as possible - what would actually happen?"),
          tags$li(tags$strong("Example:"), " HTHHTHTTHH...")
        ),
        br(),
        p("Don't overthink it - just imagine the flips happening and record what you see!", 
          style = "font-style: italic; color: #4a5568;")
      ),
      
      br(),
      
      textInput("coinflip_input",
        label = h4(paste0("Your ", rv$flip_count, "-Flip Sequence:")),
        value = "",
        placeholder = paste0("Enter ", rv$flip_count, " characters using only H and T"),
        width = "100%"
      ),
      
      # Character counter
      uiOutput("flip_counter_ui"),
      
      br(),
      
      div(style = "text-align: center;",
        actionButton("btn_coinflip_next",
          "Continue to Questions →",
          class = "btn btn-primary",
          style = "font-size: 1.2em; padding: 15px 40px;")
      )
    )
  }
  
  output$flip_counter_ui <- renderUI({
    input_text <- toupper(input$coinflip_input)
    input_length <- nchar(input_text)
    target <- rv$flip_count
    
    # Check if valid characters
    invalid_chars <- grepl("[^HT]", input_text)
    
    if (invalid_chars) {
      div(class = "flip-counter counter-incomplete",
        "⚠️ Please use only H and T characters"
      )
    } else if (input_length < target) {
      div(class = "flip-counter counter-incomplete",
        paste0("Characters: ", input_length, " / ", target, " (", target - input_length, " more needed)")
      )
    } else if (input_length == target) {
      div(class = "flip-counter counter-complete",
        paste0("✓ Perfect! ", input_length, " / ", target, " characters")
      )
    } else {
      div(class = "flip-counter counter-incomplete",
        paste0("⚠️ Too long: ", input_length, " / ", target, " (remove ", input_length - target, " characters)")
      )
    }
  })
  
  observeEvent(input$btn_coinflip_next, {
    input_text <- toupper(str_trim(input$coinflip_input))
    
    # Validate
    if (nchar(input_text) != rv$flip_count) {
      showNotification(
        paste0("Please enter exactly ", rv$flip_count, " characters"),
        type = "error",
        duration = 3
      )
      return()
    }
    
    if (grepl("[^HT]", input_text)) {
      showNotification(
        "Please use only H and T characters",
        type = "error",
        duration = 3
      )
      return()
    }
    
    # Save and move on
    rv$coinflip_sequence <- input_text
    rv$stage <- "crt"
    
    # Reset scroll to top
    runjs("window.scrollTo(0, 0);")
  })
  
  # ===========================================================================
  # CRT STAGE
  # ===========================================================================
  
  render_crt_stage <- function() {
    tagList(
      div(class = "instruction-box",
        h3("🧠 Cognitive Reflection Test (CRT-7)"),
        p("Now, please answer these 7 questions. Each question tests your ability to override an intuitive (but incorrect) response."),
        p(strong("Tips:")),
        tags$ul(
          tags$li("Take your time - there's no rush"),
          tags$li("Your first instinct might be wrong!"),
          tags$li("Think carefully before answering")
        )
      ),
      
      br(),
      
      # Question 1
      div(class = "crt-question",
        h4("Question 1 of 7"),
        p("A bat and a ball cost $1.10 in total. The bat costs $1.00 more than the ball. How much does the ball cost?"),
        radioButtons("crt1",
          label = "Your answer:",
          choices = c(
            "10 cents" = "10 cents",
            "5 cents" = "5 cents",
            "15 cents" = "15 cents",
            "1 cent" = "1 cent"
          ),
          selected = character(0))
      ),
      
      # Question 2
      div(class = "crt-question",
        h4("Question 2 of 7"),
        p("If it takes 5 machines 5 minutes to make 5 widgets, how long would it take 100 machines to make 100 widgets?"),
        radioButtons("crt2",
          label = "Your answer:",
          choices = c(
            "100 minutes" = "100 minutes",
            "5 minutes" = "5 minutes",
            "20 minutes" = "20 minutes",
            "500 minutes" = "500 minutes"
          ),
          selected = character(0))
      ),
      
      # Question 3
      div(class = "crt-question",
        h4("Question 3 of 7"),
        p("In a lake, there is a patch of lily pads. Every day, the patch doubles in size. If it takes 48 days for the patch to cover the entire lake, how long would it take for the patch to cover half of the lake?"),
        radioButtons("crt3",
          label = "Your answer:",
          choices = c(
            "24 days" = "24 days",
            "47 days" = "47 days",
            "36 days" = "36 days",
            "12 days" = "12 days"
          ),
          selected = character(0))
      ),
      
      # Question 4
      div(class = "crt-question",
        h4("Question 4 of 7"),
        p("If you're running a race and you pass the person in second place, what place are you in?"),
        radioButtons("crt4",
          label = "Your answer:",
          choices = c(
            "First place" = "first place",
            "Second place" = "second place",
            "Third place" = "third place",
            "It depends" = "it depends"
          ),
          selected = character(0))
      ),
      
      # Question 5
      div(class = "crt-question",
        h4("Question 5 of 7"),
        p("A farmer had 15 sheep and all but 8 died. How many are left?"),
        radioButtons("crt5",
          label = "Your answer:",
          choices = c(
            "7 sheep" = "7 sheep",
            "8 sheep" = "8 sheep",
            "15 sheep" = "15 sheep",
            "0 sheep" = "0 sheep"
          ),
          selected = character(0))
      ),
      
      # Question 6
      div(class = "crt-question",
        h4("Question 6 of 7"),
        p("Emily's father has three daughters. The first two are named April and May. What is the third daughter's name?"),
        radioButtons("crt6",
          label = "Your answer:",
          choices = c(
            "June" = "june",
            "Emily" = "emily",
            "May Jr." = "may jr",
            "Sarah" = "sarah"
          ),
          selected = character(0))
      ),
      
      # Question 7
      div(class = "crt-question",
        h4("Question 7 of 7"),
        p("How many cubic feet of dirt are there in a hole that is 3 feet deep, 6 feet long, and 4 feet wide?"),
        radioButtons("crt7",
          label = "Your answer:",
          choices = c(
            "72 cubic feet" = "72 cubic feet",
            "18 cubic feet" = "18 cubic feet",
            "0 cubic feet" = "0 cubic feet",
            "24 cubic feet" = "24 cubic feet"
          ),
          selected = character(0))
      ),
      
      br(),
      
      div(style = "text-align: center;",
        actionButton("btn_crt_submit",
          "See My Results! 🎉",
          class = "btn btn-primary",
          style = "font-size: 1.3em; padding: 20px 50px;")
      )
    )
  }
  
  observeEvent(input$btn_crt_submit, {
    # Check all questions answered (radio buttons return NULL if not selected)
    if (is.null(input$crt1) || is.null(input$crt2) || is.null(input$crt3) || 
        is.null(input$crt4) || is.null(input$crt5) || is.null(input$crt6) || 
        is.null(input$crt7)) {
      showNotification(
        "Please answer all 7 questions before continuing",
        type = "warning",
        duration = 3
      )
      return()
    }
    
    # Store responses
    rv$crt_responses <- list(
      crt1 = input$crt1,
      crt2 = input$crt2,
      crt3 = input$crt3,
      crt4 = input$crt4,
      crt5 = input$crt5,
      crt6 = input$crt6,
      crt7 = input$crt7
    )
    
    # Calculate results
    rv$analysis_results <- analyze_user_performance()
    rv$stage <- "results"
    
    # Reset scroll
    runjs("window.scrollTo(0, 0);")
  })
  
  # ===========================================================================
  # ANALYSIS FUNCTION
  # ===========================================================================
  
  analyze_user_performance <- function() {
    
    # Create data frame for scoring
    crt_df <- data.frame(
      crt1 = rv$crt_responses$crt1,
      crt2 = rv$crt_responses$crt2,
      crt3 = rv$crt_responses$crt3,
      crt4 = rv$crt_responses$crt4,
      crt5 = rv$crt_responses$crt5,
      crt6 = rv$crt_responses$crt6,
      crt7 = rv$crt_responses$crt7,
      stringsAsFactors = FALSE
    )
    
    # Score CRT
    crt_score <- score_crt(crt_df)[1]
    
    # Analyze coin flip sequence
    seq <- rv$coinflip_sequence
    n_flips <- rv$flip_count
    
    # Calculate metrics with dynamic expectations
    alt_rate <- calc_alternation_rate(seq)
    max_run <- calc_max_run(seq)
    n_heads <- str_count(seq, "H")
    n_tails <- str_count(seq, "T")
    head_proportion <- n_heads / n_flips
    
    # Calculate randomness score (adjusted for length)
    randomness_score <- calculate_randomness_score_flexible(seq, n_flips)
    
    # Detailed metrics
    list(
      crt_score = crt_score,
      sequence = seq,
      n_flips = n_flips,
      alternation_rate = alt_rate,
      max_run = max_run,
      n_heads = n_heads,
      n_tails = n_tails,
      head_proportion = head_proportion,
      randomness_score = randomness_score
    )
  }
  
  # ===========================================================================
  # RESULTS STAGE
  # ===========================================================================
  
  render_results_stage <- function() {
    res <- rv$analysis_results
    
    tagList(
      div(class = "alert-success",
        h2("✅ Analysis Complete!"),
        p("Here are your personalized results", style = "font-size: 1.2em; margin: 0;")
      ),
      
      br(),
      
      # CRT Results
      h2("🧠 Your Cognitive Reflection Score"),
      
      fluidRow(
        column(6,
          div(class = "metric-card",
            div(class = "metric-title", "CRT-7 Score"),
            div(class = "metric-value", paste0(res$crt_score, " / 7")),
            div(class = "metric-interpretation", 
                get_crt_interpretation(res$crt_score))
          )
        ),
        column(6,
          div(class = "metric-card",
            div(class = "metric-title", "Percentile"),
            div(class = "metric-value", paste0(get_crt_percentile(res$crt_score), "%")),
            div(class = "metric-interpretation",
                "Compared to general population")
          )
        )
      ),
      
      div(class = "instruction-box",
        h4("What does this mean?"),
        p(get_crt_detailed_interpretation(res$crt_score)),
        br(),
        p(strong("CRT Correct Answers:"), style = "color: #667eea;"),
        tags$ol(
          tags$li("The ball costs ", tags$strong("5 cents"), " (not 10 cents)"),
          tags$li("It takes ", tags$strong("5 minutes"), " (not 100 minutes)"),
          tags$li("It takes ", tags$strong("47 days"), " (not 24 days)"),
          tags$li("You're in ", tags$strong("second place"), " (not first place)"),
          tags$li(tags$strong("8 sheep"), " are left (not 7)"),
          tags$li("The third daughter's name is ", tags$strong("Emily"), " (not June)"),
          tags$li("There are ", tags$strong("0 cubic feet"), " of dirt in a hole")
        )
      ),
      
      br(),
      hr(),
      br(),
      
      # Randomness Results
      h2("🪙 Your Randomness Generation Analysis"),
      
      div(class = "your-sequence",
        res$sequence
      ),
      
      fluidRow(
        column(4,
          div(class = "metric-card",
            div(class = "metric-title", "Overall Randomness Score"),
            div(class = "metric-value", sprintf("%.1f%%", res$randomness_score * 100)),
            div(class = "metric-interpretation",
                get_randomness_interpretation(res$randomness_score))
          )
        ),
        column(4,
          div(class = "metric-card",
            div(class = "metric-title", "Alternation Rate"),
            div(class = "metric-value", sprintf("%.1f%%", res$alternation_rate * 100)),
            div(class = "metric-interpretation",
                get_alternation_interpretation(res$alternation_rate))
          )
        ),
        column(4,
          div(class = "metric-card",
            div(class = "metric-title", "Longest Streak"),
            div(class = "metric-value", res$max_run),
            div(class = "metric-interpretation",
                get_run_interpretation(res$max_run, res$n_flips))
          )
        )
      ),
      
      fluidRow(
        column(6,
          div(class = "metric-card",
            div(class = "metric-title", "Heads Count"),
            div(class = "metric-value", paste0(res$n_heads, " / ", res$n_flips)),
            div(class = "metric-interpretation",
                sprintf("%.1f%% heads", res$head_proportion * 100))
          )
        ),
        column(6,
          div(class = "metric-card",
            div(class = "metric-title", "Tails Count"),
            div(class = "metric-value", paste0(res$n_tails, " / ", res$n_flips)),
            div(class = "metric-interpretation",
                sprintf("%.1f%% tails", (1 - res$head_proportion) * 100))
          )
        )
      ),
      
      br(),
      
      div(class = "sequence-analysis",
        h4("📊 Detailed Analysis"),
        
        h5("What We Measured:"),
        tags$ul(
          tags$li(strong("Alternation Rate:"), " How often you switched between H and T. Random sequences alternate about 50% of the time."),
          tags$li(strong("Longest Streak:"), " The maximum consecutive H's or T's. Longer sequences naturally have longer streaks."),
          tags$li(strong("Balance:"), " Whether you maintained a ~50/50 split between heads and tails.")
        ),
        
        br(),
        
        h5("Common Psychological Biases:"),
        tags$ul(
          tags$li(strong("Over-alternation:"), " People tend to switch too frequently, avoiding 'unnatural' streaks like HHHH."),
          tags$li(strong("Representativeness:"), " People try too hard to ensure exactly 50% heads, even in short sequences."),
          tags$li(strong("Clustering illusion:"), " People see patterns in randomness and try to avoid them.")
        ),
        
        br(),
        
        h5("Your Pattern:"),
        p(generate_personalized_feedback(res))
      ),
      
      br(),
      
      # Visualization
      h4("📈 Your Sequence Visualization"),
      plotlyOutput("sequence_plot", height = "300px"),
      
      br(),
      hr(),
      br(),
      
      # Combined insights
      div(class = "instruction-box",
        h3("🔍 Combined Insights"),
        p(generate_combined_insights(res$crt_score, res$randomness_score)),
        br(),
        p(strong("Thank you for participating!"), " These results show how your cognitive style relates to randomness intuition."),
        p("Research suggests that people with higher cognitive reflection may approach randomness differently, though the relationship is complex.")
      ),
      
      br(),
      
      div(style = "text-align: center;",
        actionButton("btn_restart",
          "↻ Take Test Again",
          class = "btn btn-primary",
          style = "font-size: 1.2em; padding: 15px 40px;")
      )
    )
  }
  
  # Sequence visualization
  output$sequence_plot <- renderPlotly({
    req(rv$analysis_results)
    res <- rv$analysis_results
    
    # Create cumulative heads plot
    flips <- unlist(strsplit(res$sequence, ""))
    flip_nums <- 1:length(flips)
    cumulative_heads <- cumsum(flips == "H")
    cumulative_proportion <- cumulative_heads / flip_nums
    
    # Expected proportion line
    expected <- rep(0.5, length(flip_nums))
    
    plot_ly() %>%
      add_trace(x = flip_nums, y = cumulative_proportion,
                type = "scatter", mode = "lines",
                name = "Your Sequence",
                line = list(color = "#667eea", width = 3)) %>%
      add_trace(x = flip_nums, y = expected,
                type = "scatter", mode = "lines",
                name = "Expected (50%)",
                line = list(color = "#e53e3e", width = 2, dash = "dash")) %>%
      layout(
        title = "Cumulative Proportion of Heads Over Time",
        xaxis = list(title = "Flip Number"),
        yaxis = list(title = "Proportion of Heads", range = c(0, 1)),
        hovermode = "x unified"
      )
  })
  
  # Restart button
  observeEvent(input$btn_restart, {
    rv$stage <- "welcome"
    rv$flip_count <- NULL
    rv$coinflip_sequence <- NULL
    rv$crt_responses <- NULL
    rv$analysis_results <- NULL
    
    # Reset scroll
    runjs("window.scrollTo(0, 0);")
  })
}

# ==============================================================================
# HELPER FUNCTIONS FOR INTERPRETATIONS
# ==============================================================================

calculate_randomness_score_flexible <- function(seq, n_flips) {
  alt_rate <- calc_alternation_rate(seq)
  max_run <- calc_max_run(seq)
  n_heads <- str_count(seq, "H")
  head_proportion <- n_heads / n_flips
  
  # Dynamic ideal values based on sequence length
  ideal_max_run <- log2(n_flips) + 1
  
  # Calculate penalties
  alt_penalty <- abs(alt_rate - 0.5)
  run_penalty <- abs(max_run - ideal_max_run) / ideal_max_run
  head_penalty <- abs(head_proportion - 0.5)
  
  # Composite score
  score <- 1 - (alt_penalty + run_penalty + head_penalty) / 3
  return(max(0, min(1, score)))
}

get_crt_interpretation <- function(score) {
  if (score >= 6) return("Excellent - High Cognitive Reflection")
  if (score >= 4) return("Good - Above Average Reflection")
  if (score >= 2) return("Average - Moderate Reflection")
  return("Below Average - More Intuitive Thinking")
}

get_crt_percentile <- function(score) {
  # Approximate percentiles based on CRT literature
  percentiles <- c(25, 35, 45, 55, 65, 75, 85, 92)
  percentiles[score + 1]
}

get_crt_detailed_interpretation <- function(score) {
  if (score >= 6) {
    return("You scored very high! You excel at overriding intuitive but incorrect responses. You likely take time to think through problems carefully rather than going with your first instinct. Research shows people with high CRT scores tend to be more analytical and less susceptible to cognitive biases.")
  } else if (score >= 4) {
    return("You scored above average! You can often override intuitive responses when needed. You balance analytical thinking with intuition. Continue practicing mindful thinking to strengthen this skill further.")
  } else if (score >= 2) {
    return("You scored in the average range. Like most people, you sometimes rely on intuition even when deeper thinking would help. The CRT shows that our first instincts are often wrong - recognizing this is the first step to improving!")
  } else {
    return("You scored below average, which is common! The CRT questions are designed to trigger intuitive but wrong answers. Don't worry - cognitive reflection is a skill that can be improved with practice. Try slowing down and questioning your first instinct on problems.")
  }
}

get_randomness_interpretation <- function(score) {
  if (score >= 0.8) return("Excellent - Very realistic!")
  if (score >= 0.6) return("Good - Pretty random")
  if (score >= 0.4) return("Fair - Some patterns visible")
  return("Shows common biases")
}

get_alternation_interpretation <- function(rate) {
  if (rate > 0.6) return("Higher than random (over-alternating)")
  if (rate < 0.4) return("Lower than random (under-alternating)")
  return("Near ideal (random-like)")
}

get_run_interpretation <- function(run, n_flips) {
  expected <- log2(n_flips) + 1
  if (run > expected + 2) return("Longer than expected")
  if (run < expected - 2) return("Shorter than expected")
  return("About right for randomness")
}

generate_personalized_feedback <- function(res) {
  feedback <- ""
  
  # Alternation analysis
  if (res$alternation_rate > 0.6) {
    feedback <- paste0(feedback, "You alternated quite frequently (", 
                      sprintf("%.0f%%", res$alternation_rate * 100), 
                      "). This is a common pattern where people switch between H and T more than a truly random sequence would. Many people do this because long streaks of the same outcome 'feel' non-random, even though they're actually quite normal in random sequences. ")
  } else if (res$alternation_rate < 0.4) {
    feedback <- paste0(feedback, "You had relatively few alternations (", 
                      sprintf("%.0f%%", res$alternation_rate * 100), 
                      "), creating more streaks than typical. This could indicate comfort with runs of the same outcome. ")
  } else {
    feedback <- paste0(feedback, "Your alternation rate (", 
                      sprintf("%.0f%%", res$alternation_rate * 100), 
                      ") is quite close to what we'd expect from true randomness. Nice job! ")
  }
  
  # Balance analysis
  balance_deviation <- abs(res$head_proportion - 0.5)
  if (balance_deviation < 0.1) {
    feedback <- paste0(feedback, "You maintained an excellent balance between heads and tails. ")
  } else if (balance_deviation > 0.2) {
    feedback <- paste0(feedback, "Your sequence had more ", 
                      ifelse(res$head_proportion > 0.5, "heads", "tails"),
                      " than tails (", sprintf("%.0f%%", res$head_proportion * 100), 
                      " heads). In truly random sequences, imbalances like this are actually quite normal, especially for shorter sequences. ")
  }
  
  # Run analysis
  expected_run <- log2(res$n_flips) + 1
  if (res$max_run < expected_run - 2) {
    feedback <- paste0(feedback, "Your longest streak was only ", res$max_run, 
                      " flips, which is shorter than expected. This suggests you may have been avoiding longer runs because they seemed 'too predictable.'")
  } else if (res$max_run > expected_run + 3) {
    feedback <- paste0(feedback, "You had a relatively long streak of ", res$max_run, 
                      " consecutive flips, which is actually quite realistic for a ", 
                      res$n_flips, "-flip sequence!")
  }
  
  return(feedback)
}

generate_combined_insights <- function(crt_score, randomness_score) {
  if (crt_score >= 5 && randomness_score >= 0.7) {
    return("Interesting! You scored high on both cognitive reflection AND generated a very random-looking sequence. This suggests you may understand randomness at a deeper level and can override the common bias of over-structuring your sequences.")
  } else if (crt_score >= 5 && randomness_score < 0.5) {
    return("You scored high on cognitive reflection but your sequence showed some typical biases. This is actually quite common - even analytically-minded people often struggle with randomness intuition because our brains are wired to see patterns everywhere!")
  } else if (crt_score <= 2 && randomness_score >= 0.7) {
    return("Fascinating! You rely more on intuition (low CRT) yet generated a realistic random sequence. Sometimes intuitive thinking can actually help with randomness generation when we don't overthink it!")
  } else {
    return("Your results show a typical pattern. Both cognitive reflection and randomness intuition are skills that can be developed with practice and awareness of common biases.")
  }
}

# ==============================================================================
# RUN APPLICATION
# ==============================================================================

shinyApp(ui = ui, server = server)
