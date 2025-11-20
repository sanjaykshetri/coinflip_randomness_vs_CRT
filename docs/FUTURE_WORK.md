# Future Work & Research Extensions

This document outlines potential directions for extending the coinflip randomness vs. cognitive reflection research.

---

## 🎯 Immediate Next Steps

### 1. Statistical Power & Replication

**Current Limitation**: n=83 provides ~65% power to detect medium effects (r=0.3)

**Action Items**:
- [ ] Conduct formal power analysis using `pwr` package in R
- [ ] Target sample size: n=200-300 for 80% power to detect r=0.20
- [ ] Create **Shiny web application** for continuous data collection
- [ ] Implement multi-site data collection across universities
- [ ] Pre-register replication study on OSF (Open Science Framework)

**Implementation**:
```r
library(pwr)
pwr.r.test(n = NULL, r = 0.20, sig.level = 0.05, power = 0.80)
# Required n ≈ 194
```

---

## 🔬 Methodological Improvements

### 2. Enhanced Randomness Metrics

**Current**: Alternation rate, max run, head deviation  
**Add**:

#### A. Information-Theoretic Measures
- **Shannon Entropy**: Quantify unpredictability
  ```r
  library(entropy)
  calc_shannon_entropy <- function(seq) {
    flips <- unlist(strsplit(seq, ""))
    entropy(table(flips), method = "ML")
  }
  ```

- **Kolmogorov Complexity**: Approximate via compression algorithms
  - Lempel-Ziv complexity
  - gzip compression ratio

#### B. Sequential Dependence
- **Markov Transition Matrix**: Test for memory effects
  ```r
  # P(H|H), P(T|H), P(H|T), P(T|T)
  calc_transition_probs <- function(seq) {
    flips <- unlist(strsplit(seq, ""))
    transitions <- table(head(flips, -1), tail(flips, -1))
    prop.table(transitions, margin = 1)
  }
  ```

- **Autocorrelation Function**: Detect periodicities

#### C. Distributional Tests
- **Chi-square goodness of fit**: Test against binomial distribution
- **Runs test**: Formal test of randomness (Wald-Wolfowitz)
- **Spectral analysis**: Frequency domain examination

### 3. Cognitive Battery Expansion

**Beyond CRT-7**:

| Test | What It Measures | Implementation |
|------|------------------|----------------|
| **Berlin Numeracy Test** | Statistical literacy | 4-item adaptive test |
| **Need for Cognition (NFC-6)** | Enjoyment of effortful thinking | Likert scale questionnaire |
| **Raven's Progressive Matrices** | Fluid intelligence | Abbreviated 12-item version |
| **Digit Span** | Working memory capacity | Forward/backward recall task |
| **Iowa Gambling Task (IGT)** | Decision-making under uncertainty | Computerized card game |

**Research Question**: Does domain-specific statistical knowledge predict randomness better than general cognitive ability?

---

## 💡 Novel Research Directions

### 4. Training & Intervention Studies

**Experimental Design**:

**Control Group**: No intervention  
**Treatment 1**: View 100 truly random sequences (calibration)  
**Treatment 2**: Statistics mini-lesson on probability  
**Treatment 3**: Gamified training app with feedback

**Hypothesis**: Exposure to real randomness improves generation accuracy

**Measurement**:
- Pre/post randomness scores
- Transfer to other tasks (lottery number picking, password creation)

### 5. Individual Differences & Predictors

**Demographic Variables**:
- Academic major (STEM vs. humanities)
- Math anxiety scores
- Prior statistics coursework
- Gambling frequency

**Personality Traits**:
- Big Five personality (via BFI-10)
- Risk aversion (via DOSPERT scale)
- Numeracy (via SNS scale)

**Research Question**: Who is best at simulating randomness?

**Analysis**: Multiple regression predicting randomness score:
```r
model <- lm(randomness_score ~ crt_score + major + math_anxiety + 
            gambling_freq + openness + conscientiousness, data = df)
```

### 6. Computational Cognitive Modeling

#### Approach A: Hidden Markov Models (HMM)
**Goal**: Reverse-engineer participants' generation strategies

**Implementation**:
```r
library(depmixS4)
# Fit HMM with 2-4 latent states
# States might correspond to: "alternating mode", "streak mode", "random mode"
```

#### Approach B: Reinforcement Learning Models
**Hypothesis**: People learn what "feels random" through cultural exposure

**Model**: Q-learning with representativeness heuristic bias

#### Approach C: Bayesian Hierarchical Modeling
**Capture individual differences** in randomness generation parameters

```r
library(brms)
model <- brm(
  randomness_score ~ crt_score + (1 + crt_score | participant_id),
  family = gaussian(),
  data = df
)
```

### 7. Machine Learning Approaches

**Task**: Predict CRT score from coinflip sequence alone

**Models to Try**:
- Random Forest
- Gradient Boosting (XGBoost)
- LSTM neural networks (for sequence data)

**Features**:
- All existing randomness metrics
- N-gram frequencies (HH, HT, TH, TT, HHH, etc.)
- Positional encoding
- Fourier transform coefficients

**Research Question**: Do high-CRT individuals have distinct "signatures" in their randomness?

---

## 🌍 Cross-Cultural Extensions

### 8. Cultural Psychology Perspective

**Hypothesis**: Individualist vs. collectivist cultures differ in randomness perception

**Study Design**:
- Recruit participants from 10+ countries
- Control for education level
- Translate CRT carefully (cultural equivalence)

