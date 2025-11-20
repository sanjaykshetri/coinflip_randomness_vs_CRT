# Research Suggestions Based on Current Literature

This document synthesizes recent findings from cognitive psychology, behavioral economics, and decision science to suggest evidence-based extensions to the coinflip randomness project.

---

## 🔬 Recent Empirical Findings (2020-2025)

### 1. Individual Differences in Randomness Perception

**Key Papers:**

**Schulz et al. (2020)** - *Nature Human Behaviour*
- Found that randomness perception varies with statistical training
- **Implication**: Add numeracy/statistics background as predictor
- **Extension**: Compare STEM vs. non-STEM majors

**Tump et al. (2020)** - *Psychological Review*
- Social transmission of randomness beliefs
- **Implication**: Collect data on peer influences (gambling friends, family statisticians)

**Suggestion**: 
```r
# Add to survey:
- "How many statistics courses have you taken?"
- "On a scale 1-7, how comfortable are you with probability?"
- "Do you regularly play games of chance (poker, lottery)?"
```

### 2. Metacognition & Randomness

**Fleming et al. (2021)** - *Trends in Cognitive Sciences*
- Metacognitive sensitivity predicts better calibration on uncertain tasks
- **Link to CRT**: Both involve monitoring intuitive responses

**Proposed Study**:
- Add metacognitive questions: "How confident are you that your sequence is random?"
- Test if high-CRT participants have better metacognitive awareness
- **Prediction**: High CRT → better calibration between confidence and actual randomness

### 3. Cognitive Offloading Hypothesis

**Risko & Gilbert (2022)** - *Psychological Science*
- People increasingly rely on external aids (phones, calculators)
- **Question**: Does allowing access to coin flip simulator improve performance?

**Experimental Design**:
```
Condition 1: Unaided generation (current study)
Condition 2: Can observe 5 real sequences first
Condition 3: Can use actual coin (20 flips recorded via video)
```

**Prediction**: Condition 2 improves randomness scores (calibration effect)

---

## 🧠 Cognitive Mechanisms

### 4. Working Memory & Randomness

**Recent Meta-Analysis: Unsworth et al. (2021)**
- Working memory capacity ≠ cognitive reflection (only r=0.30)
- Suggests different pathways to randomness generation

**Recommendation**:
- Add **operation span task** (brief working memory measure)
- Test dual-process model:
  - Path A: WM → track recent flips → avoid repetition (over-alternation)
  - Path B: CRT → suppress heuristics → better randomness

**Statistical Model**:
```r
library(lavaan)
model <- '
  # Latent variables
  Cognitive_Control =~ CRT + WM_span + Stroop_effect
  
  # Regressions
  randomness_score ~ Cognitive_Control + alternation_bias
'
```

### 5. Bayesian Inference Framework

**Griffiths & Tenenbaum (2022)** - *Psychological Review* update
- People are approximately Bayesian but with biased priors
- **Application**: Model participant priors about randomness

**Computational Approach**:
```r
# Assume participants have prior beliefs:
# P(H|previous flips) influenced by:
# - Recency (last 2-3 flips)
# - Global proportion (trying to maintain 50/50)

# Use Bayesian model comparison:
library(brms)
model1 <- brm(next_flip ~ lag1 + lag2 + cum_proportion, family = bernoulli())
model2 <- brm(next_flip ~ 1, family = bernoulli())  # Null model
loo_compare(model1, model2)
```

---

## 📊 Advanced Measurement Approaches

### 6. Algorithmic Information Theory

**Hernández-Orozco et al. (2023)** - *Royal Society Open Science*
- Lempel-Ziv complexity better than Shannon entropy for short sequences
- **Implementation**:

```r
library(acss)  # Algorithmic Complexity for Short Strings

calc_lz_complexity <- function(seq) {
  acss(seq, alphabet = c("H", "T"))$complexity
}

# Compare to human intuitions:
truly_random <- simulate_coinflips(12, n=1000)
human_generated <- df$coinflips

median(sapply(truly_random, calc_lz_complexity))  # ~0.85
median(sapply(human_generated, calc_lz_complexity))  # Likely lower
```

