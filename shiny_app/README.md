# 🪙 Coinflip Randomness Study - Shiny Dashboard

> Interactive web application for collecting data on randomness generation and cognitive reflection

---

## 📊 Overview

This Shiny dashboard enables live data collection for studying the relationship between cognitive reflection and randomness intuition. Participants complete a coinflip generation task, answer CRT questions, and provide demographic information—all through an intuitive web interface.

---

## ✨ Features

### Participant Experience
- **Modern, responsive design** - Works on desktop, tablet, and mobile
- **Real-time validation** - Instant feedback on input quality
- **Progress tracking** - Clear navigation through study stages
- **Debriefing** - Educational information about study purpose

### Research Features
- **Automated scoring** - CRT and randomness metrics calculated automatically
- **Admin dashboard** - Real-time analytics and data visualization
- **CSV export** - Download complete dataset anytime
- **Data integrity** - Validation prevents invalid submissions

---

## 🚀 Quick Start

### Run Locally

```r
# Install required packages
install.packages(c("shiny", "shinyjs", "tidyverse", "DT", "plotly"))

# Navigate to this directory
setwd("shiny_app")

# Launch app
shiny::runApp()
```

The app will open automatically in your default browser.

---

## 📁 File Structure

```
shiny_app/
├── app.R                    # Main Shiny application
├── utils.R                  # Validation and data management functions
├── analysis_functions.R     # Randomness & CRT scoring algorithms
├── DEPLOYMENT.md           # Deployment instructions
├── README.md               # This file
├── data/                   # Data storage directory
│   └── survey_responses.csv # Collected responses (auto-generated)
└── www/                    # Static assets (images, CSS, etc.)
```

---

## 🎨 Interface Sections

### 1. Welcome & Consent
- Study overview and time estimate
- Privacy information
- Informed consent checkbox

### 2. Coinflip Task
- Input field for 20-character sequence
- Real-time character counter
- Validation (H/T only, exactly 20 chars)

### 3. CRT Questions
Seven cognitive reflection questions:
1. Bat and ball problem
2. Widget machines
3. Lily pad coverage
4. Race position
5. Farmer's sheep
6. Three daughters
7. Hole volume

### 4. Demographics
- Age
- Gender
- Education level
- Academic year (if student)
- Major/field of study
- Statistics course background

### 5. Completion & Debriefing
- Thank you message
- Study explanation
- Related research references

### 6. Admin Dashboard (Password Protected)
- Total response count
- Average CRT & randomness scores
- Interactive CRT vs. Randomness plot
- Data table with all responses
- CSV download button

**Default admin password**: `randomness2025`  
**⚠️ Change this before deployment!** (See DEPLOYMENT.md)

---

## 📊 Data Collected

### Automatic Calculations:
- **CRT Score** (0-7): Number of correct CRT responses
- **Randomness Score** (0-1): Composite quality metric
- **Alternation Rate** (0-1): Frequency of H/T switches
- **Max Run Length**: Longest streak of same outcome
- **Head Count**: Number of H in sequence

### Demographics:
- Age, gender, education
- Academic year, major
- Statistics course count

### Timestamps:
- Submission date/time
- Unique submission ID

---

## 🔧 Customization

### Change Number of Flips
Currently set to 20. To modify:
1. Update validation in `app.R` (line ~200)
2. Adjust scoring in `analysis_functions.R`

### Add Questions
Insert new questions in `app.R` CRT section (around line 450)

### Modify Scoring
Edit functions in `analysis_functions.R`:
- `calculate_randomness_score()` - Randomness algorithm
- `score_crt()` - CRT answer matching

### Customize Appearance
Modify CSS in `app.R` starting at line 30

---

## 📈 Deployment

### Local Testing
```r
shiny::runApp()
```

### shinyapps.io (Free Hosting)
```r
install.packages("rsconnect")
library(rsconnect)

# Configure account (get token from shinyapps.io)
setAccountInfo(name='YOUR-NAME', token='TOKEN', secret='SECRET')

# Deploy
deployApp(appDir = ".", appName = "coinflip-study")
```

**See DEPLOYMENT.md for complete instructions**

---

## 🔐 Security

### Before Going Live:

1. **Change Admin Password**
   - Edit `app.R` line 745
   - Use strong, unique password

2. **Review Data Privacy**
   - Ensure compliance with IRB
   - Check GDPR/privacy regulations
   - No PII collected by default

3. **Backup Data**
   - `data/survey_responses.csv` contains all responses
   - Set up regular backups
   - Consider database storage for production

---

## 📊 Sample Data Structure

**survey_responses.csv:**

| Field | Type | Example |
|-------|------|---------|
| submission_id | String | SUB_20251120_143052_7834 |
| timestamp | DateTime | 2025-11-20 14:30:52 |
| coinflip_sequence | String | HTHHTTTHTHHHTTHHHTTT |
| crt1-crt7 | String | 5 cents, 5 minutes, 47 days... |
| age | Integer | 22 |
| gender | String | Female |
| education | String | Bachelor's Degree |
| academic_year | String | Junior |
| major | String | Psychology |
| stats_courses | Integer | 2 |
| crt_score | Integer | 4 |
| randomness_score | Float | 0.823 |
| alternation_rate | Float | 0.632 |
| max_run | Integer | 3 |
| head_count | Integer | 11 |

---

## 🐛 Troubleshooting

### App won't start
```r
# Check for errors
shiny::runApp(launch.browser = FALSE)

# Install missing packages
install.packages(c("shiny", "shinyjs", "tidyverse", "DT", "plotly"))
```

### Data not saving
```r
# Check directory exists
dir.create("data", showWarnings = FALSE)

# Check write permissions
file.access("data", 2)  # Should return 0
```

### Admin dashboard blank
- Check password is correct
- Ensure data file exists and has responses
- Check browser console for errors (F12)

---

## 📞 Support & Contact

**Technical Issues:**
- Review DEPLOYMENT.md
- Check Shiny documentation: https://shiny.rstudio.com/
- Contact: [your email]

**Research Questions:**
- Study purpose: See debriefing page in app
- IRB approval: [add if applicable]
- Principal investigator: [your name]

---

## 📚 Related Files

- `../R/` - Original analysis scripts
- `../docs/METHODOLOGY.md` - Study design details
- `../docs/FUTURE_WORK.md` - Research extensions
- `../README.md` - Main project documentation

---

## 🎓 Citation

If you use this dashboard in your research:

```bibtex
@software{shetri2025shiny,
  author = {Shetri, Sanjay K.},
  title = {Coinflip Randomness Study: Interactive Shiny Dashboard},
  year = {2025},
  url = {https://github.com/sanjaykshetri/coinflip_randomness_vs_CRT}
}
```

---

## 📄 License

MIT License - See ../LICENSE for details

---

## 🙏 Acknowledgments

- Built with [Shiny by RStudio](https://shiny.rstudio.com/)
- Inspired by cognitive psychology research on randomness perception
- CRT questions from Frederick (2005) and extensions

---

**Ready to collect data? Run the app and share your URL!**

```r
shiny::runApp()
```

*Last Updated: November 2025*
