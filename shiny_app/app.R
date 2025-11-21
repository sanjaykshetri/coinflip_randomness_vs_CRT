# ==============================================================================
# Coinflip Randomness vs. Cognitive Reflection - Shiny Dashboard
# ==============================================================================
# Interactive data collection platform for studying the relationship between
# cognitive reflection and randomness generation intuition
# Author: Sanjay K Shetri
# ==============================================================================

library(shiny)
library(shinyjs)
library(tidyverse)
library(DT)
library(plotly)

# Source helper functions
source("utils.R")
source("analysis_functions.R")

# ==============================================================================
# USER INTERFACE
# ==============================================================================

ui <- fluidPage(
  
  # Enable shinyjs for interactive features
  useShinyjs(),
  
  # Custom CSS styling
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap');
      
      body {
        font-family: 'Inter', sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
      }
      
      .main-container {
        background: white;
        border-radius: 15px;
        padding: 30px;
        margin: 30px auto;
        max-width: 900px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.2);
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
        font-size: 2.2em;
        margin-bottom: 10px;
      }
      
      .page-header p {
        color: #718096;
        font-size: 1.1em;
      }
      
      .instruction-box {
        background: #f7fafc;
        border-left: 4px solid #667eea;
        padding: 20px;
        margin: 20px 0;
        border-radius: 5px;
      }
      
      .instruction-box strong {
        color: #667eea;
        font-size: 1.1em;
      }
      
      .coinflip-input {
        font-family: 'Courier New', monospace;
        font-size: 1.3em;
        text-align: center;
        letter-spacing: 3px;
        padding: 15px;
        border: 2px solid #667eea;
        border-radius: 8px;
      }
      
      .btn-primary {
        background: #667eea;
        border: none;
        padding: 12px 30px;
        font-size: 1.1em;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s;
      }
      
      .btn-primary:hover {
        background: #5568d3;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
      }
      
      .progress-bar {
        background: #667eea !important;
      }
      
      .crt-question {
        background: #f7fafc;
        padding: 20px;
        margin: 15px 0;
        border-radius: 8px;
        border: 1px solid #e2e8f0;
      }
      
      .crt-question h4 {
        color: #2d3748;
        margin-bottom: 15px;
      }
      
      .radio label {
        font-size: 1em;
        padding: 10px;
        margin: 5px 0;
      }
      
      .alert-success {
        background: #c6f6d5;
        color: #2f855a;
        border: 2px solid #9ae6b4;
        padding: 20px;
        border-radius: 8px;
        text-align: center;
        font-size: 1.1em;
      }
      
      .stats-card {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        margin: 15px 0;
      }
      
      .stats-number {
        font-size: 2.5em;
        font-weight: 700;
        color: #667eea;
      }
      
      .nav-tabs {
        border-bottom: 3px solid #667eea;
      }
      
      .nav-tabs > li.active > a {
        background: #667eea !important;
        color: white !important;
        border: none !important;
      }
    "))
  ),
  
  # Main container
  div(class = "main-container",
    
    # Application title
    div(class = "page-header",
      h1("🪙 Randomness Intuition Study"),
      p("Exploring the link between cognitive reflection and randomness generation")
    ),
    
    # Multi-page navigation
    tabsetPanel(id = "main_tabs",
      
      # ========================================================================
      # TAB 1: WELCOME & CONSENT
      # ========================================================================
      tabPanel("Welcome",
        value = "welcome_tab",
        
        br(),
        h2("Welcome to Our Research Study!", style = "color: #667eea;"),
        
        hr(),
        
        h3("📋 Study Overview"),
        p("Thank you for your interest in participating! This study investigates how people generate random sequences and solve cognitive problems."),
        
        h3("⏱️ Time Required"),
        p(strong("Approximately 8-10 minutes")),
        
        h3("📝 What You'll Do"),
        tags$ol(
          tags$li("Imagine flipping a coin 20 times and record your sequence"),
          tags$li("Answer 7 cognitive reflection questions"),
          tags$li("Provide brief demographic information")
        ),
        
        h3("🔒 Privacy & Data"),
        tags$ul(
          tags$li("All responses are ", strong("completely anonymous")),
          tags$li("No personally identifiable information is collected"),
          tags$li("Data will be used for research purposes only"),
          tags$li("You may withdraw at any time without penalty")
        ),
        
        h3("✅ Informed Consent"),
        div(class = "instruction-box",
          checkboxInput("consent_check", 
            HTML("<strong>I am 18 years or older and voluntarily agree to participate in this research study. I understand that my responses are anonymous and that I can withdraw at any time.</strong>"),
            value = FALSE)
        ),
        
        br(),
        
        div(style = "text-align: center;",
          actionButton("btn_start", 
            "Begin Study →", 
            class = "btn btn-primary btn-lg",
            width = "250px")
        ),
        
        br(),
        
        p(style = "text-align: center; color: #718096; font-size: 0.9em;",
          "Questions? Contact: research@example.com")
      ),
      
      # ========================================================================
      # TAB 2: COINFLIP TASK
      # ========================================================================
      tabPanel("Coinflip Task",
        value = "coinflip_tab",
        
        br(),
        
        div(class = "instruction-box",
          h3("🪙 Task: Mental Coin Flipping"),
          p(strong("Instructions:"), "Imagine you are flipping a fair coin 20 times. In the box below, type the sequence of Heads (H) and Tails (T) that you think would result from these flips."),
          tags$ul(
            tags$li("Use only the letters 'H' (for Heads) and 'T' (for Tails)"),
            tags$li("Enter exactly 20 characters"),
            tags$li("Try to make your sequence as realistic as possible"),
            tags$li(strong("Example format:"), " HTHHTTTHTHHHTTHHHTTT")
          )
        ),
        
        br(),
        
        # Coinflip input with character counter
        textInput("coinflip_input",
          label = h4("Your Coinflip Sequence:"),
          value = "",
          placeholder = "Type your 20-character sequence here (e.g., HTHHTTTHTHHHTTHHHTTT)",
          width = "100%"
        ),
        
        # Real-time feedback
        div(id = "coinflip_feedback",
          style = "text-align: center; margin: 15px 0; font-size: 1.1em;",
          uiOutput("flip_counter")
        ),
        
        # Validation message
        uiOutput("flip_validation"),
        
        br(),
        
        div(style = "text-align: center;",
          actionButton("btn_coinflip_next",
            "Continue to Questions →",
            class = "btn btn-primary btn-lg",
            width = "250px")
        )
      ),
      
      # ========================================================================
      # TAB 3: CRT QUESTIONS
      # ========================================================================
      tabPanel("CRT Questions",
        value = "crt_tab",
        
        br(),
        
        div(class = "instruction-box",
          h3("🧠 Cognitive Reflection Test"),
          p("Please answer the following 7 questions. Take your time and think carefully about each one."),
          p(strong("Important:"), "There are no trick questions - just answer what seems right to you.")
        ),
        
        br(),
        
        # CRT Question 1
        div(class = "crt-question",
          h4("Question 1 of 7"),
          p("A bat and a ball cost $1.10 in total. The bat costs $1.00 more than the ball. How much does the ball cost?"),
          textInput("crt1", 
            label = "Your answer:",
            placeholder = "Enter your answer (e.g., 5 cents)",
            width = "100%")
        ),
        
        # CRT Question 2
        div(class = "crt-question",
          h4("Question 2 of 7"),
          p("If it takes 5 machines 5 minutes to make 5 widgets, how long would it take 100 machines to make 100 widgets?"),
          textInput("crt2",
            label = "Your answer:",
            placeholder = "Enter your answer (e.g., 5 minutes)",
            width = "100%")
        ),
        
        # CRT Question 3
        div(class = "crt-question",
          h4("Question 3 of 7"),
          p("In a lake, there is a patch of lily pads. Every day, the patch doubles in size. If it takes 48 days for the patch to cover the entire lake, how long would it take for the patch to cover half of the lake?"),
          textInput("crt3",
            label = "Your answer:",
            placeholder = "Enter your answer (e.g., 24 days)",
            width = "100%")
        ),
        
        # CRT Question 4
        div(class = "crt-question",
          h4("Question 4 of 7"),
          p("If you're running a race and you pass the person in second place, what place are you in?"),
          textInput("crt4",
            label = "Your answer:",
            placeholder = "Enter your answer (e.g., first place)",
            width = "100%")
        ),
        
        # CRT Question 5
        div(class = "crt-question",
          h4("Question 5 of 7"),
          p("A farmer had 15 sheep and all but 8 died. How many are left?"),
          textInput("crt5",
            label = "Your answer:",
            placeholder = "Enter your answer (e.g., 8 sheep)",
            width = "100%")
        ),
        
        # CRT Question 6
        div(class = "crt-question",
          h4("Question 6 of 7"),
          p("Emily's father has three daughters. The first two are named April and May. What is the third daughter's name?"),
          textInput("crt6",
            label = "Your answer:",
            placeholder = "Enter your answer (e.g., Emily)",
            width = "100%")
        ),
        
        # CRT Question 7
        div(class = "crt-question",
          h4("Question 7 of 7"),
          p("How many cubic feet of dirt are there in a hole that is 3 feet deep, 6 feet long, and 4 feet wide?"),
          textInput("crt7",
            label = "Your answer:",
            placeholder = "Enter your answer (e.g., 0 cubic feet)",
            width = "100%")
        ),
        
        br(),
        
        uiOutput("crt_validation"),
        
        br(),
        
        div(style = "text-align: center;",
          actionButton("btn_crt_next",
            "Continue to Demographics →",
            class = "btn btn-primary btn-lg",
            width = "250px")
        )
      ),
      
      # ========================================================================
      # TAB 4: DEMOGRAPHICS
      # ========================================================================
      tabPanel("Demographics",
        value = "demo_tab",
        
        br(),
        
        div(class = "instruction-box",
          h3("👤 About You"),
          p("Finally, please provide some basic information about yourself. Remember, all responses are anonymous.")
        ),
        
        br(),
        
        # Age
        numericInput("age",
          label = h4("What is your age?"),
          value = NA,
          min = 18,
          max = 100,
          width = "300px"),
        
        br(),
        
        # Gender
        radioButtons("gender",
          label = h4("What is your gender?"),
          choices = c("Male", "Female", "Non-binary", "Prefer not to say"),
          selected = character(0)),
        
        br(),
        
        # Education
        selectInput("education",
          label = h4("What is your highest level of education?"),
          choices = c("Please select..." = "",
                     "High School",
                     "Some College",
                     "Associate's Degree",
                     "Bachelor's Degree",
                     "Master's Degree",
                     "Doctoral Degree",
                     "Other"),
          width = "400px"),
        
        br(),
        
        # Academic Year (if student)
        selectInput("academic_year",
          label = h4("If you are currently a student, what year are you in?"),
          choices = c("Not a student" = "N/A",
                     "Freshman",
                     "Sophomore", 
                     "Junior",
                     "Senior",
                     "Graduate Student"),
          width = "400px"),
        
        br(),
        
        # Major/Field
        textInput("major",
          label = h4("What is your major or field of study? (Optional)"),
          placeholder = "e.g., Psychology, Computer Science, etc.",
          width = "400px"),
        
        br(),
        
        # Statistics courses
        numericInput("stats_courses",
          label = h4("How many statistics or probability courses have you taken?"),
          value = 0,
          min = 0,
          max = 20,
          width = "300px"),
        
        br(),
        
        uiOutput("demo_validation"),
        
        br(),
        
        div(style = "text-align: center;",
          actionButton("btn_submit",
            "Submit Responses ✓",
            class = "btn btn-primary btn-lg",
            width = "250px")
        )
      ),
      
      # ========================================================================
      # TAB 5: THANK YOU / DEBRIEFING
      # ========================================================================
      tabPanel("Complete",
        value = "complete_tab",
        
        br(),
        
        div(class = "alert alert-success",
          h2("✅ Thank You for Participating!"),
          p("Your responses have been recorded successfully.")
        ),
        
        br(),
        
        h3("📊 Study Debriefing"),
        
        p("This study investigates whether cognitive reflection ability (measured by the CRT) predicts how well people can simulate random sequences."),
        
        h4("Why Coinflips?"),
        p("Research shows that people often struggle to generate truly random sequences. Common biases include:"),
        tags$ul(
          tags$li(strong("Over-alternation:"), " People switch between H and T too frequently (avoiding 'unnatural' streaks)"),
          tags$li(strong("Representativeness:"), " People try to ensure roughly 50% heads and 50% tails even in short sequences"),
          tags$li(strong("Clustering illusion:"), " People see patterns where none exist")
        ),
        
        h4("What We're Testing"),
        p("We're examining whether people with higher cognitive reflection scores (those who take time to think carefully rather than going with their first instinct) generate more or less 'random' sequences."),
        
        h4("Your Contribution"),
        p("Your data will help us understand the relationship between analytical thinking and probability intuition. This has implications for:"),
        tags$ul(
          tags$li("Education: How to teach probability and statistical reasoning"),
          tags$li("Decision-making: Understanding biases in risk assessment"),
          tags$li("Security: Why humans are poor at generating random passwords")
        ),
        
        hr(),
        
        h4("📚 Learn More"),
        p("Interested in the research behind this study? Check out:"),
        tags$ul(
          tags$li("Kahneman, D., & Tversky, A. (1972). Subjective probability: A judgment of representativeness."),
          tags$li("Gilovich, T., Vallone, R., & Tversky, A. (1985). The hot hand in basketball: On the misperception of random sequences."),
          tags$li("Frederick, S. (2005). Cognitive reflection and decision making.")
        ),
        
        br(),
        
        div(style = "text-align: center; background: #f7fafc; padding: 20px; border-radius: 8px;",
          h4("Share This Study"),
          p("Know others who might be interested? Share this link:"),
          p(strong("[Your deployment URL will go here]")),
          br(),
          p(style = "color: #718096;", "Questions or feedback? Contact: research@example.com")
        )
      ),
      
      # ========================================================================
      # TAB 6: ADMIN DASHBOARD (Password Protected)
      # ========================================================================
      tabPanel("Admin",
        value = "admin_tab",
        
        br(),
        
        passwordInput("admin_password",
          label = "Enter admin password:",
          placeholder = "Password"),
        
        actionButton("btn_admin_login", "Login"),
        
        br(),
        br(),
        
        # Admin content (shown only after authentication)
        uiOutput("admin_content")
      )
    )
  )
)

