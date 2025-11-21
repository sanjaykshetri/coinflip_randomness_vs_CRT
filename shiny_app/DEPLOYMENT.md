# 🚀 Shiny Dashboard Deployment Guide

## Quick Start (Local Testing)

### Run Locally

```r
# Navigate to shiny_app directory
setwd("shiny_app")

# Install required packages
install.packages(c("shiny", "shinyjs", "tidyverse", "DT", "plotly"))

# Run the app
shiny::runApp()
```

The app will open in your default browser at `http://127.0.0.1:XXXX`

---

## 📊 App Features

### For Participants:
1. **Informed Consent** - Clear study information and consent form
2. **Coinflip Task** - Input 20-character sequence with real-time validation
3. **CRT-7 Questions** - Seven cognitive reflection questions
4. **Demographics** - Age, gender, education, major, statistics background
5. **Debriefing** - Explanation of study purpose and findings

### For Researchers (Admin Dashboard):
1. **Real-time Statistics** - Total responses, average scores
2. **Interactive Visualization** - CRT vs Randomness scatterplot
3. **Data Table** - Browse all responses
4. **CSV Export** - Download complete dataset

**Admin Password**: `randomness2025` (Change this in `app.R` line 745!)

---

## 🌐 Deployment Options

### Option 1: shinyapps.io (Easiest)

**Free tier**: 25 active hours/month, 5 applications

#### Step 1: Create Account
1. Go to https://www.shinyapps.io/
2. Sign up with GitHub or email
3. Note your account name

#### Step 2: Install rsconnect
```r
install.packages("rsconnect")
```

#### Step 3: Configure Account
```r
library(rsconnect)

# Get your token from: https://www.shinyapps.io/admin/#/tokens
rsconnect::setAccountInfo(
  name='YOUR-ACCOUNT-NAME',
  token='YOUR-TOKEN',
  secret='YOUR-SECRET'
)
```

#### Step 4: Deploy
```r
# From project root directory
rsconnect::deployApp(
  appDir = "shiny_app",
  appName = "coinflip-randomness-study",
  account = "YOUR-ACCOUNT-NAME"
)
```

**Your app will be live at:**  
`https://YOUR-ACCOUNT-NAME.shinyapps.io/coinflip-randomness-study/`

#### Updating the App
```r
# After making changes, redeploy:
rsconnect::deployApp(appDir = "shiny_app")
```

---

### Option 2: Shiny Server (Self-Hosted)

**For institutions with their own servers**

#### Requirements:
- Linux server (Ubuntu recommended)
- R installed
- Sudo access

#### Installation:
```bash
# Install R
sudo apt-get update
sudo apt-get install r-base

# Install Shiny Server
sudo apt-get install gdebi-core
wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.20.1002-amd64.deb
sudo gdebi shiny-server-1.5.20.1002-amd64.deb

# Install R packages
sudo su - -c "R -e \"install.packages(c('shiny', 'shinyjs', 'tidyverse', 'DT', 'plotly'), repos='http://cran.rstudio.com/')\""
```

#### Deploy App:
```bash
# Copy app to Shiny Server directory
sudo cp -R shiny_app /srv/shiny-server/coinflip-study

# Set permissions
sudo chown -R shiny:shiny /srv/shiny-server/coinflip-study

# Restart server
sudo systemctl restart shiny-server
```

**Access at:** `http://YOUR-SERVER-IP:3838/coinflip-study/`

---

### Option 3: Docker (Portable)

**Create Dockerfile:**

```dockerfile
FROM rocker/shiny:4.3.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev

# Install R packages
RUN R -e "install.packages(c('shiny', 'shinyjs', 'tidyverse', 'DT', 'plotly'), repos='http://cran.rstudio.com/')"

# Copy app
COPY shiny_app /srv/shiny-server/

# Expose port
EXPOSE 3838

# Run app
CMD ["/usr/bin/shiny-server"]
```

**Build and Run:**
```bash
# Build image
docker build -t coinflip-shiny .

# Run container
docker run -d -p 3838:3838 -v $(pwd)/shiny_app/data:/srv/shiny-server/data coinflip-shiny
```

---

## 📁 Data Storage

### Local Storage (Default)
Data saved to: `shiny_app/data/survey_responses.csv`

**Pros:**
- Simple setup
- No additional configuration

**Cons:**
- Not suitable for high traffic
- Data can be lost if app crashes
- No concurrent write protection

### Database Storage (Recommended for Production)

#### PostgreSQL Setup:

