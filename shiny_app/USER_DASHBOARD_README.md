# User Dashboard - Coin Flip Randomness & CRT-7 Test

An interactive Shiny dashboard that allows users to:
1. Choose their test length (12, 20, 50, or 200 coin flips)
2. Generate a mental coin flip sequence
3. Complete the CRT-7 (Cognitive Reflection Test)
4. Receive personalized analysis and results

## Features

### 🪙 Mental Coin Flipping
- Users can select from 4 different test lengths:
  - **12 flips**: Quick test (~3 minutes)
  - **20 flips**: Standard test (~5 minutes)
  - **50 flips**: Challenging test (~7 minutes)
  - **200 flips**: Expert test (~10 minutes)

- Real-time validation of input
- Character counter showing progress

### 🧠 CRT-7 Questions
All 7 standard CRT questions with flexible answer validation:
1. Bat and ball problem (Answer: 5 cents)
2. Widget machines (Answer: 5 minutes)
3. Lily pads (Answer: 47 days)
4. Race position (Answer: second place)
5. Sheep problem (Answer: 8 sheep)
6. Emily's sisters (Answer: Emily)
7. Dirt in a hole (Answer: 0 cubic feet)

### 📊 Personalized Results

Users receive comprehensive feedback including:

#### CRT Results:
- Overall score (0-7)
- Percentile ranking
- Detailed interpretation of cognitive reflection ability
- All correct answers with explanations

#### Randomness Analysis:
- Overall randomness score (0-100%)
- Visual display of their sequence
- Alternation rate (how often H/T switches)
- Longest streak analysis
- Heads/Tails balance
- Cumulative proportion graph
- Personalized feedback on their specific patterns

#### Combined Insights:
- Analysis of relationship between CRT score and randomness generation
- Explanation of common psychological biases
- Interpretation based on user's specific results

## Installation

### Prerequisites
- R (version 4.0 or higher)
- RStudio (recommended)

### Required R Packages
```r
install.packages(c(
  "shiny",
  "shinyjs",
  "tidyverse",
  "plotly",
  "scales"
))
```

## Running the Dashboard

### Option 1: From RStudio
1. Open `user_dashboard.R` in RStudio
2. Click "Run App" button in the top-right corner
3. The dashboard will open in a new window or browser

### Option 2: From Command Line
```bash
cd shiny_app
Rscript -e "shiny::runApp('user_dashboard.R', port=3838, host='0.0.0.0')"
```

### Option 3: From R Console
```r
setwd("path/to/shiny_app")
shiny::runApp("user_dashboard.R")
```

## File Structure

```
shiny_app/
├── user_dashboard.R           # Main dashboard application
├── analysis_functions.R       # Randomness and CRT scoring functions
├── utils.R                    # Helper utilities
├── app.R                      # Original data collection app
└── USER_DASHBOARD_README.md   # This file
```

## How It Works

### Stage 1: Welcome
- Users select their preferred test length
- Brief explanation of what the test measures

### Stage 2: Coin Flip Generation
- Users type their imagined sequence of H's and T's
- Real-time validation ensures correct format
- Character counter shows progress

### Stage 3: CRT Questions
- 7 cognitive reflection questions
- Free-text input for flexibility
- Validation ensures all questions are answered

### Stage 4: Results Display
- Instant analysis upon completion
- Multiple metrics and visualizations
- Personalized interpretations
- Option to restart and try again

## Metrics Explained

### Randomness Score
Combines three key metrics:
1. **Alternation Rate**: Should be ~50% for random sequences
2. **Maximum Run Length**: Dynamically calculated based on sequence length (expected: log₂(n) + 1)
3. **Head/Tail Balance**: Should be close to 50/50

### CRT Score
- Simple count of correct answers (0-7)
- Percentile based on population norms
- Higher scores indicate greater cognitive reflection

## Common Psychological Biases Detected

1. **Over-alternation**: Switching H/T too frequently (>60%)
2. **Under-alternation**: Too many long streaks (<40%)
3. **Representativeness**: Forcing exactly 50/50 split
4. **Streak Avoidance**: Avoiding natural runs like HHHH
5. **Pattern Perception**: Seeing non-existent patterns

## Customization

### Changing Test Lengths
Edit the `render_welcome_stage()` function:
```r
radioButtons("flip_count_choice",
  choices = c(
    "Your custom length" = "custom_number"
  )
)
```

### Modifying Interpretations
All interpretation functions are at the bottom of `user_dashboard.R`:
- `get_crt_interpretation()`
- `get_randomness_interpretation()`
- `generate_personalized_feedback()`
- `generate_combined_insights()`

### Styling
Custom CSS is embedded in the `tags$head()` section. Key classes:
- `.metric-card`: Score display boxes
- `.instruction-box`: Information panels
- `.crt-question`: Question containers
- `.btn-primary`: Action buttons

## Deployment Options

### ShinyApps.io (Free Hosting)
```r
library(rsconnect)
rsconnect::deployApp('path/to/shiny_app/user_dashboard.R')
```

### Shiny Server (Self-Hosted)
1. Install Shiny Server on your server
2. Copy files to `/srv/shiny-server/`
3. Access via `http://your-server:3838/`

### Docker
Create a Dockerfile:
```dockerfile
FROM rocker/shiny:latest
RUN R -e "install.packages(c('shinyjs', 'tidyverse', 'plotly', 'scales'))"
COPY . /srv/shiny-server/
```

## Technical Notes

### Performance
- All calculations are instant (no external API calls)
- Visualizations use plotly for interactivity
- Reactive programming ensures smooth UX

### Data Privacy
- **No data is stored** in this dashboard version
- All analysis happens client-side
- Results are shown immediately and then discarded
- Perfect for individual testing without data collection concerns

### Browser Compatibility
- Works in all modern browsers
- Tested on Chrome, Firefox, Safari, Edge
- Mobile-responsive design

## Differences from Original App

The original `app.R` is designed for **data collection** and includes:
- Data storage functionality
- Admin dashboard
- Multiple participants
- Downloadable datasets

This `user_dashboard.R` is designed for **individual feedback** and includes:
- No data storage
- Immediate personalized results
- Variable test lengths (12, 20, 50, 200)
- More detailed interpretations
- Restart capability

## Future Enhancements

Potential additions:
- [ ] Save results as PDF
- [ ] Email results to participant
- [ ] Compare to population distributions
- [ ] Add more cognitive tests
- [ ] Gamification elements (achievements, scores)
- [ ] Social sharing features
- [ ] Multi-language support

## Troubleshooting

### App won't start
```r
# Check if packages are installed
packages <- c("shiny", "shinyjs", "tidyverse", "plotly", "scales")
missing <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(missing)) install.packages(missing)
```

### Visualizations not showing
- Ensure `plotly` package is installed
- Check browser console for JavaScript errors
- Try refreshing the page

### Styling issues
- Clear browser cache
- Check for CSS conflicts
- Verify all CSS classes are properly closed

## Support

For issues, questions, or suggestions:
- Check existing documentation
- Review code comments in `user_dashboard.R`
- Test with different sequence lengths to identify issues
- Verify all packages are up to date

## License

Same license as parent project (see main LICENSE file)

## Citation

If you use this dashboard in research:
```
Shetri, S. K. (2025). Coin Flip Randomness vs. Cognitive Reflection Test - 
Interactive Dashboard. GitHub repository.
```

## Acknowledgments

- CRT-7 questions from Toplak, West, & Stanovich (2014)
- Randomness metrics based on Falk & Konold (1997)
- UI design inspired by modern web standards
