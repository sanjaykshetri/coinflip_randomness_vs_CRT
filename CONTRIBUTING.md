# Contributing to Coinflip Randomness vs. CRT

Thank you for your interest in contributing to this project! This document provides guidelines for various types of contributions.

---

## Ways to Contribute

### 🐛 Reporting Bugs

**Before submitting:**
- Check existing issues to avoid duplicates
- Collect information about your environment (R version, OS, package versions)

**Include in your report:**
- Clear, descriptive title
- Steps to reproduce the issue
- Expected vs. actual behavior
- Screenshots (if applicable)
- Relevant code snippets

### 💡 Suggesting Enhancements

**Good enhancement suggestions include:**
- Clear description of the feature
- Rationale (why is it useful?)
- Example use cases
- Potential implementation approach

### 📝 Improving Documentation

- Fix typos or clarify unclear sections
- Add examples or tutorials
- Improve code comments
- Translate documentation

### 🔬 Contributing Research Ideas

See [`docs/FUTURE_WORK.md`](docs/FUTURE_WORK.md) for research directions. Open an issue to discuss:
- Novel analysis approaches
- Additional cognitive measures
- Experimental extensions
- Theoretical frameworks

### 💻 Code Contributions

**Areas for improvement:**
1. **Randomness algorithms**: Implement entropy-based metrics, Kolmogorov complexity approximations
2. **Visualization**: Create interactive Shiny dashboard, plotly enhancements
3. **Statistical methods**: Bayesian analysis, mixed models, machine learning
4. **Testing**: Unit tests for calculation functions
5. **Performance**: Optimize slow operations

---

## Development Workflow

### 1. Fork & Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/coinflip_randomness_vs_CRT.git
cd coinflip_randomness_vs_CRT
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# OR
git checkout -b bugfix/issue-description
```

**Branch naming conventions:**
- `feature/` - New features or enhancements
- `bugfix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Adding or improving tests

### 3. Make Changes