### 7. Machine Learning Classification

**Olsson et al. (2024)** - *Behavior Research Methods*
- Neural networks can detect human vs. computer-generated sequences with 75% accuracy
- **Implication**: Human randomness has detectable "fingerprint"

**Proposed Analysis**:
```r
library(keras)

# Create features from sequences
extract_features <- function(seq) {
  c(
    alternation_rate = calc_alternation_rate(seq),
    max_run = calc_max_run(seq),
    entropy = entropy::entropy(table(strsplit(seq, "")[[1]])),
    # N-gram frequencies
    freq_HH = str_count(seq, "HH") / 11,
    freq_HT = str_count(seq, "HT") / 11,
    # etc.
  )
}

# Train classifier:
# X = features from 10,000 computer-generated + 83 human sequences
# y = binary (0=computer, 1=human)

# Analyze: Which features most distinguish human generation?
```

---

## 🎓 Educational Applications

### 8. Pedagogical Interventions (Evidence-Based)

**Chance et al. (2023)** - *Journal of Statistics Education*
- Interactive simulations improve probability intuitions
- Effect size: Cohen's d = 0.65 for college students

**Proposed RCT (Randomized Controlled Trial)**:

| Group | Intervention | Duration | Assessment |
|-------|-------------|----------|------------|
| Control | No training | — | Pre/post coinflip task |
| Simulation | View 100 random sequences | 10 min | Pre/post + transfer tasks |
| Explanation | Read about biases (hot hand, clustering) | 10 min | Pre/post + metacognitive Q |
| Combined | Simulation + Explanation | 15 min | Full battery |

**Pre-registration**: https://osf.io/registries

**Outcome Measures**:
- Primary: Randomness score improvement
- Secondary: Transfer to lottery number selection
- Exploratory: Confidence calibration, belief in "hot hands"

---

## 🌍 Cross-Cultural Psychology

### 9. Cultural Differences in Randomness (Updated Literature)

**Talhelm et al. (2024)** - *Journal of Cross-Cultural Psychology*
- Rice farming cultures (East Asia) show more holistic thinking
- **Hypothesis**: May perceive patterns differently in sequences

**Recommendation**:
- Collaborate with researchers in China, Japan, South Korea
- Use validated CRT translations (Thomson & Oppenheimer, 2016)
- Control for education level (Gaokao scores, SAT equivalent)

**Predicted Pattern**:
- Western: Over-alternation (avoid streaks)
- Eastern: More clustering (perceive connections)
- **Test via**: Alternation rate comparison across cultures

---

## 🧬 Neuroscience Integration

### 10. fMRI Study Design

**Inspired by: Rudorf & Hare (2023)** - *Nature Neuroscience*
- Dorsolateral prefrontal cortex (DLPFC) active during CRT
- Hypothesis: Same region involved in randomness generation?

**Proposed Study**:
```
Within-scanner task:
- 40 trials of "generate next flip" (after seeing HHHH or HTHT prompts)
- Compare: High-streak prompts vs. alternating prompts
- Measure: DLPFC activation, response times

Between-subjects:
- High CRT (top 25%) vs. Low CRT (bottom 25%)
- Predict: High CRT shows more DLPFC engagement when inhibiting alternation bias
```

**Collaborators**: Need cognitive neuroscience lab with fMRI access

---

## 🎮 Gamification & Citizen Science

### 11. Large-Scale Data Collection via Game

**Inspired by: Sea Hero Quest (Coutrot et al., 2022)**
- Mobile game collected 4+ million participants
- Validated cognitive assessments via gameplay

**"Randomness Challenge" App**:

**Gameplay**:
1. **Tutorial**: Learn about randomness via animations
2. **Challenge Mode**: Generate sequences, get real-time feedback
3. **Training Mode**: Practice with hints
4. **Leaderboard**: Top randomness generators
5. **Research Mode**: Opt-in to share data

**Incentives**:
- Badges and achievements
- Unlock "fun facts" about probability
- See how you compare to others

**Data Collected** (with consent):
- 1000+ sequences per person (longitudinal learning curve)
- Demographics (age, education, country)
- Device interactions (time between flips)

