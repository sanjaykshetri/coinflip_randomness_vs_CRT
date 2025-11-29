# 🪙 Coinflip Randomness vs. Cognitive Reflection

[![R](https://img.shields.io/badge/R-4.0%2B-blue.svg)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-Interactive-brightgreen.svg)](https://shiny.rstudio.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Active](https://img.shields.io/badge/Status-Active-success.svg)]()

> Investigating the relationship between cognitive complexity and intuitive randomness: Can analytical thinkers simulate coinflips more "randomly"?

**✨ NEW: Interactive Dashboard Available!** Test your own randomness intuition and cognitive reflection with instant personalized feedback.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Interactive Dashboard](#interactive-dashboard)
- [Research Question](#research-question)
- [Methodology](#methodology)
- [Key Findings](#key-findings)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Results & Visualizations](#results--visualizations)
- [Future Directions](#future-directions)
- [Contributing](#contributing)
- [Citation](#citation)
- [License](#license)

---

## 🎯 Overview

This project examines whether **cognitive reflection ability** predicts **randomness generation performance**. Using survey data from college students, we analyze the correlation between:

1. **CRT-7 scores** (Cognitive Reflection Test) — a measure of analytical thinking and cognitive control
2. **Randomness intuition** — how well participants simulate coin flips compared to truly random sequences

The study bridges cognitive psychology, behavioral economics, and statistical reasoning.

### 🚀 What's Included

- **Research Analysis**: Complete statistical analysis of 80+ participants
- **Interactive Dashboard**: User-facing web application with instant feedback
- **Data Collection Tools**: Shiny app for gathering participant responses
- **Comprehensive Documentation**: Methodology, findings, and technical details

---

## 🎮 Interactive Dashboard

Test your own randomness intuition and cognitive reflection with our **interactive web dashboard**!

### Features

- ✅ **Flexible Test Lengths**: Choose from 12, 20, 50, 100, or 200 coin flips
- ✅ **CRT-7 Assessment**: Complete 7 cognitive reflection questions with multiple choice
- ✅ **Instant Analysis**: Get immediate personalized feedback including:
  - Overall randomness score (0-100%)
  - CRT-7 score with percentile ranking
  - Detailed pattern analysis (alternation rate, streaks, balance)
  - Interactive visualizations
  - Personalized interpretation of your cognitive patterns
- ✅ **Privacy-First**: No data storage, results shown immediately
- ✅ **Beautiful UI**: Modern gradient design, mobile-responsive

### 🌐 Live Demo

> **Coming Soon**: Public deployment link will be added here

To run locally:

```bash
# Navigate to the dashboard directory
cd shiny_app

# Run the dashboard
./run_dashboard.sh
```

Or open in R/RStudio:
```r
shiny::runApp("shiny_app/user_dashboard.R")
```

**Access at:** http://localhost:3838

### 🚀 Deploy Your Own

Want to share this with others? Deploy to:
- **ShinyApps.io** (Free tier available): `rsconnect::deployApp("shiny_app/user_dashboard.R")`
- **Shiny Server** (Self-hosted): Copy to `/srv/shiny-server/`
- **Docker**: See `shiny_app/DEPLOYMENT.md` for container setup

📖 See [`shiny_app/USER_DASHBOARD_README.md`](shiny_app/USER_DASHBOARD_README.md) for detailed documentation.

---

## 🔬 Research Question

**Primary Hypothesis:**  
*Individuals with higher cognitive reflection scores will demonstrate better intuition for randomness in their simulated coinflip sequences.*

### Why This Matters

- **Cognitive Science**: Understanding how analytical thinking relates to probabilistic reasoning
- **Decision-Making**: Implications for risk assessment and statistical literacy
- **Education**: Informing pedagogy around probability and randomness concepts
- **Behavioral Economics**: Insights into the "hot hand fallacy" and representativeness heuristic

---

## 🧪 Methodology

### Data Collection

**Participants**: 80+ college students (Freshmen through Seniors)

**Survey Instrument** (Google Forms):
- **Task 1**: Generate a sequence of 12 imaginary coinflips (Heads/Tails)
- **Task 2**: Complete the 7-item Cognitive Reflection Test (CRT-7)
- **Demographics**: Academic year, sleep hours

**CRT-7 Questions**: Classic problems designed to elicit intuitive (incorrect) vs. reflective (correct) responses  
*Reference: Toplak, M. E., West, R. F., & Stanovich, K. E. (2014)*

### Randomness Scoring Algorithm

We quantified "randomness quality" using three evidence-based metrics:

| Metric | Formula | Expected Value (12 flips) | Psychological Basis |
|--------|---------|---------------------------|---------------------|
| **Alternation Rate** | P(flip_i ≠ flip_{i+1}) | ~0.50 | People often over-alternate (Falk & Konold, 1997) |
| **Max Run Length** | max(consecutive H or T) | 3-4 | Streaks feel "non-random" (Gilovich et al., 1985) |
| **Head Deviation** | \|count(H) - 6\| | 0 | Tendency toward 50/50 split |

**Composite Score**:  
$$
\text{Randomness Score} = 1 - \frac{1}{3}\left(\left|A - 0.5\right| + \frac{\left|R - 3.5\right|}{3.5} + \frac{D}{6}\right)
$$

Where *A* = alternation rate, *R* = max run, *D* = head deviation

---

## 📊 Key Findings

### Main Result

**Correlation: r = -0.18, p = 0.09**  
*No statistically significant relationship detected at α = 0.05*

### Interpretation

- **Weak negative trend**: Higher CRT scores slightly associated with *lower* randomness scores
- **Possible explanation**: High-CRT individuals may "over-correct" — trying too hard to be random leads to systematic biases
- **Statistical power**: With n=83, we had ~65% power to detect medium effects (r=0.3)

### Secondary Observations

1. **Grade-level differences**: Minimal variation across academic years
2. **Score distributions**: 
   - CRT scores: Mean = 2.8/7 (SD = 2.1)
   - Randomness scores: Mean = 0.81 (SD = 0.12)
3. **Common biases**: Participants frequently over-alternated (avoiding "unnatural" streaks)

---

## 📁 Project Structure

```
coinflip_randomness_vs_CRT/
├── README.md                          # You are here
├── main_analysis.R                    # Master script (run research analysis)
├── coinflip_randomness_vs_CRT.Rproj  # RStudio project file
│
├── shiny_app/                         # 🆕 Interactive Applications
│   ├── user_dashboard.R               # User-facing dashboard (NEW!)
│   ├── app.R                          # Data collection tool
│   ├── analysis_functions.R           # Scoring algorithms
│   ├── utils.R                        # Helper functions
│   ├── run_dashboard.sh               # Quick-start script
│   ├── USER_DASHBOARD_README.md       # Dashboard documentation
│   └── IMPLEMENTATION_SUMMARY.md      # Technical details
│
├── R/                                 # Research Analysis Code
│   ├── 01_data_loading.R              # Import & clean functions
│   ├── 02_crt_scoring.R               # CRT-7 scoring logic
│   ├── 03_randomness_metrics.R        # Randomness algorithms
│   ├── 04_visualization.R             # ggplot2 publication figures
│   └── 05_statistical_analysis.R      # Correlation tests & reports
│
├── data/                              # Data files
│   ├── coinflip_crt_survey_data_edited.xlsx  # Raw survey data
│   └── final_data_ready.csv           # Cleaned analysis dataset
│
├── output/                            # Generated results
│   ├── fig1_crt_vs_randomness.png     # Main scatterplot
│   ├── fig2_randomness_by_grade.png   # Boxplot by year
│   ├── fig3_crt_distribution.png      # CRT score histogram
│   └── statistical_results.csv        # Numerical results table
│
└── docs/                              # Additional documentation
    ├── METHODOLOGY.md                 # Detailed methods
    ├── FUTURE_WORK.md                 # Research extensions
    └── REFERENCES.md                  # Bibliography
```

---

## 🚀 Getting Started

### Prerequisites

- **R** ≥ 4.0.0 ([Download](https://www.r-project.org/))
- **RStudio** (recommended) ([Download](https://posit.co/products/open-source/rstudio/))

### Required R Packages

**For Research Analysis:**
```r
install.packages(c(
  "tidyverse",   # Data manipulation & ggplot2
  "readxl",      # Excel file import
  "janitor",     # Column name cleaning
  "broom"        # Tidy statistical output
))
```

**For Interactive Dashboard:**
```r
install.packages(c(
  "shiny",       # Web application framework
  "shinyjs",     # JavaScript integration
  "dplyr",       # Data manipulation
  "stringr",     # String operations
  "plotly",      # Interactive visualizations
  "scales"       # Scaling functions
))
```

### Installation

```bash
# Clone the repository
git clone https://github.com/sanjaykshetri/coinflip_randomness_vs_CRT.git
cd coinflip_randomness_vs_CRT

# Open in RStudio
# Double-click: coinflip_randomness_vs_CRT.Rproj
```

---

## 💻 Usage

### Option 1: Interactive Dashboard (Try It Yourself!)

Experience the test firsthand with instant feedback:

```bash
cd shiny_app
./run_dashboard.sh
```

Or in R:
```r
shiny::runApp("shiny_app/user_dashboard.R")
```

**What you'll do:**
1. Choose test length (12, 20, 50, 100, or 200 flips)
2. Imagine and enter your coin flip sequence
3. Answer 7 CRT questions (multiple choice)
4. Get instant analysis with interactive visualizations

### Option 2: Research Analysis (Replicate Findings)

Run the complete statistical analysis:

```r
# Run the complete analysis pipeline
source("main_analysis.R")
```

This will:
1. ✅ Load and clean survey data
2. ✅ Calculate CRT scores
3. ✅ Compute randomness metrics
4. ✅ Generate statistical reports
5. ✅ Create publication-quality figures
6. ✅ Export results to `output/` directory

### Option 3: Data Collection

Use the Shiny data collection app for your own study:

```r
shiny::runApp("shiny_app/app.R")
```

### Step-by-Step Analysis

If you prefer modular execution:

```r
# 1. Load modules
source("R/01_data_loading.R")
source("R/02_crt_scoring.R")
source("R/03_randomness_metrics.R")
source("R/04_visualization.R")
source("R/05_statistical_analysis.R")

# 2. Load data
df <- load_survey_data("data/coinflip_crt_survey_data_edited.xlsx")

# 3. Process
df <- df %>%
  standardize_coinflips() %>%
  consolidate_flips() %>%
  score_crt_items() %>%
  calculate_total_crt() %>%
  add_randomness_metrics()

# 4. Analyze
stats <- generate_statistical_report(df)
print_statistical_report(stats)

# 5. Visualize
plots <- create_all_plots(df)
plots$main_scatter  # View primary figure
```

---

## 📈 Results & Visualizations

### Figure 1: Primary Analysis
![CRT vs Randomness](output/fig1_crt_vs_randomness.png)
*Scatterplot showing weak negative relationship (r = -0.18, p = 0.09)*

### Figure 2: Grade-Level Comparison
![Randomness by Grade](output/fig2_randomness_by_grade.png)
*Minimal differences across academic years*

### Figure 3: CRT Score Distribution
![CRT Distribution](output/fig3_crt_distribution.png)
*Most participants scored 0-4 out of 7 (mean = 2.8)*

---

## 🔮 Future Directions

### Immediate Extensions

1. **Power Analysis & Sample Size**
   - Current n=83 → Target n=200+ for detecting small-to-medium effects
   - Implement online data collection via Shiny dashboard

2. **Advanced Randomness Metrics**
   - Entropy measures (Shannon entropy)
   - Kolmogorov complexity approximations
   - Markov chain transition probabilities
   - Spectral analysis of sequence patterns

3. **Alternative Cognitive Measures**
   - Berlin Numeracy Test (statistical literacy)
   - Need for Cognition Scale
   - Working memory capacity (digit span)

### Novel Research Questions

4. **Training Interventions**
   - Can teaching probability improve randomness generation?
   - Effect of showing computer-generated sequences as calibration

5. **Individual Differences**
   - STEM vs. non-STEM majors
   - Gambling experience correlations
   - Cultural differences in randomness perception

6. **Computational Modeling**
   - Hidden Markov Models to reverse-engineer generation strategies
   - Bayesian hierarchical models for individual differences
   - Machine learning to predict CRT from sequence patterns alone

### Publication Path

- Expand to **pre-registered replication** with larger sample
- ✅ **Shiny web app developed** for crowd-sourced data collection and public engagement
- Target journals: *Judgment and Decision Making*, *Cognitive Psychology*, *Behavioral Research Methods*

---

## 🎯 Project Milestones

- [x] Initial data collection (n=83)
- [x] Statistical analysis and visualization
- [x] Core randomness metrics implementation
- [x] Interactive data collection tool
- [x] **User-facing dashboard with instant feedback**
- [x] **Multiple test lengths (12, 20, 50, 100, 200 flips)**
- [x] **Multiple choice CRT format for better UX**
- [ ] Scale up data collection (target: n=500+)
- [ ] Cross-cultural validation
- [ ] Machine learning pattern analysis

**See [`docs/FUTURE_WORK.md`](docs/FUTURE_WORK.md) for detailed research roadmap.**

---

## 🤝 Contributing

Contributions are welcome! Areas for improvement:

- **Code**: Optimize randomness algorithms, add unit tests
- **Analysis**: Suggest additional statistical approaches
- **Visualization**: Enhanced interactive plots (plotly, shiny)
- **Documentation**: Clarify methods, add tutorials

**Process:**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 🛠️ Technologies & Tools

### Research Analysis
- **R** (4.0+) - Statistical computing
- **tidyverse** - Data manipulation and visualization
- **ggplot2** - Publication-quality graphics
- **broom** - Statistical model tidying

### Interactive Applications
- **Shiny** - Web application framework
- **shinyjs** - Interactive JavaScript features
- **plotly** - Interactive visualizations
- **Custom CSS** - Modern gradient UI design

### Features
- ✅ Modular, reusable code architecture
- ✅ Comprehensive documentation
- ✅ Automated analysis pipeline
- ✅ Real-time input validation
- ✅ Responsive design (mobile-friendly)
- ✅ Privacy-first (no data tracking in user dashboard)
- ✅ Flexible scoring algorithms (adapts to sequence length)

---

## 📝 Citation

If you use this project in your research, please cite:

```bibtex
@software{shetri2025coinflip,
  author = {Shetri, Sanjay K.},
  title = {Coinflip Randomness vs. Cognitive Reflection Test},
  year = {2025},
  url = {https://github.com/sanjaykshetri/coinflip_randomness_vs_CRT},
  note = {GitHub repository}
}
```

### Key References

- **Cognitive Reflection Test**:  
  Toplak, M. E., West, R. F., & Stanovich, K. E. (2014). Assessing miserly information processing: An expansion of the Cognitive Reflection Test. *Thinking & Reasoning*, 20(2), 147-168.

- **Randomness Perception**:  
  Falk, R., & Konold, C. (1997). Making sense of randomness: Implicit encoding as a basis for judgment. *Psychological Review*, 104(2), 301-318.

- **Hot Hand Fallacy**:  
  Gilovich, T., Vallone, R., & Tversky, A. (1985). The hot hand in basketball: On the misperception of random sequences. *Cognitive Psychology*, 17(3), 295-314.

*Full bibliography: [`docs/REFERENCES.md`](docs/REFERENCES.md)*

---

## 📄 License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) for details.

You are free to:
- ✅ Use for commercial purposes
- ✅ Modify and adapt
- ✅ Distribute copies
- ✅ Use for academic research

**Attribution required** — please cite the project if used in publications.

---

## 👤 Author

**Sanjay K Shetri**
- GitHub: [@sanjaykshetri](https://github.com/sanjaykshetri)
- Repository: [coinflip_randomness_vs_CRT](https://github.com/sanjaykshetri/coinflip_randomness_vs_CRT)

---

## 🙏 Acknowledgments

- Survey participants from undergraduate classes
- Cognitive reflection test design: Toplak, West, & Stanovich
- Randomness literature: Kahneman, Tversky, Gilovich, Falk, Konold
- R community for amazing open-source tools
- Shiny framework for making interactive applications accessible

---

## 🚀 Try It Now!

Want to test yourself? The interactive dashboard is ready to use:

```bash
cd shiny_app && ./run_dashboard.sh
```

Or in R:
```r
shiny::runApp("shiny_app/user_dashboard.R")
```

**Features you'll love:**
- 🎯 Choose your difficulty: 12-200 flips
- 🧠 Complete the CRT-7 test
- 📊 Get instant personalized analysis
- 📈 Interactive visualizations
- 🎨 Beautiful, modern interface
- 🔒 Privacy-first (no tracking)

---

<div align="center">

**⭐ Star this repo if you find it useful!**

[![GitHub stars](https://img.shields.io/github/stars/sanjaykshetri/coinflip_randomness_vs_CRT?style=social)](https://github.com/sanjaykshetri/coinflip_randomness_vs_CRT)

*Last Updated: November 29, 2025*

</div> 