1. **Install RPostgres:**
```r
install.packages("RPostgres")
```

2. **Modify `utils.R`:**
```r
library(RPostgres)

save_response_data <- function(response_data) {
  con <- dbConnect(
    Postgres(),
    dbname = "coinflip_db",
    host = "localhost",
    port = 5432,
    user = "your_username",
    password = "your_password"
  )
  
  # Convert to data frame
  df <- data.frame(...)
  
  # Insert into database
  dbAppendTable(con, "responses", df)
  
  dbDisconnect(con)
}
```

---

## 🔐 Security Considerations

### Change Admin Password
**In `app.R` line 745:**
```r
if (input$admin_password == "YOUR-SECURE-PASSWORD-HERE") {
```

### Environment Variables (Better Practice)
```r
# In app.R
ADMIN_PASSWORD <- Sys.getenv("SHINY_ADMIN_PASSWORD")

# Set environment variable before running:
Sys.setenv(SHINY_ADMIN_PASSWORD = "your_secure_password")
```

### HTTPS/SSL
- **shinyapps.io**: Automatic HTTPS
- **Self-hosted**: Use nginx reverse proxy with Let's Encrypt

---

## 📊 Monitoring & Analytics

### Built-in Analytics
- Admin dashboard shows real-time response counts
- Interactive plots update automatically
- Export data anytime as CSV

### Google Analytics (Optional)
Add to `app.R` in the `<head>` section:
```r
tags$script(HTML("
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
  
  ga('create', 'UA-XXXXX-Y', 'auto');
  ga('send', 'pageview');
"))
```

---

## 🐛 Troubleshooting

### App Won't Start
```r
# Check for errors
shiny::runApp(launch.browser = FALSE)

# View logs
options(shiny.trace = TRUE)
```

### Package Installation Issues
```r
# Try installing from source
install.packages("tidyverse", type = "source")

# Check R version
R.version.string  # Should be 4.0+
```

### Data Not Saving
```r
# Check directory permissions
Sys.chmod("shiny_app/data", mode = "0777")

# Verify write access
file.access("shiny_app/data", 2)  # Should return 0
```

### Memory Issues (High Traffic)
- Increase RAM allocation
- Use database instead of CSV
- Implement caching for admin dashboard

---

## 📈 Scaling for High Traffic

### Optimization Tips:

1. **Reactive Data Loading**
```r
# In server.R
all_data <- reactiveFileReader(
  intervalMillis = 5000,
  session = session,
  filePath = "data/survey_responses.csv",
  readFunc = read.csv
)
```

2. **Connection Pooling** (if using database)
```r
pool <- dbPool(
  drv = RPostgres::Postgres(),
  dbname = "coinflip_db",
  host = "localhost"
)

onStop(function() {
  poolClose(pool)
})
```

3. **Caching**
```r
# Cache randomness calculations
randomness_cache <- memoise::memoise(calculate_randomness_score)
```

---

## 🎯 Best Practices

### Before Deployment:
- [ ] Change admin password
- [ ] Test all input validation
- [ ] Test on mobile devices
- [ ] Add contact email in app
- [ ] Review data privacy compliance
- [ ] Set up automatic backups

### After Deployment:
- [ ] Monitor error logs regularly
- [ ] Backup data weekly
- [ ] Check disk space (CSV files grow)
- [ ] Test admin dashboard access
- [ ] Share URL with participants

---

## 📞 Support

**App Issues?**
- Check logs in console
- Review error messages
- Test locally first

**Deployment Issues?**
- shinyapps.io: https://docs.rstudio.com/shinyapps.io/
- Shiny Server: https://docs.rstudio.com/shiny-server/

---

## 📝 Customization

### Modify Number of Flips
Currently set to 20. To change:

**In `app.R`:**
- Line ~200: Update character count validation
- Line ~225: Update instruction text

**In `analysis_functions.R`:**
- Update ideal values in `calculate_randomness_score()`

### Add More Questions
Add new CRT questions in `app.R` around line 450:
```r
div(class = "crt-question",
  h4("Question 8 of 8"),
  p("Your question here?"),
  textInput("crt8", label = "Your answer:", ...)
)
```

### Change Color Scheme
Modify CSS in `app.R` starting at line 30:
```css
background: linear-gradient(135deg, #YOUR-COLOR-1 0%, #YOUR-COLOR-2 100%);
```

---

**Ready to deploy? Choose your platform and follow the steps above!**

*Last Updated: November 2025*
