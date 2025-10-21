# Initial Prompt

Let's create a system of scripts in ./analysis/eda-2-casenote/ (following the example in eda-1 and ./scripts/template) that ingests synthetic notes (for now it will be synthetic, but we'll pretend it's real data). I would like to think in terms of: 
1) demographic shape of the given group 
2) what we can say about each case note in isolation (can we flag something? evaluate sentiment?) 
3) how this case note should be interpreted in the context of a selected group (all sample, or some subgroup which would provide a more meaningful reference point).  

This is my goal, but first, help me design a system prompt following ROTRISE framework (example provided, use what is relevant, ask me questions).

## AI Clarifying Questions & Responses

### **Role Clarity:**
**Q1: Who is the intended user of this analysis system?**
**A1:** Researchers specializing in data analysis of social data

**Q2: What's their technical background and decision-making authority?**
**A2:** R, ggplot2, quarto, etc. Experienced R and SQL programmers.

### **Objective Specificity:**
**Q3: For demographic analysis - are you primarily interested in risk stratification, resource allocation, or outcome prediction?**
**A3:** Risk stratification

**Q4: For individual case flagging - what constitutes a "flag"?**
**A4:** Whether the note indicates substance use, homelessness, etc.

**Q5: For contextual interpretation - what reference groups matter most?**
**A5:** The total group, plus the group that shares the same risk factors.

### **Tools/Capabilities:**
**Q6: Should the system integrate with existing risk assessment frameworks or create new ones?**
**A6:** Create new, but keep it brief

**Q7: Do you want real-time alerts, batch reports, or interactive dashboards?**
**A7:** Batch reports

**Q8: Should it include natural language processing for sentiment analysis, or focus on structured indicators?**
**A8:** Natural language processing, but use Python models for that

### **Style/Tone:**
**Q9: Should outputs be clinical/technical (for caseworkers) or executive summary style (for administrators)?**
**A9:** Outputs should be versatile, suitable for both caseworkers and researchers

**Q10: How much explanation vs. actionable recommendations?**
**A10:** Lean toward explanation. Gently propose ideas for actionable recommendations

### **Domain-Specific Considerations:**
**Q11: Are there specific GoA social services protocols or risk frameworks I should reference?**
**A11:** Not yet, make agnostic for now.

**Q12: What privacy/ethical constraints apply to the flagging system?**
**A12:** No constraints yet

**Q13: Should the system account for caseworker writing styles when interpreting notes?**
**A13:** No, make the language neutral




# First draft of system prompt approved

Great, now let's create the analytical framework strucutre

# Analytical Framework Implementation - COMPLETED ✅

## Files Created

### Core Analysis Framework
- **`eda-2-casenote.R`**: Main R analysis script implementing three-layer framework
  - Layer 1: Population demographics and risk stratification
  - Layer 2: Individual case note analysis with basic NLP preparation
  - Layer 3: Contextual interpretation within reference groups
  - Modular function structure following tidyverse conventions
  - Integrated visualization system

- **`eda-2-casenote.qmd`**: Quarto report template
  - Publication-ready analytical report structure
  - Code folding and interactive elements
  - Executive summary and methodological documentation
  - Three-layer analysis presentation

### Supporting Infrastructure
- **`setup-structure.ps1`**: PowerShell setup script (ASCII-compliant)
  - Creates directory structure (`temp/`, `python/`, `output/`, `reports/`)
  - Initializes placeholder files and documentation
  - One-command environment setup

- **`system-prompt-casenote-analyst.md`**: ROTRISE-based system prompt
  - Senior social services data analyst persona
  - Three-layer analytical objectives
  - R+Python integration specifications
  - Versatile output requirements (researchers + caseworkers)

### Python NLP Integration
- **`python/nlp_processing.py`**: Advanced text analysis module
  - Sentiment analysis using transformer models
  - Risk flag extraction with pattern matching
  - Composite urgency scoring (0-1 scale)
  - R-Python data exchange via CSV
  - JSON output for integration back to R

- **`python/requirements.txt`**: Python dependencies
  - transformers, torch, pandas, numpy, scikit-learn