**Code style guidelines:**
- Follow [tidyverse style guide](https://style.tidyverse.org/)
- Use meaningful variable names
- Comment complex logic
- Keep functions focused (single responsibility)

**Example:**
```r
# Good
calculate_alternation_rate <- function(sequence) {
  # Split sequence into individual flips
  flips <- unlist(strsplit(sequence, ""))
  
  # Count alternations between consecutive flips
  alternations <- sum(head(flips, -1) != tail(flips, -1))
  
  # Return proportion
  alternations / (length(flips) - 1)
}

# Less ideal
calc_alt <- function(s) {
  f <- unlist(strsplit(s, ""))
  sum(head(f, -1) != tail(f, -1)) / (length(f) - 1)
}
```

### 4. Test Your Changes

```r
# Source your modified script
source("R/03_randomness_metrics.R")

# Test the function
test_seq <- "HTHHTTHTHTHT"
result <- calc_alternation_rate(test_seq)
print(result)  # Should be 0.636

# Run full analysis to ensure no breakage
source("main_analysis.R")
```

### 5. Commit Changes

```bash
git add .
git commit -m "Add entropy-based randomness metric

- Implement Shannon entropy calculation
- Add unit tests for new function
- Update documentation in 03_randomness_metrics.R"
```

**Commit message guidelines:**
- Use present tense ("Add feature" not "Added feature")
- First line: concise summary (50 chars max)
- Blank line, then detailed description
- Reference issues: "Fixes #42" or "Relates to #123"

### 6. Push & Open Pull Request

```bash
git push origin feature/your-feature-name
```

Then open a pull request on GitHub with:
- **Title**: Clear description of changes
- **Description**:
  - What problem does this solve?
  - What approach did you take?
  - Any breaking changes?
  - Testing performed
  - Screenshots (for UI changes)

---

## Pull Request Checklist

Before submitting, ensure:

- [ ] Code follows project style guidelines
- [ ] Comments added for complex logic
- [ ] Documentation updated (README, function docs)
- [ ] No breaking changes (or clearly documented)
- [ ] Tested on your local machine
- [ ] No merge conflicts with main branch
- [ ] Commit messages are clear and descriptive

---

## Code Review Process

1. **Maintainer review**: Within 1-2 weeks
2. **Feedback**: You may be asked to make changes
3. **Revision**: Push additional commits to same branch
4. **Approval**: Once changes are satisfactory
5. **Merge**: Maintainer will merge into main branch

**Be patient and respectful!** Code review is collaborative.

---

## Coding Standards

### R Style

**Variable naming:**
```r
# Use snake_case for variables and functions
randomness_score <- 0.85
calculate_head_deviation <- function(seq) { ... }

# Use UPPER_CASE for constants
MAX_COINFLIPS <- 12
DEFAULT_THRESHOLD <- 0.5
```

**Function documentation:**
```r
#' Calculate Alternation Rate
#'
#' Measures how frequently consecutive flips alternate (H->T or T->H).
#' Expected value for truly random sequence ≈ 0.5
#'
#' @param seq Character string of flip sequence (e.g., "HTHHTHT")
#' @return Numeric value between 0 and 1
#' @examples
#' calc_alternation_rate("HTHHTHT")
#' # Returns: 0.833
#' @export
calc_alternation_rate <- function(seq) {
  # Implementation...
}
```

**Error handling:**
```r
# Check inputs
if (!is.character(seq)) {
  stop("Input must be a character string")
}

if (nchar(seq) < 2) {
  warning("Sequence too short for meaningful alternation rate")
  return(NA_real_)
}
```

### File Organization

**Script headers:**
```r
# ==============================================================================
# Script Purpose: Brief description
# ==============================================================================
# Author: Your Name
# Date: YYYY-MM-DD
# Dependencies: tidyverse, ggplot2
# ==============================================================================
```

---

## Testing

### Manual Testing

```r
# Test with edge cases
calc_alternation_rate("HH")        # Should return 0
calc_alternation_rate("HTHT")      # Should return 1
calc_alternation_rate("HHHHTTTTHHHHTTT")  # Should return ~0.214

# Test with invalid inputs
calc_alternation_rate("")          # Should handle gracefully
calc_alternation_rate(123)         # Should error with clear message
```

### Automated Testing (Future)

We plan to implement:
```r
library(testthat)

test_that("alternation rate calculates correctly", {
  expect_equal(calc_alternation_rate("HT"), 1)
  expect_equal(calc_alternation_rate("HH"), 0)
  expect_true(is.na(calc_alternation_rate("")))
})
```

---

## Documentation Standards

### README Updates

When adding features, update:
- Installation instructions (if new dependencies)
- Usage examples
- Project structure diagram
- Dependencies list

### Code Comments

**When to comment:**
- Complex algorithms
- Non-obvious logic
- Workarounds for bugs
- References to papers/methods

**When NOT to comment:**
```r
# Bad: Obvious comments
x <- x + 1  # Increment x by 1

# Good: Explains WHY
x <- x + 1  # Adjust for 0-indexing in Python version
```

---

## Community Guidelines

### Code of Conduct

**Be respectful:**
- Welcome newcomers
- Assume good intentions
- Provide constructive feedback
- Value diverse perspectives

**Unacceptable behavior:**
- Harassment or discrimination
- Trolling or insulting comments
- Publishing others' private information

**Enforcement:**
- Violations reported to [maintainer email]
- Temporary or permanent bans for serious violations

---

## Getting Help

**Questions?**
- Open an issue with "Question:" prefix
- Check [`docs/METHODOLOGY.md`](docs/METHODOLOGY.md) for technical details
- Review existing issues for similar questions

**Want to discuss ideas?**
- Open a GitHub Discussion (if enabled)
- Tag issues as "discussion"

---

## Recognition

**Contributors will be:**
- Listed in CONTRIBUTORS.md
- Acknowledged in publication acknowledgments
- Credited in code comments (for major contributions)

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for helping improve this project!** 🙏

*Last Updated: November 2025*