**Related Work**:
- Ji, L. J., Nisbett, R. E., & Su, Y. (2001). Culture, change, and prediction. *Psychological Science*.

---

## 🎮 Applied Contexts

### 9. Real-World Randomness Tasks

**Beyond Coinflips**:

#### Password Generation
- Ask participants to create "random" 8-character passwords
- Measure entropy and predictability
- **Application**: Security training

#### Lottery Number Selection
- Pick 6 numbers from 1-49
- Compare to actual lottery draw distributions
- **Application**: Gambling behavior research

#### Creative Randomization
- Compose "random" melodies (music cognition)
- Generate "random" visual patterns (art & design)

### 10. Gamification & Education

**Develop "Randomness Trainer" App**:
- Users generate sequences
- Real-time feedback on randomness quality
- Leaderboards and achievements
- Pre/post assessment of probability understanding

**Target Audience**:
- Statistics educators
- Psychology courses on heuristics & biases
- General public (citizen science)

---

## 📊 Advanced Statistical Techniques

### 11. Techniques to Explore

- **Mixture Models**: Identify subgroups of generators (e.g., "alternators" vs. "clusterers")
- **Network Analysis**: Do participants with similar CRT scores generate similar sequences?
- **Time Series Analysis**: If longitudinal data collected, track learning curves
- **Survival Analysis**: Model "time until first long streak" across participants

---

## 📚 Publication Strategy

### Phase 1: Pilot Results (Current Status)
- **Target**: Poster at SPSP or Psychonomics conference
- **Format**: Brief empirical report

### Phase 2: Powered Replication
- **Target**: *Judgment and Decision Making* (open access)
- **Requirements**: n≥200, pre-registration, open data

### Phase 3: Multi-Method Extension
- **Target**: *Psychological Science* or *Cognition*
- **Include**: Training intervention + computational modeling
- **Format**: Full empirical article

### Phase 4: Review/Meta-Analysis
- **After 5+ studies exist in literature**
- **Synthesize**: What predicts randomness generation?

---

## 🛠️ Technical Infrastructure Needs

### Shiny Dashboard Development

**Features**:
- Participant consent form
- Embedded coinflip task (interactive buttons or text input)
- Adaptive CRT-7 administration
- Additional measures (numeracy, demographics)
- Automated data storage (PostgreSQL backend)
- Real-time analytics dashboard for researchers

**Tech Stack**:
- `shiny` + `shinyjs` for interactivity
- `DT` for data tables
- `plotly` for interactive visualizations
- `RPostgres` for database connection
- Deploy on shinyapps.io or AWS

### Data Management
- **Version control**: GitHub
- **Data storage**: OSF project page (private during collection, public after publication)
- **Reproducibility**: Docker container with R environment
- **Pre-registration**: AsPredicted.org or OSF Registries

---

## 🎓 Educational Extensions

### Course Integration

**Use Case 1**: Undergraduate Research Methods
- Students replicate study
- Learn data cleaning, visualization, correlation analysis
- Crowdsource data collection across sections

**Use Case 2**: Cognitive Psychology Lab
- Demonstrate heuristics & biases
- Compare to other randomness tasks (Benford's Law, birthday problem)

**Use Case 3**: Statistics Education
- Teach sampling distributions through simulation
- Show discrepancy between intuition and probability

### Open Science Materials
- **Create OSF page** with:
  - Survey materials
  - Codebook
  - Analysis scripts
  - Supplementary materials
- **License**: CC-BY 4.0 (maximally open)

---

## 🔗 Interdisciplinary Connections

### Relevant Fields

1. **Neuroscience**: fMRI studies of randomness generation (prefrontal cortex activation)
2. **Philosophy**: Epistemology of randomness and chance
3. **Computer Science**: Random number generation algorithms, PRNG testing
4. **Economics**: Lottery ticket purchasing behavior
5. **Security**: Human-generated cryptographic keys
6. **Sports Analytics**: "Hot hand" and streak perception in athletics

### Collaborative Opportunities
- **Seek co-authors** with expertise in:
  - Bayesian statistics
  - Computational modeling
  - Cultural psychology
  - Neuroeconomics

---

## 📅 Timeline (18-Month Roadmap)

| Month | Milestone |
|-------|-----------|
| 1-2 | Develop Shiny app prototype |
| 3-4 | Pilot test (n=50), refine measures |
| 4-6 | Pre-register main study |
| 6-12 | Data collection (n=250+) |
| 12-14 | Complete analysis, draft manuscript |
| 14-16 | Submit to journal, peer review |
| 16-18 | Revisions, acceptance, prepare OSF materials |

---

## 🏆 Success Metrics

**Short-Term**:
- [ ] 200+ participants recruited
- [ ] Shiny app deployed and functional
- [ ] Conference presentation accepted

**Medium-Term**:
- [ ] Peer-reviewed publication
- [ ] 50+ citations within 2 years
- [ ] Replication by independent lab

**Long-Term**:
- [ ] Integrated into psychology textbooks (e.g., Gilovich & Griffin)
- [ ] Practical applications (education, security)
- [ ] 10+ follow-up studies inspired by this work

---

## 💬 Get Involved

**Interested in collaborating?**
- Open an issue on GitHub
- Contact: [Your email or Twitter]
- Join our OSF project team

**Skills Needed**:
- R programming (advanced ggplot2, Shiny)
- Statistical modeling (mixed models, Bayesian)
- Survey design & participant recruitment
- Scientific writing & peer review

---

*This document is a living roadmap. Suggestions welcome via pull requests!*

**Last Updated**: November 2025