### Documentation
- **`README.md`**: Comprehensive project documentation
  - Usage instructions and quick start guide
  - Technical implementation details
  - Methodological notes and limitations
  - Future enhancement roadmap

## Directory Structure Created
```
eda-2-casenote/
├── eda-2-casenote.R           # Main R analysis script
├── eda-2-casenote.qmd         # Quarto report template  
├── setup-structure.ps1        # Environment setup (run first)
├── system-prompt-casenote-analyst.md  # ROTRISE system prompt
├── README.md                  # Project documentation
├── temp/                      # R-Python data exchange
├── python/                    # NLP processing modules
├── output/                    # Analysis results
└── reports/                   # Generated reports
```

## Key Features Implemented

### ✅ **Three-Layer Analysis**
1. **Demographics**: Age, gender, location, complexity distributions with risk stratification
2. **Individual**: Risk flagging (substance use, housing, mental health) + sentiment analysis
3. **Contextual**: Reference group comparisons (total population + complexity cohorts)

### ✅ **Risk Flagging System**
- Substance use detection
- Housing crisis indicators  
- Mental health concerns
- Crisis/emergency language
- Family separation patterns

### ✅ **R+Python Integration**
- R handles statistical analysis and visualization
- Python provides advanced NLP capabilities
- CSV-based data exchange system
- JSON output for enhanced analysis

### ✅ **Reporting Framework**
- Batch reports (as requested)
- Suitable for both researchers and caseworkers
- Explanation-focused with gentle recommendations
- Reproducible Quarto workflow

### ✅ **Synthetic Data Ready**
- Designed for `synthetic-case-notes.csv` input
- Framework-agnostic approach
- Language-neutral processing
- Privacy-conscious analysis

## Next Steps Available
1. **Test Analysis**: Run with synthetic case notes dataset
2. **Python Setup**: Install NLP dependencies and test integration  
3. **Report Generation**: Render initial Quarto report
4. **Refinement**: Adjust risk flagging patterns based on data patterns

# Testing Progress - LAYER 1 COMPLETED ✅

## Production-Ready Constraints Applied
**Key Decision**: Modified analysis to use only production-available variables:
- **Allowed**: `person_oid`, `first_name`, `last_name`, `gender`, `age`, `location`, `case_note`  
- **Excluded**: `complexity_level`, `archetype_id`, `writer_style`, `embedded_scenarios` (simulation artifacts)

## Layer 1: Demographics Analysis - SUCCESS ✅

**Date Tested**: October 21, 2025  
**Dataset**: 500 synthetic case records  
**Status**: Production-ready analysis working perfectly

### Key Findings from Synthetic Data:
- **Population Size**: 500 cases (production variables only)
- **Age Distribution**: Mean 39.4 years, range 18-64 (matches target population)  
- **Gender Split**: 56.4% Female, 43.6% Male
- **Geographic**: 73% Urban, 27% Rural
- **Age Stratification**: Middle Age (35-49) largest group at 38%

### Production Adaptations Made:
- ✅ **Age Groups**: Created meaningful age cohorts to replace `complexity_level`
  - Young Adult (18-24): 13%  
  - Young Adult (25-34): 25%
  - Middle Age (35-49): 38%
  - Older Adult (50-64): 24%
- ✅ **Risk Stratification**: Age groups × Location matrix working
- ✅ **No Missing Data**: All core production variables complete
- ✅ **Functions**: `load_synthetic_data()` and `analyze_population_demographics()` operational

### Technical Validation:
- Data loading with production column filtering: ✅
- Age group creation and stratification: ✅  
- Demographic distributions and summaries: ✅
- Risk stratification framework: ✅

## Ready for Next Step: Layer 2 Testing
**Next**: Individual case note analysis with risk flagging system
- Basic text characteristics (length, word count)
- Keyword-based risk detection (substance, housing, mental health, crisis)
- Age group pattern analysis
- Python NLP preparation

**Rest Point Established** - Layer 1 production-ready demographic analysis confirmed working 
