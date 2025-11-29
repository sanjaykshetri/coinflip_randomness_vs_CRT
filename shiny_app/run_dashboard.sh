#!/bin/bash
# Quick start script for User Dashboard

echo "=================================================="
echo "   Coin Flip Randomness & CRT-7 User Dashboard   "
echo "=================================================="
echo ""

# Check if R is installed
if ! command -v R &> /dev/null; then
    echo "❌ R is not installed. Please install R first."
    echo ""
    echo "Installation instructions:"
    echo "  Ubuntu/Debian: sudo apt-get install r-base"
    echo "  macOS: brew install r"
    echo "  Windows: Download from https://cran.r-project.org/"
    exit 1
fi

echo "✓ R is installed"

# Check if required packages are installed
echo ""
echo "Checking required R packages..."

Rscript -e "
packages <- c('shiny', 'shinyjs', 'tidyverse', 'plotly', 'scales')
missing <- packages[!(packages %in% installed.packages()[,'Package'])]

if(length(missing) > 0) {
  cat('\n❌ Missing packages:', paste(missing, collapse=', '), '\n')
  cat('\nInstalling missing packages...\n\n')
  install.packages(missing, repos='https://cran.rstudio.com/')
  cat('\n✓ All packages installed!\n')
} else {
  cat('✓ All required packages are installed\n')
}
"

echo ""
echo "=================================================="
echo "Starting User Dashboard..."
echo "=================================================="
echo ""
echo "The dashboard will open in your browser at:"
echo "  http://localhost:3838"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Run the dashboard
cd "$(dirname "$0")"
Rscript -e "shiny::runApp('user_dashboard.R', port=3838, host='0.0.0.0', launch.browser=TRUE)"