# ==============================================================================
# SERVER LOGIC
# ==============================================================================

server <- function(input, output, session) {
  
  # Reactive values to store state
  rv <- reactiveValues(
    admin_authenticated = FALSE,
    submission_id = NULL
  )
  
  # ============================================================================
  # NAVIGATION CONTROLS
  # ============================================================================
  
  # Start button - move to coinflip tab
  observeEvent(input$btn_start, {
    if (!input$consent_check) {
      showNotification("Please check the consent box to continue.", 
                      type = "warning", duration = 3)
    } else {
      updateTabsetPanel(session, "main_tabs", selected = "coinflip_tab")
    }
  })
  
  # Coinflip next button
  observeEvent(input$btn_coinflip_next, {
    if (validate_coinflip(input$coinflip_input)) {
      updateTabsetPanel(session, "main_tabs", selected = "crt_tab")
    } else {
      showNotification("Please enter exactly 20 characters using only H and T.", 
                      type = "error", duration = 3)
    }
  })
  
  # CRT next button
  observeEvent(input$btn_crt_next, {
    if (validate_crt_responses(input)) {
      updateTabsetPanel(session, "main_tabs", selected = "demo_tab")
    } else {
      showNotification("Please answer all CRT questions before continuing.", 
                      type = "warning", duration = 3)
    }
  })
  
  # ============================================================================
  # COINFLIP TASK
  # ============================================================================
  
  # Real-time character counter
  output$flip_counter <- renderUI({
    input_length <- nchar(input$coinflip_input)
    color <- if (input_length == 20) "green" else if (input_length > 20) "red" else "orange"
    
    HTML(sprintf(
      "<span style='color: %s; font-weight: 600;'>Characters: %d / 20</span>",
      color, input_length
    ))
  })
  
  # Validation message
  output$flip_validation <- renderUI({
    if (input$coinflip_input == "") return(NULL)
    
    validation <- validate_coinflip(input$coinflip_input)
    
    if (validation) {
      div(style = "color: green; text-align: center; font-weight: 600;",
        "✓ Valid sequence! You can continue.")
    } else {
      div(style = "color: red; text-align: center; font-weight: 600;",
        "⚠ Please use only 'H' and 'T' and enter exactly 20 characters.")
    }
  })
  
  # ============================================================================
  # CRT VALIDATION
  # ============================================================================
  
  output$crt_validation <- renderUI({
    all_answered <- all(
      nchar(input$crt1) > 0,
      nchar(input$crt2) > 0,
      nchar(input$crt3) > 0,
      nchar(input$crt4) > 0,
      nchar(input$crt5) > 0,
      nchar(input$crt6) > 0,
      nchar(input$crt7) > 0
    )
    
    if (all_answered) {
      div(style = "color: green; text-align: center; font-weight: 600;",
        "✓ All questions answered!")
    }
  })
  
  # ============================================================================
  # DEMOGRAPHICS VALIDATION
  # ============================================================================
  
  output$demo_validation <- renderUI({
    all_complete <- !is.na(input$age) && 
                   input$gender != "" && 
                   input$education != ""
    
    if (all_complete) {
      div(style = "color: green; text-align: center; font-weight: 600;",
        "✓ All required fields completed!")
    }
  })
  
  # ============================================================================
  # SUBMIT RESPONSES
  # ============================================================================
  
  observeEvent(input$btn_submit, {
    
    # Validate all sections
    if (!validate_coinflip(input$coinflip_input)) {
      showNotification("Error: Invalid coinflip sequence", type = "error")
      return()
    }
    
    if (!validate_crt_responses(input)) {
      showNotification("Error: CRT questions incomplete", type = "error")
      return()
    }
    
    if (is.na(input$age) || input$gender == "" || input$education == "") {
      showNotification("Please complete all required demographic fields", 
                      type = "warning", duration = 3)
      return()
    }
    
    # Collect all data
    response_data <- list(
      timestamp = Sys.time(),
      # Coinflip data
      coinflip_sequence = input$coinflip_input,
      # CRT responses
      crt1 = input$crt1,
      crt2 = input$crt2,
      crt3 = input$crt3,
      crt4 = input$crt4,
      crt5 = input$crt5,
      crt6 = input$crt6,
      crt7 = input$crt7,
      # Demographics
      age = input$age,
      gender = input$gender,
      education = input$education,
      academic_year = input$academic_year,
      major = input$major,
      stats_courses = input$stats_courses
    )
    
    # Save data
    submission_id <- save_response_data(response_data)
    rv$submission_id <- submission_id
    
    # Show success message
    showNotification("✅ Responses submitted successfully!", 
                    type = "message", duration = 3)
    
    # Navigate to completion page
    updateTabsetPanel(session, "main_tabs", selected = "complete_tab")
  })
  
  # ============================================================================
  # ADMIN DASHBOARD
  # ============================================================================
  
  observeEvent(input$btn_admin_login, {
    if (input$admin_password == "randomness2025") {  # Change this password!
      rv$admin_authenticated <- TRUE
      showNotification("✓ Admin access granted", type = "message")
    } else {
      showNotification("✗ Incorrect password", type = "error")
    }
  })
  
  output$admin_content <- renderUI({
    if (!rv$admin_authenticated) {
      return(NULL)
    }
    
    # Load all responses
    all_data <- load_all_responses()
    
    if (is.null(all_data) || nrow(all_data) == 0) {
      return(
        div(class = "alert alert-info",
          h3("No Data Yet"),
          p("No responses have been collected yet. Share your survey link to start collecting data!")
        )
      )
    }
    
    # Calculate statistics
    n_responses <- nrow(all_data)
    avg_crt <- mean(all_data$crt_score, na.rm = TRUE)
    avg_randomness <- mean(all_data$randomness_score, na.rm = TRUE)
    
    tagList(
      h2("📊 Data Dashboard"),
      
      hr(),
      
      # Summary statistics
      fluidRow(
        column(4,
          div(class = "stats-card",
            h4("Total Responses"),
            div(class = "stats-number", n_responses)
          )
        ),
        column(4,
          div(class = "stats-card",
            h4("Avg CRT Score"),
            div(class = "stats-number", sprintf("%.2f", avg_crt))
          )
        ),
        column(4,
          div(class = "stats-card",
            h4("Avg Randomness"),
            div(class = "stats-number", sprintf("%.2f", avg_randomness))
          )
        )
      ),
      
      br(),
      
      # Interactive plot
      h3("CRT vs Randomness Score"),
      plotlyOutput("admin_plot", height = "400px"),
      
      br(),
      
      # Data table
      h3("Recent Responses"),
      DTOutput("admin_table"),
      
      br(),
      
      # Download button
      downloadButton("download_data", "Download All Data (CSV)", 
                    class = "btn btn-primary")
    )
  })
  
  # Admin plot
  output$admin_plot <- renderPlotly({
    req(rv$admin_authenticated)
    all_data <- load_all_responses()
    
    if (is.null(all_data) || nrow(all_data) == 0) return(NULL)
    
    plot_ly(all_data, x = ~crt_score, y = ~randomness_score,
            type = "scatter", mode = "markers",
            marker = list(size = 10, opacity = 0.6, color = "#667eea"),
            hoverinfo = "text",
            text = ~paste("CRT:", crt_score, "<br>Randomness:", 
                         round(randomness_score, 3))) %>%
      add_trace(type = "scatter", mode = "lines",
               x = ~crt_score, y = fitted(lm(randomness_score ~ crt_score, data = all_data)),
               line = list(color = "#764ba2", width = 2),
               showlegend = FALSE,
               hoverinfo = "none") %>%
      layout(
        xaxis = list(title = "CRT Score (0-7)"),
        yaxis = list(title = "Randomness Score (0-1)"),
        hovermode = "closest"
      )
  })
  
  # Admin data table
  output$admin_table <- renderDT({
    req(rv$admin_authenticated)
    all_data <- load_all_responses()
    
    if (is.null(all_data)) return(NULL)
    
    # Select and format columns for display
    display_data <- all_data %>%
      select(timestamp, age, gender, education, crt_score, randomness_score) %>%
      mutate(timestamp = as.character(timestamp))
    
    datatable(display_data,
              options = list(pageLength = 10, order = list(list(0, 'desc'))),
              rownames = FALSE)
  })
  
  # Download handler
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("coinflip_crt_data_", Sys.Date(), ".csv")
    },
    content = function(file) {
      all_data <- load_all_responses()
      write.csv(all_data, file, row.names = FALSE)
    }
  )
}

# ==============================================================================
# RUN APPLICATION
# ==============================================================================

shinyApp(ui = ui, server = server)