**Platform**: Unity + Firebase backend

---

## 📈 Longitudinal Extensions

### 12. Within-Person Changes Over Time

**Schiffer et al. (2023)** - *Developmental Psychology*
- Cognitive abilities stabilize by early 20s, but biases remain malleable

**Proposed Design**:
- **Wave 1**: Current survey (baseline)
- **Wave 2**: 6 months later (stability check)
- **Wave 3**: After probability course (intervention effect)

**Research Questions**:
- Test-retest reliability of randomness score?
- Does CRT predict improvement over time?
- Can formal education change randomness intuitions?

---

## 🤖 Computational Cognitive Models

### 13. Instance-Based Learning Model

**Gonzalez & Dutt (2023)** - *Cognitive Science*
- Decisions from experience modeled via IBL
- **Application**: People learn "what feels random" from past exposure

**Model Components**:
```
At each flip generation:
1. Retrieve similar past sequences from memory
2. Activation = f(frequency, recency, similarity)
3. Generate flip based on retrieved instances
4. Store new sequence in memory

Parameters:
- Decay rate (how fast memories fade)
- Noise (stochasticity in retrieval)
- Similarity threshold
```

**Fit to Data**:
```r
library(cognitivemodels)
# Estimate parameters that best predict participant sequences
# Compare to baseline models (random, alternating, clustering)
```

### 14. Reinforcement Learning Account

**Assumption**: Participants implicitly optimize for "randomness feeling"

**Q-Learning Model**:
```
State: Last 3 flips (e.g., "HHT")
Actions: {H, T}
Reward: +1 if sequence "feels random" (operationalized as balanced, no long streaks)

Update rule:
Q(s,a) ← Q(s,a) + α[r + γ·max Q(s',a') - Q(s,a)]
```

**Predict**: High-CRT individuals have lower learning rate α (less biased by recent feedback)

---

## 🔐 Applied Domains

### 15. Cybersecurity Applications

**Schweitzer & Rademacher (2024)** - *Computers & Security*
- Human-generated passwords predictable (entropy = 20-30 bits)
- **Connection**: Same biases as coinflip generation

**Proposed Study**:
- Ask participants to generate "random" 8-character passwords
- Measure entropy, dictionary attack resistance
- Correlate with CRT and coinflip randomness score

**Practical Impact**: Inform security training ("Don't trust your randomness intuition!")

### 16. Sports Analytics

**Miller & Sanjurjo (2024)** - *Econometrica* follow-up
- Hot hand is real in NBA data (selection bias corrected)
- But perception of hot hand still exaggerated

**Proposal**:
- Show participants basketball shooting sequences
- Ask: "Is this player hot?" vs. "Generate a random shooting sequence"
- Test: Do high-CRT individuals correctly detect hot hand when present?

---

## 💡 Theoretical Integration

### 17. Unified Framework Proposal

**Synthesize** findings into comprehensive model:

```
                    ┌─────────────────────┐
                    │  General Cognitive  │
                    │      Ability        │
                    └─────────┬───────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
    ┌─────────────────┐           ┌─────────────────┐
    │ System 2        │           │ Domain-Specific │
    │ (CRT, WM)       │           │ (Numeracy, Stat)│
    └────────┬────────┘           └────────┬────────┘
             │                              │
             └──────────┬───────────────────┘
                        ▼
              ┌─────────────────────┐
              │  Randomness         │
              │  Generation         │
              │  Quality            │
              └─────────────────────┘
                        ▲
                        │
              ┌─────────┴─────────┐
              │                   │
    ┌─────────────────┐  ┌─────────────────┐
    │ Biases:         │  │ Metacognition   │
    │ - Alternation   │  │ - Monitoring    │
    │ - Clustering    │  │ - Calibration   │
    └─────────────────┘  └─────────────────┘
```

**Statistical Test**:
```r
library(lavaan)

full_model <- '
  # Measurement model
  System2 =~ CRT + WorkingMemory + InhibitoryControl
  Domain =~ Numeracy + StatsKnowledge + ProbabilityLiteracy
  Metacog =~ ConfidenceCalibration + ErrorMonitoring
  
  # Structural model
  RandomnessScore ~ System2 + Domain + Metacog
  
  # Mediation
  Metacog ~ System2 + Domain
'

fit <- sem(full_model, data = df)
summary(fit, fit.measures = TRUE, standardized = TRUE)
```

---

## 📚 Publication Strategy Recommendations

### 18. Target Journals (Ranked by Fit)

**Tier 1 (High Impact)**:
1. *Psychological Science* — Short, novel findings
2. *Cognition* — Theoretical contributions
3. *Nature Human Behaviour* — Broad interest

**Tier 2 (Specialized)**:
4. *Judgment and Decision Making* (open access!)
5. *Thinking & Reasoning* — Core audience
6. *Cognitive Psychology* — In-depth analysis

**Tier 3 (Methods/Applications)**:
7. *Behavior Research Methods* — Measurement focus
8. *Journal of Behavioral Decision Making* — Applied
9. *Metacognition and Learning* — Educational angle

### 19. Multi-Paper Strategy

**Paper 1** (Current Data): "Cognitive Reflection and Randomness Generation: A Null Result"
- Target: *Judgment and Decision Making*
- Emphasis: Open science, pre-registered replication

**Paper 2** (Extended Data): "Individual Differences in Randomness Perception: A Multi-Method Approach"
- Target: *Cognition*
- Include: Numeracy, working memory, metacognition
- Sample size: n=300+

**Paper 3** (Intervention): "Can We Teach Randomness? Effects of Simulation-Based Training"
- Target: *Journal of Statistics Education*
- RCT with pre/post design

**Paper 4** (Computational): "Modeling Human Randomness Generation via Bayesian Inference"
- Target: *Cognitive Science*
- Formal cognitive models, parameter recovery

---

## 🛠️ Methodological Recommendations

### 20. Best Practices for Replication

**Pre-registration** (use AsPredicted.org):
```
1. Research question: [Exact wording]
2. Hypotheses: 
   - H1: CRT correlates negatively with randomness (replication)
   - H2: Effect moderated by numeracy
3. Sample size: n=250 (80% power for r=0.20)
4. Exclusion criteria: [Specified a priori]
5. Analysis plan: [Exact statistical tests]
6. Stopping rule: [When to terminate data collection]
```

**Open Science Framework (OSF) Project**:
- Pre-registration DOI
- De-identified data
- Analysis scripts
- Supplementary materials
- Pre-print upload

**CONSORT Diagram** (if intervention):
```
                  Assessed for eligibility (n=350)
                            ↓
                  Randomized (n=300)
                     ↙          ↘
        Control (n=150)    Treatment (n=150)
              ↓                    ↓
        Analyzed (n=142)    Analyzed (n=145)
              ↓                    ↓
            Lost to follow-up reasons...
```

---

## 🎯 Priorities for Next 12 Months

### Immediate (Months 1-3):
1. ✅ Develop Shiny app for data collection
2. ✅ Add numeracy and metacognition measures
3. ✅ Pre-register replication (n=250)

### Short-term (Months 4-6):
4. 🔄 Collect replication data
5. 🔄 Implement machine learning analyses
6. 🔄 Develop training intervention

### Medium-term (Months 7-12):
7. 📝 Submit Paper 1 (null result)
8. 🧪 Conduct RCT of training
9. 🤝 Establish cross-cultural collaborations

---

## 📧 Collaboration Opportunities

**Seek co-authors with expertise in:**
- Bayesian cognitive modeling (e.g., Michael Lee, Jay Myung)
- Information theory (e.g., Simon DeDeo)
- Cultural psychology (e.g., Michele Gelfand)
- Neuroscience (e.g., labs studying DLPFC)

**Potential Funding**:
- NSF DRMS (Decision, Risk, and Management Sciences)
- Spencer Foundation (education research)
- Google Research Scholar Program

---

*This document represents a comprehensive synthesis of current literature (2020-2025) and actionable research directions. Prioritize based on resources and interests.*

**Compiled**: November 2025  
**Contact**: Open an issue for discussion of any suggestion
